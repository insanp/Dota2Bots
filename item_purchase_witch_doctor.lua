local tableItemsToBuy = {
  "item_tango",
  "item_tango",
  "item_branches",
  "item_branches",
  "item_circlet",
  "item_magic_stick",

  "item_boots",
  "item_energy_booster",

  "sell;item_tango",
  "item_ring_of_regen",
  "item_sobi_mask",
  "item_recipe_soul_ring",
  "item_point_booster",
  "item_vitality_booster",
  "item_energy_booster",
  "item_recipe_bloodstone",

  "item_point_booster",
  "item_staff_of_wizardry",
  "item_ogre_axe",
  "item_blade_of_alacrity",

  "item_ogre_axe",
  "item_mithril_hammer",
  "item_recipe_black_king_bar",
  
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
