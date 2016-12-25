local tableItemsToBuy = {
  "item_tango",
  "item_tango",
  "item_branches",
  "item_branches",
  "item_circlet",
  "item_magic_stick",
  "item_boots",
  "item_energy_booster",

  "item_mithril_hammer",
  "item_gloves",
  "item_recipe_maelstrom",

  "item_stout_shield",
  "item_ring_of_health",
  "item_vitality_booster",

  "sell;item_tango",
  "item_blink",
  "item_hyperstone",
  "item_recipe_mjollnir",

  "sell;item_magic_wand",
  "item_javelin",
  "item_belt_of_strength",
  "item_recipe_basher",
  "item_recipe_abyssal_blade",

  "item_recipe_travel_boots",
  "sell;item_arcane_boots",
  "item_boots",

  "item_relic",
  "item_recipe_radiance"

};

pcall(require, "bots/utility/item_purchase" )

----------------------------------------------------------------------------------------------------

function ItemPurchaseThink()
  ItemPurchaseGenericThink(tableItemsToBuy);
end

----------------------------------------------------------------------------------------------------
