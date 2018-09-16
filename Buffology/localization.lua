--[[ Buffology is a World of Warcraft-addon by Mischback.

	This is menu.lua, where the menu is defined.
]]

local ADDON_NAME, ns = ...								-- get the addons namespace to exchange functions between core and layout
local settings = ns.settings							-- get the settings
local strings = CreateFrame('Frame')					-- create the menu
-- *****************************************************

local localization = {
	['default'] = {
		['slashcommand'] = '/buffology',		-- the slash-command to trigger buffology actions
		['menutrigger'] = 'menu',				-- option to slash-command to show buffology menu
		
		['buffology_menu'] = {
			['caption_frames'] = 'Окна', 
			['caption_filter'] = 'Фильтр',
			['frame_dropdown_title'] = 'Выбирите фрейм для настройки...',
			['frame_create_new'] = 'Создать новое окно',
			['frame_create_text'] = 'Пожалуйста введите имя вашего нового окна...', 
			['frame_double_text'] = 'Это имя уже используется!', 
			['frame_create_ok'] = 'Принять', 
			['frame_create_cancel'] = 'Отменить',
			['frame_anchorPointCaption'] = 'точка переноса',
			['frame_relativeToCaption'] = 'относительно',
			['frame_relativePointCaption'] = 'относительная точка',
			['frame_xOffsetCaption'] = 'x Смещение',
			['frame_yOffsetCaption'] = 'y Смещение',
			['frame_xGrowDirCaption'] = 'гор. направление роста',
			['frame_yGrowDirCaption'] = 'вер. направление ростаgrowth direction',
			['frame_columnsCaption'] = 'колонки',
			['frame_xSpacingCaption'] = 'гор. пробел',
			['frame_ySpacingCaption'] = 'вер. пробел',
			['frame_saveButton'] = 'Сохранить',
			['filter_dropdown_title'] = 'Выбирите окно для фильтра...',
		},
	},
}

	--[[ Sets the current localization or defaults
		VOID loadLocalizedStrings()
	]]
	strings.loadLocalizedStrings = function()
		for k, v in pairs(localization['default']) do
			strings[k] = v
		end
	end

-- *****************************************************
ns.strings = strings									-- handover of the strings to the namespace