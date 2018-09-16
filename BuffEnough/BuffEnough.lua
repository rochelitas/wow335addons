--[[ ---------------------------------------------------------------------------

BuffEnough: personal buff monitor.

BuffEnough is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

BuffEnough is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License
along with BuffEnough.	If not, see <http://www.gnu.org/licenses/>.

----------------------------------------------------------------------------- ]]

--[[ ---------------------------------------------------------------------------
	 Instantiate addon and libraries
----------------------------------------------------------------------------- ]]

BuffEnough = LibStub("AceAddon-3.0"):NewAddon("BuffEnough", "AceEvent-3.0", "AceBucket-3.0", "AceTimer-3.0", "AceConsole-3.0")

local L = LibStub("AceLocale-3.0"):GetLocale("BuffEnough")
local TQ = LibStub:GetLibrary("LibTalentQuery-1.0")
local G = LibStub:GetLibrary("LibGratuity-3.0")
local LDB = LibStub:GetLibrary("LibDataBroker-1.1")


--[[ ---------------------------------------------------------------------------
	 Constants
----------------------------------------------------------------------------- ]]

local invSlots = {"HeadSlot", "NeckSlot", "ShoulderSlot", "BackSlot", "ChestSlot", "WristSlot", "HandsSlot", "WaistSlot", "LegsSlot", "FeetSlot", "Finger0Slot", "Finger1Slot", "Trinket0Slot", "Trinket1Slot", "MainHandSlot", "SecondaryHandSlot", "RangedSlot"}

local warnings = {}
warnings[L["Missing"]] = false
warnings[L["Broken"]] = false
warnings[L["Unexpected"]] = false
warnings[L["Low"]] = true
warnings[L["Unhappy"]] = false

local VER = " "..(GetAddOnMetadata("BuffEnough", "X-Curse-Packaged-Version") or GetAddOnMetadata("BuffEnough", "Version") or "")


--[[ ---------------------------------------------------------------------------
	 Ace3 initialization
----------------------------------------------------------------------------- ]]
function BuffEnough:OnInitialize()

	-- Initialize persistent addon variables
	self.raidClassCount = {}
	self.partyClassCount = {}
	self.talents = {}
	self.talentsAvailable = {}
	self.lastBuffer = {}
	self.playerIsTank = false
		
	self.trackedItems = {}
	self.results = {}
	self.isBuffEnough = true
	self.isBuffWarning = false
	
	self.Anchor = nil
	self.Display = nil
	self.Grip = nil
	self.tooltip = ""
	self.optionsFrame = nil
	self.isShowingTooltip = false
	self.timeSinceBuffEnough = 0
	self.currentCustomCategory = nil
	self.currentCustomAction = nil
	
	self.unitInventoryChangedBucket = nil
	self.updateInventoryAlertsBucket = nil

	-- Set up saved variables and config options
	self.db = LibStub("AceDB-3.0"):New("BuffEnoughDB", self.defaults, "Default")

	self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileDeleted","OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileReset", "OnProfileChanged")
	
	TQ.RegisterCallback(self, "TalentQuery_Ready")
	
	self.options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	LibStub("AceConfig-3.0"):RegisterOptionsTable(L["BuffEnough"], self.options, {L["buffenough"], L["be"]})
	self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(L["BuffEnough"], L["BuffEnough"])
	
	-- Set up the data broker object
	self.dobj = LDB:NewDataObject(L["BuffEnough"], {
		type = "data source",
		icon = "Interface\\Icons\\Spell_Magic_GreaterBlessingofKings",
		label = L["BuffEnough"],
    	text = L["Yes"],
    	OnClick = function(frame, button)
            if button == "LeftButton" then
            	if not self:GetProfileParam("enable") then
            		BuffEnough:ToggleConfigDialog()
            	else
                	BuffEnough:RunCheck()
                end
            elseif button == "RightButton" and IsShiftKeyDown() then
                BuffEnough:WhisperResults("player")
                BuffEnough:WhisperResults("pet")
            elseif button == "RightButton" then
                BuffEnough:PrintResults("player")
                BuffEnough:PrintResults("pet")
            end
        end,
    	OnTooltipShow = function(tooltip)
    		local txt = nil
			if not self:GetProfileParam("enable") then
				txt = L["Buff Enough"]..VER.."\n"..L["Currently disabled"]
			else
				txt = L["Buff Enough"]..VER..self.tooltip..L["Hint"]
			end
			
			if tooltip and tooltip.AddLine then
				tooltip:AddLine(txt)
			end
		end
	})
	
	LDB.RegisterCallback(self, "LibDataBroker_AttributeChanged_BuffEnough_text", "UpdateDisplay")
	LDB.RegisterCallback(self, "LibDataBroker_AttributeChanged_BuffEnough_buffenoughtooltiptext", "UpdateDisplay")
	
	-- Set up display
	self:CreateFrame()
	self:DisplayCustomBuffs()
	
	-- Register the events that might enable the addon
	self:RegisterBucketEvent("RAID_ROSTER_UPDATE", .2, "CheckRaidChange")
	self:RegisterBucketEvent("PARTY_MEMBERS_CHANGED", .2, "CheckRaidChange")

