--[[
	Copyright 2010 Matthew Mullins (aka Baffler)
	
    This file is part of 'Quartz: Procs' (World of Warcraft addon).

    'Quartz: Procs' is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    'Quartz: Procs' is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with 'Quartz: Procs'.  If not, see <http://www.gnu.org/licenses/>.
]]

--[[
	* For next beta
	- proc addition mode: spell id's on the tooltips? show spellid's somehwere?
	-- maybe just add by name if possible (for triggers)
	-- Trigger, proc by name?
	- Remove the one-time message when you type /procs
	
	X Choose events that you want each trigger to proc on, in config
	*Bugs
	
]]

local MAJOR_VERS = 3
local MINOR_VERS = 30
local vers = tostring(MAJOR_VERS) .. "." .. tostring(MINOR_VERS)


local Quartz3 = LibStub("AceAddon-3.0"):GetAddon("Quartz3")
local MODNAME = "Procs"
local QuartzProcs = Quartz3:NewModule(MODNAME, "AceEvent-3.0")
local Mirror = Quartz3:GetModule("Mirror")
local ex = Mirror.ExternalTimers
local media = LibStub("LibSharedMedia-3.0")

function del(tbl)
	wipe(tbl)
end

local db

local defaults = {
	profile = {
		fixCustomProcCaps = true,
		debugProcsAddon = false,
		procMode = false,
		cooldowns = { },
		spells = {
			[string.lower(GetSpellInfo(32182))] = {
				enabled = true, name = GetSpellInfo(32182),
				color = {1, 0.65, 0}, ptype = "custom",
			}, -- Heroism
			[string.lower(GetSpellInfo(2825))] = {
				enabled = true, name = GetSpellInfo(2825),
				color = {1, 0.65, 0}, ptype = "custom",
			},-- Bloodlust
		},
	}
}

local procs = {}

local buffThrottle = GetTime()
local combatThrottle = GetTime()

function QuartzProcs:DEBUGPRINT(text)
	if (db.debugProcsAddon == true) then
		print("Quartz:Procs~ " .. text)
	end
end

function QuartzProcs:SetupDebugging(debugstate)
	FrameXML_Debug(debugstate)
	
	if (debugstate == true) then
		--[[
		if (LoggingChat()) then
			print("Chat is already being logged")
		else
			LoggingChat(true)
			print("Chat is now being logged to Logs\\WOWChatLog.txt");
		end
		]]
		
		local _, curClass = UnitClass("player")
		
		print("Quartz:Procs~ Version = " .. vers)
		print("Quartz:Procs~ Class = " .. curClass)
		print("Quartz:Procs~ Level = " .. UnitLevel("player"))
	end
		--LoggingChat(false)
	--end
end

function QuartzProcs:OnInitialize()
	self.db = Quartz3.db:RegisterNamespace(MODNAME, defaults)
	db = self.db.profile
	
	self:SetupDebugging(db.debugProcsAddon)
	self:DEBUGPRINT("Initializing...")
	self:DEBUGPRINT("GetModuleEnabled("..MODNAME..") = " .. tostring(Quartz3:GetModuleEnabled(MODNAME)))
	
	self:SetEnabledState(Quartz3:GetModuleEnabled(MODNAME))
	Quartz3:RegisterModuleOptions(MODNAME, getOptions, "Procs")
	
	Quartz3:RegisterChatCommand("procs", function()
		if (Quartz3.optFrames[MODNAME] ~= nil) then
			if (db.version == nil) or (db.version ~= vers) then
				--print("|cFF00FF00Quartz: Procs|r ~ |cFFFF0000Attention!|r ~ If you added Triggers with an earlier version, then you need to go through each trigger you have in your custom proc list, and change the Event to SPELL_CAST_SUCCESS. If the proc doesn't work with that setting, change it to SPELL_DAMAGE for spells that have a cast time or SPELL_CAST_START for instant cast spells");
				--print("|cFF00FF00Quartz: Procs|r ~ |cFFFF0000Attention!|r ~ 'Proc Mode' added under the Settings tab. This lets you view Spell IDs and Event for each spell you cast, to make it easier to add Triggers")
				print("|cFF00FF00Quartz: Procs|r ~ |cFFFF0000Attention!|r ~ New 'CoolDowns' tab to allow adding of any spell (by name) that has a cooldown time. If you added any cooldowns with 'Add Trigger', then you need to delete those.")
				db.version = vers
			end
			
			InterfaceOptionsFrame_OpenToCategory(Quartz3.optFrames[MODNAME])
		else
			print(MODNAME .. " options have not been setup!")
		end
	end)
	
	Quartz3:RegisterChatCommand("procstest", function()
		self:createCustomTimer("Test Proc", 30, (GetTime() + 30), 2825, {1,0,0}, false, "", "combatlog")
	end)
	
	Quartz3:RegisterChatCommand("procsdebug", function()
		--self:createCustomTimer("Test Proc", 30, (GetTime() + 30), 2825, {1,0,0}, false, "", "combatlog")
		if (db.debugProcsAddon == false) then
			FrameXML_Debug(true)			
			db.debugProcsAddon = true
			print("Debugging enabled.")
			
			--[[
			if (LoggingChat()) then
			  print("Chat is already being logged")
			else
			  LoggingChat(true)
			  print("Chat is now being logged to Logs\\WOWChatLog.txt");
			end
			]]

		else
			FrameXML_Debug(false)
			db.debugProcsAddon = false
			print("Debugging disabled.")
			--LoggingChat(false)
		end
	end)
	
	procs = self:returnProcList()
	
	-- fix the custom procs that have already been added
	-- TODO: remove this in a future version
	if (db.fixCustomProcCaps == true) then
		local tmptbl = { }
		for spellkey,spell in pairs(db.spells) do
			if (spell.ptype ~= nil) and (spell.ptype == "custom") then
				tmptbl[string.lower(spellkey)] = {}
				tmptbl[string.lower(spellkey)].name = (spell.name ~= nil and spell.name or spellkey)
				tmptbl[string.lower(spellkey)].sound = (spell.sound ~= nil and spell.sound or "None")
				tmptbl[string.lower(spellkey)].color = (spell.color ~= nil and spell.color or {1,0,0})
				tmptbl[string.lower(spellkey)].ptype = "custom"
				--print(string.lower(spellkey))
			else
				tmptbl[spellkey] = db.spells[spellkey]
			end
		end
		
		table.wipe(db.spells)
		db.spells = nil
		
		db.spells = tmptbl
		
		db.fixCustomProcCaps = false
	end
	
	for spellkey,spell in pairs(db.spells) do
		if (spell.ptype ~= nil) and (spell.ptype == "custom") then
			procs[spellkey] = db.spells[spellkey]
		end
	end
	
	if (db.debugProcsAddon == true) then
		for spellkey,spell in pairs(procs) do
			print("Quartz:Procs~ spell= ".. tostring(spellkey) .. " " .. tostring(spell.color))
		end
	end
	
	self:checkTalentPoints()
end

function QuartzProcs:OnEnable()
	self:DEBUGPRINT("Registering Events...")
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:RegisterEvent("UNIT_AURA")
	self:RegisterEvent("PLAYER_TALENT_UPDATE")
	
	self:RegisterEvent("SPELL_UPDATE_COOLDOWN")
end

function QuartzProcs:OnDisable()
	self:DEBUGPRINT("Addon Disabled")
end

