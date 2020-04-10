--DO NOT EDIT OR REUPLOAD THIS FILE

include("shared.lua")

function ENT:Initialize()	
end

function ENT:ExhaustFX()
	if not self:GetEngineActive() then return end
	
	self.nextEFX = self.nextEFX or 0
	
	local THR = (self:GetRPM() - self.IdleRPM) / (self.LimitRPM - self.IdleRPM)
	
	local Driver = self:GetDriver()
	if IsValid( Driver ) then
		local W = Driver:KeyPressed( IN_FORWARD )
		if W ~= self.oldW then
			self.oldW = W
			if W then
				self.BoostAdd = 40
			end
		end
	end
	
	self.BoostAdd = self.BoostAdd and (self.BoostAdd - self.BoostAdd * FrameTime()) or 0
end

function ENT:CalcEngineSound( RPM, Pitch, Doppler )
	if self.ENG then
		self.ENG:ChangePitch(  math.Clamp(math.Clamp(  60 + Pitch * 50, 80,255) + Doppler,0,255) )
		self.ENG:ChangeVolume( math.Clamp( -1 + Pitch * 6, 0.5,1) )
	end
	
	if self.DIST then
		self.DIST:ChangePitch(  math.Clamp(math.Clamp(  Pitch * 100, 50,255) + Doppler * 1.25,0,255) )
		self.DIST:ChangeVolume( math.Clamp( -1.5 + Pitch * 6, 0.5,1) )
	end
end

function ENT:EngineActiveChanged( bActive )
	if bActive then
		self.ENG = CreateSound( self, "ADVDROID_ENGINE" )
		self.ENG:PlayEx(0,0)
		
		self.DIST = CreateSound( self, "ADVDROID_DIST" )
		self.DIST:PlayEx(0,0)
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
end


local mat = Material( "sprites/light_glow02_add" )
function ENT:Draw()
	self:DrawModel()
	
	if not self:GetEngineActive() then return end
	
	-- Far Bottom
	
	cam.Start3D2D( self:LocalToWorld( Vector(-181,-65,45) ), self:LocalToWorldAngles( Angle(0,291.5,120) ), 1 )
		draw.NoTexture()
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawTexturedRectRotated( 0, 0, 45, 6 , 0 )
	cam.End3D2D()
	
	cam.Start3D2D( self:LocalToWorld( Vector(-181,65,45) ), self:LocalToWorldAngles( Angle(0,68.5,-120) ), 1 )
		draw.NoTexture()
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawTexturedRectRotated( 0, 0, 45, 6 , 0 )
	cam.End3D2D()
	
	-- Near Bottom 
	
	cam.Start3D2D( self:LocalToWorld( Vector(-192,-22,45) ), self:LocalToWorldAngles( Angle(0,276.5,120) ), 1 )
		draw.NoTexture()
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawTexturedRectRotated( 0, 0, 45, 6 , 0 )
	cam.End3D2D()
	
	cam.Start3D2D( self:LocalToWorld( Vector(-192,22,45) ), self:LocalToWorldAngles( Angle(0,83.5,-120) ), 1 )
		draw.NoTexture()
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawTexturedRectRotated( 0, 0, 45, 6 , 0 )
	cam.End3D2D()
	
	-- Far Top
	
	cam.Start3D2D( self:LocalToWorld( Vector(-181,-65,53) ), self:LocalToWorldAngles( Angle(0,291.5,60) ), 1 )
		draw.NoTexture()
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawTexturedRectRotated( 0, 0, 45, 6 , 0 )
	cam.End3D2D()
	
	cam.Start3D2D( self:LocalToWorld( Vector(-181,65,53) ), self:LocalToWorldAngles( Angle(0,68.5,-60) ), 1 )
		draw.NoTexture()
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawTexturedRectRotated( 0, 0, 45, 6 , 0 )
	cam.End3D2D()
	
	-- Near Top
	
	cam.Start3D2D( self:LocalToWorld( Vector(-192,-22,53) ), self:LocalToWorldAngles( Angle(0,276.5,60) ), 1 )
		draw.NoTexture()
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawTexturedRectRotated( 0, 0, 45, 6 , 0 )
	cam.End3D2D()
	
	cam.Start3D2D( self:LocalToWorld( Vector(-192,22,53) ), self:LocalToWorldAngles( Angle(0,83.5,-60) ), 1 )
		draw.NoTexture()
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawTexturedRectRotated( 0, 0, 45, 6 , 0 )
	cam.End3D2D()
	
	if not istable( self.FxPos ) then
		self.FxPos = {
			Vector(-172,-89,53),
			Vector(-175,-84,53),
			Vector(-178,-78,53),
			Vector(-180,-73,53),
			Vector(-181,-68,53),
			Vector(-183,-64,53),
			Vector(-185,-58,53),
			Vector(-187,-52,53),
			Vector(-190,-47,53),
			
			Vector(-191,-41,53),
			Vector(-192,-35,53),
			Vector(-193,-29,53),
			Vector(-194,-23,53),
			Vector(-195,-17,53),
			Vector(-196,-11,53),
			Vector(-197,-5,53),
			
			Vector(-197,0,53),
			
			Vector(-197,5,53),
			Vector(-196,11,53),
			Vector(-195,17,53),
			Vector(-194,23,53),
			Vector(-193,29,53),
			Vector(-192,35,53),
			Vector(-191,41,53),
			
			Vector(-190,47,53),
			Vector(-187,52,53),
			Vector(-185,58,53),
			Vector(-183,64,53),
			Vector(-181,68,53),
			Vector(-180,73,53),
			Vector(-178,78,53),
			Vector(-175,84,53),
			Vector(-172,89,53),
			
			-- Bottom
			
			Vector(-190,-47,44),
			Vector(-187,-52,44),
			Vector(-185,-58,44),
			Vector(-183,-64,44),
			Vector(-181,-68,44),
			Vector(-180,-73,44),
			Vector(-178,-78,44),
			Vector(-175,-84,44),
			Vector(-172,-89,44),
			
			Vector(-191,-41,44),
			Vector(-192,-35,44),
			Vector(-193,-29,44),
			Vector(-194,-23,44),
			Vector(-195,-17,44),
			Vector(-196,-11,44),
			Vector(-197,-5,44),
			
			Vector(-197,0,44),
	
			Vector(-197,5,44),
			Vector(-196,11,44),
			Vector(-195,17,44),
			Vector(-194,23,44),
			Vector(-193,29,44),
			Vector(-192,35,44),
			Vector(-191,41,44),
			
			Vector(-190,47,44),
			Vector(-187,52,44),
			Vector(-185,58,44),
			Vector(-183,64,44),
			Vector(-181,68,44),
			Vector(-180,73,44),
			Vector(-178,78,44),
			Vector(-175,84,44),
			Vector(-172,89,44),
		}
	end
	
	local Boost = self.BoostAdd or 0
	local Size = 30 + (self:GetRPM() / self:GetLimitRPM()) * 15 + Boost
	
	for _, v in pairs( self.FxPos ) do
		local pos = self:LocalToWorld( v )
		render.SetMaterial( mat )
		render.DrawSprite( pos, Size, Size, Color( 230, 30, 0, 255) )
	end
end
