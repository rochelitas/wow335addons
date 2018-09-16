local _, cClass = UnitClass("player")
if (cClass ~= "PALADIN") then return end

local Quartz3 = LibStub("AceAddon-3.0"):GetAddon("Quartz3")
if not Quartz3 then error("Quartz3 not found!"); return end

local QuartzProcs = Quartz3:GetModule("Procs")
if not QuartzProcs then return end

function QuartzProcs:returnProcList()
	local tmplist = {
		-- Art of War
		[string.lower(GetSpellInfo(59578))] = { color={1,0.5,0}, name=GetSpellInfo(59578), },
		-- Divine Plea
		[string.lower(GetSpellInfo(54428))] = { color={0,0,1}, name=GetSpellInfo(54428), },
		-- Divine Shield
		[string.lower(GetSpellInfo(642))]   = { color={1,0.5,1}, name=GetSpellInfo(642), },
		-- Divine Protection 244;164;96
		[string.lower(GetSpellInfo(498))]   = { color={0.97,0.65,0.38}, name=GetSpellInfo(498), },
		-- Divine Sacrifice 238;173;14
		[string.lower(GetSpellInfo(64205))] = { color={0.93,0.68,0.05}, name=GetSpellInfo(64205), },
		-- Infusion of Light
		[string.lower(GetSpellInfo(54149))] = { color={1,0.5,0}, name=GetSpellInfo(54149), },
		-- Avenging Wrath
		[string.lower(GetSpellInfo(31884))] = { color={1,0.5,0}, name=GetSpellInfo(31884), },
		-- Sacred Shield (self)
		["58597"] = {
			name=GetSpellInfo(58597), color={0.93,0.98,0.51} --, spellid=58597,
		},
		
		combatlog = {
			-- Sacred Shield (target)
			["53601"] = {
				name=GetSpellInfo(53601) .. " (target)", color={0.73,0.55,0.55}, dur=30, cast=true,
			},
			-- Ardent Defender (debuff)
			["66233"] = {
				name=GetSpellInfo(66233), color={1,0,0}, dur=120,
			},
			-- Forbearance (debuff)
			["25771"] = {
				name=GetSpellInfo(25771), color={1,0,0}, dur=120,
			},
		},
	}
	return tmplist
end