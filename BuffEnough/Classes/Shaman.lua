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


if select(2, UnitClass("player")) ~= "SHAMAN" then return end 

local L = LibStub("AceLocale-3.0"):GetLocale("BuffEnough")
local Shaman = BuffEnough:GetOrCreateModule("Player")


--[[ ---------------------------------------------------------------------------
     Check class buffs
----------------------------------------------------------------------------- ]]
function Shaman:CheckClassBuffs()

    if BuffEnough.debug then BuffEnough:debug("Checking shaman buffs") end

    BuffEnough:TrackItem(L["Buffs"], BuffEnough.spells["Elemental Shield"], false, true, false, nil, nil, true)
    
    BuffEnough:TrackItem(L["Buffs"], L["Mainhand Buff"], false, true, false, nil, nil, true)
	
	if OffhandHasWeapon() then
		BuffEnough:TrackItem(L["Buffs"], L["Offhand Buff"], false, true, false)
	end

end


--[[ ---------------------------------------------------------------------------
     Formulate priority list for paladin blessings
----------------------------------------------------------------------------- ]]
function Shaman:GetPaladinBlessingList()

    if select(3, GetTalentTabInfo(1)) > 40 then
        return {BuffEnough.spells["Blessing of Wisdom"], BuffEnough.spells["Blessing of Kings"], BuffEnough.spells["Blessing of Sanctuary"]}
    elseif select(3, GetTalentTabInfo(2)) > 40 then
        return {BuffEnough.spells["Blessing of Kings"], BuffEnough.spells["Blessing of Might"], BuffEnough.spells["Blessing of Wisdom"], BuffEnough.spells["Blessing of Sanctuary"]}
    else
        return {BuffEnough.spells["Blessing of Wisdom"], BuffEnough.spells["Blessing of Kings"], BuffEnough.spells["Blessing of Sanctuary"]}
    end

end