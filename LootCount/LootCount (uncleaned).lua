--[[****************************************************************
	LootCount v1.10

	Author: Evil Duck
	****************************************************************
	Thanks to belleboom for the party-idea.
	Thanks to Faladrin for the good fieldwork to improve LootCount
	with the goal-counter.

	Description:
		Type /lc or /lootcount for brief help

	****************************************************************]]

-- 1.10 Added option to use items, removed double leftclick for toggle local-mode, added right-click drop-down menu
-- 1.05 Added option for hiding the center frame, another bug-fix for patch-days
-- 1.04 Updated for WoW 2.4.1, added drop-handler for plug-in API, fixed bug in plug-in right-click,
--      added scaling for text, removed "L"-button on non-items, added display of local items
-- 1.03 Added local count for single watches, changed plug-in API for better stability, added support for plug-in
--      data-save in LootCount's database, fixed bug in transmission within group/raid, added toggle of tooltip-count
-- 1.02 Added plug-in handler for mouse-clicks, changed "Clear button" from single left-click to double right-click,
--      bug-fix for goal-save, changed scheme for count update (should be lag-free now)
-- 1.00 Reworked for plug-ins
-- 0.98 A few bugfixes, added tooltip-count, added DPS-meter (beta), added local-setting for each button
-- 0.90 Added "Include alts", added moneydisplay, a few other minor tweaks and a bugfix
-- 0.77 Kill count-down takes rested into account, added item pre-load
-- 0.76 Bugfix when setting goal at empty slots, added rep countdown, added kill countdown,
--      fixed bug in slot-clearing that could set previsouly viewed chat-link, frame colours for locked/unlocked,
--      fixed bug in bank update, added option to not participate in group-loot
-- 0.73 Added option to add item that is not in your bags
-- 0.72 Added option to include bank contents
-- 0.71 Fixed bug in saving, fixed bug in old to new conversion
-- 0.70 New layout, lower impact on communication channel, fixed UI glitches
-- 0.64 Added sizing, locking, and a menu
-- 0.60 Changed Frame, removed double numbers, added goal-counter
-- 0.50 Added dynamic slots, changed slot size, slots persist per character between sessions
-- 0.10 Added support for party/raid counting
-- 0.02 Fixed bug where the WoW-type drag-n-drop didn't work (drag-release-click)
-- 0.01 First version


BINDING_HEADER_LOOTCOUNT = "LootCount bindings";
BINDING_NAME_TOGGLELOOTCOUNT = "Toggle LootCount";
LOOTCOUNT_VERSIONTEXT = "LootCount v1.10";
SLASH_LOOTCOUNT1 = "/lootcount";
SLASH_LOOTCOUNT2 = "/lc";
local LOOTCOUNT_DATAVERSION = 2;
local LOOTCOUNT_PREFIX="LoCo";
local LOOTCOUNTBUTTON="LootCountItem";
local LOOTCOUNTSPACE=3;
local LOOTCOUNTSIZE=25;
local LC_FONTHEIGHT=14;
local LOOTCOUNTOFFSET=16;
local LOOTCOUNT_SPECIAL="SPECIAL";
local LOOTCOUNT_SCANTIME=1.0;
local LOOTCOUNT_DOUBLECLICK=0.4;
local LCWAITERTIME=10;
local LCUPDATEDELAY=0.005;

local LOOTCOUNT_H=0;
local LOOTCOUNT_V=1;
local LOOTCOUNT_N=2;

local LootCount_DB = {};
      LootCount_Populated = {};
      LootCount_Global = {};
      LootCount_Info = {};
      LootCount_InCombat=nil;
      LootCount_Loaded=nil;
local LootCount_InitValue=0;
local LootCount_Debug=nil;
local LootCount_OnHyperlinkShow=nil;
local LootCount_Grabber=nil;
local LootCount_ShowGrabber=nil;
local LootCount_InCombatDone=-1;
local LootCount_UpdateTime=-10;				-- Start off by some silence
local LootCount_LoadedStuff={};
local LootCount_LastLoaded=nil;
local LootCount_LastLoadCount=0;
local LootCount_UpdateIndex=1;
local LootCount_CacheRetries=0;
local LootCount_TextureMissing=nil;
local LootCount_ReadAgain=nil;
local LootCount_GTTCountButton=nil;
local LootCount_GTTOwnTooltip=nil;
local LootCount_GIRCountButton=nil;
local LootCount_GIROwnTooltip=nil;
local LootCount_LastGTTItem=0;
local LootCount_LastGIRItem=0;
local LootCount_Clicker = {
	Time=0;
	LeftRight=0;
	Button=nil;
	Count=0;
};
local LootCount_LastMenuButton=nil;
local LootCount_LocalBackdrop = {
	bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
	edgeFile = "", tile = true, tileSize = 12, edgeSize = 12, 
	insets = { left = -2, right = -2, top = -2, bottom = -2 }
};
local LootCount_BDr=1;
local LootCount_BDg=0;
local LootCount_BDb=0;
local LootCount_BDa=1;
local LootCount_BankOpen=nil;
local LootCount_PluginTimer=0;
local LootCount_PluginLoader=10;
local LootCount_Waiter=LCWAITERTIME;
local LootCount_BGUpdate = {
	last=nil,
	other=nil,
	fastbuttons=nil,
	xdir=0,
	xpos=0,
	ydir=0,
	ypos=0
};
local LootCount_FrameTimer=-1;
local LootCount_FrameFaded=nil;
local LOOTCOUNT_FRAMETIME=4;
local LOOTCOUNT_FADETIME=1;
local LCUP_USE="^Use: .+$";
local LCUP_RCLICK="^.Right Click to Open.$";
LootCount_UsageID={
	[5523]=true,
};




--[[
info-table:

	-- Mandatory information
	Name="Your plugin name"
	Texture=Path to texture for your plugin's icon
	Update=The function that LootCount will call when update is needed

	-- Optional information
	MenuText="Text for selecting your plugin from menu in LootCount"
	Tooltip=The function LootCount will call for your plugin to display a tooltip on mouse-over
	Clicker=The function LootCount will call when your plug-in's icon has been clicked by the user
	ColorTop=Color-table for the upper number
	ColorBottom=Color-table for the bottom number
	Drop=The function LootCount will call when an item is dropped on your plug-in's icon
	Modifier=The function your plugin will use to modify the original count

Color-table:
	r=Red
	g=Green
	b=Blue
]]


function LootCount_Plugin_Register(info)
	if (not LootCount_Plugin) then LootCount_Plugin={}; end
	LootCount_Plugin[info.Name]={};
	LootCount_Plugin[info.Name].sTexture=info.Texture;
	if (not info.ColorTop) then info.ColorTop={ r=.7, g=.7, b=.7 }; end
	LootCount_Plugin[info.Name].cColorTop=info.ColorTop;
	if (not info.ColorBottom) then info.ColorBottom={ r=1, g=1, b=1 }; end
	LootCount_Plugin[info.Name].cColorBottom=info.ColorBottom;
	LootCount_Plugin[info.Name].fUpdateIcon=info.Update;
	LootCount_Plugin[info.Name].fTooltip=info.Tooltip;
	if (not info.MenuText) then info.MenuText=info.Name; end
	LootCount_Plugin[info.Name].MenuText=info.MenuText;
	LootCount_Plugin[info.Name].Modifier=info.Modifier;
	LootCount_Plugin[info.Name].fClicker=info.Clicker;
	LootCount_Plugin[info.Name].fDrop=info.Drop;

--	LootCount_Chat(info.Name.." ready for use");
	LootCount_Waiter=LCWAITERTIME/2;
end

function LootCount_Plugin_Update(plugin,button,lower,upper)
	if (not plugin or not LootCount_Plugin[plugin]) then return; end
	local info=LootCount_Plugin[plugin];
	if (not lower) then lower=""; end
	if (not upper) then upper=""; end
	if (button.itemID==LOOTCOUNT_SPECIAL and button.Special==plugin) then
		LootCount_SetNumber(button,"MyCount",lower,info.cColorBottom.r,info.cColorBottom.g,info.cColorBottom.b);
		LootCount_SetNumber(button,"OurStock",upper,info.cColorTop.r,info.cColorTop.g,info.cColorTop.b);
	end
end

function LootCount_Plugin_ForceUpdate(plugin)
	LootCount_TraverseIcons(plugin);
end


function LootCount_Plugin_Save(plugin)
	LootCount_TraverseIcons(plugin,LootCount_SaveButton);
end

function LootCount_StartUser(button)
	if (not button.User) then button.User={}; end
	return button.User;
end

function LootCount_TraverseIcons(method,extra)
	local now=time();
	local info;
	local plugin,func;

	if (type(method)=="string") then
		plugin=method;
		if (type(extra)=="function") then func=extra; end
	elseif (type(method)=="function") then func=method;
	end

	if (plugin) then
		if (not LootCount_Plugin[plugin]) then return; end
		info=LootCount_Plugin[plugin];
	end
	
	-- Center, shift from right, aim up
	local xdir=1;
	local xpos=0;
	local ydir=1;
	local ypos=0;

	while (xdir~=0 or ydir~=0) do
		while (LootCount_GetButton(xpos,ypos,true)) do										-- Do not create if non-existent
			local button=LootCount_GetButton(xpos,ypos,true);
			if (not button.LastUpdated or button.LastUpdated~=now) then
				button.LastUpdated=now;
				if (plugin) then
					if (button.itemID==LOOTCOUNT_SPECIAL and button.Special==plugin) then
						if (func) then
							func(button);
						else
							info.fUpdateIcon(button);
						end
					end
				elseif (func) then
					func(button);
				end
			end
			xpos=xpos+xdir;
		end
		-- Check end of direction
			if (xpos==0 and xdir== 1 and ydir== 1) then xpos=-1; xdir=-1; ypos= 0; ydir= 1;	-- One left to center, shift from left, aim up
		elseif (xpos==0 and xdir==-1 and ydir== 1) then xpos= 0; xdir= 1; ypos=-1; ydir=-1;	-- One below center, shift from right, aim down
		elseif (xpos==0 and xdir== 1 and ydir==-1) then xpos= 0; xdir=-1; ypos=-1; ydir=-1;	-- One below center, shift from left, aim down
		elseif (xpos==0 and xdir==-1 and ydir==-1) then xdir=0; ydir=0; break;				-- Done
		else xpos=0; ypos=ypos+ydir; end													-- Continue
	end

	if (plugin and not func) then info.fUpdateIcon(nil); end		-- Signify "done"
end


LootCountAPI = {
	Register=LootCount_Plugin_Register;			-- info-table
	SetData=LootCount_Plugin_Update;			-- plugin,button,lower,upper
	Force=LootCount_Plugin_ForceUpdate;			-- plugin
	Save=LootCount_Plugin_Save;					-- plugin
	User=LootCount_StartUser;					-- button
	GetIcons=LootCount_TraverseIcons			-- plugin,function
};




