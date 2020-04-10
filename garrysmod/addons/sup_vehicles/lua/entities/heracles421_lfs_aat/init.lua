AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:RunOnSpawn()
	--[[local TurretSeat = self:AddPassengerSeat( Vector(150,0,150), Angle(0,-90,0) )
	
	local ID = self:LookupAttachment( "driver_turret" )
	local TSAttachment = self:GetAttachment( ID )
	
	if TSAttachment then
		local Pos,Ang = LocalToWorld( Vector(0,-5,8), Angle(180,0,-55), TSAttachment.Pos, TSAttachment.Ang )
		
		TurretSeat:SetParent( NULL )
		TurretSeat:SetPos( Pos )
		TurretSeat:SetAngles( Ang )
		TurretSeat:SetParent( self, ID )
		self:SetTurretSeat( TurretSeat )
	end]]--

	local TurretSeat = self:AddPassengerSeat( Vector(-130,0,120), Angle(0,-90,0) )
	self:SetTurretSeat( TurretSeat )
end

function ENT:PrimaryAttack()
	if self:GetIsCarried() then return end
	if not self:CanPrimaryAttack() or not self.MainGunDir then return end

	local ID1 = self:LookupAttachment( "muzzle_left" )
	local ID2 = self:LookupAttachment( "muzzle_right" )
	local ID3 = self:LookupAttachment( "muzzle_fixed_left" )
	local ID4 = self:LookupAttachment( "muzzle_fixed_right" )

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
	
	self.FireIndex = self.FireIndex and self.FireIndex + 1 or 1
	
	if self.FireIndex > 4 then
		self.FireIndex = 1
		self:SetNextPrimary( 0.2 )
	else
		if self.FireIndex == 4 then
			self:SetNextPrimary( 0.5 )
		else
			self:SetNextPrimary( 0.2 )
		end
	end
	
	self:EmitSound( "GALACTICA_AAT_FIRE" )

	local Pos = FirePos[self.FireIndex].Pos
	local Dir =  FirePos[self.FireIndex].Ang:Up()
	
	if math.deg( math.acos( math.Clamp( Dir:Dot( self.MainGunDir ) ,-1,1) ) ) < 8 then
		Dir = self.MainGunDir
	end
	
	local bullet = {}
	bullet.Num 	= 1
	bullet.Src 	= Pos
	bullet.Dir 	= Dir
	bullet.Spread 	= Vector( 0.01,  0.01, 0 )
	bullet.Tracer	= 1
	bullet.TracerName	= "lfs_laser_red"
	bullet.Force	= 100
	bullet.HullSize 	= 22
	bullet.Damage	= 150
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
	if self:GetIsCarried() then return end
	if not self:CanAltSecondaryAttack() or not self.MainGunDir then return end

	local ID1 = self:LookupAttachment( "left_launch_tube_1" )
	local ID2 = self:LookupAttachment( "right_launch_tube_1" )
	local ID3 = self:LookupAttachment( "left_launch_tube_2" )
	local ID4 = self:LookupAttachment( "right_launch_tube_2" )
	local ID5 = self:LookupAttachment( "left_launch_tube_3" )
	local ID6 = self:LookupAttachment( "right_launch_tube_3" )

	local Muzzle1 = self:GetAttachment( ID1 )
	local Muzzle2 = self:GetAttachment( ID2 )
	local Muzzle3 = self:GetAttachment( ID3 )
	local Muzzle4 = self:GetAttachment( ID4 )
	local Muzzle5 = self:GetAttachment( ID5 )
	local Muzzle6 = self:GetAttachment( ID6 )
	
	if not Muzzle1 or not Muzzle2 then return end
	
	local FirePos = {
		[1] = Muzzle1,
		[2] = Muzzle2,
		[3] = Muzzle3,
		[4] = Muzzle4,
		[5] = Muzzle5,
		[6] = Muzzle6,
	}
	
	self.FireIndex = self.FireIndex and self.FireIndex + 1 or 1
	
	if self.FireIndex > 6 then
		self.FireIndex = 1
		self:SetNextAltSecondary( 1 )
	else
		if self.FireIndex == 6 then
			self:SetNextAltSecondary( 3 )
		else
			self:SetNextAltSecondary( 1 )
		end
	end
	
	self:EmitSound( "GALACTICA_AAT_TORPEDOFIRE" )

	local Pos = FirePos[self.FireIndex].Pos
	local Dir =  FirePos[self.FireIndex].Ang:Up()
	
	if math.deg( math.acos( math.Clamp( Dir:Dot( self.MainGunDir ) ,-1,1) ) ) < 8 then
		Dir = self.MainGunDir
	end
	
	local ent = ents.Create( "lunasflightschool_missile" )
	ent:SetPos( Pos )
	ent:SetAngles( Dir:Angle() )
	ent:Spawn()
	ent:Activate()
	ent:SetAttacker( self:GetTurretDriver() )
	ent:SetInflictor( self )
	ent:SetStartVelocity( 10000 )
	ent:SetCleanMissile( true )
	
	constraint.NoCollide( ent, self, 0, 0 )
	
	self:TakeSecondaryAmmo()
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
	
	self:SetPoseParameter("sidegun_pitch", AimAngles.p )

	local ID = self:LookupAttachment( "muzzle_left" )
	local Muzzle = self:GetAttachment( ID )
	
	if Muzzle then
		self:SetFrontInRange( math.deg( math.acos( math.Clamp( Muzzle.Ang:Up():Dot( self.MainGunDir ) ,-1,1) ) ) < 15 )
	end
