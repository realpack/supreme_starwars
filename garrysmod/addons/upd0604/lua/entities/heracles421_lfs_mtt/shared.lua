ENT.Type            = "anim"
DEFINE_BASECLASS( "heracles421_lfs_base" )

ENT.PrintName = "MTT"
ENT.Author = "Heracles421"
ENT.Information = ""
ENT.Category = "[LFS] Galactica Networks"

ENT.Spawnable		= true
ENT.AdminSpawnable	= false
ENT.AITEAM = 1

ENT.RotorPos = Vector(323,0,310)

ENT.MDL = "models/heracles421/galactica_vehicles/mtt.mdl"
ENT.GibModels = {
	"models/heracles421/galactica_vehicles/mtt.mdl",
}

ENT.MaxPrimaryAmmo = 1500

ENT.Mass = 20000

ENT.SeatPos = Vector(320,0,300)
--ENT.SeatPos = Vector(-25,0,20)
ENT.SeatAng = Angle(0,-90,0)

ENT.MaxHealth = 50000
ENT.MoveSpeed = 100
ENT.BoostSpeed = 150
ENT.LerpMultiplier = 0.5
ENT.HeightOffset = -10
ENT.TraceDistance = 200
ENT.IgnoreWater = false
ENT.HideDriver = true
ENT.AutomaticFrameAdvance = true

sound.Add( {
	name = "GALACTICA_MTT_FIRE",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 125,
	pitch = {65, 85},
	sound = "heracles421/galactica_vehicles/mtt_sideguns_fire.mp3"
} )

sound.Add( {
	name = "GALACTICA_MTT_ENGINE",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 120,
	pitch = 85,
	sound = "heracles421/galactica_vehicles/mtt_engine.wav"
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
