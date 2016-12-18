local tableItemsToBuy = {
				"item_tango",
				"item_branches",
				"item_branches",
				"item_stout_shield",
				"item_circlet",
				"item_magic_stick",
				"item_boots",
				"item_ring_of_protection",
				"item_ring_of_regen",
				"item_ring_of_health",
				"item_vitality_booster",
				"item_blink",
				"item_chainmail",
				"item_broadsword",
				"item_robe",
				"item_reaver",
				"item_vitality_booster",
				"item_recipe_heart"
			};

pcall(require, "bots/utility/item_purchase" )

----------------------------------------------------------------------------------------------------

function ItemPurchaseThink()
        ItemPurchaseGenericThink(tableItemsToBuy);
end

----------------------------------------------------------------------------------------------------