function QuartzProcs:SPELL_UPDATE_COOLDOWN()
	for spellkey,spell in pairs(db.cooldowns) do
		local startTime, sDuration, sEnabled = GetSpellCooldown(spell.name)
		if (sDuration ~= nil) and (sDuration > 1.5) then
			self:DEBUGPRINT(spellkey .. " - startTime: " .. tostring(startTime) .. " - dur: ".. tostring(sDuration))
			
			if (spell.enabled == nil) or (spell.enabled == true) then
				local expr = startTime + sDuration
					
				local spellcolor = {1, 0, 0}
				if (spell.color ~= nil) then
					spellcolor = spell.color
				end
				
				local tname, trank, sIcon = GetSpellInfo(spell.name)
				
				self:createCustomCooldownTimer(spell.name .. " CD", sDuration, expr, spellcolor, sIcon, "customcooldown")
			end
		end
	end
end

-- check talent points for paladin, to update timer lengths
function QuartzProcs:PLAYER_TALENT_UPDATE()
	local _, curClass = UnitClass("player")
	if (curClass == "PALADIN") then
		self:checkTalentPoints()
	end
end

-- get the divine guardian talent (to see how long to increase sacred shield buff)
function QuartzProcs:checkTalentPoints()
	local _, curClass = UnitClass("player")
	if (curClass == "PALADIN") then
		self:DEBUGPRINT("Checking talent points changed (for paladin's divine guardian length)")
		nameTalent, icon, tier, column, currRank, maxRank = GetTalentInfo(2,9); -- Divine Guardian
		
		if (procs ~= nil) and (procs.combatlog ~= nil) and (procs.combatlog["53601"] ~= nil)
		then
			self:DEBUGPRINT(tostring(nameTalent)..": "..tostring(currRank).."/"..tostring(maxRank));
			procs.combatlog["53601"].dur = 30 + (30 *  (currRank * 0.5))
			self:DEBUGPRINT("dur = " .. tostring(procs.combatlog["53601"].dur))
		else
			self:DEBUGPRINT("procs.combatlog[\"53601\"] was nil!")
		end
	end
end

function QuartzProcs:UNIT_AURA(event, unit)
	if (unit == "player") then
		self:CheckBuffs()
	end
end

function QuartzProcs:COMBAT_LOG_EVENT_UNFILTERED(event, ...)
	local timestamp, eventType, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags = select(1, ...)
	
	if ((GetTime() - combatThrottle) > 10) then
		self:DEBUGPRINT("COMBAT_LOG_EVENT_UNFILTERED")
		combatThrottle = GetTime()
	end

	if (sourceGUID == UnitGUID("player")) then --check if the player is casting the spell
		local spellID, spellname, spellSchool = select(9, ...)
		if (spellID ~= nil) and (spellID ~= "") then spellID = tostring(spellID) end

		if (db.procMode ~= nil) and (db.procMode == true) then
			print("-- " .. tostring(spellname) .. " id: "..tostring(spellID))
			print("- event = " .. tostring(eventType))
			print("----")
		end
		
		-- cooldown check 
		-- ignore SPELL_CAST_FAILED cause it gets called if you spam the button and its not off cooldown
		-- SPELL_CAST_START/SUCCESS seems to show incorrect times too
		--[[
		if (eventType ~= "SPELL_CAST_FAILED") and (eventType ~= "SPELL_CAST_START") and 
			(eventType ~= "SPELL_CAST_SUCCESS") and (spellname ~= nil) and 
			((db.cooldowns[string.lower(spellname)] ~= nil) and 
			 ((db.cooldowns[string.lower(spellname)].enabled == nil) or 
			 (db.cooldowns[string.lower(spellname)].enabled == true)))
		then
			local spell = db.cooldowns[string.lower(spellname)]
			local startTime, sDuration, sEnabled = GetSpellCooldown(spellname)
			--print(spellname .. " - startTime: " .. startTime .. " - dur: ".. sDuration)

			-- sDuration shows up as just 1/1.5 sometimes, do > 1.5 to fix it
			if (sEnabled == 1) and (startTime > 0) and (sDuration > 1.5) then
				local expr = startTime + sDuration
				
				local spellcolor = {1, 0, 0}
				if (spell.color ~= nil) then
					spellcolor = spell.color
				end
				
				--self:createCustomTimer(spell.name .. " CD", sDuration, expr, tonumber(spellID), spellcolor, false, "", "customcooldown")
			end
		end
		]]
		
		-- custom combat log event
		if ((db.spells[spellID] ~= nil) and (db.spells[spellID].ptype == "customcombatlog"))
		then
			local spell = db.spells[spellID]
			local expr = GetTime() + spell.dur
			local _,_,icon = GetSpellInfo(tonumber(spellID))

			if (spell.event ~= nil) and ((string.upper(spell.event) == eventType)
				or ((eventType == "SPELL_MISSED") and (spell.eventmiss ~= nil) and (spell.eventmiss == true)))
			then
				local sound = "None"
				if (spell.sound ~= nil) then
					sound = spell.sound
				end
				
				local spellcolor = {1, 0, 0}
				if (spell.color ~= nil) then
					spellcolor = spell.color
				end
				
				self:createCustomTimer(spell.name, spell.dur, expr, tonumber(spellID), spellcolor, false, sound, "customcombatlog")
				
				local spellcd = 0
				if (spell.cooldown ~= nil) and (type(spell.cooldown) == "number")
				then spellcd = spell.cooldown end
				
				if (spellcd > 0) then
					self:createCustomTimer(spell.name .. " CD", spellcd, 0, tonumber(spellID), {1,0,0}, true, "", "customcombatlog")
				end
			end
		end
			
		--if (eventType == "SPELL_CAST_SUCCESS") or (eventType == "SPELL_AURA_APPLIED") then
		if (eventType == "SPELL_AURA_APPLIED") or (eventType == "SPELL_AURA_REFRESH") then
			if (procs ~= nil) and (procs.combatlog ~= nil) and (procs.combatlog[spellID] ~= nil)
				--and (procs.combatlog[spellID].cast ~= nil) and (procs.combatlog[spellID].cast == true)
			then
				local spell = procs.combatlog[spellID]
				local expr = GetTime() + spell.dur
				local _,_,icon = GetSpellInfo(tonumber(spellID))
				local sdb = db.spells

				if ((sdb[spellID] == nil) or (sdb[spellID].enabled == nil) or (sdb[spellID].enabled == true))
				then
					local sound = "None"
					if ((sdb[spellID] ~= nil) and (sdb[spellID].sound ~= nil)) then
						sound = sdb[spellID].sound
					end
					
					local spellcolor = spell.color or {1, 0, 0}
					if ((sdb[spellID] ~= nil) and (sdb[spellID].color ~= nil)) then
						spellcolor = sdb[spellID].color
					end

					if (eventType == "SPELL_AURA_REFRESH") then
						-- refresh timer (used so like Arcane Blast(4) will stay at 4)
						self:refreshSpell(spell.name, spell.dur, expr, tonumber(spellID), spellcolor, sound, "combatlog")
					else
						self:createCustomTimer(spell.name, spell.dur, expr, tonumber(spellID), spellcolor, false, sound, "combatlog")
					end
				end
				--[[
				if ((sdb[spellID] == nil) or (sdb[spellID].enabled == nil) or (sdb[spellID].enabled == true))
				then
					local sound = "None"
					if ((sdb[spellID] ~= nil) and (sdb[spellID].sound ~= nil)) then
						sound = sdb[spellID].sound
					end
					
					local spellcolor = spell.color or {1, 0, 0}
					if ((sdb[spellID] ~= nil) and (sdb[spellID].color ~= nil)) then
						spellcolor = sdb[spellID].color
					end
					
					self:createCustomTimer(spell.name, spell.dur, expr, tonumber(spellID), spellcolor, false, sound, "combatlog")
				end]]
			end
		-- for spell stacking (so far this is only going to be used for ArcaneBlast debuff.. hmmm)
		elseif (eventType == "SPELL_AURA_APPLIED_DOSE") then
			if (procs ~= nil) and (procs.combatlog ~= nil) and (procs.combatlog[spellID] ~= nil) then
				local spellStack = select(13,...)
				local spell = procs.combatlog[spellID]
				local expr = GetTime() + spell.dur
				local _,_,icon = GetSpellInfo(tonumber(spellID))
				local sdb = db.spells
				
				if ((sdb[spellID] == nil) or (sdb[spellID].enabled == nil) or (sdb[spellID].enabled == true))
				then
					local spellcolor = spell.color or {1, 0, 0}
					if ((sdb[spellID] ~= nil) and (sdb[spellID].color ~= nil)) then
						spellcolor = sdb[spellID].color
					end
					--self:createCustomTimer(spell.name, spell.dur, expr, tonumber(spellID), spellcolor, false, "", "combatlog")
					self:checkSpellStack(spell.name, spellStack, spell.dur, expr, tonumber(spellID), spellcolor, "", "combatlog")
				end
			end
		-- remove the timer
		elseif (eventType == "SPELL_AURA_REMOVED") then
			if (procs ~= nil) and (procs.combatlog ~= nil) and (procs.combatlog[spellID] ~= nil) then
				for k,v in pairs(ex) do
					if (tostring(v.spellid) == tostring(spellID)) and (v.spelltype == "combatlog") then
						--print("Update 2")
						ex[k] = del(ex[k])
						Mirror:SendMessage("Quartz3Mirror_UpdateCustom")
					end
				end
			end
		end
	elseif (destGUID == UnitGUID("player")) then --check if the player is receiving the buff
		local spellID, spellname, spellSchool = select(9, ...)
		if (spellID ~= nil) and (spellID ~= "") then spellID = tostring(spellID) end
		
		if (eventType == "SPELL_AURA_APPLIED") or (eventType == "SPELL_AURA_REFRESH") then
			if (procs ~= nil) and (procs.combatlog ~= nil) and (procs.combatlog[spellID] ~= nil)
				--and ((procs.combatlog[spellID].cast == nil) or (procs.combatlog[spellID].cast == false))
			then
				local spell = procs.combatlog[spellID]
				local expr = GetTime() + spell.dur
				local _,_,icon = GetSpellInfo(tonumber(spellID))
				local sdb = db.spells

				if ((sdb[spellID] == nil) or (sdb[spellID].enabled == nil) or (sdb[spellID].enabled == true))
				then
					local sound = "None"
					if ((sdb[spellID] ~= nil) and (sdb[spellID].sound ~= nil)) then
						sound = sdb[spellID].sound
					end
					
					local spellcolor = spell.color or {1, 0, 0}
					if ((sdb[spellID] ~= nil) and (sdb[spellID].color ~= nil)) then
						spellcolor = sdb[spellID].color
					end

					if (eventType == "SPELL_AURA_REFRESH") then
						-- refresh timer (used so like Arcane Blast(4) will stay at 4)
						self:refreshSpell(spell.name, spell.dur, expr, tonumber(spellID), spellcolor, sound, "combatlog")
					else
						self:createCustomTimer(spell.name, spell.dur, expr, tonumber(spellID), spellcolor, false, sound, "combatlog")
					end
				end
			end
		elseif (eventType == "SPELL_AURA_REMOVED") then
			if (procs ~= nil) and (procs.combatlog ~= nil) and (procs.combatlog[spellID] ~= nil) then
				for k,v in pairs(ex) do
					--if (v.spellname == spellname) and (v.spelltype == "combatlog") then
					if (tostring(v.spellid) == tostring(spellID)) and (v.spelltype == "combatlog") then
						--print("Update 1")
						ex[k] = del(ex[k])
						Mirror:SendMessage("Quartz3Mirror_UpdateCustom")
					end
				end
			end
		end
	end
