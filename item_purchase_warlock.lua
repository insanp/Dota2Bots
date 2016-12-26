local tableItemsToBuy = {
  "item_courier",
  "item_ring_of_protection",
  "item_tango",
  "item_clarity",
  "item_branches",
  "item_branches",
  "item_circlet",
  "item_magic_stick",
  "item_sobi_mask",
  "item_boots",
  "item_energy_booster",
  "sell;item_tango",
  "item_point_booster",
  "item_staff_of_wizardry",
  "item_ogre_axe",
  "item_blade_of_alacrity",
  "item_platemail",
  "item_mystic_staff",
  "item_recipe_shivas_guard",
  "sell;item_ring_of_basilius",
  "item_ring_of_health",
  "item_void_stone",
  "item_ring_of_health",
  "item_void_stone",
  "item_recipe_refresher"
};

pcall(require, "bots/utility/item_purchase" )

----------------------------------------------------------------------------------------------------

function ItemPurchaseThink()
        ItemPurchaseGenericThink(tableItemsToBuy);
end

----------------------------------------------------------------------------------------------------
