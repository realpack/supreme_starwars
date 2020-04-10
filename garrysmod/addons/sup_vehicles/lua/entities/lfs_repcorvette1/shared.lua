--DO NOT EDIT OR REUPLOAD THIS FILE

ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript" )

ENT.PrintName = "Consular-class Cruiser"
ENT.Author = "Nashatok"
ENT.Information = ""
ENT.Category = "[LFS] Star Wars"

ENT.Spawnable		= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/sweaw/ships/rep_corvette_1st_servius.mdl"

ENT.AITEAM = 2

ENT.Mass = 5000
ENT.Inertia = Vector(600000,600000,600000)
ENT.Drag = 1

ENT.HideDriver = true
ENT.SeatPos = Vector(-100,50,200)
ENT.SeatAng = Angle(0,-90,0)

ENT.IdleRPM = 1
ENT.MaxRPM = 2400
ENT.LimitRPM = 3600

ENT.RotorPos = Vector(350,50,200)
ENT.WingPos = Vector(0,50,180)
ENT.ElevatorPos = Vector(-500,50,00)
ENT.RudderPos = Vector(-900,50,00)

ENT.MaxVelocity = 3200

ENT.MaxThrust = 50000

ENT.MaxTurnPitch = 1100
ENT.MaxTurnYaw = 1400
ENT.MaxTurnRoll = 900

ENT.MaxPerfVelocity = 2800

ENT.MaxHealth = 12000
ENT.MaxShield = 3000

ENT.Stability = 0.7

ENT.VerticalTakeoff = true
ENT.VtolAllowInputBelowThrottle = 15
ENT.MaxThrustVtol = 12000

ENT.MaxSecondaryAmmo = 32

sound.Add( {
	name = "CONSULAR_FIRE",
	channel = CHAN_WEAPON,
	volume = 0.8,
	level = 125,
	pitch = {95, 105},
	sound = "lfs/wpn_tie_fighter_1.wav"
} )

sound.Add( {
	name = "CONSULAR_FIRE2",
	channel = CHAN_WEAPON,
	volume = 0.8,
	level = 125,
	pitch = {80, 95},
	sound = "lfs/trifighter/fire2.mp3"
} )

sound.Add( {
	name = "CONSULAR_BOOST",
	channel = CHAN_WEAPON,
	volume = 0.8,
	level = 125,
	pitch = {80, 95},
	sound = "lfs/w_wing_by_1.wav"
} )

sound.Add( {
	name = "CONSULAR_BRAKE",
	channel = CHAN_WEAPON,
	volume = 0.8,
	level = 125,
	pitch = {80, 95},
	sound = "lfs/naboo_n1_starfighter/brake.wav"
} )