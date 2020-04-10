AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:SpawnFunction( ply, tr, ClassName )

	if not tr.Hit then return end

	local ent = ents.Create( ClassName )
	ent.dOwnerEntLFS = ply
	ent:SetPos( tr.HitPos + tr.HitNormal * 120 )
	ent:Spawn()
	ent:Activate()

	return ent

end

function ENT:OnTick()
	if IsValid(self:GetDriver()) then
		local vDriver = self:GetDriver()
		self:GetDriver():SetRenderMode(RENDERMODE_NONE)
	else 
		for k, v in pairs(player.GetAll()) do
			v:SetRenderMode(RENDERMODE_NORMAL)
		end
	end
end


function ENT:RunOnSpawn()

	self:GetDriverSeat().ExitPos = Vector(280.32,329.46,-105.26)

	local GunnerSeat = self:AddPassengerSeat( Vector(296.18,-0.69,40.31), Angle(0,-90,0)  ) 
	GunnerSeat.ExitPos = Vector(396.14,273.02,-107.61)
	
	self:SetGunnerSeat( GunnerSeat )

	self:AddPassengerSeat(Vector(-175.75,0,60), Angle(0,-90,0) ).ExitPos = Vector(234.69,419.13,-104.47)
	self:AddPassengerSeat(Vector(-175.75,0,60), Angle(0,-90,0) ).ExitPos = Vector(222.87,-381.22,-102.29) 
	self:AddPassengerSeat(Vector(-175.75,0,60), Angle(0,-90,0) ).ExitPos = Vector(66.36,468.92,-102.57) 
	self:AddPassengerSeat(Vector(-175.75,0,60), Angle(0,-90,0) ).ExitPos = Vector(114.63,-472.97,-99.79)  
	self:AddPassengerSeat(Vector(-175.75,0,60), Angle(0,-90,0) ).ExitPos = Vector(-54.2,508.86,-101)
	self:AddPassengerSeat(Vector(-175.75,0,60), Angle(0,-90,0) ).ExitPos = Vector(-19.16,-521.76,-98.58) 
	self:AddPassengerSeat(Vector(-175.75,0,60), Angle(0,-90,0) ).ExitPos = Vector(-180.35,518.16,-99.64)
	self:AddPassengerSeat(Vector(-175.75,0,60), Angle(0,-90,0) ).ExitPos = Vector(-178.05,-523.65,-96.66) 
	self:AddPassengerSeat(Vector(-175.75,0,60), Angle(0,-90,0) ).ExitPos = Vector(-295.58,506.31,-98.23)
	self:AddPassengerSeat(Vector(-175.75,0,60), Angle(0,-90,0) ).ExitPos = Vector(-307.63,-503.55,-99.81) 
	self:AddPassengerSeat(Vector(-175.75,0,60), Angle(0,-90,0) ).ExitPos = Vector(-432.87,454.39,-96.72)
	self:AddPassengerSeat(Vector(-175.75,0,60), Angle(0,-90,0) ).ExitPos = Vector(-425.23,-444.07,-99)
	self:AddPassengerSeat(Vector(-175.75,0,60), Angle(0,-90,0) ).ExitPos = Vector(-544.43,340.96,-95.79)
	self:AddPassengerSeat(Vector(-175.75,0,60), Angle(0,-90,0) ).ExitPos = Vector(-526.91,-342.1,-97.56)
	self:AddPassengerSeat(Vector(-175.75,0,60), Angle(0,-90,0) ).ExitPos = Vector(-621.83,200.94,-95.23)
	self:AddPassengerSeat(Vector(-175.75,0,60), Angle(0,-90,0) ).ExitPos = Vector(-624.35,-210.97,-96.16)  
	self:AddPassengerSeat(Vector(-175.75,0,60), Angle(0,-90,0) ).ExitPos = Vector(-665.45,60.1,-95.07) 
	self:AddPassengerSeat(Vector(-175.75,0,60), Angle(0,-90,0) ).ExitPos = Vector(-662.37,-88.14,-95.5) 
end

