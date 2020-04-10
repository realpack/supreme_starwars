--DO NOT EDIT OR REUPLOAD THIS FILE

ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript" )

ENT.PrintName = "Z-95 Headhunter"
ENT.Author = "Nashatok"
ENT.Information = ""
ENT.Category = "[LFS] Star Wars"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/z95/z951.mdl"

ENT.AITEAM = 2

ENT.Mass = 5000
ENT.Inertia = Vector(400000,400000,400000)
ENT.Drag = 1

ENT.HideDriver = true
ENT.SeatPos = Vector(0,0,60)
ENT.SeatAng = Angle(0,-90,0)

ENT.IdleRPM = 1
ENT.MaxRPM = 2600
ENT.LimitRPM = 3200

ENT.RotorPos = Vector(225,0,60)
ENT.WingPos = Vector(50,0,30)
ENT.ElevatorPos = Vector(-200,0,30)
ENT.RudderPos = Vector(-200,0,30)

ENT.MaxVelocity = 2000

ENT.MaxThrust = 50000

ENT.MaxTurnPitch = 500
ENT.MaxTurnYaw = 600
ENT.MaxTurnRoll = 300

ENT.MaxPerfVelocity = 1500

ENT.MaxHealth = 850
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