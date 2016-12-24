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

  local ability = npcBot:GetAbilityByName( sNextAbility );
  local aLevel = ability:GetLevel();
  if ( ability:CanAbilityBeUpgraded() ) then
    npcBot:Action_LevelAbility( sNextAbility );
    local aLevelResult = ability:GetLevel();

    if ( aLevelResult > aLevel and tableAbilitiesToLearn ~= nil ) then
      print( npcBot:GetUnitName() .. " has learned " .. sNextAbility );
      table.remove( tableAbilitiesToLearn, 1 );
    end
  end

  return;
end
