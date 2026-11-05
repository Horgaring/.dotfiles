-- Оболочка: waybar + swaync + swayosd + wlogout
return function(mainMod)
    hl.on("hyprland.start", function()
        hl.exec_cmd("waybar")
        hl.exec_cmd("command -v swayosd-server >/dev/null && swayosd-server")
    end)

    -- Громкость/яркость: индикатор swayosd, если установлен, иначе без него
    local el = { locked = true, repeating = true }
    hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("swayosd-client --output-volume +5 --max-volume 100 || wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), el)
    hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("swayosd-client --output-volume -5 || wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), el)
    hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle || wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), el)
    hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("swayosd-client --input-volume mute-toggle || wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), el)
    hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("swayosd-client --brightness +5 || brightnessctl -e4 -n2 set 5%+"), el)
    hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("swayosd-client --brightness -5 || brightnessctl -e4 -n2 set 5%-"), el)
    hl.bind("CAPS + Caps_Lock", hl.dsp.exec_cmd("swayosd-client --caps-lock"), { release = true })

    -- Меню выключения
    hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd("pkill wlogout || wlogout -b 3 -T 180 -B 180 -L 260 -R 260"))
end
