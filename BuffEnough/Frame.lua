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
local media = LibStub("LibSharedMedia-3.0")


--[[ ---------------------------------------------------------------------------
     Initializes the main display frame
----------------------------------------------------------------------------- ]]
function BuffEnough:CreateFrame()

        -- Anchor
	self.Anchor = CreateFrame("Frame", "BuffEnoughAnchor", UIParent)
	self.Anchor:SetResizable(true)
	self.Anchor:SetMinResize(20, 20)
	self.Anchor:SetMovable(true)
	self.Anchor:SetPoint("CENTER", UIParent, "CENTER")
	self.Anchor:SetHeight(50)
	self.Anchor:SetWidth(100)

        -- Display
	self.Display = CreateFrame("Frame", "BuffEnoughDisplay", self.Anchor)
	self.Display:SetResizable(true)
	self.Display:EnableMouse(true)
	self.Display:SetPoint("TOPLEFT", self.Anchor, "TOPLEFT")
	self.Display:SetPoint("TOPRIGHT", self.Anchor, "TOPRIGHT")
	self.Display:SetPoint("BOTTOMLEFT", self.Anchor, "BOTTOMLEFT")
	self.Display:SetPoint("BOTTOMRIGHT", self.Anchor, "BOTTOMRIGHT")
	
	self.Display:SetScript("OnMouseDown", function(_, button)
            if button == "LeftButton" and not self:GetProfileParam("lock") then
                self.Anchor:StartMoving();
            else
				self.dobj.OnClick(this, button)
            end
        end)

	self.Display:SetScript("OnMouseUp", function()
            if not self:GetProfileParam("lock") then
				self.Anchor:StopMovingOrSizing();		
				self:SetAnchors()
            end
	end)

	self.Display:SetScript("OnEnter", function()
				self:Unfade()
                GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
          		GameTooltip:ClearLines()
                self.dobj.OnTooltipShow(GameTooltip)
                GameTooltip:Show()
                self.isShowingTooltip = true
        end)

	self.Display:SetScript("OnLeave", function()
				self:Fade()	
                GameTooltip:Hide()
                self.isShowingTooltip = false
        end)

    -- Grip
	self.Grip = CreateFrame("Button", "BuffEnoughResizeGrip", self.Display)
	self.Grip:SetNormalTexture("Interface\\AddOns\\BuffEnough\\ResizeGrip")
	self.Grip:SetHighlightTexture("Interface\\AddOns\\BuffEnough\\ResizeGrip")
	self.Grip:SetWidth(16)
	self.Grip:SetHeight(16)
	self.Grip:SetScript("OnMouseDown", function()
		if not self:GetProfileParam("lock") then
			this:GetParent():GetParent():StartSizing()
			this:GetParent():GetParent().IsMovingOrSizing = true
		end
	end)
	
	self.Grip:SetScript("OnMouseUp", function()
		this:GetParent():GetParent():StopMovingOrSizing()
		this:GetParent():GetParent().IsMovingOrSizing = nil
		self:SetAnchors()
	end)
	
	self.Grip:SetPoint("BOTTOMRIGHT", self.Display, "BOTTOMRIGHT", 1, -1)

	self:UpdateDisplay()

    self.Anchor:Hide()

end


--[[ ---------------------------------------------------------------------------
     Start the process of fading out the main frame
----------------------------------------------------------------------------- ]]
function BuffEnough:Fade()

	if self:GetProfileParam("fade") > 0 and self.isBuffEnough and not self.isBuffWarning then
		self.Display:SetScript("OnUpdate", function(_, elapsed) self:OnDisplayUpdate(elapsed) end)
	elseif self:GetProfileParam("fade") == 0 then
		self:Unfade()
	end

end


--[[ ---------------------------------------------------------------------------
     Take the main frame out of a faded mode
----------------------------------------------------------------------------- ]]
function BuffEnough:Unfade()

	self.Display:SetAlpha(self:GetProfileParam("alpha"))
	self.Display:SetScript("OnUpdate", nil)
	self.timeSinceBuffEnough = 0
	
end


--[[ ---------------------------------------------------------------------------
     Called from the display frame OnUpdate event
----------------------------------------------------------------------------- ]]
function BuffEnough:OnDisplayUpdate(elapsed)

	self.timeSinceBuffEnough = self.timeSinceBuffEnough + elapsed
	
	if self.timeSinceBuffEnough > self:GetProfileParam("fade") then
		if self.timeSinceBuffEnough > self:GetProfileParam("fade") + 5 then
			self.Display:SetScript("OnUpdate", nil)
			self.Display:SetAlpha(0)
		else
			self.Display:SetAlpha(self:GetProfileParam("alpha") * (1 - ((self.timeSinceBuffEnough - self:GetProfileParam("fade"))/5)))
		end
	end
	