-- Set up for handling
function LootCount_OnLoad()
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("BAG_UPDATE");
	this:RegisterEvent("BANKFRAME_OPENED");
	this:RegisterEvent("BANKFRAME_CLOSED");
	this:RegisterEvent("CHAT_MSG_ADDON");
	this:RegisterEvent("PARTY_MEMBERS_CHANGED");
	this:RegisterEvent("PLAYER_REGEN_DISABLED");
	this:RegisterEvent("PLAYER_REGEN_ENABLED");
	this:RegisterEvent("PLAYER_CONTROL_GAINED");

	SlashCmdList["LOOTCOUNT"]=function(msg) LootCount_Slasher(msg) end;

	if (not LootCount_InitValue) then LootCount_InitValue=0; end
	StaticPopupDialogs["LOOT_COUNT_GOAL"] = {
		text = "Enter goal (0=no goal)",
		button1 = TEXT(ACCEPT),
		button2 = TEXT(CANCEL),
		OnShow = function() if (not LootCount_InitValue) then LootCount_InitValue=0; end getglobal(this:GetName().."EditBox"):SetText(LootCount_InitValue); end,
		OnAccept = function(arg1)
			arg1.goal=tonumber(getglobal(this:GetParent():GetName().."EditBox"):GetText());
			if (not arg1.goal) then arg1.goal=0; end
			LootCount_SaveButton(arg1);
			LootCount_SetItems(arg1,false)
		end,
		hasEditBox = 1,
		timeout = 0,
		whileDead = 1,
		hideOnEscape = 1
	}

	LootCount_GetButton(0,0);
	this:RegisterForDrag("LeftButton");
	LootCount_Info.Server=GetRealmName();
--	LootCount_Chat("Loaded");
end


function LootCount_ClearTable(t)
	for k in pairs(t) do t[k]=nil; end;
end


-- An event has been received
function LootCount_OnEvent(event)
	if (event=="PLAYER_REGEN_ENABLED") then LootCount_InCombatDone=2; return; end
	if (event=="PLAYER_REGEN_DISABLED") then LootCount_InCombat=true; return; end			-- Yepp. Fighting something

	if (event=="BANKFRAME_OPENED") then LootCount_BankOpen=true;
	elseif (event=="BANKFRAME_CLOSED") then LootCount_BankOpen=nil; return; end

	if (event=="BAG_UPDATE" or event=="BANKFRAME_OPENED" or event=="PLAYER_CONTROL_GAINED") then
		LootCount_ReadBank();
		LootCount_UpdateItems();
		return; 
	end

	if (event=="CHAT_MSG_ADDON") then if (arg1==LOOTCOUNT_PREFIX and arg4~=UnitName("player")) then LootCount_IncomingItem(arg4,arg2); end return; end
	if (event=="PARTY_MEMBERS_CHANGED") then LootCount_DB={}; LootCount_UpdateItems(true); LootCount_SendMyStuff(); return; end

	if (event=="VARIABLES_LOADED") then
		LootCount_GetButton(0,0,false,true);
		if (not LootCount_Global.DataVersion or LootCount_Global.DataVersion<LOOTCOUNT_DATAVERSION) then
			LootCount_ClearTable(LootCount_Global); --LootCount_Global={};
			LootCount_Global.DataVersion=LOOTCOUNT_DATAVERSION;
			LootCount_Chat("Your bank- and alt-contents is incompatible with this version and has been cleared. Please visit your banks and alts to update it.");
		end
		if (not LootCount_Populated.DataVersion or LootCount_Populated.DataVersion<LOOTCOUNT_DATAVERSION) then
			LootCount_ClearTable(LootCount_Populated); --LootCount_Populated={};
			LootCount_Populated.DataVersion=LOOTCOUNT_DATAVERSION;
			LootCount_Chat("Your layout is incompatible with this version and has been cleared. Please visit your banks and alts to update it.");
		end
		if ((LootCount_Populated.Visible and not LootCount_Frame0:IsVisible()) or (not LootCount_Populated.Visible and LootCount_Frame0:IsVisible())) then
			LootCount_ToggleMainFrame();
		end
		if (not LootCount_Populated.BankMax) then LootCount_Populated.BankMax=0; LootCount_Populated.BankUse=0; end
		if (not LootCount_Populated.BagMax) then LootCount_Populated.BagMax=0; LootCount_Populated.BagUse=0; end
		if (not LootCount_Populated.Orientation) then LootCount_Populated.Orientation=LOOTCOUNT_H; end
		if (not LootCount_Populated.Size) then LootCount_Populated.Size=25; end
		if (LootCount_Populated.FontSize) then LC_FONTHEIGHT=LootCount_Populated.FontSize; end
		LootCount_SetSize(LootCount_Populated.Size);
		LootCount_Lock(LootCount_Populated.Locked);
		LootCount_OnHyperlinkShow=ChatFrame_OnHyperlinkShow;
		ChatFrame_OnHyperlinkShow=LootCount_GrabChatLink;
	end
end


function LootCount_LoadItems(lastattempt)
	LootCount_TextureMissing=nil;
	local xdir=1;		-- Center, shift from right, aim up
	local xpos=0;
	local ydir=1;
	local ypos=0;

	LootCount_UnknownPlugin=false;
	LootCount_LastLoadCount=0;
	while (xdir~=0 or ydir~=0) do
		while (LootCount_LoadItem(xpos,ypos)) do
			if (LootCount_LastLoaded and LootCount_LastLoaded~=0) then
				LootCount_LastLoadCount=LootCount_LastLoadCount+1;
				LootCount_LoadedStuff[LootCount_LastLoadCount]=LootCount_LastLoaded;
			end
			xpos=xpos+xdir;
		end
		-- Check end of direction
			if (xpos==0 and xdir== 1 and ydir== 1) then xpos=-1; xdir=-1; ypos= 0; ydir= 1;	-- One left to center, shift from left, aim up
		elseif (xpos==0 and xdir==-1 and ydir== 1) then xpos= 0; xdir= 1; ypos=-1; ydir=-1;	-- One below center, shift from right, aim down
		elseif (xpos==0 and xdir== 1 and ydir==-1) then xpos= 0; xdir=-1; ypos=-1; ydir=-1;	-- One below center, shift from left, aim down
		elseif (xpos==0 and xdir==-1 and ydir==-1) then xdir=0; ydir=0; break;				-- Done
		else xpos=0; ypos=ypos+ydir; end													-- Continue
	end

	if (LootCount_TextureMissing and lastattempt) then
		LootCount_Chat("Unable to get one or more item icons from the server.");
		LootCount_Chat("Please try a manual update with \"/lc update\" in a few seconds when your game has finished loading.");
	else
		LootCount_Loaded=true;
		LootCount_ShowFrame(true);
	end
end


function LootCount_GrabChatLink(link,text,button)
	LootCount_OnHyperlinkShow(link,text,button);
	local thislink=LootCount_GetID(link);
	if (not thislink) then LootCount_ShowGrabber=nil; return; end
	LootCount_ShowGrabber=true;
	LootCount_Grabber=link;
	if (LootCount_Debug) then LootCount_Chat("DEBUG: "..link.." grabbed"); end
end


function LootCount_BaseHandler()
	if (not LootCount_Info.Server) then return nil; end
	if (not LootCount_Global[LootCount_Info.Server]) then LootCount_Global[LootCount_Info.Server]={}; end
	englishFaction=UnitFactionGroup("player");
	if (englishFaction~="Alliance" and englishFaction~="Horde") then return nil; end
	if (not LootCount_Global[LootCount_Info.Server][englishFaction]) then LootCount_Global[LootCount_Info.Server][englishFaction]={}; end
	LootCount_Info.Base=LootCount_Global[LootCount_Info.Server][englishFaction];
	if (not LootCount_Info.Base) then return nil; end
	LootCount_Info.Player=UnitName("player");
	if (not LootCount_Info.Player or LootCount_Info.Player=="") then return nil; end
	if (not LootCount_Info.Base[LootCount_Info.Player]) then LootCount_Info.Base[LootCount_Info.Player]={}; end
	return true;
end


function LootCount_OnUpdate(elapsed)
	if (not LootCount_Info.Base) then
		LootCount_Info.Server=GetRealmName();
		if (not LootCount_BaseHandler()) then return; end
--		LootCount_Chat("DEBUG: Base set to:"..LootCount_Info.Server);
	end
	if (not LootCount_AltsUpdated) then
		LootCount_UpdateItems(true);
		LootCount_AltsUpdated=true;
	end

	if (LootCount_Waiter>0) then
		LootCount_Waiter=LootCount_Waiter-elapsed;
		if (LootCount_Waiter<=0) then LootCount_LoadItems(); end
		return;
	end

	if (LootCount_BGUpdate.last) then
		LootCount_BGUpdate.last=LootCount_BGUpdate.last+elapsed;
		if (LootCount_BGUpdate.last>=LCUPDATEDELAY) then
			LootCount_BGUpdate.last=0;
			LootCount_BGUpdateItems();
		end
	end

	if (LootCount_Clicker.Button) then
		if ((time()-LootCount_Clicker.Time)>LOOTCOUNT_DOUBLECLICK) then															-- Waited enough
			if (LootCount_Clicker.Count>=2) then LootCount_DoubleClick(LootCount_Clicker.Button,LootCount_Clicker.LeftRight);	-- It's fast, so call doubleclick
			else LootCount_SingleClick(LootCount_Clicker.Button,LootCount_Clicker.LeftRight);									-- It's slow, so call singleclick
			end
			LootCount_Clicker.Button=nil;
			LootCount_Clicker.Time=0;
			LootCount_Clicker.Count=0;
		end
	end

	if (LootCount_ReadAgain) then
		if (LootCount_ReadAgain>=0) then LootCount_ReadAgain=LootCount_ReadAgain-elapsed;
		else
			LootCount_ReadAgain=nil;
			LootCount_ReadBank();
