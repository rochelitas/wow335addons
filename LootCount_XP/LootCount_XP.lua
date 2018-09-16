--[[****************************************************************
	LootCount XP kill-counter v0.11

	Author: Evil Duck
	****************************************************************

	Plug-in for the World of Warcraft add-on LootCount.

	****************************************************************]]

-- 0.11 Bug-fix in number-update
-- 0.10 First version


LOOTCOUNT_XP_VERSIONTEXT = "LootCount Kill-counter XP v0.11";
LOOTCOUNT_XP = "LootCount XP";
local LootCount_XP_Registered=nil;
local LootCount_XP_Fighting=nil;

local LootCount_XP_XPQueue = {};
local LootCount_XP_XPQueueNorm = {};
local LootCount_XP_XPQueueModifier = {};
local LOOTCOUNT_XP_XPQUEUE_SIZE = 20;
local LootCount_XP_LastRested=0;



-- Set up for handling
function LootCount_XP_OnLoad()
	this:RegisterEvent("PLAYER_XP_UPDATE");
	this:RegisterEvent("PLAYER_REGEN_DISABLED");
end


-- An event has been received
function LootCount_XP_OnEvent(event)
	if (event=="PLAYER_XP_UPDATE") then LootCount_XP_RunXP(); return; end
	if (event=="PLAYER_REGEN_DISABLED") then
		LootCount_XP_LastRested=GetXPExhaustion(); if (not LootCount_XP_LastRested) then LootCount_XP_LastRested=0; end	-- Set rested as this may have been a quick relog or a visit to an Inn
		return;
	end
end


function LootCount_XP_RunXP()
	local i;
	local XP=UnitXP("player");
	if (not LootCount_XP_XPQueue[1] or XP<LootCount_XP_XPQueue[1]) then		-- First run or leveled up
		i=1;
		while (i<=LOOTCOUNT_XP_XPQUEUE_SIZE+1) do
			LootCount_XP_XPQueue[i]=XP;
			LootCount_XP_XPQueueModifier[i]=0;
			i=i+1;
		end
		if (not LootCount_XP_Fighting) then return; end
	end

	if (not LootCount_XP_Fighting) then
		local offset=UnitXP("player")-LootCount_XP_XPQueue[1];
		i=1; while (i<=LOOTCOUNT_XP_XPQUEUE_SIZE+1) do LootCount_XP_XPQueue[i]=LootCount_XP_XPQueue[i]+offset; i=i+1; end
		return;
	end

	-- Shift raw data
	i=LOOTCOUNT_XP_XPQUEUE_SIZE+1;
	while (i>1) do
		LootCount_XP_XPQueue[i]=LootCount_XP_XPQueue[i-1];
		i=i-1;
	end
	LootCount_XP_XPQueue[1]=UnitXP("player");				-- Insert new raw data

	-- Shift modifier data
	i=LOOTCOUNT_XP_XPQUEUE_SIZE;
	while (i>1) do
		LootCount_XP_XPQueueModifier[i]=LootCount_XP_XPQueueModifier[i-1];
		i=i-1;
	end

	-- Make rested normalised data
	i=1;
	while(i<=LOOTCOUNT_XP_XPQUEUE_SIZE) do
		LootCount_XP_XPQueueNorm[i]=LootCount_XP_XPQueue[i]-LootCount_XP_XPQueue[i+1];
		i=i+1;
	end

	-- Do newest modifier
	if (LootCount_XP_LastRested>0) then
		LootCount_XP_XPQueueModifier[1]=LootCount_XP_LastRested;
		if (LootCount_XP_XPQueueModifier[1]>LootCount_XP_XPQueueNorm[1]) then LootCount_XP_XPQueueModifier[1]=LootCount_XP_XPQueueNorm[1]; end	-- Clip to last XP
		LootCount_XP_XPQueueModifier[1]=LootCount_XP_XPQueueModifier[1]/2;
	else LootCount_XP_XPQueueModifier[1]=0; end

	-- Make unrested normalised data
	i=1;
	while(i<=LOOTCOUNT_XP_XPQUEUE_SIZE) do
		LootCount_XP_XPQueueNorm[i]=LootCount_XP_XPQueue[i]-LootCount_XP_XPQueue[i+1];
		LootCount_XP_XPQueueNorm[i]=LootCount_XP_XPQueueNorm[i]-LootCount_XP_XPQueueModifier[i];
		i=i+1;
	end

	LootCount_XP_LastRested=GetXPExhaustion(); if (not LootCount_XP_LastRested) then LootCount_XP_LastRested=0; end	-- Set new rested as some XP update happened
	LootCountAPI.Force(LOOTCOUNT_XP);
end


function LootCount_XP_UpdateXPButton(button)
	if (not button) then return; end			-- End of iteration
	local i=1;
	local KillXP=0;
	local divider=0;
	local dText="XP:";
	while (i<=LOOTCOUNT_XP_XPQUEUE_SIZE) do
		if (not LootCount_XP_XPQueueNorm[i]) then return; end
		if (LootCount_XP_XPQueueNorm[i]>0) then divider=divider+1; end
		KillXP=KillXP+LootCount_XP_XPQueueNorm[i];
		i=i+1;
	end
	if (KillXP<LOOTCOUNT_XP_XPQUEUE_SIZE or divider<1) then return; end
	KillXP=KillXP/divider;
	local MaxXP=UnitXPMax("player");
	local RemainXP=MaxXP-UnitXP("player");

	if (LootCount_XP_LastRested>0) then								-- Make remaining XP unrested
		local ThisRested=LootCount_XP_LastRested;
		if (ThisRested>RemainXP) then ThisRested=RemainXP; end		-- Clip to top of level
		RemainXP=RemainXP-ThisRested/2;
	end

	local Remain=ceil(RemainXP/KillXP);
	local lastXP=nil;
	if (LootCount_XP_XPQueueNorm[1]>0) then lastXP=ceil(RemainXP/LootCount_XP_XPQueueNorm[1]); end
	LootCountAPI.SetData(LOOTCOUNT_XP,button,Remain,lastXP);
end


function LootCount_XP_Tooltip(button)
	GameTooltip:SetOwner(button,"ANCHOR_RIGHT");
	GameTooltip:SetText("Estimated kills until next level");
	GameTooltip:Show();
end



function LootCount_XP_OnUpdate(elapsed)
	if (LootCount_XP_Registered) then
		if (not LootCount_InCombat and LootCount_XP_Fighting) then
			LootCount_XP_Fighting=nil;
		elseif (LootCount_InCombat and not LootCount_XP_Fighting) then
			LootCount_XP_Fighting=true;
		end
		return;
	end
	if (not LootCountAPI or not LootCountAPI.Register) then return; end
	
	local info = { Name=LOOTCOUNT_XP, Update=LootCount_XP_UpdateXPButton, Texture="Interface\\Icons\\Ability_Creature_Cursed_05", Tooltip=LootCount_XP_Tooltip };
	LootCountAPI.Register(info);
	LootCount_XP_Registered=true;
	local i=1; while(i<=LOOTCOUNT_XP_XPQUEUE_SIZE) do
		LootCount_XP_XPQueueModifier[i]=0;
		LootCount_XP_XPQueueNorm[i]=0;
		i=i+1;
	end
end
