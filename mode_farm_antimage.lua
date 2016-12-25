
----------------------------------------------------------------------------------------------------
--[[
function OnStart()
	--print( "mode_generic_defend_ally.OnStart" );
end

----------------------------------------------------------------------------------------------------

function OnEnd()
	--print( "mode_generic_defend_ally.OnEnd" );
end

-------------------------------------------------------------\---------------------------------------

function Think()
	--print( "mode_generic_defend_ally.Think" );
end

----------------------------------------------------------------------------------------------------
]]--
function GetDesire()
  local npcBot = GetBot();
  local desire = BOT_MODE_DESIRE_NONE;

  for i=0,14 do
    local sCurItem = npcBot:GetItemInSlot( i );
    if ( sCurItem ~= nil ) then
      local iName = sCurItem:GetName();
      if (iName == 'item_bfury') then
        return Clamp( BOT_MODE_DESIRE_NONE, BOT_MODE_DESIRE_NONE, BOT_MODE_DESIRE_ABSOLUTE );
      end
    end
  end

  return Clamp( desire, BOT_MODE_DESIRE_NONE, BOT_MODE_DESIRE_ABSOLUTE );
end

----------------------------------------------------------------------------------------------------
