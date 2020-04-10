AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:RunOnSpawn()
	self.gearTime = CurTime()
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

	--local TurretSeat = self:AddPassengerSeat( Vector(-130,0,120), Angle(0,-90,0) )
	--self:SetTurretSeat( TurretSeat )
	for i = 1, 8 do
		local RackPod1 = self:AddPassengerSeat( Vector(0,0,100), Angle(0,-90,0) )
		local RackPod2 = self:AddPassengerSeat( Vector(0,0,100), Angle(0,-90,0) )

		local ID = self:LookupAttachment( "seat_00" .. i )
		local Seat = self:GetAttachment( ID )

		if Seat then
			local Pos,Ang = LocalToWorld( Vector(10,-10,0), Angle(90,0,-90), Seat.Pos, Seat.Ang )
			if i >= 5 then
				Pos,Ang = LocalToWorld( Vector(-10,-10,0), Angle(-90,0,-90), Seat.Pos, Seat.Ang )
			end

			RackPod1:SetParent( NULL )
			RackPod1:SetPos( Pos + Vector(-15,0,0) )
			RackPod1:SetAngles( Ang )
			RackPod1:SetParent( self, ID )

			RackPod2:SetParent( NULL )
			RackPod2:SetPos( Pos + Vector(15,0,0) )
			RackPod2:SetAngles( Ang )
			RackPod2:SetParent( self, ID )
		end
	end
end

function ENT:PrimaryAttack()
	if self:GetIsCarried() then return end
	if not self:CanPrimaryAttack() or not self.MainGunDir then return end

	local ID1 = self:LookupAttachment( "muzzle_right_top" )
	local ID2 = self:LookupAttachment( "muzzle_right_bottom" )
	local ID3 = self:LookupAttachment( "muzzle_left_top" )
	local ID4 = self:LookupAttachment( "muzzle_left_bottom" )

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

	self:EmitSound( "GALACTICA_MTT_FIRE" )

	local Pos = FirePos[self.FireIndex].Pos
	local Dir = FirePos[self.FireIndex].Ang:Up()

	local bullet = {}
	bullet.Num 	= 1
	bullet.Src 	= Pos
	bullet.Dir 	= Dir
	bullet.Spread 	= Vector( 0.01,  0.01, 0 )
	bullet.Tracer	= 1
	bullet.TracerName	= "lfs_laser_red"
	bullet.Force	= 100
	bullet.HullSize = 22
	bullet.Damage	= 300
	bullet.Attacker = self:GetDriver()
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

	local ID1 = self:LookupBone( "right_gun_pitch_yaw" )
	local ID2 = self:LookupBone( "left_gun_pitch_yaw" )
	local ID1Position = self:GetBonePosition( ID1 )
	local ID2Position = self:GetBonePosition( ID2 )

	local AimAnglesRight = self:FindLookAtRotation(ID1Position, TracePlane.HitPos)
	local AimAnglesLeft = self:FindLookAtRotation(ID2Position, TracePlane.HitPos)

	self:SetPoseParameter("right_gun_pitch", AimAnglesRight.p )
	self:SetPoseParameter("right_gun_yaw", AimAnglesRight.y )
	self:SetPoseParameter("left_gun_pitch", AimAnglesLeft.p )
	self:SetPoseParameter("left_gun_yaw", AimAnglesLeft.y )

	local ID = self:LookupAttachment( "muzzle_right_top" )
	local Muzzle = self:GetAttachment( ID )

	if Muzzle then
		self:SetFrontInRange( math.deg( math.acos( math.Clamp( Muzzle.Ang:Up():Dot( self.MainGunDir ) ,-1,1) ) ) < 15 )
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

function ENT:OnLandingGearToggled( bOn )
	if self.gearTime > CurTime() then
		self.LandingGearUp = not bOn
		return
	end
	local playbackTime = 1
	self.gearTime = CurTime() + 10 / playbackTime

	if bOn then
		self:PlayAnimation( "deploy_transport", playbackTime )
		self:EmitSound( "vehicles/tank_readyfire1.wav" )
	else
		self:PlayAnimation( "retract_transport", playbackTime )
		self:EmitSound( "vehicles/tank_readyfire1.wav" )
	end
end
