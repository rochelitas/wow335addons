function CreateDatabase()
    t = {};
    for i=1,422 do
        _,_,_,_,_,_,_,_,_,j = GetAchievementCriteriaInfo(1832,i);
        a, _, c,_, _, _, _, _, _, _ = GetAchievementCriteriaInfo(j);
        t[a]=j;
    end
    for i=1,74 do
        _,_,_,_,_,_,_,_,_,j = GetAchievementCriteriaInfo(1021,i);
        a, _, c,_, _, _, _, _, _, _ = GetAchievementCriteriaInfo(j);
        t[a]=j;
    end
    for i=1,190 do
        _,_,_,_,_,_,_,_,_,j = GetAchievementCriteriaInfo(1833,i);
        a, _, c,_, _, _, _, _, _, _ = GetAchievementCriteriaInfo(j);
        t[a]=j;
    end
end

function login()    
    GameTooltip:HookScript("OnTooltipSetItem", Item)    
    ItemRefTooltip:HookScript("OnTooltipSetItem", Item)    
    CreateDatabase()
end    

function Item(tooltip)
    itemName=tooltip:GetItem();
    if t[itemName] ~= nil then    
         _, _, completed = GetAchievementCriteriaInfo(t[itemName]);
        if completed then      
            tooltip:AddLine("Completed", 0, 225, 225)
        else
            tooltip:AddLine("Needed", 255, 0, 0)
        end              
    end    
end
login()