end


--[[ ---------------------------------------------------------------------------
	 Ace3 enable addon
----------------------------------------------------------------------------- ]]
function BuffEnough:OnEnable()

	local isSolo = GetNumRaidMembers() == 0 and GetNumPartyMembers() == 0
	
	if isSolo and not self:GetProfileParam("solo") then
		self:SetProfileParam("enable", false)
	end

	if self:GetProfileParam("enable") then
		self:DoEnable()
	end

end


--[[ ---------------------------------------------------------------------------
	 Enables addon
----------------------------------------------------------------------------- ]]
function BuffEnough:DoEnable()
	
	self:SetProfileParam("enable", true) 
	
	self:RegisterEvent("UNIT_AURA", "CheckBuffOrPetChange")
	self:RegisterEvent("UNIT_PET", "CheckBuffOrPetChange")
	self:RegisterEvent("ZONE_CHANGED", "RunCheck")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "RunCheck")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "RunCheck")
	self:RegisterEvent("READY_CHECK")
		
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", "RecordLastBuffer")

	self.unitInventoryChangedBucket = self:RegisterBucketEvent("UNIT_INVENTORY_CHANGED", .2, "RunCheck")
	self.updateInventoryAlertsBucket = self:RegisterBucketEvent("UPDATE_INVENTORY_ALERTS", .2, "RunCheck")
	
	-- Watch main tanks
	if oRA then
		self:RegisterEvent("oRA_MainTankUpdate", "RunCheck")
	end
	
	self:SetAnchors(true)
	self:UpdateVisible()
	self:RunCheck()

end


--[[ ---------------------------------------------------------------------------
	 Ace3 disable addon
----------------------------------------------------------------------------- ]]
function BuffEnough:OnDisable()

	self:DoDisable()

end


--[[ ---------------------------------------------------------------------------
	 Disables addon
----------------------------------------------------------------------------- ]]
function BuffEnough:DoDisable()

	self:SetProfileParam("enable", false) 
	
	self:UnregisterAllEvents()
	self:UnregisterBucket(self.unitInventoryChangedBucket)
	self:UnregisterBucket(self.updateInventoryAlertsBucket)

	self:UpdateVisible()

end


