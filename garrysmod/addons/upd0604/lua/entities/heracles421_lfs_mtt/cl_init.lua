include("shared.lua")

function ENT:DamageFX()
	local HP = self:GetHP()
	if HP == 0 or HP > self:GetMaxHP() * 0.5 then return end

	self.nextDFX = self.nextDFX or 0

	if self.nextDFX < CurTime() then
		self.nextDFX = CurTime() + 0.05

		local effectdata = EffectData()
			effectdata:SetOrigin( self:LocalToWorld( Vector(-120,0,300) ) )
		util.Effect( "lfs_blacksmoke", effectdata )
	end
end

function ENT:LFSCalcViewThirdPerson( view, ply, FirstPerson )
	local Pod = ply:GetVehicle()

	if ply == self:GetTurretDriver() then
		local radius = 800
		radius = radius + radius * Pod:GetCameraDistance()

		local StartPos = self:LocalToWorld( Vector(320,0,300) ) + view.angles:Up() * 100
		local EndPos = StartPos - view.angles:Forward() * radius

		local WallOffset = 4

		local tr = util.TraceHull( {
			start = StartPos,
			endpos = EndPos,
			filter = function( e )
				local c = e:GetClass()
				local collide = not c:StartWith( "prop_physics" ) and not c:StartWith( "prop_dynamic" ) and not c:StartWith( "prop_ragdoll" ) and not e:IsVehicle() and not c:StartWith( "gmod_" ) and not c:StartWith( "player" ) and not e.LFS

				return collide
			end,
			mins = Vector( -WallOffset, -WallOffset, -WallOffset ),
			maxs = Vector( WallOffset, WallOffset, WallOffset ),
		} )

		view.drawviewer = true
		view.origin = tr.HitPos

		if tr.Hit and not tr.StartSolid then
			view.origin = view.origin + tr.HitNormal * WallOffset
		end

	end

	return view
end

function ENT:LFSHudPaintInfoText( X, Y, speed, alt, AmmoPrimary, AmmoSecondary, Throttle )
	draw.SimpleText( "SPEED", "LFS_FONT", 10, 10, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	draw.SimpleText( speed.."km/h", "LFS_FONT", 120, 10, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

	draw.SimpleText( "PRI", "LFS_FONT", 10, 35, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	draw.SimpleText( AmmoPrimary, "LFS_FONT", 120, 35, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
end

function ENT:EngineActiveChanged( bActive )
	if bActive then
		self.ENG = CreateSound( self, "GALACTICA_MTT_ENGINE" )
		self.ENG:PlayEx(0,0)

		--self.DIST = CreateSound( self, "LFS_SPITFIRE_DIST" )
		--self.DIST:PlayEx(0,0)
	else
		self:SoundStop()
	end
end

function ENT:LFSHudPaintCrosshair( HitEnt, HitPly )
	self:LFSHudPaintDrivingCrosshair( HitEnt, HitPly )
	--[[if LocalPlayer():lfsGetInput( "FREELOOK" ) then
		self:LFSHudPaintAimingCrosshair( 0, 0, LocalPlayer() )
	else
		self:LFSHudPaintDrivingCrosshair( HitEnt, HitPly )
	end]]
end

function ENT:LFSHudPaintDrivingCrosshair( HitEnt, HitPly )
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

function ENT:LFSHudPaintAimingCrosshair( HitEnt, HitPly )
	local ID = self:LookupAttachment( "muzzle_right_top" )
	local Muzzle = self:GetAttachment( ID )

	if Muzzle then
		local startpos = Muzzle.Pos
		local Trace = util.TraceHull( {
			start = startpos,
			endpos = (startpos + Muzzle.Ang:Up() * 5000000),
			mins = Vector( -10, -10, -10 ),
			maxs = Vector( 10, 10, 10 ),
			filter = function( ent ) if ent == self or ent:GetClass() == "lunasflightschool_missile" then return false end return true end
		} )
		local HitPos = Trace.HitPos:ToScreen()

		local X = HitPos.x
		local Y = HitPos.y

		if self:GetIsCarried() then
			surface.SetDrawColor( 255, 0, 0, 255 )
		else
			surface.SetDrawColor( 255, 255, 255, 255 )
		end

		simfphys.LFS.DrawCircle( X, Y, 10 )
		surface.DrawLine( X + 10, Y, X + 20, Y )
		surface.DrawLine( X - 10, Y, X - 20, Y )
		surface.DrawLine( X, Y + 10, X, Y + 20 )
		surface.DrawLine( X, Y - 10, X, Y - 20 )

		-- shadow
		surface.SetDrawColor( 0, 0, 0, 80 )
		simfphys.LFS.DrawCircle( X + 1, Y + 1, 10 )
		surface.DrawLine( X + 11, Y + 1, X + 21, Y + 1 )
		surface.DrawLine( X - 9, Y + 1, X - 16, Y + 1 )
		surface.DrawLine( X + 1, Y + 11, X + 1, Y + 21 )
		surface.DrawLine( X + 1, Y - 19, X + 1, Y - 16 )
	end
end

--[[function ENT:AnimLandingGear()
	self.SMLG = self.SMLG and self.SMLG + (20 *  self:GetLGear() - self.SMLG) * FrameTime() * 2 or 0

	local Ang = 20 - self.SMLG
	self:ManipulateBoneAngles( 8, Angle(0,-Ang,0) )
	self:ManipulateBoneAngles( 9, Angle(0,Ang,0) )

	self:ManipulateBoneAngles( 10, Angle(0,Ang,0) )
	self:ManipulateBoneAngles( 11, Angle(0,-Ang,0) )
end]]
