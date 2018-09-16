local _, cClass = UnitClass("player")
if (cClass ~= "DEATHKNIGHT") then return end

local Quartz3 = LibStub("AceAddon-3.0"):GetAddon("Quartz3")
if not Quartz3 then error("Quartz3 not found!"); return end

local QuartzProcs = Quartz3:GetModule("Procs")
if not QuartzProcs then return end

function QuartzProcs:returnProcList()
	local tmplist = {
		-- Killing Machine
		[string.lower(GetSpellInfo(51124))] = { color={1,0,0}, name=GetSpellInfo(51124), },
		-- Freezing Fog
		[string.lower(GetSpellInfo(59052))] = { color={0,0,1}, name=GetSpellInfo(59052), },
		-- IceBound Fortitude
		[string.lower(GetSpellInfo(48792))] = { color={0,0.5,1}, name=GetSpellInfo(48792), },
		-- Deathchill
		[string.lower(GetSpellInfo(49796))] = { color={0,0,1}, name=GetSpellInfo(49796), },
		-- Anti-Magic Shell
		[string.lower(GetSpellInfo(48707))] = { color={0,1,0}, name=GetSpellInfo(48707), },
	}
	return tmplist
end