--[[ Buffology is a World of Warcraft-addon by Mischback.

	This is core.lua, where the addon-core is defined.

	##### FUNCTIONS #####
	VOID SlashHandler() - Handles the slash-command
	VOID WeaponEnchantWatcher(FRAME self, INT elapsed) - Handles weapon enchants
	VOID UpdateIcon(STRING unit, INT index, INT offset, STRING filter) - Gets the buff-/debuff-details and creates a new icon, if necessary
	VOID SetIconPositions() - Sets the positions off all (visible) icons
	VOID Trigger(STRING unit) - UNIT_AURA triggers this
]]

local ADDON_NAME, ns = ...									-- get the addons namespace to exchange functions between core and layout
local settings = ns.settings								-- get the settings
local strings = ns.strings									-- get the localization
local lib = ns.lib											-- get the lib
local menu = ns.menu										-- get the menu
local core = CreateFrame('Frame')							-- create the core
-- *****************************************************

	local Buffology = CreateFrame('Frame', 'Buffology', UIParent)
	local Buffology_trigger = CreateFrame('Frame', 'Buffology_trigger', Buffology)
	local Buffology_enchant = CreateFrame('Frame', 'Buffology_enchant', Buffology)
	local Buffology_Icons = {}
	local tempList = {}
	Buffology.framelist = {}

	--[[ Handles the slash-command
		VOID SlashHandler()
	]]
	core.SlashHandler = function(msg)
		if ( msg == strings.menutrigger ) then
			menu.CreateMenu()
			menu.MenuFrame:Show()
			for _, v in pairs(Buffology.framelist) do
				v:SetScript('OnClick', menu.BuffologySetActiveFrame)
				v:Show()
			end
		end
	end

	--[[ Handles weapon enchants
		VOID WeaponEnchantWatcher(FRAME self, INT elapsed)
		This is an OnUpdate-Eventhandler, which checks, if you have a temporary weapon-enchant.
	]]
	core.WeaponEnchantWatcher = function(self, elapsed)
		self.lastUpdate = self.lastUpdate + elapsed
		if ( self.lastUpdate > settings.static.updateInterval) then
			-- lib.debugging('checking for WeaponEnchant')

			if ( not PlayerFrame.unit or PlayerFrame.unit ~= "player" ) then
				return										-- don't check, if the player doesn't control his char
			end

			local hasMainHandEnchant, mainHandExpiration, mainHandCharges, hasOffHandEnchant, offHandExpiration, offHandCharges = GetWeaponEnchantInfo()

			local icon
			if ( hasMainHandEnchant ) then
				icon = Buffology_Icons[1]
				if ( not icon ) then
					icon = lib.CreateIcon(1)
				end
				icon.name = 'Mainhand'
				lib.CollectAura(icon.name, 'TempEnchant (MH)')
				icon.display = lib.FindDisplayFrame(icon)
				icon.texture:SetTexture(GetInventoryItemTexture('player', 16))
				icon.duration = 0
				if ( mainHandExpiration ) then
					icon.timestring:SetText(lib.TimeFormat(mainHandExpiration/1000))
					icon.timestring:Show()
				else
					icon.timestring:Hide()
				end
				icon:SetScript('OnClick', function() CancelItemTempEnchantment(1) end)
				icon:Show()
				Buffology_Icons[1] = icon
			else
				if ( Buffology_Icons[1] ) then				-- hide icon, if one has already been created
					Buffology_Icons[1]:Hide()				-- hide icon, if one has already been created
				end
			end

			if ( hasOffHandEnchant ) then
				icon = Buffology_Icons[2]
				if ( not icon ) then
					icon = lib.CreateIcon(2)
				end
				icon.name = 'Offhand'
				lib.CollectAura(icon.name, 'TempEnchant (OH)')
				icon.display = lib.FindDisplayFrame(icon)
				icon.texture:SetTexture(GetInventoryItemTexture('player', 17))
				icon.duration = 0
				if ( offHandExpiration ) then
					icon.timestring:SetText(lib.TimeFormat(offHandExpiration/1000))
					icon.timestring:Show()
				else
					icon.timestring:Hide()
				end
				icon:Show()
				icon:SetScript('OnClick', function() CancelItemTempEnchantment(2) end)
				Buffology_Icons[2] = icon
			else
				if ( Buffology_Icons[2] ) then				-- hide icon, if one has already been created
					Buffology_Icons[2]:Hide()				-- hide icon, if one has already been created
				end
			end

			self.lastUpdate = 0
		end
	end

	--[[ Gets the buff-/debuff-details and creates a new icon, if necessary.
		VOID UpdateIcon(STRING unit, INT index, INT offset, STRING filter)
	]]
	core.UpdateIcon = function(unit, index, offset, filter)
		local name, rank, texture, count, dtype, duration, timeleft, caster, _, _, spellID = UnitAura(unit, index, filter)
		local icon = Buffology_Icons[index+offset]
		if ( not name ) then								-- UNIT_AURA was triggered, but there is no aura on this index (works damn good, when an aura faded, 'cause UNIT_AURA is triggered in this case, too)
			if ( icon ) then								-- hide icon, if one has already been created
				icon:Hide()									-- hide icon, if one has already been created
			end
		else
			-- lib.debugging(spellID..': '..name)
			if ( not icon ) then							-- UNIT_AURA was triggered, but there is no icon for this index -> let's create one
				icon = lib.CreateIcon(index+offset)			-- create Icon if necessary
			end

			icon.name = name								-- set the name
			icon.spellID = spellID							-- set the spellID
			icon.texture:SetTexture(texture)				-- set the texture
			if ( filter == 'HARMFUL' ) then
				icon.isDebuff = true						-- set debuff-flag
			end

			if ( duration > 0 ) then						-- we got a time-limited aura
				icon.timeleft = timeleft					-- apply timeleft
				icon.duration = timeleft					-- apply duration
				icon:SetScript('OnUpdate', lib.UpdateAuraTime)	-- apply the OnUpdate-handler
				icon.timestring:Show()						-- show the text
			else											-- we got a permanent aura
				icon.timeleft = nil							-- no timeleft
				icon.duration = 0
				icon:SetScript('OnUpdate', nil)				-- no OnUpdate-handler necessary
				icon.timestring:Hide()						-- hide the text
			end

			icon.count:SetText((count > 1 and count))

			-- if ( icon.cd ) then								-- apply the cooldown-spiral TODO: Do we want this?
				-- if ( duration and duration > 0 ) then
					-- icon.cd:SetCooldown(timeleft - duration, duration)
					-- icon.cd:Show()
				-- else
					-- icon.cd:Hide()
				-- end
			-- end

			icon:SetID(index)

			icon.display = lib.FindDisplayFrame(icon)

			icon:Show()
			Buffology_Icons[index+offset] = icon

			lib.CollectAura(spellID, name)
		end
	end

	--[[ Sets the positions off all (visible) icons
		VOID SetIconPositions()
	]]
	core.SetIconPositions = function()
		for _, v in pairs(Buffology.framelist) do			-- clear all frames
			v.icons = 0										-- no icons in any frame
		end

		local xModifier, yModifier
		for k, v in pairs(Buffology_Icons) do
			if ( v:IsShown() ) then							-- just do positioning for visible icons

				xModifier = -1								-- default direction: LEFT
				yModifier = -1								-- default direction: DOWN

				if ( settings.frames[v.display].xGrowDir == 'RIGHT' ) then
					xModifier = 1							-- switching to grow RIGHT
				end

				if ( settings.frames[v.display].xGrowDir == 'UP' ) then
					yModifier = 1							-- switching to grow UP
				end

															-- SetPoint() OF HELL!!!
				v:ClearAllPoints()
				v:SetPoint(settings.frames[v.display].anchorPoint, 
							Buffology.framelist[v.display], 
							settings.frames[v.display].anchorPoint, 
							xModifier * (Buffology.framelist[v.display].icons % settings.frames[v.display].columns) * (settings.static.iconSize + settings.frames[v.display].xSpacing),
							yModifier * (math.floor(Buffology.framelist[v.display].icons / settings.frames[v.display].columns)) * (settings.static.iconSize + settings.frames[v.display].ySpacing) )
															-- inc the number of icons on this frame!
				Buffology.framelist[v.display].icons = Buffology.framelist[v.display].icons + 1
			end
		end
	end

	--[[ This function is triggered by UNIT_AURA. It just walks over ALL of your buffs/debuffs to make sure, none is missed.
		VOID Trigger(STRING unit)
	]]
	core.Trigger = function(_, _, unit)
		if ( unit ~= 'player' ) then return end				-- jump out, if we're not on 'player'
															-- TODO: Do we want to manage more than player-buffs?!?
		-- lib.debugging('Trigger()')
		local index
		for index = 1, settings.static.buff_maxicons do		-- handle BUFFS
			core.UpdateIcon(unit, index, settings.static.enchant_maxicons, 'HELPFUL')
		end

		for index = 1, settings.static.debuff_maxicons do	-- handle DEBUFFS
			core.UpdateIcon(unit, index, (settings.static.buff_maxicons + settings.static.enchant_maxicons), 'HARMFUL')
		end

		-- table.sort(Buffology_Icons, function(a, b) 
			-- lib.SortIcons(a, b)
		-- end)

		core.SetIconPositions()

		-- for _, v in pairs(Buffology_Icons) do
			-- if (v) then
				-- tempList[v.BuffologyID] = v
			-- end
		-- end
		-- wipe(Buffology_Icons)
		-- Buffology_Icons = tempList
		-- wipe(tempList)

	end

	Buffology:RegisterEvent('ADDON_LOADED')
	Buffology:SetScript('OnEvent', function(self, event, addon)
		if ( addon ~= ADDON_NAME ) then return end			-- jump out, if it's not our addon
		if ( not Buffology_trigger ) then return end		-- jump out, if we don't got a trigger

		-- lib.debugging('Buffology loaded...')

	-- ***** Loading the SavedVars *************************

		do
			if ( not BuffologyOptions) then
				BuffologyOptions = {}
			end
			for k, v in pairs(settings.options) do
				if type(v) ~= type(BuffologyOptions[k]) then
					BuffologyOptions[k] = v
				end
			end
			settings.options = BuffologyOptions

			if ( not BuffologyFrames) then
				BuffologyFrames = {}
			end
			for k, v in pairs(settings.frames) do
				if type(v) ~= type(BuffologyFrames[k]) then
					BuffologyFrames[k] = v
				end
			end
			settings.frames = BuffologyFrames

			if ( not BuffologyAssignments) then
				BuffologyAssignments = {}
			end
			for k, v in pairs(settings.assignments) do
				if type(v) ~= type(BuffologyAssignments[k]) then
					BuffologyAssignments[k] = v
				end
			end
			settings.assignments = BuffologyAssignments

			if ( not BuffologyAuraList ) then
				BuffologyAuraList = {}
				BuffologyAuraList['locale'] = GetLocale()
			end

			if ( not BuffologyFacade ) then
				BuffologyFacade = settings.facade
			end
			settings.facade = BuffologyFacade
		end

	-- ***** Setting Up Buffology **************************

		strings.loadLocalizedStrings()						-- get the correct localization

		local BlizzFrame = _G['BuffFrame']					-- get the default Blizzard BuffFrame
		BlizzFrame:UnregisterEvent('UNIT_AURA')				-- Unregister the event
		BlizzFrame:Hide()									-- hide the default Blizzard BuffFrame

		BlizzFrame = _G['TemporaryEnchantFrame']
		BlizzFrame:Hide()
		BlizzFrame:SetScript('OnUpdate', nil)

		SLASH_BUFFOLOGY1 = strings.slashcommand				-- register slash-command
		SlashCmdList['BUFFOLOGY'] = core.SlashHandler		-- register slash-command

		lib.SetUpFrames(settings.frames, Buffology)			-- create our frames

		Buffology_trigger:RegisterEvent('UNIT_AURA')
		Buffology_trigger:SetScript('OnEvent', core.Trigger)

		Buffology_enchant.lastUpdate = 0
		Buffology_enchant:SetScript('OnUpdate', core.WeaponEnchantWatcher)

		core.Trigger(_, _, 'player')
	end)

-- *****************************************************
ns.core = core											-- handover of the core to the namespace