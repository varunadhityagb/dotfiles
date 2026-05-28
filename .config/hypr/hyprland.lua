hl.env("XCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_PLUGIN_PATH", "/usr/lib/qt6/plugins")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")
hl.env("OZONE_PLATFORM", "wayland")
hl.env("LD_LIBRARY_PATH", "/usr/lib:/usr/lib64:/usr/local/lib:/usr/local/lib64")
hl.env("GTK_IM_MODULE", "fcitx")
hl.env("QT_IM_MODULE", "fcitx")
hl.env("XMODIFIERS", "@im=fcitx")
hl.env("MESA_LOADER_DRIVER_OVERRIDE", "iris")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_QPA_PLATFORMTHEME_QT5", "qt5ct")
hl.env("QML2_IMPORT_PATH", " /usr/lib/qt6/qml")
hl.env("QT_QPA_PLATFORM_PLUGIN_PATH", "/usr/lib/qt/plugins/platforms")
hl.env("GTK_USE_PORTAL", "1")
hl.env("GDK_DEBUG", "portals")
hl.env("QML_IMPORT_PATH", "/usr/lib/qt6/qml")
hl.env("QML2_IMPORT_PATH", "/usr/lib/qt6/qml")

local terminal = "ghostty"
local fileManager = "thunar"
local menu =  [[rofi -kb-element-prev "Ctrl+[45]" -kb-element-next "Ctrl+[44]" -kb-mode-previous "Ctrl+[43]" -kb-mode-next "Ctrl+[46]"]]
local browser = [[brave --enable-features=UseOzonePlatform,TouchpadOverscrollHistoryNavigation --ozone-platform=wayland --disable-features=WaylandWpColorManagerV1]]
local mainMod = "SUPER"

require("shader")
require("monitors")

hl.on("hyprland.start", function()
        hl.exec_cmd(terminal)
        hl.exec_cmd("bash /home/varunadhityagb/.config/hypr/scripts/open_whatsapp")
        hl.exec_cmd("bash /usr/bin/screen_timer start ")
        hl.exec_cmd("bash /home/varunadhityagb/.local/bin/wellbeing on")
        hl.exec_cmd("waybar")
        hl.exec_cmd("emacs --daemon")
        hl.exec_cmd("cliphist wipe")
        hl.exec_cmd("awww-daemon")
        hl.exec_cmd("hypridle")
        hl.exec_cmd("avizo-service")
        hl.exec_cmd("/usr/bin/clipse -clear")
        hl.exec_cmd("/usr/bin/clipse -listen")
        hl.exec_cmd("syncthing --gui-address=0.0.0.0:8384 --no-browser")
        hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
        hl.exec_cmd("swaync")
        hl.exec_cmd("kdeconnect-indicator")
        hl.exec_cmd("kdeconnectd")
        hl.exec_cmd("bash wayscriber --no-tray -d")
        hl.exec_cmd("qs -c overview")
        hl.exec_cmd([[bash -c 'socat -u UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - | while read -r line; do pkill -RTMIN+8 waybar; done']])
        hl.exec_cmd("matugen image /home/varunadhityagb/Downloads/trees_and_bushes.jpg")
end)

local colors = require("colors")

hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 5,
        border_size = 3,
        resize_on_border = true,
        allow_tearing = false,
        col = {
          active_border = colors.primary,
        },
        layout = "dwindle"
    },

    decoration = {
        rounding = 10,
        rounding_power = 2,
        blur = {
            enabled = true,
            size = 6,
            passes = 4,
            ignore_opacity = true,
            new_optimizations = true,
            popups = true,
            popups_ignorealpha = 0.1,
        },
    },

    animations =  {
        enabled = true,
    },
})

hl.curve("elastic", { type = "bezier", points = { {0.68, -0.55}, {0.265, 1.55} } })
hl.curve("smooth",  { type = "bezier", points = { {0.25, 0.46},  {0.45, 0.94}  } })
hl.curve("snappy",  { type = "bezier", points = { {0.23, 1},     {0.32, 1}     } })
hl.curve("easeOut", { type = "bezier", points = { {0.16, 1},     {0.3, 1}      } })

hl.curve("easy",           { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })
hl.curve("hobbyist",       { type = "spring", mass = 1, stiffness = 40, dampening = 6 } )
hl.curve("cat",            { type = "spring", mass = 1, stiffness = 30, dampening = 6 } )

