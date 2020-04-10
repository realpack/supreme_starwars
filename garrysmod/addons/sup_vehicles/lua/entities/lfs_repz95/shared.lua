--DO NOT EDIT OR REUPLOAD THIS FILE

ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript" )

ENT.PrintName = "Republic Z-95"
ENT.Author = "Nashatok"
ENT.Information = ""
ENT.Category = "[LFS] Star Wars"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/sweaw/ships/rep_z95_servius.mdl"

ENT.AITEAM = 2

ENT.Mass = 5000
ENT.Inertia = Vector(200000,200000,200000)
ENT.Drag = 1

ENT.HideDriver = true
ENT.SeatPos = Vector(0,0,60)
ENT.SeatAng = Angle(0,-90,0)

ENT.IdleRPM = 1
ENT.MaxRPM = 2600
ENT.LimitRPM = 3200

ENT.RotorPos = Vector(-100,0,60)
ENT.WingPos = Vector(10,0,60)
ENT.ElevatorPos = Vector(-100,0,60)
ENT.RudderPos = Vector(-400,0,60)

ENT.MaxVelocity = 2500

ENT.MaxThrust = 50000

ENT.MaxTurnPitch = 600
ENT.MaxTurnYaw = 800
ENT.MaxTurnRoll = 300

ENT.MaxPerfVelocity = 1900

ENT.MaxHealth = 850
ENT.MaxShield = 200

ENT.Stability = 0.7

ENT.VerticalTakeoff = true
ENT.VtolAllowInputBelowThrottle = 10
ENT.MaxThrustVtol = 12000

ENT.MaxPrimaryAmmo = 1000
ENT.MaxSecondaryAmmo = 6