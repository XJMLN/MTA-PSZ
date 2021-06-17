
--function domy_showaOwnedHouse(who)
  --  for k,v in ipairs(getElementsByType('colshape'), resourceRoot) do
    --    local dom = getElementData(v,"dom")
      --  if (dom and dom.ownerid==getElementData(who,"auth:uid")) then
        --    local x,y,z = getElementPosition(v)
          --  local blip = createBlip(x,y,z,32,2,255,0,0,255,100,500);
            --setElementData(blip,'anty_destroy',true)
        --end
    --end
--end
--addEvent("showOwnedHouse",true)
--addEventHandler("showOwnedHouse",root,domy_showaOwnedHouse)

bindKey( 'i', 'both', function( key, keyState )
        if keyState == 'down' then
            for k, v in ipairs ( getElementsByType( 'colshape', resourceRoot ) ) do
                local dom=getElementData(v,"dom")
                if (dom and dom.ownerid) then
                    createBlipAttachedTo( v, 32, 2, 255,0,0,255,100,500 );
                else
                    createBlipAttachedTo( v, 31, 2, 255,0,0,255,100,500 );
                end
            end
        else
            for k, v in ipairs( getElementsByType( 'blip', getResourceRootElement() ) ) do
                if not getElementData(v,"anty_destroy") then
                destroyElement(v)
                end
            end
        end

    end)