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
				"item_ultimate_scepter",
				"item_ultimate_orb",
				"item_manta",
				"item_satanic",
				"item_black_king_bar"
			};

pcall(require, "bots/item_purchase_utility" )

----------------------------------------------------------------------------------------------------

function ItemPurchaseThink()
        ItemPurchaseGenericThink(tableItemsToBuy);
end

----------------------------------------------------------------------------------------------------
