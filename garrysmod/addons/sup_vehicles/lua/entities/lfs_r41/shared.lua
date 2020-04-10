--DO NOT EDIT OR REUPLOAD THIS FILE

ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript" )

ENT.PrintName = "R-41 Starchaser"
ENT.Author = "Nashatok"
ENT.Information = ""
ENT.Category = "[LFS] Star Wars"

ENT.Spawnable		= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/sfp_r41/sfp_r41.mdl"

ENT.AITEAM = 2

ENT.Mass = 3000
ENT.Inertia = Vector(250000,250000,250000)
ENT.Drag = 1

ENT.HideDriver = true
ENT.SeatPos = Vector(30,-5,65)
ENT.SeatAng = Angle(0,-90,0)

ENT.IdleRPM = 1
ENT.MaxRPM = 2800
ENT.LimitRPM = 3000

ENT.RotorPos = Vector(100,-5,65)
ENT.WingPos = Vector(100,-5,20)
ENT.ElevatorPos = Vector(-200,-5,20)
ENT.RudderPos = Vector(-200,-5,20)

ENT.MaxVelocity = 3000

ENT.MaxThrust = 28000

ENT.MaxTurnPitch = 400
ENT.MaxTurnYaw = 600
ENT.MaxTurnRoll = 350

ENT.MaxPerfVelocity = 1500

ENT.MaxHealth = 500
ENT.MaxShield = 300

ENT.Stability = 0.7

ENT.VerticalTakeoff = true
ENT.VtolAllowInputBelowThrottle = 12
ENT.MaxThrustVtol = 12000

ENT.MaxPrimaryAmmo = 1500
ENT.MaxSecondaryAmmo = 1500

sound.Add( {
	name = "R41_FIRE",
	channel = CHAN_ITEM,
	volume = 1.0,
	level = 125,
	pitch = {95, 105},
	sound = "lfs/wpn_jediStrftr_blaster_fire.wav"
} )

sound.Add( {
	name = "R41_FIRE2",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 125,
	pitch = {95, 105},
	sound = "lfs/wpn_atst_chinBlaster_fire.wav"
} )

sound.Add( {
	name = "R41_ENGINE",
	channel = CHAN_STATIC,
	volume = 1.5,
	level = 125,
	sound = "lfs/eng_jedistarfighter_hi_lp.wav"
} )

sound.Add( {
	name = "R41_DIST",
	channel = CHAN_STATIC,
	volume = 1.5,
	level = 125,
	sound = "lfs/eng_jedistarfighter_mid_lp.wav"
} )
