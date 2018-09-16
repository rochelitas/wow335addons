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
along with BuffEnough.	If not, see <http://www.gnu.org/licenses/>.

----------------------------------------------------------------------------- ]]


local L = LibStub("AceLocale-3.0"):GetLocale("BuffEnough")
local C = LibStub("AceConfigDialog-3.0")


--[[ ---------------------------------------------------------------------------
	 Create dropdowns
----------------------------------------------------------------------------- ]]

local blessingsDropdown = {}
blessingsDropdown[BuffEnough.spells["Blessing of Kings"]] = BuffEnough.spells["Blessing of Kings"]
blessingsDropdown[BuffEnough.spells["Blessing of Might"]] = BuffEnough.spells["Blessing of Might"]
blessingsDropdown[BuffEnough.spells["Blessing of Sanctuary"]] = BuffEnough.spells["Blessing of Sanctuary"]
blessingsDropdown[BuffEnough.spells["Blessing of Wisdom"]] = BuffEnough.spells["Blessing of Wisdom"]
blessingsDropdown[L["None"]] = L["None"]

local customCategoryDropdown = {}
customCategoryDropdown[L["Buffs"]] = L["Buffs"]
customCategoryDropdown[L["Gear"]] = L["Gear"]
customCategoryDropdown[L["Consumables"]] = L["Consumables"]
customCategoryDropdown[L["Pet"]] = L["Pet"]

local customActionDropdown = {}
customActionDropdown[L["Expected"]] = L["Expected"]
customActionDropdown[L["Unexpected"]] = L["Unexpected"]
customActionDropdown[L["Ignored"]] = L["Ignored"]


