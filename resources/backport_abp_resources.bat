lua _backport/copyxml.lua

:: Rocks
for /F "tokens=*" %%A in (_backport/rocks.txt) do magick %%A -crop 128x256+0+0 _backport/masks/rocks.png -compose DstOut -composite ../resources/%%A

pause
