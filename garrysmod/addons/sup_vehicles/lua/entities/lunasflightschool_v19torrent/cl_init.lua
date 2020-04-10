--DO NOT EDIT OR REUPLOAD THIS FILE

include("shared.lua")

function ENT:Initialize()
end

function ENT:DamageFX()
	local HP = self:GetHP()
	if HP == 0 or HP > self:GetMaxHP() * 0.5 then return end
	
	self.nextDFX = self.nextDFX or 0
	
	if self.nextDFX < CurTime() then
		self.nextDFX = CurTime() + 0.05
		
		local effectdata = EffectData()
			effectdata:SetOrigin( self:LocalToWorld(Vector(-190,123,7.78) + VectorRand() * 8) )
		util.Effect( "lfs_blacksmoke", effectdata )
	end
end

function ENT:ExhaustFX()
	if not self:GetEngineActive() then return end
	
	self.nextEFX = self.nextEFX or 0
	
	local THR = (self:GetRPM() - self.IdleRPM) / (self.LimitRPM - self.IdleRPM)
	
	local Driver = self:GetDriver()
	if IsValid( Driver ) then
		local W = Driver:lfsGetInput( "+THROTTLE" )
		if W ~= self.oldW then
			self.oldW = W
			if W then
				self.BoostAdd = 200
			end
		end
	end
	
	self.BoostAdd = self.BoostAdd and (self.BoostAdd - self.BoostAdd * FrameTime()) or 0
	
	if self.nextEFX < CurTime() then
		self.nextEFX = CurTime() + 0.01
		
		local emitter = ParticleEmitter( self:GetPos(), false )

		if emitter then
			local Mirror = false
			for i = 0,1 do
				local Sub = Mirror and 1 or -1
				local vOffset = self:LocalToWorld( Vector(-215,-123 * Sub,7.78) )
				local vNormal = -self:GetForward()

				vOffset = vOffset + vNormal * 5

				local particle = emitter:Add( "effects/muzzleflash2", vOffset )
				if not particle then return end

				particle:SetVelocity( vNormal * math.Rand(500,1000) + self:GetVelocity() )
				particle:SetLifeTime( 0 )
				particle:SetDieTime( 0.1 )
				particle:SetStartAlpha( 255 )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( math.Rand(15,25) )
				particle:SetEndSize( math.Rand(0,10) )
				particle:SetRoll( math.Rand(-1,1) * 100 )
				
				particle:SetColor( 39, 207, 244 )
			
				Mirror = true
			end
			
			emitter:Finish()
		end
		if self:GetLGear() < 0.01  then
			local emitter = ParticleEmitter( self:GetPos(), false )

			if emitter then
	
				for i = 0,1 do
					local vOffset = self:LocalToWorld( Vector(-135,0,-208.578) )
					local vNormal = -self:GetForward()

					vOffset = vOffset + vNormal * 5

					local particle = emitter:Add( "effects/muzzleflash2", vOffset )
					if not particle then return end

					particle:SetVelocity( vNormal * math.Rand(500,1000) + self:GetVelocity() )
					particle:SetLifeTime( 0 )
					particle:SetDieTime( 0.1 )
					particle:SetStartAlpha( 255 )
					particle:SetEndAlpha( 0 )
					particle:SetStartSize( math.Rand(15,25) )
					particle:SetEndSize( math.Rand(0,10) )
					particle:SetRoll( math.Rand(-1,1) * 100 )
				
					particle:SetColor( 39, 207, 244 )
				end
				emitter:Finish()
			end
		end

	end
end

function ENT:CalcEngineSound( RPM, Pitch, Doppler )
	if self.ENG then
		self.ENG:ChangePitch(  math.Clamp(math.Clamp(  70 + Pitch * 45, 50,255) + Doppler,0,255) )
		self.ENG:ChangeVolume( math.Clamp( -1 + Pitch * 6, 0.5,1) )
	end
	
	if self.DIST then
		self.DIST:ChangePitch(  math.Clamp(math.Clamp(  Pitch * 150, 50,255) + Doppler,0,255) )
		self.DIST:ChangeVolume( math.Clamp( -1 + Pitch * 6, 0.5,1) )
	end
end

function ENT:EngineActiveChanged( bActive )
	if bActive then
		self.ENG = CreateSound( self, "ARC170_ENGINE" )
		self.ENG:PlayEx(0,0)
		
		--self.DIST = CreateSound( self, "LFS_SPITFIRE_DIST" )
		--self.DIST:PlayEx(0,0)
	else
		self:SoundStop()
	end
end

function ENT:OnRemove()
	self:SoundStop()
end

function ENT:SoundStop()
	if self.DIST then
		self.DIST:Stop()
	end
	
	if self.ENG then
		self.ENG:Stop()
	end
end

function ENT:AnimFins()
end

function ENT:AnimRotor()
end

function ENT:AnimCabin()
end

function ENT:AnimLandingGear()
	self.SMLG = self.SMLG and self.SMLG + (180 *  self:GetLGear() - self.SMLG) * FrameTime() * 2.1 or 0	
	self.SMLG1 = self.SMLG1 and self.SMLG1 + (46 *  self:GetLGear() - self.SMLG1) * FrameTime() * 2.1 or 0	
	local Ang = 180 - self.SMLG
	local Mov = 46 - self.SMLG1
	self:ManipulateBoneAngles( 3, Angle(0,Ang,0) )
	self:ManipulateBoneAngles( 2, Angle(0,0,Ang*0.7) )
	self:ManipulateBoneAngles( 1, Angle(0,0,-Ang*0.7) )
	self:ManipulateBonePosition( 4, Vector(0,Mov,0) ) --Landing Gear
end

local mat = Material( "sprites/light_glow02_add" )
function ENT:Draw()
	self:DrawModel()
	
	if not self:GetEngineActive() then return end
	
	local Boost = self.BoostAdd or 0
	
	local Size = 80 + (self:GetRPM() / self:GetLimitRPM()) * 120 + Boost
	local Mirror = false
	for i = 0,1 do
		local Sub = Mirror and 1 or -1
		local pos = self:LocalToWorld( Vector(-215,-123 * Sub,7.78) )
		
		render.SetMaterial( mat )
		render.DrawSprite( pos, Size, Size, Color( 39, 207, 244 ) )
		Mirror = true

		if self:GetLGear() < 0.01  then
		render.DrawSprite( self:LocalToWorld( Vector(-135,0,-208.578) ), Size, Size, Color( 39, 207, 244 ) )
		end

	end
end
