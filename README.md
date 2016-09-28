# RetrOrangePi_shaders
Shaders for mimic CRT scanlines

## Install

make "shader" directory to /home/pi/RetroPie/roms (or \\RetrOrangePi\roms).
copy test720.glsl and test720.glslp to /home/pi/RetroPie/roms/shader (or \\RetrOrangePi\roms\shader)

Edit emulator settings file /opt/retropie/configs/neogeo/retroarch.cfg (this example is for neogeo):
```
video_shader = "/home/pi/RetroPie/roms/shader/test720.glslp"
video_shader_enable = true
```
test720 doesn't obey any aspect ratio settings! All pixels are assumed to be square. Every pixel are scaled by 3, so size of image are fixed (you can't scale it).


