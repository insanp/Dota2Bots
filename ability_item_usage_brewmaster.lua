local tableAbilitiesToLearn = {
  "brewmaster_thunder_clap",
  "brewmaster_drunken_haze",
  "brewmaster_thunder_clap",
  "brewmaster_drunken_haze",
  "brewmaster_thunder_clap",

  "brewmaster_primal_split", -- lvl 6
  "brewmaster_thunder_clap",
  "brewmaster_drunken_haze",
  "brewmaster_drunken_haze",
  "special_bonus_mp_regen_3",

  "brewmaster_drunken_brawler",
  "brewmaster_primal_split", -- lvl 12
  "brewmaster_drunken_brawler",
  "brewmaster_drunken_brawler",
  "special_bonus_movement_speed_20",

  "brewmaster_drunken_brawler",
  "brewmaster_primal_split", -- lvl 18

  "special_bonus_strength_20",

  "special_bonus_unique_brewmaster"
}

pcall(require, "bots/utility/ability_usage" )

----------------------------------------------------------------------------------------------------

local castTCDesire = 0;
local castDHDesire = 0;
local castPSDesire = 0;
local abilityTC = nil;
local abilityDH = nil;
local abilityPS = nil;
local dModifier = 0.0;
local retreatMode = false;

--local minX, minY, maxX, maxY = GetWorldBounds();
--local vRadiant = Vector(minX, minY);
--local vDire = Vector(maxX, maxY);

local npcBot = GetBot();

function AbilityUsageThink()
  abilityTC = npcBot:GetAbilityByName( "brewmaster_thunder_clap" );
  abilityDH = npcBot:GetAbilityByName( "brewmaster_drunken_haze" );
  abilityPS = npcBot:GetAbilityByName( "brewmaster_primal_split" );

  if ( RollPercentage(10) ) then
    print(npcBot:GetUnitName());
  end

  abilityLevelUp( npcBot, tableAbilitiesToLearn );

  -- Check if we're already using an ability
  if ( npcBot:IsUsingAbility() ) then return end;

  -- Consider using each ability
  castTCDesire = ConsiderThunderClap();
  castDHDesire, castDHTarget = ConsiderDrunkenHaze();
  castPSDesire = ConsiderPrimalSplit();

  if ( castPSDesire > BOT_ACTION_DESIRE_NONE ) then
    npcBot:Action_UseAbility( abilityPS );
    return;
  end

  if ( castTCDesire > BOT_ACTION_DESIRE_NONE ) then
    npcBot:Action_UseAbility( abilityTC );
    return;
  end

  if ( castDHDesire > BOT_ACTION_DESIRE_NONE ) then
    npcBot:Action_UseAbilityOnEntity( abilityDH, castDHTarget );
    return;
  end

end

----------------------------------------------------------------------------------------------------

function CanCastThunderClapOnTarget( npcTarget )
  return npcTarget:CanBeSeen() and not npcTarget:IsMagicImmune() and not npcTarget:IsInvulnerable();
end

function CanCastDrunkenHazeOnTarget( npcTarget )
  return npcTarget:CanBeSeen() and not npcTarget:IsMagicImmune() and not npcTarget:IsInvulnerable();
end

----------------------------------------------------------------------------------------------------

function ConsiderThunderClap()
  if ( not abilityTC:IsFullyCastable() ) then
    return BOT_ACTION_DESIRE_NONE, 0;
  end;

  local nRadius = abilityTC:GetSpecialValueInt( "radius" );

  local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes( nRadius / 2, true, BOT_MODE_NONE );
  for _,npcEnemy in pairs( tableNearbyEnemyHeroes ) do
    if ( CanCastThunderClapOnTarget( npcEnemy ) ) then
      return BOT_ACTION_DESIRE_MODERATE
    end
  end

  return BOT_ACTION_DESIRE_NONE, 0;
end

function ConsiderDrunkenHaze()
  if ( not abilityDH:IsFullyCastable() ) then
    return BOT_ACTION_DESIRE_NONE, 0;
  end;

  local nCastRange = abilityDH:GetCastRange();
  local npcTarget = npcBot:GetTarget();

  if ( npcTarget ~= nil
    and GetUnitToUnitDistance( npcBot, npcTarget ) <= nCastRange ) then
      return BOT_ACTION_DESIRE_MODERATE, npcTarget;
  end

  return BOT_ACTION_DESIRE_NONE, 0;
end

function ConsiderPrimalSplit()
  if ( not abilityPS:IsFullyCastable() ) then
    return BOT_ACTION_DESIRE_NONE;
  end;

  if ( npcBot:GetHealth() <= 0.2 * npcBot:GetMaxHealth() ) then
    retreatMode = true;
    return BOT_ACTION_DESIRE_HIGH;
  end

  local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes( 400, true, BOT_MODE_NONE );
  if (#tableNearbyEnemyHeroes >= 3) then
    return BOT_ACTION_DESIRE_MODERATE;
  end

  return BOT_ACTION_DESIRE_NONE;
end
