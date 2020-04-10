-- DO NOT EDIT OR REUPLOAD THIS FILE

ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript" )

ENT.PrintName = "H-6 Scurrg"
ENT.Author = "Nashatok"
ENT.Information = "A slow but powerful prototype bomber crewed by a Pilot and a single Gunner"
ENT.Category = "[LFS] Star Wars"

ENT.Spawnable		= true
ENT.AdminSpawnable	= false

ENT.MDL = "models/sweaw/ships/rep_havoc.mdl"

ENT.AITEAM = 1

ENT.Mass = 5000
ENT.Inertia = Vector(400000,400000,400000)
ENT.Drag = 1

ENT.HideDriver = true
ENT.HideGunner = true
ENT.SeatPos = Vector(105,0,30)
ENT.SeatAng = Angle(0,-90,0)

ENT.IdleRPM = 1
ENT.MaxRPM = 2600
ENT.LimitRPM = 3200

ENT.RotorPos = Vector(225,0,30)
ENT.WingPos = Vector(100,0,30)
ENT.ElevatorPos = Vector(-250,0,30)
ENT.RudderPos = Vector(-300,0,30)

ENT.MaxVelocity = 2000

ENT.MaxThrust = 50000

ENT.MaxTurnPitch = 600
ENT.MaxTurnYaw = 800
ENT.MaxTurnRoll = 400

ENT.MaxPerfVelocity = 1200

ENT.MaxHealth = 1750
ENT.MaxShield = 500

ENT.Stability = 0.7

ENT.VerticalTakeoff = true
--ENT.VtolAllowInputBelowThrottle = 10
ENT.MaxThrustVtol = 12000

ENT.MaxPrimaryAmmo = 4000
ENT.MaxSecondaryAmmo = 32


sound.Add( {
	name = "HAVOC_FIRE",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 125,
	pitch = {105, 115},
	sound = "lfs/wpn_atst_chinBlaster_fire.wav"
} )

sound.Add( {
	name = "HAVOC_FIRE2",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 125,
	pitch = {85, 95},
	sound = "lfs/naboo_n1_starfighter/fire.mp3"
} )

sound.Add( {
	name = "HAVOC_ALTFIRE",
	channel = CHAN_ITEM,
	volume = 1.0,
	level = 125,
	pitch = {70, 85},
	sound = "lfs/naboo_n1_starfighter/proton_fire.mp3"
} )