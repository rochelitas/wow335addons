--- **AceConsole-3.0** provides registration facilities for slash commands.
-- You can register slash commands to your custom functions and use the `GetArgs` function to parse them
-- to your addons individual needs.
--
-- **AceConsole-3.0** can be embeded into your addon, either explicitly by calling AceConsole:Embed(MyAddon) or by 
-- specifying it as an embeded library in your AceAddon. All functions will be available on your addon object
-- and can be accessed directly, without having to explicitly call AceConsole itself.\\
-- It is recommended to embed AceConsole, otherwise you'll have to specify a custom `self` on all calls you
-- make into AceConsole.
-- @class file
-- @name AceConsole-3.0
-- @release $Id: AceConsole-3.0.lua 779 2009-04-05 08:52:46Z nevcairiel $
local MAJOR,MINOR = "AceConsole-3.0", 6

local AceConsole, oldminor = LibStub:NewLibrary(MAJOR, MINOR)

if not AceConsole then return end -- No upgrade needed

AceConsole.embeds = AceConsole.embeds or {} -- table containing objects AceConsole is embedded in.
AceConsole.commands = AceConsole.commands or {} -- table containing commands registered
AceConsole.weakcommands = AceConsole.weakcommands or {} -- table containing self, command => func references for weak commands that don't persist through enable/disable

-- local upvalues
local _G = _G
local pairs = pairs
local select = select
local type = type
local tostring = tostring
local strfind = string.find
local strsub = string.sub
local max = math.max

--- Print to DEFAULT_CHAT_FRAME or given ChatFrame (anything with an .AddMessage function)
-- @paramsig [chatframe ,] ...
-- @param chatframe Custom ChatFrame to print to (or any frame with an .AddMessage function)
-- @param ... List of any values to be printed
function AceConsole:Print(...)
	local text = ""
	if self ~= AceConsole then
		text = "|cff33ff99"..tostring( self ).."|r: "
	end

	local frame = select(1, ...)
	if not ( type(frame) == "table" and frame.AddMessage ) then	-- Is first argument something with an .AddMessage member?
		frame=nil
	end
	
	for i=(frame and 2 or 1), select("#", ...) do
		text = text .. tostring( select( i, ...) ) .." "
	end
	(frame or DEFAULT_CHAT_FRAME):AddMessage( text )
end


--- Register a simple chat command
-- @param command Chat command to be registered WITHOUT leading "/"
-- @param func Function to call when the slash command is being used (funcref or methodname)
-- @param persist if false, the command will be soft disabled/enabled when aceconsole is used as a mixin (default: true)
function AceConsole:RegisterChatCommand( command, func, persist )
	if type(command)~="string" then error([[Usage: AceConsole:RegisterChatCommand( "command", func[, persist ]): 'command' - expected a string]], 2) end
	
	if persist==nil then persist=true end	-- I'd rather have my addon's "/addon enable" around if the author screws up. Having some extra slash regged when it shouldnt be isn't as destructive. True is a better default. /Mikk
	
	local name = "ACECONSOLE_"..command:upper()
	
	if type( func ) == "string" then
		SlashCmdList[name] = function(input, editBox)
			self[func](self, input, editBox)
		end
	else
		SlashCmdList[name] = func
	end
	_G["SLASH_"..name.."1"] = "/"..command:lower()
	AceConsole.commands[command] = name
	-- non-persisting commands are registered for enabling disabling
	if not persist then
		if not AceConsole.weakcommands[self] then AceConsole.weakcommands[self] = {} end
		AceConsole.weakcommands[self][command] = func
	end
	return true
end

--- Unregister a chatcommand
-- @param command Chat command to be unregistered WITHOUT leading "/"
function AceConsole:UnregisterChatCommand( command )
	local name = AceConsole.commands[command]
	if name then
		SlashCmdList[name] = nil
		_G["SLASH_" .. name .. "1"] = nil
		hash_SlashCmdList["/" .. command:upper()] = nil
		AceConsole.commands[command] = nil
	end
