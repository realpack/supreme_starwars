--[[
addons/swb_starwars/lua/effects/cwbase_laser.lua
--]]

TRACER_FLAG_USEATTACHMENT = 0x0002
SOUND_FROM_WORLD = 0
CHAN_STATIC = 6

EFFECT.Speed = 12000
EFFECT.Length = 50
EFFECT.UseModel = false

local EMPTY = Vector()
local MaterialMain = Material 'effects/sw_laser_blue_main'
local MaterialFront = Material 'effects/sw_laser_blue_front'

function EFFECT:GetTracerOrigin(data)
	local start = data:GetStart()
	local entity = data:GetEntity()
	if not IsValid(entity) or entity:IsDormant() then
		return EMPTY
	end

	local owner = entity:GetOwner()
	if not IsValid(owner) or owner:IsDormant() then
		return EMPTY
	end

	if bit.band(data:GetFlags(), TRACER_FLAG_USEATTACHMENT) == TRACER_FLAG_USEATTACHMENT then		
		local pl = LocalPlayer()
		if entity:IsWeapon() and (entity.IsCarriedByLocalPlayer and entity:IsCarriedByLocalPlayer()) and not pl:ShouldDrawLocalPlayer() and MuzzlePosition then
			self.LocalPlayer = true

			local pos = entity.Akimbo and (entity.AkimboLeftFire and MuzzlePosition or MuzzlePosition2) or MuzzlePosition
			return pos + entity:GetForward() * 1
		else
			local attachmentId = entity.Akimbo and (entity.AkimboLeftFire and 1 or 2) or data:GetAttachment()
			local attachment = entity:GetAttachment(attachmentId) or {Pos = entity:GetPos()}
			if attachment then
				return attachment.Pos
			else
				return start
			end
		end
	end

	self.DeleteMe = true
	return start
end

function EFFECT:Init(data)
	self.StartPos = self:GetTracerOrigin(data)
	self.EndPos = data:GetOrigin()
	self.MinimalMode = cvar.GetValue('srp_minimal') 

	if not self.StartPos or self.StartPos == EMPTY then
		self.DeleteMe = true
		return
	end

	local diff = (self.EndPos - self.StartPos)
	self.Normal = diff:GetNormal()
	self.StartTime = 0
	self.LifeTime = (diff:Length() + self.Length) / self.Speed
end

function EFFECT:Think()
	if not self.StartPos or not self.LifeTime or not self.StartTime then 
		return false
	end

	self.LifeTime = self.LifeTime - FrameTime()
	self.StartTime = self.StartTime + FrameTime()

	if self.DeleteMe or self.LifeTime <= 0 and IsValid(bolt) then
		bolt:Remove()
	end

	return not (self.DeleteMe or self.LifeTime < 0)
end

function EFFECT:Render()
	if 	not self.StartPos or 
		not self.Speed or 
		not self.StartTime then
		self.DeleteMe = true
		return 
	end

	local endDistance = math.max(0, self.Speed * self.StartTime)
	local startDistance = math.max( 0, endDistance - self.Length)
	local startPos = self.StartPos + self.Normal * startDistance
	local endPos = self.StartPos + self.Normal * endDistance

	render.SetMaterial(MaterialFront)
	render.DrawSprite(endPos, 15, 15, col.white)

	render.SetMaterial(MaterialMain)
	render.DrawBeam(startPos, endPos, 15, 0, 1, col.white)

	if not self.MinimalMode then
		self.dlight = DynamicLight(self)
		if self.dlight then
			self.dlight.pos = endPos
			self.dlight.r = 0
			self.dlight.g = 0
			self.dlight.b = 255
			self.dlight.brightness 	= 2
			self.dlight.Decay = 2000
			self.dlight.Size = 700
			self.dlight.DieTime = CurTime() + 1
		end
	end
end

