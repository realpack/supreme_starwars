include("shared.lua")

function ENT:DamageFX()
	local HP = self:GetHP()
	if HP == 0 or HP > self:GetMaxHP() * 0.5 then return end
	
	self.nextDFX = self.nextDFX or 0
	
	if self.nextDFX < CurTime() then
		self.nextDFX = CurTime() + 0.05
		
		local effectdata = EffectData()
			effectdata:SetOrigin( self:LocalToWorld( Vector(-90,0,40) ) )
		util.Effect( "lfs_blacksmoke", effectdata )
	end
end

function ENT:LFSCalcViewThirdPerson( view, ply, FirstPerson )
	local Pod = ply:GetVehicle()
	
	if ply == self:GetTurretDriver() then
		local radius = 800
		radius = radius + radius * Pod:GetCameraDistance()
		
		local StartPos = self:LocalToWorld( Vector(-130.360611,0,111.885109) ) + view.angles:Up() * 100
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
	
	draw.SimpleText( "SEC", "LFS_FONT", 10, 60, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	draw.SimpleText( AmmoSecondary, "LFS_FONT", 120, 60, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
end

function ENT:LFSHudPaintPassenger( X, Y, ply )	
	if ply == self:GetTurretDriver() then
		draw.SimpleText( "PRI", "LFS_FONT", 10, 10, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.SimpleText( self:GetAmmoPrimary(), "LFS_FONT", 120, 10, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		
		local ID = self:LookupAttachment( "muzzle_cannon" )
		local Muzzle = self:GetAttachment( ID )
	
		if Muzzle then
			local startpos = Muzzle.Pos
			local Trace = util.TraceHull( {
				start = startpos,
				endpos = (startpos + Muzzle.Ang:Up() * 50000),
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
end

function ENT:EngineActiveChanged( bActive )
	if bActive then
		self.ENG = CreateSound( self, "TX_ENGINE" )
		self.ENG:PlayEx(0,0)
		
		--self.DIST = CreateSound( self, "LFS_SPITFIRE_DIST" )
		--self.DIST:PlayEx(0,0)
	else
		self:SoundStop()
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

function ENT:AnimLandingGear()
	self.SMLG = self.SMLG and self.SMLG + (11 *  self:GetLGear() - self.SMLG) * FrameTime() * 9 or 0
	
	local Pos = 11 - self.SMLG
	self:ManipulateBonePosition( 17, Vector(0,Pos,0) )
	self:ManipulateBonePosition( 18, Vector(0,Pos,0) )
end