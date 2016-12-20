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

  --[[ if (string.find( sNextItem, "sell")) then
    local _, sellItem = sNextItem:match("([^,]+);([^,]+)");
    if ( npcBot:DistanceFromSideShop() <= 300 or
         npcBot:DistanceFromSecretShop() <= 100 or
         npcBot:DistanceFromFountain() <= 300) then
           ItemSellBot( npcBot, sellItem, tableItemsToBuy );
    end
    return;
  end
  ]]

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
      if ( GetTeam() == TEAM_RADIANT ) then
        npcBot:Action_MoveToLocation(secretShopLocationRadiant);
      else
        npcBot:Action_MoveToLocation(secretShopLocationDire);
      end
      if ( npcBot:DistanceFromSecretShop() <= distanceBuyShop ) then
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

  BuyTPScroll( npcBot, 2 );
end

-- this code is from nostrademous
-- http://dev.dota2.com/showthread.php?t=275015
function BuyTPScroll(npcBot, count)
	count = count or 1;
	local iScrollCount = 0;

	for i=0,8 do
		local sCurItem = npcBot:GetItemInSlot( i );
		if ( sCurItem ~= nil ) then
			local iName = sCurItem:GetName();
			if ( iName == "item_tpscroll" ) then
				iScrollCount = iScrollCount + 1;
			elseif ( iName == "item_travel_boots_1" or iName == "item_travel_boots_2" ) then
				return; --we are done, no need to check further
			end
		end
	end

	-- If we are at the sideshop or fountain with no TPs, then buy up to count
	if ( (npcBot:DistanceFromSideShop() <= distanceBuyShop or npcBot:DistanceFromFountain() <= distanceBuyShop)
        and iScrollCount < count and DotaTime() > 0) then
		for i=1,(count-iScrollCount) do
			if ( npcBot:GetGold() >= GetItemCost( "item_tpscroll" ) ) then
        print ( DotaTime() .. ' ' .. npcBot:GetUnitName() .. ' ' .. iScrollCount .. ' / ' .. count )
				ItemPurchaseBot( npcBot, "item_tpscroll", nil );
				iScrollCount = iScrollCount + 1;
			end
		end
	end
end

function ItemPurchaseBot( npcBot, sNextItem, tableItemsToBuy)
  npcBot:Action_PurchaseItem( sNextItem );
  print( npcBot:GetUnitName() .. ' buys ' .. sNextItem );

  if ( tableItemsToBuy ~= nil ) then
    table.remove( tableItemsToBuy, 1 );
  end

  flashMessage = true;
end

function ItemSellBot( npcBot, sNextItem, tableItemsToBuy )
  --[[ npcBot:Action_SellItem( sNextItem );
  print( npcBot:GetUnitName() .. ' sells ' .. sNextItem );

  if ( tableItemsToBuy ) then
    table.remove( tableItemsToBuy, 1 );
  end

  flashMessage = true;
  ]]
end
