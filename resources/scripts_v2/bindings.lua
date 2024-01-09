local ffi = require("ffi")
local C = ffi.C

local checktype = luahelper.checktype
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
local _EntityRef = luahelper._EntityRef
local _RoomData = luahelper._RoomData
local _LevelGenerator = luahelper._LevelGenerator
local _LevelGeneratorRoom = luahelper._LevelGeneratorRoom

local ref_add = luahelper.ref_add
local ref_remove = luahelper.ref_remove
local CDATA = luahelper.CDATA

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
local LevelGenerator = luahelper.LevelGenerator_functions
local ANM2 = luahelper.ANM2_functions or {}
local color_default = _Color()
local kcolor_default = _KColor()
local vector_minus_one = _Vector(-1,-1)
local color_slow = _Color(1, 1, 1.3, 1, 0, 0, 0, 0, 40/255, 40/255, 40/255)
local vector_one = _Vector(1,1)
local entityref_default = _EntityRef()
local vector_zero = _Vector(0,0)

----------------------------------------------------------------------------

function RandomUnitVector()
	local ret = _Vector()
	C.L_RandomUnitVector(ret)
	return ret
end

if not Isaac then Isaac = {} end

function Isaac.GetPlayer(id)
	if id then checknumber(1, id) else id = 0 end
	return EntityHandle(C.LL_Isaac__GetPlayer(id))
end

function Isaac.GetFrameCount()
	return C.LL_Isaac__GetFrameCount()
end

function Isaac.RenderText(str, X, Y, Col)
	checkstring(1, str)
	checknumber(2, X)
	checknumber(3, Y)
	if Col then checkcdata(4, Col, _KColor) else Col = kcolor_default end
	C.LL_Isaac__RenderText(str, X, Y, Col)
end

function Isaac.RenderScaledText(str, X, Y, ScaleX, ScaleY, Col)
	checkstring(1, str)
	checknumber(2, X)
	checknumber(3, Y)
	checknumber(4, ScaleX)
	checknumber(5, ScaleY)
	if Col then checkcdata(6, Col, _KColor) else Col = kcolor_default end
	C.LL_Isaac__RenderScaledText(str, X, Y, ScaleX, ScaleY, Col)
end

function Isaac.GetTextWidth(str)
	checkstring(1, str)
	return C.LL_Isaac__GetTextWidth(str)
end

function Isaac.GetRandomPosition()
	local ret = _Vector()
	C.LL_Isaac__GetRandomPosition(ret)
	return ret
end

function Isaac.GetFreeNearPosition(pos, step, avoidActiveEntities)
	local ret = _Vector()
	checkcdata(1, pos, _Vector)
	if step then checknumber(2, step) else step = 0 end
	avoidActiveEntities = tobool(avoidActiveEntities)
	C.LL_Isaac__GetFreeNearPosition(ret, pos, step, avoidActiveEntities)
	return ret
end

function Isaac.AddPillEffectToPool(pillEffect)
	checknumber(1, pillEffect)
	return C.LL_Isaac__AddPillEffectToPool(pillEffect)
end

function Isaac.GetChallenge()
	return C.LL_Isaac__GetChallenge()
end

function Isaac.GetEntityTypeByName(entityName)
	checkstring(1, entityName)
	return C.LL_Isaac__GetEntityTypeByName(entityName)
end

function Isaac.GetEntityVariantByName(entityName)
	checkstring(1, entityName)
	return C.LL_Isaac__GetEntityVariantByName(entityName)
end

function Isaac.GetItemIdByName(itemName)
	checkstring(1, itemName)
	return C.LL_Isaac__GetItemIdByName(itemName)
end

function Isaac.GetPlayerTypeByName(playerName)
	checkstring(1, playerName)
	return C.LL_Isaac__GetPlayerTypeByName(playerName)
end

function Isaac.GetCardIdByName(cardName)
	checkstring(1, cardName)
	return C.LL_Isaac__GetCardIdByName(cardName)
end

function Isaac.GetPillEffectByName(pillEffect)
	checkstring(1, pillEffect)
	return C.LL_Isaac__GetPillEffectByName(pillEffect)
end

function Isaac.GetTrinketIdByName(trinketName)
	checkstring(1, trinketName)
	return C.LL_Isaac__GetTrinketIdByName(trinketName)
end

function Isaac.GetChallengeIdByName(challengeName)
	checkstring(1, challengeName)
	return C.LL_Isaac__GetChallengeIdByName(challengeName)
end

function Isaac.GetCostumeIdByPath(path)
	checkstring(1, path)
	return C.LL_Isaac__GetCostumeIdByPath(path)
end

function Isaac.GetCurseIdByName(curseName)
	checkstring(1, curseName)
	return C.LL_Isaac__GetCurseIdByName(curseName)
end

function Isaac.GetMusicIdByName(musicName)
	checkstring(1, musicName)
	return C.LL_Isaac__GetMusicIdByName(musicName)
end

function Isaac.GetSoundIdByName(soundName)
	checkstring(1, soundName)
	return C.LL_Isaac__GetSoundIdByName(soundName)
end

function Isaac.GetTime()
	return C.LL_Isaac__GetTime()
end

function Isaac.ExecuteCommand(command)
	checkstring(1, command)
	return ffi.string(C.LL_Isaac__ExecuteCommand(command))
end

function Isaac.ConsoleOutput(text)
	checkstring(1, text)
	C.LL_Isaac__ConsoleOutput(text)
end

function Isaac.CountEntities(Spawner, Type, Variant, Subtype)
	if Spawner then checkhandle(1, Spawner, META_Entity) else Spawner = EntityHandle(NULL) end
	if Type then checknumber(2, Type) else Type = 0 end
	if Variant then checknumber(3, Variant) else Variant = -1 end
	if Subtype then checknumber(4, Subtype) else Subtype = -1 end
	return C.LL_Isaac__CountEntities(CDATA(Spawner), Type, Variant, Subtype)
end

function Isaac.CountBosses()
	return C.LL_Isaac__CountBosses()
end

function Isaac.CountEnemies()
	return C.LL_Isaac__CountEnemies()
end

function Isaac.GetScreenWidth()
	return C.LL_Isaac__GetScreenWidth()
end

function Isaac.GetScreenHeight()
	return C.LL_Isaac__GetScreenHeight()
end

function Isaac.GetPointScale()
	return C.LL_Isaac__GetPointScale()
end

function Isaac.ScreenToWorld(pos)
	local ret = _Vector()
	checkcdata(1, pos, _Vector)
	C.LL_Isaac__ScreenToWorld(ret, pos)
	return ret
end

function Isaac.WorldToScreen(pos)
	local ret = _Vector()
	checkcdata(1, pos, _Vector)
	C.LL_Isaac__WorldToScreen(ret, pos)
	return ret
end

function Isaac.WorldToScreenDistance(pos)
	local ret = _Vector()
	checkcdata(1, pos, _Vector)
	C.LL_Isaac__WorldToScreenDistance(ret, pos)
	return ret
end

function Isaac.WorldToRenderPosition(pos)
	local ret = _Vector()
	checkcdata(1, pos, _Vector)
	C.LL_Isaac__WorldToRenderPosition(ret, pos)
	return ret
end

function Isaac.ScreenToWorldDistance(pos)
	local ret = _Vector()
	checkcdata(1, pos, _Vector)
	C.LL_Isaac__ScreenToWorldDistance(ret, pos)
	return ret
end

if not Input then Input = {} end

function Input.IsButtonTriggered(button, controllerId)
	checknumber(1, button)
	if controllerId then checknumber(2, controllerId) else controllerId = 4294967295 end
	return C.LL_Input__IsButtonTriggered(button, controllerId)
end

function Input.IsButtonPressed(button, controllerId)
	checknumber(1, button)
	if controllerId then checknumber(2, controllerId) else controllerId = 4294967295 end
	return C.LL_Input__IsButtonPressed(button, controllerId)
end

function Input.GetButtonValue(button, controllerId)
	checknumber(1, button)
	if controllerId then checknumber(2, controllerId) else controllerId = 4294967295 end
	return C.LL_Input__GetButtonValue(button, controllerId)
end

function Input.IsActionTriggered(action, controllerId)
	checknumber(1, action)
	if controllerId then checknumber(2, controllerId) else controllerId = 4294967295 end
	return C.LL_Input__IsActionTriggered(action, controllerId)
end

function Input.IsActionPressed(action, controllerId)
	checknumber(1, action)
	if controllerId then checknumber(2, controllerId) else controllerId = 4294967295 end
	return C.LL_Input__IsActionPressed(action, controllerId)
end

function Input.GetActionValue(action, controllerId)
	checknumber(1, action)
	if controllerId then checknumber(2, controllerId) else controllerId = 4294967295 end
	return C.LL_Input__GetActionValue(action, controllerId)
end

function Input.IsMouseBtnPressed(button)
	checknumber(1, button)
	return C.LL_Input__IsMouseBtnPressed(button)
end

function Input.GetMousePos(gameCoords)
	local ret = _Vector()
	gameCoords = tobool(gameCoords)
	C.LL_Input__GetMousePos(ret, gameCoords)
	return ret
end

if not Music then Music = {} end

function Music.Play(ID, Volume)
	checknumber(1, ID)
	checknumber(2, Volume)
	C.LL_Music__Play(ID, Volume)
end

function Music.Fadein(ID, Volume)
	checknumber(1, ID)
	checknumber(2, Volume)
	C.LL_Music__Fadein(ID, Volume)
end

function Music.Crossfade(ID)
	checknumber(1, ID)
	C.LL_Music__Crossfade(ID)
end

function Music.Queue(ID)
	checknumber(1, ID)
	C.LL_Music__Queue(ID)
end

function Music.Fadeout()
	C.LL_Music__Fadeout()
end

function Music.Pause()
	C.LL_Music__Pause()
end

function Music.Resume()
	C.LL_Music__Resume()
end

function Music.SetLayerEnabled(b)
	b = tobool(b)
	C.LL_Music__SetLayerEnabled(b)
end

function Music.IsLayerEnabled()
	return C.LL_Music__IsLayerEnabled()
end

function Music.SetEnabled(b)
	b = tobool(b)
	C.LL_Music__SetEnabled(b)
end

function Music.IsEnabled()
	return C.LL_Music__IsEnabled()
end

function Music.PitchSlide(TargetPitch)
	checknumber(1, TargetPitch)
	C.LL_Music__PitchSlide(TargetPitch)
end

function Music.ResetPitch()
	C.LL_Music__ResetPitch()
end

function Music.VolumeSlide(TargetVolume)
	checknumber(1, TargetVolume)
	C.LL_Music__VolumeSlide(TargetVolume)
