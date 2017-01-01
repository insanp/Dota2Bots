local radiantLocation = Vector(-7000, -7000);
local direLocation = Vector(7000, 7000);

function Think()
  local npcBot = GetBot();
  print("bot boar");
  if ( GetTeam() == TEAM_RADIANT ) then
    npcBot:Action_AttackMove( radiantLocation );
  else
    npcBot:Action_AttackMove( direLocation );
  end
end
