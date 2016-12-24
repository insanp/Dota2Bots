local tableAbilitiesToLearn = {
  "abaddon_aphotic_shield",
  "abaddon_death_coil",
  "abaddon_frostmourne",
  "abaddon_death_coil",
  "abaddon_death_coil",

  "abaddon_borrowed_time",
  "abaddon_death_coil",
  "abaddon_aphotic_shield",
  "abaddon_aphotic_shield",
  "special_bonus_attack_damage_25",

  "abaddon_borrowed_time",
  "abaddon_aphotic_shield",
  "abaddon_frostmourne",
  "abaddon_frostmourne",
  "special_bonus_armor_5",

  "abaddon_frostmourne",
  "abaddon_borrowed_time",

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

  ability = npcBot:GetAbilityByName( sNextAbility );
  print( "checking " .. sNextAbility );
  if ( ability:CanAbilityBeUpgraded() ) then
    --npcBot:Action_LevelAbility( sNextAbility );
    abilty:UpgradeAbility();
    if ( tableAbilitiesToLearn ~= nil ) then
      print("learned " .. sNextAbility );
      table.remove( tableAbilitiesToLearn, 1 );
    end
  end

  return;
end