end

function Music.UpdateVolume()
	C.LL_Music__UpdateVolume()
end

function Music.GetCurrentMusicID()
	return C.LL_Music__GetCurrentMusicID()
end

function Music.GetQueuedMusicID()
	return C.LL_Music__GetQueuedMusicID()
end

if not SFX then SFX = {} end

function SFX.Play(ID, Volume, FrameDelay, Loop, Pitch)
	checknumber(1, ID)
	if Volume then checknumber(2, Volume) else Volume = 1 end
	if FrameDelay then checknumber(3, FrameDelay) else FrameDelay = 2 end
	Loop = tobool(Loop)
	if Pitch then checknumber(5, Pitch) else Pitch = 1 end
	C.LL_SFX__Play(ID, Volume, FrameDelay, Loop, Pitch)
end

function SFX.AdjustVolume(ID, Volume)
	checknumber(1, ID)
	checknumber(2, Volume)
	C.LL_SFX__AdjustVolume(ID, Volume)
end

function SFX.AdjustPitch(ID, Pitch)
	checknumber(1, ID)
	checknumber(2, Pitch)
	C.LL_SFX__AdjustPitch(ID, Pitch)
end

function SFX.Stop(ID)
	checknumber(1, ID)
	C.LL_SFX__Stop(ID)
end

function SFX.StopLoopingSounds()
	C.LL_SFX__StopLoopingSounds()
end

function SFX.Preload(ID)
	checknumber(1, ID)
	C.LL_SFX__Preload(ID)
end

function SFX.IsPlaying(ID)
	checknumber(1, ID)
	return C.LL_SFX__IsPlaying(ID)
end

function SFX.SetAmbientSound(ID, Volume, Pitch)
	checknumber(1, ID)
	if Volume then checknumber(2, Volume) else Volume = 1 end
	if Pitch then checknumber(3, Pitch) else Pitch = 1 end
	C.LL_SFX__SetAmbientSound(ID, Volume, Pitch)
end

function SFX.GetAmbientSoundVolume(ID)
	checknumber(1, ID)
	return C.LL_SFX__GetAmbientSoundVolume(ID)
end

function Entity:GetFriction()
	return C.LC_Entity__GetFriction(CDATA(self))
end

function Entity:SetFriction(friction)
	checknumber(2, friction)
	C.LC_Entity__SetFriction(CDATA(self), friction)
end

function Entity:GetPosition()
	local ret = _Vector()
	C.LC_Entity__GetPosition(ret, CDATA(self))
	return ret
end

function Entity:SetPosition(v)
	checkcdata(2, v, _Vector)
	C.LC_Entity__SetPosition(CDATA(self), v)
end

function Entity:GetVelocity()
	local ret = _Vector()
	C.LC_Entity__GetVelocity(ret, CDATA(self))
	return ret
end

function Entity:SetVelocity(v)
	checkcdata(2, v, _Vector)
	C.LC_Entity__SetVelocity(CDATA(self), v)
end

function Entity:GetDefaultColor()
	local ret = _Color()
	C.LC_Entity__GetDefaultColor(ret, CDATA(self))
	return ret
end

function Entity:GetColor()
	local ret = _Color()
	C.LC_Entity__GetColor(ret, CDATA(self))
	return ret
end

function Entity:SetColor(Col, Duration, Priority, Fadeout, Share)
	checkcdata(2, Col, _Color)
	if Duration then checknumber(3, Duration) else Duration = -1 end
	if Priority then checknumber(4, Priority) else Priority = 255 end
	Fadeout = tobool(Fadeout)
	if Share ~= nil then Share = tobool(Share) else Share = true end
	C.LC_Entity__SetColor(CDATA(self), Col, Duration, Priority, Fadeout, Share)
end

function Entity:Update()
	C.LC_Entity__Update(CDATA(self))
end

function Entity:Render(Offset)
	checkcdata(2, Offset, _Vector)
	C.LC_Entity__Render(CDATA(self), Offset)
end

function Entity:RenderShadowLayer(Offset)
	checkcdata(2, Offset, _Vector)
	return C.LC_Entity__RenderShadowLayer(CDATA(self), Offset)
end

function Entity:PostRender()
	C.LC_Entity__PostRender(CDATA(self))
end

function Entity:TakeDamage(Damage, Flags, Source, DamageCountdown)
	checknumber(2, Damage)
	if Flags then checknumber(3, Flags) else Flags = 0 end
	if Source then Source = toentityref(4, Source) else Source = entityref_default end
	if DamageCountdown then checknumber(5, DamageCountdown) else DamageCountdown = 30 end
	return C.LC_Entity__TakeDamage(CDATA(self), Damage, Flags, Source, DamageCountdown)
end

function Entity:HasMortalDamage()
	return C.LC_Entity__HasMortalDamage(CDATA(self))
end

function Entity:Kill()
	C.LC_Entity__Kill(CDATA(self))
end

function Entity:Die()
	C.LC_Entity__Die(CDATA(self))
end

function Entity:Remove()
	C.LC_Entity__Remove(CDATA(self))
end

function Entity:BloodExplode()
	C.LC_Entity__BloodExplode(CDATA(self))
end

function Entity:GetType()
	return C.LC_Entity__GetType(CDATA(self))
end

function Entity:GetVariant()
	return C.LC_Entity__GetVariant(CDATA(self))
end

function Entity:SetVariant(v)
	checknumber(2, v)
	C.LC_Entity__SetVariant(CDATA(self), v)
end

function Entity:GetSubType()
	return C.LC_Entity__GetSubType(CDATA(self))
end

function Entity:SetSubType(v)
	checknumber(2, v)
	C.LC_Entity__SetSubType(CDATA(self), v)
end

function Entity:GetSpawnerType()
	return C.LC_Entity__GetSpawnerType(CDATA(self))
end

function Entity:SetSpawnerType(v)
	checknumber(2, v)
	C.LC_Entity__SetSpawnerType(CDATA(self), v)
end

function Entity:GetSpawnerVariant()
	return C.LC_Entity__GetSpawnerVariant(CDATA(self))
end

function Entity:SetSpawnerVariant(v)
	checknumber(2, v)
	C.LC_Entity__SetSpawnerVariant(CDATA(self), v)
end

function Entity:AddVelocity(vel)
	checkcdata(2, vel, _Vector)
	C.LC_Entity__AddVelocity(CDATA(self), vel)
end

function Entity:MultiplyFriction(mul)
	checknumber(2, mul)
	C.LC_Entity__MultiplyFriction(CDATA(self), mul)
end

function Entity:GetSplatColor()
	local ret = _Color()
	C.LC_Entity__GetSplatColor(ret, CDATA(self))
	return ret
end

function Entity:SetSplatColor(v)
	checkcdata(2, v, _Color)
	C.LC_Entity__SetSplatColor(CDATA(self), v)
end

function Entity:GetVisible()
	return C.LC_Entity__GetVisible(CDATA(self))
end

function Entity:SetVisible(v)
	v = tobool(v)
	C.LC_Entity__SetVisible(CDATA(self), v)
end

function Entity:GetPositionOffset()
	local ret = _Vector()
	C.LC_Entity__GetPositionOffset(ret, CDATA(self))
	return ret
end

function Entity:SetPositionOffset(v)
	checkcdata(2, v, _Vector)
	C.LC_Entity__SetPositionOffset(CDATA(self), v)
end

function Entity:GetRenderZOffset()
	return C.LC_Entity__GetRenderZOffset(CDATA(self))
end

function Entity:SetRenderZOffset(v)
	checknumber(2, v)
	C.LC_Entity__SetRenderZOffset(CDATA(self), v)
end

function Entity:GetFlipX()
	return C.LC_Entity__GetFlipX(CDATA(self))
end

function Entity:SetFlipX(v)
	v = tobool(v)
	C.LC_Entity__SetFlipX(CDATA(self), v)
end

function Entity:GetSpriteOffset()
	local ret = _Vector()
	C.LC_Entity__GetSpriteOffset(ret, CDATA(self))
	return ret
end

function Entity:SetSpriteOffset(v)
	checkcdata(2, v, _Vector)
	C.LC_Entity__SetSpriteOffset(CDATA(self), v)
end

function Entity:GetSpriteScale()
	local ret = _Vector()
	C.LC_Entity__GetSpriteScale(ret, CDATA(self))
	return ret
end

function Entity:SetSpriteScale(v)
	checkcdata(2, v, _Vector)
	C.LC_Entity__SetSpriteScale(CDATA(self), v)
end

function Entity:GetSpriteRotation()
	return C.LC_Entity__GetSpriteRotation(CDATA(self))
end

function Entity:SetSpriteRotation(v)
	checknumber(2, v)
	C.LC_Entity__SetSpriteRotation(CDATA(self), v)
end

function Entity:SetSpriteFrame(Anim, FrameNum)
	checkstring(2, Anim)
	checknumber(3, FrameNum)
	C.LC_Entity__SetSpriteFrame(CDATA(self), Anim, FrameNum)
end

function Entity:SetSpriteOverlayFrame(Anim, FrameNum)
	checkstring(2, Anim)
	checknumber(3, FrameNum)
	C.LC_Entity__SetSpriteOverlayFrame(CDATA(self), Anim, FrameNum)
end

function Entity:GetSize()
	return C.LC_Entity__GetSize(CDATA(self))
end

function Entity:SetSize(Size, SizeMulti, NumGridCollisionPoints)
	checknumber(2, Size)
	if SizeMulti then checkcdata(3, SizeMulti, _Vector) else SizeMulti = vector_minus_one end
	if NumGridCollisionPoints then checknumber(4, NumGridCollisionPoints) else NumGridCollisionPoints = -1 end
	C.LC_Entity__SetSize(CDATA(self), Size, SizeMulti, NumGridCollisionPoints)
end

function Entity:GetSizeMulti()
	local ret = _Vector()
	C.LC_Entity__GetSizeMulti(ret, CDATA(self))
	return ret
end

function Entity:SetSizeMulti(v)
	checkcdata(2, v, _Vector)
	C.LC_Entity__SetSizeMulti(CDATA(self), v)
end

function Entity:GetMass()
	return C.LC_Entity__GetMass(CDATA(self))
end

function Entity:SetMass(v)
	checknumber(2, v)
	C.LC_Entity__SetMass(CDATA(self), v)
end

function Entity:GetMaxHitPoints()
	return C.LC_Entity__GetMaxHitPoints(CDATA(self))
end

function Entity:SetMaxHitPoints(v)
	checknumber(2, v)
	C.LC_Entity__SetMaxHitPoints(CDATA(self), v)
end

