include("shared.lua")

local VisibleTime = 0
local smVisible = 0
local zoom_mat = Material( "vgui/zoom" )
local mat = Material( "sprites/light_glow02_add" )

local function DrawCircle( X, Y, radius )
	local segmentdist = 360 / ( 2 * math.pi * radius / 2 )
	
	for a = 0, 360, segmentdist do
		surface.DrawLine( X + math.cos( math.rad( a ) ) * radius, Y - math.sin( math.rad( a ) ) * radius, X + math.cos( math.rad( a + segmentdist ) ) * radius, Y - math.sin( math.rad( a + segmentdist ) ) * radius )
	end
end

function ENT:LFSHudPaintPassenger( X, Y, ply )
	if ply ~= self:GetGunner() then return end

	local UsingGunCam = self.ToggledView
	
	local HitPlane = Vector(X*0.5,Y*0.5,0)

	local ID = self:LookupAttachment( "muzzle" )
	local Attachment = self:GetAttachment( ID )

	if Attachment then
		-- for the crosshair to be accurate CLIENT aiming code has to be exactly the same as SERVER aiming code
		
	local EyeAngles = Pod:WorldToLocalAngles( Driver:EyeAngles() )
	local Forward = -self:GetForward()
	
	local AimDirToForwardDir = math.deg( math.acos( math.Clamp( Forward:Dot( EyeAngles:Forward() ) ,-1,1) ) )
	if AimDirToForwardDir < 95 then return end
		
	local startpos =  self:GetRotorPos()
	local TracePlane = util.TraceHull( {
		start = startpos,
		endpos = (startpos + EyeAngles:Forward() * 50000),
		mins = Vector( -10, -10, -10 ),
		maxs = Vector( 10, 10, 10 ),
		filter = self
	} )	
		
		local pToScreen = Trace.HitPos:ToScreen()
		
		HitPlane = Vector(pToScreen.x,pToScreen.y,0)
	end
	
	local Time = CurTime()
	

	
	local Visible = VisibleTime > Time
	smVisible = smVisible + ((Visible and 1 or 0) - smVisible) * FrameTime() * 10
	
	local wobl = ((VisibleTime - 1.9 > Time) and  self:GetAmmoLaserCannon() > 0) and math.cos( Time * 300 ) * 6 or 0
	
	local vD = 5 + (5 + wobl)
	local vD2 = 10 + (10 + wobl)
	surface.SetDrawColor( Color(255,255,255,255) )
	surface.DrawLine( HitPlane.x + vD, HitPlane.y, HitPlane.x + vD2, HitPlane.y ) 
	surface.DrawLine( HitPlane.x - vD, HitPlane.y, HitPlane.x - vD2, HitPlane.y ) 
	surface.DrawLine( HitPlane.x, HitPlane.y + vD, HitPlane.x, HitPlane.y + vD2 ) 
	surface.DrawLine( HitPlane.x, HitPlane.y - vD, HitPlane.x, HitPlane.y - vD2 ) 
	
	local HitPlane = HitPlane + Vector(1,1,0)
	surface.SetDrawColor( Color(0,0,0,50) )
	surface.DrawLine( HitPlane.x + vD, HitPlane.y, HitPlane.x + vD2, HitPlane.y ) 
	surface.DrawLine( HitPlane.x - vD, HitPlane.y, HitPlane.x - vD2, HitPlane.y ) 
	surface.DrawLine( HitPlane.x, HitPlane.y + vD, HitPlane.x, HitPlane.y + vD2 ) 
	surface.DrawLine( HitPlane.x, HitPlane.y - vD, HitPlane.x, HitPlane.y - vD2 ) 
	

	
	if not UsingGunCam then return end
	
	local X = ScrW() * 0.5
	local Y = ScrH() * 0.5
	
	self.curZoom = self.curZoom or 90
	
	local Scale = (2.5 - self.curZoom / 70)
	
	local R = X * 0.2 * Scale
	
	surface.SetDrawColor( Color(255,255,255,50) )
	DrawCircle( X, Y, R * 0.8 )
	DrawCircle( X, Y, R )
	
	surface.SetDrawColor( Color(0,0,0,50) )
	DrawCircle( X + 1, Y + 1, R * 0.8 )
	DrawCircle( X + 1, Y + 1, R )
	
	for i = 3, 43 do
		surface.SetDrawColor( Color(255,255,255,100) )
		surface.DrawLine( X + R * 0.19 * i, Y + R * 0.05, X + R * 0.19 * i, Y - R * 0.05 )
		surface.DrawLine( X - R * 0.19 * i, Y + R * 0.05, X - R * 0.19 * i, Y - R * 0.05 )
		
		surface.SetDrawColor( Color(0,0,0,50) )
		surface.DrawLine( X + R * 0.19 * i + 1, Y + R * 0.05 + 1, X + R * 0.19 * i + 1, Y - R * 0.05 + 1 )
		surface.DrawLine( X - R * 0.19 * i + 1, Y + R * 0.05 + 1, X - R * 0.19 * i + 1, Y - R * 0.05 + 1 )
	end

	surface.SetDrawColor( Color(255,255,255,255) )
	surface.SetMaterial(zoom_mat ) 
	surface.DrawTexturedRectRotated( X + X * 0.5, Y * 0.5, X, Y, 0 )
	surface.DrawTexturedRectRotated( X + X * 0.5, Y + Y * 0.5, Y, X, 270 )
	surface.DrawTexturedRectRotated( X * 0.5, Y * 0.5, Y, X, 90 )
	surface.DrawTexturedRectRotated( X * 0.5, Y + Y * 0.5, X, Y, 180 )