--[[ ---------------------------------------------------------------------------
	 Run the check!
----------------------------------------------------------------------------- ]]
function BuffEnough:RunCheck()

	if not self:GetProfileParam("enable") then
		return
	elseif not self:GetProfileParam("incombat") and UnitAffectingCombat("player") then
		return
	end
	
	-- Initialize
	self.tooltip = ""
	self.trackedItems = {}
	self.results = {}
	self.isBuffEnough = true
	self.isBuffWarning = false

	-- Go!
	self:CheckTank()
	self:ScanRaidParty()
	self:CheckBuffs()
	self:GetModule("Player"):CheckPaladinBlessings()
	self:GetModule("Player"):CheckClassBuffs()
	self:CheckGear()
	self:AnalyzeBuffResults()
	self:RenderTooltip()
	
	-- Feed results to DO
	if not self.isBuffEnough then
		self.dobj.text = L["No"]
	elseif self.isBuffWarning then
		self.dobj.text = L["Warning"]
	else
		self.dobj.text = L["Yes"]
	end
	
	self.dobj.buffenoughtooltiptext = L["Buff Enough"]..self.tooltip..L["Hint"]

end


--[[ ---------------------------------------------------------------------------
	 Iterate through party/raid to see what we have to work with
----------------------------------------------------------------------------- ]]
function BuffEnough:ScanRaidParty()

	-- Initialize
	self.raidClassCount = {DEATHKNIGHT = 0, DRUID = 0, HUNTER = 0, MAGE = 0, PALADIN = 0, PRIEST = 0, ROGUE = 0, SHAMAN = 0, WARLOCK = 0, WARRIOR = 0}
	self.partyClassCount = {DEATHKNIGHT = 0, DRUID = 0, HUNTER = 0, MAGE = 0, PALADIN = 0, PRIEST = 0, ROGUE = 0, SHAMAN = 0, WARLOCK = 0, WARRIOR = 0}
	self.talentsAvailable = {}

	local unit = nil
	local groupType = nil
	local groupSize = 0
	local startNum = 0
	local playerZone = GetRealZoneText()

	-- Determine group size
	if GetNumRaidMembers() > 0 then
		groupType = "raid"
		groupSize = GetNumRaidMembers()
		startNum = 1
	elseif GetNumPartyMembers() > 0 then
		groupType = "party"
		groupSize = GetNumPartyMembers()
	end

	-- Tally up the raid/party, check talents if needed
	for i = startNum, groupSize do

		if i == 0 then
			unit = "player"
		else
			unit = groupType..i
		end

		if UnitExists(unit) then

			local unitClass = select(2, UnitClass(unit))
			local unitZone = nil

			if ((groupType == "raid") and (UnitInRaid(unit))) then
				unitZone = select(7, GetRaidRosterInfo(i))
			end

			if ((not unitZone or unitZone == playerZone) and unitClass) then

				self.raidClassCount[unitClass] = self.raidClassCount[unitClass] + 1

				if (UnitInParty(unit)) then
					self.partyClassCount[unitClass] = self.partyClassCount[unitClass] + 1
				end

				if (unitClass == "PALADIN") then

					self:GetTalents(unit)

				end

			end

		end

	end

end