--[[ ---------------------------------------------------------------------------
	 Config options
----------------------------------------------------------------------------- ]]
BuffEnough.options = {
	name = L["BuffEnough"],
	handler = BuffEnough,
	type = "group",
	args = {
		general = {
			type = "group",
			name = L["General"],
			order = 0,
			set = "SetProfileParam",
			get = "GetProfileParam",
			cmdHidden = true,
			order = 0,
			args = {
				solo = {
					type = "toggle",
					name = L["Enable While Solo"],
					desc = L["Enable BuffEnough while not in a party/raid"],
					width = "full",
					order = 0,
					set = function(info, v)
							BuffEnough:SetProfileParam("solo", v)
							BuffEnough:CheckRaidChange()
				  		end	
				},
				incombat = {
					type = "toggle",
					name = L["Check In Combat"],
					desc = L["Continue to do buff checks even while in combat"],
					width = "full",
					order = 1,
				},
				warn = {
					type = "toggle",
					name = L["Warn"],
					desc = L["Display shows warning color when you are buff enough but one or more buffs is about to expire"],
					width = "full",
					order = 2,
					set = function(info, v)
							BuffEnough:SetProfileParam("warn", v)
							BuffEnough:UpdateDisplay()
				  		end	
				},
				warnmin = {
					type = "range",
					name = L["Warn Minimum Buff Time"],
					desc = L["The minimum buff duration in minutes before we check for expiration. Set to 0 for no minimum"],
					min = 0,
					max = 120,
					step = 1,
					bigStep = 1,
					width = "full",
					order = 3,
					disabled = function() return not BuffEnough:GetProfileParam("warn") end,
				},
				warnthreshold = {
					type = "range",
					name = L["Warn Threshold"],
					desc = L["The number of minutes left on the buff before we warn"],
					min = 0,
					max = 30,
					step = 1,
					bigStep = 1,
					width = "full",
					order = 4,
					disabled = function() return not BuffEnough:GetProfileParam("warn") end ,
				},
				fade = {
					type = "range",
					name = L["Fade"],
					desc = L["Fade frame after this many seconds of being buff enough. Set to 0 for no fading"],
					min = 0,
					max = 60,
					step = 1,
					bigStep = 1,
					width = "full",
					order = 5,
					set = function(info, v)
							BuffEnough:SetProfileParam("fade", v)
							BuffEnough:UpdateDisplay()
				  		end	
				},
			},
		},
		blessings = {
			type = "group",
			name = L["Blessings"],
			set = "SetProfileParam",
			get = "GetProfileParam",
			cmdHidden = true,
			order = 3,
			args = {
				override = {
					type = "toggle",
					name = L["Override"],
					desc = L["Overrides the default paladin blessing priority and uses the priority you specify."],
					width = "full",
					order = 0,
					get = function(info) return BuffEnough:GetProfileParam("overrideblessings") end,
					set = function(info, v)
							BuffEnough:SetProfileParam("overrideblessings", v)
							BuffEnough:RunCheck()
						  end	
				},
				blessing1 = {
					type = "select",
					name = L["Blessing"].."1",
					disabled = function() return not BuffEnough:GetProfileParam("overrideblessings") end,
					values = blessingsDropdown,
					set = function(info, v)
							BuffEnough:SetProfileParam("blessing1", v)
							BuffEnough:RunCheck()
						  end	
				},
				blessing2 = {
					type = "select",
					name = L["Blessing"].."2",
					disabled = function() return not BuffEnough:GetProfileParam("overrideblessings") end,
					values = blessingsDropdown,
					set = function(info, v)
							BuffEnough:SetProfileParam("blessing2", v)
							BuffEnough:RunCheck()
						  end	
				},
				blessing3 = {
					type = "select",
					name = L["Blessing"].."3",
					disabled = function() return not BuffEnough:GetProfileParam("overrideblessings") end,
					values = blessingsDropdown,
					set = function(info, v)
							BuffEnough:SetProfileParam("blessing3", v)
							BuffEnough:RunCheck()
						  end	
				},
				blessing4 = {
					type = "select",
					name = L["Blessing"].."4",
					disabled = function() return not BuffEnough:GetProfileParam("overrideblessings") end,
					values = blessingsDropdown,
					set = function(info, v)
							BuffEnough:SetProfileParam("blessing4", v)
							BuffEnough:RunCheck()
						  end	
				},
			},
		},
		consumables = {
			type = "group",
			name = L["Consumables"],
			set = "SetProfileParam",
			get = "GetProfileParam",
			cmdHidden = true,
			order = 2,
			args = {
				flask = {
					type = "toggle",
					name = L["Check Flask/Elixirs"],
					desc = L["Check whether or not you have either a flask or Guardian and Battle elixirs"],
					width = "full",
					order = 2,
					set = function(info, v)
							BuffEnough:SetProfileParam("flask", v)
							BuffEnough:RunCheck()
						  end	
				},
				food = {
					type = "toggle",
					name = L["Check Food"],
					desc = L["Check whether or not you have a food buff"],
					width = "full",
					order = 4,
					set = function(info, v)
							BuffEnough:SetProfileParam("food", v)
							BuffEnough:RunCheck()
						  end	
				},
				chest = {
					type = "toggle",
					name = L["Check Chest"],
					desc = L["Check whether or not your chest has a Rune of Warding"],
					width = "full",
					order = 5,
					set = function(info, v)
							BuffEnough:SetProfileParam("chest", v)
							BuffEnough:RunCheck()
						  end	
				},
				inraid = {
					type = "toggle",
					name = L["Only Check In Raid"],
					desc = L["Only check consumable use when in a raid"],
					width = "full",
					order = 1,
					get = function(info) return BuffEnough:GetProfileParam("consumablesinraid") end,
					set = function(info, v)
							BuffEnough:SetProfileParam("consumablesinraid", v)
							BuffEnough:RunCheck()
						  end
				},
			},
		},
		custom = {
			type = "group",
			name = L["Custom"],
			set = "SetProfileParam",
			get = "GetProfileParam",
			cmdHidden = true,
			order = 4,
			args = {
				customcategory = {
					type = "select",
					name = L["Category"],
					values = customCategoryDropdown,
					order = 0,
					get = function(info) return BuffEnough.currentCustomCategory end,
					set = function(info, v) BuffEnough.currentCustomCategory = v end
				},
				customaction = {
					type = "select",
					name = L["Action"],
					values = customActionDropdown,
					order = 1,
					get = function(info) return BuffEnough.currentCustomAction end,
					set = function(info, v) BuffEnough.currentCustomAction = v end
				},
				customname = {
					type = "input",
					name = L["Buff"],
					desc = L["Select the desired category and behavior from the dropdown menu and enter the name of a buff. You can use this to ignore an existing buff check or add a new one."],
					order = 2,
					set = function(info, v)
							if not BuffEnough.db.profile.custom[BuffEnough.currentCustomCategory] then
								BuffEnough.db.profile.custom[BuffEnough.currentCustomCategory] = {}
							end
							BuffEnough.db.profile.custom[BuffEnough.currentCustomCategory][v] = BuffEnough.currentCustomAction
							if BuffEnough.trace then BuffEnough:trace("Adding custom %s '%s' as %s.", BuffEnough.currentCustomCategory, v, BuffEnough.currentCustomAction) end
							BuffEnough:DisplayCustomBuffs()
							BuffEnough:RunCheck()
						  end,
					validate = function(info, v)
								if not BuffEnough.currentCustomCategory or not BuffEnough.currentCustomAction then
									return L["You must select an action from the dropdown menu to associate with this buff"]
								elseif string.len(v) == 0 then
									return L["You must enter a value for the buff name"]
								end
								return true
						  	   end
				},
				customdefined = {
					type = "group",
					name = L["Custom"],
					guiInline = true,
					order = 3,
					args = {}
				},
			},
		},
		pet = {
			type = "group",
			name = L["Pet"],
			set = "SetProfileParam",
			get = "GetProfileParam",
			order = 3,
			cmdHidden = true,
			guiHidden = true,
			args = {
				petbuffs = {
					type = "toggle",
					name = L["Check Pet Buffs"],
					desc = L["Check pet for the same raid buffs as the player"],
					width = "full",
					order = 1,
					set = function(info, v)
							BuffEnough:SetProfileParam("petbuffs", v)
							BuffEnough:RunCheck()
				  		end
				},
				petfood = {
					type = "toggle",
					name = L["Check Pet Food"],
					desc = L["Check whether or not your pet has a food buff"],
					width = "full",
					order = 2,
					set = function(info, v)
							BuffEnough:SetProfileParam("petfood", v)
							BuffEnough:RunCheck()
				  		end
				},
				petblessings = {
					type = "group",
					name = L["Pet"].." "..L["Blessings"],
					set = "SetProfileParam",
					get = "GetProfileParam",
					guiInline = true,
					order = 3,
					args = {
						petoverride = {
							type = "toggle",
							name = L["Override"],
							desc = L["Overrides the default paladin blessing priority and uses the priority you specify."],
							width = "full",
							order = 0,
							get = function(info) return BuffEnough:GetProfileParam("petoverrideblessings") end,
							set = function(info, v)
									BuffEnough:SetProfileParam("petoverrideblessings", v)
									BuffEnough:RunCheck()
						  		end	
						},
						petblessing1 = {
							type = "select",
							name = L["Blessing"].."1",
							disabled = function() return not BuffEnough:GetProfileParam("petoverrideblessings") end,
							values = blessingsDropdown,
							set = function(info, v)
									BuffEnough:SetProfileParam("petblessing1", v)
									BuffEnough:RunCheck()
						  		end	
						},
						petblessing2 = {
							type = "select",
							name = L["Blessing"].."2",
							disabled = function() return not BuffEnough:GetProfileParam("petoverrideblessings") end,
							values = blessingsDropdown,
							set = function(info, v)
									BuffEnough:SetProfileParam("petblessing2", v)
									BuffEnough:RunCheck()
						  		end	
						},
						petblessing3 = {
							type = "select",
							name = L["Blessing"].."3",
							disabled = function() return not BuffEnough:GetProfileParam("petoverrideblessings") end,
							values = blessingsDropdown,
							set = function(info, v)
									BuffEnough:SetProfileParam("petblessing3", v)
									BuffEnough:RunCheck()
								  end	
						},
						petblessing4 = {
							type = "select",
							name = L["Blessing"].."4",
							disabled = function() return not BuffEnough:GetProfileParam("petoverrideblessings") end,
							values = blessingsDropdown,
							set = function(info, v)
									BuffEnough:SetProfileParam("petblessing4", v)
									BuffEnough:RunCheck()
								  end	
						},
					},
				},
			},
		},
		display = {
			type = "group",
			name = L["Display"],
			cmdHidden = true,
			order = 1,
			args = {
				show = {
					type = "toggle",
					name = L["Show Display"],
					desc = L["Shows the display"],
					order = 0,
					width = "full",
					get = function(info) return BuffEnough:GetProfileParam("show") end,
					set = function(info, v)
							BuffEnough:SetProfileParam("show", v)
							BuffEnough:UpdateVisible()
				  		end	
				},
				lock = {
					type = "toggle",
					name = L["Lock"],
					desc = L["Lock the display"],
					order = 1,
					width = "full",
					get = function(info) return BuffEnough:GetProfileParam("lock") end,
					set = function(info, v)
					  		BuffEnough:SetProfileParam("lock", v)
					  		BuffEnough:UpdateDisplay()
				  		end	
				},
				scale = {
					type = "range",
					name = L["Scale"],
					desc = L["Scale of the display"],
					min = 1,
					max = 150,
					step = 1,
					bigStep = 1,
					order = 2,
					get = function(info) return BuffEnough:GetProfileParam("scale") end,
					set = function(info, v)
							BuffEnough:SetProfileParam("scale", v)
			  				BuffEnough:UpdateDisplay()
						end						
				},
				alpha = {
					type = "range",
					name = L["Opacity"],
					desc = L["Opacity of the display"],
					min = 0,
					max = 1,
					step = 0.01,
					bigStep = 0.05,
					order = 3,
					get = function(info) return BuffEnough:GetProfileParam("alpha") end,
					set = function(info, v)
				 			BuffEnough:SetProfileParam("alpha", v)
				  			BuffEnough:UpdateDisplay()
						end	
				},
				strata = {
					type = "select",
					name = L["Strata"],
					desc = L["Strata of the display"],
					order = 4,
					values = {HIGH = _G["HIGH"], MEDIUM = _G["AUCTION_TIME_LEFT2"], LOW = _G["LOW"], BACKGROUND = _G["BACKGROUND"]},
					get = function(info) return BuffEnough:GetProfileParam("strata") end,
					set = function(info, v)
				 			BuffEnough:SetProfileParam("strata", v)
				  			BuffEnough:UpdateDisplay()
						end	
				},
				buffcolor = {
					type = "color",
					name = L["Buff Color"],
					desc = L["Color to display when you are buff enough"],
					order = 5,
					hasAlpha = false,
					width = "full",
					get = function(info)
							local r = BuffEnough:GetProfileParam("buffcolorr")
							local g = BuffEnough:GetProfileParam("buffcolorg")
							local b = BuffEnough:GetProfileParam("buffcolorb")
							return r, g, b
					end,
					set = function(info, r, g, b)
							BuffEnough:SetProfileParam("buffcolorr", r)
							BuffEnough:SetProfileParam("buffcolorg", g)
							BuffEnough:SetProfileParam("buffcolorb", b) 
							BuffEnough:UpdateDisplay()
						end
				},
				unbuffcolor = {
					type = "color",
					name = L["Unbuff Color"],
					desc = L["Color to display when you are not buff enough"],
					order = 6,
					hasAlpha = false,
					width = "full",
					get = function(info)
							local r = BuffEnough:GetProfileParam("unbuffcolorr")
							local g = BuffEnough:GetProfileParam("unbuffcolorg")
							local b = BuffEnough:GetProfileParam("unbuffcolorb")
							return r, g, b
						end,
					set = function(info, r, g, b)
							BuffEnough:SetProfileParam("unbuffcolorr", r)
							BuffEnough:SetProfileParam("unbuffcolorg", g)
							BuffEnough:SetProfileParam("unbuffcolorb", b) 
							BuffEnough:UpdateDisplay()
						end
				},
				warnbuffcolor = {
					type = "color",
					name = L["Warn Buff Color"],
					desc = L["Color to display when you are buffs are at a warning level"],
					order = 7,
					hasAlpha = false,
					width = "full",
					get = function(info)
							local r = BuffEnough:GetProfileParam("warnbuffcolorr")
							local g = BuffEnough:GetProfileParam("warnbuffcolorg")
							local b = BuffEnough:GetProfileParam("warnbuffcolorb")
							return r, g, b
						end,
					set = function(info, r, g, b)
							BuffEnough:SetProfileParam("warnbuffcolorr", r)
							BuffEnough:SetProfileParam("warnbuffcolorg", g)
							BuffEnough:SetProfileParam("warnbuffcolorb", b) 
							BuffEnough:UpdateDisplay()
						end
				},
				bordercolor = {
					type = "color",
					name = L["Border Color"],
					desc = L["Color of the display border"],
					order = 8,
					hasAlpha = false,
					width = "full",
					get = function(info)
							local r = BuffEnough:GetProfileParam("bordercolorr")
							local g = BuffEnough:GetProfileParam("bordercolorg")
							local b = BuffEnough:GetProfileParam("bordercolorb")
							return r, g, b
						end,
					set = function(info, r, g, b)
							BuffEnough:SetProfileParam("bordercolorr", r)
							BuffEnough:SetProfileParam("bordercolorg", g)
							BuffEnough:SetProfileParam("bordercolorb", b) 
							BuffEnough:UpdateDisplay()
						end
				},
				bordersize = {
					type = "range",
					name = L["Border Size"],
					desc = L["Thickness of the display border"],
					min = 1,
					max = 64,
					step = 1,
					bigStep = 1,
					order = 9,
					get = "GetProfileParam",
					set = function(info, v)
							BuffEnough:SetProfileParam("bordersize", v)
			  				BuffEnough:UpdateDisplay()
						end						
				},
				bginset = {
					type = "range",
					name = L["Background Inset"],
					desc = L["How far inside the border to set the background of the display"],
					min = 1,
					max = 64,
					step = 1,
					bigStep = 1,
					order = 10,
					get = "GetProfileParam",
					set = function(info, v)
							BuffEnough:SetProfileParam("bginset", v)
			  				BuffEnough:UpdateDisplay()
						end						
				},
				bgtexture = {
		  			type = "select",
		  			dialogControl = "LSM30_Background",
		  			name = L["Background Texture"],
		  			desc = L["The background texture of the display"],
		  			order = 11,
		  			values = AceGUIWidgetLSMlists.background,
					get = "GetProfileParam",
		  			set = function(info, v)
				 			BuffEnough:SetProfileParam("bgtexture", v)
				  			BuffEnough:UpdateDisplay()
					end	
	       		},
	       		bordertexture = {
		  			type = 'select',
		  			dialogControl = 'LSM30_Border',
		  			name = L["Border Texture"],
		  			desc = L["The border texture of the display"],
		  			order = 12,
		  			values = AceGUIWidgetLSMlists.border, 
		  			get = "GetProfileParam",
		  			set = function(info, v)
				 			BuffEnough:SetProfileParam("bordertexture", v)
				  			BuffEnough:UpdateDisplay()
					end	
	       		},
			},
		},
	},
}

