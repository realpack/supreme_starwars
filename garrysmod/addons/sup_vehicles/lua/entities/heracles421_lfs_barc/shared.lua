ENT.Type            = "anim"
DEFINE_BASECLASS( "heracles421_lfs_base" )

ENT.PrintName = "BARC"
ENT.Author = "Heracles421"
ENT.Information = ""
ENT.Category = "[LFS] Galactica Networks"

ENT.Spawnable		= true
ENT.AdminSpawnable	= false

ENT.RotorPos = Vector(30,0,40)

ENT.MDL = "models/heracles421/galactica_vehicles/barc.mdl"
ENT.GibModels = {
	"models/heracles421/galactica_vehicles/barc.mdl",
}

ENT.MaxPrimaryAmmo = 200

ENT.SeatPos = Vector(-25,0,40)
--ENT.SeatPos = Vector(-25,0,20)
ENT.SeatAng = Angle(0,-90,0)

ENT.MaxHealth = 2000
ENT.LevelForceMultiplier = 1000
ENT.LevelRotationMultiplier = 3
ENT.MoveSpeed = 400
ENT.BoostSpeed = 600
ENT.TurnRateMultiplier = 3
ENT.HeightOffset = -15
ENT.IgnoreWater = false

sound.Add( {
	name = "GALACTICA_BARC_FIRE",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 125,
	pitch = {95, 105},
	sound = "lfs/laatc_atte/fire.mp3"
} )

sound.Add( {
	name = "GALACTICA_BARC_ENGINE",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 120,
	sound = "heracles421/galactica_vehicles/barc_engine.wav"
} )