end

function QuartzProcs:CheckBuffs()
	if ((GetTime() - buffThrottle) > 10) then
		self:DEBUGPRINT("CheckBuffs()")
		buffThrottle = GetTime()
	end
	
	for i = 1, 40 do
		local name,rank,icon,count,dtype,dur,expr,caster,isStealable,shouldConsolidate,spellId=UnitAura("player",i)
		if not name then break end
		
		if (procs[string.lower(name)] ~= nil) or (procs[tostring(spellId)] ~= nil) then
			local spellname
			local spellkey
			if (procs[tostring(spellId)] ~= nil) then
				spellkey = tostring(spellId)
				spell = procs[spellkey]
				spellname = spell.name
			else
				spellkey = string.lower(name)
				spell = procs[spellkey]
				spellname = name
			end
			
			local sdb = db.spells
			
			if ((sdb[spellkey] == nil) or (sdb[spellkey].enabled == nil) or (sdb[spellkey].enabled == true))
			then
				if (dur ~= nil) and (dur > 0) then
					-- create timer
					local pColor = spell.color
					if (sdb[spellkey] ~= nil) and (sdb[spellkey].color ~= nil) then
						pColor = sdb[spellkey].color
					end
					
					local pSound = "None"
					if (sdb[spellkey] ~= nil) and (sdb[spellkey].sound ~= nil) then
						pSound = sdb[spellkey].sound
					end
						
					-- check if timer exists
					if (rawget(ex, spellname) == nil) then
						if (count == nil) or ((count ~= nil) and (count < 1)) then
							self:createCustomTimer(spellname, dur, expr, tonumber(spellId), pColor, false, pSound, "aura")
						end
						
						-- create cooldown timer
						local spellcd = 0
						if (spell.cooldown ~= nil) and (type(spell.cooldown) == "number")
						then spellcd = spell.cooldown end
						
						if (sdb[spellkey] ~= nil) and (sdb[spellkey].cooldown ~= nil)
							and (type(sdb[spellkey].cooldown) == "number") 
						then spellcd = sdb[spellkey].cooldown end
						
						-- TODO: spellcd needs to be spellcd - expires
						if (spellcd > 0) then
							self:createCustomTimer(spellname .. " CD", spellcd, 0, tonumber(spellId), {1,0,0}, true, "", "cooldown")
						end
					-- update timer
					elseif (rawget(ex, spellname) ~= nil) and (ex[spellname].expires ~= expr) then
						-- TODO: need to check this?
						if (count == nil) or ((count ~= nil) and (count < 1)) then
							self:createCustomTimer(spellname, dur, expr, tonumber(spellId), pColor, false, "", "aura")
						end
					end

					-- check spell stack here
					if (count) and (count > 0) then
						self:checkSpellStack(spellname, count, dur, expr, tonumber(spellId), pColor, pSound, "aura")
					end
				end
			end
		end
	end
	
	for k,v in pairs(ex) do
		local remSpell = true

		if (v.spelltype == "aura") or (v.spelltype == "cooldown") then
			for i = 1, 40 do
				local name,rank,icon,count,dtype,dur,expr,caster,isStealable,shouldConsolidate,spellId=UnitAura("player",i)
				if not name then break end
				
				if (v.spelltype == "cooldown") then
					-- check if cooldown is solar, and check if lunar eclipse exists
					if (v.spellid == 48517) and (spellId == 48518) then
						remSpell = true
						break
					-- check if cooldown is lunar, and check if solar eclipse exists
					elseif (v.spellid == 48518) and (spellId == 48517) then
						remSpell = true
						break
					else
						remSpell = false
					end
				end
					
				if (v.spelltype == "aura") and (tonumber(v.spellid) == tonumber(spellId)) then
					remSpell = false
					break
				end
			end

			if (remSpell == true) then
				if (rawget(ex, k) ~= nil) then
					--print("Update 3 ".. k)
					ex[k] = del(ex[k])
					Mirror:SendMessage("Quartz3Mirror_UpdateCustom")
				end
			end
		end
	end
