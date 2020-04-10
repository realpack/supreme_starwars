include('shared.lua')

include('shared.lua')

local icon_size = 200
local mat_wep = Material('sup_ui/vgui/gicons/armor-vest.png', 'smooth noclamp')

function ENT:Draw()
    self:DrawModel()

    if self:GetPos():Distance(LocalPlayer():GetPos()) < 1000 then
        local Ang = LocalPlayer():GetAngles()

        Ang:RotateAroundAxis( Ang:Forward(), 90)
        Ang:RotateAroundAxis( Ang:Right(), 90)

        cam.Start3D2D(self:GetPos()+self:GetUp()*95, Ang, 0.05)
            render.PushFilterMin(TEXFILTER.ANISOTROPIC)
                draw.Icon(icon_size*-.5,icon_size*-.5-125,icon_size,icon_size,mat_wep,color_white)
                draw.ShadowSimpleText( 'Шкаф с формой', "font_base_84", -3, 0, Color(3, 144, 252), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
                draw.ShadowSimpleText( 'кастомизация', "font_base_54", -3, 70, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
            render.PopFilterMin()
        cam.End3D2D()
    end
end




local Menu

local alpha_lerp, alpha = 0, 0
-- local mat_point = Material('icon16/connect.png')
netstream.Hook("Cupboard_OpenMenu", function(data)
    if IsValid(Menu) then
        Menu:Remove()
    end

    local alpha_lerp, alpha = 0, 0
    local select_team = 1

    alpha = 160

    Menu = vgui.Create( "DFrame" )
    Menu:SetSize(ScrW(),ScrH())
    Menu:Center()
    Menu:ShowCloseButton(false)
    Menu:MakePopup()
    Menu:SetTitle('')
    Menu.Paint = function( self, w, h )
        alpha_lerp = Lerp(FrameTime()*6,alpha_lerp or 0,alpha or 0) or 0

        local x, y = self:GetPos()
        draw.DrawBlur( x, y, self:GetWide(), self:GetTall(), alpha_lerp/100 )

        draw.RoundedBox(0,0,0,w,h,Color(52, 73, 94, alpha_lerp))
    end

    local Close = vgui.Create( "DButton", Menu )
    Close:SetSize( 30, 30 )
    Close:SetText('')
    Close:SetPos( Menu:GetWide()-Close:GetWide()-10, 10 )
    Close.Paint = function( self, w, h )
        draw.RoundedBox(0, 0, 0, w, h, Color(191, 67, 57))
        draw.SimpleText('X', "font_base_22", w/2, h/2, Color( 255, 255, 255, 255 ), 1, 1)
    end

    Close.DoClick = function( self )
        Menu:Remove()
    end

    local scrollpanel = vgui.Create('DScrollPanel',Menu)
    scrollpanel:SetSize(440,600)
    scrollpanel:SetPos(Menu:GetWide()*.5 - scrollpanel:GetWide()*.5, Menu:GetTall()*.5 - scrollpanel:GetTall()*.5)
    scrollpanel.Paint = function( self, w, h ) end

    local models = vgui.Create( "DListLayout", scrollpanel )
    models:Dock( FILL )

    for key, data in pairs(FEATURE_ARMORMODELS) do
        if data.check(LocalPlayer()) == true then
            local nextmodel = vgui.Create("DButton")
            nextmodel:SetSize(400, 20)
            nextmodel:SetText('')
            nextmodel.Paint = function( self, w, h )
                local col = self:IsHovered() and Color(255,255,255,30) or Color(255,255,255,20)
                draw.RoundedBox(0,0,0,w,h,col)
                -- draw.Icon(2,2,h-4,h-4,mat_point,color_white)
                draw.SimpleText('Надеть "'..data.name..'"', "font_base_18", 4, h/2, Color( 255, 255, 255, 255 ), 0, 1)
            end

            nextmodel.DoClick = function( self )
                netstream.Start('Cupboard_TakeModel', { name = key })
                Menu:Remove()
            end

            models:Add( nextmodel )
        end
    end

    local nextmodel = vgui.Create("DButton")
    nextmodel:SetSize(400, 20)
    nextmodel:SetText('')
    nextmodel.Paint = function( self, w, h )
        local col = self:IsHovered() and Color(255,255,255,30) or Color(255,255,255,20)
        draw.RoundedBox(0,0,0,w,h,col)
        -- draw.Icon(2,2,h-4,h-4,mat_point,color_white)
        draw.SimpleText('Снять броню', "font_base_18", 4, h/2, Color( 255, 255, 255, 255 ), 0, 1)
    end

    nextmodel.DoClick = function( self )
        -- netstream.Start('NPCPortal_MakeProtals', { name = name, ent_index = ent_index })
        netstream.Start('Cupboard_TakeOffModel', nil)
        Menu:Remove()
    end

    models:Add( nextmodel )
end)

