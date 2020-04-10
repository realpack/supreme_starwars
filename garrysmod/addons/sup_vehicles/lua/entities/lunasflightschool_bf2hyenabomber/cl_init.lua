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

function ENT:DamageFX()
	local HP = self:GetHP()
	if HP > self:GetMaxHP() * 0.5 then return end
	self.nextDFX = self.nextDFX or 0
	
	if self.nextDFX < CurTime() then
		self.nextDFX = CurTime() + 0.05
		
		for k,v in pairs( {Vector(3.52,99.98,-68.78) } ) do
			local effectdata = EffectData()
				effectdata:SetOrigin( self:LocalToWorld( v ) )
			util.Effect( "lfs_blacksmoke", effectdata )

		end
	end

end

function ENT:LFSCalcViewThirdPerson( view, ply ) -- modify third person camera view here
	local ply = LocalPlayer()
	
	local Pod = ply:GetVehicle()
	
	if not IsValid( Pod ) then return view end
	
	if ply == self:GetDriver() then
		local radius = 500
		radius = radius + radius * Pod:GetCameraDistance()
		
		view.origin = self:LocalToWorld( Vector(0,0,0) )
		
		local TargetOrigin = view.origin - view.angles:Forward() * radius  + view.angles:Up() * 750 * 0.1
		local WallOffset = 1

		local tr = util.TraceHull( {
			start = view.origin,
			endpos = TargetOrigin,
			filter = function( e )
				local c = e:GetClass()
				local collide = not c:StartWith( "prop_physics" ) and not c:StartWith( "prop_dynamic" ) and not c:StartWith( "prop_ragdoll" ) and not e:IsVehicle() and not c:StartWith( "gmod_" ) and not c:StartWith( "player" ) and not e.LFS
				
				return collide
			end,
			mins = Vector( -WallOffset, -WallOffset, -WallOffset ),
			maxs = Vector( WallOffset, WallOffset, WallOffset ),
		} )
		
		view.origin = tr.HitPos
		
		if tr.Hit and not tr.StartSolid then
			view.origin = view.origin + tr.HitNormal * WallOffset
		end
		
		return view
	end
end

function ENT:CalcEngineSound( RPM, Pitch, Doppler )
	local ply = LocalPlayer()
	local mypos = self:GetPos()
	local plypos = ply:GetPos() + (self.FirstPerson and Vector(0,0,0) or -ply:EyeAngles():Forward() * 50000)
	local IsInFront = self:WorldToLocal( plypos ).x > -100

	local daVol = math.min( (plypos - mypos):Length() / 7000,0.7 )
	
	if self.ENG then
		self.ENG:ChangePitch( math.Clamp(70 + Pitch * 30 + Doppler * 1.5,0,255) )
		self.ENG:ChangeVolume( self.FirstPerson and 0 or (IsInFront and 1 or daVol), 1.2)
	end
	
	if self.DIST then
		self.DIST:ChangePitch( math.Clamp(90 + Pitch * 10 + Doppler * 0.5,0,255) )
		self.DIST:ChangeVolume( self.FirstPerson and 0 or (IsInFront and daVol or 1), 0.2)
	end

end

function ENT:EngineActiveChanged( bActive )
	if bActive then
		self.ENG = CreateSound( self, "HYENA_DIST_A" )
		self.ENG:PlayEx(0,0)
		
		self.DIST = CreateSound( self, "HYENA_DIST_B" )
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
	
	cam.Start3D2D( self:LocalToWorld( Vector(9,-119,-68.86) ), self:LocalToWorldAngles( Angle(0,295,90) ), 1.67 )
		draw.NoTexture()
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawTexturedRectRotated( -11, -1.5, 19.7, 6 , -3.4 )
		surface.DrawTexturedRectRotated( -11, 1.5, 19.7, 6 , 3.4 )
	cam.End3D2D()
	
	cam.Start3D2D( self:LocalToWorld( Vector(9,118,-68.86) ), self:LocalToWorldAngles( Angle(0,65,-90) ), 1.65 )
		draw.NoTexture()
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawTexturedRectRotated( -11, -1.5, 19.7, 6 , -3.4 )
		surface.DrawTexturedRectRotated( -11, 1.5, 19.7, 6 , 3.4 )
	cam.End3D2D()
	
	if not istable( self.FxPos ) then
		self.FxPos = {
			Vector(2,112.02,-65.62),
			Vector(-1.3,105.54,-65.69),
			Vector(-4.59,99.56,-65.74),
			Vector(-7.04,93.32,-65.44),
			Vector(3.26,111.68,-72.02),
			Vector(-0.96,105.53,-71.91),
			Vector(-4.05,99.4,-71.94),
			Vector(-6.5,93.15,-71.93),
			Vector(-6.08,-93.34,-65.64),
			Vector(-3.24,-99.63,-65.7),
			Vector(-0.66,-105.62,-65.77),
			Vector(2.11,-111.75,-65.63),
			Vector(-6.8,-93.49,-72.11),
			Vector(-3.27,-99.57,-72.07),
			Vector(0.95,-105.68,-72.05),
			Vector(-6.77,88.66,-65.53),
			Vector(-6.64,88.74,-72.2),
			Vector(-7.94,-88.69,-65.27),
			Vector(-7.72,-88.74,-72.08),
		}
	end
	
	local Boost = self.BoostAdd or 0
	local Size = 30 + (self:GetRPM() / self:GetLimitRPM()) * 15 + Boost
	
	for _, v in pairs( self.FxPos ) do
		local pos = self:LocalToWorld( v )
		render.SetMaterial( mat )
		render.DrawSprite( pos, Size, Size, Color( 38, 0, 230, 255) )
	end

	if self:GetEngineActive() then

