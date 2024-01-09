ffi = require("ffi")
local C = ffi.C

_APIVERSION = 2

-- Enums
include("enums.lua")

-- Structs
ffi.cdef[[
typedef struct
{
	union {float x, X;};
	union {float y, Y;};
} Vector2;

typedef struct
{
	union {float r, R, Red;};
	union {float g, G, Green;};
	union {float b, B, Blue;};
	union {float a, A, Alpha;};
} Color;

typedef struct
{
	union {float r, R;};
	union {float g, G;};
	union {float b, B;};
	union {float a, A;};
	union {float rc, RC;};
	union {float gc, GC;};
	union {float bc, BC;};
	union {float ac, AC;};
	union {float ro, RO;};
	union {float go, GO;};
	union {float bo, BO;};
} ColorMod;

typedef struct
{
	unsigned int Seed;
	unsigned int __shift[3];
} RNG;

typedef struct
{
	uint64_t lo, hi;
} bitset128_t;

typedef struct {void *_;} Entity;
typedef struct {void *_;} ANM2;
typedef struct {void *_;} EntityDesc;
typedef struct {void *_;} Font;
typedef struct {void *_;} Entity_Player;

typedef struct {void *_;} RoomData;
typedef struct {void *_;} LevelGenerator;
typedef struct {
	bool exists;
	int roomIdx;
	int x;
	int y;
	int w;
	int h;
	int shape;
	int requiredDoors;
	int connectingDir;
	int connectingSlot;
	int connectingX;
	int connectingY;
	// std::set<s32> connectingRoomIndices;
	// s32 numConnectingRooms;
	// bool deadEnd;
	// s32 distanceToStartRoom;
	// bool secret;
} LevelGeneratorRoom;

typedef struct {void *_;} EL;
typedef struct {void *_;} RoomDescriptor;

typedef struct
{
	int Type;
	unsigned int Variant;
	int SpawnerType;
	unsigned int SpawnerVariant;
	Vector2 Position;
	Vector2 Velocity;
	bool IsCharmed;
	bool IsFriendly;
	void *__entity;
} EntityRef;

typedef struct
{
	int Callback;
	union {int I1; float F1; const char *S1; void *P1;};
	union {int I2; float F2; const char *S2; void *P2;};
	union {int I3; float F3; const char *S3; void *P3;};
	union {int I4; float F4; const char *S4; void *P4;};
	union {int I5; float F5; const char *S5; void *P5;};
	union {int I6; float F6; const char *S6; void *P6;};
	union {int I7; float F7; const char *S7; void *P7;};
	union {int I8; float F8; const char *S8; void *P8;};
} LuaCallback;
]]

-- C definitions
include("cdefs.lua")

-- Internal utils
luahelper = {}

function luahelper.checktype(index, val, typ, level)
	local t = type(val)
	if t ~= typ then
		error(string.format("bad argument #%d to '%s' (%s expected, got %s)", index, debug.getinfo(level).name, typ, t), level+1)
	end
end

local checktype = luahelper.checktype

function luahelper.checknumber(index, val, level)
	checktype(index, val, "number", (level or 2)+1)
end

function luahelper.checkstring(index, val, level)
	checktype(index, val, "string", (level or 2)+1)
end

function luahelper.checktable(index, val, level)
	checktype(index, val, "table", (level or 2)+1)
end

function luahelper.checkhandle(index, val, meta, level)
	level = level or 2
	local t = type(val)
	if t == "table" then
		local m = getmetatable(val)
		if m ~= meta and m.__base.meta ~= meta then
			t = m.__type or "table"
			error(string.format("bad argument #%d to '%s' (%s expected, got %s)", index, debug.getinfo(level).name, meta.__type, t), level+1)
		end
	else
		error(string.format("bad argument #%d to '%s' (%s expected, got %s)", index, debug.getinfo(level).name, meta.__type, t), level+1)
	end
end

function luahelper.checkcdata(index, val, ctype, level)
	level = level or 2
	if not val or not ffi.istype(ctype, val) then
		local typ = tostring(ctype) -- todo
		local t = type(val)
		if t == "cdata" then t = tostring(ffi.typeof(val)) end
		
		error(string.format("bad argument #%d to '%s' (%s expected, got %s)", index, debug.getinfo(level).name, typ, t), level+1)
	end
end

function luahelper.checkint64(index, val, level)
	level = level or 2
	if not val or not (type(val) == "number" or ffi.istype("int64_t", val) or ffi.istype("uint64_t", val)) then
		local t = type(val)
		error(string.format("bad argument #%d to '%s' (int64 expected, got %s)", index, debug.getinfo(level).name, t), level+1)
	end
end

