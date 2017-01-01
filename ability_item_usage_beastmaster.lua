local tableAbilitiesToLearn = {
  "beastmaster_wild_axes",
  "beastmaster_call_of_the_wild",
  "beastmaster_wild_axes",
  "beastmaster_call_of_the_wild",
  "beastmaster_wild_axes",

  "beastmaster_primal_roar", -- lvl 6
  "beastmaster_wild_axes",
  "beastmaster_call_of_the_wild",
  "beastmaster_call_of_the_wild",
  "special_bonus_movement_speed_20",

  "beastmaster_inner_beast",
  "beastmaster_primal_roar", -- lvl 12
  "beastmaster_inner_beast",
  "beastmaster_inner_beast",
  "special_bonus_strength_12",

  "beastmaster_inner_beast",
  "beastmaster_primal_roar", -- lvl 18

  "special_bonus_cooldown_reduction_12",

  "special_bonus_unique_beastmaster"
}

pcall(require, "bots/utility/ability_usage" )

----------------------------------------------------------------------------------------------------

local castWADesire = 0;
local castCOTWDesire = 0;
local castCOTWBDesire = 0;
local castPRDesire = 0;
local abilityWA = nil;
local abilityCOTW = nil;
local abilityCOTWB = nil;
local abilityPR = nil;
local dModifier = 0.0;

local vRadiant = Vector(-7000, -7000);
local vDire = Vector(7000, 7000);

local npcBot = GetBot();

function AbilityUsageThink()
  abilityWA = npcBot:GetAbilityByName( "beastmaster_wild_axes" );
  abilityCOTW = npcBot:GetAbilityByName( "beastmaster_call_of_the_wild" );
  abilityCOTWB = npcBot:GetAbilityByName( "beastmaster_call_of_the_wild_boar" );
  abilityPR = npcBot:GetAbilityByName( "beastmaster_primal_roar" );

  abilityLevelUp( npcBot, tableAbilitiesToLearn );

  -- Check if we're already using an ability
  if ( npcBot:IsUsingAbility() ) then return end;

  -- Consider using each ability
  castWADesire, castWALocation = ConsiderWildAxes();
  castCOTWDesire = ConsiderCallOfTheWild();
  castCOTWBDesire = ConsiderCallOfTheWildBoar();
  castPRDesire, castPRTarget = ConsiderPrimalRoar();

  if ( castPRDesire > BOT_ACTION_DESIRE_NONE ) then
    npcBot:Action_UseAbilityOnEntity( abilityPR, castPRTarget );
    return;
  end

  if ( castWADesire > BOT_ACTION_DESIRE_NONE ) then
    npcBot:Action_UseAbilityOnLocation( abilityWA, castWALocation );
    return;
  end

  if ( castCOTWDesire > BOT_ACTION_DESIRE_NONE ) then
    npcBot:Action_UseAbility( abilityCOTW );
    return;
  end

  if ( castCOTWBDesire > BOT_ACTION_DESIRE_NONE ) then
    npcBot:Action_UseAbility( abilityCOTWB );
    return;
  end

end

----------------------------------------------------------------------------------------------------

function CanCastWildAxesOnTarget( npcTarget )
  return npcTarget:CanBeSeen();
end

function CanCastPrimalRoarOnTarget( npcTarget )
  return npcTarget:CanBeSeen();
end

----------------------------------------------------------------------------------------------------

