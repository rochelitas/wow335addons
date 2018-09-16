--[[****************************************************************
	LootCount reputation kill-counter v0.10

	Author: Evil Duck
	****************************************************************

	Plug-in for the World of Warcraft add-on LootCount.

	****************************************************************]]

-- 0.10 First version


LOOTCOUNT_REP_VERSIONTEXT = "LootCount Reputation kill-counter v0.10";
LOOTCOUNT_REP = "LootCount REP";
local LootCount_REP_Registered=nil;
local LootCount_REP_Fighting=nil;

local LootCount_REP_REPName="";
local LootCount_REP_REPQueue = {};
local LootCount_REP_REPQueueNorm = {};
local LOOTCOUNT_REP_REPQUEUE_SIZE = 20;



-- Set up for handling
function LootCount_REP_OnLoad()
	this:RegisterEvent("UPDATE_FACTION");
end


-- An event has been received
function LootCount_REP_OnEvent(event)
	if (event=="UPDATE_FACTION") then LootCount_REP_RunREP(); return; end
end


function LootCount_REP_RunREP()
	local i;
	local name,standing,min,max,rep=GetWatchedFactionInfo();
	if (name~=LootCount_REP_REPName) then
		LootCount_REP_REPName=name;
		LootCount_REP_REPQueue[1]=nil;
	end

	-- Start new queue
	if (not LootCount_REP_REPQueue[1]) then
		i=1;
		while (i<=LOOTCOUNT_REP_REPQUEUE_SIZE+1) do LootCount_REP_REPQueue[i]=rep; i=i+1; end
		if (not LootCount_InCombat) then return; end
	end

	-- Rep received while not in combat
	if (not LootCount_REP_Fighting) then
		local offset=rep-LootCount_REP_REPQueue[1];
		i=1; while (i<=LOOTCOUNT_REP_REPQUEUE_SIZE+1) do LootCount_REP_REPQueue[i]=LootCount_REP_REPQueue[i]+offset; i=i+1; end
		return;
	end

	i=LOOTCOUNT_REP_REPQUEUE_SIZE+1;
	while (i>1) do LootCount_REP_REPQueue[i]=LootCount_REP_REPQueue[i-1]; i=i-1; end
	LootCount_REP_REPQueue[1]=rep;

	i=1;
	while(i<=LOOTCOUNT_REP_REPQUEUE_SIZE) do LootCount_REP_REPQueueNorm[i]=LootCount_REP_REPQueue[i]-LootCount_REP_REPQueue[i+1]; i=i+1; end
	LootCountAPI.Force(LOOTCOUNT_REP);
end


function LootCount_REP_UpdateREPButton(button)
	if (not button) then return; end			-- End of iteration
	local i=1;
	local KillREP=0;
	local divider=0;
	local dText="REP:";
	while (i<=LOOTCOUNT_REP_REPQUEUE_SIZE) do
		if (not LootCount_REP_REPQueueNorm[i]) then return; end
		if (LootCount_REP_REPQueueNorm[i]>0) then divider=divider+1; end
		KillREP=KillREP+LootCount_REP_REPQueueNorm[i];
		if (LootCount_Debug) then dText=dText..LootCount_REP_REPQueueNorm[i].." "; end
		i=i+1;
	end
	if (KillREP<1 or divider<1) then return; end
	local name,standing,min,max,rep=GetWatchedFactionInfo();
	KillREP=KillREP/divider;
	local RemainREP=max-rep;
	local Remain=ceil(RemainREP/KillREP);
	local lastREP=nil;
	if (LootCount_REP_REPQueueNorm[1]>0) then lastREP=ceil(RemainREP/LootCount_REP_REPQueueNorm[1]); end
	LootCountAPI.SetData(LOOTCOUNT_REP,button,Remain,lastREP);
end


function LootCount_REP_Tooltip(button)
	GameTooltip:SetOwner(button,"ANCHOR_RIGHT");
	if (not LootCount_REP_REPName or LootCount_REP_REPName=="") then GameTooltip:SetText("Estimated kills until next reputation-level: None selected");
	else GameTooltip:SetText("Estimated kills until next reputation-level: "..LootCount_REP_REPName); end
	GameTooltip:Show();
end



function LootCount_REP_OnUpdate(elapsed)
	if (LootCount_REP_Registered) then
		if (not LootCount_InCombat and LootCount_REP_Fighting) then
			LootCount_REP_Fighting=nil;
		elseif (LootCount_InCombat and not LootCount_REP_Fighting) then
			LootCount_REP_Fighting=true;
		end
		return;
	end
	if (not LootCountAPI or not LootCountAPI.Register) then return; end
	
	local info = { Name=LOOTCOUNT_REP, Update=LootCount_REP_UpdateREPButton, Texture="Interface\\Icons\\Spell_Holy_Crusade", Tooltip=LootCount_REP_Tooltip };
	LootCountAPI.Register(info);
	LootCount_REP_Registered=true;
end
