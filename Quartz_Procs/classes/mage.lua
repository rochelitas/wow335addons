local _, cClass = UnitClass("player")
if (cClass ~= "MAGE") then return end

local Quartz3 = LibStub("AceAddon-3.0"):GetAddon("Quartz3")
if not Quartz3 then error("Quartz3 not found!"); return end

local QuartzProcs = Quartz3:GetModule("Procs")
if not QuartzProcs then return end

function QuartzProcs:returnProcList()
	local tmplist = {
		-- Impact
		[string.lower(GetSpellInfo(64343))] = { color={1,0.5,0}, name=GetSpellInfo(64343), },
		-- Hot Streak
		[string.lower(GetSpellInfo(48108))] = { color={1,0,0}, name=GetSpellInfo(48108), },
		-- FireStarter
		[string.lower(GetSpellInfo(54741))] = { color={1,0,0.5}, name=GetSpellInfo(54741), },
		-- Blazing Speed
		[string.lower(GetSpellInfo(31643))] = { color={0,1,0}, name=GetSpellInfo(31643), },
		-- Arcane Power
		[string.lower(GetSpellInfo(12042))] = { color={0.25,0.5,75}, name=GetSpellInfo(12042), },
		-- Missile Barrage
		[string.lower(GetSpellInfo(44401))] = { color={1,0,0.5}, name=GetSpellInfo(44401), },
		-- Icy Veins
		[string.lower(GetSpellInfo(12472))] = { color={0.27,0.51,0.71}, name=GetSpellInfo(12472), },
		-- Fingers of Frost
		[string.lower(GetSpellInfo(44544))] = { color={0,0,1}, name=GetSpellInfo(44544), },
		-- Ice Barrier
		[string.lower(GetSpellInfo(43038))] = { color={0,0,1}, name=GetSpellInfo(43038), },
		-- Ice Block
		[string.lower(GetSpellInfo(45438))] = { color={0,0,0.5}, name=GetSpellInfo(45438), },
		-- Invisibility
		[string.lower(GetSpellInfo(32612))] = { color={0.39,0.58,0.93}, name=GetSpellInfo(32612), },
		-- Brain Freeze (Fireball!) ~instant cast fireball~
		[string.lower(GetSpellInfo(57761))] = { color={0.95,0.1,0.2}, name=GetSpellInfo(57761), },
		-- Combustion
		[string.lower(GetSpellInfo(28682))] = { color={1,0.5,0}, name=GetSpellInfo(28682), },
		
		-- All keys {the ["#####"]) will have to be the spellID, cant be the names like above
		combatlog = {
			["55342"] = { name=GetSpellInfo(55342), color={0,0.5,1}, dur=30, }, -- Mirror Image
			["36032"] = { name=GetSpellInfo(36032), color={0,0,1}, dur=6, }, -- Arcane Blast (debuff)
			["41425"] = { name=GetSpellInfo(41425), color={1,0,0}, dur=30, }, -- Hypothermia
		},
	}
	return tmplist
end