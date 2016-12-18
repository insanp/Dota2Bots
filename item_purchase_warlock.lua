local tableItemsToBuy = {
				"item_ring_of_protection",
				"item_tango",
				"item_clarity",
				"item_branches",
				"item_branches",
				"item_circlet",
				"item_magic_stick",
				"item_boots",
				"item_energy_booster",
				"item_arcane_boots",
				"item_point_booster",
				"item_staff_of_wizardry",
				"item_ogre_axe",
				"item_blade_of_alacrity",
				"item_platemail",
				"item_mystic_staff",
				"item_shivas_guard",
				"item_guardian_greaves",
				"item_refresher"
			};

pcall(require, "bots/item_purchase_utility" )

----------------------------------------------------------------------------------------------------

function ItemPurchaseThink()
        ItemPurchaseGenericThink(tableItemsToBuy);
end

----------------------------------------------------------------------------------------------------