end

function ENT:GunCamera( view, ply )
	if ply == self:GetGunner() then
		local Zoom = ply:KeyDown( IN_ATTACK2 )
		
		local zIn = ply:KeyDown( IN_FORWARD ) and 1 or 0
		local zOut = ply:KeyDown( IN_BACK ) and 1 or 0
		
		if self.oldZoom ~= Zoom then
			self.oldZoom = Zoom
			if Zoom then
				self.ToggledView = not self.ToggledView
			else
				self.curZoom = 100
			end
		end
		
		self.curZoom = self.curZoom and math.Clamp(self.curZoom + (zOut - zIn) * FrameTime() * 100,20,90) or 0
		
		if self.ToggledView then
			local ID = self:LookupAttachment( "muzzle" )
			local Attachment = self:GetAttachment( ID )

			if Attachment then
				view.origin = Attachment.Pos + Attachment.Ang:Up() * 15 + Attachment.Ang:Forward() * 5
			else
				view.origin = self:LocalToWorld( Vector(416.35,-0.02,10.69) )
			end
			
			view.fov = self.curZoom
		end
	end
	
	if self.oldToggledView ~= self.ToggledView then
		self.oldToggledView = self.ToggledView
		
		if self.ToggledView then
			surface.PlaySound("weapons/sniper/sniper_zoomin.wav")
		else
			surface.PlaySound("weapons/sniper/sniper_zoomout.wav")
		end
	end
	
	return view
end

function ENT:ExhaustFX()
end

function ENT:DamageFX()
	local HP = self:GetHP()
	if HP > self:GetMaxHP() * 0.5 then return end
	self:SetSkin( 1 )
	self.nextDFX = self.nextDFX or 0
	
	if self.nextDFX < CurTime() then
		self.nextDFX = CurTime() + 0.05
		
		for k,v in pairs( {Vector(-442.24,-188.61,104.02), Vector(-178.89,352.98,103.16), Vector(31.16,-293.36,87.94), Vector(355.46,-54.91,40.22), Vector(261.45,115.44,-28.97)  } ) do
			local effectdata = EffectData()
				effectdata:SetOrigin( self:LocalToWorld( v ) )
			util.Effect( "lfs_blacksmoke", effectdata )
		end
	end

end

