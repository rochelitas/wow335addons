local _, cClass = UnitClass("player")
if (cClass ~= "HUNTER") then return end

local Quartz3 = LibStub("AceAddon-3.0"):GetAddon("Quartz3")
if not Quartz3 then error("Quartz3 not found!"); return end

local QuartzProcs = Quartz3:GetModule("Procs")
if not QuartzProcs then return end

function QuartzProcs:returnProcList()
	local tmplist = {
		-- Lock and Load
		[string.lower(GetSpellInfo(56453))] = { color={0,0.5,1}, cooldown=22, name=GetSpellInfo(56453), },
		-- Rapid Killing
		[string.lower(GetSpellInfo(35099))] = { color={1,0,0.5}, name=GetSpellInfo(35099), },
		-- Rapid Fire
		[string.lower(GetSpellInfo(3045))]  = { color={0.7,0.1,0.1}, name=GetSpellInfo(3045), },
		-- The Beast Within
		[string.lower(GetSpellInfo(34692))] = { color={0,0,1}, name=GetSpellInfo(34692), },
		-- Deterrance
		[string.lower(GetSpellInfo(19263))] = { color={0.93,0.98,0.51}, name=GetSpellInfo(19263), },
		-- Sniper Training
		[string.lower(GetSpellInfo(64418))] = { color={1,0.5,0}, name=GetSpellInfo(64418), },
		-- Misidirection (self)
		[string.lower(GetSpellInfo(34477))] = { color={0.40,0.80,1}, name=GetSpellInfo(34477), },
	}
	return tmplist
end