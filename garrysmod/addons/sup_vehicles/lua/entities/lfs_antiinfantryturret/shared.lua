--DO NOT EDIT OR REUPLOAD THIS FILE

ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript" )

ENT.PrintName = "Anti-Infantry Turret"
ENT.Author = "Nashatok"
ENT.Information = ""
ENT.Category = "[LFS] Star Wars"

ENT.Spawnable		= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/swbf3/turrets/rep_anti-infantryturret.mdl"

ENT.AITEAM = 2

ENT.Mass = 5000
ENT.Inertia = Vector(600000,600000,600000)
ENT.Drag = 1

ENT.HideDriver = true
ENT.SeatPos = Vector(0,0,50)
ENT.SeatAng = Angle(0,-90,0)

ENT.IdleRPM = 1
ENT.MaxRPM = 10
ENT.LimitRPM = 20

ENT.RotorPos = Vector(0,0,70)
ENT.WingPos = Vector(0,0,20)
ENT.ElevatorPos = Vector(0,0,20)
ENT.RudderPos = Vector(0,0,20)

ENT.MaxVelocity = 10

ENT.MaxThrust = 10

ENT.MaxTurnPitch = 0
ENT.MaxTurnYaw = 0
ENT.MaxTurnRoll = 0

ENT.MaxPerfVelocity = 10

ENT.MaxHealth = 3000

ENT.Stability = 0.7

ENT.MaxPrimaryAmmo = 1600

sound.Add( {
	name = "AI_FIRE",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 125,
	pitch = {75, 95},
	sound = "lfs/vulturedroid/fire.mp3"
} )