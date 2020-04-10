--DO NOT EDIT OR REUPLOAD THIS FILE

ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript" )

ENT.PrintName = "Skipray Blastboat"
ENT.Author = "Nashatok"
ENT.Information = ""
ENT.Category = "[LFS] Star Wars"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/skipray/skipray1.mdl"

ENT.AITEAM = 1

ENT.Mass = 10000
ENT.Inertia = Vector(600000,600000,600000)
ENT.Drag = 1

ENT.HideDriver = true
ENT.SeatPos = Vector(180,0,80)
ENT.SeatAng = Angle(0,-90,0)

ENT.IdleRPM = 1
ENT.MaxRPM = 2600
ENT.LimitRPM = 3200

ENT.RotorPos = Vector(225,0,60)
ENT.WingPos = Vector(50,0,30)
ENT.ElevatorPos = Vector(-200,0,30)
ENT.RudderPos = Vector(-200,0,30)

ENT.MaxVelocity = 2600

ENT.MaxThrust = 20000

ENT.MaxTurnPitch = 500
ENT.MaxTurnYaw = 600
ENT.MaxTurnRoll = 300

ENT.MaxPerfVelocity = 2000

ENT.MaxHealth = 1250
ENT.MaxShield = 400

ENT.Stability = 0.7

ENT.VerticalTakeoff = true
ENT.VtolAllowInputBelowThrottle = 10
ENT.MaxThrustVtol = 12000

ENT.MaxPrimaryAmmo = 1200
ENT.MaxSecondaryAmmo = 18