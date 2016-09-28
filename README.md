# RetrOrangePi_shaders
Shaders for mimic CRT scanlines

## Install

make "shader" directory to /home/pi/RetroPie/roms (or \\RetrOrangePi\roms).
copy test720.glsl and test720.glslp to /home/pi/RetroPie/roms/shader (or \\RetrOrangePi\roms\shader)

Edit emulator settings, example file /opt/retropie/configs/neogeo/retroarch.cfg:
```
video_shader = "/home/pi/RetroPie/roms/shader/test720.glslp"
video_shader_enable = true
```
test720 doesn't obey any aspect ratio settings! All pixels are assumed to be square.