function ENT:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	
	self:EmitSound( "DGS_FIRE" )
	
	self:SetNextPrimary( 0.06 )
	
	local fP = { Vector(-45,431.5,-15.8),Vector(580,0,-91.5),Vector(-45,-431.5,-15.8) }

	self.NumPrim = self.NumPrim and self.NumPrim + 1 or 1
	if self.NumPrim > 3 then self.NumPrim = 1 end
	
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
	bullet.Spread 	= Vector( 0.02,  0.02, 0 )
	bullet.Tracer	= 1
	bullet.TracerName	= "lfs_laser_red"
	bullet.Force	= 100
	bullet.HullSize 	= 40
	bullet.Damage	= 25
	bullet.Attacker 	= self:GetDriver()
	bullet.AmmoType = "Pistol"
	bullet.Callback = function(att, tr, dmginfo)
		dmginfo:SetDamageType(DMG_AIRBOAT)
	end
	self:FireBullets( bullet )
	
	self:TakePrimaryAmmo()
	
end

function ENT:SecondaryAttack()

	if not self:CanSecondaryAttack() then return end

	self:TakeSecondaryAmmo()

	self:EmitSound( "DGS_FIRE2" )
	
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
	
	local rocketpos = {
		self:GetPos()+self:GetForward()*0+self:GetUp()*9+self:GetRight()*330,
		self:GetPos()+self:GetForward()*0+self:GetUp()*9+self:GetRight()*-330,
		self:GetPos()+self:GetForward()*0+self:GetUp()*9+self:GetRight()*293,
		self:GetPos()+self:GetForward()*0+self:GetUp()*9+self:GetRight()*-293,
		self:GetPos()+self:GetForward()*0+self:GetUp()*9+self:GetRight()*255,
		self:GetPos()+self:GetForward()*0+self:GetUp()*9+self:GetRight()*-255,
		self:GetPos()+self:GetForward()*0+self:GetUp()*9+self:GetRight()*220,
		self:GetPos()+self:GetForward()*0+self:GetUp()*9+self:GetRight()*-220,
		self:GetPos()+self:GetForward()*0+self:GetUp()*9+self:GetRight()*182,
		self:GetPos()+self:GetForward()*0+self:GetUp()*9+self:GetRight()*-182,
		self:GetPos()+self:GetForward()*0+self:GetUp()*-29+self:GetRight()*278,
		self:GetPos()+self:GetForward()*0+self:GetUp()*-29+self:GetRight()*-278,
		self:GetPos()+self:GetForward()*0+self:GetUp()*-29+self:GetRight()*238,
		self:GetPos()+self:GetForward()*0+self:GetUp()*-29+self:GetRight()*-238,
	}	
		
	local ent = ents.Create( "lunasflightschool_droidgunship_missile" )
	local mPos
	if (self:GetAmmoSecondary()+1)%14 == 0 then
		mPos = rocketpos[2]
		self:SetNextSecondary( 0.13 )

	elseif (self:GetAmmoSecondary()+1)%14 == 13 then
		mPos = rocketpos[11]
		self:SetNextSecondary( 0.13 )

	elseif (self:GetAmmoSecondary()+1)%14 == 12 then
		mPos = rocketpos[6]
		self:SetNextSecondary( 0.13 )

	elseif (self:GetAmmoSecondary()+1)%14 == 11 then
		mPos = rocketpos[7]
		self:SetNextSecondary( 0.13 )


	elseif (self:GetAmmoSecondary()+1)%14 == 10 then
		mPos = rocketpos[10]
		self:SetNextSecondary( 0.13 )

	elseif (self:GetAmmoSecondary()+1)%14 == 9 then
		mPos = rocketpos[3]
		self:SetNextSecondary( 0.13 )

	elseif (self:GetAmmoSecondary()+1)%14 == 8 then
		mPos = rocketpos[14]
		self:SetNextSecondary( 0.13 )

	elseif (self:GetAmmoSecondary()+1)%14 == 7 then
		mPos = rocketpos[1]
		self:SetNextSecondary( 0.13 )

	elseif (self:GetAmmoSecondary()+1)%14 == 6 then
		mPos = rocketpos[12]
		self:SetNextSecondary( 0.13 )

	elseif (self:GetAmmoSecondary()+1)%14 == 5 then
		mPos = rocketpos[5]
		self:SetNextSecondary( 0.13 )

	elseif (self:GetAmmoSecondary()+1)%14 == 4 then
		mPos = rocketpos[8]
		self:SetNextSecondary( 0.13 )

	elseif (self:GetAmmoSecondary()+1)%14 == 3 then
		mPos = rocketpos[9]
		self:SetNextSecondary( 0.13 )

	elseif (self:GetAmmoSecondary()+1)%14 == 2 then
		mPos = rocketpos[4]
		self:SetNextSecondary( 0.13 )

	else
		mPos = rocketpos[13]
		self:SetNextSecondary( 1.35 )
	end

	local Ang = self:WorldToLocal( mPos ).y > 0 and -1 or 1
	ent:SetPos( mPos )
	ent:SetAngles( self:LocalToWorldAngles( Angle(0,Ang,0) ) )
	ent:Spawn()
	ent:Activate()
	ent:SetAttacker( self:GetDriver() )
	ent:SetInflictor( self )
	ent:SetStartVelocity( self:GetVelocity():Length() )
	
	if self:GetAI() then
		local enemy = self:AIGetTarget()
		if IsValid(enemy) then
			if math.random(1,8) != 1 then
				if string.find(enemy:GetClass(),"lunasflightschool") then
					if enemy:GetClass() == "lunasflightschool_droidgunship_missile" then return end
					ent:SetLockOn(enemy)
					ent:SetStartVelocity(0)
				end
			end
		end
	else
		if tr.Hit then
			local Target = tr.Entity
			if IsValid(Target) then
				if Target:GetClass():lower() ~= "lunasflightschool_droidgunship_missile" then
					ent:SetLockOn(Target)
					ent:SetStartVelocity(0)
				end
			end
		end
	end
	constraint.NoCollide(ent,self,0,0) 
