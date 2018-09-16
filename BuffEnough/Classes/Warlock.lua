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

if select(2, UnitClass("player")) ~= "WARLOCK" then return end 

local L = LibStub("AceLocale-3.0"):GetLocale("BuffEnough")
local Warlock = BuffEnough:GetOrCreateModule("Player")

BuffEnough.options.args.pet.guiHidden = false


--[[ ---------------------------------------------------------------------------
     Check class buffs
----------------------------------------------------------------------------- ]]
function Warlock:CheckClassBuffs()

    if BuffEnough.debug then BuffEnough:debug("Checking warlock buffs") end

    BuffEnough:TrackItem(L["Buffs"], BuffEnough.spells["Fel/Demon Armor"], false, true, false, nil, nil, true)
    BuffEnough:TrackItem(L["Buffs"], BuffEnough.spells["Blessing of Might"], false, false, true)
    
    BuffEnough:TrackItem(L["Buffs"], L["Mainhand Buff"], false, true, false, nil, nil, true)

    if ((not UnitExists("pet")) and (not IsMounted())) then
    
        BuffEnough:TrackItem(L["Pet"], L["Pet"], false, true, false, nil, nil, true)
        
    end
    
    self:CheckPetBuffs()
    self:CheckPetPaladinBlessings()
    
end


--[[ ---------------------------------------------------------------------------
     Formulate priority list for paladin blessings
----------------------------------------------------------------------------- ]]
function Warlock:GetPaladinBlessingList()

    return {BuffEnough.spells["Blessing of Kings"], BuffEnough.spells["Blessing of Wisdom"], BuffEnough.spells["Blessing of Sanctuary"]}

end

