--DO NOT EDIT OR REUPLOAD THIS FILE

ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript" )

ENT.PrintName = "Alpha-3 Nimbus-class V-wing Starfighter"
ENT.Author = "Doctor"
ENT.Information = ""
ENT.Category = "[LFS] Star Wars"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/diggerthings/vwing/5.mdl"

ENT.AITEAM = 2

ENT.Mass = 5000
ENT.Inertia = Vector(400000,400000,400000)
ENT.Drag = 1

ENT.SeatPos = Vector(19,0,-15)
ENT.SeatAng = Angle(0,-90,10)

ENT.IdleRPM = 1
ENT.MaxRPM = 2600
ENT.LimitRPM = 3200

ENT.RotorPos = Vector(225,0,10)
ENT.WingPos = Vector(100,0,10)
ENT.ElevatorPos = Vector(-200,0,10)
ENT.RudderPos = Vector(-200,0,10)

ENT.MaxVelocity = 3200

ENT.MaxThrust = 40000

ENT.MaxTurnPitch = 900
ENT.MaxTurnYaw = 900
ENT.MaxTurnRoll = 550

ENT.MaxPerfVelocity = 1500

ENT.MaxHealth = 800
ENT.MaxShield = 650

ENT.Stability = 0.9

ENT.VerticalTakeoff = true
ENT.VtolAllowInputBelowThrottle = 10
ENT.MaxThrustVtol = 12000

ENT.MaxPrimaryAmmo = 1000
ENT.MaxSecondaryAmmo = 120

sound.Add( {
	name = "VWINGENGINE",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 160,
	sound = "lfs/vwing/vwingengine.wav"
} )

sound.Add( {
	name = "VWINGBOOST",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "lfs/vwing/vwingboost.wav"
} )

sound.Add( {
	name = "VWINGBRAKE",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "lfs/vwing/vwingbrake.wav"
} )

sound.Add( {
	name = "VWINGSHOOT",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 155,
	sound = "lfs/vwing/vwingshoot.wav"
} )