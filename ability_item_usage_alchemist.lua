local tableAbilitiesToLearn = {
  "alchemist_acid_spray",
  "alchemist_unstable_concoction",
  "alchemist_acid_spray",
  "alchemist_unstable_concoction",
  "alchemist_acid_spray",

  "alchemist_chemical_rage", -- lvl 6
  "alchemist_acid_spray",
  "alchemist_unstable_concoction",
  "alchemist_unstable_concoction",
  "special_bonus_attack_damage_20",

  "alchemist_goblins_greed",
  "alchemist_chemical_rage", -- lvl 12
  "alchemist_goblins_greed",
  "alchemist_goblins_greed",
  "special_bonus_all_stats_6",

  "alchemist_goblins_greed",
  "alchemist_chemical_rage", -- lvl 18

  "special_bonus_attack_speed_30",

  "special_bonus_lifesteal_30"
}

pcall(require, "bots/utility/ability_usage" )

----------------------------------------------------------------------------------------------------

local castASDesire = 0;
local castUCDesire = 0;
local castUCTDesire = 0;
local castCRDesire = 0;
local abilityAS = nil;
local abilityUC = nil;
local abilityUCT = nil;
local abilityCR = nil;
local unstableConcoctionActive = false;
local unstableConcoctionStartTime = 0;
local dModifier = 0.0;

local npcBot = GetBot();

function AbilityUsageThink()
  abilityAS = npcBot:GetAbilityByName( "alchemist_acid_spray" );
  abilityUC = npcBot:GetAbilityByName( "alchemist_unstable_concoction" );
  abilityUCT = npcBot:GetAbilityByName( "alchemist_unstable_concoction_throw" );
  abilityCR = npcBot:GetAbilityByName( "alchemist_chemical_rage" );

  abilityLevelUp( npcBot, tableAbilitiesToLearn ); -- it seems in built skill tree bypass this...

  -- Check if we're already using an ability
  if ( npcBot:IsUsingAbility() ) then return end;

  -- Consider using each ability
  castASDesire, castASLocation = ConsiderAcidSpray();
  castUCDesire = ConsiderUnstableConcoction();
  castUCTDesire, castUCTTarget = ConsiderUnstableConcoctionThrow();
  castCRDesire = ConsiderChemicalRage();

  if ( castCRDesire > BOT_ACTION_DESIRE_NONE ) then
    npcBot:Action_UseAbility( abilityCR );
    return;
  end

  if ( unstableConcoctionActive ) then
    if ( castUCTDesire > BOT_ACTION_DESIRE_NONE ) then
      unstableConcoctionActive = false;
      npcBot:Action_UseAbilityOnEntity( abilityUCT, castUCTTarget );
    end
  end

  if ( castUCDesire > BOT_ACTION_DESIRE_NONE ) then
    unstableConcoctionActive = true;
    unstableConcoctionStartTime = DotaTime();
    npcBot:Action_UseAbility( abilityUC );
    return;
  end

  if ( castASDesire > BOT_ACTION_DESIRE_NONE ) then
    npcBot:Action_UseAbilityOnLocation( abilityAS, castASLocation );
    return;
  end

end

----------------------------------------------------------------------------------------------------

function CanCastAcidSprayOnTarget( npcTarget )
  return npcTarget:CanBeSeen() and not npcTarget:IsMagicImmune() and not npcTarget:IsInvulnerable();
end

function CanCastUnstableConcoctionThrowOnTarget( npcTarget )
  return npcTarget:CanBeSeen() and not npcTarget:IsMagicImmune() and not npcTarget:IsInvulnerable();
end

----------------------------------------------------------------------------------------------------

