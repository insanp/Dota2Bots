local tableItemsToBuy = {
  "item_tango",
  "item_clarity",
  "item_clarity",
  "item_branches",
  "item_branches",
  "item_circlet",
  "item_magic_stick",

  "item_boots",
  "item_energy_booster",

  "item_void_stone",
  "item_staff_of_wizardry",
  "item_ring_of_regen",
  "sell;item_tango",
  "sell;item_clarity",
  "item_recipe_force_staff",

  "item_ultimate_orb",
  "item_mystic_staff",

  "item_point_booster",
  "item_staff_of_wizardry",
  "item_ogre_axe",
  "item_blade_of_alacrity",

  "item_void_stone",
  "item_staff_of_wizardry",
  "item_wind_lace",
  "sell;item_magic_wand",
  "item_recipe_cyclone",
  
  "item_ring_of_regen",
  "item_branches",
  "item_recipe_headdress",
  "item_chainmail",
  "item_branches",
  "item_recipe_buckler",
  "item_recipe_mekansm",
  "item_recipe_guardian_greaves"
};

pcall(require, "bots/utility/item_purchase" )

----------------------------------------------------------------------------------------------------

function ItemPurchaseThink()
  ItemPurchaseGenericThink(tableItemsToBuy);
end

----------------------------------------------------------------------------------------------------
