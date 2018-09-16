--[[ ---------------------------------------------------------------------------

BuffEnough: personal buff monitor.

BuffEnough is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

BuffEnough is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License
along with BuffEnough.  If not, see <http://www.gnu.org/licenses/>.

----------------------------------------------------------------------------- ]]


local L = LibStub("AceLocale-3.0"):GetLocale("BuffEnough")


BuffEnough.knownSpells = {}
BuffEnough.spells = {}
BuffEnough.spellMap = {}
BuffEnough.blessings = {}
BuffEnough.groupBuffs = {}
BuffEnough.flasks = {}
BuffEnough.battleElixirs = {}
BuffEnough.guardianElixirs = {}

-- Death Knights

BuffEnough.spells["Horn of Winter"] = GetSpellInfo(57330)
BuffEnough.spells["Frost Presence"] = GetSpellInfo(48263)

-- Druids
BuffEnough.spells["Mark of the Wild"] = GetSpellInfo(1126)
BuffEnough.spells["Gift of the Wild"] = GetSpellInfo(21849)

BuffEnough.spellMap[BuffEnough.spells["Gift of the Wild"]] = BuffEnough.spells["Mark of the Wild"]

BuffEnough.groupBuffs[BuffEnough.spells["Gift of the Wild"]] = true

-- Hunter
BuffEnough.spells["Aspect of the Pack"] = GetSpellInfo(13159)
BuffEnough.spells["Aspect of the Cheetah"] = GetSpellInfo(5118)
BuffEnough.spells["Aspect of the Beast"] = GetSpellInfo(13161)

BuffEnough.spells["Aspect of the Monkey"] = GetSpellInfo(13163)
BuffEnough.spells["Aspect of the Viper"] = GetSpellInfo(34074)
BuffEnough.spells["Aspect of the Wild"] = GetSpellInfo(20043)
BuffEnough.spells["Aspect of the Hawk"] = GetSpellInfo(13165)
BuffEnough.spells["Aspect of the Dragonhawk"] = GetSpellInfo(61847)
BuffEnough.spells["Aspect"] = L["Aspect"]

BuffEnough.spells["Trueshot Aura"] = GetSpellInfo(19506)

BuffEnough.spellMap[BuffEnough.spells["Aspect of the Monkey"]] = BuffEnough.spells["Aspect"]
BuffEnough.spellMap[BuffEnough.spells["Aspect of the Viper"]] = BuffEnough.spells["Aspect"]
BuffEnough.spellMap[BuffEnough.spells["Aspect of the Wild"]] = BuffEnough.spells["Aspect"]
BuffEnough.spellMap[BuffEnough.spells["Aspect of the Hawk"]] = BuffEnough.spells["Aspect"]
BuffEnough.spellMap[BuffEnough.spells["Aspect of the Dragonhawk"]] = BuffEnough.spells["Aspect"]

-- Mages
BuffEnough.spells["Arcane Intellect"] = GetSpellInfo(1459)
BuffEnough.spells["Arcane Brilliance"] = GetSpellInfo(23028)
BuffEnough.spells["Dalaran Intellect"] = GetSpellInfo(61024)
BuffEnough.spells["Dalaran Brilliance"] = GetSpellInfo(61316)
BuffEnough.spells["Mage Armor"] = GetSpellInfo(6117)
BuffEnough.spells["Molten Armor"] = GetSpellInfo(30482)
BuffEnough.spells["Mage/Molten Armor"] = L["Mage/Molten Armor"]

BuffEnough.spellMap[BuffEnough.spells["Arcane Brilliance"]] = BuffEnough.spells["Arcane Intellect"]
BuffEnough.spellMap[BuffEnough.spells["Dalaran Intellect"]] = BuffEnough.spells["Arcane Intellect"]
BuffEnough.spellMap[BuffEnough.spells["Dalaran Brilliance"]] = BuffEnough.spells["Arcane Intellect"]
BuffEnough.spellMap[BuffEnough.spells["Mage Armor"]] = BuffEnough.spells["Mage/Molten Armor"]
BuffEnough.spellMap[BuffEnough.spells["Molten Armor"]] = BuffEnough.spells["Mage/Molten Armor"]

