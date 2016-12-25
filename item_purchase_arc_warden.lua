local tableItemsToBuy = {
  "item_tango",
  "item_tango",
  "item_branches",
  "item_branches",
  "item_circlet",
  "item_magic_stick",

  "item_boots",
  "item_energy_booster",
  "item_gloves",
  "item_recipe_hand_of_midas",

  "item_staff_of_wizardry",
  "item_belt_of_strength",
  "item_recipe_necronomicon",
  "item_recipe_necronomicon",
  "item_recipe_necronomicon",

  "sell;item_tango",
  "item_ghost",
  "item_eagle",

  "sell;item_magic_wand",
  "item_mithril_hammer",
  "item_gloves",
  "item_recipe_maelstrom",
  "item_hyperstone",
  "item_recipe_mjollnir"

};

pcall(require, "bots/utility/item_purchase" )

----------------------------------------------------------------------------------------------------

function ItemPurchaseThink()
  ItemPurchaseGenericThink(tableItemsToBuy);
end

----------------------------------------------------------------------------------------------------
