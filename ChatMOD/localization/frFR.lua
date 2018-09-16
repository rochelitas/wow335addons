if ( GetLocale() == "frFR" ) then
	SCCN_INIT_CHANNEL_LOCAL			= "G\195\169n\195\169ral";
	SCCN_GUI_HIGHLIGHT1				  = "Ici vous pouvez entrer les mots que Chatmod doit mettre en Surbrillance. Chaque ligne est un mot.";
	SCCN_LOCAL_CLASS["WARLOCK"] = "D\195\169moniste";
	SCCN_LOCAL_CLASS["HUNTER"]  = "Chasseur";
	SCCN_LOCAL_CLASS["PRIEST"]  = "Pr\195\170tre";
	SCCN_LOCAL_CLASS["PALADIN"] = "Paladin";
	SCCN_LOCAL_CLASS["MAGE"]    = "Mage";
	SCCN_LOCAL_CLASS["ROGUE"]   = "Voleur";
	SCCN_LOCAL_CLASS["DRUID"]   = "Druide";
	SCCN_LOCAL_CLASS["SHAMAN"]  = "Chaman";
	SCCN_LOCAL_CLASS["WARRIOR"] = "Guerrier";
	SCCN_LOCAL_CLASS["DEATHKNIGHT"] = "Chevalier de la mort";
		-- What the heck are the Engliosh female names for the classes ? How do you say to "Hexenmeisterin" ?
    SCCN_LOCAL_CLASS["WARLOCKF"] 	= "Warlockf"; -- Female Classname in English ?
    SCCN_LOCAL_CLASS["HUNTERF"]     = "Chasseresse"; -- Female Classname in English ?
    SCCN_LOCAL_CLASS["PRIESTF"]     = "Prêtresse"; -- Female Classname in English ?
    SCCN_LOCAL_CLASS["MAGEF"]       = "Magierin"; -- Female Classname in English ?
    SCCN_LOCAL_CLASS["ROGUEF"]      = "Voleuse"; -- Female Classname in English ?
    SCCN_LOCAL_CLASS["DRUIDF"]      = "Druidesse"; -- Female Classname in English ?
    SCCN_LOCAL_CLASS["SHAMANF"]     = "Chamane"; -- Female Classname in English ?
    SCCN_LOCAL_CLASS["WARRIORF"]    = "Guerrière"; -- Female Classname in English ?
    SCCN_LOCAL_CLASS["DEATHKNIGHT"] = "Todesritterin"; -- Female Classname in English ?
    SCCN_LOCAL_CLASS["DEATHKNIGHTF"] = "Chevalier de la mort";
    SCCN_LOCAL_CLASS["PALADINF"]    = "Paladin";
    
    
	-- Zones, partly Translation Needed
	SCCN_LOCAL_ZONE["alterac"]	= "Vall\195\169e d'Alterac";
	SCCN_LOCAL_ZONE["warsong"]	= "Goulet des Warsong";
	SCCN_LOCAL_ZONE["arathi"]	  = "Arathi Basin";
	-- Translation completed
	SCCN_CONFAB   = "|cffff0000L\'Addon Confab a \195\169t\195\169 trouv\195\169. Les fonctions SCCN Editbox ont \195\169t\195\169 d\195\169sactiv\195\169es par soucis de compatibilit\195\169";
	SCCN_HELP[1]  = "Sol's Color chat Nicks - Aide, ligne de commandes:";
	SCCN_HELP[2]  = "|cff68ccef".."/chatmod hidechanname ".."|cffffffff".." [ON/OFF] Supression du nom du canal";
	SCCN_HELP[3]  = "|cff68ccef".."/chatmod colornicks ".."|cffffffff".." [ON/OFF] Colorer les noms selon la couleur de classe.";
	SCCN_HELP[4]  = "|cff68ccef".."/chatmod purge".."|cffffffff".." Lancement d\'une purge standard de la base de Donn\195\169es. |cffa0a0a0(S\'ex\195\169cute automatiquement \195\160 chaque lancement de l\'addon).";
	SCCN_HELP[5]  = "|cff68ccef".."/chatmod killdb".."|cffffffff".." Supprime compl\195\168tement la base de Donn\195\169es. (D\195\169finitif)";
	SCCN_HELP[6]  = "|cff68ccef".."/chatmod mousescroll".."|cffffffff".." [ON/OFF] Faire d\195\169filer le Chat avec la molette de la souris. |cffa0a0a0(<SHIFT>-Molette = Scroll Rapide, <STRG>-Molette = Haut, Bas)";
	SCCN_HELP[7]  = "|cff68ccef".."/chatmod topeditbox".."|cffffffff".." D\195\169placer la zone de frappe en haut de la fen\195\170tre.";
	SCCN_HELP[8]  = "|cff68ccef".."/chatmod timestamp".."|cffffffff".." utiliser le format 24H dans les messages (HH:MM).";
	SCCN_HELP[9]  = "|cff68ccef".."/chatmod colormap".."|cffffffff".." Coloration des membres du raid par classe sur la carte.";
	SCCN_HELP[10] = "|cff68ccef".."/chatmod hyperlink".."|cffffffff".." Rendre les liens hypertextes clicables.";
	SCCN_HELP[11] = "|cff68ccef".."/chatmod selfhighlight".."|cffffffff".." Activer la surbrillance du nom de votre personnage dans les messages.";
	SCCN_HELP[12] = "|cff68ccef".."/chatmod clickinvite".."|cffffffff".." Rendre le mot [invite] clicable (invite sur clic).";
	SCCN_HELP[13] = "|cff68ccef".."/chatmod editboxkeys".."|cffffffff".." Utiliser les cl\195\169s du menu de Chat sans presser la touche <ALT> & augmenter le cache de l\'historique.";
	SCCN_HELP[14] = "|cff68ccef".."/chatmod chatstring".."|cffffffff".." Personnalisation des lignes de Chat.";
	SCCN_HELP[15] = "|cff68ccef".."/chatmod selfhighlightmsg".."|cffffffff".." Afficher les messages contenants votre nom \195\160 l\'\195\169cran.";
	SCCN_HELP[16] = "|cff68ccef".."/chatmod hidechatbuttons".."|cffffffff".." Cacher les boutons.";	
	SCCN_HELP[17] = "|cff68ccef".."/chatmod highlight".."|cffffffff".." Activer les filtres personnalis\195\169s de mise en surbrillance.";	
	SCCN_HELP[18] = "|cff68ccef".."/chatmod AutoBGMap".."|cffffffff".." Popup automatique de la carte de Champ de bataille.";		
	SCCN_HELP[19] = "|cff68ccef".."/chatmod shortchanname ".."|cffffffff".." Afficher les noms de canaux en version courte.";	
	SCCN_HELP[20] = "|cff68ccef".."/chatmod autogossipskip ".."|cffffffff".." Passer la fen\195\170tre de bavardage (gossip) automatiquement. |cffa0a0a0(Presser <CTRL> pour d\195\169sactiver cette fonction)";
	SCCN_HELP[21] = "|cff68ccef".."/chatmod autodismount ".."|cffffffff".." Quitter sa monture aux NPC de vol.";
	SCCN_HELP[22]	= "|cff68ccef".."/chatmod inchathighlight ".."|cffffffff".." Activer la surbrillance des pseudos connus.";	
	SCCN_HELP[23]	= "|cff68ccef".."/chatmod sticky ".."|cffffffff".." Activer le rappel du dernier canal utilis\195\169.";	
	SCCN_HELP[24]	= "|cff68ccef".."/chatmod initchan <channelname>".."|cffffffff".." D\195\169finir le canal par d\195\169faut au d\195\169marrage.";		
	SCCN_HELP[25]	= "|cff68ccef".."/chatmod nofade".."|cffffffff".." D\195\169sactiver l'effacement du texte.";
	SCCN_HELP[26]	= "|cff68ccef".."/chatmod chaticon".."|cffffffff".." Activer l'icone d'indicateur de d\195\169filement.";
	SCCN_HELP[27]	= "|cff68ccef".."/chatmod showlevel".."|cffffffff".." Afficher le niveau du personnage.";
	SCCN_HELP[28]	= "|cff68ccef".."/chatmod chatcolorname".."|cffffffff".." Inverser la fonction de coloration des noms.";
	SCCN_HELP[99] = "|cff68ccef".."/chatmod status".."|cffffffff".." Afficher la configuration courante.";
	SCCN_TS_HELP = "|cff68ccef".."/chatmod timestamp |cffFF0000FORMAT|cffffffff\n".."FORMAT:\n$h = heure (0-24) \n$t = heure (0-12) \n$m = minutes \n$s = secondes \n$p = periode (am / pm)\n".."|cff909090Exemple: /chatmod timestamp [$t:$m:$s $p]";
	SCCN_CMDSTATUS[1]  = "Suppression du nom du canal:";
	SCCN_CMDSTATUS[2]  = "Coloration par classe:";
	SCCN_CMDSTATUS[3]  = "Faire d\195\169filer le texte:";
	SCCN_CMDSTATUS[4]  = "Zone de frappe en haut:";
	SCCN_CMDSTATUS[5]  = "Format de l'heure du Chat:";
	SCCN_CMDSTATUS[6]  = "Coloration des membres du raid:";
	SCCN_CMDSTATUS[7]  = "Liens hypertextes clicables:";
	SCCN_CMDSTATUS[8]  = "Surbrillance sur soi-m\195\170me:";
	SCCN_CMDSTATUS[9]  = "Invite sur clic:";
	SCCN_CMDSTATUS[10] = "Utilisation des cl\195\169s du menu de Chat sans presser la touche <ALT>:";
	SCCN_CMDSTATUS[11] = "Personnalisation des lignes de Chat:";
	SCCN_CMDSTATUS[12] = "Affichage \195\160 l\'\195\169cran des messages contenant votre nom:";
	SCCN_CMDSTATUS[13] = "Cacher les boutons de la fen\195\170tre de Chat:";
	SCCN_CMDSTATUS[14] = "Popup automatique de la carte des champs de bataille:";
	SCCN_CMDSTATUS[15] = "Surbrillance personnalis\195\169e:";
	SCCN_CMDSTATUS[16] = "Nom court du canal:";
	SCCN_CMDSTATUS[17] = "Passer automatiquement fen\195\170tre de bavardage (gossip):";
	SCCN_CMDSTATUS[18] = "Quitter sa monture automatiquement:";	
	SCCN_CMDSTATUS[19] = "Surbrillance des noms:";	
	SCCN_CMDSTATUS[20] = "Se souvenir du dernier canal (sticky):";
	SCCN_CMDSTATUS[21] = "Ne pas effacer le texte du Chat automatiquement:";
	SCCN_CMDSTATUS[22] = "Icone de d\195\169filement du Chat:";
	SCCN_CMDSTATUS[23] = "Niveau du joueur dans le nom:";
	SCCN_CMDSTATUS[24] = "Colorer les noms dans le Chat:";
	SCCN_CMDSTATUS[25]              = "Chat Icon Markers:";
	SCCN_CMDSTATUS[26]				= "only Highlight full words:";
	-- cursom invite word in the local language
	SCCN_CUSTOM_INV[0] = "invite";
	-- Whispers customized
	SCCN_CUSTOM_CHT_FROM = "de %s:";
	SCCN_CUSTOM_CHT_TO = "\195\160 %s:";
	-- hide this channels aditional, feel free to add your own
	SCCN_STRIPCHAN[1] = "Guilde";
	SCCN_STRIPCHAN[2] = "Raid";
	SCCN_STRIPCHAN[3] = "Groupe";
-- ItemLink Channels
    SCCN_ILINK[1] = "G\195\169n\195\169ral -"
    SCCN_ILINK[2] = "Commerce -"
    SCCN_ILINK[3] = "RechercheGroupe -"
    SCCN_ILINK[4] = "D\195\169fenseLocale -"
    SCCN_ILINK[5] = "D\195\169fenseUniverselle"	
	
	-- some general channel name translation for the GUI
	SCCN_TRANSLATE[1] = "Guilde";
	SCCN_TRANSLATE[2]	= "Officer";
	SCCN_TRANSLATE[3]	= "Groupe";
	SCCN_TRANSLATE[4]	= "Raid";
	SCCN_TRANSLATE[5]	= "Whisper";
	SCCN_Highlighter	= "Highlight";
	SCCN_Config				= "Config";
	SCCN_Changelog		= "Changelog";	
	SCCN_NewVer       = "Une nouvelle version de ChatMOD est disponible. Merci de visiter www.solariz.de !";
end;