-- Windows
hl.animation({ leaf = "windows",       enabled = true,  speed = 10,    spring = "hobbyist",        style = "popin" })
hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 10,    spring = "easy",        style = "popin" })
hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 10,    spring = "hobbyist",        style = "popin bottom" })
hl.animation({ leaf = "windowsMove",   enabled = true,  speed = 10,    spring = "hobbyist" })

-- Fades
hl.animation({ leaf = "fade",              enabled = true, speed = 4, bezier = "smooth" })
hl.animation({ leaf = "fadeIn",            enabled = true, speed = 3, bezier = "smooth" })
hl.animation({ leaf = "fadeOut",           enabled = true, speed = 3, bezier = "smooth" })
hl.animation({ leaf = "fadeDim",           enabled = true, speed = 4, bezier = "smooth" })

-- Workspaces
hl.animation({ leaf = "workspaces",    enabled = true,  speed = 12,    spring = "hobbyist",     style = "slide" })
hl.animation({ leaf = "workspacesIn",  enabled = true,  speed = 12,    spring = "hobbyist",     style = "slide" })
hl.animation({ leaf = "workspacesOut", enabled = true,  speed = 12,    spring = "hobbyist",     style = "slide" })
hl.animation({ leaf = "specialWorkspace",  enabled = true, speed = 4,  spring = "hobbyist",     style = "slidefadevert" })

-- Layers
hl.animation({ leaf = "layers",            enabled = true, speed = 3, bezier = "snappy",   style = "slide" })
hl.animation({ leaf = "layersIn",          enabled = true, speed = 3, bezier = "snappy",   style = "slide" })
hl.animation({ leaf = "layersOut",         enabled = true, speed = 2, bezier = "smooth",   style = "fade" })


hl.config({
    dwindle = {
      force_split = 2,
      preserve_split = true,
    },

    master = {
        new_status = master,
        new_on_top = true,
    },

    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo = true,
        on_focus_under_fullscreen = 2,
        vrr = 2,
        animate_manual_resizes = true,
    },

    binds = {
        workspace_back_and_forth = true,
        hide_special_on_workspace_change = true,
    },

    cursor = {
        hide_on_key_press = true,
    },

})

hl.config({
    input = {
        kb_layout = us,
        kb_options = "caps:escape_shifted_capslock",
        follow_mouse = 1,
        sensitivity = 0,
        scroll_button = 108,

        touchpad = {
            natural_scroll = true,
            clickfinger_behavior = true,
            disable_while_typing = true,
        },
    },
})



hl.window_rule({
  name = "windowrule-1",
  float = true,
  stay_focused = true,
  size = { 802, 537 },
  match = { class = "^(qalculate-gtk)$" },
})

hl.window_rule({
  name = "windowrule-2",
  float = true,
  stay_focused = true,
  match = { title = "(Peek preview)" },
})

hl.window_rule({
  name = "windowrule-3",
  float = true,
  pin = true,
  move = { 1125, 625 },
  size = { "monitor_w*0.4", "monitor_h*0.4" },
  match = { initial_title = "(Picture in picture|Picture-in-Picture)" },
})

hl.window_rule({
  name = "windowrule-4",
  idle_inhibit = "fullscreen",
  suppress_event = "maximize",
  match = { class = ".*" },
})

hl.window_rule({
  name = "windowrule-5",
  float = true,
  stay_focused = true,
  match = { class = "(brave-nngceckbapebfimnlniiiahkandclblb-Default)" },
})

hl.window_rule({
  name = "windowrule-6",
  workspace = 1,
  match = { class = "(emacs)" },
})

hl.window_rule({
  name = "windowrule-7",
  workspace = 1,
  match = { class = "(code)" },
})

hl.window_rule({
  name = "windowrule-8",
  workspace = 1,
  match = { class = "(DBeaver)" },
})

hl.window_rule({
  name = "windowrule-9",
  workspace = 3,
  match = { class = "^(?i)brave-.*" },
})

hl.window_rule({
  name = "windowrule-10",
  workspace = 2,
  match = { class = "(org.pwmt.zathura)" },
})

hl.window_rule({
  name = "windowrule-11",
  workspace = 5,
  match = { initial_title = "(hotstar.com_/)" },
})

hl.window_rule({
  name = "windowrule-12",
  workspace = 4,
  match = { initial_title = "(web.whatsapp.com_/)" },
})

