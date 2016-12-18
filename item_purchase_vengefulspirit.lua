local tableItemsToBuy = {
				"item_tango",
				"item_clarity",
				"item_branches",
				"item_branches",
				"item_magic_stick",
				"item_circlet",
				"item_boots",
				"item_energy_booster",
				"item_staff_of_wizardry",
				"item_ring_of_regen",
				"item_recipe_force_staff",
				"item_mithril_hammer",
				"item_mithril_hammer",
				"item_desolator",
				"item_point_booster",
				"item_ultimate_scepter"
			};

print(pcall(require, "bots/item_purchase_utility" ))

----------------------------------------------------------------------------------------------------

function ItemPurchaseThink()
        ItemPurchaseGenericThink(tableItemsToBuy);
end

----------------------------------------------------------------------------------------------------
