

----------------------------------------------------------------------------------------------------

function Think()


	if ( GetTeam() == TEAM_RADIANT )
	then
		print( "selecting radiant" );
		SelectHero( 0, "npc_dota_hero_drow_ranger" );
		SelectHero( 1, "npc_dota_hero_axe" );
		SelectHero( 2, "npc_dota_hero_abaddon" );
		SelectHero( 3, "npc_dota_hero_batrider" );
		SelectHero( 4, "npc_dota_hero_brewmaster" );
	elseif ( GetTeam() == TEAM_DIRE )
	then
		print( "selecting dire" );
		SelectHero( 5, "npc_dota_hero_alchemist" );
		SelectHero( 6, "npc_dota_hero_antimage" );
		SelectHero( 7, "npc_dota_hero_ancient_apparition" );
		SelectHero( 8, "npc_dota_hero_beastmaster" );
		SelectHero( 9, "npc_dota_hero_arc_warden" );
	end

end

----------------------------------------------------------------------------------------------------
