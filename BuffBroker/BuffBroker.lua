-- Global instance of the mod
-- *AceConsole included for :Print
BuffBroker = LibStub('AceAddon-3.0'):NewAddon('BuffBroker', 'AceConsole-3.0', 'AceEvent-3.0')

local AceConfig = LibStub('AceConfig-3.0')
local AceConfigDialog = LibStub('AceConfigDialog-3.0')
local AceDB = LibStub('AceDB-3.0')

-- load localization strings
local L = LibStub('AceLocale-3.0'):GetLocale('BuffBroker')

-- load global strings
_G["BINDING_HEADER_BUFFBROKER_HEADER"] = 'Buff Broker'
_G["BINDING_NAME_CLICK BuffBroker_CastSuggestionButton:LeftButton"] = 'Cast the Next Suggested Enhancement'

-- optional deps
local LBF = LibStub('LibButtonFacade', true)

local profileDB -- Initialized in :OnInitialize()

BuffBroker.PrintDebug = false
BuffBroker.ActivityFrame = nil
BuffBroker.FailCodes = {}

BuffBroker.InCombat = nil
BuffBroker.Idle = nil

BuffBroker.TalentGroup = 1

BuffList = {}

BuffList.InspectOutstanding = nil
BuffList.InspectBusy = nil
BuffList.InspectTarget = nil
BuffList.InspectPending = nil
BuffList.InspectComplete = nil
BuffList.InspectLastChecked = nil
BuffList.InspectIdleWait = 5
BuffList.InspectTimeout = 15
BuffList.BusyWarningTimeout = 120
BuffList.Suggestions = {}
BuffList.LastSuggested = nil

BuffList.TooltipPrime = L["Loading..."]
BuffList.TooltipDetail = L["Buff Broker is starting up"]
BuffList.TooltipMinor = ''
BuffList.tooltipFormatter = ''

BuffList.AurasFirstChangedAt = nil
BuffList.AurasLastChangedAt = nil

BuffList.LastCheckedRange = nil
BuffList.RangeCheckDelay = 5

BuffList.StalePlayers = {}

BuffList.PlayerGUID = nil
BuffList.Players = {}
BuffList.PlayerCount = 0
BuffList.ProfiledBuffProviders = nil

BuffList.Classes = {}

BuffList.Coverage = {}

BuffBroker.Constants = {
	SpecSpells = {
		Primary = true,
		Secondary = true,
	},
	TalentGroup = {
		None = -1, -- character doesn't have dual spec
		Unknown = 0, -- character hasn't been scanned yet
		Primary = 1, -- primary spec active
		Secondary = 2, -- secondary spec active
	},
		
	Confidence = {
		Certain = 5, -- can provide best (as can others), all others committed
		Likely = 4, -- can provide best (as can others), no coverage
		Possible = 3, -- can provide best, slot coverage
		Optional = 2, -- can't provide best, no slot coverage
		Unlikely = 1, -- player coverage (not us); or can't provide best, slot coverage
		None = 0,
	},
	Types = {
		Player = 0,
		WorldObject = 1,
		NPC = 3, -- includes temporary pets/guardians
		CombatPet = 4,
		Vehicle = 5,
		
	},
	Classes = {
		Warrior = "WARRIOR",
		Deathknight = "DEATHKNIGHT",
		Paladin = "PALADIN",
		Shaman = "SHAMAN",
		Hunter = "HUNTER",
		Rogue = "ROGUE",
		Druid = "DRUID",
		Warlock = "WARLOCK",
		Priest = "PRIEST",
		Mage = "MAGE",
		Raid = "RAID",
	},
	Roles = {
		None = "No Role",
		Unknown = "Unknown Role",
		Tank = "Tank",
		PureMelee = "Melee DPS",
		MeleeMana = "Melee DPS (mana user)",
		Caster = "Caster",
		MeleeMana_Low = "Low level Melee DPS (mana user)",
		Healer = "Healer",
	},
	Totems = {
		["FIRE_TOTEMS"] = 133,
		["EARTH_TOTEMS"] = 134,
		["WATER_TOTEMS"] = 135,
		["AIR_TOTEMS"] = 136,
	},
	Buffed = {
		None,
		Partial,
		Full
	},
	-- TODO:  Figure out a better name for this, i.e. 'How improved this buff is'
	Buffs = {
		None = 1, -- can't provide
		ProfessionStats = 2, -- Leatherworking Kings
		Basic = 3, -- class inherent (shaman/warrior)
		BasicLong = 4, -- class inherent (paladin): wisdom, might, kings, sanctuary
		MinorTalented = 5, -- partial talent investment, warrior (1,2 /5), shaman (1/3)
		PartialTalented = 6, -- partial talent investment, druid (1/2), priest (1/2)
		PartialTalentedLong = 7, -- partial talent investment, paladin (1/2)
		MajorTalented = 8, -- partial talent investment, warrior (3,4 /5), shaman (2/3)
		FullTalented = 8, -- 3/3 shaman totems, 5/5 warrior shouts, druid (2/2), priest (2/2)
		FullTalentedLong = 9, -- 2/2 paladin wisdom, 2/2 Paladin might
		Awesome = 10, -- way better than anything we could do
	},
	Scope = {
		Individual = 1,
		Class = 2,
		Raid = 3,
		Self = 4,
	},
	MaxBuffSlots = 40,
	MaxPlayers = 40,
}

BuffBroker.Constants.Forms = { -- warrior stances are dum-dums for now, until blizzard makes them an aura, OR, forms are checked on spellcast instead of aura scan (which is cludgy)
		[71] = BuffBroker.Constants.Roles.Tank, -- defensive stance
		[2457] = BuffBroker.Constants.Roles.PureMelee, -- battle stance
		[2458] = BuffBroker.Constants.Roles.PureMelee, -- Berserker stance
		[25780] = BuffBroker.Constants.Roles.Tank, -- righteous fury
		[48263] = BuffBroker.Constants.Roles.Tank, -- frost presence
		[48265] = BuffBroker.Constants.Roles.PureMelee, -- unholy presence
		[48266] = BuffBroker.Constants.Roles.PureMelee, -- blood presence
		[5487] = BuffBroker.Constants.Roles.Tank, -- Bear Form
		[9634] = BuffBroker.Constants.Roles.Tank, -- Dire Bear Form
		[768] = BuffBroker.Constants.Roles.PureMelee, -- Cat Form
}

BuffBroker.Constants.BuffSlots = {
	["BLESSINGS_BASIC"] = {
		[19742] = {Score = BuffBroker.Constants.Buffs.BasicLong, Target = true, MinLevel = 14, Scope = BuffBroker.Constants.Scope.Individual}, -- wisdom
		[25894] = {Score = BuffBroker.Constants.Buffs.BasicLong, Target = true, MinLevel = 54, Scope = BuffBroker.Constants.Scope.Class}, -- greater wisdom
		[19740] = {Score = BuffBroker.Constants.Buffs.BasicLong, Target = true, MinLevel = 4, Scope = BuffBroker.Constants.Scope.Individual}, -- might
		[25782] = {Score = BuffBroker.Constants.Buffs.BasicLong, Target = true, MinLevel = 52, Scope = BuffBroker.Constants.Scope.Class}, -- greater might
		[20217] = {Score = BuffBroker.Constants.Buffs.BasicLong, Target = true, MinLevel = 20, Scope = BuffBroker.Constants.Scope.Individual}, -- kings
		[25898] = {Score = BuffBroker.Constants.Buffs.BasicLong, Target = true, MinLevel = 60, Scope = BuffBroker.Constants.Scope.Class}, -- greater kings
	},
	["BLESSINGS"] = {
		[19742] = {Score = BuffBroker.Constants.Buffs.BasicLong, Target = true, MinLevel = 14, Scope = BuffBroker.Constants.Scope.Individual}, -- wisdom
		[25894] = {Score = BuffBroker.Constants.Buffs.BasicLong, Target = true, MinLevel = 54, Scope = BuffBroker.Constants.Scope.Class}, -- greater wisdom
		[19740] = {Score = BuffBroker.Constants.Buffs.BasicLong, Target = true, MinLevel = 4, Scope = BuffBroker.Constants.Scope.Individual}, -- might
		[25782] = {Score = BuffBroker.Constants.Buffs.BasicLong, Target = true, MinLevel = 52, Scope = BuffBroker.Constants.Scope.Class}, -- greater might
		[20217] = {Score = BuffBroker.Constants.Buffs.BasicLong, Target = true, MinLevel = 20, Scope = BuffBroker.Constants.Scope.Individual}, -- kings
		[25898] = {Score = BuffBroker.Constants.Buffs.BasicLong, Target = true, MinLevel = 60, Scope = BuffBroker.Constants.Scope.Class}, -- greater kings
		[20911] = {Score = BuffBroker.Constants.Buffs.BasicLong, Target = true, MinLevel = 30, Scope = BuffBroker.Constants.Scope.Individual}, -- sanctuary
		[25899] = {Score = BuffBroker.Constants.Buffs.BasicLong, Target = true, MinLevel = 60, Scope = BuffBroker.Constants.Scope.Class}, -- greater sanctuary
	},
	["SEALS"] = {
		[53736] = {Score = BuffBroker.Constants.Buffs.Basic, Target = true, MinLevel = 66, Scope = BuffBroker.Constants.Scope.Self}, -- seal of corruption
		[20164] = {Score = BuffBroker.Constants.Buffs.Basic, Target = true, MinLevel = 22, Scope = BuffBroker.Constants.Scope.Self}, -- seal of justice
		[20165] = {Score = BuffBroker.Constants.Buffs.Basic, Target = true, MinLevel = 30, Scope = BuffBroker.Constants.Scope.Self}, -- seal of light
		[21084] = {Score = BuffBroker.Constants.Buffs.Basic, Target = true, MinLevel = 1, Scope = BuffBroker.Constants.Scope.Self}, -- seal of righteousness
		[31801] = {Score = BuffBroker.Constants.Buffs.Basic, Target = true, MinLevel = 64, Scope = BuffBroker.Constants.Scope.Self}, -- seal of vengeance
		[20166] = {Score = BuffBroker.Constants.Buffs.Basic, Target = true, MinLevel = 38, Scope = BuffBroker.Constants.Scope.Self}, -- seal of wisdom
		[20375] = {Score = BuffBroker.Constants.Buffs.Basic, Target = true, MinLevel = 20, Scope = BuffBroker.Constants.Scope.Self}, -- seal of command
	},
	["SHOUTS"] = {
		[469] = {Score = BuffBroker.Constants.Buffs.Basic, Target = false, MinLevel = 68, Scope = BuffBroker.Constants.Scope.Raid}, -- commanding
		[6673] = {Score = BuffBroker.Constants.Buffs.Basic, Target = false, MinLevel = 1, Scope = BuffBroker.Constants.Scope.Raid}, -- battle
	},
	["ICY_TALONS"] = {
		[55610] = {Score = BuffBroker.Constants.Buffs.Basic, Target = false, MinLevel = 36, Scope = BuffBroker.Constants.Scope.Raid}, -- improved icy talons
	},
	["HORNS"] = {
		[57330] = {Score = BuffBroker.Constants.Buffs.Basic, Target = false, MinLevel = 65, Scope = BuffBroker.Constants.Scope.Raid}, -- horn of winter
	},
	["WATER_TOTEMS"] = {
		[5677] = {Score = BuffBroker.Constants.Buffs.Basic, Target = false, MinLevel = 26, Scope = BuffBroker.Constants.Scope.Raid}, -- mana spring
		[5672] = {Score = BuffBroker.Constants.Buffs.Basic, Target = false, MinLevel = 20, Scope = BuffBroker.Constants.Scope.Raid}, -- healing stream
	},
	["EARTH_TOTEMS"] = {
		[8072] = {Score = BuffBroker.Constants.Buffs.Basic, Target = false, MinLevel = 4, Scope = BuffBroker.Constants.Scope.Raid}, -- stoneskin
		[8076] = {Score = BuffBroker.Constants.Buffs.Basic, Target = false, MinLevel = 10, Scope = BuffBroker.Constants.Scope.Raid}, -- strength of earth
	},
	["FIRE_TOTEMS_BASIC"] = {
		[52109] = {Score = BuffBroker.Constants.Buffs.Basic, Target = false, MinLevel = 28, Scope = BuffBroker.Constants.Scope.Raid}, -- flametongue
		[3599] = {Score = BuffBroker.Constants.Buffs.Basic, Target = false, MinLevel = 10, Scope = BuffBroker.Constants.Scope.Raid}, -- searing totem
	},
	["FIRE_TOTEMS"] = {
		[52109] = {Score = BuffBroker.Constants.Buffs.Basic, Target = false, MinLevel = 28, Scope = BuffBroker.Constants.Scope.Raid}, -- flametongue
		[3599] = {Score = BuffBroker.Constants.Buffs.Basic, Target = false, MinLevel = 10, Scope = BuffBroker.Constants.Scope.Raid}, -- searing totem
		[57658] = {Score = BuffBroker.Constants.Buffs.Basic, Target = false, MinLevel = 50, Scope = BuffBroker.Constants.Scope.Raid}, -- wrath
	},
	["AIR_TOTEMS"] = {
		[8515] = {Score = BuffBroker.Constants.Buffs.Basic, Target = false, MinLevel = 32, Scope = BuffBroker.Constants.Scope.Raid}, -- windfury
		[2895] = {Score = BuffBroker.Constants.Buffs.Basic, Target = false, MinLevel = 64, Scope = BuffBroker.Constants.Scope.Raid}, -- wrath of air
	},
	["FORTITUDE"] = {
		[1243] = {Score = BuffBroker.Constants.Buffs.Basic, Target = true, MinLevel = 1, Scope = BuffBroker.Constants.Scope.Individual}, -- Power Word: Fortitude 8
		[21562] = {Score = BuffBroker.Constants.Buffs.Basic, Target = true, MinLevel = 48, Scope = BuffBroker.Constants.Scope.Raid}, -- Prayer of Fortitude 4
	},
	["AI"] = {
		[61024] = {Score = BuffBroker.Constants.Buffs.Basic, Target = true, MinLevel = 80, Scope = BuffBroker.Constants.Scope.Individual}, -- Dalaran Intellect
		[61316] = {Score = BuffBroker.Constants.Buffs.Basic, Target = true, MinLevel = 80, Scope = BuffBroker.Constants.Scope.Raid}, -- Dalaran Brilliance
		[1459] = {Score = BuffBroker.Constants.Buffs.Basic, Target = true, MinLevel = 1, Scope = BuffBroker.Constants.Scope.Individual}, -- Arcane Intellect 7 
		[23028] = {Score = BuffBroker.Constants.Buffs.Basic, Target = true, MinLevel = 56, Scope = BuffBroker.Constants.Scope.Raid}, -- Arcane Brilliance 3
	},
	["WILD"] = {
		[1126] = {Score = BuffBroker.Constants.Buffs.Basic, Target = true, MinLevel = 1, Scope = BuffBroker.Constants.Scope.Individual}, -- Mark of the Wild 9
		[21849] = {Score = BuffBroker.Constants.Buffs.Basic, Target = true, MinLevel = 50, Scope = BuffBroker.Constants.Scope.Raid}, -- Gift of the Wild 4
	},
	["THORNS"] = {
		[467] = {Score = BuffBroker.Constants.Buffs.Basic, Target = true, MinLevel = 6, Scope = BuffBroker.Constants.Scope.Individual}, -- Thorns 8
	},
	["SPIRIT"] = {
		[14752] = {Score = BuffBroker.Constants.Buffs.Basic, Target = true, MinLevel = 30, Scope = BuffBroker.Constants.Scope.Individual}, -- Divine Spirit 6
		[27681] = {Score = BuffBroker.Constants.Buffs.Basic, Target = true, MinLevel = 60, Scope = BuffBroker.Constants.Scope.Raid}, -- Prayer of Spirit 3
	},
	["PRIEST_INNER"] = {
		[588] = {Score = BuffBroker.Constants.Buffs.Basic, Target = true, MinLevel = 12, Scope = BuffBroker.Constants.Scope.Self}, -- Inner Fire
	},
	["PRIEST_PROTECTION"] = {
		[976] = {Score = BuffBroker.Constants.Buffs.Basic, Target = true, MinLevel = 30, Scope = BuffBroker.Constants.Scope.Individual}, -- Shadow Protection
		[27683] = {Score = BuffBroker.Constants.Buffs.Basic, Target = true, MinLevel = 56, Scope = BuffBroker.Constants.Scope.Raid}, -- Prayer of Shadow Protection
	},
	["EMBRACE"] = {
		[15286] = {Score = BuffBroker.Constants.Buffs.Basic, Target = true, MinLevel = 30, Scope = BuffBroker.Constants.Scope.Self}, -- Inner Fire
	},
	["MAGE_ARMOR"] = {
		[6117] = {Score = BuffBroker.Constants.Buffs.Basic, Target = true, MinLevel = 64, Scope = BuffBroker.Constants.Scope.Self}, -- Mage Armor
		[168] = {Score = BuffBroker.Constants.Buffs.Basic, Target = true, MinLevel = 1, Scope = BuffBroker.Constants.Scope.Self}, -- Frost Armor
		[7302] = {Score = BuffBroker.Constants.Buffs.Basic, Target = true, MinLevel = 30, Scope = BuffBroker.Constants.Scope.Self}, -- Ice Armor
		[30482] = {Score = BuffBroker.Constants.Buffs.Basic, Target = true, MinLevel = 62, Scope = BuffBroker.Constants.Scope.Self}, -- Molten Armor
	},
	["WARLOCK_ARMOR"] = {
		[687] = {Score = BuffBroker.Constants.Buffs.Basic, Target = true, MinLevel = 1, Scope = BuffBroker.Constants.Scope.Self}, -- Demon Skin
		[706] = {Score = BuffBroker.Constants.Buffs.Basic, Target = true, MinLevel = 20, Scope = BuffBroker.Constants.Scope.Self}, -- Demon Armor
		[28176] = {Score = BuffBroker.Constants.Buffs.Basic, Target = true, MinLevel = 62, Scope = BuffBroker.Constants.Scope.Self}, -- Fel Armor
	},
	["RIGHTEOUS_FURY"] = {
		[25780] = {Score = BuffBroker.Constants.Buffs.Basic, Target = true, MinLevel = 20, Scope = BuffBroker.Constants.Scope.Self}, -- Righteous Fury
	},
	["PRIEST_FORM"] = {
		[15473] = {Score = BuffBroker.Constants.Buffs.Basic, Target = true, MinLevel = 40, Scope = BuffBroker.Constants.Scope.Self}, -- Shadow Form
	},

	["SHAPESHIFT"] = {
		[24858] = {Score = BuffBroker.Constants.Buffs.Basic, Target = true, MinLevel = 40, Scope = BuffBroker.Constants.Scope.Self}, -- Owl Form
		[33891] = {Score = BuffBroker.Constants.Buffs.Basic, Target = true, MinLevel = 50, Scope = BuffBroker.Constants.Scope.Self}, -- Tree Form
	},

	["PROFESSION_STATS"] = {
		[69378] = {Score = BuffBroker.Constants.Buffs.ProfessionStats, Scope = BuffBroker.Constants.Scope.Raid}, -- forgotten kings
	},
}


BuffList.GreaterLookup = {
	["BLESSINGS"] = {
		[20217] = 25898, -- Kings
		[20911] = 25899, -- Sanctuary
		[19838] = 25782, -- Might 1
		[25291] = 25916, -- Might 2
		[27140] = 27141, -- Might 3
		[48931] = 48933, -- Might 4
		[48932] = 48934, -- Might 5
		[19854] = 25894, -- Wisdom 1
		[25290] = 25918, -- Wisdom 2
		[27142] = 27143, -- Wisdom 3
		[48935] = 48937, -- Wisdom 4
		[48936] = 48938, -- Wisdom 5
	},
	["FORTITUDE"] = {
		[10937] = 21562, -- Prayer of Fortitude 1
		[10938] = 21564, -- Prayer of Fortitude 2
		[25389] = 25392, -- Prayer of Fortitude 3
		[48161] = 48162, -- Prayer of Fortitude 4
	},
	["AI"] = {
		[10157] = 23028, -- Arcane Brilliance 1
		[27126] = 27127, -- Arcane Brilliance 2
		[42995] = 43002, -- Arcane Brilliance 3
	},
	["WILD"] = {
		[9884] = 21849, -- Gift of the Wild 1
		[9885] = 21850, -- Gift of the Wild 2
		[26990] = 26991, -- Gift of the Wild 3
		[48469] = 48470, -- Gift of the Wild 4
	},
	["SPIRIT"] = {
		[27841] = 27681, -- Prayer of Spirit 1
		[25312] = 32999, -- Prayer of Spirit 2
		[48073] = 48074, -- Prayer of Spirit 3
	},
	["PRIEST_PROTECTION"] = {
		[976] = 27683, -- Prayer of Spirit 1
		[25433] = 39374, -- Prayer of Spirit 2
		[48169] = 48170, -- Prayer of Spirit 3
	},
}

