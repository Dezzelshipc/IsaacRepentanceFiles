:: Generate
call :generate 07x_corpse
call :generate 07x_corpse2
call :generate 07x_corpse3
call :generate 06x_gehenna

:: Cleanup
del _tmp1.png
del _tmp2.png
del _tmp3.png
del _tmp4.png
del _tmp5.png
del _tmp1b.png
del _tmp2b.png
del _tmp3b.png
del _tmp4b.png
del _tmp5b.png
goto :eof

:generate
set PNG_OPTIONS=-strip -define png:bit-depth=8 -define png:color-type=6
set SHEET=%1.png
set OUTPUT_N=%1_Nfloor.png
set OUTPUT_L=%1_Lfloor.png

magick %SHEET% -crop 78x104+52+52 _tmp1.png
magick _tmp1.png -flop _tmp2.png
magick %SHEET% -crop 182x52+52+52 _tmp3.png
magick _tmp3.png -flip _tmp4.png

magick %SHEET% -crop 78x104+52+208 _tmp1b.png
magick _tmp1b.png -flop _tmp2b.png
magick %SHEET% -crop 182x52+52+208 _tmp3b.png
magick _tmp3b.png -flip _tmp4b.png

magick -size 338x338 xc:transparent ^
	_tmp1.png -geometry +0+78 -composite ^
	_tmp2.png -geometry +52+78 -composite ^
	_tmp1.png -geometry +0+0 -composite ^
	_tmp2.png -geometry +52+0 -composite ^
	_tmp1b.png -geometry +130+78 -composite ^
	_tmp2b.png -geometry +182+78 -composite ^
	_tmp1b.png -geometry +130+0 -composite ^
	_tmp2b.png -geometry +182+0 -composite ^
	_tmp3.png -geometry +156+182 -composite ^
	_tmp4.png -geometry +156+208 -composite ^
	_tmp3.png -geometry +0+182 -composite ^
	_tmp4.png -geometry +0+208 -composite ^
	_tmp3b.png -geometry +156+260 -composite ^
	_tmp4b.png -geometry +156+286 -composite ^
	_tmp3b.png -geometry +0+260 -composite ^
	_tmp4b.png -geometry +0+286 -composite ^
	%PNG_OPTIONS% %OUTPUT_N%

magick %SHEET% -crop 182x104+52+52 _tmp1.png
magick _tmp1.png -flop _tmp2.png
magick _tmp1.png -flip _tmp3.png
magick _tmp2.png -flip _tmp4.png

magick %SHEET% -crop 182x104+52+208 _tmp1b.png
magick _tmp1b.png -flop _tmp2b.png
magick _tmp1b.png -flip _tmp3b.png
magick _tmp2b.png -flip _tmp4b.png

magick -size 1014x182 xc:transparent ^
	_tmp4.png -geometry +182+78 -composite ^
	_tmp3.png -geometry +0+78 -composite ^
	_tmp4.png -geometry +338+104 -composite ^
	_tmp4.png -geometry +494+104 -composite ^
	_tmp2.png -geometry +182+0 -composite ^
	_tmp2.png -geometry +338+0 -composite ^
	_tmp2.png -geometry +494+0 -composite ^
	_tmp1.png -geometry +0+0 -composite ^
	_tmp4.png -geometry +832+0 -composite ^
	_tmp3.png -geometry +676+0 -composite ^
	_tmp4.png -geometry +832+78 -composite ^
	_tmp3.png -geometry +676+78 -composite ^
	_tmp5.png
	
magick -size 1014x182 xc:transparent ^
	_tmp4b.png -geometry +182+78 -composite ^
	_tmp3b.png -geometry +0+78 -composite ^
	_tmp4b.png -geometry +338+104 -composite ^
	_tmp4b.png -geometry +494+104 -composite ^
	_tmp2b.png -geometry +182+0 -composite ^
	_tmp2b.png -geometry +338+0 -composite ^
	_tmp2b.png -geometry +494+0 -composite ^
	_tmp1b.png -geometry +0+0 -composite ^
	_tmp4b.png -geometry +832+0 -composite ^
	_tmp3b.png -geometry +676+0 -composite ^
	_tmp4b.png -geometry +832+78 -composite ^
	_tmp3b.png -geometry +676+78 -composite ^
	_tmp5b.png
	
magick -size 1024x364 xc:transparent ^
	_tmp5.png -geometry +0+0 -composite ^
	_tmp5b.png -geometry +0+182 -composite ^
	%PNG_OPTIONS% %OUTPUT_L%

goto :eof
