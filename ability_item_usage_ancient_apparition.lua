local tableAbilitiesToLearn = {
  "ancient_apparition_cold_feet",
  "ancient_apparition_ice_vortex",
  "ancient_apparition_cold_feet",
  "ancient_apparition_ice_vortex",
  "ancient_apparition_cold_feet",

  "ancient_apparition_ice_blast", -- lvl 6
  "ancient_apparition_cold_feet",
  "ancient_apparition_ice_vortex",
  "ancient_apparition_ice_vortex",
  "special_bonus_spell_amplify_8",

  "ancient_apparition_chilling_touch",
  "ancient_apparition_ice_blast", -- lvl 12
  "ancient_apparition_chilling_touch",
  "ancient_apparition_chilling_touch",
  "special_bonus_hp_regen_25",

  "ancient_apparition_chilling_touch",
  "ancient_apparition_ice_blast", -- lvl 18

  "special_bonus_movement_speed_35",

  "special_bonus_unique_ancient_apparition_1"
}

pcall(require, "bots/utility/ability_usage" )

----------------------------------------------------------------------------------------------------

local castCFDesire = 0;
local castIVDesire = 0;
local castCTDesire = 0;
local castIBDesire = 0;
local abilityCF = nil;
local abilityIV = nil;
local abilityCT = nil;
local abilityIB = nil;
local abilityIBR = nil;
local dModifier = 0.0;
local iceBlastActive = false;
local iceBlastStartTime = 0;
local iceBlastTravelTime = 0;

local npcBot = GetBot();

function AbilityUsageThink()
  abilityCF = npcBot:GetAbilityByName( "ancient_apparition_cold_feet" );
  abilityIV = npcBot:GetAbilityByName( "ancient_apparition_ice_vortex" );
  abilityCT = npcBot:GetAbilityByName( "ancient_apparition_chilling_touch" );
  abilityIB = npcBot:GetAbilityByName( "ancient_apparition_ice_blast" );
  abilityIBR = npcBot:GetAbilityByName( "ancient_apparition_ice_blast_release" );

  abilityLevelUp( npcBot, tableAbilitiesToLearn );

  -- Check if we're already using an ability
  if ( npcBot:IsUsingAbility() ) then return end;

  -- Consider using each ability
  castCFDesire, castCFTarget = ConsiderColdFeet();
  castIVDesire, castIVLocation = ConsiderIceVortex();
  castCTDesire, castCTLocation = ConsiderChillingTouch();
  castIBDesire, castIBLocation = ConsiderIceBlast();

  if ( iceBlastActive ) then
    if ( DotaTime() - iceBlastStartTime >= iceBlastTravelTime ) then
      -- detonate ice blast
      iceBlastActive = false;
      npcBot:Action_UseAbility( abilityIBR );
      return;
    end
  end

  if ( castIBDesire > BOT_ACTION_DESIRE_NONE and not iceBlastActive ) then
    iceBlastActive = true;
    iceBlastStartTime = DotaTime();
    iceBlastTravelTime = GetUnitToLocationDistance( npcBot, castIBLocation) / abilityIB:GetSpecialValueInt( 'speed' );
    npcBot:Action_UseAbilityOnLocation( abilityIB, castIBLocation );
    return;
  end

  if ( castCTDesire > BOT_ACTION_DESIRE_NONE ) then
    npcBot:Action_UseAbilityOnLocation( abilityCT, castCTLocation );
    return;
  end

  if ( castCFDesire > BOT_ACTION_DESIRE_NONE ) then
    npcBot:Action_UseAbilityOnEntity( abilityCF, castCFTarget );
    return;
  end

  if ( castIVDesire > BOT_ACTION_DESIRE_NONE ) then
    npcBot:Action_UseAbilityOnLocation( abilityIV, castIVLocation );
    return;
  end

end

----------------------------------------------------------------------------------------------------

function CanCastColdFeetOnTarget( npcTarget )
  return npcTarget:CanBeSeen() and not npcTarget:IsMagicImmune() and not npcTarget:IsInvulnerable();
end

function CanCastIceVortexOnTarget( npcTarget )
  return npcTarget:CanBeSeen() and not npcTarget:IsMagicImmune() and not npcTarget:IsInvulnerable();
