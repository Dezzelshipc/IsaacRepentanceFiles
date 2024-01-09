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
local ref_add = luahelper.ref_add
local ref_remove = luahelper.ref_remove

local META_Entity = luahelper.META_Entity

---------------------------------------------------------------
-- Entity
---------------------------------------------------------------

local _EntityRef

local function CDATA(obj)
	return rawget(obj, "__cdata")
end

local EntityHandles = {}
local NullEntity

local function checkentity(idx, val, level)
	return checkhandle(idx, val, META_Entity, level)
end

local function toentityref(idx, val, level)
	if not val then
		return EntityRef()
	elseif type(val) == "table" and getmetatable(val) == META_Entity then
		return EntityRef(val)
	else
		checkcdata(idx, val, _EntityRef, (level or 2)+1)
		return val
	end
end

local metas = {
	luahelper.META_Entity_Player;
	luahelper.META_Entity_Tear;
	luahelper.META_Entity_Familiar;
	luahelper.META_Entity_Bomb;
	luahelper.META_Entity_Pickup;
	luahelper.META_Entity_Slot;
	luahelper.META_Entity_Laser;
	luahelper.META_Entity_Knife;
	luahelper.META_Entity_Projectile;
	
	[1000] = luahelper.META_Entity_Effect;
	[9001] = luahelper.META_Entity_Text;
	
	default = luahelper.META_Entity_NPC;
}

local function GetMetatableForEntity(ent)
	return ent ~= NULL and (metas[C.LC_Entity__GetType(ent)] or metas.default) or luahelper.META_Entity
end

local function EntityHandle(ent)
	local isValid = (ent ~= NULL)
	ent = ffi.cast("void*", ent)
	if isValid then
		local ref = C.LC_Entity__GetRef(ent)
		if ref > 0 then
			return EntityHandles[ref]
		end
	elseif NullEntity then
		return NullEntity
	end
	
	local handle = {__cdata = ent, __data = {}}
	setmetatable(handle, GetMetatableForEntity(ent))
	if isValid then
		C.LC_Entity__SetRef(ent, ref_add(EntityHandles, handle))
	else
		NullEntity = handle
	end
	
	return handle
end

NullEntity = EntityHandle(NULL)
META_Entity.__constructor = EntityHandle

local function PropertyAccessor(vartype, get, set)
	local a = {}
	if vartype == "number" then
		if get then
			a[1] = function(self)
				return get(self)
			end
		end
		if set then
			a[2] = function(self, val)
				checknumber(1, val)
				set(self, val)
			end
		end
	elseif vartype == "bool" then
		if get then
			a[1] = function(self)
				return get(self)
			end
		end
		if set then
			a[2] = function(self, val)
				set(self, tobool(val))
			end
		end
	elseif vartype == "string" then
		if get then
			a[1] = function(self)
				return get(self)
			end
		end
		if set then
			a[2] = function(self, val)
				checkstring(1, val)
				set(self, val)
			end
		end
	elseif type(vartype) == "table" then
		local makehandle = vartype.__constructor
		if get then
			a[1] = function(self)
				return makehandle(get(self))
			end
		end
		if set then
			a[2] = function(self, val)
				checkhandle(1, val, vartype)
				set(self, CDATA(val))
			end
		end
	elseif type(vartype) == "cdata" then
		if get then
			a[1] = function(self)
				local val = vartype()
				get(val, self)
				return val
			end
		end
		if set then
			a[2] = function(self, val)
				set(self, val)
			end
		end
	end
	
	return a
end

local function entity_meta_eq(a, b)
	return CDATA(a) == CDATA(b)
end

local entity_regdata = {}

local function GetEntityRegisterData(name)
	return entity_regdata[name]
end

