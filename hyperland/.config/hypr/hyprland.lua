--  _   _                  _                 _
-- | | | |_   _ _ __  _ __| | __ _ _ __   __| |
-- | |_| | | | | '_ \| '__| |/ _` | '_ \ / _` |
-- |  _  | |_| | |_) | |  | | (_| | | | | (_| |
-- |_| |_|\__, | .__/|_|  |_|\__,_|_| |_|\__,_|
--        |___/|_|
--
-- Each require() is its own Lua scope: an error in one module does not stop
-- the others from loading. Keep it that way -- don't inline these.

require("conf.monitors")
require("conf.env")
require("conf.look")
require("conf.input")
require("conf.binds")
require("conf.rules")
require("conf.autostart")
