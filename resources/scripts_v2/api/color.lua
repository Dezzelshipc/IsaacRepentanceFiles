local ffi = require("ffi")
local C = ffi.C
local checktype = luahelper.checktype
local checknumber = luahelper.checknumber
local checkstring = luahelper.checkstring
local checktable = luahelper.checktable
local tobool = luahelper.tobool
local NULL = luahelper.NULL

---------------------------------------------------------------
-- Color
---------------------------------------------------------------

local META_Color = {}

function META_Color:Reset()
	self.r, self.g, self.b, self.a = 1, 1, 1, 1
	self.rc, self.gc, self.bc, self.ac = 0, 0, 0, 0
	self.ro, self.go, self.bo = 0, 0, 0
	return self
end

function META_Color:SetTint(R, G, B, A)
	self.r, self.g, self.b, self.a = R, G, B, A or 1
	return self
end

function META_Color:SetColorize(R, G, B, A)
	self.rc, self.gc, self.bc, self.ac = R, G, B, A or 1
	return self
end

function META_Color:SetOffset(R, G, B)
	self.ro, self.go, self.bo = R, G, B
	return self
end

local _Color
_Color = ffi.metatype("ColorMod", {
	__tostring = function(a)
		return string.format("[%g %g %g %g] [%g %g %g %g] [%g %g %g]", a.r, a.g, a.b, a.a, a.rc, a.gc, a.bc, a.ac, a.ro, a.go, a.bo)
	end;
	__mul = function(a, b)
		local rc, gc, bc, ac
		if b.rc + b.gc + b.bc ~= 0 then
			if a.rc + a.gc + a.bc ~= 0 then
				rc, gc, bc, ac = (a.rc+b.rc)*0.5, (a.gc+b.gc)*0.5, (a.bc+b.bc)*0.5, (a.ac+b.ac)*0.5
			else
				rc, gc, bc, ac = b.rc, b.gc, b.bc, b.ac
			end
		else
			rc, gc, bc, ac = a.rc, a.gc, a.bc, a.ac
		end
		
		return _Color(
			a.r * b.r,
			a.g * b.g,
			a.b * b.b,
			a.a * b.a,
			rc,
			gc,
			bc,
			ac,
			a.ro + b.ro,
			a.go + b.go,
			a.bo + b.bo
		)
	end;
	__eq = function(a, b)
		return a.r==b.r and a.g==b.g and a.b==b.b and a.a==b.a
		and a.rc==b.rc and a.gc==b.gc and a.bc==b.bc and a.ac==b.ac
		and a.ro==b.ro and a.go==b.go and a.bo==b.bo
	end;
	__index = META_Color;
})

Color = setmetatable({
	-- Static functions
	Lerp = function(a, b, c)
		local d = 1-c
		
		return _Color(
			a.r*d + b.r*c,
			a.g*d + b.g*c,
			a.b*d + b.b*c,
			a.a*d + b.a*c,
			a.rc*d + b.rc*c,
			a.gc*d + b.gc*c,
			a.bc*d + b.bc*c,
			a.ac*d + b.ac*c,
			a.ro*d + b.ro*c,
			a.go*d + b.go*c,
			a.bo*d + b.bo*c
		)
	end;
	
	Default = _Color(1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0);
},
{
	-- Constructor
	__call = function(_, r, g, b, a, ro, go, bo, rc, gc, bc, ac)
		return _Color(
			r or 1, g or 1, b or 1, a or 1,
			rc or 0, gc or 0, bc or 0, ac or 0,
			ro or 0, go or 0, bo or 0
		)
	end
})

luahelper._Color = _Color
return _Color
