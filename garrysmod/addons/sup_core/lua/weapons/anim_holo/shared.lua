--[[
Only allowed to use in Addons by
​Mattis 'Mattzimann' Krämer
]]--

SWEP.Purpose				= "You can now use the Hololink!"
SWEP.Instructions 			= "Click to Hololink."

SWEP.Category 				= "SUP | Аниманции"
SWEP.PrintName				= "Гололинк"
SWEP.Spawnable				= true

SWEP.Base = "anim_base"

if CLIENT then
	function SWEP:GetGesture()
		return {
	        ["ValveBiped.Bip01_R_UpperArm"] = Angle(10,-20),
	        ["ValveBiped.Bip01_R_Hand"] = Angle(0,1,50),
	        ["ValveBiped.Bip01_Head1"] = Angle(0,-30,-20),
	        ["ValveBiped.Bip01_R_Forearm"] = Angle(0,-65,39.8863),
	    }
	end
end
