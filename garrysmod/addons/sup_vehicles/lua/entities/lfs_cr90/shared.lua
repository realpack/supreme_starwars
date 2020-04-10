--DO NOT EDIT OR REUPLOAD THIS FILE

ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript" )

ENT.PrintName = "CR-90 Blockade Runner"
ENT.Author = "Nashatok"
ENT.Information = ""
ENT.Category = "[LFS] Star Wars"

ENT.Spawnable		= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/swbf3/vehicles/reb_corvette90_servius.mdl"

ENT.AITEAM = 2

ENT.Mass = 4000
ENT.Inertia = Vector(400000,400000,400000)
ENT.Drag = 1

ENT.HideDriver = true
ENT.SeatPos = Vector(150,0,200)
ENT.SeatAng = Angle(0,-90,0)

ENT.IdleRPM = 1
ENT.MaxRPM = 2800
ENT.LimitRPM = 3600

ENT.RotorPos = Vector(200,0,260)
ENT.WingPos = Vector(0,0,150)
ENT.ElevatorPos = Vector(-300,0,100)
ENT.RudderPos = Vector(-300,0,100)

ENT.MaxVelocity = 2900

ENT.MaxThrust = 50000

ENT.MaxTurnPitch = 800
ENT.MaxTurnYaw = 1200
ENT.MaxTurnRoll = 400

ENT.MaxPerfVelocity = 2400

ENT.MaxHealth = 12000
ENT.MaxShield = 3000

ENT.Stability = 0.7

ENT.VerticalTakeoff = true
ENT.VtolAllowInputBelowThrottle = 15
ENT.MaxThrustVtol = 12000

ENT.MaxPrimaryAmmo = 1500

sound.Add( {
	name = "CR90_FIRE",
	channel = CHAN_WEAPON,
	volume = 0.8,
	level = 125,
	pitch = {100, 110},
	sound = "lfs/wpn_xwing_blaster_fire.wav"
} )

sound.Add( {
	name = "CR90_FIRE2",
	channel = CHAN_WEAPON,
	volume = 0.8,
	level = 125,
	pitch = {80, 95},
	sound = "lfs/wpn_xwing_blaster_fire.wav"
} )