end

function ENT:Turret( Driver, Pod )
	if not IsValid( Pod ) or not IsValid( Driver ) then 
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
	
	self:SetPoseParameter("cannon_pitch", TargetAng.p )
	self:SetPoseParameter("cannon_yaw", TargetAng.y )
	
	if KeyAttack then
		self:FireTurret( Driver )
	end
	
	if (self.cFireIndex or 0) > 0 and Driver:KeyDown( IN_RELOAD ) then
		self.cFireIndex = 0
		self:SetNextSecondary( 2 )
		Pod:EmitSound("GALACTICA_AAT_CANNONRELOAD")
	end
end

function ENT:FireTurret()
	if not self:CanSecondaryAttack() then return end
	
	self:SetNextSecondary( 0.5 )
	
	self.cFireIndex = self.cFireIndex and self.cFireIndex + 1 or 1
	if self.cFireIndex >= 3 then
		self.cFireIndex = 0
		self:SetNextSecondary( 2 )
		timer.Simple(0.2, function()
			if not IsValid( self ) then return end
			
			local Pod = self:GetTurretSeat()
			if not IsValid( Pod ) then return end
			
			Pod:EmitSound("GALACTICA_AAT_CANNONRELOAD")
		end )
	end
	
	self:EmitSound( "GALACTICA_AAT_CANNONFIRE" )
	
	local ID = self:LookupAttachment( "muzzle_cannon" )
	local Muzzle = self:GetAttachment( ID )

	if Muzzle then
		--[[local ent = ents.Create( "lunasflightschool_missile" )
		ent:SetPos( Muzzle.Pos )
		ent:SetAngles( Muzzle.Ang:Up():Angle() )
		ent:Spawn()
		ent:Activate()
		ent:SetAttacker( self:GetTurretDriver() )
		ent:SetInflictor( self )
		ent:SetStartVelocity( 10000 )
		ent:SetCleanMissile( true )
		
		constraint.NoCollide( ent, self, 0, 0 )
		
		self:TakeSecondaryAmmo()]]
		
		local bullet = {}
		bullet.Num 	= 1
		bullet.Src 	= Muzzle.Pos
		bullet.Dir 	= Muzzle.Ang:Up()
		bullet.Spread 	= Vector( 0.01,  0.01, 0 )
		bullet.Tracer	= 1
		bullet.TracerName	= "lfs_laser_red"
		bullet.Force	= 100
		bullet.HullSize 	= 40
		bullet.Damage	= 500
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
		self:PlayAnimation( "fire_turret" )
	end
end

function ENT:OnEngineStarted()
	self:EmitSound( "lfs/naboo_n1_starfighter/start.wav" )
	self.HeightOffset = 8
end

function ENT:OnEngineStopped()
	self:EmitSound( "lfs/naboo_n1_starfighter/stop.wav" )
	self.HeightOffset = -10
end