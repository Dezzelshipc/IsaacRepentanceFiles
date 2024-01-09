local pairs = pairs
local ipairs = ipairs
local type = type
local setfenv = setfenv
local getfenv = getfenv

local COMPAT_ENV = {}
local G = getfenv()
setfenv(1, COMPAT_ENV)
----------------------------------------------------

local globals = {}
for k,v in pairs(G) do
	if type(v) == "number" or type(v) == "ctype" then
		globals[k] = v
	end
end

local function BuildEnumTable(params)
	local t = {}
	local f0 = params.replace
	local f = f0
	local prefix = params.prefix
	local direct = params.direct
	
	if type(f) == "string" then
		local r = f
		local trimLength = prefix and #prefix+1 or 1
		f = function(k) return r..k:sub(trimLength) end
		f0 = nil
	end
	
	if direct then
		direct = (type(direct) == "table" and direct or {direct})
	
		for _,v in ipairs(direct) do
			t[f0 and f0(v) or v] = globals[v]
			globals[v] = nil
		end
	end
	
	if prefix then
		local reg = "^"..prefix
		for k,v in pairs(globals) do
			if k:find(reg) then
				t[f and f(k) or k] = globals[k]
				globals[k] = nil
			end
		end
	end
	
	return t
end

ModCallbacks = BuildEnumTable{prefix="MC_"}
EntityType = BuildEnumTable{prefix="ENTITY_"}
GridEntityType = BuildEnumTable{prefix="GRID_"}
EffectVariant = BuildEnumTable{direct="EFFECT_NULL", prefix="EFFECT_", replace=""}
HeartSubType = BuildEnumTable{prefix="PICKUP_HEART_", replace="HEART_"}
CoinSubType = BuildEnumTable{prefix="PICKUP_COIN_", replace="COIN_"}
KeySubType = BuildEnumTable{prefix="PICKUP_KEY_", replace="KEY_"}
ChestSubType = BuildEnumTable{prefix="PICKUP_CHEST_", replace="CHEST_"}
BombSubType = BuildEnumTable{prefix="PICKUP_BOMB_", replace="BOMB_"}
PickupVariant = BuildEnumTable{prefix="PICKUP_"}
PickupPrice = BuildEnumTable{prefix="PRICE_"}
Challenge = BuildEnumTable{direct="NUM_CHALLENGES", prefix="CHALLENGE_"}
BombVariant = BuildEnumTable{prefix="BOMB_"}
CacheFlag = BuildEnumTable{prefix="CACHE_"}
NpcState = BuildEnumTable{prefix="AI_", replace="STATE_"}
EntityGridCollisionClass = BuildEnumTable{prefix="GRIDCOLL_"}
EntityCollisionClass = BuildEnumTable{prefix="ENTCOLL_"}
EntityFlag = BuildEnumTable{prefix="EF_", replace="FLAG_"}
DamageFlag = BuildEnumTable{prefix="DMG_", replace="DAMAGE_"}
SortingLayer = BuildEnumTable{prefix="LAYER_", replace="SORTING_"}
FamiliarVariant = BuildEnumTable{direct="FAMILIAR_NULL", prefix="FAMILIAR_", replace=""}
LocustSubtypes = BuildEnumTable{prefix="LOCUST_"}
ItemType = BuildEnumTable{prefix="ITEM_"}
NullItemID = BuildEnumTable{direct="NUM_NULLITEMS", prefix="NULLITEM_", replace="ID_"}
WeaponType = BuildEnumTable{direct="NUM_WEAPON_TYPES", prefix="WEAPON_"}
PlayerSpriteLayer = BuildEnumTable{direct="NUM_SPRITE_LAYERS", prefix="SL_", replace="SPRITE_"}
BabySubType = BuildEnumTable{prefix="BABY_"}
LaserOffset = BuildEnumTable{prefix="LASER_OFFSET_", replace=function(e) return e:gsub("^LASER_OFFSET_", "LASER_").."_OFFSET" end}
ActionTriggers = BuildEnumTable{prefix="ACTIONTRIGGER_"}
GridCollisionClass = BuildEnumTable{prefix="GRIDCOLLISION_", replace="COLLISION_"}
Direction = BuildEnumTable{prefix="DIR_", replace=function(e) return e == "DIR_NONE" and NO_DIRECTION or e:gsub("^DIR_", "") end}
LevelStage = BuildEnumTable{direct="NUM_STAGES", prefix="STAGE_"}
StageType = BuildEnumTable{prefix="STAGETYPE_"}
RoomType = BuildEnumTable{direct="NUM_ROOMTYPES", prefix="ROOM_"}
RoomShape = BuildEnumTable{direct="NUM_ROOMSHAPES", prefix="ROOMSHAPE_"}
DoorSlot = BuildEnumTable{direct="NUM_DOOR_SLOTS", prefix="DOORSLOT_", replace=""}
DoorSlot.NO_DOOR_SLOT, DoorSlot.NONE = DoorSlot.NONE, nil
LevelCurse = BuildEnumTable{direct="NUM_CURSES", prefix="CURSE_"}
PlayerType = BuildEnumTable{direct="NUM_PLAYER_TYPES", prefix="PLAYER_"}
PlayerForm = BuildEnumTable{direct="NUM_PLAYER_FORMS", prefix="PLAYERFORM_"}
PillColor = BuildEnumTable{direct="NUM_PILLS", prefix="PILL_"}
Music = BuildEnumTable{direct="NUM_MUSIC", prefix="MUSIC_"}
SoundEffect = BuildEnumTable{direct="NUM_SOUNDS", prefix="SOUND_"}
DoorState = BuildEnumTable{prefix="DOORSTATE_", replace="STATE_"}
DoorVariant = BuildEnumTable{prefix="DOOR_"}
Difficulty = BuildEnumTable{prefix="GM_", replace="DIFFICULTY_"}
LevelStateFlag = BuildEnumTable{direct="NUM_LEVEL_STATE_FLAGS", prefix="LS_", replace="STATE_"}
LevelStateFlag.NUM_STATE_FLAGS, LevelStateFlag.NUM_LEVEL_STATE_FLAGS = LevelStateFlag.NUM_LEVEL_STATE_FLAGS, nil
GameStateFlag = BuildEnumTable{direct="NUM_GAME_STATE_FLAGS", prefix="GS_", replace="STATE_"}
GameStateFlag.NUM_STATE_FLAGS, GameStateFlag.NUM_GAME_STATE_FLAGS = GameStateFlag.NUM_GAME_STATE_FLAGS, nil
CollectibleType = BuildEnumTable{direct="NUM_COLLECTIBLES", prefix="COLLECTIBLE_"}
TrinketType = BuildEnumTable{direct="NUM_TRINKETS", prefix="TRINKET_"}
PillEffect = BuildEnumTable{direct="NUM_PILL_EFFECTS", prefix="PILLEFFECT_"}
Card = BuildEnumTable{direct="NUM_CARDS", prefix="CARD_"}
local runes = BuildEnumTable{prefix="RUNE_"}
for k,v in pairs(runes) do Card[k] = v end
TearVariant = BuildEnumTable{prefix="TEAR_", replace=""}
TearFlags = BuildEnumTable{prefix="TF_", replace="TEAR_"}
ButtonAction = BuildEnumTable{prefix="ACT_", replace="ACTION_"}
Keyboard = BuildEnumTable{prefix="K_", replace="KEY_"}
Mouse = BuildEnumTable{prefix="MOUSE_", replace="MOUSE_BUTTON_"}
InputHook = BuildEnumTable{prefix="INPUTHOOK_", replace=""}
SeedEffect = BuildEnumTable{direct="NUM_SEEDS", prefix="SEED_"}
GridRooms = BuildEnumTable{prefix="ROOMIDX_", replace=function(e) return e:gsub("^ROOMIDX_", "ROOM_").."_IDX" end}
GridRooms.MAX_GRID_ROOMS = MAX_GRID_ROOMS
GridRooms.NUM_OFF_GRID_ROOMS = NUM_OFF_GRID_ROOMS
GridRooms.MAX_ROOMS = MAX_ROOMS
ItemPoolType = BuildEnumTable{direct="NUM_ITEMPOOLS", prefix="POOL_"}
ProjectileVariant = BuildEnumTable{prefix="PROJECTILE_"}
ProjectileFlags = BuildEnumTable{prefix="PF_", replace=""}
EntityPartition = BuildEnumTable{prefix="PARTITION_", replace=""}

