--[[ Buffology is a World of Warcraft-addon by Mischback.

	This is menu.lua, where the menu is defined.
]]

local ADDON_NAME, ns = ...								-- get the addons namespace to exchange functions between core and layout
local settings = ns.settings							-- get the settings
local strings = ns.strings								-- get the localization
local lib = ns.lib										-- get the lib
local menu = CreateFrame('Frame')						-- create the menu

local MENUFRAMENAME = 'BuffologyMenu'
menu.info = {}
menu.bufflist = {}
-- *****************************************************

BuffologyMenuFunctions = {
	-- These are general functions
	['General'] = {
		-- this closes the menu (hide the frame and the buff-anchors)
		['CloseMenu'] = function()
			for _, v in pairs(_G['Buffology'].framelist) do	-- Hide the frame-anchors
				v:Hide()
			end
			menu.MenuFrame:Hide()							-- Hide the menu
		end,

		-- apply localized strings
		['OnShow'] = function()
			_G[MENUFRAMENAME..'ButtonFrames']:SetText(strings.buffology_menu.caption_frames)	-- set the text of the "Frames"-button
			_G[MENUFRAMENAME..'ButtonFilter']:SetText(strings.buffology_menu.caption_filter)	-- set the text of the "Filters"-button
		end,

		-- OnClick-Handler for tab-buttons
		['TabButtonOnClick'] = function(button)
			_G[MENUFRAMENAME..'TabFrames']:Hide()
			_G[MENUFRAMENAME..'TabFilter']:Hide()
			local _, item = string.find(button, MENUFRAMENAME..'Button')
			item = string.sub(button, item + 1)
			_G[MENUFRAMENAME..'Tab'..item]:Show()
		end,
	},
	
	-- These functions handle the "Frames"-tab
	['TabFrames'] = {
		-- This is executed, when the "Frames"-tab becomes visible
		['OnShow'] = function(name)
			_G[name..'Caption']:SetText(strings.buffology_menu.caption_frames)	-- set the panel's caption
			_G[name..'FrameTitle']:SetText(strings.buffology_menu.frame_dropdown_title)	-- set the panel's caption
			_G[name..'Option_Save']:SetText(strings.buffology_menu.frame_saveButton)
			_G[name..'Option_anchorPointCaption']:SetText(strings.buffology_menu.frame_anchorPointCaption..':')
			_G[name..'Option_relativeToCaption']:SetText(strings.buffology_menu.frame_relativeToCaption..':')
			_G[name..'Option_relativePointCaption']:SetText(strings.buffology_menu.frame_relativePointCaption..':')
			_G[name..'Option_xOffsetCaption']:SetText(strings.buffology_menu.frame_xOffsetCaption..':')
			_G[name..'Option_yOffsetCaption']:SetText(strings.buffology_menu.frame_yOffsetCaption..':')
			_G[name..'Option_xGrowDirCaption']:SetText(strings.buffology_menu.frame_xGrowDirCaption..':')
			_G[name..'Option_yGrowDirCaption']:SetText(strings.buffology_menu.frame_yGrowDirCaption..':')
			_G[name..'Option_columnsCaption']:SetText(strings.buffology_menu.frame_columnsCaption..':')
			_G[name..'Option_xSpacingCaption']:SetText(strings.buffology_menu.frame_xSpacingCaption..':')
			_G[name..'Option_ySpacingCaption']:SetText(strings.buffology_menu.frame_ySpacingCaption..':')
			_G[name..'Option_anchorPointEditBox']:SetText('')
			_G[name..'Option_relativeToEditBox']:SetText('')
			_G[name..'Option_relativePointEditBox']:SetText('')
			_G[name..'Option_xOffsetEditBox']:SetText('')
			_G[name..'Option_yOffsetEditBox']:SetText('')
			_G[name..'Option_xGrowDirEditBox']:SetText('')
			_G[name..'Option_yGrowDirEditBox']:SetText('')
			_G[name..'Option_columnsEditBox']:SetText('')
			_G[name..'Option_xSpacingEditBox']:SetText('')
			_G[name..'Option_ySpacingEditBox']:SetText('')
		end,

		-- Builds the DropDownMenu
		['FrameDropDown_OnLoad'] = function()
			wipe(menu.info)
			menu.info.text = strings.buffology_menu.frame_dropdown_title
			menu.info.isTitle = 1
			UIDropDownMenu_AddButton(menu.info)

			for k, v in pairs(settings.frames) do
				wipe(menu.info)
				menu.info.text = k
				menu.info.func = menu.BuffologySetActiveFrame
				UIDropDownMenu_AddButton(menu.info)
			end

			wipe(menu.info)
			menu.info.text = strings.buffology_menu.frame_create_new
			menu.info.func = menu.BuffologyCreateNewFrame
			UIDropDownMenu_AddButton(menu.info)
		end,

		-- Saves the new values
		['Save'] = function()
			local name = this:GetParent():GetName()
			local frame = _G[name..'FrameTitle']:GetText()
			if ( frame ~= strings.buffology_menu.frame_dropdown_title ) then
				-- lib.debugging(frame)
				if ( not settings.frames[frame] ) then return end

				settings.frames[frame].anchorPoint = _G[name..'Option_anchorPointEditBox']:GetText()
				settings.frames[frame].relativeTo = _G[name..'Option_relativeToEditBox']:GetText()
				settings.frames[frame].relativePoint = _G[name..'Option_relativePointEditBox']:GetText()
				settings.frames[frame].xOffset = _G[name..'Option_xOffsetEditBox']:GetText()
				settings.frames[frame].yOffset = _G[name..'Option_yOffsetEditBox']:GetText()
				settings.frames[frame].xGrowDir = _G[name..'Option_xGrowDirEditBox']:GetText()
				settings.frames[frame].yGrowDir = _G[name..'Option_yGrowDirEditBox']:GetText()
				settings.frames[frame].columns = _G[name..'Option_columnsEditBox']:GetText()
				settings.frames[frame].xSpacing = _G[name..'Option_xSpacingEditBox']:GetText()
				settings.frames[frame].ySpacing = _G[name..'Option_ySpacingEditBox']:GetText()

				_G[frame]:SetPoint(settings.frames[frame].anchorPoint, settings.frames[frame].relativeTo, settings.frames[frame].relativePoint, settings.frames[frame].xOffset, settings.frames[frame].yOffset)
			end
		end,
	},
	
	-- These functions handle the "Filter"-tab
	['TabFilter'] = {
		-- This is executed, when the "Filter"-tab becomes visible (builds the buff list and applies the localized strings)
		['OnShow'] = function(name)

			-- lib.debugging('OnShow()')

			_G[name..'Caption']:SetText(strings.buffology_menu.caption_filter)	-- set the panel's caption
			_G[name..'SelectedAuraID']:SetText('')
			_G[name..'SelectedAuraName']:SetText('')
			_G[name..'SelectedFrame']:SetText('')

			if ( not BuffologyAuraList ) then return end

			local k, v, offset
			wipe(menu.bufflist)
			offset = 1
			for k, v in pairs(BuffologyAuraList) do
				if ( k ~= 'locale' ) then
					menu.bufflist[offset] = {}
					menu.bufflist[offset]['name'] = v
					menu.bufflist[offset]['spellID'] = k
					-- lib.debugging(offset..': '..menu.bufflist[offset].name..' ('..menu.bufflist[offset].spellID..')')
					offset = offset + 1
				end
			end
			table.sort(menu.bufflist, function(a, b) return a.name < b.name end)
		end,

		-- Updates the AuraList
		['AuraList_Update'] = function()

			-- lib.debugging('AuraList_Update()')

			if (#menu.bufflist == 0) then
				BuffologyMenuFunctions.TabFilter.OnShow(MENUFRAMENAME..'TabFilter')
			end

			local numAura = #menu.bufflist
			local line, offset, item

			FauxScrollFrame_Update(_G[MENUFRAMENAME..'TabFilterList'], numAura, 15, 16)

			for line = 1, 15 do
				offset = line + FauxScrollFrame_GetOffset(_G[MENUFRAMENAME..'TabFilterList'])
				if ( offset <= numAura ) then
					_G[MENUFRAMENAME..'TabFilterEntry'..line]:Show()
					_G[MENUFRAMENAME..'TabFilterEntry'..line].offset = offset
					if ( settings.assignments[tostring(menu.bufflist[offset].spellID)] ) then
						_G[MENUFRAMENAME..'TabFilterEntry'..line]:SetFormattedText('|cff00FF00%s|r', menu.bufflist[offset].name)
					else
						_G[MENUFRAMENAME..'TabFilterEntry'..line]:SetFormattedText('|cffDDDDDD%s|r', menu.bufflist[offset].name)
					end
					-- _G[MENUFRAMENAME..'TabFilterEntry'..line]:SetText(menu.bufflist[offset].name)
				else
					_G[MENUFRAMENAME..'TabFilterEntry'..line]:Hide()
				end
			end
		end,

		-- Sets the selected aura
		['AuraList_OnClick'] = function(offset)
			_G[MENUFRAMENAME..'TabFilterSelectedAuraID']:SetText(menu.bufflist[offset].spellID)
			_G[MENUFRAMENAME..'TabFilterSelectedAuraName']:SetText(menu.bufflist[offset].name)
			if ( settings.assignments[tostring(menu.bufflist[offset].spellID)] ) then
				_G[MENUFRAMENAME..'TabFilterSelectedFrame']:SetText(settings.assignments[tostring(menu.bufflist[offset].spellID)])
			else
				_G[MENUFRAMENAME..'TabFilterSelectedFrame']:SetText(strings.buffology_menu.filter_dropdown_title)
			end
		end,

		-- builds the DropDownMenu
		['FrameDropDown_OnLoad'] = function()
			wipe(menu.info)
			menu.info.text = strings.buffology_menu.filter_dropdown_title
			menu.info.isTitle = 1
			UIDropDownMenu_AddButton(menu.info)

			for k, v in pairs(settings.frames) do
				wipe(menu.info)
				menu.info.text = k
				menu.info.func = menu.BuffologySetFilterFrame
				UIDropDownMenu_AddButton(menu.info)
			end
		end,

		-- Saves the assignment
		['Save'] = function()
			-- local name = this:GetParent():GetName()
			local frame = _G[MENUFRAMENAME..'TabFilterSelectedFrame']:GetText()
			if ( frame ~= strings.buffology_menu.filter_dropdown_title ) then
				settings.assignments[_G[MENUFRAMENAME..'TabFilterSelectedAuraID']:GetText()] = _G[MENUFRAMENAME..'TabFilterSelectedFrame']:GetText()
			end
		end,
	},
}

-- *****************************************************

	--[[
	
	]]
	menu.BuffologySetActiveFrame = function()
		if (not _G[MENUFRAMENAME]) then return end
		local frame = this.value or this:GetName()
		_G[MENUFRAMENAME..'TabFramesFrameTitle']:SetText(frame)
		_G[MENUFRAMENAME..'TabFramesOption_anchorPointEditBox']:SetText(settings.frames[frame].anchorPoint)
		_G[MENUFRAMENAME..'TabFramesOption_relativeToEditBox']:SetText(settings.frames[frame].relativeTo)
		_G[MENUFRAMENAME..'TabFramesOption_relativePointEditBox']:SetText(settings.frames[frame].relativePoint)
		_G[MENUFRAMENAME..'TabFramesOption_xOffsetEditBox']:SetText(settings.frames[frame].xOffset)
		_G[MENUFRAMENAME..'TabFramesOption_yOffsetEditBox']:SetText(settings.frames[frame].yOffset)
		_G[MENUFRAMENAME..'TabFramesOption_xGrowDirEditBox']:SetText(settings.frames[frame].xGrowDir)
		_G[MENUFRAMENAME..'TabFramesOption_yGrowDirEditBox']:SetText(settings.frames[frame].yGrowDir)
		_G[MENUFRAMENAME..'TabFramesOption_columnsEditBox']:SetText(settings.frames[frame].columns)
		_G[MENUFRAMENAME..'TabFramesOption_xSpacingEditBox']:SetText(settings.frames[frame].xSpacing)
		_G[MENUFRAMENAME..'TabFramesOption_ySpacingEditBox']:SetText(settings.frames[frame].ySpacing)
	end

	--[[
	
	]]
	menu.BuffologySetFilterFrame = function()
		if (not _G[MENUFRAMENAME]) then return end
		local frame = this.value or this:GetName()
		_G[MENUFRAMENAME..'TabFilterSelectedFrame']:SetText(frame)
	end

	--[[
	
	]]
	menu.BuffologyCreateNewFrame = function()
		StaticPopup_Show('BUFFOLOGY_CREATE_FRAME_DIALOG1')
	end

	--[[
	
	]]
	menu.BuffologyInitializeNewFrame = function(newName)
		if ( (not newName) or (newName == '') ) then return end
		if (settings.frames[newName]) then
			StaticPopup_Show('BUFFOLOGY_CREATE_FRAME_DIALOG2')
		else
			settings.frames[newName] = {
				['anchorPoint'] = 'CENTER',
				['relativeTo'] = 'UIParent',
				['relativePoint'] = 'CENTER', 
				['xOffset'] = 0,
				['yOffset'] = 0,
				['xGrowDir'] = 'LEFT', 
				['yGrowDir'] = 'DOWN',
				['columns'] = 16,
				['xSpacing'] = 6,
				['ySpacing'] = 10,
			}
			lib.SetUpFrames(settings.frames, _G['Buffology'])
			_G['Buffology'].framelist[newName]:Show()
		end
	end

	--[[
	
	]]
	menu.CreateMenu = function()
		if menu.MenuFrame then return end

		StaticPopupDialogs['BUFFOLOGY_CREATE_FRAME_DIALOG1'] = {
			text = strings.buffology_menu.frame_create_text,
			button1 = strings.buffology_menu.frame_create_ok,
			button2 = strings.buffology_menu.frame_create_cancel,
			hasEditBox = true,
			OnAccept = function(self)
				menu.BuffologyInitializeNewFrame(self.editBox:GetText())
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
		}

		StaticPopupDialogs['BUFFOLOGY_CREATE_FRAME_DIALOG2'] = {
			text = strings.buffology_menu.frame_double_text,
			button1 = strings.buffology_menu.frame_create_ok,
			button2 = strings.buffology_menu.frame_create_cancel,
			OnAccept = function(self)
				return
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
		}

		local frame = CreateFrame('Frame', MENUFRAMENAME, UIParent, 'BuffologyMenuSkel')

		frame:Hide()
		menu.MenuFrame = frame
	end

-- *****************************************************
ns.menu = menu											-- handover of the menu to the namespace