--[[ ---------------------------------------------------------------------------
	 Check buffs
----------------------------------------------------------------------------- ]]
function BuffEnough:CheckBuffs()

	-- Initialize
	local playerPowerType = UnitPowerType("player")
	local checkingConsumables = (GetNumRaidMembers() > 0) or (not self:GetProfileParam("consumablesinraid"))
	local checkingPet = self:GetProfileParam("petbuffs") and UnitExists("pet")

	local petPowerType = nil
	if checkingPet then
		petPowerType = UnitPowerType("pet")
	end

	-- What buffs do we actually have
	local i = 1
	while true do
	
		local category = L["Buffs"]
		local buff, _, _, _, _, duration, expTime, _, _ = UnitBuff("player", i)
		if not buff then break end
		local timeLeft = expTime and (expTime - GetTime()) or 0

		-- Map if this a longer version of a buff (eg. greater blessing vs regular blessing)
		if self.spellMap[buff] then
			buff = self.spellMap[buff]
		end

		-- Remap for flask/battle/guardian elixir
		if not self.knownSpells[buff] and checkingConsumables then

			G:SetUnitBuff("player", i)

			if (string.find(buff, L["Flask of"]) or
				string.find(buff, L["of Shattrath"]) or
				self.flasks[buff])
		   then
				buff = self.spells["Flask/Elixirs"]
				category = L["Consumables"]
				duration = 3600
			elseif G:Find(L["Battle Elixir"]) or self.battleElixirs[buff] then
				buff = self.spells["Battle Elixir"]
				category = L["Consumables"]
				duration = 3600
			elseif G:Find(L["Guardian Elixir"]) or self.guardianElixirs[buff] then
				buff = self.spells["Guardian Elixir"]
				category = L["Consumables"]
				duration = 3600
			end
			
		end
		
		if checkingConsumables and buff == self.spells["Well Fed"] then
			category = L["Consumables"]
			duration = 1800
		end
		
		self:TrackItem(category, buff, true, false, false, duration, timeLeft)
		i = i + 1

	end

	-- What buffs should we expect (or not expect) in general
	self:TrackItem(L["Buffs"], self.spells["Crusader Aura"], false, false, true)
	self:TrackItem(L["Buffs"], self.spells["Aspect of the Pack"], false, false, true)

	if self.raidClassCount["DRUID"] > 0 then
		self:TrackItem(L["Buffs"], self.spells["Mark of the Wild"], false, true)
		
		if checkingPet then
			self:TrackItem(L["Pet"], self.spells["Mark of the Wild"], false, true)
		end
	end

	if (self.raidClassCount["MAGE"] > 0 and playerPowerType == 0) then
		self:TrackItem(L["Buffs"], self.spells["Arcane Intellect"], false, true)
		
		if checkingPet and petPowerType == 0 then
			self:TrackItem(L["Pet"], self.spells["Arcane Intellect"], false, true)
		end
	end

	if self.raidClassCount["PRIEST"] > 0 then
		self:TrackItem(L["Buffs"], self.spells["Shadow Resistance Aura"], false, false, true)
		self:TrackItem(L["Buffs"], self.spells["Power Word: Fortitude"], false, true)
		
		if playerPowerType == 0 then
			self:TrackItem(L["Buffs"], self.spells["Divine Spirit"], false, true)
		end
		
		if checkingPet then
			self:TrackItem(L["Pet"], self.spells["Power Word: Fortitude"], false, true)
			
			if petPowerType == 0 then
				self:TrackItem(L["Pet"], self.spells["Divine Spirit"], false, true)
			end
		end
	end

	-- Consumables requirements
	if checkingConsumables then

		if self:GetProfileParam("flask") then
		
			local hasGuardian = self:HasTrackedItem(L["Consumables"], self.spells["Guardian Elixir"])
			local hasBattle = self:HasTrackedItem(L["Consumables"], self.spells["Battle Elixir"])
		
			if hasBattle and not hasGuardian then
				self:TrackItem(L["Consumables"], self.spells["Guardian Elixir"], false, true)
			elseif hasGuardian and not hasBattle then
				self:TrackItem(L["Consumables"], self.spells["Battle Elixir"], false, true)
			elseif not hasBattle and not hasGuardian then
				self:TrackItem(L["Consumables"], self.spells["Flask/Elixirs"], false, true)
			end
			
		end

		if self:GetProfileParam("food") then
			self:TrackItem(L["Consumables"], self.spells["Well Fed"], false, true)
		end
		
	end
	
	-- Add in any custom buff checks the player has defined
	for category,t in pairs(self:GetProfileParam("custom")) do
	
		for buff,action in pairs(t) do
	
			local isPresent = false
			local isExpected = false
			local isUnexpected = false
		
			if action == L["Expected"] then
				isExpected = true
			elseif action == L["Unexpected"] then
				isUnexpected = true
			elseif action == L["Ignored"] then
				isPresent = true
				isExpected = true
				isUnexpected = true
			end
			
			if category == L["Gear"] and IsEquippedItem(buff) then
				isPresent = true
			end
	
			self:TrackItem(category, buff, isPresent, isExpected, isUnexpected)
			
		end
	
	end

