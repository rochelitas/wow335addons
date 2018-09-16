-- Chinese Simplified by q09q09
-- q09q09' Profile: http://wiki.cwowaddon.com/%E6%80%A5%E4%BA%91
-- Last Update 09/04/2008
if ( GetLocale() == "zhCN" ) then
	SCCN_INIT_CHANNEL_LOCAL			= "常规";
	SCCN_GUI_HIGHLIGHT1				= "在这对话输入你要 SCCN 显示的词。 每行输入一个词";
	SCCN_LOCAL_CLASS["WARLOCK"] 	= "Warlock";
	SCCN_LOCAL_CLASS["HUNTER"] 	= "Hunter";
	SCCN_LOCAL_CLASS["PRIEST"] 	= "Priest";
	SCCN_LOCAL_CLASS["PALADIN"] 	= "Paladin";
	SCCN_LOCAL_CLASS["MAGE"] 	= "Mage";
	SCCN_LOCAL_CLASS["ROGUE"] 	= "Rogue";
	SCCN_LOCAL_CLASS["DRUID"] 	= "Druid";
	SCCN_LOCAL_CLASS["SHAMAN"] 	= "Shaman";
	SCCN_LOCAL_CLASS["WARRIOR"] 	= "Warrior";
	SCCN_LOCAL_CLASS["DEATHKNIGHT"]	= "Deathknight";
	--  Female Classnames
	-- What the heck are the Engliosh female names for the classes ? How do you say to "Hexenmeisterin" ?
	SCCN_LOCAL_CLASS["WARLOCKF"]	= "术士";
	SCCN_LOCAL_CLASS["HUNTERF"]	= "猎人";
	SCCN_LOCAL_CLASS["PRIESTF"]	= "牧师";
	SCCN_LOCAL_CLASS["MAGEF"]	= "法师";
	SCCN_LOCAL_CLASS["ROGUEF"]	= "潜行者";
	SCCN_LOCAL_CLASS["DRUIDF"]	= "德鲁伊";
	SCCN_LOCAL_CLASS["SHAMANF"]	= "萨满祭司";
	SCCN_LOCAL_CLASS["WARRIORF"]	= "战士";
	SCCN_LOCAL_CLASS["DEATHKNIGHTF"]= "死亡骑士";
	SCCN_LOCAL_CLASS["PALADINF"]	= "圣骑士";

	-- Zones
	SCCN_LOCAL_ZONE["alterac"]	= "奥特兰克山谷";
	SCCN_LOCAL_ZONE["warsong"]	= "战歌峡谷";
	SCCN_LOCAL_ZONE["arathi"]	= "阿拉希盆地";
	SCCN_CONFAB			= "|cffff0000你有安装Confab。为了兼容性，SCCN的输入框相关功能取消！";
	SCCN_HELP[1]			= "Sol's Color chat Nicks - 指令说明:";
	SCCN_HELP[2]			= "|cff68ccef".."/chatmod hidechanname".."\n|cffffffff".." 隐藏频道名称";
	SCCN_HELP[3]			= "|cff68ccef".."/chatmod colornicks".."\n|cffffffff".." 以职业颜色显示玩家名字";
	SCCN_HELP[4]			= "|cff68ccef".."/chatmod purge".."\n|cffffffff".." 整理SCCN数据库。 |cffa0a0a0(每次载入此ui时都会自动执行这个动作。)";
	SCCN_HELP[5]			= "|cff68ccef".."/chatmod killdb".."\n|cffffffff".." 完整地把SCCN数据库清除。 (无法复原)";
	SCCN_HELP[6]			= "|cff68ccef".."/chatmod mousescroll".."\n|cffffffff".." 使用鼠标滚轮滚动对话框。 \n|cffa0a0a0(按住<SHIFT>-鼠标滚轮=快翻，按住<CTRL>-鼠标滚轮=翻至尽头, <STRG>-Molette = Top, Bottom)";
	SCCN_HELP[7]			= "|cff68ccef".."/chatmod topeditbox".."\n|cffffffff".." 对话输入框显示在聊天窗口的上面。";
	SCCN_HELP[8]			= "|cff68ccef".."/chatmod timestamp".."\n|cffffffff".." 显示时间戳在每条信息之前。输入|cffa0a0a0 /chatmod timestamp ?|cffffffff 显示更改格式说明。";
	SCCN_HELP[9]			= "|cff68ccef".."/chatmod colormap".."\n|cffffffff".." 小地图上的团队成员以职业颜色标记。";
	SCCN_HELP[10]			= "|cff68ccef".."/chatmod hyperlink".."\n|cffffffff".." 让对话消息里的URL可被选择复制！";
	SCCN_HELP[11]			= "|cff68ccef".."/chatmod selfhighlight".."\n|cffffffff".." 在对话消息中把自己名字明显标示！";
	SCCN_HELP[12]			= "|cff68ccef".."/chatmod clickinvite".."\n|cffffffff".." 让对话消息中的[邀请]能直接被点选以加入队伍。";
	SCCN_HELP[13] 			= "|cff68ccef".."/chatmod editboxkeys".."\n|cffffffff".." 在对话输入框里不需要按住<ALT>键\n|cffa0a0a0就能用方向键做编辑 & 历史纪录缓冲区增加至256行！";
	SCCN_HELP[14] 			= "|cff68ccef".."/chatmod chatstring".."\n|cffffffff".." 简化密语字符串。";
	SCCN_HELP[15] 			= "|cff68ccef".."/chatmod selfhighlightmsg".."\n|cffffffff".." 包含自己名字的对话消息会另外显示在屏幕上方，须开启 /chatmod selfhighlight";
	SCCN_HELP[16]			= "|cff68ccef".."/chatmod hidechatbuttons".."\n|cffffffff".." 隐藏聊天按钮。";
	SCCN_HELP[17]			= "|cff68ccef".."/chatmod highlight".."\n|cffffffff".." 在聊天中高亮显示自定义词.";
	SCCN_HELP[19]			= "|cff68ccef".."/chatmod shortchanname ".."\n|cffffffff".." 显示简略频道名.";
	SCCN_HELP[20]			= "|cff68ccef".."/chatmod autogossipskip ".."\n|cffffffff".." 自动跳过闲谈窗口. |cffa0a0a0(按住 <CTRL> 则撤销跳过)";
	SCCN_HELP[21]			= "|cff68ccef".."/chatmod autodismount ".."\n|cffffffff".." 与飞行点管理员对话时自动下马";
	SCCN_HELP[22]			= "|cff68ccef".."/chatmod inchathighlight ".."\n|cffffffff".."高亮已知昵称";
	SCCN_HELP[23]			= "|cff68ccef".."/chatmod sticky ".."\n|cffffffff".."保持上次对话动作";
	SCCN_HELP[24]			= "|cff68ccef".."/chatmod initchan <channelname>".."\n|cffffffff".."起动时设置指定的<频道名>在默认聊天框.";
	SCCN_HELP[25]			= "|cff68ccef".."/chatmod nofade".."\n|cffffffff".."关闭聊天文字淡出";
	SCCN_HELP[26]			= "|cff68ccef".."/chatmod chaticon".."\n|cffffffff".."显示/关闭文字滚动提示图标";
	SCCN_HELP[27]			= "|cff68ccef".."/chatmod showlevel".."\n|cffffffff".."显示/关闭名字处显示等级";
	SCCN_HELP[28]			= "|cff68ccef".."/chatmod chatcolorname".."\n|cffffffff".."显示/关闭聊天文本中名字着色";

	SCCN_HELP[99]					= "|cff68ccef".."/chatmod status".."|cffffffff".."\n 显示目前设置。";
	SCCN_TS_HELP  			= "|cff68ccef".."/chatmod timestamp |cffFF0000FORMAT|cffffffff\n".."格式:\n$h = 小时 (0-24) \n$t = 小时 (0-12) \n$m = 分钟 \n$s = 秒 \n$p = 上午/下午 (am / pm)\n".."|cff909090例如: /chatmod timestamp [$t:$m:$s $p]";
	SCCN_CMDSTATUS[1]		= "隐藏频道名称:";
	SCCN_CMDSTATUS[2]		= "以职业颜色显示玩家名字:";
	SCCN_CMDSTATUS[3]		= "使用鼠标滚轮滚动对话框:";
	SCCN_CMDSTATUS[4]		= "对话输入框顶置:";
	SCCN_CMDSTATUS[5]		= "加入消息时间:";
	SCCN_CMDSTATUS[6]		= "小地图上的队伍成员以职业颜色标记:";
	SCCN_CMDSTATUS[7]		= "URL可点选复制:";
	SCCN_CMDSTATUS[8]		= "明显标示自己的名字:";
	SCCN_CMDSTATUS[9]		= "对话框中的邀请信息可以被点选:";
	SCCN_CMDSTATUS[10]		= "对话编辑不需按住<ALT>:";
	SCCN_CMDSTATUS[11]		= "自定密语消息:";
	SCCN_CMDSTATUS[12]		= "额外显示包含自己名字的消息:";
	SCCN_CMDSTATUS[13]		= "隐藏聊天按钮:";
	SCCN_CMDSTATUS[14] 		= "战场自动打开小地图:";
	SCCN_CMDSTATUS[15] 		= "自定义高亮:";
	SCCN_CMDSTATUS[16] 		= "简略频道名:";
	SCCN_CMDSTATUS[17]		= "闲谈自动跳过:";
	SCCN_CMDSTATUS[18]		= "自动下马:";
	SCCN_CMDSTATUS[19]				= "聊天中高亮:";
	SCCN_CMDSTATUS[20]				= "记住上次聊天室(粘滞):";
	SCCN_CMDSTATUS[21]				= "不使用聊天文字自动淡出:";
	SCCN_CMDSTATUS[22]				= "聊天滚动图标:";
	SCCN_CMDSTATUS[23]				= "名字处显示等级:";
	SCCN_CMDSTATUS[24]      = "聊天文字中名字着色:";
	SCCN_CMDSTATUS[25]              = "聊天图标标记:";
	SCCN_CMDSTATUS[26]				= "only Highlight full words:";
	-- cursom invite word in the local language
	SCCN_CUSTOM_INV[0]		= "邀请";
	SCCN_CUSTOM_INV[1] 		= "邀请";
	-- Whispers customized
	SCCN_CUSTOM_CHT_FROM		= "%s说：";
	SCCN_CUSTOM_CHT_TO		= "密%s：";
	-- hide this channels aditional, feel free to add your own
	SCCN_STRIPCHAN[1]		= "公会";
	SCCN_STRIPCHAN[2]		= "团队";
	SCCN_STRIPCHAN[3]		= "小队";
	SCCN_STRIPCHAN[4]		= "本地防务";
	SCCN_STRIPCHAN[5]		= "世界防务";
	SCCN_STRIPCHAN[6]		= "寻求组队";
	SCCN_STRIPCHAN[7]		= "交易";
	SCCN_STRIPCHAN[8]		= "综合";
	SCCN_STRIPCHAN[9]		= "战场";
-- ItemLink Channels
    SCCN_ILINK[1]                   = "综合 -";
    SCCN_ILINK[2]                   = "交易 -"
    SCCN_ILINK[3]                   = "寻求组队 -";
    SCCN_ILINK[4]                   = "本地防务 -";
    SCCN_ILINK[5]                   = "世界防务";
	-- some general channel name translation for the GUI
	SCCN_TRANSLATE[1]				= "工会";
	SCCN_TRANSLATE[2]				= "官员";
	SCCN_TRANSLATE[3]				= "小队";
	SCCN_TRANSLATE[4]				= "团队";
	SCCN_TRANSLATE[5]				= "密语";
	SCCN_Highlighter				= "ChatMOD 高亮";
	SCCN_Config						= "ChatMOD 设置";
	SCCN_Changelog					= "ChatMOD 更新日志";
	SCCN_NewVer                     = "发现 ChatMOD 新版本.请检查更新www.solariz.de";

end