-- Does anyone even use this? It's not even correct anymore
PlayerItemState = {
	ITEMSTATE_NORMAL = 0,
	ITEMSTATE_CANDLE = 1,
	ITEMSTATE_SHOOP_DA_WHOOP = 2,
	ITEMSTATE_BOBS_ROTTEN_HEAD = 3,
	ITEMSTATE_DOCTORS_REMOTE = 4,
	ITEMSTATE_PONY = 5,
	ITEMSTATE_NOTCHEDAXE = 6,
	ITEMSTATE_BOOMERANG = 7,
	ITEMSTATE_CANNON = 8,
	ITEMSTATE_FRIENDBALL = 9
}

-----------------------------------------------------------------
local function CreateWrapper(lib)
	local W = {}
	for k,v in pairs(lib) do
		W[k] = function(_, ...) return v(...) end
	end
	return W
end

local COMPAT_GAME = CreateWrapper(G.Game)
function Game() return COMPAT_GAME end

local COMPAT_LEVEL = CreateWrapper(G.Level)
function COMPAT_GAME.GetLevel() return COMPAT_LEVEL end

local COMPAT_ITEMPOOL = CreateWrapper(G.ItemPool)
function COMPAT_GAME.GetItemPool() return COMPAT_ITEMPOOL end

local COMPAT_SFX = CreateWrapper(G.SFX)
function SFXManager() return COMPAT_SFX end

local COMPAT_MUSIC = CreateWrapper(G.Music)
function MusicManager() return COMPAT_MUSIC end

----------------------------------------------------
setfenv(1, G)

setmetatable(COMPAT_ENV, {
	__index = function(self, k)
		return rawget(self, k) or rawget(_G, k)
	end;
	__newindex = function(self, k, v)
		rawset(_G, k, v)
	end;
})

return COMPAT_ENV