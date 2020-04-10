ENT.Type            = "anim"
DEFINE_BASECLASS( "heracles421_lfs_base" )

ENT.PrintName = "TX-130"
ENT.Author = "Tkaro"
ENT.Information = ""
ENT.Category = "[LFS] Star Wars"

ENT.Spawnable		= true
ENT.AdminSpawnable	= false

ENT.RotorPos = Vector(30,0,40)

ENT.MDL = "models/tkaro/starwars/vehicle/republic/tx130.mdl"

ENT.GibModels = {
	"models/props_c17/TrapPropeller_Engine.mdl",
	"models/props_junk/Shoe001a.mdl",
	"models/tkaro/starwars/vehicle/republic/gibs/tx130_gib1.mdl",
    "models/tkaro/starwars/vehicle/republic/gibs/tx130_gib2.mdl",
	"models/tkaro/starwars/vehicle/republic/gibs/tx130_gib3.mdl",
	"models/tkaro/starwars/vehicle/republic/gibs/tx130_gib4.mdl",
	"models/tkaro/starwars/vehicle/republic/gibs/tx130_gib5.mdl",
	"models/tkaro/starwars/vehicle/republic/gibs/tx130_gib6.mdl",
	"models/tkaro/starwars/vehicle/republic/gibs/tx130_gib7.mdl",
}

ENT.AITEAM = 2
ENT.MaxPrimaryAmmo = 1500
ENT.MaxSecondaryAmmo = 24

ENT.Mass = 5000

ENT.HideDriver = true

ENT.SeatPos = Vector(0,0,33)
--ENT.SeatPos = Vector(-25,0,20)
ENT.SeatAng = Angle(0,-90,0)

ENT.MaxHealth = 6000
ENT.MoveSpeed = 180
ENT.BoostSpeed = 300
ENT.LerpMultiplier = 0.8
ENT.HeightOffset = 7
ENT.IgnoreWater = false

sound.Add( {
	name = "TX_FIRE",
	channel = CHAN_WEAPON,
	volume = 0.6,
	level = 125,
	pitch = {95, 105},
	sound = "lfs/tx130/twincannonlaser.wav"
} )

sound.Add( {
	name = "TX_ENGINE",
	channel = CHAN_STATIC,
	volume = 1.1,
	level = 120,
	sound = "lfs/tx130/engine.wav"
} )

sound.Add( {
	name = "TX_ROCKET",
	channel = CHAN_ITEM,
	volume = 1.0,
	level = 90,
	pitch = 100,
	sound = "lfs/tx130/rocket.wav"
} )

sound.Add( {
	name = "TX_ROCKETPODS",
	channel = CHAN_ITEM,
	volume = 1.0,
	level = 90,
	pitch = 100,
	sound = "lfs/tx130/rocketpods.wav"
} )

ENT.ShadowParams = {
	secondstoarrive		= 0.5,
	maxangular			= 25,
	maxangulardamp		= 100000,
	maxspeed			= 1000000,
	maxspeeddamp		= 500000,
	dampfactor			= 1,
	teleportdistance	= 0,
}

ENT.EntityFilter = {
["lunasflightschool_droidgunship_missile"] = true
}