function luahelper.ref_add(t, v)
	local ref = t[0] -- Index 0 holds the index of the last free slot
	if ref then
		t[0] = t[ref] -- Set t[0] to the next free slot
	else
		ref = #t + 1 -- No free slots, extend the table
	end
	
	t[ref] = v
	return ref
end

function luahelper.ref_remove(t, ref)
	t[ref] = t[0] -- Replace the reference with the index of the last free slot
	t[0] = ref -- New last free slot is the one we emptied just now
end

function luahelper.tobool(b)
	return not not b
end

luahelper.NULL = ffi.new("void*")
luahelper.META_Entity = {}
luahelper.META_Entity_Player = {}
luahelper.META_Entity_Tear = {}
luahelper.META_Entity_Familiar = {}
luahelper.META_Entity_Bomb = {}
luahelper.META_Entity_Pickup = {}
luahelper.META_Entity_Slot = {}
luahelper.META_Entity_Laser = {}
luahelper.META_Entity_Knife = {}
luahelper.META_Entity_Projectile = {}
luahelper.META_Entity_Effect = {}
luahelper.META_Entity_Text = {}
luahelper.META_Entity_NPC = {}

-- Load basic types
include("api/vector.lua")
include("api/kcolor.lua")
include("api/color.lua")
include("api/rng.lua")

include("api/entity.lua")
include("api/entity_player.lua")
include("api/entity_pickup.lua")

include("api/roomconfig.lua")
include("api/levelgenerator.lua")

-- Load auto generated bindings
include("bindings.lua")

-- Load locals for further bindings
local checknumber = luahelper.checknumber
local checkstring = luahelper.checkstring
local checktable = luahelper.checktable
local checkhandle = luahelper.checkhandle
local checkcdata = luahelper.checkcdata
local checkint64 = luahelper.checkint64
local tobool = luahelper.tobool
local NULL = luahelper.NULL
local _Vector = luahelper._Vector
local _Color = luahelper._Color
local _KColor = luahelper._KColor
local _RNG = luahelper._RNG

local ref_add = luahelper.ref_add
local ref_remove = luahelper.ref_remove

local EntityHandle = luahelper.EntityHandle

local META_Entity = luahelper.META_Entity
local META_Entity_Player = luahelper.META_Entity_Player;
local META_Entity_Tear = luahelper.META_Entity_Tear;
local META_Entity_Familiar = luahelper.META_Entity_Familiar;
local META_Entity_Bomb = luahelper.META_Entity_Bomb;
local META_Entity_Pickup = luahelper.META_Entity_Pickup;
local META_Entity_Slot = luahelper.META_Entity_Slot;
local META_Entity_Laser = luahelper.META_Entity_Laser;
local META_Entity_Knife = luahelper.META_Entity_Knife;
local META_Entity_Projectile = luahelper.META_Entity_Projectile;
local META_Entity_Effect = luahelper.META_Entity_Effect;
local META_Entity_Text = luahelper.META_Entity_Text;
local META_Entity_NPC = luahelper.META_Entity_NPC;

local Entity = luahelper.GetEntityRegisterData("Entity").functions
local Entity_Player = luahelper.GetEntityRegisterData("Entity_Player").functions

-- Cleanup
luahelper = nil

---------------------------------------------------------------
-- Isaac namespace
---------------------------------------------------------------

function Isaac.DebugString(...)
	local args = {...}
	for k,v in ipairs(args) do
		if type(v) ~= "string" then
			args[k] = tostring(v)
		end
	end
	
	C.L_DebugString(table.concat(args, " "))
end

---------------------------------------------------------------
-- Global functions
---------------------------------------------------------------

function Random(x)
	if x then
		checknumber(1, x)
		return C.L_Random(x)
	else
		return C.L_RandomU32()
	end
end

function RandomFloat()
	return C.L_RandomFloat()
end

function RandomVector()
	local v = Vector()
	C.L_RandomUnitVector(v)
	return v
end

---------------------------------------------------------------
-- Mods
---------------------------------------------------------------

local CallbackTable = {}
local CallbackTableV1 -- compatibility

