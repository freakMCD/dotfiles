hl.config(require("config"))

local mod = "SUPER"
local smod = mod .. " + SHIFT"
local scripts = "~/nix/scripts"
local volume = scripts .. "/volume-notif"
local screenshots = scripts .. "/screenshots"

-- Environment
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("HYPRLAND_NO_SD_NOTIFY", "1")
hl.env("HYPRCURSOR_THEME", "Future-Cyan-Hyprcursor_Theme")
hl.env("HYPRCURSOR_SIZE", "32")
hl.env("XCURSOR_SIZE", "16")
hl.env("LD_LIBRARY_PATH", "/etc/sane-libs")

-- Autostart
hl.on("hyprland.start", function()
    hl.exec_cmd("fnott")
    hl.exec_cmd("udiskie")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("mpc clear && mpc add \"ES Brother\" \"ES Sister\" && mpc random on")
    hl.exec_cmd(scripts .. "/network-notify")
end)

-- Workspace Navigation
for ws, key in ipairs({ "1", "2", "3", "4", "F1", "F2", "F3", "F4", "Z" }) do
    hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = ws }))
    hl.bind(smod .. " + " .. key, hl.dsp.window.move({ workspace = ws }))
end

-- Window Navigation
for key, dir in pairs({ h = "l", l = "r", k = "u", j = "d" }) do
    hl.bind(mod  .. " + " .. key, hl.dsp.focus({ direction = dir }))
    hl.bind(smod .. " + " .. key, hl.dsp.window.move({ direction = dir }))
end

-- Window Actions
hl.bind(mod .. " + f", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(mod .. " + Space", hl.dsp.window.float({ action = "toggle" }))
hl.bind(smod .. " + c", hl.dsp.window.close())
hl.bind(mod .. " + U", hl.dsp.window.move({ out_of_group = true }))
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag())
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize())

-- Group Actions
hl.bind(mod .. " + TAB", hl.dsp.group.next())
hl.bind(smod .. " + TAB", hl.dsp.group.prev())
hl.bind(mod .. " + grave", hl.dsp.group.toggle())
hl.bind(smod .. " + Y", hl.dsp.group.lock_active({ action = "toggle" }))

-- Misc
hl.bind("MOD5 + Up", hl.dsp.exec_cmd(volume .. " up"), { repeating = true })
hl.bind("MOD5 + Down", hl.dsp.exec_cmd(volume .. " down"), { repeating = true })
hl.bind("MOD5 + Delete", hl.dsp.exec_cmd(volume .. " mute"))
hl.bind(mod .. " + Delete", hl.dsp.exec_cmd(volume .. " mute-mic"))

hl.bind("Print", hl.dsp.exec_cmd(screenshots .. "/screen"))
hl.bind(mod .. " + Print", hl.dsp.exec_cmd(screenshots .. "/area"))

hl.bind(mod .. " + CONTROL + F12", hl.dsp.exec_cmd(scripts .. "/shutdown-delay"))
hl.bind("KP_Down", hl.dsp.exec_cmd(scripts .. "/toggle-clock"))

hl.bind(mod .. " + q", hl.dsp.exec_cmd("foot"))
hl.bind(mod .. " + r", hl.dsp.exec_cmd("fuzzel"))
hl.bind("MOD5 + P", hl.dsp.exec_cmd("mpc toggle"))
hl.bind("KP_Next", hl.dsp.exec_cmd("notify-send -r 9999 -t 1250 \"Now Playing\" \"$(mpc current)\""))

-- Special workspaces
hl.workspace_rule({ workspace = "special:mail", on_created_empty = "foot --app-id=neomutt neomutt" })
hl.workspace_rule({ workspace = "special:openfile", on_created_empty = "foot --app-id=openfile open_file" })
hl.bind("KP_End", hl.dsp.workspace.toggle_special("mail"))
hl.bind(mod .. " + o", hl.dsp.workspace.toggle_special("openfile"))

-- Window rules
for class, ws in pairs({
    ["org.pwmt.zathura"] = 1,
    firefox = 2,
    geogebra = 3,
}) do
    hl.window_rule({
        match = { class = class },
        workspace = tostring(ws),
    })
end

hl.window_rule({ match = { class = "libreoffice.*" }, suppress_event = "maximize" })
hl.window_rule({ match = { class = "foot" }, group = "override barred" })
hl.window_rule({
    match = { class = "conky" },
    float = true,
    pin = true,
    border_size = 0,
    no_focus = true,
    no_shadow = true,
})


