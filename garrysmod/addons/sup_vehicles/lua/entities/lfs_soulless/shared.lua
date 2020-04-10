--DO NOT EDIT OR REUPLOAD THIS FILE

ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript" )

ENT.PrintName = "Belbullab-22"
ENT.Author = "Nashatok"
ENT.Information = ""
ENT.Category = "[LFS] Star Wars"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/soulless/soulless1.mdl"

ENT.AITEAM = 1

ENT.Mass = 5000
ENT.Inertia = Vector(250000,250000,250000)
ENT.Drag = 1

ENT.HideDriver = true
ENT.SeatPos = Vector(-100,0,60)
ENT.SeatAng = Angle(0,-90,0)

ENT.IdleRPM = 1
ENT.MaxRPM = 2300
ENT.LimitRPM = 3000

ENT.RotorPos = Vector(120,0,60)
ENT.WingPos = Vector(50,0,60)
ENT.ElevatorPos = Vector(-250,0,60)
ENT.RudderPos = Vector(-250,0,60)

ENT.MaxVelocity = 2900

ENT.MaxThrust = 50000

ENT.MaxTurnPitch = 700
ENT.MaxTurnYaw = 800
ENT.MaxTurnRoll = 600

ENT.MaxPerfVelocity = 2300

ENT.MaxHealth = 800
ENT.MaxShield = 200

ENT.Stability = 0.7

ENT.VerticalTakeoff = true
ENT.VtolAllowInputBelowThrottle = 10
ENT.MaxThrustVtol = 12000

ENT.MaxPrimaryAmmo = 1500