local ffi = require("ffi")
local C = ffi.C
local checktype = luahelper.checktype
local checknumber = luahelper.checknumber
local checkstring = luahelper.checkstring
local checktable = luahelper.checktable
local tobool = luahelper.tobool
local NULL = luahelper.NULL

---------------------------------------------------------------
-- Vector
---------------------------------------------------------------

local META_Vector = {}
local _Vector

function META_Vector:Normalize()
	local d = math.sqrt(self.x*self.x + self.y*self.y)
	if d > 0 then
		self.x, self.y = self.x / d, self.y / d
	end
	return self
end

function META_Vector:Normalized()
	local d = math.sqrt(self.x*self.x + self.y*self.y)
	if d > 0 then
		return _Vector(self.x/d, self.y/d)
	else
		return _Vector(self.x, self.y)
	end
end

function META_Vector:Dot(other)
	return self.x*other.x + self.y*other.y
end

function META_Vector:Cross(other)
	return self.x*other.y - self.y*other.x
end

function META_Vector:Lerp(other, amount)
	self.x, self.y = (1-amount)*self.x + amount*other.x, (1-amount)*self.y + amount*other.y
	return self
end

function META_Vector:Distance(other)
	local dx, dy = other.x-self.x, other.y-self.y
	return math.sqrt(dx*dx+dy*dy)
end

function META_Vector:DistanceSqr(other)
	local dx, dy = other.x-self.x, other.y-self.y
	return dx*dx+dy*dy
end

function META_Vector:Rotate(angle)
	angle = math.rad(angle)
	local c, s = math.cos(angle), math.sin(angle)
	self.x, self.y = self.x*c - self.y*s, self.x*s + self.y*c
	return self
end

function META_Vector:Rotated(angle)
	angle = math.rad(angle)
	local c, s = math.cos(angle), math.sin(angle)
	return _Vector(self.x*c - self.y*s, self.x*s + self.y*c)
end

function META_Vector:Angle()
	return math.deg(math.atan2(self.y, self.x))
end

function META_Vector:Resize(length)
	local d = math.sqrt(self.x*self.x + self.y*self.y)
	if d > 0 then
		self.x, self.y = self.x * length / d, self.y * length / d
	end
	return self
end

function META_Vector:Resized(length)
	local d = math.sqrt(self.x*self.x + self.y*self.y)
	if d > 0 then
		return _Vector(self.x * length / d, self.y * length / d)
	else
		return _Vector(self.x, self.y)
	end
end

function META_Vector:Clamp(xmin, ymin, xmax, ymax)
	self.x = math.min(math.max(self.x, xmin), xmax)
	self.y = math.min(math.max(self.y, ymin), ymax)
	return self
end

function META_Vector:Clamped(xmin, ymin, xmax, ymax)
	return _Vector(math.min(math.max(self.x, xmin), xmax), math.min(math.max(self.y, ymin), ymax))
end

function META_Vector:Length()
	return math.sqrt(self.x*self.x + self.y*self.y)
end

function META_Vector:LengthSqr()
	return self.x*self.x + self.y*self.y
end

function META_Vector:Add(other)
	self.x, self.y = self.x+other.x, self.y+other.y
	return self
end

function META_Vector:Sub(other)
	self.x, self.y = self.x-other.x, self.y-other.y
	return self
end

function META_Vector:Mul(scalar)
	self.x, self.y = self.x*scalar, self.y*scalar
	return self
end

function META_Vector:Div(scalar)
	self.x, self.y = self.x/scalar, self.y/scalar
	return self
end

function META_Vector:Copy()
	return _Vector(self.x, self.y)
end

META_Vector.LengthSquared = META_Vector.LengthSqr
META_Vector.DistanceSquared = META_Vector.DistanceSqr
META_Vector.GetAngleDegrees = META_Vector.Angle

_Vector = ffi.metatype("Vector2", {
	__add = function(a, b)
		return _Vector(a.x+b.x, a.y+b.y)
	end;
	__sub = function(a, b)
		return _Vector(a.x-b.x, a.y-b.y)
	end;
	__mul = function(a, b)
		if ffi.istype(_Vector, b) then
			return _Vector(a*b.x, a*b.y)
		else
			return _Vector(a.x*b, a.y*b)
		end
	end;
	__div = function(a, b)
		return _Vector(a.x/b, a.y/b)
	end;
	__unm = function(a)
		return _Vector(-a.x, -a.y)
	end;
	__eq = function(a, b)
		return a.x==b.x and a.y==b.y
	end;
	__len = function(a)
		return math.sqrt(a.x*a.x + a.y*a.y)
	end;
	__tostring = function(a)
		return string.format("%g %g", a.x, a.y)
	end;
	__index = META_Vector;
})

Vector = setmetatable({
	-- Static functions
	FromAngle = function(a)
		a = math.rad(a)
		return _Vector(math.cos(a), math.sin(a))
	end;
	Lerp = function(a, b, c)
		return _Vector((1-c)*a.x + c*b.x, (1-c)*a.y + c*b.y)
	end;
	Zero = _Vector(0, 0);
	One = _Vector(1, 1);
},
{
	-- Constructor
	__call = function(_, x, y)
		if not x and not y then
			return _Vector(0, 0)
		else
			checknumber(1, x)
			checknumber(2, y)
			return _Vector(x, y)
		end
	end
})

luahelper._Vector = _Vector
return _Vector
