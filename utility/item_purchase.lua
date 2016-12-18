local flashMessage = true;
local sideShopThreshold = 3000;
local secretShopThreshold = 5000;

local sideShopLocationTop = Vector(-7000, 4500);
local sideShopLocationBot = Vector(7000, -4500);

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
          loc = npcBot:GetLocation();
          print(loc);
          if (loc.x < 0) then
            npcBot:Action_MoveToLocation(sideShopLocationTop);
          else
            npcBot:Action_MoveToLocation(sideShopLocationBot);
          end
          if ( npcBot:DistanceFromSideShop() <= 600 ) then
            ItemPurchaseBot( npcBot, sNextItem, tableItemsToBuy );
          end
        end
        return;
      else
        -- buy this item if it is not from secret shop (which can go through courier)
        if ( not IsItemPurchasedFromSecretShop( sNextItem ) ) then
          ItemPurchaseBot( npcBot, sNextItem, tableItemsToBuy );
        end
      end
      flashMessage = false;
    end

    if ( not IsItemPurchasedFromSideShop( sNextItem ) and not IsItemPurchasedFromSecretShop( sNextItem )) then
      -- this item can only be bought in home shop
      ItemPurchaseBot( npcBot, sNextItem, tableItemsToBuy );
    end

    flashMessage = false;
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
