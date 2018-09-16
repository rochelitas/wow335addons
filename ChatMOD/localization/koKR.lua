--==============
--=   KOREAN   =
--==============
-- 28.05.2007
if ( GetLocale() == "koKR" ) then
	SCCN_GUI_HIGHLIGHT1				    = "여기에 입력하는 단어를 강조할 수 있습니다. 한줄에 한단어씩만 가능합니다.";
	SCCN_LOCAL_CLASS["WARLOCK"] 		= "흑마법사";
	SCCN_LOCAL_CLASS["HUNTER"] 			= "사냥꾼";
	SCCN_LOCAL_CLASS["PRIEST"] 			= "사제";
	SCCN_LOCAL_CLASS["PALADIN"] 		= "성기사";
	SCCN_LOCAL_CLASS["MAGE"] 			= "마법사";
	SCCN_LOCAL_CLASS["ROGUE"] 			= "도적";
	SCCN_LOCAL_CLASS["DRUID"] 			= "드루이드";
	SCCN_LOCAL_CLASS["SHAMAN"] 			= "주술사";
	SCCN_LOCAL_CLASS["WARRIOR"] 		= "전사";
	SCCN_LOCAL_CLASS["DEATHKNIGHT"] = "Todesritterin"; -- Female Classname in English ?
	-- What the heck are the Engliosh female names for the classes ? How do you say to "Hexenmeisterin" ?
    SCCN_LOCAL_CLASS["WARLOCKF"] 	= "흑마법사"; -- Female Classname in English ?
    SCCN_LOCAL_CLASS["HUNTERF"]     = "사냥꾼"; -- Female Classname in English ?
    SCCN_LOCAL_CLASS["PRIESTF"]     = "사제"; -- Female Classname in English ?
    SCCN_LOCAL_CLASS["MAGEF"]       = "마법사"; -- Female Classname in English ?
    SCCN_LOCAL_CLASS["ROGUEF"]      = "도적"; -- Female Classname in English ?
    SCCN_LOCAL_CLASS["DRUIDF"]      = "드루이드"; -- Female Classname in English ?
    SCCN_LOCAL_CLASS["SHAMANF"]     = "주술사"; -- Female Classname in English ?
    SCCN_LOCAL_CLASS["WARRIORF"]    = "전사"; -- Female Classname in English ?
    SCCN_LOCAL_CLASS["DEATHKNIGHTF"] = "Todesritterin"; -- Female Classname in English ?
    SCCN_LOCAL_CLASS["PALADINF"]    = "Paladin";
    
	-- Zones
	SCCN_LOCAL_ZONE["alterac"]			= "알터랙 계곡";
	SCCN_LOCAL_ZONE["warsong"]			= "전쟁노래 협곡";
	SCCN_LOCAL_ZONE["arathi"]			= "아라시 분지";
	SCCN_CONFAB					= "|cffff0000The Confab Addon was found. SCCN Editbox functions are disabled due to compatibility!";
	SCCN_HELP[1]					= "ChatMOD - 명령어 도움말:";
	SCCN_HELP[2]					= "|cff68ccef".."/chatmod hidechanname ".."|cffffffff".." 채널이름 숨기기";
	SCCN_HELP[3]					= "|cff68ccef".."/chatmod colornicks ".."|cffffffff".." 캐릭터의 직업에 따라 캐릭터 이름의 색상 표시";
	SCCN_HELP[4]					= "|cff68ccef".."/chatmod purge".."|cffffffff".."자료 초기화 실행 |cffa0a0a0(애드온을 재시작 할때마다 자동으로 실행)";
	SCCN_HELP[5]					= "|cff68ccef".."/chatmod killdb".."|cffffffff".." 저장된 자료 모두 삭제 (되돌리기 불가능)";
	SCCN_HELP[6]					= "|cff68ccef".."/chatmod mousescroll".."|cffffffff".." 마우스 휠을 이용하여 채팅창 스크롤.\n|cffa0a0a0(SHIFT+휠 = 빠른 스크롤, STRG+휠버튼 = 채팅창 맨위 또는 맨아래로 이동)";
	SCCN_HELP[7]					= "|cff68ccef".."/chatmod topeditbox".."|cffffffff".." 채팅 입력창을 채팅창 위로 이동";
	SCCN_HELP[8]					= "|cff68ccef".."/chatmod timestamp".."|cffffffff".." 채팅창에 시간 표시. (기본 형식은 [HH:MM])";
	SCCN_HELP[9]					= "|cff68ccef".."/chatmod colormap".."|cffffffff".." 월드맵에 공대원의 위치를 직업에 따라 색상으로 표시";
	SCCN_HELP[10]					= "|cff68ccef".."/chatmod hyperlink".."|cffffffff".." 웹페이지를 복사할 수 있는 창 띄우기";
	SCCN_HELP[11]					= "|cff68ccef".."/chatmod selfhighlight".."|cffffffff".." 자신의 캐릭터 이름을 강조.\n(형식은 >캐릭터이름<)";
	SCCN_HELP[12]					= "|cff68ccef".."/chatmod clickinvite".."|cffffffff".." 특정단어를 클릭하면 자동으로 파티에 초대.\n(초대 가능 단어: 초대, 손, ㅅㅅ, ㅅ)";
	SCCN_HELP[13] 					= "|cff68ccef".."/chatmod editboxkeys".."|cffffffff".." ALT키를 누르지 않고 채팅 입력창에 기록한 내용 수정하기";
	SCCN_HELP[14] 					= "|cff68ccef".."/chatmod chatstring".."|cffffffff".." 귓속말 짧게 표시 사용";
	SCCN_HELP[15] 					= "|cff68ccef".."/chatmod selfhighlightmsg".."|cffffffff".." 자신의 캐릭터 이름을 화면 가운데 표시";	
	SCCN_HELP[16]					= "|cff68ccef".."/chatmod hidechatbuttons".."|cffffffff".." 채팅 버튼 숨기기";	
	SCCN_HELP[17]					= "|cff68ccef".."/chatmod highlight".."|cffffffff".." 사용자 채팅 강조 구문 사용";	
	SCCN_HELP[18]					= "|cff68ccef".."/chatmod AutoBGMap".."|cffffffff".." 전장 진입시 자동으로 전장미니맵 표시";	
	SCCN_HELP[19]					= "|cff68ccef".."/chatmod shortchanname ".."|cffffffff".." 짧은 채널이름 사용";	
	SCCN_HELP[20]					= "|cff68ccef".."/chatmod autogossipskip ".."|cffffffff".." NPC와의 대화 자동으로 넘기기.\n|cffa0a0a0(CTRL키를 누르면 활성화 취소)";
	SCCN_HELP[21]					= "|cff68ccef".."/chatmod autodismount ".."|cffffffff".." 조련사 클릭하면 자동으로 탈 것에서 내리기";	
	SCCN_HELP[22]					= "|cff68ccef".."/chatmod inchathighlight ".."|cffffffff".."알려진 닉네임 강조하기";	
	SCCN_HELP[23]					= "|cff68ccef".."/chatmod sticky ".."|cffffffff".."채팅을 입력했던 채널 고정하기";
	SCCN_HELP[26]					= "|cff68ccef".."/chatmod chaticon".."|cffffffff".."Toggle Chatcroll indicator Icon";
	SCCN_HELP[27]					= "|cff68ccef".."/chatmod showlevel".."|cffffffff".."Toggle Leveldisplay in Name";
	SCCN_HELP[28]					= "|cff68ccef".."/chatmod chatcolorname".."|cffffffff".."Toggle Namecoloring in Chattext";
	SCCN_HELP[99]					= "|cff68ccef".."/chatmod status".."|cffffffff".." 현재 설정상태 보기";	
	SCCN_TS_HELP  					= "|cff68ccef".."/chatmod timestamp |cffFF0000??|cffffffff\n".."??:\n$h = 24??? (0-24) \n$t = 12??? (0-12) \n$m = ? \n$s = ? \n$p = ??/?? \n".."|cff909090??: /chatmod timestamp [$t:$m:$s $p]";
	SCCN_CMDSTATUS[1]				= "채널이름 숨기기 설정:";
	SCCN_CMDSTATUS[2]				= "캐릭터이름 색상 설정:";
	SCCN_CMDSTATUS[3]				= "마우스로 채팅창 스크롤 설정:";
	SCCN_CMDSTATUS[4]				= "채팅 입력창 위로 올리기 설정:";
	SCCN_CMDSTATUS[5]				= "채팅창 시간표시 설정:";
	SCCN_CMDSTATUS[6]				= "공대원 색상 표시 설정:";
	SCCN_CMDSTATUS[7]				= "웹페이지 복사하기 설정:";
	SCCN_CMDSTATUS[8]				= "캐릭터이름 강조 설정:";
	SCCN_CMDSTATUS[9]				= "클릭으로 초대 설정:";
	SCCN_CMDSTATUS[10]  				= "ALT키 사용 안함 설정:";
	SCCN_CMDSTATUS[11] 				= "귓속말 짧게 표시 설정:";
	SCCN_CMDSTATUS[12]				= "캐릭터이름 화면표시 설정:";
	SCCN_CMDSTATUS[13]				= "채팅창 버튼 숨기기 설정:";
	SCCN_CMDSTATUS[14] 				= "전장 미니맵 자동표시 설정:";
	SCCN_CMDSTATUS[15] 				= "사용자지정 강조 설정:";
	SCCN_CMDSTATUS[16] 				= "짧은 채널이름 설정:";
	SCCN_CMDSTATUS[17]				= "가쉽거리 숨김 설정:";
	SCCN_CMDSTATUS[18]				= "자동 탈것 내리기 설정:";
	SCCN_CMDSTATUS[19]				= "채팅창에 강조하기 설정:";	
	SCCN_CMDSTATUS[20]				= "채팅 채널 고정 설정:";
	SCCN_CMDSTATUS[21]				= "Don't Fade chattext automaticaly:";
	SCCN_CMDSTATUS[22]				= "Chat Scoll Icon:";
	SCCN_CMDSTATUS[23]				= "Leveldisplay in Name:";
	SCCN_CMDSTATUS[24]      = "Color names in Chattext:";
	SCCN_CMDSTATUS[25]              = "Chat Icon Markers:";
	SCCN_CMDSTATUS[26]				= "only Highlight full words:";
	-- cursom invite word in the local language
	SCCN_CUSTOM_INV[0] 				= "ㅅㅅ"; --   :D
	SCCN_CUSTOM_INV[1] 				= "ㅅ"; --   :D
	-- Whispers customized
	SCCN_CUSTOM_CHT_FROM				= "%s님의 귓속말:";
	SCCN_CUSTOM_CHT_TO				= "%s님에게 귓속말:";
	-- hide this channels aditional, feel free to add your own
	SCCN_STRIPCHAN[1]				= "길드";
	SCCN_STRIPCHAN[2]				= "공격대";
	SCCN_STRIPCHAN[3]				= "파티";	
	SCCN_STRIPCHAN[4]				= "파티찾기";
    -- ItemLink Channels
    SCCN_ILINK[1]                   = "General -"
    SCCN_ILINK[2]                   = "Trade -"
    SCCN_ILINK[3]                   = "LookingForGroup -"
    SCCN_ILINK[4]                   = "LocalDefense -"
    SCCN_ILINK[5]                   = "WorldDefense"	
	-- some general channel name translation for the GUI
	SCCN_TRANSLATE[1]				= "길드";
	SCCN_TRANSLATE[2]				= "길드관리자";
	SCCN_TRANSLATE[3]				= "파티";
	SCCN_TRANSLATE[4]				= "공격대";
	SCCN_TRANSLATE[5]				= "귓속말";	
	SCCN_Highlighter				= "ChatMOD ??";
	SCCN_Config					= "ChatMOD ??";
	SCCN_Changelog					= "ChatMOD ????";
	SCCN_NewVer                     = "There is a new ChatMOD Version available. Check www.solariz.de for Update!";
end;
