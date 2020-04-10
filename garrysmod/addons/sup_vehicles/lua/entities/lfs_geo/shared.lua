--DO NOT EDIT OR REUPLOAD THIS FILE

ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript" )

ENT.PrintName = "Nantex-class"
ENT.Author = "Nashatok"
ENT.Information = ""
ENT.Category = "[LFS] Star Wars"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/geon/geon1.mdl"

ENT.AITEAM = 1

ENT.Mass = 5000
ENT.Inertia = Vector(250000,250000,250000)
ENT.Drag = 1

ENT.HideDriver = true
ENT.SeatPos = Vector(-40,0,60)
ENT.SeatAng = Angle(0,-90,0)

ENT.IdleRPM = 1
ENT.MaxRPM = 2300
ENT.LimitRPM = 3500

ENT.RotorPos = Vector(80,0,60)
ENT.WingPos = Vector(50,0,60)
ENT.ElevatorPos = Vector(-250,0,60)
ENT.RudderPos = Vector(-250,0,60)

ENT.MaxVelocity = 3500

ENT.MaxThrust = 50000

ENT.MaxTurnPitch = 900
ENT.MaxTurnYaw = 1200
ENT.MaxTurnRoll = 800

ENT.MaxPerfVelocity = 2300

ENT.MaxHealth = 450
--ENT.MaxShield = 200

ENT.Stability = 0.7

ENT.VerticalTakeoff = true
ENT.VtolAllowInputBelowThrottle = 10
ENT.MaxThrustVtol = 12000

ENT.MaxPrimaryAmmo = 5000

sound.Add( {
	name = "GEO_FIRE",
	channel = CHAN_STREAM,
	volume = 0.8,
	level = 125,
	pitch = {95, 105},
	sound = "lfs/speeder_shoot.wav"
} )