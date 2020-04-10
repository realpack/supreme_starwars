--NO U

ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript" )

ENT.PrintName = "A-Wing"
ENT.Author = "Nashatok"
ENT.Information = ""
ENT.Category = "[LFS] Star Wars"

ENT.Spawnable		= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/awing/awing1.mdl"

ENT.AITEAM = 2

ENT.Mass = 2000
ENT.Inertia = Vector(250000,250000,250000)
ENT.Drag = 1

ENT.HideDriver = true
ENT.SeatPos = Vector(50,0,40)
ENT.SeatAng = Angle(0,-90,0)

ENT.IdleRPM = 1
ENT.MaxRPM = 2800
ENT.LimitRPM = 3000

ENT.RotorPos = Vector(225,0,40)
ENT.WingPos = Vector(100,0,40)
ENT.ElevatorPos = Vector(-300,0,40)
ENT.RudderPos = Vector(-300,0,40)

ENT.MaxVelocity = 3000

ENT.MaxThrust = 28000

ENT.MaxTurnPitch = 1200
ENT.MaxTurnYaw = 1400
ENT.MaxTurnRoll = 1000

ENT.MaxPerfVelocity = 1500

ENT.MaxHealth = 550
ENT.MaxShield = 150

ENT.Stability = 0.7

ENT.VerticalTakeoff = true
ENT.VtolAllowInputBelowThrottle = 12
ENT.MaxThrustVtol = 12000

ENT.MaxPrimaryAmmo = 2000