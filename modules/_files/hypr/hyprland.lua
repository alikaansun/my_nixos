local mainMod = "SUPER"
local msg = "noctalia msg "

-- Global so the generated host.lua can use it.
configHome = os.getenv("XDG_CONFIG_HOME") or (os.getenv("HOME") .. "/.config")

-- host.lua is generated per machine; the test window writes its own.
local hostConfig = configHome .. "/hypr/host.lua"
if io.open(hostConfig) then dofile(hostConfig) end

hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("GTK_THEME", "Adwaita:dark")

hl.config({
    general = {
        gaps_in = 6,
        gaps_out = 2,
        border_size = 2,
        layout = "dwindle",
        allow_tearing = true,
        col = { active_border = "rgb(7e9cd8)", inactive_border = "rgb(363646)" },
    },
    decoration = { rounding = 0, blur = { enabled = false }, shadow = { enabled = false } },
    animations = { enabled = false },
    input = { kb_layout = "us,tr", follow_mouse = 1 },
    misc = { vrr = 2, disable_hyprland_logo = true, force_default_wallpaper = 0 },
    ecosystem = { no_update_news = true, no_donation_nag = true },
})

local directions = { I = "up", J = "left", K = "down", L = "right" }
local resize = { I = { 0, -40 }, J = { -40, 0 }, K = { 0, 40 }, L = { 40, 0 } }
for key, direction in pairs(directions) do
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ direction = direction }))
    hl.bind(mainMod .. " + CTRL + " .. key, hl.dsp.window.move({ direction = direction }))
    hl.bind(mainMod .. " + ALT + " .. key, hl.dsp.window.resize({ x = resize[key][1], y = resize[key][2], relative = true }), { repeating = true })
end

local workspaces = { ["1"] = "1", ["2"] = "2", ["3"] = "3", ["4"] = "4", ["5"] = "5", M = "name:m" }
for key, workspace in pairs(workspaces) do
    hl.workspace_rule({ workspace = workspace, persistent = true })
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = workspace }))
    hl.bind(mainMod .. " + CTRL + " .. key, hl.dsp.window.move({ workspace = workspace }))
end

-- Keycodes rather than comma, period and backtick so these survive the tr layout.
local comma, period, grave = "code:59", "code:60", "code:49"
hl.bind(mainMod .. " + " .. comma, hl.dsp.focus({ monitor = "-1" }))
hl.bind(mainMod .. " + " .. period, hl.dsp.focus({ monitor = "+1" }))
hl.bind(mainMod .. " + CTRL + " .. comma, hl.dsp.window.move({ monitor = "-1" }))
hl.bind(mainMod .. " + CTRL + " .. period, hl.dsp.window.move({ monitor = "+1" }))

hl.bind(mainMod .. " + W", hl.dsp.window.close())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + H", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("ghostty"))
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd("brave"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("dolphin"))
for key, command in pairs({ V = "code", D = "discord", O = "obsidian", K = "keepassxc --config " .. configHome .. "/keepassxc/hyprland.ini", M = "spotify", S = "steam" }) do
    hl.bind("CTRL + ALT + " .. key, hl.dsp.exec_cmd(command))
end

hl.bind(mainMod .. " + Tab", hl.dsp.exec_cmd(msg .. "window-switcher hold"))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(msg .. "panel-toggle launcher"))
hl.bind(mainMod .. " + " .. grave, hl.dsp.exec_cmd(msg .. "panel-toggle launcher /session"))
hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd(msg .. "panel-toggle launcher /session"))
hl.bind(mainMod .. " + SHIFT + " .. grave, hl.dsp.exec_cmd(msg .. "session lock"))
hl.bind(mainMod .. " + SHIFT + Escape", hl.dsp.exec_cmd(msg .. "session lock"))
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd(msg .. "panel-toggle control-center"))
hl.bind(mainMod .. " + CTRL + S", hl.dsp.exec_cmd(msg .. "settings-toggle"))
hl.bind(mainMod .. " + CTRL + D", hl.dsp.exec_cmd("hypr-desktop-menu"))
hl.bind(mainMod .. " + ALT + H", hl.dsp.exec_cmd("hypr-keybind-help"))
hl.bind(mainMod .. " + O", hl.dsp.exec_cmd(msg .. "notification-dnd-toggle && " .. msg .. "caffeine-toggle"))
hl.bind(mainMod .. " + CTRL + A", hl.dsp.exec_cmd(msg .. "annotate"))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd(msg .. "notification-clear-active"))
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd(msg .. "notification-dnd-toggle"))
hl.bind(mainMod .. " + CTRL + V", hl.dsp.exec_cmd(msg .. "panel-toggle clipboard"))
hl.bind(mainMod .. " + CTRL + E", hl.dsp.exec_cmd(msg .. "panel-toggle launcher /emo"))
hl.bind("Print", hl.dsp.exec_cmd(msg .. "screenshot-region --annotate"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd(msg .. "screenshot-region --annotate"))
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("hypr-record-toggle"))
hl.bind(mainMod .. " + ALT + Space", hl.dsp.exec_cmd("hyprctl switchxkblayout all next"))

-- Ghostty's Shift+Insert pastes the selection rather than the clipboard.
local function clipboardBind(key, mods, code, ghosttyKey)
    hl.bind(mainMod .. " + " .. key, function()
        local window = hl.get_active_window()
        if window and window.class == "com.mitchellh.ghostty" and ghosttyKey then
            hl.dispatch(hl.dsp.send_shortcut({ mods = "CTRL SHIFT", key = ghosttyKey, window = "activewindow" }))
        else
            hl.dispatch(hl.dsp.send_shortcut({ mods = mods, key = code, window = "activewindow" }))
        end
    end)
end
clipboardBind("C", "CTRL", "Insert", "C")
clipboardBind("V", "SHIFT", "Insert", "V")
clipboardBind("X", "SHIFT", "Delete", nil)

local zoomed = false
hl.bind(mainMod .. " + CTRL + Z", function()
    zoomed = not zoomed
    hl.config({ cursor = { zoom_factor = zoomed and 2 or 1 } })
end)

for key, command in pairs({
    XF86AudioRaiseVolume = "volume-up",
    XF86AudioLowerVolume = "volume-down",
    XF86AudioMute = "volume-mute",
    XF86AudioMicMute = "mic-mute",
    XF86MonBrightnessUp = "brightness-up",
    XF86MonBrightnessDown = "brightness-down",
    XF86AudioPlay = "media toggle",
    XF86AudioPause = "media toggle",
    XF86AudioNext = "media next",
    XF86AudioPrev = "media previous",
}) do
    hl.bind(key, hl.dsp.exec_cmd(msg .. command), { locked = true })
end

local function assign(class, workspace)
    hl.window_rule({ name = "workspace-" .. class, match = { class = class }, workspace = workspace })
end
assign("^(brave-browser)$", "1")
assign("^(com.mitchellh.ghostty|code)$", "2")
assign("^(obsidian|zotero|Zotero)$", "3")
assign("^(steam)$", "4")
assign("^(spotify|Spotify|whatsapp.*|org.keepassxc.KeePassXC|discord)$", "name:m")

hl.window_rule({ name = "games-tear", match = { class = "^(steam_app_.*|gamescope)$" }, immediate = true })
hl.window_rule({ name = "games-workspace", match = { class = "^(steam_app_.*|gamescope)$" }, workspace = "4" })
hl.window_rule({ name = "suppress-maximize", match = { class = ".*" }, suppress_event = "maximize" })