end

function CanCastChillingTouchOnTarget( npcTarget )
  return npcTarget:CanBeSeen();
end

function CanCastIceBlastOnTarget( npcTarget )
  return npcTarget:CanBeSeen() and not npcTarget:IsMagicImmune() and not npcTarget:IsInvulnerable();
end

----------------------------------------------------------------------------------------------------

function ConsiderColdFeet()
  if ( not abilityCF:IsFullyCastable() ) then
    return BOT_ACTION_DESIRE_NONE, 0;
  end;

  -- Get some of its values
  local nCastRange = abilityCF:GetCastRange();

  -- decide to damage current enemy target?
  local npcTarget = npcBot:GetTarget();

  if ( npcTarget ~= nil ) then
    if ( CanCastColdFeetOnTarget( npcTarget )
      and GetUnitToUnitDistance( npcBot, npcTarget ) <= nCastRange ) then

      return BOT_ACTION_DESIRE_MODERATE + dModifier, npcTarget;
    end
  end

  -- or find the nearest enemy with slow or rooted
  local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes( nCastRange, true, BOT_MODE_NONE );
  for _,npcEnemy in pairs( tableNearbyEnemyHeroes ) do
    if ( CanCastColdFeetOnTarget( npcEnemy ) ) then
      if ( npcEnemy:IsRooted() or npcEnemy:IsHexed() or npcEnemy:IsStunned()
        or npcEnemy:GetBaseMovementSpeed() <= 250 ) then
        return BOT_ACTION_DESIRE_HIGH + dModifier, npcEnemy;
      end
    end
  end

  return BOT_ACTION_DESIRE_NONE, 0;
end

function ConsiderIceVortex()
  if ( not abilityIV:IsFullyCastable() ) then
    return BOT_ACTION_DESIRE_NONE, 0;
  end;

  local nCastRange = abilityIV:GetCastRange();
  -- decide to damage current enemy target?
  local npcTarget = npcBot:GetTarget();

  if ( npcTarget ~= nil and npcTarget:IsHero() ) then
    if ( CanCastIceVortexOnTarget( npcTarget )
      and GetUnitToUnitDistance( npcBot, npcTarget ) <= nCastRange ) then

      return BOT_ACTION_DESIRE_MODERATE + dModifier, npcTarget:GetLocation();
    end
  end

  local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes( nCastRange, true, BOT_MODE_NONE );
  for _,npcEnemy in pairs( tableNearbyEnemyHeroes ) do
    if ( CanCastIceVortexOnTarget( npcEnemy ) ) then
      if ( npcEnemy:IsRooted() or npcEnemy:IsHexed() or npcEnemy:IsStunned()
        or npcEnemy:GetBaseMovementSpeed() >= 400
        or ( npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH )) then
        return BOT_ACTION_DESIRE_HIGH + dModifier, npcEnemy:GetLocation();
      end
    end
  end


  return BOT_ACTION_DESIRE_NONE, 0;
end

function ConsiderChillingTouch()
  if ( not abilityCT:IsFullyCastable() ) then
    return BOT_ACTION_DESIRE_NONE, 0;
  end;

  local nCastRange = abilityCT:GetCastRange();
  local nRadius = abilityCT:GetSpecialValueInt('radius');
  local locationAoE = npcBot:FindAoELocation( false, true, npcBot:GetLocation(), nCastRange, nRadius, 0, 0 );

  if ( locationAoE.count >= 3 )
  then
    return BOT_ACTION_DESIRE_MODERATE, locationAoE.targetloc;
  end

  return BOT_ACTION_DESIRE_NONE, 0;
end

function ConsiderIceBlast()
  if ( not abilityIB:IsFullyCastable() ) then
    return BOT_ACTION_DESIRE_NONE;
  end;

  local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes( 4000, true, BOT_MODE_NONE );
  for _,npcEnemy in pairs( tableNearbyEnemyHeroes ) do
    if ( CanCastIceBlastOnTarget( npcEnemy ) ) then
      return BOT_ACTION_DESIRE_MODERATE + dModifier, npcEnemy:GetLocation();
    end
  end

  return BOT_ACTION_DESIRE_NONE, 0;
end