-- TODO:  add 'strength';  level is close, but not a perfect guidline (especially with MP5)
BuffList.DownRankLookup = {
	["SHADOW_RESIST"] = {
		[976] = {minspellid=976, worstSpellID,level=30, slot="PRIEST_PROTECTION"},
		[10957] = {minspellid=976, worstSpellID,level=42, slot="PRIEST_PROTECTION"},
		[10958] = {minspellid=976, worstSpellID,level=56, slot="PRIEST_PROTECTION"},
		[27683] = {minspellid=27683, worstSpellID,level=56, slot="PRIEST_PROTECTION"},
		[25433] = {minspellid=976, worstSpellID,level=68, slot="PRIEST_PROTECTION"},
		[39374] = {minspellid=27683, worstSpellID,level=70, slot="PRIEST_PROTECTION"},
		[48169] = {minspellid=976, worstSpellID,level=76, slot="PRIEST_PROTECTION"},
		[48170] = {minspellid=27683, worstSpellID,level=77, slot="PRIEST_PROTECTION"},
	},
	["AP"] = {
		[6673] = {minspellid=6673, worstSpellID,level=1, slot="SHOUTS"},
		[19740] = {minspellid=19740,level=4, slot="BLESSINGS"},
		[5242] = {minspellid=6673,level=12, slot="SHOUTS"},
		[19834] = {minspellid=19740,level=12, slot="BLESSINGS"},
		[6192] = {minspellid=6673,level=22, slot="SHOUTS"},
		[19835] = {minspellid=19740,level=22, slot="BLESSINGS"},
		[11549] = {minspellid=6673,level=32, slot="SHOUTS"},
		[19836] = {minspellid=19740,level=32, slot="BLESSINGS"},
		[11550] = {minspellid=6673,level=42, slot="SHOUTS"},
		[19837] = {minspellid=19740,level=42, slot="BLESSINGS"},
		[11551] = {minspellid=6673,level=52, slot="SHOUTS"},
		[19838] = {minspellid=19740,level=52, slot="BLESSINGS"},
		[25782] = {minspellid=25782,level=52, slot="BLESSINGS"},
		[25289] = {minspellid=6673,level=60, slot="SHOUTS"},
		[25291] = {minspellid=19740,level=60, slot="BLESSINGS"},
		[25916] = {minspellid=25782,level=60, slot="BLESSINGS"},
		[2048] = {minspellid=6673,level=69, slot="SHOUTS"},
		[27140] = {minspellid=19740,level=70, slot="BLESSINGS"},
		[27141] = {minspellid=25782,level=70, slot="BLESSINGS"},
		[48931] = {minspellid=19740,level=73, slot="BLESSINGS"},
		[48933] = {minspellid=25782,level=73, slot="BLESSINGS"},
		[47436] = {minspellid=6673,level=78, slot="SHOUTS"},
		[48932] = {minspellid=19740,level=79, slot="BLESSINGS"},
		[48934] = {minspellid=25782,level=79, slot="BLESSINGS"},
	},
	["MP5"] = {
		[19742] = {minspellid=19742,level=14, slot="BLESSINGS"},
		[19850] = {minspellid=19742,level=24, slot="BLESSINGS"},
		[5677] = {minspellid=5677,level=26, totemspellid=5675, slot="WATER_TOTEMS"},
		[5675] = {minspellid=5675,level=26, slot="WATER_TOTEMS"},
		[19852] = {minspellid=19742,level=34, slot="BLESSINGS"},
		[10491] = {minspellid=5677,level=36, totemspellid=10495, slot="WATER_TOTEMS"},
		[10495] = {minspellid=5675,level=36, slot="WATER_TOTEMS"},
		[19853] = {minspellid=19742,level=44, slot="BLESSINGS"},
		[10493] = {minspellid=5677,level=46, totemspellid=10496, slot="WATER_TOTEMS"},
		[10496] = {minspellid=5675,level=46, slot="WATER_TOTEMS"},
		[19854] = {minspellid=19742,level=54, slot="BLESSINGS"},
		[25894] = {minspellid=25894,level=54, slot="BLESSINGS"},
		[10494] = {minspellid=5677,level=56, totemspellid=10497, slot="WATER_TOTEMS"},
		[10497] = {minspellid=5675,level=56, slot="WATER_TOTEMS"},
		[25290] = {minspellid=19742,level=60, slot="BLESSINGS"},
		[25918] = {minspellid=25894,level=60, slot="BLESSINGS"},
		[25569] = {minspellid=5677,level=65, totemspellid=25570, slot="WATER_TOTEMS"},
		[25570] = {minspellid=5675,level=65, slot="WATER_TOTEMS"},
		[27142] = {minspellid=19742,level=65, slot="BLESSINGS"},
		[27143] = {minspellid=25894,level=65, slot="BLESSINGS"},
		[58775] = {minspellid=5677,level=71, totemspellid=58771, slot="WATER_TOTEMS"},
		[58771] = {minspellid=5675,level=71, slot="WATER_TOTEMS"},
		[48935] = {minspellid=19742,level=71, slot="BLESSINGS"},
		[48937] = {minspellid=5675,level=71, slot="BLESSINGS"},
		[58776] = {minspellid=5675,level=76, totemspellid=58773, slot="WATER_TOTEMS"},
		[58773] = {minspellid=5675,level=76, slot="WATER_TOTEMS"},
		[48936] = {minspellid=5675,level=77, slot="BLESSINGS"},
		[48938] = {minspellid=25894,level=77, slot="BLESSINGS"},
		[58777] = {minspellid=5677,level=80, totemspellid=58774, slot="WATER_TOTEMS"},
		[58774] = {minspellid=5675,level=80, slot="WATER_TOTEMS"},
	},
	["HP5"] = {
		[5672] = {minspellid=5672,level=20, totemspellid=5394, slot="WATER_TOTEMS"},
		[5394] = {minspellid=5394,level=20, slot="WATER_TOTEMS"},
		[6371] = {minspellid=5672,level=30, totemspellid=6375, slot="WATER_TOTEMS"},
		[6375] = {minspellid=5394,level=30, slot="WATER_TOTEMS"},
		[6372] = {minspellid=5672,level=40, totemspellid=6377, slot="WATER_TOTEMS"},
		[6377] = {minspellid=5394,level=40, slot="WATER_TOTEMS"},
		[10460] = {minspellid=5672,level=50, totemspellid=10462, slot="WATER_TOTEMS"},
		[10462] = {minspellid=5394,level=50, slot="WATER_TOTEMS"},
		[10461] = {minspellid=5672,level=60, totemspellid=10463, slot="WATER_TOTEMS"},
		[10463] = {minspellid=5394,level=60, slot="WATER_TOTEMS"},
		[25566] = {minspellid=5672,level=69, totemspellid=25567, slot="WATER_TOTEMS"},
		[25567] = {minspellid=5394,level=69, slot="WATER_TOTEMS"},
		[58763] = {minspellid=5672,level=71, totemspellid=58755, slot="WATER_TOTEMS"},
		[58755] = {minspellid=5394,level=71, slot="WATER_TOTEMS"},
		[58764] = {minspellid=5672,level=76, totemspellid=58756, slot="WATER_TOTEMS"},
		[58756] = {minspellid=5394,level=76, slot="WATER_TOTEMS"},
		[65994] = {minspellid=5672,level=80, totemspellid=58757, slot="WATER_TOTEMS"},
		[58757] = {minspellid=5394,level=80, slot="WATER_TOTEMS"},
	},
	["ARMOR"] = {
		[8072] = {minspellid=8072,level=4, totemspellid=8071, slot="EARTH_TOTEMS"},
		[8071] = {minspellid=8071,level=4, slot="EARTH_TOTEMS"},
		[8156] = {minspellid=8072,level=14, totemspellid=8154, slot="EARTH_TOTEMS"},
		[8154] = {minspellid=8071,level=14, slot="EARTH_TOTEMS"},
		[8157] = {minspellid=8072,level=24, totemspellid=8155, slot="EARTH_TOTEMS"},
		[8155] = {minspellid=8071,level=24, slot="EARTH_TOTEMS"},
		[10403] = {minspellid=8072,level=34, totemspellid=10406, slot="EARTH_TOTEMS"},
		[10406] = {minspellid=8071,level=34, slot="EARTH_TOTEMS"},
		[10404] = {minspellid=8072,level=44, totemspellid=10407, slot="EARTH_TOTEMS"},
		[10407] = {minspellid=8071,level=44, slot="EARTH_TOTEMS"},
		[10405] = {minspellid=8072,level=54, totemspellid=10408, slot="EARTH_TOTEMS"},
		[10408] = {minspellid=8071,level=54, slot="EARTH_TOTEMS"},
		[25506] = {minspellid=8072,level=63, totemspellid=25508, slot="EARTH_TOTEMS"},
		[25508] = {minspellid=8071,level=63, slot="EARTH_TOTEMS"},
		[25507] = {minspellid=8072,level=70, totemspellid=25509, slot="EARTH_TOTEMS"},
		[25509] = {minspellid=8071,level=70, slot="EARTH_TOTEMS"},
		[58752] = {minspellid=8072,level=75, totemspellid=58751, slot="EARTH_TOTEMS"},
		[58751] = {minspellid=8071,level=75, slot="EARTH_TOTEMS"},
		[58754] = {minspellid=8072,level=78, totemspellid=58753, slot="EARTH_TOTEMS"},
		[58753] = {minspellid=8071,level=78, slot="EARTH_TOTEMS"},
	},
	["STRENGTH_AGILITY"] = {
		[8076] = {minspellid=8076,level=10, totemspellid=8075, slot="EARTH_TOTEMS"},
		[8075] = {minspellid=8075,level=10, slot="EARTH_TOTEMS"},
		[8162] = {minspellid=8076,level=24, totemspellid=8160, slot="EARTH_TOTEMS"},
		[8160] = {minspellid=8075,level=24, slot="EARTH_TOTEMS"},
		[8163] = {minspellid=8076,level=38, totemspellid=8161, slot="EARTH_TOTEMS"},
		[8161] = {minspellid=8075,level=38, slot="EARTH_TOTEMS"},
		[10441] = {minspellid=8076,level=52, totemspellid=10442, slot="EARTH_TOTEMS"},
		[10442] = {minspellid=8075,level=52, slot="EARTH_TOTEMS"},
		[25362] = {minspellid=8076,level=60, totemspellid=25361, slot="EARTH_TOTEMS"},
		[25361] = {minspellid=8075,level=60, slot="EARTH_TOTEMS"},
		[25527] = {minspellid=8076,level=65, totemspellid=25528, slot="EARTH_TOTEMS"},
		[25528] = {minspellid=8075,level=65, slot="EARTH_TOTEMS"},
		[57330] = {minspellid=57330,level=65, slot="HORNS"},
		[57621] = {minspellid=8076,level=75, totemspellid=57622, slot="EARTH_TOTEMS"},
		[57622] = {minspellid=8075,level=75, slot="EARTH_TOTEMS"},
		[57623] = {minspellid=57330,level=75, slot="HORNS"},
		[58646] = {minspellid=8076,level=80, totemspellid=58643, slot="EARTH_TOTEMS"},
		[58643] = {minspellid=8075,level=80, slot="EARTH_TOTEMS"},
	},
	["SOLO_FIRE_TOTEM"] = {
		[3599] = {minspellid=3599,level=10, totemspellid=3599, slot="FIRE_TOTEMS"},
		[3599] = {minspellid=3599,level=10, slot="FIRE_TOTEMS"},
		[6363] = {minspellid=3599,level=20, totemspellid=6363, slot="FIRE_TOTEMS"},
		[6363] = {minspellid=3599,level=20, slot="FIRE_TOTEMS"},
		[6364] = {minspellid=3599,level=30, totemspellid=6364, slot="FIRE_TOTEMS"},
		[6364] = {minspellid=3599,level=30, slot="FIRE_TOTEMS"},
		[6365] = {minspellid=3599,level=40, totemspellid=6365, slot="FIRE_TOTEMS"},
		[6365] = {minspellid=3599,level=40, slot="FIRE_TOTEMS"},
		[10437] = {minspellid=3599,level=50, totemspellid=10437, slot="FIRE_TOTEMS"},
		[10437] = {minspellid=3599,level=50, slot="FIRE_TOTEMS"},
		[10438] = {minspellid=3599,level=60, totemspellid=10438, slot="FIRE_TOTEMS"},
		[10438] = {minspellid=3599,level=60, slot="FIRE_TOTEMS"},
		[25533] = {minspellid=3599,level=69, totemspellid=25533, slot="FIRE_TOTEMS"},
		[25533] = {minspellid=3599,level=69, slot="FIRE_TOTEMS"},
		[58699] = {minspellid=3599,level=71, totemspellid=58699, slot="FIRE_TOTEMS"},
		[58699] = {minspellid=3599,level=71, slot="FIRE_TOTEMS"},
		[58703] = {minspellid=3599,level=75, totemspellid=58703, slot="FIRE_TOTEMS"},
		[58703] = {minspellid=3599,level=75, slot="FIRE_TOTEMS"},
		[58704] = {minspellid=3599,level=80, totemspellid=58704, slot="FIRE_TOTEMS"},
		[58704] = {minspellid=3599,level=80, slot="FIRE_TOTEMS"},
	},
	["FLAT_SPELL"] = {
		[52109] = {minspellid=52109,level=28, totemspellid=8227, slot="FIRE_TOTEMS"},
		[8227] = {minspellid=8227,level=28, slot="FIRE_TOTEMS"},
		[52110] = {minspellid=52109,level=38, totemspellid=8249, slot="FIRE_TOTEMS"},
		[8249] = {minspellid=8227,level=38, slot="FIRE_TOTEMS"},
		[52111] = {minspellid=52109,level=48, totemspellid=10526, slot="FIRE_TOTEMS"},
		[10526] = {minspellid=8227,level=48, slot="FIRE_TOTEMS"},
		[52112] = {minspellid=52109,level=58, totemspellid=16387, slot="FIRE_TOTEMS"},
		[16387] = {minspellid=8227,level=58, slot="FIRE_TOTEMS"},
		[52113] = {minspellid=52109,level=67, totemspellid=25557, slot="FIRE_TOTEMS"},
		[25557] = {minspellid=8227,level=67, slot="FIRE_TOTEMS"},
		[58651] = {minspellid=52109,level=71, totemspellid=58649, slot="FIRE_TOTEMS"},
		[58649] = {minspellid=8227,level=71, slot="FIRE_TOTEMS"},
		[58654] = {minspellid=52109,level=75, totemspellid=58652, slot="FIRE_TOTEMS"},
		[58652] = {minspellid=8227,level=75, slot="FIRE_TOTEMS"},
		[58655] = {minspellid=52109,level=80, totemspellid=58656, slot="FIRE_TOTEMS"},
		[58656] = {minspellid=8227,level=80, slot="FIRE_TOTEMS"},
	},
	["FLAT_SPELL_CRIT"] = {
		[57658] = {minspellid=57658,level=50, totemspellid=30706, slot="FIRE_TOTEMS"},
		[30706] = {minspellid=30706,level=50, slot="FIRE_TOTEMS"},
		[57660] = {minspellid=57658,level=60, totemspellid=57720, slot="FIRE_TOTEMS"},
		[57720] = {minspellid=30706,level=60, slot="FIRE_TOTEMS"},
		[57662] = {minspellid=57658,level=70, totemspellid=57721, slot="FIRE_TOTEMS"},
		[57721] = {minspellid=30706,level=70, slot="FIRE_TOTEMS"},
		[57663] = {minspellid=57658,level=80, totemspellid=57722, slot="FIRE_TOTEMS"},
		[57722] = {minspellid=30706,level=80, slot="FIRE_TOTEMS"},
	},
	["MELEE_HASTE"] = {
		[8515] = {minspellid=8515,level=32, totemspellid=8512, slot="AIR_TOTEMS"},
		[8512] = {minspellid=8512,level=32, slot="AIR_TOTEMS"},
		[55610] = {minspellid=55610,level=36, slot="ICY_TALONS"},
	},
	["SPELL_HASTE"] = {
		[2895] = {minspellid=2895,level=64, totemspellid=3738, slot="AIR_TOTEMS"},
		[3738] = {minspellid=3738,level=64, slot="AIR_TOTEMS"},
	},
	["STATS"] = {
		[20217] = {minspellid=20217,level=20, slot="BLESSINGS"},
		[25898] = {minspellid=25898,level=60, slot="BLESSINGS"},
	},
	["TANK"] = {
		[20911] = {minspellid=20911,level=30, slot="BLESSINGS"},
		[25899] = {minspellid=25899,level=60, slot="BLESSINGS"},
	},
	["HP"] = {
		[469] = {minspellid=469,level=68, slot="SHOUTS"},
		[47439] = {minspellid=469,level=74, slot="SHOUTS"},
		[47440] = {minspellid=469,level=80, slot="SHOUTS"},
	},
	["STAMINA"] = {
		[1243] = {minspellid=1243,level=1, slot="FORTITUDE"}, -- Power Word: Fortitude 1
		[1244] = {minspellid=1243,level=12, slot="FORTITUDE"}, -- Power Word: Fortitude 2
		[1245] = {minspellid=1243,level=24, slot="FORTITUDE"}, -- Power Word: Fortitude 3
		[2791] = {minspellid=1243,level=36, slot="FORTITUDE"}, -- Power Word: Fortitude 4
		[10937] = {minspellid=1243,level=48, slot="FORTITUDE"}, -- Power Word: Fortitude 5
		[21562] = {minspellid=21562,level=48, slot="FORTITUDE"}, -- Prayer of Fortitude 1
		[10938] = {minspellid=1243,level=60, slot="FORTITUDE"}, -- Power Word: Fortitude 6
		[21564] = {minspellid=21562,level=60, slot="FORTITUDE"}, -- Prayer of Fortitude 2
		[25389] = {minspellid=1243,level=70, slot="FORTITUDE"}, -- Power Word: Fortitude 7
		[25392] = {minspellid=21562,level=70, slot="FORTITUDE"}, -- Prayer of Fortitude 3
		[48161] = {minspellid=1243,level=80, slot="FORTITUDE"}, -- Power Word: Fortitude 8
		[48162] = {minspellid=21562,level=80, slot="FORTITUDE"}, -- Prayer of Fortitude 4
	},
	["INTELLECT"] = {
		[1459] = {minspellid=1459,level=1, slot="AI"}, -- Arcane Intellect 1
		[1460] = {minspellid=1459,level=14, slot="AI"}, -- Arcane Intellect 2
		[1461] = {minspellid=1459,level=28, slot="AI"}, -- Arcane Intellect 3
		[10156] = {minspellid=1459,level=42, slot="AI"}, -- Arcane Intellect 4
		[10157] = {minspellid=1459,level=56, slot="AI"}, -- Arcane Intellect 5
		[23028] = {minspellid=23028,level=56, slot="AI"}, -- Arcane Brilliance 1
		[27126] = {minspellid=1459,level=70, slot="AI"}, -- Arcane Intellect 6
		[27127] = {minspellid=23028,level=70, slot="AI"}, -- Arcane Brilliance 2
		[42995] = {minspellid=1459,level=80, slot="AI"}, -- Arcane Intellect 7 
		[43002] = {minspellid=23028,level=80, slot="AI"}, -- Arcane Brilliance 3
		[61024] = {minspellid=61024,level=80, slot="AI"}, -- Dalaran Intellect
		[61316] = {minspellid=61316,level=80, slot="AI"}, -- Dalaran Brilliance
	},
	["WILD"] = {
		[1126] = {minspellid=1126,level=1, slot="WILD"}, -- Mark of the Wild 1
		[5232] = {minspellid=1126,level=10, slot="WILD"}, -- Mark of the Wild 2
		[6756] = {minspellid=1126,level=20, slot="WILD"}, -- Mark of the Wild 3
		[5234] = {minspellid=1126,level=30, slot="WILD"}, -- Mark of the Wild 4
		[8907] = {minspellid=1126,level=40, slot="WILD"}, -- Mark of the Wild 5
		[9884] = {minspellid=1126,level=50, slot="WILD"}, -- Mark of the Wild 6
		[21849] = {minspellid=21849,level=50, slot="WILD"}, -- Gift of the Wild 1
		[9885] = {minspellid=1126,level=60, slot="WILD"}, -- Mark of the Wild 7
		[21850] = {minspellid=21849,level=60, slot="WILD"}, -- Gift of the Wild 2
		[26990] = {minspellid=1126,level=70, slot="WILD"}, -- Mark of the Wild 8
		[26991] = {minspellid=21849,level=70, slot="WILD"}, -- Gift of the Wild 3
		[48469] = {minspellid=1126,level=80, slot="WILD"}, -- Mark of the Wild 9
		[48470] = {minspellid=21849,level=80, slot="WILD"}, -- Gift of the Wild 4
	},
	["THORNS"] = {
		[467] = {minspellid=467,level=6, slot="THORNS"}, -- Thorns 1
		[782] = {minspellid=467,level=14, slot="THORNS"}, -- Thorns 2
		[1075] = {minspellid=467,level=24, slot="THORNS"}, -- Thorns 3
		[8914] = {minspellid=467,level=34, slot="THORNS"}, -- Thorns 4
		[9756] = {minspellid=467,level=44, slot="THORNS"}, -- Thorns 5
		[9910] = {minspellid=467,level=54, slot="THORNS"}, -- Thorns 6
		[26992] = {minspellid=467,level=64, slot="THORNS"}, -- Thorns 7
		[53307] = {minspellid=467,level=74, slot="THORNS"}, -- Thorns 8
	},
	["SPIRIT"] = {
		[14752] = {minspellid=14752,level=30, slot="SPIRIT"}, -- Divine Spirit 1
		[14818] = {minspellid=14752,level=40, slot="SPIRIT"}, -- Divine Spirit 2
		[14819] = {minspellid=14752,level=50, slot="SPIRIT"}, -- Divine Spirit 3
		[27841] = {minspellid=14752,level=60, slot="SPIRIT"}, -- Divine Spirit 4
		[27681] = {minspellid=27681,level=60, slot="SPIRIT"}, -- Prayer of Spirit 1
		[25312] = {minspellid=14752,level=70, slot="SPIRIT"}, -- Divine Spirit 5
		[32999] = {minspellid=27681,level=70, slot="SPIRIT"}, -- Prayer of Spirit 2
		[48073] = {minspellid=14752,level=80, slot="SPIRIT"}, -- Divine Spirit 6
		[48074] = {minspellid=27681,level=80, slot="SPIRIT"}, -- Prayer of Spirit 3
	},
	["WARLOCK_ARMOR"] = {
		[687] = {minspellid=687,level=1, slot="WARLOCK_ARMOR"}, -- Demon Skin 1
		[696] = {minspellid=687,level=10, slot="WARLOCK_ARMOR"}, -- Demon Skin 2
		[706] = {minspellid=706,level=20, slot="WARLOCK_ARMOR"}, -- Demon Armor 1
		[1086] = {minspellid=706,level=30, slot="WARLOCK_ARMOR"}, -- Demon Armor 2
		[11733] = {minspellid=706,level=40, slot="WARLOCK_ARMOR"}, -- Demon Armor 3
		[11734] = {minspellid=706,level=50, slot="WARLOCK_ARMOR"}, -- Demon Armor 4
		[11735] = {minspellid=706,level=60, slot="WARLOCK_ARMOR"}, -- Demon Armor 5
		[27260] = {minspellid=706,level=70, slot="WARLOCK_ARMOR"}, -- Demon Armor 6
		[47793] = {minspellid=706,level=76, slot="WARLOCK_ARMOR"}, -- Demon Armor 7
		[47889] = {minspellid=706,level=80, slot="WARLOCK_ARMOR"}, -- Demon Armor 8
		[28176] = {minspellid=28176,level=62, slot="WARLOCK_ARMOR"}, -- Fel Armor 1
		[28189] = {minspellid=28176,level=69, slot="WARLOCK_ARMOR"}, -- Fel Armor 2
		[47892] = {minspellid=28176,level=74, slot="WARLOCK_ARMOR"}, -- Fel Armor 3
		[47893] = {minspellid=28176,level=79, slot="WARLOCK_ARMOR"}, -- Fel Armor 4
	},
	["MAGE_ARMOR"] = {
		[6117] = {minspellid=6117,level=34, slot="MAGE_ARMOR"}, -- Mage Armor 1
		[22782] = {minspellid=6117,level=46, slot="MAGE_ARMOR"}, -- Mage Armor 2
		[22783] = {minspellid=6117,level=58, slot="MAGE_ARMOR"}, -- Mage Armor 3
		[27125] = {minspellid=6117,level=69, slot="MAGE_ARMOR"}, -- Mage Armor 4
		[43023] = {minspellid=6117,level=71, slot="MAGE_ARMOR"}, -- Mage Armor 5
		[43024] = {minspellid=6117,level=79, slot="MAGE_ARMOR"}, -- Mage Armor 6
		[30482] = {minspellid=30482,level=62, slot="MAGE_ARMOR"}, -- Molten Armor 1
		[43045] = {minspellid=30482,level=71, slot="MAGE_ARMOR"}, -- Molten Armor 2
		[43046] = {minspellid=30482,level=79, slot="MAGE_ARMOR"}, -- Molten Armor 3
		[168] = {minspellid=168,level=1, slot="MAGE_ARMOR"}, -- Frost Armor 1
		[7300] = {minspellid=168,level=10, slot="MAGE_ARMOR"}, -- Frost Armor 2
		[7301] = {minspellid=168,level=20, slot="MAGE_ARMOR"}, -- Frost Armor 3
		[7302] = {minspellid=7302,level=30, slot="MAGE_ARMOR"}, -- Ice Armor 1
		[7320] = {minspellid=7302,level=40, slot="MAGE_ARMOR"}, -- Ice Armor 2
		[10219] = {minspellid=7302,level=50, slot="MAGE_ARMOR"}, -- Ice Armor 3
		[10220] = {minspellid=7302,level=60, slot="MAGE_ARMOR"}, -- Ice Armor 4
		[27124] = {minspellid=7302,level=69, slot="MAGE_ARMOR"}, -- Ice Armor 5
		[43008] = {minspellid=7302,level=79, slot="MAGE_ARMOR"}, -- Ice Armor 6
	},
	["PALADIN_SEAL"] = {
		[53736] = {minspellid=53736,level=66, slot="SEALS"}, -- seal of corruption
		[20164] = {minspellid=20164,level=22, slot="SEALS"}, -- seal of justice
		[20165] = {minspellid=20165,level=30, slot="SEALS"}, -- seal of light
		[21084] = {minspellid=21084,level=1, slot="SEALS"}, -- seal of righteousness
		[31801] = {minspellid=31801,level=64, slot="SEALS"}, -- seal of vengeance
		[20166] = {minspellid=20166,level=38, slot="SEALS"}, -- seal of wisdom
		[20375] = {minspellid=20375,level=20, slot="SEALS"}, -- seal of command
	},
	["RIGHTEOUS_FURY"] = {
		[25780] = {minspellid=25780,level=20, slot="RIGHTEOUS_FURY"}, -- Righteous Fury
	},
	["PRIEST_FORM"] = {
		[15473] = {minspellid=15473,level=40, slot="PRIEST_FORM"}, -- Shadow Form
	},

	["OWL_FORM"] = {
		[24858] = {minspellid=24858,level=40, slot="SHAPESHIFT"}, -- Owl Form
	},

	["TREE_FORM"] = {
		[33891] = {minspellid=33891,level=50, slot="SHAPESHIFT"}, -- Tree Form
	},
	["PRIEST_INNER"] = {
		[588] = {minspellid=588,level=12, slot="PRIEST_INNER"}, -- Inner Fire 1
		[7128] = {minspellid=588,level=20, slot="PRIEST_INNER"}, -- Inner Fire 2
		[602] = {minspellid=588,level=30, slot="PRIEST_INNER"}, -- Inner Fire 3
		[1006] = {minspellid=588,level=40, slot="PRIEST_INNER"}, -- Inner Fire 4
		[10951] = {minspellid=588,level=50, slot="PRIEST_INNER"}, -- Inner Fire 5
		[10952] = {minspellid=588,level=60, slot="PRIEST_INNER"}, -- Inner Fire 6
		[25431] = {minspellid=588,level=69, slot="PRIEST_INNER"}, -- Inner Fire 7
		[48040] = {minspellid=588,level=71, slot="PRIEST_INNER"}, -- Inner Fire 8
		[48168] = {minspellid=588,level=77, slot="PRIEST_INNER"}, -- Inner Fire 9
	},
	["EMBRACE"] = {
		[15286] = {minspellid=15286,level=30, slot="EMBRACE"}, -- Vampiric Embrace
	},
}


BuffList.BuffPriorities = {
	[BuffBroker.Constants.Roles.Unknown] = {},
	[BuffBroker.Constants.Roles.Tank] = {
		["PALADIN_SEAL"] = 11,
		["TANK"] = 10,
		["HP"] = 9,
		["STATS"] = 8,
		["STAMINA"] = 7,
		["WILD"] = 6,
		["AP"] = 5,
		["THORNS"] = 4,
		["STRENGTH_AGILITY"] = 3,
		["MELEE_HASTE"] = 2,
		["ARMOR"] = 1,
		["SHADOW_RESIST"] = 0
	},
	[BuffBroker.Constants.Roles.PureMelee] = {
		["AP"] = 7,
		["STATS"] = 6,
		["HP"] = 5,
		["WILD"] = 4,
		["STAMINA"] = 3,
		["STRENGTH_AGILITY"] = 2,
		["MELEE_HASTE"] = 1,
		["SHADOW_RESIST"] = 0
	},
	[BuffBroker.Constants.Roles.MeleeMana] = {
		["PALADIN_SEAL"] = 13, ["AP"] = 12, ["STATS"] = 11, ["MP5"] = 10, ["HP"] = 9, ["WILD"] = 8, ["INTELLECT"] = 7, ["STAMINA"] = 6, ["STRENGTH_AGILITY"] = 5, ["MELEE_HASTE"] = 4, ["FLAT_SPELL_CRIT"] = 3, ["FLAT_SPELL"] = 2, ["SPELL_HASTE"] = 1, ["SHADOW_RESIST"] = 0},
	[BuffBroker.Constants.Roles.Caster] = {
		["EMBRACE"] = 13,
		["PALADIN_SEAL"] = 12,
		["STATS"] = 11,
		["MP5"] = 10,
		["HP"] = 9,
		["WILD"] = 8,
		["INTELLECT"] = 7,
		["SPIRIT"] = 6,
		["STAMINA"] = 5,
		["FLAT_SPELL_CRIT"] = 4,
		["FLAT_SPELL"] = 3,
		["SPELL_HASTE"] = 2,
		["SHADOW_RESIST"] = 1,
	},
	[BuffBroker.Constants.Roles.MeleeMana_Low] = {
		["PALADIN_SEAL"] = 13,
		["MP5"] = 12,
		["AP"] = 11,
		["STATS"] = 10,
		["HP"] = 9,
		["WILD"] = 8,
		["INTELLECT"] = 7,
		["STAMINA"] = 6,
		["STRENGTH_AGILITY"] = 5,
		["MELEE_HASTE"] = 4,
		["FLAT_SPELL_CRIT"] = 3,
		["FLAT_SPELL"] = 2,
		["SPELL_HASTE"] = 1,
		["SHADOW_RESIST"] = 0
	},
	[BuffBroker.Constants.Roles.Healer] = {
		["EMBRACE"] = 12,
		["PALADIN_SEAL"] = 11,
		["MP5"] = 10,
		["STATS"] = 9,
		["HP"] = 8,
		["WILD"] = 7,
		["INTELLECT"] = 6,
		["SPIRIT"] = 5,
		["STAMINA"] = 4,
		["FLAT_SPELL_CRIT"] = 3,
		["FLAT_SPELL"] = 2,
		["SPELL_HASTE"] = 1,
		["SHADOW_RESIST"] = 0
	},
}

-- config

local function getProfileOption(info)
	local option = profileDB[info.arg]
	local buffSpec = tonumber(string.sub(info.arg, 1, 1))
	local buffName = string.sub(info.arg, 2, string.len(info.arg))
	
	-- if: is a spec-specific buff type
	if buffSpec and BuffBroker.Constants.BuffSlots[buffName] then
		option = profileDB.slots[buffSpec][buffName]
	end -- if: is a spec-specific buff type
	
	return option
end

local function setProfileOption(info, value)
	
	local buffSpec = tonumber(string.sub(info.arg, 1, 1))
	local buffName = string.sub(info.arg, 2, string.len(info.arg))
	
	-- if: is a spec-specific buff type
	if buffSpec and BuffBroker.Constants.BuffSlots[buffName] then
		-- buff enabled/disabled
		if value then
			profileDB.slots[buffSpec][buffName] = true
		else
			profileDB.slots[buffSpec][buffName] = false
		end
	else
		-- any other setting changed
		profileDB[info.arg] = value
	end
	
	-- if: UI settings changed, take effect now
	if info.arg == "scale" then
		BuffBroker.BuffButton:SetScale(value / 100)
		BuffBroker.MoveFrame:SetScale(value / 100)
	elseif info.arg == "lock" then
		if value == true then
			-- locking
			BuffBroker.MoveFrame:Hide()
		else
			-- unlocking
			
			if BuffBroker.BuffButton:IsVisible() then
				BuffBroker.MoveFrame:Show()
			end
		end
	elseif info.arg == "show" then
		if value == true then
			BuffBroker.ActivityFrame:Show()
			BuffBroker:FullProfile()
		else
			BuffBroker.ActivityFrame:Hide()
		end
	elseif info.arg == "healerLevel" then
		BuffBroker:CheckRoles()
	elseif info.arg == "hiddenWhileIdle" then
		-- hide while idle
		if value == true then
			if BuffBroker.Idle and BuffBroker.BuffButton:IsVisible() then
				BuffBroker.BuffButton:Hide()
				BuffBroker.MoveFrame:Hide()
			end
		
		-- else; show while idle
		else
			if BuffBroker.Idle and not BuffBroker.BuffButton:IsVisible() then
				BuffBroker.BuffButton:Show()
				if not profileDB.lock then
					BuffBroker.MoveFrame:Show()
				end
			end
		end
	end
