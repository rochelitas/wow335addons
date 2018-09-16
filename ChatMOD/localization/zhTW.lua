--==============
--= TAIWAN =
--==============
-- Chinese Translation by Chris
-- Chris' Profile: http://forums.curse-gaming.com/member.php?u=47448
-- Last Update 28.05.2007  Thanks for Info by 'toshism' that URF-8 was broken.
if ( GetLocale() == "zhTW" ) then
	SCCN_INIT_CHANNEL_LOCAL			= "General";
	SCCN_GUI_HIGHLIGHT1				= "In this Dialogue you can enter Words which ChatMOD should Highlight. Each Line is one Word.";
	SCCN_LOCAL_CLASS["WARLOCK"] 	= "術士";
	SCCN_LOCAL_CLASS["HUNTER"] 	= "獵人";
	SCCN_LOCAL_CLASS["PRIEST"] 	= "牧師";
	SCCN_LOCAL_CLASS["PALADIN"] 	= "聖騎士";
	SCCN_LOCAL_CLASS["MAGE"] 	= "法師";
	SCCN_LOCAL_CLASS["ROGUE"] 	= "盜賊";
	SCCN_LOCAL_CLASS["DRUID"] 	= "德魯伊";
	SCCN_LOCAL_CLASS["SHAMAN"] 	= "薩滿";
	SCCN_LOCAL_CLASS["WARRIOR"] 	= "戰士";
	SCCN_LOCAL_CLASS["DEATHKNIGHT"] = "Todesritter"; -- ???

	-- What the heck are the Engliosh female names for the classes ? How do you say to "Hexenmeisterin" ?
    SCCN_LOCAL_CLASS["WARLOCKF"] 	= "術士"; -- Female Classname in English ?
    SCCN_LOCAL_CLASS["HUNTERF"]     = "獵人"; -- Female Classname in English ?
    SCCN_LOCAL_CLASS["PRIESTF"]     = "牧師"; -- Female Classname in English ?
    SCCN_LOCAL_CLASS["MAGEF"]       = "法師"; -- Female Classname in English ?
    SCCN_LOCAL_CLASS["ROGUEF"]      = "盜賊"; -- Female Classname in English ?
    SCCN_LOCAL_CLASS["DRUIDF"]      = "德魯伊"; -- Female Classname in English ?
    SCCN_LOCAL_CLASS["SHAMANF"]     = "薩滿"; -- Female Classname in English ?
    SCCN_LOCAL_CLASS["WARRIORF"]    = "戰士"; -- Female Classname in English ?
    SCCN_LOCAL_CLASS["DEATHKNIGHT"] = "Todesritterin"; -- Female Classname in English ?
	-- Zones, Translation Needed
	SCCN_LOCAL_ZONE["alterac"]	= "Alterac Valley";
	SCCN_LOCAL_ZONE["warsong"]	= "Warsong Gulch";
	SCCN_LOCAL_ZONE["arathi"]	= "Arathi Basin";
	SCCN_CONFAB			= "|cffff0000你有安裝Confab。為了相容性，SCCN的輸入框相關功能取消！";
	SCCN_HELP[1]			= "Sol's Color chat Nicks - 指令說明:";
	SCCN_HELP[2]			= "|cff68ccef".."/chatmod hidechanname".."|cffffffff".." 隱藏頻道名稱";
	SCCN_HELP[3]			= "|cff68ccef".."/chatmod colornicks".."|cffffffff".." 以職業顏色顯示玩家名字";
	SCCN_HELP[4]			= "|cff68ccef".."/chatmod purge".."|cffffffff".." 整理SCCN資料庫。 |cffa0a0a0(每次載入此ui時都會自動做這個動作。)";
	SCCN_HELP[5]			= "|cff68ccef".."/chatmod killdb".."|cffffffff".." 完整地把SCCN資料庫清除。 (無法復原)";
	SCCN_HELP[6]			= "|cff68ccef".."/chatmod mousescroll".."|cffffffff".." 用滑鼠滾輪捲動對話欄。 |cffa0a0a0(按著<SHIFT>-滑鼠滾輪=快捲，按著<CTRL>-滑鼠滾輪=捲至盡頭)";
	SCCN_HELP[7]			= "|cff68ccef".."/chatmod topeditbox".."|cffffffff".." 對話輸入框顯示在聊天視窗的最上頭。";	
	SCCN_HELP[8]			= "|cff68ccef".."/chatmod timestamp".."|cffffffff".." 顯示時間戳記在每列訊息之前。鍵入|cffa0a0a0 /chatmod timestamp ?|cffffffff 顯示更改格式說明。";
	SCCN_HELP[9]			= "|cff68ccef".."/chatmod colormap".."|cffffffff".." 小地圖上的團隊成員以職業顏色標記。";	
	SCCN_HELP[10]			= "|cff68ccef".."/chatmod hyperlink".."|cffffffff".." 讓對話訊息裡的網頁連結可被點選複製！";
	SCCN_HELP[11]			= "|cff68ccef".."/chatmod selfhighlight".."|cffffffff".." 在對話訊息中把自己名字明顯標示！";
	SCCN_HELP[12]			= "|cff68ccef".."/chatmod clickinvite".."|cffffffff".." 讓對話訊息中的[邀請]能直接被點選以加入隊伍。";	
	SCCN_HELP[13] 			= "|cff68ccef".."/chatmod editboxkeys".."|cffffffff".." 在對話輸入框裡不需按著<ALT>鍵就能用方向鍵做編輯 & 歷史記錄緩衝區增加至256行！";
	SCCN_HELP[14] 			= "|cff68ccef".."/chatmod chatstring".."|cffffffff".." 簡化密語字串。";
	SCCN_HELP[15] 			= "|cff68ccef".."/chatmod selfhighlightmsg".."|cffffffff".." 包含自己名字的對話訊息會另外顯示在螢幕上方，須開啟 /chatmod selfhighlight";	
	SCCN_HELP[16]			= "|cff68ccef".."/chatmod hidechatbuttons".."|cffffffff".." Hide Chat Buttons.";	
	SCCN_HELP[17]			= "|cff68ccef".."/chatmod highlight".."|cffffffff".." Custom filter dialogue for highlighting Words in Chat.";	
	SCCN_HELP[18]			= "|cff68ccef".."/chatmod AutoBGMap".."|cffffffff".." BGMinimap Autopupup.";	
	SCCN_HELP[19] = "|cff68ccef".."/chatmod shortchanname ".."|cffffffff".." Displays Short channelname.";	
	SCCN_HELP[20] = "|cff68ccef".."/chatmod autogossipskip ".."|cffffffff".." Skip the gossip Window automaticaly. |cffa0a0a0(Press <CTRL> to deactivate skip)";
	SCCN_HELP[21] = "|cff68ccef".."/chatmod autodismount ".."|cffffffff".." Auto Dismounts at taxi NPCs";	
	SCCN_HELP[22]					= "|cff68ccef".."/chatmod inchathighlight ".."|cffffffff".."Highlight Known Nicknames";
	SCCN_HELP[23]					= "|cff68ccef".."/chatmod sticky ".."|cffffffff".."Sticky Chat behavior";	
	SCCN_HELP[24]					= "|cff68ccef".."/chatmod initchan <channelname>".."|cffffffff".."Set the specified <channelname> to default chatfram on startup.";		
	SCCN_HELP[25]					= "|cff68ccef".."/chatmod nofade".."|cffffffff".."Disable fading of Chattext";
	SCCN_HELP[26]					= "|cff68ccef".."/chatmod chaticon".."|cffffffff".."Toggle Chatcroll indicator Icon";
	SCCN_HELP[27]					= "|cff68ccef".."/chatmod showlevel".."|cffffffff".."Toggle Leveldisplay in Name";
	SCCN_HELP[28]					= "|cff68ccef".."/chatmod chatcolorname".."|cffffffff".."Toggle Namecoloring in Chattext";
	SCCN_HELP[99]			= "|cff68ccef".."/chatmod status".."|cffffffff".." 顯示目前設置。";
	SCCN_TS_HELP  			= "|cff68ccef".."/chatmod timestamp |cffFF0000FORMAT|cffffffff\n".."FORMAT:\n$h = 小時 (0-24) \n$t = 小時 (0-12) \n$m = 分鐘 \n$s = 秒 \n$p = 午前/午後 (am / pm)\n".."|cff909090Example: /chatmod timestamp [$t:$m:$s $p]";
	SCCN_CMDSTATUS[1]		= "隱藏頻道名稱:";
	SCCN_CMDSTATUS[2]		= "以職業顏色顯示名字:";
	SCCN_CMDSTATUS[3]		= "使用滑鼠滾輪捲動聊天視窗:";
	SCCN_CMDSTATUS[4]		= "對話輸入欄置頂:";
	SCCN_CMDSTATUS[5]		= "加入訊息時間:";
	SCCN_CMDSTATUS[6]		= "小地圖上的隊伍成員以職業顏色標記:";
	SCCN_CMDSTATUS[7]		= "網頁連結可點選複製:";
	SCCN_CMDSTATUS[8]		= "明顯標示自己的名字:";
	SCCN_CMDSTATUS[9]		= "對話欄中的邀請訊息可被點選:";
	SCCN_CMDSTATUS[10]		= "對話編輯不需按住<ALT>:";
	SCCN_CMDSTATUS[11]		= "自定密語訊息:";
	SCCN_CMDSTATUS[12]		= "額外顯示包含自己名字的訊息:";
	SCCN_CMDSTATUS[13]		= "Hide Chat Buttons:";
	SCCN_CMDSTATUS[14] 		= "BG Minimap Autopopup:";
	SCCN_CMDSTATUS[15] 		= "Custom Highlight:";
	SCCN_CMDSTATUS[16] 		= "Short Channelname:";
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
	SCCN_CUSTOM_INV[0]		= "++";
	-- Whispers customized
	SCCN_CUSTOM_CHT_FROM		= "%s說：";
	SCCN_CUSTOM_CHT_TO		= "密%s：";	
	-- hide this channels aditional, feel free to add your own
	SCCN_STRIPCHAN[1]		= "公會";
	SCCN_STRIPCHAN[2]		= "團隊";
	SCCN_STRIPCHAN[3]		= "小隊";	
-- ItemLink Channels
    SCCN_ILINK[1]                   = "General -"
    SCCN_ILINK[2]                   = "Trade -"
    SCCN_ILINK[3]                   = "LookingForGroup -"
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
	SCCN_NewVer                     = "There is a new ChatMOD Version available. Check www.solariz.de for Update!";
end;
