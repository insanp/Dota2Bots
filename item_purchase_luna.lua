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
  "sell;item_tango",
  "sell;item_clarity",
  "sell;item_ring_of_basilius",
  "item_reaver",
  "item_mithril_hammer",
  "item_blade_of_alacrity",
  "item_boots_of_elves",
  "item_recipe_yasha",
  "item_ultimate_orb",
  "sell;item_magic_wand",
  "item_recipe_manta",
  "item_ogre_axe",
  "item_mithril_hammer",
  "item_recipe_black_king_bar"
};

pcall(require, "bots/utility/item_purchase" )

----------------------------------------------------------------------------------------------------

function ItemPurchaseThink()
  ItemPurchaseGenericThink(tableItemsToBuy);
end

----------------------------------------------------------------------------------------------------
