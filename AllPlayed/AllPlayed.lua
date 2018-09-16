local AP_display_name, AP = ...

-- AllPlayed.lua
-- $Id: AllPlayed.lua 207 2010-03-01 03:44:13Z LaoTseu $

if not AllPlayed_revision then AllPlayed_revision = {} end
AllPlayed_revision.main	= ("$Revision: 207 $"):match("(%d+)")
AllPlayed_revision.toc  = GetAddOnMetadata("AllPlayed", "Version"):match("%$Revision:%s(%d+)")


--[[ ================================================================= ]]--
--[[                     Addon Initialisation                          ]]--
--[[ ================================================================= ]]--

-- Define static values for the addon
-- Ten days in second, needed to estimate the rested XP
local TEN_DAYS  = 60 * 60 * 24 * 10

-- Prototypes for local functions
--local AllPlayed.GetClassHexColour				-- AllPlayed.GetClassHexColour(class)

-- Load external libraries

-- L is for localisation (to allow translation of the addon)
local L = LibStub("AceLocale-3.0"):GetLocale("AllPlayed")
-- A is for time and money formating functions
local A = LibStub("LibAbacus-3.0")
-- C is for colour management functions
local C = LibStub("LibCrayon-3.0")
-- LibDataBroker
local ldb = LibStub:GetLibrary("LibDataBroker-1.1", true)
-- LibDBIcon
local ldbicon = LibStub("LibDBIcon-1.0")
-- LibQTip
local lqt = LibStub("LibQTip-1.0")

-- Class colours
local CLASS_COLOURS = {}

-- Local cache
local XPToNextLevelCache = {}

