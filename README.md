# mpv-settings

My configuration for [mpv](https://mpv.io/) on Windows. It will need some
changes to work on macOS or Linux, mostly around font names and paths.

The goal is enhanced defaults. Every one of mpv's builtin key bindings still
works exactly as it does in a stock install, and the keys added here are ones
mpv leaves unbound. If you already know mpv, nothing you know stops working.

Tested against mpv v0.41.0. Older builds may not have `autocreate-playlist`
or the console script options used here.

## Installation

Download a Windows build from the [mpv installation
page](https://mpv.io/installation/) and put the folder wherever you like.
Copy `portable_config` into that folder, next to `mpv.exe`. Everything mpv
needs then lives in one directory, so it is easy to move or delete.

To make mpv your default video and music player, run `mpv-register.bat` from
the mpv folder. Older builds shipped an `installer` folder with
`mpv-install.bat` instead.

## Added key bindings

| Key | Action |
| --- | --- |
| `B` | Cycle deband strength (mpv's own `b` toggles debanding on and off) |
| `h` / `H` | Next / previous audio track |
| `Ctrl+f` | Toggle between the high-quality and fast video profiles |
| `Ctrl+i` | Toggle smooth motion (display-sync plus interpolation) |
| `Ctrl+t` | Open the console to jump to a timestamp |
| `Ctrl+o` | Cycle tone-mapping between spline, bt.2446a and st2094-40 |

`Ctrl+f` is the one to reach for on integrated graphics or on battery. It
drops to mpv's builtin `fast` profile and back again, restoring the previous
settings properly rather than leaving some of them stuck.

`Ctrl+i` reduces judder when the video frame rate does not divide evenly into
your refresh rate, for example 24 fps on a 180 Hz display. It costs CPU and GPU
time, so it is off by default. Interpolation cannot work alone, which is why
this switches `video-sync` at the same time.

Both are profiles in `mpv.conf` driven by `scripts/profile-toggle.lua`. The
comments in those two files explain why toggling a profile needs a script.

## What the config does

Rendering uses `vo=gpu-next` with the `high-quality` profile and `hwdec=auto`.
Debanding is configured but off; press `b` to turn it on.

HDR peak detection measures the peak per frame rather than reading the file's
static metadata. Mastering-display tags describe a whole film instead of the
current scene and are usually far brighter than anything actually on screen,
which makes darker scenes look flatter than they should. mpv already does this
by default wherever compute shaders work, so the config only tunes it: a slow
decay rate and raised scene thresholds hold the measured peak steady, since
detection otherwise makes brightness drift mid-scene. If you still see
drifting, raise `hdr-peak-decay-rate` first. `Ctrl+f` switches detection off
entirely, since the compute shaders it needs are slow on some drivers.

Surround audio is normalized when folded down to stereo, so dialogue in a 5.1
or 7.1 track does not end up buried under the effects. ReplayGain is set to
`track`, which evens out loudness between files that carry gain tags.

Playback keeps a 1 GB demuxer back buffer and 300 MB of forward readahead, so
seeking backward does not re-read the file. Opening one file loads the rest of
its folder as a playlist. Resume-on-open is off, so mpv never writes
watch-later files.

Screenshots go into a `Screenshots` folder next to the video, as PNG with the
colorspace tagged. For streams and anything else not on disk, they fall back
to `Screenshots` on your Desktop.

The `log-file` line in `mpv.conf` is commented out. Uncomment it to write
`portable_config/mpv-log.txt` on every run. mpv forces that file to at least
`-v -v`, so it grows quickly and is overwritten each time mpv starts.

Subtitle font settings apply to plain-text subtitles only. ASS and SSA
subtitles keep their own styling, which is usually what you want.

## Fonts

`portable_config/fonts` is loaded by mpv automatically. It contains:

- [Geist](https://github.com/vercel/geist-font) for subtitles and the OSD
- [Literata](https://github.com/googlefonts/literata), a serif alternative for
  subtitles. Swap the commented-out `sub-font` line in `mpv.conf` to use it
- [JetBrains Mono](https://github.com/JetBrains/JetBrainsMono) for the stats
  overlay and console

All three are licensed under the [SIL Open Font
License 1.1](https://scripts.sil.org/OFL), not under this repository's
license. Their license files are in `portable_config/font-licenses` and must
stay with the fonts if you redistribute. They sit outside the fonts folder
because libass tries to load every entry in that folder as a font and warns
about anything that is not one, including subfolders.

Use static font files rather than variable ones. libass cannot select a named
instance from a variable font, so asking for a Bold or a Display cut silently
gives you the default weight instead.

## License

MIT, covering the configuration files. The fonts are licensed separately, as
described above.
