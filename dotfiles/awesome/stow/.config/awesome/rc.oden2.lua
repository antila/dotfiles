local awful = require("awful")
local tyrannical = require("tyrannical")

awful.tag.delete()

tyrannical.tags = {
    {
        name        = "Web",
        screen      = 2, -- Setup on screen 2 if there is more than 1 screen, else on screen 1
        init        = true,
        exclusive   = true,
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
        screen      = 2, -- Setup on screen 2 if there is more than 1 screen, else on screen 1
        init        = true,
        exclusive   = true,
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
        screen      = 3, -- Setup on screen 2 if there is more than 1 screen, else on screen 1
        init        = true,
        exclusive   = true,
        layout      = awful.layout.suit.tile,
        exec_once   = {
            "pidgin",
            "icedove"
        },
        class       = {
            "Icedove",
            "Pidgin"
        }
    },
    {
        name        = "Terminal",             -- Call the tag "Term"
        init        = true,                   -- Load the tag on startup
        exclusive   = true,                   -- Refuse any other type of clients (by classes)
        screen      = 1 and 2 and 3,                      -- Create this tag on screen 1 and screen 2
        layout      = awful.layout.suit.tile, -- Use the tile layout
        instance    = {"dev", "ops"},         -- Accept the following instances. This takes precedence over 'class'
        class       = { --Accept the following classes, refuse everything else (because of "exclusive=true")
            "xterm" , "urxvt" , "aterm","URxvt","XTerm","konsole","terminator","gnome-terminal"
        }
    },
    {
        name        = "Buddy List",
        screen      = 3, -- Setup on screen 2 if there is more than 1 screen, else on screen 1
        init        = true,
        exclusive   = true,
        layout      = awful.layout.suit.tile,
        class       = {
            "buddy_list"
        }
    }
}
