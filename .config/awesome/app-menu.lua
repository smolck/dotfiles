local awful = require('awful')

local button = awful.widget.button.new {
    image = '/opt/goneovim/goneovim.ico'
}

local app_menu = awful.popup {
    widget = {
    },
    ontop     = true,
    placement = awful.placement.centered,
    visible   = false,
}