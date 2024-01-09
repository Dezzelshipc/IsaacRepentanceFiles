local ffi = require("ffi")
local C = ffi.C
local checktype = luahelper.checktype
local checknumber = luahelper.checknumber
local checkstring = luahelper.checkstring
local checktable = luahelper.checktable
local tobool = luahelper.tobool
local NULL = luahelper.NULL

---------------------------------------------------------------
-- RNG
---------------------------------------------------------------

local META_RNG = {}
local MAX_SHIFT_IDX = 80

function META_RNG:SetSeed(seed, shiftIdx)
	shiftIdx = shiftIdx or 35
	checknumber(2, seed)
	checknumber(3, shiftIdx)
	if shiftIdx < 0 or shiftIdx > MAX_SHIFT_IDX then
		error(string.format("RNG: Invalid ShiftIdx %d (must be between 0 and %d)", shiftIdx, MAX_SHIFT_IDX), 2)
	end
	
	C.LC_RNG__SetSeed(self, seed, shiftIdx)
end

function META_RNG:GetSeed()
	return self.Seed
end

function META_RNG:RandomInt(max)
	if max then
		checknumber(2, max)
		return C.LC_RNG__RandomInt(self, max)
	else
		return C.LC_RNG__Next(self)
	end
end

function META_RNG:RandomFloat()
	return C.LC_RNG__RandomFloat(self)
end

function META_RNG:Next()
	return C.LC_RNG__Next(self)
end

local _RNG
_RNG = ffi.metatype("RNG", {
	__tostring = function(a)
		return "RNG"
	end;
	__call = function(a, max)
		if max then
			checknumber(2, max)
			return C.LC_RNG__RandomInt(a, max)
		else
			return C.LC_RNG__Next(a)
		end
	end;
	__index = META_RNG;
})

RNG = setmetatable({},
{
	-- Constructor
	__call = function(_, seed, shiftIdx)
		local rng = _RNG()
		if seed then
			shiftIdx = shiftIdx or 35
			checknumber(1, seed)
			checknumber(2, shiftIdx)
			if shiftIdx < 0 or shiftIdx > MAX_SHIFT_IDX then
				error(string.format("RNG: Invalid ShiftIdx %d (must be between 0 and %d)", shiftIdx, MAX_SHIFT_IDX), 2)
			end
			C.LC_RNG__SetSeed(rng, seed, shiftIdx)
		else
			C.LC_RNG__SetSeed(rng, 2853650767, 35)
		end
		return rng
	end
})

luahelper._RNG = _RNG
return _RNG
