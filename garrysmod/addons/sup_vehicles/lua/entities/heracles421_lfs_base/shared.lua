ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript" )

ENT.PrintName = "Hover Base"
ENT.Author = "Heracles421"
ENT.Information = ""
ENT.Category = "[LFS] Galactica Networks"

ENT.Spawnable		= false
ENT.AdminSpawnable	= false

ENT.LAATC_PICKUPABLE = false
ENT.LAATC_PICKUP_POS = Vector(0,0,0)
ENT.LAATC_PICKUP_Angle = Angle(0,0,0)

ENT.StoredForwardVector = Vector(0,-1,0)

ENT.deltaV = Vector(0,0,0)

ENT.RotorPos = Vector(0,0,0)

ENT.MassCenterOffset = Vector(0,0,0)

ENT.MDL = "models/hunter/blocks/cube1x3x1.mdl"

ENT.MaxPrimaryAmmo = 400
ENT.MaxSecondaryAmmo = 10

ENT.AITEAM = 2

ENT.Mass = 500

ENT.SeatPos = Vector(0,0,0)
ENT.SeatAng = Angle(0,-90,0)

ENT.MaxHealth = 2000

ENT.MoveSpeed = 500
ENT.BoostSpeed = 800
ENT.LerpMultiplier = 1
ENT.HeightOffset = 80
ENT.TraceDistance = ENT.HeightOffset * 1.5
ENT.IgnoreWater = true
ENT.CanMoveSideways = true

ENT.DebugMode = false
ENT.HitBoxMultiplier = 0.5

function ENT:AddDataTables()
	self:NetworkVar( "Entity",23, "TurretDriver" )
	self:NetworkVar( "Entity",24, "TurretSeat" )

	self:NetworkVar( "Float",22, "Move" )

	self:NetworkVar( "Bool",19, "IsMoving" )
	self:NetworkVar( "Bool",20, "IsCarried" )
	self:NetworkVar( "Bool",21, "FrontInRange" )
	self:NetworkVar( "Bool",22, "RearInRange" )

	self:NetworkVar( "Vector",1, "MassCenter" )
	self:NetworkVar( "Vector",2, "DeltaV" )
end

function ENT:TraceFilter( ent )
	if ent == self or ent:IsPlayer() or ent:IsNPC() or ent:IsVehicle() or self.GroupCollide[ ent:GetCollisionGroup() ] or self.EntityFilter[ ent:GetClass() ] then
		return false
	end

	return true
end

function ENT:DoTrace()
	local Up = self:GetUp()
	local MassCenter = self:GetMassCenter()
	local Mins, Maxs = self:GetRotatedAABB( self:OBBMins(), self:OBBMaxs() )
	Mins = Vector(Mins.x * self.HitBoxMultiplier, Mins.y * self.HitBoxMultiplier, 0)
	Maxs = Vector(Maxs.x * self.HitBoxMultiplier, Maxs.y * self.HitBoxMultiplier, 0)

	self.GroundTrace = util.TraceHull( {
		start = MassCenter,
		endpos = MassCenter - Up * (self.TraceDistance),

		filter = function(ent) return self:TraceFilter(ent) end,

		mins = Mins,
		maxs = Maxs,

		mask = MASK_SOLID,
	})

	self.WaterTrace = util.TraceHull( {
		start = MassCenter,
		endpos = MassCenter - Up * (self.TraceDistance),

		filter = function(ent) return self:TraceFilter(ent) end,

		mins = Mins,
		maxs = Maxs,

		mask = MASK_WATER,
	})
end

function ENT:LookRotation( lookAt, upDirection )
	if not (isvector( lookAt ) and isvector( upDirection )) then return end

	local Forward = lookAt
	local Up = upDirection

	-- Prepare input vectors to be used
	Forward = Forward:GetNormalized()
	--Up = Up - (Forward * Up:Dot(Forward))
	Up = Up:GetNormalized()

	local vector = Forward:GetNormalized()
	local vector2 = Up:Cross(vector)
	local vector3 = vector:Cross(vector2)

	local m00 = vector2.x
	local m01 = vector2.y
	local m02 = vector2.z

	local m10 = vector3.x
	local m11 = vector3.y
	local m12 = vector3.z

	local m20 = vector.x
	local m21 = vector.y
	local m22 = vector.z

	local num8 = (m00 + m11) + m22
	local quat = Quaternion.new(0,0,0,0)

	if (num8 > 0) then
		local num = math.sqrt(num8 + 1.0)
		quat[1] = num * 0.5
		num = 0.5 / num
		quat[2] = (m12 - m21) * num
		quat[3] = (m20 - m02) * num
		quat[4] = (m01 - m10) * num
		return quat:toAngle()
	end

	if (m00 >= m11) && (m00 >= m22) then
		local num7 = math.sqrt(((1 + m00) - m11) - m22)
		local num4 = 0.5 / num7
		quat[1] = (m12 - m21) * num4
		quat[2] = 0.5 * num7
		quat[3] = (m01 + m10) * num4
		quat[4] = (m02 + m20) * num4

		return quat:toAngle()
	end

	if (m11 > m22) then
		local num6 = math.sqrt(((1 + m11) - m00) - m22)
		local num3 = 0.5 / num6
		quat[1] = (m20 - m02) * num3
		quat[2] = (m10+ m01) * num3
		quat[3] = 0.5 * num6
		quat[4] = (m21 + m12) * num3
		return quat:toAngle()
	end

	local num5 = math.sqrt(((1 + m22) - m00) - m11)
	local num2 = 0.5 / num5
	quat[1] = (m01 - m10) * num2
	quat[2] = (m20 + m02) * num2
	quat[3] = (m21 + m12) * num2
	quat[4] = 0.5 * num5
	return quat:toAngle()
end

function ENT:FindLookAtRotation(startVector, targetVector)
	return self:WorldToLocalAngles((targetVector - startVector):GetNormalized():Angle())
end

ENT.ShadowParams = {
	secondstoarrive		= 0.5,
	maxangular			= 50000,
	maxangulardamp		= 100000,
	maxspeed			= 1000000,
	maxspeeddamp		= 500000,
	dampfactor			= 1,
	teleportdistance	= 0,
}

ENT.GroupCollide = {
	[COLLISION_GROUP_DEBRIS] = true,
	[COLLISION_GROUP_DEBRIS_TRIGGER] = true,
	[COLLISION_GROUP_PLAYER] = true,
	[COLLISION_GROUP_WEAPON] = true,
	[COLLISION_GROUP_VEHICLE_CLIP] = true,
	[COLLISION_GROUP_WORLD] = true,
}

ENT.EntityFilter = {}