end

--- Get an iterator over all Chat Commands registered with AceConsole
-- @return Iterator (pairs) over all commands
function AceConsole:IterateChatCommands() return pairs(AceConsole.commands) end


local function nils(n, ...)
	if n>1 then
		return nil, nils(n-1, ...)
	elseif n==1 then
		return nil, ...
	else
		return ...
	end
end
	

--- Retreive one or more space-separated arguments from a string. 
-- Treats quoted strings and itemlinks as non-spaced.
-- @param string The raw argument string
-- @param numargs How many arguments to get (default 1)
-- @param startpos Where in the string to start scanning (default  1)
-- @return Returns arg1, arg2, ..., nextposition\\
-- Missing arguments will be returned as nils. 'nextposition' is returned as 1e9 at the end of the string.
function AceConsole:GetArgs(str, numargs, startpos)
	numargs = numargs or 1
	startpos = max(startpos or 1, 1)
	
	local pos=startpos

	-- find start of new arg
	pos = strfind(str, "[^ ]", pos)
	if not pos then	-- whoops, end of string
		return nils(numargs, 1e9)
	end

	if numargs<1 then
		return pos
	end

	-- quoted or space separated? find out which pattern to use
	local delim_or_pipe
	local ch = strsub(str, pos, pos)
	if ch=='"' then
		pos = pos + 1
		delim_or_pipe='([|"])'
	elseif ch=="'" then
		pos = pos + 1
		delim_or_pipe="([|'])"
	else
		delim_or_pipe="([| ])"
	end
	
	startpos = pos
	
	while true do
		-- find delimiter or hyperlink
		local ch,_
		pos,_,ch = strfind(str, delim_or_pipe, pos)
		
		if not pos then break end
		
		if ch=="|" then
			-- some kind of escape
			
			if strsub(str,pos,pos+1)=="|H" then
				-- It's a |H....|hhyper link!|h
				pos=strfind(str, "|h", pos+2)	-- first |h
				if not pos then break end
				
				pos=strfind(str, "|h", pos+2)	-- second |h
				if not pos then break end
			elseif strsub(str,pos, pos+1) == "|T" then
				-- It's a |T....|t  texture
				pos=strfind(str, "|t", pos+2)
				if not pos then break end
			end
			
			pos=pos+2 -- skip past this escape (last |h if it was a hyperlink)
		
		else
			-- found delimiter, done with this arg
			return strsub(str, startpos, pos-1), AceConsole:GetArgs(str, numargs-1, pos+1)
		end
		
	end
	
	-- search aborted, we hit end of string. return it all as one argument. (yes, even if it's an unterminated quote or hyperlink)
	return strsub(str, startpos), nils(numargs-1, 1e9)
end


--- embedding and embed handling

local mixins = {
	"Print",
	"RegisterChatCommand", 
	"UnregisterChatCommand",
	"GetArgs",
} 

-- Embeds AceConsole into the target object making the functions from the mixins list available on target:..
-- @param target target object to embed AceBucket in
function AceConsole:Embed( target )
	for k, v in pairs( mixins ) do
		target[v] = self[v]
	end
	self.embeds[target] = true
	return target
end

function AceConsole:OnEmbedEnable( target )
	if AceConsole.weakcommands[target] then
		for command, func in pairs( AceConsole.weakcommands[target] ) do
			target:RegisterChatCommand( command, func, false, true ) -- nonpersisting and silent registry
		end
	end
end

function AceConsole:OnEmbedDisable( target )
	if AceConsole.weakcommands[target] then
		for command, func in pairs( AceConsole.weakcommands[target] ) do
			target:UnregisterChatCommand( command ) -- TODO: this could potentially unregister a command from another application in case of command conflicts. Do we care?
		end
	end
end

for addon in pairs(AceConsole.embeds) do
	AceConsole:Embed(addon)
end