local CallbackData = {
[0]={name = "NpcUpdate", args = function(p) return EntityHandle(p.P1) end};
	{name = "PostUpdate", args = function(p) end};
	{name = "PostRender", args = function(p) end};
	{name = "UseItem", args = function(p) return p.I1, ffi.cast("RNG*", p.P2) end};
	{name = "PostPlayerEffectUpdate", args = function(p) return EntityHandle(p.P1) end};
	{name = "UseCard", args = function(p) end};
	{name = "FamiliarUpdate", args = function(p) end};
	{name = "FamiliarInit", args = function(p) end};
	{name = "EvaluateCache", args = function(p) return EntityHandle(p.P1), p.I2 end};
	{name = "PostPlayerInit", args = function(p) end};
	{name = "UsePill", args = function(p) end};
	{name = "EntityTakeDmg", args = function(p) end};
	{name = "PostCurseEval", args = function(p) end};
	{name = "InputAction", args = function(p) end};
	{name = "LevelGenerator", args = function(p) return p.I1 end};
	{name = "PostGameStarted", args = function(p) end};
	{name = "PostGameEnd", args = function(p) end};
	{name = "PreGameExit", args = function(p) end};
	{name = "PostNewLevel", args = function(p) end};
	{name = "PostNewRoom", args = function(p) end};
	{name = "GetCard", args = function(p) end};
	{name = "GetShaderParams", args = function(p) end};
	{name = "ExecuteCmd", args = function(p) end};
	{name = "PreUseItem", args = function(p) return p.I1, ffi.cast("RNG*", p.P2) end};
	{name = "PreEntitySpawn", args = function(p) end};
	{name = "PostFamiliarRender", args = function(p) end};
	{name = "PreFamiliarCollision", args = function(p) end};
	{name = "PostNpcInit", args = function(p) end};
	{name = "PostNpcRender", args = function(p) end};
	{name = "PostNpcDeath", args = function(p) end};
	{name = "PreNpcCollision", args = function(p) end};
	{name = "PostPlayerUpdate", args = function(p) end};
	{name = "PostPlayerRender", args = function(p) end};
	{name = "PrePlayerCollision", args = function(p) end};
	{name = "PostPickupInit", args = function(p) return EntityHandle(p.P1) end};
	{name = "PostPickupUpdate", args = function(p) end};
	{name = "PostPickupRender", args = function(p) end};
	{name = "PostPickupSelection", args = function(p) end};
	{name = "PrePickupCollision", args = function(p) end};
	{name = "PostTearInit", args = function(p) end};
	{name = "PostTearUpdate", args = function(p) end};
	{name = "PostTearRender", args = function(p) end};
	{name = "PreTearCollision", args = function(p) end};
	{name = "PostProjectileInit", args = function(p) end};
	{name = "PostProjectileUpdate", args = function(p) end};
	{name = "PostProjectileRender", args = function(p) end};
	{name = "PreProjectileCollision", args = function(p) end};
	{name = "PostLaserInit", args = function(p) end};
	{name = "PostLaserUpdate", args = function(p) end};
	{name = "PostLaserRender", args = function(p) end};
	{name = "PostKnifeInit", args = function(p) end};
	{name = "PostKnifeUpdate", args = function(p) end};
	{name = "PostKnifeRender", args = function(p) end};
	{name = "PreKnifeCollision", args = function(p) end};
	{name = "PostEffectInit", args = function(p) end};
	{name = "PostEffectUpdate", args = function(p) end};
	{name = "PostEffectRender", args = function(p) end};
	{name = "PostBombInit", args = function(p) end};
	{name = "PostBombUpdate", args = function(p) end};
	{name = "PostBombRender", args = function(p) end};
	{name = "PreBombCollision", args = function(p) end};
	{name = "PostFireTear", args = function(p) end};
	{name = "PreGetCollectible", args = function(p) end};
	{name = "PostGetCollectible", args = function(p) end};
	{name = "GetPillColor", args = function(p) end};
	{name = "GetPillEffect", args = function(p) end};
	{name = "GetTrinket", args = function(p) end};
	{name = "PostEntityRemove", args = function(p) end};
	{name = "PostEntityKill", args = function(p) end};
	{name = "PreNpcUpdate", args = function(p) end};
	{name = "PreSpawnCleanAward", args = function(p) end};
	{name = "PreRoomEntitySpawn", args = function(p) end};
	
	{name = "CallbackBenchmark", args = function(p) return p.I1 end};
}

local CallbacksByName = {}
for k,v in pairs(CallbackData) do
	CallbacksByName[v.name] = k
end

function __ProcessCallback(P)
	local I = {}
	local O = {}
	
	P = ffi.cast("LuaCallback*", P)
	local callbacks = CallbackTable[P.Callback]
	if callbacks then
		local D = CallbackData[P.Callback]
		I[1],I[2],I[3],I[4],I[5],I[6],I[7],I[8] = D.args(P)
		for _,v in pairs(callbacks) do
			O[1],O[2],O[3],O[4],O[5],O[6],O[7],O[8] = v.func(I[1],I[2],I[3],I[4],I[5],I[6],I[7],I[8])
			if O[1] ~= nil then
				if not v.pass or not v.pass(I,O) then
					return O[1],O[2],O[3],O[4],O[5],O[6],O[7],O[8]
				end
			end
		end
	end
	
	-- Version 1 compatibility
	callbacks = CallbackTableV1 and CallbackTableV1[P.Callback]
	if callbacks then
		local D = CallbackData[P.Callback]
		I[1],I[2],I[3],I[4],I[5],I[6],I[7],I[8] = D.args(P)
		for _,v in pairs(callbacks) do
			O[1],O[2],O[3],O[4],O[5],O[6],O[7],O[8] = v.func(v.mod, I[1],I[2],I[3],I[4],I[5],I[6],I[7],I[8])
			if O[1] ~= nil then
				if not v.pass or not v.pass(I,O) then
					return O[1],O[2],O[3],O[4],O[5],O[6],O[7],O[8]
				end
			end
		end
	end
	
	return O[1],O[2],O[3],O[4],O[5],O[6],O[7],O[8]
