local _, cClass = UnitClass("player")
if (cClass ~= "PRIEST") then return end

local Quartz3 = LibStub("AceAddon-3.0"):GetAddon("Quartz3")
if not Quartz3 then error("Quartz3 not found!"); return end

local QuartzProcs = Quartz3:GetModule("Procs")
if not QuartzProcs then return end

function QuartzProcs:returnProcList()
	local tmplist = {
		-- Surge of Light
		[string.lower(GetSpellInfo(33154))] = { color={0.93,0.98,0.51}, name=GetSpellInfo(33154), },
		-- Pain Suppression
		[string.lower(GetSpellInfo(33206))] = { color={0,0.5,1}, name=GetSpellInfo(33206), },
		-- Power Infusion
		[string.lower(GetSpellInfo(10060))] = { color={1,0.5,0}, name=GetSpellInfo(10060), },
		-- Spirit Tap
		[string.lower(GetSpellInfo(59000))] = { color={1,0,0.5}, name=GetSpellInfo(59000), },
		-- Borrowed Time
		[string.lower(GetSpellInfo(59891))] = { color={1,0.5,0}, name=GetSpellInfo(59891), },
		-- Renewed Hope
		[string.lower(GetSpellInfo(63944))] = { color={0.93,0.98,0.51}, name=GetSpellInfo(63944), },
		-- Serendipity
		[string.lower(GetSpellInfo(63734))] = { color={0,0,1}, maxc=3, name=GetSpellInfo(63734), },
		-- Inner Fire
		[string.lower(GetSpellInfo(48168))] = { color={0.4,0.4,0}, name=GetSpellInfo(48168), },
		-- Inner Focus
		[string.lower(GetSpellInfo(14751))] = { color={0,0,1}, name=GetSpellInfo(14751), },
		-- Shadow Weaving
		[string.lower(GetSpellInfo(15332))] = { color={1,0,0.5}, name=GetSpellInfo(15332), },
	}
	return tmplist
end