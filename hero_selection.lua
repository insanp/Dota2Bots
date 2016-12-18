

----------------------------------------------------------------------------------------------------

function Think()


	if ( GetTeam() == TEAM_RADIANT )
	then
		print( "selecting radiant" );
		--SelectHero( 0, "npc_dota_hero_bounty_hunter" );
		SelectHero( 1, "npc_dota_hero_axe" );
		SelectHero( 2, "npc_dota_hero_luna" );
		SelectHero( 3, "npc_dota_hero_lina" );
		SelectHero( 4, "npc_dota_hero_skeleton_king" );
	elseif ( GetTeam() == TEAM_DIRE )
	then
		print( "selecting dire" );
		SelectHero( 5, "npc_dota_hero_dragon_knight" );
		SelectHero( 6, "npc_dota_hero_lion" );
		SelectHero( 7, "npc_dota_hero_viper" );
		SelectHero( 8, "npc_dota_hero_omniknight" );
		SelectHero( 9, "npc_dota_hero_nevermore" );
	end

end

----------------------------------------------------------------------------------------------------
