--DO NOT EDIT OR REUPLOAD THIS FILE

ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript" )

ENT.PrintName = "IG-2000"
ENT.Author = "Nashatok"
ENT.Information = ""
ENT.Category = "[LFS] Star Wars"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/sfp_ig2000/sfp_ig2000.mdl"

ENT.AITEAM = 1

ENT.Mass = 5000
ENT.Inertia = Vector(250000,250000,250000)
ENT.Drag = 1

ENT.HideDriver = true
ENT.SeatPos = Vector(100,0,90)
ENT.SeatAng = Angle(0,-90,0)

ENT.IdleRPM = 1
ENT.MaxRPM = 2300
ENT.LimitRPM = 3500

ENT.RotorPos = Vector(100,0,90)
ENT.WingPos = Vector(50,0,90)
ENT.ElevatorPos = Vector(-250,0,90)
ENT.RudderPos = Vector(-250,0,90)

ENT.MaxVelocity = 3500

ENT.MaxThrust = 50000

ENT.MaxTurnPitch = 700
ENT.MaxTurnYaw = 800
ENT.MaxTurnRoll = 600

ENT.MaxPerfVelocity = 2300

ENT.MaxHealth = 850
ENT.MaxShield = 200

ENT.Stability = 0.6

ENT.VerticalTakeoff = true
ENT.VtolAllowInputBelowThrottle = 10
ENT.MaxThrustVtol = 12000

ENT.MaxPrimaryAmmo = 1500
ENT.MaxSecondaryAmmo = 500


sound.Add( {
	name = "SCYK_FIRE",
	channel = CHAN_STREAM,
	volume = 1.0,
	level = 125,
	pitch = {85, 95},
	sound = "vehicles/speeder_shoot.wav"
} )