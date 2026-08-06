-- -----------------------------------------------------
-- Environment variables & driver workarounds
-- https://wiki.hypr.land/Nvidia/
-- -----------------------------------------------------

hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("GBM_BACKEND", "nvidia-drm")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("NVD_BACKEND", "direct")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

hl.config({
    cursor = {
        no_hardware_cursors = true,
    },

    ecosystem = {
        no_donation_nag = true,
    },
})

-- -----------------------------------------------------
-- Electron / IntelliJ flickering workarounds
--
-- debug.damage_tracking = 0 used to be set here. It disables damage tracking
-- entirely and forces a full redraw every frame, at significant performance
-- cost; the NVIDIA driver bugs it worked around have largely been fixed. If
-- flickering returns in Electron apps, re-add it before touching anything else.
-- -----------------------------------------------------

hl.config({
    opengl = {
        nvidia_anti_flicker = false,
    },

    debug = {
        vfr = false, -- was misc:vfr in the old config; that key does not exist
    },
})
