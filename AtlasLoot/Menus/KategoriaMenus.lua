local AL = LibStub("AceLocale-3.0"):GetLocale("AtlasLoot");
local BabbleInventory = AtlasLoot_GetLocaleLibBabble("LibBabble-Inventory-3.0")
local BabbleFaction = AtlasLoot_GetLocaleLibBabble("LibBabble-Faction-3.0")
local BabbleZone = AtlasLoot_GetLocaleLibBabble("LibBabble-Zone-3.0")


	AtlasLoot_Data["KATEGORIAMENU"] = {
		{ 2, "7MENU", "seven", "=ds="..AL["7 kata"], ""};
		{ 3, "6MENU", "six", "=ds="..AL["6 kata"], ""};
		{ 4, "5MENU", "five", "=ds="..AL["5 kata"], ""};
		{ 5, "4MENU", "four", "=ds="..AL["4 kata"], ""};
		{ 6, "3MENU", "three", "=ds="..AL["3 kata"], ""};
		{ 7, "2MENU", "two", "=ds="..AL["2 kata"], ""};
		{ 8, "1MENU", "one", "=ds="..AL["1 kata"], ""};
		{ 10, "SIRUSLEGENDARYMENU", "inv_misc_cape_deathwingraid_d_01", "=ds="..AL["SIRUSLEGENDARY"], ""};
		{ 11, "SIRUSCHESTMENU", "inv_misc_bag_34", "=ds="..AL["SIRUSCHEST"], ""};
		{ 12, "SIRUSCHEST2MENU", "inv_misc_lockbox_1", "=ds="..AL["SIRUSCHEST2"], ""};
		{ 14, "SIRUSMOUNTMENU", "ability_mount_cranemountblue", "=ds="..AL["SIRUSMOUNT"], ""};
		{ 15, "SIRUSPETMENU", "inv_misc_petmoonkinne", "=ds="..AL["SIRUSPET"], ""};
	
		{ 17, "LordKrimor", "Ability_Ambush", "=ds="..AL["LordKrimor"], ""};
	};

	AtlasLoot_Data["7MENU"] = {
		{ 2, "7Menu+", "seven", "=ds="..AL["7+ kata"], ""};
		Back = "KATEGORIAMENU";
	};

	AtlasLoot_Data["6MENU"] = {
		{ 2, "6Menu+", "six", "=ds="..AL["6+ kata"], ""};
		{ 3, "6Menu++", "six", "=ds="..AL["6++ kata"], ""};
		Back = "KATEGORIAMENU";
	};

	AtlasLoot_Data["5MENU"] = {
		{ 2, "5Menu+", "five", "=ds="..AL["5+ kata"], ""};
		{ 3, "5Menu++", "five", "=ds="..AL["5++ kata"], ""};
		{ 4, "5Menu+++", "five", "=ds="..AL["5+++ kata"], ""};
		Back = "KATEGORIAMENU";
	};

	AtlasLoot_Data["4MENU"] = {
		{ 2, "4Menu+", "four", "=ds="..AL["4+ kata"], ""};
		{ 3, "4Menu++", "four", "=ds="..AL["4++ kata"], ""};
		{ 4, "4Menu+++", "four", "=ds="..AL["4+++ kata"], ""};
		{ 5, "4Menu++++", "four", "=ds="..AL["4++++ kata"], ""};
		Back = "KATEGORIAMENU";
	};

	AtlasLoot_Data["3MENU"] = {
		{ 2, "3Menu+", "three", "=ds="..AL["3+ kata"], ""};
		{ 3, "3Menu++", "three", "=ds="..AL["3++ kata"], ""};
		{ 4, "3Menu+++", "three", "=ds="..AL["3+++ kata"], ""};
		{ 5, "3Menu++++", "three", "=ds="..AL["3++++ kata"], ""};
		{ 6, "3Menu+++++", "three", "=ds="..AL["3+++++ kata"], ""};
		Back = "KATEGORIAMENU";
	};

	AtlasLoot_Data["2MENU"] = {
		{ 2, "2Menu+", "two", "=ds="..AL["2+ kata"], ""};
		{ 3, "2Menu++", "two", "=ds="..AL["2++ kata"], ""};
		{ 4, "2Menu+++", "two", "=ds="..AL["2+++ kata"], ""};
		{ 5, "2Menu++++", "two", "=ds="..AL["2++++ kata"], ""};
		{ 6, "2Menu+++++", "two", "=ds="..AL["2+++++ kata"], ""};
		{ 7, "2Menu++++++", "two", "=ds="..AL["2++++++ kata"], ""};
		Back = "KATEGORIAMENU";
	};

	AtlasLoot_Data["1MENU"] = {
		{ 2, "1Menu+", "one", "=ds="..AL["1+ kata"], ""};
		{ 3, "1Menu++", "one", "=ds="..AL["1++ kata"], ""};
		{ 4, "1Menu+++", "one", "=ds="..AL["1+++ kata"], ""};
		{ 5, "1Menu++++", "one", "=ds="..AL["1++++ kata"], ""};
		{ 6, "1Menu+++++", "one", "=ds="..AL["1+++++ kata"], ""};
		{ 7, "1Menu++++++", "one", "=ds="..AL["1++++++ kata"], ""};
		{ 8, "1Menu+++++++", "one", "=ds="..AL["1+++++++ kata"], ""};
		Back = "KATEGORIAMENU";
	};

