local tableItemsToBuy = {
				"item_tango",
				"item_clarity",
				"item_clarity",
				"item_branches",
				"item_branches",
				"item_circlet",
				"item_magic_stick",
				"item_boots",
				"item_energy_booster",
				"item_void_stone",
				"item_staff_of_wizardry",
				"item_ring_of_regen",
				"item_recipe_force_staff",
				"item_ultimate_orb",
				"item_mystic_staff",
				"item_point_booster",
				"item_staff_of_wizardry",
				"item_ogre_axe",
				"item_blade_of_alacrity",
				"item_void_stone",
				"item_staff_of_wizardry",
				"item_wind_lace",
				"item_recipe_cyclone",
			};

pcall(require, "bots/utility/item_purchase" )

----------------------------------------------------------------------------------------------------

function ItemPurchaseThink()
        ItemPurchaseGenericThink(tableItemsToBuy);
end

----------------------------------------------------------------------------------------------------
