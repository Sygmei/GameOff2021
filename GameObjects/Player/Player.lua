Items = require "scripts://Items";

local _chaos = 0.0;
local _money = 50;
local _job_manager = Engine.Scene:createGameObject("JobManager")({});
local _inventory = Engine.Scene:createGameObject("Inventory")({pos={x=0,y=0}});

function Local.Init()
    -- Testing
    _inventory = Engine.Scene:createGameObject("Inventory")({pos={x=0,y=0}});
    _inventory:AddItem(Items.CPU);
    _inventory:AddItem(Items.RAM_2GB);
    _inventory:AddItem(Items.CPU);
    _inventory:RemoveItem(1);
    _inventory:AddItem(Items.Beeper);
    _inventory:AddItem(Items.CPU);
    _inventory:AddItem(Items.CPU);
    _inventory:AddItem(Items.CPU);
    _inventory:AddItem(Items.CPU);
    _inventory:AddItem(Items.CPU);
    _inventory:AddItem(Items.CPU);
    _inventory:AddItem(Items.CPU);
    _inventory:AddItem(Items.RAM_2GB);
    _job_manager = Engine.Scene:createGameObject("JobManager")({});
    _job_manager:AddNewJob("C++ course lvl 1");
    _job_manager:AddNewJob("Add memory leak to Google");
    _job_manager:AddNewJob("Develop SkyNet");
end

function UserEvent.Money.Gained(evt)
    _money = _money + evt.amount;
    log.info("Money +"..evt.amount.." $");
end

function UserEvent.Money.Lost(evt)
    _money = _money - evt.amount;
end

function UserEvent.Chaos.Raise(evt)
    _chaos = _chaos + evt.amount;
end

function UserEvent.Chaos.Lower(evt)
    _chaos = _chaos - evt.amount;
end


function UpdateView()

end