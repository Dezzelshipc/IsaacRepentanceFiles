local ffi = require("ffi")
local C = ffi.C
local checktype = luahelper.checktype
local checknumber = luahelper.checknumber
local checkstring = luahelper.checkstring
local checktable = luahelper.checktable
local tobool = luahelper.tobool
local NULL = luahelper.NULL

local checkhandle = luahelper.checkhandle
local checkcdata = luahelper.checkcdata
local checkint64 = luahelper.checkint64

local LevelGenerator_functions = {}

luahelper._LevelGenerator = ffi.metatype("LevelGenerator", {
	__tostring = function(a)
		return "LevelGenerator"
	end;
	__gc = function(a)
		C.L_LevelGenerator__destructor(a)
	end;
	__index = function(a,k)
		return LevelGenerator_functions[k]
	end;
})

function LevelGenerator(seed)
	return C.L_LevelGenerator(seed)
end

luahelper.LevelGenerator_functions = LevelGenerator_functions
luahelper._LevelGeneratorRoom = ffi.metatype("LevelGeneratorRoom", {__tostring = function(a) return "LevelGeneratorRoom" end;})
