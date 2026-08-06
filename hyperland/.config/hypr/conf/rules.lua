-- -----------------------------------------------------
-- Window rules
-- https://wiki.hypr.land/Configuring/Basics/Window-Rules/
--
-- NOTE: in the old rules.conf these were all nested inside a `general { }`
-- block, which is not valid -- window rules are top-level, not general:
-- sub-keys. They are un-nested here, so some of these may be taking effect
-- for the first time.
-- -----------------------------------------------------

hl.window_rule({ match = { class = "Spotify" }, workspace = "11" })
hl.window_rule({ match = { class = "kitty" },   workspace = "4" })
hl.window_rule({ match = { class = "Slack" },   workspace = "3" })
hl.window_rule({ match = { class = "zen" },     workspace = "1" })

-- Wiremix: small floating panel pinned to the top-right of the monitor.
hl.window_rule({
    name  = "wiremix-panel",
    match = { class = "Wiremix" },

    float = true,
    size  = {800, 420},
    move  = {"monitor_w-window_w-4", "monitor_h*0.04"}, -- was "100%-w-4 4%"
})

-- Fix flickering on floating JetBrains windows.
hl.window_rule({
    name  = "intellij-no-initial-focus",
    match = { class = "^jetbrains-.*", float = true },

    no_initial_focus = true,
})