function Entity:GetHitPoints()
	return C.LC_Entity__GetHitPoints(CDATA(self))
end

function Entity:SetHitPoints(v)
	checknumber(2, v)
	C.LC_Entity__SetHitPoints(CDATA(self), v)
end

function Entity:GetIndex()
	return C.LC_Entity__GetIndex(CDATA(self))
end

function Entity:GetTargetPosition()
	local ret = _Vector()
	C.LC_Entity__GetTargetPosition(ret, CDATA(self))
	return ret
end

function Entity:SetTargetPosition(v)
	checkcdata(2, v, _Vector)
	C.LC_Entity__SetTargetPosition(CDATA(self), v)
end

function Entity:GetGridCollisionClass()
	return C.LC_Entity__GetGridCollisionClass(CDATA(self))
end

function Entity:SetGridCollisionClass(v)
	checknumber(2, v)
	C.LC_Entity__SetGridCollisionClass(CDATA(self), v)
end

function Entity:GetEntityCollisionClass()
	return C.LC_Entity__GetEntityCollisionClass(CDATA(self))
end

function Entity:SetEntityCollisionClass(v)
	checknumber(2, v)
	C.LC_Entity__SetEntityCollisionClass(CDATA(self), v)
end

function Entity:GetCollisionDamage()
	return C.LC_Entity__GetCollisionDamage(CDATA(self))
end

function Entity:SetCollisionDamage(v)
	checknumber(2, v)
	C.LC_Entity__SetCollisionDamage(CDATA(self), v)
end

function Entity:CollidesWithGrid()
	return C.LC_Entity__CollidesWithGrid(CDATA(self))
end

function Entity:GetSpawnGridIndex()
	return C.LC_Entity__GetSpawnGridIndex(CDATA(self))
end

function Entity:IsEnemy()
	return C.LC_Entity__IsEnemy(CDATA(self))
end

function Entity:IsActiveEnemy()
	return C.LC_Entity__IsActiveEnemy(CDATA(self))
end

function Entity:IsVulnerableEnemy()
	return C.LC_Entity__IsVulnerableEnemy(CDATA(self))
end

function Entity:IsFlying()
	return C.LC_Entity__IsFlying(CDATA(self))
end

function Entity:AddEntityFlags(Flags)
	checknumber(2, Flags)
	C.LC_Entity__AddEntityFlags(CDATA(self), Flags)
end

function Entity:ClearEntityFlags(Flags)
	checknumber(2, Flags)
	C.LC_Entity__ClearEntityFlags(CDATA(self), Flags)
end

function Entity:GetEntityFlags()
	return C.LC_Entity__GetEntityFlags(CDATA(self))
end

function Entity:HasEntityFlags(Flags)
	checknumber(2, Flags)
	return C.LC_Entity__HasEntityFlags(CDATA(self), Flags)
end

function Entity:HasFullHealth()
	return C.LC_Entity__HasFullHealth(CDATA(self))
end

function Entity:AddHealth(Health)
	checknumber(2, Health)
	C.LC_Entity__AddHealth(CDATA(self), Health)
end

function Entity:AddPoison(Source, Duration, Damage)
	Source = toentityref(2, Source)
	checknumber(3, Duration)
	if Damage then checknumber(4, Damage) else Damage = 0 end
	C.LC_Entity__AddPoison(CDATA(self), Source, Duration, Damage)
end

function Entity:AddFreeze(Source, Duration)
	Source = toentityref(2, Source)
	checknumber(3, Duration)
	C.LC_Entity__AddFreeze(CDATA(self), Source, Duration)
end

function Entity:AddSlowing(Source, Duration, Slow, Col)
	Source = toentityref(2, Source)
	checknumber(3, Duration)
	if Slow then checknumber(4, Slow) else Slow = 0.899999976 end
	if Col then checkcdata(5, Col, _Color) else Col = color_slow end
	C.LC_Entity__AddSlowing(CDATA(self), Source, Duration, Slow, Col)
end

function Entity:AddCharmed(Source, Duration)
	Source = toentityref(2, Source)
	checknumber(3, Duration)
	C.LC_Entity__AddCharmed(CDATA(self), Source, Duration)
end

function Entity:AddConfusion(Source, Duration, IgnoreBosses)
	Source = toentityref(2, Source)
	checknumber(3, Duration)
	IgnoreBosses = tobool(IgnoreBosses)
	C.LC_Entity__AddConfusion(CDATA(self), Source, Duration, IgnoreBosses)
end

function Entity:AddMidasFreeze(Source, Duration)
	Source = toentityref(2, Source)
	checknumber(3, Duration)
	C.LC_Entity__AddMidasFreeze(CDATA(self), Source, Duration)
end

function Entity:AddFear(Source, Duration)
	Source = toentityref(2, Source)
	checknumber(3, Duration)
	C.LC_Entity__AddFear(CDATA(self), Source, Duration)
end

function Entity:AddBurn(Source, Duration, Damage)
	Source = toentityref(2, Source)
	checknumber(3, Duration)
	checknumber(4, Damage)
	C.LC_Entity__AddBurn(CDATA(self), Source, Duration, Damage)
end

function Entity:AddShrink(Source, Duration)
	Source = toentityref(2, Source)
	checknumber(3, Duration)
	C.LC_Entity__AddShrink(CDATA(self), Source, Duration)
end

function Entity:RemoveStatusEffects()
	C.LC_Entity__RemoveStatusEffects(CDATA(self))
end

function Entity:Exists()
	return C.LC_Entity__Exists(CDATA(self))
end

function Entity:IsDead()
	return C.LC_Entity__IsDead(CDATA(self))
end

function Entity:IsVisible()
	return C.LC_Entity__IsVisible(CDATA(self))
end

function Entity:IsInvincible()
	return C.LC_Entity__IsInvincible(CDATA(self))
end

function Entity:CanShutDoors()
	return C.LC_Entity__CanShutDoors(CDATA(self))
end

function Entity:IsBoss()
	return C.LC_Entity__IsBoss(CDATA(self))
end

function Entity:GetBossID()
	return C.LC_Entity__GetBossID(CDATA(self))
end

function Entity:GetParent()
	return EntityHandle(C.LC_Entity__GetParent(CDATA(self)))
end

function Entity:SetParent(v)
	checkhandle(2, v, META_Entity)
	C.LC_Entity__SetParent(CDATA(self), CDATA(v))
end

function Entity:GetChild()
	return EntityHandle(C.LC_Entity__GetChild(CDATA(self)))
end

function Entity:SetChild(v)
	checkhandle(2, v, META_Entity)
	C.LC_Entity__SetChild(CDATA(self), CDATA(v))
end

function Entity:GetTarget()
	return EntityHandle(C.LC_Entity__GetTarget(CDATA(self)))
end

function Entity:SetTarget(v)
	checkhandle(2, v, META_Entity)
	C.LC_Entity__SetTarget(CDATA(self), CDATA(v))
end

function Entity:GetSpawnerEntity()
	return EntityHandle(C.LC_Entity__GetSpawnerEntity(CDATA(self)))
end

function Entity:SetSpawnerEntity(v)
	checkhandle(2, v, META_Entity)
	C.LC_Entity__SetSpawnerEntity(CDATA(self), CDATA(v))
end

function Entity:GetLastParent()
	return EntityHandle(C.LC_Entity__GetLastParent(CDATA(self)))
end

function Entity:GetLastChild()
	return EntityHandle(C.LC_Entity__GetLastChild(CDATA(self)))
end

function Entity:HasCommonParentWithEntity(other)
	checkhandle(2, other, META_Entity)
	return C.LC_Entity__HasCommonParentWithEntity(CDATA(self), CDATA(other))
end

function Entity:GetFrameCount()
	return C.LC_Entity__GetFrameCount(CDATA(self))
end

function Entity:IsFrame(Frame, Offset)
	checknumber(2, Frame)
	checknumber(3, Offset)
	return C.LC_Entity__IsFrame(CDATA(self), Frame, Offset)
end

function Entity:GetInitSeed()
	return C.LC_Entity__GetInitSeed(CDATA(self))
end

function Entity:GetDropSeed()
	return C.LC_Entity__GetDropSeed(CDATA(self))
end

function Entity:GetDropRNG()
	return C.LC_Entity__GetDropRNG(CDATA(self))
end

function Entity:GetSprite()
	return C.LC_Entity__GetSprite(CDATA(self))
end

function Entity:GetDepthOffset()
	return C.LC_Entity__GetDepthOffset(CDATA(self))
end

function Entity:SetDepthOffset(v)
	checknumber(2, v)
	C.LC_Entity__SetDepthOffset(CDATA(self), v)
end

function Entity:IsEntityConnected(other)
	if other then checkhandle(2, other, META_Entity) else other = EntityHandle(NULL) end
	return C.LC_Entity__IsEntityConnected(CDATA(self), CDATA(other))
end

function Entity:DoesEntityShareStatus()
	return C.LC_Entity__DoesEntityShareStatus(CDATA(self))
end

if not Game then Game = {} end

function Game.Update()
	C.LL_Game__Update()
end

function Game.Render()
	C.LL_Game__Render()
end

function Game.IsPaused()
	return C.LL_Game__IsPaused()
end

function Game.Spawn(Type, Variant, Position, Velocity, Spawner, SubType, Seed)
	checknumber(1, Type)
	checknumber(2, Variant)
	checkcdata(3, Position, _Vector)
	checkcdata(4, Velocity, _Vector)
	if Spawner then checkhandle(5, Spawner, META_Entity) else Spawner = EntityHandle(NULL) end
	if SubType then checknumber(6, SubType) else SubType = 0 end
	if Seed then checknumber(7, Seed) else Seed = Random() end
	return EntityHandle(C.LL_Game__Spawn(Type, Variant, Position, Velocity, CDATA(Spawner), SubType, Seed))
end

function Game.BombDamage(pos, damage, radius, lineCheck, source, tearFlags, damageFlags, damageSource)
	checkcdata(1, pos, _Vector)
	checknumber(2, damage)
	checknumber(3, radius)
	lineCheck = tobool(lineCheck)
	if source then checkhandle(5, source, META_Entity) else source = EntityHandle(NULL) end
	if tearFlags then checkcdata(6, tearFlags, _BitSet128) else tearFlags = 0 end
	if damageFlags then checknumber(7, damageFlags) else damageFlags = DMG_EXPLOSION end
	damageSource = tobool(damageSource)
	C.LL_Game__BombDamage(pos, damage, radius, lineCheck, CDATA(source), tearFlags, damageFlags, damageSource)
end

