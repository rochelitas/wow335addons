-- Roles:
--		Unknown = 1,
--		Tank = 2,
--		PureMelee = 3,
--		MeleeMana = 4,
--		Caster = 5,

--	Buffs:
--	None = 1, -- can't provide
--	ProfessionStats = 2, -- Leatherworking Kings
--	Basic = 3, -- class inherent (shaman/warrior)
--	BasicLong = 4, -- class inherent (paladin): wisdom, might, kings, sanctuary
--	MinorTalented = 5, -- partial talent investment, warrior (1,2 /5), shaman (1/3)
--	PartialTalentedLong = 6, -- partial talent investment, paladin (1/2)
--	MajorTalented = 7, -- partial talent investment, warrior (3,4 /5), shaman (2/3)
--	FullTalented = 7, -- 3/3 shaman totems, 5/5 warrior shouts
--	FullTalentedLong = 8, -- 2/2 paladin wisdom, 2/2 Paladin might


BuffBroker.TestCases = {}

BuffBroker.TestCases.MockPlayers =
	{
		PaladinHealer =
		{
			Name = "PaladinHealer",
			GUID = "PaladinHealer_GUID",
			Class = "PALADIN",
			Role = BuffBroker.Constants.Roles.Caster,
			Inspected = true,
			Level = 80,
			Near = true,
			LOS = true,
			CastableBuffs = {
				["AP"] = BuffBroker.Constants.Buffs.BasicLong,
				["HP"] = BuffBroker.Constants.Buffs.None,
				["STATS"] = BuffBroker.Constants.Buffs.BasicLong,
				["MP5"] = BuffBroker.Constants.Buffs.BasicLong,
				["TANK"] = BuffBroker.Constants.Buffs.None,
			},
			ActiveBuffs = {},
			BuffSlots = {
				["BLESSINGS"] = BuffBroker.Constants.BuffSlots["BLESSINGS_BASIC"],
			},
		},
			
		PaladinHealer_MP5 =
		{
			Name = "PaladinHealer_MP5",
			GUID = "PaladinHealer_MP5_GUID",
			Class = "PALADIN",
			Role = BuffBroker.Constants.Roles.Caster,
			Inspected = true,
			Level = 80,
			Near = true,
			LOS = true,
			CastableBuffs = {
				["AP"] = BuffBroker.Constants.Buffs.BasicLong,
				["HP"] = BuffBroker.Constants.Buffs.None,
				["STATS"] = BuffBroker.Constants.Buffs.BasicLong,
				["MP5"] = BuffBroker.Constants.Buffs.FullTalentedLong,
				["TANK"] = BuffBroker.Constants.Buffs.None,
			},
			ActiveBuffs = {},
			BuffSlots = {
				["BLESSINGS"] = BuffBroker.Constants.BuffSlots["BLESSINGS_BASIC"],
			},
		},
		
		PaladinHealer_AP =
		{
			Name = "PaladinHealer_AP",
			GUID = "PaladinHealer_AP_GUID",
			Class = "PALADIN",
			Role = BuffBroker.Constants.Roles.Caster,
			Inspected = true,
			Level = 80,
			Near = true,
			LOS = true,
			CastableBuffs = {
				["AP"] = BuffBroker.Constants.Buffs.FullTalentedLong,
				["HP"] = BuffBroker.Constants.Buffs.None,
				["STATS"] = BuffBroker.Constants.Buffs.BasicLong,
				["MP5"] = BuffBroker.Constants.Buffs.BasicLong,
				["TANK"] = BuffBroker.Constants.Buffs.None,
			},
			ActiveBuffs = {},
			BuffSlots = {
				["BLESSINGS"] = BuffBroker.Constants.BuffSlots["BLESSINGS_BASIC"],
			},
		},
		
		PaladinHealer_MP5_AP =
		{
			Name = "PaladinHealer_MP5_AP",
			GUID = "PaladinHealer_MP5_AP_GUID",
			Class = "PALADIN",
			Role = BuffBroker.Constants.Roles.Caster,
			Inspected = true,
			Level = 80,
			Near = true,
			LOS = true,
			CastableBuffs = {
				["AP"] = BuffBroker.Constants.Buffs.FullTalentedLong,
				["HP"] = BuffBroker.Constants.Buffs.None,
				["STATS"] = BuffBroker.Constants.Buffs.BasicLong,
				["MP5"] = BuffBroker.Constants.Buffs.FullTalentedLong,
				["TANK"] = BuffBroker.Constants.Buffs.None,
			},
			ActiveBuffs = {},
			BuffSlots = {
				["BLESSINGS"] = BuffBroker.Constants.BuffSlots["BLESSINGS_BASIC"],
			},
		},
		
		PaladinMelee =
		{
			Name = "PaladinMelee",
			GUID = "PaladinMelee_GUID",
			Class = "PALADIN",
			Role = BuffBroker.Constants.Roles.MeleeMana,
			Inspected = true,
			Level = 80,
			Near = true,
			LOS = true,
			CastableBuffs = {
				["AP"] = BuffBroker.Constants.Buffs.BasicLong,
				["HP"] = BuffBroker.Constants.Buffs.None,
				["STATS"] = BuffBroker.Constants.Buffs.BasicLong,
				["MP5"] = BuffBroker.Constants.Buffs.BasicLong,
				["TANK"] = BuffBroker.Constants.Buffs.None,
			},
			ActiveBuffs = {},
			BuffSlots = {
				["BLESSINGS"] = BuffBroker.Constants.BuffSlots["BLESSINGS_BASIC"],
			},
		},
		
		PaladinMelee_AP =
		{
			Name = "PaladinMelee_AP",
			GUID = "PaladinMelee_AP_GUID",
			Class = "PALADIN",
			Role = BuffBroker.Constants.Roles.MeleeMana,
			Inspected = true,
			Level = 80,
			Near = true,
			LOS = true,
			CastableBuffs = {
				["AP"] = BuffBroker.Constants.Buffs.FullTalentedLong,
				["HP"] = BuffBroker.Constants.Buffs.None,
				["STATS"] = BuffBroker.Constants.Buffs.BasicLong,
				["MP5"] = BuffBroker.Constants.Buffs.BasicLong,
				["TANK"] = BuffBroker.Constants.Buffs.None,
			},
			ActiveBuffs = {},
			BuffSlots = {
				["BLESSINGS"] = BuffBroker.Constants.BuffSlots["BLESSINGS_BASIC"],
			},
		},
		
		PaladinTank =
		{
			Name = "PaladinTank",
			GUID = "PaladinTank_GUID",
			Class = "PALADIN",
			Role = BuffBroker.Constants.Roles.Tank,
			Inspected = true,
			Level = 80,
			Near = true,
			LOS = true,
			CastableBuffs = {
				["AP"] = BuffBroker.Constants.Buffs.BasicLong,
				["HP"] = BuffBroker.Constants.Buffs.None,
				["STATS"] = BuffBroker.Constants.Buffs.BasicLong,
				["MP5"] = BuffBroker.Constants.Buffs.BasicLong,
				["TANK"] = BuffBroker.Constants.Buffs.FullTalentedLong,
			},
			ActiveBuffs = {},
			BuffSlots = {
				["BLESSINGS"] = BuffBroker.Constants.BuffSlots["BLESSINGS"],
			},
		},
		
		PaladinTank_AP =
		{
			Name = "PaladinTank_AP",
			GUID = "PaladinTank_AP_GUID",
			Class = "PALADIN",
			Role = BuffBroker.Constants.Roles.Tank,
			Inspected = true,
			Level = 80,
			Near = true,
			LOS = true,
			CastableBuffs = {
				["AP"] = BuffBroker.Constants.Buffs.FullTalentedLong,
				["HP"] = BuffBroker.Constants.Buffs.None,
				["STATS"] = BuffBroker.Constants.Buffs.BasicLong,
				["MP5"] = BuffBroker.Constants.Buffs.BasicLong,
				["TANK"] = BuffBroker.Constants.Buffs.FullTalentedLong,
			},
			ActiveBuffs = {},
			BuffSlots = {
				["BLESSINGS"] = BuffBroker.Constants.BuffSlots["BLESSINGS"],
			},
		},
		
		PureMelee =
		{
			Name = "PureMelee",
			GUID = "PureMelee_GUID",
			Class = "DRUID",
			Role = BuffBroker.Constants.Roles.PureMelee,
			Inspected = true,
			Level = 80,
			Near = true,
			LOS = true,
			CastableBuffs = {
				["AP"] = BuffBroker.Constants.Buffs.None,
				["HP"] = BuffBroker.Constants.Buffs.None,
				["STATS"] = BuffBroker.Constants.Buffs.None,
				["MP5"] = BuffBroker.Constants.Buffs.None,
				["TANK"] = BuffBroker.Constants.Buffs.None,
			},
			ActiveBuffs = {},
			BuffSlots = {},
		},
		
		PureMeleeAlt =
		{
			Name = "PureMeleeAlt",
			GUID = "PureMeleeAlt_GUID",
			Class = "DEATHKNIGHT",
			Role = BuffBroker.Constants.Roles.PureMelee,
			Inspected = true,
			Level = 80,
			Near = true,
			LOS = true,
			CastableBuffs = {
				["AP"] = BuffBroker.Constants.Buffs.None,
				["HP"] = BuffBroker.Constants.Buffs.None,
				["STATS"] = BuffBroker.Constants.Buffs.None,
				["MP5"] = BuffBroker.Constants.Buffs.None,
				["TANK"] = BuffBroker.Constants.Buffs.None,
			},
			ActiveBuffs = {},
			BuffSlots = {},
		},
		
		Caster =
		{
			Name = "Caster",
			GUID = "Caster_GUID",
			Class = "WARLOCK",
			Role = BuffBroker.Constants.Roles.Caster,
			Inspected = true,
			Level = 80,
			Near = true,
			LOS = true,
			CastableBuffs = {
				["AP"] = BuffBroker.Constants.Buffs.None,
				["HP"] = BuffBroker.Constants.Buffs.None,
				["STATS"] = BuffBroker.Constants.Buffs.None,
				["MP5"] = BuffBroker.Constants.Buffs.None,
				["TANK"] = BuffBroker.Constants.Buffs.None,
			},
			ActiveBuffs = {},
			BuffSlots = {},
		},
		
		Healer =
		{
			Name = "Healer",
			GUID = "Healer_GUID",
			Class = "PRIEST",
			Role = BuffBroker.Constants.Roles.Caster,
			Inspected = true,
			Level = 80,
			Near = true,
			LOS = true,
			CastableBuffs = {
				["AP"] = BuffBroker.Constants.Buffs.None,
				["HP"] = BuffBroker.Constants.Buffs.None,
				["STATS"] = BuffBroker.Constants.Buffs.None,
				["MP5"] = BuffBroker.Constants.Buffs.None,
				["TANK"] = BuffBroker.Constants.Buffs.None,
			},
			ActiveBuffs = {},
			BuffSlots = {},
		},
		
		Owl =
		{
			Name = "Owl",
			GUID = "Owl_GUID",
			Class = "DRUID",
			Role = BuffBroker.Constants.Roles.Caster,
			Inspected = true,
			Level = 80,
			Near = true,
			LOS = true,
			CastableBuffs = {
				["THORNS"] = BuffBroker.Constants.Buffs.FullTalented,
				["WILD"] = BuffBroker.Constants.Buffs.Basic,
			},
			ActiveBuffs = {},
			BuffSlots = {},
		},
		
		Tree =
		{
			Name = "Tree",
			GUID = "Tree_GUID",
			Class = "DRUID",
			Role = BuffBroker.Constants.Roles.Healer,
			Inspected = true,
			Level = 80,
			Near = true,
			LOS = true,
			CastableBuffs = {
				["THORNS"] = BuffBroker.Constants.Buffs.Basic,
				["WILD"] = BuffBroker.Constants.Buffs.FullTalented,
			},
			ActiveBuffs = {},
			BuffSlots = {},
		},
		
		MeleeMana = 
		{
			Name = "MeleeMana",
			GUID = "MeleeMana_GUID",
			Class = "HUNTER",
			Role = BuffBroker.Constants.Roles.MeleeMana,
			Inspected = true,
			Level = 80,
			Near = true,
			LOS = true,
			Near = true,
			LOS = true,
			CastableBuffs = {
				["AP"] = BuffBroker.Constants.Buffs.None,
				["HP"] = BuffBroker.Constants.Buffs.None,
				["STATS"] = BuffBroker.Constants.Buffs.None,
				["MP5"] = BuffBroker.Constants.Buffs.None,
				["TANK"] = BuffBroker.Constants.Buffs.None,
			},
			ActiveBuffs = {},
			BuffSlots = {},
		},
		
		MeleeManaFar = 
		{
			Name = "MeleeManaFar",
			GUID = "MeleeManaFar_GUID",
			Class = "HUNTER",
			Role = BuffBroker.Constants.Roles.MeleeMana,
			Inspected = true,
			Level = 80,
			Near = nil,
			LOS = true,
			CastableBuffs = {
				["AP"] = BuffBroker.Constants.Buffs.None,
				["HP"] = BuffBroker.Constants.Buffs.None,
				["STATS"] = BuffBroker.Constants.Buffs.None,
				["MP5"] = BuffBroker.Constants.Buffs.None,
				["TANK"] = BuffBroker.Constants.Buffs.None,
			},
			ActiveBuffs = {},
			BuffSlots = {},
		},
		
		Warrior = 
		{
			Name = "Warrior",
			GUID = "Warrior_GUID",
			Class = "WARRIOR",
			Role = BuffBroker.Constants.Roles.PureMelee,
			Inspected = true,
			Level = 80,
			Near = true,
			LOS = true,
			CastableBuffs = {
				["AP"] = BuffBroker.Constants.Buffs.Basic,
				["HP"] = BuffBroker.Constants.Buffs.Basic,
				["STATS"] = BuffBroker.Constants.Buffs.None,
				["MP5"] = BuffBroker.Constants.Buffs.None,
				["TANK"] = BuffBroker.Constants.Buffs.None,
			},
			ActiveBuffs = {},
			BuffSlots = {
				["SHOUTS"] = BuffBroker.Constants.BuffSlots["SHOUTS"],
			},
		},

		Warrior_AP = 
		{
			Name = "Warrior_AP",
			GUID = "Warrior_AP_GUID",
			Class = "WARRIOR",
			Role = BuffBroker.Constants.Roles.PureMelee,
			Inspected = true,
			Level = 80,
			Near = true,
			LOS = true,
			CastableBuffs = {
				["AP"] = BuffBroker.Constants.Buffs.FullTalented,
				["HP"] = BuffBroker.Constants.Buffs.FullTalented,
				["STATS"] = BuffBroker.Constants.Buffs.None,
				["MP5"] = BuffBroker.Constants.Buffs.None,
				["TANK"] = BuffBroker.Constants.Buffs.None,
			},
			ActiveBuffs = {},
			BuffSlots = {
				["SHOUTS"] = BuffBroker.Constants.BuffSlots["SHOUTS"],
			},
		},

		ShamanCaster = 
		{
			Name = "ShamanCaster",
			GUID = "ShamanCaster_GUID",
			Class = "SHAMAN",
			Role = BuffBroker.Constants.Roles.Caster,
			Inspected = true,
			Level = 80,
			Near = true,
			LOS = true,
			CastableBuffs = {
				["AP"] = BuffBroker.Constants.Buffs.None,
				["HP"] = BuffBroker.Constants.Buffs.None,
				["STATS"] = BuffBroker.Constants.Buffs.None,
				["MP5"] = BuffBroker.Constants.Buffs.Basic,
				["TANK"] = BuffBroker.Constants.Buffs.None,
			},
			ActiveBuffs = {},
			BuffSlots = {
				["WATER_TOTEMS"] = BuffBroker.Constants.BuffSlots["WATER_TOTEMS"],
			},
		},

		ShamanMelee = 
		{
			Name = "ShamanMelee",
			GUID = "ShamanMelee_GUID",
			Class = "SHAMAN",
			Role = BuffBroker.Constants.Roles.MeleeMana,
			Inspected = true,
			Level = 80,
			Near = true,
			LOS = true,
			CastableBuffs = {
				["AP"] = BuffBroker.Constants.Buffs.None,
				["HP"] = BuffBroker.Constants.Buffs.None,
				["STATS"] = BuffBroker.Constants.Buffs.None,
				["MP5"] = BuffBroker.Constants.Buffs.Basic,
				["TANK"] = BuffBroker.Constants.Buffs.None,
			},
			ActiveBuffs = {},
			BuffSlots = {
				["WATER_TOTEMS"] = BuffBroker.Constants.BuffSlots["WATER_TOTEMS"],
			},
		},

		ShamanCaster_MP5 = 
		{
			Name = "ShamanCaster_MP5",
			GUID = "ShamanCaster_MP5_GUID",
			Class = "SHAMAN",
			Role = BuffBroker.Constants.Roles.Caster,
			Inspected = true,
			Level = 80,
			Near = true,
			LOS = true,
			CastableBuffs = {
				["AP"] = BuffBroker.Constants.Buffs.None,
				["HP"] = BuffBroker.Constants.Buffs.None,
				["STATS"] = BuffBroker.Constants.Buffs.None,
				["MP5"] = BuffBroker.Constants.Buffs.FullTalented,
				["TANK"] = BuffBroker.Constants.Buffs.None,
			},
			ActiveBuffs = {},
			BuffSlots = {
				["WATER_TOTEMS"] = BuffBroker.Constants.BuffSlots["WATER_TOTEMS"],
			},
		},
	}
	