function ConsiderAcidSpray()
  if ( not abilityAS:IsFullyCastable() ) then
    return BOT_ACTION_DESIRE_NONE, 0;
  end;

  -- Get some of its values
  local nCastRange = abilityAS:GetCastRange();
  local nRadius = abilityAS:GetSpecialValueInt( "radius" );

  -- or we use on our target?
  local npcTarget = npcBot:GetTarget();
  if ( npcTarget ~= nil and npcTarget:IsHero() ) then
    if ( CanCastAcidSprayOnTarget( npcTarget )
      and GetUnitToUnitDistance( npcBot, npcTarget ) <= nCastRange ) then

      return BOT_ACTION_DESIRE_MODERATE + dModifier, npcTarget:GetLocation();
    end
  end

  -- find a group of enemy heroes
  local locationAoE = npcBot:FindAoELocation( true, true, npcBot:GetLocation(), 0.5*nCastRange, nRadius, 0, 0 );
  if ( locationAoE.count >= 3 )
  then
    return BOT_ACTION_DESIRE_MODERATE, locationAoE.targetloc;
  end

  -- many creeps detected
  locationAoE = npcBot:FindAoELocation( true, false, npcBot:GetLocation(), 0.5*nCastRange, nRadius, 0, 0 );
  if ( locationAoE.count >= 8 )
  then
    return BOT_ACTION_DESIRE_MODERATE, locationAoE.targetloc;
  end

  return BOT_ACTION_DESIRE_NONE, 0;
end

function ConsiderUnstableConcoction()
  if ( not abilityUC:IsFullyCastable() ) then
    return BOT_ACTION_DESIRE_NONE;
  end;

  -- Get some of its values
  local nCastRange = abilityUCT:GetCastRange();

  -- check our target
  local npcTarget = npcBot:GetTarget();
  if ( npcTarget ~= nil and npcTarget:IsHero() ) then
    if ( CanCastUnstableConcoctionThrowOnTarget( npcTarget )
      and GetUnitToUnitDistance( npcBot, npcTarget ) <= 0.5*nCastRange ) then
      return BOT_ACTION_DESIRE_MODERATE + dModifier;
    end
  end

  return BOT_ACTION_DESIRE_NONE;
end

function ConsiderUnstableConcoctionThrow()
  if ( not abilityUCT:IsFullyCastable() ) then
    return BOT_ACTION_DESIRE_NONE, 0;
  end;

  -- Get some of its values
  local nCastRange = abilityUCT:GetCastRange();
  local nBrewTime = abilityUCT:GetSpecialValueInt( "brew_time" );

  -- check nearby heroes
  local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes( nCastRange, true, BOT_MODE_NONE );
  for _,npcEnemy in pairs( tableNearbyEnemyHeroes ) do
    if ( CanCastUnstableConcoctionThrowOnTarget( npcEnemy ) ) then
      -- immediately throw to nearest enemy hero if reaching maximum brew time
      if ( DotaTime() - unstableConcoctionStartTime >= 5.0 ) then
        return BOT_ACTION_DESIRE_HIGH + dModifier, npcEnemy;
      end

      -- immediately hits channeling enemy
      if ( npcEnemy:IsChanneling() ) then
        return BOT_ACTION_DESIRE_HIGH + dModifier, npcEnemy;
      end

      -- there is only one hero left nearing maximum cast range, throw before it hits alchemist
      if ( #tableNearbyEnemyHeroes == 1 and ( nCastRange - GetUnitToUnitDistance( npcBot, npcEnemy )) < 100 ) then
        return BOT_ACTION_DESIRE_HIGH + dModifier, npcEnemy;
      end
    end
  end

  return BOT_ACTION_DESIRE_NONE, 0;
end

function ConsiderChemicalRage()
  if ( not abilityCR:IsFullyCastable() ) then
    return BOT_ACTION_DESIRE_NONE, 0;
  end;

  -- do we need regen?
  if ( npcBot:GetHealth() <= 0.5*npcBot:GetMaxHealth() or
      npcBot:GetMana() <= 0.5*npcBot:GetMaxMana() ) then
    return BOT_ACTION_DESIRE_MODERATE, 0;
  end

  -- enemy heroes attacking detected
  local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes( 600, true, BOT_MODE_ATTACK );
  if ( #tableNearbyEnemyHeroes ~= nil ) then
    return BOT_ACTION_DESIRE_MODERATE, 0;
  end
end
