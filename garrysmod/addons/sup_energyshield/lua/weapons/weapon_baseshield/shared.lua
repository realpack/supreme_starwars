SWEP.PrintName					= 'Стационарный Щит'
SWEP.Slot						= 1
SWEP.SlotPos					= 4
SWEP.DrawAmmo 					= false
SWEP.DrawCrosshair 				= false

SWEP.Author 					= 'pack'
SWEP.Instructions				= ''
SWEP.Contact 					= ''
SWEP.Purpose 					= ''

SWEP.ViewModel					= ""
SWEP.WorldModel					= ""

SWEP.ViewModelFOV 				= 70
SWEP.ViewModelFlip 				= false

SWEP.Spawnable					= true
SWEP.Category					= "SUP | Разработки"
SWEP.Primary.ClipSize 			= -1
SWEP.Primary.DefaultClip 		= 0
SWEP.Primary.Automatic 			= false
SWEP.Primary.Ammo 				= ''

SWEP.Secondary.ClipSize 		= -1
SWEP.Secondary.DefaultClip 		= 0
SWEP.Secondary.Automatic 		= false
SWEP.Secondary.Ammo 			= ''

SWEP.WorldModel					= 'models/galactic/repairtool/w_repairtool.mdl'
SWEP.ViewModel					= 'models/galactic/repairtool/v_repairtool.mdl'

SWEP.HoldType					= "slam"

function SWEP:Deploy()
	self:SetHoldType(self.HoldType)

	baseshield_draw = false
end

function SWEP:Initialize()

end


local mat = Material('models/wireframe')

function SWEP:DrawHUD()
	local tr = LocalPlayer():GetEyeTrace()

	cam.Start3D()
		render.SetMaterial(mat)
		-- render.SetColorMaterial()

		if tr.HitPos:DistToSqr(LocalPlayer():GetPos()) > 128 ^ 2 then
			render.SetColorModulation( 255, 0, 0 )
		else
			render.SetColorModulation( 0, 255, 0 )
		end
		render.SetBlend(190/255)
		
		render.Model( {model = 'models/props/electricbarrel.mdl', pos = tr.HitPos})
	cam.End3D()

	baseshield_draw = true
end

function SWEP:Holster()
	baseshield_draw = false

	return true
end

function SWEP:OnRemove()
	self:Holster()
end