--DO NOT EDIT OR REUPLOAD THIS FILE

ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript" )

ENT.PrintName = "Light Assault Cruiser (Besh Refit)"
ENT.Author = "Nashatok"
ENT.Information = ""
ENT.Category = "[LFS] Star Wars"

ENT.Spawnable		= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/sweaw/ships/rep_corvette_2nd_servius.mdl"

ENT.AITEAM = 2

ENT.Mass = 5000
ENT.Inertia = Vector(600000,600000,600000)
ENT.Drag = 1

ENT.HideDriver = true
ENT.SeatPos = Vector(-100,20,300)
ENT.SeatAng = Angle(0,-90,0)

ENT.IdleRPM = 1
ENT.MaxRPM = 2800
ENT.LimitRPM = 3600

ENT.RotorPos = Vector(550,20,250)
ENT.WingPos = Vector(-200,20,280)
ENT.ElevatorPos = Vector(-700,20,0)
ENT.RudderPos = Vector(-700,20,0)

ENT.MaxVelocity = 2900

ENT.MaxThrust = 50000

ENT.MaxTurnPitch = 800
ENT.MaxTurnYaw = 1200
ENT.MaxTurnRoll = 900

ENT.MaxPerfVelocity = 2400

ENT.MaxHealth = 12000
ENT.MaxShield = 3000

ENT.Stability = 0.7

ENT.VerticalTakeoff = true
ENT.VtolAllowInputBelowThrottle = 15
ENT.MaxThrustVtol = 12000