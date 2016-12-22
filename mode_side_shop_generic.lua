_G._savedEnv = getfenv()
module( "mode_side_shop_generic", package.seeall )

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
  if ( npcBot.sideShopMode == true ) then
    desire = BOT_MODE_DESIRE_MODERATE;
  end

  return Clamp( desire, BOT_MODE_DESIRE_NONE, BOT_MODE_DESIRE_ABSOLUTE );
end

----------------------------------------------------------------------------------------------------
for k,v in pairs( mode_side_shop_generic ) do _G._savedEnv[k] = v end
