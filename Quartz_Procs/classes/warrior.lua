local _, cClass = UnitClass("player")
if (cClass ~= "WARRIOR") then return end

local Quartz3 = LibStub("AceAddon-3.0"):GetAddon("Quartz3")
if not Quartz3 then error("Quartz3 not found!"); return end

local QuartzProcs = Quartz3:GetModule("Procs")
if not QuartzProcs then return end

function QuartzProcs:returnProcList()
	local tmplist = {
		-- Sudden Death
		[string.lower(GetSpellInfo(52437))] = { color={0.7,0.1,0.1}, name=GetSpellInfo(52437), },
		-- Taste for Blood
		[string.lower(GetSpellInfo(60503))] = { color={1,0.5,0}, name=GetSpellInfo(60503), },
		-- Bladestorm
		[string.lower(GetSpellInfo(46924))] = { color={0.93,0.98,0.51}, name=GetSpellInfo(46924), },
		-- Shield Wall
		[string.lower(GetSpellInfo(871))]   = { color={0.7,0.1,0.1}, name=GetSpellInfo(871), },
		-- Last Stand
		[string.lower(GetSpellInfo(12975))] = { color={0.8,0.2,0.1}, name=GetSpellInfo(12975), },
		-- Slam! (triggered by Bloodsurge)
		[string.lower(GetSpellInfo(46916))] = { color={1,0,0.5}, name=GetSpellInfo(46916), },
		-- Sword and Board
		[string.lower(GetSpellInfo(50227))] = { color={0,0,1}, name=GetSpellInfo(50227), },
	}
	return tmplist
end