end

function QuartzProcs:refreshSpell(spellname, duration, sExpires, spellid, spellcolor, spellsound, spelltype)
	self:DEBUGPRINT("refreshSpell")
	
	local foundSpell = false
	for k,v in pairs(ex) do
		--if (v.cooldown == false) and (v.spellname == spellname)
		if (v.cooldown == false) and (tonumber(v.spellid) == tonumber(spellid))
		then
			--if (rawget(ex,k) ~= nil) then
				--ex[k] = del(ex[k])
				--Mirror:SendMessage("Quartz3Mirror_UpdateCustom")
			--end
			
			self:createCustomTimer(k, duration, sExpires, spellid, spellcolor, false, "", spelltype)
			foundSpell = true
			break
		end
	end
	if (not foundSpell) then
		self:createCustomTimer(spellname, duration, sExpires, spellid, spellcolor, false, spellsound, spelltype)
	end
end

function QuartzProcs:checkSpellStack(spellname, spellcount, duration, sExpires, spellid, spellcolor, spellsound, spelltype)
	local dname = spellname.." ("..spellcount..")"
	self:DEBUGPRINT("checkSpellStack:: dname = "..tostring(dname))

	if (rawget(ex, dname) == nil) then
		local foundSpell = false
		for k,v in pairs(ex) do
			if (v.cooldown == false) and (tonumber(v.spellid) == tonumber(spellid)) and (k ~= dname)
			then
				if (rawget(ex, k) ~= nil) then
					--print("Update 4")
					ex[k] = del(ex[k])
					Mirror:SendMessage("Quartz3Mirror_UpdateCustom")
				end
				
				--print("1")
				-- refreshing timer
				self:createCustomTimer(dname, duration, sExpires, spellid, spellcolor, false, "", spelltype)
				foundSpell = true
				break
			end
		end
		if (not foundSpell) then
			--print("2")
			-- creating timer
			self:createCustomTimer(dname, duration, sExpires, spellid, spellcolor, false, spellsound, spelltype)
		end
	elseif (rawget(ex, dname) ~= nil) and (ex[dname].expires ~= sExpires) then
		--print("3")
		-- updating timer
		self:createCustomTimer(dname, duration, sExpires, spellid, spellcolor, false, spellsound, spelltype)
	end
end

function QuartzProcs:createCustomTimer(spellname, duration, sExpires, spellid, spellcolor, isCoolDown, spellsound, stype)
	self:DEBUGPRINT("createTimer:: "..tostring(spellname)..", "..tostring(duration)..", "..tostring(sExpires)..", "..tostring(spellid)..", "..tostring(spellcolor)..", "..tostring(isCoolDown)..", "..tostring(spellsound)..", "..tostring(stype))
	local sdb = db.spells[spellname]
	if (sdb == nil) then sdb = db.spells[spellid] end
	
	if (sdb == nil) or ((sdb ~= nil) and ((sdb.enabled == nil) or (sdb.enabled == true))) then
		local sIcon = ''
		local sName = ''
		local sColor = spellcolor
		if (sdb ~= nil) and (not isCoolDown) then sColor = sdb.color or spellcolor end
		if (type(spellid) == "number") and (spellid > 0) then
			sName,_,_ = GetSpellInfo(spellid)
			if (isCoolDown == false) then
				_,_,sIcon = GetSpellInfo(spellid)
			end
		end
		
		--print("Update 5")
		self:DEBUGPRINT("Updating Mirror.ExternalTimers")

		ex[spellname] = {
			startTime = GetTime(),
			endTime = GetTime() + duration,
			icon = sIcon,
			color = sColor,
			spellid = spellid,
			spellname = sname,
			expires = sExpires,
			cooldown = isCoolDown,
			spelltype = stype,
		} 
		
		Mirror:SendMessage("Quartz3Mirror_UpdateCustom")
		
		if (string.lower(spellsound) ~= "none") and (spellsound ~= "") then
			PlaySoundFile(spellsound)
		end

		if (not isCoolDown) then
			ex[spellname].startTime = GetTime() - ((GetTime() + duration) - sExpires)
			ex[spellname].endTime = sExpires
		end
	end
end

function QuartzProcs:createCustomCooldownTimer(spellname, duration, sExpires, spellcolor, spellicon, stype)
	ex[spellname] = {
		startTime = GetTime(),
		endTime = GetTime() + duration,
		icon = spellicon,
		color = spellcolor,
		spellid = 0,
		spellname = spellname,
		expires = sExpires,
		cooldown = false,
		spelltype = stype,
	} 
	
	Mirror:SendMessage("Quartz3Mirror_UpdateCustom")
		
	ex[spellname].startTime = GetTime() - ((GetTime() + duration) - sExpires)
	ex[spellname].endTime = sExpires
end




--[[
*********************************************
*** Configuration ***************************
*********************************************
]]