function ENT:LFSCalcViewFirstPerson( view, ply )
	if ply == self:GetGunner() then  -- dont change view if the player is pilot or copilot
	
	local Pod = ply:GetVehicle()
	
	if not IsValid( Pod ) then return view end
	
	local radius = 1150
	
	local TargetOrigin = self:LocalToWorld( Vector(300,0,100) ) - view.angles:Forward() * radius  + view.angles:Up() * radius * 0.2
	local WallOffset = 4

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
	
	return self:GunCamera( view, ply )
end

	if ply == self:GetDriver() or ply == self:GetGunner() then return view end -- dont change view if the player is pilot or copilot
	
	local Pod = ply:GetVehicle()
	
	if not IsValid( Pod ) then return view end
	
	local radius = 1150
	
	local TargetOrigin = self:LocalToWorld( Vector(-100,0,50) ) - view.angles:Forward() * radius  + view.angles:Up() * radius * 0.2
	local WallOffset = 4

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


function ENT:LFSCalcViewThirdPerson( view, ply )
	local ply = LocalPlayer()
	if ply == self:GetDriver() then 
	
	local Pod = ply:GetVehicle()
	
	if not IsValid( Pod ) then return view end
	
	if ply == self:GetDriver() then
	local radius = 1150
		radius = radius + radius * Pod:GetCameraDistance()
		
		view.origin = self:LocalToWorld( Vector(0,0,230) )
		
		local TargetOrigin = view.origin - view.angles:Forward() * radius  + view.angles:Up() * 950 * 0.2
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

	if self:GetGunner() then 
	return self:LFSCalcViewFirstPerson( view, ply ) -- lets call the first person camera function so we dont have to do the same code twice. This will force the same view for both first and thirdperson
end
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
		self.ENG = CreateSound( self, "DGS_ENGINE" )
		self.ENG:PlayEx(0,0)
		
		self.DIST = CreateSound( self, "DGS_DIST" )
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

	local Size = 40

	render.SetMaterial( mat )
	render.DrawSprite( self:LocalToWorld( Vector(405,-25.51,-0.9) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(402.5,-30,1.2) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(400.07,-34.19,3.08) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(397.58,-38.77,5.5) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(395.01,-43.68,7.81) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(392.09,-48.93,9.97) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(388.73,-53.49,12.44) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(385.83,-57.99,14.02) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(405,-25.51,-0.9) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(402.5,-30,1.2) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(400.07,-34.19,3.08) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(397.58,-38.77,5.5) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(395.01,-43.68,7.81) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(392.09,-48.93,9.97) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(388.73,-53.49,12.44) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(385.83,-57.99,14.02) ), Size, Size, Color( 255, 0, 0, 255) )
--
--
	render.DrawSprite( self:LocalToWorld( Vector(405,25.51,-0.9) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(402.5,30,1.2) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(400.07,34.19,3.08) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(397.58,38.77,5.5) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(395.01,43.68,7.81) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(392.09,48.93,9.97) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(388.73,53.49,12.44) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(385.83,57.99,14.02) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(405,25.51,-0.9) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(402.5,30,1.2) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(400.07,34.19,3.08) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(397.58,38.77,5.5) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(395.01,43.68,7.81) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(392.09,48.93,9.97) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(388.73,53.49,12.44) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(385.83,57.99,14.02) ), Size, Size, Color( 255, 0, 0, 255) )
