local tableItemsToBuy = {
  "item_tango",
  "item_tango",
  "item_branches",
  "item_branches",
  "item_circlet",
  "item_magic_stick",

  "item_quelling_blade",
  "item_boots",
  "sell;item_tango",
  "item_gloves",
  "item_belt_of_strength",

  "item_ring_of_health",
  "item_void_stone",
  "item_broadsword",
  "item_claymore",

  "item_blink",

  "item_point_booster",
  "item_staff_of_wizardry",
  "item_ogre_axe",
  "item_blade_of_alacrity",

  "sell;item_magic_wand",
  "item_stout_shield",
  "item_ring_of_health",
  "item_vitality_booster",
  "item_javelin",
  "item_belt_of_strength",
  "item_recipe_basher",
  "item_recipe_abyssal_blade"
};

pcall(require, "bots/utility/item_purchase" )

----------------------------------------------------------------------------------------------------

function ItemPurchaseThink()
  ItemPurchaseGenericThink(tableItemsToBuy);
end

----------------------------------------------------------------------------------------------------