BuffEnough.groupBuffs[BuffEnough.spells["Arcane Brilliance"]] = true
BuffEnough.groupBuffs[BuffEnough.spells["Dalaran Brilliance"]] = true

-- Paladins
BuffEnough.spells["Blessing of Kings"] = GetSpellInfo(20217)
BuffEnough.spells["Blessing of Might"] = GetSpellInfo(19740)
BuffEnough.spells["Blessing of Sanctuary"] = GetSpellInfo(20911)
BuffEnough.spells["Blessing of Wisdom"] = GetSpellInfo(48936)
BuffEnough.spells["Greater Blessing of Kings"] = GetSpellInfo(25898)
BuffEnough.spells["Greater Blessing of Might"] = GetSpellInfo(25782)
BuffEnough.spells["Greater Blessing of Sanctuary"] = GetSpellInfo(25899)
BuffEnough.spells["Greater Blessing of Wisdom"] = GetSpellInfo(25894)

BuffEnough.spellMap[BuffEnough.spells["Greater Blessing of Kings"]] = BuffEnough.spells["Blessing of Kings"]
BuffEnough.spellMap[BuffEnough.spells["Greater Blessing of Might"]] = BuffEnough.spells["Blessing of Might"]
BuffEnough.spellMap[BuffEnough.spells["Greater Blessing of Sanctuary"]] = BuffEnough.spells["Blessing of Sanctuary"]
BuffEnough.spellMap[BuffEnough.spells["Greater Blessing of Wisdom"]] = BuffEnough.spells["Blessing of Wisdom"]

BuffEnough.blessings[BuffEnough.spells["Blessing of Kings"]] = true
BuffEnough.blessings[BuffEnough.spells["Blessing of Might"]] = true
BuffEnough.blessings[BuffEnough.spells["Blessing of Sanctuary"]] = true
BuffEnough.blessings[BuffEnough.spells["Blessing of Wisdom"]] = true
BuffEnough.blessings[BuffEnough.spells["Greater Blessing of Kings"]] = true
BuffEnough.blessings[BuffEnough.spells["Greater Blessing of Might"]] = true
BuffEnough.blessings[BuffEnough.spells["Greater Blessing of Sanctuary"]] = true
BuffEnough.blessings[BuffEnough.spells["Greater Blessing of Wisdom"]] = true

BuffEnough.spells["Concentration Aura"] = GetSpellInfo(19746)
BuffEnough.spells["Crusader Aura"] = GetSpellInfo(32223)
BuffEnough.spells["Devotion Aura"] = GetSpellInfo(465)
BuffEnough.spells["Fire Resistance Aura"] = GetSpellInfo(19891)
BuffEnough.spells["Frost Resistance Aura"] = GetSpellInfo(19888)
BuffEnough.spells["Retribution Aura"] = GetSpellInfo(7294)
BuffEnough.spells["Shadow Resistance Aura"] = GetSpellInfo(19876)

BuffEnough.spells["Righteous Fury"] = GetSpellInfo(25780)

-- Priests
BuffEnough.spells["Power Word: Fortitude"] = GetSpellInfo(1243)
BuffEnough.spells["Prayer of Fortitude"] = GetSpellInfo(21562)
BuffEnough.spells["Divine Spirit"] = GetSpellInfo(14752)
BuffEnough.spells["Prayer of Spirit"] = GetSpellInfo(27681)
BuffEnough.spells["Inner Fire"] = GetSpellInfo(588)

BuffEnough.spellMap[BuffEnough.spells["Prayer of Fortitude"]] = BuffEnough.spells["Power Word: Fortitude"]
BuffEnough.spellMap[BuffEnough.spells["Prayer of Spirit"]] = BuffEnough.spells["Divine Spirit"]

BuffEnough.groupBuffs[BuffEnough.spells["Prayer of Fortitude"]] = true
BuffEnough.groupBuffs[BuffEnough.spells["Prayer of Spirit"]] = true

-- Shamans
BuffEnough.spells["Strength of Earth"] = GetSpellInfo(58646)
BuffEnough.spells["Lightning Shield"] = GetSpellInfo(324)
BuffEnough.spells["Earth Shield"] = GetSpellInfo(974)
BuffEnough.spells["Water Shield"] = GetSpellInfo(52127)
BuffEnough.spells["Elemental Shield"] = L["Elemental Shield"]

