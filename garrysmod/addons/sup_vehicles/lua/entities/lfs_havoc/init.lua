--DO NOT EDIT OR REUPLOAD THIS FILE

AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:SpawnFunction( ply, tr, ClassName ) -- called by garry
	if not tr.Hit then return end

	local ent = ents.Create( ClassName )
	ent.dOwnerEntLFS = ply  -- this is important
	ent:SetPos( tr.HitPos + tr.HitNormal * 30 ) -- spawn 20 units above ground
	ent:Spawn()
	ent:Activate()

	return ent
end

function ENT:OnTick() -- use this instead of "think"
end

function ENT:RunOnSpawn()
	self:SetGunnerSeat( self:AddPassengerSeat( Vector(60,0,60), Angle(0,90,0) ) )
end

function ENT:SetNextAltPrimary( delay )
	self.NextAltPrimary = CurTime() + delay
end

function ENT:CanAltPrimaryAttack()
	self.NextAltPrimary = self.NextAltPrimary or 0
	return self.NextAltPrimary < CurTime()
end

function ENT:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end

	self:EmitSound( "HAVOC_FIRE" )
	
	self:SetNextPrimary( 0.12 )
	
	local fP = { Vector(140,-235,22),Vector(140,235,22),Vector(130,-220,18),Vector(130,220,18),Vector(100,-210,18),Vector(100,210,18), }

	self.NumPrim = self.NumPrim and self.NumPrim + 1 or 1
	if self.NumPrim > 6 then self.NumPrim = 1 end
	
	local startpos =  self:GetRotorPos()
	local TracePlane = util.TraceHull( {
		start = startpos,
		endpos = (startpos + self:GetForward() * 50000),
		mins = Vector( -10, -10, -10 ),
		maxs = Vector( 10, 10, 10 ),
		filter = self
	} )
	
	local bullet = {}
	bullet.Num 	= 1
	bullet.Src 	= self:LocalToWorld( fP[self.NumPrim] )
	bullet.Dir 	= (TracePlane.HitPos - bullet.Src):GetNormalized()
	bullet.Spread 	= Vector( 0.015,  0.015, 0 )
	bullet.Tracer	= 1
	bullet.TracerName	= "lfs_laser_yellow"
	bullet.Force	= 50
	bullet.HullSize 	= 30
	bullet.Damage	= 55
	bullet.Attacker 	= self:GetDriver()
	bullet.AmmoType = "Pistol"
	bullet.Callback = function(att, tr, dmginfo)
		dmginfo:SetDamageType(DMG_SHOCK)
		
	local effectdata = EffectData()
		effectdata:SetOrigin( tr.HitPos )
	util.Effect( "cball_bounce", effectdata )
	end
	self:FireBullets( bullet )
	
	self:TakePrimaryAmmo()
	
end

function ENT:AltPrimaryAttack( Driver, Pod )
	if not self:CanAltPrimaryAttack() then return end
	
	if not IsValid( Pod ) then Pod = self:GetDriverSeat() end
	if not IsValid( Driver ) then Driver = Pod:GetDriver() end
	
	if not IsValid( Pod ) then return end
	if not IsValid( Driver ) then return end
	
	local EyeAngles = Pod:WorldToLocalAngles( Driver:EyeAngles() )
	local Forward = -self:GetForward()
	
	local AimDirToForwardDir = math.deg( math.acos( math.Clamp( Forward:Dot( EyeAngles:Forward() ) ,-1,1) ) )
	if AimDirToForwardDir > 180 then return end
	
	self:EmitSound( "HAVOC_FIRE2" )
	
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
	
	local MuzzlePos = self:LocalToWorld( self.MirrorPrimary and Vector(50,8,78) or Vector(50,-8,78) )

	local bullet = {}
	bullet.Num 	= 1
	bullet.Src 	= MuzzlePos
	bullet.Dir 	= (TracePlane.HitPos - bullet.Src):GetNormalized()
	bullet.Spread 	= Vector( 0.03,  0.03, 0 )
	bullet.Tracer	= 1
	bullet.TracerName	= "lfs_laser_yellow2"
	bullet.Force	= 100
	bullet.HullSize 	= 20
	bullet.Damage	= 80
	bullet.Attacker 	= Driver
	bullet.AmmoType = "Pistol"
	bullet.Callback = function(att, tr, dmginfo)
		dmginfo:SetDamageType(DMG_BULLET)
	end
	self:FireBullets( bullet )
