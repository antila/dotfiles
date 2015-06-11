-- local awful = require("awful")
-- require('posix')

-- -- Autostart
-- function resolve_symlink(file, level)
--     if not level then
--         level = -1
--     end
--     local file_stat = posix.stat(file)
--     if level ~= 0 and file_stat and file_stat.type == 'link' then
--         local readlink_output = awful.util.pread(string.format('readlink %s', file)):gsub('%s*$', '')
--         return resolve_symlink(readlink_output, level - 1)
--     end

--     return file
-- end

-- function launch_command(command)
--     local basename = command:gsub('^.*/', ''):gsub('%s+.*$', '')
--     awful.util.spawn_with_shell(string.format('pgrep -u $USER -f "%s$" >/dev/null || (%s &)', basename, command))
-- end

-- local autostart_commands = {}

-- -- Awesome autostart directory
-- local autostart_dir = string.format('%s/autostart', awful.util.getdir('config'))
-- local autostart_stat = posix.stat(autostart_dir)
-- if autostart_stat and autostart_stat.type == 'directory' then
--     local files = posix.dir(autostart_dir)
--     if files then
--         for _, file in pairs(files) do
--             local full_file = resolve_symlink(string.format('%s/%s', autostart_dir, file), 1)
--             local file_stat = posix.stat(full_file)
--             if file_stat and file_stat.type == 'regular' then
--                 autostart_commands[full_file] = full_file
--             end
--         end
--     end
-- end