--			if (not LootCount_ReadAgain) then LootCount_Chat("Bags saved (alt-data)"); end
--			LootCount_Chat("PLEASE NOTE: Clearing an item is now double right-click (it was single left-click)",.75,0,.4);
		end
	end

	if (LootCount_Populated.FadeFrame and not LootCount_FrameFaded and LootCount_FrameTimer>=0) then
		LootCount_FrameTimer=LootCount_FrameTimer-elapsed;
		if (LootCount_FrameTimer<=0) then
			LootCount_ShowFrame(nil);
		elseif (LootCount_FrameTimer<=LOOTCOUNT_FADETIME) then
			LootCount_Lock(LootCount_Populated.Locked,1-((LOOTCOUNT_FADETIME-LootCount_FrameTimer)/LOOTCOUNT_FADETIME));
		end
	end

	if (ItemRefTooltip) then
		if (not ItemRefTooltip:IsVisible()) then
			if (LootCount_GrabLinkButton) then
				LootCount_GrabLinkButton:Hide();
				LootCount_GrabLinkButton=nil;
				LootCount_GIR_Count=nil;
				LootCount_GIROwnTooltip=nil;
				if (LootCount_GIRCountButton) then LootCount_GIRCountButton:Hide(); end
			end
			if (LootCount_Grabber and type(LootCount_Grabber)=="string" and LootCount_Grabber~=LOOTCOUNT_SPECIAL) then
				LootCount_Grabber=nil;
			end
		else
			if (not LootCount_GrabLinkButton) then
				LootCount_GIR_Count=nil;
				LootCount_GrabLinkButton=CreateFrame("Button","LootCount_GrabLinkButton",getglobal("ItemRefTooltip"),"LootCount_GrabLinkButtonTemplate");
				if (not LootCount_GrabLinkButton) then return; end
				LootCount_GrabLinkButton:Hide();
			elseif (not LootCount_GrabLinkButton:IsVisible()) then
				LootCount_GrabLinkButton:ClearAllPoints();
				LootCount_GrabLinkButton:SetPoint("TOP","ItemRefCloseButton","BOTTOM",0,3);
				if (LootCount_ShowGrabber) then LootCount_GrabLinkButton:Show();
				else LootCount_GrabLinkButton:Hide(); end
			end
			local _,ThisItem=ItemRefTooltip:GetItem();
			if (ThisItem~=LootCount_LastGIRItem) then LootCount_GIR_Count=nil; end
			if (not LootCount_GIR_Count) then
				_,LootCount_LastGIRItem=ItemRefTooltip:GetItem();
				item=LootCount_GetID(LootCount_LastGIRItem);
				LootCount_FrameAppendCount(ItemRefTooltip,LootCount_GIRCountButton,item);
				LootCount_GIR_Count=true;
			end
		end
	end
	if (GameTooltip and GameTooltip:IsVisible()) then
		local _,ThisItem=GameTooltip:GetItem();
		if (ThisItem~=LootCount_LastGTTItem) then LootCount_GTT_Count=nil; end
		if (not LootCount_GTT_Count) then
			if (ThisItem) then
				local _,numID=LootCount_GetID(ThisItem);
				if (not LootCount_UsageID[numID]) then
					LootCount_UsageID[numID]=LootCount_FindTooltipText(LCUP_RCLICK);
					if (LootCount_Debug) then
						if (LootCount_UsageID[numID]) then LootCount_Chat("DEBUG: "..numID.." added to usable database"); end
					end
				end
			end
			LootCount_LastGTTItem=ThisItem;
			if (LootCount_LastGTTItem) then
				local item=LootCount_GetID(LootCount_LastGTTItem);
				if (not LootCount_GTTOwnTooltip) then LootCount_FrameAppendCount(GameTooltip,LootCount_GTTCountButton,item); end
			else
				if (LootCount_GTTCountButton) then LootCount_GTTCountButton:Hide(); end
			end
			LootCount_GTT_Count=true;
		end
	else
		LootCount_GTT_Count=nil;
		LootCount_GTTOwnTooltip=nil;
	end
	
	if (LootCount_InCombatDone>=0) then
		LootCount_InCombatDone=LootCount_InCombatDone-elapsed;
		if (LootCount_InCombatDone<0) then
			LootCount_InCombatDone=-1;
			LootCount_InCombat=nil;
		end
	end

	if (LootCount_Updated) then
		if (LootCount_UnknownPlugin) then
			if (LootCount_PluginTimer>0) then LootCount_PluginTimer=LootCount_PluginTimer-elapsed; return; end
			LootCount_PluginTimer=5;
			LootCount_PluginLoader=LootCount_PluginLoader-1;
			LootCount_Chat("Some plugins are not loaded. Retrying...");
			LootCount_LoadItems();
		end
		return;
	end

	LootCount_UpdateTime=LootCount_UpdateTime+elapsed;
	if (LootCount_UpdateTime<LOOTCOUNT_SCANTIME) then return; end
	LootCount_UpdateTime=0;
	if (not LootCount_LoadedStuff[1]) then LootCount_Updated=true; return; end

	if (LootCount_UpdateIndex<=LootCount_LastLoadCount) then
--		local item="item:"..LootCount_LoadedStuff[LootCount_UpdateIndex];
		local item=LootCount_LoadedStuff[LootCount_UpdateIndex];
		local itemname=GetItemInfo(item);
		if (not itemname) then
			if (not GameTooltip:IsVisible()) then
				if (LootCount_CacheRetries<10) then
					if (LootCount_Debug) then LootCount_Chat("Cache: Loading "..item.." ("..LootCount_UpdateIndex..")"); end
					GameTooltip:SetOwner(UIParent); GameTooltip:SetHyperlink(item); GameTooltip:Show(); GameTooltip:Hide();
					LootCount_CacheRetries=LootCount_CacheRetries+1;
				else
					if (LootCount_Debug) then LootCount_Chat("Cache: Can't load "..item.." ("..LootCount_UpdateIndex..")"); end
					LootCount_CacheRetries=0;
					LootCount_UpdateIndex=LootCount_UpdateIndex+1;
				end
			end
		else
			if (LootCount_Debug) then LootCount_Chat("Cache: Item okay "..item.." ("..LootCount_UpdateIndex..") \""..itemname.."\""); end
			LootCount_CacheRetries=0;
			LootCount_UpdateIndex=LootCount_UpdateIndex+1;
		end
	else
		if (LootCount_Debug) then LootCount_Chat("Cache: Done"); end
		LootCount_Updated=true;
		LootCount_LoadItems(true);
	end
end


function LootCount_FrameAppendCount(frame,icon,itemID)
	local count=LootCount_GetItemCount(itemID,false);

	if (not icon) then
		if (frame==GameTooltip) then
			LootCount_GTTCountButton=CreateFrame("Button","LootCountGTTTooltipCount",frame,"LootCount_DeadButtonTemplate");
			LootCount_GTTCountButton.Special="TOOLTIPICON";
			icon=LootCount_GTTCountButton;
		elseif (frame==ItemRefTooltip) then
			LootCount_GIRCountButton=CreateFrame("Button","LootCountGIRTooltipCount",frame,"LootCount_DeadButtonTemplate");
			LootCount_GIRCountButton.Special="TOOLTIPICON";
			icon=LootCount_GIRCountButton;
		else
			return;
		end
	end

	if (not LootCount_Populated.Hide) then
		LootCount_PlaceItem(icon,itemID,true);
		icon.Local=nil;
		LootCount_UpdateLocal(icon);
		LootCount_SetItems(icon,true);
		icon:SetPoint("BOTTOMLEFT",frame,"TOPLEFT",0,3);
		icon:Show();
	else
		icon:Hide();
	end
end


function LootCount_GrabLinkButton_OnClick()
	if (not LootCount_Grabber) then
		if (LootCount_Debug) then LootCount_Chat("DEBUG: No link grabbed"); end
		return;
	end
	LootCount_OnEnter(true);
end


function LootCount_IncomingItem(sender,msg)
	if (LootCount_Populated.ExcludeGroup) then return; end
	if (not string.find(msg,"Item:") or not string.find(msg,"Count:")) then return; end
	if (not LootCount_DB[sender]) then LootCount_DB[sender]={}; end

--	local item=tonumber(string.sub(msg,string.find(msg,"Item:")+5,string.find(msg,"�")-1));
	local item=string.sub(msg,string.find(msg,"Item:")+5,string.find(msg,"�")-1);
	msg=string.sub(msg,string.find(msg,"�")+1);
--	local count=tonumber(string.sub(msg,string.find(msg,"Count:")+6,string.find(msg,"�")-1));
	local count=string.sub(msg,string.find(msg,"Count:")+6,string.find(msg,"�")-1);

	LootCount_DB[sender][item]=count;
	LootCount_UpdateItems(true);
end


function LootCount_TransmitData(button)
	if (LootCount_Populated.ExcludeGroup) then return; end
	if (not button) then return nil; end
	if (button.deleted) then return nil; end
	if (not button.itemID) then return nil; end
	if (button.itemID==LOOTCOUNT_SPECIAL) then return nil; end
	if (button.Local) then return nil; end

	local buttoncount=LootCount_GetItemCount(button.itemID,false);
	if (button.lastSent~=buttoncount) then
		local text="Item:"..button.itemID.."�Count:"..buttoncount.."�";
		if (LootCount_Debug) then LootCount_Chat("DEBUG: "..text); end
		SendAddonMessage(LOOTCOUNT_PREFIX,text,"RAID");
		button.lastSent=buttoncount;
	end
	return button;
end


function LootCount_SendMyStuff()
	LootCount_TraverseIcons(LootCount_TransmitData);
end


function LootCount_SetNumber(button,item,num,r,g,b)
	if (not num) then num="";
	else
--		local testnum=tonumber(num);
--		if (testnum) then num=testnum; end
	end
	if (type(num)=="number" and num>=1000) then num=string.format("%.1fk",num/1000); end
	local buttontext=getglobal(button:GetName()..item);
	buttontext:SetText(num);
	buttontext:SetTextHeight(LC_FONTHEIGHT);
	buttontext:Show();
	if (not r and not g and not b) then return; end
	if (not r) then r=0; end
	if (not g) then g=0; end
	if (not b) then b=0; end
	buttontext:SetTextColor(r,g,b);
end


