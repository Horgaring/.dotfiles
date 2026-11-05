-- Оболочка: Caelestia (quickshell) — панель, лаунчер, уведомления, OSD, сайдбар, меню сессии
-- Горячие клавиши адаптированы из caelestia-dots/caelestia (hypr/hyprland/keybinds.lua)
return function(mainMod)
    hl.on("hyprland.start", function()
        hl.exec_cmd("caelestia shell -d")
    end)

    -- Лаунчер — короткое нажатие Super (Super+Space остаётся за vicinae)
    hl.bind("SUPER + SUPER_L", hl.dsp.global("caelestia:launcher"), { release = true })

    -- Панели
    hl.bind(mainMod .. " + N", hl.dsp.global("caelestia:sidebar"))
    hl.bind(mainMod .. " + K", hl.dsp.global("caelestia:showall"))
    hl.bind("CTRL + ALT + Delete", hl.dsp.global("caelestia:session"))
    hl.bind(mainMod .. " + Escape", hl.dsp.global("caelestia:session"))
    hl.bind("CTRL + ALT + C", hl.dsp.global("caelestia:clearNotifs"), { locked = true })

    -- Буфер обмена и эмодзи
    hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("pkill fuzzel || caelestia clipboard"))
    hl.bind(mainMod .. " + ALT + V", hl.dsp.exec_cmd("pkill fuzzel || caelestia clipboard -d"))
    hl.bind(mainMod .. " + period", hl.dsp.exec_cmd("pkill fuzzel || caelestia emoji -p"))

    -- Запись экрана
    hl.bind(mainMod .. " + ALT + R", hl.dsp.exec_cmd("caelestia record -r"))
    hl.bind("CTRL + ALT + R", hl.dsp.exec_cmd("caelestia record -s"))

    -- Громкость (OSD рисует сама оболочка) и яркость
    local el = { locked = true, repeating = true }
    hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), el)
    hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), el)
    hl.bind("XF86AudioMute",    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
    hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
    hl.bind("XF86MonBrightnessUp",   hl.dsp.global("caelestia:brightnessUp"), el)
    hl.bind("XF86MonBrightnessDown", hl.dsp.global("caelestia:brightnessDown"), el)

    -- Перезапуск оболочки
    hl.bind("CTRL + SUPER + ALT + R", hl.dsp.exec_cmd("caelestia shell -k; caelestia shell -d"), { release = true })

    hl.layer_rule({
        name  = "caelestia-no-anim",
        match = { namespace = "^caelestia-(border-exclusion|area-picker)$" },
        no_anim = true,
    })
    hl.layer_rule({
        name  = "caelestia-fade",
        match = { namespace = "^caelestia-(drawers|background)$" },
        animation = "fade",
    })
end
