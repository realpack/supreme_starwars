--DO NOT EDIT OR REUPLOAD THIS FILE

ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript" )

ENT.PrintName = "Mandalorian Gauntlet"
ENT.Author = "Nashatok"
ENT.Information = ""
ENT.Category = "[LFS] Star Wars"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/sfp_gauntlet/sfp_gauntlet.mdl"

ENT.AITEAM = 1

ENT.Mass = 5000
ENT.Inertia = Vector(400000,400000,400000)
ENT.Drag = 1

ENT.HideDriver = true
ENT.SeatPos = Vector(-180,0,180)
ENT.SeatAng = Angle(0,-90,0)

ENT.IdleRPM = 1
ENT.MaxRPM = 2600
ENT.LimitRPM = 3200

ENT.RotorPos = Vector(225,0,180)
ENT.WingPos = Vector(50,0,50)
ENT.ElevatorPos = Vector(-500,0,50)
ENT.RudderPos = Vector(-500,0,50)

ENT.MaxVelocity = 3000

ENT.MaxThrust = 50000

ENT.MaxTurnPitch = 800
ENT.MaxTurnYaw = 1200
ENT.MaxTurnRoll = 300

ENT.MaxPerfVelocity = 2500

ENT.MaxHealth = 2500
ENT.MaxShield = 200

ENT.Stability = 0.7

ENT.VerticalTakeoff = true
ENT.VtolAllowInputBelowThrottle = 10
ENT.MaxThrustVtol = 12000

ENT.MaxPrimaryAmmo = 1000
ENT.MaxSecondaryAmmo = 6


sound.Add( {
	name = "Z95_FIRE",
	channel = CHAN_STREAM,
	volume = 1.0,
	level = 125,
	pitch = {85, 95},
	sound = "lfs/wpn_xwing_blaster_fire.wav"
} )

sound.Add( {
	name = "Z95_FIRE2",
	channel = CHAN_ITEM,
	volume = 1.0,
	level = 125,
	pitch = {95, 105},
	sound = "lfs/Proton Torpedo 5B.wav"
} )

sound.Add( {
	name = "Z95_ENGINE",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "lfs/eng_jedistarfighter_hi_lp.wav"
} )

sound.Add( {
	name = "Z95_DIST",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "lfs/eng_jedistarfighter_mid_lp.wav"
} )

sound.Add( {
	name = "Z95_BOOST",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "lfs/w_wing_by_1.wav"
} )

sound.Add( {
	name = "Z95_BRAKE",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "lfs/w_wing_by_2.wav"
} )