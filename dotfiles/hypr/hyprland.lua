hl.config(require("config"))

local mod = "SUPER"
local smod = mod .. " + SHIFT"
local scripts = "~/nix/scripts"
local volume = scripts .. "/volume-notif"
local screenshots = scripts .. "/screenshots"

local function bind_cmd(key, cmd, opts)
    hl.bind(key, hl.dsp.exec_cmd(cmd), opts)
end

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
    hl.exec_cmd(scripts .. "/network-notify")
    hl.exec_cmd(scripts .. "/dev/mpc_albums.py ~/Music/Sakuzyo/")
end)

-- Workspace Navigation
for ws, key in ipairs({ "1", "2", "3", "4", "F1", "F2", "F3", "F4", "Z" }) do
    hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = ws }))
    hl.bind(smod .. " + " .. key, hl.dsp.window.move({ workspace = ws }))
end

-- Window Navigation
for key, dir in pairs({ h = "l", l = "r", k = "u", j = "d" }) do
    hl.bind(mod .. " + " .. key, hl.dsp.focus({ direction = dir }))
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

-- Commands
bind_cmd("MOD5 + p", "mpc toggle && ~/nix/scripts/song_notify")
bind_cmd("MOD5 + Up", volume .. " up", { repeating = true })
bind_cmd("MOD5 + Down", volume .. " down", { repeating = true })
bind_cmd("MOD5 + Delete", volume .. " mute")
bind_cmd(mod .. " + Delete", volume .. " mute-mic")

bind_cmd("Print", screenshots .. "/screen")
bind_cmd(mod .. " + Print", screenshots .. "/area")

bind_cmd(mod .. " + CONTROL + F12", scripts .. "/shutdown-delay")
bind_cmd("KP_Down", [[notify-send -u low -r 9997 -t 1150 "<b>$(date '+%H:%M')</b>"]])
bind_cmd(mod .. " + q", "foot")
bind_cmd(mod .. " + r", "fuzzel")

-- Special workspaces
hl.workspace_rule({ workspace = "special:mail", on_created_empty = "foot --app-id=neomutt neomutt" })
hl.workspace_rule({ workspace = "special:openfile", on_created_empty = "foot --app-id=openfile open_file" })
hl.bind("KP_End", hl.dsp.workspace.toggle_special("mail"))
hl.bind(mod .. " + o", hl.dsp.workspace.toggle_special("openfile"))

-- Window rules
for class, ws in pairs({
    firefox = 1,
    ["org.pwmt.zathura"] = 2,
    geogebra = 3,
}) do
    hl.window_rule({
        match = { class = class },
        workspace = tostring(ws),
    })
end

hl.window_rule({ match = { class = "libreoffice.*" }, suppress_event = "maximize" })
hl.window_rule({ match = { class = "foot" }, group = "override barred" })
hl.window_rule({ match = { class = "^org.octave.Octave", title = "^Figure.*" }, workspace = 5 })
