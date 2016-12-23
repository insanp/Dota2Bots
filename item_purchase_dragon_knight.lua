local tableItemsToBuy = {
  "item_tango",
  "item_branches",
  "item_branches",
  "item_stout_shield",
  "item_circlet",
  "item_magic_stick",
  "item_boots",
  "item_gloves",
  "item_belt_of_strength",
  "item_ring_of_health",
  "item_vitality_booster",
  "sell;item_tango",
  "sell;item_clarity",
  "item_mithril_hammer",
  "item_gloves",
  "item_recipe_maelstrom",
  "item_hyperstone",
  "item_recipe_mjollnir",
  "item_blink",
  "sell;item_magic_wand",
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
