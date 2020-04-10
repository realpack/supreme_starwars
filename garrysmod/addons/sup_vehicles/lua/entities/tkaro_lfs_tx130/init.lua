AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:PrimaryAttack()
	if self:GetIsCarried() then return end
	if not self:CanPrimaryAttack() or not self.MainGunDir then return end

	local ID1 = self:LookupAttachment( "muzzle_left" )
	local ID2 = self:LookupAttachment( "muzzle_right" )

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
	
	self:EmitSound( "TX_FIRE" )

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
	bullet.TracerName	= "lfs_laser_blue"
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
	
	self:PlayAnimation( "fire_gun" )
	self:TakePrimaryAmmo()
end

function ENT:SecondaryAttack()
	if self:GetIsCarried() then return end
	if not self:CanAltSecondaryAttack() or not self.MainGunDir then return end
	if self:GetLGear() > 0.01 then return end

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
	
	self:EmitSound( "TX_ROCKET" )

	local Pos = FirePos[self.FireIndex].Pos
	local Dir =  FirePos[self.FireIndex].Ang:Up()
	
	if math.deg( math.acos( math.Clamp( Dir:Dot( self.MainGunDir ) ,-1,1) ) ) < 8 then
		Dir = self.MainGunDir
	end
	
	local ent = ents.Create( "lunasflightschool_droidgunship_missile" )
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

function ENT:OnKeyThrottle( bPressed )
	if bPressed then
	self.SMLG = self.SMLG and self.SMLG + (9 *  self:GetLGear() - self.SMLG) * FrameTime() * 0 or 0
	
	local Ang = 9 - self.SMLG
	self:ManipulateBoneAngles( 1, Angle(0,-Ang,0) )
	self:ManipulateBoneAngles( 9, Angle(0,Ang,0) )
	end
	
	if not bPressed then
	self.SMLG = self.SMLG and self.SMLG + (0 *  self:GetLGear() - self.SMLG) * FrameTime() * 0 or 0
	
	local Ang = 0 - self.SMLG
	self:ManipulateBoneAngles( 1, Angle(0,Ang,0) )
	self:ManipulateBoneAngles( 9, Angle(0,Ang,0) )
	end
end

function ENT:OnLandingGearToggled( bOn )
	self:EmitSound( "TX_ROCKETPODS" )
end

function ENT:OnEngineStarted()
	self:EmitSound( "lfs/tx130/engine_start.wav" )
	self.HeightOffset = 27
end

function ENT:OnEngineStopped()
	self:EmitSound( "lfs/tx130/engine_stop.wav" )
	self.HeightOffset = 7
end