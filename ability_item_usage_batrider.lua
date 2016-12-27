local tableAbilitiesToLearn = {
  "batrider_sticky_napalm",
  "batrider_firefly",
  "batrider_sticky_napalm",
  "batrider_firefly",
  "batrider_sticky_napalm",

  "batrider_flaming_lasso", -- lvl 6
  "batrider_sticky_napalm",
  "batrider_firefly",
  "batrider_firefly",
  "special_bonus_armor_4",

  "batrider_flamebreak",
  "batrider_flaming_lasso", -- lvl 12
  "batrider_flamebreak",
  "batrider_flamebreak",
  "special_bonus_hp_175",

  "batrider_flamebreak",
  "batrider_flaming_lasso", -- lvl 18

  "special_bonus_movement_speed_35",

  "special_bonus_unique_batrider_1"
}

pcall(require, "bots/utility/ability_usage" )

----------------------------------------------------------------------------------------------------

local castSNDesire = 0;
local castFBDesire = 0;
local castFFDesire = 0;
local castFLDesire = 0;
local abilitySN = nil;
local abilityFB = nil;
local abilityFF = nil;
local abilityFL = nil;
local flamingLassoToRadiant = Vector(-7000, -7000);
local flamingLassoToDire = Vector(7000, 7000);
local dModifier = 0.0;

local npcBot = GetBot();

function AbilityUsageThink()
  abilitySN = npcBot:GetAbilityByName( "batrider_sticky_napalm" );
  abilityFB = npcBot:GetAbilityByName( "batrider_flamebreak" );
  abilityFF = npcBot:GetAbilityByName( "batrider_firefly" );
  abilityFL = npcBot:GetAbilityByName( "batrider_flaming_lasso" );

  abilityLevelUp( npcBot, tableAbilitiesToLearn );

  -- Check if we're already using an ability
  if ( npcBot:IsUsingAbility() ) then return end;

  -- Consider using each ability
  castSNDesire, castSNLocation = ConsiderStickyNapalm();
  castFBDesire, castFBLocation = ConsiderFlamebreak();
  castFFDesire = ConsiderFirefly();
  castFLDesire, castFLTarget = ConsiderFlamingLasso();

  if ( castFLDesire > BOT_ACTION_DESIRE_NONE ) then
    npcBot:Action_UseAbilityOnEntity( abilityFL, castFLTarget );
    return;
  end

  if ( castFFDesire > BOT_ACTION_DESIRE_NONE ) then
    npcBot:Action_UseAbility( abilityFF );
    return;
  end

  if ( castFBDesire > BOT_ACTION_DESIRE_NONE ) then
    npcBot:Action_UseAbilityOnLocation( abilityFB, castFBLocation );
    return;
  end

  if ( castSNDesire > BOT_ACTION_DESIRE_NONE ) then
    npcBot:Action_UseAbilityOnLocation( abilitySN, castSNLocation );
    return;
  end

end

----------------------------------------------------------------------------------------------------

function CanCastStickyNapalmOnTarget( npcTarget )
  return npcTarget:CanBeSeen() and not npcTarget:IsMagicImmune() and not npcTarget:IsInvulnerable();
end

function CanCastFlamebreakOnTarget( npcTarget )
  return npcTarget:CanBeSeen() and not npcTarget:IsMagicImmune() and not npcTarget:IsInvulnerable();
end

function CanCastFlamingLassoOnTarget( npcTarget )
  return npcTarget:CanBeSeen() and not npcTarget:IsMagicImmune() and not npcTarget:IsInvulnerable();
end

----------------------------------------------------------------------------------------------------

function ConsiderStickyNapalm()
  if ( not abilitySN:IsFullyCastable() ) then
    return BOT_ACTION_DESIRE_NONE, 0;
  end;

  -- Get some of its values
  local nCastRange = abilitySN:GetCastRange();

  -- find nearby enemy hero
  local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes( nCastRange, true, BOT_MODE_NONE );
  for _,npcEnemy in pairs( tableNearbyEnemyHeroes ) do
    if ( CanCastStickyNapalmOnTarget( npcEnemy ) ) then
      return BOT_ACTION_DESIRE_HIGH + dModifier, npcEnemy:GetLocation();
    end
  end

  return BOT_ACTION_DESIRE_NONE, 0;
end

function ConsiderFlamebreak()
  if ( not abilityFB:IsFullyCastable() ) then
    return BOT_ACTION_DESIRE_NONE, 0;
  end;

  -- Get some of its values
  local nCastRange = abilityFB:GetCastRange();

  -- decide to damage current enemy target?
  local npcTarget = npcBot:GetTarget();

  if ( npcTarget ~= nil and npcTarget:IsHero() ) then
    if ( CanCastFlamebreakOnTarget( npcTarget )
      and GetUnitToUnitDistance( npcBot, npcTarget ) <= nCastRange ) then

      return BOT_ACTION_DESIRE_MODERATE, npcTarget:GetLocation();
    end
  end

  return BOT_ACTION_DESIRE_NONE, 0;
end

function ConsiderFirefly()
  if ( not abilityFF:IsFullyCastable() ) then
    return BOT_ACTION_DESIRE_NONE;
  end;

  if ( npcBot:HasModifier('modifier_batrider_flaming_lasso_self') ) then
    return BOT_ACTION_DESIRE_HIGH;
  end

  if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT ) then
    if ( npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_MODERATE and npcBot:WasRecentlyDamagedByAnyHero(1.0) ) then
      return BOT_ACTION_DESIRE_MODERATE;
    end
  end

  return BOT_ACTION_DESIRE_NONE, 0;
end

function ConsiderFlamingLasso()
  -- move to base dragging enemies
  if ( npcBot:HasModifier('modifier_batrider_flaming_lasso_self') ) then
    local loc;
    if ( GetTeam() == TEAM_RADIANT ) then
      loc = flamingLassoToRadiant;
    else
      loc = flamingLassoToDire;
    end
    npcBot:Action_MoveToLocation( loc );
    return BOT_ACTION_DESIRE_NONE, 0;
  end

  if ( not abilityFL:IsFullyCastable() ) then
    return BOT_ACTION_DESIRE_NONE, 0;
  end;

  -- Get some of its values
  local nCastRange = abilityFL:GetCastRange();

  -- decide to damage current enemy target?
  local npcTarget = npcBot:GetTarget();

  if ( npcTarget ~= nil and npcTarget:IsHero() ) then
    if ( CanCastFlamingLassoOnTarget( npcTarget )
      and GetUnitToUnitDistance( npcBot, npcTarget ) <= nCastRange ) then

      return BOT_ACTION_DESIRE_MODERATE, npcTarget;
    end
  end

  return BOT_ACTION_DESIRE_NONE, 0;
end
