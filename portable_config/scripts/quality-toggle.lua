-- Toggle between the high-quality profile set in mpv.conf and mpv's builtin
-- fast profile, for integrated graphics or when saving battery.
--
-- Bound to Ctrl+f in input.conf. mpv has no command that toggles a profile on
-- its own: apply-profile only applies or restores, and neither cycle nor
-- cycle-values works on user-data properties, so the state is tracked here.

local fast = false

mp.add_key_binding(nil, "toggle-video-quality", function()
    fast = not fast
    if fast then
        mp.command("apply-profile video-fast")
    else
        mp.command("apply-profile video-fast restore")
    end
    mp.osd_message("Video: " .. (fast and "fast" or "high quality"))
end)
