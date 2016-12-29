local tableItemsToBuy = {
  "item_tango",
  "item_branches",
  "item_branches",
  "item_ring_of_protection",
  "item_circlet",
  "item_magic_stick",

  "item_boots",
  "item_sobi_mask",
  "item_belt_of_strength",
  "item_gloves",

  "item_branches",
  "item_ring_of_regen",
  "item_recipe_headdress",
  "item_lifesteal",
  "sell;item_tango",
  "sell;item_clarity",

  "item_blink",

  "item_staff_of_wizardry",
  "item_belt_of_strength",
  "item_recipe_necronomicon",
  "item_recipe_necronomicon",
  "item_recipe_necronomicon",

  "sell;item_magic_wand",
  "item_point_booster",
  "item_staff_of_wizardry",
  "item_ogre_axe",
  "item_blade_of_alacrity",

  "sell;item_power_treads",
  "item_boots",
  "sell:item_tpscroll",
  "item_recipe_travel_boots",

  "item_energy_booster",
  "item_ring_of_health",
  "item_recipe_aether_lens"
};

pcall(require, "bots/utility/item_purchase" )

----------------------------------------------------------------------------------------------------

function ItemPurchaseThink()
  ItemPurchaseGenericThink(tableItemsToBuy);
end

----------------------------------------------------------------------------------------------------
