-- DO NOT EDIT OR REUPLOAD THIS FILE

ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript" )

ENT.PrintName = "NBT-630 Heavy Bomber"
ENT.Author = "Nashatok"
ENT.Information = ""
ENT.Category = "[LFS] Star Wars"

ENT.Spawnable		= true
ENT.AdminSpawnable	= false

ENT.MDL = "models/sweaw/ships/rep_ntb630_servius.mdl"

ENT.AITEAM = 2

ENT.Mass = 5000
ENT.Inertia = Vector(800000,800000,800000)
ENT.Drag = 1

ENT.HideDriver = true
ENT.SeatPos = Vector(305,0,48)
ENT.SeatAng = Angle(0,-90,0)

ENT.IdleRPM = 1
ENT.MaxRPM = 2600
ENT.LimitRPM = 3200

ENT.RotorPos = Vector(225,0,50)
ENT.WingPos = Vector(100,0,50)
ENT.ElevatorPos = Vector(-250,0,50)
ENT.RudderPos = Vector(-300,0,50)

ENT.MaxVelocity = 3000

ENT.MaxThrust = 50000

ENT.MaxTurnPitch = 500
ENT.MaxTurnYaw = 600
ENT.MaxTurnRoll = 400

ENT.MaxPerfVelocity = 2300

ENT.MaxHealth = 1750
ENT.MaxShield = 500

ENT.Stability = 0.7

ENT.VerticalTakeoff = true
ENT.VtolAllowInputBelowThrottle = 10
ENT.MaxThrustVtol = 12000

ENT.MaxPrimaryAmmo = 2000
ENT.MaxSecondaryAmmo = 32