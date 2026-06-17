return {
animations = { enabled = false },

decoration = { blur = { enabled = false },
},

dwindle = {
    default_split_ratio = 1,
    force_split = 2,
    special_scale_factor = 0.6,
},

general = {
    allow_tearing = false,
    border_size = 1,
    col = {
        active_border = { colors = { "rgba(ff4500ee)", "rgba(ff6347ee)" }, angle = 135 },
        inactive_border = "rgba(59595966)",
    },
    gaps_in = 0,
    gaps_out = 0,
    snap = { enabled = 1 },
},

group = {
    groupbar = {
        col = {
            active = { colors = { "rgba(ff450099)", "rgba(ff634799)" }, angle = 135 },
            inactive = "rgba(2a1c1088)",
            locked_active = "rgba(dd66eecc)",
            locked_inactive = "rgba(dd66ee66)",
        },
        gaps_in = 0,
        gaps_out = 0,
        indicator_gap = 0,
        indicator_height = 6,
        render_titles = false,
        rounding = 0,
        scrolling = false,
    },
    col = {
        border_active = { colors = { "rgba(ff4500cc)", "rgba(ff6347cc)" }, angle = 135 },
        border_inactive = "rgba(59595988)",
        border_locked_active = "rgba(dd66eecc)",
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
},

xwayland = { enabled = true },

binds = { allow_pin_fullscreen = true },
}
