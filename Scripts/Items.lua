local Items = {};

Items.CPU = {
    display_name = "CPU",
    texture = "sprites://item_placeholder.png",
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
    texture = "sprites://item_placeholder_2.png",
}

return Items;