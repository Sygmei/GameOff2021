local MoneyEvents = UserEvent.Money();

local _inventory = {};
local _capacity = 14;
local _hold_control = false;
local _sell_button = nil;

local GAP_BETWEEN_ITEMS = 0.05; --SceneUnits
local ITEM_SPRITE_SIZE = obe.Transform.UnitVector(0.1, 0.1); --SceneUnits
local SELECTION_SPRITE = "sprites://item_select.png";
local ITEMS_PER_LINE = 7;
local GAP_BETWEEN_LINES = 0.1; --SceneUnits

function Local.Init(pos)
    This.SceneNode:setPosition(obe.Transform.UnitVector(pos.x, pos.y, obe.Transform.Units.SceneUnits));
    _sell_button = Engine.Scene:createGameObject("Button")({
        pos=obe.Transform.UnitVector(1, 1),
        label="Sell",
        on_press=function()
            Object:SellSelection();
            end});
    _sell_button:SetEnabled(false);
end

function Object:AddItem(item)
    if #_inventory >= _capacity then return false end;
    new_item = loadItem(item);
    table.insert(_inventory, new_item);
    new_item:on_acquire(Object);
    UpdateView();
end

function loadItem(item)
    new_item = {
        display_name = item.display_name,
        sprite = Engine.Scene:createSprite(),
        on_remove = item.on_remove or function()end,
        on_acquire = item.on_acquire or function()end,
        use = item.use or function()end,
        selected = false,
        selection_sprite = Engine.Scene:createSprite(),
        sell_price = item.sell_price or 0
    };
    new_item.sprite:loadTexture(item.texture);
    new_item.sprite:setSize(ITEM_SPRITE_SIZE);
    new_item.selection_sprite:loadTexture(SELECTION_SPRITE);
    new_item.selection_sprite:setSize(ITEM_SPRITE_SIZE);
    new_item.selection_sprite:setVisible(false);
    return new_item;
end

function Object:RemoveItem(index)
    Object:RemoveItems({index});
end

function Object:RemoveItems(indexes)
    if #indexes <= 0 then return end;
    for _, i in ipairs(indexes) do
        if _inventory[i] ~= nil then
            _inventory[i]:on_remove(Object);
            Engine.Scene:removeSprite(_inventory[i].sprite:getId());
            Engine.Scene:removeSprite(_inventory[i].selection_sprite:getId());
            _inventory[i].to_remove = true;
        end
    end
    for i = #_inventory, 1, -1 do
        if _inventory[i].to_remove == true then
            table.remove(_inventory, i);
        end
    end
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
    local line = 0;
    local line_pos = 0;
    for i, item in ipairs(_inventory) do
        line = i // (ITEMS_PER_LINE + 1);
        line_pos = (i-1) % ITEMS_PER_LINE;
        local sprite_pos = This.SceneNode:getPosition() + obe.Transform.UnitVector((line_pos)*(ITEM_SPRITE_SIZE.x+GAP_BETWEEN_ITEMS), line*(ITEM_SPRITE_SIZE.y+GAP_BETWEEN_LINES), obe.Transform.Units.SceneUnits)
        item.sprite:setPosition(sprite_pos);
        item.selection_sprite:setPosition(sprite_pos);
    end
end

function UnselectAll()
    for i, item in ipairs(_inventory) do
        item.selected = false;
        item.selection_sprite:setVisible(false);
    end
end

function GetSelectedItems()
    local selected = {}
    for _, item in ipairs(_inventory) do
        if item.selected then
            table.insert(selected, item);
        end
    end
    return selected;
end

function Event.Keys.LControl(event)
    if event.state == obe.Input.InputButtonState.Pressed then
        _hold_control = true;
    elseif event.state == obe.Input.InputButtonState.Released then
        _hold_control = false;
    end
end

-- Use item
function Event.Keys.Space(event)
    if event.state == obe.Input.InputButtonState.Pressed then
        for _, item in ipairs(_inventory) do
            if item.selected then
                item.use();
            end
        end
    end
end

-- Sell item
function Object:SellSelection()
    local to_remove = {}
    for i, item in ipairs(_inventory) do
        if item.selected then
            MoneyEvents:trigger("Gained", {amount = item.sell_price});
            table.insert(to_remove, i);
        end
    end
    Object:RemoveItems(to_remove);
    _sell_button:SetEnabled(false);
end

function Event.Keys.S(event)
    if event.state == obe.Input.InputButtonState.Pressed then
        Object:SellSelection();
    end
end

-- Select item
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
    _sell_button:SetEnabled(#GetSelectedItems() > 0);

end
