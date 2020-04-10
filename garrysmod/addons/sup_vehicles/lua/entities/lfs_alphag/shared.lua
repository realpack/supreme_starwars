ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript" )

ENT.PrintName = "Alpha-class XG-1 Star Wing"
ENT.Author = "Nashatok"
ENT.Information = ""
ENT.Category = "[LFS] Star Wars"

ENT.Spawnable		= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/sfp_alphag/sfp_alphag.mdl"

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

ENT.HideDriver = true
ENT.SeatPos = Vector(130,0,75)
ENT.SeatAng = Angle(0,-90,0)

ENT.IdleRPM = 1
ENT.MaxRPM = 2600
ENT.LimitRPM = 2880
ENT.RPMThrottleIncrement = 1300 

ENT.RotorPos = Vector(225,0,75)
ENT.WingPos = Vector(100,0,50)
ENT.ElevatorPos = Vector(-200,0,25)
ENT.RudderPos = Vector(-200,0,25)

ENT.MaxVelocity = 2200

ENT.MaxThrust = 50000

ENT.MaxTurnPitch = 600
ENT.MaxTurnYaw = 800
ENT.MaxTurnRoll = 400

ENT.MaxPerfVelocity = 1600

ENT.MaxHealth = 1200
ENT.MaxShield = 500

ENT.Stability = 0.7

ENT.VerticalTakeoff = true
--ENT.VtolAllowInputBelowThrottle = 12
ENT.MaxThrustVtol = 12000

ENT.MaxPrimaryAmmo = 1600
ENT.MaxSecondaryAmmo = 600

sound.Add( {
	name = "ALPHAG_FIRE2",
	channel = CHAN_ITEM,
	volume = 1.0,
	level = 125,
	pitch = {95, 105},
    sound = "lfs/droidgunship/rockets/rocket_ignite.wav"
} )