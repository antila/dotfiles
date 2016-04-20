local awful = require("awful")
local tyrannical = require("tyrannical")

print(string.format('[awesome] load rc'))

-- screens
local left = 3
local middle = 1
local right = 2

-- Conky
-- mystatusbar = awful.wibox({ position = "right", screen = 2, ontop = false, width = 600, height = 1440})
-- mystatusbar:set_bg("#00000000")

awful.tag.delete()

tyrannical.tags = {
    {
        name        = "Web",
        screen      = middle, --screens["DP-1.81"].index, -- Setup on screen 2 if there is more than 1 screen, else on screen 1
        init        = true,
        -- exclusive   = true,
        layout      = awful.layout.suit.tile,
        exec_once   = {
            "iceweasel"
        },
        class       = {
            "Iceweasel"
        }
    },
    {
        name        = "Develop",
        screen      = middle, -- Setup on screen 2 if there is more than 1 screen, else on screen 1
        init        = true,
        -- exclusive  R = true,
        layout      = awful.layout.suit.tile,
        exec_once   = {
            "atom"
        },
        class       = {
            "Atom"
        }
    },
    {
        name        = "Social",
        screen      = right, -- Setup on screen 2 if there is more than 1 screen, else on screen 1
        init        = true,
        -- exclusive   = true,
        layout      = awful.layout.suit.tile,
        exec_once   = {
            -- "pidgin",
            "icedove"
        },
        class       = {
            "Icedove",
            -- "Pidgin"
        }
    },
    {
        name        = "Testing",
        screen      = right, -- Setup on screen 2 if there is more than 1 screen, else on screen 1
        init        = true,
        exclusive   = true,
        layout      = awful.layout.suit.tile,
        no_focus_stealing = true,
        force_screen = true,
        class       = {
            "chromium",
            "chromium-browser",
            "google-chrome",
            "google-chrome-stable",
            "URxvt:tests"
        }
    },
    {
        name        = "Terminal",             -- Call the tag "Term"
        init        = true,                   -- Load the tag on startup
        -- exclusive   = true,                   -- Refuse any other type of clients (by classes)
        screen      = 1 and 2 and 3,                      -- Create this tag on screen 1 and screen 2
        layout      = awful.layout.suit.tile, -- Use the tile layout
        instance    = {"dev", "ops"},         -- Accept the following instances. This takes precedence over 'class'
        class       = { --Accept the following classes, refuse everything else (because of "exclusive=true")
            "xterm","urxvt","aterm","URxvt","XTerm","konsole","terminator","gnome-terminal"
        }
    }
}

awful.rules.rules = {
    {
        rule = { class = "URxvt", name = "npm run test-nodemon" },
        callback = function(c)
            awful.client.property.set(c, "overwrite_class", "URxvt:tests")
        end
    }
}

--Force popups/dialogs to have the same tags as the parent client
tyrannical.settings.group_children = true