------------------------
-------- Signs ---------
------------------------

	AtlasLoot_Data["TailorMENU"] = {
		{ 2, "TailorMenu1", "inv_fabric_frostweave_imbuedbolt", "=ds="..AL["TailorSign1"], ""};
		{ 3, "TailorMenu2", "spell_nature_astralrecalgroup", "=ds="..AL["TailorSign2"], ""};
		{ 17, "TailorMenu3", "inv_fabric_netherweave_bolt", "=ds="..AL["TailorSign3"], ""};
		{ 18, "TailorMenu4", "inv_fabric_netherweave_bolt_imbued", "=ds="..AL["TailorSign4"], ""};
		{ 19, "TailorMenu5", "inv_fabric_soulcloth_bolt", "=ds="..AL["TailorSign5"], ""};
		Back = "KATEGORIAMENU";
	};

	AtlasLoot_Data["AlchemyMENU"] = {
		{ 2, "AlchemyMenu1", "inv_potion_27", "=ds="..AL["AlchemySign1"], ""};
		{ 17, "AlchemyMenu2", "inv_potion_28", "=ds="..AL["AlchemySign2"], ""};
		Back = "KATEGORIAMENU";
	};

	AtlasLoot_Data["EnchanterMENU"] = {
		{ 2, "EnchanterMenu1", "inv_enchant_essencenetherlarge", "=ds="..AL["EnchanterSign1"], ""};
		{ 3, "EnchanterMenu2", "inv_enchant_essenceeternallarge", "=ds="..AL["EnchanterSign2"], ""};
		{ 17, "EnchanterMenu3", "inv_enchant_duststrange", "=ds="..AL["EnchanterSign3"], ""};
		{ 18, "EnchanterMenu4", "inv_enchant_dustvision", "=ds="..AL["EnchanterSign4"], ""};
		Back = "KATEGORIAMENU";
	};

	AtlasLoot_Data["EngineerMENU"] = {
		{ 2, "EngineerMenu1", "inv_gizmo_adamantiteframe", "=ds="..AL["EngineerSign1"], ""};
		{ 3, "EngineerMenu2", "inv_misc_enggizmos_28", "=ds="..AL["EngineerSign2"], ""};
		{ 17, "EngineerMenu3", "inv_gizmo_bronzeframework_01", "=ds="..AL["EngineerSign3"], ""};
		{ 18, "EngineerMenu4", "inv_gizmo_felironcasing", "=ds="..AL["EngineerSign4"], ""};
		Back = "KATEGORIAMENU";
	};

	AtlasLoot_Data["SkinnerMENU"] = {
		{ 2, "SkinnerMenu1", "inv_misc_armorkit_23", "=ds="..AL["SkinnerSign1"], ""};
		{ 3, "SkinnerMenu2", "inv_misc_armorkit_25", "=ds="..AL["SkinnerSign2"], ""};
		{ 4, "SkinnerMenu3", "inv_misc_armorkit_22", "=ds="..AL["SkinnerSign3"], ""};
		{ 17, "SkinnerMenu4", "inv_misc_armorkit_28", "=ds="..AL["SkinnerSign4"], ""};
		{ 18, "SkinnerMenu5", "inv_misc_armorkit_31", "=ds="..AL["SkinnerSign5"], ""};
		{ 19, "SkinnerMenu6", "inv_misc_armorkit_29", "=ds="..AL["SkinnerSign6"], ""};
		Back = "KATEGORIAMENU";
	};

	AtlasLoot_Data["CookerMENU"] = {
		{ 2, "CookerMenu1", "inv_misc_food_64", "=ds="..AL["CookerSign1"], ""};
		{ 3, "CookerMenu2", "inv_potion_01", "=ds="..AL["CookerSign2"], ""};
		{ 17, "CookerMenu3", "inv_misc_food_117_heartysoup", "=ds="..AL["CookerSign3"], ""};
		Back = "KATEGORIAMENU";
	};
	
	AtlasLoot_Data["InscriptionMENU"] = {
		{ 2, "InscriptionMenu1", "inv_misc_book_08", "=ds="..AL["InscriptionSign1"], ""};
		{ 17, "InscriptionMenu2", "inv_misc_book_10", "=ds="..AL["InscriptionSign2"], ""};
		Back = "KATEGORIAMENU";
	};
	
	AtlasLoot_Data["MinerMENU"] = {
		{ 2, "MinerMenu1", "inv_rod_platinum", "=ds="..AL["MinerSign1"], ""};
		{ 3, "MinerMenu2", "inv_staff_19", "=ds="..AL["MinerSign2"], ""};
		{ 4, "MinerMenu3", "spell_shadow_mindbomb", "=ds="..AL["MinerSign3"], ""};
		{ 17, "MinerMenu4", "inv_rod_adamantite", "=ds="..AL["MinerSign4"], ""};
		{ 18, "MinerMenu5", "inv_rod_eternium", "=ds="..AL["MinerSign5"], ""};
		{ 19, "MinerMenu6", "inv_ingot_thorium", "=ds="..AL["MinerSign6"], ""};
		Back = "KATEGORIAMENU";
	};
	
	AtlasLoot_Data["ElementalMENU"] = {
		{ 2, "ElementalMenu1", "spell_fire_masterofelements", "=ds="..AL["ElementalSign1"], ""};
		{ 4, "ElementalMenu2", "inv_misc_petbiscuit_01", "=ds="..AL["ElementalSign2"], ""};
		{ 5, "ElementalMenu3", "ability_mage_netherwindpresence", "=ds="..AL["ElementalSign3"], ""};
		{ 6, "ElementalMenu4", "ability_druid_treeoflife", "=ds="..AL["ElementalSign4"], ""};
		{ 17, "ElementalMenu5", "spell_holy_pureofheart", "=ds="..AL["ElementalSign5"], ""};
		{ 19, "ElementalMenu6", "inv_ingot_eternium", "=ds="..AL["ElementalSign6"], ""};
		{ 20, "ElementalMenu7", "inv_jewelcrafting_starofelune_01", "=ds="..AL["ElementalSign7"], ""};
		{ 21, "ElementalMenu8", "inv_enchant_voidsphere", "=ds="..AL["ElementalSign8"], ""};
		Back = "KATEGORIAMENU";
	};
		
	AtlasLoot_Data["JewelryMENU"] = {
		{ 2, "JewelryMenu1", "inv_misc_gem_03", "=ds="..AL["JewelrySign1"], ""};
		{ 4, "JewelryMenu2", "inv_jewelcrafting_gem_25", "=ds="..AL["JewelrySign2"], ""};
		{ 5, "JewelryMenu3", "inv_jewelcrafting_gem_19", "=ds="..AL["JewelrySign3"], ""};
		{ 7, "JewelryMenu4", "inv_misc_gem_02", "=ds="..AL["JewelrySign4"], ""};
		{ 9, "JewelryMenu5", "inv_jewelcrafting_gem_27", "=ds="..AL["JewelrySign5"], ""};
		{ 10, "JewelryMenu6", "inv_jewelcrafting_gem_24", "=ds="..AL["JewelrySign6"], ""};
		{ 12, "JewelryMenu7", "inv_misc_gem_01", "=ds="..AL["JewelrySign7"], ""};
		{ 14, "JewelryMenu8", "inv_jewelcrafting_gem_29", "=ds="..AL["JewelrySign8"], ""};
		{ 15, "JewelryMenu9", "inv_jewelcrafting_gem_23", "=ds="..AL["JewelrySign9"], ""}; ------
		{ 17, "JewelryMenu10", "inv_jewelcrafting_seasprayemerald_02", "=ds="..AL["JewelrySign10"], ""};
		{ 19, "JewelryMenu11", "inv_jewelcrafting_talasite_03", "=ds="..AL["JewelrySign11"], ""};
		{ 20, "JewelryMenu12", "inv_misc_gem_deepperidot_02", "=ds="..AL["JewelrySign12"], ""};
		{ 22, "JewelryMenu13", "inv_jewelcrafting_empyreansapphire_02", "=ds="..AL["JewelrySign13"], ""};
		{ 24, "JewelryMenu14", "inv_jewelcrafting_starofelune_03", "=ds="..AL["JewelrySign14"], ""};
		{ 25, "JewelryMenu15", "inv_misc_gem_azuredraenite_02", "=ds="..AL["JewelrySign15"], ""};
		{ 27, "JewelryMenu16", "inv_jewelcrafting_shadowsongamethyst_02", "=ds="..AL["JewelrySign16"], ""};
		{ 29, "JewelryMenu17", "inv_jewelcrafting_nightseye_03", "=ds="..AL["JewelrySign17"], ""};
		{ 30, "JewelryMenu18", "inv_misc_gem_ebondraenite_02", "=ds="..AL["JewelrySign18"], ""};
		Back = "KATEGORIAMENU";
	};
