-- Purge entrys not seen since X weeks
   SCCN_PURGEWEEKS = 4;
   SCCN_DEBUG = false;

-------------------------------------------------
-- DEFAULT VARIABLES
-------------------------------------------------
	if( not SCCN_storage ) then SCCN_storage = { Skyhawk = { c=7, t=123} }; end;
	if( not SCCN_mousescroll ) then SCCN_mousescroll   = 1; end;
	if( not SCCN_hidechanname ) then SCCN_hidechanname = 0; end;
	if( not SCCN_shortchanname ) then SCCN_shortchanname = 0; end;
	if( not SCCN_colornicks ) then SCCN_colornicks   = 1; end;
	if( not SCCN_topeditbox ) then SCCN_topeditbox   = 0; end;
	if( not SCCN_timestamp ) then SCCN_timestamp     = 1; end;
	if( not SCCN_hyperlinker )  then SCCN_hyperlinker = 1; end;
	if( not SCCN_selfhighlight )  then SCCN_selfhighlight = 1; end;
	if( not SCCN_clickinvite )  then SCCN_clickinvite = 1; end;
	if( not SCCN_editboxkeys )  then SCCN_editboxkeys = 1; end;
	if( not SCCN_chatstring )  then SCCN_chatstring = 1; end;
	if( not SCCN_selfhighlightmsg )  then SCCN_selfhighlightmsg = 1; end;
	if( not SCCN_ts_format ) then SCCN_ts_format = "#33CCFF[$h:$m]" end;
	if( not SCCN_HideChatButtons )  then SCCN_HideChatButtons = 0; end;
	if( not SCCN_Highlight_Text ) then SCCN_Highlight_Text = {}; end;
	if( not SCCN_Highlight ) then SCCN_Highlight = 0; end;
	if( not SCCN_AutoGossipSkip ) then SCCN_AutoGossipSkip = 0; end;
	if( not SCCN_Chan_Replace ) then SCCN_Chan_Replace = {}; end;
	if( not SCCN_Chan_ReplaceWith ) then SCCN_Chan_ReplaceWith = {}; end;
	if( not SCCN_chatsound ) then SCCN_chatsound = {}; end;
	if( not SCCN_InChatHighlight ) then SCCN_InChatHighlight = 1; end;
	if( not SCCN_AllSticky ) then SCCN_AllSticky = 1; end;
	if( not SCCN_NOFADE ) then SCCN_NOFADE = 1; end;
	if( not SCCNScrollDown_X ) then SCCNScrollDown_X = 0; end;
	if( not SCCNScrollDown_Y ) then SCCNScrollDown_Y = 0; end;
	if( not SCCN_disablewhocheck ) then SCCN_disablewhocheck = 0; end;
	if( not SCCN_chatscrollicon ) then SCCN_chatscrollicon = 1; end;
	if( not SCCN_displayusage ) then SCCN_displayusage = 0; end;
	if( not SCCN_SCROLLBACK_BUFFER) then SCCN_SCROLLBACK_BUFFER = 128; end;
	if( not SCCN_COM_GUILD) then SCCN_COM_GUILD = 1; end;
	if( not SCCN_SHOWLEVEL) then SCCN_SHOWLEVEL = 1; end;
	if( not SCCN_SHOWICON) then SCCN_SHOWICON = 0; end;
	if( not SCCN_Highlight_onlyfull) then SCCN_Highlight_onlyfull = 1; end; -- new in rev 132
	SCCN_CHATLINK = nil; -- removed function in rev 132 should be unset
	SCCN_AutoDismount = nil; -- removed in rev 132
	
	

-------------------------------------------------
-- SCCN Ignore this name in highlight
-- This is a kind of blacklist
-- !! ONLY ACCEPTS LOWER CASE LETTERS !!
-------------------------------------------------
	SCCN_IGNORE_HNAMES = {
	ist = 1, with = 1, duel = 1, gm = 1, fight = 1, unkown = 1, stimme = 1,	won = 1,
	core = 1, done = 1, quest = 1, general = 1, defense = 1, party = 1, raid = 1,
    battleground = 1, battle = 1, gruppe = 1, gilde = 1, online = 1, offline = 1,
    alliance = 1, horde = 1, alterac = 1, warsong = 1, taken = 1, attack = 1, someone = 1,
    wrong = 1, loot = 1, invite = 1, group = 1, raid = 1, horde = 1, alliance = 1,
	away = 1, arathi = 1, alterac = 1, basin = 1
	}


-------------------------------------------------
-- MISC SETTINGS FOR STARTUP
-------------------------------------------------
	ChatMOD_Loaded = true;
	SCCN_OutsideBG = 1;
	SCCNOnScreenMessage = "";
	ChatFrame_MessageEventHandler_Org = nil;
    ORG_AddMessage = nil;
	SCCN_EntrysConverted = 0;
	SCCN_INVITEFOUND = nil;
	SCCN_JOINEDDEF = nil;
	SCCN_LAST_PLAYER = "";
	SCCN_LAST_VAR = "";
	ChatMOD_COM_ID = "chatmod";
	ChatMOD_COM_INIT = nil;

-------------------------------------------------
-- CHATMOD_COLOR CONFIGURATION
-- because RAID_CLASS_COLORS is not working always
-- as intended (dont figured out why exactly) I using this.
-------------------------------------------------

	-- Some Colors
	CHATMOD_COLOR = {
		RED     = "|cffff0000",
		GREEN   = "|cff10ff10",
		BLUE    = "|cff0000ff",
		MAGENTA = "|cffff00ff",
		YELLOW  = "|cffffff00",
		ORANGE  = "|cffff9c00",
		CYAN    = "|cff00ffff",
		WHITE   = "|cffffffff",
		SILVER  = "|ca0a0a0a0"
	}
--EOF
