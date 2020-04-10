AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:RunOnSpawn()
	local TurretSeat = self:AddPassengerSeat( Vector(-5,15,50), Angle(0,-90,0) )
	self:SetTurretSeat( TurretSeat )
	self:AddPassengerSeat( Vector(0,50,33), Angle(0,0,0) )
	self:AddPassengerSeat( Vector(-25,50,33), Angle(0,0,0) )
	self:AddPassengerSeat( Vector(-55,50,33), Angle(0,0,0) )
	self:AddPassengerSeat( Vector(-85,50,33), Angle(0,0,0) )
	self:AddPassengerSeat( Vector(0,-50,33), Angle(0,180,0) )
	self:AddPassengerSeat( Vector(-25,-50,33), Angle(0,180,0) )
	self:AddPassengerSeat( Vector(-55,-50,33), Angle(0,180,0) )
	self:AddPassengerSeat( Vector(-85,-50,33), Angle(0,180,0) )
end

function ENT:PrimaryAttack()
	if self:GetIsCarried() then return end
	if not self:CanPrimaryAttack() or not self.MainGunDir then return end

	local ID1 = self:LookupAttachment( "muzzle_r_front" )
	local ID2 = self:LookupAttachment( "muzzle_l_front" )

	local Muzzle1 = self:GetAttachment( ID1 )
	local Muzzle2 = self:GetAttachment( ID2 )
	
	if not Muzzle1 or not Muzzle2 then return end
	
	local FirePos = {
		[1] = Muzzle1,
		[2] = Muzzle2,
	}
	
	self.FireIndex = self.FireIndex and self.FireIndex + 1 or 1
	
	if self.FireIndex > 2 then
		self.FireIndex = 1
		self:SetNextPrimary( 0 )
	else
		if self.FireIndex == 2 then
			self:SetNextPrimary( 0.5 )
		else
			self:SetNextPrimary( 0 )
		end
	end
	
	self:EmitSound( "TX225_FIRE1" )
	
	local Pos = FirePos[self.FireIndex].Pos
	local Dir =  FirePos[self.FireIndex].Ang:Up()
	
		if math.deg( math.acos( math.Clamp( Dir:Dot( self.MainGunDir ) ,-1,1) ) ) < 8 then
	end
	
	
	local bullet = {}
	bullet.Num 	= 1
	bullet.Src 	= Pos
	bullet.Dir 	= Dir
	bullet.Spread 	= Vector( 0.01,  0.01, 0 )
	bullet.Tracer	= 1
	bullet.TracerName	= "lfs_laser_blue"
	bullet.Force	= 100
	bullet.HullSize 	= 22
	bullet.Damage	= 40
	bullet.Attacker 	= self:GetDriver()
	bullet.AmmoType = "Pistol"
	bullet.Callback = function(att, tr, dmginfo)
		if tr.Entity.IsSimfphyscar then
			dmginfo:SetDamageType(DMG_DIRECT)
		else
			dmginfo:SetDamageType(DMG_AIRBOAT)
		end
	end
	self:FireBullets( bullet )
	
	self:TakePrimaryAmmo()
end

function ENT:SecondaryAttack()
end

function ENT:MainGunPoser( EyeAngles )
	
	self.MainGunDir = EyeAngles:Forward()
	
	local startpos = self:GetRotorPos()
	local TracePlane = util.TraceHull( {
		start = startpos,
		endpos = (startpos + self.MainGunDir * 50000),
		mins = Vector( -10, -10, -10 ),
		maxs = Vector( 10, 10, 10 ),
		filter = {self}
	} )
	
	local AimAngles = self:WorldToLocalAngles( (TracePlane.HitPos - self:LocalToWorld( Vector(11.962392,0,115.135384)) ):GetNormalized():Angle() )

	local ID = self:LookupAttachment( "muzzle_r_front" )
	local Muzzle = self:GetAttachment( ID )
	
	if Muzzle then
		self:SetFrontInRange( math.deg( math.acos( math.Clamp( Muzzle.Ang:Up():Dot( self.MainGunDir ) ,-1,1) ) ) < 15 )
	end
end

