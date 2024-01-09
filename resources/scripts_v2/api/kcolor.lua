local ffi = require("ffi")
local C = ffi.C
local checktype = luahelper.checktype
local checknumber = luahelper.checknumber
local checkstring = luahelper.checkstring
local checktable = luahelper.checktable
local tobool = luahelper.tobool
local NULL = luahelper.NULL

---------------------------------------------------------------
-- KColor
---------------------------------------------------------------

local META_KColor = {}

function META_KColor:ToARGB()
	return bit.bor(bit.bor(bit.bor(
		bit.lshift(bit.band(self.a*255, 0xff), 24),
		bit.lshift(bit.band(self.r*255, 0xff), 16)),
		bit.lshift(bit.band(self.g*255, 0xff), 8)),
		bit.band(self.b*255, 0xff))
end

local _KColor
_KColor = ffi.metatype("Color", {
	__tostring = function(a)
		return string.format("%g %g %g %g", a.r, a.g, a.b, a.a)
	end;
	__mul = function(a, b)
		return _KColor(a.r*b.r, a.g*b.g, a.b*b.b, a.a*b.a)
	end;
	__eq = function(a, b)
		return a.r==b.r and a.g==b.g and a.b==b.b and a.a==b.a
	end;
	__index = META_KColor;
})

