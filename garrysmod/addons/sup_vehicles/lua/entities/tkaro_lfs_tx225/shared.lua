ENT.Type            = "anim"
DEFINE_BASECLASS( "heracles421_lfs_base" )

ENT.PrintName = "TX-225"
ENT.Author = "Tkaro"
ENT.Information = ""
ENT.Category = "[LFS] Star Wars"

ENT.Spawnable		= true
ENT.AdminSpawnable	= false

ENT.RotorPos = Vector(30,0,40)

ENT.MDL = "models/tkaro/starwars/vehicle/empire/tx225.mdl"

ENT.GibModels = {
	"models/props_c17/TrapPropeller_Engine.mdl",
	"models/props_junk/Shoe001a.mdl",
    "models/tkaro/starwars/vehicle/empire/tx225.mdl"
}

ENT.AITEAM = 1
ENT.MaxPrimaryAmmo = 1500
ENT.MaxSecondaryAmmo = 24

ENT.Mass = 5000

ENT.HideDriver = true

ENT.SeatPos = Vector(33,0,33)
--ENT.SeatPos = Vector(-25,0,20)
ENT.SeatAng = Angle(0,-90,0)

ENT.MaxHealth = 5000
ENT.MoveSpeed = 100
ENT.BoostSpeed = 130
ENT.LerpMultiplier = 0.8
ENT.HeightOffset = 7
ENT.IgnoreWater = false

sound.Add( {
	name = "TX225_FIRE1",
	channel = CHAN_WEAPON,
	volume = 0.6,
	level = 125,
	pitch = {95, 105},
	sound = "tx225/fire1.wav"
} )

sound.Add( {
	name = "TX225_ENGINE",
	channel = CHAN_STATIC,
	volume = 0.7,
	level = 120,
	sound = "ambient/machines/train_idle.wav"
} )

sound.Add( {
	name = "TX225_FIRE2",
	channel = CHAN_ITEM,
	volume = 1.0,
	level = 90,
	pitch = 100,
	sound = "tx225/fire2.wav"
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