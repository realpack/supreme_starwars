--DO NOT EDIT OR REUPLOAD THIS FILE

AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:SpawnFunction( ply, tr, ClassName )

	if not tr.Hit then return end

	local ent = ents.Create( ClassName )
	ent.dOwnerEntLFS = ply
	ent:SetPos( tr.HitPos + tr.HitNormal * 30 )
	ent:Spawn()
	ent:Activate()

	return ent

end


function ENT:RunOnSpawn()
	self:SetGunnerSeat( self:AddPassengerSeat( Vector(650,0,250), Angle(0,-90,0) ) )
	self:AddPassengerSeat( Vector(170,30,150), Angle(0,-90,0) )
	self:AddPassengerSeat( Vector(200,30,150), Angle(0,-90,0) )
	self:AddPassengerSeat( Vector(140,-30,150), Angle(0,-90,0) )
	self:AddPassengerSeat( Vector(170,-30,150), Angle(0,-90,0) )
	self:AddPassengerSeat( Vector(200,-30,150), Angle(0,-90,0) )
end

function ENT:SetNextAltSecondary( delay )
	self.NextAltSecondary = CurTime() + delay
end

function ENT:CanAltSecondaryAttack()
	self.NextAltSecondary = self.NextAltSecondary or 0
	return self.NextAltSecondary < CurTime()
end

function ENT:PrimaryAttack ()
	if not self:CanPrimaryAttack() then return end
	
	if not IsValid( Pod ) then Pod = self:GetDriverSeat() end
	if not IsValid( Driver ) then Driver = Pod:GetDriver() end
	
	if not IsValid( Pod ) then return end
	if not IsValid( Driver ) then return end
	
	local EyeAngles = Pod:WorldToLocalAngles( Driver:EyeAngles() )
	local Forward = self:GetForward()
	
	local AimDirToForwardDir = math.deg( math.acos( math.Clamp( Forward:Dot( EyeAngles:Forward() ) ,-1,1) ) )
	if AimDirToForwardDir > 15 then return end

	self:EmitSound( "CR90_FIRE" )
	
	self:SetNextPrimary( 0.35 )
	
	local startpos =  self:GetRotorPos()
	local TracePlane = util.TraceHull( {
		start = startpos,
		endpos = (startpos + EyeAngles:Forward() * 50000),
		mins = Vector( -10, -10, -10 ),
		maxs = Vector( 10, 10, 10 ),
		filter = self
	} )
	for i = 0,1 do
		self.MirrorPrimary = not self.MirrorPrimary
		
		local Mirror = self.MirrorPrimary and -1 or 1
		local bullet = {}
		bullet.Num 	= 1
		bullet.Src 	= self:LocalToWorld( Vector(-25,285 * Mirror,270) )
		bullet.Dir 	= (TracePlane.HitPos - bullet.Src):GetNormalized()
		bullet.Spread 	= Vector( 0.01,  0.01, 0 )
		bullet.Tracer	= 1
		bullet.TracerName	= "lfs_laser_red_large"
		bullet.Force	= 100
		bullet.HullSize 	= 25
		bullet.Damage	= 60
		bullet.Attacker 	= self:GetDriver()
		bullet.AmmoType = "Pistol"
		bullet.Callback = function(att, tr, dmginfo)
			dmginfo:SetDamageType(DMG_AIRBOAT)
		end
		self:FireBullets( bullet )
		
		self:TakePrimaryAmmo()
	end
end 

function ENT:PrimaryAttack2 ()
	if not self:CanPrimaryAttack() then return end

	self:EmitSound( "CR90_FIRE" )
	
	self:SetNextPrimary( 0.35 )
	
	local startpos =  self:GetRotorPos()
	local TracePlane = util.TraceHull( {
		start = startpos,
		endpos = (startpos + self:GetForward() * 50000),
		mins = Vector( -10, -10, -10 ),
		maxs = Vector( 10, 10, 10 ),
		filter = self
	} )
	for i = 0,1 do
		self.MirrorPrimary = not self.MirrorPrimary
		
		local Mirror = self.MirrorPrimary and -1 or 1
		local bullet = {}
		bullet.Num 	= 1
		bullet.Src 	= self:LocalToWorld( Vector(-25,285 * Mirror,270) )
		bullet.Dir 	= (TracePlane.HitPos - bullet.Src):GetNormalized()
		bullet.Spread 	= Vector( 0.01,  0.01, 0 )
		bullet.Tracer	= 1
		bullet.TracerName	= "lfs_laser_red_large"
		bullet.Force	= 100
		bullet.HullSize 	= 25
		bullet.Damage	= 60
		bullet.Attacker 	= self:GetDriver()
		bullet.AmmoType = "Pistol"
		bullet.Callback = function(att, tr, dmginfo)
			dmginfo:SetDamageType(DMG_AIRBOAT)
		end
		self:FireBullets( bullet )
		
		self:TakePrimaryAmmo()
	end
end