function Game.BombExplosionEffects(pos, damage, tearFlags, color, source, radiusMult, lineCheck, damageSource)
	checkcdata(1, pos, _Vector)
	checknumber(2, damage)
	if tearFlags then checkcdata(3, tearFlags, _BitSet128) else tearFlags = 0 end
	if color then checkcdata(4, color, _Color) else color = color_default end
	if source then checkhandle(5, source, META_Entity) else source = EntityHandle(NULL) end
	if radiusMult then checknumber(6, radiusMult) else radiusMult = 1 end
	if lineCheck ~= nil then lineCheck = tobool(lineCheck) else lineCheck = true end
	damageSource = tobool(damageSource)
	C.LL_Game__BombExplosionEffects(pos, damage, tearFlags, color, CDATA(source), radiusMult, lineCheck, damageSource)
end

function Game.BombTearflagEffects(pos, radius, tearFlags, source)
	checkcdata(1, pos, _Vector)
	checknumber(2, radius)
	if tearFlags then checkcdata(3, tearFlags, _BitSet128) else tearFlags = 0 end
	if source then checkhandle(4, source, META_Entity) else source = EntityHandle(NULL) end
	C.LL_Game__BombTearflagEffects(pos, radius, tearFlags, CDATA(source))
end

function Game.Fart(pos, radius, source, scale, subType)
	checkcdata(1, pos, _Vector)
	if radius then checknumber(2, radius) else radius = 85 end
	if source then checkhandle(3, source, META_Entity) else source = EntityHandle(NULL) end
	if scale then checknumber(4, scale) else scale = 1 end
	if subType then checknumber(5, subType) else subType = 0 end
	C.LL_Game__Fart(pos, radius, CDATA(source), scale, subType)
end

function Game.CharmFart(pos, radius, source)
	checkcdata(1, pos, _Vector)
	if radius then checknumber(2, radius) else radius = 100 end
	if source then checkhandle(3, source, META_Entity) else source = EntityHandle(NULL) end
	C.LL_Game__CharmFart(pos, radius, CDATA(source))
end

function Game.ButterBeanFart(pos, radius, source, showEffect)
	checkcdata(1, pos, _Vector)
	if radius then checknumber(2, radius) else radius = 120 end
	if source then checkhandle(3, source, META_Entity) else source = EntityHandle(NULL) end
	if showEffect ~= nil then showEffect = tobool(showEffect) else showEffect = true end
	C.LL_Game__ButterBeanFart(pos, radius, CDATA(source), showEffect)
end

function Game.RerollEnemy(e)
	checkhandle(1, e, META_Entity)
	return C.LL_Game__RerollEnemy(CDATA(e))
end

function Game.SpawnParticles(pos, particleType, numParticles, speed, color, height, subType)
	checkcdata(1, pos, _Vector)
	checknumber(2, particleType)
	checknumber(3, numParticles)
	checknumber(4, speed)
	if color then checkcdata(5, color, _Color) else color = color_default end
	if height then checknumber(6, height) else height = 100000 end
	if subType then checknumber(7, subType) else subType = 0 end
	C.LL_Game__SpawnParticles(pos, particleType, numParticles, speed, color, height, subType)
end

function Game.GetFont()
	return C.LL_Game__GetFont()
end

function Game.GetNearestPlayer(pos)
	checkcdata(1, pos, _Vector)
	return EntityHandle(C.LL_Game__GetNearestPlayer(pos))
end

function Game.GetRandomPlayer(pos, radius)
	checkcdata(1, pos, _Vector)
	checknumber(2, radius)
	return EntityHandle(C.LL_Game__GetRandomPlayer(pos, radius))
end

function Game.GetNumPlayers()
	return C.LL_Game__GetNumPlayers()
end

function Game.End(ending)
	checknumber(1, ending)
	C.LL_Game__End(ending)
end

function Game.ShowFortune()
	C.LL_Game__ShowFortune()
end

function Game.ShowRule()
	C.LL_Game__ShowRule()
end

function Game.StartRoomTransition(roomIndex, direction, anim, player)
	checknumber(1, roomIndex)
	checknumber(2, direction)
	if anim then checknumber(3, anim) else anim = ROOMTRANSITION_WALK end
	if player then checkhandle(4, player, META_Entity_Player) else player = EntityHandle(NULL) end
	C.LL_Game__StartRoomTransition(roomIndex, direction, anim, CDATA(player))
end

function Game.ChangeRoom(roomIndex)
	checknumber(1, roomIndex)
	C.LL_Game__ChangeRoom(roomIndex)
end

function Game.StartStageTransition(sameStage, anim, player)
	sameStage = tobool(sameStage)
	if anim then checknumber(2, anim) else anim = STAGETRANSITION_CRY end
	if player then checkhandle(3, player, META_Entity_Player) else player = EntityHandle(NULL) end
	C.LL_Game__StartStageTransition(sameStage, anim, CDATA(player))
end

function Game.MoveToRandomRoom(allowErrorRoom, seed)
	allowErrorRoom = tobool(allowErrorRoom)
	if seed then checknumber(2, seed) else seed = Random() end
	C.LL_Game__MoveToRandomRoom(allowErrorRoom, seed)
end

function Game.GetFrameCount()
	return C.LL_Game__GetFrameCount()
end

function Game.GetStateFlag(flag)
	checknumber(1, flag)
	return C.LL_Game__GetStateFlag(flag)
end

function Game.SetStateFlag(flag, value)
	checknumber(1, flag)
	value = tobool(value)
	C.LL_Game__SetStateFlag(flag, value)
end

function Game.GetBossRushParTime()
	return C.LL_Game__GetBossRushParTime()
end

function Game.SetBossRushParTime(v)
	checknumber(1, v)
	C.LL_Game__SetBossRushParTime(v)
end

function Game.GetBlueWombParTime()
	return C.LL_Game__GetBlueWombParTime()
end

function Game.SetBlueWombParTime(v)
	checknumber(1, v)
	C.LL_Game__SetBlueWombParTime(v)
end

function Game.GetLastDevilRoomStage()
	return C.LL_Game__GetLastDevilRoomStage()
end

function Game.SetLastDevilRoomStage(v)
	checknumber(1, v)
	C.LL_Game__SetLastDevilRoomStage(v)
end

function Game.AddTreasureRoomsVisited()
	C.LL_Game__AddTreasureRoomsVisited()
end

function Game.GetTreasureRoomVisitCount()
	return C.LL_Game__GetTreasureRoomVisitCount()
end

function Game.AddStageWithoutHeartsPicked()
	C.LL_Game__AddStageWithoutHeartsPicked()
end

function Game.ClearStagesWithoutHeartsPicked()
	C.LL_Game__ClearStagesWithoutHeartsPicked()
end

function Game.GetStagesWithoutHeartsPicked()
	return C.LL_Game__GetStagesWithoutHeartsPicked()
end

function Game.AddStageWithoutDamage()
	C.LL_Game__AddStageWithoutDamage()
end

function Game.ClearStagesWithoutDamage()
	C.LL_Game__ClearStagesWithoutDamage()
end

function Game.GetStagesWithoutDamage()
	return C.LL_Game__GetStagesWithoutDamage()
end

function Game.DonateGreed(donate)
	if donate then checknumber(1, donate) else donate = 1 end
	C.LL_Game__DonateGreed(donate)
end

function Game.DonateAngel(donate)
	if donate then checknumber(1, donate) else donate = 1 end
	C.LL_Game__DonateAngel(donate)
end

function Game.GetDevilRoomDeals()
	return C.LL_Game__GetDevilRoomDeals()
end

function Game.GetDonationModGreed()
	return C.LL_Game__GetDonationModGreed()
end

function Game.GetDonationModAngel()
	return C.LL_Game__GetDonationModAngel()
end

function Game.ClearDonationModGreed()
	C.LL_Game__ClearDonationModGreed()
end

function Game.ClearDonationModAngel()
	C.LL_Game__ClearDonationModAngel()
end

function Game.GetLastLevelWithDamage()
	return C.LL_Game__GetLastLevelWithDamage()
end

function Game.SetLastLevelWithDamage(v)
	checknumber(1, v)
	C.LL_Game__SetLastLevelWithDamage(v)
end

function Game.AddEncounteredBoss(boss, variant)
	checknumber(1, boss)
	checknumber(2, variant)
	C.LL_Game__AddEncounteredBoss(boss, variant)
end

function Game.GetNumEncounteredBosses()
	return C.LL_Game__GetNumEncounteredBosses()
end

function Game.HasEncounteredBoss(boss, variant)
	checknumber(1, boss)
	checknumber(2, variant)
	return C.LL_Game__HasEncounteredBoss(boss, variant)
end

function Game.GetGreedWavesNum()
	return C.LL_Game__GetGreedWavesNum()
end

function Game.GetGreedBossWaveNum()
	return C.LL_Game__GetGreedBossWaveNum()
end

function Game.GetLastLevelWithoutHalfHp()
	return C.LL_Game__GetLastLevelWithoutHalfHp()
end

function Game.SetLastLevelWithoutHalfHp(v)
	checknumber(1, v)
	C.LL_Game__SetLastLevelWithoutHalfHp(v)
end

function Game.ShakeScreen(timeout)
	checknumber(1, timeout)
	C.LL_Game__ShakeScreen(timeout)
end

function Game.GetScreenShakeOffset()
	local ret = _Vector()
	C.LL_Game__GetScreenShakeOffset(ret)
	return ret
end

function Game.SetScreenShakeOffset(v)
	checkcdata(1, v, _Vector)
	C.LL_Game__SetScreenShakeOffset(v)
end

function Game.GetScreenShakeCountdown()
	return C.LL_Game__GetScreenShakeCountdown()
end

function Game.Darken(darkness, timeout)
	checknumber(1, darkness)
	checknumber(2, timeout)
	C.LL_Game__Darken(darkness, timeout)
end

function Game.GetDarknessModifier()
	return C.LL_Game__GetDarknessModifier()
end

function Game.SetDarknessModifier(v)
	checknumber(1, v)
	C.LL_Game__SetDarknessModifier(v)
end

function Game.GetTargetDarkness()
	return C.LL_Game__GetTargetDarkness()
end

function Game.GetChallenge()
	return C.LL_Game__GetChallenge()
end

function Game.SetChallenge(v)
	checknumber(1, v)
	C.LL_Game__SetChallenge(v)
end

function Game.GetDifficulty()
	return C.LL_Game__GetDifficulty()
end

function Game.GetVictoryLap()
	return C.LL_Game__GetVictoryLap()
end

function Game.NextVictoryLap()
	C.LL_Game__NextVictoryLap()
end

function Game.IsGreedMode()
	return C.LL_Game__IsGreedMode()
end

