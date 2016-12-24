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

function AbilityUsageThink()
  local npcBot = GetBot();
  local loc = npcBot:GetLocation();

  abilityLevelUp( npcBot, tableAbilitiesToLearn );
end

function abilityLevelUp( npcBot, tableAbilitiesToLearn )
  if ( tableAbilitiesToLearn == 0 )
  then
    return;
  end

  local sNextAbility = tableAbilitiesToLearn[1];

  if (sNextAbility == nil) then
    return;
  end

  -- skip talent abilites, still not working
  if ( string.find( sNextAbility, "special") and tableAbilitiesToLearn ~= nil ) then
    table.remove( tableAbilitiesToLearn, 1 );
    return;
  end

  ability = npcBot:GetAbilityByName( sNextAbility );
  local aLevel = ability:GetLevel();
  if ( ability:CanAbilityBeUpgraded() ) then
    npcBot:Action_LevelAbility( sNextAbility );
    local aLevelResult = ability:GetLevel();

    if ( aLevelResult > aLevel and tableAbilitiesToLearn ~= nil ) then
      print("learned " .. sNextAbility );
      table.remove( tableAbilitiesToLearn, 1 );
    end
  end

  return;
end
