ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript" )

ENT.PrintName = "HMP Droid Gunship"
ENT.Author = "Lightning Bolt"
ENT.Information = ""
ENT.Category = "[LFS] Star Wars"

ENT.Spawnable		= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/syphadias/starwars/gunship.mdl"

ENT.GibModels = {
	"models/XQM/wingpiece2.mdl",
	"models/XQM/wingpiece2.mdl",
	"models/XQM/jetwing2medium.mdl",
	"models/XQM/jetwing2medium.mdl",
	"models/props_c17/TrapPropeller_Engine.mdl",
	"models/props_junk/Shoe001a.mdl",
	"models/XQM/jetbody2fuselage.mdl",
	"models/XQM/jettailpiece1medium.mdl",
	"models/XQM/pistontype1huge.mdl",
}

ENT.AITEAM = 1

ENT.Mass = 5000
ENT.Inertia = Vector(400000,400000,400000)
ENT.Drag = -1

ENT.SeatPos = Vector(440,-0.4,-105)
ENT.SeatAng = Angle(0,-90,0)

ENT.IdleRPM = 0
ENT.MaxRPM = 3000
ENT.LimitRPM = 3400
ENT.RPMThrottleIncrement = 1300 

ENT.RotorPos = Vector(276.44,-0,154.28)
ENT.WingPos = Vector(21.91,0,91.49)
ENT.ElevatorPos = Vector(-460.309,0,91.49)
ENT.RudderPos = Vector(-460.309,0,91.49)

ENT.MaxVelocity = 3200

ENT.MaxThrust = 40000

ENT.MaxTurnPitch = 850
ENT.MaxTurnYaw = 1000
ENT.MaxTurnRoll = 160

ENT.MaxPerfVelocity = 1500

ENT.MaxHealth = 3000
ENT.MaxShield = 3000

ENT.Stability = 0.7

ENT.VerticalTakeoff = true
ENT.MaxThrustVtol = 12000

ENT.MaxPrimaryAmmo = 3000
ENT.MaxSecondaryAmmo = 1500

sound.Add( {
	name = "DGS_FIRE",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 125,
	pitch = {90, 90},
	sound = "lfs/droidgunship/droidgs_shoot.wav"
} )

sound.Add( {
	name = "DGS_FIRE2",
	channel = CHAN_ITEM,
	volume = 1.0,
	level = 125,
	pitch = {95, 105},
    sound = "lfs/droidgunship/rockets/rocket_ignite.wav"
} )

sound.Add( {
	name = "DGS_ENGINE",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "lfs/droidgunship/droidgs_fly.wav"
} )

sound.Add( {
	name = "DGS_DIST",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "lfs/droidgunship/droidgs_dist.wav"
} )

sound.Add( {
	name = "DGS_BOOST",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "lfs/droidgunship/droidgs_boost.wav"
} )

sound.Add( {
	name = "DGS_BRAKE",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "lfs/droidgunship/brake.wav"
} )