BuffEnough.spellMap[BuffEnough.spells["Lightning Shield"]] = BuffEnough.spells["Elemental Shield"]
BuffEnough.spellMap[BuffEnough.spells["Earth Shield"]] = BuffEnough.spells["Elemental Shield"]
BuffEnough.spellMap[BuffEnough.spells["Water Shield"]] = BuffEnough.spells["Elemental Shield"]

-- Warlocks
BuffEnough.spells["Fel Armor"] = GetSpellInfo(28176)
BuffEnough.spells["Demon Armor"] = GetSpellInfo(706)
BuffEnough.spells["Fel/Demon Armor"] = L["Fel/Demon Armor"]

BuffEnough.spellMap[BuffEnough.spells["Fel Armor"]] = BuffEnough.spells["Fel/Demon Armor"]
BuffEnough.spellMap[BuffEnough.spells["Demon Armor"]] = BuffEnough.spells["Fel/Demon Armor"]

-- Warriors
BuffEnough.spells["Battle Shout"] = GetSpellInfo(6673)
BuffEnough.spells["Commanding Shout"] = GetSpellInfo(469)
BuffEnough.spells["Defensive Stance"] = GetSpellInfo(71)

-- Consumables
BuffEnough.spells["Flask/Elixirs"] = L["Flask/Elixirs"]
BuffEnough.spells["Battle Elixir"] = L["Battle Elixir"]
BuffEnough.spells["Guardian Elixir"] = L["Guardian Elixir"]

BuffEnough.flasks[GetSpellInfo(17629)] = "Chromatic Resistance"
BuffEnough.flasks[GetSpellInfo(42735)] = "Chromatic Wonder"
BuffEnough.flasks[GetSpellInfo(17627)] = "Distilled Wisdom"
BuffEnough.flasks[GetSpellInfo(17628)] = "Supreme Power"

BuffEnough.battleElixirs[GetSpellInfo(60344)] = "Expertise"
BuffEnough.battleElixirs[GetSpellInfo(28497)] = "Mighty Agility"
BuffEnough.battleElixirs[GetSpellInfo(54494)] = "Major Agility"
BuffEnough.battleElixirs[GetSpellInfo(60340)] = "Accuracy"
BuffEnough.battleElixirs[GetSpellInfo(60345)] = "Armor Piercing"
BuffEnough.battleElixirs[GetSpellInfo(60341)] = "Deadly Strikes"
BuffEnough.battleElixirs[GetSpellInfo(60346)] = "Lightning Speed"

BuffEnough.guardianElixirs[GetSpellInfo(60347)] = "Mighty Thoughts"

BuffEnough.spells["Well Fed"] = GetSpellInfo(33263)
BuffEnough.spells["\"Well Fed\""] = GetSpellInfo(44106)
BuffEnough.spells["Increased Stamina"] = GetSpellInfo(25661)
BuffEnough.spells["Electrified"] = GetSpellInfo(43730)
BuffEnough.spells["Rumsey Rum Black Label"] = GetSpellInfo(25804)
BuffEnough.spells["Enlightened"] = GetSpellInfo(43722)

BuffEnough.spellMap[BuffEnough.spells["Increased Stamina"]] = BuffEnough.spells["Well Fed"]
BuffEnough.spellMap[BuffEnough.spells["Electrified"]] = BuffEnough.spells["Well Fed"]
BuffEnough.spellMap[BuffEnough.spells["Rumsey Rum Black Label"]] = BuffEnough.spells["Well Fed"]
BuffEnough.spellMap[BuffEnough.spells["Enlightened"]] = BuffEnough.spells["Well Fed"]
BuffEnough.spellMap[BuffEnough.spells["\"Well Fed\""]] = BuffEnough.spells["Well Fed"]

-- Gear
BuffEnough.spells["Riding Crop"] = GetItemInfo(25653)
BuffEnough.spells["Skybreaker Whip"] = GetItemInfo(32863)
BuffEnough.spells["Fishing Pole"] = GetSpellInfo(7738)
BuffEnough.spells["Blessed Medallion of Karabor"] = GetItemInfo(32757)

-- Index what we know about
for buff,_ in pairs(BuffEnough.spells) do
	BuffEnough.knownSpells[buff] = true
end