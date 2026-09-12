-- Turn the profiles defined at the end of mpv.conf on and off from a key.
--
-- mpv has no command that toggles a profile: apply-profile only applies or
-- restores, and neither cycle nor cycle-values works on user-data properties,
-- so whether a profile is currently on has to be tracked here.
--
-- Restoring relies on profile-restore=copy being set on each profile.

local function make_toggle(profile, on_label, off_label)
    local on = false
    return function()
        on = not on
        if on then
            mp.command("apply-profile " .. profile)
        else
            mp.command("apply-profile " .. profile .. " restore")
        end
        mp.osd_message(on and on_label or off_label)
    end
end

mp.add_key_binding(nil, "toggle-video-quality",
    make_toggle("video-fast", "Video: fast", "Video: high quality"))

mp.add_key_binding(nil, "toggle-motion-smooth",
    make_toggle("motion-smooth", "Smooth motion: on", "Smooth motion: off"))
