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

if select(2, UnitClass("player")) ~= "PALADIN" then return end 

local L = LibStub("AceLocale-3.0"):GetLocale("BuffEnough")
local Paladin = BuffEnough:GetOrCreateModule("Player")


--[[ ---------------------------------------------------------------------------
     Check class buffs
----------------------------------------------------------------------------- ]]
function Paladin:CheckClassBuffs()

    if BuffEnough.debug then BuffEnough:debug("Checking paladin buffs") end

    local impRF = select(5, GetTalentInfo(2, 7, false))

    if BuffEnough.playerIsTank then
        BuffEnough:TrackItem(L["Buffs"], BuffEnough.spells["Righteous Fury"], false, true, false, nil, nil, true)
    elseif impRF == 0 then
        BuffEnough:TrackItem(L["Buffs"], BuffEnough.spells["Righteous Fury"], false, false, true, nil, nil, true)
    end
    
    if GetShapeshiftForm(false) == 0 then
    	BuffEnough:TrackItem(L["Buffs"], L["Aura"], false, true, false, nil, nil, true)
    end

end


--[[ ---------------------------------------------------------------------------
     Formulate priority list for paladin blessings
----------------------------------------------------------------------------- ]]
function Paladin:GetPaladinBlessingList()

	if GetNumRaidMembers() == 0 and GetNumPartyMembers() == 0 then
		return {BuffEnough.spells["Blessing of Kings"]}
    elseif select(3, GetTalentTabInfo(1)) > 40 then
        return {BuffEnough.spells["Blessing of Kings"], BuffEnough.spells["Blessing of Wisdom"], BuffEnough.spells["Blessing of Sanctuary"]}
    elseif select(3, GetTalentTabInfo(2)) > 40 then
        return {BuffEnough.spells["Blessing of Sanctuary"], BuffEnough.spells["Blessing of Kings"], BuffEnough.spells["Blessing of Might"], BuffEnough.spells["Blessing of Wisdom"]}
    else
        return {BuffEnough.spells["Blessing of Might"], BuffEnough.spells["Blessing of Kings"], BuffEnough.spells["Blessing of Wisdom"], BuffEnough.spells["Blessing of Sanctuary"]}
    end

end