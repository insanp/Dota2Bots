local flashMessage = true;
local sideShopThreshold = 4000;
local secretShopThreshold = 4000;

local sideShopLocationTop = Vector(-7000, 4500);
local sideShopLocationBot = Vector(7000, -4500);
local secretShopLocationRadiant = Vector(-4800, 900);
local secretShopLocationDire = Vector(4700, -1900);

function ItemPurchaseGenericThink(tableItemsToBuy)
  local npcBot = GetBot();
  local loc = npcBot:GetLocation();

  if ( tableItemsToBuy == 0 )
  then
    npcBot:SetNextItemPurchaseValue( 0 );
    return;
  end

  local sNextItem = tableItemsToBuy[1];

  npcBot:SetNextItemPurchaseValue( GetItemCost( sNextItem ) );

  if ( npcBot:GetGold() >= GetItemCost( sNextItem ) )
  then
    if ( flashMessage == true ) then
      print( npcBot:GetUnitName() .. ' will be buying ' .. sNextItem );
    end

    -- try to make a purchase
    if ( IsItemPurchasedFromSideShop( sNextItem ) and IsItemPurchasedFromSecretShop( sNextItem )) then
      -- this item can be bought from either side or secret shop
      -- find the closest
      flashMessage = false;
    end

    if ( IsItemPurchasedFromSideShop( sNextItem ) ) then
      -- this item can be bought from side shop
      if ( npcBot:DistanceFromSideShop() <= sideShopThreshold ) then
        -- there is a side shop nearby, do not buy item yet
        -- print( npcBot:GetUnitName() .. ' is near side shop for ' .. sNextItem .. ' with distance ' .. npcBot:DistanceFromSideShop())
        if ( npcBot:DistanceFromSideShop() <= (0.5 * sideShopThreshold) ) then
          -- side shop is near, go immediately
          if (loc.x < 0) then
            npcBot:Action_MoveToLocation(sideShopLocationTop);
          else
            npcBot:Action_MoveToLocation(sideShopLocationBot);
          end
          if ( npcBot:DistanceFromSideShop() <= 300 ) then
            ItemPurchaseBot( npcBot, sNextItem, tableItemsToBuy );
          end
        end
        flashMessage = true;
        return;
      else
        -- buy this item if it is not from secret shop (which can go through courier)
        if ( not IsItemPurchasedFromSecretShop( sNextItem ) ) then
          ItemPurchaseBot( npcBot, sNextItem, tableItemsToBuy );
        end
      end
      flashMessage = false;
    end

    if ( IsItemPurchasedFromSecretShop( sNextItem ) and npcBot:DistanceFromSecretShop() <= secretShopThreshold ) then
      -- this item is from secret shop
      if ( GetTeam() == TEAM_RADIANT ) then
        npcBot:Action_MoveToLocation(secretShopLocationRadiant);
      else
        npcBot:Action_MoveToLocation(secretShopLocationDire);
      end
      if ( npcBot:DistanceFromSecretShop() <= 100 ) then
        ItemPurchaseBot( npcBot, sNextItem, tableItemsToBuy );
      end
    end

    if ( not IsItemPurchasedFromSideShop( sNextItem ) and not IsItemPurchasedFromSecretShop( sNextItem )) then
      -- this item can only be bought in home shop
      ItemPurchaseBot( npcBot, sNextItem, tableItemsToBuy );
    end

    flashMessage = false;
  else
    flashMessage = false;
  end

  if ( npcBot:GetGold() >= GetItemCost( 'item_tpscroll' ) and npcBot:DistanceFromSideShop() <= 300 ) then
    -- buy at least one scroll from side shop
    for i=1,6 do
      print (npcBot:GetItemInSlot(i))
      if ( npcBot:GetItemInSlot(i) == 'item_tpscroll') then
         return
      end
    end
    ItemPurchaseBot( npcBot, 'item_tpscroll', nil );
  end
end

function ItemPurchaseBot( npcBot, sNextItem, tableItemsToBuy)
  npcBot:Action_PurchaseItem( sNextItem );
  print( npcBot:GetUnitName() .. ' buys ' .. sNextItem );

  if ( tableItemsToBuy ) then
    table.remove( tableItemsToBuy, 1 );
  end

  flashMessage = true;
end

function ItemSellBot( npcBot, sNextItem, tableItemsToBuy )
end
