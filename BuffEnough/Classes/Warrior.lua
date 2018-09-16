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


if select(2, UnitClass("player")) ~= "WARRIOR" then return end 

local L = LibStub("AceLocale-3.0"):GetLocale("BuffEnough")
local Warrior = BuffEnough:GetOrCreateModule("Player")


--[[ ---------------------------------------------------------------------------
     Check class buffs
----------------------------------------------------------------------------- ]]
function Warrior:CheckClassBuffs()

    if BuffEnough.debug then BuffEnough:debug("Checking warrior buffs") end

    BuffEnough:TrackItem(L["Buffs"], BuffEnough.spells["Blessing of Wisdom"], false, false, true)

    if UnitAffectingCombat("player") then
     
    	if BuffEnough:IsExpectingTrackedItem(L["Buffs"], BuffEnough.spells["Blessing of Might"]) then
    
    		BuffEnough:TrackItem(L["Buffs"], BuffEnough.spells["Commanding Shout"], false, true, false, nil, nil, true)
    	
		elseif BuffEnough.partyClassCount["WARRIOR"] > 1 then
		
            BuffEnough:TrackItem(L["Buffs"], BuffEnough.spells["Battle Shout"], false, true, false, nil, nil, true)
            BuffEnough:TrackItem(L["Buffs"], BuffEnough.spells["Commanding Shout"], false, true, false, nil, nil, true)
            
        elseif not BuffEnough.trackedItems[BuffEnough.spells["Battle Shout"]] and
               not BuffEnough.trackedItems[BuffEnough.spells["Commanding Shout"]]
        then
        
            if select(3, GetTalentTabInfo(3)) > 40 then
            	BuffEnough:TrackItem(L["Buffs"], BuffEnough.spells["Commanding Shout"], false, true, false, nil, nil, true)
            else
            	BuffEnough:TrackItem(L["Buffs"], BuffEnough.spells["Battle Shout"], false, true, false, nil, nil, true)
            end
            
        end
        
    end
    
    local isDefensiveStance = GetShapeshiftForm(true) == 2
    
    if BuffEnough.playerIsTank then
        BuffEnough:TrackItem(L["Buffs"], BuffEnough.spells["Defensive Stance"], isDefensiveStance, true, false, nil, nil, true)
    else
        BuffEnough:TrackItem(L["Buffs"], BuffEnough.spells["Defensive Stance"], isDefensiveStance, false, true, nil, nil, true)
    end

end


--[[ ---------------------------------------------------------------------------
     Formulate priority list for paladin blessings
----------------------------------------------------------------------------- ]]
function Warrior:GetPaladinBlessingList()

	return {BuffEnough.spells["Blessing of Kings"], BuffEnough.spells["Blessing of Might"], BuffEnough.spells["Blessing of Sanctuary"]}

end