BuffEnough.options.args[L["config"]] = {
	type = "execute",
	name = L["config"],
	desc = L["Toggle the configuration dialog"],
	func = "ToggleConfigDialog",
	guiHidden = true,
	order = 1,
}


--[[ ---------------------------------------------------------------------------
	 Config defaults
----------------------------------------------------------------------------- ]]
BuffEnough.defaults = {
	profile = {
		enable = true,
		show = true,
		logLevel = 0,
		solo = true,
		incombat = true,
		warn = true,
		warnmin = 30,
		warnthreshold = 5,
		fade = 0,
		overrideblessings = false,
		petoverrideblessings = false,
		flask = true,
		food = true,
		chest = false,
		consumablesinraid = true,
		custom = {},
		lock = false,
		alpha = 1,
		scale = 100,
		strata = "BACKGROUND",
		buffcolorr = 0,
		buffcolorg = .75,
		buffcolorb = 0,
		unbuffcolorr = .75,
		unbuffcolorg = 0,
		unbuffcolorb = 0,
		warnbuffcolorr = .75,
		warnbuffcolorg = .75,
		warnbuffcolorb = 0,
		bordercolorr = 1,
		bordercolorg = 1,
		bordercolorb = 1,
		bordersize = 6,
		bginset = 1,
		bgtexture = "Blizzard Tooltip",
		bordertexture = "Blizzard Tooltip",
		petbuffs = false,
		petfood = false,
	},
}


