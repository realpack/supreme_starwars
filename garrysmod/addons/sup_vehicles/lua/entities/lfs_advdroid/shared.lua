--DO NOT EDIT OR REUPLOAD THIS FILE

ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript" )

ENT.PrintName = "Advanced Bomber - Cluster"
ENT.Author = "Nashatok"
ENT.Information = "An automated bomber developed by the Trade Federation"
ENT.Category = "[LFS] Star Wars"

ENT.Spawnable		= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/sfp_droidbomber/sfp_droidbomber.mdl"

ENT.AITEAM = 1

ENT.Mass = 5000
ENT.Inertia = Vector(400000,400000,400000)
ENT.Drag = 1

ENT.HideDriver = true
ENT.SeatPos = Vector(10,0,55)
ENT.SeatAng = Angle(0,-90,0)

ENT.IdleRPM = 1
ENT.MaxRPM = 2600
ENT.LimitRPM = 2880

ENT.RotorPos = Vector(225,0,55)
ENT.WingPos = Vector(100,0,55)
ENT.ElevatorPos = Vector(-200,0,55)
ENT.RudderPos = Vector(-200,0,55)

ENT.MaxVelocity = 2800

ENT.MaxThrust = 50000

ENT.MaxTurnPitch = 800
ENT.MaxTurnYaw = 1000
ENT.MaxTurnRoll = 900

ENT.MaxPerfVelocity = 2100

ENT.MaxHealth = 1500
ENT.MaxShield = 250

ENT.Stability = 0.7

ENT.VerticalTakeoff = true
ENT.VtolAllowInputBelowThrottle = 10
ENT.MaxThrustVtol = 8000

ENT.MaxPrimaryAmmo = 1600
ENT.MaxSecondaryAmmo = 64

sound.Add( {
	name = "ADVDROID_FIRE",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 125,
	pitch = {75, 95},
	sound = "lfs/vulturedroid/fire.wav"
} )


sound.Add( {
	name = "ADVDROID_ENGINE",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "^lfs/vulturedroid/loop.wav"
} )

sound.Add( {
	name = "ADVDROID_DIST",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "^lfs/vulturedroid/dist.wav"
} )

sound.Add( {
	name = "ADVDROID_BOOST",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "lfs/vulturedroid/boost.wav"
} )

sound.Add( {
	name = "ADVDROID_BRAKE",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "lfs/vulturedroid/brake.wav"
} )