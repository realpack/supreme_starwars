EFFECT.Speed = 10000
EFFECT.Length = 50
EFFECT.UseModel = false

local EMPTY = Vector()
local MaterialMain = Material 'effects/sw_laser_red_main'
local MaterialFront = Material 'effects/sw_laser_red_front'

function EFFECT:Init(data)
	self.StartPos = data:GetStart()
	self.EndPos = data:GetOrigin()

	if not self.StartPos or not self.EndPos then
		self.DieTime = CurTime()
		return
	end

	local ent = data:GetEntity()
	local att = data:GetAttachment()

	if ent and IsValid(ent) then
		local pl = ent:GetOwner()

		-- print(pl)

		if IsValid(pl) and LocalPlayer() == pl and bit.band( data:GetFlags(), TRACER_FLAG_USEATTACHMENT ) == TRACER_FLAG_USEATTACHMENT then
			local vm = pl:GetViewModel()
			local attachment = vm:GetAttachment( att )
			if attachment and IsValid(vm) then
				self.StartPos = attachment.Pos
			else
				self.StartPos = pl:GetShootPos()
			end
		else
			if pl:IsNPC() then
				local pos = pl:GetPos() + pl:GetForward() * 1 + pl:GetUp() * 45

				self.StartPos = pos
			else
				self.StartPos = pl:GetShootPos()
			end
		end
	end


	self.Dir = (self.EndPos - self.StartPos):GetNormalized()

	self:SetRenderBoundsWS(self.StartPos+self.Dir*1, self.EndPos)

	self.StartTime = CurTime()
	self.Distance = self.StartPos:Distance(self.EndPos)
	self.TracerTime = self.Distance/self.Speed
	self.DieTime = self.StartTime + self.TracerTime
end

function EFFECT:Think()
	if CurTime() > self.DieTime then
		return false
	end

	return true
end

function EFFECT:Render()
	if CurTime() >= self.DieTime then return end
	local perc = (CurTime()-self.StartTime)/self.TracerTime
	if perc < 0 then return end

	local startPos = self.StartPos + self.Dir * (self.Distance*perc)
	local endPos = startPos + self.Dir * self.Length

	render.SetMaterial(MaterialMain)
	render.DrawBeam(startPos, endPos, 15, 0, 1, color_white)

	render.SetMaterial(MaterialFront)
	render.DrawSprite(endPos, 15, 15, color_white)

	-- self.dlight = DynamicLight(self)

	-- if self.dlight then
	-- 	self.dlight.pos = endPos
	-- 	self.dlight.r = 255
	-- 	self.dlight.g = 0
	-- 	self.dlight.b = 0
	-- 	self.dlight.brightness 	= 2
	-- 	self.dlight.Decay = 2000
	-- 	self.dlight.Size = 700
	-- 	self.dlight.DieTime = CurTime() + 1
	-- end
end

