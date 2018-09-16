if ( GetLocale() == "deDE" ) then
	SCCN_INIT_CHANNEL_LOCAL			= "Allgemein";
	SCCN_GUI_HIGHLIGHT1				= "In diesem Dialog können Wörter angegeben werden welche SCCN hervorheben soll.";
	SCCN_LOCAL_CLASS["WARLOCK"] 	= "Hexenmeister";
	SCCN_LOCAL_CLASS["HUNTER"] 		= "J\195\164ger";
	SCCN_LOCAL_CLASS["PRIEST"] 		= "Priester";
	SCCN_LOCAL_CLASS["PALADIN"] 	= "Paladin";
	SCCN_LOCAL_CLASS["MAGE"] 		= "Magier";
	SCCN_LOCAL_CLASS["ROGUE"] 		= "Schurke";
	SCCN_LOCAL_CLASS["DRUID"] 		= "Druide";
	SCCN_LOCAL_CLASS["SHAMAN"] 		= "Schamane";
	SCCN_LOCAL_CLASS["WARRIOR"] 	= "Krieger";
	SCCN_LOCAL_CLASS["DEATHKNIGHT"] = "Todesritter";
--  Female Classnames
    SCCN_LOCAL_CLASS["WARLOCKF"] 	= "Hexenmeisterin";
    SCCN_LOCAL_CLASS["HUNTERF"]     = "J\195\164gerin";
    SCCN_LOCAL_CLASS["PRIESTF"]     = "Priesterin";
    SCCN_LOCAL_CLASS["MAGEF"]       = "Magierin";
    SCCN_LOCAL_CLASS["ROGUEF"]      = "Schurkin";
    SCCN_LOCAL_CLASS["DRUIDF"]      = "Druidin";
    SCCN_LOCAL_CLASS["SHAMANF"]     = "Schamanin";
    SCCN_LOCAL_CLASS["WARRIORF"]    = "Kriegerin";
    SCCN_LOCAL_CLASS["DEATHKNIGHTF"] = "Todesritterin";
    SCCN_LOCAL_CLASS["PALADINF"]    = "Paladin";

	SCCN_LOCAL_ZONE["alterac"]	= "Alteractal";
	SCCN_LOCAL_ZONE["warsong"]	= "Warsongschlucht";
	SCCN_LOCAL_ZONE["arathi"]	= "Arathibecken";
	SCCN_CONFAB					= "|cffff0000Das 'confab' Addon wurde gefunden. SCCN Editbox Kontrolle wurde aus kompatibilitätsgründen deaktiviert!";
	SCCN_HELP[1]					= "Sol's Color chat Nicks - Command Hilfe:";
	SCCN_HELP[2]					= "|cff68ccef".."/chatmod hidechanname ".."|cffffffff".." Chat Kanalname wird ein/ausgeblendet";
	SCCN_HELP[3]					= "|cff68ccef".."/chatmod colornicks ".."|cffffffff".." Chat Nicknames nach Klasse färben  ein/ausschalten";
	SCCN_HELP[4]					= "|cff68ccef".."/chatmod purge".."|cffffffff".." Datenbank aufräumen. |cffa0a0a0(passiert auch automatisch wenn das Addon geladen wird)";
	SCCN_HELP[5]					= "|cff68ccef".."/chatmod killdb".."|cffffffff".." Datenbank komplett leeren. (kann nicht rückgängig gemacht werden)";
	SCCN_HELP[6]					= "|cff68ccef".."/chatmod mousescroll".."|cffffffff".." Im Chatfenster per Mausrad Scrollen ein/ausschalten. |cffa0a0a0(SHIFT-Mausrad = Schnelles scrollen, STRG-Mausrad = Anfang, Ende)";
	SCCN_HELP[7]					= "|cff68ccef".."/chatmod topeditbox".."|cffffffff".." Chat Eingabefeld oberhalb des chatfensters.";	
	SCCN_HELP[8]					= "|cff68ccef".."/chatmod timestamp".."|cffffffff".." Zeigt eine 24h Timestamp vor Chatnachrichten. SS:MM";
	SCCN_HELP[9]					= "|cff68ccef".."/chatmod colormap".."|cffffffff".." Raidmitglieder auf der Karte in Klassenfarbe darstellen.";	
	SCCN_HELP[10]					= "|cff68ccef".."/chatmod hyperlink".."|cffffffff".." Hyperlinks im Chat klickbar machen.";
	SCCN_HELP[11]					= "|cff68ccef".."/chatmod selfhighlight".."|cffffffff".." Eigenen namen in Chats hervorheben.";	
	SCCN_HELP[12]					= "|cff68ccef".."/chatmod clickinvite".."|cffffffff".." Macht das Wort [invite] im Chat klickbar. (Einladung bei Klick).";	
	SCCN_HELP[13]					= "|cff68ccef".."/chatmod editboxkeys".."|cffffffff".." Chat Editbox tasten ohne <ALT> nutzen & History buffer vergößern.";
	SCCN_HELP[14]					= "|cff68ccef".."/chatmod chatstring".."|cffffffff".." Angepasste Chat Zeichenketten.";	
	SCCN_HELP[15]					= "|cff68ccef".."/chatmod selfhighlightmsg".."|cffffffff".." OnScreen Ausgabe von Chatmeldungen mit eigenem Nickname.";	
	SCCN_HELP[16]					= "|cff68ccef".."/chatmod hidechatbuttons".."|cffffffff".." Chat Buttons ausblenden.";	
	SCCN_HELP[17]					= "|cff68ccef".."/chatmod highlight".."|cffffffff".." Angepasste Filter zur Hervorhebung von Worten im Chat.";
	SCCN_HELP[18]					= "|cff68ccef".."/chatmod AutoBGMap".."|cffffffff".." BGMinimap Autopupup.";
	SCCN_HELP[19]					= "|cff68ccef".."/chatmod shortchanname ".."|cffffffff".." Chat Kanalname wird verkürzt dargestellt";
	SCCN_HELP[20]					= "|cff68ccef".."/chatmod autogossipskip ".."|cffffffff".." Die info Fenster bei NPC's werden übersprungen. |cffa0a0a0(<STRG> drücken um kurzzeitig zu deaktivieren)";
	SCCN_HELP[21]					= "|cff68ccef".."/chatmod autodismount ".."|cffffffff".." Bei Flugpunkt NPC's wird automatisch vom Reittier abgestiegen.";
	SCCN_HELP[22]					= "|cff68ccef".."/chatmod inchathighlight ".."|cffffffff".."Highlight Known Nicknames";
	SCCN_HELP[23]					= "|cff68ccef".."/chatmod sticky ".."|cffffffff".."Sticky Chat behavior";	
	SCCN_HELP[24]					= "|cff68ccef".."/chatmod initchan <channelname>".."|cffffffff".."Setzt den standard Chatraum auf <channelname>";	
	SCCN_HELP[25]					= "|cff68ccef".."/chatmod nofade".."|cffffffff".."Der chattext wird nicht mehr nach gewisser Zeit ausgebeldet";
	SCCN_HELP[26]					= "|cff68ccef".."/chatmod chaticon".."|cffffffff".."Chatfenster scroll Anzeige Icon ein/aus -schalten";
	SCCN_HELP[27]					= "|cff68ccef".."/chatmod showlevel".."|cffffffff".."Levelanzeige im Namen ein/aus schalten";
	SCCN_HELP[28]					= "|cff68ccef".."/chatmod chatcolorname".."|cffffffff".."Name imChattext einfaerben";
	SCCN_HELP[99]					= "|cff68ccef".."/chatmod status".."|cffffffff".." Aktuelle Einstellungen zeigen.";
	SCCN_TS_HELP					= "|cff68ccef".."/chatmod timestamp |cffFF0000FORMAT|cffffffff\n".."FORMAT:\n$h = Stunde (0-24) \n$t = Stunde (0-12) \n$m = Minute \n$s = Sekunde \n$p = Periode (am / pm)\n".."|cff909090Beispiel: /chatmod timestamp [$t:$m:$s $p]";
	SCCN_CMDSTATUS[1]				= "Kanalname ausblenden:";
	SCCN_CMDSTATUS[2]				= "Chat Nicknames in Klassenfarbe:";
	SCCN_CMDSTATUS[3]				= "Im Chat per Mausrad Scrollen:";
	SCCN_CMDSTATUS[4]				= "Chat Eingabefeld oben:";
	SCCN_CMDSTATUS[5]				= "Chat Timestamp:";
	SCCN_CMDSTATUS[6]				= "Spielerpins auf Karte in Klassenfarbe:";
	SCCN_CMDSTATUS[7]				= "Klickbare Hyperlinks:";
	SCCN_CMDSTATUS[8]				= "Eigenen Namen hervorheben:";
	SCCN_CMDSTATUS[9]				= "Click Invite:";
	SCCN_CMDSTATUS[10]				= "Chat Editbox Tasten ohne <alt> nutzen:";
	SCCN_CMDSTATUS[11]				= "Angepasste Chat Zeichenkette.";
	SCCN_CMDSTATUS[12]				= "Chatnachrichten OnScreen:";
	SCCN_CMDSTATUS[13]				= "Chat Buttons ausblenden:";
	SCCN_CMDSTATUS[14]				= "Automatischer Popup der Schlachtfeld MiniKarte:";
	SCCN_CMDSTATUS[15]				= "Angepasster Highlightfilter:";
	SCCN_CMDSTATUS[16]				= "Kanalname verkürzen:";
	SCCN_CMDSTATUS[17]				= "Auto Gossip Skip:";
	SCCN_CMDSTATUS[18]				= "Auto Dismount:";
	SCCN_CMDSTATUS[19]				= "Bekannte Namen hervorheben:";	
	SCCN_CMDSTATUS[20]				= "Letzten Chatraum merken (sticky):";	
	SCCN_CMDSTATUS[21]				= "Chattext nicht automatisch ausbleden:";	
	SCCN_CMDSTATUS[22]				= "Chat Scoll Icon:";
	SCCN_CMDSTATUS[23]				= "Levelanzeige im Name:";
	SCCN_CMDSTATUS[24]              = "Namen im Chattext einfaerben:";
	SCCN_CMDSTATUS[25]              = "Chat Icon Markierungen:";
	SCCN_CMDSTATUS[26]				= "nur noch ganze Wörter hervorheben:";
	
	
	-- cursom invite word in the local language
	SCCN_CUSTOM_INV[0] 				= "einladen";	
	SCCN_CUSTOM_INV[1] 				= "inviten";
	-- Whispers customized
	SCCN_CUSTOM_CHT_FROM			= "von %s:";
	SCCN_CUSTOM_CHT_TO				= "zu %s:";		
	-- hide this channels aditional, feel free to add your own	
	SCCN_STRIPCHAN[1]				= "Gilde";
	SCCN_STRIPCHAN[2]				= "Schlachtzug";
	SCCN_STRIPCHAN[3]				= "Gruppe";
	SCCN_STRIPCHAN[4]				= "WeltVerteidigung";
	SCCN_STRIPCHAN[5]				= "Offizier";
	SCCN_STRIPCHAN[6]				= "SucheNachGruppe";
	SCCN_STRIPCHAN[7]				= "Allgemein";
	SCCN_STRIPCHAN[8]				= "Handel";
	SCCN_STRIPCHAN[9]				= "LokaleVerteidigung";
-- ItemLink Channels
    SCCN_ILINK[1]                   = "Allgemein -"
    SCCN_ILINK[2]                   = "Handel -"
    SCCN_ILINK[3]                   = "SucheNachGruppe -"
    SCCN_ILINK[4]                   = "LokaleVerteidigung -"
    SCCN_ILINK[5]                   = "WeltVerteidigung"
	
	SCCN_TRANSLATE[1]				= "Gilde";
	SCCN_TRANSLATE[2]				= "Offizier";
	SCCN_TRANSLATE[3]				= "Gruppe";
	SCCN_TRANSLATE[4]				= "Schlachtzug";
	SCCN_TRANSLATE[5]				= "Flüstern";
	SCCN_Highlighter				= "ChatMOD Hervorheben";
	SCCN_Config						= "ChatMOD Konfig";
	SCCN_Changelog					= "ChatMOD Aenderungen";
	SCCN_NewVer                     = "Es ist eine neue Version von ChatMOD Verfügbar. Auf http://www.solariz.de gibt es mehr dazu!";
end;
