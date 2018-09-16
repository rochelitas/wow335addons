local L = LibStub("AceLocale-3.0"):NewLocale("BuffEnough", "enUS", true)

-- basics

L["BuffEnough"] = true
L["Buff Enough"] = true
L["buffenough"] = true
L["be"] = true

L["Yes"] = true
L["No"] = true
L["Warning"] = true

-- config strings

L["config"] = true
L["Toggle the configuration dialog"] = true

L["General"] = true
L["Enable While Solo"] = true
L["Enable BuffEnough while not in a party/raid"] = true
L["Check In Combat"] = true
L["Continue to do buff checks even while in combat"] = true
L["Warn"] = true
L["Display shows warning color when you are buff enough but one or more buffs is about to expire"] = true
L["Warn Minimum Buff Time"] = true
L["The minimum buff duration in minutes before we check for expiration. Set to 0 for no minimum"] = true
L["Warn Threshold"] = true
L["The number of minutes left on the buff before we warn"] = true
L["Fade"] = true
L["Fade frame after this many seconds of being buff enough. Set to 0 for no fading"] = true

L["Blessings"] = true
L["None"] = true
L["Override"] = true
L["Overrides the default paladin blessing priority and uses the priority you specify."] = true
L["Blessing"] = true

L["Consumables"] = true
L["Check Flask/Elixirs"] = true
L["Check whether or not you have either a flask or Guardian and Battle elixirs"] = true
L["Check Food"] = true
L["Check whether or not you have a food buff"] = true
L["Check Pet Food"] = true
L["Check whether or not your pet has a food buff"] = true
L["Check Weapon"] = true
L["Check whether or not you have a temporary weapon enchant"] = true
L["Check Chest"] = true
L["Check whether or not your chest has a Rune of Warding"] = true
L["Only Check In Raid"] = true
L["Only check consumable use when in a raid"] = true

L["Custom"] = true
L["Select the desired category and behavior from the dropdown menu and enter the name of a buff. You can use this to ignore an existing buff check or add a new one."] = true
L["You must select an action and category from the dropdown menu to associate with this buff"] = true
L["You must enter a value for the buff name"] = true
L["Buff"] = true
L["Action"] = true
L["Category"] = true
L["Expected"] = true
L["Ignored"] = true
L["Delete"] = true
L["Are you sure you want to delete this custom buff?"] = true

L["Display"] = true
L["Show Display"] = true
L["Shows the display"] = true
L["Lock"] = true
L["Lock the display"] = true
L["Scale"] = true
L["Scale of the display"] = true
L["Opacity"] = true
L["Opacity of the display"] = true
L["Strata"] = true
L["Strata of the display"] = true
L["Buff Color"] = true
L["Color to display when you are buff enough"] = true
L["Unbuff Color"] = true
L["Color to display when you are not buff enough"] = true
L["Warn Buff Color"] = true
L["Color to display when you are buffs are at a warning level"] = true
L["Border Color"] = true
L["Color of the display border"] = true
L["Border Size"] = true
L["Thickness of the display border"] = true
L["Background Inset"] = true
L["How far inside the border to set the background of the display"] = true
L["Background Texture"] = true
L["The background texture of the display"] = true
L["Border Texture"] = true
L["The border texture of the display"] = true

L["Check Pet Buffs"] = true
L["Check pet for the same raid buffs as the player"] = true

L["Profile: %s"] = true

-- gear

L["HeadSlot"] = "Head"
L["NeckSlot"] = "Neck"
L["ShoulderSlot"] = "Shoulders"
L["BackSlot"] = "Back"
L["ChestSlot"] = "Chest"
L["WristSlot"] = "Wrist"
L["HandsSlot"] = "Hands"
L["WaistSlot"] = "Waist"
L["LegsSlot"] = "Legs"
L["FeetSlot"] = "Feet"
L["Finger0Slot"] = "Finger1"
L["Finger1Slot"] = "Finger2"
L["Trinket0Slot"] = "Trinket1"
L["Trinket1Slot"] = "Trinket2"
L["MainHandSlot"] = "Main Hand Weapon"
L["SecondaryHandSlot"] = "Off Hand Weapon/Shield"
L["RangedSlot"] = "Ranged"

L["Mainhand Buff"] = true
L["Offhand Buff"] = true
L["Rune of Warding"] = true

-- tooltip output

L["Buffs"] = true
L["Gear"] = true
L["Pet"] = true

L["Missing"] = true
L["Broken"] = true
L["Unexpected"] = true
L["Low"] = true
L["Unhappy"] = true

L["Aura"] = true

L["Hint"] = "\n\n|cffafa4ffHint:|r |cffffffffLeft-click to run check|r\n|cffafa4ffHint:|r |cffffffffRight-click to report missing buffs|r\n|cffafa4ffHint:|r |cffffffffShift-right-click to whisper missing buffs|r"
L["No buffer known for "] = true
L["All buffs accounted for!"] = true
L["Currently disabled"] = true

-- buffs

L["Mage/Molten Armor"] = true
L["Fel/Demon Armor"] = true
L["Aspect"] = true
L["Elemental Shield"] = true
L["Flask/Elixirs"] = true
L["Flask of"] = true
L["of Shattrath"] = true
L["Battle Elixir"] = true
L["Guardian Elixir"] = true