function LootCount_GetItemCount(itemID,localOR,countit)
	local bagstuff={ Count=0 };
	local bankstuff={ Count=0 };
	local mystuff=GetItemCount(itemID);
	bagstuff.Count=mystuff;
	if (LootCount_Populated.IncludeBank and LootCount_Populated.Bank) then
		if (LootCount_Populated.Bank[itemID]) then
			bankstuff.Count=LootCount_Populated.Bank[itemID].Count;
			mystuff=mystuff+bankstuff.Count;
		end
	end

	if (localOR) then return mystuff,bagstuff.Count,bankstuff.Count;  end

	local altdude={}; altdude[1]={};
	altdude[1].Count=0;
	if (LootCount_Populated.Alts and LootCount_Info.Base and LootCount_Info.Player) then					-- If all is in place for alts
		local alt=1;
		for altToon,altTable in pairs(LootCount_Info.Base) do				-- All alts (if any)
			if (altToon~=LootCount_Info.Player) then						-- Not myself of course
				if (altTable[itemID]) then									-- If the alt have the item in question
					altdude[alt]={};
					altdude[alt].Name=altToon;						-- Get name of alt
					altdude[alt].Count=altTable[itemID].Count;		-- Get alt-count of item
					mystuff=mystuff+altTable[itemID].Count;					-- Add it to the total
					alt=alt+1;
					altdude[alt]={};
					altdude[alt].Count=0;
				end
			end
		end
	end

	local data={};
	-- Repack
	data.Total=mystuff; data.Bags=bagstuff; data.Bank=bankstuff;
	local i=1; while(i<=10) do
		if (altdude[i]) then data["Alt"..i]={ Name=altdude[i].Name, Count=altdude[i].Count };
		else data["Alt"..i]={ Name="Alt"..i, Count=0 }; end
		i=i+1;
	end
	if (LootCount_Plugin) then
		-- Call all modifier-plugins
		for plugin,pTable in pairs(LootCount_Plugin) do
			if (pTable.Modifier) then data=pTable.Modifier(itemID,data); end
		end
	end
	-- Backpack :P
	mystuff=data.Total; bagstuff=data.Bags; bankstuff=data.Bank;
	i=1; while(i<=10) do
		if (not altdude[i]) then altdude[i]={}; end
		altdude[i].Name=data["Alt"..i].Name; altdude[i].Count=data["Alt"..i].Count;
		i=i+1;
	end

	if (countit) then return bagstuff,bankstuff,altdude[1],altdude[2],altdude[3],altdude[4],altdude[5],altdude[6],altdude[7],altdude[8],altdude[9],altdude[10]; end
	return mystuff,bagstuff.Count,bankstuff.Count;
end


function LootCount_UpdateSpecial(button)
	if (LootCount_Plugin[button.Special] and LootCount_Plugin[button.Special].fUpdateIcon) then LootCount_Plugin[button.Special].fUpdateIcon(button); return; end
end


function LootCount_SetItems(button,other,fastbuttons)
	if (not button) then return nil; end
	if (button.itemID) then
		if (tostring(button.itemID)==LOOTCOUNT_SPECIAL) then LootCount_UpdateSpecial(button); return; end
		if (fastbuttons) then return; end
		LootCount_SetUsageButton(button,true);
		local mystuff,bagstuff,bankstuff=LootCount_GetItemCount(button.itemID,button.Local);
		local total=mystuff;
		if (not button.Local) then								-- Add all group-members
			for player,pTable in pairs(LootCount_DB) do
				for item,iEntry in pairs(pTable) do
					if (item==button.itemID) then total=total+iEntry; end
				end
			end
		end

		local OurStock=getglobal(button:GetName().."OurStock");
		local MyCount=getglobal(button:GetName().."MyCount");

		if (total==mystuff) then															-- No items from the group
			LootCount_SetNumber(button,"MyCount",mystuff,1,1,1);
			if (button.goal==0) then														-- No goal set
				if (button.Local) then														-- Only bank and bags counted
					if (bagstuff~=mystuff) then												-- Stuff in bank
						LootCount_SetNumber(button,"OurStock",bagstuff,.4,.4,1);			-- Set bag-items only
					else
						OurStock:Hide();
					end
				else
					if (bagstuff+bankstuff~=mystuff) then									-- If alts have any items
						LootCount_SetNumber(button,"OurStock",bagstuff+bankstuff,.4,.4,1);	-- Set only own items
					else
						OurStock:Hide();
					end
				end
			else
				if (button.goal-total>0) then
					LootCount_SetNumber(button,"OurStock",button.goal-total,1,0,0);
					MyCount:SetTextColor(1,1,1);
				else
					OurStock:Hide();
					MyCount:SetTextColor(0,1,0);
				end
			end
		else
			OurStock:Show();
			if (button.goal==0) then
				LootCount_SetNumber(button,"OurStock",total,.75,.75,0);
				LootCount_SetNumber(button,"MyCount",mystuff,1,1,1);
			else
				if (button.goal-total>0) then
					LootCount_SetNumber(button,"OurStock",button.goal-total,1,0,0);
					LootCount_SetNumber(button,"MyCount",mystuff,1,1,1);
				else
					LootCount_SetNumber(button,"OurStock",total,0,1,0);
					LootCount_SetNumber(button,"MyCount",mystuff);
					if (button.goal-mystuff>0) then MyCount:SetTextColor(1,0,0); else MyCount:SetTextColor(0,1,0); end
				end
			end
		end

		if (not other) then LootCount_TransmitData(button); end
		return 1;
	end
	return nil;
end


function LootCount_GetID(link)
	if (type(link)~="string") then
		if (type(link)~="number") then return nil,nil; end
		_,link=GetItemInfo(link);
	end
	local itemID,i1,i2,i3,i4,i5,i6=link:match("|Hitem:(%p?%d+):(%p?%d+):(%p?%d+):(%p?%d+):(%p?%d+):(%p?%d+):(%p?%d+):(%p?%d+)|h%[(.-)%]|h");
	if (not i6) then
		itemID,i1,i2,i3,i4,i5,i6=link:match("item:(%p?%d+):(%p?%d+):(%p?%d+):(%p?%d+):(%p?%d+):(%p?%d+):(%p?%d+)");
	end
	if (not i6) then return; end
	return "item:"..itemID..":"..i1..":"..i2..":"..i3..":"..i4..":"..i5..":"..i6,tonumber(itemID);
end


function LootCount_RegisterBankItem(itemID,quantity)
	if (not LootCount_Populated.Bank[itemID]) then
		LootCount_Populated.Bank[itemID]={};
		LootCount_Populated.Bank[itemID].Count=quantity;
	else
		LootCount_Populated.Bank[itemID].Count=LootCount_Populated.Bank[itemID].Count+quantity;
	end
end


function LootCount_ValidateGlobalSave()
	if (not LootCount_Info.Base) then return nil; end
	if (not LootCount_Info.Player) then return nil; end
	return true;
end


function LootCount_ReadBank()
	local link,bagslots;
	if (not LootCount_ValidateGlobalSave()) then LootCount_ReadAgain=2; return; end

	if (LootCount_BankOpen) then
		if (not LootCount_Populated.Bank) then LootCount_Populated.Bank={};			-- Fresh
		else LootCount_ClearTable(LootCount_Populated.Bank); end					-- Clear local bank data
	end

	-- Do all bank slots
	for num=1,28 do
		link=GetContainerItemLink(BANK_CONTAINER,num);
		if (link) then
			local itemID=LootCount_GetID(link)
			local _,quantity=GetContainerItemInfo(BANK_CONTAINER,num);
			LootCount_RegisterBankItem(itemID,quantity);
		end
	end

	-- Each banker bag
	for num=5,11 do
		bagslots=GetContainerNumSlots(num);
		-- Each slot in said bag
		link=nil;
		for item=1,bagslots do
			link=GetContainerItemLink(num,item);
			if (link) then
				local itemID=LootCount_GetID(link)
				local _,quantity=GetContainerItemInfo(num,item);
				LootCount_RegisterBankItem(itemID,quantity);
			end
		end
	end

	if (LootCount_ValidateGlobalSave()) then
		-- Copy existing alt data
		if (not LootCount_Info.Base[LootCount_Info.Player]) then LootCount_Info.Base[LootCount_Info.Player]={};		-- Fresh
		else LootCount_ClearTable(LootCount_Info.Base[LootCount_Info.Player]); end									-- Clear global alt data
		if (LootCount_Populated.Bank) then
			LootCount_Info.Base[LootCount_Info.Player]=LootCount_CopyTable(LootCount_Populated.Bank);				-- Copy local bank to global alt
		end
		-- Save bags
		for num=0,4 do
			local bagslots=GetContainerNumSlots(num);
			link=nil;
			for item=1,bagslots do
				link=GetContainerItemLink(num,item);
				if (link) then
					local itemID=LootCount_GetID(link);
					local _,quantity=GetContainerItemInfo(num,item);
					if (not LootCount_Info.Base[LootCount_Info.Player][itemID]) then LootCount_Info.Base[LootCount_Info.Player][itemID]={ Count=0 }; end
					LootCount_Info.Base[LootCount_Info.Player][itemID].Count=LootCount_Info.Base[LootCount_Info.Player][itemID].Count+quantity;
				end
			end
		end
		LootCount_ReadAgain=nil;
	else
		LootCount_ReadAgain=2;
		LootCount_Chat("Could not read bag contents. Retrying...");
	end
end


function LootCount_CopyTable(t)
	local new = {};          
	local i,v;  
	for i,v in pairs(t) do
		if (type(v)=="table") then new[i]=LootCount_CopyTable(v); else new[i]=v; end
	end
	return new;
end


function LootCount_UpdateItems(other,fastbuttons)
	LootCount_BGUpdate.last=time();
	LootCount_BGUpdate.other=other;
	LootCount_BGUpdate.fastbuttons=fastbuttons;
	LootCount_BGUpdate.xdir=1;
	LootCount_BGUpdate.xpos=0;
	LootCount_BGUpdate.ydir=1;
	LootCount_BGUpdate.ypos=0;
end


function LootCount_BGUpdateItems()
	while (LootCount_BGUpdate.xdir~=0 or LootCount_BGUpdate.ydir~=0) do
		if (LootCount_GetButton(LootCount_BGUpdate.xpos,LootCount_BGUpdate.ypos,true)) then			-- Do not create if non-existent
			LootCount_SetItems(LootCount_GetButton(LootCount_BGUpdate.xpos,LootCount_BGUpdate.ypos,true),LootCount_BGUpdate.other,LootCount_BGUpdate.fastbuttons);
			LootCount_BGUpdate.xpos=LootCount_BGUpdate.xpos+LootCount_BGUpdate.xdir;
			return;
		end
		-- Check end of direction
		if (LootCount_BGUpdate.xpos==0 and LootCount_BGUpdate.xdir== 1 and LootCount_BGUpdate.ydir== 1) then
			LootCount_BGUpdate.xpos=-1; LootCount_BGUpdate.xdir=-1; LootCount_BGUpdate.ypos= 0; LootCount_BGUpdate.ydir= 1;	-- One left to center, shift from left, aim up
		elseif (LootCount_BGUpdate.xpos==0 and LootCount_BGUpdate.xdir==-1 and LootCount_BGUpdate.ydir== 1) then
			LootCount_BGUpdate.xpos= 0; LootCount_BGUpdate.xdir= 1; LootCount_BGUpdate.ypos=-1; LootCount_BGUpdate.ydir=-1;	-- One below center, shift from right, aim down
		elseif (LootCount_BGUpdate.xpos==0 and LootCount_BGUpdate.xdir== 1 and LootCount_BGUpdate.ydir==-1) then
			LootCount_BGUpdate.xpos= 0; LootCount_BGUpdate.xdir=-1; LootCount_BGUpdate.ypos=-1; LootCount_BGUpdate.ydir=-1;	-- One below center, shift from left, aim down
		elseif (LootCount_BGUpdate.xpos==0 and LootCount_BGUpdate.xdir==-1 and LootCount_BGUpdate.ydir==-1) then
			LootCount_BGUpdate.xdir=0; LootCount_BGUpdate.ydir=0; break;				-- Done
		else
			LootCount_BGUpdate.xpos=0; LootCount_BGUpdate.ypos=LootCount_BGUpdate.ypos+LootCount_BGUpdate.ydir;				-- Continue
		end
	end
	LootCount_BGUpdate.last=nil;