local function CreateEntityMetatable(meta, name, accessors, functions, base)
	entity_regdata[name] = {meta=meta, functions=functions, accessors=accessors}
	
	if base then
		base = entity_regdata[base]
		if base then
			local base_functions = base.functions
			local base_accessors = base.accessors
			setmetatable(accessors, {__index = base_accessors})
			setmetatable(functions, {__index = base_functions})
			
			meta.__constructor = base.__constructor
			meta.__base = base
		end
	end
	
	meta.__type = name
	meta.__eq = entity_meta_eq
	meta.__index = function(a, k)
		local cdata = CDATA(a)
		
		-- Only function which can be called on a NULL entity
		if k == "Exists" then
			return functions.Exists(cdata)
		end
		
		if cdata == NULL then
			error("Tried to index a NULL entity!", 2)
		end
		
		local f = accessors[k]
		if f then
			-- Property accessors
			return f[1](cdata)
		else
			-- Member functions or custom data
			return functions[k] or rawget(a, "__data")[k]
		end
	end
	meta.__newindex = function(a, k, v)
		local cdata = CDATA(a)
		if cdata == NULL then
			error("Tried to index a NULL entity!", 2)
		end
		
		local f = accessors[k]
		if f then
			-- Property accessors
			if not f[2] then error(name.." field '"..k.."' is read only", 2) end
			f[2](cdata, v)
		else
			-- Custom data
			local dt = rawget(a, "__data")
			dt[k] = v
		end
	end
	meta.__tostring = function(a)
		local cdata = CDATA(a)
		if cdata == NULL then
			return "NULL Entity"
		else
			return name
		end
	end
end

-------------------------------------------------------------------------------------------------

local vector_minusone = Vector(-1, -1)

local Entity_accessors = {
	Friction				= PropertyAccessor("number", C.LC_Entity__GetFriction, C.LC_Entity__SetFriction);
	Position				= PropertyAccessor(_Vector, C.LC_Entity__GetPosition, C.LC_Entity__SetPosition);
	Velocity				= PropertyAccessor(_Vector, C.LC_Entity__GetVelocity, C.LC_Entity__SetVelocity);
	Color					= PropertyAccessor(_Color, C.LC_Entity__GetDefaultColor, function(self, col) C.LC_Entity__SetColor(self, col, -1, 255, false, true) end);
	Type					= PropertyAccessor("number", C.LC_Entity__GetType);
	Variant					= PropertyAccessor("number", C.LC_Entity__GetVariant, C.LC_Entity__SetVariant);
	SubType					= PropertyAccessor("number", C.LC_Entity__GetSubType, C.LC_Entity__SetSubType);
	SpawnerType				= PropertyAccessor("number", C.LC_Entity__GetSpawnerType, C.LC_Entity__SetSpawnerType);
	SpawnerVariant			= PropertyAccessor("number", C.LC_Entity__GetSpawnerVariant, C.LC_Entity__SetSpawnerVariant);
	SplatColor				= PropertyAccessor(_Color, C.LC_Entity__GetSplatColor, C.LC_Entity__SetSplatColor);
	Visible					= PropertyAccessor("bool", C.LC_Entity__GetVisible, C.LC_Entity__SetVisible);
	PositionOffset			= PropertyAccessor(_Vector, C.LC_Entity__GetPositionOffset, C.LC_Entity__SetPositionOffset);
	RenderZOffset			= PropertyAccessor("number", C.LC_Entity__GetRenderZOffset, C.LC_Entity__SetRenderZOffset);
	FlipX					= PropertyAccessor("bool", C.LC_Entity__GetFlipX, C.LC_Entity__SetFlipX);
	SpriteOffset			= PropertyAccessor(_Vector, C.LC_Entity__GetSpriteOffset, C.LC_Entity__SetSpriteOffset);
	SpriteScale				= PropertyAccessor(_Vector, C.LC_Entity__GetSpriteScale, C.LC_Entity__SetSpriteScale);
	SpriteRotation			= PropertyAccessor("number", C.LC_Entity__GetSpriteRotation, C.LC_Entity__SetSpriteRotation);
	Size					= PropertyAccessor("number", C.LC_Entity__GetSize, function(self, size) C.LC_Entity__SetSize(self, size, vector_minusone, -1) end);
	SizeMulti				= PropertyAccessor(_Vector, C.LC_Entity__GetSizeMulti, C.LC_Entity__SetSizeMulti);
	Mass					= PropertyAccessor("number", C.LC_Entity__GetMass, C.LC_Entity__SetMass);
	MaxHitPoints			= PropertyAccessor("number", C.LC_Entity__GetMaxHitPoints, C.LC_Entity__SetMaxHitPoints);
	HitPoints				= PropertyAccessor("number", C.LC_Entity__GetHitPoints, C.LC_Entity__SetHitPoints);
	Index					= PropertyAccessor("number", C.LC_Entity__GetIndex);
	TargetPosition			= PropertyAccessor(_Vector, C.LC_Entity__GetTargetPosition, C.LC_Entity__SetTargetPosition);
	GridCollisionClass		= PropertyAccessor("number", C.LC_Entity__GetGridCollisionClass, C.LC_Entity__SetGridCollisionClass);
	EntityCollisionClass	= PropertyAccessor("number", C.LC_Entity__GetEntityCollisionClass, C.LC_Entity__SetEntityCollisionClass);
	CollisionDamage			= PropertyAccessor("number", C.LC_Entity__GetCollisionDamage, C.LC_Entity__SetCollisionDamage);
	SpawnGridIndex			= PropertyAccessor("number", C.LC_Entity__GetSpawnGridIndex);
	Parent					= PropertyAccessor(META_Entity, C.LC_Entity__GetParent, C.LC_Entity__SetParent);
	Child					= PropertyAccessor(META_Entity, C.LC_Entity__GetChild, C.LC_Entity__SetChild);
	Target					= PropertyAccessor(META_Entity, C.LC_Entity__GetTarget, C.LC_Entity__SetTarget);
	SpawnerEntity			= PropertyAccessor(META_Entity, C.LC_Entity__GetSpawnerEntity, C.LC_Entity__SetSpawnerEntity);
	FrameCount				= PropertyAccessor("number", C.LC_Entity__GetFrameCount);
	InitSeed				= PropertyAccessor("number", C.LC_Entity__GetInitSeed);
	DropSeed				= PropertyAccessor("number", C.LC_Entity__GetDropSeed);
	DepthOffset				= PropertyAccessor("number", C.LC_Entity__GetDepthOffset, C.LC_Entity__SetDepthOffset);
}