end

-- Slash commands (via AceConfig-3.0)
local options = {
	type = 'group',
	get = getProfileOption,
	set = setProfileOption,
	args = {
		general = {
			type = 'group',
			name = L["General Settings"],
			cmdInline = true,
			order = -1,
			args = {
				version = {
					type = 'description',
					name = '1.6.10B',
					order = 1,
				},
				behavior  = {
					type = 'header',
					name = L["Behavior"],
					order = 2,
				},
				behavior_desc = {
					type = 'description',
					name = L["Change how Buff Broker handles group-wide buffs"]..'\n',
					order = 3,
				},
				refreshAtDuration = {
					type = 'range',
					order = 4,
					width = 'triple',
					name = L["Refresh Time"],
					desc = L["Refresh buffs with less than X seconds remaining (0 = when it expires)"],
					arg = 'refreshAtDuration',
					get = getProfileOption,
					set = setProfileOption,
					min = 0,
					max = 1800, -- set to level cap + 3
					step = 10,
				},
				raidBuffAttendThreshold = {
					type = 'range',
					order = 5,
					width = 'single',
					name = L["Attendance Threshold"],
					desc = L["minimum % of targets nearby, in order to cast a raid-wide spell"],
					arg = 'raidBuffAttendThreshold',
					get = getProfileOption,
					set = setProfileOption,
					min = 0,
					max = 100,
					step = 5,
				},
				raidBuffHeadCountThreshold = {
					type = 'range',
					order = 6,
					width = 'single',
					name = L["Head Count Threshold"],
					desc = L["minimum # of targets nearby, in order to cast a raid-wide spell"],
					arg = 'raidBuffHeadCountThreshold',
					get = getProfileOption,
					set = setProfileOption,
					min = 1,
					max = 40,
					step = 1,
				},
				frugal = {
					type = 'toggle',
					order = 7,
					width = 'single',
					name = L["Frugal"],
					desc = L["don't use class/raid wide buffs when only one eligible target exists"],
					arg = 'frugal',
					get = getProfileOption,
					set = setProfileOption,
				},
				friendly = {
					type = 'toggle',
					order = 8,
					width = 'single',
					name = L["Friendly"],
					desc = L["don't apply buffs another raid member cast, even if theirs expires"],
					arg = 'friendly',
					get = getProfileOption,
					set = setProfileOption,
				},
				healerLevel = {
					type = 'range',
					order = 9,
					width = 'double',
					name = L["Healer Level"],
					desc = L["Prefer mana regeneration over stats, for healers under this level"],
					arg = 'healerLevel',
					get = getProfileOption,
					set = setProfileOption,
					min = 1,
					max = 81,
					step = 1,
				},
				appearance  = {
					type = 'header',
					name = L["Appearance"],
					order = 20,
				},
				appearance_desc = {
					type = 'description',
					name = L["Change how Buff Broker looks, feels, and fits"]..'\n',
					order = 21,
				},
				scale = {
					type = 'range',
					order = 22,
					width = 'single',
					name = L["UI Scaling"],
					desc = L["change the size of the button"],
					arg = 'scale',
					get = getProfileOption,
					set = setProfileOption,
					min = 0,
					max = 100,
					step = 5,
				},
				lock = {
					type = 'toggle',
					order = 23,
					width = 'single',
					name = L["Lock UI"],
					desc = L["Disable the UI Move Bar"],
					arg = 'lock',
					get = getProfileOption,
					set = setProfileOption,
				},
				toggle = {
					type = 'toggle',
					order = 24,
					width = 'single',
					name = L["Visible"],
					desc = L["Show/Hide the main button (scanning disabled while hidden)"],
					arg = 'show',
					get = getProfileOption,
					set = setProfileOption,
				},
				hiddenWhileIdle = {
					type = 'toggle',
					order = 25,
					width = 'single',
					name = L["Hidden while Idle"],
					desc = L["Hide the main button when no action required (background scanning still active)"],
					arg = 'hiddenWhileIdle',
					get = getProfileOption,
					set = setProfileOption,
				},
				tooltipAnchor = {
					type = 'select',
					order = 26,
					width = 'single',
					name = L["Tooltip Position"],
					desc = L["Position of the Tooltip, relative to the buff button"],
					values = {
						["ANCHOR_TOPLEFT"] = L["TOPLEFT"],
						["ANCHOR_TOP"] = L["TOP"],
						["ANCHOR_TOPRIGHT"] = L["TOPRIGHT"],
						["ANCHOR_RIGHT"] = L["RIGHT"],
						["ANCHOR_BOTTOMRIGHT"] = L["BOTTOMRIGHT"],
						["ANCHOR_BOTTOM"] = L["BOTTOM"],
						["ANCHOR_BOTTOMLEFT"] = L["BOTTOMLEFT"],
						["ANCHOR_LEFT"] = L["LEFT"],
						},
					arg = 'tooltipAnchor',
					get = getProfileOption,
					set = setProfileOption,
				},
				
				support  = {
					type = 'header',
					name = L["Support"],
					order = 70,
				},
				support_desc = {
					type = 'description',
					name = L["Test, fix, or reset Buff Broker"]..'\n',
					order = 71,
				},
				testBuffs = {
					order = 72,
					name = L["Test: Buff Providers"],
					desc = L["perform unit tests against sample party compositions"],
					type = 'execute',
					func = function() BuffBroker:TestBestBuffs() end
				},
				testSuggestions = {
					order = 73,
					name = L["Test: Suggestions"],
					desc = L["perform unit tests for suggestions against sample parties"],
					type = 'execute',
					func = function() BuffBroker:TestSuggestions() end
				},
				scanActive = {
					order = 74,
					name = 'scanActive',
					desc = L["Perform a full scan of the buffs active on your current group"],
					type = 'execute',
					func = function() BuffBroker:ScanActiveAll() end,
					dialogHidden = true,
				},
				ScanAvailable = {
					order = 75,
					name = 'scanAvailable',
					desc = L["Perform a full scan of the buffs available to your current group"],
					type = 'execute',
					func = function() BuffBroker:ScanAvailable() end,
					dialogHidden = true,
				},
				buildSuggestions = {
					order = 76,
					name = 'buildSuggestions',
					desc = L["makes buff recommendations based on raid, active buffs, and raid member talents/abilities"],
					type = 'execute',
					func = function() BuffList.Suggestions = BuffBroker:BuildSuggestList(BuffList.Players, BuffList.Classes, BuffList.Coverage, BuffList.Coverage, BuffList.ProfiledBuffProviders, BuffList.PlayerGUID) end,
					dialogHidden = true,
				},
				suggest = {
					order = 77,
					name = 'suggest',
					desc = L["return suggestions for number of party members"],
					type = 'execute',
					func = function() BuffBroker:Suggest() end,
					dialogHidden = true,
				},
				dumpSuggestions = {
					order = 78,
					name = L["Output Suggestions"],
					desc = L["print suggestions (sorted) to the chat window; includes relevant sort criteria"],
					type = 'execute',
					func = function() BuffBroker:DumpSuggestions() end,
				},
				reset = {
					order = 79,
					name = L["Reset"],
					desc = L["Clear cached data and restart the addon"],
					type = 'execute',
					func = function() BuffBroker:Reset() end,
				},
				standby = {
					type = 'toggle',
					order = 80,
					width = 'double',
					name = L["Enabled"],
					desc = L["Suspend/resume this addon"],
					get = function() return BuffBroker:IsEnabled() end,
					set = function()
						if BuffBroker:IsEnabled() then
							BuffBroker:Disable()
						else
							BuffBroker:Enable()
						end
					end,
					dialogHidden = true,
				},
				show = {
					order = 81,
					name = L["Show"],
					desc = L["Shows the main window"],
					type = 'execute',
					func = function() BuffBroker.ActivityFrame:Show() end,
					dialogHidden = true,
				},
				hide = {
					order = 82,
					name = L["Hide"],
					desc = L["Hides the main window"],
					type = 'execute',
					func = function() BuffBroker.ActivityFrame:Hide() end,
					dialogHidden = true,
				},
				
				buffSlots  = {
					type = 'header',
					name = L["Buff Selection"],
					order = 30,
				},
				buffSlots_desc = {
					type = 'description',
					name = L["Pick which Buffs to parse, analyze, and suggest"]..'\n',
					order = 31,
				},
				--[[
				MAGE_ARMOR = { -- <- auto-generated entries should look like this
					type = 'toggle',
					order = 32,
					width = 'single',
					name = L["MAGE_ARMOR"],
					desc = L["MAGE_ARMOR_DESC"],
					arg = 'MAGE_ARMOR',
					get = getProfileOption,
					set = setProfileOption,
				},]]
				
				buffSlotsDualSpec = {
					type = 'header',
					name = L["Buff Selection - Dual Spec"],
					order = 50,
					dialogHidden = true,
				},
				buffSlotsDualSpec_desc = {
					type = 'description',
					name = L["Pick which Buffs to parse, analyze, and suggest for your offspec"]..'\n',
					order = 51,
					dialogHidden = true,
				},
				--[[
				MAGE_ARMOR = { -- <- auto-generated entries should look like this
					type = 'toggle',
					order = 52,
					width = 'single',
					name = L["MAGE_ARMOR"],
					desc = L["MAGE_ARMOR_DESC"],
					arg = 'MAGE_ARMOR',
					get = getProfileOption,
					set = setProfileOption,
				},]]
			}, -- args
		}, -- General
	}, -- args
} -- .Options

--[[ Save Versions:
1.0 -> 1.1: "slots" sub-tree'd by spec:  slot{1={NAME=TRUE, ...}...}
]]

local defaults = {
	base = {
		profile = {
			saveVersion = 1.0,
			refreshAtDuration = 20,
			raidBuffAttendThreshold = 0,
			raidBuffHeadCountThreshold = 1,
			frugal = false,
			friendly = false,
			healerLevel = 68,
			screenX = 0,
			screenY = -100,
			scale = 100,
			lock = false,
			show = true,
			tooltipAnchor = "ANCHOR_BOTTOM",
			skin = {
				ID = 'Blizzard',
				Backdrop = true,
				Gloss = 0,
				Zoom = false,
				Colors = {},
			},
			subskin = {
				ID = 'Blizzard',
				Backdrop = true,
				Gloss = 0,
				Zoom = false,
				Colors = {},
			},
			slots = {
				[1] = {},
				[2] = {},
			},
			activeSelfBuffs = {
				{}, -- talent group 1
				{}, -- talent group 2
			},
		},
	},
	[BuffBroker.Constants.Classes.Warrior] = {
		profile = {
			slots = {
				[1] = {
					["SHOUTS"] = true,
				},
				[2] = {
					["SHOUTS"] = true,
				},
			},
		},
	},
	[BuffBroker.Constants.Classes.Deathknight] = {
		profile = {
			slots = {
				[1] = {
					["HORNS"] = true,
				},
				[2] = {
					["HORNS"] = true,
				},
			},
		},
	},
	[BuffBroker.Constants.Classes.Paladin] = {
		profile = {
			refreshAtDuration = 300,
			raidBuffAttendThreshold = 90,
			friendly = true,
			slots = {
				[1] = {
					["BLESSINGS"] = true,
					["SEALS"] = true,
					["RIGHTEOUS_FURY"] = false, -- not quite working yet
					--["AURAS"] = true,
				},
				[2] = {
					["BLESSINGS"] = true,
					["SEALS"] = true,
					["RIGHTEOUS_FURY"] = false, -- not quite working yet
					--["AURAS"] = true,
				},
			},
		},
	},
	[BuffBroker.Constants.Classes.Shaman] = {
		profile = {
			refreshAtDuration = 300,
			friendly = true,
			slots = {
				[1] = {
					["WATER_TOTEMS"] = true,
					["EARTH_TOTEMS"] = true,
					["FIRE_TOTEMS"] = true,
					["AIR_TOTEMS"] = true,
					-- ["SHAMAN_WEAPONS"] = true,
				},
				[2] = {
					["WATER_TOTEMS"] = true,
					["EARTH_TOTEMS"] = true,
					["FIRE_TOTEMS"] = true,
					["AIR_TOTEMS"] = true,
					-- ["SHAMAN_WEAPONS"] = true,
				},
			},
		},
	},
	[BuffBroker.Constants.Classes.Hunter] = {
		profile = {
			slots = {
				[1] = {
				},
				[2] = {
				},
			},
		},
	},
	[BuffBroker.Constants.Classes.Rogue] = {
		profile = {
			slots = {
				[1] = {
					-- ["ROGUE_POISONS"] = true,
				},
				[2] = {
					-- ["ROGUE_POISONS"] = true,
				},
			},
		},
	},
	[BuffBroker.Constants.Classes.Druid] = {
		profile = {
			refreshAtDuration = 300,
			raidBuffAttendThreshold = 90,
			raidBuffHeadCountThreshold = 2,
			slots = {
				[1] = {
					["THORNS"] = true,
					["WILD"] = true,
					["SHAPESHIFT"] = false,
				},
				[2] = {
					["THORNS"] = true,
					["WILD"] = true,
					["SHAPESHIFT"] = false,
				},
			},
		},
	},
	[BuffBroker.Constants.Classes.Warlock] = {
		profile = {
			slots = {
				[1] = {
					["WARLOCK_ARMOR"] = true,
					--["WARLOCK_WEAPON"] = true,
				},
				[2] = {
					["WARLOCK_ARMOR"] = true,
					--["WARLOCK_WEAPON"] = true,
				},
			},
		},
	},
	[BuffBroker.Constants.Classes.Priest] = {
		profile = {
			refreshAtDuration = 300,
			raidBuffAttendThreshold = 90,
			raidBuffHeadCountThreshold = 2,
			slots = {
				[1] = {
					["FORTITUDE"] = true,
					["SPIRIT"] = true,
					["PRIEST_INNER"] = true,
					["PRIEST_PROTECTION"] = true,
					["EMBRACE"] = true,
					["PRIEST_FORM"] = true,
				},
				[2] = {
					["FORTITUDE"] = true,
					["SPIRIT"] = true,
					["PRIEST_INNER"] = true,
					["PRIEST_PROTECTION"] = true,
					["EMBRACE"] = true,
					["PRIEST_FORM"] = true,
				},
			},
		},
	},
	[BuffBroker.Constants.Classes.Mage] = {
		profile = {
			refreshAtDuration = 300,
			raidBuffAttendThreshold = 90,
			raidBuffHeadCountThreshold = 2,
			slots = {
				[1] = {
					["AI"] = true,
					["MAGE_ARMOR"] = true,
					--["MAGE_STONE"] = true,
				},
				[2] = {
					["AI"] = true,
					["MAGE_ARMOR"] = true,
					--["MAGE_STONE"] = true,
				},
			},
		},
	},
}

function BuffBroker:DumpSuggestions()
	local os, key, suggestion, player
	local kB, vB
	
	print('--BuffBroker Suggestions ('..table.getn(BuffList.Suggestions)..')--')
	for key, suggestion in ipairs(BuffList.Suggestions) do
		os = 'Cast '..GetSpellInfo(suggestion.spellid)..' on '..suggestion.TargetProfile.Name..' @ '..suggestion.Confidence..':'
		
		if suggestion.BetterActive then
			os = os..' Better Active;'
		end
			
		if suggestion.Near then
			os = os..' Nearby;'
		end
		
		if suggestion.UnBuffedHeadCount then
			os = os..' #'..suggestion.UnBuffedHeadCount..';'
		end
		
		if suggestion.Attendance then
			os = os..' '..(suggestion.Attendance*100)..'%;'
		end
		
		print(os)
	end
	print('--BuffBroker Players ('..BuffList.PlayerCount..')--')

	for key, player in pairs(BuffList.Players) do
		os = '['..key..'] '..player.Name..' the level '..player.Level..' '..player.Class..' ('..player.Role..'): '
		
		if player.Stale then
			os = os..' Stale;'
		end
		
		os = os..' Buffs: '
		for kB, vB in pairs(player.ActiveBuffs) do
			os = os..kB..' from '..BuffList.Players[vB.CasterGUID].Name
			if vB.Expires then
				os = os..' expires in '..math.floor(vB.Expires - GetTime())..'s'
			end
			os = os..', '
		end
		
		print(os)
	end

	print('--BuffBroker Stale Players ('..table.getn(BuffList.StalePlayers)..')--')
	for index, playerGUID in ipairs(BuffList.StalePlayers) do
		os = '['..playerGUID..'] '..BuffList.Players[playerGUID].Name
		
		print(os)
	end
	
	print('--BuffBroker Finished Report--')

end

function BuffBroker:Reset()
	BuffList.PlayerGUID = nil
	BuffList.Players = {}
	BuffList.PlayerCount = 0
	BuffList.ProfiledBuffProviders = nil
	BuffList.Suggestions = {}
	BuffList.StalePlayers = {}

	BuffBroker.InCombat = nil
	BuffBroker.Idle = nil
	BuffBroker.TalentGroup = 1

	BuffList.InspectOutstanding = nil
	BuffList.InspectBusy = nil
	BuffList.InspectTarget = nil
	BuffList.InspectPending = nil
	BuffList.InspectComplete = nil
	BuffList.InspectLastChecked = nil
	BuffList.LastSuggested = nil

	BuffList.TooltipPrime = L["Loading..."]
	BuffList.TooltipDetail = L["Buff Broker is starting up"]
	BuffList.TooltipMinor = ''
	BuffList.tooltipFormatter = ''

	BuffList.AurasFirstChangedAt = nil
	BuffList.AurasLastChangedAt = nil

	BuffList.LastCheckedRange = nil
	BuffList.RangeCheckDelay = 5

	BuffBroker:ClearState()
end

function BuffBroker:Suggest()
	BuffBroker.BuffButton:Click()
end

