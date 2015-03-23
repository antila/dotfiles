local beautiful = require("beautiful")
local gears = require("gears")

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- Wallpaper Changer Based On
-- menu icon menu pdq 07-02-2012
 local wallmenu = {}
 local function wall_load(wall)
 local f = io.popen('ln -sfn ' .. home_path .. '.config/awesome/wallpaper/' .. wall .. ' ' .. home_path .. '.config/awesome/themes/default/bg.png')
 awesome.restart()
 end
 local function wall_menu()
 local f = io.popen('ls -1 ' .. home_path .. '.config/awesome/wallpaper/')
 for l in f:lines() do
local item = { l, function () wall_load(l) end }
 table.insert(wallmenu, item)
 end
 f:close()
 end
 wall_menu()