function Game.RerollLevelCollectibles()
	C.LL_Game__RerollLevelCollectibles()
end

function Game.RerollLevelPickups(seed)
	checknumber(1, seed)
	C.LL_Game__RerollLevelPickups(seed)
end

function Game.FinishChallenge()
	C.LL_Game__FinishChallenge()
end

function Game.AddPixelation(duration)
	checknumber(1, duration)
	C.LL_Game__AddPixelation(duration)
end

function Game.ShowHallucination(duration, backdrop)
	checknumber(1, duration)
	checknumber(2, backdrop)
	C.LL_Game__ShowHallucination(duration, backdrop)
end

function Game.HasHallucination()
	return C.LL_Game__HasHallucination()
end

function Game.UpdateStrangeAttractor(pos)
	checkcdata(1, pos, _Vector)
	C.LL_Game__UpdateStrangeAttractor(pos)
end

function Game.Fadein(speed)
	checknumber(1, speed)
	C.LL_Game__Fadein(speed)
end

function Game.Fadeout(speed, target)
	checknumber(1, speed)
	checknumber(2, target)
	C.LL_Game__Fadeout(speed, target)
end

function Game.GetTimeCounter()
	return C.LL_Game__GetTimeCounter()
end

function Game.SetTimeCounter(t)
	checknumber(1, t)
	C.LL_Game__SetTimeCounter(t)
end

if not Level then Level = {} end

function Level.Update()
	C.LL_Level__Update()
end

function Level.SetStage(stage, stageType)
	checknumber(1, stage)
	checknumber(2, stageType)
	C.LL_Level__SetStage(stage, stageType)
end

function Level.SetNextStage()
	C.LL_Level__SetNextStage()
end

function Level.GetStage()
	return C.LL_Level__GetStage()
end

function Level.GetCurses()
	return C.LL_Level__GetCurses()
end

function Level.IsAltStage()
	return C.LL_Level__IsAltStage()
end

function Level.GetStageType()
	return C.LL_Level__GetStageType()
end

function Level.GetName()
	return ffi.string(C.LL_Level__GetName())
end

function Level.GetCurseName()
	return ffi.string(C.LL_Level__GetCurseName())
end

function Level.CanStageHaveCurseOfLabyrinth(stage)
	checknumber(1, stage)
	return C.LL_Level__CanStageHaveCurseOfLabyrinth(stage)
end

function Level.ShowName(sticky)
	sticky = tobool(sticky)
	C.LL_Level__ShowName(sticky)
end

function Level.GetStateFlag(stateFlag)
	checknumber(1, stateFlag)
	return C.LL_Level__GetStateFlag(stateFlag)
end

function Level.SetStateFlag(stateFlag, val)
	checknumber(1, stateFlag)
	if val ~= nil then val = tobool(val) else val = true end
	C.LL_Level__SetStateFlag(stateFlag, val)
end

function Level.GetPreviousRoomIndex()
	return C.LL_Level__GetPreviousRoomIndex()
end

function Level.GetCurrentRoomIndex()
	return C.LL_Level__GetCurrentRoomIndex()
end

function Level.GetRoomCount()
	return C.LL_Level__GetRoomCount()
end

function Level.GetRandomRoomIndex(includeErrorRoom, seed)
	includeErrorRoom = tobool(includeErrorRoom)
	if seed then checknumber(2, seed) else seed = Random() end
	return C.LL_Level__GetRandomRoomIndex(includeErrorRoom, seed)
end

function Level.GetNonCompleteRoomIndex()
	return C.LL_Level__GetNonCompleteRoomIndex()
end

function Level.GetStartingRoomIndex()
	return C.LL_Level__GetStartingRoomIndex()
end

function Level.QueryRoomTypeIndex(roomType, visited, rng)
	checknumber(1, roomType)
	visited = tobool(visited)
	checkcdata(3, rng, _RNG)
	return C.LL_Level__QueryRoomTypeIndex(roomType, visited, rng)
end

function Level.GetLastBossRoomListIndex()
	return C.LL_Level__GetLastBossRoomListIndex()
end

function Level.CanOpenChallengeRoom(roomIndex)
	checknumber(1, roomIndex)
	return C.LL_Level__CanOpenChallengeRoom(roomIndex)
end

function Level.GetEnterDoor()
	return C.LL_Level__GetEnterDoor()
end

function Level.SetEnterDoor(v)
	checknumber(1, v)
	C.LL_Level__SetEnterDoor(v)
end

function Level.GetLeaveDoor()
	return C.LL_Level__GetLeaveDoor()
end

function Level.SetLeaveDoor(v)
	checknumber(1, v)
	C.LL_Level__SetLeaveDoor(v)
end

function Level.GetDungeonReturnPosition()
	local ret = _Vector()
	C.LL_Level__GetDungeonReturnPosition(ret)
	return ret
end

function Level.SetDungeonReturnPosition(v)
	checkcdata(1, v, _Vector)
	C.LL_Level__SetDungeonReturnPosition(v)
end

function Level.GetDungeonReturnRoomIndex()
	return C.LL_Level__GetDungeonReturnRoomIndex()
end

function Level.SetDungeonReturnRoomIndex(v)
	checknumber(1, v)
	C.LL_Level__SetDungeonReturnRoomIndex(v)
end

function Level.GetEnterPosition()
	local ret = _Vector()
	C.LL_Level__GetEnterPosition(ret)
	return ret
end

function Level.ChangeRoom(roomIndex)
	checknumber(1, roomIndex)
	C.LL_Level__ChangeRoom(roomIndex)
end

function Level.ForceHorsemanBoss(seed)
	if seed then checknumber(1, seed) else seed = Random() end
	return C.LL_Level__ForceHorsemanBoss(seed)
end

function Level.HasBossChallenge()
	return C.LL_Level__HasBossChallenge()
end

function Level.IsDevilRoomDisabled()
	return C.LL_Level__IsDevilRoomDisabled()
end

function Level.DisableDevilRoom()
	C.LL_Level__DisableDevilRoom()
end

function Level.UpdateVisibility()
	C.LL_Level__UpdateVisibility()
end

function Level.ApplyMapEffect()
	C.LL_Level__ApplyMapEffect()
end

function Level.ApplyBlueMapEffect()
	C.LL_Level__ApplyBlueMapEffect()
end

function Level.ApplyCompassEffect(persist)
	if persist ~= nil then persist = tobool(persist) else persist = true end
	C.LL_Level__ApplyCompassEffect(persist)
end

function Level.RemoveCompassEffect()
	C.LL_Level__RemoveCompassEffect()
end

function Level.ShowMap()
	C.LL_Level__ShowMap()
end

function Level.SetHeartPicked()
	C.LL_Level__SetHeartPicked()
end

function Level.GetHeartPicked()
	return C.LL_Level__GetHeartPicked()
end

function Level.SetCanSeeEverything(val)
	if val ~= nil then val = tobool(val) else val = true end
	C.LL_Level__SetCanSeeEverything(val)
end

function Level.GetCanSeeEverything()
	return C.LL_Level__GetCanSeeEverything()
end

function Level.AddCurse(curse, showName)
	checknumber(1, curse)
	if showName ~= nil then showName = tobool(showName) else showName = true end
	C.LL_Level__AddCurse(curse, showName)
end

function Level.RemoveCurse(curse)
	checknumber(1, curse)
	C.LL_Level__RemoveCurse(curse)
end

function Level.RemoveCurses()
	C.LL_Level__RemoveCurses()
end

function Level.GetDungeonPlacementSeed()
	return C.LL_Level__GetDungeonPlacementSeed()
end

function Level.GetDevilAngelRoomRNG()
	return C.LL_Level__GetDevilAngelRoomRNG()
end

function Level.CanSpawnDevilRoom()
	return C.LL_Level__CanSpawnDevilRoom()
end

function Level.InitializeDevilAngelRoom(forceAngel, forceDevil)
	forceAngel = tobool(forceAngel)
	forceDevil = tobool(forceDevil)
	C.LL_Level__InitializeDevilAngelRoom(forceAngel, forceDevil)
end

function Level.UncoverHiddenDoor(currentRoomIdx, doorSlot)
	checknumber(1, currentRoomIdx)
	checknumber(2, doorSlot)
	C.LL_Level__UncoverHiddenDoor(currentRoomIdx, doorSlot)
end

function Level.GetGreedModeWave()
	return C.LL_Level__GetGreedModeWave()
end

function Level.SetGreedModeWave(v)
	checknumber(1, v)
	C.LL_Level__SetGreedModeWave(v)
end

function Level.SetRedHeartDamage()
	C.LL_Level__SetRedHeartDamage()
end

function Level.IsNextStageAvailable()
	return C.LL_Level__IsNextStageAvailable()
end

function Level.GetAbsoluteStage()
	return C.LL_Level__GetAbsoluteStage()
end

function Level.AddAngelRoomChance(chance)
	checknumber(1, chance)
	C.LL_Level__AddAngelRoomChance(chance)
end

function Level.GetAddAngelRoomChance()
	return C.LL_Level__GetAddAngelRoomChance()
end

function Level.GetRoomByIdx(idx)
	checknumber(1, idx)
	return C.LL_Level__GetRoomByIdx(idx)
end

function Level.GetCurrentRoomDesc()
	return C.LL_Level__GetCurrentRoomDesc()
end

function Level.GetLastRoomDesc()
	return C.LL_Level__GetLastRoomDesc()
end

function Entity_Player:GetHearts()
	return C.LC_Entity_Player__GetHearts(CDATA(self))
end

function Entity_Player:GetMaxHearts()
	return C.LC_Entity_Player__GetMaxHearts(CDATA(self))
end

function Entity_Player:GetEffectiveMaxHearts()
	return C.LC_Entity_Player__GetEffectiveMaxHearts(CDATA(self))
end

function Entity_Player:GetHeartLimit(ignoreModifiers)
	ignoreModifiers = tobool(ignoreModifiers)
	return C.LC_Entity_Player__GetHeartLimit(CDATA(self), ignoreModifiers)
end

function Entity_Player:GetSoulHearts()
	return C.LC_Entity_Player__GetSoulHearts(CDATA(self))
end

function Entity_Player:GetBlackHearts()
	return C.LC_Entity_Player__GetBlackHearts(CDATA(self))
end

function Entity_Player:GetEternalHearts()
	return C.LC_Entity_Player__GetEternalHearts(CDATA(self))
end

function Entity_Player:GetExtraLives()
	return C.LC_Entity_Player__GetExtraLives(CDATA(self))
end

function Entity_Player:GetNumBombs()
	return C.LC_Entity_Player__GetNumBombs(CDATA(self))
end