end


--[[ ---------------------------------------------------------------------------
     Save the display frame location when moved
----------------------------------------------------------------------------- ]]
function BuffEnough:SetAnchors(useDB)

	local x, y, height, width, relativePoint,relativeTo = nil,nil,nil,nil,nil,nil

	if useDB then
		x = self:GetProfileParam("positionx") or 0
        y = self:GetProfileParam("positiony") or 0
        height = self:GetProfileParam("height") or 50
        width = self:GetProfileParam("width") or 100
        relativeTo = self:GetProfileParam("relativeto") or "CENTER"
        relativePoint = self:GetProfileParam("relativepoint") or "CENTER"
	else
        height, width = self.Anchor:GetHeight(), self.Anchor:GetWidth()
        relativeTo,_,relativePoint,x,y = self.Anchor:GetPoint()
	end

	self.Anchor:ClearAllPoints()
    self.Anchor:SetPoint(relativeTo, UIParent, relativePoint, x, y)
	self.Anchor:SetHeight(height)
	self.Anchor:SetWidth(width)

	self:SetProfileParam("positionx", x)
	self:SetProfileParam("positiony", y)
	self:SetProfileParam("height", height)
	self:SetProfileParam("width", width)
	self:SetProfileParam("relativepoint", relativePoint)
	self:SetProfileParam("relativeto", relativeTo)

end


--[[ ---------------------------------------------------------------------------
     Apply any config options about the display
----------------------------------------------------------------------------- ]]
function BuffEnough:UpdateDisplay()

	if not self.Anchor or not self:GetProfileParam("show") then return end

	self.Anchor:SetScale(self:GetProfileParam("scale") / 100.0)
	self.Anchor:SetFrameStrata(self:GetProfileParam("strata"))
	
	local bgFrame = {
		bgFile = media:Fetch("background", BuffEnough:GetProfileParam("bgtexture")), 
		edgeFile = media:Fetch("border", BuffEnough:GetProfileParam("bordertexture")),
		tile = false,
		edgeSize = BuffEnough:GetProfileParam("bordersize"),
		insets = {left = BuffEnough:GetProfileParam("bginset"),
				  right = BuffEnough:GetProfileParam("bginset"),
				  top = BuffEnough:GetProfileParam("bginset"),
				  bottom = BuffEnough:GetProfileParam("bginset")}
    }

	self.Display:SetBackdrop(bgFrame)
	self.Display:SetBackdropBorderColor(BuffEnough:GetProfileParam("bordercolorr"),
                                  		BuffEnough:GetProfileParam("bordercolorg"),
                                  		BuffEnough:GetProfileParam("bordercolorb"))

	if self:GetProfileParam("lock") then
		self.Grip:Hide()
	else
		self.Grip:Show()
	end

	if self.isShowingTooltip then
		GameTooltip:ClearLines()
		self.dobj.OnTooltipShow(GameTooltip)
		GameTooltip:Show()
	end

	if (self.dobj.text == L["Warning"] and BuffEnough:GetProfileParam("warn")) then
    	self:Unfade()
		self.Display:SetBackdropColor(BuffEnough:GetProfileParam("warnbuffcolorr"),
                                      BuffEnough:GetProfileParam("warnbuffcolorg"),
                                      BuffEnough:GetProfileParam("warnbuffcolorb"))
	elseif self.dobj.text == L["Yes"] then
	    self:Fade()
	    self.Display:SetBackdropColor(BuffEnough:GetProfileParam("buffcolorr"),
                                      BuffEnough:GetProfileParam("buffcolorg"),
                                      BuffEnough:GetProfileParam("buffcolorb"))
	else
    	self:Unfade()
	    self.Display:SetBackdropColor(BuffEnough:GetProfileParam("unbuffcolorr"),
                                      BuffEnough:GetProfileParam("unbuffcolorg"),
                                      BuffEnough:GetProfileParam("unbuffcolorb"))
	end

end


--[[ ---------------------------------------------------------------------------
     Show or hide the display
----------------------------------------------------------------------------- ]]
function BuffEnough:UpdateVisible()

	if not self.Anchor then return end

	if self:GetProfileParam("enable") and self:GetProfileParam("show") then
		self.Anchor:Show()
	else
		self.Anchor:Hide()
	end

end