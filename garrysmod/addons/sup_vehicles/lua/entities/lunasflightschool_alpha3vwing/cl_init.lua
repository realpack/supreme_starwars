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
			effectdata:SetOrigin( self:LocalToWorld(Vector(-80,0, 0) + VectorRand() * 8) )
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
				local Sub = Mirror and 1 or -2.6
				local vOffset = self:LocalToWorld( Vector(-90,0, 9.12* Sub) )
				local vNormal = -self:GetForward()

				vOffset = vOffset + vNormal * 5

				local particle = emitter:Add( "effects/muzzleflash2", vOffset )
				if not particle then return end

				particle:SetVelocity( vNormal * math.Rand(500,1000) + self:GetVelocity() )
				particle:SetLifeTime( 0 )
				particle:SetDieTime( 0.1 )
				particle:SetStartAlpha( 255 )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( math.Rand(5,8) )
				particle:SetEndSize( math.Rand(0,10) )
				particle:SetRoll( math.Rand(-1,1) * 100 )
				
				particle:SetColor( 224, 180, 109 )
			
				Mirror = true
			end
			
			emitter:Finish()
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
		self.ENG = CreateSound( self, "VWINGENGINE" )
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

function ENT:AnimRotor()

	self.AstroAng = self.AstroAng or 0
	self.nextAstro = self.nextAstro or 0
	if self.nextAstro < CurTime() then
		self.nextAstro = CurTime() + math.Rand(0.5,2)
		self.AstroAng = math.Rand(-180,180)
		
		if math.random(0,4) == 3 then
			self:EmitSound( "lfs/naboo_n1_starfighter/astromech/"..math.random(1,11)..".ogg" )
		end
	end
	
	self.smastro = self.smastro and (self.smastro + (self.AstroAng - self.smastro) * FrameTime() * 10) or 0
	
	self:ManipulateBoneAngles( 1, Angle(self.smastro,0,0) )
end

function ENT:AnimCabin()
end

function ENT:AnimLandingGear()

	self.SMLG = self.SMLG and self.SMLG + (90 *  self:GetLGear() - self.SMLG) * FrameTime() * 2.1 or 0	
	local Ang = 90 - self.SMLG
	self:ManipulateBoneAngles( 2, Angle(0,Ang,0) )
	self:ManipulateBoneAngles( 3, Angle(0,Ang,0) )	


end

local mat = Material( "sprites/light_glow02_add" )
function ENT:Draw()
	self:DrawModel()
	
	if not self:GetEngineActive() then return end
	
	local Boost = self.BoostAdd or 0
	
	local Size = 60 + (self:GetRPM() / self:GetLimitRPM()) * 120 + Boost
	local Mirror = false
	for i = 0,1 do
		local Sub = Mirror and 1 or -2.6
		local pos = self:LocalToWorld( Vector(-90,0, 9.12* Sub) )
		
		render.SetMaterial( mat )
		render.DrawSprite( pos, Size, Size, Color( 224, 180, 109 ) )
		Mirror = true
	end
end