function BuffBroker:HasExpired(activeBuff, thePlayerGUID)
	local hasExpired = true
	
	-- if: buff exists
	if activeBuff then
		-- if: known source
		if activeBuff.CasterGUID then
			-- if: friendly, and cast by a friend
			if profileDB.friendly
			and activeBuff.CasterGUID ~= thePlayerGUID then
				-- assume is active (ie: don't poach)
				hasExpired = false
			else
				-- calculate if never expires, or if ready to re-buff
				hasExpired = (activeBuff.Expires and activeBuff.Expires ~= 0) and ((activeBuff.Expires - GetTime()) < profileDB.refreshAtDuration)
			end -- if: check if can't poach buffs
		else
			-- unknown source;  check for absolute expiration
			hasExpired = (activeBuff.Expires) and ((activeBuff.Expires - GetTime()) < 0)
		end
	end -- if: buff exists
	
	return hasExpired
end

function BuffBroker:ClassIterator (thePlayers, className)
	local lastID = nil
	local lastProfile = nil
	
	return function ()
		lastID, lastProfile = next(thePlayers, lastID)

		-- while: key, value are valid
		while lastID and lastProfile do
			-- if: key, value are valid, and class matches
			if not className or lastProfile.Class == className or BuffBroker.Constants.Classes.Raid == className then
				break
			else
				lastID, lastProfile = next(thePlayers, lastID)
			end
		end
		
		return lastID, lastProfile
	end
end


function BuffBroker:BuildSuggestList(thePlayers, theClasses, theCoverage, bestBuffs, myGUID)
	local playerProfile
	local myName
	local mySlotName, ourCurrentSlot
	local currentSlotEntry
	local buffLabel
	local currentGUID
	local currentProfile
	local buffPriorities
	local currentName
	local suggestionConfidence
	local committedBuffers
	local key
	local currentActiveBuff
	local buffActive
	local theirSlotName
	local theirSlot
	local theirSlotNameEntry
	local theirSlotEntry
	local buffLookup
	local committedCount
	local caster_slot
	local activeBuffStrength
	local activeExpired
	local possibleSuggestion
	local sortedSuggestList = {}
	local wantsBuffCount
	local hasBuffCount
	local hasBetterFromMeCount
	local wantsBetterCount
	local headCount
	
	local inRangeCount
	local someProfile
	local i
	local currentSuggestion
	local activeSlotName
	local buffSlot
	local activeSuggestions = {}
	local spellName
	local groupsToScan
	local className
	local classValue
	local someTarget
	local someTargetProfile
	local currentGroupName
	local hasAwesomeGreaterBuff
	local currentTotem
	local currentTotemLabel
	local someSlotName
	
	MyDebugPrint("Rebuilding suggest list from scratch")
	
	-- if: I'm profiled/cached
	if myGUID and thePlayers[myGUID] then
		playerProfile = thePlayers[myGUID]
		myName = thePlayers[myGUID].Name

		-- suggestion list will be empty if player can't do ANY best buffs :3

		-- for: each buffslot we could use
		for mySlotName, ourCurrentSlot in pairs(playerProfile.BuffSlots) do
			MyDebugPrint("suggesting for buffslot %s", mySlotName)
			
			-- for: each spell in our current buffslot
			for currentSlotID, currentSlotEntry in pairs(ourCurrentSlot) do
				buffLabel = BuffBroker:SpellInfoFromID(currentSlotID)
				spellName = GetSpellInfo(currentSlotID)

				-- if: single-target buff
				if BuffBroker.Constants.Scope.Individual == currentSlotEntry.Scope then

					MyDebugPrint("suggesting for single buff slot")
					-- for: each player/target
					for currentGUID, currentProfile in pairs(thePlayers) do
						buffPriorities = {}
						currentName = thePlayers[currentGUID].Name
						suggestionConfidence = BuffBroker.Constants.Confidence.None -- (0 == none, 1 == backups available, 2 == among many good versions, 3 == unique snowflake)
						
						MyDebugPrint("-Player: %s", currentName)
						-- Come up with a suggestion for this player (nil == can't do anything target would want)

						-- Get the prioritized list of buffs this player/target wants (based on their role)
						if currentProfile.Role then buffPriorities = BuffList.BuffPriorities[currentProfile.Role] end
						
						-- if: this player actually WANTS this type of buff, and can HAVE this buff
						MyDebugPrint("character level: %d, Min level of %s: %d", currentProfile.Level, spellName, currentSlotEntry.MinLevel)
						if buffPriorities[buffLabel] and not (currentProfile.Level < currentSlotEntry.MinLevel) then
							MyDebugPrint("%s wants %s ", currentName, buffLabel)
							
							-- compile flat-list of who already buffed this target (committedBuffers)
							committedBuffers = {}
							
							-- for: each active buff on currentProfile
							for key, currentActiveBuff in pairs(currentProfile.ActiveBuffs) do

								buffActive = not BuffBroker:HasExpired(currentActiveBuff, myGUID)
								
								-- if: caster is in the raid, wasn't me, and the buff is active
								if thePlayers[currentActiveBuff.CasterGUID] and myGUID ~= currentActiveBuff.CasterGUID and buffActive then
								
									-- This dude has committed a buffslot to <spell>
									-- for: each of the dude's buffslot
									for theirSlotName, theirSlot in pairs(thePlayers[currentActiveBuff.CasterGUID].BuffSlots) do
										
										-- if: spellid matches an entry in this slot
										if theirSlot[currentActiveBuff.Spellid] then
										
											-- Buffslot used!  record the player's name & buffslot name
											table.insert(committedBuffers, {currentActiveBuff.CasterGUID, theirSlotName})
										end -- if: spellid matches an entry in this slot
									end -- for: each of the dude's buffslot
								end -- if: caster is in the raid
							end -- for: each active buff on currentProfile
							
							-- Suggest buffs;  higher confidence rules > lower confidence rules
							
							-- get buff name, strength, and eligible providers
							buffLookup = bestBuffs[buffLabel] -- {Strength = BuffBroker.Constants.Buffs.#, TotalCount = #, Players = {name, ...} }
							committedCount = 0
							
							-- count how many eligible players already committed themselves to a buff
							-- for: each buffer/buffslot already consumed
							for _, caster_slot in pairs(committedBuffers) do
								-- caster_slot: {PlayerGUID, BuffSlotIndex, expiration)

								-- for: each entry in current buffslot
								for theirSlotID in pairs(thePlayers[caster_slot[1]].BuffSlots[caster_slot[2]]) do
									
									-- if: spellid from this used-up bufflist COULD have fit/satisfied the label
									if buffLabel == BuffBroker:SpellInfoFromID(theirSlotID) then
										-- slot already used: increase committedCount, move on to next buffslot
										committedCount = committedCount + 1
										break
									end -- if: spellid from this used-up bufflist COULD have fit/satisfied the label
								end -- for: each spellid in this buffslot
							end -- for: each buffer/buffslot already consumed
							
							-- determine active buff's strength from player lookup
							if currentProfile.ActiveBuffs[buffLabel] then
								activeBuffStrength = currentProfile.ActiveBuffs[buffLabel].Strength
								-- has it expired?
								
								-- calculate if is still active
								activeExpired = BuffBroker:HasExpired(currentProfile.ActiveBuffs[buffLabel], myGUID)
							else
								MyDebugPrint("buff %s on %s isn't active..?", buffLabel, currentProfile.Name)
								activeBuffStrength = BuffBroker.Constants.Buffs.None
								activeExpired = true
							end
							
							-- suggest a buff if..
							--  a) it fits the BuffLabel
							--  b) it's suitable to do so (with SOME confidence)
							--  c) it's not a greater paladin buff (we'll math that out later)
							possibleSuggestion = nil
							
							-- if: spellid is a buffLabel type of buff
							if buffLabel == BuffBroker:SpellInfoFromID(currentSlotID) then
								
								MyDebugPrint("%s eligible for %s; determining Confidence...", spellName, buffLabel)
								-- We COULD do this buff!  Start Suggesting, with varying degrees of confidence
								
								-- if: the buff isn't best, fell off, or is mine
								if buffLookup and ((activeBuffStrength < buffLookup.Strength)
								or myGUID == currentProfile.ActiveBuffs[buffLabel].CasterGUID)
								or activeExpired then
									MyDebugPrint("Active Score: %d of buffLabel %s", activeBuffStrength, buffLabel)
									if activeExpired then MyDebugPrint("active expired") end
									
									possibleSuggestion = {
										Scope = BuffBroker.Constants.Scope.Individual,
										Confidence = BuffBroker.Constants.Confidence.Certain,
										Target = currentGUID,
										spellid = currentSlotID,
										TargetProfile = currentProfile,
										Attendance = (1.0 * theClasses[currentProfile.Class].Near) / theClasses[currentProfile.Class].HeadCount,
										UnBuffedHeadCount = 1,
										IsDominantRole = theClasses[currentProfile.Class].DominantRole == currentProfile.Role,
										BetterActive = activeBuffStrength > buffLookup.Strength,
									}
									
									if theClasses[currentProfile.Class].HeadCount == 0 then
										-- THN:  This is getting encountered;  investigate!
										possibleSuggestion.Attendance = 0
										--print(L["BuffBroker:  0 headcount...profiling incomplete, or error'd"])
									end

									-- if: player is the only one left to do the buff
									if 1 == (buffLookup.TotalCount - committedCount) then
										-- can provide best (as can others), all others committed
										possibleSuggestion.Confidence = BuffBroker.Constants.Confidence.Certain

									-- elseif: player can provide the best buff
									elseif listContains(buffLookup.Players, myGUID) then
										-- down to Likely, or Possible

										coverageBy = BuffBroker:CheckCoverage(theCoverage, currentProfile.Class, buffLabel)

										-- if: slot coverage
										if BuffBroker.Constants.BuffSlots[coverageBy] then
											-- can provide best, slot coverage
											possibleSuggestion.Confidence = BuffBroker.Constants.Confidence.Possible
										elseif thePlayers[coverageBy] and coverageBy ~= myGUID then
											-- can provide best, but player coverage already (not us)
											possibleSuggestion.Confidence = BuffBroker.Constants.Confidence.Unlikely
										elseif not coverageBy then
											-- can provide best (as can others), no coverage
											possibleSuggestion.Confidence = BuffBroker.Constants.Confidence.Likely
										end
										
									-- else: player cannot provide the best buff
									else
										-- down to Optional or Unlikely
										
										-- if: slot coverage
										if BuffBroker.Constants.BuffSlots[coverageBy] then
											-- can't provide best, slot coverage
											possibleSuggestion.Confidence = BuffBroker.Constants.Confidence.Unlikely
										elseif thePlayers[coverageBy] and coverageBy ~= myGUID then
											-- player coverage (not us)
											possibleSuggestion.Confidence = BuffBroker.Constants.Confidence.Unlikely
										elseif not coverageBy then
											-- can't provide best, no coverage
											possibleSuggestion.Confidence = BuffBroker.Constants.Confidence.Optional
										end

										--[[ OLD
										-- if: buff not active
										if activeBuffStrength == BuffBroker.Constants.Buffs.None then
											-- SUGGEST:  OPTIONAL
											possibleSuggestion.Confidence = BuffBroker.Constants.Confidence.Optional
										elseif activeExpired then
											-- SUGGEST:  UNLIKELY
											possibleSuggestion.Confidence = BuffBroker.Constants.Confidence.Unlikely
										end
										]]
									end -- else: player cannot provide the best buff
									
								end -- if: the buff isn't best, fell off, or is mine
							end -- if: spellid is a buffLabel type of buff

							if possibleSuggestion then
								table.insert(sortedSuggestList, possibleSuggestion)
							end

							-- else TODO:  Account for idiocy (ie: someone already did a dumb version of the buff)
						end -- if: this player actually WANTS this type of buff
					end -- for: each player/target


				elseif BuffBroker.Constants.Scope.Self == currentSlotEntry.Scope then
					--if BuffBroker:HasExpired(thePlayers[myGUID].ActiveBuffs[buffLabel], myGUID) and IsSpellKnown(currentSlotID) then
					if IsSpellKnown(currentSlotID) then
						possibleSuggestion = {
							Scope = BuffBroker.Constants.Scope.Self,
							Confidence = BuffBroker.Constants.Confidence.Certain,
							Target = myGUID,
							spellid = currentSlotID,
							TargetProfile = thePlayers[myGUID],
							Attendance = 1,
							UnBuffedHeadCount = 1,
							IsDominantRole = true,
							RoleCount = {},
						}

						table.insert(sortedSuggestList, possibleSuggestion)
					end


				elseif BuffBroker.Constants.Scope.Class == currentSlotEntry.Scope or BuffBroker.Constants.Scope.Raid == currentSlotEntry.Scope then
					
					groupsToScan = {}

					if BuffBroker.Constants.Scope.Class == currentSlotEntry.Scope then
						for classKey, className in pairs(BuffBroker.Constants.Classes) do
							groupsToScan[classKey] = className
						end
						
						groupsToScan.Raid = nil
					elseif BuffBroker.Constants.Scope.Raid == currentSlotEntry.Scope then
						groupsToScan.Raid = BuffBroker.Constants.Classes.Raid
					end
					
					-- for: each group to scan
					for _, currentGroupName in pairs(groupsToScan) do
						coverageBy = BuffBroker:CheckCoverage(theCoverage, currentGroupName, buffLabel)
						buffLabel = BuffBroker:SpellInfoFromID(currentSlotID)
						myBuffStrength = BuffBroker:GetBuffStrength(BuffList.Players, BuffList.PlayerGUID, buffLabel)
						wantsBuffCount = 0
						wantsBetterCount = 0
						hasBuffCount = 0
						hasBetterFromMeCount = 0
						inRangeCount = 0
						hasAwesomeGreaterBuff = nil
						possibleSuggestion = nil

						-- check for current totem selection
						
						-- if: Coverage is by nobody, me, any buffslots, or someone in the raid (if we're not being friendly):
						if not hasAwesomeGreaterBuff
						and ( not coverageBy
						or coverageBy == myGUID
						or BuffBroker.Constants.BuffSlots[coverageBy]
						or (thePlayers[coverageBy] and not profileDB.friendly) ) then
						
							-- for: each player in the current group
							for currentGUID, currentProfile in BuffBroker:ClassIterator(thePlayers, currentGroupName) do
								-- check expiration, attendance, & headcount threshold

								-- check if they have an awesome greater buff (ie: scoping sanctuary, have (and want) kings as a caster)
								-- "awesome greater buff" precludes cast!
								
								-- if: they want this buff
								if BuffList.BuffPriorities[currentProfile.Role][buffLabel] and not (currentProfile.Level < currentSlotEntry.MinLevel) then
									wantsBuffCount = wantsBuffCount + 1
									wantsBuff = true

									-- if: they're in range
									if currentProfile.Near then
										inRangeCount = inRangeCount + 1
										
										-- if: they're visible
										if currentProfile.LOS and not currentProfile.Obscured then
											
											-- if: they don't have a better version active
											if not currentProfile.ActiveBuffs[buffLabel] or
											not (currentProfile.ActiveBuffs[buffLabel].Strength > myBuffStrength) then
												-- use them as the class target
												someTarget = currentGUID
												someTargetProfile = currentProfile
											end -- if: they don't have a better version active
										end -- if: they're visible too
									end

								else
									wantsBuff = false
								end

								-- for: each buff they want
								for currentLabel, currentLabelPriority in pairs(BuffList.BuffPriorities[currentProfile.Role]) do
									
									-- if: desire current label more than suggested label
									if currentLabelPriority > BuffBroker:GetBuffDepth(currentProfile.Role, currentSlotID) then
									
										-- if: is from me
										if currentProfile.ActiveBuffs[currentLabel] and currentProfile.ActiveBuffs[currentLabel].CasterGUID == myGUID then
											_, someSlotName, ActiveScope = BuffBroker:SpellInfoFromID(currentProfile.ActiveBuffs[currentLabel].Spellid)
																				
											-- if: from the same slot as we're scoping out
											if someSlotName == mySlotName then
												-- if: scope of buff is group-wide
												if ActiveScope == BuffBroker.Constants.Scope.Class or ActiveSlot == BuffBroker.Constants.Scope.Raid then
													hasAwesomeGreaterBuff = true

												end
												
												if wantsBuff then

													-- if: expired
													if BuffBroker:HasExpired(currentProfile.ActiveBuffs[currentLabel], myGUID) then
														-- they want this better buff from me!
														wantsBetterCount = wantsBetterCount + 1
													
													-- else: not expired
													else

														-- has better active from me;  note count, and advance to next player
														hasBetterFromMeCount = hasBetterFromMeCount + 1
													end -- if: expired
											
													-- advance to next player
													break
												end
											end
										end -- if: from me
									elseif currentLabelPriority == BuffBroker:GetBuffDepth(currentProfile.Role, currentSlotID) then
										-- if: they have the buff we're scoping, from anyone
										if not BuffBroker:HasExpired(currentProfile.ActiveBuffs[currentLabel], myGUID) then

											_, ActiveSlot, ActiveScope = BuffBroker:SpellInfoFromID(currentProfile.ActiveBuffs[currentLabel].Spellid)
											
											-- if: slots match
											if wantsBuff then

												-- is already active;  note count, and advance to next player
												hasBuffCount = hasBuffCount + 1
												break
											end
										end
									end
								end -- for: each buff they want
										
							end -- for: each player
							
							headCount = wantsBuffCount - (hasBuffCount + hasBetterFromMeCount + wantsBetterCount)
							-- math done!
							
							-- if: anyone wants (and can receive) this buff, and it won't overwrite an existing (accurate) group-wide buff
							--if (wantsBuffCount - (hasBuffCount + hasBetterFromMeCount)) > 0 and inRangeCount > 0 and not hasAwesomeGreaterBuff then
							if headCount > 0 and inRangeCount > 0 then
							--if inRangeCount > 0 then
								
							
								possibleSuggestion = {
									Scope = currentSlotEntry.Scope,
									Confidence = BuffBroker.Constants.Confidence.Certain,
									Target = nil, -- placeholder
									spellid = currentSlotID,
									TotemSlot = BuffBroker.Constants.Totems[mySlotName],
									TargetProfile = nil, -- placeholder
									Attendance = inRangeCount / wantsBuffCount,
									UnBuffedHeadCount = headCount,
									IsDominantRole = true,
									RoleCount = {},
									BetterActive = (hasBetterFromMeCount > 0),
								}
								
								-- if: is a totem, and we know how to drop dis totem
								if possibleSuggestion.TotemSlot
								and BuffList.DownRankLookup[buffLabel]
								and BuffList.DownRankLookup[buffLabel][currentSlotID]
								and BuffList.DownRankLookup[buffLabel][currentSlotID].totemspellid then
									-- suggest we cast the totem's id, not the aura's id
									possibleSuggestion.TotemSpell = BuffList.DownRankLookup[buffLabel][currentSlotID].totemspellid
								end
								
								
								--if (wantsBuffCount - (hasBuffCount + hasBetterFromMeCount)) > 0 and inRangeCount > 0 and not hasAwesomeGreaterBuff then
								if hasAwesomeGreaterBuff then
									possibleSuggestion.BetterActive = true
								end
								
								if currentSlotEntry.Scope == BuffBroker.Constants.Scope.Class then
									possibleSuggestion.Target = someTarget
									possibleSuggestion.TargetProfile = someTargetProfile
								elseif currentSlotEntry.Scope == BuffBroker.Constants.Scope.Raid then
									possibleSuggestion.Target = myGUID
									possibleSuggestion.TargetProfile = thePlayers[myGUID]
								end
								
								-- if: can see anyone for this group buff
								if possibleSuggestion.TargetProfile and possibleSuggestion.Target then

									-- determine role counts
									for _, someProfile in pairs(thePlayers) do
										-- if: class-scope and class matches, or player-scope and matches, and raid-scope
										if (possibleSuggestion.Scope == BuffBroker.Constants.Scope.Class and possibleSuggestion.TargetProfile.Class == someProfile.Class)
										or (possibleSuggestion.Scope == BuffBroker.Constants.Scope.Player and possibleSuggestion.Target == someProfile.GUID)
										or (possibleSuggestion.Scope == BuffBroker.Constants.Scope.Self and possibleSuggestion.Target == someProfile.GUID)
										or possibleSuggestion.Scope == BuffBroker.Constants.Scope.Raid then
											if not possibleSuggestion.RoleCount[someProfile.Role] then
												possibleSuggestion.RoleCount[someProfile.Role] = 1
											else
												possibleSuggestion.RoleCount[someProfile.Role] = possibleSuggestion.RoleCount[someProfile.Role] + 1
											end
										end -- if: class-scope and class matches, or raid-scope 
									end

									-- determine confidence
									-- if: i can provide the best version
									if bestBuffs[buffLabel] and listContains(bestBuffs[buffLabel].Players, myGUID) then

										-- if: i did this last time
										if coverageBy == myGUID then

											-- I should totally do it this time
											possibleSuggestion.Confidence = BuffBroker.Constants.Confidence.Certain
										-- else: someone ELSE did it last time!
										elseif thePlayers[coverageBy] then
											
											-- if: best-version active
											if listContains(bestBuffs[buffLabel].Players, coverageBy) then
												-- let them keep doing it
												possibleSuggestion.Confidence = BuffBroker.Constants.Confidence.Unlikely

											else
												-- some shitty version active
												possibleSuggestion.Confidence = BuffBroker.Constants.Confidence.Possible
											end

										-- else:  SOMEONE who knows the slot should, but hasn't
										elseif BuffBroker.Constants.BuffSlots[coverageBy] then
											possibleSuggestion.Confidence = BuffBroker.Constants.Confidence.Likely
										end
									else
										
										-- if: i did this last time
										if coverageBy == myGUID then
											-- might as well keep doing it
											possibleSuggestion.Confidence = BuffBroker.Constants.Confidence.Possible
										elseif BuffBroker.Constants.BuffSlots[coverageBy] then
											-- SOMEONE will provide this buff
											possibleSuggestion.Confidence = BuffBroker.Constants.Confidence.Unlikely
										else
											-- no coverage
											possibleSuggestion.Confidence = BuffBroker.Constants.Confidence.Optional
										end
									end
									
									table.insert(sortedSuggestList, possibleSuggestion)
								end -- if: can see anyone for this group buff
							end -- if: anyone wants (and can recieve) this buff
						end -- if: Coverage is by me, my class, or nobody, or we're just not friendly:
					end -- for: each group to scan
				end -- if: check buff scope (single, self, group)
			end -- for: each spell in the slot
		end -- for: each buffslot we could use
		
		if 0 < table.getn(sortedSuggestList) then
			MyDebugPrint("Sorting %d suggestions", table.getn(sortedSuggestList))
			table.sort(sortedSuggestList, OrderSuggestions) -- sort suggestions
		end
		
		-- for: each suggestion
		for i, currentSuggestion in ipairs(sortedSuggestList) do
			-- record which I've already buffed, and note better suggestions as better
			buffLabel = BuffBroker:SpellInfoFromID(currentSuggestion.spellid)
			activeSlotName = nil

			-- for: each buffslot of the player
			for theirSlotName, buffSlot in pairs(thePlayers[myGUID].BuffSlots) do
				-- if: spell in the slot
				if buffSlot[currentSuggestion.spellid] then
					-- use it
					activeSlotName = theirSlotName
					break
				end
			end -- for: each buffslot of the player

			MyDebugPrint("cast %d on %s...", currentSuggestion.spellid, currentSuggestion.Target)
			
			 -- if: one or many target
			if currentSuggestion.Scope == BuffBroker.Constants.Scope.Individual or currentSuggestion.Scope == BuffBroker.Constants.Scope.Self then

				-- calculate if is still active
				buffActive = not BuffBroker:HasExpired(thePlayers[currentSuggestion.Target].ActiveBuffs[buffLabel], myGUID)
				
				-- if: I already cast this buff, and it's still active
				if buffActive 
				and (thePlayers[currentSuggestion.Target].ActiveBuffs[buffLabel])
				and thePlayers[currentSuggestion.Target].ActiveBuffs[buffLabel].CasterGUID == myGUID then
					MyDebugPrint("%d is already active from slot %s", currentSuggestion.spellid, activeSlotName)
					activeSuggestions[currentSuggestion.Target..activeSlotName..currentSuggestion.Scope] = true
					currentSuggestion.BetterActive = true
				else
					-- if: better version is active
					if activeSuggestions[currentSuggestion.Target..activeSlotName..currentSuggestion.Scope] then
						MyDebugPrint("better is already active from slot %s", activeSlotName)
						currentSuggestion.BetterActive = true
					else
						MyDebugPrint("nothing active from us from slot %s", activeSlotName)
						--currentSuggestion.BetterActive = false
					end -- if/else: better version is active
				end -- if/else: I already cast this buff, and it's still active

			elseif currentSuggestion.Scope == BuffBroker.Constants.Scope.Class or currentSuggestion.Scope == BuffBroker.Constants.Scope.Raid then

				if currentSuggestion.Scope == BuffBroker.Constants.Scope.Class then
					currentGroupName = currentSuggestion.TargetProfile.Class
				elseif currentSuggestion.Scope == BuffBroker.Constants.Scope.RAID then
					currentGroupName = BuffBroker.Constants.Classes.Raid
				end
				
				if BuffBroker.Constants.Scope.Class == currentSuggestion.Scope then
					groupsToScan = {}
					for k, v in pairs(BuffBroker.Constants.Classes) do
						groupsToScan[k] = v
					end
					
					groupsToScan.Raid = nil
				elseif BuffBroker.Constants.Scope.Raid == currentSuggestion.Scope then
					groupsToScan.Raid = BuffBroker.Constants.Classes.Raid
				end
				
				-- for: each group to scan
				--for _, currentGroupName in pairs(groupsToScan) do
					-- if: is a totem slot
					if BuffBroker.Constants.Totems[activeSlotName] then

						-- get current totem assignment, and it's matching buff label (MP5, etc)
						_, _, _, currentTotem = GetActionInfo(BuffBroker.Constants.Totems[activeSlotName])
						currentTotemLabel, currentTotemSlot = BuffBroker:SpellInfoFromID(currentTotem)

						-- if: check label match (ie: both MP5), existing slot name (ie: better air totem suggested)
						if currentTotemLabel and buffLabel and currentTotemLabel == buffLabel then
							-- label is same;  keep current!
							currentSuggestion.BetterActive = true
							activeSuggestions[currentSuggestion.Target..activeSlotName..currentSuggestion.Scope] = true
						elseif activeSuggestions[currentSuggestion.Target..activeSlotName..currentSuggestion.Scope] then
							-- better totem active of same type (say, better air totem)
							currentSuggestion.BetterActive = true
						end -- if: check label match, existing slot name
					else
						coverageBy = BuffBroker:CheckCoverage(theCoverage, currentGroupName, buffLabel)
						-- if: i've called dibs on this slot already
						if coverageBy == myGUID then
							-- for raid-wide buffs:  NEVER claim active is best!  let the thresholds figure that out later :)
							activeSuggestions[currentSuggestion.Target..activeSlotName..currentSuggestion.Scope] = true
							--currentSuggestion.BetterActive = false
							MyDebugPrint("active spell is one I'm covering from our slot %s on %s", activeSlotName, currentGroupName)
						else
							-- if: better version is active
							if activeSuggestions[currentSuggestion.Target..activeSlotName..currentSuggestion.Scope] then
								MyDebugPrint("better is already active from our slot %s on %s", activeSlotName, currentGroupName)
								currentSuggestion.BetterActive = true
							end -- if/else: better version is active
						end -- if/else: I already cast this buff, and it's still active
					end -- if: is a totem slot
				--end -- for: each group to scan
			end -- if: one or many target
		end
	end -- if: I'm profiled/cached
	
	return sortedSuggestList
end

function BuffBroker:SlotContainsLabel(theSlot, theLabel)
	local containsLabel = nil
	
	for spellID in pairs(theSlot) do
		if theLabel == BuffBroker:SpellInfoFromID(spellID) then
			containsLabel = true
			break
		end
	end
	
	return containsLabel
end

function BuffBroker:GetHighestSpellID(spellid)
	local name
	local highestSpellID = spellid
	local spellLink
	local markStart
	local markEnd
	local subLink
	local numberedLink
	
	name = GetSpellInfo(spellid)
	
	-- if: can get a name
	if name then
		-- get a weirdly formatted link to the spell
		spellLink = GetSpellLink(name)
		
		if spellLink then
			-- parse out the spellid text
			markStart, markEnd = string.find(spellLink, '\:[^\|]*')
			
			-- if: link contains a spellid (it should!)
			if markStart and markEnd then
				-- cut out the ID, as a #
				subLink = string.sub(spellLink, markStart + 1, markEnd)
				highestSpellID = tonumber(subLink)
			end -- if: link contains a spellid (it should!)
		end
	end -- if: can get a name
	
	return highestSpellID
end

function BuffBroker:SetCoverage(group, label, source, slot)

	local curLabel
	local curData
	
	if group and label then
		if not BuffList.Coverage then
			BuffList.Coverage = {}
		end
		
		if not BuffList.Coverage[group] then
			BuffList.Coverage[group] = {}
		end

		if not BuffList.Coverage[group][label]
		or BuffList.Coverage[group][label].Source ~= source
		or BuffList.Coverage[group][label].Slot ~= slot then
			-- for: each coveraged buff label/type
			for curLabel, curData in pairs(BuffList.Coverage[group]) do
				-- if: mutually exclusive with new coverage
				if curData.Slot == slot and curData.Source == source then
					BuffList.Coverage[group][curLabel] = nil
				end -- if: mutually exclusive with new coverage
			end -- for: each coveraged buff label/type

			BuffList.Coverage[group][label] = {Source = source, Slot = slot}
		end
	end
end

function BuffBroker:CheckCoverage(theCoverage, group, label)
	local coverageBy = nil
	
	if theCoverage and label then
		if theCoverage[BuffBroker.Constants.Classes.Raid] and theCoverage[BuffBroker.Constants.Classes.Raid][label] then
			coverageBy = theCoverage[BuffBroker.Constants.Classes.Raid][label].Source
		elseif group and theCoverage[group] and theCoverage[group][label] then
			coverageBy = theCoverage[group][label].Source
		end
	end
	
	return coverageBy
end

function BuffBroker:GetBuffStrength(thePlayers, casterGUID, buffLabel)
	-- activeBuff: caster, spellid, expiration
	local buffStrength = BuffBroker.Constants.Buffs.None
	local casterProfile

	if thePlayers and casterGUID then
		-- lookup Caster index
		casterProfile = thePlayers[casterGUID]
		
		-- if: have caster data
		if casterProfile then

			if casterProfile.CastableBuffs[buffLabel] then
				buffStrength = casterProfile.CastableBuffs[buffLabel]
			end
		end -- if: have caster data
	end
	
	return buffStrength
end

function BuffBroker:ScanActiveAll()
	local targetGUID
	local aurasChanged
	
	-- for: each cached player
	for targetGUID, _ in pairs(BuffList.Players) do

		if self:ScanActive(targetGUID) then
			aurasChanged = true
		end
	end -- for: each cached player
	
	return aurasChanged
end

function BuffBroker:ScanActive(GUIDToScan)
	local playerProfile
	local targetProfile
	local auraName = 'placeholder'
	local casterGUID
	local iBuff = 1
	local Nowish = GetTime()
	local buffLabel
	local buffSlot
	local expires, caster, spellid
	local someLabel
	local activeChanged
	local anyChanged
	local scope
	local hasOldExpired
	local oldExpires
	local buffStillActive = {}
	local obscured = nil
	
	playerProfile = BuffList.Players[BuffList.PlayerGUID]
	targetProfile = BuffList.Players[GUIDToScan]

	-- if: target profiled
	if targetProfile then
		-- scan potential raid-buffs

		-- while: haven't run out of auras
		while auraName and not (iBuff > BuffBroker.Constants.MaxBuffSlots) do
			activeChanged = nil
			casterGUID = nil
			
			-- profile group buffs
			auraName, _, _, _, _, _, expires, caster, _, _, spellid = UnitAura(targetProfile.Name, iBuff, 'HELPFUL')

			-- if: valid, cast by a player we're interested in
			if auraName then
				-- if: cast by someone we're watching
				if caster and BuffList.Players[UnitGUID(caster)] then
					casterGUID = UnitGUID(caster)
				end
				
				buffLabel, buffSlot, scope = BuffBroker:SpellInfoFromID(spellid)
				
				-- if: is a buff we're monitoring
				if buffLabel then
					-- still active!
					buffStillActive[buffLabel] = true

					MyDebugPrint("%s is label type %s", auraName, buffLabel)

					-- if: new cast, never been profiled
					if not targetProfile.ActiveBuffs[buffLabel] then
						targetProfile.ActiveBuffs[buffLabel] = {
							CasterGUID = casterGUID,
							Spellid = spellid,
							Expires = expires,
						}
						
						targetProfile.ActiveBuffs[buffLabel].Strength = BuffBroker:GetBuffStrength(BuffList.Players, casterGUID, buffLabel)
						activeChanged = true
					
					-- else: already cached, check for updates
					else
						-- record if old state is "expired", and insert new expiration (for comparator)
						hasOldExpired = BuffBroker:HasExpired(targetProfile.ActiveBuffs[buffLabel], BuffList.PlayerGUID)
						oldExpires = targetProfile.ActiveBuffs[buffLabel].Expires
						targetProfile.ActiveBuffs[buffLabel].Expires = expires

						if casterGUID ~= targetProfile.ActiveBuffs[buffLabel].CasterGUID
						or spellid ~= targetProfile.ActiveBuffs[buffLabel].Spellid
						or hasOldExpired ~= BuffBroker:HasExpired(targetProfile.ActiveBuffs[buffLabel], BuffList.PlayerGUID) then
							-- genuine new state!  finish updating aura info
							targetProfile.ActiveBuffs[buffLabel].Spellid = spellid
							targetProfile.ActiveBuffs[buffLabel].CasterGUID = casterGUID

							activeChanged = true
						else
							-- revert aura info to prior state
							targetProfile.ActiveBuffs[buffLabel].Expires = oldExpires
						end
					end
					
					-- note the coverage
					if scope == BuffBroker.Constants.Scope.Class then
						BuffBroker:SetCoverage(targetProfile.Class, buffLabel, casterGUID, buffSlot)
					elseif scope == BuffBroker.Constants.Scope.Raid then
						BuffBroker:SetCoverage(BuffBroker.Constants.Classes.Raid, buffLabel, casterGUID, buffSlot)
					elseif scope == BuffBroker.Constants.Scope.Self and GUIDToScan == BuffList.PlayerGUID then
						if activeChanged then
							profileDB.activeSelfBuffs[BuffBroker.TalentGroup][buffLabel] = spellid
						end
					end
				end -- if: is a buff we're monitoring

				if spellid == 69378 then -- Forgotten Kings
					targetProfile.ActiveBuffs[L["STATS"]] = {CasterGUID = casterGUID, Spellid = spellid, Expires = expires}

					-- If caster's in the raid
					if BuffList.Players[casterGUID] then
					
						-- note that they can do this buff!
						BuffList.Players[casterGUID].BuffSlots[L["PROFESSION_STATS"]] = BuffList.Constants.BuffSlots[L["PROFESSION_STATS"]]
					end -- If caster's in the raid
				end -- Forgotten Kings
					
				-- if: stance/form changing (ignore casters)
				if BuffBroker.Constants.Forms[spellid]
				and BuffList.Players[GUIDToScan].Role ~= BuffBroker.Constants.Roles.Caster 
				and BuffList.Players[GUIDToScan].Role ~= BuffBroker.Constants.Roles.Healer then
					-- changed to/from tank spec
					if BuffBroker.Constants.Forms[spellid] == BuffBroker.Constants.Roles.Tank
					and BuffList.Players[GUIDToScan].Role ~= BuffBroker.Constants.Roles.Tank then
						-- is becoming a tank (DK, Warrior, Bear, Tankadin)
						BuffList.Players[GUIDToScan].OldRole = BuffList.Players[GUIDToScan].Role
						BuffList.Players[GUIDToScan].Role = BuffBroker.Constants.Roles.Tank
						activeChanged = true
					elseif BuffBroker.Constants.Forms[spellid] == BuffBroker.Constants.Roles.PureMelee 
					and BuffList.Players[GUIDToScan].Role == BuffBroker.Constants.Roles.Tank then
						-- is becoming a PureMelee (DK, Warrior, Cat)
						BuffList.Players[GUIDToScan].Role = BuffList.Players[GUIDToScan].OldRole
						activeChanged = true
					end

				end -- if: stance/form changing (ignore casters)
				
				-- if: phase-shifted imp
				if BuffBroker:IsObscured(spellid) then
					obscured = true
				end -- if: phase-shifted imp
			end -- if: valid, cast by a player we're interested in
		
			if activeChanged then
				anyChanged = true
			end
			
			iBuff = iBuff + 1
		end -- while: haven't run out of auras

		if iBuff > BuffBroker.Constants.MaxBuffSlots then MyDebugPrint("searched past end of spell IDs;  maybe all buff slots are used?") end

		-- for: each active buff
		for someLabel, someActiveBuff in pairs(targetProfile.ActiveBuffs) do
			-- elseif: buff is no longer listed as an aura
			if not buffStillActive[someLabel] then
				-- mark as expired

				-- if: caster not in the party
				if not BuffList.Players[someActiveBuff.CasterGUID] then
					-- we can't count on them re-activating their buff
					targetProfile.ActiveBuffs[someLabel] = nil
				else
					targetProfile.ActiveBuffs[someLabel].Expires = GetTime() - 1
					targetProfile.ActiveBuffs[someLabel].Strength = BuffBroker.Constants.Buffs.None
				end
				
				anyChanged = true

			end -- if/elsif: buffs are expired or orphaned
		end -- for: each active buff

		if BuffList.Players[GUIDToScan].Obscured ~= obscured then
			activeChanged = true
			BuffList.Players[GUIDToScan].Obscured = obscured
		end
	end -- if: target profiled

	return anyChanged
