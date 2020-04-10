ENT.Type            = "anim"
DEFINE_BASECLASS( "heracles421_lfs_base" )

ENT.PrintName = "AAT"
ENT.Author = "Heracles421"
ENT.Information = ""
ENT.Category = "[LFS] Galactica Networks"

ENT.Spawnable		= true
ENT.AdminSpawnable	= false

ENT.RotorPos = Vector(80,0,70)

ENT.MDL = "models/heracles421/galactica_vehicles/aat.mdl"
ENT.GibModels = {
	"models/heracles421/galactica_vehicles/aat.mdl",
}

ENT.MaxPrimaryAmmo = 1000
ENT.MaxSecondaryAmmo = 54

ENT.Mass = 5000

ENT.SeatPos = Vector(120,0,80)
--ENT.SeatPos = Vector(-25,0,20)
ENT.SeatAng = Angle(0,-90,0)

ENT.MaxHealth = 20000
ENT.MoveSpeed = 60
ENT.BoostSpeed = 150
ENT.LerpMultiplier = 0.8
ENT.HeightOffset = -10
ENT.IgnoreWater = false
ENT.HideDriver = true

sound.Add( {
	name = "GALACTICA_AAT_FIRE",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 125,
	pitch = {95, 105},
	sound = "heracles421/galactica_vehicles/aat_sideguns_fire.mp3"
} )

sound.Add( {
	name = "GALACTICA_AAT_CANNONFIRE",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 125,
	pitch = {90, 110},
	sound = "heracles421/galactica_vehicles/aat_main_cannon_fire.mp3"
} )

sound.Add( {
	name = "GALACTICA_AAT_TORPEDOFIRE",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 90,
	pitch = 100,
	sound = "heracles421/galactica_vehicles/aat_torpedo.mp3"
} )

sound.Add( {
	name = "GALACTICA_AAT_CANNONRELOAD",
	channel = CHAN_ITEM,
	volume = 1.0,
	level = 90,
	pitch = 100,
	sound = "lfs/laatc_atte/overheat.mp3"
} )

sound.Add( {
	name = "GALACTICA_AAT_ENGINE",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 120,
	sound = "heracles421/galactica_vehicles/aat_engine.wav"
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