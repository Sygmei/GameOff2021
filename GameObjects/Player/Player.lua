local _chaos = 0.0;
local _money = 50;

function Local.Init()
end

function Object:AddMoney(amount)
    _money = _money + amount;
end

function UpdateView()

end