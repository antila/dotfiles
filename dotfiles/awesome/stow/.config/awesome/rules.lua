local awful = require("awful")
local beautiful = require("beautiful")

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "Iceweasel" },
        properties = { tag = tags[1][1] }
    },
    { rule = { class = "Sublime" },
        properties = { tag = tags[1][2] }
    },
    { rule = { class = "Terminal" },
        properties = { tag = tags[1][3] }
    },
    { rule = { class = "Pidgin" },
        properties = { tag = tags[2][5] }
    },
    -- { rule = { class = "pinentry" },
    --   properties = { floating = true } },
    -- { rule = { class = "gimp" },
    --   properties = { floating = true } },
    -- { rule = { class = "Chromium" },
    --   properties = { tag = tags[1][3] } },
    -- { rule = { class = "Vlc" },
    --   properties = { tag = tags[1][6] } },
    -- { rule = { class = "VirtualBox" },
    --   properties = { tag = tags[1][5] } },
    -- { rule = { class = "Gns3" },
    --   properties = { tag = tags[1][5] } },
    -- { rule = { class = "Bitcoin-qt" },
    --   properties = { tag = tags[1][9] } },
    -- { rule = { class = "luakit" },
    --   properties = { tag = tags[1][2] } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}
