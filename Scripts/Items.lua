local Items = {};

Items.CPU = {
    display_name = "CPU",
    texture = "sprites://item_placeholder.png",
    buy_price = 275,
    sell_price = 150,
    on_acquire = function (self, inventory)
        log.info("You acquired a", self.display_name, "!");
        log.info("It's your item number", inventory:Count());
    end,
    on_remove = function()
        log.info("You just lost a CPU !");
    end
}

Items.RAM_2GB = {
    display_name = "RAM 2GB",
    buy_price = 200,
    sell_price = 100,
    texture = "sprites://item_placeholder_2.png"
}

Items.Beeper = {
    display_name = "Beeper",
    texture = "sprites://Beeper.png",
    buy_price = 5,
    sell_price = 1,
    use = function()
        log.info("Beep !");
    end
}

return Items;