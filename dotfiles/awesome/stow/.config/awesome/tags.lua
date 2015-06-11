local awful = require("awful")
local tyrannical = require("tyrannical")

-- Ignore the tag "exclusive" property for the following clients (matched by classes)
tyrannical.properties.intrusive = {
    "ksnapshot"     , "pinentry"       , "gtksu"     , "kcalc"        , "xcalc"               ,
    "feh"           , "Gradient editor", "About KDE" , "Paste Special", "Background color"    ,
    "kcolorchooser" , "plasmoidviewer" , "Xephyr"    , "kruler"       , "plasmaengineexplorer",
}

-- Ignore the tiled layout for the matching clients
tyrannical.properties.floating = {
    "MPlayer"      , "pinentry"        , "ksnapshot"  , "pinentry"     , "gtksu"          ,
    "xine"         , "feh"             , "kmix"       , "kcalc"        , "xcalc"          ,
    "yakuake"      , "Select Color$"   , "kruler"     , "kcolorchooser", "Paste Special"  ,
    "New Form"     , "Insert Picture"  , "kcharselect", "mythfrontend" , "plasmoidviewer"
}

-- Make the matching clients (by classes) on top of the default layout
tyrannical.properties.ontop = {
    "Xephyr"       , "ksnapshot"       , "kruler"
}

-- Force the matching clients (by classes) to be centered on the screen on init
tyrannical.properties.centered = {
    "kcalc"
}

tyrannical.properties.master = {
    "icedove"
}


tyrannical.settings.block_children_focus_stealing = true --Block popups ()
tyrannical.settings.group_children = true --Force popups/dialogs to have the same tags as the parent client

-- Create class for profanity running in terminal
awful.rules.rules = {
    {
        rule = { class = "URxvt", name = "profanity"  },
        callback = function(c)
        awful.client.property.set(c, "overwrite_class", "profanity")
        end
    }
}

-- Create class for Pidgins annoying Buddy List
awful.rules.rules = {
    {
        rule = { class = "Pidgin", name = "Buddy List"  },
        callback = function(c)
        awful.client.property.set(c, "overwrite_class", "buddy_list")
        end
    }
}