end

function ENT:SetNextAltPrimary( delay )
	self.NextAltPrimary = CurTime() + delay
end

function ENT:CanAltPrimaryAttack()
	self.NextAltPrimary = self.NextAltPrimary or 0
	return self.NextAltPrimary < CurTime()
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
	if AimDirToForwardDir < 95 then return end
	
	self:EmitSound( "DGS_FIRE" )
	
	self:SetNextAltPrimary( 0.06 )
	
	local startpos =  self:GetRotorPos()
	local TracePlane = util.TraceHull( {
		start = startpos,
		endpos = (startpos + EyeAngles:Forward() * 50000),
		mins = Vector( -40, -40, -40 ),
		maxs = Vector( 40, 40, 40 ),
		filter = self
	} )

	self.MirrorPrimary = not self.MirrorPrimary
	
	local Mirror = self.MirrorPrimary and -1 or 1
	
	local MuzzlePos = self:LocalToWorld( self.MirrorPrimary and Vector(408,-228.07,-74.93) or Vector(408,227.7,-75.1) )

	local bullet = {}
	bullet.Num 	= 1
	bullet.Src 	= MuzzlePos
	bullet.Dir 	= (TracePlane.HitPos - bullet.Src):GetNormalized()
	bullet.Spread 	= Vector( 0.017,  0.008, 0 )
	bullet.Tracer	= 1
	bullet.TracerName	= "lfs_laser_red_large"
	bullet.Force	= 100
	bullet.HullSize 	= 25
	bullet.Damage	= 25
	bullet.Attacker 	= self:GetGunner()
	bullet.AmmoType = "Pistol"
	bullet.Callback = function(att, tr, dmginfo)
		dmginfo:SetDamageType(DMG_AIRBOAT)
	end

	self:FireBullets( bullet )
end

function ENT:AltPrimaryAttack2( Driver, Pod, Dir )
	if not self:CanAltPrimaryAttack() then return end
	
	if not IsValid( Pod ) then Pod = self:GetDriverSeat() end
	if not IsValid( Driver ) then Driver = Pod:GetDriver() end
	
	if not IsValid( Pod ) then return end
	if not IsValid( Driver ) then return end
	
	local EyeAngles = Pod:WorldToLocalAngles( Driver:EyeAngles() )
	local Forward = -self:GetForward()
	
	local AimDirToForwardDir = math.deg( math.acos( math.Clamp( Forward:Dot( EyeAngles:Forward() ) ,-1,1) ) )
	if AimDirToForwardDir < 95 then return end
	
	self:EmitSound( "DGS_FIRE" )
	
	self:SetNextAltPrimary( 0.10 )
	
	local startpos =  self:GetRotorPos()
	local TracePlane = util.TraceHull( {
		start = startpos,
		endpos = (startpos + EyeAngles:Forward() * 50000),
		mins = Vector( -40, -40, -40 ),
		maxs = Vector( 40, 40, 40 ),
		filter = self
	} )
	
	local MuzzlePos = self:LocalToWorld(Vector(584.43,-0.16,-91.37))

	local bullet = {}
	bullet.Num 	= 1
	bullet.Src 	= MuzzlePos
	bullet.Dir 	= (TracePlane.HitPos - bullet.Src):GetNormalized()
	bullet.Spread 	= Vector( 0.02,  0.01, 0 )
	bullet.Tracer	= 1
	bullet.TracerName	= "lfs_laser_red"
	bullet.Force	= 100
	bullet.HullSize 	= 25
	bullet.Damage	= 25
	bullet.Attacker 	= self:GetGunner()
	bullet.AmmoType = "Pistol"
	bullet.Callback = function(att, tr, dmginfo)
		dmginfo:SetDamageType(DMG_AIRBOAT)
	end
	
	self:FireBullets( bullet )

	self:TakePrimaryAmmo()	
