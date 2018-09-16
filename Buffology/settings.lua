--[[ Buffology is a World of Warcraft-addon by Mischback.

	This is settings.lua, where settings are initialized and stored
]]

local ADDON_NAME, ns = ...								-- get the addons namespace to exchange functions between core and layout
local settings = CreateFrame('Frame')					-- create the settings
-- *****************************************************

settings.static = {
	['iconSize'] = 30,				-- default icon-size
	['updateInterval'] = 1,			-- update-interval of the buff-durations
	['enchant_maxicons'] = 2,		-- number of max weapon-buffs to display
	['buff_maxicons'] = 32,			-- number of buffs to display
	['debuff_maxicons'] = 16,		-- number of buffs to display
}

settings.options = {
	fonts = {
		['timestring'] = 'Fonts\\FRIZQT__.TTF',
		['count'] = 'Fonts\\FRIZQT__.TTF',
	},
}

settings.frames = {
	['Buffology_buffs'] = {
		['anchorPoint'] = 'TOPRIGHT',
		['relativeTo'] = 'UIParent',
		['relativePoint'] = 'TOPRIGHT', 
		['xOffset'] = -180,
		['yOffset'] = -12,
		['xGrowDir'] = 'LEFT', 
		['yGrowDir'] = 'DOWN',
		['columns'] = 16,
		['rows'] = 2,
		['xSpacing'] = 6,
		['ySpacing'] = 10,
	},
	['Buffology_debuffs'] = {
		['anchorPoint'] = 'TOPRIGHT',
		['relativeTo'] = 'UIParent',
		['relativePoint'] = 'TOPRIGHT', 
		['xOffset'] = -180,
		['yOffset'] = -100,
		['xGrowDir'] = 'LEFT', 
		['yGrowDir'] = 'DOWN',
		['columns'] = 4,
		['rows'] = 4,
		['xSpacing'] = 6,
		['ySpacing'] = 10,
	},
}

settings.assignments = {}

settings.facade = {
	groups = {
		['Buffs/Debuffs'] = {
			skin =  'Blizzard',
			gloss = false,
			backdrop = false,
			colors = {},
		},
	},
}

-- *****************************************************
ns.settings = settings									-- handover of the settings to the namespace