--
--
end	
	
	if self:GetEngineActive() then

	local Size = 80	

	render.DrawSprite( self:LocalToWorld( Vector(-474.76,271.06,64.33) ), Size, Size, Color( 255, 180, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-478.92,265.74,64.86) ), Size, Size, Color( 255, 180, 0, 255) )		
	render.DrawSprite( self:LocalToWorld( Vector(-484,258.11,65.69) ), Size, Size, Color( 255, 180, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-487.86,251.62,65.75) ), Size, Size, Color( 255, 180, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-493.37,244.7,65.85) ), Size, Size, Color( 255, 180, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-498.56,237.34,65.83) ), Size, Size, Color( 255, 180, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-503.64,230.24,65.74) ), Size, Size, Color( 255, 180, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-508.52,223.21,65.85) ), Size, Size, Color( 255, 180, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-513.48,215.7,65.67) ), Size, Size, Color( 255, 180, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-517.98,209.33,65.78) ), Size, Size, Color( 255, 180, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-522.12,201.68,65.72) ), Size, Size, Color( 255, 180, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-526.11,193.46,65.74) ), Size, Size, Color( 255, 180, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-529.97,185.66,65.92) ), Size, Size, Color( 255, 180, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-533.68,177.81,65.87) ), Size, Size, Color( 255, 180, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-537.78,169.72,65.86) ), Size, Size, Color( 255, 180, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-541.09,162.98,65.63) ), Size, Size, Color( 255, 180, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-544.36,147.39,65.43) ), Size, Size, Color( 255, 180, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-545.29,155,65.78) ), Size, Size, Color( 255, 180, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-548.17,146.37,65.89) ), Size, Size, Color( 255, 180, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-550.91,137.63,65.96) ), Size, Size, Color( 255, 180, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-553.28,130.16,65.98) ), Size, Size, Color( 255, 180, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-555.62,122.02,66.19) ), Size, Size, Color( 255, 180, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-558.17,113.93,66.57) ), Size, Size, Color( 255, 180, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-560.77,105.25,66.32) ), Size, Size, Color( 255, 180, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-562.87,97.91,66.61 ) ), Size, Size, Color( 255, 180, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-564.38,89.59,66.9) ), Size, Size, Color( 255, 180, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-566.16,81.21,67.07) ), Size, Size, Color( 255, 180, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-567.9,71.68,66.98) ), Size, Size, Color( 255, 180, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-569.93,62.86,66.86) ), Size, Size, Color( 255, 180, 0, 255) )	


	render.DrawSprite( self:LocalToWorld( Vector(-474.76,-271.06,64.33) ), Size, Size, Color( 255, 180, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-478.92,-265.74,64.86) ), Size, Size, Color( 255, 180, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-484,-258.11,65.69) ), Size, Size, Color( 255, 180, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-487.86,-251.62,65.75) ), Size, Size, Color( 255, 180, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-493.37,-244.7,65.85) ), Size, Size, Color( 255, 180, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-498.56,-237.34,65.83) ), Size, Size, Color( 255, 180, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-503.64,-230.24,65.74) ), Size, Size, Color( 255, 180, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-508.52,-223.21,65.85) ), Size, Size, Color( 255, 180, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-513.48,-215.7,65.67) ), Size, Size, Color( 255, 180, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-517.98,-209.33,65.78) ), Size, Size, Color( 255, 180, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-522.12,-201.68,65.72) ), Size, Size, Color( 255, 180, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-526.11,-193.46,65.74) ), Size, Size, Color( 255, 180, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-529.97,-185.66,65.92) ), Size, Size, Color( 255, 180, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-533.68,-177.81,65.87) ), Size, Size, Color( 255, 180, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-537.78,-169.72,65.86) ), Size, Size, Color( 255, 180, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-541.09,-162.98,65.63) ), Size, Size, Color( 255, 180, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-544.36,-147.39,65.43) ), Size, Size, Color( 255, 180, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-545.29,-155,65.78) ), Size, Size, Color( 255, 180, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-548.17,-146.37,65.89) ), Size, Size, Color( 255, 180, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-550.91,-137.63,65.96) ), Size, Size, Color( 255, 180, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-553.28,-130.16,65.98) ), Size, Size, Color( 255, 180, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-555.62,-122.02,66.19) ), Size, Size, Color( 255, 180, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-558.17,-113.93,66.57) ), Size, Size, Color( 255, 180, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-560.77,-105.25,66.32) ), Size, Size, Color( 255, 180, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-562.87,-97.91,66.61 ) ), Size, Size, Color( 255, 180, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-564.38,-89.59,66.9) ), Size, Size, Color( 255, 180, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-566.16,-81.21,67.07) ), Size, Size, Color( 255, 180, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-567.9,-71.68,66.98) ), Size, Size, Color( 255, 180, 0, 255) )	
	render.DrawSprite( self:LocalToWorld( Vector(-569.93,-62.86,66.86) ), Size, Size, Color( 255, 180, 0, 255) )	




	end
end