end


--[[ ---------------------------------------------------------------------------
	 Check gear
----------------------------------------------------------------------------- ]]
function BuffEnough:CheckGear()

	local twoHander = false

	local itemLink = GetInventoryItemLink("player", GetInventorySlotInfo("MainHandSlot"))
	if (itemLink and select(9,GetItemInfo(itemLink)) == "INVTYPE_2HWEAPON") then
		twoHander = true
	end

	-- Iterate over gear slots, check for missing/broken/almost broken items
	for _,slot in ipairs(invSlots) do

		local slotId = select(1, GetInventorySlotInfo(slot))

		if not GetInventoryItemQuality("player", slotId) then

			if ((slot ~= "SecondaryHandSlot") or (not twoHander)) then
				self:TrackItem(L["Gear"], L[slot], false, true)
			end

		elseif GetInventoryItemBroken("player", slotId) then
			self:TrackItem(L["Gear"], L[slot], false, true, false, nil, nil, nil, L["Broken"])
		else
			local value, max = GetInventoryItemDurability(slotId)
			local percent = 100

			if max and max ~= 0 and value then
				percent = (value / max) * 100
			end

			if percent < 10 then
				self:TrackItem(L["Gear"], L[slot], false, true, false, nil, nil, nil, L["Low"])
			end
		end

	end

	-- Check for temporary weapon enchants
	local hasMHEnchant, mhExp, _, hasOHEnchant, ohExp = GetWeaponEnchantInfo()
	
	if mhExp then mhExp = mhExp / 1000 end
	if ohExp then ohExp = ohExp / 1000 end
	
	if hasMHEnchant then
		self:TrackItem(L["Buffs"], L["Mainhand Buff"], true, false, false, 3600, mhExp)
	end
	
	if hasOHEnchant then
		self:TrackItem(L["Buffs"], L["Offhand Buff"], true, false, false, 3600, ohExp)
	end
	
	-- Check for temporary chest enchants
	local checkingConsumables = ((GetNumRaidMembers() > 0) or (not self:GetProfileParam("consumablesinraid")))
	if checkingConsumables and self:GetProfileParam("chest") then
		G:SetInventoryItem("player", select(1,GetInventorySlotInfo("ChestSlot")))
		if not G:Find(L["Rune of Warding"]) then
		    self:TrackItem(L["Consumables"], L["Rune of Warding"], false, true)
		end
	end
	
	-- Check for riding crop items
	if IsEquippedItem(self.spells["Riding Crop"]) and not IsMounted() then
		self:TrackItem(L["Gear"], self.spells["Riding Crop"], true, false, true)
	end

	if IsEquippedItem(self.spells["Skybreaker Whip"]) and not IsMounted() then
		self:TrackItem(L["Gear"], self.spells["Skybreaker Whip"], true, false, true)
	end

	-- If shadow resistance is <= 120, then we're probably not stacking
	-- shadow resist and don't mean to be wearing the medallion
	if (IsEquippedItem(self.spells["Blessed Medallion of Karabor"]) and
		select(2, UnitResistance("player", 5)) <= 120)
	then
		self:TrackItem(L["Gear"], self.spells["Blessed Medallion of Karabor"], true, false, true)
	end

	-- Check for fishing poles
	if IsEquippedItemType("Fishing Poles") then
		self:TrackItem(L["Gear"], self.spells["Fishing Pole"], true, false, true)
	end

end


