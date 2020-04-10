--DO NOT EDIT OR REUPLOAD THIS FILE

ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript" )

ENT.PrintName = "T-42 Fighter"
ENT.Author = "Nashatok"
ENT.Information = ""
ENT.Category = "[LFS] Star Wars"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/sfp_t42/sfp_t42.mdl"

ENT.AITEAM = 2

ENT.Mass = 5000
ENT.Inertia = Vector(500000,500000,500000)
ENT.Drag = 1

ENT.HideDriver = true
ENT.SeatPos = Vector(-20,0,100)
ENT.SeatAng = Angle(0,-90,0)

ENT.IdleRPM = 1
ENT.MaxRPM = 2600
ENT.LimitRPM = 3200

ENT.RotorPos = Vector(125,0,60)
ENT.WingPos = Vector(50,0,60)
ENT.ElevatorPos = Vector(-200,0,40)
ENT.RudderPos = Vector(-200,0,40)

ENT.MaxVelocity = 2800

ENT.MaxThrust = 50000

ENT.MaxTurnPitch = 600
ENT.MaxTurnYaw = 800
ENT.MaxTurnRoll = 300

ENT.MaxPerfVelocity = 2000

ENT.MaxHealth = 1200
ENT.MaxShield = 400

ENT.Stability = 0.7

ENT.VerticalTakeoff = true
ENT.VtolAllowInputBelowThrottle = 10
ENT.MaxThrustVtol = 12000

ENT.MaxPrimaryAmmo = 1600
ENT.MaxSecondaryAmmo = 6