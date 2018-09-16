if ( GetLocale() ~= "deDE" and GetLocale() ~= "frFR" and GetLocale() ~= "zhCN" and GetLocale() ~= "zhTW" and GetLocale() ~= "koKR" ) then
    SCCN_INIT_CHANNEL_LOCAL			= "General";
	SCCN_GUI_HIGHLIGHT1				= "In this Dialogue you can enter Words which ChatMOD should Highlight. Each Line is one Word.";
	SCCN_LOCAL_CLASS["WARLOCK"] 	= "Warlock";
	SCCN_LOCAL_CLASS["HUNTER"] 		= "Hunter";
	SCCN_LOCAL_CLASS["PRIEST"] 		= "Priest";
	SCCN_LOCAL_CLASS["PALADIN"] 	= "Paladin";
	SCCN_LOCAL_CLASS["MAGE"] 		= "Mage";
	SCCN_LOCAL_CLASS["ROGUE"] 		= "Rogue";
	SCCN_LOCAL_CLASS["DRUID"] 		= "Druid";
	SCCN_LOCAL_CLASS["SHAMAN"] 		= "Shaman";
	SCCN_LOCAL_CLASS["WARRIOR"] 	= "Warrior";
	SCCN_LOCAL_CLASS["DEATHKNIGHT"] = "Deathknight";
	--  Female Classnames
	-- What the heck are the Engliosh female names for the classes ? How do you say to "Hexenmeisterin" ?
    SCCN_LOCAL_CLASS["WARLOCKF"] 	= "Warlockf"; -- Female Classname in English ?
    SCCN_LOCAL_CLASS["HUNTERF"]     = "Huntress"; -- Female Classname in English ?
    SCCN_LOCAL_CLASS["PRIESTF"]     = "Priestress"; -- Female Classname in English ?
    SCCN_LOCAL_CLASS["MAGEF"]       = "Mage"; -- Female Classname in English ?
    SCCN_LOCAL_CLASS["ROGUEF"]      = "Schurkin"; -- Female Classname in English ?
    SCCN_LOCAL_CLASS["DRUIDF"]      = "Druidin"; -- Female Classname in English ?
    SCCN_LOCAL_CLASS["SHAMANF"]     = "Schamanin"; -- Female Classname in English ?
    SCCN_LOCAL_CLASS["WARRIORF"]    = "Kriegerin"; -- Female Classname in English ?
    SCCN_LOCAL_CLASS["DEATHKNIGHTF"] = "Todesritterin"; -- Female Classname in English ?
    SCCN_LOCAL_CLASS["PALADINF"]    = "Paladin";
	-- Zones
	SCCN_LOCAL_ZONE["alterac"]	= "Alterac Valley";
	SCCN_LOCAL_ZONE["warsong"]	= "Warsong Gulch";
	SCCN_LOCAL_ZONE["arathi"]	= "Arathi Basin";
	SCCN_CONFAB						= "|cffff0000The Confab Addon was found. SCCN Editbox functions are disabled due to compatibility!";
	SCCN_HELP[1]					= "Sol's Color chat Nicks - Command Help:";
	SCCN_HELP[2]					= "|cff68ccef".."/chatmod hidechanname ".."|cffffffff".." Toggle chatname supression";
	SCCN_HELP[3]					= "|cff68ccef".."/chatmod colornicks ".."|cffffffff".." Toggle Chatname coloring in chatters class";
	SCCN_HELP[4]					= "|cff68ccef".."/chatmod purge".."|cffffffff".." Start a standard DB purge. |cffa0a0a0(done automaticaly each time the addon is loaded)";
	SCCN_HELP[5]					= "|cff68ccef".."/chatmod killdb".."|cffffffff".." Flushes the Database completly. (no undo)";
	SCCN_HELP[6]					= "|cff68ccef".."/chatmod mousescroll".."|cffffffff".." Toggle chat scrolling with mousewheel. |cffa0a0a0(<SHIFT>-MouseWheel  = Fast Scroll, <STRG>-MWheel = Top, Bottom)";
	SCCN_HELP[7]					= "|cff68ccef".."/chatmod topeditbox".."|cffffffff".." Move the chat editbox on top of the chatframe.";
	SCCN_HELP[8]					= "|cff68ccef".."/chatmod timestamp".."|cffffffff".." Show 24h Timestamp in Chatwindow.  HH:MM";
	SCCN_HELP[9]					= "|cff68ccef".."/chatmod colormap".."|cffffffff".." Color raidmembers on map in classcolor.";
	SCCN_HELP[10]					= "|cff68ccef".."/chatmod hyperlink".."|cffffffff".." Make Hyperlinks in Chat clickable.";
	SCCN_HELP[11]					= "|cff68ccef".."/chatmod selfhighlight".."|cffffffff".." Highlight own charname in chats.";
	SCCN_HELP[12]					= "|cff68ccef".."/chatmod clickinvite".."|cffffffff".." Make the word [invite] clickable in chats (invite on click).";
	SCCN_HELP[13] 					= "|cff68ccef".."/chatmod editboxkeys".."|cffffffff".." Use Chat Editbox keys without pressing <ALT> & increase History Buffer.";
	SCCN_HELP[14] 					= "|cff68ccef".."/chatmod chatstring".."|cffffffff".." Custom chat Strings.";
	SCCN_HELP[15] 					= "|cff68ccef".."/chatmod selfhighlightmsg".."|cffffffff".." Print OnScreen msg containing own nick on Screen.";
	SCCN_HELP[16]					= "|cff68ccef".."/chatmod hidechatbuttons".."|cffffffff".." Hide Chat Buttons.";
	SCCN_HELP[17]					= "|cff68ccef".."/chatmod highlight".."|cffffffff".." Custom filter dialogue for highlighting Words in Chat.";
	SCCN_HELP[19] = "|cff68ccef".."/chatmod shortchanname ".."|cffffffff".." Displays Short channelname.";
	SCCN_HELP[20] = "|cff68ccef".."/chatmod autogossipskip ".."|cffffffff".." Skip the gossip Window automaticaly. |cffa0a0a0(Press <CTRL> to deactivate skip)";
	SCCN_HELP[21] = "|cff68ccef".."/chatmod autodismount ".."|cffffffff".." Auto Dismounts at taxi NPCs";
	SCCN_HELP[22]					= "|cff68ccef".."/chatmod inchathighlight ".."|cffffffff".."Highlight Known Nicknames";
	SCCN_HELP[22]					= "|cff68ccef".."/chatmod sticky ".."|cffffffff".."Sticky Chat behavior";
	SCCN_HELP[23]					= "|cff68ccef".."/chatmod sticky ".."|cffffffff".."Sticky Chat behavior";
	SCCN_HELP[24]					= "|cff68ccef".."/chatmod initchan <channelname>".."|cffffffff".."Set the specified <channelname> to default chatfram on startup.";
	SCCN_HELP[25]					= "|cff68ccef".."/chatmod nofade".."|cffffffff".."Disable fading of Chattext";
	SCCN_HELP[26]					= "|cff68ccef".."/chatmod chaticon".."|cffffffff".."Toggle Chatcroll indicator Icon";
	SCCN_HELP[27]					= "|cff68ccef".."/chatmod showlevel".."|cffffffff".."Toggle Leveldisplay in Name";
	SCCN_HELP[28]					= "|cff68ccef".."/chatmod chatcolorname".."|cffffffff".."Toggle Namecoloring in Chattext";

	SCCN_HELP[99]					= "|cff68ccef".."/chatmod status".."|cffffffff".." Show current configuration.";
	SCCN_TS_HELP  					= "|cff68ccef".."/chatmod timestamp |cffFF0000FORMAT|cffffffff\n".."FORMAT:\n$h = hour (0-24) \n$t = hour (0-12) \n$m = minute \n$s = second \n$p = periode (am / pm)\n".."|cff909090Example: /chatmod timestamp [$t:$m:$s $p]";
	SCCN_CMDSTATUS[1]				= "Supress Channelname:";
	SCCN_CMDSTATUS[2]				= "Chat nicknames in classcolor:";
	SCCN_CMDSTATUS[3]				= "Scroll Chat with Mousewheel:";
	SCCN_CMDSTATUS[4]				= "Chat Editbox onTop:";
	SCCN_CMDSTATUS[5]				= "Chat Timestamp:";
	SCCN_CMDSTATUS[6]				= "Class colored Map pins:";
	SCCN_CMDSTATUS[7]				= "Clickable Hyperlinks:";
	SCCN_CMDSTATUS[8]				= "Self Highlight:";
	SCCN_CMDSTATUS[9]				= "Click Invite:";
	SCCN_CMDSTATUS[10]  			= "Use Editbox Keys without <ALT>:";
	SCCN_CMDSTATUS[11] 				= "Custom chat strings:";
	SCCN_CMDSTATUS[12]				= "Self Highlight On Screen:";
	SCCN_CMDSTATUS[13]				= "Hide Chat Buttons:";
	SCCN_CMDSTATUS[14] 				= "BG Minimap Autopopup:";
	SCCN_CMDSTATUS[15] 				= "Custom Highlight:";
	SCCN_CMDSTATUS[16] 				= "Short Channelname:";
	SCCN_CMDSTATUS[17]				= "Auto Gossip Skip:";
	SCCN_CMDSTATUS[18]				= "Auto Dismount:";
	SCCN_CMDSTATUS[19]				= "In Chat Highlight:";
	SCCN_CMDSTATUS[20]				= "Remeber last Chatroom (sticky):";
	SCCN_CMDSTATUS[21]				= "Don't Fade chattext automaticaly:";
	SCCN_CMDSTATUS[22]				= "Chat Scoll Icon:";
	SCCN_CMDSTATUS[23]				= "Leveldisplay in Name:";
	SCCN_CMDSTATUS[24]      = "Color names in Chattext:";
	SCCN_CMDSTATUS[25]              = "Chat Icon Markers:";
	SCCN_CMDSTATUS[26]				= "only Highlight full words:";
	-- cursom invite word in the local language
	SCCN_CUSTOM_INV[0] 				= "1nv1t3"; --   :D
	SCCN_CUSTOM_INV[1] 				= "einladen"; --   :D
	-- Whispers customized
	SCCN_CUSTOM_CHT_FROM			= "From %s:";
	SCCN_CUSTOM_CHT_TO				= "To %s:";
	-- hide this channels aditional, feel free to add your own
	SCCN_STRIPCHAN[1]				= "Guild";
	SCCN_STRIPCHAN[2]				= "Raid";
	SCCN_STRIPCHAN[3]				= "Party";
	SCCN_STRIPCHAN[4]				= "LocalDefense";
	SCCN_STRIPCHAN[5]				= "WorldDefense";
	SCCN_STRIPCHAN[6]				= "LookingForGroup";
	SCCN_STRIPCHAN[7]				= "Trade";
	SCCN_STRIPCHAN[8]				= "General";
	SCCN_STRIPCHAN[9]				= "Battleground";

	-- ItemLink Channels
    SCCN_ILINK[1]                   = "General -"
    SCCN_ILINK[2]                   = "Trade -"
    SCCN_ILINK[3]                   = "LookingForGroup"
    SCCN_ILINK[4]                   = "LocalDefense -"
    SCCN_ILINK[5]                   = "WorldDefense"
	-- some general channel name translation for the GUI
	SCCN_TRANSLATE[1]				= "Guild";
	SCCN_TRANSLATE[2]				= "Officer";
	SCCN_TRANSLATE[3]				= "Group";
	SCCN_TRANSLATE[4]				= "Raid";
	SCCN_TRANSLATE[5]				= "Whisper";
	SCCN_Highlighter				= "ChatMOD Highlight";
	SCCN_Config						= "ChatMOD Config";
	SCCN_Changelog					= "ChatMOD Changelog";
	SCCN_NewVer                     = "There is a new ChatMOD Version available. Check http://www.solariz.de for Update!";

end