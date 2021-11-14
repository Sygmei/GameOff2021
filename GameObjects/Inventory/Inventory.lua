local _inventory = {};
local _capacity = 5;
local _hold_control = false;

local GAP_BETWEEN_ITEMS = 0.05; --SceneUnits
local ITEM_SPRITE_SIZE = obe.Transform.UnitVector(0.1, 0.1); --SceneUnits
local SELECTION_SPRITE = "sprites://item_select.png";

function Local.Init(pos)
    This.SceneNode:setPosition(obe.Transform.UnitVector(pos.x, pos.y, obe.Transform.Units.SceneUnits));
end

function Object:AddItem(item)
    if #_inventory+1 >= _capacity then return false end;
    new_item = loadItem(item);
    _inventory[#_inventory+1] = new_item;
    new_item:on_acquire(Object);
    UpdateView();
end

function loadItem(item)
    new_item = {
        display_name = item.display_name,
        sprite = Engine.Scene:createSprite(),
        on_remove = item.on_remove or function()end,
        on_acquire = item.on_acquire or function()end,
        selected = false,
        selection_sprite = Engine.Scene:createSprite()
    };
    new_item.sprite:loadTexture(item.texture);
    new_item.sprite:setSize(ITEM_SPRITE_SIZE);
    new_item.selection_sprite:loadTexture(SELECTION_SPRITE);
    new_item.selection_sprite:setSize(ITEM_SPRITE_SIZE);
    new_item.selection_sprite:setVisible(false);
    return new_item;
end

function Object:RemoveItem(index)
    local to_remove = _inventory[index]
    if to_remove == nil then return false end;

    Engine.Scene:removeSprite(to_remove.sprite:getId());
    to_remove:on_remove(Object);
    table.remove(_inventory, index);
    UpdateView();
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

function UpdateView()
    for i, item in ipairs(_inventory) do
        item.sprite:setPosition(This.SceneNode:getPosition() + obe.Transform.UnitVector((i-1)*(ITEM_SPRITE_SIZE.x+GAP_BETWEEN_ITEMS), 0, obe.Transform.Units.SceneUnits));
        item.selection_sprite:setPosition(This.SceneNode:getPosition() + obe.Transform.UnitVector((i-1)*(ITEM_SPRITE_SIZE.x+GAP_BETWEEN_ITEMS), 0, obe.Transform.Units.SceneUnits));
    end
end

function UnselectAll()
    for i, item in ipairs(_inventory) do
        item.selected = false;
        item.selection_sprite:setVisible(false);
    end
end

function Event.Keys.LControl(event)
    if event.state == obe.Input.InputButtonState.Pressed then
        _hold_control = true;
    elseif event.state == obe.Input.InputButtonState.Released then
        _hold_control = false;
    end
end

function Event.Cursor.Press(event)
    local click_pos = obe.Transform.UnitVector(event.x, event.y, obe.Transform.Units.ViewPixels);
    local item_clicked = false;

    if event.left == true then
        for i, item in ipairs(_inventory) do
            if item.sprite:contains(click_pos) then
                item_clicked = true;
                if _hold_control then
                    item.selected = not item.selected
                else
                    UnselectAll();
                    item.selected = true;
                end
                item.selection_sprite:setVisible(item.selected);
                break;
            end
        end
    end
    if not item_clicked then
        UnselectAll();
    end

end
