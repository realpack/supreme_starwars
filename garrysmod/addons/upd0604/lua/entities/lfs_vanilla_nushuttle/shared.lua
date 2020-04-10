-- YOU CAN EDIT AND REUPLOAD THIS FILE. 
-- HOWEVER MAKE SURE TO RENAME THE FOLDER TO AVOID CONFLICTS

ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript" )

ENT.PrintName = "NU-Class Attack Shuttle"
ENT.Author = "VanillaNekoNYAN"
ENT.Information = ""
ENT.Category = "[LFS] Vanilla"

ENT.Spawnable		= true -- set to "true" to make it spawnable
ENT.AdminSpawnable	= false

ENT.MDL = "models/props/nuclassv2/nuclasslanded/nuclasslanded.mdl" -- model forward direction must be facing to X+

ENT.AITEAM = 2 -- 0 = FFA  1 = bad guys  2 = good guys

ENT.Mass = 2000 -- lower this value if you encounter spazz
ENT.Inertia = Vector(150000,150000,150000) -- you must increase this when you increase mass or it will spazz
ENT.Drag = -1 -- drag is a good air brake but it will make diving speed worse

ENT.HideDriver = true -- hide the driver?
ENT.SeatPos = Vector(255,0,255)
ENT.SeatAng = Angle(0,-90,0)

ENT.IdleRPM = 300 -- idle rpm. this can be used to tweak the minimum flight speed
ENT.MaxRPM = 2800 -- rpm at 100% throttle
ENT.LimitRPM = 3000 -- max rpm when holding throttle key
ENT.RPMThrottleIncrement = 1200 -- how fast the RPM should increase/decrease per second

ENT.RotorPos = Vector(300,0,100) -- make sure you set these correctly or your plane will act wierd.
ENT.WingPos = Vector(0,25,-100) -- make sure you set these correctly or your plane will act wierd. Excessive values can cause spazz.
ENT.ElevatorPos = Vector(-400,0,0) -- make sure you set these correctly or your plane will act wierd. Excessive values can cause spazz.
ENT.RudderPos = Vector(-400,0,0) -- make sure you set these correctly or your plane will act wierd. Excessive values can cause spazz.

ENT.MaxVelocity = 2100

ENT.MaxThrust = 48000

ENT.MaxTurnPitch = 300
ENT.MaxTurnYaw = 600
ENT.MaxTurnRoll = 300

ENT.MaxHealth = 800
ENT.MaxShield = 300  -- uncomment this if you want to use deflector shields. Dont use excessive amounts because it regenerates.

ENT.Stability = 0.7   -- if you uncomment this the plane will always be able to turn at maximum performance. This causes MaxPerfVelocity to get ignored
--ENT.MaxStability = 0.7 -- lower this value if you encounter spazz. You can increase this up to 1 to aid turning performance at MaxPerfVelocity-speeds but be careful

ENT.VerticalTakeoff = true -- move vertically with landing gear out? REQUIRES ENT.Stability
--ENT.VtolAllowInputBelowThrottle = 10 -- number is in % of throttle. Removes the landing gear dependency. Vtol mode will always be active when throttle is below this number. In this mode up movement is done with "Shift" key instead of W
ENT.MaxThrustVtol = 10000 -- amount of vertical thrust

ENT.MaxPrimaryAmmo = 5000   -- set to a positive number if you want to use weapons. set to -1 if you dont
ENT.MaxSecondaryAmmo = -1 -- set to a positive number if you want to use weapons. set to -1 if you dont

function ENT:AddDataTables() -- use this to add networkvariables instead of ENT:SetupDataTables().
	--[[DO NOT USE SLOTS SMALLER THAN 10]]--
end

sound.Add( {
	name = "VANILLA_NUSHUTTLE_HUM",
	channel = CHAN_STATIC,
	volume = 0.8,
	level = 125,
	sound = "vanilla/btlbywing/vanilla_nushuttle_hum.wav"
} )

sound.Add( {
	name = "VANILLA_NUSHUTTLE_FIRE",
	channel = CHAN_WEAPON,
	volume = 0.8,
	level = 125,
	pitch = {95, 98},
	sound = "vanilla/btlbywing/vanilla_nushuttle_fire.wav"
} )