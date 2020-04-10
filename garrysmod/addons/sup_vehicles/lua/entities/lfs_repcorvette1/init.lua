--DO NOT EDIT OR REUPLOAD THIS FILE

AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:SpawnFunction( ply, tr, ClassName )

	if not tr.Hit then return end

	local ent = ents.Create( ClassName )
	ent.dOwnerEntLFS = ply
	ent:SetPos( tr.HitPos + tr.HitNormal * 5 )
	ent:Spawn()
	ent:Activate()

	return ent

end


function ENT:RunOnSpawn()
	self:SetGunnerSeat( self:AddPassengerSeat( Vector(-100,50,200), Angle(0,-90,0) ) )
	self:AddPassengerSeat( Vector(-170,30,100), Angle(0,-90,0) )
	self:AddPassengerSeat( Vector(-200,30,100), Angle(0,-90,0) )
	self:AddPassengerSeat( Vector(-140,-30,100), Angle(0,-90,0) )
	self:AddPassengerSeat( Vector(-170,-30,100), Angle(0,-90,0) )
	self:AddPassengerSeat( Vector(-200,-30,100), Angle(0,-90,0) )
end

function ENT:SetNextAltPrimary( delay )
	self.NextAltPrimary = CurTime() + delay
end

function ENT:CanAltPrimaryAttack()
	self.NextAltPrimary = self.NextAltPrimary or 0.15
	return self.NextAltPrimary < CurTime()
end

function ENT:SecondaryAttack()
	if self:GetAI() then return end
	
	if not self:CanPrimaryAttack() then return end
	
	self:SetNextPrimary( 1 )

	self:TakePrimaryAmmo()

	self:EmitSound( "N1_FIRE2" )
	
	self.MirrorSecondary = not self.MirrorSecondary
	
	local Mirror = self.MirrorSecondary and -1 or 1
	
	local startpos =  self:GetRotorPos()
	local tr = util.TraceHull( {
		start = startpos,
		endpos = (startpos + self:GetForward() * 50000),
		mins = Vector( -40, -40, -40 ),
		maxs = Vector( 40, 40, 40 ),
		filter = function( e )
			local collide = e ~= self
			return collide
		end
	} )
	
	local ent = ents.Create( "lunasflightschool_missile" )
	local Pos = self:LocalToWorld( Vector(350,-160 * Mirror,180) )
	ent:SetPos( Pos )
	ent:SetAngles( (tr.HitPos - Pos):Angle() )
	ent:Spawn()
	ent:Activate()
	ent:SetAttacker( self:GetDriver() )
	ent:SetInflictor( self )
	ent:SetStartVelocity( self:GetVelocity():Length() )
	ent:SetCleanMissile( true )
	
	if tr.Hit then
		local Target = tr.Entity
		if IsValid( Target ) then
			if Target:GetClass():lower() ~= "lunasflightschool_missile" then
				ent:SetLockOn( Target )
				ent:SetStartVelocity( 0 )
			end
		end
	end
	
	constraint.NoCollide( ent, self, 0, 0 ) 
end
/*
function ENT:AltPrimaryAttack( Driver, Pod )
	if not self:CanAltPrimaryAttack() then return end
	
	if not IsValid( Pod ) then Pod = self:GetDriverSeat() end
	if not IsValid( Driver ) then Driver = Pod:GetDriver() end
	
	if not IsValid( Pod ) then return end
	if not IsValid( Driver ) then return end
	
	local EyeAngles = Pod:WorldToLocalAngles( Driver:EyeAngles() )
	local Forward = self:GetForward()
	
	local AimDirToForwardDir = math.deg( math.acos( math.Clamp( Forward:Dot( EyeAngles:Forward() ) ,-1,1) ) )
	if AimDirToForwardDir > 45 then return end
	
	self:EmitSound( "CONSULAR_FIRE" )
	
	self:SetNextAltPrimary( 0.15 )
	
	local startpos =  self:GetRotorPos()
	local TracePlane = util.TraceHull( {
		start = startpos,
		endpos = (startpos + EyeAngles:Forward() * 50000),
		mins = Vector( -10, -10, -10 ),
		maxs = Vector( 10, 10, 10 ),
		filter = self
	} )

	self.MirrorPrimary = not self.MirrorPrimary
	
	local Mirror = self.MirrorPrimary and -1 or 1
	
	local MuzzlePos = self:LocalToWorld( self.MirrorPrimary and Vector(1050,10,385) or Vector(1050,40,385) )

	local bullet = {}
	bullet.Num 	= 1
	bullet.Src 	= MuzzlePos
	bullet.Dir 	= (TracePlane.HitPos - bullet.Src):GetNormalized()
	bullet.Spread 	= Vector( 0.03,  0.03, 0 )
	bullet.Tracer	= 1
	bullet.TracerName	= "lfs_laser_blue"
	bullet.Force	= 100
	bullet.HullSize 	= 20
	bullet.Damage	= 40
	bullet.Attacker 	= Driver
	bullet.AmmoType = "Pistol"
	bullet.Callback = function(att, tr, dmginfo)
		dmginfo:SetDamageType(DMG_AIRBOAT)
	end
	self:FireBullets( bullet )
end

function ENT:AltPrimaryAttack2( Driver, Pod )
	if not self:CanAltPrimaryAttack() then return end
	
	if not IsValid( Pod ) then Pod = self:GetDriverSeat() end
	if not IsValid( Driver ) then Driver = Pod:GetDriver() end
	
	if not IsValid( Pod ) then return end
	if not IsValid( Driver ) then return end
	
	local EyeAngles = Pod:WorldToLocalAngles( Driver:EyeAngles() )
	local Forward = -self:GetForward()
	
	local AimDirToForwardDir = math.deg( math.acos( math.Clamp( Forward:Dot( EyeAngles:Forward() ) ,-1,1) ) )
	if AimDirToForwardDir > 45 then return end
	
	self:EmitSound( "CONSULAR_FIRE2" )
	
	self:SetNextAltPrimary( 0.15 )
	
	local startpos =  self:GetRotorPos()
	local TracePlane = util.TraceHull( {
		start = startpos,
		endpos = (startpos + EyeAngles:Forward() * 50000),
		mins = Vector( -10, -10, -10 ),
		maxs = Vector( 10, 10, 10 ),
		filter = self
	} )

	self.MirrorPrimary = not self.MirrorPrimary
	
	local Mirror = self.MirrorPrimary and -1 or 1
	
	local MuzzlePos = self:LocalToWorld( self.MirrorPrimary and Vector(-1000,0,430) or Vector(-1000,60,430) )

	local bullet = {}
	bullet.Num 	= 1
	bullet.Src 	= MuzzlePos
	bullet.Dir 	= (TracePlane.HitPos - bullet.Src):GetNormalized()
	bullet.Spread 	= Vector( 0.02,  0.02, 0 )
	bullet.Tracer	= 1
	bullet.TracerName	= "lfs_laser_blue"
	bullet.Force	= 100
	bullet.HullSize 	= 20
	bullet.Damage	= 40
	bullet.Attacker 	= Driver
	bullet.AmmoType = "Pistol"
	bullet.Callback = function(att, tr, dmginfo)
		dmginfo:SetDamageType(DMG_AIRBOAT)
	end
	self:FireBullets( bullet )
end*/


