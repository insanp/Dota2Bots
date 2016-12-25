local tableAbilitiesToLearn = {
  "antimage_mana_break",
  "antimage_blink",
  "antimage_spell_shield",
  "antimage_mana_break",
  "antimage_mana_break",

  "antimage_mana_void", -- lvl 6
  "antimage_mana_break",
  "antimage_blink",
  "antimage_blink",
  "special_bonus_strength_6",

  "antimage_blink",
  "antimage_mana_void", -- lvl 12
  "antimage_spell_shield",
  "antimage_spell_shield",
  "special_bonus_hp_250",

  "antimage_spell_shield",
  "antimage_mana_void", -- lvl 18

  "special_bonus_evasion_15",

  "special_bonus_unique_antimage"
}

pcall(require, "bots/utility/ability_usage" )

----------------------------------------------------------------------------------------------------

local castBDesire = 0;
local castMVDesire = 0;
local abilityB = nil;
local abilityMB = nil;
local retreatBlinkRadiant = Vector(-7000, -7000);
local retreatBlinkDire = Vector(7000, 7000);
local dModifier = 0.0;

local npcBot = GetBot();

function AbilityUsageThink()
  abilityB = npcBot:GetAbilityByName( "antimage_blink" );
  abilityMV = npcBot:GetAbilityByName( "antimage_mana_void" );

  abilityLevelUp( npcBot, tableAbilitiesToLearn );

  -- Check if we're already using an ability
  if ( npcBot:IsUsingAbility() ) then return end;

  -- Consider using each ability
  castBDesire, castBLocation = ConsiderBlink();
  castMVDesire, castMVTarget = ConsiderManaVoid();

  if ( castMVDesire > BOT_ACTION_DESIRE_NONE ) then
    npcBot:Action_UseAbilityOnEntity( abilityMV, castMVTarget );
    return;
  end

  if ( castBDesire > BOT_ACTION_DESIRE_NONE ) then
    npcBot:Action_UseAbilityOnLocation( abilityB, castBLocation );
    return;
  end

end

----------------------------------------------------------------------------------------------------

function CanCastManaVoidOnTarget( npcTarget )
  return npcTarget:CanBeSeen() and not npcTarget:IsMagicImmune() and not npcTarget:IsInvulnerable();
end

----------------------------------------------------------------------------------------------------

function ConsiderBlink()
  if ( not abilityB:IsFullyCastable() ) then
    return BOT_ACTION_DESIRE_NONE, 0;
  end;

  -- Get some of its values
  local nBlinkRange = abilityB:GetSpecialValueInt( "blink_range" );

  -- retreating?
  if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT ) then
    if ( npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_MODERATE or npcBot:WasRecentlyDamagedByAnyHero(1.0) ) then
      -- find furthest retreat point
      local loc;
      if ( GetTeam() == TEAM_RADIANT ) then
        loc = retreatBlinkRadiant;
      else
        loc = retreatBlinkDire;
      end
      print(loc);
      return BOT_ACTION_DESIRE_HIGH, loc;
    end
  end

  -- attacking?
  local npcTarget = npcBot:GetTarget();

  if ( npcTarget ~= nil and npcBot:GetActiveMode() == BOT_MODE_ATTACK ) then
    return BOT_ACTION_DESIRE_MODERATE + dModifier, npcTarget:GetLocation();
  end

  return BOT_ACTION_DESIRE_NONE, 0;
end

function ConsiderManaVoid()
  if ( not abilityMV:IsFullyCastable() ) then
    return BOT_ACTION_DESIRE_NONE, 0;
  end;

  -- Get some of its values
  local nCastRange = abilityMV:GetCastRange();
  local nVoidDamageRatio = abilityMV:GetSpecialValueFloat( "mana_void_damage_per_mana" );

  local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes( nCastRange, true, BOT_MODE_NONE );
  for _,npcEnemy in pairs( tableNearbyEnemyHeroes ) do
    if ( CanCastManaVoidOnTarget( npcEnemy ) ) then
      -- find a weak enemy in respect to mana void
      local enemyMaxHealth = npcEnemy:GetMaxHealth();
      local enemyHealth = npcEnemy:GetHealth();
      local enemyMaxMana = npcEnemy:GetMaxMana();
      local enemyMana = npcEnemy:GetMana();
      local estimatedDamage = ( enemyMaxMana - enemyMana ) * nVoidDamageRatio;
      print("Estimated mana void on " .. npcEnemy:GetUnitName() .. " is " .. estimatedDamage);
      if ( estimatedDamage * 0.75 >= enemyHealth ) then
        -- aim for a kill
        return BOT_ACTION_DESIRE_HIGH, npcEnemy;
      end

      -- if burst damage is good, go for it
      if ( estimatedDamage > 1000 ) then
        return BOT_ACTION_DESIRE_MODERATE, npcEnemy;
      end

      -- if a bot is channeling and burst damage is good too, go for it
      if ( estimatedDamage > 500 and npcEnemy:IsChanneling() ) then
        return BOT_ACTION_DESIRE_MODERATE, npcEnemy;
      end
    end
  end

  return BOT_ACTION_DESIRE_NONE, 0;
end
