local ffi = require("ffi")
local C = ffi.C
local checktype = luahelper.checktype
local checknumber = luahelper.checknumber
local checkstring = luahelper.checkstring
local checktable = luahelper.checktable
local tobool = luahelper.tobool
local NULL = luahelper.NULL

local _Vector = luahelper._Vector
local _Color = luahelper._Color

local checkhandle = luahelper.checkhandle
local checkcdata = luahelper.checkcdata
local checkint64 = luahelper.checkint64

local META_Entity_Pickup = luahelper.META_Entity_Pickup
local CreateEntityMetatable = luahelper.CreateEntityMetatable
local PropertyAccessor = luahelper.PropertyAccessor

---------------------------------------------------------------
-- Pickup
---------------------------------------------------------------

local ACCESSORS = {
	--TearsOffset = PropertyAccessor(_Vector, C.LC_Entity_Player__GetTearsOffset, C.LC_Entity_Player__SetTearsOffset);
}

local ENT = {}
CreateEntityMetatable(META_Entity_Pickup, "Entity_Pickup", ACCESSORS, ENT, "Entity")
