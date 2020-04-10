-- YOU CAN EDIT AND REUPLOAD THIS FILE. 
-- HOWEVER MAKE SURE TO RENAME THE FOLDER TO AVOID CONFLICTS

AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:SpawnFunction( ply, tr, ClassName ) -- called by garry
	if not tr.Hit then return end

	local ent = ents.Create( ClassName )
	ent.dOwnerEntLFS = ply  -- this is important
	ent:SetPos( tr.HitPos + tr.HitNormal * 20 ) -- spawn 20 units above ground
	ent:Spawn()
	ent:Activate()

	return ent
end

function ENT:OnTick() -- use this instead of "think"
end

function ENT:RunOnSpawn() -- called when the vehicle is spawned
	local Seat1 = self:AddPassengerSeat(Vector(-115,-50,170),Angle(0,0,0))
	Seat1.ExitPos = Vector(-115,-20,170)
	local Seat2 = self:AddPassengerSeat(Vector(-140,-50,170),Angle(0,0,0))
	Seat2.ExitPos = Vector(-140,-20,170)
	local Seat3 = self:AddPassengerSeat(Vector(-170,-50,170),Angle(0,0,0))
	Seat3.ExitPos = Vector(-170,-20,170)
	local Seat4 = self:AddPassengerSeat(Vector(-200,-50,170),Angle(0,0,0))
	Seat4.ExitPos = Vector(-200,-20,170)
	local Seat5 = self:AddPassengerSeat(Vector(-225,-50,170),Angle(0,0,0))
	Seat5.ExitPos = Vector(-225,-20,170)
	local Seat6 = self:AddPassengerSeat(Vector(-260,-50,170),Angle(0,0,0))
	Seat6.ExitPos = Vector(-260,-20,170)
	local Seat7 = self:AddPassengerSeat(Vector(-285,-50,170),Angle(0,0,0))
	Seat7.ExitPos = Vector(-285,-20,170)

	local Seat8 = self:AddPassengerSeat(Vector(-115,50,170),Angle(0,180,0))
	Seat8.ExitPos = Vector(-115,20,170)
	local Seat9 = self:AddPassengerSeat(Vector(-140,50,170),Angle(0,180,0))
	Seat9.ExitPos = Vector(-140,20,170)
	local Seat10 = self:AddPassengerSeat(Vector(-170,50,170),Angle(0,180,0))
	Seat10.ExitPos = Vector(-170,20,170)
	local Seat11 = self:AddPassengerSeat(Vector(-200,50,170),Angle(0,180,0))
	Seat11.ExitPos = Vector(-200,20,170)
	local Seat12 = self:AddPassengerSeat(Vector(-225,50,170),Angle(0,180,0))
	Seat12.ExitPos = Vector(-225,20,170)
	local Seat13 = self:AddPassengerSeat(Vector(-260,50,170),Angle(0,180,0))
	Seat13.ExitPos = Vector(-260,20,170)
	local Seat14 = self:AddPassengerSeat(Vector(-285,50,170),Angle(0,180,0))
	Seat14.ExitPos = Vector(-285,20,170)
end

function ENT:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end

	self:SetNextPrimary( 0.15 )
	
	--[[ do primary attack code here ]]--
	
	self:EmitSound( "VANILLA_NUSHUTTLE_FIRE" )
	
	local Driver = self:GetDriver()

	fP = {Vector(0,223,85),Vector(0,223,105),Vector(0,-223,85),Vector(0,-223,105)}

	self.NumPrim = self.NumPrim and self.NumPrim + 1 or 1
	if self.NumPrim > 4 then self.NumPrim = 1 end
	
	local bullet = {}
	bullet.Num 	= 1
	bullet.Src 	= self:LocalToWorld(fP[self.NumPrim])
	bullet.Dir 	= self:GetForward()
	bullet.Spread 	= Vector( 0.015,  0.015, 0 )
	bullet.Tracer	= 1
	bullet.TracerName	= "lfs_laser_blue"
	bullet.Force	= 10
	bullet.HullSize 	= 5
	bullet.Damage	= 5
	bullet.Attacker 	= Driver
	bullet.AmmoType = "Pistol"
	
	if self.Vtol == false then

		self:FireBullets( bullet )
	
		self:TakePrimaryAmmo()
	end
end

function ENT:SecondaryAttack()
	if not self:CanSecondaryAttack() then return end
	
	self:SetNextSecondary( 0.15 )

	--[[ do secondary attack code here ]]--
	
	self:TakeSecondaryAmmo()
end

function ENT:CreateAI() -- called when the ai gets enabled
end

function ENT:RemoveAI() -- called when the ai gets disabled
end

function ENT:OnKeyThrottle( bPressed )
	if self:CanSound() then -- makes sure the player cant spam sounds
		if bPressed then -- if throttle key is pressed
			--self:EmitSound( "buttons/button3.wav" )
			--self:DelayNextSound( 1 ) -- when the next sound should be allowed to be played
		else
			--self:EmitSound( "buttons/button11.wav" )
			--self:DelayNextSound( 0.5 )
		end
	end
end

--[[
function ENT:ApplyThrustVtol( PhysObj, vDirection, fForce )
	PhysObj:ApplyForceOffset( vDirection * fForce,  self:GetElevatorPos() )
	PhysObj:ApplyForceOffset( vDirection * fForce,  self:GetWingPos() )
end

function ENT:ApplyThrust( PhysObj, vDirection, fForce )
	PhysObj:ApplyForceOffset( vDirection * fForce, self:GetRotorPos() )
end
]]--

function ENT:OnEngineStarted()
	--[[ play engine start sound? ]]--
	self:SetModel('models/props/nuclassv2/nuclassidle/nuclassidle.mdl')
end

function ENT:OnEngineStopped()
	--[[ play engine stop sound? ]]--
	self:SetModel('models/props/nuclassv2/nuclasslanded/nuclasslanded.mdl')
end

function ENT:OnVtolMode( IsOn )
	--[[ called when vtol mode is activated / deactivated ]]--
end

function ENT:OnLandingGearToggled( bOn )
	self:EmitSound( "vehicles/tank_readyfire1.wav" )
	
	if bOn then
		self:SetModel('models/props/nuclassv2/nuclassattack/nuclassattack.mdl')
		self.Vtol = false
	else
		self:SetModel('models/props/nuclassv2/nuclassidle/nuclassidle.mdl')
		self.Vtol = true
	end
end