-- Creation fo the main "object" with librairies (mixins) directly attach to the object (use self:functions)
AllPlayed = LibStub("AceAddon-3.0"):NewAddon("AllPlayed", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0")

-- For debuging
--AllPlayed.AP = AP
AllPlayed.debugging = false
function AllPlayed:Debug(msg,...)
	if not self.debugging then return end
	geterrorhandler()(format(msg,...))
end

-- Local function prototypes
local AcquireTable
local ReleaseTable
local ClearTable
local FormatXP
local FormatMoney
local FormatHonor
local FactionColour
local PercentColour
local ClassColour
local FormatCharacterName
local buildSortedTable
local PCSortByLevel
local PCSortByRevLevel
local PCSortByXP              
local PCSortByRevXP
local PCSortByRestedXP
local PCSortByRevRestedXP
local PCSortByPercentRest
local PCSortByRevPercentRest
local PCSortByCoin
local PCSortByRevCoin
local PCSortByRevTimePlayed
local PCSortByTimePlayed
local XPToLevel
local InitXPToLevelCache
local XPToNextLevel
local MXP

--[[ ================================================================= ]]--
--[[                        Util Functions                             ]]--
--[[ ================================================================= ]]--

do
	local table_cache = {}

	-- Returns a table
	function AcquireTable()
		local tbl = tremove(table_cache) or {}
		return tbl
	end

	-- Cleans the table and stores it in the cache
	function ReleaseTable(tbl)
		if not tbl then return end
		
		-- Nested tables ?
		for i=1,#tbl do
			if type(tbl[i]) == "table" then ReleaseTable(tbl[i]) end
		end
		
		wipe(tbl)
		tinsert(table_cache, tbl)
	end
	
	-- Release and Acquire in one go
	function ClearTable(tbl)
		ReleaseTable(tbl)
		return AcquireTable()
	end
end	-- do block

--[[ ================================================================= ]]--
--[[                      Ace Framework Init                           ]]--
--[[ ================================================================= ]]--

-- Default values for the save variables
default_options = {
	global = {
		data = {
			-- Faction
			['*'] = {
				-- Realm
				['*'] = {
					-- Name
					['*'] = {
						class                      = "",   -- English class name
						class_loc                  = "",   -- Localized class name
						level                      = 0,
						coin                       = 0,
						rested_xp                  = 0,
						xp                         = -1,
						max_rested_xp              = 0,
						last_update                = 0,
						is_resting                 = false,
						seconds_played             = 0,
						seconds_played_last_update	= 0,
						zone_text                  = L["Unknown"],
						subzone_text               = "",
						arena_points					= 0,
						honor_points					= 0,
						highest_rank					= nil,
						honor_kills						= 0,
					}
				}
			}
		},
		cache = {
			XPToNextLevel = {
				-- Build version
				['*'] = {}
			}
		},
	},
	profile = {
		options = {
			all_factions               = true,
			all_realms                 = true,
			show_coins						= true,
			show_played_time				= true,
			show_seconds               = false,
			show_progress              = true,
			show_rested_xp             = false,
			percent_rest               = "100",
			show_rested_xp_countdown   = true,
			refresh_rate               = 20,
			show_class_name            = true,
			colorize_class             = true,
			use_pre_210_shaman_colour	= false,
			show_location              = "none",
			show_xp_total              = true,
			show_arena_points				= false,
			show_honor_points				= false,
			show_honor_kills				= false,
			show_pvp_totals				= false,
			tooltip_scale					= 1,
			opacity							= .9,
			sort_type						= "alpha",
			use_icons						= false,
			is_ignored = {
				-- Realm
				['*'] = {
					-- Name
					['*'] = false,
				},
			},
			ldbicon = {
			  hide = nil,
			},
		},
	},
}


-- This function is called by the Ace2 framework one time after the addon is loaded
function AllPlayed:OnInitialize()
	-- code here, executed only once.
   --self:SetDebugging(true) -- to have debugging through your whole app.

	-- Initialize the SaveVariables table if it's the first time that AllPlayed is loaded
	AllPlayedDB = AllPlayedDB or {}


	-- Register the command line
	-- /ap and /allplayed will open the blizard interface panel
	SLASH_ALLPLAYED_CONFIG1 = L["/ap"]
	SLASH_ALLPLAYED_CONFIG2 = L["/allplayed"]
	SlashCmdList["ALLPLAYED_CONFIG"] = function()
		InterfaceOptionsFrame_OpenToCategory(AP_display_name)
	end
	
	-- Conversion of old data
	AllPlayedDB.global = AllPlayedDB.global or {}
	if AllPlayedDB.global.data_version ~= "30300-2" and AllPlayedDB.account then
	
		local function tcopy(t)
		  local t2 = AcquireTable()
		  for k,v in pairs(t) do
		  	 if type(v) == 'table' then
		  	 	t2[k] = tcopy(v)
		  	 else
		  	 	t2[k] = v
		  	 end
		  end
		  return t2
		end
	
		AllPlayedDB.global = tcopy(AllPlayedDB.account)
		AllPlayedDB.profiles = nil
		AllPlayedDB.currentProfile = nil
		AllPlayedDB.global.data_version = "30300-2"
	end

	-- Register the varibles with the defaults
	self.db = LibStub("AceDB-3.0"):New("AllPlayedDB", default_options, true)
	self.db.RegisterCallback(self, "OnProfileChanged", "RefreshConfig")
	self.db.RegisterCallback(self, "OnProfileCopied", "RefreshConfig")
	self.db.RegisterCallback(self, "OnProfileReset", "RefreshConfig")
	
	-- Initial setup is done by OnEnable (not mush to do here)
	-- We set total variables to zero and create the tables that will never
	-- be deleted
	self.total_faction      = { ["Horde"]    = { time_played = 0, coin = 0 },
									    ["Alliance"] = { time_played = 0, coin = 0 },
	}
	self.total_realm        = { }
	self.total              = { time_played = 0, coin = 0, xp = 0 }

	self.sort_tables_done    = false

	-- Initialize the cache
	InitXPToLevelCache()
end

function AllPlayed:OnEnable()

    --self:Debug("AllPlayed:OnEnable()")

    -- code here, executed after everything is loaded.
    
    -- Configuration initialization
    AP.db = self.db
    AP.InitConfig()

    -- Register the events we need
    -- (event unregistering is done automagicaly by ACE)
    self:RegisterEvent("TIME_PLAYED_MSG",       		"OnTimePlayedMsg")
    self:RegisterEvent("PLAYER_LEVEL_UP",       		"EventHandlerWithSort")
    self:RegisterEvent("PLAYER_XP_UPDATE",      		"EventHandlerWithSort")
    self:RegisterEvent("ZONE_CHANGED_NEW_AREA", 		"EventHandler")
    self:RegisterEvent("ZONE_CHANGED",          		"EventHandler")
    self:RegisterEvent("MINIMAP_ZONE_CHANGED",  		"EventHandler")
    if(self:GetOption('show_coins')) then
    	self:RegisterEvent("PLAYER_MONEY",      "EventHandler")
    end
    self:RegisterEvent("CHAT_MSG_COMBAT_HONOR_GAIN",  "EventHandlerHonorGain")

    -- Hook the functions that need hooking
    self:Hook("Logout", true)
    self:Hook("Quit",   true)

    -- Initialize values that don't change between reloads
    self.faction, self.loc_faction	= UnitFactionGroup("player")
    self.realm      						= GetRealmName()
    self.pc         						= UnitName("player")

    -- Initial update of values

	 -- Class colours
	 CLASS_COLOURS['DEATHKNIGHT']	= AllPlayed.GetClassHexColour("DEATHKNIGHT")
	 CLASS_COLOURS['DRUID']      	= AllPlayed.GetClassHexColour("DRUID")
	 CLASS_COLOURS['HUNTER']     	= AllPlayed.GetClassHexColour("HUNTER")
	 CLASS_COLOURS['MAGE']       	= AllPlayed.GetClassHexColour("MAGE")
	 CLASS_COLOURS['PALADIN']    	= AllPlayed.GetClassHexColour("PALADIN")
	 CLASS_COLOURS['PRIEST']     	= AllPlayed.GetClassHexColour("PRIEST")
	 CLASS_COLOURS['ROGUE']      	= AllPlayed.GetClassHexColour("ROGUE")
	 CLASS_COLOURS['WARLOCK']    	= AllPlayed.GetClassHexColour("WARLOCK")
	 CLASS_COLOURS['WARRIOR']    	= AllPlayed.GetClassHexColour("WARRIOR")

	 CLASS_COLOURS['PRE-210-SHAMAN'] = "00dbba"


    -- What colour should be used for Shaman?
    if(self:GetOption('use_pre_210_shaman_colour')) then
    	CLASS_COLOURS['SHAMAN'] = CLASS_COLOURS['PRE-210-SHAMAN']
    else
		CLASS_COLOURS['SHAMAN'] = AllPlayed.GetClassHexColour("SHAMAN")
    end

    -- Find the max level
    self.max_pc_level = 60  +  10 * GetAccountExpansionLevel()

    -- Get the values for the current character
    self:SaveVar()

    -- Compute Honor at least once (it will be computed only if it change afterward
    self:ComputeTotalHonor()

    -- Build the sorting tables
  	 self:BuildSortTables()

    -- Request the time played so we can populate seconds_played
    self:RequestTimePlayed()

	-- Set the callback for !ClassColor if present
	if CUSTOM_CLASS_COLORS then
		CUSTOM_CLASS_COLORS:RegisterCallback(function()
			for class in pairs(CUSTOM_CLASS_COLORS) do
				 CLASS_COLOURS[class] = AllPlayed.GetClassHexColour(class)
			end

			-- Check again for the Shamy colour
			if(AllPlayed:GetOption('use_pre_210_shaman_colour')) then
				CLASS_COLOURS['SHAMAN'] = CLASS_COLOURS['PRE-210-SHAMAN']
			else
				CLASS_COLOURS['SHAMAN'] = AllPlayed.GetClassHexColour("SHAMAN")
			end

		end)
	end

   -- Start the timer event to get an OnDataUpdate, OnUpdateText and OnUpdateTooltip every second
   -- or 20 seconds depending on the refresh_rate setting
	--self:ScheduleRepeatingEvent(self.name, self.MyUpdate, self:GetOption('refresh_rate'), self)
	self.timer = self:ScheduleRepeatingTimer("MyUpdate", self:GetOption('refresh_rate'))

	-- Create a frame with an OnUpdate event to deal with the disposal of the tooltip created for LDB 
	self.OnUpdate_frame = CreateFrame("frame")
	self.OnUpdate_frame:Hide() -- to prevent the OnUpdate until it is needed.
	self.elapsed = 0
	self.OnUpdate_frame:SetScript("OnUpdate", function(self, elap)
		AllPlayed.elapsed = AllPlayed.elapsed + elap
		
		if AllPlayed.elapsed < .2 then return end
		if (AllPlayed.tooltip and AllPlayed.tooltip:IsMouseOver()) or
		   (AllPlayed.tooltip_anchor and AllPlayed.tooltip_anchor:IsMouseOver()) then
		   AllPlayed.elapsed = 0
		   return
		end
		   
		AllPlayed.tooltip = lqt:Release(AllPlayed.tooltip)
		AllPlayed.tooltip_anchor = nil
		AllPlayed.OnUpdate_frame:Hide()
	end)
	
	-- LDB Minimap Icon support (for users without a LDB Broker)
	ldbicon:Register("AllPlayed", AllPlayedLDB, self.db.profile.options.ldbicon)

	self:MyUpdate()
end

function AllPlayed:OnDisable()
	self:CancelScheduledEvent(self.name)
end

function AllPlayed:IsDebugging() return self.db.profile.debugging end
function AllPlayed:SetDebugging(debugging) self.db.profile.debugging = debugging; self.debugging = debugging; end


--[[ ================================================================= ]]--
--[[                       Update Functions                            ]]--
--[[ ================================================================= ]]--

function AllPlayed:MyUpdate(...)
	self:Debug("MyUpdate: %d",time())

	self:OnDataUpdate()
   AllPlayedLDB.text = self:FormatTime(self.total.time_played)
   
   if self.tooltip then
		self:DrawTooltip()		
	end
end


function AllPlayed:OnDataUpdate()
    --self:Debug("AllPlayed:OnDataUpdate()")

    -- Update the data that may have changed but are not tracked by an event
    self.db.global.data[self.faction][self.realm][self.pc].is_resting = IsResting()

    -- Recompute the totals
    self:ComputeTotal()
end

function AllPlayed:RefreshConfig()
	-- Reapply all the settings that change behavior
	self:SetOption('show_seconds',self:GetOption('show_seconds'))
	self:SetOption('show_coins',self:GetOption('show_coins'))
	self:SetOption('use_pre_210_shaman_colour',self:GetOption('use_pre_210_shaman_colour'))
	self:SetOption('tooltip_scale',self:GetOption('tooltip_scale'))
	self:SetOption('opacity',self:GetOption('opacity'))
	self:SetOption('show_minimap_icon',self:GetOption('show_minimap_icon'))
	
	-- Recompute all the totals
	self:ComputeTotal()
	self:ComputeTotalHonor()
end

--[[ ================================================================= ]]--
--[[              Functions specific to the addon                      ]]--
--[[ ================================================================= ]]--

-- Get the totals per faction and realm
function AllPlayed:ComputeTotal()
    self:Debug("AllPlayed:ComputeTotal(): %d",time())

    -- Let's start from scratch
    self.total_faction["Horde"].time_played      = 0
    self.total_faction["Horde"].coin             = 0
    self.total_faction["Horde"].xp               = 0
    self.total_faction["Alliance"].time_played   = 0
    self.total_faction["Alliance"].coin          = 0
    self.total_faction["Alliance"].xp            = 0
    self.total.time_played                       = 0
    self.total.coin                              = 0
    self.total.xp                                = 0

    -- Let all the factions, realms and PC be counted
    for faction, faction_table in pairs(self.db.global.data) do
        for realm, realm_table in pairs(faction_table) do
            --self:Debug("faction: %s realm: %s", faction, realm)

            if not self.total_realm[faction] then self.total_realm[faction] = {} end
            if not self.total_realm[faction][realm] then self.total_realm[faction][realm] = {} end
            self.total_realm[faction][realm].time_played = 0
            self.total_realm[faction][realm].coin = 0
            self.total_realm[faction][realm].xp = 0
            for pc, pc_table in pairs(realm_table) do
                if not self:GetOption('is_ignored', realm, pc) then
						-- Need to get the current seconds_played for the PC
						local seconds_played = self:EstimateTimePlayed(pc,
																		realm,
																		pc_table.seconds_played,
																		pc_table.seconds_played_last_update
												)

						local pc_xp = pc_table.xp
						if (pc_xp ==-1) then pc_xp = 0 end

						if (pc_table.level == self.max_pc_level) then pc_xp = 0 end

						pc_xp = pc_xp + XPToLevel(pc_table.level)

						self.total_faction[faction].time_played         = self.total_faction[faction].time_played       + seconds_played
						self.total_faction[faction].coin                = self.total_faction[faction].coin              + pc_table.coin
						self.total_faction[faction].xp                  = self.total_faction[faction].xp                + pc_xp
						self.total_realm[faction][realm].time_played    = self.total_realm[faction][realm].time_played  + seconds_played
						self.total_realm[faction][realm].coin           = self.total_realm[faction][realm].coin         + pc_table.coin
						self.total_realm[faction][realm].xp             = self.total_realm[faction][realm].xp           + pc_xp
                end
            end
        end
    end

    -- The Grand Total varies according to the options
    if self:GetOption('all_realms') then
        if self:GetOption('all_factions') then
            -- Everything count
            self.total.time_played
                =   self.total_faction["Horde"].time_played
                  + self.total_faction["Alliance"].time_played
            self.total.coin
                =   self.total_faction["Horde"].coin
                  + self.total_faction["Alliance"].coin
            self.total.xp
                =   self.total_faction["Horde"].xp
                  + self.total_faction["Alliance"].xp
        else
            -- Only the current faction count
            self.total.time_played = self.total_faction[self.faction].time_played
            self.total.coin        = self.total_faction[self.faction].coin
            self.total.xp          = self.total_faction[self.faction].xp
        end
    else
        -- Only the current realm count (all_factions is ignore)
        self.total.time_played = self.total_realm[self.faction][self.realm].time_played
        self.total.coin        = self.total_realm[self.faction][self.realm].coin
        self.total.xp          = self.total_realm[self.faction][self.realm].xp
    end
end

function AllPlayed:ComputeTotalHonor()
	--self:Debug("AllPlayed:ComputeTotalHonor()")

	self.total_faction["Horde"].honor_kills      			= 0
	self.total_faction["Horde"].honor_points     			= 0
	self.total_faction["Horde"].arena_points     			= 0

	self.total_faction["Alliance"].honor_kills   			= 0
	self.total_faction["Alliance"].honor_points  			= 0
	self.total_faction["Alliance"].arena_points  			= 0

	self.total.honor_kills                          			= 0
	self.total.honor_points                         			= 0
	self.total.arena_points                        				= 0

    -- Let all the factions, realms and PC be counted
    for faction, faction_table in pairs(self.db.global.data) do
        for realm, realm_table in pairs(faction_table) do
            --self:Debug("faction: %s realm: %s", faction, realm)

            if not self.total_realm[faction] then self.total_realm[faction] = {} end
            if not self.total_realm[faction][realm] then self.total_realm[faction][realm] = {} end

            self.total_realm[faction][realm].honor_kills = 0
            self.total_realm[faction][realm].honor_points = 0
            self.total_realm[faction][realm].arena_points = 0

            for pc, pc_table in pairs(realm_table) do
                if not self:GetOption('is_ignored', realm, pc) then
						self.total_faction[faction].honor_kills         	= self.total_faction[faction].honor_kills       	+ (pc_table.honor_kills or 0)
						self.total_faction[faction].honor_points        	= self.total_faction[faction].honor_points      	+ (pc_table.honor_points or 0)
						self.total_faction[faction].arena_points        	= self.total_faction[faction].arena_points      	+ (pc_table.arena_points or 0)

						self.total_realm[faction][realm].honor_kills    		= self.total_realm[faction][realm].honor_kills  			+ (pc_table.honor_kills or 0)
						self.total_realm[faction][realm].honor_points   		= self.total_realm[faction][realm].honor_points 			+ (pc_table.honor_points or 0)
						self.total_realm[faction][realm].arena_points   		= self.total_realm[faction][realm].arena_points 			+ (pc_table.arena_points or 0)
                end
            end
        end
    end

    -- The Grand Total varies according to the options
    if self:GetOption('all_realms') then
        if self:GetOption('all_factions') then
            -- Everything count
            self.total.honor_kills
                =   self.total_faction["Horde"].honor_kills
                  + self.total_faction["Alliance"].honor_kills
            self.total.honor_points
                =   self.total_faction["Horde"].honor_points
                  + self.total_faction["Alliance"].honor_points
            self.total.arena_points
                =   self.total_faction["Horde"].arena_points
                  + self.total_faction["Alliance"].arena_points
        else
            -- Only the current faction count
            self.total.honor_kills 				= self.total_faction[self.faction].honor_kills
            self.total.honor_points 			= self.total_faction[self.faction].honor_points
            self.total.arena_points 			= self.total_faction[self.faction].arena_points
        end
    else
        -- Only the current realm count (all_factions is ignore)
        self.total.honor_kills 				= self.total_realm[self.faction][self.realm].honor_kills
        self.total.honor_points  			= self.total_realm[self.faction][self.realm].honor_points
        self.total.arena_points  			= self.total_realm[self.faction][self.realm].arena_points
    end
end

-- Utility function to set the tooltip alpha
function AllPlayed:SetTTOpacity(opacity)
	if not self.tooltip then return end
	
	--for i=1,self.tooltip:GetColumnCount() do
	--	self.tooltip:SetColumnColor(i,0,0,0,opacity)
	--end
	
	self.tooltip:SetBackdropColor(0,0,0,opacity)
end

-- Fill the QTip witl the information
local col_text = {} -- reuse the table that is used over and over when drawing.
function AllPlayed:DrawTooltip(anchor)

	-- Keep the anchor for further use
	self.tooltip_anchor = anchor or self.tooltip_anchor

	-- Update the sort tables
	self:BuildSortTables()

	local first_category 		= true
	local nb_columns = 1

	-- Is the Location column needed?
	if self:GetOption('show_location') ~= "none" then
		nb_columns = nb_columns + 1
	end

	-- Do we have a PvP column?
	local need_pvp =	self:GetOption('show_arena_points') or
							self:GetOption('show_honor_points') or
							self:GetOption('show_honor_kills')

	if need_pvp then nb_columns = nb_columns + 1 end

	-- Is the gold/rested XP column needed?
	if self:GetOption('show_coins')
		or self:GetOption('show_xp_total')
		or self:GetOption('show_rested_xp')
		or self:GetOption('show_rested_xp_countdown')
		or self:GetOption('percent_rest') ~= "0" then
		nb_columns = nb_columns + 1
	end
	
	if not self.tooltip then
		self.tooltip = lqt:Acquire("AllPlayedTooltip", nb_columns)
	end
	
	local tooltip = self.tooltip
	
	-- Set the scale
	tooltip:SetScale(self:GetOption('tooltip_scale'))

	tooltip:Clear()

	tooltip:SmartAnchorTo(self.tooltip_anchor)
	
	local line, column = tooltip:AddHeader()
	tooltip:SetCell(line, 1, C:White(L["All Played Breakdown"]), "CENTER", nb_columns)
	tooltip:AddSeparator()
	
	-- We group by factions, then by realm, then by PC
	for _, faction in ipairs (self.sort_faction) do
		-- We do not print the faction if no option to select it is on
		-- and if the time played for the faction = 0 since this means
		-- all PC in the faction are ingored.
		if ((self:GetOption('all_factions') or self.faction == faction)
			  and self.total.time_played ~= 0
			  and self.sort_faction_realm[self:GetOption('display_sort_type')][faction]
		) then
			for _, realm in ipairs(self.sort_faction_realm[self:GetOption('display_sort_type')][faction]) do
				-- We do not print the realm if no option to select it is on
				-- and if the time played for the realm = 0 since this means
				-- all PC in the realm are ingored.
				if ( (self:GetOption('all_realms') or self.realm == realm) and
					  self.total_realm[faction][realm].time_played ~= 0 ) then
					----self:Debug("self.total_realm[faction][realm].time_played: ",self.total_realm[faction][realm].time_played)

					-- Build the Realm aggregated line
					local text_realm = string.format( C:Yellow(L["%s characters "]), realm )

					local text_realm_optional = ""
					local first_option = true

					if self:GetOption('show_played_time') then
						text_realm_optional = self:FormatTime(self.total_realm[faction][realm].time_played)
						first_option = false
					end

					if self:GetOption('show_coins') then
						if first_option then
							text_realm_optional = FormatMoney(self.total_realm[faction][realm].coin)
							first_option = false
						else
							text_realm_optional = string.format(
										"%s " .. C:Green(" : ") .. "%s",
										text_realm_optional,
										FormatMoney(self.total_realm[faction][realm].coin)
							)
						end
					end

					if self:GetOption('show_xp_total') then
						if first_option then
							text_realm_optional = FormatXP(self.total_realm[faction][realm].xp)
							first_option = false
						else
							text_realm_optional = string.format(
									"%s " .. C:Green(" : %s"),
									text_realm_optional,
									FormatXP(self.total_realm[faction][realm].xp)
							)
						end
					end

					if text_realm_optional ~= "" then
						text_realm = text_realm .. C:Green("[") .. text_realm_optional .. C:Green("]")
					end

					--tooltip:AddSeparator()
					if first_category then
						first_category = false
					else
						line, column = tooltip:AddLine()
						tooltip:SetCell(line, 1, " ")
					end

					--tooltip:AddSeparator()
					line, column = tooltip:AddLine()
					tooltip:SetCell(line, 1, text_realm, "LEFT", nb_columns)


					for _, pc in ipairs(self.sort_realm_pc[self:GetOption('display_sort_type')][faction][realm]) do
						if not self:GetOption('is_ignored', realm, pc) then
							local pc_data = self.db.global.data[faction][realm][pc]

							wipe(col_text)
							local col_no = 1

							-- Seconds played are still going up for the current PC
							local seconds_played = self:EstimateTimePlayed(
															  pc,
															  realm,
															  pc_data.seconds_played,
															  pc_data.seconds_played_last_update
														  )

							col_text[col_no] = FormatCharacterName(
															pc,
															pc_data.level,
															pc_data.xp,
															seconds_played,
															pc_data.class,
															pc_data.class_loc,
															faction
							                   )

							col_no = col_no + 1
							col_text[col_no] = ''

							--local text_location = ""
							if self:GetOption('show_location') ~= "none" then
								if self:GetOption('show_location') == "loc" or
									pc_data.zone_text == L["Unknown"] or
									(self:GetOption('show_location') == "loc/sub" and
									 pc_data.subzone_text == "") then

									col_text[col_no] = FactionColour(
														faction,
														pc_data.zone_text
													)
								elseif self:GetOption('show_location') == "sub" then

									col_text[col_no] = FactionColour(
														faction,
														pc_data.subzone_text
													)
								else
									col_text[col_no] = FactionColour(
														faction,
														pc_data.zone_text
														.. '/' .. pc_data.subzone_text
													)
								end

								col_no = col_no + 1
								col_text[col_no] = ''
							end

							--local text_pvp = ""
							if need_pvp then
								col_text[col_no] = FormatHonor(
										faction,
										pc_data.honor_kills,
										pc_data.honor_points,
										pc_data.arena_points
								)
								col_no = col_no + 1
								col_text[col_no] = ''
							end

							--local text_coin = ""
							if self:GetOption('show_coins') then
								col_text[col_no] = FormatMoney(pc_data.coin)
							end

							if (pc_data.level < self.max_pc_level) and
							   (pc_data.level > 1 or pc_data.xp > 0)
							then
								-- How must rested XP do we have?
								local estimated_rested_xp = self:EstimateRestedXP(
																	pc,
																	realm,
																	pc_data.level,
																	pc_data.rested_xp,
																	pc_data.max_rested_xp,
																	pc_data.last_update,
																	pc_data.is_resting,
																	pc_data.xp
															)

								-- Do we need to show the rested XP for the character?
								if self:GetOption('show_rested_xp') then
									if col_text[col_no] ~= "" then
										col_text[col_no] = col_text[col_no] .. FactionColour( faction, " : " )
									end
									col_text[col_no] = col_text[col_no] .. string.format(
																	FactionColour( faction, L["%d rested XP"] ),
																	estimated_rested_xp
															 )
								end

								local percent_for_colour = estimated_rested_xp / pc_data.max_rested_xp
								if pc_data.level == self.max_pc_level - 1 then
									-- Last level before max
									percent_for_colour 
										= estimated_rested_xp / 
											(XPToNextLevelCache[self.max_pc_level - 1] - pc_data.xp)
								end
								local countdown_seconds  = floor( TEN_DAYS * (1 - percent_for_colour) )

								-- The time to rest is way more if not in an inn or a major city
								if not pc_data.is_resting then
									countdown_seconds = countdown_seconds * 4
								end

								local text_countdown = ""
								if percent_for_colour < 1 and ( pc_data.is_resting or
																		 pc ~= self.pc or realm ~= self.realm
																	  )
								then
									text_countdown = self:FormatTime(countdown_seconds)
								end

								-- Do we show the percent XP rested and/or the countdown until 100% rested?
								if self:GetOption('percent_rest') ~= "0" and self:GetOption('show_rested_xp_countdown') and text_countdown ~= "" then
									col_text[col_no] = col_text[col_no] .. string.format( PercentColour(percent_for_colour, " (%d%% %s, -%s)"),
																						 self:GetOption('percent_rest') * percent_for_colour,
																						 L["rested"],
																						 text_countdown
																	 )
								elseif self:GetOption('percent_rest') ~= "0" then
									col_text[col_no] = col_text[col_no] .. string.format( PercentColour(percent_for_colour, " (%d%% %s)"),
																						 self:GetOption('percent_rest') * percent_for_colour,
																						 L["rested"]
																	 )
								elseif self:GetOption('show_rested_xp_countdown') and text_countdown ~= "" then
									col_text[col_no] = col_text[col_no] .. PercentColour( percent_for_colour, " (-" .. text_countdown .. ")" )
								end
							end

							line, column = tooltip:AddLine()
							tooltip:SetCell(line, 1, "  "..col_text[1], "LEFT")
							if nb_columns == 2 then
								tooltip:SetCell(line, 2, col_text[2], "RIGHT")
							elseif nb_columns == 3 then
								tooltip:SetCell(line, 2, col_text[2], "CENTER")
								tooltip:SetCell(line, 3, col_text[3], "RIGHT")
							else
								tooltip:SetCell(line, 2, col_text[2], "CENTER")
								tooltip:SetCell(line, 3, col_text[3], "CENTER")
								tooltip:SetCell(line, 4, col_text[4], "RIGHT")
							end
						end
					end
				end
			end
		end
	end

	-- Print the totals
	
	if self:GetOption('show_played_time') or
	   self:GetOption('show_coins') or
	   (self:GetOption('show_pvp_totals') and need_pvp) 
	then
		line, column = tooltip:AddLine()
		tooltip:SetCell(line, 1, " ")
		tooltip:AddSeparator()
	end
	
	if self:GetOption('show_played_time') then
		line, column = tooltip:AddLine()
		tooltip:SetCell(line, 1, C:Orange( L["Total Time Played: "] ), "LEFT", nb_columns - 1)
		tooltip:SetCell(line, nb_columns, C:Yellow( self:FormatTime(self.total.time_played) ), "RIGHT")
	end

	if self:GetOption('show_coins') then
		line, column = tooltip:AddLine()
		tooltip:SetCell(line, 1, C:Orange( L["Total Cash Value: "] ), "LEFT", nb_columns - 1)
		tooltip:SetCell(line, nb_columns, FormatMoney(self.total.coin), "RIGHT")
	end

	if self:GetOption('show_pvp_totals') and need_pvp then
		line, column = tooltip:AddLine()
		tooltip:SetCell(line, 1, C:Orange( L["Total PvP: "] ), "LEFT", nb_columns - 1)
		tooltip:SetCell(
				line, 
				nb_columns, 
				FormatHonor(self.faction,
								self.total.honor_kills,
								self.total.honor_points,
								self.total.arena_points
				), 
				"RIGHT"
		)
	end

	if self:GetOption('show_xp_total') then
		line, column = tooltip:AddLine()
		tooltip:SetCell(line, 1, C:Orange( L["Total XP: "] ), "LEFT", nb_columns - 1)
		tooltip:SetCell(line, nb_columns, C:Yellow( FormatXP(self.total.xp) ), "RIGHT")
	end
	
	-- Set the opacity
	self:SetTTOpacity(self:GetOption('opacity'))

	-- Adjust the hight of the tooltip so that it fits in the screen
	--tooltip:UpdateScrolling(GetScreenHeight() - 30)
	tooltip:UpdateScrolling()
	
	
	tooltip:Show()
	self.OnUpdate_frame:Show() -- Start the OnUpdate script
end

-- Function trigered when the TIME_PLAYED_MSG event is fired
function AllPlayed:OnTimePlayedMsg(msg, seconds_played)
    --self:Debug("OnTimePlayedMsg(): ",seconds_played)

    -- We save the normal variables and the seconds played
    self:SetSecondsPlayed(seconds_played)
    self:SaveVar()

    -- Compute the totals
    self:ComputeTotal()
end

-- Event handler for the events that trigger a sort
function AllPlayed:EventHandlerWithSort(msg)
    --self:Debug("EventHandlerWithSort(): [arg1: %s] [arg2: %s] [arg3: %s]", arg1, arg2, arg3)

    -- Trigger the sort
	self.sort_tables_done = false

	-- Call the global event handler
	self:EventHandler()
end

-- Event handler for the other events registered
function AllPlayed:EventHandler(msg)
    self:Debug("EventHandler(): [arg1: %s] [arg2: %s] [arg3: %s]", arg1, arg2, arg3)

    -- We save a new copy of the vars
    self:SaveVar()

    -- Compute totals
    self:ComputeTotal()
end

-- Event handler for the other events registered
function AllPlayed:EventHandlerHonorGain()
    --self:Debug("EventHandlerHonorGain(): [arg1: %s] [arg2: %s] [arg3: %s]", arg1, arg2, arg3)

    -- We save a new copy of the vars
    self:SaveVarHonor()

    -- Compute totals
    self:ComputeTotalHonor()
end


--[[ ================================================================= ]]--
--[[                  Store and retreive methods                       ]]--
--[[ ================================================================= ]]--

-- This function should be called everytime it is useful to refresh the save data
-- I know that some data never change until the user log out but since the function
-- is not called very often, I don't see the needs to do more special cases
function AllPlayed:SaveVar()
    --self:Debug("AllPlayed:SaveVar()")

    -- Fill some of the SaveVariables
    local pc = self.db.global.data[self.faction][self.realm][self.pc]
    pc.class_loc, pc.class	= UnitClass("player")
    pc.level           		= UnitLevel("player")
    pc.xp              		= UnitXP("player")
    pc.max_rested_xp   		= UnitXPMax("player") * 1.5
    pc.last_update     		= time()
    pc.is_resting      		= IsResting()
    pc.zone_text       		= GetZoneText()
    pc.subzone_text    		= GetSubZoneText()
	 pc.arena_points    		= GetArenaCurrency()
	 
	 -- Statistical stuff
	 

    -- Verify that the XPToNextLevel return the proper value and store the value if it is not the case
    if UnitXPMax("player") ~= XPToNextLevel(UnitLevel("player")) then
    	local _, build_version = GetBuildInfo()
    	self.db.global.cache.XPToNextLevel[build_version][UnitLevel("player")] = UnitXPMax("player")
    end

    --self:Print("AllPlayed:SaveVar() Zone: ->%s<- ->%s<-", GetZoneText(), self.db.global.data[self.faction][self.realm][self.pc].zone_text)

    -- Make sure that coin is not nil
    pc.coin = GetMoney() or 0

    -- Make sure that rested_xp is not nil
    pc.rested_xp = GetXPExhaustion() or 0

	 -- PvPstuff
	 self:SaveVarHonor()
	 --self:SaveVarMarks()
end

-- Save only the honor portion of the deal (for the honor gain event)
function AllPlayed:SaveVarHonor()
	--self:Debug("SaveVarHonor()")

	local pc = self.db.global.data[self.faction][self.realm][self.pc]

	pc.honor_points	 					= GetHonorCurrency()
	pc.honor_kills, pc.highest_rank = GetPVPLifetimeStats()
end

-- Set the value seconds_played that will be saved in the save variables
function AllPlayed:SetSecondsPlayed(seconds_played)
	--self:Debug("SetSecondsPlayed(): ",seconds_played)

	local pc = self.db.global.data[self.faction][self.realm][self.pc]

	pc.seconds_played              = seconds_played
	pc.seconds_played_last_update  = time()

end

--[[ Methods used for the option menu ]]--

-- Get the option value
function AllPlayed:GetOption( option, ... )
	--self:Debug(format("AllPlayed:GetOption(%s) = %s", option or 'nil', tostring(self.db.profile.options[option] or 'nil')))


	-- is_ignored has multiple parameters
	if option == 'is_ignored' then
		local realm, name = ...

		return self.db.profile.options.is_ignored[realm][name]

	-- The sort direction is kept in the sort name
	elseif option == 'reverse_sort' then
		if string.find(self.db.profile.options.sort_type, "rev-") == 1 then
			return true
		else
			return false
		end
	elseif option == 'sort_type' then
		if string.find(self.db.profile.options.sort_type, "rev-") == 1 then
			return string.sub(self.db.profile.options.sort_type, 5)
		else
			return self.db.profile.options.sort_type
		end
	elseif option == 'display_sort_type' then
		-- For display, we need the complete thing
		return self.db.profile.options.sort_type
		
	elseif option == 'show_minimap_icon' then
		return not self.db.profile.options.ldbicon.hide
	end

	return self.db.profile.options[option]
end

-- Set an option value
function AllPlayed:SetOption( option, value, ... )
	--self:Debug(format("AllPlayed:SetOption(%s): old %s, new %s", option or 'nil', tostring(self.db.profile.options[option] or 'nil'), tostring(value or 'nil') ))

	local already_set = false

	-- Do we need to recompute the totals?
	if option == 'all_factions' or option == 'all_realms' or option == 'is_ignored' then
		if option == 'is_ignored' then
			local realm, name = ...
			self.db.profile.options.is_ignored[realm][name] = value
		else
			self.db.profile.options[option] = value
		end

		already_set = true

		-- Compute the totals
		self:ComputeTotal()
		self:ComputeTotalHonor()

	-- Do we need to change the refresh rate?
	elseif option == 'show_seconds' then
		if value then
			-- If the seconds are displayed, we need to refresh every seconds
			self.db.profile.options.refresh_rate = 1
		else
			-- If only the minutes are shown, 3 refreshs a minute will do nicely
			self.db.profile.options.refresh_rate = 20
		end
		--self:Debug("=> refresh rate:", self:GetOption('refresh_rate'))

		-- If there is a timer active, we change the rate
		--if self:IsEventScheduled(self.name) then
		--	self:ScheduleRepeatingEvent(self.name, self.MyUpdate, self:GetOption('refresh_rate'), self)
		--end
		self:CancelTimer(self.timer,true)
		self.timer = self:ScheduleRepeatingTimer("MyUpdate", self:GetOption('refresh_rate'))

   -- Set activate or disactivate the PLAYER_MONEY event
	elseif option == 'show_coins' then
		if value then
			self:RegisterEvent("PLAYER_MONEY", "EventHandler")
		else
			self:UnregisterEvent("PLAYER_MONEY")
		end

	-- Set the Shaman colour
	elseif option == 'use_pre_210_shaman_colour' then
		if value then
			CLASS_COLOURS['SHAMAN'] = CLASS_COLOURS['PRE-210-SHAMAN']
		else
			CLASS_COLOURS['SHAMAN'] = AllPlayed.GetClassHexColour("SHAMAN")
		end

	-- Set the scale of the tooltip
	elseif option == 'tooltip_scale' and self.tooltip then
		self.tooltip:SetScale(value)
	
	-- Set the opacity of the tablet frame
	elseif option == 'opacity' then
		self:SetTTOpacity(value)
		
	-- Ajust the sort type with the direction
	elseif option == 'sort_type' then
	    if self:GetOption('reverse_sort') then
	    	self.db.profile.options.sort_type = "rev-" .. value
	    else
	    	self.db.profile.options.sort_type = value
	    end

	    already_set = true

	-- Modify the direction of the sort
	elseif option == 'reverse_sort' then
		local sort_type
		if self:GetOption('reverse_sort') then
			sort_type = string.sub(self.db.profile.options.sort_type,5)
		else
			sort_type = self.db.profile.options.sort_type
		end

		if value then
			self.db.profile.options.sort_type = "rev-" .. sort_type
		else
			self.db.profile.options.sort_type = sort_type
		end

		already_set = true

	elseif option == 'show_minimap_icon' then
		if value then
			self.db.profile.options.ldbicon.hide = nil
			ldbicon:Show("AllPlayed")
		else
			self.db.profile.options.ldbicon.hide = true
			ldbicon:Hide("AllPlayed")
		end
		
		ldbicon:Refresh("AllPlayed", self.db.profile.options.ldbicon)

		already_set = true
	end

	-- Set the value
	if not already_set then
		self.db.profile.options[option] = value
	end

	-- Refesh
	self:MyUpdate()
end

--[[ ================================================================= ]]--
--[[                         Hook function                             ]]--
--[[ ================================================================= ]]--

-- Those are used to get a last update on the time played before going away
function AllPlayed:Logout()
    --self:Debug("Logout()")

    self:RequestTimePlayed()
    --return self.hooks.Logout()
end

function AllPlayed:Quit()
    --self:Debug("Quit()")

    self:RequestTimePlayed()
    --return self.hooks.Quit()
end

--[[ ================================================================= ]]--
--[[                       Utility Functions                           ]]--
--[[ ================================================================= ]]--

-- This function estimate (calculate) the real time played
-- Only the current player is still playing.
function AllPlayed:EstimateTimePlayed( pc, realm, time_played, last_update )
    if pc == self.pc and realm == self.realm then
        return time_played + time() - last_update
    else
        return time_played
    end
end

-- This function tries to estimate the total rested XP for a character based
-- on the last time the data were updated and whether or not the character
-- was in an Inn
function AllPlayed:EstimateRestedXP( pc, realm, level, rested_xp, max_rested_xp, last_update, is_resting, curent_xp )
    --self:Debug("AllPlayed:EstimateRestedXP: %s, %s, %s, %s, %s, %s, %s",pc, realm, level, rested_xp, max_rested_xp, last_update, is_resting)
    -- I'm putting level as a parameter even though I don't use it for now. I need to find
    -- out at what level do a character start to gain rested XP

    -- If the character is the current player and he is not in an Inn, he gain no rest
    if pc == AllPlayed.pc and realm == self.realm and not is_resting then
        return rested_xp
    end

    -- It takes 10 days to for a character to be fully rested if he is in an Inn,
    -- otherwise it takes 40 days.
    local estimated_rested_xp
    if is_resting then
        estimated_rested_xp = math.min( rested_xp + math.floor( ( time()-last_update ) * ( max_rested_xp/TEN_DAYS ) ), max_rested_xp )
    else
        estimated_rested_xp = math.min( rested_xp + math.floor( ( time()-last_update ) * ( max_rested_xp/(4 * TEN_DAYS) ) ), max_rested_xp )
    end
    
    -- If the character is at the last level before max level, he cannot have more rest 
    -- then what remains to level
    if level == self.max_pc_level - 1 then 
    	estimated_rested_xp = math.min( estimated_rested_xp, XPToNextLevelCache[self.max_pc_level - 1] - curent_xp )
    end
    
    return estimated_rested_xp
end

-- Function that Send a request to the server to get an update of the time played.
function AllPlayed:RequestTimePlayed()
    -- We only send the event if the message has not been seen for 10 seconds
    if time() - self.db.global.data[self.faction][self.realm][self.pc].seconds_played_last_update > 10 then
        RequestTimePlayed()
    end

end

function AllPlayed:FormatTime(seconds)
    return A:FormatDurationFull( seconds, false, not self:GetOption('show_seconds') )
end

-- Function that format the XP based on the value
-- The result is a string with XP, K XP or M XP depending on the size of the XP to display
function FormatXP(xp)
   local display_xp = ""

   if xp > 1000000 then
      -- Millions of XP
      display_xp = string.format( L["%.1f M XP"], xp / 1000000 )
   elseif xp > 1000 then
      -- Thousands of XP
      display_xp = string.format( L["%.1f K XP"], xp / 1000 )
   else
      -- Very few XP
      display_xp = string.format( L["%d XP"] , xp )
   end

   return display_xp
end

-- Fonction that format the money string
-- The result is a string with embeded coin icons
local gold_icon 	= "|TInterface\\AddOns\\AllPlayed\\Gold:0:0:2:0|t"
local silver_icon = "|TInterface\\AddOns\\AllPlayed\\Silver:0:0:2:0|t"
local copper_icon = "|TInterface\\AddOns\\AllPlayed\\Copper:0:0:2:0|t"
--> "6996|TInterface\MoneyFrame\UI-GoldIcon:0:0:2:0|t 38|TInterface\MoneyFrame\UI-SilverIcon:0:0:2:0|t 2|TInterface\MoneyFrame\UI-CopperIcon:0:0:2:0|t"
--local gold_icon 	= "|TInterface\MoneyFrame\UI-GoldIcon:0:0:2:0|t"
--local silver_icon = "|TInterface\MoneyFrame\UI-SilverIcon:0:0:2:0|t"
--local copper_icon = "|TInterface\MoneyFrame\UI-CopperIcon:0:0:2:0|t"
function FormatMoney(amount)
   if not AllPlayed:GetOption('use_icons') then return A:FormatMoneyFull( amount, true, false ) end

	local string = ""

	if amount >= 10000 then
		string = format("%d%s %d%s %d%s",
							 amount / 10000,
							 gold_icon,
							 (amount % 10000) / 100,
							 silver_icon,
							 (amount % 100),
							 copper_icon)
	elseif amount >= 100 then
		string = format("%d%s %d%s",
							 (amount % 10000) / 100,
							 silver_icon,
							 (amount % 100),
							 copper_icon)
	else
		string = format("%d%s",
							 amount,
							 copper_icon)
	end

	return C:White(string)

end

local honor_strings = {
	icons = {
		hk 					= '%s|TInterface\\LootFrame\\LootPanel-Icon:0|t',
		['hp-Alliance']	= '%s|TInterface\\AddOns\\AllPlayed\\UI-PVP-Alliance:0|t',
		['hp-Horde']		= '%s|TInterface\\AddOns\\AllPlayed\\UI-PVP-Horde:0|t',
		ap 					= '%s|TInterface\\PVPFrame\\PVP-ArenaPoints-Icon:0|t',
--		bj 					= '%s|TInterface\\Icons\\Spell_Holy_ChampionsBond:0,0,0,-1|t',
--		ab 					= '%s|TInterface\\Icons\\INV_Jewelry_Amulet_07:0,0,0,1|t',
--		av 					= '%s|TInterface\\Icons\\INV_Jewelry_Necklace_21:0|t',
--		wg 					= '%s|TInterface\\Icons\\INV_Misc_Rune_07:0|t',
--		es 					= '%s|TInterface\\Icons\\Spell_Nature_EyeOfTheStorm:0|t'
	},
	no_icons = {
		hk 					= L['%s HK'],
		['hp-Alliance']	= L['%s HP'],
		['hp-Horde'] 		= L['%s HP'],
		ap 					= L['%s AP'],
--		bj 					= L['%s BoJ'],
--		ab 					= L['%s AB'],
--		av 					= L['%s AV'],
--		wg 					= L['%s WG'],
--		es 					= L['%s EotS']
	}
}

-- Function that produce the honour string based on the display options
function FormatHonor( faction, honor_kills, pvp_points, arena_points )

	local honor_string, fmt = ""
	if AllPlayed:GetOption('use_icons') then
		fmt = honor_strings.icons
	else
		fmt = honor_strings.no_icons
	end


	if AllPlayed:GetOption('show_honor_kills') then
		honor_string = honor_string .. format(fmt.hk, C:White(tostring(honor_kills))) .. ' '
	end
	if AllPlayed:GetOption('show_honor_points') 		then
		honor_string = honor_string .. format(fmt['hp-' .. faction], C:White(tostring(pvp_points))) .. ' '
	end
	if AllPlayed:GetOption('show_arena_points') 		then
		honor_string = honor_string .. format(fmt.ap, C:White(tostring(arena_points))) .. ' '
	end

	-- Return the string minus the last space
	return (string.gsub(honor_string, "^%s*(.-)%s*$", "%1"))

end

-- This function colorize the text based on the faction
function FactionColour( faction, string )
    if faction == "Horde" then
        return C:Red(string)
    else
        -- Blue
        return C:Colorize( "007fff", string )
    end
end

-- This function colorize the text based on the percent value
-- percent must be a value in the range 0-1, not 0-100
function PercentColour( percent, string )
    return C:Colorize( C:GetThresholdHexColor( percent, 0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 0.95, 1 ), string )
end

-- This function colorize the text based on the class
-- If no class is defined, the text is colorized by faction
function ClassColour( class, faction, string )
    if class == "" or not AllPlayed:GetOption('colorize_class') then
        return FactionColour( faction, string )
    else
        return C:Colorize( CLASS_COLOURS[class], string )
    end
end

-- This function format and colorize the Character name and level
-- based on the options selected by the user
function FormatCharacterName( pc, level, xp, seconds_played, class, class_loc, faction )
	--AllPlayed:Debug("FormatCharacterName: %s, %s, %s, %s, %s, %s, %s",pc, level, xp, seconds_played, class, class_loc, faction)

	local result_string     = ""
	local level_string      = ""

	-- Format the level string according to the show_progress option
	if AllPlayed:GetOption('show_progress') and xp ~= -1 then
		local progress
		if level == AllPlayed.max_pc_level then
			progress = 0
		else
			progress = min( xp / XPToNextLevel(level), .99 )
		end

		level_string = string.format( "%.2f" , level + progress )
	else
		level_string = string.format( "%d" , level )
	end

	-- Created use the all cap english name if the localized name is not present
	-- This should never happen but I like to code defensively
	local class_display = class_loc
	if class_display == "" then class_display = class end

	if class_display ~= "" and AllPlayed:GetOption('show_class_name') then
		level_string = string.format( "%s %s", class_display, level_string )
	end

	result_string = string.format( ClassColour( class, faction, "%s (%s)" ),
											  pc,
											  level_string
					  	 )

	if AllPlayed:GetOption('show_played_time') then
		result_string = result_string .. string.format(
														FactionColour( faction, " : %s" ),
														AllPlayed:FormatTime(seconds_played)
													)
	end

	-- Do we need to show the total XP
	if AllPlayed:GetOption('show_xp_total') and xp ~= -1 then
		local pc_xp = XPToLevel(level)
		if AllPlayed.max_pc_level < level then pc_xp = pc_xp + xp end
		result_string = result_string .. FactionColour( faction, " : " .. FormatXP(pc_xp) )
	end

	return result_string
end


-- Build the static sort table needed
function AllPlayed:BuildSortTables()
	self:Debug("Sorting asked: %d",time())
	-- If the sort is already done, we don't redo it.
	if self.sort_tables_done then return end
	self:Debug("Sorting done: %d",time())

	-- Static sort for the factions
	if not self.sort_faction then self.sort_faction = { "Horde", "Alliance" } end

	self.sort_faction_realm = ClearTable(self.sort_faction_realm)
	self.sort_faction_realm["alpha"] 				= AcquireTable()
	self.sort_faction_realm["rev-alpha"] 			= AcquireTable()
	self.sort_faction_realm["level"] 				= AcquireTable()
	self.sort_faction_realm["rev-level"] 			= AcquireTable()
	self.sort_faction_realm["xp"] 					= AcquireTable()
	self.sort_faction_realm["rev-xp"] 				= AcquireTable()
	self.sort_faction_realm["rested_xp"] 			= AcquireTable()
	self.sort_faction_realm["rev-rested_xp"] 		= AcquireTable()
	self.sort_faction_realm["percent_rest"] 		= AcquireTable()
	self.sort_faction_realm["rev-percent_rest"] 	= AcquireTable()
	self.sort_faction_realm["coin"] 					= AcquireTable()
	self.sort_faction_realm["rev-coin"] 			= AcquireTable()
	self.sort_faction_realm["time_played"] 		= AcquireTable()
	self.sort_faction_realm["rev-time_played"] 	= AcquireTable()

	self.sort_realm_pc = ClearTable(self.sort_realm_pc)
	self.sort_realm_pc["alpha"]						= AcquireTable()
	self.sort_realm_pc["rev-alpha"]					= AcquireTable()
	self.sort_realm_pc["level"]						= AcquireTable()
	self.sort_realm_pc["rev-level"]					= AcquireTable()
	self.sort_realm_pc["xp"] 							= AcquireTable()
	self.sort_realm_pc["rev-xp"] 						= AcquireTable()
	self.sort_realm_pc["rested_xp"] 					= AcquireTable()
	self.sort_realm_pc["rev-rested_xp"] 			= AcquireTable()
	self.sort_realm_pc["percent_rest"] 				= AcquireTable()
	self.sort_realm_pc["rev-percent_rest"] 		= AcquireTable()
	self.sort_realm_pc["coin"] 						= AcquireTable()
	self.sort_realm_pc["rev-coin"] 					= AcquireTable()
	self.sort_realm_pc["time_played"] 				= AcquireTable()
	self.sort_realm_pc["rev-time_played"]			= AcquireTable()

	for faction, faction_table in pairs(self.db.global.data) do

		-- Realms in each faction are alpha sorted
		--self:Debug("ST : Faction = ",faction)
		self.sort_faction_realm["alpha"][faction]
			= buildSortedTable( faction_table )
		self.sort_faction_realm["rev-alpha"][faction]
			= self.sort_faction_realm["alpha"][faction]
		self.sort_faction_realm["level"][faction]
			= self.sort_faction_realm["alpha"][faction]
		self.sort_faction_realm["rev-level"][faction]
			= self.sort_faction_realm["alpha"][faction]
		self.sort_faction_realm["xp"][faction]
			= self.sort_faction_realm["alpha"][faction]
		self.sort_faction_realm["rev-xp"][faction]
			= self.sort_faction_realm["alpha"][faction]
		self.sort_faction_realm["rested_xp"][faction]
			= self.sort_faction_realm["alpha"][faction]
		self.sort_faction_realm["rev-rested_xp"][faction]
			= self.sort_faction_realm["alpha"][faction]
		self.sort_faction_realm["percent_rest"][faction]
			= self.sort_faction_realm["alpha"][faction]
		self.sort_faction_realm["rev-percent_rest"][faction]
			= self.sort_faction_realm["alpha"][faction]
		self.sort_faction_realm["coin"][faction]
			= self.sort_faction_realm["alpha"][faction]
		self.sort_faction_realm["rev-coin"][faction]
			= self.sort_faction_realm["alpha"][faction]
		self.sort_faction_realm["time_played"][faction]
			= self.sort_faction_realm["alpha"][faction]
		self.sort_faction_realm["rev-time_played"][faction]
			= self.sort_faction_realm["alpha"][faction]

		-- Reset the pc tables
		self.sort_realm_pc["alpha"][faction]        		= AcquireTable()
		self.sort_realm_pc["rev-alpha"][faction]    		= AcquireTable()
		self.sort_realm_pc["level"][faction]        		= AcquireTable()
		self.sort_realm_pc["rev-level"][faction]    		= AcquireTable()
		self.sort_realm_pc["xp"][faction]           		= AcquireTable()
		self.sort_realm_pc["rev-xp"][faction]       		= AcquireTable()
		self.sort_realm_pc["rested_xp"][faction]       	= AcquireTable()
		self.sort_realm_pc["rev-rested_xp"][faction]   	= AcquireTable()
		self.sort_realm_pc["percent_rest"][faction]     = AcquireTable()
		self.sort_realm_pc["rev-percent_rest"][faction] = AcquireTable()
		self.sort_realm_pc["coin"][faction]     			= AcquireTable()
		self.sort_realm_pc["rev-coin"][faction] 			= AcquireTable()
		self.sort_realm_pc["time_played"][faction]     	= AcquireTable()
		self.sort_realm_pc["rev-time_played"][faction] 	= AcquireTable()

		for realm, realm_table in pairs(faction_table) do
			-- PC in each realm are alpha sorted by name
			--self:Debug("ST : Realm = ",realm)
			self.sort_realm_pc["alpha"][faction][realm] = buildSortedTable( realm_table )
			self.sort_realm_pc["rev-alpha"][faction][realm]
				= buildSortedTable( realm_table, function(a,b) return a>b end )
			self.sort_realm_pc["level"][faction][realm]
				= buildSortedTable( realm_table, PCSortByLevel )
			self.sort_realm_pc["rev-level"][faction][realm]
				= buildSortedTable( realm_table, PCSortByRevLevel )
			self.sort_realm_pc["xp"][faction][realm]
				= buildSortedTable( realm_table, PCSortByXP )
			self.sort_realm_pc["rev-xp"][faction][realm]
				= buildSortedTable( realm_table, PCSortByRevXP )
			self.sort_realm_pc["rested_xp"][faction][realm]
				= buildSortedTable( realm_table, PCSortByRestedXP, realm )
			self.sort_realm_pc["rev-rested_xp"][faction][realm]
				= buildSortedTable( realm_table, PCSortByRevRestedXP, realm )
			self.sort_realm_pc["percent_rest"][faction][realm]
				= buildSortedTable( realm_table, PCSortByPercentRest, realm )
			self.sort_realm_pc["rev-percent_rest"][faction][realm]
				= buildSortedTable( realm_table, PCSortByRevPercentRest, realm )
			self.sort_realm_pc["coin"][faction][realm]
				= buildSortedTable( realm_table, PCSortByCoin )
			self.sort_realm_pc["rev-coin"][faction][realm]
				= buildSortedTable( realm_table, PCSortByRevCoin )
			self.sort_realm_pc["time_played"][faction][realm]
				= buildSortedTable( realm_table, PCSortByTimePlayed )
			self.sort_realm_pc["rev-time_played"][faction][realm]
				= buildSortedTable( realm_table, PCSortByRevTimePlayed )

		end

	end

	self.sort_tables_done = true
end

-- This function build a table of sorted keys that will latter
-- be used with ipairs in order to get the value of a hash in order
-- By doing it this way, the temporary tables are droped only once so
-- it reduce the LUA garbage collection.
do
	local table_to_sort, realm_for_sort

	function buildSortedTable( unsorted_table, sort_function, realm )
		--AllPlayed:Debug("buildSortedTable:")

		-- If the realm is needed for the sort, we initialize it
		realm_for_sort = realm or nil


		local sorted_key_table = AcquireTable()
		for key in pairs(unsorted_table) do table.insert(sorted_key_table, key) end

		table_to_sort = unsorted_table
		table.sort(sorted_key_table, sort_function)

		return sorted_key_table
	end

	-- Sort function to sort per level, then per name
	function PCSortByLevel(a,b)
		-- First per level
		if table_to_sort[a].level ~= table_to_sort[b].level then
			return table_to_sort[a].level < table_to_sort[b].level
		else
			return a < b
		end
	end

	-- Sort function to sort per reverse level, then per name
	function PCSortByRevLevel(a,b)
		-- First per level
		if table_to_sort[b].level ~= table_to_sort[a].level then
			return table_to_sort[b].level < table_to_sort[a].level
		else
			return a < b
		end
	end

	-- Sort function to sort per total XP
	function PCSortByXP(a,b)
		-- First per level
		if table_to_sort[a].level ~= table_to_sort[b].level then
			return table_to_sort[a].level < table_to_sort[b].level
		elseif table_to_sort[a].xp ~= table_to_sort[b].xp then
			return table_to_sort[a].xp < table_to_sort[b].xp
		else
			return a < b
		end
	end

	-- Sort function to sort per reverse total XP
	function PCSortByRevXP(a,b)
		-- First per level
		if table_to_sort[b].level ~= table_to_sort[a].level then
			return table_to_sort[b].level < table_to_sort[a].level
		elseif table_to_sort[a].xp ~= table_to_sort[b].xp then
			return table_to_sort[b].xp < table_to_sort[a].xp
		else
			return a < b
		end
	end

	-- Sort function to sort per rested XP
	function PCSortByRestedXP(a,b)
		 local estimated_rested_xp_a = 0
		 local estimated_rested_xp_b = 0

		 if a and table_to_sort[a] then
			  estimated_rested_xp_a = AllPlayed:EstimateRestedXP(
											a,
											realm_for_sort,
											table_to_sort[a].level,
											table_to_sort[a].rested_xp,
											table_to_sort[a].max_rested_xp,
											table_to_sort[a].last_update,
											table_to_sort[a].is_resting,
											table_to_sort[a].xp
			  )
		 end

		 if b and table_to_sort[b] then
			  estimated_rested_xp_b = AllPlayed:EstimateRestedXP(
											b,
											realm_for_sort,
											table_to_sort[b].level,
											table_to_sort[b].rested_xp,
											table_to_sort[b].max_rested_xp,
											table_to_sort[b].last_update,
											table_to_sort[b].is_resting,
											table_to_sort[b].xp
			  )
		 end

		 --AllPlayed:Debug("PCSortByRestedXP: %s = %s, %s = %s",a, estimated_rested_xp_a, b, estimated_rested_xp_b)

		 if estimated_rested_xp_a ~= estimated_rested_xp_b then
			  return estimated_rested_xp_a < estimated_rested_xp_b
		 else
			  return a < b
		 end
	end

	-- Sort function to sort per reverse rested XP
	function PCSortByRevRestedXP(a,b)
		 local estimated_rested_xp_a = 0
		 local estimated_rested_xp_b = 0

		 if a and table_to_sort[a] then
			  estimated_rested_xp_a = AllPlayed:EstimateRestedXP(
											a,
											realm_for_sort,
											table_to_sort[a].level,
											table_to_sort[a].rested_xp,
											table_to_sort[a].max_rested_xp,
											table_to_sort[a].last_update,
											table_to_sort[a].is_resting,
											table_to_sort[a].xp
			  )
		 end

		 if b and table_to_sort[b] then
			  estimated_rested_xp_b = AllPlayed:EstimateRestedXP(
											b,
											realm_for_sort,
											table_to_sort[b].level,
											table_to_sort[b].rested_xp,
											table_to_sort[b].max_rested_xp,
											table_to_sort[b].last_update,
											table_to_sort[b].is_resting,
											table_to_sort[b].xp
			  )
		 end

		 --AllPlayed:Debug("PCSortByRestedXP: %s = %s, %s = %s",a, estimated_rested_xp_a, b, estimated_rested_xp_b)

		 if estimated_rested_xp_b ~= estimated_rested_xp_a then
			  return estimated_rested_xp_b < estimated_rested_xp_a
		 else
			  return a < b
		 end
	end

	-- Sort function to sort per % rest
	function PCSortByPercentRest(a,b)
		 local estimated_rested_xp_a = 0
		 local estimated_rested_xp_b = 0

		 if a and table_to_sort[a] then
			  estimated_rested_xp_a = AllPlayed:EstimateRestedXP(
											a,
											realm_for_sort,
											table_to_sort[a].level,
											table_to_sort[a].rested_xp,
											table_to_sort[a].max_rested_xp,
											table_to_sort[a].last_update,
											table_to_sort[a].is_resting,
											table_to_sort[a].xp
			  )
		 end

		 if b and table_to_sort[b] then
			  estimated_rested_xp_b = AllPlayed:EstimateRestedXP(
											b,
											realm_for_sort,
											table_to_sort[b].level,
											table_to_sort[b].rested_xp,
											table_to_sort[b].max_rested_xp,
											table_to_sort[b].last_update,
											table_to_sort[b].is_resting,
											table_to_sort[b].xp
			  )
		 end

		 --AllPlayed:Debug("PCSortByPercentRest: %s = %s, %s = %s",a, estimated_rested_xp_a, b, estimated_rested_xp_b)

		 if estimated_rested_xp_a / table_to_sort[a].max_rested_xp
			 ~= estimated_rested_xp_b / table_to_sort[b].max_rested_xp then
			  return estimated_rested_xp_a / table_to_sort[a].max_rested_xp
						< estimated_rested_xp_b / table_to_sort[b].max_rested_xp
		 elseif estimated_rested_xp_a ~= estimated_rested_xp_b then
			return estimated_rested_xp_a < estimated_rested_xp_b
		 else
			  return a < b
		 end
	end

	-- Sort function to sort per reverse % rest
	function PCSortByRevPercentRest(a,b)
		 local estimated_rested_xp_a = 0
		 local estimated_rested_xp_b = 0

		 if a and table_to_sort[a] then
			  estimated_rested_xp_a = AllPlayed:EstimateRestedXP(
											a,
											realm_for_sort,
											table_to_sort[a].level,
											table_to_sort[a].rested_xp,
											table_to_sort[a].max_rested_xp,
											table_to_sort[a].last_update,
											table_to_sort[a].is_resting,
											table_to_sort[a].xp
			  )
		 end

		 if b and table_to_sort[b] then
			  estimated_rested_xp_b = AllPlayed:EstimateRestedXP(
											b,
											realm_for_sort,
											table_to_sort[b].level,
											table_to_sort[b].rested_xp,
											table_to_sort[b].max_rested_xp,
											table_to_sort[b].last_update,
											table_to_sort[b].is_resting,
											table_to_sort[b].xp
			  )
		 end

		 --AllPlayed:Debug("PCSortByPercentRest: %s = %s, %s = %s",a, estimated_rested_xp_a, b, estimated_rested_xp_b)

		 if estimated_rested_xp_b / table_to_sort[b].max_rested_xp
			 ~= estimated_rested_xp_a / table_to_sort[a].max_rested_xp then
			  return estimated_rested_xp_b / table_to_sort[b].max_rested_xp
						< estimated_rested_xp_a / table_to_sort[a].max_rested_xp
		 elseif estimated_rested_xp_b ~= estimated_rested_xp_a then
			return estimated_rested_xp_b < estimated_rested_xp_a
		 else
			  return a < b
		 end
	end

	-- Sort funciton to sort per money
	function PCSortByCoin(a,b)
		if table_to_sort[a].coin ~= table_to_sort[b].coin then
			return table_to_sort[a].coin < table_to_sort[b].coin
		else
			return a < b
		end
	end

	-- Sort funciton to sort per reverse money
	function PCSortByRevCoin(a,b)
		if table_to_sort[b].coin ~= table_to_sort[a].coin then
			return table_to_sort[b].coin < table_to_sort[a].coin
		else
			return a < b
		end
	end

	-- Sort funciton to sort per time played
	function PCSortByTimePlayed(a,b)
		if table_to_sort[a].seconds_played ~= table_to_sort[b].seconds_played then
			return table_to_sort[a].seconds_played < table_to_sort[b].seconds_played
		else
			return a < b
		end
	end

	-- Sort funciton to sort per reverse time played
	function PCSortByRevTimePlayed(a,b)
		if table_to_sort[b].seconds_played ~= table_to_sort[a].seconds_played then
			return table_to_sort[b].seconds_played < table_to_sort[a].seconds_played
		else
			return a < b
		end
	end
end -- do end


-- This function caculate the number of XP to reach a particular level.
local XPToLevelCache  = {}
XPToLevelCache[0]     = 0
XPToLevelCache[1]     = 0
function XPToLevel( level )
    if XPToLevelCache[level] == nil then
        XPToLevelCache[level] = XPToNextLevel( level - 1 ) + XPToLevel( level - 1 )
    end

    return XPToLevelCache[level]
end

-- This function caculate the number of XP that you need at a particular level to reach
-- next level. Will need to review this when BC becomes live.
-- Until there is a new formula for 2.3, I use the published XP values

function InitXPToLevelCache( game_version, build_version )
	local date, toc_number

	if game_version == nil then
		game_version, build_version, date, toc_number = GetBuildInfo()
	elseif build_version == nil then
		_, build_version, date, toc_number = GetBuildInfo()
	else
		_, _, date, toc_number = GetBuildInfo()
	end

	-- Values for the 2.3 patches as recorded on WoWWiki
	XPToNextLevelCache[11]    = 8700
	XPToNextLevelCache[12]    = 9800
	XPToNextLevelCache[13]    = 11000
	XPToNextLevelCache[14]    = 12300
	XPToNextLevelCache[15]    = 13600
	XPToNextLevelCache[16]    = 15000
	XPToNextLevelCache[17]    = 16400
	XPToNextLevelCache[18]    = 17800
	XPToNextLevelCache[19]    = 19300
	XPToNextLevelCache[20]    = 20800
	XPToNextLevelCache[21]    = 22400
	XPToNextLevelCache[22]    = 24000
	XPToNextLevelCache[23]    = 25500
	XPToNextLevelCache[24]    = 27200
	XPToNextLevelCache[25]    = 28900
	XPToNextLevelCache[26]    = 30500
	XPToNextLevelCache[27]    = 32200
	XPToNextLevelCache[28]    = 33900
	XPToNextLevelCache[29]    = 36300
	XPToNextLevelCache[30]    = 38800
	XPToNextLevelCache[31]    = 41600
	XPToNextLevelCache[32]    = 44600
	XPToNextLevelCache[33]    = 48000
	XPToNextLevelCache[34]    = 51400
	XPToNextLevelCache[35]    = 55000
	XPToNextLevelCache[36]    = 58700
	XPToNextLevelCache[37]    = 62400
	XPToNextLevelCache[38]    = 66200
	XPToNextLevelCache[39]    = 70200
	XPToNextLevelCache[40]    = 74300
	XPToNextLevelCache[41]    = 78500
	XPToNextLevelCache[42]    = 82800
	XPToNextLevelCache[43]    = 87100
	XPToNextLevelCache[44]    = 91600
	XPToNextLevelCache[45]    = 96300
	XPToNextLevelCache[46]    = 101000
	XPToNextLevelCache[47]    = 105800
	XPToNextLevelCache[48]    = 110700
	XPToNextLevelCache[49]    = 115700
	XPToNextLevelCache[50]    = 120900
	XPToNextLevelCache[51]    = 126100
	XPToNextLevelCache[52]    = 131500
	XPToNextLevelCache[53]    = 137000
	XPToNextLevelCache[54]    = 142500
	XPToNextLevelCache[55]    = 148200
	XPToNextLevelCache[56]    = 154000
	XPToNextLevelCache[57]    = 159900
	XPToNextLevelCache[58]    = 165800
	XPToNextLevelCache[59]    = 172000
	XPToNextLevelCache[60]	  = 290000
	XPToNextLevelCache[61]	  = 317000
	XPToNextLevelCache[62]	  = 349000
	XPToNextLevelCache[63]	  = 386000
	XPToNextLevelCache[64]	  = 428000
	XPToNextLevelCache[65]	  = 475000
	XPToNextLevelCache[66]	  = 527000
	XPToNextLevelCache[67]	  = 585000
	XPToNextLevelCache[68]	  = 648000
	XPToNextLevelCache[69]	  = 717000
	XPToNextLevelCache[70] 	  = 1523800
	XPToNextLevelCache[71] 	  = 1539600
	XPToNextLevelCache[72] 	  = 1555700
	XPToNextLevelCache[73] 	  = 1571800
	XPToNextLevelCache[74] 	  = 1587900
	XPToNextLevelCache[75] 	  = 1604200
	XPToNextLevelCache[76] 	  = 1620700
	XPToNextLevelCache[77] 	  = 1637400
	XPToNextLevelCache[78] 	  = 1653900
	XPToNextLevelCache[79] 	  = 1670800

	-- Initialize the exceptions that were found by AllPlayed
	--	XPToNextLevelCache = self.db.global.cache.XPToNextLevel[build_version]
	if AllPlayed.db.global.cache.XPToNextLevel[build_version] ~= nil then
		for level = 1,69 do
			if AllPlayed.db.global.cache.XPToNextLevel[build_version][level] ~= nil then
				XPToNextLevelCache[level] = AllPlayed.db.global.cache.XPToNextLevel[build_version][level]
			end
		end
	end


end
--[[
function XPToNextLevel( level )
    if XPToNextLevelCache[level] == nil then
        XPToNextLevelCache[level] = 40 * level^2 + (5 * level + 45) * XPDiff(level) + 360 * level
    end

    return XPToNextLevelCache[level]
end


-- This is a special function that is used to had difficulty (more XP) requirement after
-- level 28
function XPDiff( level )
   local x = max( level - 28, 0 )

   if ( x < 4 ) then
      return ( x * (x + 1) ) / 2
   else
      return 5 * (x - 2)
   end
end
]]--

-- This is in preparation of patch 2.3
function XPToNextLevel( level )
	if XPToNextLevelCache[level] == nil then
		-- There are currently 4 different formulas to get the XP to next level
		-- I expect the formulas under 60 to change quite a bit
		-- See <http://www.wowwiki.com/Formulas:XP_To_Level> for details
		if     ( level < 32  ) then
			-- level 1 to 31
			XPToNextLevelCache[level] = (40 * level * level)  +  (360 * level)
			-- There is a little weird exception for level 29 to 31
			if     level == 29 then XPToNextLevelCache[level] = XPToNextLevelCache[level] + 1 * MXP(level)
			elseif level == 30 then XPToNextLevelCache[level] = XPToNextLevelCache[level] + 3 * MXP(level)
			elseif level == 31 then XPToNextLevelCache[level] = XPToNextLevelCache[level] + 6 * MXP(level)
			end
		elseif ( level < 60  ) then
			-- level 32 to 59
			XPToNextLevelCache[level] = (65 * level * level)  -  (165 * level)  -  6750
		elseif ( level == 60 ) then
			-- level 60
			XPToNextLevelCache[level] = 494000
		else
			-- level 61 to 70
			XPToNextLevelCache[level] = 155 + MXP(level) * (1344 - ( (69-level) * (3+(69-level)*4) ))
		end

		-- Round the result to the nearest 100
		XPToNextLevelCache[level] = math.floor(XPToNextLevelCache[level] / 100 + 0.5) * 100

		-- Fix the value for patch 2.3 and above (formula provided on WoWWiki)
		--[[
		if level >10 and level < 60 and "2.2.3" =~ GetBuildInfo() then
			XPToNextLevelCache[level] = math.floor((XPToNextLevelCache[level] * (1-math.min(level-10,18)/100)) /100) * 100
		end
		]]
	end

	return XPToNextLevelCache[level]
end

-- Basic amount of XP earned to kill a mob of the character current level
function MXP( level )
	-- The formula changed for TBC
	if ( level < 60 ) then
		return  45 + (5 * level)
	else
		return 235 + (5 * level)
	end

end
--[[
function AllPlayed:testXP()
--	local levels = { 60, 61, 62, 63, 64, 65, 66, 67, 68, 69 }

	for k = 61,69 do
		self:Print("%s => %s",k,XPToNextLevelCache[k])
	end
end
]]--

-- #################################################################################
-- #################################################################################
-- ##
-- ## AllPlayed.GetClassHexColour(class)
-- ## ----------------------------------
-- ##
-- ## Return the HEX color string for a specific character class
-- ##
-- ## Note: This function was taken nearly verbatim from the Bable-Class library.
-- ##       I figured seven lines of code was not worth including a library.
-- ##
-- ## Parameter: 	class				= Class name not localised
-- ##
-- ## Return:		classColor		= Hexadecimal string representing the class color
-- ##
-- #################################################################################

function AllPlayed.GetClassHexColour(class)
	if (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class]) then
		return string.format("%02x%02x%02x",
									CUSTOM_CLASS_COLORS[class].r*255,
									CUSTOM_CLASS_COLORS[class].g*255,
									CUSTOM_CLASS_COLORS[class].b*255)
	elseif (RAID_CLASS_COLORS and RAID_CLASS_COLORS[class]) then
		return string.format("%02x%02x%02x",
									RAID_CLASS_COLORS[class].r*255,
									RAID_CLASS_COLORS[class].g*255,
									RAID_CLASS_COLORS[class].b*255)
	else
		return "a1a1a1"
	end
end

-- Deathknight : b=0.23, g=0.12, r=0.77


-- #################################################################################
-- #################################################################################
-- ##
-- ## LibDataBroker section
-- ##
-- #################################################################################
-- #################################################################################

AllPlayedLDB = ldb:NewDataObject("AllPlayed", {
	type = "data source",
	text = "***AllPlayed***",
	icon = "Interface\\Icons\\INV_Misc_PocketWatch_02.blp",
})

local ldb_options = { type = 'group' }
function AllPlayedLDB:OnClick(button,down)
	
	-- The popup only when the button is release
	if down then return end
	
	-- For tests of EasyMenu
	if button ==  "RightButton" then
		AP.DisplayConfigMenu()
	end
	
	if AllPlayed.tooltip then
		AllPlayed.tooltip = lqt:Release(AllPlayed.tooltip)
		AllPlayed.tooltip_anchor = nil
		AllPlayed.OnUpdate_frame:Hide()
	end
end

function AllPlayedLDB:OnEnter(motion)
	AllPlayed:DrawTooltip(self)

end

function AllPlayedLDB:OnLeave()
	-- Nothing to so, the update frame take care of the tooltip disposal
end

--AllPlayedLDB.tooltip = AllPlayed.tablet


-- test stuff
function GSId(CategoryTitle, StatisticTitle)
	local str = ""
	for _, CategoryId in pairs(GetStatisticsCategoryList()) do
		local Title, ParentCategoryId, Something
		Title, ParentCategoryId, Something = GetCategoryInfo(CategoryId)
		
		if Title == CategoryTitle then
			local i
			local statisticCount = GetCategoryNumAchievements(CategoryId)
			for i = 1, statisticCount do
				local IDNumber, Name, Points, Completed, Month, Day, Year, Description, Flags, Image, RewardText
				IDNumber, Name, Points, Completed, Month, Day, Year, Description, Flags, Image, RewardText = GetAchievementInfo(CategoryId, i)
				if Name == StatisticTitle then
					return IDNumber
				end
			end
		end
	end
	return -1
end

--Total gold aquired = 328
--Gold looted = 333
--Gold from quest rewards = 326
--Gold earned from auctions = 919
--Gold from vendors = 921
--> "6996|TInterface\MoneyFrame\UI-GoldIcon:0:0:2:0|t 38|TInterface\MoneyFrame\UI-SilverIcon:0:0:2:0|t 2|TInterface\MoneyFrame\UI-CopperIcon:0:0:2:0|t"

