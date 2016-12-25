local tableAbilitiesToLearn = {
  "arc_warden_flux",
  "arc_warden_magnetic_field",
  "arc_warden_flux",
  "arc_warden_magnetic_field",
  "arc_warden_flux",

  "arc_warden_tempest_double", -- lvl 6
  "arc_warden_flux",
  "arc_warden_magnetic_field",
  "arc_warden_magnetic_field",
  "special_bonus_hp_125",

  "arc_warden_spark_wraith",
  "arc_warden_tempest_double", -- lvl 12
  "arc_warden_spark_wraith",
  "arc_warden_spark_wraith",
  "special_bonus_attack_damage_30",

  "arc_warden_spark_wraith",
  "arc_warden_tempest_double", -- lvl 18

  "special_bonus_cooldown_reduction_10",

  "special_bonus_unique_arc_warden"
}

pcall(require, "bots/utility/ability_usage" )

----------------------------------------------------------------------------------------------------

local castFDesire = 0;
local castMFDesire = 0;
local castSWDesire = 0;
local castTDDesire = 0;

local abilityF = nil;
local abilityMF = nil;
local abilitySW = nil;
local abilityTD = nil;

local dModifier = 0.0;

local npcBot = GetBot();

function AbilityUsageThink()
  abilityF = npcBot:GetAbilityByName( "arc_warden_flux" );
  abilityMF = npcBot:GetAbilityByName( "arc_warden_magnetic_field" );
  abilitySW = npcBot:GetAbilityByName( "arc_warden_spark_wraith" );
  abilityTD = npcBot:GetAbilityByName( "arc_warden_tempest_double" );

  abilityLevelUp( npcBot, tableAbilitiesToLearn );

  -- Check if we're already using an ability
  if ( npcBot:IsUsingAbility() ) then return end;

  -- Consider using each ability
  castFDesire, castFTarget = ConsiderFlux();
  castMFDesire, castMFLocation = ConsiderMagneticField();
  castSWDesire, castSWLocation = ConsiderSparkWraith();
  castTDDesire = ConsiderTempestDouble();

  if ( castTDDesire > BOT_ACTION_DESIRE_NONE ) then
    npcBot:Action_UseAbility( abilityTD );
    return;
  end

  if ( castSWDesire > BOT_ACTION_DESIRE_NONE ) then
    npcBot:Action_UseAbilityOnLocation( abilitySW, castSWLocation );
    return;
  end

  if ( castMFDesire > BOT_ACTION_DESIRE_NONE ) then
    npcBot:Action_UseAbilityOnLocation( abilityMF, castMFLocation );
    return;
  end

  if ( castFDesire > BOT_ACTION_DESIRE_NONE ) then
    npcBot:Action_UseAbilityOnEntity( abilityF, castFTarget );
    return;
  end

end

----------------------------------------------------------------------------------------------------

function CanCastFluxOnTarget( npcTarget )
  return npcTarget:CanBeSeen() and not npcTarget:IsMagicImmune() and not npcTarget:IsInvulnerable();
end

function CanCastSparksWraithOnTarget( npcTarget )
  return npcTarget:CanBeSeen() and not npcTarget:IsMagicImmune() and not npcTarget:IsInvulnerable();
end

----------------------------------------------------------------------------------------------------

function ConsiderFlux()
  if ( not abilityF:IsFullyCastable() ) then
    return BOT_ACTION_DESIRE_NONE, 0;
  end;

  -- Get some of its values
  local nCastRange = abilityF:GetCastRange();
  local nSearchRadius = abilityF:GetSpecialValueInt( "search_radius" );

  local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes( nCastRange, true, BOT_MODE_NONE );
  for _,npcEnemy in pairs( tableNearbyEnemyHeroes ) do
    if ( CanCastFluxOnTarget (npcEnemy) ) then
      return BOT_ACTION_DESIRE_MODERATE, npcEnemy;
    end
  end

  return BOT_ACTION_DESIRE_NONE, 0;
end

function ConsiderMagneticField()
  if ( not abilityMF:IsFullyCastable() ) then
    return BOT_ACTION_DESIRE_NONE, 0;
  end;

  -- Get some of its values
  local nCastRange = abilityMF:GetCastRange();
  local nRadius = abilityF:GetSpecialValueInt( "radius" );

  -- protect ally that is attacked
  local tableNearbyAllyHeroes = npcBot:GetNearbyHeroes( nCastRange, false, BOT_MODE_NONE );
  for _,npcAlly in pairs( tableNearbyAllyHeroes ) do
    if ( npcAlly:WasRecentlyDamagedByAnyHero(3.0) ) then
      return BOT_ACTION_DESIRE_MODERATE, npcAlly:GetLocation();
    end
  end

  -- create magnetic field where many ally heroes present
  local locationAoE = npcBot:FindAoELocation( false, true, npcBot:GetLocation(), nCastRange, nRadius, 0, 0 );

  if ( locationAoE.count >= 3 )
  then
    return BOT_ACTION_DESIRE_MODERATE, locationAoE.targetloc;
  end

  -- create magnetic field near ally tower
  local tableNearbyAllyTowers = npcBot:GetNearbyTowers( nCastRange, false );
  for _,npcAlly in pairs( tableNearbyAllyTowers ) do
    if ( CanCastFluxOnTarget (npcAlly) and npcAlly:WasRecentlyDamagedByAnyHero(1.0) ) then
      return BOT_ACTION_DESIRE_MODERATE, npcAlly:GetLocation();
    end
  end

  return BOT_ACTION_DESIRE_NONE, 0;
end

function ConsiderSparkWraith()
  if ( not abilitySW:IsFullyCastable() ) then
    return BOT_ACTION_DESIRE_NONE, 0;
  end;

  -- Get some of its values
  local nCastRange = abilitySW:GetCastRange();
  local nRadius = abilitySW:GetSpecialValueInt( "radius" );

  local locationAoE = npcBot:FindAoELocation( true, true, npcBot:GetLocation(), nCastRange, nRadius, 0, 0 );

  if ( locationAoE.count == 1 )
  then
    return BOT_ACTION_DESIRE_MODERATE, locationAoE.targetloc;
  end

  return BOT_ACTION_DESIRE_NONE, 0;
end

function ConsiderTempestDouble()
  if ( not abilityTD:IsFullyCastable() ) then
    return BOT_ACTION_DESIRE_NONE, 0;
  end;

  local npcTarget = npcBot:GetTarget();

  if ( npcTarget ~= nil and npcTarget:IsHero() ) then
    return BOT_ACTION_DESIRE_MODERATE;
  end

  return BOT_ACTION_DESIRE_NONE, 0;
end
