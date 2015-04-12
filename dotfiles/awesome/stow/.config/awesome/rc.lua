--Configure home path so you dont have too
home_path  = os.getenv('HOME') .. '/'

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
local tyrannical = require("tyrannical")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
beautiful.init( awful.util.getdir("config") .. "/themes/default/theme.lua" )

-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
--FreeDesktop
require('freedesktop.utils')
require('freedesktop.menu')
freedesktop.utils.icon_theme = 'gnome'
--Vicious + Widgets
vicious = require("vicious")

local tags = require("tags")
local layouts = require("layouts")
local keys = require("keys")
local menu = require("menu")
local signals = require("signals")
local wallpaper = require("wallpaper")
local wi = require("wi")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Naughty presets
naughty.config.defaults.timeout = 5
naughty.config.defaults.screen = 1
naughty.config.defaults.position = "top_right"
naughty.config.defaults.margin = 8
naughty.config.defaults.gap = 1
naughty.config.defaults.ontop = true
naughty.config.defaults.font = "GohuFont 10"
naughty.config.defaults.icon = nil
naughty.config.defaults.icon_size = 256
naughty.config.defaults.fg = beautiful.fg_tooltip
naughty.config.defaults.bg = beautiful.bg_tooltip
naughty.config.defaults.border_color = beautiful.border_tooltip
naughty.config.defaults.border_width = 2
naughty.config.defaults.hover_timeout = nil
-- -- }}}

awesome.font = "GohuFont 10"
theme.font = 'GohuFont 10'
vicious.font = 'GohuFont 10'

-- this is my default font
-- theme.font      = "Inconsolata Medium 10"
-- make tag list bigger
-- theme.taglist_font = "Inconsolata Medium 14"

function run_once(cmd)
    findme = cmd
    firstspace = cmd:find(" ")
    if firstspace then
        findme = cmd:sub(0, firstspace-1)
    end
    awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end

run_once("xscreensaver -no-splash")
run_once("nm-applet") -- wifi

-- TODO:
-- https://awesome.naquadah.org/wiki/Conky_HUD
-- https://awesome.naquadah.org/wiki/Using_dmenu
-- http://weechat.org/
-- https://awesome.naquadah.org/wiki/Urxvt_tips
-- prevent minimize
-- click to focus instead of sloppy focus
