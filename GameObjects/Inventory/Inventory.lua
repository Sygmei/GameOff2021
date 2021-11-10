local _inventory = {};
local _capacity = 5;
local GAP_BETWEEN_ITEMS = 0.05; --SceneUnits
local ITEM_SPRITE_SIZE = obe.Transform.UnitVector(0.1, 0.1); --SceneUnits

function Local.Init(pos)
    This.SceneNode:setPosition(obe.Transform.UnitVector(pos.x, pos.y, obe.Transform.Units.SceneUnits));
end

function Object:AddItem(item)
    if #_inventory+1 >= _capacity then return false end;
    new_item = loadItem(item);
    _inventory[#_inventory+1] = new_item;
    new_item:on_acquire(Object);
    updateView();
end

function loadItem(item)
    new_item = {
        display_name = item.display_name,
        sprite = Engine.Scene:createSprite(),
        on_remove = item.on_remove or function()end,
        on_acquire = item.on_acquire or function()end
    };
    new_item.sprite:loadTexture(item.texture);
    new_item.sprite:setSize(ITEM_SPRITE_SIZE);
    return new_item;
end

function Object:RemoveItem(index)
    local to_remove = _inventory[index]
    if to_remove == nil then return false end;

    Engine.Scene:removeSprite(to_remove.sprite:getId());
    to_remove:on_remove(Object);
    table.remove(_inventory, index);
    updateView();
end

function Object:AddCapacity(add)
    _capacity = _capacity + add;
end

function Object:SetCapacity(capacity)
    -- TODO what if capacity < number of items ?
    _capacity = capacity;
end

function Object:HasItem(item)
    --TODO compare all necessary fields
end

function Object:Count()
    return #_inventory;
end

function updateView()
    for i, item in ipairs(_inventory) do
        item.sprite:setPosition(This.SceneNode:getPosition() + obe.Transform.UnitVector((i-1)*(ITEM_SPRITE_SIZE.x+GAP_BETWEEN_ITEMS), 0, obe.Transform.Units.SceneUnits));
    end
end