--[[ ---------------------------------------------------------------------------
	 Analyze buff results
----------------------------------------------------------------------------- ]]
function BuffEnough:AnalyzeBuffResults()
	
	for c,cv in pairs(self.trackedItems) do

		for b,v in pairs(cv) do
		
			-- Set the status for each buff
			local status = nil
	
			if (v.isExpected and not v.isPresent) then
				status = L["Missing"]
			elseif (not v.isExpected and v.isUnexpected and v.isPresent) then
				status = L["Unexpected"]
			elseif (v.isExpected and v.isCloseToExpire) then
				status = L["Low"]
			end
		
			-- If there is a status, record it in results
			if status then
		
				if v.statusOverride then
					status = v.statusOverride
				end	
		
				if not self.results[c] then
					self.results[c] = {}
				end
		
				self.results[c][b] = status
			
			end
										  
		end

	end
		
end


--[[ ---------------------------------------------------------------------------
	 As we discover buffs that we should have, or buffs that we do have,
	 they get recorded here
----------------------------------------------------------------------------- ]]
function BuffEnough:TrackItem(category, itemName, isPresent, isExpected, isUnexpected, duration, timeLeft, dontReport, statusOverride)

	-- Create the category entry if this is the first one
	if not self.trackedItems[category] then
		self.trackedItems[category] = {}
	end
	
	-- Create the item entry if this is the first one
	if not self.trackedItems[category][itemName] then
		self.trackedItems[category][itemName] = {}
		self.trackedItems[category][itemName].statusOverride = statusOverride
		self.trackedItems[category][itemName].isCloseToExpire = false
		self.trackedItems[category][itemName].dontReport = false
	end

	-- Record item attributes
	self.trackedItems[category][itemName].isPresent = self.trackedItems[category][itemName].isPresent or isPresent
	self.trackedItems[category][itemName].isExpected = self.trackedItems[category][itemName].isExpected or isExpected
	self.trackedItems[category][itemName].isUnexpected = self.trackedItems[category][itemName].isUnexpected or isUnexpected
	self.trackedItems[category][itemName].dontReport = self.trackedItems[category][itemName].dontReport or dontReport
	
	-- Determine if about to expire
	if (duration and duration > 0 and
		timeLeft and timeLeft > 0 and
		self:GetProfileParam("warn") and
		(self:GetProfileParam("warnthreshold") * 60) >= timeLeft and
		(self:GetProfileParam("warnmin") == 0 or (self:GetProfileParam("warnmin") * 60) <= duration))
	then
		self.trackedItems[category][itemName].isCloseToExpire = true
	end
	
end


--[[ ---------------------------------------------------------------------------
	 Checks if we already have a buff on us
----------------------------------------------------------------------------- ]]
function BuffEnough:HasTrackedItem(category, itemName)

	hasItem = false

	if self.trackedItems and
	   self.trackedItems[category] and
	   self.trackedItems[category][itemName] and
	   self.trackedItems[category][itemName].isPresent
	then
		hasItem = true
	end
	
	return hasItem

end


--[[ ---------------------------------------------------------------------------
	 Checks if we are expecting a buff on us
----------------------------------------------------------------------------- ]]
function BuffEnough:IsExpectingTrackedItem(category, itemName)

	isExpectingItem = false

	if self.trackedItems and
	   self.trackedItems[category] and
	   self.trackedItems[category][itemName] and
	   self.trackedItems[category][itemName].isExpected
	then
		isExpectingItem = true
	end
	
	return isExpectingItem

end


--[[ ---------------------------------------------------------------------------
	 Takes a results table from any kind of check and formats it for the
	 tooltip
----------------------------------------------------------------------------- ]]
function BuffEnough:RenderTooltip()

	for heading, res in pairs(self.results) do

		if next(res) then	 

			self.tooltip = self.tooltip.."\n\n"..heading

			for buff,status in pairs(res) do
				
				self.tooltip = self.tooltip.."\n  "..status.." |cffffffff"..buff
				
				if (UnitExists(self.lastBuffer[buff])) then
					self.tooltip = self.tooltip.." ("..self.lastBuffer[buff]..")|r"
				else
					self.tooltip = self.tooltip.."|r"
				end

				if warnings[status] then
					self.isBuffWarning = true
				else
					self.isBuffEnough = false
				end

			end

		end

	end

