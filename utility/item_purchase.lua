local flashMessage = true;
local sideShopThreshold = 4000;
local secretShopThreshold = 4000;
local distanceBuyShop = 300;

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

  if (sNextItem == nil) then
    return;
  end

  if (string.find( sNextItem, "sell")) then
    local _, sellItem = sNextItem:match("([^,]+);([^,]+)");
    ItemSellBot( npcBot, sellItem, tableItemsToBuy );
    return;
  end

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

    if ( IsItemPurchasedFromSideShop( sNextItem ) and DecidedToBuyToSideSecret( npcBot ) ) then
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
          if ( npcBot:DistanceFromSideShop() <= distanceBuyShop ) then
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
      npcBot.secretShopMode = true;

      if ( npcBot:DistanceFromSecretShop() <= distanceBuyShop ) then
        ItemPurchaseBot( npcBot, sNextItem, tableItemsToBuy );
        npcBot.secretShopMode = false;
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

  BuyTPScroll( npcBot, 2 );
end

-- this code is from nostrademous
-- http://dev.dota2.com/showthread.php?t=275015
function BuyTPScroll(npcBot, count)
  count = 1; -- override count until there is a way to find out how many in possessions
  local iScrollCount = 0;
  local iPossession = 0;


  -- checks scrolls or boots
  for i=0,14 do
    local sCurItem = npcBot:GetItemInSlot( i );
    if ( sCurItem ~= nil ) then
      iPossession = iPossession + 1;
      local iName = sCurItem:GetName();
      if ( iName == "item_tpscroll" ) then -- only check type, next : number of items
        iScrollCount = iScrollCount + 1;
      elseif ( iName == "item_travel_boots_1" or iName == "item_travel_boots_2" ) then
        return; --we are done, no need to check further
      end
    end
  end

  -- If we are at the sideshop or fountai\n with no TPs, then buy up to count, but only to inventory
  if ( (npcBot:DistanceFromSideShop() <= distanceBuyShop or npcBot:DistanceFromFountain() <= distanceBuyShop)
        and iScrollCount < count and DotaTime() > 0 and iPossession < 6) then
    for i=1,(count-iScrollCount) do
      if ( npcBot:GetGold() >= GetItemCost( "item_tpscroll" ) ) then
        ItemPurchaseBot( npcBot, "item_tpscroll", nil );
        iScrollCount = iScrollCount + 1;
      end
    end
  end
end

function DecidedToBuyToSideSecret( npcBot )
  return true; -- ( npcBot:GetActiveMode() == BOT_MODE_LANING );
end

function ItemPurchaseBot( npcBot, sNextItem, tableItemsToBuy)
  npcBot:Action_PurchaseItem( sNextItem );
  print( npcBot:GetUnitName() .. ' buys ' .. sNextItem );

  if ( tableItemsToBuy ~= nil ) then
    table.remove( tableItemsToBuy, 1 );
  end

  flashMessage = true;
end

function ItemSellBot( npcBot, sellItem, tableItemsToBuy )
  if ( npcBot:DistanceFromSideShop() <= distanceBuyShop or
       npcBot:DistanceFromSecretShop() <= distanceBuyShop or
       npcBot:DistanceFromFountain() <= distanceBuyShop ) then
    for i=0,5 do
      local sCurItem = npcBot:GetItemInSlot( i );
      if ( sCurItem ~= nil ) then
        local iName = sCurItem:GetName();
        if ( iName == sellItem ) then
          -- item exists! must be sold
          npcBot:Action_SellItem( sCurItem );
          print( npcBot:GetUnitName() .. ' sells ' .. sellItem );
        end
      end
    end

    -- exist or not, move on to next item build
    if ( tableItemsToBuy ~= nil ) then
      table.remove( tableItemsToBuy, 1 );
    end
    flashMessage = true;
  end
end
