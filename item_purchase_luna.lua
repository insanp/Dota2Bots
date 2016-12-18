local tableItemsToBuy = {
				"item_tango",
				"item_branches",
				"item_branches",
				"item_ring_of_protection",
				"item_circlet",
				"item_magic_stick",
				"item_sobi_mask",
				"item_lifesteal",
				"item_boots",
				"item_gloves",
				"item_belt_of_strength",
				"item_point_booster",
				"item_staff_of_wizardry",
				"item_ogre_axe",
				"item_blade_of_alacrity",
				"item_blade_of_alacrity",
				"item_boots_of_elves",
				"item_reaver",
				"item_mithril_hammer",
				"item_ultimate_orb",
				"item_recipe_manta",
			};

pcall(require, "bots/utility/item_purchase" )

----------------------------------------------------------------------------------------------------

function ItemPurchaseThink()
        ItemPurchaseGenericThink(tableItemsToBuy);
end

----------------------------------------------------------------------------------------------------