end

function Isaac.AddCallback(cb, id, func, extra, mod)
	if type(cb) == "string" and CallbacksByName[cb] then
		cb = CallbacksByName[cb]
	end
	
	local callbacks = CallbackTable[cb]
	if not callbacks then
		callbacks = {}
		CallbackTable[cb] = callbacks
		
		if type(cb) == "number" then
			C.L_EnableCallback(cb)
		end
	end
	
	callbacks[id] = {func = func, extra = extra, mod = mod}
end

function Isaac.RemoveCallback(cb, id)
	local callbacks = CallbackTable[cb]
	if callbacks then
		if type(id) == "function" then
			for k,v in pairs(callbacks) do
				if v.func == id then
					callbacks[k] = nil
				end
			end
		else
			callbacks[id] = nil
		end
	end
end

local Mods = {}
local META_Mod = {}

local lastCallbackUniqueId = 0

function META_Mod:AddCallback(callbackId, fn, entityId)
	Isaac.AddCallback(callbackId, tostring(lastCallbackUniqueId), fn, entityId)
	lastCallbackUniqueId = lastCallbackUniqueId + 1
end

function META_Mod:RemoveCallback(callbackId, fn)
	Isaac.RemoveCallback(callbackId, fn)
end

function META_Mod:SaveData(data)
	if self.Path then
		C.L_Mod_SaveData(self.Path, data, #data)
	end
end

function META_Mod:LoadData()
	if self.Path then
		local length = ffi.new("int[1]")
		local data = C.L_Mod_LoadData(self.Path, length)
		
		if data ~= NULL then
			ffi.gc(data, ffi.C.L_Free) -- garbage collect returned data
			return ffi.string(data, length[0])
		end
	end
end

function META_Mod:HasData()
	return self.Path and C.L_Mod_HasData(self.Path)
end

function META_Mod:RemoveData()
	if self.Path then
		C.L_Mod_RemoveData(self.Path)
	end
end

------------------------------------------------------
-- Version 1 compatibility

local META_Mod_v1 = {}

local lastCallbackUniqueIdV1 = 0
function META_Mod_v1:AddCallback(callbackId, fn, entityId)
	if not CallbackTableV1 then CallbackTableV1 = {} end
	
	local callbacks = CallbackTableV1[callbackId]
	if not callbacks then
		callbacks = {}
		CallbackTableV1[callbackId] = callbacks
		C.L_EnableCallback(callbackId)
	end
	
	callbacks[callbackId] = {func = fn, extra = entityId, mod = self}
end

function META_Mod_v1:RemoveCallback(callbackId, fn)
	local callbacks = CallbackTableV1 and CallbackTableV1[callbackId]
	for k,v in pairs(callbacks) do
		if v.func == fn then
			callbacks[k] = nil
		end
	end
end

setmetatable(META_Mod_v1, {__index = META_Mod})

------------------------------------------------------

local COMPAT_ENV

function RegisterMod(modname, apiversion)
	local meta = META_Mod
	
	-- Version 1 compatibility
	if apiversion == 1 then
		if not COMPAT_ENV then
			COMPAT_ENV = include("compat.lua")
		end
		setfenv(2, COMPAT_ENV)
		
		meta = META_Mod_v1
	end
	
	local mod = {
		Name = modname;
		APIVersion = apiversion or _APIVERSION;
	}
	
	local source = debug.getinfo(2, "S").source
	if source and source:sub(1,1) == "@" then
		-- Replace backslashes with regular slashes then remove last entry to obtain the root folder of our mod
		mod.Path = source:sub(2):gsub("\\", "/"):gsub("/[^/]+$", "/")
	end
	
	setmetatable(mod, {__index = meta})
	Mods[modname] = mod
	return mod
end

function StartDebug()
	print("Debug mode is no longer supported")
	--[[
	local ok, m = pcall(require, 'mobdebug') 
	if ok and m then
		m.start()
	else
		Isaac.DebugString("Failed to start debugging.")
	end
	]]
end