end

function BuffBroker:IsObscured(spellid)
	return (spellid == 4511) -- phase shifted imp
end

function BuffBroker:ScanAvailable()

	self:RefreshPlayers()
end

function BuffBroker:RefreshPlayers()
	-- ensure cached names match current party/raid
	local i, iTooFar = 0, 0
	local partyMembers,isRaid
	local prefix, numMembers
	local targetGUID, targetProfile, petGUID, petProfile
	local oldTargetIndex
	local iterGUID, iterNext
	local rosterChanged = nil
	local labelName
	local spellID
	
	if not BuffList.InspectPending then
		BuffList.InspectComplete = nil
		BuffList.InspectTarget = nil
		
		targetGUID = UnitGUID('player')
		-- if: never seen before
		if not BuffList.Players[targetGUID] then
		
			-- if: player not yet cached in party
			targetGUID, targetProfile = self:ProfileUnit('player')
			petGUID, petProfile = self:ProfileUnit('playerpet')

			-- if: able to profile
			if targetProfile then

				-- if: new to the cache
				if not BuffList.Players[UnitGUID('player')] then
				
					BuffList.Players[targetGUID] = targetProfile
					BuffList.PlayerCount = BuffList.PlayerCount + 1
					BuffList.PlayerGUID = targetGUID
					
					-- seed last-seen self buffs on self
					for labelName, spellID in pairs(profileDB.activeSelfBuffs[BuffBroker.TalentGroup]) do
						targetProfile.ActiveBuffs[labelName] = {CasterGUID = targetGUID, Spellid = spellID, Expires = GetTime() - 1}
					end
					
					-- parse auras on unit
					self:ScanActive(targetGUID)

					-- if: target has pet
					if petGUID and not BuffList.Players[petGUID] then
						-- Add pet, scan buffs, mark for inspection
						BuffList.Players[targetGUID].PetGUID = petGUID
						BuffList.Players[petGUID] = petProfile
						BuffList.PlayerCount = BuffList.PlayerCount + 1

						-- parse auras on unit
						self:ScanActive(petGUID)
					end -- if: target has pet

					rosterChanged = true
				end -- if: new to the cache
			end -- if: able to profile
		end -- if: never seen before

		-- if: in group, not inspected, and not waiting for inspection
		if BuffList.Players[targetGUID] and BuffList.Players[targetGUID].Stale and not listContains(BuffList.StalePlayers, targetGUID) then
			table.insert(BuffList.StalePlayers, targetGUID)
		end -- if: in group, not inspected, and not waiting for inspection

		-- Build the Bufflist.Players as 'potential buffers';  it will
		-- act as an L'inspect' list for a later mechanism
		numMembers = GetNumRaidMembers()
		prefix = 'raid'
		
		if 0 == numMembers then
			numMembers = GetNumPartyMembers()
			prefix = 'party'
		end
		
		-- for: each REAL party member
		for i=1,numMembers do
			
			targetGUID = UnitGUID(prefix..i)

			-- if: never seen before
			if not BuffList.Players[targetGUID] then
			
				-- perform a shallow-profile (name, class, ...)
				targetGUID, targetProfile = self:ProfileUnit(prefix..i)
				petGUID, petProfile = self:ProfileUnit(prefix..'pet'..i)
				
				-- if: able to profile
				if targetProfile then
					
					-- if: new to cache
					if not BuffList.Players[targetGUID] then
						-- Add player, scan buffs, mark for inspection
						BuffList.Players[targetGUID] = targetProfile
						BuffList.PlayerCount = BuffList.PlayerCount + 1

						-- parse auras on unit
						self:ScanActive(targetGUID)

						-- if: target has pet
						if petGUID and not BuffList.Players[petGUID] then
							-- Add pet, scan buffs, mark for inspection
							BuffList.Players[targetGUID].PetGUID = petGUID
							BuffList.Players[petGUID] = petProfile
							BuffList.PlayerCount = BuffList.PlayerCount + 1

							-- parse auras on unit
							self:ScanActive(petGUID)
						end -- if: target has pet
						
						rosterChanged = true
					end -- if: new to the cache
				end -- if: able to profile
			else
				-- check visibility (players only)
				if not UnitIsVisible(BuffList.Players[targetGUID].Name) and BuffList.Players[targetGUID].Type == BuffBroker.Constants.Types.Player then
					-- outside area of interest/events:  mark for full scan when near us
					BuffList.Players[targetGUID].Stale = true
				end -- check visibility
			end -- if: never seen before

			-- if: in group, not inspected, and not waiting for inspection
			if BuffList.Players[targetGUID] and BuffList.Players[targetGUID].Stale and not listContains(BuffList.StalePlayers, targetGUID) then
				-- mark for talent scan
				table.insert(BuffList.StalePlayers, targetGUID)
			end -- mark for talent scan

		end -- for: each REAL party member

		-- remove players who left
		iterGUID, currentProfile = next(BuffList.Players, nil)
		
		-- for: each cached party member
		while iterGUID and not (iTooFar > BuffBroker.Constants.MaxPlayers) do
			iterNext, nextProfile = next(BuffList.Players, iterGUID)
			
			-- if: not in raid/party
			if currentProfile.Type == BuffBroker.Constants.Types.Player
			and not UnitInParty(currentProfile.Name)
			and not UnitInRaid(currentProfile.Name) then
				-- stop tracking unit
				MyDebugPrint("removing %s; left party/raid", currentProfile.Name)
				if BuffList.Players[iterGUID].PetGUID and BuffList.Players[BuffList.Players[iterGUID].PetGUID] then
					BuffList.Players[BuffList.Players[iterGUID].PetGUID] = nil
					BuffList.PlayerCount = BuffList.PlayerCount - 1
				end
				
				BuffList.Players[iterGUID] = nil
				BuffList.PlayerCount = BuffList.PlayerCount - 1

				rosterChanged = true
			end -- if: not in raid/party
			
			-- next entry
			iterGUID = iterNext
			currentProfile = nextProfile
			
			iTooFar = iTooFar + 1
		end -- for: each cached party member
		
		-- if: players left/joined/respec'd
		if rosterChanged then
			-- remove auras the (now absent) dudes cast; account for new dudes
			if BuffBroker:ScanActiveAll() then

				-- update suggestions
				BuffBroker:RegenerateSuggestionDependencies()
				self:AssignNextSuggestion()
			end
		end
	end
end

function BuffBroker:RegenerateSuggestionDependencies()
	local changedProviders
	local changedRoles
	local changedCoverage
	local changedRange
	
	if BuffList.PlayerCount > 0 and BuffList.PlayerGUID and not BuffList.Players[BuffList.PlayerGUID].Stale then
		BuffList.ProfiledBuffProviders, changedProviders = self:ProfileBest(BuffList.Players)
		BuffList.Classes, changedRoles = self:UpdateRoleCount(BuffList.Players, BuffList.Classes)
		BuffList.Coverage, changedCoverage = self:UpdateCoverage(BuffList.Players, BuffList.Coverage)
		BuffList.Classes, changedRange = self:UpdateRangeCheck(BuffList.Players, BuffList.Classes)

		BuffList.Suggestions = self:BuildSuggestList(BuffList.Players, BuffList.Classes, BuffList.Coverage, BuffList.ProfiledBuffProviders, BuffList.PlayerGUID)
		BuffList.LastSuggested = nil
	end
end

