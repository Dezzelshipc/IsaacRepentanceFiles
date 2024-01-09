for %%f in (playerportrait*.png) do (
	magick %%f -gravity south -background none -extent 144x144 -strip -define png:bit-depth=8 -define png:color-type=6 %%f
)