--[[ ---------------------------------------------------------------------------
	 Toggle the config window
----------------------------------------------------------------------------- ]]
function BuffEnough:ToggleConfigDialog()

   local frame = C.OpenFrames[L["BuffEnough"]]

   if frame then
	  C:Close(L["BuffEnough"])
   else
	  C:Open(L["BuffEnough"])
	  self:SetStatusText(string.format(L["Profile: %s"], self.db:GetCurrentProfile()))
   end

end


--[[ ---------------------------------------------------------------------------
	 Display the set of custom buffs defined by the user in the config dialog
----------------------------------------------------------------------------- ]]
function BuffEnough:DisplayCustomBuffs()

	local customArgs = {}
	local i = 1
	
	for category, t in pairs(BuffEnough:GetProfileParam("custom")) do
	
		for buff,action in pairs(t) do
	
			local key = category..string.lower(string.gsub(buff, " ", ""))
		
			customArgs[key] = {
				type = "description",
				name = category..": "..buff.." ["..action.."]",
				order = i,
			}
		
			i = i + 1
		
			customArgs[key.."delete"] = {
				type = "execute",
				name = L["Delete"],
				confirm = true,
				confirmText = L["Are you sure you want to delete this custom buff?"],
				order = i,
				width = "half",
				func = function(info)
						BuffEnough.db.profile.custom[category][buff] = nil
						BuffEnough:DisplayCustomBuffs()
						BuffEnough:RunCheck()
				   	   end
			}
		
			i = i + 1
		end
		
	end

	BuffEnough.options.args.custom.args.customdefined.args = customArgs
	