end


function ENT:OnKeyThrottle( bPressed )
	if bPressed then
		if self:CanSound() then
			self:EmitSound( "DGS_BOOST" )
			self:DelayNextSound( 4 )
		end
	end
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

function ENT:HandleWeapons(Fire1, Fire2, Fire3)
	local Driver = self:GetDriver()
	
	local Gunner = self:GetGunner()
	local GunnerSeat = self:GetGunnerSeat()
	local HasGunner = IsValid( Gunner )
	
	if IsValid( Driver ) then
		if self:GetAmmoPrimary() > 0 then
			Fire1 = Driver:KeyDown( IN_ATTACK )
		end
	
		FireTurret = Driver:KeyDown( IN_WALK )
	
		if self:GetAmmoSecondary() > 0 then
			Fire2 = Driver:KeyDown( IN_ATTACK2 )
		end
	end
	
	if HasGunner then
		local EyeAng = Gunner:EyeAngles()
		local GunnerAng = GunnerSeat:WorldToLocalAngles( EyeAng )
		
		GunnerDir = GunnerAng:Forward()
		
		Gunner:CrosshairDisable()
		
		if Gunner:KeyDown( IN_ATTACK ) then
			self:AltPrimaryAttack( Gunner, self:GetGunnerSeat() )
		end
	end
	
	if Fire1 then
		if FireTurret and not HasGunner then
			self:AltPrimaryAttack2()
		else
			self:PrimaryAttack()
		end
end

	if Fire2 then
		self:SecondaryAttack()
	end

	if Fire3 then
		self:AltPrimaryAttack2( Gunner, GunnerSeat, GunnerDir )
	end

end

function ENT:InitWheels()
	local GearPlates = {
		Vector(-290,0,-110),
	}
	
	self.LandingGearPlates = {}

	for _, v in pairs( GearPlates ) do
		local Plate = ents.Create( "prop_physics" )
		if IsValid( Plate ) then
			Plate:SetPos( self:LocalToWorld( v ) )
			Plate:SetAngles( self:LocalToWorldAngles( Angle(0,90,0) ) )
			
			Plate:SetModel( "models/hunter/plates/plate3x8.mdl" )
			Plate:Spawn()
			Plate:Activate()
			
			Plate:SetNoDraw( true )
			Plate:DrawShadow( false )
			Plate.DoNotDuplicate = true
			
			local pObj = Plate:GetPhysicsObject()
			if not IsValid( pObj ) then
				self:Remove()
				print("LFS: Failed to initialize landing gear phys model. Plane terminated.")
				return
			end
		
			pObj:EnableMotion(false)
			pObj:SetMass( 500 )
			
			table.insert( self.LandingGearPlates, Plate )
			self:DeleteOnRemove( Plate )
			self:dOwner( Plate )
			
			constraint.Weld( self, Plate, 0, 0, 0,false, true ) 
			constraint.NoCollide( Plate, self, 0, 0 ) 
			
			pObj:EnableMotion( true )
			pObj:EnableDrag( false ) 
			
			Plate:SetPos( self:GetPos() )
			
		else
			self:Remove()
		
			print("LFS: Failed to initialize landing gear. Plane terminated.")
		end
	end

	timer.Simple( 0.1, function()
		if not IsValid( self ) then return end
		
		local PObj = self:GetPhysicsObject()
		if IsValid( PObj ) then 
			PObj:EnableMotion( true )
		end
		
		self:PhysWake() 
	end)
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