function Entity_Player:GetNumKeys()
	return C.LC_Entity_Player__GetNumKeys(CDATA(self))
end

function Entity_Player:HasGoldenKey()
	return C.LC_Entity_Player__HasGoldenKey(CDATA(self))
end

function Entity_Player:HasGoldenBomb()
	return C.LC_Entity_Player__HasGoldenBomb(CDATA(self))
end

function Entity_Player:GetGoldenHearts()
	return C.LC_Entity_Player__GetGoldenHearts(CDATA(self))
end

function Entity_Player:GetNumCoins()
	return C.LC_Entity_Player__GetNumCoins(CDATA(self))
end

function Entity_Player:GetPlayerType()
	return C.LC_Entity_Player__GetPlayerType(CDATA(self))
end

function Entity_Player:GetTrinket(Index)
	if Index then checknumber(2, Index) else Index = 0 end
	return C.LC_Entity_Player__GetTrinket(CDATA(self), Index)
end

function Entity_Player:GetLuck()
	return C.LC_Entity_Player__GetLuck(CDATA(self))
end

function Entity_Player:GetSpeed()
	return C.LC_Entity_Player__GetSpeed(CDATA(self))
end

function Entity_Player:GetNumBlueFlies()
	return C.LC_Entity_Player__GetNumBlueFlies(CDATA(self))
end

function Entity_Player:GetNumBlueSpiders()
	return C.LC_Entity_Player__GetNumBlueSpiders(CDATA(self))
end

function Entity_Player:RenderGlow(position)
	checkcdata(2, position, _Vector)
	C.LC_Entity_Player__RenderGlow(CDATA(self), position)
end

function Entity_Player:RenderBody(position)
	checkcdata(2, position, _Vector)
	C.LC_Entity_Player__RenderBody(CDATA(self), position)
end

function Entity_Player:RenderHead(position)
	checkcdata(2, position, _Vector)
	C.LC_Entity_Player__RenderHead(CDATA(self), position)
end

function Entity_Player:RenderTop(position)
	checkcdata(2, position, _Vector)
	C.LC_Entity_Player__RenderTop(CDATA(self), position)
end

function Entity_Player:GetName()
	return ffi.string(C.LC_Entity_Player__GetName(CDATA(self)))
end

function Entity_Player:HasFullHearts()
	return C.LC_Entity_Player__HasFullHearts(CDATA(self))
end

function Entity_Player:HasFullHeartsSoulHearts()
	return C.LC_Entity_Player__HasFullHeartsSoulHearts(CDATA(self))
end

function Entity_Player:AddMaxHearts(v)
	checknumber(2, v)
	C.LC_Entity_Player__AddMaxHearts(CDATA(self), v)
end

function Entity_Player:AddHearts(v)
	checknumber(2, v)
	C.LC_Entity_Player__AddHearts(CDATA(self), v)
end

function Entity_Player:AddEternalHearts(v)
	checknumber(2, v)
	C.LC_Entity_Player__AddEternalHearts(CDATA(self), v)
end

function Entity_Player:AddSoulHearts(v)
	checknumber(2, v)
	C.LC_Entity_Player__AddSoulHearts(CDATA(self), v)
end

function Entity_Player:AddBlackHearts(v)
	checknumber(2, v)
	C.LC_Entity_Player__AddBlackHearts(CDATA(self), v)
end

function Entity_Player:RemoveBlackHeart(v)
	checknumber(2, v)
	C.LC_Entity_Player__RemoveBlackHeart(CDATA(self), v)
end

function Entity_Player:IsBlackHeart(heart)
	checknumber(2, heart)
	return C.LC_Entity_Player__IsBlackHeart(CDATA(self), heart)
end

function Entity_Player:AddJarHearts(v)
	checknumber(2, v)
	C.LC_Entity_Player__AddJarHearts(CDATA(self), v)
end

function Entity_Player:GetJarHearts()
	return C.LC_Entity_Player__GetJarHearts(CDATA(self))
end

function Entity_Player:AddJarFlies(v)
	checknumber(2, v)
	C.LC_Entity_Player__AddJarFlies(CDATA(self), v)
end

function Entity_Player:GetJarFlies()
	return C.LC_Entity_Player__GetJarFlies(CDATA(self))
end

function Entity_Player:AddCoins(v)
	checknumber(2, v)
	C.LC_Entity_Player__AddCoins(CDATA(self), v)
end

function Entity_Player:AddBombs(v)
	checknumber(2, v)
	C.LC_Entity_Player__AddBombs(CDATA(self), v)
end

function Entity_Player:AddKeys(v)
	checknumber(2, v)
	C.LC_Entity_Player__AddKeys(CDATA(self), v)
end

function Entity_Player:AddGoldenKey()
	C.LC_Entity_Player__AddGoldenKey(CDATA(self))
end

function Entity_Player:RemoveGoldenKey()
	C.LC_Entity_Player__RemoveGoldenKey(CDATA(self))
end

function Entity_Player:AddGoldenBomb()
	C.LC_Entity_Player__AddGoldenBomb(CDATA(self))
end

function Entity_Player:RemoveGoldenBomb()
	C.LC_Entity_Player__RemoveGoldenBomb(CDATA(self))
end

function Entity_Player:AddGoldenHearts(v)
	checknumber(2, v)
	C.LC_Entity_Player__AddGoldenHearts(CDATA(self), v)
end

function Entity_Player:AddBlueSpider(position)
	checkcdata(2, position, _Vector)
	return EntityHandle(C.LC_Entity_Player__AddBlueSpider(CDATA(self), position))
end

function Entity_Player:ThrowBlueSpider(position, target)
	checkcdata(2, position, _Vector)
	if target then checkcdata(3, target, _Vector) else target = vector_zero end
	return EntityHandle(C.LC_Entity_Player__ThrowBlueSpider(CDATA(self), position, target))
end

function Entity_Player:RemoveBlueSpider()
	C.LC_Entity_Player__RemoveBlueSpider(CDATA(self))
end

function Entity_Player:AddBlueFlies(amount, position, target)
	checknumber(2, amount)
	checkcdata(3, position, _Vector)
	if target then checkhandle(4, target, META_Entity) else target = EntityHandle(NULL) end
	return EntityHandle(C.LC_Entity_Player__AddBlueFlies(CDATA(self), amount, position, CDATA(target)))
end

function Entity_Player:RemoveBlueFly()
	C.LC_Entity_Player__RemoveBlueFly(CDATA(self))
end

function Entity_Player:AddPrettyFly()
	C.LC_Entity_Player__AddPrettyFly(CDATA(self))
end

function Entity_Player:TryUseKey()
	return C.LC_Entity_Player__TryUseKey(CDATA(self))
end

function Entity_Player:ClearCostumes()
	C.LC_Entity_Player__ClearCostumes(CDATA(self))
end

function Entity_Player:FlushQueueItem()
	return C.LC_Entity_Player__FlushQueueItem(CDATA(self))
end

function Entity_Player:IsItemQueueEmpty()
	return C.LC_Entity_Player__IsItemQueueEmpty(CDATA(self))
end

function Entity_Player:AddCollectible(type, charge, addConsumables)
	checknumber(2, type)
	if charge then checknumber(3, charge) else charge = 0 end
	if addConsumables ~= nil then addConsumables = tobool(addConsumables) else addConsumables = true end
	C.LC_Entity_Player__AddCollectible(CDATA(self), type, charge, addConsumables)
end

function Entity_Player:RemoveCollectible(type)
	checknumber(2, type)
	C.LC_Entity_Player__RemoveCollectible(CDATA(self), type)
end

function Entity_Player:DropCollectible(type)
	checknumber(2, type)
	C.LC_Entity_Player__DropCollectible(CDATA(self), type)
end

function Entity_Player:GetCollectibleCount()
	return C.LC_Entity_Player__GetCollectibleCount(CDATA(self))
end

function Entity_Player:AddTrinket(type)
	checknumber(2, type)
	C.LC_Entity_Player__AddTrinket(CDATA(self), type)
end

function Entity_Player:TryRemoveTrinket(type)
	checknumber(2, type)
	return C.LC_Entity_Player__TryRemoveTrinket(CDATA(self), type)
end

function Entity_Player:DropTrinket(dropPos, replaceTick)
	checkcdata(2, dropPos, _Vector)
	replaceTick = tobool(replaceTick)
	C.LC_Entity_Player__DropTrinket(CDATA(self), dropPos, replaceTick)
end

function Entity_Player:GetMaxTrinkets()
	return C.LC_Entity_Player__GetMaxTrinkets(CDATA(self))
end

function Entity_Player:GetMaxPocketItems()
	return C.LC_Entity_Player__GetMaxPocketItems(CDATA(self))
end

function Entity_Player:DropPocketItem(slot, dropPos)
	checknumber(2, slot)
	checkcdata(3, dropPos, _Vector)
	C.LC_Entity_Player__DropPocketItem(CDATA(self), slot, dropPos)
end

function Entity_Player:ClearTemporaryEffects()
	C.LC_Entity_Player__ClearTemporaryEffects(CDATA(self))
end

function Entity_Player:DonateLuck(v)
	checknumber(2, v)
	C.LC_Entity_Player__DonateLuck(CDATA(self), v)
end

function Entity_Player:CanPickRedHearts()
	return C.LC_Entity_Player__CanPickRedHearts(CDATA(self))
end

function Entity_Player:CanPickSoulHearts()
	return C.LC_Entity_Player__CanPickSoulHearts(CDATA(self))
end

function Entity_Player:CanPickBlackHearts()
	return C.LC_Entity_Player__CanPickBlackHearts(CDATA(self))
end

function Entity_Player:CanPickGoldenHearts()
	return C.LC_Entity_Player__CanPickGoldenHearts(CDATA(self))
end

function Entity_Player:CanPickBoneHearts()
	return C.LC_Entity_Player__CanPickBoneHearts(CDATA(self))
end

function Entity_Player:FindActiveItem(id)
	checknumber(2, id)
	return C.LC_Entity_Player__FindActiveItem(CDATA(self), id)
end

function Entity_Player:GetActiveItem(slot)
	if slot then checknumber(2, slot) else slot = 0 end
	return C.LC_Entity_Player__GetActiveItem(CDATA(self), slot)
end

function Entity_Player:GetActiveCharge(slot)
	if slot then checknumber(2, slot) else slot = 0 end
	return C.LC_Entity_Player__GetActiveCharge(CDATA(self), slot)
end

function Entity_Player:GetBatteryCharge(slot)
	if slot then checknumber(2, slot) else slot = 0 end
	return C.LC_Entity_Player__GetBatteryCharge(CDATA(self), slot)
end