hl.window_rule({
  name = "windowrule-13",
  workspace = 4,
  match = { initial_title = "(teams.microsoft.com_/)" },
})

hl.window_rule({
  name = "windowrule-14",
  workspace = 4,
  match = { initial_title = "(Mozilla Thunderbird)" },
})

hl.window_rule({
  name = "windowrule-15",
  workspace = 5,
  match = { initial_title = "(youtube.com_/)" },
})

hl.window_rule({
  name = "windowrule-16",
  workspace = 5,
  match = { class = "(spotify)" },
})

hl.window_rule({
  name = "windowrule-17",
  float = true,
  center = true,
  stay_focused = true,
  size = { 800, 600 },
  match = {
    class = "^(blueberry.py|pavucontrol|Wiremix|clipse)$",
  },
})

hl.window_rule({
  name = "windowrule-18",
  float = true,
  center = true,
  stay_focused = true,
  match = {
    class = "xdg-desktop-portal-gtk",
    title = "^(Open.*Files?|Save.*Files?|All Files|Save)",
  },
})

hl.window_rule({
  name = "windowrule-19",
  float = true,
  center = true,
  stay_focused = true,
  match = {
    title = "(.*wants to save)$",
  },
})

hl.window_rule({
  name = "windowrule-20",
  float = true,
  center = true,
  stay_focused = true,
  match = {
    title = "(.*wants to open)$",
  },
})

hl.window_rule({
  name = "windowrule-21",
  float = true,
  stay_focused = true,
  match = {
    title = "^(Rename.*)",
  },
})

hl.window_rule({
  name = "windowrule-22",
  float = true,
  stay_focused = true,
  match = {
    class = "(java)",
    title = "(Dbeaver)",
  },
})

hl.window_rule({
  name = "windowrule-23",
  float = true,
  center = true,
  match = {
    title = "(File Operation Progress)",
  },
})

hl.window_rule({
  name = "windowrule-24",
  float = true,
  size = { 393, 871 },
  move = { 460, 75 },
  match = {
    title = "(I2223)",
  },
})

hl.window_rule({
  name = "windowrule-25",
  float = true,
  center = true,
  size = { 900, 600 },
  border_color = "rgb(89b4fa)",
  animation = "popin",
  match = {
    class = "^(kitty-updates)$",
  },
})

hl.window_rule({
  name = "windowrule-26",
  float = true,
  workspace = "special:m1",
  size = { 540, 960 },
  match = {
    class = "(\\b(Waydroid|waydroid.*)\\b)",
  },
})

hl.window_rule({
  name = "windowrule-27",
  workspace = 4,
  match = {
    class = "discord",
  },
})

hl.window_rule({
  name = "windowrule-28",
  float = true,
  center = true,
  size = { 1000, 650 },
  animation = "popin",
  match = {
    class = "^(file_chooser)$",
  },
})

hl.layer_rule({
  name = "layerrule-1",
  animation = "popin",
  blur = true,
  match = { namespace = "rofi" },
})

hl.layer_rule({
  name = "layerrule-2",
  animation = "popin",
  blur = true,
  match = { namespace = "avizo" },
})

hl.layer_rule({
  name = "layerrule-3",
  animation = "slide top",
  blur = true,
  blur_popups = true,
  match = { namespace = "waybar" },
})

hl.layer_rule({
  name = "layerrule-4",
  animation = "slide top",
  blur = true,
  match = { namespace = "fabric" },
})

hl.layer_rule({
  name = "layerrule-5",
  animation = "slide top",
  blur = true,
  match = { namespace = "swaync-control-center" },
})

hl.layer_rule({
  name = "layerrule-6",
  blur = true,
  ignore_alpha = 0,
  animation = "slide top",
  match = { namespace = "swaync-notification-window" },
})

hl.layer_rule({
  name = "layerrule-7",
  blur = true,
  match = { namespace = "kitty" },
})

hl.layer_rule({
  name = "layerrule-8",
  blur = true,
  ignore_alpha = 0,
  xray = 0,
  match = { namespace = "wofi" },
})

hl.layer_rule({
  name = "layerrule-9",
  no_anim = true,
  match = { namespace = "hyprpicker" },
})

hl.layer_rule({
  name = "layerrule-10",
  no_anim = true,
  match = { namespace = "selection" },
})

hl.workspace_rule({ workspace = "1", layout = "scrolling" })
hl.workspace_rule({ workspace = "2", layout = "monocle" })
hl.workspace_rule({ workspace = "4", layout = "monocle" })