function BuffBroker:UpdateCoverage(thePlayers, theLabelCoverage)
	
	local buffSlotCount = {} -- ['SLOT_NAME'] = {Labels = {MP5, AP, etc}, LabelCount, ProviderCount = #, Covered = true/false}
	-- theLabelCoverage: {THORNS = class, FORT = class, SHOUT = player, etc}
	local coverageChanged = true
	local currentCoverageCount = 0
	local someProvider
	
	local tooFar = 100
	local i = 0

	-- for: each group
	for _, className in pairs(BuffBroker.Constants.Classes) do
		-- if: no container
		if not theLabelCoverage[className] then
			theLabelCoverage[className] = {}
		end -- if: no container
	
		-- for: reset each label covered for current group
		for labelName, labelCoveredBy in pairs(theLabelCoverage[className]) do
			-- if: covered by a slot
			if BuffBroker.Constants.BuffSlots[labelCoveredBy.Source] then
				-- covered by a slot;  reset, will recalculate below
				theLabelCoverage[className][labelName] = nil
			
			elseif not thePlayers[labelCoveredBy.Source] then
				-- covered by player, who left the party
				theLabelCoverage[className][labelName] = nil
			end -- if: covered by a class
		end -- for: reset each label covered for current group
	end -- for: each group
	
	-- for: build slot coverage from players
	for playerName, playerProfile in pairs(thePlayers) do
		-- for: each buffslot of the player
		for slotName, slotSpells in pairs(playerProfile.BuffSlots) do

			-- if: first time seeing this slot
			if not buffSlotCount[slotName] then
				-- seed slot data to 0
				buffSlotCount[slotName] = {Labels = {}, Providers = {}, ProviderCount = 0, LabelCount = 0, Covered = false}
			end

			-- count player as a provider (of their current buffslot)
			buffSlotCount[slotName].ProviderCount = buffSlotCount[slotName].ProviderCount + 1
			table.insert(buffSlotCount[slotName].Providers, playerName)

			-- for: each entry in buffslot
			for currentSlotID, currentSlotSpell in pairs(slotSpells) do
				buffLabel = BuffBroker:SpellInfoFromID(currentSlotID)

				-- if: label new to the slot, and applies to friendlies, and can be cast by this playerName
				if not buffSlotCount[slotName].Labels[buffLabel]
				and currentSlotSpell.Scope ~= BuffBroker.Constants.Scope.Self
				and not (currentSlotSpell.MinLevel > playerProfile.Level) then
					-- seed extra label
					buffSlotCount[slotName].LabelCount = buffSlotCount[slotName].LabelCount + 1
					buffSlotCount[slotName].Labels[buffLabel] = true
				end -- if: label new to the slot (and applies to friendlies)
			end -- for: each entry in buffslot
		end -- for: each buffslot of the player
	end -- for: build slot coverage from players

	-- at this point we know:
	-- how many people know each buffslot (ie: 2 paladins know BLESSINGS)
	-- the unique labels of each buffslot (ie: AP, STATS, MP5)
	-- how many unique labels are in each buffslot (ie: 3 blessings)
	
	-- while: coverage changed
	while coverageChanged and i < tooFar do
		coverageChanged = false
		
		-- for: each player
		for playerName, playerProfile in pairs(thePlayers) do
			-- for: each buffslot of the player
			for slotName, slotSpells in pairs(playerProfile.BuffSlots) do
				
				-- for: each class
				for _, className in pairs(BuffBroker.Constants.Classes) do

					-- if: slot isn't fully covered yet
					if buffSlotCount[slotName].ProviderCount < buffSlotCount[slotName].LabelCount then

						currentCoverageCount = 0
						
						-- for: each label of the slot
						for currentLabel, _ in  pairs(buffSlotCount[slotName].Labels) do
							if theLabelCoverage
							and theLabelCoverage[className]
							and theLabelCoverage[className][currentLabel] then
								someProvider = theLabelCoverage[className][currentLabel].Source
							end
							
							-- if: label is covered by a not-provider (ie: if checking BLESSINGS, discount AP by somepaladin...but count AP by SHOUTS)
							if someProvider and not listContains(buffSlotCount[slotName].Providers, someProvider) then
								-- add to covered count
								currentCoverageCount = currentCoverageCount + 1
							end -- if: label is covered
						end -- for: each label of the slot
						
						-- if: slot wasn't covered, and now is
						if (currentCoverageCount < buffSlotCount[slotName].LabelCount)
						and not ( ( buffSlotCount[slotName].ProviderCount + currentCoverageCount ) < buffSlotCount[slotName].LabelCount) then
							-- for: each Label (of the slot)
							for currentLabel, _ in pairs(buffSlotCount[slotName].Labels) do
								--  if: no entry in theLabelCoverage for label
								if not theLabelCoverage[className][currentLabel] then
									-- mark label as covered by this buffslot
									-- TODO:  double-hitting shamans!
									theLabelCoverage[className][currentLabel] = {Source = slotName, Slot = slotName}
									coverageChanged = true
								end --  if: no entry in buffLabelCoverage for label
							end -- for: each buffSlotCount[N].Labels in named buffslot
						end -- if: slot wasn't covered, and now is
					else
						-- for: each Label (of the slot)
						for currentLabel, _ in pairs(buffSlotCount[slotName].Labels) do
							--  if: no entry in theLabelCoverage for label
							if not theLabelCoverage[className][currentLabel] then
								-- mark label as covered by this buffslot
								-- TODO:  double-hitting shamans!
								theLabelCoverage[className][currentLabel] = {Source = slotName, Slot = slotName}
								coverageChanged = true
							end --  if: no entry in buffLabelCoverage for label
						end -- for: each buffSlotCount[N].Labels in named buffslot
					end -- if: slot isn't fully covered yet
				end -- for: each class
			end -- for: each buffslot of the player
		end -- for: each player
		
		i = i + 1
	end -- while: coverage changed

	if (i == tooFar) then print(L["catastrophic mistake;  coverage not completing"]) end
	
	return theLabelCoverage
end

function BuffBroker:ParseGUID(unitGUID)
	local typeID
	local unitID
	
	if unitGUID and string.len(unitGUID) > 15 then
		typeID = tonumber(string.sub(unitGUID, 5, 5)) % 8
		
		unitID = string.sub(unitGUID, 6, 12)
	end
	
	return typeID, unitID
end

function BuffBroker:ProfileUnit(toProfile)
	local targetPlayer = nil
	local unknownSpells = {}
	local theirClass
	local theirFamily
	local theirType
	local theirLevel = UnitLevel(toProfile)
	local theirName = UnitName(toProfile)
	local typeID
	local theirGUID = UnitGUID(toProfile)
	
	if theirGUID then
		typeID = BuffBroker:ParseGUID(theirGUID)
		
		_, theirClass = UnitClass(toProfile)
		theirFamily = UnitCreatureFamily(toProfile)
		
		-- if: online
		if UnitIsConnected(toProfile)
		and theirLevel > 0
		and theirName
		and theirClass
		and UnitIsVisible(theirName) then

		-- TODO:  Check for secondary role on zone-change, based on
		-- isTank, isHeal, isDPS = UnitGroupRolesAssigned(unitid)

			if (typeID == BuffBroker.Constants.Types.CombatPet or typeID == BuffBroker.Constants.Types.Player) then
				MyDebugPrint("lpally: profiling %s", toProfile)
				targetPlayer = {
					Name = theirName,
					Class = theirClass,
					Type = typeID,
					Level = theirLevel,
					Role = BuffBroker.Constants.Roles.Unknown,
					Inspected = nil,
					BuffSlots = {},
					CastableBuffs = {},
					ActiveBuffs = {},
					LOS = true,
					Stale = true,
					ActiveTalentGroup = BuffBroker.Constants.TalentGroup.Unknown,
				}
				
				-- for: seeding each type of castable buff
				for labelName, _ in pairs(BuffList.DownRankLookup) do
					targetPlayer.CastableBuffs[labelName] = BuffBroker.Constants.Buffs.None
				end -- for: seeding each type of castable buff

				-- if: pet or player
				if typeID == BuffBroker.Constants.Types.Player then -- else: player
				
					-- determine spec-independent roles and buffs
					if theirClass == BuffBroker.Constants.Classes.Mage then
						if targetPlayer.Level < profileDB.healerLevel then
							-- doesn't have decent regeneration model yet (evocate is terribad until higher levels)
							targetPlayer.Role = BuffBroker.Constants.Roles.Healer
						else
							targetPlayer.Role = BuffBroker.Constants.Roles.Caster
						end

						targetPlayer.Role = BuffBroker.Constants.Roles.Caster
						targetPlayer.CastableBuffs["INTELLECT"] = BuffBroker.Constants.Buffs.Basic
						targetPlayer.BuffSlots["AI"] = BuffBroker.Constants.BuffSlots["AI"]
						targetPlayer.CastableBuffs["MAGE_ARMOR"] = BuffBroker.Constants.Buffs.Basic
						targetPlayer.BuffSlots["MAGE_ARMOR"] = BuffBroker.Constants.BuffSlots["MAGE_ARMOR"]
					elseif theirClass == BuffBroker.Constants.Classes.Priest then
						targetPlayer.Role = BuffBroker.Constants.Roles.Caster
						targetPlayer.CastableBuffs["STAMINA"] = BuffBroker.Constants.Buffs.Basic
						targetPlayer.BuffSlots["FORTITUDE"] = BuffBroker.Constants.BuffSlots["FORTITUDE"]
						targetPlayer.CastableBuffs["SPIRIT"] = BuffBroker.Constants.Buffs.Basic
						targetPlayer.BuffSlots["SPIRIT"] = BuffBroker.Constants.BuffSlots["SPIRIT"]
						targetPlayer.CastableBuffs["PRIEST_INNER"] = BuffBroker.Constants.Buffs.Basic
						targetPlayer.BuffSlots["PRIEST_INNER"] = BuffBroker.Constants.BuffSlots["PRIEST_INNER"]
						targetPlayer.CastableBuffs["PRIEST_FORM"] = BuffBroker.Constants.Buffs.Basic
						targetPlayer.BuffSlots["PRIEST_FORM"] = BuffBroker.Constants.BuffSlots["PRIEST_FORM"]
						targetPlayer.CastableBuffs["SHADOW_RESIST"] = BuffBroker.Constants.Buffs.Basic
						targetPlayer.BuffSlots["PRIEST_PROTECTION"] = BuffBroker.Constants.BuffSlots["PRIEST_PROTECTION"]
					elseif theirClass == BuffBroker.Constants.Classes.Druid then
						targetPlayer.Role = BuffBroker.Constants.Roles.Caster
						targetPlayer.CastableBuffs["WILD"] = BuffBroker.Constants.Buffs.Basic
						targetPlayer.BuffSlots["WILD"] = BuffBroker.Constants.BuffSlots["WILD"]
						targetPlayer.CastableBuffs["THORNS"] = BuffBroker.Constants.Buffs.Basic
						targetPlayer.BuffSlots["THORNS"] = BuffBroker.Constants.BuffSlots["THORNS"]
						targetPlayer.CastableBuffs["OWL_FORM"] = BuffBroker.Constants.Buffs.Basic
						targetPlayer.CastableBuffs["TREE_FORM"] = BuffBroker.Constants.Buffs.Basic
						targetPlayer.BuffSlots["SHAPESHIFT"] = BuffBroker.Constants.BuffSlots["SHAPESHIFT"]
					elseif theirClass == BuffBroker.Constants.Classes.Warlock then
						if targetPlayer.Level < 62 then
							-- doesn't have fel armor yet
							targetPlayer.Role = BuffBroker.Constants.Roles.Healer
						else
							targetPlayer.Role = BuffBroker.Constants.Roles.Caster
						end

						targetPlayer.CastableBuffs["WARLOCK_ARMOR"] = BuffBroker.Constants.Buffs.Basic
						targetPlayer.BuffSlots["WARLOCK_ARMOR"] = BuffBroker.Constants.BuffSlots["WARLOCK_ARMOR"]
					elseif theirClass == BuffBroker.Constants.Classes.Rogue then
						targetPlayer.Role = BuffBroker.Constants.Roles.PureMelee
					elseif theirClass == BuffBroker.Constants.Classes.Deathknight then
						targetPlayer.Role = BuffBroker.Constants.Roles.PureMelee
						targetPlayer.CastableBuffs["STRENGTH_AGILITY"] = BuffBroker.Constants.Buffs.Basic
						targetPlayer.BuffSlots["HORNS"] = BuffBroker.Constants.BuffSlots["HORNS"]
					elseif theirClass == BuffBroker.Constants.Classes.Hunter then
						if targetPlayer.Level < 20 then
							-- doesn't have aspect of the viper yet
							targetPlayer.Role = BuffBroker.Constants.Roles.MeleeMana_Low
						else
							targetPlayer.Role = BuffBroker.Constants.Roles.MeleeMana
						end
						
					elseif theirClass == BuffBroker.Constants.Classes.Shaman then
						targetPlayer.CastableBuffs["MP5"] = BuffBroker.Constants.Buffs.Basic
						targetPlayer.CastableBuffs["HP5"] = BuffBroker.Constants.Buffs.Basic
						targetPlayer.CastableBuffs["ARMOR"] = BuffBroker.Constants.Buffs.Basic
						targetPlayer.CastableBuffs["STRENGTH_AGILITY"] = BuffBroker.Constants.Buffs.Basic
						targetPlayer.CastableBuffs["SOLO_FIRE_TOTEM"] = BuffBroker.Constants.Buffs.Basic
						targetPlayer.CastableBuffs["FLAT_SPELL"] = BuffBroker.Constants.Buffs.Basic
						targetPlayer.CastableBuffs["MELEE_HASTE"] = BuffBroker.Constants.Buffs.Basic
						targetPlayer.CastableBuffs["SPELL_HASTE"] = BuffBroker.Constants.Buffs.Basic
						targetPlayer.BuffSlots["WATER_TOTEMS"] = BuffBroker.Constants.BuffSlots["WATER_TOTEMS"]
						targetPlayer.BuffSlots["EARTH_TOTEMS"] = BuffBroker.Constants.BuffSlots["EARTH_TOTEMS"]
						targetPlayer.BuffSlots["FIRE_TOTEMS"] = BuffBroker.Constants.BuffSlots["FIRE_TOTEMS_BASIC"]
						targetPlayer.BuffSlots["AIR_TOTEMS"] = BuffBroker.Constants.BuffSlots["AIR_TOTEMS"]
					elseif theirClass == BuffBroker.Constants.Classes.Warrior then
						targetPlayer.Role = BuffBroker.Constants.Roles.PureMelee
						targetPlayer.CastableBuffs["AP"] = BuffBroker.Constants.Buffs.Basic
						targetPlayer.CastableBuffs["HP"] = BuffBroker.Constants.Buffs.Basic
						targetPlayer.BuffSlots["SHOUTS"] = BuffBroker.Constants.BuffSlots["SHOUTS"]
					elseif theirClass == BuffBroker.Constants.Classes.Paladin then
						targetPlayer.CastableBuffs["AP"] = BuffBroker.Constants.Buffs.BasicLong
						targetPlayer.CastableBuffs["STATS"] = BuffBroker.Constants.Buffs.BasicLong
						targetPlayer.CastableBuffs["MP5"] = BuffBroker.Constants.Buffs.BasicLong
						targetPlayer.CastableBuffs["PALADIN_SEAL"] = BuffBroker.Constants.Buffs.Basic
						targetPlayer.CastableBuffs["RIGHTEOUS_FURY"] = BuffBroker.Constants.Buffs.Basic
						
						targetPlayer.BuffSlots["BLESSINGS"] = BuffBroker.Constants.BuffSlots["BLESSINGS_BASIC"]
						targetPlayer.BuffSlots["SEALS"] = BuffBroker.Constants.BuffSlots["SEALS"]
						targetPlayer.BuffSlots["RIGHTEOUS_FURY"] = BuffBroker.Constants.BuffSlots["RIGHTEOUS_FURY"]
					end
				elseif typeID == BuffBroker.Constants.Types.CombatPet then -- is permanentpet
					targetPlayer.Stale = false
					targetPlayer.Inspected = true
					
					if targetPlayer.Class == BuffBroker.Constants.Classes.Paladin then
						targetPlayer.Role = BuffBroker.Constants.Roles.MeleeMana
					elseif targetPlayer.Class == BuffBroker.Constants.Classes.Warrior then
						targetPlayer.Role = BuffBroker.Constants.Roles.PureMelee
					elseif targetPlayer.Class == BuffBroker.Constants.Classes.Mage then
						targetPlayer.Role = BuffBroker.Constants.Roles.Caster
					end

					if UnitCreatureType(toProfile) == L["Demon"] then
						if UnitCreatureFamily(toProfile) == L["Voidwalker"] then
							targetPlayer.Class = BuffBroker.Constants.Classes.Warrior
						elseif UnitCreatureFamily(toProfile) == L["Felguard"] then
							targetPlayer.Class = BuffBroker.Constants.Classes.Warrior
						elseif UnitCreatureFamily(toProfile) == L["Imp"] then
							targetPlayer.Class = BuffBroker.Constants.Classes.Warlock
						elseif UnitCreatureFamily(toProfile) == L["Felhunter"] then
							targetPlayer.Class = BuffBroker.Constants.Classes.Warlock
						elseif UnitCreatureFamily(toProfile) == L["Succubus"] then
							targetPlayer.Class = BuffBroker.Constants.Classes.Warlock
						end
					elseif UnitCreatureType(toProfile) == L["Beast"] then
						targetPlayer.Class = BuffBroker.Constants.Classes.Warrior
					end
					-- NOTE:  BuffSlots will be auto-filled in if/when they're found as auras
					-- i.e. for Imp, Felguard, or talented felhunter...or beasts in cataclysm
					
				end -- if: check if pet or player
			elseif typeID ~= BuffBroker.Constants.Types.NPC
			and typeID ~= BuffBroker.Constants.Types.Vehicle then -- is permanentpet
				-- TODO:  Handle NPC pets made permanent (ghoul via talent, water elemental via glyph)
				BuffBroker:SetFailCode("buffbroker error: found party member who isn't a player, pet, or vehicle! please notify author of this player/guid: "..toProfile.." - "..UnitGUID(toProfile))
			end -- if: controlled, permanent GUID
		end -- if: online
	end -- if: has a GUID
	
	return UnitGUID(toProfile), targetPlayer
end

function BuffBroker:CopySlot(slotToCopy)
	local newBuffSlot = {}
	local tempSlotData
	
	for slotID, slotData in pairs(slotToCopy) do
		tempSlotData = {
			Score = slotData.Score,
			Target = slotData.Target,
			Scope = slotData.Scope,
		
		}
		
		newBuffSlot[slotID] = tempSlotData
	end
	
	return newBuffSlot
end

function BuffBroker:NextInspect()
	local iNumChecks = 0
	local iInspectIndex
	local staleGUID, iterPlayer
	local nextPlayer, iterNext
	local iTooFar = 0
	
	if BuffList.InspectTarget and not BuffList.InspectPending then
		MyDebugPrint("Next Inspect: have inspectTarget & not pending")
		-- Prune not-stale entries
		iterPlayer, staleGUID = next(BuffList.StalePlayers, nil)
		
		-- while: not at end of stale list
		while iterPlayer and not (iTooFar > BuffBroker.Constants.MaxPlayers) do
			iterNext, nextPlayer = next(BuffList.StalePlayers, iterPlayer)
			
			-- if: player not cached, already inspected, or a pet
			if not BuffList.Players[staleGUID]
			or not BuffList.Players[staleGUID].Stale
			or not BuffList.Players[staleGUID].Type == BuffBroker.Constants.Types.Player then
				--MyDebugPrint("Skipping inspect of %s", BuffList.Players[staleGUID].Name)
				table.remove(BuffList.StalePlayers, iterPlayer)
				
				if iterPlayer < BuffList.InspectTarget then
					BuffList.InspectTarget = BuffList.InspectTarget - 1
				end
				
				if BuffList.InspectTarget < 1 or BuffList.InspectTarget > table.getn(BuffList.StalePlayers) then
					BuffList.InspectTarget = 1
				end
			end -- if: player not cached, or already inspected
			
			iterPlayer = iterNext
			staleGUID = nextPlayer
			iTooFar = iTooFar + 1
		end -- while: not at end of stale list

		MyDebugPrint("Next Inspect: decided to check stale player #%d", BuffList.InspectTarget)

		-- while: targets left to check, and next target hasn't been inspected
		while iNumChecks < table.getn(BuffList.StalePlayers) and not self:ShouldInspect(BuffList.StalePlayers[BuffList.InspectTarget]) do

			BuffList.InspectTarget = BuffList.InspectTarget - 1
					
			-- if: start of list
			if BuffList.InspectTarget == 0 then
				BuffList.InspectTarget = table.getn(BuffList.StalePlayers)
			end -- if: end of list
			
			iNumChecks = iNumChecks + 1
		end -- while: targets left to check, and next target hasn't been inspected
	end
	
	-- if - found someone to inspect
	if iNumChecks < table.getn(BuffList.StalePlayers) then
		-- Set inspect target
		inspectGUID = BuffList.StalePlayers[BuffList.InspectTarget]

		-- Request inspect data for this target
		if not UnitIsVisible(BuffList.Players[inspectGUID].Name) then
			BuffBroker:SetFailCode("inspect hickup;  target isn't visible to game client")
		else
			MyDebugPrint("Next Inspect: inspecting "..BuffList.Players[inspectGUID].Name)
			ClearInspectPlayer()
			BuffList.InspectPending = GetTime()
			NotifyInspect(BuffList.Players[inspectGUID].Name)
		end
	else
		MyDebugPrint("Next Inspect: out of inspect targets, or something")
		-- done inspecting, or can't inspect further
		BuffList.InspectLastChecked = GetTime()
		BuffList.InspectComplete = true
		BuffList.InspectPending = nil
		BuffList.InspectTarget = nil

		self:FullProfile()
	end -- if - found someone to inspect
	
end

function BuffBroker:FullProfile()
	MyDebugPrint("Performing full profile (active, roles, bestbuffs, suggestions)")
	
	-- re-populates player's active buffs
	-- re-populates player's buffslots
	self:RefreshPlayers()
	if self:ScanActiveAll() then
		self:RegenerateSuggestionDependencies()
		
		-- update the buff button
		self:AssignNextSuggestion()
	end
end

function BuffBroker:AssignNextSuggestion()
	local suggestOffset
	local iterCurrent, iterStart, iterNext
	local currentSuggestion, nextSuggestion
	local targetProfile
	local spellName
	local currentTotem
	local spellSlot
	local buffLabel
	local currentCastSpellName
	local lastCastSpellName
	
	if 0 < table.getn(BuffList.Suggestions) then
	
		if BuffList.LastSuggested then
			--iterStart = BuffList.LastSuggested
			iterStart = 1
		else
			iterStart = 1
		end

		for iterCurrent=iterStart, table.getn(BuffList.Suggestions) do
			currentSuggestion = BuffList.Suggestions[iterCurrent]
			spellName = GetSpellInfo(currentSuggestion.spellid)
			buffLabel, spellSlot, _ = BuffBroker:SpellInfoFromID(currentSuggestion.spellid)
			
			-- if: high-confidence buff, which we're allowed to cast, on a valid target
			if currentSuggestion.Confidence >= BuffBroker.Constants.Confidence.Unlikely
			and profileDB.slots[BuffBroker.TalentGroup][spellSlot] == true then
				
				-- if: raid or class buff
				if currentSuggestion.Scope == BuffBroker.Constants.Scope.Class or currentSuggestion.Scope == BuffBroker.Constants.Scope.Raid then

					-- if: raid-wide buff passes thresholds (known, sufficient attendance/headcount, none better active from us)
					if (IsSpellKnown(currentSuggestion.spellid) or currentSuggestion.TotemSlot or IsHelpfulSpell(spellName))
					and not (currentSuggestion.Attendance < (profileDB.raidBuffAttendThreshold / 100))
					and not (currentSuggestion.UnBuffedHeadCount < profileDB.raidBuffHeadCountThreshold)
					and not (profileDB.frugal and ( currentSuggestion.UnBuffedHeadCount == 1))
					and not currentSuggestion.BetterActive then

						-- use this suggestion next
						iterNext = iterCurrent

						break
						
					end -- if: raid-wide buff passes thresholds

				-- elseif: self of single buff
				elseif currentSuggestion.Scope == BuffBroker.Constants.Scope.Individual then
				
					-- if: can cast, target exists, is in range, is targetable, is inspected, and better is not active
					if IsSpellKnown(currentSuggestion.spellid)
					and currentSuggestion.TargetProfile
					and currentSuggestion.TargetProfile.Near
					and not currentSuggestion.TargetProfile.Obscured
					and not currentSuggestion.TargetProfile.Stale
					and not currentSuggestion.BetterActive then
						iterNext = iterCurrent
						break
					end
				
				elseif currentSuggestion.Scope == BuffBroker.Constants.Scope.Self then
					lastCastSpellName = nil
					currentCastSpellName = nil
					if profileDB.activeSelfBuffs[BuffBroker.TalentGroup][buffLabel] then
						lastCastSpellName = GetSpellInfo(profileDB.activeSelfBuffs[BuffBroker.TalentGroup][buffLabel])
					end
					
					if BuffList.PlayerGUID
					and BuffList.Players[BuffList.PlayerGUID]
					and BuffList.Players[BuffList.PlayerGUID].ActiveBuffs
					and BuffList.Players[BuffList.PlayerGUID].ActiveBuffs[buffLabel] then
						currentCastSpellName = GetSpellInfo(BuffList.Players[BuffList.PlayerGUID].ActiveBuffs[buffLabel].Spellid)
					end
					
					-- if: can cast, and is inspected
					if lastCastSpellName
					and currentCastSpellName
					and IsSpellKnown(currentSuggestion.spellid)
					and not currentSuggestion.TargetProfile.Stale then
						-- if: has expired
						if BuffBroker:HasExpired(BuffList.Players[BuffList.PlayerGUID].ActiveBuffs[buffLabel], BuffList.PlayerGUID) then
							-- if: this matches last cast
							if lastCastSpellName == spellName then
								iterNext = iterCurrent
								break
							end -- if: this matches last cast
						else
							-- if: active is wrong, current is right
							if lastCastSpellName ~= currentCastSpellName and lastCastSpellName == spellName then
								iterNext = iterCurrent
								break
							end -- if: active is wrong, current is right
						end -- if: has expired
					end -- if: can cast, and is inspected
				end -- if/elseif: match scope
			end
		end
		
		suggestOffset = iterNext
	end
	
	if suggestOffset then

		-- if - TargetProfile is not in LOS
		if not BuffList.Suggestions[suggestOffset].TargetProfile.LOS then
			
			-- for: each player
			for _, someProfile in pairs(BuffList.Players) do
				-- reset LOS info
				someProfile.LOS = true
			end -- for: each player
		end -- if - TargetProfile is not in LOS
	
		MyDebugPrint("Assigning next clickable suggestion on: %s", BuffList.Players[BuffList.Suggestions[suggestOffset].Target].Name)
		
		self:AssignButtonBuff(BuffList.Suggestions[suggestOffset])
		BuffList.LastSuggested = suggestOffset
	else
		MyDebugPrint("No valid suggestions (out of %d).  Resetting button to Dizzy.", table.getn(BuffList.Suggestions))

		BuffList.TooltipPrime = L["Idle"]
		BuffList.TooltipDetail = L["Nothing to suggest"]
		BuffList.TooltipFormatter = L["%d/%d players profiled"]
		BuffList.TooltipMinor = BuffList.TooltipFormatter:format(BuffList.PlayerCount - table.getn(BuffList.StalePlayers), BuffList.PlayerCount)
		
		BuffBroker:ClearButtonBuff()
	end
end

function BuffBroker:ClearButtonBuff()

	-- if: not locked down (THN:  Remove restriction once secure template stuff is understood/working
	if not InCombatLockdown() then
		BuffBroker.Idle = true
		if profileDB.hiddenWhileIdle and BuffBroker.BuffButton:IsVisible() then
			BuffBroker.BuffButton:Hide()
			BuffBroker.MoveFrame:Hide()
		end
		
		BuffBroker.BuffTexture:SetTexture('Interface\\Icons\\Spell_Holy_Dizzy.blp')
		BuffBroker.BuffButton:SetAttribute('type', 'spell')
		BuffBroker.BuffButton:SetAttribute('unit', '')
		BuffBroker.BuffButton:SetAttribute('spell', '')
		BuffList.LastSuggested = nil

		BuffBroker:ShowTip()
	end -- if: not locked down
end

function BuffBroker:AssignButtonBuff(suggestedBuff)
	local spellName
	local spellTexture
	local targetName
	local bestSpellid = suggestedBuff.spellid
	local tooCheapForBestVersion
	local localizedClass
	local highestSpellID
	
	-- if: not locked down (THN:  Remove restriction once secure template stuff is understood/working
	if not InCombatLockdown() then

		--MyDebugPrint("assigning %d", suggestedBuff.spellid)
		if suggestedBuff and BuffBroker:ShouldProfile() then

			BuffBroker.Idle = false
			-- if: no longer idle, but still hidden
			if profileDB.hiddenWhileIdle and not BuffBroker.BuffButton:IsVisible() then
				BuffBroker.BuffButton:Show()
				if not profileDB.lock then
					BuffBroker.MoveFrame:Show()
				end
			end

			if suggestedBuff.TargetProfile and suggestedBuff.TargetProfile.Near then
				targetName = BuffList.Players[suggestedBuff.Target].Name
				spellName, _, spellTexture = GetSpellInfo(bestSpellid)
				localizedClass = UnitClass(suggestedBuff.TargetProfile.Name)
				
				if suggestedBuff.TotemSlot and suggestedBuff.TotemSpell then
					highestSpellID = BuffBroker:GetHighestSpellID(suggestedBuff.TotemSpell)
					
					-- assign totem to desired slot
					BuffBroker.BuffTexture:SetTexture(spellTexture)
					BuffBroker.BuffButton:SetAttribute('type', 'multispell')
					BuffBroker.BuffButton:SetAttribute('unit', targetName)
					BuffBroker.BuffButton:SetAttribute('spell', highestSpellID)
					BuffBroker.BuffButton:SetAttribute('action', suggestedBuff.TotemSlot)

					BuffList.TooltipPrime = spellName
					BuffList.TooltipDetail = L["Add to Call of Elements totem bar"]
					BuffList.TooltipMinor = L["Best totem for this group"]

				else
					BuffBroker.BuffTexture:SetTexture(spellTexture)
					BuffBroker.BuffButton:SetAttribute('type', 'spell')
					BuffBroker.BuffButton:SetAttribute('unit', targetName)
					BuffBroker.BuffButton:SetAttribute('spell', spellName)
				
					BuffList.TooltipPrime = spellName
					BuffList.TooltipFormatter = L["Cast on %s the %s"]
					BuffList.TooltipDetail = BuffList.TooltipFormatter:format(suggestedBuff.TargetProfile.Name, L[suggestedBuff.TargetProfile.Role])

					if suggestedBuff.Scope == BuffBroker.Constants.Scope.Class then
						BuffList.TooltipFormatter = L["%d%% of %s nearby"]
						BuffList.TooltipMinor = BuffList.TooltipFormatter:format(suggestedBuff.Attendance * 100, localizedClass)
					elseif suggestedBuff.Scope == BuffBroker.Constants.Scope.Raid then
						BuffList.TooltipFormatter = L["%d%% of targets nearby"]
						BuffList.TooltipMinor = BuffList.TooltipFormatter:format(suggestedBuff.Attendance * 100)
					elseif suggestedBuff.Scope == BuffBroker.Constants.Scope.Self then
						BuffList.TooltipMinor = L["Refresh this last-used self buff"]
					else
						BuffList.TooltipMinor = ''
					end
				end
				
				BuffBroker:ShowTip()
			end
		end
	end -- if: not locked down
end

function BuffBroker:TestSuggestions()
	local testName, testArray, i, iCurrentSuggestion
	local MatchingResults
	local searchDepth
	local expectedSuggestion, expectedFound
	local failedConfigurations
	local profiledBestBuffs
	local testSuggestList
	local testClasses = {}
	local testCoverage
	
	-- for: each test group
	for testName,testArray in pairs(BuffBroker.TestCases.Groups) do
		failedConfigurations = 0
		
		-- for: each party configuration
		for i = 1,table.getn(testArray) do
			MatchingResults = true
			
			-- update role count
			testClasses = self:UpdateRoleCount(testArray[i].Players, testClasses)
			
			-- update near/far count
			testClasses = self:UpdateRangeCheck(testArray[i].Players, testClasses, true)
			
			-- update coverage
			testCoverage = self:UpdateCoverage(testArray[i].Players, {})
			
			-- clear old buffs
			for _, currentPlayer in pairs(testArray[i].Players) do
				currentPlayer.ActiveBuffs = {}
			end
			
			-- update existing buffs
			if testArray[i].ActiveBuffs then
				for _, currentBuff in pairs(testArray[i].ActiveBuffs) do
					testArray[i].Players[currentBuff.Target].ActiveBuffs[currentBuff.Type] = {
						CasterGUID = currentBuff.Source,
						Spellid = currentBuff.spellid,
						Expires = GetTime() + profileDB.refreshAtDuration + 60,
						Strength = testArray[i].Players[currentBuff.Source].CastableBuffs[currentBuff.Type],
						LOS = true,
					}
						
					if currentBuff.Expired then
						testArray[i].Players[currentBuff.Target].ActiveBuffs[currentBuff.Type].Expires = GetTime() - 1
					end
				end
			end
			
			-- Process data from testArray
			profiledBestBuffs = self:ProfileBest(testArray[i].Players) -- run the profile
			-- IDEAL:  test configuration should swap out BuffList with entire replica!
			testSuggestList = self:BuildSuggestList(testArray[i].Players, testClasses, testCoverage, profiledBestBuffs, testArray[i].PlayerGUID) -- generate suggestions

			-- make sure the sample matches are in the top of the generated list
			searchDepth = table.getn(testArray[i].Suggestions)
			if table.getn(testSuggestList) and table.getn(testSuggestList) < searchDepth then
				searchDepth = table.getn(testSuggestList)
			end
			
			if table.getn(testArray[i].Suggestions) ~= table.getn(testSuggestList) then
				print("Test "..testName.." on "..testArray[i].Test..": Expected "..table.getn(testArray[i].Suggestions)..", got "..table.getn(testSuggestList).." :[")
			end

			-- for: each expected suggestion from testArray
			for iCurrentSuggestion=1, searchDepth do
				
				expectedFound = self:CompareSuggestions(testArray[i].Suggestions[iCurrentSuggestion], testSuggestList[iCurrentSuggestion])

				if not expectedFound then
					print("Suggestion #"..iCurrentSuggestion..", expected <"..testArray[i].Suggestions[iCurrentSuggestion].spellid.." on "..testArray[i].Suggestions[iCurrentSuggestion].Target.." @ "..testArray[i].Suggestions[iCurrentSuggestion].Confidence..">")
					print("Suggestion #"..iCurrentSuggestion..", instead found  <"..testSuggestList[iCurrentSuggestion].spellid.." on "..testSuggestList[iCurrentSuggestion].Target.." @ "..testSuggestList[iCurrentSuggestion].Confidence..">")
					MatchingResults = false
					break
				end
			end -- for: each expected suggestion from testArray

			if not MatchingResults then
				print("Test: "..testName.." on "..testArray[i].Test.." failed")
				failedConfigurations = failedConfigurations + 1

				print("-----Suggestions for failed test-----")
				for iCurrentSuggestion=1, searchDepth do
					os = "Cast ["..GetSpellInfo(testSuggestList[iCurrentSuggestion].spellid).." on <"..testSuggestList[iCurrentSuggestion].Target..">, C: "..testSuggestList[iCurrentSuggestion].Confidence
					os = os.." -actual, vs, expected- Cast ["..GetSpellInfo(testArray[i].Suggestions[iCurrentSuggestion].spellid).." on <"..testArray[i].Suggestions[iCurrentSuggestion].Target..">, Confidence: "..testArray[i].Suggestions[iCurrentSuggestion].Confidence
					print(os)
					
					if testSuggestList[iCurrentSuggestion].BetterActive then print ("oh shit, but better is active (actual)!") end
					
					if testSuggestList[iCurrentSuggestion].Attendance then
						--print("actual attend (%, #): "..testSuggestList[iCurrentSuggestion].Attendance..", "..testSuggestList[iCurrentSuggestion].UnBuffedHeadCount)
					end
					if testArray[i].Suggestions[iCurrentSuggestion].Attendance then
						--print("expected attend: "..testArray[i].Suggestions[iCurrentSuggestion].Attendance)
					end
				end
				MyDebugPrint("-----")
			end
			
		end -- for: each party configuration

		if failedConfigurations == 0 then
			print("Test cleared: "..testName)
		end
	end
end

function BuffBroker:CompareSuggestions(left, right)
	local Match
	if left and right then
		Match = (left.Confidence == right.Confidence)
			and (left.Target == right.Target)
			and (left.spellid == right.spellid)
	end
	
	return Match
end

function BuffBroker:TestBestBuffs()
	local testName, testArray, i
	local MatchingResults
	local failedConfigurations
	local profiledBestBuffs
	
	-- for: each test group
	for testName,testArray in pairs(BuffBroker.TestCases.Groups) do

		failedConfigurations = 0

		-- for: each party configuration
		for i = 1,table.getn(testArray) do
			MatchingResults = true
			
			profiledBestBuffs = self:ProfileBest(testArray[i].Players) -- run the profile

			-- Compare results:
			
			for labelName, _ in pairs(BuffList.DownRankLookup) do
				if testArray[i].Results[labelName] and not self:CompareBuffList(profiledBestBuffs[labelName], testArray[i].Results[labelName]) then
					MatchingResults = false
					print("---Test "..testName.." on "..testArray[i].Test..": Mis-match in "..labelName.." results")
				end
			end
			
			if not MatchingResults then
				print("Test: "..testName.." on "..testArray[i].Test.." failed")
				failedConfigurations = failedConfigurations + 1
			end
		end -- for: each party configuration
		if failedConfigurations == 0 then
			print("Test cleared: "..testName)
		end
	end
end

function BuffBroker:CompareBuffList(FirstList, OtherList)
	local Match
	
	Match = FirstList.Strength == OtherList.Strength
		and FirstList.TotalCount == OtherList.TotalCount
		and table.getn(FirstList.Players) == table.getn(OtherList.Players)
	
	if Match then
		for i=1,table.getn(FirstList.Players) do
			Match = Match and (FirstList.Players[i] == OtherList.Players[i])
		end
	else
		MyDebugPrint("Couldn't match Strength (%d vs %d), total (%d vs %d), or player list size", FirstList.Strength, OtherList.Strength, FirstList.TotalCount, OtherList.TotalCount)
	end
	
	
	return Match
end

function BuffBroker:ProfileBest(playersToProfile)
	--local bestStats, bestAP, bestHP, bestTank, bestMP5 = {}, {}, {}, {}, {}
	local bestBuffsByType = {}
	
	for labelName, _ in pairs(BuffList.DownRankLookup) do
		bestBuffsByType[labelName] = {Strength = BuffBroker.Constants.Buffs.None, TotalCount = 0, Players = {} }
	end
	
	-- for: each Player
	for currentGUID, currentProfile in pairs(playersToProfile) do

		-- update best buffs with this player's info
		
		for labelName, _ in pairs(BuffList.DownRankLookup) do
			bestBuffsByType[labelName] = self:CompareBuffability(currentGUID, currentProfile.CastableBuffs[labelName], bestBuffsByType[labelName])
		end
		
		-- TODO:
		-- for: each BUFFSLOT!  Paladin with king drums should result in TotalCount += 2
	end
		
	return bestBuffsByType
end

function BuffBroker:CompareBuffability(PlayerGUID, PlayerStrength, CurrentBestBuff)
	if PlayerStrength and (PlayerStrength > BuffBroker.Constants.Buffs.None) then
		-- Player can do some (potentially shitty) version of this buff
		CurrentBestBuff.TotalCount = CurrentBestBuff.TotalCount + 1
		-- if: player's buff is same as best seen
		if PlayerStrength == CurrentBestBuff.Strength then
			-- add player to eligibility list
			table.insert(CurrentBestBuff.Players, PlayerGUID)
		elseif PlayerStrength > CurrentBestBuff.Strength then
			-- add player as only member of new better eligibility list
			CurrentBestBuff.Strength = PlayerStrength
			CurrentBestBuff.Players = {PlayerGUID}
		end
	end
	
	return CurrentBestBuff
end

-- TODO:  DEAD CODE HEAR
function BuffBroker:ShouldInspect(targetGUID)
	local inspect = false
	local targetProfile
	
	if BuffList.Players[targetGUID] then
		targetProfile = BuffList.Players[targetGUID] 

		-- should inspect if: not yet inspected, and able to inspect (range, non-NPC, non-flagged pvp hostile)
		inspect = targetProfile.Stale and CanInspect(targetProfile.Name)
	end
	
	return inspect
end

function BuffBroker:CheckRoles()
	local targetName
	local targetProfile
	local changed
	
	for targetName, targetProfile in pairs(BuffList.Players) do
		if targetProfile.Level < profileDB.healerLevel then
			if targetProfile.Role == BuffBroker.Constants.Roles.Caster then
				-- was a caster, but too low level to be a caster
				targetProfile.Role = BuffBroker.Constants.Roles.Healer
				changed = true
			end
		else
			-- 
			if targetProfile.Role == BuffBroker.Constants.Roles.Healer then
				-- was a healer; high enough level to be a caster though
				targetProfile.Role = BuffBroker.Constants.Roles.Caster
				changed = true
			end
		end
	end
	
	if changed then
		BuffList.Classes = BuffBroker:UpdateRoleCount(BuffList.Players, BuffList.Classes)
	end
end

function BuffBroker:InspectAvailable()
	local talentName, rank, maxrank
	local maxTree
	local inspectGUID = BuffList.StalePlayers[BuffList.InspectTarget]

	BuffList.InspectOutstanding = nil
	
	if (not BuffList.InspectBusy) and BuffList.InspectPending then
		
		-- check roles and improved buffs
		if BuffList.Players[inspectGUID].Class == BuffBroker.Constants.Classes.Paladin then

			-- determine role, based on deepest talent tree investment
			BuffList.Players[inspectGUID].Role = BuffBroker:RoleFromTalents(
				BuffBroker.Constants.Roles.Caster,
				BuffBroker.Constants.Roles.Tank,
				BuffBroker.Constants.Roles.MeleeMana_Low,
				BuffBroker.Constants.Roles.MeleeMana_Low)

			-- if - low level caster
			if BuffList.Players[inspectGUID].Level < profileDB.healerLevel and BuffList.Players[inspectGUID].Role == BuffBroker.Constants.Roles.Caster then
				-- will prefer mana
				BuffList.Players[inspectGUID].Role = BuffBroker.Constants.Roles.Healer
			end -- if: low level caster

			-- can generate own mana as retribution? (judgements of the wise)
			talentName, _, _, _, rank, maxrank = GetTalentInfo(3, 18, true, false, GetActiveTalentGroup(true, false)) -- Improved Blessing of Might
			if rank == maxrank then
				BuffList.Players[inspectGUID].Role = BuffBroker.Constants.Roles.MeleeMana
			end

			
			-- can generate own mana as protection? (divine plea)
			talentName, _, _, _, rank, maxrank = GetTalentInfo(2, 23, true, false, GetActiveTalentGroup(true, false)) -- Improved Blessing of Might
			if rank == maxrank and BuffList.Players[inspectGUID].Level > 70 then
				BuffList.Players[inspectGUID].Role = BuffBroker.Constants.Roles.MeleeMana
			end

			BuffList.Players[inspectGUID].OldRole = BuffList.Players[inspectGUID].Role

			-- can buff AP?
			talentName, _, _, _, rank, maxrank = GetTalentInfo(3, 5, true, false, GetActiveTalentGroup(true, false)) -- Improved Blessing of Might
			if rank == maxrank then
				BuffList.Players[inspectGUID].CastableBuffs["AP"] = BuffBroker.Constants.Buffs.FullTalentedLong
			elseif rank > 0 then
				BuffList.Players[inspectGUID].CastableBuffs["AP"] = BuffBroker.Constants.Buffs.PartialTalentedLong
			end
			
			-- can buff Sanctuary for Tank role?
			talentName, _, _, _, rank, maxrank = GetTalentInfo(2, 12, true, false, GetActiveTalentGroup(true, false)) -- Blessing of Sanctuary
			if rank == maxrank then
				BuffList.Players[inspectGUID].CastableBuffs["TANK"] = BuffBroker.Constants.Buffs.FullTalentedLong

				BuffList.Players[inspectGUID].BuffSlots["BLESSINGS"] = BuffBroker.Constants.BuffSlots["BLESSINGS"]
			end

			-- can buff Mana?
			talentName, _, _, _, rank, maxrank = GetTalentInfo(1, 10, true, false, GetActiveTalentGroup(true, false)) -- Improved Blessing of Wisdom
			if rank == maxrank then
				BuffList.Players[inspectGUID].CastableBuffs["MP5"] = BuffBroker.Constants.Buffs.FullTalentedLong
			elseif rank > 0 then
				BuffList.Players[inspectGUID].CastableBuffs["MP5"] = BuffBroker.Constants.Buffs.PartialTalentedLong
			end

		elseif BuffList.Players[inspectGUID].Class == BuffBroker.Constants.Classes.Shaman then
			-- determine role, based on deepest talent tree investment
			BuffList.Players[inspectGUID].Role = BuffBroker:RoleFromTalents(
				BuffBroker.Constants.Roles.Healer,
				BuffBroker.Constants.Roles.MeleeMana_Low,
				BuffBroker.Constants.Roles.Healer,
				BuffBroker.Constants.Roles.MeleeMana_Low)

			-- can regenerate own mana as enhancement?
			talentName, _, _, _, rank, maxrank = GetTalentInfo(2, 24, true, false, GetActiveTalentGroup(true, false)) -- Restorative Totems
			if rank == maxrank then
				BuffList.Players[inspectGUID].Role = BuffBroker.Constants.Roles.MeleeMana
			end

			-- doesn't care about regeneration as enhancement?
			talentName, _, _, _, rank, maxrank = GetTalentInfo(2, 26, true, false, GetActiveTalentGroup(true, false)) -- Restorative Totems
			if rank == maxrank then
				BuffList.Players[inspectGUID].Role = BuffBroker.Constants.Roles.MeleeMana
			end

			-- can regenerate own mana as elemental?
			talentName, _, _, _, rank, maxrank = GetTalentInfo(1, 25, true, false, GetActiveTalentGroup(true, false)) -- Restorative Totems
			if rank == maxrank then
				BuffList.Players[inspectGUID].Role = BuffBroker.Constants.Roles.Caster
			end
			
			-- can buff Mana?
			talentName, _, _, _, rank, maxrank = GetTalentInfo(3, 10, true, false, GetActiveTalentGroup(true, false)) -- Restorative Totems
			if rank == maxrank then
				BuffList.Players[inspectGUID].CastableBuffs["MP5"] = BuffBroker.Constants.Buffs.FullTalented
			elseif rank < (1.0 * maxrank / 2) then
				BuffList.Players[inspectGUID].CastableBuffs["MP5"] = BuffBroker.Constants.Buffs.MinorTalented
			elseif rank > (1.0 * maxrank / 2) then
				BuffList.Players[inspectGUID].CastableBuffs["MP5"] = BuffBroker.Constants.Buffs.MajorTalented
			end

			-- knows totem of wrath?
			talentName, _, _, _, rank, maxrank = GetTalentInfo(1, 22, true, false, GetActiveTalentGroup(true, false)) -- Blessing of Sanctuary
			if rank == maxrank then
				BuffList.Players[inspectGUID].CastableBuffs["FLAT_SPELL_CRIT"] = BuffBroker.Constants.Buffs.Basic

				BuffList.Players[inspectGUID].BuffSlots["FIRE_TOTEMS"] = BuffBroker.Constants.BuffSlots["FIRE_TOTEMS"]
			end

			-- knows improved strength of earth?
			talentName, _, _, _, rank, maxrank = GetTalentInfo(2, 1, true, false, GetActiveTalentGroup(true, false)) -- Blessing of Sanctuary
			if rank == maxrank then
				BuffList.Players[inspectGUID].CastableBuffs["STRENGTH_AGILITY"] = BuffBroker.Constants.Buffs.FullTalented
			elseif rank < (1.0 * maxrank / 2) then
				BuffList.Players[inspectGUID].CastableBuffs["STRENGTH_AGILITY"] = BuffBroker.Constants.Buffs.MinorTalented
			elseif rank > (1.0 * maxrank / 2) then
				BuffList.Players[inspectGUID].CastableBuffs["STRENGTH_AGILITY"] = BuffBroker.Constants.Buffs.MajorTalented
			end

			-- knows improved stoneskin?
			talentName, _, _, _, rank, maxrank = GetTalentInfo(2, 4, true, false, GetActiveTalentGroup(true, false)) -- Blessing of Sanctuary
			if rank == maxrank then
				BuffList.Players[inspectGUID].CastableBuffs["ARMOR"] = BuffBroker.Constants.Buffs.FullTalented
			elseif rank == (1.0 * maxrank / 2) then
				BuffList.Players[inspectGUID].CastableBuffs["ARMOR"] = BuffBroker.Constants.Buffs.PartialTalented
			end

			-- knows improved windfury?
			talentName, _, _, _, rank, maxrank = GetTalentInfo(2, 4, true, false, GetActiveTalentGroup(true, false)) -- Blessing of Sanctuary
			if rank == maxrank then
				BuffList.Players[inspectGUID].CastableBuffs["MELEE_HASTE"] = BuffBroker.Constants.Buffs.FullTalented
			elseif rank == (1.0 * maxrank / 2) then
				BuffList.Players[inspectGUID].CastableBuffs["MELEE_HASTE"] = BuffBroker.Constants.Buffs.PartialTalented
			end

		elseif BuffList.Players[inspectGUID].Class == BuffBroker.Constants.Classes.Deathknight then
			BuffList.Players[inspectGUID].OldRole = BuffBroker.Constants.Roles.PureMelee

			-- knows icy talons?
			talentName, _, _, _, rank, maxrank = GetTalentInfo(2, 16, true, false, GetActiveTalentGroup(true, false)) -- Blessing of Sanctuary
			if rank == maxrank then
				BuffList.Players[inspectGUID].CastableBuffs["MELEE_HASTE"] = BuffBroker.Constants.Buffs.FullTalented
				
				BuffList.Players[inspectGUID].BuffSlots["ICY_TALONS"] = BuffBroker.Constants.BuffSlots["ICY_TALONS"]
			end

		elseif BuffList.Players[inspectGUID].Class == BuffBroker.Constants.Classes.Warrior then
			BuffList.Players[inspectGUID].Role = BuffBroker:RoleFromTalents(
				BuffBroker.Constants.Roles.PureMelee,
				BuffBroker.Constants.Roles.PureMelee,
				BuffBroker.Constants.Roles.Tank,
				BuffBroker.Constants.Roles.PureMelee)
				
			BuffList.Players[inspectGUID].OldRole = BuffBroker.Constants.Roles.PureMelee

			talentName, _, _, _, rank, maxrank = GetTalentInfo(2, 9, true, false, GetActiveTalentGroup(true, false)) -- Improved Shouts
			if rank == maxrank then
				BuffList.Players[inspectGUID].CastableBuffs["AP"] = BuffBroker.Constants.Buffs.FullTalented
				BuffList.Players[inspectGUID].CastableBuffs["HP"] = BuffBroker.Constants.Buffs.FullTalented
			elseif rank < (1.0 * maxrank / 2) then
				BuffList.Players[inspectGUID].CastableBuffs["AP"] = BuffBroker.Constants.Buffs.MinorTalented
				BuffList.Players[inspectGUID].CastableBuffs["HP"] = BuffBroker.Constants.Buffs.MinorTalented
			elseif rank > (1.0 * maxrank / 2) then
				BuffList.Players[inspectGUID].CastableBuffs["AP"] = BuffBroker.Constants.Buffs.MajorTalented
				BuffList.Players[inspectGUID].CastableBuffs["HP"] = BuffBroker.Constants.Buffs.MajorTalented
			end

		elseif BuffList.Players[inspectGUID].Class == BuffBroker.Constants.Classes.Druid then
			-- determine role, based on deepest talent tree investment
			BuffList.Players[inspectGUID].Role = BuffBroker:RoleFromTalents(
				BuffBroker.Constants.Roles.Caster,
				BuffBroker.Constants.Roles.PureMelee,
				BuffBroker.Constants.Roles.Caster,
				BuffBroker.Constants.Roles.PureMelee)

			BuffList.Players[inspectGUID].OldRole = BuffBroker.Constants.Roles.PureMelee

			-- if: low level caster
			if BuffList.Players[inspectGUID].Level < profileDB.healerLevel and BuffList.Players[inspectGUID].Role == BuffBroker.Constants.Roles.Caster then
				-- will prefer mana
				BuffList.Players[inspectGUID].Role = BuffBroker.Constants.Roles.Healer
			end -- if: low level caster

			-- can buff MotW?
			talentName, _, _, _, rank, maxrank = GetTalentInfo(3, 1, true, false, GetActiveTalentGroup(true, false)) -- Improved Mark/Gift of the Wild
			if rank == maxrank then
				BuffList.Players[inspectGUID].CastableBuffs["WILD"] = BuffBroker.Constants.Buffs.FullTalented
			elseif rank > 0 then
				BuffList.Players[inspectGUID].CastableBuffs["WILD"] = BuffBroker.Constants.Buffs.PartialTalented
			end

		elseif BuffList.Players[inspectGUID].Class == BuffBroker.Constants.Classes.Priest then
			if BuffList.Players[inspectGUID].Level < profileDB.healerLevel then
				BuffList.Players[inspectGUID].Role = BuffBroker.Constants.Roles.Healer
			else
				BuffList.Players[inspectGUID].Role = BuffBroker.Constants.Roles.Caster
			end
			
			-- can buff Fortitude?
			talentName, _, _, _, rank, maxrank = GetTalentInfo(1, 5, true, false, GetActiveTalentGroup(true, false)) -- Improved Fortitude
			if rank == maxrank then
				BuffList.Players[inspectGUID].CastableBuffs["STAMINA"] = BuffBroker.Constants.Buffs.FullTalented
			elseif rank > 0 then
				BuffList.Players[inspectGUID].CastableBuffs["STAMINA"] = BuffBroker.Constants.Buffs.PartialTalented
			end

			-- knows vampiric embrace?
			talentName, _, _, _, rank, maxrank = GetTalentInfo(3, 14, true, false, GetActiveTalentGroup(true, false)) -- vampiric embrace
			if rank == maxrank then
				BuffList.Players[inspectGUID].CastableBuffs["EMBRACE"] = BuffBroker.Constants.Buffs.Basic

				BuffList.Players[inspectGUID].BuffSlots["EMBRACE"] = BuffBroker.Constants.BuffSlots["EMBRACE"]
			end
			
		end

		ClearInspectPlayer()
		BuffList.Players[inspectGUID].Stale = false
		BuffList.InspectPending = nil
		table.remove(BuffList.StalePlayers, BuffList.InspectTarget)

		-- if: check if anyone left to inspect
		if (0 < table.getn(BuffList.StalePlayers) ) then
			-- if: start of list
			if BuffList.InspectTarget == 1 then
				-- iterate to end of list
				BuffList.InspectTarget = table.getn(BuffList.StalePlayers)
			else
				-- next inspect target
				BuffList.InspectTarget = BuffList.InspectTarget - 1
			end
		else
			-- done inspecting, or can't inspect further
			BuffList.InspectLastChecked = GetTime()
			BuffList.InspectComplete = true
			BuffList.InspectTarget = nil

			self:FullProfile()

		end -- if: check if anyone left to inspect
	end
end

function BuffBroker:RoleFromTalents(Role1, Role2, Role3, DefaultRole)
	local spentPoints1, spentPoints2, spentPoints3
	local probableRole = DefaultRole

	-- determine role, based on deepest talent tree investment
	_, _, spentPoints1 = GetTalentTabInfo(1, true, false, GetActiveTalentGroup(true, false))
	_, _, spentPoints2 = GetTalentTabInfo(2, true, false, GetActiveTalentGroup(true, false))
	_, _, spentPoints3 = GetTalentTabInfo(3, true, false, GetActiveTalentGroup(true, false))
			
	if spentPoints1 > (spentPoints2 + spentPoints3) then
		probableRole = Role1
	elseif spentPoints2 > (spentPoints1 + spentPoints3) then
		probableRole = Role2
	elseif spentPoints3 > (spentPoints1 + spentPoints2) then
		probableRole = Role3
	end
			
	return probableRole
end

function BuffBroker:ClearState()
	BuffBroker.TalentGroup = GetActiveTalentGroup()
	if not BuffBroker.TalentGroup then
		BuffBroker.TalentGroup = 'nil'
	end
	
	BuffBroker.InCombat = InCombatLockdown()
	
	BuffBroker.Constants.SpecSpells.Primary = GetSpellInfo(63645)
	BuffBroker.Constants.SpecSpells.Secondary = GetSpellInfo(63644)
	
	-- make initial (interactive) frame & buttons
	hooksecurefunc('NotifyInspect', BuffBroker_NotifyInspect)
	hooksecurefunc('ClearInspectPlayer', BuffBroker_ClearInspectPlayer)

	-- Seed data structures
	BuffList.Classes = BuffBroker:UpdateRoleCount(BuffList.Players, BuffList.Classes)

	-- Do other cool stuff
	BuffList.InspectLastChecked = GetTime()
	BuffList.LastCheckedRange = GetTime()
		
end

function BuffBroker:OnInitialize()
	local playerClass
	local slotOrder = options.args.general.args.buffSlots.order
	local constructedDefaults = {}

	-- initialization goes here
	BuffBroker:ClearState()

	_, playerClass = UnitClass('player')
	
	constructedDefaults.profile = {}
	for k, v in pairs(defaults.base.profile) do constructedDefaults.profile[k] = v end
	for k, v in pairs(defaults[playerClass].profile) do constructedDefaults.profile[k] = v end

	self.db = AceDB:New('BuffBrokerDB', constructedDefaults)
	self.db.RegisterCallback(self, 'OnProfileChanged', 'RefreshConfig')
	self.db.RegisterCallback(self, 'OnProfileCopied', 'RefreshConfig')
	self.db.RegisterCallback(self, 'OnProfileReset', 'RefreshConfig')

	profileDB = self.db.profile
	options.args.profile = LibStub('AceDBOptions-3.0'):GetOptionsTable(self.db)

	BuffBroker:UpdateSaveFile()

	-- register slash commands, for console interaction
	AceConfig:RegisterOptionsTable('BuffBroker', options, {'BuffBroker', 'bb'})

	-- Setup Blizzard option frames
	self.OptionsFrames = {}
	self.OptionsFrames.General = AceConfigDialog:AddToBlizOptions('BuffBroker', nil, nil, 'general')

	self:MakeMainFrame()	
end

function BuffBroker:UpdateSaveFile()

	if not profileDB.currentVersion then
		-- SUPER old; don't even bother
		print(L["Buff Broker: Save format changed! please check your settings in the Interface -> AddOns menu"])
	-- elseif profileDB.currentVersion == 1.0 then
		--[[ update to latest version, from this:
		base = {
			profile = {
				saveVersion = 1.0,
				refreshAtDuration = 20,
				raidBuffAttendThreshold = 0,
				raidBuffHeadCountThreshold = 1,
				frugal = false,
				friendly = false,
				healerLevel = 68,
				screenX = 0,
				screenY = -100,
				scale = 100,
				lock = false,
				show = true,
				tooltipAnchor = "ANCHOR_BOTTOM",
				skin = {
					ID = 'Blizzard',
					Backdrop = true,
					Gloss = 0,
					Zoom = false,
					Colors = {},
				},
				subskin = {
					ID = 'Blizzard',
					Backdrop = true,
					Gloss = 0,
					Zoom = false,
					Colors = {},
				},
				slots = {
					[1] = {},
					[2] = {},
				},
				activeSelfBuffs = {
					{}, -- talent group 1
					{}, -- talent group 2
				},
			},
		},
		[BuffBroker.Constants.Classes.Warrior] = ...
		]]
	
	end	
	
	profileDB.currentVersion = profileDB.saveVersion
end

function BuffBroker:SkinChanged(SkinID, Gloss, Backdrop, Group, Button, Colors)
	
	if not Group then
		profileDB.skin.ID = SkinID
		profileDB.skin.Gloss = Gloss
		profileDB.skin.Backdrop = Backdrop
		profileDB.skin.Colors = Colors
	elseif Group == "MainBar" then
		profileDB.subskin.ID = SkinID
		profileDB.subskin.Gloss = Gloss
		profileDB.subskin.Backdrop = Backdrop
		profileDB.subskin.Colors = Colors
	end
end

function BuffBroker_ClearInspectPlayer()
	BuffList.InspectOutstanding = nil

	-- if: player/someone was using the inspect feature
	if BuffList.InspectBusy then
		MyDebugPrint("BuffBroker: Poached NotifyInspect;  inspectPlayer is free again")
		-- they must be done now
		BuffList.InspectBusy = nil
	else
		BuffList.InspectPending = nil
	end -- if: player/someone was using the inspect feature
end

function BuffBroker_NotifyInspect(unitName)
	local inspectGUID
	
	BuffList.InspectOutstanding = GetTime()

	if BuffList.InspectTarget then
		inspectGUID = BuffList.StalePlayers[BuffList.InspectTarget]
		
		if inspectGUID ~= UnitGUID(unitName) then
			MyDebugPrint("BuffBroker: Poached NotifyInspect;  someone else requested %s", unitName)
			BuffList.InspectPending = nil
			BuffList.InspectBusy = GetTime()
			BuffList.InspectTarget = nil
		end
	else
		BuffList.InspectBusy = GetTime()
	end
end

function BuffBroker:OnUpdate(self, elapsed)
	
	if not tonumber(BuffBroker.TalentGroup) then
		BuffBroker.TalentGroup = GetActiveTalentGroup()
		
	end
	
	-- if: 1/2 second from first change, or 1/10th second since last change
	if (BuffList.AurasFirstChangedAt and ((GetTime() - BuffList.AurasFirstChangedAt) > 0.5) )
	or (BuffList.AurasLastChangedAt and ((GetTime() - BuffList.AurasLastChangedAt) > 0.1) ) then
		BuffList.AurasFirstChangedAt = nil
		BuffList.AurasLastChangedAt = nil

		BuffBroker:RegenerateSuggestionDependencies()
		BuffBroker:AssignNextSuggestion()
	end -- if: auras finished changing
	
	
	-- if: haven't profiled the player, or the party
	if not BuffList.PlayerGUID
	or not BuffList.Players[BuffList.PlayerGUID]
	or (BuffList.Players[BuffList.PlayerGUID].BuffSlots and 0 == table.getn(BuffList.Suggestions)) then
		-- do so now (pro-tip:  Should find a trigger so this doesn't slow down load?)
		BuffBroker:RefreshPlayers()
	end -- if: haven't profiled the party yet
	
	
	-- if: have a new face to inspect
	if BuffList.InspectTarget and not BuffList.InspectPending and not BuffList.InspectComplete then
		-- inspect them now
		MyDebugPrint("Next Inspect, Have target, not pending, not complete")
		BuffBroker:NextInspect()
	
			
	-- elseif: X seconds since last party check	
	elseif  ((GetTime() - BuffList.InspectLastChecked) > BuffList.InspectIdleWait)  then
		-- update stale player list (add & prune)
		BuffBroker:CheckStalePlayers()

		-- if: not occupied
		if not BuffList.InspectPending and 0 < table.getn(BuffList.StalePlayers) then
			BuffList.InspectTarget = table.getn(BuffList.StalePlayers)
			BuffBroker:NextInspect()
			MyDebugPrint("Next Inspect, not pending, stale players to check")

		-- if: InspectTarget is out of range
		elseif BuffList.InspectTarget
		and BuffList.InspectPending
		and BuffList.StalePlayers[BuffList.InspectTarget]
		and BuffList.Players[BuffList.StalePlayers[BuffList.InspectTarget]]
		and not BuffList.Players[BuffList.StalePlayers[BuffList.InspectTarget]].Near then
			
			MyDebugPrint("Next Inspect, not pending, inspect target out of range")
			BuffList.InspectTarget = table.getn(BuffList.StalePlayers)
			BuffBroker:NextInspect()
		end -- if: InspectTarget is out of range

		BuffList.InspectLastChecked = GetTime()
	end
	
	-- if: inspect timed out
	if BuffList.InspectOutstanding and ((GetTime() - BuffList.InspectOutstanding) > BuffList.InspectTimeout) then
		if not BuffList.InspectBusy then
			ClearInspectPlayer()
			BuffBroker:SetFailCode("BuffBroker: abandoning inspect request after "..BuffList.InspectTimeout.." seconds.  This is odd...")
		else
			BuffBroker:SetFailCode("BuffBroker: something has locked the inspect API for "..BuffList.InspectTimeout.." seconds now :3")
		end
		
		-- reset all inspection parameters
		BuffList.InspectBusy = false
		BuffList.InspectLastChecked = GetTime()
		BuffList.InspectComplete = true
		BuffList.InspectPending = nil
		BuffList.InspectTarget = nil
		BuffList.InspectOutstanding = nil
	end -- if: inspect timed out

	-- if: something else keeping us busy
	if BuffList.InspectBusy and ((GetTime() - BuffList.InspectBusy) > BuffList.BusyWarningTimeout) then -- BuffList.BusyWarningTimeout) then
		--BuffBroker:SetFailCode("BuffBroker: something has been hogging the inspect API for "..BuffList.BusyWarningTimeout.." seconds now :3")
		--BuffBroker:SetFailCode("BuffBroker: If you don't have the inspect window out, please check for addons (incorrectly) using ClearInspectPlayer() and NotifyInspect().  Posting this message & a list of your active addons would really help the BuffBroker author, if you have time!")
		BuffList.InspectBusy = nil
	end
	
	-- if: time to check range of players
	if ((GetTime() - BuffList.LastCheckedRange) > BuffList.RangeCheckDelay) and BuffBroker:ShouldProfile() then
		if BuffList.PlayerCount < 1 or not BuffList.PlayerGUID then
			BuffBroker:FullProfile()
		elseif not BuffList.Players[BuffList.PlayerGUID].Stale then
			-- TODO:  Trigger this ONLY when ANY buff needs to be refreshed
			-- TIP:  Watch the expiration time of oldest aura goes by
			-- ALTERNATE:  Scan for expired auras before doing refresh/regenerate/assign
			BuffBroker:RefreshPlayers()
			BuffBroker:RegenerateSuggestionDependencies()
			BuffBroker:AssignNextSuggestion()
		end
		
		BuffList.LastCheckedRange = GetTime()
	end -- if: time to check range of players
end

function BuffBroker:ShouldProfile()

	local shouldProfile = not BuffBroker.InCombat -- Not in combat
	and (profileDB.show or BuffBroker.ActivityFrame:IsVisible() ) -- not (hidden & disabled while hidden)
	and not UnitIsDeadOrGhost('player') -- alive
	and not UnitControllingVehicle('player') -- not controlling a vehicle
	-- add: in mounted?
	
	return shouldProfile
end

function BuffBroker:CheckStalePlayers()
	local currentGUID
	local currentProfile
	local prunedList = {}
	
	for currentGUID, currentProfile in pairs(BuffList.Players) do
		if currentProfile.Stale or currentProfile.Role == BuffBroker.Constants.Roles.Unknown then
			if not listContains(BuffList.StalePlayers, currentGUID) then
				table.insert(BuffList.StalePlayers, currentGUID)
			end
		end
	end
	
	for _, currentGUID in pairs(BuffList.StalePlayers) do
		if BuffList.Players[currentGUID] and BuffList.Players[currentGUID].Stale then
			table.insert(prunedList, currentGUID)
		end
	end
	
	BuffList.StalePlayers = prunedList
end

function BuffBroker:OnEvent(self, event, ...)
	local targetName
	local targetGUID
	local changedActionSlot
	local targetName
	local spellName
	local newPetID, petType, lastPetID

	if event == 'UNIT_AURA' then
		-- update aura data for affected unit
		targetGUID = UnitGUID(select(1, ...))

		-- if: unit is of interest to us
		if targetGUID and BuffList.Players[targetGUID] then
			-- if: during aura scan, anything relevant changed
			if BuffBroker:ScanActive(targetGUID) then
				BuffList.AurasLastChangedAt = GetTime()
				
				if not BuffList.AurasFirstChangedAt then
					BuffList.AurasFirstChangedAt = BuffList.AurasLastChangedAt
				end
			end -- if: during aura scan, anything relevant changed
		end -- if: unit is of interest to us
		
	elseif event == 'INSPECT_TALENT_READY' then
		BuffBroker:InspectAvailable()
	elseif event == 'PARTY_MEMBERS_CHANGED' then
		-- refresh buffer list
		MyDebugPrint("LP: party members changed")
		BuffBroker:RefreshPlayers()
	elseif event == 'RAID_ROSTER_UPDATE' then
		-- refresh buffer list
		MyDebugPrint("LP: raid roster updated")
		BuffBroker:RefreshPlayers()
	elseif event == 'ACTIVE_TALENT_GROUP_CHANGED' then
		BuffBroker.TalentGroup = GetActiveTalentGroup()
	elseif event == 'UNIT_LEVEL' then
		targetGUID = UnitGUID(select(1, ...))
		
		if BuffList.Players[targetGUID] and not BuffList.Players[targetGUID].Stale and BuffList.Players[targetGUID].Type == BuffBroker.Constants.Types.Player then
			BuffList.Players[targetGUID].Stale = true
			BuffBroker:FullProfile()
		end
	elseif event == 'LEARNED_SPELL_IN_TAB' then
		if BuffList.PlayerGUID and BuffList.Players[BuffList.PlayerGUID] and not BuffList.Players[BuffList.PlayerGUID].Stale then
			BuffList.Players[BuffList.PlayerGUID].Stale = true
			BuffBroker:FullProfile()
		end
	elseif event == 'PLAYER_DEAD' then
		BuffList.TooltipPrime = L["Dead"]
		BuffList.TooltipDetail = L["Suggestions Disabled while dead"]
		BuffList.TooltipMinor = ''
		
		BuffBroker:ClearButtonBuff()
	elseif event == 'ACTIONBAR_SLOT_CHANGED' then
		changedActionSlot = select(1, ...)
		
		if listContains(BuffBroker.Constants.Totems, changedActionSlot) then
			BuffBroker:RegenerateSuggestionDependencies()
			BuffBroker:AssignNextSuggestion()
		end
	elseif event == 'PLAYER_REGEN_DISABLED' then
		BuffBroker.InCombat = true
		BuffList.TooltipPrime = L["Combat"]
		BuffList.TooltipDetail = L["Suggestions Disabled while in combat"]
		BuffList.TooltipMinor = ''
		
		BuffBroker:ClearButtonBuff()
	elseif event == 'PLAYER_REGEN_ENABLED' then
		BuffBroker.InCombat = nil
		BuffBroker:FullProfile()
	elseif event == 'PLAYER_ENTERED_VEHICLE' or event == 'PLAYER_ENTERING_VEHICLE' then
		BuffList.TooltipPrime = L["Vehicle"]
		BuffList.TooltipDetail = L["Suggestions Disabled while in a vehicle"]
		BuffList.TooltipMinor = ''
		
		BuffBroker:ClearButtonBuff()
	elseif event == 'PLAYER_EXITED_VEHICLE' or event == 'PLAYER_EXITING_VEHICLE' then
		BuffBroker:FullProfile()
	elseif event == 'COMBAT_LOG_EVENT_UNFILTERED' then
		if BuffBroker:ShouldProfile() then
			BuffBroker:ParseSpellCast(...)
		end
		--- spell cast by raid member, on raid member
		--- spell is a buff we want to monitor
	elseif event == 'UNIT_SPELLCAST_SUCCEEDED' then
		-- Spec change! 63645 spec 1, 63644 spec 2
		targetName, spellName = select(1, ...)
		
		if BuffList.Players[UnitGUID(targetName)]
		and (spellName == BuffBroker.Constants.SpecSpells.Secondary or spellName == BuffBroker.Constants.SpecSpells.Secondary) then
			if UnitGUID(targetName) ~= BuffList.PlayerGUID then
				-- update their talent spec
				BuffList.Players[UnitGUID(targetName)].Stale = true
				BuffBroker:FullProfile()
			end
		end
	elseif event == 'PLAYER_ALIVE' then
		BuffBroker:FullProfile()
	elseif event == 'PLAYER_LOGIN' then
		BuffBroker:FullProfile()
	elseif event == 'UNIT_PET' then
		targetName = select(1, ...)
		
		if targetName then
			targetGUID = UnitGUID(targetName)
		end
		
		-- if: target is of interest to us
		if targetGUID and BuffList.Players[targetGUID] then
			petGUID = UnitGUID(targetName.."pet")
			petType, newPetID = BuffBroker:ParseGUID(petGUID)
			
			-- if: player has a permanent pet out meow
			if petGUID and petType == BuffBroker.Constants.Types.CombatPet then
				-- disect GUID:  determine pet's unique ID

				if BuffList.Players[targetGUID].PetGUID then
					_, lastPetID = BuffBroker:ParseGUID(BuffList.Players[targetGUID].PetGUID)
				end

				-- if: different pet
				if newPetID and newPetID ~= lastPetID then
					--Remove last pet
					if BuffList.Players[targetGUID].PetGUID
					and BuffList.Players[BuffList.Players[targetGUID].PetGUID] then
						BuffList.Players[BuffList.Players[targetGUID].PetGUID] = nil
						BuffList.PlayerCount = BuffList.PlayerCount - 1
					end

					--Add new pet
					petGUID, petProfile = BuffBroker:ProfileUnit(targetName..'pet')
					
					-- if: scanned pet successfully
					if petGUID and petProfile and not BuffList.Players[petGUID] then
						-- Add pet, scan buffs, mark for inspection
						BuffList.Players[targetGUID].PetGUID = petGUID
						BuffList.Players[petGUID] = petProfile
						BuffList.PlayerCount = BuffList.PlayerCount + 1

						-- parse auras on unit
						BuffBroker:ScanActive(petGUID)
						
						-- New Suggestions
						BuffBroker:RegenerateSuggestionDependencies()
						BuffBroker:AssignNextSuggestion()
					end -- if: scanned pet successfully
				elseif BuffList.Players[petGUID] and BuffList.Players[petGUID].Name ~= UnitName(targetName..'pet') then
					BuffList.Players[petGUID].Name = UnitName(targetName..'pet')
				end
			end -- if: player summoned a new pet, or changed pets

		end -- if: target is of interest to us
	end
end

function BuffBroker:ParseSpellCast(timestamp, event, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, ...)
	local aurasChanged = false
	local playersToWipe = {}
	local buffLabel
	local lastTargetGUID
	local spellid
	local failReason
	local lastSpell


	-- if: cast by player
	if sourceGUID == BuffList.PlayerGUID then
		
		-- if: cast by me (successfully), on someone we're watching
		if event == 'SPELL_CAST_SUCCEEDED' and destGUID and BuffList.Players[destGUID] then
			-- they must be in range & visible if we managed to buff 'em
			BuffList.Players[destGUID].LOS = true
		end
		
		-- if: player's spell failed
		if event == 'SPELL_CAST_FAILED' then
			spellid, _, _, failReason = select(1, ...)
			buffLabel = BuffBroker:SpellInfoFromID(spellid)
			lastTargetGUID = nil
			
			-- TODO:  Cache target GUID in pre-click and post-click of action, to ensure we're not triggering from
			-- actions of user, or some other addon
			
			
			-- if: target not in LOS
			if failReason == SPELL_FAILED_LINE_OF_SIGHT -- "Target not in line of sight" <- can't buff, even if nearby;  close enough to get the buff
			or failReason == SPELL_FAILED_OUT_OF_RANGE then -- "Target not in range" <- can't buff, even if 'nearby';  too far for casting, close enough to get the buff
				if BuffBroker.BuffButton:GetAttribute('unit') then
					lastTargetGUID = UnitGUID(BuffBroker.BuffButton:GetAttribute('unit'))
				end
				if BuffBroker.BuffButton:GetAttribute('spell') then
					lastSpell = UnitGUID(BuffBroker.BuffButton:GetAttribute('spell'))
				end
				
				if lastTargetGUID and BuffList.Players[lastTargetGUID] then
					-- mark player as out of LOS
					BuffList.Players[lastTargetGUID].LOS = nil
					-- re-sort suggestions for this player to end of list
					BuffBroker:RegenerateSuggestionDependencies()
					self:AssignNextSuggestion()
				end

			-- elseif: can't over-write more powerful spell
			elseif failReason == SPELL_FAILED_AURA_BOUNCED then -- "A more powerful spell is already active" <- got a buff from someone outside the party
				-- occurs when an unknown source buffed the party (ie: lesser talented blessings, thorns, etc)
				-- set ActiveBuffs[label].Strength to ONE NOTCH higher than what we can do
				if BuffBroker.BuffButton:GetAttribute('unit') then
					lastTargetGUID = UnitGUID(BuffBroker.BuffButton:GetAttribute('unit'))
				end
				if BuffBroker.BuffButton:GetAttribute('spell') then
					lastSpell = UnitGUID(BuffBroker.BuffButton:GetAttribute('spell'))
				end

				-- if: known target, and buff known/cached, and we can do the same buff
				if lastTargetGUID and BuffList.Players[lastTargetGUID]
				and buffLabel and BuffList.Players[lastTargetGUID].ActiveBuffs[buffLabel]
				and BuffList.Players[BuffList.PlayerGUID].CastableBuffs[buffLabel]
				and BuffList.Players[lastTargetGUID].ActiveBuffs[buffLabel].Caster ~= BuffList.PlayerGUID then
					-- update strength to better than what we can do
					BuffList.Players[lastTargetGUID].ActiveBuffs[buffLabel].Strength = BuffBroker.Constants.Buffs.Awesome

					-- re-do suggestions
					BuffBroker:RegenerateSuggestionDependencies()
					self:AssignNextSuggestion()
				end
			end
			
		end -- if: player's spell failed
	end -- if: cast by player
end

function BuffBroker:MarkMove()
	BuffBroker.MoveStartX = BuffBroker.ActivityFrame:GetLeft()
	BuffBroker.MoveStartY = BuffBroker.ActivityFrame:GetTop()

	BuffBroker.ActivityFrame:StartMoving()
end

function BuffBroker:StopMove()
	local offsetX, offsetY
	
	-- if - already moving
	if BuffBroker.MoveStartX and BuffBroker.MoveStartY then
		-- adjust frame position based on move distance
		offsetX = BuffBroker.ActivityFrame:GetLeft() - BuffBroker.MoveStartX
		offsetY = BuffBroker.ActivityFrame:GetTop() - BuffBroker.MoveStartY
		BuffBroker.ActivityFrame:StopMovingOrSizing()
		
		profileDB.screenX = profileDB.screenX + offsetX
		profileDB.screenY = profileDB.screenY + offsetY
		
		-- clear/save start-of-move indicators
		BuffBroker.MoveStartX = nil
		BuffBroker.MoveStartY = nil
	end
end

function BuffBroker:MakeMainFrame()

	local f, t
	-- create 'Frame'
	f = CreateFrame('Frame', nil, SecureStateHeaderTemplate)
	f:SetPoint('TOPLEFT', profileDB.screenX, profileDB.screenY)
	f:SetFrameStrata('DIALOG')
	f:SetHeight(80)
	f:SetWidth(64)
	f:SetMovable(true)
	f:RegisterEvent('UNIT_AURA')
	f:RegisterEvent('INSPECT_TALENT_READY')
	f:RegisterEvent('PARTY_CONVERTED_TO_RAID')
	f:RegisterEvent('PARTY_MEMBERS_CHANGED')
	f:RegisterEvent('PARTY_MEMBERS_ENABLE')
	f:RegisterEvent('RAID_ROSTER_UPDATE')
	f:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
	f:RegisterEvent('UNIT_SPELLCAST_SUCCEEDED')
	f:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
	f:RegisterEvent('LEARNED_SPELL_IN_TAB')
	f:RegisterEvent('PLAYER_DEAD')
	f:RegisterEvent('UNIT_LEVEL')
	f:RegisterEvent('PLAYER_REGEN_ENABLED')
	f:RegisterEvent('PLAYER_REGEN_DISABLED')
	f:RegisterEvent('PLAYER_ENTERED_VEHICLE')
	f:RegisterEvent('PLAYER_ENTERING_VEHICLE')
	f:RegisterEvent('ACTIONBAR_SLOT_CHANGED')
	f:RegisterEvent('UNIT_PET')
	f:RegisterEvent('UNIT_ENTERED_VEHICLE')
	f:RegisterEvent('UNIT_EXITED_VEHICLE')
	f:RegisterEvent('UNIT_ENTERING_VEHICLE')
	f:RegisterEvent('UNIT_EXITING_VEHICLE')
	f:RegisterEvent('PLAYER_LOGIN')
	f:SetScript('OnEvent', function(self, event, ...) BuffBroker:OnEvent(self, event, ...) end)
	f:SetScript('OnUpdate', function(self, elapsed) BuffBroker:OnUpdate(self, elapsed) end)
	BuffBroker.ActivityFrame = f
	if profileDB.show then
		BuffBroker.ActivityFrame:Show()
	else
		BuffBroker.ActivityFrame:Hide()
	end
	
	-- make move handle
	f = CreateFrame('Frame', nil, BuffBroker.ActivityFrame)
	f:SetMovable(true)
	f:SetPoint('TOPLEFT', BuffBroker.ActivityFrame, 'TOPLEFT')
	f:SetHeight(16)
	f:SetWidth(64)
	f:SetScale(profileDB.scale / 100)
	f:EnableMouse(true)
	f:RegisterForDrag('LeftButton')
	f:SetScript('OnMouseDown', function() BuffBroker:MarkMove() end)
	f:SetScript('OnMouseUp', function() BuffBroker:StopMove() end)
	f:SetScript('OnHide', function() BuffBroker:StopMove() end)
	f:SetFrameStrata('HIGH')
	BuffBroker.MoveFrame = f
	if profileDB.lock then
		BuffBroker.MoveFrame:Hide()
	else
		BuffBroker.MoveFrame:Show()
	end

	fs = BuffBroker.MoveFrame:CreateFontString()
	fs:SetAllPoints(BuffBroker.MoveFrame)
	fs:SetFontObject(GameFontNormalSmall)
	fs:SetJustifyH('CENTER')
	fs:SetJustifyV('MIDDLE')
	fs:SetText('BuffBroker')
	BuffBroker.MoveFrame.FontString = fs

	-- make buttan
	f = CreateFrame('Button', 'BuffBroker_CastSuggestionButton', BuffBroker.ActivityFrame, 'SecureActionButtonTemplate')
	f:SetNormalTexture('Interface\\Icons\\Spell_Holy_Dizzy.blp')
	t = f:GetNormalTexture()
	f:RegisterForClicks('LeftButtonDown', 'RightButtonDown')
	f:SetHeight(64)
	f:SetWidth(64)
	f:SetScale(profileDB.scale / 100)
	f:SetPoint('TOPLEFT', BuffBroker.MoveFrame, 'BOTTOMLEFT')
	f:SetScript('OnEnter', function() BuffBroker.ShowingTooltip = true BuffBroker:ShowTip() end)
	f:SetScript('OnLeave', function() BuffBroker.ShowingTooltip = false BuffBroker:FadeTip() end)
	--f:SetScript'OnClick',function(this) BuffBroker:UpdateButtonSpell() end)
	BuffBroker.BuffButton = f
	BuffBroker.BuffTexture = t
	
	t = BuffBroker.MoveFrame:CreateTexture(nil, 'BACKGROUND')
	t:SetTexture('Interface\\Tooltips\\ChatBubble-Background.blp')
	t:SetPoint('TOPLEFT', BuffBroker.ActivityFrame, 'TOPLEFT')
	t:SetPoint('BOTTOMRIGHT', BuffBroker.BuffButton, 'BOTTOMRIGHT')
	BuffBroker.MoveFrame.texture = t

	BuffBroker.BuffButton:Raise()
	BuffBroker.ActivityFrame:Show()

end

function BuffBroker:ShowTip()
	if BuffBroker.ShowingTooltip then
		GameTooltip:SetOwner(BuffBroker.BuffButton, profileDB.tooltipAnchor)
		GameTooltip:SetText(BuffList.TooltipPrime, 1, .82, 0, 1)
		GameTooltip:AddLine(BuffList.TooltipDetail, 1, 1, 1, 1)
		GameTooltip:AddLine(BuffList.TooltipMinor, .7, .7, .7, 1)

		GameTooltip:Show()
	end
end

function BuffBroker:FadeTip()
	GameTooltip:FadeOut()

end

function BuffBroker:OnEnable()
	local playerClass
	_, playerClass = UnitClass('player')

	-- activate
	-- set up skinning framework
	if LBF then
		-- Group registration delayed until OnEnable, to ensure it shows up in the ButtonFacade UI
		LBF:RegisterSkinCallback("BuffBroker", BuffBroker.SkinChanged, self)
		LBF:Group("BuffBroker"):Skin(
			profileDB.skin.ID,
			profileDB.skin.Gloss,
			profileDB.skin.Backdrop,
			profileDB.skin.Colors)

		LBF:Group("BuffBroker", "MainBar"):Skin(
			profileDB.subskin.ID,
			profileDB.subskin.Gloss,
			profileDB.subskin.Backdrop,
			profileDB.subskin.Colors)

		LBF:Group("BuffBroker", "MainBar"):AddButton(BuffBroker.BuffButton, {Button = BuffBroker.BuffButton, Icon = BuffBroker.BuffTexture,} )
	
	end

	-- Seed primary spec possibilities
	slotOrder = options.args.general.args.buffSlots.order + 2
	-- for: each class-appropriate buffslot
	for slotName, slotEnabled in pairs(defaults[playerClass].profile.slots[1]) do
		options.args.general.args["1"..slotName] = {
			type = 'toggle',
			order = slotOrder,
			width = 'single',
			name = L[slotName],
			desc = L[slotName.."_DESC"],
			arg = "1"..slotName,
			get = getProfileOption,
			set = setProfileOption,
		}

		slotOrder = slotOrder + 1
	end

	if GetNumTalentGroups() > 1 then
		options.args.general.args.buffSlotsDualSpec.dialogHidden = false
		options.args.general.args.buffSlotsDualSpec_desc.dialogHidden = false
	
		-- Seed offspec possibilities
		slotOrder = options.args.general.args.buffSlotsDualSpec.order + 2
		-- for: each class-appropriate buffslot
		for slotName, slotEnabled in pairs(defaults[playerClass].profile.slots[2]) do
			options.args.general.args["2"..slotName] = {
				type = 'toggle',
				order = slotOrder,
				width = 'single',
				name = L[slotName],
				desc = L[slotName.."_DESC"],
				arg = "2"..slotName,
				get = getProfileOption,
				set = setProfileOption,
			}

			slotOrder = slotOrder + 1
		end
	end
end

function BuffBroker:OnDisable()
	-- deactivate
end

function BuffBroker:SpellInfoFromID(spellid)
	local buffLabel = nil

	local buffSlotEntry = nil
	local slotName
	local scope
	
	local labelName
	local labelSpellidMap
	local minspellid
	
	-- for: each label lookup map (AP, MP5, HP, etc)
	for labelName, labelSpellidMap in pairs(BuffList.DownRankLookup) do
		-- if: spell exists in downrank lookup table
		if labelSpellidMap[spellid] then
			-- figure out the relevant label, and other cool info

			buffLabel = labelName

			slotName = labelSpellidMap[spellid].slot
			minspellid = labelSpellidMap[spellid].minspellid
			buffSlotEntry = BuffBroker.Constants.BuffSlots[slotName]
			if buffSlotEntry[minspellid] then
				scope = buffSlotEntry[minspellid].Scope
			end
			
			break
		end -- if: spell exists in downrank lookup table
	end -- for: each label lookup map

	return buffLabel, slotName, scope
end

function MyDebugPrint(formatText, ...)
	if BuffBroker.PrintDebug then
		print(formatText:format(...))
	end
end

function listContains(theList, thisValue)
	local found
	local i
	
	if theList then
		-- for: each pair in table
		for key, value in pairs(theList) do
			-- if: match
			if value == thisValue then
				found = true
				break
			end -- if: match
		end
	end
	
	return found
end

function BuffBroker:IsGreaterPallyBuff(spellid)
	local found
	
	for _, GreaterSpellid in pairs(BuffList.GreaterLookup["BLESSINGS"]) do
		if spellid == GreaterSpellid then
			found = true
			break
		end
	end
	
	return found
end

function BuffBroker:GetGreaterPallyBuff(spellid)
	local greaterVersion = BuffList.GreaterLookup["BLESSINGS"][spellid]
	
	if not greaterVersion then
		greaterVersion = spellid
	end
	
	return greaterVersion
end

function BuffBroker:UpdateRangeCheck(thePlayers, theClasses, ignoreLive)
	local targetGUID, targetProfile, className
	local totalNear = 0
	
	for _, className in pairs(BuffBroker.Constants.Classes) do
		theClasses[className].Near = 0
	end

	for targetGUID, targetProfile in pairs(thePlayers) do
		if ignoreLive then
			if targetProfile.Near then
				theClasses[targetProfile.Class].Near = theClasses[targetProfile.Class].Near + 1
				totalNear = totalNear + 1
			end
		else
			if (UnitInRange(targetProfile.Name) and not UnitInVehicle(targetProfile.Name) and not UnitIsDeadOrGhost(targetProfile.Name) and UnitIsConnected(targetProfile.Name)) then
				targetProfile.Near = true
				theClasses[targetProfile.Class].Near = theClasses[targetProfile.Class].Near + 1
				totalNear = totalNear + 1
			else
				targetProfile.Near = false
				--self:ScanActive(targetGUID)
			end
		end
	end

	theClasses[BuffBroker.Constants.Classes.Raid].Near = totalNear
	
	return theClasses
end

function BuffBroker:UpdateRoleCount(thePlayers, theClasses)
	local target, className, classNum, role
	local highestRole, highestCount
		
	-- for: each class
	for _, className in pairs(BuffBroker.Constants.Classes) do
		if not theClasses[className] then
			 -- reset initial class data
			theClasses[className] = {
				HeadCount = 0,
				Near = 0,
				RoleCount = {},
				DominantRole = BuffBroker.Constants.Roles.None,
			}
		else
			theClasses[className].RoleCount = {}
			theClasses[className].DominantRole = BuffBroker.Constants.Roles.None
			theClasses[className].HeadCount = 0
		end

		-- for: each role
		for _, role in pairs(BuffBroker.Constants.Roles) do
			if not theClasses[className].RoleCount then
				theClasses[className].RoleCount = {}
			end
			
			-- reset the count
			theClasses[className].RoleCount[role] = 0
		end -- for: each role

	end -- for: each class
	
	-- for: each player
	for _, target in pairs(thePlayers) do
		-- add them to the class head/role count
		if target.Role then
			theClasses[target.Class].RoleCount[target.Role] = theClasses[target.Class].RoleCount[target.Role] + 1
			theClasses[target.Class].HeadCount = theClasses[target.Class].HeadCount + 1

			-- add to the total head/role count
			theClasses[BuffBroker.Constants.Classes.Raid].RoleCount[target.Role] = theClasses[target.Class].RoleCount[target.Role] + 1
			theClasses[BuffBroker.Constants.Classes.Raid].HeadCount = theClasses[BuffBroker.Constants.Classes.Raid].HeadCount + 1
		end
	end

	-- for: each class
	for _, className in pairs(BuffBroker.Constants.Classes) do

		-- if: only one person from the class
		if theClasses[className].HeadCount == 1 then
			-- use their role as the dominant role
			highestCount = 0
		else
			-- start new count;  to be dominant, there have to be 2 of that role
			highestCount = 1
		end
		
		-- for: each role
		for _, role in pairs(BuffBroker.Constants.Roles) do
			-- if: more of this role than the last dominant role
			if theClasses[className].RoleCount[role] > highestCount then
				
				-- Assign as new dominant role:  preserve head-count
				theClasses[className].DominantRole = role
				highestCount = theClasses[className].RoleCount[role]
			end -- if: more of this role than the last dominant role
		end -- for: each role
		
	end -- for: each class

	return theClasses
end

function BuffBroker:GetBuffDepth(Role, Spellid)
	local actualDepth, buffLabel
	local iDepth, currentLabel

	-- determine label of spell
	buffLabel = BuffBroker:SpellInfoFromID(Spellid)
	
	actualDepth = BuffList.BuffPriorities[Role][buffLabel]
	
	if not actualDepth then actualDepth = 0 end
	
	return actualDepth
end

function compareRaidPreference(left, right)
	local leftRaidPreference, rightRaidPreference = 0, 0
	local leftDepth, rightDepth = 0, 0

	-- for: each role
	for roleName, _ in pairs(BuffList.BuffPriorities) do
		-- if: have any of that role in the raid
		if left.RoleCount[roleName] and right.RoleCount[roleName] then
			leftDepth = BuffBroker:GetBuffDepth(roleName, left.spellid)
			rightDepth = BuffBroker:GetBuffDepth(roleName, right.spellid)
			
			if leftDepth and rightDepth then
				if leftDepth > rightDepth then
					-- roleName prefers left.spellid over right.spellid
					leftRaidPreference = leftRaidPreference + left.RoleCount[roleName]
				elseif leftDepth < rightDepth then
					-- roleName prefers right.spellid over left.spellid
					rightRaidPreference = rightRaidPreference + right.RoleCount[roleName]
				else
					-- roleName doesn't prefer either left.spellid or right.spellid
				end
			elseif leftDepth and not rightDepth then
				-- roleName doesn't care about right.spellid
				leftRaidPreference = leftRaidPreference + left.RoleCount[roleName]
			elseif not leftDepth and rightDepth then
				-- roleName doesn't care about left.spellid
				rightRaidPreference = rightRaidPreference + right.RoleCount[roleName]
			else
				-- roleName doesn't care about left.spellid or right.spellid
			end
		elseif left.RoleCount[roleName] ~= right.RoleCount[roleName] then
			print(L["BuffBroker:  Internal error, suggestions contain different role counts"])
		end -- if: have any of that role in the raid
	end
	
	return leftRaidPreference, rightRaidPreference
end

function OrderSuggestions(left, right)
	local buffLabel, suggestedLabel
	local leftFirst = false
	local leftPriority, rightPriority
	local leftRaidPreference, rightRaidPreference = 0, 0
	local leftDepth, rightDepth = 0, 0
	local groupScope

	-- left/right:  {Confidence=BuffBroker.Constants.Confidence.#, Target='name', TargetProfile=BuffList.Player[name], spellid=#, Attendance=#, IsDominantRole=bool}

	-- Determine 'how important this buff is (1 is very important)
	leftPriority = BuffBroker:GetBuffDepth(left.TargetProfile.Role, left.spellid)
	rightPriority = BuffBroker:GetBuffDepth(right.TargetProfile.Role, right.spellid)
	

	-- if: compare target validity
	if left.TargetProfile and not right.TargetProfile then
		leftFirst = true
	elseif (not left.TargetProfile and not right.TargetProfile) then
		-- Note:  we should NEVER get suggestions for targets which aren't in the cache!
		leftFirst = true
	elseif left.TargetProfile and right.TargetProfile then

		-- if: comparing line of sight
		if left.TargetProfile.LOS and not right.TargetProfile.LOS then
			leftFirst = true
		elseif left.TargetProfile.LOS == right.TargetProfile.LOS then

			-- if: comparing scope
			if left.Scope > right.Scope then
				leftFirst = true
			elseif left.Scope == right.Scope then
				
				-- same scope; check preference (raid only)
				if left.Scope == BuffBroker.Constants.Scope.Raid then
					leftRaidPreference, rightRaidPreference = compareRaidPreference(left, right)
				end
				
				-- if: raid-preference different AND isa raid buff
				if left.Scope == BuffBroker.Constants.Scope.Raid and (leftRaidPreference > rightRaidPreference) then
					leftFirst = true
				-- elseif: raid-wide preference is same
				elseif (left.Scope ~= BuffBroker.Constants.Scope.Raid) or (leftRaidPreference == rightRaidPreference) then
			
					if left.Attendance > right.Attendance then
						leftFirst = true
					elseif left.Attendance == right.Attendance then
						-- same attendance; check class

						if left.TargetProfile.Class < right.TargetProfile.Class then
							leftFirst = true
						elseif left.TargetProfile.Class == right.TargetProfile.Class then
							
							-- if: compare presence as dominant role
							if left.IsDominantRole and not right.IsDominantRole then
								-- left more dominant than right
								leftFirst = true
							elseif left.IsDominantRole == right.IsDominantRole then

								-- if: compare targets (players)
								if left.TargetProfile.Name < right.TargetProfile.Name then
									leftFirst = true
								elseif left.TargetProfile.Name == right.TargetProfile.Name then
									
									-- same target

									-- if: compare confidences
									if left.Confidence > right.Confidence then
										leftFirst = true
									elseif left.Confidence == right.Confidence then

										-- same confidence & class; check preference (class only)
										if left.Scope == BuffBroker.Constants.Scope.Class then
											leftRaidPreference, rightRaidPreference = compareRaidPreference(left, right)
										end
										
										-- if: class-preference different AND isa class buff
										if left.Scope == BuffBroker.Constants.Scope.Class and (leftRaidPreference > rightRaidPreference) then
											leftFirst = true
										-- elseif: class-wide preference is same
										elseif (left.Scope ~= BuffBroker.Constants.Scope.Class) or (leftRaidPreference == rightRaidPreference) then

											-- Determine how important this buff is (1 is very important)
											
											-- if: compare relevance of buff
											if leftPriority and not rightPriority then
												leftFirst = true
											elseif (leftPriority and rightPriority) and (leftPriority > rightPriority) then
												leftFirst = true
											elseif leftPriority == rightPriority then
													-- No two suggestions would have the same target, confidence, and priority... would they?
													-- might wind up here if comparing class buff vs profession buff, so put in SOME kind of reproducible comparator
													if left.spellid > right.spellid then
														leftFirst = true
													end
											end -- if: compare relevance of buff for both
										end -- if: comparing preference (class only)
									end -- if: compare confidences
								end -- if: compare targets(players)
							end -- if: compare presence as dominant role
						end -- if: comparing class
					end -- if: comparing attendance
				end -- if: comparing preference (raid only)
			end -- if: comparing scope
		end -- if: comparing line of sight
	end -- if: compare target validity

	--[[
	osL = 'Left: Attend: '..(left.Attendance * 100)..'%, C: '..left.TargetProfile.Class..', D: '
	if left.IsDominantRole then osL = osL..'T' else osL = osL..'F' end
	osL = osL..', N: '..left.TargetProfile.Name..', Conf: '..left.Confidence..', P: '
	if leftPriority then osL = osL..leftPriority end
	
	
	osR = 'Right: Attend: '..(right.Attendance * 100)..'%, C: '..right.TargetProfile.Class..', D: '
	if right.IsDominantRole then osR = osR..'T' else osR = osR..'F' end
	osR = osR..', N: '..right.TargetProfile.Name..', Conf: '..right.Confidence..', P: '
	if rightPriority then osR = osR..rightPriority end

	if leftFirst then print(osL..' ><before><'..osR) else print(osR..' ><before>< '..osL) end
	]]
	
	return leftFirst
end

function BuffBroker:RefreshConfig(event, database, newProfileKey)
	-- this is called every time our profile changes (after the change)
	profileDB = database.profile
	clearCache()
end

function BuffBroker:SetFailCode(failureMessage)
	if not BuffBroker.FailCodes[failureMessage] then
		print(failureMessage)
		BuffBroker.FailCodes[failureMessage] = true
	end
end
