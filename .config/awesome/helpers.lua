-- NOT MY WORK! Credit goes to github user 'elenapan'.
-- Here's his/her dotfiles (from whence this was gotten):
-- https://github.com/elenapan/dotfiles

local gears = require("gears")

local helpers = {}

-- Create rounded rectangle shape
helpers.rrect = function(radius)
    return function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, radius)
        --gears.shape.octogon(cr, width, height, radius)
        --gears.shape.rounded_bar(cr, width, height)
    end
end

function helpers.colorize_text(txt, fg)
    return "<span foreground='" .. fg .."'>" .. txt .. "</span>"
end

-- Create rectangle shape
helpers.rect = function()
    return function(cr, width, height)
        gears.shape.rectangle(cr, width, height)
    end
end

return helpers
