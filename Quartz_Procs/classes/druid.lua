local _, cClass = UnitClass("player")
if (cClass ~= "DRUID") then return end

local Quartz3 = LibStub("AceAddon-3.0"):GetAddon("Quartz3")
if not Quartz3 then error("Quartz3 not found!"); return end

local QuartzProcs = Quartz3:GetModule("Procs")
if not QuartzProcs then return end

function QuartzProcs:returnProcList()
	local tmplist = {
		["48517"] = { -- Eclipse (Solar)  ((Wrath Eclipse))
			name = GetSpellInfo(48517),
			color={1,0.5,0}, spellid=48517, cooldown=30,
		}, 
		["48518"] = { -- Eclipse (Lunar)  ((Starfire Eclipse))
			name = GetSpellInfo(48518),
			color={0,0.5,1}, spellid=48518, cooldown=30,
		}, 
		
		-- Barkskin
		[string.lower(GetSpellInfo(22812))] = { color={0,1,0}, name=GetSpellInfo(22812), },
		-- Innervate
		[string.lower(GetSpellInfo(29166))] = { color={0,0,1}, name=GetSpellInfo(29166), },
		-- Berserk
		["50334"] = { name=GetSpellInfo(50334), color={1,0,0}, },
		-- Tiger's Fury
		[string.lower(GetSpellInfo(50213))] = { color={1,0,0}, name=GetSpellInfo(50213), },
		-- Cat Dash
		[string.lower(GetSpellInfo(33357))] = { color={0,1,0}, name=GetSpellInfo(33357), },
		-- Owklin Frenzy
		[string.lower(GetSpellInfo(48391))] = { color={0.7, 0.1, 0.1}, name=GetSpellInfo(48391), },
		-- StarFall
		[string.lower(GetSpellInfo(53198))] = { color={0.125, 0.698, 0.686}, name=GetSpellInfo(53198), },
		-- Enrage
		[string.lower(GetSpellInfo(5229))]  = { color={1,0,0}, name=GetSpellInfo(5229), },
		-- Frenzied Regen
		[string.lower(GetSpellInfo(22842))] = { color={0,1,0}, name=GetSpellInfo(22842), },
		-- Survival Instincts
		[string.lower(GetSpellInfo(61336))] = { color={1,0,0}, name=GetSpellInfo(61336), },
		-- Clearcasting (From Omen of Clarity)
		[string.lower(GetSpellInfo(16870))] = { color={0,0,1}, name=GetSpellInfo(16870), },
		-- Savage Roar
		[string.lower(GetSpellInfo(52610))] = { color={1, 0.5, 0}, name=GetSpellInfo(52610), },
		-- Predator's Swiftness (instant cast nature spell)
		[string.lower(GetSpellInfo(69369))] = { color={0.47, 1, 0.298}, name=GetSpellInfo(69369), },
		
		combatlog = {
			--187,140,139
			--6/6 20:19:31.949  SPELL_CAST_SUCCESS,0x01000000000C45F8,"Meeka",0x511,0x0000000000000000,nil,0x80000000,33831,"Force of Nature",0x8
			["33831"] = { name=GetSpellInfo(33831), color={0.73,0.55,0.55}, dur=30, cast=true, }, -- Force of Nature
		},
	}
	return tmplist
end
