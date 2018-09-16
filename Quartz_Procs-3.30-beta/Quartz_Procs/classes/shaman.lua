local _, cClass = UnitClass("player")
if (cClass ~= "SHAMAN") then return end

local Quartz3 = LibStub("AceAddon-3.0"):GetAddon("Quartz3")
if not Quartz3 then error("Quartz3 not found!"); return end

local QuartzProcs = Quartz3:GetModule("Procs")
if not QuartzProcs then return end

function QuartzProcs:returnProcList()
	local tmplist = {
		-- Maelstrom Weapon
		[string.lower(GetSpellInfo(53817))] = { color={0,0.5,1}, name=GetSpellInfo(53817), },
		-- Clearcasting
		[string.lower(GetSpellInfo(16246))] = { color={0,0,1}, name=GetSpellInfo(16246), },
		-- Elemental Mastery
		[string.lower(GetSpellInfo(64701))] = { color={0,0,1}, name=GetSpellInfo(64701), },
		-- Tidal Waves
		[string.lower(GetSpellInfo(53390))] = { color={0.25,0.5,0.75}, name=GetSpellInfo(53390), },
		-- Tidal Force
		[string.lower(GetSpellInfo(55198))] = { color={0,0,1}, name=GetSpellInfo(55198), },
	}
	return tmplist
end