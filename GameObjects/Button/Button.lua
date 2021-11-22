DEFAULT_TEXTURE = "sprites://button_default.png"

local _enabled = true;
local _canvas = nil;
local _canvas_text = nil;
local _canvas_sprite = nil;

function Local.Init(pos, label, size, texture, on_press)
    -- Button sprite + canvas
    Object.sprite = Engine.Scene:createSprite();
    Object.sprite:loadTexture(texture or DEFAULT_TEXTURE);
    Object.sprite:setSize(size or Object.sprite:getTexture():getSize());
    _canvas_sprite = Engine.Scene:createSprite();
    _canvas_sprite:setSize(Object.sprite:getSize());
    local canvas_size = Object.sprite:getSize():to(obe.Transform.Units.ScenePixels);
    _canvas = obe.Canvas.Canvas(canvas_size.x, canvas_size.y);
    This.SceneNode:addChild(Object.sprite);
    This.SceneNode:addChild(_canvas_sprite);

    local position = pos or obe.Transform.UnitVector(0, 0);
    This.SceneNode:setPosition(position);

    _canvas_text = _canvas:Text(This:getId().."_label") {
        x = canvas_size.x/2,
        y = canvas_size.y/2,
        unit = canvas_size.unit,
        size = 24,
        align = {h = "Center", v = "Center"},
        color = "#FFF",
        font = "Data/Fonts/NotoSans.ttf",
        text = "",
        layer = 1
    }
    SetText(label or "");

    Object.on_press = on_press or function()end;
end

function Object:SetEnabled(enable)
    --TODO gray out sprite
    _enabled = enable;
end

function Event.Cursor.Press(event)
    if _enabled == true then
        local click_pos = obe.Transform.UnitVector(event.x, event.y, obe.Transform.Units.ViewPixels);
        if event.left == true and Object.sprite:contains(click_pos) then
            Object:on_press(Object);
        end
    end
end

function SetText(text)
    _canvas_text.text = text;
    _canvas:render(_canvas_sprite);
end

