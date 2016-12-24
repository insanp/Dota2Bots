local tableAbilitiesToLearn = {
  "abaddon_aphotic_shield",
  "abaddon_death_coil",
  "abaddon_frostmourne",
  "abaddon_death_coil",
  "abaddon_death_coil",

  "abaddon_borrowed_time", -- lvl 6
  "abaddon_death_coil",
  "abaddon_aphotic_shield",
  "abaddon_aphotic_shield",
  "special_bonus_attack_damage_25",

  "abaddon_aphotic_shield",
  "abaddon_borrowed_time", -- lvl 12
  "abaddon_frostmourne",
  "abaddon_frostmourne",
  "special_bonus_armor_5",

  "abaddon_frostmourne",
  "abaddon_borrowed_time", -- lvl 18

  "special_bonus_cooldown_reduction_15",

  "special_bonus_unique_abaddon"
}

pcall(require, "bots/utility/ability_usage" )

----------------------------------------------------------------------------------------------------

local castDCDesire = 0;
local castASDesire = 0;
local castBTDesire = 0;
local abilityDC = nil;
local abilityAS = nil;
local abilityBT = nil;
local nBTThreshold = nil;
local dModifier = 0.0;

local npcBot = GetBot();

function AbilityUsageThink()
  abilityDC = npcBot:GetAbilityByName( "abaddon_death_coil" );
  abilityAS = npcBot:GetAbilityByName( "abaddon_aphotic_shield" );
  abilityBT = npcBot:GetAbilityByName( "abaddon_borrowed_time" );
  nBTThreshold = abilityBT:GetSpecialValueInt( "hp_threshold" );
  if ( nBTThreshold == 0) then
    nBTThreshold = 0.5*npcBot:GetMaxHealth();
  end;

  abilityLevelUp( npcBot, tableAbilitiesToLearn );

  -- Check if we're already using an ability
  if ( npcBot:IsUsingAbility() ) then return end;

  -- Consider using each ability
  castDCDesire, castDCTarget = ConsiderDeathCoil();
  castASDesire, castASTarget = ConsiderAphoticShield();
  castBTDesire = ConsiderBorrowedTime();

  if ( castBTDesire > BOT_ACTION_DESIRE_NONE ) then
    npcBot:Action_UseAbility( abilityBT );
    return;
  end

  if ( castDCDesire > BOT_ACTION_DESIRE_NONE ) then
    npcBot:Action_UseAbilityOnEntity( abilityDC, castDCTarget );
    return;
  end

  if ( castASDesire > BOT_ACTION_DESIRE_NONE ) then
    npcBot:Action_UseAbilityOnEntity( abilityAS, castASTarget );
    return;
  end

end

----------------------------------------------------------------------------------------------------

function CanCastDeathCoilOnTarget( npcTarget )
  return npcTarget:CanBeSeen() and not npcTarget:IsMagicImmune() and not npcTarget:IsInvulnerable();
end


function CanCastAphoticShieldOnTarget( npcTarget )
  return npcTarget:CanBeSeen();
end

----------------------------------------------------------------------------------------------------

function ConsiderDeathCoil()
  if ( not abilityDC:IsFullyCastable() ) then
    return BOT_ACTION_DESIRE_NONE, 0;
  end;

  -- Get some of its values
  local nCastRange = abilityDC:GetCastRange();
  local nSelfDamage = abilityDC:GetSpecialValueInt( "self_damage" );
  local nTargetDamage = abilityDC:GetSpecialValueInt( "target_damage" );
  local nHealAmount = abilityDC:GetSpecialValueInt( "heal_amount" );

  local botMaxHealth = npcBot:GetMaxHealth();
  local botCurrentHealth = npcBot:GetHealth();

  if ( abilityBT:IsCooldownReady() and abilityBT:GetLevel() > 0 ) then
    dModifier = 0.25;
  end

  if ( ( botCurrentHealth - nSelfDamage ) > nBTThreshold or abilityBT:IsCooldownReady() and abilityBT:GetLevel() > 0 ) then
  -- decide to damage current enemy target?
    local npcTarget = npcBot:GetTarget();

    if ( npcTarget ~= nil ) then
      if ( CanCastDeathCoilOnTarget( npcTarget )
        and GetUnitToUnitDistance( npcBot, npcTarget ) > 200 ) then

        return BOT_ACTION_DESIRE_MODERATE + dModifier, npcTarget;
      end
    end

    -- decide to heal nearby ally?
    local tableNearbyAllyHeroes = npcBot:GetNearbyHeroes( nCastRange, false, BOT_MODE_NONE );
    for _,npcAlly in pairs( tableNearbyAllyHeroes ) do
      if ( npcAlly:GetUnitName() ~= 'npc_dota_hero_abaddon' ) then
        local allyMaxHealth = npcAlly:GetMaxHealth();
        local allyCurrentHealth = npcAlly:GetHealth();

        if ( allyCurrentHealth < 0.5*allyMaxHealth ) then
          if ( CanCastDeathCoilOnTarget( npcAlly ) ) then
            return BOT_ACTION_DESIRE_HIGH + dModifier, npcAlly;
          end
        end
      end
    end
  end

  return BOT_ACTION_DESIRE_NONE, 0;
end

function ConsiderAphoticShield()
  if ( not abilityAS:IsFullyCastable() ) then
    return BOT_ACTION_DESIRE_NONE, 0;
  end;

  if ( abilityBT:IsActivated() ) then
    dModifier = 0.25;
  end

  local nCastRange = abilityAS:GetCastRange();

  local tableNearbyAllyHeroes = npcBot:GetNearbyHeroes( nCastRange, false, BOT_MODE_NONE );
  for _,npcAlly in pairs( tableNearbyAllyHeroes ) do
    if ( CanCastAphoticShieldOnTarget( npcAlly ) ) then
      -- cover recently damaged ally
      if ( npcAlly:WasRecentlyDamagedByAnyHero(1.0) ) then
        return BOT_ACTION_DESIRE_MODERATE + dModifier, npcAlly;
      elseif ( npcAlly:IsBlind() or npcAlly:IsChanneling()
        or npcAlly:IsDisarmed() or npcAlly:IsHexed()
        or npcAlly:IsRooted() or npcAlly:IsMuted()
        or npcAlly:IsSilenced() or npcAlly:IsStunned()) then
          return BOT_ACTION_DESIRE_HIGH + dModifier, npcAlly;
      end
    end
  end

  return BOT_ACTION_DESIRE_NONE, 0;
end

function ConsiderBorrowedTime( npcBot )
  if ( not abilityBT:IsFullyCastable() ) then
    return BOT_ACTION_DESIRE_NONE;
  end;

  return BOT_ACTION_DESIRE_NONE, 0;
end
