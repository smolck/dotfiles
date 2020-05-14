local theme_assets = require('beautiful.theme_assets')
local awful        = require('awful')
local xresources   = require('beautiful.xresources')
local dpi          = xresources.apply_dpi

local colors       = require('themes/gruvboxmat/colors')

local theme = {}

theme.dir             = os.getenv('HOME') .. '/.config/awesome/themes/gruvboxmat'
theme.wallpaper       = theme.dir .. '/wall.jpg'

theme.font        = 'Hasklig Bold 12'
theme.nerd_font   = 'Hasklig Bold 12'

theme.hotkeys_font = 'Hasklig Bold 12'
theme.hotkeys_description_font = 'Hasklig Bold 8'

theme.bg_normal    = colors.bg1
theme.bg_focus     = colors.bg
theme.bg_urgent    = colors.bg1
theme.bg_minimize  = colors.bg1
theme.bg_systray   = colors.bg1

theme.fg_normal    = colors.fg
theme.fg_focus     = colors.fg0
theme.fg_urgent    = colors.fg
theme.fg_minimize  = colors.fg

theme.useless_gap   = dpi(10)
theme.border_width  = 0
theme.border_normal = colors.bg1
theme.border_focus  = colors.bg1
theme.border_marked = colors.bg1

theme.hotkeys_modifiers_fg = colors.fg1
theme.wibar_bg             = colors.bg1

theme.notification_padding = dpi(10)
theme.notification_spacing = theme.notification_padding
theme.notification_margin  = dpi(10)

theme.icon_theme = nil

function theme.create_wibar(screen)
    local lain  = require('lain')
    local gears = require('gears')
    local wibox = require('wibox')

    screen.wibar = awful.wibar({position = 'top', screen = screen})

    local separator = wibox.widget {
        markup = ' | ',
        widget = wibox.widget.textbox,
    }

    local root_space = awful.widget.watch('python ' .. theme.dir .. '/scripts/root_space.py', 20)

    -- Create a wibox for each screen and add it
    local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

    screen.mytaglist = awful.widget.taglist {
         screen  = screen,
         filter  = function (t) return t.selected or #t:clients() > 0 end,
         -- filter  = awful.widget.taglist.filter.all,
         buttons = taglist_buttons
    }
    local spacer = wibox.widget{}

    local mem = lain.widget.mem {
        settings = function ()
            widget:set_markup(mem_now.used .. " MB")
        end
    }

    -- local baticon = wibox.widget.imagebox(theme.widget_battery)
    local bat    = lain.widget.bat {
        settings = function ()
            local bat_percentage = io.popen(os.getenv('HOME') .. '/.scripts/battery'):read()
            -- if bat_now.status and bat_now.status ~= "N/A"
            -- baticon:set_image(theme.dir .. '/icons/battery_charging_full.svg')

            -- TODO
            if bat_now.ac_status == 1 then
                widget:set_markup('AC ' .. bat_percentage)
            elseif bat_now.ac_status == 0 or bat_now.ac_status == 'N/A' then
                widget:set_markup(bat_percentage)
            end
            -- end
        end
    }

    screen.wibar:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            screen.mytaglist,
            -- s.mypromptbox,
        },
        spacer,
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),

            wibox.widget.textclock(),
            separator,

            -- baticon,
            mem.widget,
            separator,

            bat.widget,
            separator,

            root_space,
        },
    }
end

return theme