end


--[[ ---------------------------------------------------------------------------
	 Display missing buffs in party/raid chat
----------------------------------------------------------------------------- ]]
function BuffEnough:PrintResults(unitId)

	local dest = nil
	local category = nil
	local reportedBuff = false
	local solo = false

	if unitId == "player" then
		category = L["Buffs"]
	elseif unitId == "pet" then
		if self:GetProfileParam("petbuffs") and UnitExists("pet") then
			category = L["Pet"]
		else
			return
		end
	else
		return
	end
	
	if GetNumRaidMembers() > 0 then
		dest = "RAID"
	elseif GetNumPartyMembers() > 0 then
		dest = "PARTY"
	else
		solo = true
	end

	if self.results[category] then	

		for buff,status in pairs(self.results[category]) do
		
		    if solo or not self.trackedItems[category][buff].dontReport then
		    
		    	if not reportedBuff then
					self:DoPrint(L["BuffEnough"]..": "..UnitName(unitId), dest)		    	
		    	end	
		    
				self:DoPrint("  "..status.." "..buff, dest)
				reportedBuff = true
			end
			
		end

	end

	if not reportedBuff then
		self:DoPrint(L["BuffEnough"]..": "..UnitName(unitId))
		self:DoPrint(L["All buffs accounted for!"])
	end
	
end


--[[ ---------------------------------------------------------------------------
	 Whisper missing buffs to the last person in party/raid to cast it
----------------------------------------------------------------------------- ]]
function BuffEnough:WhisperResults(unitId)

	local category = nil
	local whisperedBuff = false
	
	if GetNumRaidMembers() == 0 and GetNumPartyMembers() == 0 then
		self:PrintResults(unitId)
		return
	end

	if unitId == "player" then
		category = L["Buffs"]
	elseif unitId == "pet" then
		if self:GetProfileParam("petbuffs") and UnitExists("pet") then
			category = L["Pet"]
		else
			return
		end
	else
		return
	end
	
	if self.results[category] then	

		for buff,status in pairs(self.results[category]) do
		    if not self.trackedItems[category][buff].dontReport then
		    	whisperedBuff = true
		    	if UnitExists(self.lastBuffer[buff]) then
					SendChatMessage(L["BuffEnough"]..": "..UnitName(unitId).." "..status.." "..buff, "WHISPER", nil, self.lastBuffer[buff])
				else
					self:DoPrint(L["No buffer known for "]..buff)
				end
			end
		end

	end

	if not whisperedBuff then
		self:DoPrint(L["BuffEnough"]..": "..UnitName(unitId))
		self:DoPrint(L["All buffs accounted for!"])
	end
	
end


--[[ ---------------------------------------------------------------------------
	 Determine where to do text output
----------------------------------------------------------------------------- ]]
function BuffEnough:DoPrint(string, loc)

    if loc then
    	SendChatMessage(string, loc)
    else
    	DEFAULT_CHAT_FRAME:AddMessage(string);
    end

end

--[[ ---------------------------------------------------------------------------
	 Determine if the player is a tank according to CTRaid or oRA
----------------------------------------------------------------------------- ]]
function BuffEnough:CheckTank()

	local tanks = nil
	self.playerIsTank = false

	if oRA and oRA.maintanktable then
		tanks = oRA.maintanktable
	elseif CT_RA_MainTanks then
		tanks = CT_RA_MainTanks
	end

	if tanks then
		for _, name in pairs(tanks) do
			if name == UnitName("player") then
				self.playerIsTank = true
			end
		end
	end

end