hl.bind(mainMod .. " + R", hl.dsp.submap("apps"))
hl.define_submap("apps", function()

    hl.bind("W", hl.dsp.exec_cmd("~/dotfiles/.config/hypr/scripts/open_whatsapp"))
    hl.bind("T", hl.dsp.exec_cmd(browser .. " --app=https://teams.microsoft.com/"))
    hl.bind("I", hl.dsp.exec_cmd(browser .. " --app=https://instagram.com/"))
    hl.bind("D", hl.dsp.exec_cmd("discord"))
    hl.bind("M", hl.dsp.exec_cmd("thunderbird"))
    hl.bind("F", hl.dsp.exec_cmd("~/dotfiles/.config/hypr/scripts/quickFiles"))
    hl.bind("2", hl.dsp.exec_cmd([[bash -c "2fa | rofi -kb-element-prev 'Ctrl+[45]' -kb-element-next 'Ctrl+[44]' -kb-mode-previous 'Ctrl+[43]' -kb-mode-next 'Ctrl+[46]' -dmenu | awk '{print \$1}' | xargs wl-copy"]]))


    hl.define_submap("files", "reset", function()
        hl.bind("E", hl.dsp.exec_cmd([[emacsclient -c -F "((title . \"emacs-dired\"))" -e "(dired \"~\")"]]))
        hl.bind("D", hl.dsp.exec_cmd([[emacsclient -c -F "((title . \"emacs-dired\"))" -e "(dired \"~/Downloads\")"]]))
        hl.bind("S", hl.dsp.exec_cmd([[emacsclient -c -F "((title . \"emacs-dired\"))" -e "(dired \"~/Syncthing/College/Sem5\")"]]))
        hl.bind("catchall", hl.dsp.submap("reset"))
    end)

    hl.define_submap("screen", function()
        hl.bind("SHIFT + R", hl.dsp.exec_cmd("~/dotfiles/.config/hypr/scripts/screenRotate 0"))
        hl.bind("R", hl.dsp.exec_cmd("~/dotfiles/.config/hypr/scripts/screenRotate 1"))
        hl.bind("S", hl.dsp.exec_cmd("~/dotfiles/.config/hypr/scripts/shaders-rofi"))
        hl.bind("L", hl.dsp.window.resize({ x = 10, y = 0, relative = false}), { repeating = true })
        hl.bind("H", hl.dsp.window.resize({ x = -10, y = 0, relative = false}), { repeating = true })
        hl.bind("K", hl.dsp.window.resize({ x = 0, y = 10, relative = false}), { repeating = true })
        hl.bind("J", hl.dsp.window.resize({ x = 0, y = -10, relative = false}), { repeating = true })
        hl.bind("M", hl.dsp.workspace.swap_monitors({ monitor1 = "eDP-1", monitor2 = "HDMI-A-1"}))
        hl.bind("escape", hl.dsp.submap("reset"))
    end)



    hl.bind("E", hl.dsp.submap("files"))

    hl.bind("S", hl.dsp.submap("screen"))

    hl.bind("catchall", hl.dsp.submap("reset"))
end)

hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd(browser .. " --incognito"))
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd("emacsclient -c -a ''"))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("pkill -SIGUSR1 wayscriber"))
hl.bind(mainMod .. " + SHIFT + D", hl.dsp.exec_cmd("~/dotfiles/.config/hypr/scripts/define"))