-------------------------Eyes1----------------
	local Size = 20
	render.SetMaterial( mat )

	render.DrawSprite( self:LocalToWorld( Vector(-4.24,-32.63,-33.78) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-1.36,-32.44,-34.23) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(1.25,-32.47,-34.87) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(3.88,-32.44,-35.81) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(6.37,-32.42,-36.6) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(8.71,-32.32,-37.31) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(10.92,-32.38,-38.06) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(13.15,-32.34,-39.08) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(15.76,-32.34,-39.95) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(17.98,-32.22,-40.91) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(20.44,-32.24,-41.73) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(22.99,-32.26,-42.67) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(25.08,-32.25,-43.52) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(27.65,-32.25,-44.66) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(29.85,-32.33,-45.62) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(32.4,-32.27,-46.81) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(35.06,-32.34,-48.03) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(37.47,-32.41,-49.31) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(40.04,-32.43,-50.77) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(42.42,-32.43,-52.07) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(44.13,-32.19,-53.15) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(45.71,-32.17,-53.9) ), Size, Size, Color( 255, 0, 0, 255) )

	render.DrawSprite( self:LocalToWorld( Vector(21.45,-28.53,-43.97) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(20.25,-30.31,-42.29) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(24.31,-28.89,-44.85) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(27.2,-29.47,-45.88) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(29.85,-29.61,-46.92) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(32.38,-30.04,-47.82) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(34.57,-30.28,-48.56) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(36.78,-30.71,-49.7) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(39.04,-31.04,-50.84) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(40.89,-31.45,-51.53) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(22.34,-30.52,-43.15) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(25.11,-30.59,-44.32) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(26.99,-30.71,-45.05) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(29.72,-30.86,-46.12) ), Size, Size, Color( 255, 0, 0, 255) )

-------------------------Eyes2----------------

	render.DrawSprite( self:LocalToWorld( Vector(-4.24,-42.63,-33.78) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-1.36,-42.73,-34.23) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(1.25,-42.83,-34.87) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(3.88,-42.83,-35.81) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(6.37,-42.83,-36.6) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(8.71,-42.83,-37.31) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(10.92,-42.83,-38.06) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(13.15,-42.83,-39.08) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(15.76,-42.83,-39.95) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(17.98,-43,-40.91) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(20.44,-43,-41.73) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(22.99,-43,-42.67) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(25.08,-43,-43.52) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(27.65,-43,-44.66) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(29.85,-43,-45.62) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(32.4,-43,-46.81) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(35.06,-43,-48.03) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(37.47,-43,-49.31) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(40.04,-43,-50.77) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(42.42,-43,-52.07) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(44.13,-43,-53.15) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(45.71,-43,-53.9) ), Size, Size, Color( 255, 0, 0, 255) )

	render.DrawSprite( self:LocalToWorld( Vector(21.45,-46.7,-43.97) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(20.25,-45.31,-42.29) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(24.31,-46.4,-44.85) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(27.2,-46,-45.88) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(29.85,-45.7,-46.92) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(32.38,-45.3,-47.82) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(34.57,-45,-48.56) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(36.78,-44.7,-49.7) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(39.04,-44.4,-50.84) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(40.89,-44.3,-51.53) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(22.34,-45,-43.15) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(25.11,-44.8,-44.32) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(26.99,-44.6,-45.05) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(29.72,-44.5,-46.12) ), Size, Size, Color( 255, 0, 0, 255) )

end
end