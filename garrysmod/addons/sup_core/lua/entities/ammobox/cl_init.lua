include("shared.lua")

function ENT:Initialize()
end

function ENT:Think()
end
local icon_size = 200
local mat_wep11 = Material('sup_ui/metaui/ammo.png', 'smooth noclamp')

function ENT:Draw()
    self:DrawModel()

    if self:GetPos():Distance(LocalPlayer():GetPos()) < 1000 then
        local Ang = LocalPlayer():GetAngles()

        Ang:RotateAroundAxis( Ang:Forward(), 90)
        Ang:RotateAroundAxis( Ang:Right(), 90)

        cam.Start3D2D(self:GetPos()+self:GetUp()*20, Ang, 0.05)
            render.PushFilterMin(TEXFILTER.ANISOTROPIC)
                draw.Icon(icon_size*-.5,icon_size*-.5-125,icon_size,icon_size,mat_wep11,color_white)
                draw.ShadowSimpleText( 'Боезапас', "font_base_84", -3, 0, Color(3, 144, 252), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
                draw.ShadowSimpleText( 'выдача аммуниции', "font_base_54", -3, 70, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
            render.PopFilterMin()
        cam.End3D2D()
    end
end
