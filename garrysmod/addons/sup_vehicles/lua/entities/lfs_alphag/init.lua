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
end

function ENT:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end

	self:EmitSound( "TRIFIGHTER_FIRE" )
	
	self:SetNextPrimary( 0.12 )
	
	local fP = { Vector(70,105,58), Vector(70,-105,58), Vector(50,5,140), Vector(70,95,50), Vector(70,-95,50), Vector(50,-5,140), }

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
	bullet.Spread 	= Vector( 0.02,  0.02, 0 )
	bullet.Tracer	= 1
	bullet.TracerName	= "lfs_laser_green"
	bullet.Force	= 100
	bullet.HullSize 	= 40
	bullet.Damage	= 40
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

	self:EmitSound( "ALPHAG_FIRE2" )
	
	local startpos =  self:GetRotorPos()
	local tr = util.TraceHull( {
		start = startpos,
		endpos = (startpos + self:GetForward() * 50000),
		mins = Vector( -40, -40, -40 ),
		maxs = Vector( 40, 40, 40 ),
		filter = self
} )
	
	local rocketpos = {
		self:GetPos()+self:GetForward()*125+self:GetUp()*80+self:GetRight()*62,
		self:GetPos()+self:GetForward()*125+self:GetUp()*80+self:GetRight()*-62,
		self:GetPos()+self:GetForward()*125+self:GetUp()*80+self:GetRight()*73,
		self:GetPos()+self:GetForward()*125+self:GetUp()*80+self:GetRight()*-73,
		self:GetPos()+self:GetForward()*125+self:GetUp()*80+self:GetRight()*85,
		self:GetPos()+self:GetForward()*125+self:GetUp()*80+self:GetRight()*-85,
		
		self:GetPos()+self:GetForward()*125+self:GetUp()*65+self:GetRight()*62,
		self:GetPos()+self:GetForward()*125+self:GetUp()*65+self:GetRight()*-62,
		self:GetPos()+self:GetForward()*125+self:GetUp()*65+self:GetRight()*73,
		self:GetPos()+self:GetForward()*125+self:GetUp()*65+self:GetRight()*-73,
		self:GetPos()+self:GetForward()*125+self:GetUp()*65+self:GetRight()*85,
		self:GetPos()+self:GetForward()*125+self:GetUp()*65+self:GetRight()*-85,
	}	
		
	local ent = ents.Create( "lfs_misc_barrage" )
	local mPos
	if (self:GetAmmoSecondary()+1)%12 == 0 then
		mPos = rocketpos[1]
		self:SetNextSecondary( 0.18 )
		
	elseif (self:GetAmmoSecondary()+1)%12 == 11 then
		mPos = rocketpos[2]
		self:SetNextSecondary( 0.18 )

	elseif (self:GetAmmoSecondary()+1)%12 == 10 then
		mPos = rocketpos[3]
		self:SetNextSecondary( 0.18 )
		
	elseif (self:GetAmmoSecondary()+1)%12 == 9 then
		mPos = rocketpos[4]
		self:SetNextSecondary( 0.18 )

	elseif (self:GetAmmoSecondary()+1)%12 == 8 then
		mPos = rocketpos[5]
		self:SetNextSecondary( 0.18 )
		
	elseif (self:GetAmmoSecondary()+1)%12 == 7 then
		mPos = rocketpos[6]
		self:SetNextSecondary( 0.18 )

	elseif (self:GetAmmoSecondary()+1)%12 == 6 then
		mPos = rocketpos[7]
		self:SetNextSecondary( 0.18 )
		
	elseif (self:GetAmmoSecondary()+1)%12 == 5 then
		mPos = rocketpos[8]
		self:SetNextSecondary( 0.18 )

	elseif (self:GetAmmoSecondary()+1)%12 == 4 then
		mPos = rocketpos[9]
		self:SetNextSecondary( 0.18 )

	elseif (self:GetAmmoSecondary()+1)%12 == 3 then
		mPos = rocketpos[10]
		self:SetNextSecondary( 0.18 )

	elseif (self:GetAmmoSecondary()+1)%12 == 2 then
		mPos = rocketpos[11]
		self:SetNextSecondary( 0.18 )

	else
		mPos = rocketpos[12]
		self:SetNextSecondary( 8 )
	end

	local Ang = self:WorldToLocal( mPos ).y > 0 and -1 or 1
	ent:SetPos( mPos )
	ent:SetAngles( self:LocalToWorldAngles( Angle(0,Ang,0) ) )
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
					if enemy:GetClass() == "lfs_misc_barrage" then return end
					ent:SetLockOn(enemy)
					ent:SetStartVelocity(0)
				end
			end
		end
	else
		if tr.Hit then
			local Target = tr.Entity
			if IsValid(Target) then
				if Target:GetClass():lower() ~= "lfs_misc_barrage" then
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
	
	if IsValid( Driver ) then
		if self:GetAmmoPrimary() > 0 then
			Fire1 = Driver:KeyDown( IN_ATTACK )
		end
		if self:GetAmmoSecondary() > 0 then
			Fire2 = Driver:KeyDown( IN_ATTACK2 )
		end
	end
	
	if Fire1 then
		self:PrimaryAttack()
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