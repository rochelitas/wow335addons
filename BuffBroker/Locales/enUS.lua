-- Most of this file is automatically generated.  To contribute translations or alterations, go to:
-- http://www.curseforge.com/addons/buffbroker/localization/

local fileLocale = "enUS"
-- if: game language matches this file translation table
if GetLocale() == fileLocale then
	local L = LibStub("AceLocale-3.0"):NewLocale("BuffBroker", fileLocale, true, debug)
	
	-- if: able to link to localization library
	if L then

L["Add to Call of Elements totem bar"] = true
L["AI"] = "Arcane Intellect"
L["AI_DESC"] = "Inspire the intellect of your allies"
L["AIR_TOTEMS"] = "Air Totems"
L["AIR_TOTEMS_DESC"] = "Suggest the best air totem for your allies"
L["Appearance"] = true
L["Attendance Threshold"] = true
L["AURAS"] = "Auras"
L["AURAS_DESC"] = "Suggest the best aura for your allies"
L["Beast"] = true
L["Behavior"] = true
L["Best totem for this group"] = true
L["BINDINGS_BUTTON1"] = "Cast the next suggested enhancement"
L["BLESSINGS"] = "Blessings"
L["BLESSINGS_DESC"] = "Suggest the best way to bolster your allies with might, wisdom, sanctuary, or kings"
L["BOTTOM"] = "Bottom"
L["BOTTOMLEFT"] = "Bottom Left"
L["BOTTOMRIGHT"] = "Bottom Right"
L["BuffBroker:  0 headcount...profiling incomplete, or error'd"] = true
L["BuffBroker:  Internal error, suggestions contain different role counts"] = true
L["Buff Broker is starting up"] = true
L["Buff Broker: Save format changed! please check your settings in the Interface -> AddOns menu"] = true
L["Buff Selection"] = true
L["Buff Selection - Dual Spec"] = true
L["buildSuggestions"] = true
L["Caster"] = true
L["Cast on %s the %s"] = true
L["catastropic mistake;  coverage not completing"] = true
L["Change how Buff Broker handles group-wide buffs"] = true
L["Change how Buff Broker looks, feels, and fits"] = true
L["change the size of the button"] = true
L["Clear cached data and restart the addon"] = true
L["Combat"] = true
L["%d/%d players profiled"] = "%d/%d targets nearby and profiled (players & pets)"
L["Dead"] = true
L["Demon"] = true
L["Disable the UI Move Bar"] = true
L["%d%% of %s nearby"] = "%d%% of %s nearby (players & pets)"
L["%d%% of targets nearby"] = true
L["don't apply buffs another raid member cast, even if theirs expires"] = true
L["don't use class/raid wide buffs when only one eligible target exists"] = true
L["dumpSuggestions"] = true
L["EARTH_TOTEMS"] = "Earth Totems"
L["EARTH_TOTEMS_DESC"] = "Suggest the best earth totem for your allies"
L["EMBRACE"] = "Vampiric Embrace"
L["EMBRACE_DESC"] = "Re-activate your vampiric embrace"
L["Enabled"] = true
L["Felguard"] = true
L["Felhunter"] = true
L["FIRE_TOTEMS"] = "Fire Totems"
L["FIRE_TOTEMS_DESC"] = "Suggest the best fire totem for your allies"
L["FORTITUDE"] = "Fortitude"
L["FORTITUDE_DESC"] = "Enhance the fortitude of your allies"
L["Friendly"] = true
L["Frugal"] = true
L["general"] = true
L["General Settings"] = true
L["Head Count Threshold"] = true
L["Healer"] = true
L["Healer Level"] = true
L["Hidden while Idle"] = true
L["Hide"] = true
L["Hides the main window"] = true
L["Hide the main button when no action required (background scanning still active)"] = true
L["HORNS"] = "Horns"
L["HORNS_DESC"] = "Blow the Horn of Winter"
L["Idle"] = true
L["Imp"] = true
L["LEFT"] = "Left"
L["Loading..."] = true
L["Lock UI"] = true
L["Low level Melee DPS (mana user)"] = true
L["MAGE_ARMOR"] = "Mage Armor"
L["MAGE_ARMOR_DESC"] = "Re-activate your last used icy, frost, molten, or arcane armor"
L["Main Button"] = true
L["makes buff recommendations based on raid, active buffs, and raid member talents/abilities"] = true
L["Melee DPS"] = true
L["Melee DPS (mana user)"] = true
L["minimum # of targets nearby, in order to cast a raid-wide spell"] = true
L["minimum % of targets nearby, in order to cast a raid-wide spell"] = true
L["No Role"] = true
L["Nothing to suggest"] = true
L["Output Suggestions"] = true
L["Perform a full scan of the buffs active on your current group"] = true
L["Perform a full scan of the buffs available to your current group"] = true
L["perform unit tests against sample party compositions"] = true
L["perform unit tests for suggestions against sample parties"] = true
L["Pick which Buffs to parse, analyze, and suggest"] = true
L["Pick which Buffs to parse, analyze, and suggest for your offspec"] = true
L["Position of the Tooltip, relative to the buff button"] = true
L["Prefer mana regeneration over stats, for healers under this level"] = true
L["PRIEST_FORM"] = "Shadowform"
L["PRIEST_FORM_DESC"] = "Assume a Shadow Form"
L["PRIEST_INNER"] = "Inner Power"
L["PRIEST_INNER_DESC"] = "re-active your inner fire"
L["PRIEST_PROTECTION"] = "Shadow Protection"
L["PRIEST_PROTECTION_DESC"] = "Protect your party from shadow damage (disregards comparative auras)"
L["print suggestions (sorted) to the chat window; includes relevant sort criteria"] = true
L["Refresh buffs with less than X seconds remaining (0 = when it expires)"] = true
L["RefreshConfig"] = true
L["Refresh this last-used self buff"] = true
L["Refresh Time"] = true
L["Reset"] = true
L["return suggestions for number of party members"] = true
L["RIGHT"] = "Right"
L["RIGHTEOUS_FURY"] = "Righteous Fury"
L["RIGHTEOUS_FURY_DESC"] = "Light, give me threat!"
L["ROGUE_POISONS"] = "Rogue Poisons"
L["ROGUE_POISONS_DESC"] = "re-apply the last used poison on your main/off hand weapon"
L["SEALS"] = "Seals"
L["SEALS_DESC"] = "Re-empower your weapon with vengeance, wisdom, light, righteousness, or command"
L["SHAPESHIFT"] = "Shapeshift"
L["SHAPESHIFT_DESC"] = "Assume the form of a Moonkin or the Tree of Life"
L["SHOUTS"] = "Shouts"
L["SHOUTS_DESC"] = "Suggest the best Shout, to bolster the physical power or health of allies"
L["Show"] = true
L["Show/Hide the main button (scanning disabled while hidden)"] = true
L["Shows the main window"] = true
L["SPIRIT"] = "Spirit"
L["SPIRIT_DESC"] = "Energize the spirit of your allies"
L["Succubus"] = true
L["suggest"] = true
L["Suggestions Disabled while dead"] = true
L["Suggestions Disabled while in a vehicle"] = true
L["Suggestions Disabled while in combat"] = true
L["Support"] = true
L["Suspend/resume this addon"] = true
L["Tank"] = true
L["Test: Buff Providers"] = true
L["Test, fix, or reset Buff Broker"] = true
L["Test: Suggestions"] = true
L["THORNS"] = "Thorns"
L["THORNS_DESC"] = "Cover your tanking allies in thorns"
L["Tooltip Position"] = true
L["TOP"] = "Top"
L["TOPLEFT"] = "Top Left"
L["TOPRIGHT"] = "Top Right"
L["UI Scaling"] = true
L["Unknown Role"] = true
L["Vehicle"] = true
L["Visible"] = true
L["Voidwalker"] = true
L["WARLOCK_ARMOR"] = "Warlock Armor"
L["WARLOCK_ARMOR_DESC"] = "Re-active your last used fel or demon armor"
L["WATER_TOTEMS"] = "Water Totems"
L["WATER_TOTEMS_DESC"] = "Suggest the best water totem for your allies"
L["WILD"] = "The Wilds"
L["WILD_DESC"] = "Empower your allies with the gift or mark of the wild"


	end -- if: able to link to localization library
end -- if: game language matches this file translation table