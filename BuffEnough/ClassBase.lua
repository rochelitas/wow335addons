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


local prototype = {}
prototype.playerClass = select(2, UnitClass("player"))


--[[ ---------------------------------------------------------------------------
     Check paladin blessings for class
----------------------------------------------------------------------------- ]]
function prototype:CheckPaladinBlessings()

    local paladinBlessings = {}

    if BuffEnough:GetProfileParam("overrideblessings") then
        for i=1,4 do
            paladinBlessings[i] = BuffEnough:GetProfileParam("blessing"..i)
        end
    else
        paladinBlessings = self.GetPaladinBlessingList()
    end

    local i = 1

    for _,blessing in ipairs(paladinBlessings) do

        if (i > BuffEnough.raidClassCount["PALADIN"]) then break end

        if blessing and blessing ~= L["None"] then
            if ((blessing == BuffEnough.spells["Blessing of Sanctuary"] and
            	 BuffEnough.talentsAvailable[BuffEnough.spells["Blessing of Sanctuary"]]) or
                blessing ~= BuffEnough.spells["Blessing of Sanctuary"])
            then

                BuffEnough:TrackItem(L["Buffs"], blessing, false, true)
                i = i + 1

            end
        end

    end

end


--[[ ---------------------------------------------------------------------------
     Check pet buffs
----------------------------------------------------------------------------- ]]
function prototype:CheckPetBuffs()

    if not UnitExists("pet") then return end
    
    local i = 1
	local petbuff = UnitBuff("pet", i);
	while petbuff do
	
		if BuffEnough.spellMap[petbuff] then
			petbuff = BuffEnough.spellMap[petbuff]
		end
	
	    BuffEnough:TrackItem(L["Pet"], petbuff, true)
	    
		i = i + 1;
  		petbuff = UnitBuff("pet", i);
  		
	end
    
    if BuffEnough:GetProfileParam("petfood") and
       ((GetNumRaidMembers() > 0) or (not BuffEnough:GetProfileParam("consumablesinraid")))
    then
    
		BuffEnough:TrackItem(L["Pet"], BuffEnough.spells["Well Fed"], false, true, false, nil, nil, true)
		
    end

end


--[[ ---------------------------------------------------------------------------
     Check paladin blessings for pet
----------------------------------------------------------------------------- ]]
function prototype:CheckPetPaladinBlessings()

    if not UnitExists("pet") or not BuffEnough:GetProfileParam("petbuffs") then return end

    local paladinBlessings = {}

    if BuffEnough:GetProfileParam("petoverrideblessings") then
        for i=1,4 do
            paladinBlessings[i] = BuffEnough:GetProfileParam("petblessing"..i)
        end
    else
        paladinBlessings = self.GetPetPaladinBlessingList()
    end

    local i = 1

    for _,blessing in ipairs(paladinBlessings) do

        if (i > BuffEnough.raidClassCount["PALADIN"]) then break end

        if blessing and blessing ~= L["None"] then
            if ((blessing == BuffEnough.spells["Blessing of Sanctuary"] and BuffEnough.talentsAvailable[BuffEnough.spells["Blessing of Sanctuary"]]) or
                blessing ~= BuffEnough.spells["Blessing of Sanctuary"])
            then

                BuffEnough:TrackItem(L["Pet"], blessing, false, true)
                i = i + 1

            end
        end

    end

end


--[[ ---------------------------------------------------------------------------
     Formulate pet priority list for paladin blessings
----------------------------------------------------------------------------- ]]
function prototype:GetPetPaladinBlessingList()

    if not UnitExists("pet") then return end
    
    local powerType = UnitPowerType("pet")

    -- hunter/DK pet
    if powerType == 2 or powerType == 3 then
    	return {BuffEnough.spells["Blessing of Might"], BuffEnough.spells["Blessing of Kings"], BuffEnough.spells["Blessing of Sanctuary"]}
    	
    -- imp
    elseif powerType == 0 and select(2, UnitClass("pet")) == "MAGE"  then
    	return {BuffEnough.spells["Blessing of Wisdom"], BuffEnough.spells["Blessing of Kings"], BuffEnough.spells["Blessing of Sanctuary"]}
    	
    -- all other warlock pets
    else 
       	return {BuffEnough.spells["Blessing of Might"], BuffEnough.spells["Blessing of Kings"], BuffEnough.spells["Blessing of Sanctuary"], BuffEnough.spells["Blessing of Wisdom"]}
    end

end


--[[ ---------------------------------------------------------------------------
     Functions to be overriden by the prototype implementation
----------------------------------------------------------------------------- ]]
prototype.CheckClassBuffs = function() end
prototype.GetPaladinBlessingList = function() end


--[[ ---------------------------------------------------------------------------
     Loads the module for the prototype
----------------------------------------------------------------------------- ]]
function BuffEnough:GetOrCreateModule(t)	
    return self:GetModule(t, true) or self:NewModule(t, self.ClassPrototype)
end


BuffEnough.ClassPrototype = prototype
