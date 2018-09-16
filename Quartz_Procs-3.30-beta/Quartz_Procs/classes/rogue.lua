local _, cClass = UnitClass("player")
if (cClass ~= "ROGUE") then return end

local Quartz3 = LibStub("AceAddon-3.0"):GetAddon("Quartz3")
if not Quartz3 then error("Quartz3 not found!"); return end

local QuartzProcs = Quartz3:GetModule("Procs")
if not QuartzProcs then return end

function QuartzProcs:returnProcList()
	local tmplist = {
		-- Hunger for Blood
		[string.lower(GetSpellInfo(63848))] = { color={1,0,0}, name=GetSpellInfo(63848), },
		-- Sprint
		[string.lower(GetSpellInfo(11305))] = { color={0,1,0}, name=GetSpellInfo(11305), },
		-- Adrenline Rush
		[string.lower(GetSpellInfo(13750))] = { color={0.7,0.1,0.1}, name=GetSpellInfo(13750), },
		-- Blade Flurry
		[string.lower(GetSpellInfo(13877))] = { color={1,0.5,0}, name=GetSpellInfo(13877), },
		-- Cloak of Shadows
		[string.lower(GetSpellInfo(31224))] = { color={1,0,0.5}, name=GetSpellInfo(31224), },
		-- Evasion
		[string.lower(GetSpellInfo(26669))] = { color={0.93,0.98,0.51}, name=GetSpellInfo(26669), },
		-- Vanish
		[string.lower(GetSpellInfo(26888))] = { color={0.28,0.24,0.55}, name=GetSpellInfo(26888), },
		-- Killing Spree
		[string.lower(GetSpellInfo(51690))] = { color={0.7,0.1,0.1}, name=GetSpellInfo(51690), },
		-- Slice and Dice
		[string.lower(GetSpellInfo(6774))]  = { color={1,0.5,0}, name=GetSpellInfo(6774), },
		-- Shadow Dance
		[string.lower(GetSpellInfo(51713))] = { color={0.7,0.1,0.1}, name=GetSpellInfo(51713), },
		-- Feint (aoe reduction buff)
		[string.lower(GetSpellInfo(48659))] = { color={0.4,0.4,1}, name=GetSpellInfo(48659), },
		-- Envenom
		[string.lower(GetSpellInfo(57993))] = { color={0,1,0}, name=GetSpellInfo(57993), },
	}
	return tmplist
end
