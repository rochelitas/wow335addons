function ChatMOD_COM_Send(msg,to)
	  if( to == "ALL" ) then
	      if(IsInGuild()) then SendAddonMessage(ChatMOD_COM_ID, msg, "GUILD"); end;
	      if(UnitInRaid("player")) then
   		      SendAddonMessage(ChatMOD_COM_ID, msg, "RAID");
		  elseif( UnitInParty("player") ) then
              SendAddonMessage(ChatMOD_COM_ID, msg, "PARTY");
		  end;
	  elseif( to == "GUILD" and IsInGuild() ) then
	        return SendAddonMessage(ChatMOD_COM_ID, msg, to);
      elseif( to == "RAID" and UnitInRaid("player") ) then
	        return SendAddonMessage(ChatMOD_COM_ID, msg, to);
	  elseif( to == "PARTY" and UnitInParty("player") ) then
	        return SendAddonMessage(ChatMOD_COM_ID, msg, to);
	  end;
end;

function ChatMOD_COM_Parse(var,chan,player)
	  ChatMOD_debug("ChatMOD_COM_Parse","["..player..":"..chan.."]"..var);
	  -- AntiSPAM
	  -- and player ~= UnitName("player")
	  if( var ~= SCCN_LAST_VAR  ) then
	  	  SCCN_LAST_VAR = var;
		  if( string.find(var, "INIT:" ) ) then
		  	  var = string.gsub(var, "INIT:", "", 1);
	  	      if( SCCN_displayusage == 1 ) then
	  	  	  	  SCCN_write(player.." using ChatMOD rev."..var);
  		      end;
		  elseif( string.find(var, "PING_RQ:" ) ) then
			 -- Ping Request received
	          var = string.gsub(var, "PING_RQ:", "", 1);
	          ChatMOD_COM_Send("PING_RE:"..CHATMOD_REVISION, chan);
	      elseif( string.find(var, "PING_RE:" ) ) then
			 -- Ping Reply received
	          var = string.gsub(var, "PING_RE:", "", 1);
	          SCCN_write("Ping reply from '"..player.."' using rev."..var);
          elseif( string.find(var, "NEW:" ) ) then
			  if( SCCN_COM_GUILD == 1) then
              	  string.gsub(var, "NEW\:(%a-)\:(%d+)\:(%d+)", ChatMOD_COM_NewPlayer);
			  end
		  end
	  -- EO Anti SPAM
	  end;
end;

function ChatMOD_COM_Init()
	  if( ChatMOD_COM_INIT == nil ) then
	  	  ChatMOD_COM_INIT = 1;
	  	  ChatMOD_COM_Send("INIT:"..CHATMOD_REVISION, "ALL");
	  end;
end

function ChatMOD_COM_NewPlayer(name,class,level)
 ChatMOD_debug("ChatMOD_COM_NewPlayer",name..","..class..","..level);
 local LOWname = ChatMOD_prepName(name);
 SCCN_storage[LOWname] = { c = class, t=time(), l = level };
end