hl.bind(mainMod .. " + M", hl.dsp.submap("media"))
hl.define_submap("media", function()
    hl.bind("K", hl.dsp.exec_cmd("wpctl set-volume -l 2 @DEFAULT_AUDIO_SINK@ 5%+ && ~/dotfiles/.config/hypr/scripts/volume_notify"), { repeating = true })
    hl.bind("J", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && ~/dotfiles/.config/hypr/scripts/volume_notify"), { repeating = true })
    hl.bind("L", hl.dsp.exec_cmd("playerctl next"))
    hl.bind("H", hl.dsp.exec_cmd("playerctl previous"))
    hl.bind("P", hl.dsp.exec_cmd("playerctl play-pause"))
    hl.define_submap("media_apps", "reset", function()
        hl.bind("S", hl.dsp.exec_cmd("flatpak run com.spotify.Client"))
        hl.bind("Y", hl.dsp.exec_cmd(browser .. " --app=https://youtube.com/"))
        hl.bind("H", hl.dsp.exec_cmd(browser .. " --app=https://hotstar.com/"))
        hl.bind("P", hl.dsp.exec_cmd(browser .. " --app=https://primevideo.com/"))
        hl.bind("N", hl.dsp.exec_cmd(browser .. " --app=https://netflix.com/"))
        hl.bind("catchall", hl.dsp.submap("reset"))
    end)
    hl.bind("A", hl.dsp.submap("media_apps"))
    hl.bind("catchall", hl.dsp.submap("reset"))
end)

hl.bind(mainMod .. " + ALT + N", hl.dsp.submap("nobinds"))
hl.define_submap("nobinds", function()
    hl.bind(mainMod .. " + ALT + code:66", hl.dsp.submap("reset"))
end)

hl.bind(mainMod .. " + S", hl.dsp.submap("homeserver"))
hl.define_submap("homeserver", "reset", function()
    hl.bind("Return", hl.dsp.exec_cmd(terminal .. " -e ssh varunadhityagb@100.70.52.122"))
    hl.bind("E", hl.dsp.exec_cmd([[emacsclient -c -F "((title . \"emacs-dired\"))" -e "(dired \"/sftp:100.70.52.122:~\")"]]))
    hl.bind("D", hl.dsp.exec_cmd([[emacsclient -c -F "((title . \"emacs-dired\"))" -e "(dired \"/sftp:100.70.52.122:~/Downloads\")"]]))
    hl.bind("S", hl.dsp.exec_cmd([[emacsclient -c -F "((title . \"emacs-dired\"))" -e "(dired \"/sudo:root@100.70.52.122:~/Syncthing/College/Sem5\")"]]))
    hl.bind("code:9", hl.dsp.exec_cmd(terminal .. " -e ssh -t varunadhityagb@100.70.52.122 btop"))
    hl.bind("catchall", hl.dsp.submap("reset"))
end)

-- window management
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + W", hl.dsp.window.close())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle"}))
hl.bind(mainMod .. " + period", hl.dsp.layout("cyclenext"))
hl.bind(mainMod .. " + TAB", hl.dsp.exec_cmd("qs ipc -c overview call overview toggle"))
hl.bind("ALT + tab", hl.dsp.window.cycle_next())

-- applications
hl.bind("ALT + space", hl.dsp.exec_cmd(menu .. " -show drun -sort false"))

-- misc
hl.bind("ALT + F9", hl.dsp.exec_cmd("~/dotfiles/.config/hypr/scripts/vigil"))
hl.bind("SHIFT + F9", hl.dsp.exec_cmd("~/dotfiles/.config/hypr/scripts/hyprsunset"))
hl.bind("SUPER + P", hl.dsp.exec_cmd("~/dotfiles/.config/hypr/scripts/project"))
hl.bind("SUPER + code:9", hl.dsp.exec_cmd(terminal .. " -e btop"))
hl.bind("SUPER + N", hl.dsp.exec_cmd("swaync-client -t"))
hl.bind("ALT + N", hl.dsp.exec_cmd("/home/varunadhityagb/dotfiles/.config/hypr/scripts/dnd-toggle.sh"))

hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd("~/dotfiles/.config/hypr/scripts/zen"))
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd("hyprpicker | tr -d '\n' | wl-copy"))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("kitty -o background_opacity=0.9 --class clipse -e 'clipse'"))

-- Screenshot & Screen Record
hl.bind(mainMod .. " + PRINT", hl.dsp.exec_cmd("~/dotfiles/.config/hypr/scripts/screenshot window copy"))
hl.bind(mainMod .. " + SHIFT + PRINT", hl.dsp.exec_cmd("~/dotfiles/.config/hypr/scripts/screenshot region save"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("~/dotfiles/.config/hypr/scripts/screenshot region copy"))
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("~/dotfiles/.config/hypr/scripts/screenrecord"))
hl.bind(mainMod .. " + SHIFT + O", hl.dsp.exec_cmd([[grim -g "$(slurp)" - | tesseract stdin stdout -l eng+osd --psm 6 | wl-copy]]))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd([[bash -c "~/dotfiles/.config/hypr/scripts/screensend"]])
)

hl.bind(mainMod .. " + H",             hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L",             hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K",             hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J",             hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + SHIFT + H",     hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + L",     hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + K",     hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + J",     hl.dsp.window.move({ direction = "d" }))


for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i}))
    hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