end


function LootCount_Arrange()
	local arranged=true;
	while (arranged) do
		if (LootCount_Populated.Orientation==LOOTCOUNT_H) then
			arranged=LootCount_Arrange_V();
			if (not arranged) then arranged=LootCount_Arrange_H(); end
		elseif (LootCount_Populated.Orientation==LOOTCOUNT_V) then
			arranged=LootCount_Arrange_H();
			if (not arranged) then arranged=LootCount_Arrange_V(); end
		else
			return;
		end
	end
end


function LootCount_RemoveButton(xpos,ypos,xdir,ydir)
	local shifted=nil;
	local xmove=xpos+xdir;
	local ymove=ypos+ydir;
	while (LootCount_GetButton(xmove,ymove,true)) do				-- Don't create just in case
		local from=LootCount_GetButton(xmove,ymove);				-- Get button to shift from
		local to=LootCount_GetButton(xmove-xdir,ymove-ydir);		-- Get button to shift to
		if (not from.deleted) then									-- We're at the end of the line
			to.deleted=nil;
			to.MO=from.MO; to.itemID=from.itemID; to.goal=from.goal; to.lastSent=from.lastSent; to.Special=from.Special; to.Local=from.Local;
			to.LastUpdated=from.LastUpdated;
			if (from.User) then to.User=nil; to.User=LootCount_CopyTable(from.User); end
			getglobal(to:GetName().."IconTexture"):SetTexture(getglobal(from:GetName().."IconTexture"):GetTexture());
			LootCount_SetUsageButton(from,true);
			LootCount_SetUsageButton(to,true);
--			getglobal(to:GetName().."IconTextureOverlay"):SetTexture(getglobal(from:GetName().."IconTextureOverlay"):GetTexture());
			LootCount_UpdateLocal(to);								-- Update visual
			LootCount_SaveButton(to);								-- It's a "new" button, so save it (fake "PlaceItem")
			LootCount_ClearButton(from);							-- Kill old button
			from:Hide();
			shifted=true;
		end
		xmove=xmove+xdir;											-- Advance
		ymove=ymove+ydir;											-- Advance
	end

	return shifted;
end


function LootCount_Arrange_H()
	-- One right to center, shift from right, aim up
	local xdir=1;
	local xpos=1;
	local ydir=1;
	local ypos=0;
	local changed=nil;

	while (xdir~=0 or ydir~=0) do
		while (LootCount_GetButton(xpos,ypos,true)) do								-- Do not create if non-existent
			local button=LootCount_GetButton(xpos,ypos);							-- Get the button
			if (button.deleted) then
				local action=LootCount_RemoveButton(xpos,ypos,xdir,0);				-- It's deleted, so do proper horisontal remove
				if (action) then changed=true; end
				button:Hide();
			else button:Show(); end
			xpos=xpos+xdir;
		end
		-- Check end of direction
			if (xpos==0 and xdir== 1 and ydir== 1) then xpos=-1; xdir=-1; ypos= 0; ydir= 1;	-- One left to center, shift from left, aim up
		elseif (xpos==0 and xdir==-1 and ydir== 1) then xpos= 0; xdir= 1; ypos=-1; ydir=-1;	-- One below center, shift from right, aim down
		elseif (xpos==0 and xdir== 1 and ydir==-1) then xpos= 0; xdir=-1; ypos=-1; ydir=-1;	-- One below center, shift from left, aim down
		elseif (xpos==0 and xdir==-1 and ydir==-1) then xdir=0; ydir=0; break;				-- Done
		else xpos=0; ypos=ypos+ydir; end													-- Continue
	end
	return changed;
end

function LootCount_Arrange_V()
	-- One above center, shift from top, aim right
	local xdir=1;
	local xpos=0;
	local ydir=1;
	local ypos=1;
	local changed=nil;

	while (xdir~=0 or ydir~=0) do
		while (LootCount_GetButton(xpos,ypos,true)) do								-- Do not create if non-existent
			local button=LootCount_GetButton(xpos,ypos);							-- Get the button
			if (button.deleted) then
				local action=LootCount_RemoveButton(xpos,ypos,0,ydir);				-- It's deleted, so do proper vertical remove
				if (action) then changed=true; end
				button:Hide();
			else button:Show(); end
			ypos=ypos+ydir;
		end
		-- Check end of direction
			if (ypos==0 and ydir== 1 and xdir== 1) then ypos=-1; ydir=-1; xpos= 0; xdir= 1;	-- One below center, shift from bottom, aim right
		elseif (ypos==0 and ydir==-1 and xdir== 1) then ypos= 0; ydir= 1; xpos=-1; xdir=-1;	-- One left to center, shift from top, aim left
		elseif (ypos==0 and ydir== 1 and xdir==-1) then ypos= 0; ydir=-1; xpos=-1; xdir=-1;	-- One left to center, shift from bottom, aim down
		elseif (ypos==0 and ydir==-1 and xdir==-1) then xdir=0; ydir=0; break;				-- Done
		else ypos=0; xpos=xpos+xdir; end													-- Continue
	end
	return changed;
end


function LootCount_GetButtonCoords(button)
	local name=button:GetName()
	if (string.find(name,LOOTCOUNTBUTTON) and string.find(name,"_")) then
		local _,xpos=string.find(name,LOOTCOUNTBUTTON); xpos=xpos+1;
		local ypos=string.find(name,"_"); ypos=ypos+1;
		local x=tonumber(string.sub(name,xpos,ypos-2));
		local y=tonumber(string.sub(name,ypos));
		return x,y;
	end
	return nil,nil;
end


function LootCount_SaveButton(button)
	local name=button:GetName()
	local x,y=LootCount_GetButtonCoords(button);
	if (x and y) then
		local value=button.itemID;
		LootCount_SaveItem(x,y,button.itemID,button.Special);
	end
end
function LootCount_SaveItem(x,y,itemID,special)
	if (type(x)~="string") then x=tostring(x); end
	if (type(y)~="string") then y=tostring(y); end
	if (not LootCount_Populated[x]) then LootCount_Populated[x]={}; end
	if (not LootCount_Populated[x][y]) then LootCount_Populated[x][y]={}; end
	LootCount_Populated[x][y].itemID=itemID;
	LootCount_Populated[x][y].Special=special;
	if (not itemID) then LootCount_Populated[x][y]=nil;											-- Kill everything in there
	else
		local button=LootCount_GetButton(tonumber(x),tonumber(y));
		LootCount_Populated[x][y].goal=button.goal;
		LootCount_Populated[x][y].Local=button.Local;
		if (button.User) then LootCount_Populated[x][y].User=nil; LootCount_Populated[x][y].User=LootCount_CopyTable(button.User); end
	end
end
function LootCount_LoadItem(x,y)
	if (type(x)~="string") then x=tostring(x); end
	if (type(y)~="string") then y=tostring(y); end
	if (not LootCount_Populated[x]) then return nil; end
	-- Convert old-style storage
	local itemID=LootCount_Populated[x][y];
	if (type(itemID)~="table") then
		if (not itemID) then return nil; end
		LootCount_Populated[x][y]={};
		LootCount_Populated[x][y]["itemID"]=itemID;
		LootCount_Populated[x][y]["goal"]=0;
	end
	-- Continue new-style load
	itemID=LootCount_Populated[x][y].itemID;
	local special=LootCount_Populated[x][y].Special;
	local goal=LootCount_Populated[x][y]["goal"];
	if (not itemID or not goal) then
		if (x=="0" and y=="0") then
			LootCount_Populated.FadeFrame=nil;
			LootCount_ShowFrame(true);
		end
		return nil;
	end
	local button=LootCount_GetButton(tonumber(x),tonumber(y));
--	if (itemID=="XP" or itemID=="REP" or itemID=="MONEY" or itemID=="DPS") then
	if (itemID==LOOTCOUNT_SPECIAL and special) then
		LootCount_LastSpecial=special;
		itemID=LOOTCOUNT_SPECIAL;
		LootCount_LastLoaded=nil;
	else
		LootCount_LastLoaded=itemID;
	end
	button.Local=LootCount_Populated[x][y].Local;
	local usersetting=nil;
	if (LootCount_Populated[x][y].User) then usersetting=LootCount_CopyTable(LootCount_Populated[x][y].User); end

--	HUOM: This kills the old storage
	if (not LootCount_PlaceItem(button,itemID) and itemID==LOOTCOUNT_SPECIAL) then LootCount_UnknownPlugin=true; end
	button.goal=goal;

	if (not usersetting) then button.User=nil;
	else button.User=LootCount_CopyTable(usersetting); end

	LootCount_UpdateLocal(button);
	LootCount_SaveButton(button);

	return 1;
end


function LootCount_UpdateLocal(button)
	if (button.Local) then
		button:SetBackdrop(LootCount_LocalBackdrop);
		button:SetBackdropColor(LootCount_BDr,LootCount_BDg,LootCount_BDb,LootCount_BDa);
	else
		button:SetBackdrop(nil);
	end
end


function LootCount_PlaceItem(button,itemID,tooltip)
	local item,link,itemTexture;
	local result=true;
	if (button and itemID and itemID~=LOOTCOUNT_SPECIAL) then		-- Most likely load
		item,link=GetItemInfo(itemID);
	else
		if (not button) then button=this; end
		if (itemID~=LOOTCOUNT_SPECIAL) then							-- Normal drop
			item,_,link=GetCursorInfo();
			itemID=LootCount_GetID(link);
			if (not itemID) then
				LootCount_LastSpecial=nil;
				LootCount_Arrange();
				LootCount_UpdateItems();
				return nil;
			end
			button.goal=0;
		end
		if (not item) then											-- Grab or special counter
			if (LootCount_Grabber==LOOTCOUNT_SPECIAL or itemID==LOOTCOUNT_SPECIAL) then
				itemID=LOOTCOUNT_SPECIAL;
				link=nil;
				if (LootCount_Plugin and LootCount_Plugin[LootCount_LastSpecial] and LootCount_Plugin[LootCount_LastSpecial].sTexture) then
					itemTexture=LootCount_Plugin[LootCount_LastSpecial].sTexture;
				elseif (type(LootCount_Grabber)=="string" and LootCount_Grabber~=LOOTCOUNT_SPECIAL and itemID==LOOTCOUNT_SPECIAL) then
					item,link=GetItemInfo(LootCount_Grabber);
					itemID=LootCount_GetID(link);
				else																-- Unknown plugin
					itemTexture="Interface\\Icons\\INV_Misc_QuestionMark";
					result=nil;
				end
			end
