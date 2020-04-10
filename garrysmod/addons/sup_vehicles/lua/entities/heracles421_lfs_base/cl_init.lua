include("shared.lua")
include( "lib_quaternions.lua" )

function ENT:DamageFX()
	local HP = self:GetHP()
	if HP == 0 or HP > self:GetMaxHP() * 0.5 then return end

	self.nextDFX = self.nextDFX or 0

	if self.nextDFX < CurTime() then
		self.nextDFX = CurTime() + 0.05

		local effectdata = EffectData()
			effectdata:SetOrigin( self:LocalToWorld( Vector(0,0,0) ) )
		util.Effect( "lfs_blacksmoke", effectdata )
	end
end

function ENT:OnRemove()
	self:SoundStop()
end

function ENT:Draw()
	self:DrawModel()

	if self.DebugMode then
		local Mins, Maxs = self:GetRotatedAABB( self:OBBMins(), self:OBBMaxs() )
		Mins = Vector(Mins.x * self.HitBoxMultiplier, Mins.y * self.HitBoxMultiplier, 0)
		Maxs = Vector(Maxs.x * self.HitBoxMultiplier, Maxs.y * self.HitBoxMultiplier, 0)
		local startpos = self:GetMassCenter()
		local dir = self:GetUp()

		self:DoTrace()

		local Trace = self.GroundTrace
		if self.WaterTrace.Fraction <= Trace.Fraction and !self.IgnoreWater then
			Trace = self.WaterTrace
		end

		render.DrawWireframeBox( startpos, Angle( 0, 0, 0 ), Mins, Maxs, Color( 255, 255, 255 ), true )
		render.DrawLine( Trace.HitPos, startpos + dir * 200, Color( 0, 255, 0 ), true )

		local clr = color_white
		local IsOnGround = Trace.Hit and math.deg( math.acos( math.Clamp( Trace.HitNormal:Dot( Vector(0,0,1) ) ,-1,1) ) ) < 70
		if IsOnGround then
			clr = Color( 255, 0, 0 )
		end

		render.DrawWireframeBox( Trace.HitPos, Angle( 0, 0, 0 ), Mins, Maxs, clr, true )
	end
end

function ENT:LFSCalcViewFirstPerson( view, ply )
	return self:LFSCalcViewThirdPerson( view, ply, true )
end

function ENT:LFSCalcViewThirdPerson( view, ply, FirstPerson )
	return view
end

function ENT:LFSHudPaintInfoText( X, Y, speed, alt, AmmoPrimary, AmmoSecondary, Throttle )
	draw.SimpleText( "SPEED", "LFS_FONT", 10, 10, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	draw.SimpleText( speed.."km/h", "LFS_FONT", 120, 10, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

	draw.SimpleText( "PRI", "LFS_FONT", 10, 35, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	draw.SimpleText( AmmoPrimary, "LFS_FONT", 120, 35, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
end

function ENT:LFSHudPaintInfoLine( HitPlane, HitPilot, LFS_TIME_NOTIFY, Dir, Len, FREELOOK )
	surface.SetDrawColor( 255, 255, 255, 100 )
	if Len > 34 then
		local FailStart = LFS_TIME_NOTIFY > CurTime()
		if FailStart then
			surface.SetDrawColor( 255, 0, 0, math.abs( math.cos( CurTime() * 10 ) ) * 255 )
		end

		if not FREELOOK or FailStart then
			surface.DrawLine( HitPlane.x + Dir.x * 20, HitPlane.y + Dir.y * 20, HitPilot.x - Dir.x * 10, HitPilot.y- Dir.y * 10 )

			-- shadow
			surface.SetDrawColor( 0, 0, 0, 50 )
			surface.DrawLine( HitPlane.x + Dir.x * 20 + 1, HitPlane.y + Dir.y * 20 + 1, HitPilot.x - Dir.x * 10+ 1, HitPilot.y- Dir.y * 10 + 1 )
		end
	end
end

function ENT:LFSHudPaintCrosshair( HitEnt, HitPly)
	local startpos = self:GetRotorPos()
	local TracePilot = util.TraceHull( {
		start = startpos,
		endpos = (startpos + LocalPlayer():EyeAngles():Forward() * 50000),
		mins = Vector( -10, -10, -10 ),
		maxs = Vector( 10, 10, 10 ),
		filter = {self}
	} )
	local HitPilot = TracePilot.HitPos:ToScreen()

	local X = HitPilot.x
	local Y = HitPilot.y

	if self:GetFrontInRange() then
		surface.SetDrawColor( 255, 255, 255, 255 )
	else
		surface.SetDrawColor( 255, 0, 0, 255 )
	end

	simfphys.LFS.DrawCircle( X, Y, 10 )
	surface.DrawLine( X + 10, Y, X + 20, Y )
	surface.DrawLine( X - 10, Y, X - 20, Y )
	surface.DrawLine( X, Y + 10, X, Y + 20 )
	surface.DrawLine( X, Y - 10, X, Y - 20 )
	simfphys.LFS.DrawCircle( HitEnt.x, HitEnt.y, 20 )

	-- shadow
	surface.SetDrawColor( 0, 0, 0, 80 )
	simfphys.LFS.DrawCircle( X + 1, Y + 1, 10 )
	surface.DrawLine( X + 11, Y + 1, X + 21, Y + 1 )
	surface.DrawLine( X - 9, Y + 1, X - 16, Y + 1 )
	surface.DrawLine( X + 1, Y + 11, X + 1, Y + 21 )
	surface.DrawLine( X + 1, Y - 19, X + 1, Y - 16 )
	simfphys.LFS.DrawCircle( HitEnt.x + 1, HitEnt.y + 1, 20 )
end

function ENT:LFSHudPaintRollIndicator( HitPlane, Enabled )
end

function ENT:LFSHudPaintPassenger( X, Y, ply )
end

function ENT:Think()
	self:AnimCabin()
	self:AnimLandingGear()
	self:AnimRotor()
	self:AnimFins()

	self:CheckEngineState()

	self:ExhaustFX()
	self:DamageFX()

	self:OnTick()
end

function ENT:OnTick()
end

function ENT:CalcEngineSound( RPM, Pitch, Doppler )
	local speed = self:GetDeltaV():Length() / self.MoveSpeed
	if self.ENG then
		self.ENG:ChangePitch(  math.Clamp(math.Clamp(  70 + speed * 45, 50,255) + Doppler,0,255) )
		self.ENG:ChangeVolume( math.Clamp( -1 + speed * 6, 0.5,1) )
	end

	if self.DIST then
		self.DIST:ChangePitch(  math.Clamp(math.Clamp(  speed * 150, 50,255) + Doppler,0,255) )
		self.DIST:ChangeVolume( math.Clamp( -1 + speed * 6, 0.5,1) )
	end
end

function ENT:SoundStop()
	if self.DIST then
		self.DIST:Stop()
	end

	if self.ENG then
		self.ENG:Stop()
	end
end
