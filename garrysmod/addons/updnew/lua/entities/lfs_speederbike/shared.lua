ENT.Type = "anim"
DEFINE_BASECLASS( "heracles421_lfs_base" )

ENT.PrintName = "Speeder Bike"
ENT.Author = "Ranz"
ENT.Information = ""
ENT.Category = "[LFS] Multiverse Gaming"

ENT.Spawnable		= true
ENT.AdminSpawnable	= false

ENT.RotorPos = Vector(30,0,40)

ENT.MDL = "models/mvg/ranz/speederbike/speederbike.mdl"
ENT.GibModels = {
	"models/xqm/deg45single.mdl",
	"models/xqm/quad1.mdl",
	"models/xqm/jetenginepropeller.mdl",
	"models/xqm/pistontype1.mdl",
}

ENT.SeatPos = Vector(-25,0,24)
--ENT.SeatPos = Vector(-25,0,20)
ENT.SeatAng = Angle(0,-90,0)

ENT.MaxHealth = 1000
ENT.LevelForceMultiplier = 1000
ENT.LevelRotationMultiplier = 3
ENT.MoveSpeed = 700
ENT.BoostSpeed = 875
ENT.TurnRateMultiplier = 6
ENT.HeightOffset = 10
ENT.IgnoreWater = false
ENT.MaxPrimaryAmmo = 250

sound.Add( {
	name = "SPEEDERBIKE_ENGINE",
	channel = CHAN_STATIC,
	volume = 3.0,
	level = 125,
	sound = "lfs/speederbike/speederbike_engine.wav"
} )