--DO NOT EDIT OR REUPLOAD THIS FILE

ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript" )

ENT.PrintName = "[CGI] Hyena-class Bomber"
ENT.Author = "Lightning Bolt"
ENT.Information = ""
ENT.Category = "[LFS] Star Wars"

ENT.Spawnable		= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/props/hyena/cgihyena.mdl"

ENT.GibModels = {
	"models/XQM/wingpiece2.mdl",
	"models/XQM/wingpiece2.mdl",
	"models/XQM/jetwing2medium.mdl",
	"models/XQM/jetwing2medium.mdl",
	"models/props_junk/Shoe001a.mdl",
	"models/XQM/jetbody2fuselage.mdl",
	"models/XQM/jettailpiece1medium.mdl",
	"models/XQM/pistontype1huge.mdl",
}

ENT.AITEAM = 1

ENT.Mass = 2000
ENT.Inertia = Vector(150000,150000,150000)
ENT.Drag = -1

ENT.HideDriver = true
ENT.SeatPos = Vector(-20,45,0)
ENT.SeatAng = Angle(0,-90,0)

ENT.IdleRPM = 0
ENT.MaxRPM = 2800
ENT.LimitRPM = 3000

ENT.RotorPos = Vector(68.18,8.71,0)
ENT.WingPos = Vector(128.18,8.71,0)
ENT.ElevatorPos = Vector(-328,8.71,0)
ENT.RudderPos = Vector(-328,8.71,0)

ENT.MaxVelocity = 2150

ENT.MaxThrust = 20000

ENT.MaxTurnPitch = 1000
ENT.MaxTurnYaw = 1500
ENT.MaxTurnRoll = 400

ENT.MaxPerfVelocity = 1500

ENT.MaxHealth = 850

ENT.Stability = 0.7

ENT.VerticalTakeoff = true
ENT.MaxThrustVtol = 10000

ENT.MaxPrimaryAmmo = 3000
ENT.MaxSecondaryAmmo = 400

sound.Add( {
	name = "HYENA_FIRE",
	channel = CHAN_WEAPON,
	volume = 0.5,
	level = 125,
	pitch = {95, 105},
	sound = "lfs/hyenabomber/Cannons_VultureDroidTwinLaser_Laser_Close_VAR_04.wav"
} )

sound.Add( {
	name = "HYENA_FIRE2",
	channel = CHAN_ITEM,
	volume = 0.4,
	level = 125,
	pitch = {100, 100},
	sound = "lfs/hyenabomber/Explosive_EnergyTorpedo_Laser_Close_VAR_01.wav"
} )

sound.Add( {
	name = "HYENA_DIST_A",
	channel = CHAN_STATIC,
	volume = 0.68,
	level = 125,
	sound = "^lfs/hyenabomber/HyenaBomber_Front_Close_01.wav"
} )

sound.Add( {
	name = "HYENA_DIST_B",
	channel = CHAN_STATIC,
	volume = 0.68,
	level = 125,
	sound = "^lfs/hyenabomber/HyenaBomber_Rear_Close_01.wav"
} )

sound.Add( {
	name = "HYENA_BOOST",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "lfs/hyenabomber/HyenaBomber_Bys_02.wav"
} )
