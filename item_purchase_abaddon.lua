local tableItemsToBuy = {
  "item_tango",
  "item_branches",
  "item_branches",
  "item_ring_of_protection",
  "item_circlet",
  "item_magic_stick",

  "item_boots",
  "item_sobi_mask",
  "item_blades_of_attack",
  "item_blades_of_attack",

  "item_branches",
  "item_ring_of_regen",
  "item_recipe_headdress",
  "item_lifesteal",
  "sell;item_tango",
  "sell;item_clarity",

  "item_blink",
  "item_ring_of_regen",
  "item_sobi_mask",
  "item_recipe_soul_ring",
  "item_point_booster",
  "item_vitality_booster",
  "item_energy_booster",
  "sell;item_magic_wand",
  "item_recipe_bloodstone",

  "item_point_booster",
  "item_staff_of_wizardry",
  "item_ogre_axe",
  "item_blade_of_alacrity",
  
  "item_recipe_travel_boots",
  "sell;item_phase_boots",
  "item_boots",
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