function ConsiderWildAxes()
  if ( not abilityWA:IsFullyCastable() ) then
    return BOT_ACTION_DESIRE_NONE, 0;
  end;

  -- always save mana for at least a primal roar
  if ( npcBot:GetMana() < abilityPR:GetManaCost() ) then
    return BOT_ACTION_DESIRE_NONE, 0;
  end;

  -- Get some of its values
  local nCastRange = abilityWA:GetCastRange();

  local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes( nCastRange, true, BOT_MODE_NONE );
  for _,npcEnemy in pairs( tableNearbyEnemyHeroes ) do
    if ( CanCastWildAxesOnTarget( npcEnemy ) ) then
      -- first find distance and use wild axes at the furthest range
      local distance = GetUnitToUnitDistance( npcBot, npcEnemy );
      local multiplier = nCastRange / distance;
      local distanceVector = npcEnemy:GetLocation() - npcBot:GetLocation();
      return BOT_ACTION_DESIRE_MODERATE, npcBot:GetLocation() + ( multiplier * distanceVector)
    end
  end

  return BOT_ACTION_DESIRE_NONE, 0;
end

function ConsiderCallOfTheWild()
  if ( not abilityCOTW:IsFullyCastable() ) then
    return BOT_ACTION_DESIRE_NONE;
  end;

  if ( npcBot:GetActiveMode() == BOT_MODE_RUNE ) then
    return BOT_ACTION_DESIRE_LOW;
  end

  return BOT_ACTION_DESIRE_NONE;
end

function ConsiderCallOfTheWildBoar()
  -- BoarThink();
  if ( not abilityCOTWB:IsFullyCastable() ) then
    return BOT_ACTION_DESIRE_NONE;
  end;

  -- always use!
  -- return BOT_ACTION_DESIRE_MODERATE;

  -- deactivate
  return BOT_ACTION_DESIRE_NONE;
end

function ConsiderPrimalRoar()
  if ( not abilityPR:IsFullyCastable() ) then
    return BOT_ACTION_DESIRE_NONE, 0;
  end;

  -- Get some of its values
  local nCastRange = abilityPR:GetCastRange();
  if ( npcBot:HasScepter() ) then
    nCastRange = abilityPR:GetSpecialValueInt( "cast_range_scepter" );
  end

  local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes( nCastRange, true, BOT_MODE_NONE );
  for _,npcEnemy in pairs( tableNearbyEnemyHeroes ) do
    if ( CanCastPrimalRoarOnTarget( npcEnemy ) ) then
      if ( npcEnemy:IsChanneling() ) then
        return BOT_ACTION_DESIRE_HIGH, npcEnemy;
      end

      if ( npcBot:WasRecentlyDamagedByHero( npcEnemy, 1.0 )
        and npcBot:GetHealth() <= 0.8 * npcBot:GetMaxHealth() ) then
          return BOT_ACTION_DESIRE_MODERATE, npcEnemy;
      end

      if ( npcEnemy:GetHealth() <= 0.5 * npcEnemy:GetMaxHealth() ) then
        return BOT_ACTION_DESIRE_MODERATE, npcEnemy;
      end

      -- retreat!
      if ( npcBot:GetHealth() <= 0.25 * npcBot:GetMaxHealth() ) then
        return BOT_ACTION_DESIRE_HIGH, npcEnemy;
      end
    end
  end

  return BOT_ACTION_DESIRE_NONE, 0;
end

function BoarThink()
  local npcTarget = npcBot:GetTarget();
  local tableNearbyAllyCreeps = npcBot:GetNearbyCreeps( 600, false );
  for _,npcAlly in pairs( tableNearbyAllyCreeps ) do
    local unitName = npcAlly:GetUnitName();
    if (string.find( unitName, "beastmaster_boar")) then
      -- does bot has target? then attack the same

      if ( npcTarget ~= nil and npcTarget:IsHero() ) then
        --print(npcAlly:GetUnitName() .. ' attacks ' .. npcTarget:GetUnitName() );
        npcAlly:GetBot():Action_AttackUnit( npcTarget, false );
      else
        if (GetTeam() == TEAM_RADIANT) then
          --print( npcAlly:GetUnitName() .. ' attacks radiant' );
          npcAlly:GetBot():Action_AttackMove(vRadiant);
        else
          --print( npcAlly:GetUnitName() .. ' attacks dire' );
          npcAlly:GetBot():Action_AttackMove(vDire);
        end
      end
    end
  end
end
