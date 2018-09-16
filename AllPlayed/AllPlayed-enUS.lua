-- AllPlayed-enUS.lua
-- $Id: AllPlayed-enUS.lua 207 2010-03-01 03:44:13Z LaoTseu $
if not AllPlayed_revision then AllPlayed_revision = {} end
AllPlayed_revision.enUS	= ("$Revision: 207 $"):match("(%d+)")


--local L = AceLibrary("AceLocale-2.2"):new("AllPlayed")
local L = LibStub("AceLocale-3.0"):NewLocale("AllPlayed", "enUS", true)

---
--- Global strings section, no translation needed
---

-- Faction names
--L["Alliance"]                                            			= FACTION_ALLIANCE
--L["Horde"]                                               			= FACTION_HORDE

---
--- End of Global strings section
---

-- Tablet title
L["All Played Breakdown"]                                			= true

-- Menus
L["AllPlayed Configuration"]													= true
L["Version %s (r%s)"]															= true
L["Display"]                                             			= true
L["Set the display options"]                             			= true
L["All Factions"]                                        			= true
L["All factions will be displayed"]                      			= true
L["All Realms"]                                          			= true
L["All realms will de displayed"]                        			= true
L["Show Played Time"]															= true
L["Display the played time and the total time played"]				= true
L["Show Seconds"]                                        			= true
L["Display the seconds in the time strings"]             			= true
L["Show Gold"]                                    						= true
L["Display the gold each character pocess"]     						= true
L["Show XP Progress"]                                    			= true
L["Display XP progress as a decimal value appended to the level"]	= true
L["Show XP total"]																= true
L["Show the total XP for all characters"]									= true
L["Rested XP"]                                           			= true
L["Set the rested XP options"]                                   	= true
L["Rested XP Total"]                                             	= true
L["Show the character rested XP"]                                	= true
L["Percent Rest"]                                                	= true
L["Set the base for % display of rested XP"]                     	= true
L["Rested XP Countdown"]                                         	= true
L["Show the time remaining before the character is 100% rested"]	= true
L["PVP"]																				= true
L["Set the PVP options"]														= true
L["Arena Points"]																	= true
L["Show the character arena points"]										= true
L["Honor Points"]																	= true
L["Show the character honor points"]										= true
L["Honor Kills"]																	= true
L["Show the character honor kills"]											= true
L["Show PVP Totals"]																= true
--L["Badges of Justice"]															= true
--L["Show the character badges of Justice"]									= true
--L["WG Marks"]																		= true
--L["Show the Warsong Gulch Marks"]											= true
--L["AB Marks"]																		= true
--L["Show the Arathi Basin Marks"]												= true
--L["AV Marks"]																		= true
--L["Show the Alterac Valley Marks"]											= true
--L["EotS Marks"]																	= true
--L["Show the Eye of the Storm Marks"]										= true
L["Show the honor related stats for all characters"]					= true
L["Show Class Name"]                                     			= true
L["Show the character class beside the level"]           			= true
L["Show Location"]																= true
L["Show the character location"]												= true
L["Don't show location"]														= true
L["Show zone"]																		= true
L["Show subzone"]																	= true
L["Show zone/subzone"]															= true
L["Colorize Class"]                                  	    			= true
L["Colorize the character name based on class"]      	    			= true
L["Use Old Shaman Colour"]														= true
L["Use the pre-210 patch colour for the Shaman class"]				= true
L["Sort Type"]																		= true
L["Select the sort type"]														= true
L["By name"]																		= true
L["By level"]																		= true
L["By experience"]																= true
L["By rested XP"]																	= true
L["By % rested"]																	= true
L["By money"]																		= true
L["By time played"]																= true
L["Sort in reverse order"]														= true
L["Use the curent sort type in reverse order"]							= true
L["Use Icons"]																		= true
L["Use graphics for coin and PvP currencies"]							= true
L["Minimap Icon"]																	= true
L["Show Minimap Icon"]															= true
L["Scale"]																			= true
L["Scale the tooltip (70% to 150%)"]										= true
L["Opacity"]      																= true
L["% opacity of the tooltip background"]									= true
L["Sort"]																			= true
L["Set the sort options"]														= true
L["Ignore Characters"]                                      		= true
L["Hide characters from display"]                           		= true
L["%s : %s"]																		= true
L["Hide %s of %s from display"]												= true
L["BC Installed?"]                                          		= true
L["Is the Burning Crusade expansion installed?"]            		= true
L["Close"]                                        	       			= true
L["Close the tooltip"]                            	       			= true
L["None"]                                         	       			= true
L["100%"]																			= true
L["150%"]																			= true

-- Strings
L["v%s - %s (Type /ap for help)"]                 	       			= true
L["%s characters "]                               	       			= true
L["%d rested XP"]                                 	    				= true
L["rested"]                                       		        		= true
L["Total %s Time Played: "]                              			= true
L["Total %s Cash Value: "]                               			= true
L["Total Time Played: "]                                 			= true
L["Total Cash Value: "]                                  			= true
L["Total PvP: "]																	= true
L["Total XP: "]																	= true
L["Unknown"]																		= true
L["%.1f M XP"]																		= true
L["%.1f K XP"]																		= true
L["%d XP"]																			= true
L['%s HK']																			= true
L['%s HP']																			= true
L['%s AP']																			= true
--L['%s BoJ']																			= true
--L['%s AB']																			= true
--L['%s AV']																			= true
--L['%s WG']																			= true
--L['%s EotS']																		= true

-- Console commands
L["/allplayed"]                                   	       			= true
L["/ap"]                                          	       			= true
--L["/allplayedcl"]                                          			= true
--L["/apcl"]                                                 			= true

-- New stuff for 30300-2
L["Filter"]																			= true
L["Specify what to display"]													= true
L["Configuration"]																= true
L["Open configuration dialog"]												= true
L["Factions and Realms"]														= true
L["Time Played"]																	= true
L["About"]																			= true
L["UI"]																				= true
L["Set UI options"]																= true
L["Experience Points"]															= true
L["Sort Order"]																	= true
L["Main Settings"]																= true
L["Do not show Percent Rest"]													= true

