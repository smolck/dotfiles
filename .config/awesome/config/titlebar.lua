-- WIP

local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")

local dpi = require("beautiful.xresources").apply_dpi

local titlebar = {}
function titlebar:init(c) -- , color, hover_color)
    buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    test = wibox.widget {
        forced_height = dpi(24),
        forced_width = dpi(24),
        bg = "#414458",
        shape = gears.shape.circle,
        widget = wibox.container.background()
    }

    test_widget = wibox.widget {
        test,
        margins = dpi(5),
        widget = wibox.container.margin()
    }

    setup = {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            -- awful.titlebar.widget.floatingbutton (c),
            test_widget,
            -- awful.titlebar.widget.maximizedbutton(c),
            -- awful.titlebar.widget.stickybutton   (c),
            -- awful.titlebar.widget.ontopbutton    (c),
            -- awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }

    titlebar.setup = setup
    titlebar.buttons = buttons
end

return titlebar