end


-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + A",          hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + A",  hl.dsp.window.move({ workspace = "special:magic" }))

hl.bind(mainMod .. " + T", function()
    local active = hl.get_active_window()

    if active and active.floating then
        hl.dispatch(hl.dsp.window.float({ action="toggle", window = "floating" }))
    else
        hl.dispatch(hl.dsp.window.float({ action="toggle", window = "tiled" }))
    end
end
)

hl.bind("XF86AudioRaiseVolume",   hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+ && ~/dotfiles/.config/hypr/scripts/volume_notify"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",   hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && ~/dotfiles/.config/hypr/scripts/volume_notify"),        { locked = true, repeating = true })
hl.bind("XF86AudioMute",          hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && ~/dotfiles/.config/hypr/scripts/volume_notify"),        { locked = true, repeating = false })
hl.bind("XF86AudioMicMute",       hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_SOURCE@ toggle && ~/dotfiles/.config/hypr/scripts/mic_notify"),      { locked = true, repeating = false })
hl.bind("XF86MonBrightnessUp",    hl.dsp.exec_cmd("brightnessctl s 5%+ && ~/dotfiles/.config/hypr/scripts/brightness_notify 0"),                            { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",  hl.dsp.exec_cmd("brightnessctl s 5%- && ~/dotfiles/.config/hypr/scripts/brightness_notify 0"),                            { locked = true, repeating = true })
hl.bind("SHIFT + XF86MonBrightnessUp",    hl.dsp.exec_cmd("ddcutil setvcp 10 + 5 --bus 3 && ~/dotfiles/.config/hypr/scripts/brightness_notify 1"),                            { locked = true, repeating = true })
hl.bind("SHIFT + XF86MonBrightnessDown",  hl.dsp.exec_cmd("ddcutil setvcp 10 - 5 --bus 3 && ~/dotfiles/.config/hypr/scripts/brightness_notify 1"),                            { locked = true, repeating = true })

hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),          { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl pause"),    { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play"),    { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),      { locked = true })

hl.bind("XF86PowerOff",  hl.dsp.exec_cmd("~/dotfiles/.config/rofi/powermenu.sh"), { locked = true })
hl.bind("ALT + XF86PowerOff",  hl.dsp.exec_cmd("brightnessctl set 1% && ~/dotfiles/.config/hypr/scripts/brightness_notify 0"), { locked = true })
hl.bind("ALT + SHIFT + XF86PowerOff",  hl.dsp.exec_cmd("ddcutil setvcp 10 0 --bus 3 && ~/dotfiles/.config/hypr/scripts/brightness_notify 1"), { locked = true })


hl.bind("CTRL + ALT + UP",   hl.dsp.exec_cmd("wpctl set-volume -l 2 @DEFAULT_AUDIO_SINK@ 5%+ && ~/dotfiles/.config/hypr/scripts/volume_notify"), { locked = true, repeating = true })
hl.bind("CTRL + ALT + DOWN",   hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && ~/dotfiles/.config/hypr/scripts/volume_notify"),        { locked = true, repeating = true })


hl.bind("CTRL + ALT + right",  hl.dsp.exec_cmd("playerctl next"),          { locked = true })
hl.bind("CTRL + ALT + left", hl.dsp.exec_cmd("playerctl previous"),    { locked = true })
hl.bind("CTRL + ALT + space",  hl.dsp.exec_cmd("playerctl play-pause"),      { locked = true })

hl.bind("CTRL + ALT + L", hl.dsp.exec_cmd("qs -c lockscreen"))


hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 3, direction = "vertical", mods = "SUPER", action = "float" })
hl.gesture({ fingers = 3, direction = "vertical", mods = "ALT", scale = 1.5, action = "fullscreen" })
hl.gesture({ fingers = 3, direction = "vertical", scale = 1.5, action = "fullscreen", mode = "maximize" })

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272",  hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273",  hl.dsp.window.resize(), { mouse = true })

-- zoom
-- bind = SUPER ctrl, mouse_down, exec, hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor | awk '/^float.*/ {print $2 * 1.1}')
-- bind = SUPER ctrl, mouse_up, exec, hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor | awk '/^float.*/ {print $2 * 0.9}')

-- #browser navigation
-- bind = ALT, mouse:272, exec, wtype -M alt -k left
-- bind = ALT, mouse:273, exec, wtype -M alt -k right
