local tableItemsToBuy = {
  "item_tango",
  "item_tango",
  "item_branches",
  "item_branches",
  "item_circlet",
  "item_magic_stick",

  "item_boots",
  "item_gloves",
  "item_recipe_hand_of_midas",
  "item_energy_booster",

  "item_staff_of_wizardry",
  "item_ring_of_regen",
  "sell;item_tango",
  "item_recipe_force_staff",

  "item_staff_of_wizardry",
  "item_circlet",
  "item_mantle",
  "item_recipe_null_talisman",
  "item_recipe_dagon",
  "item_recipe_dagon",
  "item_recipe_dagon",
  "item_recipe_dagon",
  "item_recipe_dagon",

  "sell;item_magic_wand",
  "item_staff_of_wizardry",
  "item_belt_of_strength",
  "item_recipe_necronomicon",
  "item_recipe_necronomicon",
  "item_recipe_necronomicon",

  "item_ghost",
  "sell:item_tpscroll",
  "item_eagle"
};

pcall(require, "bots/utility/item_purchase" )

----------------------------------------------------------------------------------------------------

function ItemPurchaseThink()
  ItemPurchaseGenericThink(tableItemsToBuy);
end

----------------------------------------------------------------------------------------------------
