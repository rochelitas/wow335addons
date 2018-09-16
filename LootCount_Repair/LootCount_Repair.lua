--[[****************************************************************
	LootCount Repair v0.10

	Author: Evil Duck
	****************************************************************

	Plug-in for the World of Warcraft add-on LootCount.

	****************************************************************]]

LOOTCOUNT_REPAIR_VERSIONTEXT = "LootCount Repair v0.10";
LOOTCOUNT_REPAIR = "LootCount Repair";
local LootCount_Repair_Index = 0;
local LootCount_Repair_Tick = 15;
local LOOTCOUNT_REPAIR_SPEED = 0.5;
local LootCount_Repair_Fighting=nil;
local LootCount_Repair_Stack = {
	Worst=100,
	Total=0,
	[ 1] = { Slot="HeadSlot", Name="Head", Cost=0, Durability=100 },
	[ 2] = { Slot="ShoulderSlot", Name="Shoulders", Cost=0, Durability=100 },
	[ 3] = { Slot="ChestSlot", Name="Chest", Cost=0, Durability=100 },
	[ 4] = { Slot="WristSlot", Name="Wrist", Cost=0, Durability=100 },
	[ 5] = { Slot="HandsSlot", Name="Hands", Cost=0, Durability=100 },
	[ 6] = { Slot="WaistSlot", Name="Waist", Cost=0, Durability=100 },
	[ 7] = { Slot="LegsSlot", Name="Legs", Cost=0, Durability=100 },
	[ 8] = { Slot="FeetSlot", Name="Feet", Cost=0, Durability=100 },
	[ 9] = { Slot="MainHandSlot", Name="Main hand", Cost=0, Durability=100 },
	[10] = { Slot="SecondaryHandSlot", Name="Offhand", Cost=0, Durability=100 },
	[11] = { Slot="RangedSlot", Name="Ranged", Cost=0, Durability=100 },
};
local LOOTCOUNT_MAXSLOTS=11;
local durapat="^Durability (%d+) / (%d+)$";


function LootCount_Repair_OnLoad()
	if (GetLocale()=="deDE") then durapat="^Haltbarkeit (%d+) / (%d+)$";
	elseif (GetLocale()=="frFR") then durapat="^Durabilit\195\169 (%d+) / (%d+)$";
	elseif (GetLocale()=="esES") then durapat="^Durabilidad (%d+) / (%d+)$";
	end
	this:RegisterEvent("MERCHANT_CLOSED");
end


function LootCount_Repair_OnEvent(event)
	if (event=="MERCHANT_CLOSED") then
		LootCount_Repair_Tick=LOOTCOUNT_REPAIR_SPEED;
		LootCount_Repair_Index=0;
	end
end


function LootCount_Repair_OnUpdate(elapsed)
	if (LootCount_Repair_Registered) then
		-- Trigger on combat done
		if (not LootCount_InCombat and LootCount_Repair_Fighting) then
			LootCount_Repair_Fighting=nil;
			LootCount_Repair_Tick=LOOTCOUNT_REPAIR_SPEED;
			LootCount_Repair_Index=0;
		elseif (LootCount_InCombat and not LootCount_Repair_Fighting) then
			LootCount_Repair_Fighting=true;
		end
		if (LootCount_Repair_Index>LOOTCOUNT_MAXSLOTS) then return; end			-- Done updating
		-- Run update
		LootCount_Repair_Tick=LootCount_Repair_Tick-elapsed;
		if (LootCount_Repair_Tick>0) then return; end

		LootCount_Repair_Tick=LOOTCOUNT_REPAIR_SPEED;
		LootCount_Repair_Index=LootCount_Repair_Index+1;
		if (LootCount_Repair_Index>LOOTCOUNT_MAXSLOTS) then return; end

		LootCount_Repair_Stack[LootCount_Repair_Index].Cost,LootCount_Repair_Stack[LootCount_Repair_Index].Durability=LootCount_Repair_GetCost(LootCount_Repair_Index);
		LootCount_Repair_Stack.Total=0;
		local index=LOOTCOUNT_MAXSLOTS;
		LootCount_Repair_Stack.Worst=100;
		while (index>0) do
			LootCount_Repair_Stack.Total=LootCount_Repair_Stack.Total+LootCount_Repair_Stack[index].Cost;
			if (LootCount_Repair_Stack[index].Durability<LootCount_Repair_Stack.Worst) then LootCount_Repair_Stack.Worst=LootCount_Repair_Stack[index].Durability; end
			index=index-1;
		end
		LootCountAPI.Force(LOOTCOUNT_REPAIR);
	
		return;																-- Already registered, so abort here
	end

	if (not LootCountAPI or not LootCountAPI.Register) then return; end		-- LootCount not ready for registering yet
	local info = {
		Name=LOOTCOUNT_REPAIR,												-- The internal identifier for your plug-in
		Texture="Interface\\Icons\\INV_1H_HaremMatron_D_01",				-- The icon to display within LootCount
		Update=LootCount_Repair_UpdateInterface,							-- The function LootCount will call when an update of the LootCount interface is needed
		Tooltip=LootCount_Repair_ShowTooltip,
	};
	LootCountAPI.Register(info);											-- Register plug-in
	LootCount_Repair_Registered=true;										-- Mark as registered
