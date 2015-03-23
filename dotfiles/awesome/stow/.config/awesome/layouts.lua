local awful = require("awful")
local wibox = require("wibox")
local menu = require("menu")
local wi = require("wi")

-- Widgets
spacer       = wibox.widget.textbox()
spacer:set_text(' | ')

--Weather Widget
weather = wibox.widget.textbox()
vicious.register(weather, vicious.widgets.weather, "Weather: ${city}. Sky: ${sky}. Temp: ${tempc}c Humid: ${humid}%. Wind: ${windkmh} KM/h", 1200, "YMML")

--Battery Widget
batt = wibox.widget.textbox()
vicious.register(batt, vicious.widgets.bat, "Batt: $2% Rem: $3", 61, "BAT1")

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {
 names  = {
         '☭:IRC',
         '⚡:Luakit',
         '♨:Chrome',
         '☠:Vim',
         '☃:Vbox',
         '⌥:Multimedia',
         '⌘:Conky',
         '✇:IDE',
         '✣:Facepalm',
           },
 layout = {
      layouts[3], -- 1:irc
      layouts[3], -- 2:luakit
      layouts[3], -- 3:chrome
      layouts[3], -- 4:vim
      layouts[3], -- 5:vbox
      layouts[3], -- 6:multimedia
      layouts[3], -- 7:conky
      layouts[3], -- 8:ide
      layouts[3], -- 9:facepalm
      }
   }
  for s = 1, screen.count() do
 -- Each screen has its own tag table.
 tags[s] = awful.tag(tags.names, s, tags.layout)
 end
-- }}}


-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock()

-- Create a wibox for each screen and add it
mywibox = {}
myinfowibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    --right_layout:add(spacer)
    right_layout:add(mailicon)
    right_layout:add(mailwidget)
    right_layout:add(spacer)
    right_layout:add(baticon)
    right_layout:add(batpct)
    right_layout:add(spacer)
    --right_layout:add(pacicon)
    --right_layout:add(pacwidget)
    --right_layout:add(spacer)
    right_layout:add(volicon)
    right_layout:add(volpct)
    right_layout:add(volspace)
    right_layout:add(spacer)
    right_layout:add(mytextclock)
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    --layout:set_middle(bottom_layout)
    layout:set_right(right_layout)

   mywibox[s]:set_widget(layout)

   -- Create the bottom wibox
     myinfowibox[s] = awful.wibox({ position = "bottom", screen = s })
   -- Widgets that are aligned to the bottom
    local bottom_layout = wibox.layout.fixed.horizontal()
    bottom_layout:add(cpuicon)
    bottom_layout:add(cpu)
    bottom_layout:add(spacer)
    bottom_layout:add(memicon)
    bottom_layout:add(mem)
    bottom_layout:add(spacer)
    bottom_layout:add(wifiicon)
    bottom_layout:add(wifi)
    bottom_layout:add(spacer)
    --bottom_layout:add(weather)
    bottom_layout:add(spacer)

    --myinfowibox[s]:set_widget(bottom_layout)
    myinfowibox[s]:set_widget(mytasklist[s])
    --layout:set_middle(bottom_layout)

end
-- }}}
