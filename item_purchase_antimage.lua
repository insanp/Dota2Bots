local tableItemsToBuy = {
  "item_tango",
  "item_tango",
  "item_branches",
  "item_branches",
  "item_circlet",
  "item_magic_stick",

  "item_quelling_blade",
  "item_ring_of_health",
  "item_void_stone",
  "item_broadsword",
  "item_claymore",
  "item_boots",
  "sell;item_tango",
  "item_gloves",
  "item_belt_of_strength",

  "item_stout_shield",
  "item_ring_of_health",
  "item_vitality_booster",

  "item_quarterstaff",
  "item_sobi_mask",
  "item_robe",
  "item_ogre_axe",
  
  "item_javelin",
  "item_belt_of_strength",
  "item_recipe_basher",
  "item_recipe_abyssal_blade",

  "item_ogre_axe",
  "item_blade_of_alacrity",
  "item_boots_of_elves",
  "item_recipe_yasha",
  "item_ultimate_orb",
  "sell;item_magic_wand",
  "item_recipe_manta",

  "item_point_booster",
  "item_staff_of_wizardry",
  "item_ogre_axe",
  "item_blade_of_alacrity"
};

pcall(require, "bots/utility/item_purchase" )

----------------------------------------------------------------------------------------------------

function ItemPurchaseThink()
  ItemPurchaseGenericThink(tableItemsToBuy);
end

----------------------------------------------------------------------------------------------------
