function ItemPurchaseGenericThink(tableItemsToBuy)
  local npcBot = GetBot();

  if ( tableItemsToBuy == 0 )
  then
    npcBot:SetNextItemPurchaseValue( 0 );
    return;
  end

  local sNextItem = tableItemsToBuy[1];

  npcBot:SetNextItemPurchaseValue( GetItemCost( sNextItem ) );

  if ( npcBot:GetGold() >= GetItemCost( sNextItem ) )
  then
    print( npcBot:GetUnitName() .. ' buys ' .. sNextItem );
    npcBot:Action_PurchaseItem( sNextItem );
    table.remove( tableItemsToBuy, 1 );
  end
end
