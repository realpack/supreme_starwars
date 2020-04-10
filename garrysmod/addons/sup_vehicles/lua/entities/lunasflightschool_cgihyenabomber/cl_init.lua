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
		
		for k,v in pairs( {Vector(-47.77,-86.53,-0.22) } ) do
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
		
		local TargetOrigin = view.origin - view.angles:Forward() * radius  + view.angles:Up() * 750 * 0.2
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
	
	if self:GetEngineActive() then 
	
	local Boost = self.BoostAdd or 0
	
	local Size = 50 + (self:GetRPM() / self:GetLimitRPM()) * 15 + Boost

	render.SetMaterial( mat )
	render.DrawSprite( self:LocalToWorld( Vector(-56.71,-78.38,0.22) ), Size, Size, Color( 38, 0, 230, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-54.87,-82.29,0.2) ),  Size, Size, Color( 38, 0, 230, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-53.05,-85.9,0.09) ), Size, Size, Color( 38, 0, 230, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-51.41,-89.48,0.09) ), Size, Size, Color( 38, 0, 230, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-49.39,-93.1,0.09) ),  Size, Size, Color( 38, 0, 230, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-47.66,-97.01,0.04) ),Size, Size, Color( 38, 0, 230, 255) )

	render.DrawSprite( self:LocalToWorld( Vector(-56.32,96.61,0.17) ),  Size, Size, Color( 38, 0, 230, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-54.57,100.1,0.07) ), Size, Size, Color( 38, 0, 230, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-53.08,103.77,-0.01) ), Size, Size, Color( 38, 0, 230, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-51.11,107.39,-0.02) ), Size, Size, Color( 38, 0, 230, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-49.42,110.99,-0.03) ), Size, Size, Color( 38, 0, 230, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-47.68,114.49,0.02) ), Size, Size, Color( 38, 0, 230, 255) )

	render.DrawSprite( self:LocalToWorld( Vector(-56.71,-78.38,0.22) ), Size, Size, Color( 38, 0, 230, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-54.87,-82.29,0.2) ),  Size, Size, Color( 38, 0, 230, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-53.05,-85.9,0.09) ), Size, Size, Color( 38, 0, 230, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-51.41,-89.48,0.09) ), Size, Size, Color( 38, 0, 230, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-49.39,-93.1,0.09) ),  Size, Size, Color( 38, 0, 230, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-47.66,-97.01,0.04) ),Size, Size, Color( 38, 0, 230, 255) )

	render.DrawSprite( self:LocalToWorld( Vector(-56.32,96.61,0.17) ),  Size, Size, Color( 38, 0, 230, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-54.57,100.1,0.07) ), Size, Size, Color( 38, 0, 230, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-53.08,103.77,-0.01) ), Size, Size, Color( 38, 0, 230, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-51.11,107.39,-0.02) ), Size, Size, Color( 38, 0, 230, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-49.42,110.99,-0.03) ), Size, Size, Color( 38, 0, 230, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-47.68,114.49,0.02) ), Size, Size, Color( 38, 0, 230, 255) )	
	end
	
	
	if self:GetEngineActive() then

	local Size = 10	
	render.SetMaterial( mat )
	render.DrawSprite( self:LocalToWorld( Vector(-56.71,-78.38,0.22) ), Size, Size, Color( 255, 255, 255, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-54.87,-82.29,0.2) ), Size, Size, Color( 255, 255, 255, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-53.05,-85.9,0.09) ), Size, Size, Color( 255, 255, 255, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-51.41,-89.48,0.09) ), Size, Size, Color( 255, 255, 255, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-49.39,-93.1,0.09) ), Size, Size, Color( 255, 255, 255, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-47.66,-97.01,0.04) ), Size, Size, Color( 255, 255, 255, 255) )

	render.DrawSprite( self:LocalToWorld( Vector(-56.32,96.61,0.17) ), Size, Size, Color( 255, 255, 255, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-54.57,100.1,0.07) ), Size, Size, Color( 255, 255, 255, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-53.08,103.77,-0.01) ), Size, Size, Color( 255, 255, 255, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-51.11,107.39,-0.02) ), Size, Size, Color( 255, 255, 255, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-49.42,110.99,-0.03) ), Size, Size, Color( 255, 255, 255, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-47.68,114.49,0.02) ), Size, Size, Color( 255, 255, 255, 255) )
end

--------------Eyes 1----------------------

	if self:GetEngineActive() then

	local Size = 20
	render.SetMaterial( mat )
	render.DrawSprite( self:LocalToWorld( Vector(6.85,37.7,10.6) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(4.93,37.5,12.18) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(2.6,37,13.31) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(0.51,36.73,14.41) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-1.9,36.42,15.61) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-4.4,36.3,16.84) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-7.45,36.15,18.06) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-10.11,36.01,19.08) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-12.76,36.22,20.04) ), Size, Size, Color( 255, 0, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-15.29,35.94,20.93) ), Size, Size, Color( 255, 0, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-18.14,35.87,22.1) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-20.94,35.72,22.94) ), Size, Size, Color( 255, 0, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-23.76,35.51,24.05) ), Size, Size, Color( 255, 0, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-26.33,35.57,25.11) ), Size, Size, Color( 255, 0, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-29.35,35.31,26.24) ), Size, Size, Color( 255, 0, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-32.18,35.19,27.34) ), Size, Size, Color( 255, 0, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-35.23,35.05,28.06) ), Size, Size, Color( 255, 0, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-38.26,35.06,28.7) ), Size, Size, Color( 255, 0, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-41.06,35.06,29.41) ), Size, Size, Color( 255, 0, 0, 255) )	

	render.DrawSprite( self:LocalToWorld( Vector(-13.95,32.82,17.12) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-15.64,33.72,18.99) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-13.02,34.14,18.38) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-10.48,34.25,17.16) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-7.68,34.54,16.37) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-4.85,34.85,15.84) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-2.6,35.47,14.81) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-11.88,33.09,16.47) ), Size, Size, Color( 255, 0, 0, 255) )


--------------Eyes 2----------------------
	
	render.DrawSprite( self:LocalToWorld( Vector(6.85,51.1,10.6) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(4.93,51.4,12.18) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(2.6,51.7,13.31) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(0.51,52,14.41) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-1.9,52.3,15.61) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-4.4,52.6,16.84) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-7.45,52.9,18.06) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-10.11,53.2,19.08) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-12.76,53.3,20.04) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-15.29,53.3,20.93) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-18.14,53.3,22.1) ), Size, Size, Color( 255, 0, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-20.94,53.3,22.94) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-23.76,53.3,24.05) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-26.33,53.5,25.11) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-29.35,53.6,26.24) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-32.18,53.7,27.34) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-35.23,53.7,28.06) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-38.26,53.8,28.7) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-41.06,53.9,29.41) ), Size, Size, Color( 255, 0, 0, 255) )

	render.DrawSprite( self:LocalToWorld( Vector(-13.95,56.5,17.12) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-15.64,55.4,19.3) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-13.02,55.1,18.48) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-10.48,54.9,17.46) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-7.68,54.6,16.57) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-4.85,54.3,15.84) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-2.6,53.9,14.81) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-11.88,56.3,16.47) ), Size, Size, Color( 255, 0, 0, 255) )

end
end