local ENT = {}

function ENT:GetData()
	return rawget(self, "__data")
end

CreateEntityMetatable(META_Entity, "Entity", Entity_accessors, ENT)

-------------------------------------------------------------------------------------------------

_EntityRef = ffi.metatype("EntityRef", {
	__tostring = function(a)
		return "EntityRef"
	end;
	__index = function(a, k)
		if k == "Entity" then
			return EntityHandle(ffi.cast("Entity*"), a.__entity)
		end
	end;
	__newindex = function(a, k, v)
		if k == "Entity" then
			checkhandle(2, v, META_Entity)
			a.__entity = CDATA(v)
		end
	end;
})

function EntityRef(Ent)
	if Ent then
		checkhandle(1, Ent, META_Entity)
		local c = CDATA(Ent)
		if c ~= NULL then
			local pos = _Vector()
			local vel = _Vector()
			
			C.LC_Entity__GetPosition(c, pos)
			C.LC_Entity__GetVelocity(c, vel)
			
			return _EntityRef(
				C.LC_Entity__GetType(c),
				C.LC_Entity__GetVariant(c),
				C.LC_Entity__GetSpawnerType(c),
				C.LC_Entity__GetSpawnerVariant(c),
				pos, vel,
				C.LC_Entity__HasEntityFlags(c, EF_CHARM),
				C.LC_Entity__HasEntityFlags(c, EF_FRIENDLY),
				c)
		end
	end
	return _EntityRef(0, 0, 0, 0, Vector.Zero, Vector.Zero, false, false, NULL)
end

-------------------------------------------------------------------------------------------------

-- This is automatically called by the game when an entity is removed
-- Set all references to this entity to NULL
function __ClearReferences(ent)
	ent = ffi.cast("Entity*", ent)
	local ref = C.LC_Entity__GetRef(ent)
	
	if ref > 0 then
		local handle = EntityHandles[ref]
		rawset(handle, "__cdata", NULL)
		C.LC_Entity__SetRef(ent, 0)
		ref_remove(EntityHandles, ref)
	end
end

-------------------------------------------------------------------------------------------------

luahelper.PropertyAccessor = PropertyAccessor
luahelper.GetEntityRegisterData = GetEntityRegisterData
luahelper.CreateEntityMetatable = CreateEntityMetatable
luahelper.GetMetatableForEntity = GetMetatableForEntity
luahelper.EntityHandle = EntityHandle
luahelper._EntityRef = _EntityRef
luahelper.CDATA = CDATA
luahelper.checkentity = checkentity
luahelper.NullEntity = NullEntity