function Entity_Player:GetActiveSubCharge(slot)
	if slot then checknumber(2, slot) else slot = 0 end
	return C.LC_Entity_Player__GetActiveSubCharge(CDATA(self), slot)
end

function Entity_Player:SetActiveCharge(charge, slot)
	checknumber(2, charge)
	if slot then checknumber(3, slot) else slot = 0 end
	C.LC_Entity_Player__SetActiveCharge(CDATA(self), charge, slot)
end

function Entity_Player:DischargeActiveItem(slot)
	if slot then checknumber(2, slot) else slot = 0 end
	C.LC_Entity_Player__DischargeActiveItem(CDATA(self), slot)
end

function Entity_Player:NeedsCharge(slot)
	if slot then checknumber(2, slot) else slot = 0 end
	return C.LC_Entity_Player__NeedsCharge(CDATA(self), slot)
end

function Entity_Player:FullCharge(slot)
	if slot then checknumber(2, slot) else slot = 0 end
	return C.LC_Entity_Player__FullCharge(CDATA(self), slot)
end

function Entity_Player:AddCard(id)
	checknumber(2, id)
	C.LC_Entity_Player__AddCard(CDATA(self), id)
end

function Entity_Player:AddPill(id)
	checknumber(2, id)
	C.LC_Entity_Player__AddPill(CDATA(self), id)
end

function Entity_Player:GetCard(slot)
	if slot then checknumber(2, slot) else slot = 0 end
	return C.LC_Entity_Player__GetCard(CDATA(self), slot)
end

function Entity_Player:GetPill(slot)
	if slot then checknumber(2, slot) else slot = 0 end
	return C.LC_Entity_Player__GetPill(CDATA(self), slot)
end

function Entity_Player:SetCard(slot, id)
	checknumber(2, slot)
	checknumber(3, id)
	C.LC_Entity_Player__SetCard(CDATA(self), slot, id)
end

function Entity_Player:SetPill(slot, id)
	checknumber(2, slot)
	checknumber(3, id)
	C.LC_Entity_Player__SetPill(CDATA(self), slot, id)
end

function Entity_Player:HasCollectible(type)
	checknumber(2, type)
	return C.LC_Entity_Player__HasCollectible(CDATA(self), type)
end

function Entity_Player:GetCollectibleNum(type)
	checknumber(2, type)
	return C.LC_Entity_Player__GetCollectibleNum(CDATA(self), type)
end

function Entity_Player:HasTrinket(type)
	checknumber(2, type)
	return C.LC_Entity_Player__HasTrinket(CDATA(self), type)
end

function Entity_Player:HasPlayerForm(type)
	checknumber(2, type)
	return C.LC_Entity_Player__HasPlayerForm(CDATA(self), type)
end

function Entity_Player:CanAddCollectible()
	return C.LC_Entity_Player__CanAddCollectible(CDATA(self))
end

function Entity_Player:TryHoldTrinket(type)
	checknumber(2, type)
	return C.LC_Entity_Player__TryHoldTrinket(CDATA(self), type)
end

function Entity_Player:SetFullHearts()
	C.LC_Entity_Player__SetFullHearts(CDATA(self))
end

function Entity_Player:AddCacheFlags(flags)
	checknumber(2, flags)
	C.LC_Entity_Player__AddCacheFlags(CDATA(self), flags)
end

function Entity_Player:EvaluateItems()
	C.LC_Entity_Player__EvaluateItems(CDATA(self))
end

function Entity_Player:RespawnFamiliars()
	C.LC_Entity_Player__RespawnFamiliars(CDATA(self))
end

function Entity_Player:GetTearsOffset()
	local ret = _Vector()
	C.LC_Entity_Player__GetTearsOffset(ret, CDATA(self))
	return ret
end

function Entity_Player:SetTearsOffset(v)
	checkcdata(2, v, _Vector)
	C.LC_Entity_Player__SetTearsOffset(CDATA(self), v)
end

function Entity_Player:GetNPCTarget()
	return EntityHandle(C.LC_Entity_Player__GetNPCTarget(CDATA(self)))
end

function Entity_Player:GetMovementDirection()
	return C.LC_Entity_Player__GetMovementDirection(CDATA(self))
end

function Entity_Player:GetFireDirection()
	return C.LC_Entity_Player__GetFireDirection(CDATA(self))
end

function Entity_Player:GetHeadDirection()
	return C.LC_Entity_Player__GetHeadDirection(CDATA(self))
end

function Entity_Player:GetAimDirection()
	local ret = _Vector()
	C.LC_Entity_Player__GetAimDirection(ret, CDATA(self))
	return ret
end

function Entity_Player:GetMovementVector()
	local ret = _Vector()
	C.LC_Entity_Player__GetMovementVector(ret, CDATA(self))
	return ret
end

function Entity_Player:GetRecentMovementVector()
	local ret = _Vector()
	C.LC_Entity_Player__GetRecentMovementVector(ret, CDATA(self))
	return ret
end

function Entity_Player:GetMovementInput()
	local ret = _Vector()
	C.LC_Entity_Player__GetMovementInput(ret, CDATA(self))
	return ret
end

function Entity_Player:GetShootingInput()
	local ret = _Vector()
	C.LC_Entity_Player__GetShootingInput(ret, CDATA(self))
	return ret
end

function Entity_Player:AreOpposingShootDirectionsPressed()
	return C.LC_Entity_Player__AreOpposingShootDirectionsPressed(CDATA(self))
end

function Entity_Player:GetLastDirection()
	local ret = _Vector()
	C.LC_Entity_Player__GetLastDirection(ret, CDATA(self))
	return ret
end

function Entity_Player:GetVelocityBeforeUpdate()
	local ret = _Vector()
	C.LC_Entity_Player__GetVelocityBeforeUpdate(ret, CDATA(self))
	return ret
end

function Entity_Player:GetSmoothBodyRotation()
	return C.LC_Entity_Player__GetSmoothBodyRotation(CDATA(self))
end

function Entity_Player:GetTearPoisonDamage()
	return C.LC_Entity_Player__GetTearPoisonDamage(CDATA(self))
end

function Entity_Player:GetBombFlags()
	local ret = _BitSet128()
	C.LC_Entity_Player__GetBombFlags(ret, CDATA(self))
	return ret
end

function Entity_Player:GetBombVariant(flags, forceSmallBomb)
	if flags then checkcdata(2, flags, _BitSet128) else flags = 0 end
	forceSmallBomb = tobool(forceSmallBomb)
	return C.LC_Entity_Player__GetBombVariant(CDATA(self), flags, forceSmallBomb)
end

function Entity_Player:GetItemState()
	return C.LC_Entity_Player__GetItemState(CDATA(self))
end

function Entity_Player:UseActiveItem(item, showAnim, keepActiveItem, allowNonMainPlayer, toAddCostume)
	checknumber(2, item)
	if showAnim ~= nil then showAnim = tobool(showAnim) else showAnim = true end
	if keepActiveItem ~= nil then keepActiveItem = tobool(keepActiveItem) else keepActiveItem = true end
	allowNonMainPlayer = tobool(allowNonMainPlayer)
	if toAddCostume ~= nil then toAddCostume = tobool(toAddCostume) else toAddCostume = true end
	C.LC_Entity_Player__UseActiveItem(CDATA(self), item, showAnim, keepActiveItem, allowNonMainPlayer, toAddCostume)
end

function Entity_Player:GetTearRangeModifier()
	return C.LC_Entity_Player__GetTearRangeModifier(CDATA(self))
end

function Entity_Player:GetTrinketMultiplier()
	return C.LC_Entity_Player__GetTrinketMultiplier(CDATA(self))
end

function Entity_Player:GetBoneHearts()
	return C.LC_Entity_Player__GetBoneHearts(CDATA(self))
end

function Entity_Player:IsBoneHeart(heart)
	checknumber(2, heart)
	return C.LC_Entity_Player__IsBoneHeart(CDATA(self), heart)
end

function Entity_Player:AddBrokenHearts(v)
	checknumber(2, v)
	C.LC_Entity_Player__AddBrokenHearts(CDATA(self), v)
end

function Entity_Player:GetBrokenHearts()
	return C.LC_Entity_Player__GetBrokenHearts(CDATA(self))
end

function Entity_Player:AddRottenHearts(v)
	checknumber(2, v)
	C.LC_Entity_Player__AddRottenHearts(CDATA(self), v)
end

function Entity_Player:GetRottenHearts()
	return C.LC_Entity_Player__GetRottenHearts(CDATA(self))
end

if not ItemPool then ItemPool = {} end

function ItemPool.GetCollectible(pool, seed, flags)
	if pool then checknumber(1, pool) else pool = POOL_TREASURE end
	if seed then checknumber(2, seed) else seed = Random() end
	if flags then checknumber(3, flags) else flags = 0 end
	return C.LL_ItemPool__GetCollectible(pool, seed, flags)
end

function ItemPool.RemoveCollectible(id, checkAchievements)
	checknumber(1, id)
	checkAchievements = tobool(checkAchievements)
	return C.LL_ItemPool__RemoveCollectible(id, checkAchievements)
end

function ItemPool.RemoveTrinket(id)
	checknumber(1, id)
	return C.LL_ItemPool__RemoveTrinket(id)
end

function ItemPool.ResetTrinkets(id)
	checknumber(1, id)
	C.LL_ItemPool__ResetTrinkets(id)
end

function ItemPool.GetTrinket()
	return C.LL_ItemPool__GetTrinket()
end

function ItemPool.GetCard(seed, playing, rune, onlyRunes)
	checknumber(1, seed)
	if playing ~= nil then playing = tobool(playing) else playing = true end
	if rune ~= nil then rune = tobool(rune) else rune = true end
	onlyRunes = tobool(onlyRunes)
	return C.LL_ItemPool__GetCard(seed, playing, rune, onlyRunes)
end

function ItemPool.GetCardEx(seed, specialChance, runeChance, suitChance, allowNonCards)
	checknumber(1, seed)
	checknumber(2, specialChance)
	checknumber(3, runeChance)
	checknumber(4, suitChance)
	if allowNonCards ~= nil then allowNonCards = tobool(allowNonCards) else allowNonCards = true end
	return C.LL_ItemPool__GetCardEx(seed, specialChance, runeChance, suitChance, allowNonCards)
end

function ItemPool.GetPill(seed)
	checknumber(1, seed)
	return C.LL_ItemPool__GetPill(seed)
end

function ItemPool.GetPillEffect(pillColor, player)
	checknumber(1, pillColor)
	if player then checkhandle(2, player, META_Entity_Player) else player = EntityHandle(NULL) end
	return C.LL_ItemPool__GetPillEffect(pillColor, CDATA(player))
