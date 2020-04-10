AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:PrimaryAttack()
	if self:GetIsCarried() then return end
	if not self:CanPrimaryAttack() or not self.MainGunDir then return end

	local ID1 = self:LookupAttachment( "front_right_muzzle" )
	local ID2 = self:LookupAttachment( "front_left_muzzle" )
	local ID3 = self:LookupAttachment( "back_right_muzzle" )
	local ID4 = self:LookupAttachment( "back_left_muzzle" )
	
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
	
	if self.FireIndex > 2 then
		self.FireIndex = 1
		self:SetNextPrimary( 0.2 )
	else
		if self.FireIndex == 2 then
			self:SetNextPrimary( 0.5 )
		else
			self:SetNextPrimary( 0.2 )
		end
	end
	
	self:EmitSound( "GALACTICA_BARC_FIRE" )

	local Pos1 = FirePos[self.FireIndex*2-1].Pos
	local Dir1 =  FirePos[self.FireIndex*2-1].Ang:Up()
	
	local Pos2 = FirePos[self.FireIndex*2].Pos
	local Dir2 =  FirePos[self.FireIndex*2].Ang:Up()
	
	--[[if math.deg( math.acos( math.Clamp( Dir1:Dot( self.MainGunDir ) ,-1,1) ) ) < 8 then
		Dir1 = self.MainGunDir
	end
	
	if math.deg( math.acos( math.Clamp( Dir2:Dot( self.MainGunDir ) ,-1,1) ) ) < 8 then
		Dir2 = self.MainGunDir
	end]]--
	
	local bullet = {}
	bullet.Num 	= 1
	bullet.Src 	= Pos1
	bullet.Dir 	= Dir1
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
	
	local bullet = {}
	bullet.Num 	= 1
	bullet.Src 	= Pos2
	bullet.Dir 	= Dir2
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
	
	self:TakePrimaryAmmo()
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
	
	local AimAngles = self:WorldToLocalAngles( (TracePlane.HitPos - self:LocalToWorld( Vector(0,0,21.5)) ):GetNormalized():Angle() )

	local ID = self:LookupAttachment( "front_right_muzzle" )
	local Muzzle = self:GetAttachment( ID )
	
	if Muzzle then
		self:SetFrontInRange( math.deg( math.acos( math.Clamp( Muzzle.Ang:Up():Dot( self.MainGunDir ) ,-1,1) ) ) < 1 )
	end
end

function ENT:OnEngineStarted()
	self:EmitSound( "lfs/naboo_n1_starfighter/start.wav" )
	self.HeightOffset = 15
end

function ENT:OnEngineStopped()
	self:EmitSound( "lfs/naboo_n1_starfighter/stop.wav" )
	self.HeightOffset = -15
end