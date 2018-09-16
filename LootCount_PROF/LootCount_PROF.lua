--[[****************************************************************
	LootCount Profession v0.10

	Author: Evil Duck
	****************************************************************

	Plug-in for the World of Warcraft add-on LootCount.

	****************************************************************]]

-- 0.10 First version


LOOTCOUNT_PROF_VERSIONTEXT = "LootCount Profession XP v0.10";
LOOTCOUNT_PROF = "LootCount Profession";
local LootCount_PROF_Registered=nil;
local LCPR_Decode = {
	Pre="",
	Mid="",
	End="",
}
local LCPR_Button_Menu;
local LCPR_Button_This;
LCPR_SkillName = {
};
LCPR_PlayerSkill = {
};


-- Set up for handling
function LootCount_PROF_OnLoad()
	this:RegisterEvent("CHAT_MSG_SKILL");

	LCPR_Button_Menu=CreateFrame("Frame","LCPR_Button_MenuFrame",nil,"UIDropDownMenuTemplate");
--	LCPR_Button_Menu:SetPoint("LEFT",Minimap);
	UIDropDownMenu_Initialize(LCPR_Button_Menu,LCPR_Button_Menu_Initialise,"MENU");

	local text=string.format(ERR_SKILL_UP_SI,"PROFTEXT",12345);
	local s1,e1=string.find(text,"PROFTEXT");
	local s2,e2=string.find(text,"12345");
	if (s1>1) then LCPR_Decode.Pre=string.sub(text,1,s1-1); end
	if (e1<(s2-2)) then LCPR_Decode.Mid=string.sub(text,e1+1,s2-1); end
	LCPR_Decode.End=string.sub(text,e2+1); if (not LCPR_Decode.End) then LCPR_Decode.End=""; end
end


-- An event has been received
function LootCount_PROF_OnEvent(event)
	if (event=="CHAT_MSG_SKILL") then
		local prof,val=arg1:match(LCPR_Decode.Pre.."(.+)"..LCPR_Decode.Mid.."(%d+)"..LCPR_Decode.End);
		val=tonumber(val);
		if (not val or val<=0) then return; end
		if (not prof) then return; end
		if (not LCPR_SkillName[prof]) then LCPR_SkillName[prof]=true; end
		LCPR_PlayerSkill[prof]=val;
		LootCountAPI.Force(LOOTCOUNT_PROF);
		return;
	end
end


function LCPR_Menu_WarnTrainer()
	if (not LCPR_Button_This) then return; end
	if (not LCPR_Button_This.User) then LCPR_Button_This.User={}; end
	if (LCPR_Button_This.User.Warn) then LCPR_Button_This.User.Warn=nil; else LCPR_Button_This.User.Warn=true; end
	LootCountAPI.Save(LOOTCOUNT_PROF);
	LootCountAPI.Force(LOOTCOUNT_PROF);
	LootCount_PROF_UpdateButton(LCPR_Button_This);
end


function LCPR_Menu_AddOption(text,func)
	local info=UIDropDownMenu_CreateInfo();
	if (not func) then info.isTitle=1; end
	info.text=text;
	info.func=func;
	info.value=text;
	UIDropDownMenu_AddButton(info,1);
end

function LCPR_Button_Menu_Initialise()
	LCPR_Button_Menu:SetParent(this);
	LCPR_Button_Menu:SetPoint("LEFT",this);

	if (LCPR_Button_This and LCPR_Button_This.User and LCPR_Button_This.User.Warn) then
		LCPR_Menu_AddOption("|cFF00FF00Trainer warning",LCPR_Menu_WarnTrainer);
	else
		LCPR_Menu_AddOption("Trainer warning",LCPR_Menu_WarnTrainer);
	end
	LCPR_Menu_AddOption(" ");
	local sname,sval;
	for sname,sval in pairs(LCPR_SkillName) do
		LCPR_Menu_AddOption(sname,LCPR_Settings_SetSkill);
	end
end

function LCPR_Settings_SetSkill()
	if (not LCPR_Button_This.User) then LCPR_Button_This.User={}; end
	LCPR_Button_This.User.Skill=this.value;
	LCPR_Button_This.User.Label=string.sub(this.value,1,3);
	LootCountAPI.Save(LOOTCOUNT_PROF);
	LootCountAPI.Force(LOOTCOUNT_PROF);
	LootCount_PROF_UpdateButton(LCPR_Button_This);
end


function LootCount_PROF_Clicker(button,LR,count)
	if (LR=="RightButton" and count==1) then
		LCPR_Button_This=button;
		ToggleDropDownMenu(1,nil,LCPR_Button_Menu,button,0,0);
	end
end


function LootCount_PROF_UpdateButton(button)
	if (not button) then return; end			-- End of iteration

	if (not button.User) then return; end
	if (not button.User.Skill) then return; end
	local value;
	if (not LCPR_PlayerSkill[button.User.Skill]) then value="?";
	else value=LCPR_PlayerSkill[button.User.Skill]; end
	if (button.User.Warn and type(value)=="number") then
		local warn=nil;
		if (value>=70 and value<=75) then warn=true; end
		if (value>=145 and value<=150) then warn=true; end
		if (value>=220 and value<=225) then warn=true; end
		if (value>=295 and value<=300) then warn=true; end
		if (warn) then value="|cFFFF3030"..value.."|r"; end
	end
	LootCountAPI.SetData(LOOTCOUNT_PROF,button,value,button.User.Label);
end


function LootCount_PROF_Tooltip(button)
	GameTooltip:SetOwner(button,"ANCHOR_RIGHT");
	if (button.User and button.User.Skill) then GameTooltip:SetText("Profession: "..button.User.Skill);
	else GameTooltip:SetText("Display a profession's current level"); end
	GameTooltip:AddLine("Right-click to select profession",1,1,1);
	GameTooltip:Show();
end



function LootCount_PROF_OnUpdate(elapsed)
	if (LootCount_PROF_Registered) then
		return;
	end
	if (not LootCountAPI or not LootCountAPI.Register) then return; end
	
	local info = {
		Name=LOOTCOUNT_PROF,
		Update=LootCount_PROF_UpdateButton,
		Clicker=LootCount_PROF_Clicker,
		Texture="Interface\\InventoryItems\\WoWUnknownItem01",
		ColorTop={ r=0, g=1, b=1 },
		Tooltip=LootCount_PROF_Tooltip
	};
	LootCountAPI.Register(info);
	LootCount_PROF_Registered=true;
end