--[[
			if (LootCount_Grabber==LOOTCOUNT_SPECIAL or itemID==LOOTCOUNT_SPECIAL) then
				itemID=LOOTCOUNT_SPECIAL;
				link=nil;
				if (LootCount_Plugin and LootCount_Plugin[LootCount_LastSpecial] and LootCount_Plugin[LootCount_LastSpecial].sTexture) then
					itemTexture=LootCount_Plugin[LootCount_LastSpecial].sTexture;
				else																-- Unknown plugin
					itemTexture="Interface\\Icons\\INV_Misc_QuestionMark";
					result=nil;
				end
			elseif (LootCount_Grabber) then
				item,link=GetItemInfo(LootCount_Grabber);
				itemID=LootCount_GetID(link);
			end
]]
		end
		LootCount_Grabber=nil;
	end
	if (link or itemID==LOOTCOUNT_SPECIAL) then
		if (not tooltip) then ClearCursor(); end
		if (button.Special and itemID~=LOOTCOUNT_SPECIAL and LootCount_Plugin and LootCount_Plugin[button.Special] and LootCount_Plugin[button.Special].fDrop) then
			LootCount_Plugin[button.Special].fDrop(button,itemID);
		else
			button.deleted=nil;
			button.MO=link;
			button.itemID=itemID;
			button.lastSent=0;
			button.goal=0;
			button.Special=LootCount_LastSpecial;
			if (itemID~=LOOTCOUNT_SPECIAL) then
				_,_,_,_,_,_,_,_,_,itemTexture=GetItemInfo(itemID);
			end
			if (not itemTexture) then LootCount_TextureMissing=true; end
			local name=button:GetName()
			getglobal(name.."IconTexture"):SetTexture(itemTexture);
			LootCount_SetUsageButton(button,true);
		end
		if (tooltip) then return result; end
		LootCount_SaveButton(button);
	end
	LootCount_LastSpecial=nil;
	LootCount_Arrange();
	LootCount_UpdateItems();
	return result;
end


-- Red border: Interface\Buttons\UI-Debuff-Border.blp
-- Yellow border with highlight: Interface\Buttons\UI-Quickslot-Depress.blp
-- Purple border: Interface\Buttons\UI-TempEnchant-Border.blp
function LootCount_SetUsageButton(button,noforcelocal)
	local overlay="";
--	if (LootCount_CanUseItem(button.itemID)) then overlay="Interface\\Buttons\\UI-Quickslot-Depress"; end
	if (LootCount_CanUseItem(button.itemID)) then overlay="Interface\\AddOns\\LootCount\\Images\\Frame_m060"; end
	getglobal(button:GetName().."IconTextureOverlay"):SetTexture(overlay);
	if (overlay=="") then
		button:SetAttribute("type1","");
		button:SetAttribute("item1","");
		LootCount_UpdateLocal(button);
		return;
	end
	button:SetAttribute("type1","item");
	button:SetAttribute("item1",button.itemID);
	if (not noforcelocal) then button.Local=true; end
	LootCount_UpdateLocal(button);
end
--[[
item

Uses an item in your inventory (equipped items) or your bags.
Attributes:
slot 	Integer specifying the slot the item to be used is in. If "bag" is set, then this will be a bag slot. If "bag" is not set, then it is an Inventory slot.
bag 	Integer specifying the bag the item to be used is in. Requires that "slot" be set.
item 	String specifying the item name or itemString. May be used instead of a bag/slot combo. Will not be used if "slot" is set.
unit 	(string unitid) Unit to use that item on. Defaults to player's target.

This causes the button to use the item in Slot #1 in your backpack when left clicked:

frame:SetAttribute("type1", "item")			
frame:SetAttribute("bag1", "1")
frame:SetAttribute("slot1", "1")

This causes the button to use your Hearthstone when left clicked:

frame:SetAttribute("type1", "item")			
frame:SetAttribute("item1", "Hearthstone")
frame:SetAttribute("item1", "item:6948") -- same thing!

Note that using items by bagslot will sell or bank them with the corresponding frames open. I.e. just as right-clicking items in bags does. Using items by name or itemstring on the other hand will never do that, just as placing them in an actionbar and clicking them that way won't. 
]]


function LootCount_CanUseItem(item)
	local usable,_=IsUsableItem(item);
	if (not usable) then return nil; end
	local _,itemnum=LootCount_GetID(item);
	usable=nil;
	LootCount_Hidden_Tooltip:SetOwner(WorldFrame, "ANCHOR_NONE");
	LootCount_Hidden_Tooltip:ClearLines();
	LootCount_Hidden_Tooltip:SetHyperlink(item);

	for i=1,30 do
		local field=getglobal("LootCount_Hidden_TooltipTextLeft"..i);
		if (field~=nil) then
			local text=field:GetText();
			if (text) then
				if (string.find(text,LCUP_USE) or LootCount_UsageID[itemnum]) then
					usable=true; i=30;
				end
			end
		end
	end
	LootCount_Hidden_Tooltip:Hide();
	return usable;
end

function LootCount_FindTooltipText(pattern)
	for i=1,30 do
		local field=getglobal("GameTooltipTextLeft"..i);
		if (field~=nil) then
			local text=field:GetText();
			if (text and string.find(text,pattern)) then return true; end
		end
	end
	return nil;
end


function LootCount_GetWindowPosition(x,y)
	local neg;
	neg=false; if (x<0) then neg=true; x=-x; end
	if (x>0) then x=LOOTCOUNTOFFSET+((x-1)*(LOOTCOUNTSIZE+LOOTCOUNTSPACE))+LOOTCOUNTSIZE/2; end
	if (neg==true) then x=-x; end
	neg=false; if (y<0) then neg=true; y=-y; end
	if (y>0) then y=LOOTCOUNTOFFSET+((y-1)*(LOOTCOUNTSIZE+LOOTCOUNTSPACE))+LOOTCOUNTSIZE/2; end
	if (neg==true) then y=-y; end
	return x,y;
end


function LootCount_GetButton(x,y,nocreate,initfirstbutton)
	local dynName=LOOTCOUNTBUTTON..x.."_"..y;
	local f=getglobal(dynName);
	if (not f or initfirstbutton) then
		if (nocreate) then return nil; end
--		if (not initfirstbutton) then f=CreateFrame("Button",dynName,getglobal("LootCount_Frame0"),"LootCount_ButtonTemplate"); end
		if (not initfirstbutton) then f=CreateFrame("Button",dynName,getglobal("LootCount_Frame0"),"LootCount_SecureButtonTemplate"); end
		LootCount_SetButtonSize(f);
		f.deleted=true;
		x,y=LootCount_GetWindowPosition(x,y);
		f:SetPoint("CENTER",x,y);
	end
	if (not nocreate or initfirstbutton) then f:Show(); end

	return f;
end


function LootCount_ShowEmpty(x,y)
	local thiszero=getglobal(LOOTCOUNTBUTTON..x.."_"..y);
	local thisone=getglobal(LOOTCOUNTBUTTON..x.."_"..y.."IconTexture");
	local thistwo=getglobal(LOOTCOUNTBUTTON..x.."_"..y.."IconTextureOverlay");
	thisone:SetTexture("Interface\\Buttons\\UI-Quickslot");
	thistwo:SetTexture("");
	thiszero:Show();
end


function LootCount_OnEnter(force)
	local item,itemID,link=GetCursorInfo(); if (not link and not force) then return; end

	local xdir,ydir,pos;

	if (not LootCount_GetButton(0,0,true) or LootCount_GetButton(0,0).deleted) then LootCount_GetButton(0,0); LootCount_ShowEmpty(0,0); end
	if (LootCount_Populated.Orientation==LOOTCOUNT_H) then
		local line;
		xdir=1; ydir=1; line=0; pos=1;				-- right, up
		while (xdir~=0 or ydir~=0) do
			if (line~=0) then pos=0; end
			if (LootCount_GetButton(pos,line).deleted) then
				LootCount_ShowEmpty(pos,line);
				line=line+ydir;
			else
				while (not LootCount_GetButton(pos,line).deleted) do
					while (not LootCount_GetButton(pos,line).deleted) do pos=pos+xdir; end
					LootCount_ShowEmpty(pos,line);
					pos=0; line=line+ydir;
				end
				LootCount_ShowEmpty(pos,line);
			end
			if (pos==0) then
					if (xdir== 1 and ydir== 1) then line= 0; ydir= 1; pos=-1; xdir=-1;	-- left, up
				elseif (xdir==-1 and ydir== 1) then line=-1; ydir=-1; pos= 0; xdir= 1;	-- right, down
				elseif (xdir== 1 and ydir==-1) then line=-1; ydir=-1; pos= 0; xdir=-1;	-- left down
				else xdir=0; ydir=0; break; end
			end
		end
	elseif (LootCount_Populated.Orientation==LOOTCOUNT_V) then
		local column;
		ydir=1; xdir=1; column=0; pos=1;				-- up, right
		while (xdir~=0 or ydir~=0) do
			if (column~=0) then pos=0; end
			if (LootCount_GetButton(column,pos).deleted) then
				LootCount_ShowEmpty(column,pos);
				column=column+xdir;
			else
				while (not LootCount_GetButton(column,pos).deleted) do
					while (not LootCount_GetButton(column,pos).deleted) do pos=pos+ydir; end
					LootCount_ShowEmpty(column,pos);
					pos=0; column=column+xdir;
				end
				LootCount_ShowEmpty(column,pos);
			end
			if (pos==0) then
					if (ydir== 1 and xdir== 1) then column= 0; xdir= 1; pos=-1; ydir=-1;	-- down, right
				elseif (ydir==-1 and xdir== 1) then column=-1; xdir=-1; pos= 0; ydir= 1;	-- up, left
				elseif (ydir== 1 and xdir==-1) then column=-1; xdir=-1; pos= 0; ydir=-1;	-- down, left
				else xdir=0; ydir=0; break; end
			end
		end
	end
end


function LootCount_Frame_OnEnter(which)
	local text="";
	if (not which) then return; end
	if (which==1) then
		text="Left-click and drag to move";
		if (LootCount_Populated.Locked==true) then text=text.." (unlock window first)"; end
	elseif (which==2) then
		text="Right-click to open menu";
	else return; end
	GameTooltip:SetOwner(this,"ANCHOR_RIGHT");
	GameTooltip:SetText(text);
	GameTooltip:Show();
end