function ENT:Turret( Driver, Pod )
	if not IsValid( Pod ) or not IsValid( Driver ) then 
	self:SetBodygroup( 3, 0 )
		return
	end
	
	local EyeAngles = Pod:WorldToLocalAngles( Driver:EyeAngles() )
	
	local AimDir = EyeAngles:Forward()
	
	local KeyAttack = Driver:KeyDown( IN_ATTACK )
	
	local TurretPos = self:LocalToWorld( Vector(-130.360611,0,111.885109) )
	
	local startpos = TurretPos + EyeAngles:Up() * 100
	local TracePlane = util.TraceLine( {
		start = startpos,
		endpos = (startpos + AimDir * 50000),
		filter = {self}
	} )

	local Pos,Ang = WorldToLocal( Vector(0,0,0), (TracePlane.HitPos - TurretPos ):GetNormalized():Angle(), Vector(0,0,0),self:GetAngles() )
	
	local AimRate = 100 * FrameTime() 
	
	self.sm_ppmg_pitch = self.sm_ppmg_pitch and math.ApproachAngle( self.sm_ppmg_pitch, Ang.p, AimRate ) or 0
	self.sm_ppmg_yaw = self.sm_ppmg_yaw and math.ApproachAngle( self.sm_ppmg_yaw, Ang.y, AimRate ) or 0
	
	local TargetAng = Angle(self.sm_ppmg_pitch,self.sm_ppmg_yaw,0)
	TargetAng:Normalize() 
	
	self:SetPoseParameter("sidegun_pitch", TargetAng.p )
	
	if KeyAttack then
		self:FireTurret( Driver )
	end
	self:SetBodygroup( 3, 1 )
end

function ENT:FireTurret()
	if not self:CanSecondaryAttack() then return end
	
	self:SetNextSecondary( 1 )
	
	
	local ID1 = self:LookupAttachment( "muzzle_top_right" )
	local ID2 = self:LookupAttachment( "muzzle_top_left" )
	local ID3 = self:LookupAttachment( "muzzle_bottom_right" )
	local ID4 = self:LookupAttachment( "muzzle_bottom_left" )

	local Muzzle1 = self:GetAttachment( ID1 )
	local Muzzle2 = self:GetAttachment( ID2 )
	local Muzzle3 = self:GetAttachment( ID3 )
	local Muzzle4 = self:GetAttachment( ID4 )
	
	if not Muzzle1 or not Muzzle2 or not Muzzle3 or not Muzzle4 then return end
	
	local FirePos = {
		[1] = Muzzle1,
		[2] = Muzzle2,
		[3] = Muzzle3,
		[4] = Muzzle4,
	}
	
	self.FireIndex = self.FireIndex and self.FireIndex + 1 or 2
	
	if self.FireIndex > 4 then
		self.FireIndex = 1
		self:SetNextPrimary( 0.5 )
	else
		if self.FireIndex == 3 then
			self:SetNextPrimary( 0.2 )
		else
			self:SetNextPrimary( 0.08 )
		end
	end
	
	self:EmitSound( "TX225_FIRE2" )

	local Pos = FirePos[self.FireIndex].Pos
	local Dir =  FirePos[self.FireIndex].Ang:Up()
	
		if math.deg( math.acos( math.Clamp( Dir:Dot( self.MainGunDir ) ,-1,1) ) ) < 1 then
		Dir = self.MainGunDir
	end

		local bullet = {}
		bullet.Num 	= 1
		bullet.Src 	= Pos
		bullet.Dir 	= Dir
		bullet.Spread 	= Vector( 0.01,  0.01, 0 )
		bullet.Tracer	= 1
		bullet.TracerName	= "lfs_laser_blue"
		bullet.Force	= 100
		bullet.HullSize 	= 10
		bullet.Damage	= 100
		bullet.Attacker 	= self:GetDriver()
		bullet.AmmoType = "Pistol"
		bullet.Callback = function(att, tr, dmginfo)
			if tr.Entity.IsSimfphyscar then
				dmginfo:SetDamageType(DMG_DIRECT)
			else
				dmginfo:SetDamageType(DMG_AIRBOAT)
			end
		end
		self:FireBullets( bullet )
		
		self:TakePrimaryAmmo()
end

function ENT:OnEngineStarted()
	self:EmitSound( "lfs/naboo_n1_starfighter/start.wav" )
	self.HeightOffset = 15
end

function ENT:OnEngineStopped()
	self:EmitSound( "lfs/naboo_n1_starfighter/stop.wav" )
	self.HeightOffset = 7
end