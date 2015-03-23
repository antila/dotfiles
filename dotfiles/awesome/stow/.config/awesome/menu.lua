local beautiful = require("beautiful")
local awful = require("awful")
-- Notification library
local menubar = require("menubar")


-- This is used later as the default terminal and editor to run.
editor = os.getenv("EDITOR") or "subl"
terminal = "urxvt -fg white -bg black"
editor_cmd = terminal .. " -e " .. editor

-- {{{ Menu
-- Create a laucher widget and a main menu

menu_items = freedesktop.menu.new()
myawesomemenu = {
   { "manual", terminal .. " -e man awesome", freedesktop.utils.lookup_icon({ icon = 'help' }) },
   { "edit config", editor_cmd .. " " .. awesome.conffile, freedesktop.utils.lookup_icon({ icon = 'package_settings' }) },
   { "restart", awesome.restart, freedesktop.utils.lookup_icon({ icon = 'system-shutdown' }) },
   { "quit", awesome.quit, freedesktop.utils.lookup_icon({ icon = 'system-shutdown' }) }
       }

        table.insert(menu_items, { "Awesome", myawesomemenu, beautiful.awesome_icon })
        table.insert(menu_items, { "Wallpaper", wallmenu, freedesktop.utils.lookup_icon({ icon = 'gnome-settings-background' })})

        mymainmenu = awful.menu({ items = menu_items, width = 150 })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}