end


--[[ ---------------------------------------------------------------------------
	 Set the text displayed at the bottom of the config window
----------------------------------------------------------------------------- ]]
function BuffEnough:SetStatusText(text)

   local frame = C.OpenFrames[L["BuffEnough"]]

   if frame then
	  frame:SetStatusText(text)
   end

end


--[[ ---------------------------------------------------------------------------
	 Update config display on a profile change
----------------------------------------------------------------------------- ]]
function BuffEnough:OnProfileChanged(event, newdb)

   if event ~= "OnProfileDeleted" then
	  self:SetStatusText(string.format(L["Profile: %s"], self.db:GetCurrentProfile()))
	  BuffEnough:RunCheck()
   end

end


--[[ ---------------------------------------------------------------------------
	 Set a saved variable config option
----------------------------------------------------------------------------- ]]
function BuffEnough:SetProfileParam(var, value)

   local varName = nil

   if type(var) == "string" then
	   varName = var
   else
	   varName = var[#var]
   end

   self.db.profile[varName] = value

end


--[[ ---------------------------------------------------------------------------
	 Get a saved variable config option
----------------------------------------------------------------------------- ]]
function BuffEnough:GetProfileParam(var) 

   local varName = nil

   if type(var) == "string" then
	   varName = var
   else
	   varName = var[#var]
   end

   return self.db.profile[varName]

end