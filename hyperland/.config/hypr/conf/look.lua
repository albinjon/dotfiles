-- -----------------------------------------------------
-- Look and feel
-- https://wiki.hypr.land/Configuring/Basics/Variables/
-- -----------------------------------------------------

hl.config({
    general = {
        gaps_in     = 6,
        gaps_out    = 12,
        border_size = 2,

        col = {
            active_border = "rgba(fab387ff)", -- was 0xfffab387 (ARGB)
        },

        resize_corner    = 3,
        resize_on_border = true,
        layout           = "dwindle",
    },

    decoration = {
        rounding = 10,

        active_opacity     = 1.0,
        inactive_opacity   = 0.8,
        fullscreen_opacity = 1.0,

        blur = {
            enabled           = true,
            size              = 6,
            passes            = 2,
            new_optimizations = true,
            ignore_opacity    = true,
            xray              = true,
        },
    },

    -- NOTE: dwindle:pseudotile was dropped upstream. Pseudotiling is now
    -- reached via the hl.dsp.window.pseudo() dispatcher instead.
    dwindle = {
        preserve_split = true,
    },

    misc = {
        background_color         = 0xff1e1e2e,
        disable_hyprland_logo    = true,
        disable_splash_rendering = true,
    },

    animations = {
        enabled = true,
    },
})

-- -----------------------------------------------------
-- Animations
-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
-- -----------------------------------------------------

hl.curve("myBezier", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })

-- NOTE: the wiki documents a `curve =` key, but the implementation requires
-- specifically `bezier =` or `spring =`. Use those.
hl.animation({ leaf = "windows",     enabled = true, speed = 7,  bezier = "myBezier" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 7,  bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border",      enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8,  bezier = "default" })
hl.animation({ leaf = "fade",        enabled = true, speed = 7,  bezier = "default" })
hl.animation({ leaf = "workspaces",  enabled = true, speed = 6,  bezier = "default" })
