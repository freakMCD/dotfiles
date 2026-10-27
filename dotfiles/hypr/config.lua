local red = "rgb(b83246)"
local patina = "rgb(5e7775)"
local dark_patina = "rgb(3e4e4d)"
local slate = "rgb(34363d)"

return {
    animations = {
        enabled = false,
    },

    decoration = {
        blur = {
            enabled = false,
        },
        shadow = {
            enabled = false,
        },
    },

    dwindle = {
        force_split = 2,
        special_scale_factor = 0.5,
    },

general = {
    border_size = 1,

    col = {
        active_border = red,
        inactive_border = slate,
    },

    gaps_in = 0,
    gaps_out = 0,
    snap = { enabled = true },
},

group = {
    groupbar = {
        col = {
            active = red,
            inactive = slate,
            locked_active = patina,
            locked_inactive = dark_patina,
        },

        indicator_height = 6,

        gaps_in = 6,
        gaps_out = 3,

        render_titles = false,
        keep_upper_gap = false,
        middle_click_close = false,
        scrolling = false,
    },

    col = {
        border_active = red,
        border_inactive = slate,
        border_locked_active = patina,
        border_locked_inactive = dark_patina,
    },

    merge_groups_on_drag = false,
    merge_groups_on_groupbar = false,
},

    input = {
        follow_mouse = 1,
        kb_layout = "us",
        kb_variant = "altgr-intl",
        mouse_refocus = false,
        sensitivity = 0.3,
    },

    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        enable_anr_dialog = false,
        middle_click_paste = false,
    },

    binds = {
        allow_pin_fullscreen = true,
    },
}
