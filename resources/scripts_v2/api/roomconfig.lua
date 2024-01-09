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

-- stub
luahelper._RoomData = ffi.metatype("RoomData", {__tostring = function(a) return "RoomData" end;})
