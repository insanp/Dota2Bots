local tableItemsToBuy = {
				"item_tango",
				"item_clarity",
				"item_branches",
				"item_branches",
				"item_circlet",
				"item_magic_stick",
				"item_boots",
				"item_gloves",
				"item_belt_of_strength",
				"item_blink",
				"item_quarterstaff",
				"item_sobi_mask",
				"item_robe",
				"item_ogre_axe",
				"item_mithril_hammer",
				"item_mithril_hammer",
				"item_desolator",
				"item_point_booster",
				"item_ogre_axe",
				"item_staff_of_wizardry",
				"item_blade_of_alacrity"
			};

pcall(require, "bots/utility/item_purchase" )

----------------------------------------------------------------------------------------------------

function ItemPurchaseThink()
        ItemPurchaseGenericThink(tableItemsToBuy);
end

----------------------------------------------------------------------------------------------------