KColor = setmetatable({
	-- Static functions
	FromARGB = function(argb)
		return _KColor(
			bit.band(bit.rshift(argb, 16), 0xff)/255,
			bit.band(bit.rshift(argb, 8 ), 0xff)/255,
			bit.band(           argb     , 0xff)/255,
			bit.band(bit.rshift(argb, 24), 0xff)/255
		)
	end;
	Lerp = function(a, b, c)
		local d = 1-c
		return _KColor(
			a.r*d + b.r*c,
			a.g*d + b.g*c,
			a.b*d + b.b*c,
			a.a*d + b.a*c
		)
	end;
	AliceBlue = _KColor(0.941176, 0.972549, 1, 1);
	AntiqueWhite = _KColor(0.980392, 0.921569, 0.843137, 1);
	Aqua = _KColor(0, 1, 1, 1);
	Aquamarine = _KColor(0.498039, 1, 0.831373, 1);
	Azure = _KColor(0.941176, 1, 1, 1);
	Beige = _KColor(0.960784, 0.960784, 0.862745, 1);
	Bisque = _KColor(1, 0.894118, 0.768627, 1);
	Black = _KColor(0, 0, 0, 1);
	BlanchedAlmond = _KColor(1, 0.921569, 0.803922, 1);
	Blue = _KColor(0, 0, 1, 1);
	BlueViolet = _KColor(0.541176, 0.168627, 0.886275, 1);
	Brown = _KColor(0.647059, 0.164706, 0.164706, 1);
	BurlyWood = _KColor(0.870588, 0.721569, 0.529412, 1);
	CadetBlue = _KColor(0.372549, 0.619608, 0.627451, 1);
	Chartreuse = _KColor(0.498039, 1, 0, 1);
	Chocolate = _KColor(0.823529, 0.411765, 0.117647, 1);
	Coral = _KColor(1, 0.498039, 0.313725, 1);
	CornflowerBlue = _KColor(0.392157, 0.584314, 0.929412, 1);
	Cornsilk = _KColor(1, 0.972549, 0.862745, 1);
	Crimson = _KColor(0.862745, 0.0784314, 0.235294, 1);
	Cyan = _KColor(0, 1, 1, 1);
	DarkBlue = _KColor(0, 0, 0.545098, 1);
	DarkCyan = _KColor(0, 0.545098, 0.545098, 1);
	DarkGoldenRod = _KColor(0.721569, 0.52549, 0.0431373, 1);
	DarkGray = _KColor(0.662745, 0.662745, 0.662745, 1);
	DarkGrey = _KColor(0.662745, 0.662745, 0.662745, 1);
	DarkGreen = _KColor(0, 0.392157, 0, 1);
	DarkKhaki = _KColor(0.741176, 0.717647, 0.419608, 1);
	DarkMagenta = _KColor(0.545098, 0, 0.545098, 1);
	DarkOliveGreen = _KColor(0.333333, 0.419608, 0.184314, 1);
	DarkOrange = _KColor(1, 0.54902, 0, 1);
	DarkOrchid = _KColor(0.6, 0.196078, 0.8, 1);
	DarkRed = _KColor(0.545098, 0, 0, 1);
	DarkSalmon = _KColor(0.913725, 0.588235, 0.478431, 1);
	DarkSeaGreen = _KColor(0.560784, 0.737255, 0.560784, 1);
	DarkSlateBlue = _KColor(0.282353, 0.239216, 0.545098, 1);
	DarkSlateGray = _KColor(0.184314, 0.309804, 0.309804, 1);
	DarkSlateGrey = _KColor(0.184314, 0.309804, 0.309804, 1);
	DarkTurquoise = _KColor(0, 0.807843, 0.819608, 1);
	DarkViolet = _KColor(0.580392, 0, 0.827451, 1);
	DeepPink = _KColor(1, 0.0784314, 0.576471, 1);
	DeepSkyBlue = _KColor(0, 0.74902, 1, 1);
	DimGray = _KColor(0.411765, 0.411765, 0.411765, 1);
	DimGrey = _KColor(0.411765, 0.411765, 0.411765, 1);
	DodgerBlue = _KColor(0.117647, 0.564706, 1, 1);
	FireBrick = _KColor(0.698039, 0.133333, 0.133333, 1);
	FloralWhite = _KColor(1, 0.980392, 0.941176, 1);
	ForestGreen = _KColor(0.133333, 0.545098, 0.133333, 1);
	Fuchsia = _KColor(1, 0, 1, 1);
	Gainsboro = _KColor(0.862745, 0.862745, 0.862745, 1);
	GhostWhite = _KColor(0.972549, 0.972549, 1, 1);
	Gold = _KColor(1, 0.843137, 0, 1);
	GoldenRod = _KColor(0.854902, 0.647059, 0.12549, 1);
	Gray = _KColor(0.501961, 0.501961, 0.501961, 1);
	Grey = _KColor(0.501961, 0.501961, 0.501961, 1);
	Green = _KColor(0, 0.501961, 0, 1);
	GreenYellow = _KColor(0.678431, 1, 0.184314, 1);
	HoneyDew = _KColor(0.941176, 1, 0.941176, 1);
	HotPink = _KColor(1, 0.411765, 0.705882, 1);
	IndianRed = _KColor(0.803922, 0.360784, 0.360784, 1);
	Indigo = _KColor(0.294118, 0, 0.509804, 1);
	Ivory = _KColor(1, 1, 0.941176, 1);
	Khaki = _KColor(0.941176, 0.901961, 0.54902, 1);
	Lavender = _KColor(0.901961, 0.901961, 0.980392, 1);
	LavenderBlush = _KColor(1, 0.941176, 0.960784, 1);
	LawnGreen = _KColor(0.486275, 0.988235, 0, 1);
	LemonChiffon = _KColor(1, 0.980392, 0.803922, 1);
	LightBlue = _KColor(0.678431, 0.847059, 0.901961, 1);
	LightCoral = _KColor(0.941176, 0.501961, 0.501961, 1);
	LightCyan = _KColor(0.878431, 1, 1, 1);
	LightGoldenRodYellow = _KColor(0.980392, 0.980392, 0.823529, 1);
	LightGray = _KColor(0.827451, 0.827451, 0.827451, 1);
	LightGrey = _KColor(0.827451, 0.827451, 0.827451, 1);
	LightGreen = _KColor(0.564706, 0.933333, 0.564706, 1);
	LightPink = _KColor(1, 0.713725, 0.756863, 1);
	LightSalmon = _KColor(1, 0.627451, 0.478431, 1);
	LightSeaGreen = _KColor(0.12549, 0.698039, 0.666667, 1);
	LightSkyBlue = _KColor(0.529412, 0.807843, 0.980392, 1);
	LightSlateGray = _KColor(0.466667, 0.533333, 0.6, 1);
	LightSlateGrey = _KColor(0.466667, 0.533333, 0.6, 1);
	LightSteelBlue = _KColor(0.690196, 0.768627, 0.870588, 1);
	LightYellow = _KColor(1, 1, 0.878431, 1);
	Lime = _KColor(0, 1, 0, 1);
	LimeGreen = _KColor(0.196078, 0.803922, 0.196078, 1);
	Linen = _KColor(0.980392, 0.941176, 0.901961, 1);
	Magenta = _KColor(1, 0, 1, 1);
	Maroon = _KColor(0.501961, 0, 0, 1);
	MediumAquaMarine = _KColor(0.4, 0.803922, 0.666667, 1);
	MediumBlue = _KColor(0, 0, 0.803922, 1);
	MediumOrchid = _KColor(0.729412, 0.333333, 0.827451, 1);
	MediumPurple = _KColor(0.576471, 0.439216, 0.858824, 1);
	MediumSeaGreen = _KColor(0.235294, 0.701961, 0.443137, 1);
	MediumSlateBlue = _KColor(0.482353, 0.407843, 0.933333, 1);
	MediumSpringGreen = _KColor(0, 0.980392, 0.603922, 1);
	MediumTurquoise = _KColor(0.282353, 0.819608, 0.8, 1);
	MediumVioletRed = _KColor(0.780392, 0.0823529, 0.521569, 1);
	MidnightBlue = _KColor(0.0980392, 0.0980392, 0.439216, 1);
	MintCream = _KColor(0.960784, 1, 0.980392, 1);
	MistyRose = _KColor(1, 0.894118, 0.882353, 1);
	Moccasin = _KColor(1, 0.894118, 0.709804, 1);
	NavajoWhite = _KColor(1, 0.870588, 0.678431, 1);
	Navy = _KColor(0, 0, 0.501961, 1);
	OldLace = _KColor(0.992157, 0.960784, 0.901961, 1);
	Olive = _KColor(0.501961, 0.501961, 0, 1);
	OliveDrab = _KColor(0.419608, 0.556863, 0.137255, 1);
	Orange = _KColor(1, 0.647059, 0, 1);
	OrangeRed = _KColor(1, 0.270588, 0, 1);
	Orchid = _KColor(0.854902, 0.439216, 0.839216, 1);
	PaleGoldenRod = _KColor(0.933333, 0.909804, 0.666667, 1);
	PaleGreen = _KColor(0.596078, 0.984314, 0.596078, 1);
	PaleTurquoise = _KColor(0.686275, 0.933333, 0.933333, 1);
	PaleVioletRed = _KColor(0.858824, 0.439216, 0.576471, 1);
	PapayaWhip = _KColor(1, 0.937255, 0.835294, 1);
	PeachPuff = _KColor(1, 0.854902, 0.72549, 1);
	Peru = _KColor(0.803922, 0.521569, 0.247059, 1);
	Pink = _KColor(1, 0.752941, 0.796078, 1);
	Plum = _KColor(0.866667, 0.627451, 0.866667, 1);
	PowderBlue = _KColor(0.690196, 0.878431, 0.901961, 1);
	Purple = _KColor(0.501961, 0, 0.501961, 1);
	RebeccaPurple = _KColor(0.4, 0.2, 0.6, 1);
	Red = _KColor(1, 0, 0, 1);
	RosyBrown = _KColor(0.737255, 0.560784, 0.560784, 1);
	RoyalBlue = _KColor(0.254902, 0.411765, 0.882353, 1);
	SaddleBrown = _KColor(0.545098, 0.270588, 0.0745098, 1);
	Salmon = _KColor(0.980392, 0.501961, 0.447059, 1);
	SandyBrown = _KColor(0.956863, 0.643137, 0.376471, 1);
	SeaGreen = _KColor(0.180392, 0.545098, 0.341176, 1);
	SeaShell = _KColor(1, 0.960784, 0.933333, 1);
	Sienna = _KColor(0.627451, 0.321569, 0.176471, 1);
	Silver = _KColor(0.752941, 0.752941, 0.752941, 1);
	SkyBlue = _KColor(0.529412, 0.807843, 0.921569, 1);
	SlateBlue = _KColor(0.415686, 0.352941, 0.803922, 1);
	SlateGray = _KColor(0.439216, 0.501961, 0.564706, 1);
	SlateGrey = _KColor(0.439216, 0.501961, 0.564706, 1);
	Snow = _KColor(1, 0.980392, 0.980392, 1);
	SpringGreen = _KColor(0, 1, 0.498039, 1);
	SteelBlue = _KColor(0.27451, 0.509804, 0.705882, 1);
	Tan = _KColor(0.823529, 0.705882, 0.54902, 1);
	Teal = _KColor(0, 0.501961, 0.501961, 1);
	Thistle = _KColor(0.847059, 0.74902, 0.847059, 1);
	Tomato = _KColor(1, 0.388235, 0.278431, 1);
	Turquoise = _KColor(0.25098, 0.878431, 0.815686, 1);
	Violet = _KColor(0.933333, 0.509804, 0.933333, 1);
	Wheat = _KColor(0.960784, 0.870588, 0.701961, 1);
	White = _KColor(1, 1, 1, 1);
	WhiteSmoke = _KColor(0.960784, 0.960784, 0.960784, 1);
	Yellow = _KColor(1, 1, 0, 1);
	YellowGreen = _KColor(0.603922, 0.803922, 0.196078, 1);
},
{
	-- Constructor
	__call = function(_, r, g, b, a)
		return _KColor(r, g, b, a or 1)
	end
})

luahelper._KColor = _KColor
return _KColor