do
	local cTmpName = ""
	local cTmpColor = {0,0,0}
	--combat log
	--local cCombatLog = false
	--local cCombatLogSpellID = 0
	--local cCombatLogTime = 0
	--local cCombatLogCD = false
	--local cCombatLogCDTime = 0
	
	local cCombatLogName = ''
	local cCombatLogColor = {0,0,0}
	local cCombatLogSpellID = 0
	local cCombatLogDur = 0
	local cCombatLogEvent = "SPELL_CAST_SUCCESS"
	local cCombatLogEventMiss = false
	--
	local cCooldownName = ''
	local cCooldownColor = {0,0,0}
	--
	local cEventTypes = { ["SPELL_CAST_SUCCESS"] = "SPELL_CAST_SUCCESS", ["SPELL_CAST_START"] = "SPELL_CAST_START", ["SPELL_DAMAGE"] = "SPELL_DAMAGE", }
	local soundslist
	local options

	function cAddBtnFunc()
		if (cTmpName ~= nil) and (cTmpName ~= "") then
			local tmpTbl = {
				name = cTmpName,
				color = cTmpColor,
				ptype = 'custom',
			}
			db.spells[string.lower(cTmpName)] = tmpTbl
			--{
				--name = cTmpName,
				--color = cTmpColor,
				--ptype = 'custom',
			--}
			
			procs[string.lower(cTmpName)] = tmpTbl
			
			options.args.customprocs.args[string.lower(cTmpName)] = {
				type = 'group',
				name = cTmpName,
				desc = cTmpName,
				arg = tostring(cTmpName),
				args = spellCustomOptions,
			}
			
			print("Added '"..cTmpName.."'")
			
			cTmpName = ""
		else
			print("Some fields were empty or invalid!")
		end
	end
	
	function cCombatLogAddBtnFunc()
		if (cCombatLogName ~= nil) and (cCombatLogName ~= "")
			and (cCombatLogSpellID ~= nil) and (cCombatLogSpellID > 0)
		then
			local spellkey = tostring(cCombatLogSpellID)
			local tmpTbl = {
				name = cCombatLogName,
				color = cCombatLogColor,
				dur = cCombatLogDur,
				event = cCombatLogEvent,
				eventmiss = cCombatLogEventMiss,
				ptype = 'customcombatlog',
			}
			db.spells[spellkey] = {
				name = cCombatLogName,
				color = cCombatLogColor,
				dur = cCombatLogDur,
				event = cCombatLogEvent,
				eventmiss = cCombatLogEventMiss,
				ptype = 'customcombatlog',
			}
			
			procs[spellkey] = tmpTbl
			
			options.args.customprocs.args[spellkey] = {
				type = 'group',
				name = cCombatLogName,
				desc = cCombatLogName,
				arg = spellkey,
				args = spellCLCustomOptions,
			}
			
			print("Added '"..cCombatLogName.."'")
			
			cCombatLogName = ""
			cCombatLogSpellID = 0
			cCombatLogDur = 0
			cCombatLogEvent = "SPELL_CAST_SUCCESS"
			cCombatLogEventMiss = false
		else
			print("Some fields were empty or invalid!")
		end
	end
	
	function cCooldownAddBtnFunc()
		if (cCooldownName ~= nil) and (cCooldownName ~= "") then
			local spellkey = string.lower(tostring(cCooldownName))
			local tmpTbl = {
				name = cCooldownName,
				color = cCooldownColor,
				--ptype = 'customcombatlog',
			}
			db.cooldowns[spellkey] = {
				name = cCooldownName,
				color = cCooldownColor,
			}
			
			--procs[spellkey] = tmpTbl
			
			options.args.cooldownProcs.args[spellkey] = {
				type = 'group',
				name = cCooldownName,
				desc = cCooldownName,
				arg = spellkey,
				args = spellCoolDownCustomOptions,
			}
			
			print("Added Cooldown: '"..cCooldownName.."'")
			
			cCooldownName = ""
		else
			print("Some fields were empty or invalid!")
		end
	end
	
	function getOptions()
		if not soundslist then
			if not media:Fetch("sound", "Meow", true) then
				media:Register("sound", "Meow", [[Interface\AddOns\Quartz_Procs\media\kitten19.ogg]])
			end
			if not media:Fetch("sound", "Warning", true) then
				media:Register("sound", "Warning", [[Interface\AddOns\Quartz_Procs\media\warn1.wav]])
			end
			if not media:Fetch("sound", "System Failure", true) then
				media:Register("sound", "System Failure", [[Interface\AddOns\Quartz_Procs\media\system_failure.mp3]])
			end
			
			soundslist = {
				["None"] = "None", 
				["Sound\\Spells\\Sunwell_Fel_PortalStand.wav"] = "Fel Portal", 
				["Sound\\Spells\\SeepingGaseous_Fel_Nova.wav"] = "Fel Nova", 
				["Sound\\Doodad\\Hellfire_Raid_FX_Explosion05.wav"] = "Explosion",
				["Sound\\Doodad\\KharazahnBellToll.wav"] = "Kara Bell Toll", 
				["Sound\\Interface\\AlarmClockWarning1.wav"] = "Alarm 1", 
				["Sound\\Interface\\AlarmClockWarning2.wav"] = "Alarm 2", 
				["Sound\\Interface\\AlarmClockWarning3.wav"] = "Alarm 3", 
				["Sound\\Spells\\YarrrrImpact.wav"] = "Yarrr",
			}
			for idx, sound in next, media:List("sound") do
				if (string.lower(sound) ~= "none") then
					soundslist[media:Fetch("sound", sound)] = sound
				end
			end
		end
		
		if not spellCustomOptions then
			spellCustomOptions = {
				cToggle = {
					type = 'toggle',
					name = 'Enabled',
					desc = 'Enable/Disable',
					get = function(info)
						local sKey = info[3]
						if (db.spells[sKey] ~= nil) then
							if (db.spells[sKey].enabled ~= nil) then
								return db.spells[sKey].enabled
							else
								return true
							end
						end
						return true
					end,
					set = function(info, v)
						local sKey = info[3]
						if (db.spells[sKey] ~= nil) then
							db.spells[sKey].enabled = v
						end
					end,
					order = 10,
				},
				
				cColor = {
					type = 'color',
					name = 'color',
					get = function(info)
						local sKey = info[3]
						if (db.spells[sKey] ~= nil) then
							return unpack(db.spells[sKey].color)
						end
						return {1,0,0}
					end,
					set = function(info, ...)
						local sKey = info[3]
						if (db.spells[sKey] ~= nil) then
							db.spells[sKey].color = {...}
						end
					end,
					order = 30,
				},

				cSpellSound = {
					type = 'select',
					name = 'Sound',
					desc = 'Sound to make when proc occurs',
					get = function(info)
						local sKey = info[3]
						if (db.spells[sKey] ~= nil) and (db.spells[sKey].sound ~= nil) then
							return db.spells[sKey].sound
						end
						return "None"
					end,
					set = function(info, value)
						local sKey = info[3]
						if (db.spells[sKey] ~= nil) then
							db.spells[sKey].sound = value
							PlaySoundFile(value)
						else
							db.spells[sKey] = { sound = value }
							PlaySoundFile(value)
						end
					end,
					order = 40,
					values = soundslist,
				},

				
				cIntCooldown = {
					type = 'toggle',
					name = 'Cooldown',
					desc = 'Track the internal cooldown or the actual cooldown of the proc',
					get = function(info)
						local sKey = info[3]
						if (db.spells[sKey].cd == true) then
							return true
						end
						return false
					end,
					set = function(info, value)
						local sKey = info[3]
						if (db.spells[sKey] ~= nil) then
							db.spells[sKey].cd = value
							if (value == false) then
								db.spells[sKey].cooldown = nil
							end
						end
					end,
					order = 41,
				},
				
				cIntCooldownTime = {
					type = 'input',
					name = 'Cooldown Time',
					desc = 'How long the cooldown lasts',
					validate = function(info, value) return type(tonumber(value)) == "number" end,
					get = function(info)
						local sKey = info[3]
						if (db.spells[sKey].cooldown == nil) then return "0" end
						return tostring(db.spells[sKey].cooldown)
					end,
					set = function(info, value)
						local sKey = info[3]
						if (db.spells[sKey] ~= nil) then
							db.spells[sKey].cooldown = tonumber(value)
						end
					end,
					hidden = function(info)
						local sKey = info[3]
						if (db.spells[sKey].cd == nil) or (db.spells[sKey].cd == false)
						then return true; end
						return false
					end,
					order = 42,
				},
				

				cSplit = {
					type = 'header',
					name = '',
					order = 99,
				},
				cDelBtn = {
					type = 'execute',
					name = 'Delete',
					func = function(info)
						local sKey = info[3]
						local spellname = sKey
						if (db.spells[sKey] ~= nil) and (db.spells[sKey].name ~= nil) then
							spellname = db.spells[sKey].name
						end
						
						print("Removed custom proc ("..spellname..")")
						db.spells[sKey] = nil
						options.args.customprocs.args[sKey] = nil
						procs[tostring(sKey)] = nil
					end,
					order = 100,
				},
			}
		end
		
		-- Custom Combat Log Options
		if not spellCLCustomOptions then
			spellCLCustomOptions = {
				cToggle = {
					type = 'toggle',
					name = 'Enabled',
					desc = 'Enable/Disable',
					get = function(info)
						local sKey = info[3]
						if (db.spells[sKey] ~= nil) then
							if (db.spells[sKey].enabled ~= nil) then
								return db.spells[sKey].enabled
							else
								return true
							end
						end
						return true
					end,
					set = function(info, v)
						local sKey = info[3]
						if (db.spells[sKey] ~= nil) then
							db.spells[sKey].enabled = v
						end
					end,
					order = 10,
				},
				
				cName = {
					type = 'input',
					name = 'Name',
					desc = 'Name displayed on the timer',
					get = function(info)
						local sKey = info[3]
						if (db.spells[sKey] ~= nil) and (db.spells[sKey].name ~= nil) then
							return db.spells[sKey].name
						end
						return "<Not Set>"
					end,
					set = function(info, value)
						local sKey = info[3]
						if (db.spells[sKey] ~= nil) then
							db.spells[sKey].name = value
						end
					end,
					order = 11,
				},
				
				cSpellID = {
					type = 'input',
					name = 'Spell ID',
					desc = 'Spell ID (cannot be changed)',
					get = function(info)
						local sKey = info[3]
						return tostring(sKey)
					end,
					set = nil,
					--disabled = true,
					order = 12,
				},
				
				cDuration = {
					type = 'input',
					name = 'Duration',
					desc = 'Duration of the timer',
					validate = function(info, value) return type(tonumber(value)) == "number" end,
					get = function(info)
						local sKey = info[3]
						if (db.spells[sKey] ~= nil) and (db.spells[sKey].dur ~= nil) then
							return tostring(db.spells[sKey].dur)
						end
						return "<Not Set>"
					end,
					set = function(info, value)
						local sKey = info[3]
						if (db.spells[sKey] ~= nil) then
							db.spells[sKey].dur = tonumber(value)
						end
					end,
					order = 13,
				},
				
				cColor = {
					type = 'color',
					name = 'color',
					get = function(info)
						local sKey = info[3]
						if (db.spells[sKey] ~= nil) then
							return unpack(db.spells[sKey].color)
						end
						return {1,0,0}
					end,
					set = function(info, ...)
						local sKey = info[3]
						if (db.spells[sKey] ~= nil) then
							db.spells[sKey].color = {...}
						end
					end,
					order = 30,
				},
				
				cEventType = {
					type = 'select',
					name = 'Event',
					desc = 'The event this proc will occur on',
					get = function(info)
						local sKey = info[3]
						if (db.spells[sKey] ~= nil) and (db.spells[sKey].event ~= nil) then
							return db.spells[sKey].event
						end
						return "None"
					end,
					set = function(info, value)
						local sKey = info[3]
						if (db.spells[sKey] ~= nil) then
							db.spells[sKey].event = value
						end
					end,
					order = 31,
					values = cEventTypes,
				},
				
				cToggle = {
					type = 'toggle',
					name = 'Proc on Spell Miss',
					desc = 'Also proc on spell_miss event',
					get = function(info)
						local sKey = info[3]
						if (db.spells[sKey] ~= nil) then
							if (db.spells[sKey].event ~= nil) then
								return db.spells[sKey].eventmiss
							else
								return false
							end
						end
						return true
					end,
					set = function(info, v)
						local sKey = info[3]
						if (db.spells[sKey] ~= nil) then
							if (db.spells[sKey].event ~= nil) then
								db.spells[sKey].eventmiss = v
							end
						end
					end,
					order = 32,
				},

				cSpellSound = {
					type = 'select',
					name = 'Sound',
					desc = 'Sound to make when proc occurs',
					get = function(info)
						local sKey = info[3]
						if (db.spells[sKey] ~= nil) and (db.spells[sKey].sound ~= nil) then
							return db.spells[sKey].sound
						end
						return "None"
					end,
					set = function(info, value)
						local sKey = info[3]
						if (db.spells[sKey] ~= nil) then
							db.spells[sKey].sound = value
							PlaySoundFile(value)
						end
					end,
					order = 40,
					values = soundslist,
				},

				
				cIntCooldown = {
					type = 'toggle',
					name = 'Cooldown',
					desc = 'Track the internal cooldown or the actual cooldown of the proc',
					get = function(info)
						local sKey = info[3]
						if (db.spells[sKey].cd == true) then
							return true
						end
						return false
					end,
					set = function(info, value)
						local sKey = info[3]
						if (db.spells[sKey] ~= nil) then
							db.spells[sKey].cd = value
							if (value == false) then
								db.spells[sKey].cooldown = nil
							end
						end
					end,
					order = 41,
				},
				
				cIntCooldownTime = {
					type = 'input',
					name = 'Cooldown Time',
					desc = 'How long the cooldown lasts',
					validate = function(info, value) return type(tonumber(value)) == "number" end,
					get = function(info)
						local sKey = info[3]
						if (db.spells[sKey].cooldown == nil) then return "0" end
						return tostring(db.spells[sKey].cooldown)
					end,
					set = function(info, value)
						local sKey = info[3]
						if (db.spells[sKey] ~= nil) then
							db.spells[sKey].cooldown = tonumber(value)
						end
					end,
					hidden = function(info)
						local sKey = info[3]
						if (db.spells[sKey].cd == nil) or (db.spells[sKey].cd == false)
						then return true; end
						return false
					end,
					order = 42,
				},
				

				cSplit = {
					type = 'header',
					name = '',
					order = 99,
				},
				cDelBtn = {
					type = 'execute',
					name = 'Delete',
					func = function(info)
						local sKey = info[3]
						local spellname = sKey
						if (db.spells[sKey] ~= nil) and (db.spells[sKey].name ~= nil) then
							spellname = db.spells[sKey].name
						end
						
						print("Removed custom proc ("..spellname..")")
						db.spells[sKey] = nil
						options.args.customprocs.args[sKey] = nil
						procs[tostring(sKey)] = nil
					end,
					order = 100,
				},
			}
		end
		--
		
		-- Cooldown Options table
		if not spellCoolDownCustomOptions then
			spellCoolDownCustomOptions = {
				cdToggle = {
					type = 'toggle',
					name = 'Enabled',
					desc = 'Enable/Disable',
					get = function(info)
						local sKey = info[3]
						if (db.cooldowns[sKey] ~= nil) then
							if (db.cooldowns[sKey].enabled ~= nil) then
								return db.cooldowns[sKey].enabled
							else
								return true
							end
						end
						return true
					end,
					set = function(info, v)
						local sKey = info[3]
						if (db.cooldowns[sKey] ~= nil) then
							db.cooldowns[sKey].enabled = v
						end
					end,
					order = 10,
				},
				
				cdColor = {
					type = 'color',
					name = 'color',
					get = function(info)
						local sKey = info[3]
						if (db.cooldowns[sKey] ~= nil) then
							return unpack(db.cooldowns[sKey].color)
						end
						return {1,0,0}
					end,
					set = function(info, ...)
						local sKey = info[3]
						if (db.cooldowns[sKey] ~= nil) then
							db.cooldowns[sKey].color = {...}
						end
					end,
					order = 30,
				},
				
				cSplit = {
					type = 'header',
					name = '',
					order = 99,
				},
				cDelBtn = {
					type = 'execute',
					name = 'Delete',
					func = function(info)
						local sKey = info[3]
						local spellname = sKey
						if (db.cooldowns[sKey] ~= nil) and (db.cooldowns[sKey].name ~= nil) then
							spellname = db.cooldowns[sKey].name
						end
						
						print("Removed custom proc ("..spellname..")")
						db.cooldowns[sKey] = nil
						options.args.cooldownProcs.args[sKey] = nil
					end,
					order = 100,
				},
			}
		end
