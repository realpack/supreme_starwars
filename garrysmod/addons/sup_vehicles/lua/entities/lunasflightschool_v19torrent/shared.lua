--DO NOT EDIT OR REUPLOAD THIS FILE

ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript" )

ENT.PrintName = "V-19 Torrent"
ENT.Author = "Doctor"
ENT.Information = ""
ENT.Category = "[LFS] Star Wars"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/DiggerThings/v19/4.mdl"

ENT.AITEAM = 2

ENT.Mass = 5000
ENT.Inertia = Vector(400000,400000,400000)
ENT.Drag = 1

ENT.SeatPos = Vector(-12,0,14)
ENT.SeatAng = Angle(0,-90,9)

ENT.IdleRPM = 1
ENT.MaxRPM = 3000
ENT.LimitRPM = 2800

ENT.RotorPos = Vector(225,0,10)
ENT.WingPos = Vector(100,0,10)
ENT.ElevatorPos = Vector(-200,0,10)
ENT.RudderPos = Vector(-200,0,10)

ENT.MaxVelocity = 2800

ENT.MaxThrust = 18000

ENT.MaxTurnPitch = 1200
ENT.MaxTurnYaw = 1500
ENT.MaxTurnRoll = 200

ENT.MaxPerfVelocity = 1500

ENT.MaxHealth = 1000
ENT.MaxShield = 200

ENT.Stability = 1

ENT.VerticalTakeoff = true
ENT.VtolAllowInputBelowThrottle = 10
ENT.MaxThrustVtol = 12000

ENT.MaxPrimaryAmmo = 1000
ENT.MaxSecondaryAmmo = 12

sound.Add( {
	name = "V19_FIRE",
	channel = CHAN_ITEM,
	volume = 1.0,
	level = 125,
	pitch = {95, 105},
	sound = "lfs/v19/v19_shoot.wav"
} )