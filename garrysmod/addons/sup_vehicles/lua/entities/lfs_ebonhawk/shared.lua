--DO NOT EDIT OR REUPLOAD THIS FILE

ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript" )

ENT.PrintName = "Dynamic-class Freighter"
ENT.Author = "Nashatok"
ENT.Information = ""
ENT.Category = "[LFS] Star Wars"

ENT.Spawnable		= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/ehawk/ehawk1.mdl"

ENT.AITEAM = 2

ENT.Mass = 5000
ENT.Inertia = Vector(600000,600000,600000)
ENT.Drag = 1

ENT.HideDriver = true
ENT.SeatPos = Vector(-100,0,120)
ENT.SeatAng = Angle(0,-90,0)

ENT.IdleRPM = 1
ENT.MaxRPM = 2400
ENT.LimitRPM = 3000

ENT.RotorPos = Vector(125,0,100)
ENT.WingPos = Vector(100,0,100)
ENT.ElevatorPos = Vector(-300,0,100)
ENT.RudderPos = Vector(-300,0,100)

ENT.MaxVelocity = 2500
ENT.MaxPerfVelocity = 1500

ENT.MaxThrust = 50000

ENT.MaxTurnPitch = 700
ENT.MaxTurnYaw = 900
ENT.MaxTurnRoll = 400

ENT.MaxHealth = 7000

ENT.Stability = 0.7

ENT.VerticalTakeoff = true
ENT.VtolAllowInputBelowThrottle = 15
ENT.MaxThrustVtol = 12000

ENT.MaxPrimaryAmmo = 1600

sound.Add( {
	name = "EHAWK_FIRE",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 125,
	pitch = {75, 95},
	sound = "lfs/vulturedroid/fire.mp3"
} )

sound.Add( {
	name = "EHAWK_FIRE2",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 125,
	pitch = {85, 95},
	sound = "lfs/vulturedroid/fire.mp3"
} )


sound.Add( {
	name = "EHAWK_ENGINE",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 150,
	sound = "^lfs/eng_jedistarfighter_hi_lp.wav"
} )

sound.Add( {
	name = "EHAWK_DIST",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 150,
	sound = "^lfs/eng_jedistarfighter_mid_lp.wav"
} )

sound.Add( {
	name = "EHAWK_BOOST",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "lfs/vulturedroid/boost.wav"
} )

sound.Add( {
	name = "EHAWK_BRAKE",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "lfs/arc170/brake.wav"
} )