end

function ENT:SecondaryAttack()
	if not self:CanSecondaryAttack() then return end
	--if self:GetAI() then return end
	
	self:TakeSecondaryAmmo()

	self:EmitSound( "ALPHAG_FIRE2" )
	
	local startpos =  self:GetRotorPos()
	local tr = util.TraceHull( {
		start = startpos,
		--endpos = (startpos + self:GetForward() * 500000),
		mins = Vector( -40, -40, -40 ),
		maxs = Vector( 40, 40, 40 ),
		filter = self
} )
	
	local rocketpos = {
		self:GetPos()+self:GetForward()*125+self:GetUp()*20+self:GetRight()*65,
		self:GetPos()+self:GetForward()*125+self:GetUp()*20+self:GetRight()*-65,
		self:GetPos()+self:GetForward()*125+self:GetUp()*8+self:GetRight()*85,
		self:GetPos()+self:GetForward()*125+self:GetUp()*8+self:GetRight()*-85,
	}	
		
	local ent = ents.Create( "lunasflightschool_missile" )
	local mPos
	if (self:GetAmmoSecondary()+1)%4 == 0 then
		mPos = rocketpos[1]
		self:SetNextSecondary( 0.30 )

	elseif (self:GetAmmoSecondary()+1)%4 == 3 then
		mPos = rocketpos[2]
		self:SetNextSecondary( 0.30 )

	elseif (self:GetAmmoSecondary()+1)%4 == 2 then
		mPos = rocketpos[3]
		self:SetNextSecondary( 0.30 )

	else
		mPos = rocketpos[4]
		self:SetNextSecondary( 7 )
	end

	local Ang = self:WorldToLocal( mPos ).y > 0 and -1 or 1
	ent:SetPos( mPos )
	ent:SetAngles( self:LocalToWorldAngles( Angle(0,0,0) ) )
	ent:Spawn()
	ent:Activate()
	ent:SetAttacker( self:GetDriver() )
	ent:SetInflictor( self )
	ent:SetStartVelocity( self:GetVelocity():Length() )
	ent:SetDirtyMissile( false )
	
	if self:GetAI() then
		local enemy = self:AIGetTarget()
		if IsValid(enemy) then
			if math.random(1,8) != 1 then
				if string.find(enemy:GetClass(),"lunasflightschool") then
					if enemy:GetClass() == "lunasflightschool_missile" then return end
					ent:SetLockOn(enemy)
					ent:SetStartVelocity(0)
				end
			end
		end
	else
		if tr.Hit then
			local Target = tr.Entity
			if IsValid(Target) then
				if Target:GetClass():lower() ~= "lunasflightschool_missile" then
					ent:SetLockOn(Target)
					ent:SetStartVelocity(0)
				end
			end
		end
	end
	constraint.NoCollide(ent,self,0,0) 
end

function ENT:CreateAI()
end

function ENT:RemoveAI()
end

function ENT:OnEngineStarted()
end

function ENT:OnEngineStopped()
end

function ENT:OnLandingGearToggled( bOn )
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
			self:AltPrimaryAttack()
		else
			self:PrimaryAttack()
		end
	end
	
	if HasGunner then
		if Gunner:KeyDown( IN_ATTACK ) then
			self:AltPrimaryAttack( Gunner, self:GetGunnerSeat() )
		end
	end
	
	if Fire2 then
		self:SecondaryAttack()
	end
end

function ENT:HandleLandingGear()
	local Driver = self:GetDriver()
	
	if IsValid( Driver ) then
		local KeyJump = Driver:KeyDown( IN_JUMP )
		
		if self.OldKeyJump ~= KeyJump then
			self.OldKeyJump = KeyJump
			if KeyJump then
				self:ToggleLandingGear()
				self:PhysWake()
			end
		end
	end
	
	local TVal = self.LandingGearUp and 0 or 1
	
	local Speed = FrameTime() * 4
	
	self:SetLGear( self:GetLGear() + math.Clamp(TVal - self:GetLGear(),-Speed,Speed) )
	
	if istable( self.LandingGearPlates ) then
		for _, v in pairs( self.LandingGearPlates ) do
			if IsValid( v ) then
				local pObj = v:GetPhysicsObject()
				if IsValid( pObj ) then
					pObj:SetMass( 1 + 2000 * self:GetLGear() ^ 10 )
				end
			end
		end
	end
end
