

----------------------------------------------------------------------------------------------------

function Think()


	if ( GetTeam() == TEAM_RADIANT )
	then
		print( "selecting radiant" );
		SelectHero( 0, "npc_dota_hero_witch_doctor" );
		SelectHero( 1, "npc_dota_hero_axe" );
		SelectHero( 2, "npc_dota_hero_lina" );
		SelectHero( 3, "npc_dota_hero_alchemist" );
		SelectHero( 4, "npc_dota_hero_warlock" );
	elseif ( GetTeam() == TEAM_DIRE )
	then
		print( "selecting dire" );
		SelectHero( 5, "npc_dota_hero_skeleton_king" );
		SelectHero( 6, "npc_dota_hero_antimage" );
		SelectHero( 7, "npc_dota_hero_ancient_apparition" );
		SelectHero( 8, "npc_dota_hero_abaddon" );
		SelectHero( 9, "npc_dota_hero_omniknight" );
	end

end

----------------------------------------------------------------------------------------------------