function LootCount_ClearButton(button)
	SetItemButtonTexture(button,"");
	LootCount_SetNumber(button,"OurStock",nil);
	LootCount_SetNumber(button,"MyCount",nil);
	button.Special=nil;
	button.itemID=nil;
	button.MO=nil;
	button.deleted=true;
	button.Local=nil;
	button.User=nil;
	button:SetBackdrop(nil);				-- Kill backdrop (wont work if 'nil' isn't specifically passed as argument)
	LootCount_SaveButton(button);
end


function LootCount_Button_OnClick(arg1)
	if (LootCount_Clicker.Time==0) then LootCount_Clicker.Time=time(); end
	LootCount_Clicker.LeftRight=arg1;
	LootCount_Clicker.Button=this;
	LootCount_Clicker.Count=LootCount_Clicker.Count+1;
end


function LootCount_SingleClick(button,LR)
	if (LR=="LeftButton") then
		local item,itemID,link=GetCursorInfo();
		if (itemID or LootCount_Grabber) then				-- Cursor is holding item
			if (not button.Special) then
				LootCount_ClearButton(button);				-- Proper kill
			end
--			LootCount_PlaceItem(button);					-- Fill with new item or make a drop on plug-in
			local thismode=LOOTCOUNT_SPECIAL;
			if (itemID) then thismode=nil; end
			LootCount_PlaceItem(button,thismode);			-- Fill with new item or make a drop on plug-in
		else
			-- Not item-drop, so pass to plug-in if handler exists
			if (button.itemID==LOOTCOUNT_SPECIAL and LootCount_Plugin) then
				-- Plugin has handler
				if (LootCount_Plugin[button.Special] and LootCount_Plugin[button.Special].fClicker) then
					LootCount_Plugin[button.Special].fClicker(button,LR,1);
				end
			else				-- Native LootCount left-click
				-- Reserved for usage of items
			end
		end
	elseif (LR=="RightButton") then
		-- Plug-in, so pass click to it
		if (button.itemID==LOOTCOUNT_SPECIAL and LootCount_Plugin) then
			-- Plugin has handler
			if (LootCount_Plugin[button.Special] and LootCount_Plugin[button.Special].fClicker) then
				LootCount_Plugin[button.Special].fClicker(button,LR,1);
			end
		else
		-- Native, so show menu
			LootCount_ShowButtonMenu(button);
		end
	end
end


function LootCount_SetGoalPopup(button)
	LootCount_InitValue=button.goal;
	local dialog=StaticPopup_Show("LOOT_COUNT_GOAL");
	if (dialog) then
		dialog.data=button;
	end
end


function LootCount_DoubleClick(button,LR)
	if (LR=="LeftButton") then
		if (button.itemID==LOOTCOUNT_SPECIAL and LootCount_Plugin) then
			-- Plugin has handler, so pass click
			if (LootCount_Plugin[button.Special] and LootCount_Plugin[button.Special].fClicker) then
				LootCount_Plugin[button.Special].fClicker(button,LR,2);
			end
--[[		else
			-- Native, so do proper local lock
			if (button.Local) then
				button.Local=nil;
				button:SetBackdrop(nil);				-- Kill backdrop (wont work if not 'nil' isn't specifically passed as argument
			else
				button.Local=true;
				LootCount_UpdateLocal(button);
			end
]]
		end
		LootCount_SaveButton(button);
		LootCount_UpdateItems();
	elseif (LR=="RightButton") then
		if (LootCount_Populated.Locked~=true) then
			local x,y=LootCount_GetButtonCoords(button);
			if (x and y and x==0 and y==0) then LootCount_Populated.FadeFrame=nil; LootCount_ShowFrame(true); end
			LootCount_ClearButton(button);				-- Clear requested
			LootCount_PlaceItem(button);				-- Proper handling
		end
	end
end


function LootCount_SetButtonSize(button)
	button:SetWidth(LOOTCOUNTSIZE);
	button:SetHeight(LOOTCOUNTSIZE);

	getglobal(button:GetName().."MyCount"):SetTextHeight(LC_FONTHEIGHT);
	getglobal(button:GetName().."OurStock"):SetTextHeight(LC_FONTHEIGHT);
end


function LootCount_SetSize(size)
	LootCount_Populated.Size=size;
	LOOTCOUNTSIZE=size;
	LOOTCOUNTOFFSET=math.ceil(LOOTCOUNTSIZE/2)+LOOTCOUNTSPACE;

	LootCount_Frame0:SetWidth((LOOTCOUNTOFFSET*2)+8);
	LootCount_Frame0:SetHeight((LOOTCOUNTOFFSET*2)+8);

	LootCount_Frame0DropDownButtonT:SetWidth(LOOTCOUNTSIZE*(0.7));
	LootCount_Frame0DropDownButtonB:SetWidth(LOOTCOUNTSIZE*(0.7));
	LootCount_Frame0DropDownButtonL:SetHeight(LOOTCOUNTSIZE*(0.7));
	LootCount_Frame0DropDownButtonR:SetHeight(LOOTCOUNTSIZE*(0.7));

	if (LootCount_GTTCountButton) then LootCount_SetButtonSize(LootCount_GTTCountButton); end
	if (LootCount_GIRCountButton) then LootCount_SetButtonSize(LootCount_GIRCountButton); end

	-- Center, shift from right, aim up
	local xdir=1;
	local xpos=0;
	local ydir=1;
	local ypos=0;

	while (xdir~=0 or ydir~=0) do
		while (LootCount_GetButton(xpos,ypos,true)) do								-- Do not create if non-existent
			local button=LootCount_GetButton(xpos,ypos);							-- Get the button
			local x,y=LootCount_GetWindowPosition(xpos,ypos);
			button:SetPoint("CENTER",x,y); LootCount_SetButtonSize(button);
			xpos=xpos+xdir;
		end
		-- Check end of direction
			if (xpos==0 and xdir== 1 and ydir== 1) then xpos=-1; xdir=-1; ypos= 0; ydir= 1;	-- One left to center, shift from left, aim up
		elseif (xpos==0 and xdir==-1 and ydir== 1) then xpos= 0; xdir= 1; ypos=-1; ydir=-1;	-- One below center, shift from right, aim down
		elseif (xpos==0 and xdir== 1 and ydir==-1) then xpos= 0; xdir=-1; ypos=-1; ydir=-1;	-- One below center, shift from left, aim down
		elseif (xpos==0 and xdir==-1 and ydir==-1) then xdir=0; ydir=0; break;				-- Done
		else xpos=0; ypos=ypos+ydir; end													-- Continue
	end
end


function LootCount_ShowFrame(showit)
	if (showit) then
		LootCount_Lock(LootCount_Populated.Locked,1);
		LootCount_FrameTimer=LOOTCOUNT_FRAMETIME;
		LootCount_FrameFaded=nil;
	else
		LootCount_Lock(LootCount_Populated.Locked,0);
		LootCount_FrameFaded=true;
	end
end


function LootCount_Lock(lock,trans)
	if (not trans) then _,_,_,trans=LootCount_Frame0:GetBackdropBorderColor(); end
	if (not lock) then lock=false; end
	LootCount_Populated.Locked=lock;

	if (lock) then LootCount_Frame0:SetBackdropBorderColor(1,0,0,trans);		-- R,G,B,A
	else LootCount_Frame0:SetBackdropBorderColor(0,1,0,trans); end
end


-- There's slashing to be done
function LootCount_Slasher(msg)
-- Validate input
	if (not msg) then msg=""; end
	if (strlen(msg)>0) then msg=strlower(msg); end

	if (msg=="small") then LootCount_SetSize(25); return; end
	if (msg=="normal") then LootCount_SetSize(37); return; end
	if (string.find(msg,"size ")==1) then
		val=string.sub(msg,5); val=tonumber(val);
		if (val) then LootCount_SetSize((val*5)+20); end
		return;
	end
	if (msg=="tooltip") then if (LootCount_Populated.Hide) then LootCount_Populated.Hide=nil; else LootCount_Populated.Hide=true; end return; end
	if (msg=="lock") then LootCount_LockToggle(); return; end
	if (msg=="update") then LootCount_LoadItems(true); return; end
	if (msg=="debug") then
		if (LootCount_Debug) then
			LootCount_Debug=nil;
			LootCount_Chat("Debug: OFF");
		else
			LootCount_Debug=true;
			LootCount_Chat("Debug: ON");
		end
		return;
	end

	if (msg=="show") then
		LootCount_Populated.FadeFrame=nil;
		LootCount_ShowFrame(true);
		return;
	end

	if (msg=="") then LootCount_ToggleMainFrame(); return; end

	LootCount_Chat(LOOTCOUNT_VERSIONTEXT);
	LootCount_Chat("Drag an item from your bags to the LootCount window");
	LootCount_Chat("Double right-click the item to remove it");
	LootCount_Chat(" -> /lc show => If frame is invisible, this will show the frame ");
	LootCount_Chat(" -> /lc small => Set small-sized icons");
	LootCount_Chat(" -> /lc normal => Set normal-sized icons");
	LootCount_Chat(" -> /lc size X => Set any-sized icons with X=0,1,2,3 etc");
	LootCount_Chat(" -> /lc update => Attempt forced update of item count/texture");
	LootCount_Chat(" -> /lc tooltip => Toggle display of item-count on tooltips/mouseover");
end


function LootCount_SetOrientation(orientation)
	if (not orientation) then
		if (not this.value) then return; end
		orientation=this.value;
	end
	if (orientation==LootCount_Populated.Orientation) then return; end
	LootCount_Populated.Orientation=orientation;
end


function LootCount_BuildMenu()
	UIDropDownMenu_Initialize(LootCount_Frame0Options,LootCount_MenuLoad,"MENU");
end
function LootCount_ShowMenu()
	ToggleDropDownMenu(1,nil,LootCount_Frame0Options,this:GetParent(),0,0);
end
function LootCount_MenuLoad()
	local info={};
	info.textR=1; info.textG=1; info.textB=1;
	if (LootCount_Populated.Locked) then info.text="Unlock"; else info.text="Lock"; end
	info.func=LootCount_LockToggle;
	UIDropDownMenu_AddButton(info,1);

	info.func=LootCount_SetBank;
	info.text="Include bank"; if (LootCount_Populated.IncludeBank) then info.checked=true; else info.checked=nil; end UIDropDownMenu_AddButton(info,1);
	if (LootCount_BaseHandler()) then
		info.checked=LootCount_Populated.Alts;
		info.func=LootCount_IncludeAlts;
		info.text="Include alts"; UIDropDownMenu_AddButton(info,1);
	end

	info.func=LootCount_SetGroup;
	info.text="Do not use group"; if (LootCount_Populated.ExcludeGroup) then info.checked=true; else info.checked=nil; end UIDropDownMenu_AddButton(info,1);

	info.checked=LootCount_Populated.FadeFrame;
	info.func=LootCount_SetFrame;
	info.text="Fade center frame"; UIDropDownMenu_AddButton(info,1);

	info.checked=nil;
	info.func=LootCount_SetOrientation;
	if (LootCount_Populated.Orientation==LOOTCOUNT_H) then info.textB=0; else info.textB=1; end
	info.text="Horizontal"; info.value=LOOTCOUNT_H; UIDropDownMenu_AddButton(info,1);
	if (LootCount_Populated.Orientation==LOOTCOUNT_V) then info.textB=0; else info.textB=1; end
	info.text="Vertical"; info.value=LOOTCOUNT_V; UIDropDownMenu_AddButton(info,1);
--	if (LootCount_Populated.Orientation==LOOTCOUNT_N) then info.textB=0; else info.textB=1; end
--	info.text="No compacting"; info.value=LOOTCOUNT_N; UIDropDownMenu_AddButton(info,1);
	info.textB=1;

	if (LootCount_Plugin) then
		info.func=LootCount_SetPluginInterface;
		for plugin,pTable in pairs(LootCount_Plugin) do
			info.text="Set |r|cFF9900FF"..pTable.MenuText.."|r";
			info.value=plugin;
			UIDropDownMenu_AddButton(info,1);
		end
	end

	info.func=LootCount_SizeFromMenu;
	info.text="Tiny"; info.value=20; if (info.value==LOOTCOUNTSIZE) then info.checked=true; else info.checked=nil; end UIDropDownMenu_AddButton(info,1);
	info.text="Small"; info.value=25; if (info.value==LOOTCOUNTSIZE) then info.checked=true; else info.checked=nil; end UIDropDownMenu_AddButton(info,1);
	info.text="Medium"; info.value=30; if (info.value==LOOTCOUNTSIZE) then info.checked=true; else info.checked=nil; end UIDropDownMenu_AddButton(info,1);
	info.text="Normal"; info.value=37; if (info.value==LOOTCOUNTSIZE) then info.checked=true; else info.checked=nil; end UIDropDownMenu_AddButton(info,1);
	info.text="Big"; info.value=45; if (info.value==LOOTCOUNTSIZE) then info.checked=true; else info.checked=nil; end UIDropDownMenu_AddButton(info,1);

	info.checked=nil;
	info.func=LootCount_TextSizeFromMenu;
	info.text="Bigger text"; info.value=1; UIDropDownMenu_AddButton(info,1);
	info.text="Smaller text"; info.value=-1; UIDropDownMenu_AddButton(info,1);
end


function LootCount_BuildButtonMenu()
	UIDropDownMenu_Initialize(LootCount_Frame0ButtonOptions,LootCount_MenuButtonLoad,"MENU");
end
function LootCount_ShowButtonMenu(button)
--	ToggleDropDownMenu(1,nil,LootCount_Frame0ButtonOptions,this:GetParent(),0,0);
	LootCount_LastMenuButton=button;
	ToggleDropDownMenu(1,nil,LootCount_Frame0ButtonOptions,button,0,0);
end
function LootCount_MenuButtonLoad()
	local info={};
	info.textR=1; info.textG=1; info.textB=1;

	info.text="Set goal";
	info.func=LootCount_SetGoalMenu;
	UIDropDownMenu_AddButton(info,1);

	info.text="Toggle local mode";
	info.func=LootCount_SetLocalMenu;
	UIDropDownMenu_AddButton(info,1);
end


function LootCount_SetGoalMenu()
	LootCount_SetGoalPopup(LootCount_LastMenuButton);
end
function LootCount_SetLocalMenu()
	if (LootCount_LastMenuButton.Local) then LootCount_LastMenuButton.Local=nil; else LootCount_LastMenuButton.Local=true; end
	LootCount_UpdateLocal(LootCount_LastMenuButton);					-- Update visual
	LootCount_SaveButton(LootCount_LastMenuButton);
end


function LootCount_SetFrame()
	if (LootCount_Populated.FadeFrame) then LootCount_Populated.FadeFrame=nil; else LootCount_Populated.FadeFrame=true; end
	LootCount_ShowFrame(true);
end


function LootCount_TextSizeFromMenu()
	LC_FONTHEIGHT=LC_FONTHEIGHT+this.value;
	LootCount_Populated.FontSize=LC_FONTHEIGHT;
	LootCount_SetSize(LOOTCOUNTSIZE);
end


function LootCount_SetPluginInterface()
	LootCount_Grabber=LOOTCOUNT_SPECIAL;
	LootCount_LastSpecial=this.value;
	LootCount_OnEnter(true);
end


function LootCount_IncludeAlts()
	if (LootCount_Populated.Alts) then
		LootCount_Populated.Alts=nil;
	else
		LootCount_Populated.Alts=true;
	end
	LootCount_UpdateItems(true);
end


function LootCount_SetGroup()
	if (LootCount_Populated.ExcludeGroup) then
		LootCount_Populated.ExcludeGroup=nil;
	else
		LootCount_Populated.ExcludeGroup=true;
		LootCount_DB={};
		LootCount_UpdateItems(true);
	end
end


function LootCount_SetBank()
	if (LootCount_Populated.IncludeBank) then LootCount_Populated.IncludeBank=nil; else LootCount_Populated.IncludeBank=true; end
	LootCount_UpdateItems();
end

function LootCount_SizeFromMenu()
	if (not this.value or this.value<20) then return; end
	LootCount_SetSize(this.value);
end


function LootCount_LockToggle()
	if (LootCount_Populated.Locked) then LootCount_Lock(false); else LootCount_Lock(true); end
	LootCount_UpdateItems();
end


-- Tooltip-button mouseover
function LootCount_Button_OnEnter()
	if (this.Special=="TOOLTIPICON") then return; end
	LootCount_ShowFrame(true);
--	if (LootCount_GIRCountButton) then LootCount_GIRCountButton:Hide(); end
	if (LootCount_GTTCountButton) then LootCount_GTTCountButton:Hide(); end
	if (this==LootCount_GrabLinkButton) then
		LootCount_GTTOwnTooltip=true;
		GameTooltip:SetOwner(this,"ANCHOR_RIGHT");
		GameTooltip:SetText("LootCount");
		GameTooltipTextLeft1:SetTextColor(1,1,1);
		GameTooltip:AddLine("1. Click this button to copy the item");
		GameTooltip:AddLine("2. Click any button in LootCount");
		GameTooltip:Show();
		return;
	end
	if (this.MO) then
		LootCount_GTTOwnTooltip=true;
		GameTooltip:SetOwner(this,"ANCHOR_RIGHT");
		GameTooltip:SetHyperlink(this.MO);

		local bags,bank,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10=LootCount_GetItemCount(this.itemID,false,true);
		local startlines=GameTooltip:NumLines();
		local endlines=startlines;
		GameTooltip:AddLine(" "); endlines=endlines+1; getglobal("GameTooltipTextLeft"..endlines):SetTextColor(1,1,1);
		GameTooltip:AddLine("Bags: "..bags.Count); endlines=endlines+1; getglobal("GameTooltipTextLeft"..endlines):SetTextColor(1,1,1);
		GameTooltip:AddLine("Bank: "..bank.Count); endlines=endlines+1; getglobal("GameTooltipTextLeft"..endlines):SetTextColor(1,1,1);
		if (not this.Local) then
			if (a1 and a1.Count>0) then GameTooltip:AddLine(a1.Name..": "..a1.Count); endlines=endlines+1; getglobal("GameTooltipTextLeft"..endlines):SetTextColor(1,1,1); end
			if (a2 and a2.Count>0) then GameTooltip:AddLine(a2.Name..": "..a2.Count); endlines=endlines+1; getglobal("GameTooltipTextLeft"..endlines):SetTextColor(1,1,1); end
			if (a3 and a3.Count>0) then GameTooltip:AddLine(a3.Name..": "..a3.Count); endlines=endlines+1; getglobal("GameTooltipTextLeft"..endlines):SetTextColor(1,1,1); end
			if (a4 and a4.Count>0) then GameTooltip:AddLine(a4.Name..": "..a4.Count); endlines=endlines+1; getglobal("GameTooltipTextLeft"..endlines):SetTextColor(1,1,1); end
			if (a5 and a5.Count>0) then GameTooltip:AddLine(a5.Name..": "..a5.Count); endlines=endlines+1; getglobal("GameTooltipTextLeft"..endlines):SetTextColor(1,1,1); end
			if (a6 and a6.Count>0) then GameTooltip:AddLine(a6.Name..": "..a6.Count); endlines=endlines+1; getglobal("GameTooltipTextLeft"..endlines):SetTextColor(1,1,1); end
			if (a7 and a7.Count>0) then GameTooltip:AddLine(a7.Name..": "..a7.Count); endlines=endlines+1; getglobal("GameTooltipTextLeft"..endlines):SetTextColor(1,1,1); end
			if (a8 and a8.Count>0) then GameTooltip:AddLine(a8.Name..": "..a8.Count); endlines=endlines+1; getglobal("GameTooltipTextLeft"..endlines):SetTextColor(1,1,1); end
			if (a9 and a9.Count>0) then GameTooltip:AddLine(a9.Name..": "..a9.Count); endlines=endlines+1; getglobal("GameTooltipTextLeft"..endlines):SetTextColor(1,1,1); end
			if (a10 and a10.Count>0) then GameTooltip:AddLine(a10.Name..": "..a10.Count); endlines=endlines+1; getglobal("GameTooltipTextLeft"..endlines):SetTextColor(1,1,1); end
		end
		local thetext=getglobal("GameTooltipTextLeft"..endlines);
		GameTooltip:SetHeight((GameTooltip:GetHeight()+(thetext:GetHeight()+2)*(endlines-startlines)));

	elseif (this.itemID==LOOTCOUNT_SPECIAL and LootCount_Plugin) then
		-- Plugin's tooltips
		if (LootCount_Plugin[this.Special] and LootCount_Plugin[this.Special].fTooltip) then
			LootCount_GTTOwnTooltip=true;
			LootCount_Plugin[this.Special].fTooltip(this);
		end
	end
	LootCount_OnEnter();
end


-- Generic chat-pane stuff
function LootCount_Chat(msg,r,g,b)
	if (DEFAULT_CHAT_FRAME) then
		if (not r and not g and not b) then r=1; g=1; b=1; end;
		if (not r) then r=0; end;
		if (not g) then g=0; end;
		if (not b) then b=0; end;
		DEFAULT_CHAT_FRAME:AddMessage("LootCount: "..msg,r,g,b);
	end
end

-- Duh
function LootCount_ToggleMainFrame()
	if (LootCount_Frame0:IsVisible()) then
		LootCount_Frame0:Hide();
		LootCount_Populated.Visible=nil;
		if (LootCount_GIRCountButton) then LootCount_GIRCountButton:Hide(); end
		if (LootCount_GTTCountButton) then LootCount_GTTCountButton:Hide(); end
	else
		LootCount_Frame0:Show();
		LootCount_Populated.Visible=true;
		LootCount_ShowFrame(true);
	end
end
