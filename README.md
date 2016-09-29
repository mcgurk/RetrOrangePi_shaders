# RetrOrangePi_shaders
Shaders for mimic CRT scanlines

Works/tested with:
- neogeo
- nes
- pcengine
- msx
- playstation
- n64
- megadrive
- many mame/fba games
- many others

Some games with some consoles have interlaced (double vertical resolution) display modes (e.g. Playstation Gran Turismo menus, Megadrive Sonic The Hedgehog 2 2-player mode). Those games are better without shader.

## Install

- Create `shader` directory to `/home/pi/RetroPie/roms` (or \\\\RetrOrangePi\roms).
- Copy `kurg-ROPi-scanlines-3x.glsl` and `kurg-ROPi-scanlines-3x.glslp` to `/home/pi/RetroPie/roms/shader` (or \\\\RetrOrangePi\roms\shader)
- Edit emulator settings file `/opt/retropie/configs/neogeo/retroarch.cfg` (this example is for neogeo) (add lines before #include... -line):
```
video_scale_integer = true
video_shader = "/home/pi/RetroPie/roms/shader/kurg-ROPi-scanlines-3x.glslp"
video_shader_enable = true
```

Vertical size is fixed (3 times emulator image vertical resolution).

Works best with 720p display mode and with emulators with vertical resolution 240 or less. If vertical resolution of image is less than 240, image is not fullscreen.

### 2.5.2!
RetrOrangePi 2.5.2 default is to overwrite retroarch.cfg. If you want edit retroarch.cfg by hand, turn override off:

RetroPie -> Retroarch -> Settings -> Configuration -> Load override files automatically = off

or

`sed -i 's/auto_overrides_enable = "true"/auto_overrides_enable = "false"/g' /opt/retropie/configs/all/retroarch.cfg`


## Theory

Modern televisions have panels which have fixed resolutions. If that resolution would be very large compared to emulated device, we wouldn't have any problems. But because most displays have only 2 to 4 times of emulated device vertical resolution, scanlines have to be in "sync", or otherwise we get uneven scanlines and artifacts.

Because ROPi can't change refresh rate between emulators and because it works best with 60hz, I assume that 60hz is used. This is important because then it is assumed/recommended that roms are NTSC (USA/JAPAN). And then we can assume that in most emulators vertical resolution is 240 (or 224). This is good, because most common vertical resolutions in modern televisions are 720 and 1080 (not coincidence, 720 and 1080 comes from NTSC vertical resolution).

If we get image with vertical resolution 224 from emulator, we cannot fill whole screen. If our screenmode is 720p, 3 times 224 are only 672, so there inevitably 48 lines are unused (black area under and/or top of image). Other option is to use 4 times 224 (=896), but then big areas are clipped from top and/or bottom. In 1080p display we could use 4 times 224 (=896), but then there is even more black area. If we use 5 times 224 (=1120), we have to chop only 40 pixels (8 scanlines from original image).

If we want some simulated separation for pixels in horizontal direction, we have to lock also horizontal scaling to integer multiplication. That leads to situation, where we cannot keep aspect ratio correct, if pixels are originally something else than square.

It is possible to make good quality scanline shader with scaling (normal 1080p display scales 720p image without big artifacts), but if I try more complicated shaders with OPi, it slows down too much.


Example of "broken" scanlines, where image is not scaled with integer factor:

<a href="https://raw.githubusercontent.com/mcgurk/RetrOrangePi_shaders/master/Images/scan_broken.jpg"><img src="https://raw.githubusercontent.com/mcgurk/RetrOrangePi_shaders/master/Images/scan_broken.jpg" height="200"></a>


Example of working scanlines, where image is scaled with integer factor (3x):

<a href="https://raw.githubusercontent.com/mcgurk/RetrOrangePi_shaders/master/Images/scan_ok.jpg"><img src="https://raw.githubusercontent.com/mcgurk/RetrOrangePi_shaders/master/Images/scan_ok.jpg" height="200"></a>


## experimenting

test-shader tries to mimic gap between pixels in one scanline. Downside is that you cannot scale image at all and aspect ratio can be very distorted (depends aspect ratio of pixel).

make "shader" directory to /home/pi/RetroPie/roms (or \\\\RetrOrangePi\roms).
copy test720.glsl and test720.glslp to /home/pi/RetroPie/roms/shader (or \\\\RetrOrangePi\roms\shader)

Edit emulator settings file /opt/retropie/configs/neogeo/retroarch.cfg (this example is for neogeo):
```
video_shader = "/home/pi/RetroPie/roms/shader/test720.glslp"
video_shader_enable = true
```
test720 doesn't obey any aspect ratio settings! All pixels are assumed to be square. Every pixel are scaled by 3, so size of image are fixed (you can't scale it).
