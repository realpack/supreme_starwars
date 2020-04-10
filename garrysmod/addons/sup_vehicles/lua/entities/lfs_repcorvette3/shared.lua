--DO NOT EDIT OR REUPLOAD THIS FILE

ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript" )

ENT.PrintName = "Light Assault Cruiser (Cresh Refit)"
ENT.Author = "Nashatok"
ENT.Information = ""
ENT.Category = "[LFS] Star Wars"

ENT.Spawnable		= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/sweaw/ships/rep_corvette_3rd_servius.mdl"

ENT.AITEAM = 2

ENT.Mass = 4000
ENT.Inertia = Vector(600000,600000,600000)
ENT.Drag = 1

ENT.HideDriver = true
ENT.SeatPos = Vector(200,100,200)
ENT.SeatAng = Angle(0,-90,0)

ENT.IdleRPM = 1
ENT.MaxRPM = 2400
ENT.LimitRPM = 3600

ENT.RotorPos = Vector(450,100,200)
ENT.WingPos = Vector(200,100,190)
ENT.ElevatorPos = Vector(-500,100,10)
ENT.RudderPos = Vector(-900,100,10)

ENT.MaxVelocity = 2500

ENT.MaxThrust = 50000

ENT.MaxTurnPitch = 1200
ENT.MaxTurnYaw = 1400
ENT.MaxTurnRoll = 400

ENT.MaxPerfVelocity = 1800

ENT.MaxHealth = 12000
ENT.MaxShield = 3000

ENT.Stability = 0.7

ENT.VerticalTakeoff = true
ENT.VtolAllowInputBelowThrottle = 15
ENT.MaxThrustVtol = 12000