end


function LootCount_Repair_GetCost(index)
	LootCount_Repair_Tooltip:SetOwner(WorldFrame, "ANCHOR_NONE");
	LootCount_Repair_Tooltip:ClearLines();
	local id=GetInventorySlotInfo(LootCount_Repair_Stack[index].Slot);
	local exists,_,cost=LootCount_Repair_Tooltip:SetInventoryItem("player",id);
	local dura=100;

	if (exists) then
		if (not cost) then cost=0; end
		for i=1,30 do
			local field=getglobal("LootCount_Repair_TooltipTextLeft"..i);
			if (field~=nil) then
				local text=field:GetText();
				if (text) then
					local _,_,f_val,f_max=string.find(text,durapat);
					if (f_val) then dura=(tonumber(f_val)/tonumber(f_max))*100; i=30; end
				end
			end
		end
	else cost=0; end
	LootCount_Repair_Tooltip:Hide();

--LootCount_Chat(LootCount_Repair_Stack[index].Slot..": "..cost.." - "..dura);
	return cost,dura;
end


function LootCount_Repair_ShowTooltip(button)
	GameTooltip:SetOwner(button,"ANCHOR_RIGHT");
	GameTooltip:SetText(LOOTCOUNT_REPAIR_VERSIONTEXT);
	GameTooltip:AddLine("Repair-cost for equipped items: "..string.format("%.2f gold",LootCount_Repair_Stack.Total/10000));
	getglobal("GameTooltipTextLeft2"):SetTextColor(1,1,1);
	local lines=2;
	for i=1,LOOTCOUNT_MAXSLOTS do
		if (LootCount_Repair_Stack[i].Durability<=99) then
			lines=lines+1;
			GameTooltip:AddLine(LootCount_Repair_Stack[i].Name..": "..string.format("%.0f%%",LootCount_Repair_Stack[i].Durability));
			local saturation=floor(LootCount_Repair_Stack[i].Durability/10);
			saturation=saturation/10;
			getglobal("GameTooltipTextLeft"..lines):SetTextColor(1,saturation,saturation);
		end
	end
	if (lines==2) then GameTooltip:AddLine("Durability: 100%"); getglobal("GameTooltipTextLeft3"):SetTextColor(1,1,1); end

	GameTooltip:Show();
end


function LootCount_Repair_UpdateInterface(button)
	if (not button) then return; end			-- End of iteration
	local cost=LootCount_Repair_Stack.Total;
	local text="";
	if (cost>0) then
		    if (cost<100) then text=string.format("%.0fc",cost);
		elseif (cost<10000) then text=string.format("%.0fs",cost/100);
		else text=string.format("%.0fg",cost/10000);
		end
	end
	local dura=string.format("%.0f",LootCount_Repair_Stack.Worst);
	LootCountAPI.SetData(LOOTCOUNT_REPAIR,button,dura,text);
end