function ENT:SecondaryAttack( Driver, Pod )	
	if not self:CanSecondaryAttack() then return end
	
	if not IsValid( Pod ) then Pod = self:GetDriverSeat() end
	if not IsValid( Driver ) then Driver = Pod:GetDriver() end
	
	if not IsValid( Pod ) then return end
	if not IsValid( Driver ) then return end
	
	local EyeAngles = Pod:WorldToLocalAngles( Driver:EyeAngles() )
	local Forward = self:GetForward()
	
	local AimDirToForwardDir = math.deg( math.acos( math.Clamp( Forward:Dot( EyeAngles:Forward() ) ,-1,1) ) )
	
	self:EmitSound( "CR90_FIRE2" )
	
	self:SetNextSecondary( 0.3 )
	
	local startpos =  self:GetRotorPos()
	local TracePlane = util.TraceHull( {
		start = startpos,
		endpos = (startpos + EyeAngles:Forward() * 50000),
		mins = Vector( -10, -10, -10 ),
		maxs = Vector( 10, 10, 10 ),
		filter = self
	} )
	
	local fP = { Vector(920,30,460), Vector(920,30,40), Vector(920,-30,40), Vector(920,-30,460), }

	self.NumPrim = self.NumPrim and self.NumPrim + 1 or 1
	if self.NumPrim > 4 then self.NumPrim = 1 end
	
	local MuzzlePos = self:LocalToWorld( fP[self.NumPrim] )

	local bullet = {}
	bullet.Num 	= 1
	bullet.Src 	= MuzzlePos
	bullet.Dir 	= (TracePlane.HitPos - bullet.Src):GetNormalized()
	bullet.Spread 	= Vector( 0.04,  0.04, 0 )
	bullet.Tracer	= 1
	bullet.TracerName	= "lfs_laser_red_large"
	bullet.Force	= 300
	bullet.HullSize 	= 80
	bullet.Damage	= 120
	bullet.Attacker 	= Driver
	bullet.AmmoType = "Pistol"
	bullet.Callback = function(att, tr, dmginfo)
		dmginfo:SetDamageType(DMG_AIRBOAT)
	end
	self:FireBullets( bullet )
end

function ENT:AltSecondaryAttack( Driver, Pod )	
	if not self:CanAltSecondaryAttack() then return end
	
	if not IsValid( Pod ) then Pod = self:GetDriverSeat() end
	if not IsValid( Driver ) then Driver = Pod:GetDriver() end
	
	if not IsValid( Pod ) then return end
	if not IsValid( Driver ) then return end
	
	local EyeAngles = Pod:WorldToLocalAngles( Driver:EyeAngles() )
	local Forward = self:GetForward()
	
	local AimDirToForwardDir = math.deg( math.acos( math.Clamp( Forward:Dot( EyeAngles:Forward() ) ,-1,1) ) )
	
	self:EmitSound( "CR90_FIRE" )
	
	self:SetNextAltSecondary( 0.1 )
	
	local startpos =  self:GetRotorPos()
	local TracePlane = util.TraceHull( {
		start = startpos,
		endpos = (startpos + EyeAngles:Forward() * 50000),
		mins = Vector( -10, -10, -10 ),
		maxs = Vector( 10, 10, 10 ),
		filter = self
	} )
	
	local fP = { Vector(420,0,340), Vector(600,0,340), }

	self.NumPrim = self.NumPrim and self.NumPrim + 1 or 1
	if self.NumPrim > 2 then self.NumPrim = 1 end
	
	local MuzzlePos = self:LocalToWorld( fP[self.NumPrim] )

	local bullet = {}
	bullet.Num 	= 1
	bullet.Src 	= MuzzlePos
	bullet.Dir 	= (TracePlane.HitPos - bullet.Src):GetNormalized()
	bullet.Spread 	= Vector( 0.0,  0.0, 0 )
	bullet.Tracer	= 1
	bullet.TracerName	= "lfs_laser_red"
	bullet.Force	= 300
	bullet.HullSize 	= 80
	bullet.Damage	= 40
	bullet.Attacker 	= Driver
	bullet.AmmoType = "Pistol"
	bullet.Callback = function(att, tr, dmginfo)
		dmginfo:SetDamageType(DMG_AIRBOAT)
	end
	self:FireBullets( bullet )
end

function ENT:OnKeyThrottle( bPressed )
	if bPressed then
		if self:CanSound() then
			self:EmitSound( "CONSULAR_BOOST" )
			self:DelayNextSound( 1 )
		end
	else
		if (self:GetRPM() + 1) > self:GetMaxRPM() then
			if self:CanSound() then
				self:EmitSound( "CONSULAR_BRAKE" )
				self:DelayNextSound( 0.5 )
			end
		end
	end
end

function ENT:CreateAI()
end

function ENT:RemoveAI()
end

function ENT:ToggleLandingGear()
end

function ENT:RaiseLandingGear()
end

function ENT:HandleWeapons(Fire1, Fire2)
	local Driver = self:GetDriver()
	local Gunner = self:GetGunner()
	
	local HasGunner = IsValid( Gunner )
	
	local FireTurret = false
	
	if IsValid( Driver ) then
		Fire1 = Driver:KeyDown( IN_ATTACK )
	end
	
	if Fire1 then
		if FireTurret and not HasGunner then
			self:SecondaryAttack()
		else
			self:PrimaryAttack()
			self:PrimaryAttack2()
		end
	end
	
	if HasGunner then
		if Gunner:KeyDown( IN_ATTACK ) then
			self:SecondaryAttack( Gunner, self:GetGunnerSeat() )
		end
		if Gunner:KeyDown( IN_ATTACK2 ) then
			self:AltSecondaryAttack( Gunner, self:GetGunnerSeat() )
		end
	end
end


function ENT:OnEngineStarted()
end

function ENT:OnEngineStopped()
end