--
		
		if not options then
			options = {
				type = "group",
				name = "Procs",
				order = 700,
				--set = setOpt,
				--get = getOpt,
				childGroups = "tab",
				args = {
					toggle = {
						type = "toggle",
						name = "Enable",
						desc = "Enable or Disable this module",
						get = function()
							return Quartz3:GetModuleEnabled(MODNAME)
						end,
						set = function(info, v)
							Quartz3:SetModuleEnabled(MODNAME, v)
						end,
						order = 1,
						width = "full",
					},
					mconfig = {
						type = 'group',
						name = 'Settings',
						desc = 'Timer Bar Settings',
						order = 40,
						args = {
							mProcModeHelp = {
								type = 'description',
								name = 'Toggle the option below to show spells that you have cast. Displays Spell IDs and Events for each spell you cast in chat.',
								order = 1,
							},
							mProcMode = {
								type = 'toggle',
								name = 'Display CL Info',
								desc = 'Show spell ids and events of spells in chat window (that only you cast)',
								get = function()
									return db.procMode
								end,
								set = function(info, v)
									db.procMode = v
								end,
								order = 2,
								width = 'full',
							},
							msplit = {
								type = 'header',
								name = '',
								order = 3,
							},
							mhelp = {
								type = 'description',
								name = 'Quartz: Procs uses the Mirror module to display each proc.' ..
									' In order to change the position/size/texture/font etc., you can '..
									'open the Mirror module settings by clicking the button below, or '..
									'navigate to the Mirror module configuration under the Quartz category.',
								order = 10,
							},
							mBtnOpen = {
								type = 'execute',
								name = 'Mirror Module Options',
								desc = 'Configure what the timer bars will look like',
								func = function()
									if (Quartz3.optFrames.Mirror ~= nil) then
										InterfaceOptionsFrame_OpenToCategory(Quartz3.optFrames.Mirror)
									else
										print("Mirror options are nil!")
									end
								end,
								order = 15,
							},
						},
					},
					classprocs = {
						type = "group",
						name = "Class Procs",
						order = 10,
						args = {},
					},
					customprocs = {
						type = "group",
						name = "Custom Procs",
						order = 20,
						args = {
							AddNewProc = {
								type = 'group',
								name = "Add Proc",
								desc = "Add a New Custom Proc",
								order = 1,
								args = {
									customNameHelp = {
										type = 'description',
										name = 'The "Name" field has to be filled in with the exact name of the buff or proc you wish to add. The exact name can be obtained by having the buff or proc occur, and then hovering your mouse over it in the buff bar',
										order = 1,
									},
									customName = {
										type = 'input',
										name = 'Name',
										get = function()
											return cTmpName or ''
										end,
										set = function(info, v)
											cTmpName = v
										end,
										order = 2,
									},
									customColor = {
										type = 'color',
										name = 'color',
										get = function()
											return unpack(cTmpColor)
										end,
										set = function(info, ...)
											cTmpColor = {...}
										end,
										order = 5,
									},
									customHeader = {
										type = 'header',
										name = '',
										order = 6,
									},
									-- combat log trigger
									--[[
									customToggleComatLog = {
										type = 'toggle',
										name = 'CombatLog Event',
										desc = 'Create a proc or cooldown triggered by Combat Log',
										get = function(info)
											return cCombatLog
										end,
										set = function(info, value)
											cCombatLog = value
										end,
										order = 10,
									},
									
									customCLSpellID = {
										type = 'input',
										name = 'Spell ID',
										desc = 'The Spell ID of the spell (can be obtained from WoWhead.com)',
										validate = function(info, value) return type(tonumber(value)) == "number" end,
										get = function(info)
											return tostring(cCombatLogSpellID)
										end,
										set = function(info, value)
											cCombatLogSpellID = tonumber(value)
										end,
										hidden = function(info)
											return not cCombatLog
										end,
										order = 11,
									},
									
									customCLSpellDuration = {
										type = 'input',
										name = 'Duration',
										desc = 'The duration of the spell',
										validate = function(info, value) return type(tonumber(value)) == "number" end,
										get = function(info)
											return tostring(cCombatLogTime)
										end,
										set = function(info, value)
											cCombatLogTime = tonumber(value)
										end,
										hidden = function(info)
											return not cCombatLog
										end,
										order = 12,
									},
									
									customToggleComatLogCD = {
										type = 'toggle',
										name = 'Cooldown',
										desc = 'Cooldown that is attached to combatlog spell',
										get = function(info)
											return cCombatLogCD
										end,
										set = function(info, value)
											cCombatLogCD = value
										end,
										hidden = function(info)
											return not cCombatLog
										end,
										order = 13,
									},
									
									customCLCDduration = {
										type = 'input',
										name = 'Cooldown Duration',
										desc = 'The duration of the cooldown',
										validate = function(info, value) return type(tonumber(value)) == "number" end,
										get = function(info)
											return tostring(cCombatLogCDTime)
										end,
										set = function(info, value)
											cCombatLogCDTime = tonumber(value)
										end,
										hidden = function(info)
											if (cCombatLog) and (cCombatLogCD) then
												return false
											end
											return true
										end,
										order = 14,
									},
									]]
									-- 
									customAddBtn = {
										type = 'execute',
										name = 'Add',
										func = cAddBtnFunc,
										order = 30,
									},
									customResetBtn = {
										type = 'execute',
										name = 'Reset',
										func = function(info)
											cTmpName = ""
										end,
										order = 40,
									},
								},
							},
								
							AddNewTrigger = {
								type = 'group',
								name = "Add Trigger",
								desc = "Add a New Custom Trigger. This timer is triggered by a combat log event",
								order = 3,
								args = {
									clcustomNameHelp = {
										type = 'description',
										name = 'The "Name" field can be filled in with anything you choose. The only thing you must have correct is the "Spell ID" below. You can get the Spell ID from raw combat logs or websites like wowhead.com',
										order = 1,
									},
									clcustomName = {
										type = 'input',
										name = 'Name',
										get = function()
											return cCombatLogName or ''
										end,
										set = function(info, v)
											cCombatLogName = v
										end,
										order = 2,
									},
									clcustomColor = {
										type = 'color',
										name = 'color',
										get = function()
											return unpack(cCombatLogColor)
										end,
										set = function(info, ...)
											cCombatLogColor = {...}
										end,
										order = 5,
									},
									
									customCLSpellID = {
										type = 'input',
										name = 'Spell ID',
										desc = 'The Spell ID of the spell (can be obtained from WoWhead.com)',
										validate = function(info, value) return type(tonumber(value)) == "number" end,
										get = function(info)
											return tostring(cCombatLogSpellID)
										end,
										set = function(info, value)
											cCombatLogSpellID = tonumber(value)
										end,
										order = 11,
									},
									
									customCLSpellDuration = {
										type = 'input',
										name = 'Duration',
										desc = 'The duration of the timer',
										validate = function(info, value) return type(tonumber(value)) == "number" end,
										get = function(info)
											return tostring(cCombatLogDur)
										end,
										set = function(info, value)
											cCombatLogDur = tonumber(value)
										end,
										order = 12,
									},
									
									-- event
									clcustomEventHelp = {
										type = 'description',
										name = 'SPELL_CAST_SUCCESS typically works, if it doesn\'t, then you change it to SPELL_CAST_START for instant spells or SPELL_DAMAGE for spells with a cast time, after you add the proc.',
										order = 13,
									},
									customCLEventType = {
										type = 'select',
										name = 'Event',
										desc = 'The event this proc will occur on',
										get = function(info)
											return cCombatLogEvent
										end,
										set = function(info, value)
											cCombatLogEvent = value
										end,
										order = 14,
										values = cEventTypes,
									},
									
									customCLToggle = {
										type = 'toggle',
										name = 'Proc on Spell Miss',
										desc = 'Also makes the timer appear when the spell misses the target',
										get = function(info)
											return cCombatLogEventMiss
										end,
										set = function(info, v)
											cCombatLogEventMiss = v
										end,
										order = 15,
									},
									--
									
									clcustomAddBtn = {
										type = 'execute',
										name = 'Add',
										func = cCombatLogAddBtnFunc,
										order = 30,
									},
									clcustomResetBtn = {
										type = 'execute',
										name = 'Reset',
										func = function(info)
											cCombatLogName = ""
											cCombatLogSpellID = 0
											cCombatLogDur = 0
											cCombatLogEvent = "SPELL_CAST_SUCCESS"
											cCombatLogEventMiss = false
										end,
										order = 40,
									},
								},
							},
							
						},
					},
					
					cooldownProcs = {
						type = "group",
						name = "CoolDowns",
						order = 30,
						args = {
							AddNewCooldown = {
								type = 'group',
								name = "Add Cooldown",
								desc = "Add a New Custom Cooldown. This is used only for tracking cooldowns on spells",
								order = 1,
								args = {
									cdcustomNameHelp = {
										type = 'description',
										name = 'The "Name" field has to match exactly with the name of the spell. Case insensitive (Lowercase/Uppercase doesn\'t matter)',
										order = 1,
									},
									cdcustomName = {
										type = 'input',
										name = 'Name',
										get = function()
											return cCooldownName or ''
										end,
										set = function(info, v)
											cCooldownName = v
										end,
										order = 2,
									},
									
									cdcustomColor = {
										type = 'color',
										name = 'color',
										get = function()
											return unpack(cCooldownColor)
										end,
										set = function(info, ...)
											cCooldownColor = {...}
										end,
										order = 5,
									},
									
									cdcustomAddBtn = {
										type = 'execute',
										name = 'Add',
										func = cCooldownAddBtnFunc,
										order = 30,
									},
									cdcustomResetBtn = {
										type = 'execute',
										name = 'Reset',
										func = function(info)
											cCooldownName = ""
										end,
										order = 40,
									},
								},
							},
						}
						
					},
				}
			}
		end
		
		
		for spellkey,spell in pairs(procs) do
			if (spell.ptype == nil) and (spell.color ~= nil) then --spell.color check prevents combatlog from showing up (or spells we forget to set a color to)
				options.args.classprocs.args[spellkey] = {
					type = 'group',
					name = spell.name or spellkey,
					desc = spell.name or spellkey,
					order = 5,
					arg = tostring(spellkey),
					args = {
						cTitle = {
							type = 'description',
							order = 6,
							name = spell.name or spellkey,
						},
						cSplit = {
							type = "header",
							name = "",
							order = 7,
						},
						cToggle = {
							type = 'toggle',
							name = 'Enabled',
							desc = 'Enable/Disable',
							get = function(info)
								local sKey = info[3]
								if (db.spells[sKey] ~= nil) then
									if (db.spells[sKey].enabled ~= nil) then
										return db.spells[sKey].enabled
									else
										return true
									end
								end
								return true
							end,
							set = function(info, v)
								local sKey = info[3]
								if (db.spells[sKey] ~= nil) then
									db.spells[sKey].enabled = v
								else
									db.spells[sKey] = { enabled = v }
								end
							end,
							order = 10,
						},
						
						cColor = {
							type = 'color',
							name = 'Color',
							desc = "Color of the bar for the timer",
							get = function(info)
								local sKey = info[3]
								if (db.spells[sKey] ~= nil) and (db.spells[sKey].color ~= nil) then
									return unpack(db.spells[sKey].color)
								end
								return unpack(spell.color)
							end,
							set = function(info, ...)
								local sKey = info[3]
								if (db.spells[sKey] ~= nil) then
									db.spells[sKey].color = {...}
								else
									db.spells[sKey] = { color = {...} }
								end
							end,
							order = 30,
						},
						
						cSpellSound = {
							type = 'select',
							name = 'Sound',
							desc = 'Sound to make when proc occurs',
							get = function(info)
								local sKey = info[3]
								if (db.spells[sKey] ~= nil) and (db.spells[sKey].sound ~= nil) then
									return db.spells[sKey].sound
								end
								return "None"
							end,
							set = function(info, value)
								local sKey = info[3]
								if (db.spells[sKey] ~= nil) then
									db.spells[sKey].sound = value
									PlaySoundFile(value)
								else
									db.spells[sKey] = { sound = value }
									PlaySoundFile(value)
								end
							end,
							order = 40,
							values = soundslist,
						},
					},
				}
			end
			
			if (procs.combatlog ~= nil) then
				for k,v in pairs(procs.combatlog) do
					options.args.classprocs.args[k] = {
						type = 'group',
						name = v.name or k,
						desc = v.name or k,
						order = 5,
						arg = tostring(k),
						args = {
							cTitle = {
								type = 'description',
								order = 6,
								name = v.name or k,
							},
							cSplit = {
								type = "header",
								name = "",
								order = 7,
							},
							cToggle = {
								type = 'toggle',
								name = 'Enabled',
								desc = 'Enable/Disable',
								get = function(info)
									local sKey = info[3]
									if (db.spells[sKey] ~= nil) then
										if (db.spells[sKey].enabled ~= nil) then
											return db.spells[sKey].enabled
										else
											return true
										end
									end
									return true
								end,
								set = function(info, v)
									local sKey = info[3]
									if (db.spells[sKey] ~= nil) then
										db.spells[sKey].enabled = v
									else
										db.spells[sKey] = { enabled = v }
									end
								end,
								order = 10,
							},
							
							cColor = {
								type = 'color',
								name = 'Color',
								desc = "Color of the bar for the timer",
								get = function(info)
									local sKey = info[3]
									if (db.spells[sKey] ~= nil) and (db.spells[sKey].color ~= nil) then
										return unpack(db.spells[sKey].color)
									end
									return unpack(v.color)
								end,
								set = function(info, ...)
									local sKey = info[3]
									if (db.spells[sKey] ~= nil) then
										db.spells[sKey].color = {...}
									else
										db.spells[sKey] = { color = {...} }
									end
								end,
								order = 30,
							},
							
							cSpellSound = {
								type = 'select',
								name = 'Sound',
								desc = 'Sound to make when proc occurs',
								get = function(info)
									local sKey = info[3]
									if (db.spells[sKey] ~= nil) and (db.spells[sKey].sound ~= nil) then
										return db.spells[sKey].sound
									end
									return "None"
								end,
								set = function(info, value)
									local sKey = info[3]
									if (db.spells[sKey] ~= nil) then
										db.spells[sKey].sound = value
										PlaySoundFile(value)
									else
										db.spells[sKey] = { sound = value }
										PlaySoundFile(value)
									end
								end,
								order = 40,
								values = soundslist,
							},
						},
					}
				end
			end
		end
		
		for spellkey,spell in pairs(db.spells) do
			if (spell.ptype ~= nil) and (spell.ptype == "custom") then
				options.args.customprocs.args[spellkey] = {
					type = 'group',
					name = spell.name or spellkey,
					desc = spell.name or spellkey,
					order = 5,
					arg = tostring(spellkey),
					args = spellCustomOptions,
				}
			end
			
			if (spell.ptype ~= nil) and (spell.ptype == "customcombatlog") then
				options.args.customprocs.args[spellkey] = {
					type = 'group',
					name = spell.name or spellkey,
					desc = spell.name or spellkey,
					order = 5,
					arg = tostring(spellkey),
					args = spellCLCustomOptions,
				}
			end
		end
		
		for spellkey,spell in pairs(db.cooldowns) do
			options.args.cooldownProcs.args[spellkey] = {
				type = 'group',
				name = spell.name or spellkey,
				desc = spell.name or spellkey,
				order = 5,
				arg = tostring(spellkey),
				args = spellCoolDownCustomOptions,
			}
		end
		
		
		return options
	end
end