BuffBroker.TestCases.Groups =
{
	SoloPally =
	{
		{
			Test = "Paladin, untalented (melee)",
			Others = "none",
			Raid = "solo",
			Players = {
				[BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID] = BuffBroker.TestCases.MockPlayers.PaladinMelee,
			},
			PlayerGUID = BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID,
			Results = {
				["MP5"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID,},TotalCount=1},
				["AP"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID,},TotalCount=1},
				["HP"] = {Strength=BuffBroker.Constants.Buffs.None,Players = {},TotalCount=0},
				["STATS"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID,},TotalCount=1},
				["TANK"] = {Strength=BuffBroker.Constants.Buffs.None,Players = {},TotalCount=0},
			},
			Suggestions = {
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID, spellid=25894}, --g wisdom

				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID, spellid=19742}, --wisdom
			},
		},
		
		{
			Test = "Paladin, untalented (healer)",
			Others = "none",
			Raid = "solo",
			Players = {
				[BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID] = BuffBroker.TestCases.MockPlayers.PaladinHealer,
			},
			PlayerGUID = BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID,
			Results = {
				["MP5"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID,},TotalCount=1},
				["AP"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID,},TotalCount=1},
				["HP"] = {Strength=BuffBroker.Constants.Buffs.None,Players = {},TotalCount=0},
				["STATS"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID,},TotalCount=1},
				["TANK"] = {Strength=BuffBroker.Constants.Buffs.None,Players = {},TotalCount=0},
			},
			Suggestions = {
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID, spellid=25894}, --g wisdom

				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID, spellid=19742}, --wisdom
			},
		},
		
		{
			Test = "Paladin, tank",
			Others = "none",
			Raid = "solo",
			Players = {
				[BuffBroker.TestCases.MockPlayers.PaladinTank.GUID] = BuffBroker.TestCases.MockPlayers.PaladinTank,
			},
			PlayerGUID = BuffBroker.TestCases.MockPlayers.PaladinTank.GUID,
			Results = {
				["MP5"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinTank.GUID,},TotalCount=1},
				["AP"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinTank.GUID,},TotalCount=1},
				["HP"] = {Strength=BuffBroker.Constants.Buffs.None,Players = {},TotalCount=0},
				["STATS"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinTank.GUID,},TotalCount=1},
				["TANK"] = {Strength=BuffBroker.Constants.Buffs.FullTalentedLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinTank.GUID,},TotalCount=1},
			},
			Suggestions = {
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinTank.GUID, spellid=25899}, --g sanctuary
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinTank.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinTank.GUID, spellid=25782}, --g might

				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinTank.GUID, spellid=20911}, --sanctuary
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinTank.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinTank.GUID, spellid=19740}, --might
			},
		},
		
		{
			Test = "Paladin, imp might (melee)",
			Others = "none",
			Raid = "solo",
			Players = {
				[BuffBroker.TestCases.MockPlayers.PaladinMelee_AP.GUID] = BuffBroker.TestCases.MockPlayers.PaladinMelee_AP,
			},
			PlayerGUID = BuffBroker.TestCases.MockPlayers.PaladinMelee_AP.GUID,
			Results = {
				["MP5"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinMelee_AP.GUID,},TotalCount=1},
				["AP"] = {Strength=BuffBroker.Constants.Buffs.FullTalentedLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinMelee_AP.GUID,},TotalCount=1},
				["HP"] = {Strength=BuffBroker.Constants.Buffs.None,Players = {},TotalCount=0},
				["STATS"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinMelee_AP.GUID,},TotalCount=1},
				["TANK"] = {Strength=BuffBroker.Constants.Buffs.None,Players = {},TotalCount=0},
			},
			Suggestions = {
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee_AP.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee_AP.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee_AP.GUID, spellid=25894}, --g wisdom

				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee_AP.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee_AP.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee_AP.GUID, spellid=19742}, --wisdom
			},
		},
		
		{
			Test = "Paladin, imp might (healer)",
			Others = "none",
			Raid = "solo",
			Players = {
				[BuffBroker.TestCases.MockPlayers.PaladinHealer_AP.GUID] = BuffBroker.TestCases.MockPlayers.PaladinHealer_AP,
			},
			PlayerGUID = BuffBroker.TestCases.MockPlayers.PaladinHealer_AP.GUID,
			Results = {
				["MP5"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer_AP.GUID,},TotalCount=1},
				["AP"] = {Strength=BuffBroker.Constants.Buffs.FullTalentedLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer_AP.GUID,},TotalCount=1},
				["HP"] = {Strength=BuffBroker.Constants.Buffs.None,Players = {},TotalCount=0},
				["STATS"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer_AP.GUID,},TotalCount=1},
				["TANK"] = {Strength=BuffBroker.Constants.Buffs.None,Players = {},TotalCount=0},
			},
			Suggestions = {
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer_AP.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer_AP.GUID, spellid=25894}, --g wisdom

				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer_AP.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer_AP.GUID, spellid=19742}, --wisdom
			},
		},
		
		{
			Test = "Paladin, imp might (tank)",
			Others = "none",
			Raid = "solo",
			Players = {
				[BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID] = BuffBroker.TestCases.MockPlayers.PaladinTank_AP,
			},
			PlayerGUID = BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID,
			Results = {
				["MP5"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID,},TotalCount=1},
				["AP"] = {Strength=BuffBroker.Constants.Buffs.FullTalentedLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID,},TotalCount=1},
				["HP"] = {Strength=BuffBroker.Constants.Buffs.None,Players = {},TotalCount=0},
				["STATS"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID,},TotalCount=1},
				["TANK"] = {Strength=BuffBroker.Constants.Buffs.FullTalentedLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID,},TotalCount=1},
			},
			Suggestions = {
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID, spellid=25899}, --g sanctuary
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID, spellid=25782}, --g might

				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID, spellid=20911}, --sanctuary
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID, spellid=19740}, --might
			},
		},
		
		{
			Test = "Paladin, imp wisdom",
			Others = "none",
			Raid = "solo",
			Players = {
				[BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5.GUID] = BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5,
			},
			PlayerGUID = BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5.GUID,
			Results = {
				["MP5"] = {Strength=BuffBroker.Constants.Buffs.FullTalentedLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5.GUID,},TotalCount=1},
				["AP"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5.GUID,},TotalCount=1},
				["HP"] = {Strength=BuffBroker.Constants.Buffs.None,Players = {},TotalCount=0},
				["STATS"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5.GUID,},TotalCount=1},
				["TANK"] = {Strength=BuffBroker.Constants.Buffs.None,Players = {},TotalCount=0},
			},
			Suggestions = {
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5.GUID, spellid=25894}, --g wisdom

				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5.GUID, spellid=19742}, --wisdom
			},
		},
		
		{
			Test = "Paladin, imp wisdom/might",
			Others = "none",
			Raid = "solo",
			Players = {
				[BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5_AP.GUID] = BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5_AP,
			},
			PlayerGUID = BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5_AP.GUID,
			Results = {
				["MP5"] = {Strength=BuffBroker.Constants.Buffs.FullTalentedLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5_AP.GUID,},TotalCount=1},
				["AP"] = {Strength=BuffBroker.Constants.Buffs.FullTalentedLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5_AP.GUID,},TotalCount=1},
				["HP"] = {Strength=BuffBroker.Constants.Buffs.None,Players = {},TotalCount=0},
				["STATS"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5_AP.GUID,},TotalCount=1},
				["TANK"] = {Strength=BuffBroker.Constants.Buffs.None,Players = {},TotalCount=0},
			},
			Suggestions = {
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5_AP.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5_AP.GUID, spellid=25894}, --g wisdom

				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5_AP.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5_AP.GUID, spellid=19742}, --wisdom
			},
		},
	},

	PartyPally =
	{
		{
			Test = "Paladin, untalented (melee)",
			Others = "none",
			Raid = "party",
			Players = {
				[BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID] = BuffBroker.TestCases.MockPlayers.PaladinMelee,
				[BuffBroker.TestCases.MockPlayers.PureMelee.GUID] = BuffBroker.TestCases.MockPlayers.PureMelee,
				[BuffBroker.TestCases.MockPlayers.Caster.GUID] = BuffBroker.TestCases.MockPlayers.Caster,
				[BuffBroker.TestCases.MockPlayers.MeleeMana.GUID] = BuffBroker.TestCases.MockPlayers.MeleeMana,
				[BuffBroker.TestCases.MockPlayers.Healer.GUID] = BuffBroker.TestCases.MockPlayers.Healer,
			},
			PlayerGUID = BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID,
			Results = {
				["MP5"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID,},TotalCount=1},
				["AP"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID,},TotalCount=1},
				["HP"] = {Strength=BuffBroker.Constants.Buffs.None,Players = {},TotalCount=0},
				["STATS"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID,},TotalCount=1},
				["TANK"] = {Strength=BuffBroker.Constants.Buffs.None,Players = {},TotalCount=0},
			},
			Suggestions = {
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID, spellid=25782}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID, spellid=25898}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID, spellid=25894}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=25894}, --g wisdom

				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=19742}, --wisdom
			},
		},
		
		{
			Test = "Paladin, untalented (healer)",
			Others = "none",
			Raid = "party",
			Players = {
				[BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID] = BuffBroker.TestCases.MockPlayers.PaladinHealer,
				[BuffBroker.TestCases.MockPlayers.PureMelee.GUID] = BuffBroker.TestCases.MockPlayers.PureMelee,
				[BuffBroker.TestCases.MockPlayers.Caster.GUID] = BuffBroker.TestCases.MockPlayers.Caster,
				[BuffBroker.TestCases.MockPlayers.MeleeMana.GUID] = BuffBroker.TestCases.MockPlayers.MeleeMana,
				[BuffBroker.TestCases.MockPlayers.Healer.GUID] = BuffBroker.TestCases.MockPlayers.Healer,
			},
			PlayerGUID = BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID,
			Results = {
				["MP5"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID,},TotalCount=1},
				["AP"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID,},TotalCount=1},
				["HP"] = {Strength=BuffBroker.Constants.Buffs.None,Players = {},TotalCount=0},
				["STATS"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID,},TotalCount=1},
				["TANK"] = {Strength=BuffBroker.Constants.Buffs.None,Players = {},TotalCount=0},
			},
			-- match player name/buff
			Suggestions = {
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID, spellid=25898}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID, spellid=25894}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=25894}, --g wisdom

				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=19742}, --wisdom
			},
		},
		
		{
			Test = "Paladin, tank",
			Others = "none",
			Raid = "party",
			Players = {
				[BuffBroker.TestCases.MockPlayers.PaladinTank.GUID] = BuffBroker.TestCases.MockPlayers.PaladinTank,
				[BuffBroker.TestCases.MockPlayers.PureMelee.GUID] = BuffBroker.TestCases.MockPlayers.PureMelee,
				[BuffBroker.TestCases.MockPlayers.Caster.GUID] = BuffBroker.TestCases.MockPlayers.Caster,
				[BuffBroker.TestCases.MockPlayers.MeleeMana.GUID] = BuffBroker.TestCases.MockPlayers.MeleeMana,
				[BuffBroker.TestCases.MockPlayers.Healer.GUID] = BuffBroker.TestCases.MockPlayers.Healer,
			},
			PlayerGUID = BuffBroker.TestCases.MockPlayers.PaladinTank.GUID,
			Results = {
				["MP5"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinTank.GUID,},TotalCount=1},
				["AP"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinTank.GUID,},TotalCount=1},
				["HP"] = {Strength=BuffBroker.Constants.Buffs.None,Players = {},TotalCount=0},
				["STATS"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinTank.GUID,},TotalCount=1},
				["TANK"] = {Strength=BuffBroker.Constants.Buffs.FullTalentedLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinTank.GUID,},TotalCount=1},
			},
			Suggestions = {
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinTank.GUID, spellid=25899}, --sanctuary
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinTank.GUID, spellid=25898}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinTank.GUID, spellid=25782}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=25894}, --g wisdom

				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinTank.GUID, spellid=20911}, --sanctuary
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinTank.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinTank.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=19742}, --wisdom
			},
		},
		
		{
			Test = "Paladin, imp might (melee)",
			Others = "none",
			Raid = "party",
			Players = {
				[BuffBroker.TestCases.MockPlayers.PaladinMelee_AP.GUID] = BuffBroker.TestCases.MockPlayers.PaladinMelee_AP,
				[BuffBroker.TestCases.MockPlayers.PureMelee.GUID] = BuffBroker.TestCases.MockPlayers.PureMelee,
				[BuffBroker.TestCases.MockPlayers.Caster.GUID] = BuffBroker.TestCases.MockPlayers.Caster,
				[BuffBroker.TestCases.MockPlayers.MeleeMana.GUID] = BuffBroker.TestCases.MockPlayers.MeleeMana,
				[BuffBroker.TestCases.MockPlayers.Healer.GUID] = BuffBroker.TestCases.MockPlayers.Healer,
			},
			PlayerGUID = BuffBroker.TestCases.MockPlayers.PaladinMelee_AP.GUID,
			Results = {
				["MP5"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinMelee_AP.GUID,},TotalCount=1},
				["AP"] = {Strength=BuffBroker.Constants.Buffs.FullTalentedLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinMelee_AP.GUID,},TotalCount=1},
				["HP"] = {Strength=BuffBroker.Constants.Buffs.None,Players = {},TotalCount=0},
				["STATS"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinMelee_AP.GUID,},TotalCount=1},
				["TANK"] = {Strength=BuffBroker.Constants.Buffs.None,Players = {},TotalCount=0},
			},
			Suggestions = {
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee_AP.GUID, spellid=25782}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee_AP.GUID, spellid=25898}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee_AP.GUID, spellid=25894}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=25894}, --g wisdom

				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee_AP.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee_AP.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee_AP.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=19742}, --wisdom
			},
		},
		
		{
			Test = "Paladin, imp might (healer)",
			Others = "none",
			Raid = "party",
			Players = {
				[BuffBroker.TestCases.MockPlayers.PaladinHealer_AP.GUID] = BuffBroker.TestCases.MockPlayers.PaladinHealer_AP,
				[BuffBroker.TestCases.MockPlayers.PureMelee.GUID] = BuffBroker.TestCases.MockPlayers.PureMelee,
				[BuffBroker.TestCases.MockPlayers.Caster.GUID] = BuffBroker.TestCases.MockPlayers.Caster,
				[BuffBroker.TestCases.MockPlayers.MeleeMana.GUID] = BuffBroker.TestCases.MockPlayers.MeleeMana,
				[BuffBroker.TestCases.MockPlayers.Healer.GUID] = BuffBroker.TestCases.MockPlayers.Healer,
			},
			PlayerGUID = BuffBroker.TestCases.MockPlayers.PaladinHealer_AP.GUID,
			Results = {
				["MP5"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer_AP.GUID,},TotalCount=1},
				["AP"] = {Strength=BuffBroker.Constants.Buffs.FullTalentedLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer_AP.GUID,},TotalCount=1},
				["HP"] = {Strength=BuffBroker.Constants.Buffs.None,Players = {},TotalCount=0},
				["STATS"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer_AP.GUID,},TotalCount=1},
				["TANK"] = {Strength=BuffBroker.Constants.Buffs.None,Players = {},TotalCount=0},
			},
			Suggestions = {
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer_AP.GUID, spellid=25898}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer_AP.GUID, spellid=25894}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=25894}, --g wisdom

				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer_AP.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer_AP.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=19742}, --wisdom
			},
		},
		
		{
			Test = "Paladin, imp might (tank)",
			Others = "none",
			Raid = "party",
			Players = {
				[BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID] = BuffBroker.TestCases.MockPlayers.PaladinTank_AP,
				[BuffBroker.TestCases.MockPlayers.PureMelee.GUID] = BuffBroker.TestCases.MockPlayers.PureMelee,
				[BuffBroker.TestCases.MockPlayers.Caster.GUID] = BuffBroker.TestCases.MockPlayers.Caster,
				[BuffBroker.TestCases.MockPlayers.MeleeMana.GUID] = BuffBroker.TestCases.MockPlayers.MeleeMana,
				[BuffBroker.TestCases.MockPlayers.Healer.GUID] = BuffBroker.TestCases.MockPlayers.Healer,
			},
			PlayerGUID = BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID,
			Results = {
				["MP5"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID,},TotalCount=1},
				["AP"] = {Strength=BuffBroker.Constants.Buffs.FullTalentedLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID,},TotalCount=1},
				["HP"] = {Strength=BuffBroker.Constants.Buffs.None,Players = {},TotalCount=0},
				["STATS"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID,},TotalCount=1},
				["TANK"] = {Strength=BuffBroker.Constants.Buffs.FullTalentedLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID,},TotalCount=1},
			},
			Suggestions = {
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID, spellid=25899}, --sanctuary
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID, spellid=25898}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID, spellid=25782}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=25894}, --g wisdom

				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID, spellid=20911}, --sanctuary
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=19742}, --wisdom
			},
		},
		
		{
			Test = "Paladin, imp wisdom",
			Others = "none",
			Raid = "party",
			Players = {
				[BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5.GUID] = BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5,
				[BuffBroker.TestCases.MockPlayers.PureMelee.GUID] = BuffBroker.TestCases.MockPlayers.PureMelee,
				[BuffBroker.TestCases.MockPlayers.Caster.GUID] = BuffBroker.TestCases.MockPlayers.Caster,
				[BuffBroker.TestCases.MockPlayers.MeleeMana.GUID] = BuffBroker.TestCases.MockPlayers.MeleeMana,
				[BuffBroker.TestCases.MockPlayers.Healer.GUID] = BuffBroker.TestCases.MockPlayers.Healer,
			},
			PlayerGUID = BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5.GUID,
			Results = {
				["MP5"] = {Strength=BuffBroker.Constants.Buffs.FullTalentedLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5.GUID,},TotalCount=1},
				["AP"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5.GUID,},TotalCount=1},
				["HP"] = {Strength=BuffBroker.Constants.Buffs.None,Players = {},TotalCount=0},
				["STATS"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5.GUID,},TotalCount=1},
				["TANK"] = {Strength=BuffBroker.Constants.Buffs.None,Players = {},TotalCount=0},
			},
			Suggestions = {
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5.GUID, spellid=25898}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5.GUID, spellid=25894}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=25894}, --g wisdom

				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=19742}, --wisdom
			},
		},
		
		{
			Test = "Paladin, imp wisdom/might",
			Others = "none",
			Raid = "party",
			Players = {
				[BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5_AP.GUID] = BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5_AP,
				[BuffBroker.TestCases.MockPlayers.PureMelee.GUID] = BuffBroker.TestCases.MockPlayers.PureMelee,
				[BuffBroker.TestCases.MockPlayers.Caster.GUID] = BuffBroker.TestCases.MockPlayers.Caster,
				[BuffBroker.TestCases.MockPlayers.MeleeMana.GUID] = BuffBroker.TestCases.MockPlayers.MeleeMana,
				[BuffBroker.TestCases.MockPlayers.Healer.GUID] = BuffBroker.TestCases.MockPlayers.Healer,
			},
			PlayerGUID = BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5_AP.GUID,
			Results = {
				["MP5"] = {Strength=BuffBroker.Constants.Buffs.FullTalentedLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5_AP.GUID,},TotalCount=1},
				["AP"] = {Strength=BuffBroker.Constants.Buffs.FullTalentedLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5_AP.GUID,},TotalCount=1},
				["HP"] = {Strength=BuffBroker.Constants.Buffs.None,Players = {},TotalCount=0},
				["STATS"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5_AP.GUID,},TotalCount=1},
				["TANK"] = {Strength=BuffBroker.Constants.Buffs.None,Players = {},TotalCount=0},
			},
			Suggestions = {
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5_AP.GUID, spellid=25898}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5_AP.GUID, spellid=25894}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=25894}, --g wisdom

				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5_AP.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5_AP.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=19742}, --wisdom
			},
		},

	},


	PartyPallyWarrior =
	{
		{
			Test = "Paladin, untalented (melee)",
			Others = "none",
			Raid = "party",
			Players = {
				[BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID] = BuffBroker.TestCases.MockPlayers.PaladinMelee,
				[BuffBroker.TestCases.MockPlayers.PureMelee.GUID] = BuffBroker.TestCases.MockPlayers.PureMelee,
				[BuffBroker.TestCases.MockPlayers.Warrior.GUID] = BuffBroker.TestCases.MockPlayers.Warrior,
				[BuffBroker.TestCases.MockPlayers.MeleeMana.GUID] = BuffBroker.TestCases.MockPlayers.MeleeMana,
				[BuffBroker.TestCases.MockPlayers.Healer.GUID] = BuffBroker.TestCases.MockPlayers.Healer,
			},
			PlayerGUID = BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID,
			Results = {
				["MP5"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID,},TotalCount=1},
				["AP"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID,},TotalCount=2},
				["HP"] = {Strength=BuffBroker.Constants.Buffs.Basic,Players = {BuffBroker.TestCases.MockPlayers.Warrior.GUID},TotalCount=1},
				["STATS"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID,},TotalCount=1},
				["TANK"] = {Strength=BuffBroker.Constants.Buffs.None,Players = {},TotalCount=0},
			},
			Suggestions = {
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Warrior.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Warrior.GUID, spellid=25898}, --g kings

				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Warrior.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.Warrior.GUID, spellid=19740}, --might
			},
		},
		
		{
			Test = "Paladin, untalented (healer)",
			Others = "none",
			Raid = "party",
			Players = {
				[BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID] = BuffBroker.TestCases.MockPlayers.PaladinHealer,
				[BuffBroker.TestCases.MockPlayers.PureMelee.GUID] = BuffBroker.TestCases.MockPlayers.PureMelee,
				[BuffBroker.TestCases.MockPlayers.Warrior.GUID] = BuffBroker.TestCases.MockPlayers.Warrior,
				[BuffBroker.TestCases.MockPlayers.MeleeMana.GUID] = BuffBroker.TestCases.MockPlayers.MeleeMana,
				[BuffBroker.TestCases.MockPlayers.Caster.GUID] = BuffBroker.TestCases.MockPlayers.Caster,
			},
			PlayerGUID = BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID,
			Results = {
				["MP5"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID,},TotalCount=1},
				["AP"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID,},TotalCount=2},
				["HP"] = {Strength=BuffBroker.Constants.Buffs.Basic,Players = {BuffBroker.TestCases.MockPlayers.Warrior.GUID},TotalCount=1},
				["STATS"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID,},TotalCount=1},
				["TANK"] = {Strength=BuffBroker.Constants.Buffs.None,Players = {},TotalCount=0},
			},
			Suggestions = {
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Warrior.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Warrior.GUID, spellid=25898}, --g kings

				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Warrior.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.Warrior.GUID, spellid=19740}, --might
			},
		},
		
		{
			Test = "Paladin, tank",
			Others = "none",
			Raid = "party",
			Players = {
				[BuffBroker.TestCases.MockPlayers.PaladinTank.GUID] = BuffBroker.TestCases.MockPlayers.PaladinTank,
				[BuffBroker.TestCases.MockPlayers.PureMelee.GUID] = BuffBroker.TestCases.MockPlayers.PureMelee,
				[BuffBroker.TestCases.MockPlayers.Warrior.GUID] = BuffBroker.TestCases.MockPlayers.Warrior,
				[BuffBroker.TestCases.MockPlayers.MeleeMana.GUID] = BuffBroker.TestCases.MockPlayers.MeleeMana,
				[BuffBroker.TestCases.MockPlayers.Healer.GUID] = BuffBroker.TestCases.MockPlayers.Healer,
			},
			PlayerGUID = BuffBroker.TestCases.MockPlayers.PaladinTank.GUID,
			Results = {
				["MP5"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinTank.GUID,},TotalCount=1},
				["AP"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinTank.GUID,},TotalCount=2},
				["HP"] = {Strength=BuffBroker.Constants.Buffs.Basic,Players = {BuffBroker.TestCases.MockPlayers.Warrior.GUID},TotalCount=1},
				["STATS"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinTank.GUID,},TotalCount=1},
				["TANK"] = {Strength=BuffBroker.Constants.Buffs.FullTalentedLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinTank.GUID,},TotalCount=1},
			},
			Suggestions = {
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinTank.GUID, spellid=25899}, --g sanctuary
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinTank.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinTank.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Warrior.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Warrior.GUID, spellid=25898}, --g kings

				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinTank.GUID, spellid=20911}, --sanctuary
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinTank.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.PaladinTank.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Warrior.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.Warrior.GUID, spellid=19740}, --might
			},
		},
		
		{
			Test = "Paladin, imp might (melee)",
			Others = "none",
			Raid = "party",
			Players = {
				[BuffBroker.TestCases.MockPlayers.PaladinMelee_AP.GUID] = BuffBroker.TestCases.MockPlayers.PaladinMelee_AP,
				[BuffBroker.TestCases.MockPlayers.PureMelee.GUID] = BuffBroker.TestCases.MockPlayers.PureMelee,
				[BuffBroker.TestCases.MockPlayers.Warrior.GUID] = BuffBroker.TestCases.MockPlayers.Warrior,
				[BuffBroker.TestCases.MockPlayers.MeleeMana.GUID] = BuffBroker.TestCases.MockPlayers.MeleeMana,
				[BuffBroker.TestCases.MockPlayers.Healer.GUID] = BuffBroker.TestCases.MockPlayers.Healer,
			},
			PlayerGUID = BuffBroker.TestCases.MockPlayers.PaladinMelee_AP.GUID,
			Results = {
				["MP5"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinMelee_AP.GUID,},TotalCount=1},
				["AP"] = {Strength=BuffBroker.Constants.Buffs.FullTalentedLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinMelee_AP.GUID,},TotalCount=2},
				["HP"] = {Strength=BuffBroker.Constants.Buffs.Basic,Players = {BuffBroker.TestCases.MockPlayers.Warrior.GUID},TotalCount=1},
				["STATS"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinMelee_AP.GUID,},TotalCount=1},
				["TANK"] = {Strength=BuffBroker.Constants.Buffs.None,Players = {},TotalCount=0},
			},
			Suggestions = {
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee_AP.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee_AP.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee_AP.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Warrior.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Warrior.GUID, spellid=25898}, --g kings

				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee_AP.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee_AP.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee_AP.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Warrior.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.Warrior.GUID, spellid=19740}, --might
			},
		},
		
		{
			Test = "Paladin, imp might (healer)",
			Others = "none",
			Raid = "party",
			Players = {
				[BuffBroker.TestCases.MockPlayers.PaladinHealer_AP.GUID] = BuffBroker.TestCases.MockPlayers.PaladinHealer_AP,
				[BuffBroker.TestCases.MockPlayers.PureMelee.GUID] = BuffBroker.TestCases.MockPlayers.PureMelee,
				[BuffBroker.TestCases.MockPlayers.Warrior.GUID] = BuffBroker.TestCases.MockPlayers.Warrior,
				[BuffBroker.TestCases.MockPlayers.MeleeMana.GUID] = BuffBroker.TestCases.MockPlayers.MeleeMana,
				[BuffBroker.TestCases.MockPlayers.Caster.GUID] = BuffBroker.TestCases.MockPlayers.Caster,
			},
			PlayerGUID = BuffBroker.TestCases.MockPlayers.PaladinHealer_AP.GUID,
			Results = {
				["MP5"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer_AP.GUID,},TotalCount=1},
				["AP"] = {Strength=BuffBroker.Constants.Buffs.FullTalentedLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer_AP.GUID,},TotalCount=2},
				["HP"] = {Strength=BuffBroker.Constants.Buffs.Basic,Players = {BuffBroker.TestCases.MockPlayers.Warrior.GUID},TotalCount=1},
				["STATS"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer_AP.GUID,},TotalCount=1},
				["TANK"] = {Strength=BuffBroker.Constants.Buffs.None,Players = {},TotalCount=0},
			},
			Suggestions = {
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer_AP.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer_AP.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Warrior.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Warrior.GUID, spellid=25898}, --g kings

				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer_AP.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer_AP.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Warrior.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.Warrior.GUID, spellid=19740}, --might
			},
		},
		
		{
			Test = "Paladin, imp might (tank)",
			Others = "none",
			Raid = "party",
			Players = {
				[BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID] = BuffBroker.TestCases.MockPlayers.PaladinTank_AP,
				[BuffBroker.TestCases.MockPlayers.PureMelee.GUID] = BuffBroker.TestCases.MockPlayers.PureMelee,
				[BuffBroker.TestCases.MockPlayers.Warrior.GUID] = BuffBroker.TestCases.MockPlayers.Warrior,
				[BuffBroker.TestCases.MockPlayers.MeleeMana.GUID] = BuffBroker.TestCases.MockPlayers.MeleeMana,
				[BuffBroker.TestCases.MockPlayers.Healer.GUID] = BuffBroker.TestCases.MockPlayers.Healer,
			},
			PlayerGUID = BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID,
			Results = {
				["MP5"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID,},TotalCount=1},
				["AP"] = {Strength=BuffBroker.Constants.Buffs.FullTalentedLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID,},TotalCount=2},
				["HP"] = {Strength=BuffBroker.Constants.Buffs.Basic,Players = {BuffBroker.TestCases.MockPlayers.Warrior.GUID},TotalCount=1},
				["STATS"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID,},TotalCount=1},
				["TANK"] = {Strength=BuffBroker.Constants.Buffs.FullTalentedLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID,},TotalCount=1},
			},
			Suggestions = {
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID, spellid=25899}, --g sanctuary
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Warrior.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Warrior.GUID, spellid=25898}, --g kings

				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID, spellid=20911}, --sanctuary
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Warrior.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.Warrior.GUID, spellid=19740}, --might
			},
		},
		
		{
			Test = "Paladin, imp wisdom",
			Others = "none",
			Raid = "party",
			Players = {
				[BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5.GUID] = BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5,
				[BuffBroker.TestCases.MockPlayers.PureMelee.GUID] = BuffBroker.TestCases.MockPlayers.PureMelee,
				[BuffBroker.TestCases.MockPlayers.Warrior.GUID] = BuffBroker.TestCases.MockPlayers.Warrior,
				[BuffBroker.TestCases.MockPlayers.MeleeMana.GUID] = BuffBroker.TestCases.MockPlayers.MeleeMana,
				[BuffBroker.TestCases.MockPlayers.Caster.GUID] = BuffBroker.TestCases.MockPlayers.Caster,
			},
			PlayerGUID = BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5.GUID,
			Results = {
				["MP5"] = {Strength=BuffBroker.Constants.Buffs.FullTalentedLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5.GUID,},TotalCount=1},
				["AP"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5.GUID,},TotalCount=2},
				["HP"] = {Strength=BuffBroker.Constants.Buffs.Basic,Players = {BuffBroker.TestCases.MockPlayers.Warrior.GUID},TotalCount=1},
				["STATS"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5.GUID,},TotalCount=1},
				["TANK"] = {Strength=BuffBroker.Constants.Buffs.None,Players = {},TotalCount=0},
			},
			Suggestions = {
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Warrior.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Warrior.GUID, spellid=25898}, --g kings

				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Warrior.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.Warrior.GUID, spellid=19740}, --might
			},
		},
		
		{
			Test = "Paladin, imp wisdom/might",
			Others = "none",
			Raid = "party",
			Players = {
				[BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5_AP.GUID] = BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5_AP,
				[BuffBroker.TestCases.MockPlayers.PureMelee.GUID] = BuffBroker.TestCases.MockPlayers.PureMelee,
				[BuffBroker.TestCases.MockPlayers.Warrior.GUID] = BuffBroker.TestCases.MockPlayers.Warrior,
				[BuffBroker.TestCases.MockPlayers.MeleeMana.GUID] = BuffBroker.TestCases.MockPlayers.MeleeMana,
				[BuffBroker.TestCases.MockPlayers.Caster.GUID] = BuffBroker.TestCases.MockPlayers.Caster,
			},
			PlayerGUID = BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5_AP.GUID,
			Results = {
				["MP5"] = {Strength=BuffBroker.Constants.Buffs.FullTalentedLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5_AP.GUID,},TotalCount=1},
				["AP"] = {Strength=BuffBroker.Constants.Buffs.FullTalentedLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5_AP.GUID,},TotalCount=2},
				["HP"] = {Strength=BuffBroker.Constants.Buffs.Basic,Players = {BuffBroker.TestCases.MockPlayers.Warrior.GUID},TotalCount=1},
				["STATS"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5_AP.GUID,},TotalCount=1},
				["TANK"] = {Strength=BuffBroker.Constants.Buffs.None,Players = {},TotalCount=0},
			},
			Suggestions = {
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5_AP.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5_AP.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Warrior.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Warrior.GUID, spellid=25898}, --g kings

				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5_AP.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5_AP.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Warrior.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.Warrior.GUID, spellid=19740}, --might
			},
		},

	},

	PartyPallyWarriorAP =
	{
		{
			Test = "Paladin, untalented (melee)",
			Others = "none",
			Raid = "party",
			Players = {
				[BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID] = BuffBroker.TestCases.MockPlayers.PaladinMelee,
				[BuffBroker.TestCases.MockPlayers.PureMelee.GUID] = BuffBroker.TestCases.MockPlayers.PureMelee,
				[BuffBroker.TestCases.MockPlayers.Warrior_AP.GUID] = BuffBroker.TestCases.MockPlayers.Warrior_AP,
				[BuffBroker.TestCases.MockPlayers.MeleeMana.GUID] = BuffBroker.TestCases.MockPlayers.MeleeMana,
				[BuffBroker.TestCases.MockPlayers.Healer.GUID] = BuffBroker.TestCases.MockPlayers.Healer,
			},
			PlayerGUID = BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID,
			Results = {
				["MP5"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID,},TotalCount=1},
				["AP"] = {Strength=BuffBroker.Constants.Buffs.FullTalented,Players = {BuffBroker.TestCases.MockPlayers.Warrior_AP.GUID,},TotalCount=2},
				["HP"] = {Strength=BuffBroker.Constants.Buffs.FullTalented,Players = {BuffBroker.TestCases.MockPlayers.Warrior_AP.GUID},TotalCount=1},
				["STATS"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID,},TotalCount=1},
				["TANK"] = {Strength=BuffBroker.Constants.Buffs.None,Players = {},TotalCount=0},
			},
			Suggestions = {
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Optional,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Optional,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Optional,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Warrior_AP.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Optional,Target=BuffBroker.TestCases.MockPlayers.Warrior_AP.GUID, spellid=25782}, --g might

				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Optional,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Optional,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Optional,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Warrior_AP.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Optional,Target=BuffBroker.TestCases.MockPlayers.Warrior_AP.GUID, spellid=19740}, --might
			},
		},
		
		{
			Test = "Paladin, untalented (healer)",
			Others = "none",
			Raid = "party",
			Players = {
				[BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID] = BuffBroker.TestCases.MockPlayers.PaladinHealer,
				[BuffBroker.TestCases.MockPlayers.PureMelee.GUID] = BuffBroker.TestCases.MockPlayers.PureMelee,
				[BuffBroker.TestCases.MockPlayers.Warrior_AP.GUID] = BuffBroker.TestCases.MockPlayers.Warrior_AP,
				[BuffBroker.TestCases.MockPlayers.MeleeMana.GUID] = BuffBroker.TestCases.MockPlayers.MeleeMana,
				[BuffBroker.TestCases.MockPlayers.Caster.GUID] = BuffBroker.TestCases.MockPlayers.Caster,
			},
			PlayerGUID = BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID,
			Results = {
				["MP5"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID,},TotalCount=1},
				["AP"] = {Strength=BuffBroker.Constants.Buffs.FullTalented,Players = {BuffBroker.TestCases.MockPlayers.Warrior_AP.GUID,},TotalCount=2},
				["HP"] = {Strength=BuffBroker.Constants.Buffs.FullTalented,Players = {BuffBroker.TestCases.MockPlayers.Warrior_AP.GUID},TotalCount=1},
				["STATS"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID,},TotalCount=1},
				["TANK"] = {Strength=BuffBroker.Constants.Buffs.None,Players = {},TotalCount=0},
			},
			Suggestions = {
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Optional,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Optional,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Warrior_AP.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Optional,Target=BuffBroker.TestCases.MockPlayers.Warrior_AP.GUID, spellid=25782}, --g might

				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Optional,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Optional,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Warrior_AP.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Optional,Target=BuffBroker.TestCases.MockPlayers.Warrior_AP.GUID, spellid=19740}, --might
			},
		},
		
		{
			Test = "Paladin, tank",
			Others = "none",
			Raid = "party",
			Players = {
				[BuffBroker.TestCases.MockPlayers.PaladinTank.GUID] = BuffBroker.TestCases.MockPlayers.PaladinTank,
				[BuffBroker.TestCases.MockPlayers.PureMelee.GUID] = BuffBroker.TestCases.MockPlayers.PureMelee,
				[BuffBroker.TestCases.MockPlayers.Warrior_AP.GUID] = BuffBroker.TestCases.MockPlayers.Warrior_AP,
				[BuffBroker.TestCases.MockPlayers.MeleeMana.GUID] = BuffBroker.TestCases.MockPlayers.MeleeMana,
				[BuffBroker.TestCases.MockPlayers.Healer.GUID] = BuffBroker.TestCases.MockPlayers.Healer,
			},
			PlayerGUID = BuffBroker.TestCases.MockPlayers.PaladinTank.GUID,
			Results = {
				["MP5"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinTank.GUID,},TotalCount=1},
				["AP"] = {Strength=BuffBroker.Constants.Buffs.FullTalented,Players = {BuffBroker.TestCases.MockPlayers.Warrior_AP.GUID,},TotalCount=2},
				["HP"] = {Strength=BuffBroker.Constants.Buffs.FullTalented,Players = {BuffBroker.TestCases.MockPlayers.Warrior_AP.GUID},TotalCount=1},
				["STATS"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinTank.GUID,},TotalCount=1},
				["TANK"] = {Strength=BuffBroker.Constants.Buffs.FullTalentedLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinTank.GUID,},TotalCount=1},
			},
			Suggestions = {
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Optional,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Optional,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinTank.GUID, spellid=25899}, --g sanctuary
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinTank.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Optional,Target=BuffBroker.TestCases.MockPlayers.PaladinTank.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Warrior_AP.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Optional,Target=BuffBroker.TestCases.MockPlayers.Warrior_AP.GUID, spellid=25782}, --g might

				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Optional,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Optional,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinTank.GUID, spellid=20911}, --sanctuary
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinTank.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Optional,Target=BuffBroker.TestCases.MockPlayers.PaladinTank.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Warrior_AP.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Optional,Target=BuffBroker.TestCases.MockPlayers.Warrior_AP.GUID, spellid=19740}, --might
			},
		},
		
		{
			Test = "Paladin, imp might (melee)",
			Others = "none",
			Raid = "party",
			Players = {
				[BuffBroker.TestCases.MockPlayers.PaladinMelee_AP.GUID] = BuffBroker.TestCases.MockPlayers.PaladinMelee_AP,
				[BuffBroker.TestCases.MockPlayers.PureMelee.GUID] = BuffBroker.TestCases.MockPlayers.PureMelee,
				[BuffBroker.TestCases.MockPlayers.Warrior_AP.GUID] = BuffBroker.TestCases.MockPlayers.Warrior_AP,
				[BuffBroker.TestCases.MockPlayers.MeleeMana.GUID] = BuffBroker.TestCases.MockPlayers.MeleeMana,
				[BuffBroker.TestCases.MockPlayers.Healer.GUID] = BuffBroker.TestCases.MockPlayers.Healer,
			},
			PlayerGUID = BuffBroker.TestCases.MockPlayers.PaladinMelee_AP.GUID,
			Results = {
				["MP5"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinMelee_AP.GUID,},TotalCount=1},
				["AP"] = {Strength=BuffBroker.Constants.Buffs.FullTalentedLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinMelee_AP.GUID,},TotalCount=2},
				["HP"] = {Strength=BuffBroker.Constants.Buffs.FullTalented,Players = {BuffBroker.TestCases.MockPlayers.Warrior_AP.GUID},TotalCount=1},
				["STATS"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinMelee_AP.GUID,},TotalCount=1},
				["TANK"] = {Strength=BuffBroker.Constants.Buffs.None,Players = {},TotalCount=0},
			},
			Suggestions = {
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee_AP.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee_AP.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee_AP.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Warrior_AP.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Warrior_AP.GUID, spellid=25898}, --g kings

				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee_AP.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee_AP.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee_AP.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Warrior_AP.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.Warrior_AP.GUID, spellid=19740}, --might
			},
		},
		
		{
			Test = "Paladin, imp might (healer)",
			Others = "none",
			Raid = "party",
			Players = {
				[BuffBroker.TestCases.MockPlayers.PaladinHealer_AP.GUID] = BuffBroker.TestCases.MockPlayers.PaladinHealer_AP,
				[BuffBroker.TestCases.MockPlayers.PureMelee.GUID] = BuffBroker.TestCases.MockPlayers.PureMelee,
				[BuffBroker.TestCases.MockPlayers.Warrior_AP.GUID] = BuffBroker.TestCases.MockPlayers.Warrior_AP,
				[BuffBroker.TestCases.MockPlayers.MeleeMana.GUID] = BuffBroker.TestCases.MockPlayers.MeleeMana,
				[BuffBroker.TestCases.MockPlayers.Caster.GUID] = BuffBroker.TestCases.MockPlayers.Caster,
			},
			PlayerGUID = BuffBroker.TestCases.MockPlayers.PaladinHealer_AP.GUID,
			Results = {
				["MP5"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer_AP.GUID,},TotalCount=1},
				["AP"] = {Strength=BuffBroker.Constants.Buffs.FullTalentedLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer_AP.GUID,},TotalCount=2},
				["HP"] = {Strength=BuffBroker.Constants.Buffs.FullTalented,Players = {BuffBroker.TestCases.MockPlayers.Warrior_AP.GUID},TotalCount=1},
				["STATS"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer_AP.GUID,},TotalCount=1},
				["TANK"] = {Strength=BuffBroker.Constants.Buffs.None,Players = {},TotalCount=0},
			},
			Suggestions = {
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer_AP.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer_AP.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Warrior_AP.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Warrior_AP.GUID, spellid=25898}, --g kings

				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer_AP.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer_AP.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Warrior_AP.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.Warrior_AP.GUID, spellid=19740}, --might
			},
		},
		
		{
			Test = "Paladin, imp might (tank)",
			Others = "none",
			Raid = "party",
			Players = {
				[BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID] = BuffBroker.TestCases.MockPlayers.PaladinTank_AP,
				[BuffBroker.TestCases.MockPlayers.PureMelee.GUID] = BuffBroker.TestCases.MockPlayers.PureMelee,
				[BuffBroker.TestCases.MockPlayers.Warrior_AP.GUID] = BuffBroker.TestCases.MockPlayers.Warrior_AP,
				[BuffBroker.TestCases.MockPlayers.MeleeMana.GUID] = BuffBroker.TestCases.MockPlayers.MeleeMana,
				[BuffBroker.TestCases.MockPlayers.Healer.GUID] = BuffBroker.TestCases.MockPlayers.Healer,
			},
			PlayerGUID = BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID,
			Results = {
				["MP5"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID,},TotalCount=1},
				["AP"] = {Strength=BuffBroker.Constants.Buffs.FullTalentedLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID,},TotalCount=2},
				["HP"] = {Strength=BuffBroker.Constants.Buffs.FullTalented,Players = {BuffBroker.TestCases.MockPlayers.Warrior_AP.GUID},TotalCount=1},
				["STATS"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID,},TotalCount=1},
				["TANK"] = {Strength=BuffBroker.Constants.Buffs.FullTalentedLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID,},TotalCount=1},
			},
			Suggestions = {
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID, spellid=25899}, --g sanctuary
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Warrior_AP.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Warrior_AP.GUID, spellid=25898}, --g kings

				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID, spellid=20911}, --sanctuary
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Warrior_AP.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.Warrior_AP.GUID, spellid=19740}, --might
			},
		},
		
		{
			Test = "Paladin, imp wisdom",
			Others = "none",
			Raid = "party",
			Players = {
				[BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5.GUID] = BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5,
				[BuffBroker.TestCases.MockPlayers.PureMelee.GUID] = BuffBroker.TestCases.MockPlayers.PureMelee,
				[BuffBroker.TestCases.MockPlayers.Warrior_AP.GUID] = BuffBroker.TestCases.MockPlayers.Warrior_AP,
				[BuffBroker.TestCases.MockPlayers.MeleeMana.GUID] = BuffBroker.TestCases.MockPlayers.MeleeMana,
				[BuffBroker.TestCases.MockPlayers.Caster.GUID] = BuffBroker.TestCases.MockPlayers.Caster,
			},
			PlayerGUID = BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5.GUID,
			Results = {
				["MP5"] = {Strength=BuffBroker.Constants.Buffs.FullTalentedLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5.GUID,},TotalCount=1},
				["AP"] = {Strength=BuffBroker.Constants.Buffs.FullTalented,Players = {BuffBroker.TestCases.MockPlayers.Warrior_AP.GUID,},TotalCount=2},
				["HP"] = {Strength=BuffBroker.Constants.Buffs.FullTalented,Players = {BuffBroker.TestCases.MockPlayers.Warrior_AP.GUID},TotalCount=1},
				["STATS"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5.GUID,},TotalCount=1},
				["TANK"] = {Strength=BuffBroker.Constants.Buffs.None,Players = {},TotalCount=0},
			},
			Suggestions = {
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Optional,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Optional,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Warrior_AP.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Optional,Target=BuffBroker.TestCases.MockPlayers.Warrior_AP.GUID, spellid=25782}, --g might

				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Optional,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Optional,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Warrior_AP.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Optional,Target=BuffBroker.TestCases.MockPlayers.Warrior_AP.GUID, spellid=19740}, --might
			},
		},
		
		{
			Test = "Paladin, imp wisdom/might",
			Others = "none",
			Raid = "party",
			Players = {
				[BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5_AP.GUID] = BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5_AP,
				[BuffBroker.TestCases.MockPlayers.PureMelee.GUID] = BuffBroker.TestCases.MockPlayers.PureMelee,
				[BuffBroker.TestCases.MockPlayers.Warrior_AP.GUID] = BuffBroker.TestCases.MockPlayers.Warrior_AP,
				[BuffBroker.TestCases.MockPlayers.MeleeMana.GUID] = BuffBroker.TestCases.MockPlayers.MeleeMana,
				[BuffBroker.TestCases.MockPlayers.Caster.GUID] = BuffBroker.TestCases.MockPlayers.Caster,
			},
			PlayerGUID = BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5_AP.GUID,
			Results = {
				["MP5"] = {Strength=BuffBroker.Constants.Buffs.FullTalentedLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5_AP.GUID,},TotalCount=1},
				["AP"] = {Strength=BuffBroker.Constants.Buffs.FullTalentedLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5_AP.GUID,},TotalCount=2},
				["HP"] = {Strength=BuffBroker.Constants.Buffs.FullTalented,Players = {BuffBroker.TestCases.MockPlayers.Warrior_AP.GUID},TotalCount=1},
				["STATS"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5_AP.GUID,},TotalCount=1},
				["TANK"] = {Strength=BuffBroker.Constants.Buffs.None,Players = {},TotalCount=0},
			},
			Suggestions = {
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5_AP.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5_AP.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Warrior_AP.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Warrior_AP.GUID, spellid=25898}, --g kings

				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5_AP.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer_MP5_AP.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Warrior_AP.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.Warrior_AP.GUID, spellid=19740}, --might
			},
		},
	},
	
	PartyPallyPally =
	{
		{
			Test = "Paladin, untalented (melee), partial wisdom/AP active",
			Others = "none",
			Raid = "party",
			Players = {
				[BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID] = BuffBroker.TestCases.MockPlayers.PaladinMelee,
				[BuffBroker.TestCases.MockPlayers.PureMelee.GUID] = BuffBroker.TestCases.MockPlayers.PureMelee,
				[BuffBroker.TestCases.MockPlayers.Caster.GUID] = BuffBroker.TestCases.MockPlayers.Caster,
				[BuffBroker.TestCases.MockPlayers.MeleeMana.GUID] = BuffBroker.TestCases.MockPlayers.MeleeMana,
				[BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID] = BuffBroker.TestCases.MockPlayers.PaladinHealer,
			},
			PlayerGUID = BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID,
			Results = {
				["MP5"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID,BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID},TotalCount=2},
				["AP"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID,BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID,},TotalCount=2},
				["HP"] = {Strength=BuffBroker.Constants.Buffs.None,Players = {},TotalCount=0},
				["STATS"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID,BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID},TotalCount=2},
				["TANK"] = {Strength=BuffBroker.Constants.Buffs.None,Players = {},TotalCount=0},
			},
			ActiveBuffs = {
				{Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, Source=BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID, Type="AP", spellid=19740}, --might
				{Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, Source=BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID, Type="MP5", spellid=19742}, --wisdom
			},
			Suggestions = {
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=25898}, --g kings

				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=20217}, --kings
			},
		},
		
		{
			Test = "Paladin, untalented (melee), full wisdom/might active",
			Others = "none",
			Raid = "party",
			Players = {
				[BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID] = BuffBroker.TestCases.MockPlayers.PaladinMelee,
				[BuffBroker.TestCases.MockPlayers.PureMelee.GUID] = BuffBroker.TestCases.MockPlayers.PureMelee,
				[BuffBroker.TestCases.MockPlayers.Caster.GUID] = BuffBroker.TestCases.MockPlayers.Caster,
				[BuffBroker.TestCases.MockPlayers.MeleeMana.GUID] = BuffBroker.TestCases.MockPlayers.MeleeMana,
				[BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID] = BuffBroker.TestCases.MockPlayers.PaladinHealer,
			},
			PlayerGUID = BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID,
			Results = {
				["MP5"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID,BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID},TotalCount=2},
				["AP"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID,BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID,},TotalCount=2},
				["HP"] = {Strength=BuffBroker.Constants.Buffs.None,Players = {},TotalCount=0},
				["STATS"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID,BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID},TotalCount=2},
				["TANK"] = {Strength=BuffBroker.Constants.Buffs.None,Players = {},TotalCount=0},
			},
			ActiveBuffs = {
				{Target=BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID, Source=BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID, Type="AP", spellid=19740}, --might
				{Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, Source=BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID, Type="AP", spellid=19740}, --might
				{Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, Source=BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID, Type="MP5", spellid=19742}, --wisdom
				{Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, Source=BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID, Type="AP", spellid=19740}, --might
				{Target=BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID, Source=BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID, Type="MP5", spellid=19742}, --wisdom
			},
			Suggestions = {
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=25898}, --g kings

				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=20217}, --kings
			},
		},
		
		{
			Test = "Paladin, tank (talented AP), full wisdom/might active",
			Others = "none",
			Raid = "party",
			Players = {
				[BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID] = BuffBroker.TestCases.MockPlayers.PaladinTank_AP,
				[BuffBroker.TestCases.MockPlayers.PureMelee.GUID] = BuffBroker.TestCases.MockPlayers.PureMelee,
				[BuffBroker.TestCases.MockPlayers.Caster.GUID] = BuffBroker.TestCases.MockPlayers.Caster,
				[BuffBroker.TestCases.MockPlayers.PaladinMelee_AP.GUID] = BuffBroker.TestCases.MockPlayers.PaladinMelee_AP,
				[BuffBroker.TestCases.MockPlayers.Healer.GUID] = BuffBroker.TestCases.MockPlayers.Healer,
			},
			PlayerGUID = BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID,
			Results = {
				["MP5"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID,BuffBroker.TestCases.MockPlayers.PaladinMelee_AP.GUID},TotalCount=2},
				["AP"] = {Strength=BuffBroker.Constants.Buffs.FullTalentedLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID,BuffBroker.TestCases.MockPlayers.PaladinMelee_AP.GUID,},TotalCount=2},
				["HP"] = {Strength=BuffBroker.Constants.Buffs.None,Players = {},TotalCount=0},
				["STATS"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID,BuffBroker.TestCases.MockPlayers.PaladinMelee_AP.GUID},TotalCount=2},
				["TANK"] = {Strength=BuffBroker.Constants.Buffs.FullTalentedLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID,},TotalCount=1},
			},
			ActiveBuffs = {
				{Target=BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID, Source=BuffBroker.TestCases.MockPlayers.PaladinMelee_AP.GUID, Type="AP", spellid=19740}, --might
				{Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, Source=BuffBroker.TestCases.MockPlayers.PaladinMelee_AP.GUID, Type="AP", spellid=19740}, --might
				{Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, Source=BuffBroker.TestCases.MockPlayers.PaladinMelee_AP.GUID, Type="MP5", spellid=19742}, --wisdom
				{Target=BuffBroker.TestCases.MockPlayers.PaladinMelee_AP.GUID, Source=BuffBroker.TestCases.MockPlayers.PaladinMelee_AP.GUID, Type="AP", spellid=19740}, --might
				{Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, Source=BuffBroker.TestCases.MockPlayers.PaladinMelee_AP.GUID, Type="MP5", spellid=19742}, --wisdom
			},
			Suggestions = {
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee_AP.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee_AP.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID, spellid=25899}, --g sanctuary
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=25898}, --g kings

				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee_AP.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee_AP.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID, spellid=20911}, --sanctuary
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=20217}, --kings
			},
		},
		
		{
			Test = "Paladin, untalented (melee), full kings active",
			Others = "none",
			Raid = "party",
			Players = {
				[BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID] = BuffBroker.TestCases.MockPlayers.PaladinMelee,
				[BuffBroker.TestCases.MockPlayers.PureMelee.GUID] = BuffBroker.TestCases.MockPlayers.PureMelee,
				[BuffBroker.TestCases.MockPlayers.Caster.GUID] = BuffBroker.TestCases.MockPlayers.Caster,
				[BuffBroker.TestCases.MockPlayers.MeleeMana.GUID] = BuffBroker.TestCases.MockPlayers.MeleeMana,
				[BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID] = BuffBroker.TestCases.MockPlayers.PaladinHealer,
			},
			PlayerGUID = BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID,
			Results = {
				["MP5"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID,BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID},TotalCount=2},
				["AP"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID,BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID,},TotalCount=2},
				["HP"] = {Strength=BuffBroker.Constants.Buffs.None,Players = {},TotalCount=0},
				["STATS"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID,BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID},TotalCount=2},
				["TANK"] = {Strength=BuffBroker.Constants.Buffs.None,Players = {},TotalCount=0},
			},
			ActiveBuffs = {
				{Target=BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID, Source=BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID, Type="STATS", spellid=20217}, --kings
				{Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, Source=BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID, Type="STATS", spellid=20217}, --kings
				{Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, Source=BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID, Type="STATS", spellid=20217}, --kings
				{Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, Source=BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID, Type="STATS", spellid=20217}, --kings
				{Target=BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID, Source=BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID, Type="STATS", spellid=20217}, --kings
			},
			Suggestions = {
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=25894}, --g wisdom

				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=19742}, --wisdom
			},
		},
		
		{
			Test = "Paladin, untalented (melee), partial kings active",
			Others = "none",
			Raid = "party",
			Players = {
				[BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID] = BuffBroker.TestCases.MockPlayers.PaladinMelee,
				[BuffBroker.TestCases.MockPlayers.PureMelee.GUID] = BuffBroker.TestCases.MockPlayers.PureMelee,
				[BuffBroker.TestCases.MockPlayers.Caster.GUID] = BuffBroker.TestCases.MockPlayers.Caster,
				[BuffBroker.TestCases.MockPlayers.MeleeMana.GUID] = BuffBroker.TestCases.MockPlayers.MeleeMana,
				[BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID] = BuffBroker.TestCases.MockPlayers.PaladinHealer,
			},
			PlayerGUID = BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID,
			Results = {
				["MP5"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID,BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID},TotalCount=2},
				["AP"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID,BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID,},TotalCount=2},
				["HP"] = {Strength=BuffBroker.Constants.Buffs.None,Players = {},TotalCount=0},
				["STATS"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID,BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID},TotalCount=2},
				["TANK"] = {Strength=BuffBroker.Constants.Buffs.None,Players = {},TotalCount=0},
			},
			ActiveBuffs = {
				{Target=BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID, Source=BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID, Type="STATS", spellid=20217}, --kings
			},
			Suggestions = {
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=25894}, --g wisdom

				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=19742}, --wisdom
			},
		},
		
		{
			Test = "Paladin, untalented (melee), 1 far",
			Others = "none",
			Raid = "party",
			Players = {
				[BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID] = BuffBroker.TestCases.MockPlayers.PaladinMelee,
				[BuffBroker.TestCases.MockPlayers.PureMelee.GUID] = BuffBroker.TestCases.MockPlayers.PureMelee,
				[BuffBroker.TestCases.MockPlayers.Caster.GUID] = BuffBroker.TestCases.MockPlayers.Caster,
				[BuffBroker.TestCases.MockPlayers.MeleeManaFar.GUID] = BuffBroker.TestCases.MockPlayers.MeleeManaFar,
				[BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID] = BuffBroker.TestCases.MockPlayers.PaladinHealer,
			},
			PlayerGUID = BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID,
			Results = {
				["MP5"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID,BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID},TotalCount=2},
				["AP"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID,BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID,},TotalCount=2},
				["HP"] = {Strength=BuffBroker.Constants.Buffs.None,Players = {},TotalCount=0},
				["STATS"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID,BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID},TotalCount=2},
				["TANK"] = {Strength=BuffBroker.Constants.Buffs.None,Players = {},TotalCount=0},
			},
			ActiveBuffs = {
				{Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, Source=BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID, Type="STATS", spellid=20217}, --kings
			},
			Suggestions = {
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=25894}, --g wisdom

				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMelee.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.PaladinMelee.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.MeleeManaFar.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.MeleeManaFar.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.MeleeManaFar.GUID, spellid=19742}, --wisdom
			},
		},
	},
	
	RealPartyTesting =
	{
		{
			Test = "Paladin, tank (AP)",
			Others = "none",
			Raid = "party",
			Players = {
				[BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID] = BuffBroker.TestCases.MockPlayers.PaladinTank_AP,
				[BuffBroker.TestCases.MockPlayers.PureMeleeAlt.GUID] = BuffBroker.TestCases.MockPlayers.PureMeleeAlt,
				[BuffBroker.TestCases.MockPlayers.Caster.GUID] = BuffBroker.TestCases.MockPlayers.Caster,
				[BuffBroker.TestCases.MockPlayers.MeleeMana.GUID] = BuffBroker.TestCases.MockPlayers.MeleeMana,
				[BuffBroker.TestCases.MockPlayers.Healer.GUID] = BuffBroker.TestCases.MockPlayers.Healer,
			},
			PlayerGUID = BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID,
			Results = {
				["MP5"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID},TotalCount=1},
				["AP"] = {Strength=BuffBroker.Constants.Buffs.FullTalentedLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID,},TotalCount=1},
				["HP"] = {Strength=BuffBroker.Constants.Buffs.None,Players = {},TotalCount=0},
				["STATS"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID},TotalCount=1},
				["TANK"] = {Strength=BuffBroker.Constants.Buffs.FullTalentedLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID,},TotalCount=1},
			},
			ActiveBuffs = {
				{Target=BuffBroker.TestCases.MockPlayers.PureMeleeAlt.GUID, Source=BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID, Type="AP", spellid=25782}, --g might
				{Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, Source=BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID, Type="AP", spellid=19740}, --might
				{Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, Source=BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID, Type="STATS", spellid=25898}, --g kings
				{Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, Source=BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID, Type="STATS", spellid=20217}, --kings
				{Target=BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID, Source=BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID, Type="TANK", spellid=20911}, --sanctuary
			},
			Suggestions = {
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMeleeAlt.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PureMeleeAlt.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.MeleeMana.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID, spellid=20911}, --sanctuary
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID, spellid=19740}, --might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=19742}, --wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=20217}, --kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=19742}, --wisdom
			},
		},

		{
			Test = "Paladin tank, 2 warriors",
			Others = "none",
			Raid = "party",
			Players = {
				[BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID] = BuffBroker.TestCases.MockPlayers.PaladinTank_AP,
				[BuffBroker.TestCases.MockPlayers.Warrior.GUID] = BuffBroker.TestCases.MockPlayers.Warrior,
				[BuffBroker.TestCases.MockPlayers.Warrior_AP.GUID] = BuffBroker.TestCases.MockPlayers.Warrior_AP,
				[BuffBroker.TestCases.MockPlayers.Caster.GUID] = BuffBroker.TestCases.MockPlayers.Caster,
				[BuffBroker.TestCases.MockPlayers.Healer.GUID] = BuffBroker.TestCases.MockPlayers.Healer,
			},
			PlayerGUID = BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID,
			Results = {
				["MP5"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID},TotalCount=1},
				["AP"] = {Strength=BuffBroker.Constants.Buffs.FullTalentedLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID,},TotalCount=3},
				["HP"] = {Strength=BuffBroker.Constants.Buffs.FullTalented,Players = {BuffBroker.TestCases.MockPlayers.Warrior_AP.GUID,},TotalCount=2},
				["STATS"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID},TotalCount=1},
				["TANK"] = {Strength=BuffBroker.Constants.Buffs.FullTalentedLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID,},TotalCount=1},
			},
			ActiveBuffs = {
			},
			Suggestions = {
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID, spellid=25899}, --g sanctuary
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Warrior_AP.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.Warrior_AP.GUID, spellid=25782}, --g might

				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID, spellid=20911}, -- sanctuary
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID, spellid=20217}, -- kings
				{Confidence=BuffBroker.Constants.Confidence.Possible,Target=BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID, spellid=19740}, -- might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=20217}, -- kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Healer.GUID, spellid=19742}, -- wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=20217}, -- kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=19742}, -- wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Warrior.GUID, spellid=20217}, -- kings
				{Confidence=BuffBroker.Constants.Confidence.Possible,Target=BuffBroker.TestCases.MockPlayers.Warrior.GUID, spellid=19740}, -- might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Warrior_AP.GUID, spellid=20217}, -- kings
				{Confidence=BuffBroker.Constants.Confidence.Possible,Target=BuffBroker.TestCases.MockPlayers.Warrior_AP.GUID, spellid=19740}, -- might
			},
		},
		
		{
			Test = "Paladin, 2 druids (tree and owl)",
			Others = "none",
			Raid = "party",
			Players = {
				[BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID] = BuffBroker.TestCases.MockPlayers.PaladinTank_AP,
				[BuffBroker.TestCases.MockPlayers.Owl.GUID] = BuffBroker.TestCases.MockPlayers.Owl,
				[BuffBroker.TestCases.MockPlayers.Tree.GUID] = BuffBroker.TestCases.MockPlayers.Tree,
				[BuffBroker.TestCases.MockPlayers.Caster.GUID] = BuffBroker.TestCases.MockPlayers.Caster,
				[BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID] = BuffBroker.TestCases.MockPlayers.PaladinHealer,
			},
			PlayerGUID = BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID,
			Results = {
				["MP5"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID, BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID},TotalCount=2},
				["AP"] = {Strength=BuffBroker.Constants.Buffs.FullTalentedLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID,},TotalCount=2},
				["HP"] = {Strength=BuffBroker.Constants.Buffs.None,Players = {},TotalCount=0},
				["STATS"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID, BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID},TotalCount=2},
				["TANK"] = {Strength=BuffBroker.Constants.Buffs.FullTalentedLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID,},TotalCount=1},
				["WILD"] = {Strength=BuffBroker.Constants.Buffs.FullTalented,Players = {BuffBroker.TestCases.MockPlayers.Tree.GUID,},TotalCount=2},
				["THORNS"] = {Strength=BuffBroker.Constants.Buffs.FullTalented,Players = {BuffBroker.TestCases.MockPlayers.Owl.GUID,},TotalCount=2},
			},
			ActiveBuffs = {
				{Target=BuffBroker.TestCases.MockPlayers.Owl.GUID, Source=BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID, Type="STATS", spellid=25898}, --g kings
				{Target=BuffBroker.TestCases.MockPlayers.Tree.GUID, Source=BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID, Type="STATS", spellid=25898}, --g kings
			},
			Suggestions = {
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Owl.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID, spellid=25899}, --g sanctuary
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID, spellid=25782}, --g might
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=25894}, --g wisdom

				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Owl.GUID, spellid=19742}, -- wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Tree.GUID, spellid=19742}, -- wisdom
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID, spellid=20217}, -- kings
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID, spellid=19742}, -- wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID, spellid=20911}, -- sanctuary
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID, spellid=20217}, -- kings
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID, spellid=19740}, -- might
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=20217}, -- kings
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=19742}, -- wisdom
			},
		},
		{
			Test = "Paladin, 2 druids (tree and owl), expired buffs",
			Others = "none",
			Raid = "party",
			Players = {
				[BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID] = BuffBroker.TestCases.MockPlayers.PaladinTank_AP,
				[BuffBroker.TestCases.MockPlayers.Owl.GUID] = BuffBroker.TestCases.MockPlayers.Owl,
				[BuffBroker.TestCases.MockPlayers.Tree.GUID] = BuffBroker.TestCases.MockPlayers.Tree,
				[BuffBroker.TestCases.MockPlayers.Caster.GUID] = BuffBroker.TestCases.MockPlayers.Caster,
				[BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID] = BuffBroker.TestCases.MockPlayers.PaladinHealer,
			},
			PlayerGUID = BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID,
			Results = {
				["MP5"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID, BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID},TotalCount=2},
				["AP"] = {Strength=BuffBroker.Constants.Buffs.FullTalentedLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID,},TotalCount=2},
				["HP"] = {Strength=BuffBroker.Constants.Buffs.None,Players = {},TotalCount=0},
				["STATS"] = {Strength=BuffBroker.Constants.Buffs.BasicLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID, BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID},TotalCount=2},
				["TANK"] = {Strength=BuffBroker.Constants.Buffs.FullTalentedLong,Players = {BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID,},TotalCount=1},
				["WILD"] = {Strength=BuffBroker.Constants.Buffs.FullTalented,Players = {BuffBroker.TestCases.MockPlayers.Tree.GUID,},TotalCount=2},
				["THORNS"] = {Strength=BuffBroker.Constants.Buffs.FullTalented,Players = {BuffBroker.TestCases.MockPlayers.Owl.GUID,},TotalCount=2},
			},
			ActiveBuffs = {
				{Target=BuffBroker.TestCases.MockPlayers.Owl.GUID, Source=BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID, Type="STATS", spellid=25898}, --g kings
				{Target=BuffBroker.TestCases.MockPlayers.Tree.GUID, Source=BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID, Type="STATS", spellid=25898}, --g kings
				{Target=BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID, Source=BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID, Type="STATS", spellid=25898}, --g kings
				{Target=BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID, Source=BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID, Type="TANK", Expired = true, spellid=20911}, --sanctuary
			},
			Suggestions = {
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Owl.GUID, spellid=25894}, --g wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID, Expired = true, spellid=25899}, --g sanctuary
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=25898}, --g kings
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=25894}, --g wisdom

				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Owl.GUID, spellid=19742}, -- wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.Tree.GUID, spellid=19742}, -- wisdom
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID, spellid=20217}, -- kings
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.PaladinHealer.GUID, spellid=19742}, -- wisdom
				{Confidence=BuffBroker.Constants.Confidence.Certain,Target=BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID, spellid=20911}, -- sanctuary
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID, spellid=20217}, -- kings
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.PaladinTank_AP.GUID, spellid=19740}, -- might
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=20217}, -- kings
				{Confidence=BuffBroker.Constants.Confidence.Likely,Target=BuffBroker.TestCases.MockPlayers.Caster.GUID, spellid=19742}, -- wisdom
			},
		},
	}
} -- Groups