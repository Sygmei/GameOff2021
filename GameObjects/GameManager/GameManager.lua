local player = nil;

function Local.Init()
    -- Events
    UserEventHandle = UserEvent();
    MoneyEvents = UserEventHandle:createGroup("Money");
    MoneyEvents:setJoinable(true);
    MoneyEvents:add("Gained");
    MoneyEvents:add("Lost");
    ChaosEvents = UserEventHandle:createGroup("Chaos");
    ChaosEvents:add("Raise");
    ChaosEvents:add("Lower");
    -- Start game, create player
    player = Engine.Scene:createGameObject("Player")({});
end