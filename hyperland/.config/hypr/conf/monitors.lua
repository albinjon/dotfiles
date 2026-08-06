-- -----------------------------------------------------
-- Monitors
-- https://wiki.hypr.land/Configuring/Basics/Monitors/
-- -----------------------------------------------------

hl.monitor({
    output   = "DP-1",
    mode     = "preferred",
    position = "auto",
    scale    = 1.666667,
})

-- Kept alongside the monitor scale it compensates for.
hl.env("GDK_SCALE", "1.75")

hl.config({
    xwayland = {
        force_zero_scaling = true,
    },
})