end

function ItemPool.IdentifyPill(pillColor)
	checknumber(1, pillColor)
	C.LL_ItemPool__IdentifyPill(pillColor)
end

function ItemPool.IsPillIdentified(pillColor)
	checknumber(1, pillColor)
	return C.LL_ItemPool__IsPillIdentified(pillColor)
end

function ItemPool.ForceAddPillEffect(pillEffect)
	checknumber(1, pillEffect)
	return C.LL_ItemPool__ForceAddPillEffect(pillEffect)
end

function ItemPool.GetLastPool()
	return C.LL_ItemPool__GetLastPool()
end

function ItemPool.GetPoolForRoom(roomType, seed)
	checknumber(1, roomType)
	checknumber(2, seed)
	return C.LL_ItemPool__GetPoolForRoom(roomType, seed)
end

function ItemPool.ResetRoomBlacklist()
	C.LL_ItemPool__ResetRoomBlacklist()
end

function ItemPool.AddRoomBlacklist(item)
	checknumber(1, item)
	C.LL_ItemPool__AddRoomBlacklist(item)
end

function ItemPool.AddBibleUpgrade(add, pool)
	checknumber(1, add)
	if pool then checknumber(2, pool) else pool = NUM_ITEMPOOLS end
	C.LL_ItemPool__AddBibleUpgrade(add, pool)
end

function ItemPool.IsInBlacklist(item)
	checknumber(1, item)
	return C.LL_ItemPool__IsInBlacklist(item)
end

function ItemPool.IsInRoomBlacklist(item)
	checknumber(1, item)
	return C.LL_ItemPool__IsInRoomBlacklist(item)
end


function ItemPool.GetCollectibleFromList(list, seed, default, addToBlacklist)
	checktable(1, list)
	if seed then checknumber(2, seed) else seed = Random() end
	if default then checknumber(3, default) else default = COLLECTIBLE_BREAKFAST end
	if addToBlacklist == nil then addToBlacklist = true else addToBlacklist = tobool(addToBlacklist) end
	
	if #list == 0 then return default end
	return C.LL_ItemPool__GetCollectibleFromList(list, #list, seed, default, addToBlacklist)
end
function ANM2:IsFinished(name)
	if name then checkstring(2, name) else name = "" end
	return C.LC_ANM2__IsFinished(self, name)
end

function ANM2:Play(name, force)
	checkstring(2, name)
	force = tobool(force)
	C.LC_ANM2__Play(self, name, force)
end


function ANM2:SetFrame(name, frame)
	if not frame and type(name) == "number" then
		C.LC_ANM2__SetFrame2(self, name)
	else
		checkstring(2, name)
		checknumber(3, frame)
		C.LC_ANM2__SetFrame(self, name, frame)
	end
end
function ANM2:Reset()
	C.LC_ANM2__Reset(self)
end

function ANM2:Update()
	C.LC_ANM2__Update(self)
end

function ANM2:Render(pos, topLeftClamp, bottomRightClamp)
	checkcdata(2, pos, _Vector)
	if topLeftClamp then checkcdata(3, topLeftClamp, _Vector) else topLeftClamp = vector_zero end
	if bottomRightClamp then checkcdata(4, bottomRightClamp, _Vector) else bottomRightClamp = vector_zero end
	C.LC_ANM2__Render(self, pos, topLeftClamp, bottomRightClamp)
end

function ANM2:RenderLayer(layerId, pos)
	checknumber(2, layerId)
	checkcdata(3, pos, _Vector)
	C.LC_ANM2__RenderLayer(self, layerId, pos)
end

function ANM2:Load(fileName, loadGraphics)
	checkstring(2, fileName)
	if loadGraphics ~= nil then loadGraphics = tobool(loadGraphics) else loadGraphics = true end
	C.LC_ANM2__Load(self, fileName, loadGraphics)
end

function ANM2:Reload()
	C.LC_ANM2__Reload(self)
end

function ANM2:ReplaceSpritesheet(layerId, fileName)
	checknumber(2, layerId)
	checkstring(3, fileName)
	C.LC_ANM2__ReplaceSpritesheet(self, layerId, fileName)
end

function ANM2:LoadGraphics()
	C.LC_ANM2__LoadGraphics(self)
end

function ANM2:IsLoaded()
	return C.LC_ANM2__IsLoaded(self)
end

function ANM2:GetFilename()
	return ffi.string(C.LC_ANM2__GetFilename(self))
end

function ANM2:PlayRandom(seed)
	if seed then checknumber(2, seed) else seed = Random() end
	C.LC_ANM2__PlayRandom(self, seed)
end

function ANM2:Stop()
	C.LC_ANM2__Stop(self)
end

function ANM2:SetAnimation(name)
	checkstring(2, name)
	return C.LC_ANM2__SetAnimation(self, name)
end

function ANM2:GetFrame()
	return C.LC_ANM2__GetFrame(self)
end

function ANM2:SetLastFrame()
	C.LC_ANM2__SetLastFrame(self)
end

function ANM2:IsPlaying(name)
	if name then checkstring(2, name) else name = "" end
	return C.LC_ANM2__IsPlaying(self, name)
end

function ANM2:SetLayerFrame(layerId, frameNum)
	checknumber(2, layerId)
	checknumber(3, frameNum)
	C.LC_ANM2__SetLayerFrame(self, layerId, frameNum)
end

function ANM2:PlayOverlay(name, force)
	checkstring(2, name)
	force = tobool(force)
	C.LC_ANM2__PlayOverlay(self, name, force)
end

function ANM2:SetOverlayAnimation(name)
	checkstring(2, name)
	return C.LC_ANM2__SetOverlayAnimation(self, name)
end

function ANM2:SetOverlayRenderPriority(renderFirst)
	renderFirst = tobool(renderFirst)
	C.LC_ANM2__SetOverlayRenderPriority(self, renderFirst)
end


function ANM2:SetOverlayFrame(name, frame)
	if not frame and type(name) == "number" then
		C.LC_ANM2__SetOverlayFrame2(self, name)
	else
		checkstring(2, name)
		checknumber(3, frame)
		C.LC_ANM2__SetOverlayFrame(self, name, frame)
	end
end
function ANM2:GetOverlayFrame()
	return C.LC_ANM2__GetOverlayFrame(self)
end

function ANM2:RemoveOverlay()
	C.LC_ANM2__RemoveOverlay(self)
end

function ANM2:IsOverlayPlaying(name)
	if name then checkstring(2, name) else name = "" end
	return C.LC_ANM2__IsOverlayPlaying(self, name)
end

function ANM2:IsOverlayFinished(name)
	if name then checkstring(2, name) else name = "" end
	return C.LC_ANM2__IsOverlayFinished(self, name)
end

function ANM2:IsEventTriggered(name)
	checkstring(2, name)
	return C.LC_ANM2__IsEventTriggered(self, name)
end

function ANM2:WasEventTriggered(name)
	checkstring(2, name)
	return C.LC_ANM2__WasEventTriggered(self, name)
end

function ANM2:GetLayerCount()
	return C.LC_ANM2__GetLayerCount(self)
end

function ANM2:GetNullCount()
	return C.LC_ANM2__GetNullCount(self)
end

function ANM2:GetDefaultAnimationName()
	return ffi.string(C.LC_ANM2__GetDefaultAnimationName(self))
end

if not RoomConfig then RoomConfig = {} end

function RoomConfig.GetRoom(stageID, roomType, variant)
	checknumber(1, stageID)
	checknumber(2, roomType)
	checknumber(3, variant)
	local __ret = C.LL_RoomConfig__GetRoom(stageID, roomType, variant)
	if __ret == NULL then return nil else return __ret end
end

function RoomConfig.GetRandomRoom(seed, reduceWeight, stageID, roomType, shape, minVariant, maxVariant, minDifficulty, maxDifficulty, requiredDoors, subType)
	checknumber(1, seed)
	reduceWeight = tobool(reduceWeight)
	checknumber(3, stageID)
	checknumber(4, roomType)
	if shape then checknumber(5, shape) else shape = NUM_ROOMSHAPES end
	if minVariant then checknumber(6, minVariant) else minVariant = 0 end
	if maxVariant then checknumber(7, maxVariant) else maxVariant = -1 end
	if minDifficulty then checknumber(8, minDifficulty) else minDifficulty = 0 end
	if maxDifficulty then checknumber(9, maxDifficulty) else maxDifficulty = 10 end
	if requiredDoors then checknumber(10, requiredDoors) else requiredDoors = 0 end
	if subType then checknumber(11, subType) else subType = -1 end
	local __ret = C.LL_RoomConfig__GetRandomRoom(seed, reduceWeight, stageID, roomType, shape, minVariant, maxVariant, minDifficulty, maxDifficulty, requiredDoors, subType)
	if __ret == NULL then return nil else return __ret end
end

function RoomConfig.ResetRoomWeights(stageID)
	checknumber(1, stageID)
	C.LL_RoomConfig__ResetRoomWeights(stageID)
end

function Level.PlaceRoom(room, data, seed)
	checkcdata(1, room, _LevelGeneratorRoom)
	checkcdata(2, data, _RoomData)
	checknumber(3, seed)
	return C.LL_Level__PlaceRoom(room, data, seed)
end

function LevelGenerator:CreateRoom(x, y, shape, connectX, connectY, connectDir)
	checknumber(2, x)
	checknumber(3, y)
	checknumber(4, shape)
	if connectX then checknumber(5, connectX) else connectX = -1 end
	if connectY then checknumber(6, connectY) else connectY = -1 end
	if connectDir then checknumber(7, connectDir) else connectDir = DIR_NONE end
	return C.LC_LevelGenerator__CreateRoom(self, x, y, shape, connectX, connectY, connectDir)
end

if not HUD then HUD = {} end

function HUD.ShowItemText(name, desc, sticky, paper)
	checkstring(1, name)
	if desc then checkstring(2, desc) else desc = "" end
	sticky = tobool(sticky)
	paper = tobool(paper)
	C.LL_HUD__ShowItemText(name, desc, sticky, paper)
end

function HUD.IsVisible()
	return C.LL_HUD__IsVisible()
end

function HUD.SetVisible(visible)
	visible = tobool(visible)
	C.LL_HUD__SetVisible(visible)
end

function HUD.HideItemText()
	C.LL_HUD__HideItemText()
end

function HUD.ShowFortuneText(Line1, Line2, Line3)
	checkstring(1, Line1)
	if Line2 then checkstring(2, Line2) else Line2 = "" end
	if Line3 then checkstring(3, Line3) else Line3 = "" end
	C.LL_HUD__ShowFortuneText(Line1, Line2, Line3)
end