--[[ ---------------------------------------------------------------------------
	 Queue up a talent query for the given unit (or do it right away if its
	 for the player)
----------------------------------------------------------------------------- ]]
function BuffEnough:GetTalents(unit)

	local name = UnitName(unit)

	if not self.talents[name] then

		if UnitIsUnit(unit, "player") then
			self:TalentQuery_Ready(_, name)
		else
			TQ:Query(unit)
		end

	elseif next(self.talents[name]) then

		for t,_ in pairs(self.talents[name]) do
			self.talentsAvailable[t] = true
		end

	end

end


--[[ ---------------------------------------------------------------------------
	 Callback function for unit talent inspection, called from LibTalentQuery
	 after we call Query() and the ready event fires
----------------------------------------------------------------------------- ]]
function BuffEnough:TalentQuery_Ready(_, name)

	self.talents[name] = {}
	local unitClass = select(2, UnitClass(name))
	local isNotPlayer = not UnitIsUnit(name, "player")

	if unitClass == "PALADIN" then
		self:DoTalentQuery(name, self.spells["Blessing of Sanctuary"], 2, 12, isNotPlayer)
	end

	self:ScanRaidParty()

end


--[[ ---------------------------------------------------------------------------
	 Perform and record the specified talent query
----------------------------------------------------------------------------- ]]
function BuffEnough:DoTalentQuery(name, talent, tabIndex, talentIndex, isNotPlayer)

	local points = select(5, GetTalentInfo(tabIndex, talentIndex, isNotPlayer))

	if points > 0 then
		self.talents[name][talent] = points
	end

end


--[[ ---------------------------------------------------------------------------
	 Check to see if we need to activate the addon or run a check based on
	 changes to the party/raid
----------------------------------------------------------------------------- ]]
function BuffEnough:CheckRaidChange()

	local isSolo = GetNumRaidMembers() == 0 and GetNumPartyMembers() == 0

	if not isSolo and not self:GetProfileParam("enable") then
		self:DoEnable()
	elseif isSolo and self:GetProfileParam("solo") and not self:GetProfileParam("enable") then
		self:DoEnable()
	elseif isSolo and self:GetProfileParam("enable") and not self:GetProfileParam("solo") then
		self:DoDisable()
	end
	
	self:RunCheck()
	
end


--[[ ---------------------------------------------------------------------------
	 Check to see if we need to run a check if the player or pet changed buffs
----------------------------------------------------------------------------- ]]
function BuffEnough:CheckBuffOrPetChange(_, unitId)

	if unitId == "player" or unitId == "pet" then
		self:RunCheck()
	end

end


--[[ ---------------------------------------------------------------------------
	 Handle ready check event
----------------------------------------------------------------------------- ]]
function BuffEnough:READY_CHECK()

	self:RunCheck()
	self:Unfade()
	
	if self.dobj.text == L["Yes"] then self:Fade() end

end


--[[ ---------------------------------------------------------------------------
	 Record who last cast a buff on the player
----------------------------------------------------------------------------- ]]
function BuffEnough:RecordLastBuffer(_, _, eventType, srcGUID, srcName, _, dstGUID, dstName, _, _, spellName)

	-- if a known buff spell is successfully cast by someone other than the player
	if eventType == "SPELL_CAST_SUCCESS" and
	   self.knownSpells[spellName] and
	   srcGUID ~= UnitGUID("player") and
	   dstGUID
	then
	
		   -- if the target of the spell is the player
		if dstGUID == UnitGUID("player") or
		   -- or it's a paladin blessing cast on the same class as the player
		   (self.blessings[spellName] and dstName and select(2, UnitClass(dstName)) == select(2, UnitClass("player"))) or
		   -- or it's a raid/party-wide buff 
		   (self.groupBuffs[spellName])
		then
		
			if self.spellMap[spellName] then
				spellName = self.spellMap[spellName]
			end
	
			self.lastBuffer[spellName] = srcName
	    	
	    end
	
	end
	
end
