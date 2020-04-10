--NO U

ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript" )

ENT.PrintName = "W-Wing Starfighter"
ENT.Author = "Nashatok"
ENT.Information = ""
ENT.Category = "[LFS] Star Wars"

ENT.Spawnable		= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/sweaw/ships/rep_w-wing.mdl"

ENT.AITEAM = 2

ENT.Mass = 2000
ENT.Inertia = Vector(250000,250000,250000)
ENT.Drag = 1

ENT.HideDriver = true
ENT.SeatPos = Vector(30,0,30)
ENT.SeatAng = Angle(0,-90,0)

ENT.IdleRPM = 1
ENT.MaxRPM = 2800
ENT.LimitRPM = 3000

ENT.RotorPos = Vector(225,0,0)
ENT.WingPos = Vector(100,0,0)
ENT.ElevatorPos = Vector(-300,0,0)
ENT.RudderPos = Vector(-300,0,0)

ENT.MaxVelocity = 3000

ENT.MaxThrust = 28000

ENT.MaxTurnPitch = 800
ENT.MaxTurnYaw = 1200
ENT.MaxTurnRoll = 600

ENT.MaxPerfVelocity = 1500

ENT.MaxHealth = 450
ENT.MaxShield = 300

ENT.Stability = 0.7

ENT.VerticalTakeoff = true
ENT.VtolAllowInputBelowThrottle = 12
ENT.MaxThrustVtol = 12000

ENT.MaxPrimaryAmmo = 2000

sound.Add( {
	name = "WWING_FIRE",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 125,
	pitch = {95, 105},
	sound = "lfs/wpn_xwing_blaster_fire.wav"
} )

sound.Add( {
	name = "WWING_FIRE2",
	channel = CHAN_ITEM,
	volume = 1.0,
	level = 125,
	pitch = {95, 105},
	sound = "lfs/wpn_jediStrftr_blaster_fire.wav"
} )

sound.Add( {
	name = "WWING_ENGINE",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "lfs/eng_jedistarfighter_hi_lp.wav"
} )

sound.Add( {
	name = "WWING_DIST",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "lfs/eng_jedistarfighter_mid_lp.wav"
} )

sound.Add( {
	name = "WWING_BOOST",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "lfs/w_wing_by_1.wav"
} )

sound.Add( {
	name = "WWING_BRAKE",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "lfs/w_wing_by_2.wav"
} )
