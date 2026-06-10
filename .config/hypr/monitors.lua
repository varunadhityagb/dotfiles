local ok, state = pcall(dofile, os.getenv("HOME") .. "/.config/hypr/state.lua")
if not ok or type(state) ~= "table" then
    state = {
        layout = "mult",
        monitors = {
            ["HDMI-A-1"] = { mode = "highress@highrr", scale = 1, transform = 0 },
            ["eDP-1"]    = { mode = "highress@highrr", scale = 1, transform = 0 },
        }
    }
end

local m = state.monitors
local layouts = {}

layouts.screen1 = function()
    hl.monitor({ output = "HDMI-A-1", disabled = true })
    hl.monitor({
        output    = "eDP-1",
        mode      = m["eDP-1"].mode,
        position  = "auto",
        scale     = m["eDP-1"].scale,
        transform = m["eDP-1"].transform,
    })
end

layouts.screen2 = function()
    hl.monitor({
        output    = "HDMI-A-1",
        mode      = m["HDMI-A-1"].mode,
        position  = "auto",
        scale     = m["HDMI-A-1"].scale,
        transform = m["HDMI-A-1"].transform,
    })
    hl.monitor({ output = "eDP-1", disabled = true })
end

layouts.mult = function()
    hl.monitor({
        output    = "HDMI-A-1",
        mode      = m["HDMI-A-1"].mode,
        position  = "auto-left",
        scale     = m["HDMI-A-1"].scale,
        transform = m["HDMI-A-1"].transform,
    })
    hl.monitor({
        output    = "eDP-1",
        mode      = m["eDP-1"].mode,
        position  = "auto",
        scale     = m["eDP-1"].scale,
        transform = m["eDP-1"].transform,
    })
end

layouts.mirror = function()
    hl.monitor({
        output    = "HDMI-A-1",
        mode      = m["HDMI-A-1"].mode,
        position  = "auto",
        scale     = m["HDMI-A-1"].scale,
        mirror    = "eDP-1",
        transform = m["HDMI-A-1"].transform,
    })
    hl.monitor({
        output    = "eDP-1",
        mode      = m["eDP-1"].mode,
        position  = "auto",
        scale     = m["eDP-1"].scale,
        transform = m["eDP-1"].transform,
    })
end

local selected = layouts[state.layout]
if selected then selected() else layouts.mult() end