function ENT:AltPrimaryAttack3( Driver, Pod )
	if not self:CanAltPrimaryAttack() then return end
	
	local EyeAngles = Pod:WorldToLocalAngles( Driver:EyeAngles() )
	
	local Forward = self:GetForward()

	local KeyAttack = Driver:KeyDown( IN_ATTACK ) and math.abs( self:WorldToLocalAngles( EyeAngles ).y) < 55
	
	if KeyAttack then
		local startpos = self:GetRotorPos() + EyeAngles:Up() * 250
		local TracePlane = util.TraceLine( {
			start = startpos,
			endpos = (startpos + EyeAngles:Forward() * 50000),
			filter = self
		} )
		self:SetWingTurretTarget( TracePlane.HitPos )
	end
	
	self:EmitSound( "CONSULAR_FIRE2" )
	
	self:SetNextAltPrimary( 0.15 )
	
	local DesEndPos = self:GetWingTurretTarget()
	local DesStartPos = Vector(-172.97,334.04,93.25)
	for i = -1,1,2 do
		local StartPos = self:LocalToWorld( DesStartPos * Vector(1,i,1) )
		
		local Trace = util.TraceLine( { start = StartPos, endpos = DesEndPos} )
		local EndPos = Trace.HitPos
		
		if self.Entity:WorldToLocal( EndPos ).z < 0 then
			DesStartPos = Vector(-172.97,334.04,93.25)
		else
			DesStartPos = Vector(-174.79,350.05,125.98)
		end
	end
	
	local fP = { Vector(-40,0,85), Vector(20,0,285), Vector(-40,0,285), Vector(20,0,85), }

	self.NumPrim = self.NumPrim and self.NumPrim + 1 or 1
	if self.NumPrim > 4 then self.NumPrim = 1 end
	
	local MuzzlePos = self:LocalToWorld( fP[self.NumPrim] )

	local bullet = {}
	bullet.Num 	= 1
	bullet.Src 	= MuzzlePos
	bullet.Dir 	= (TracePlane.HitPos - bullet.Src):GetNormalized()
	bullet.Spread 	= Vector( 0.02,  0.02, 0 )
	bullet.Tracer	= 1
	bullet.TracerName	= "lfs_laser_blue"
	bullet.Force	= 100
	bullet.HullSize 	= 20
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
		if self:GetAmmoPrimary() > 0 then
			Fire1 = Driver:KeyDown( IN_ATTACK )
		end
		
		FireTurret = Driver:KeyDown( IN_WALK )
		
		if self:GetAmmoSecondary() > 0 then
			Fire2 = Driver:KeyDown( IN_ATTACK2 )
		end
	end
	
	if Fire1 then
		if FireTurret and not HasGunner then
			--self:AltPrimaryAttack()
			--self:AltPrimaryAttack2()
			self:AltPrimaryAttack3()
		else
			self:PrimaryAttack()
		end
	end
	
	if HasGunner then
		if Gunner:KeyDown( IN_ATTACK ) then
			--self:AltPrimaryAttack( Gunner, self:GetGunnerSeat() )
			--self:AltPrimaryAttack2( Gunner, self:GetGunnerSeat() )
			self:AltPrimaryAttack3( Gunner, self:GetGunnerSeat() )
			
		end
	end
	
	if Fire2 then
		self:SecondaryAttack()
	end
end


function ENT:OnEngineStarted()
end

function ENT:OnEngineStopped()
end
