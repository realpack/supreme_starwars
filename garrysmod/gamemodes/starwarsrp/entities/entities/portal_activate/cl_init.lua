include('shared.lua')

local matrix = Matrix()
local matrixAngle = Angle(0, 0, 0)
local matrixScale = Vector(0, 0, 0)
local matrixTranslation = Vector(0, 0, 0)


-- local rotate = 0
-- local mat_portal = Material('venatorig/jediwarp.vtf')
-- function ENT:Draw()
-- 	-- self:DrawModel()

--     local w, h = 52.9^2, 52.9^2
--     rotate = rotate - .1

--     cam.Start3D2D(self:GetPos()+self:GetForward()*-70+self:GetRight()*-70, self:GetAngles()-Angle(0,0,0), 0.05)
--         render.ClearStencil()
--         render.SetStencilEnable(true)

--             render.SetStencilWriteMask( 255 )
--             render.SetStencilTestMask( 255 )

--             render.SetStencilReferenceValue( 25 )
--             render.SetStencilFailOperation( STENCIL_REPLACE )

--             draw.Circle({ x = w/2, y = h/2 }, w/2, 64, Color(255, 255, 255, 255))

--             render.SetStencilCompareFunction(STENCIL_EQUAL)

--             draw.NoTexture()
--             surface.SetDrawColor(Color(255, 255, 255, 255))
--             surface.SetMaterial(mat_portal)
--             -- surface.DrawTexturedRect(0, 0, w, h)
--             surface.DrawTexturedRectRotated(w/2, h/2, w, h, rotate)

--         render.SetStencilEnable(false)


--         -- render.ClearStencil()
--         -- render.SetStencilEnable(true)

--         --     render.SetStencilWriteMask( 255 )
--         --     render.SetStencilTestMask( 255 )

--         --     render.SetStencilReferenceValue( 25 )
--         --     render.SetStencilFailOperation( STENCIL_REPLACE )

--         --     -- DrawFilledCircle(92, 92, 92, Color(255, 255, 255))

--         --     draw.Circle({ x = w/2, y = h/2 }, 92, 64, Color(255, 255, 255, 255))

--         --     render.SetStencilCompareFunction(STENCIL_EQUAL)

--         --         draw.NoTexture()
--         --         surface.SetDrawColor(color_white)
--         --         surface.SetMaterial(Material('venatorig/jediwarp.vtf'))

--         --         surface.DrawTexturedRectRotated(w/2, h/2, w, h, rotate)

--         --     render.SetStencilEnable(false)
--     cam.End3D2D()
-- end

local Menu

local alpha_lerp, alpha = 0, 0
local mat_point = Material('icon16/connect.png')
netstream.Hook("NPCPortal_OpenMenu", function(data)
    if IsValid(Menu) then
        Menu:Remove()
    end

    local alpha_lerp, alpha = 0, 0
    local select_team = 1
    local ent_index = data.ent_index

    alpha = 160

    Menu = vgui.Create( "DFrame" )
    Menu:SetSize(ScrW(),ScrH())
    Menu:Center()
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
    scrollpanel:SetSize(400,600)
    scrollpanel:SetPos(Menu:GetWide()*.5 - scrollpanel:GetWide()*.5, Menu:GetTall()*.5 - scrollpanel:GetTall()*.5)
    scrollpanel.Paint = function( self, w, h ) end

    local vehicles = vgui.Create( "DListLayout", scrollpanel )
    vehicles:Dock( FILL )

    for name, vector in pairs(SPAWNPORTALS_VECTORS) do
        local nextbuy = vgui.Create("DButton")
        nextbuy:SetSize(400, 20)
        nextbuy:SetText('')
        nextbuy.Paint = function( self, w, h )
            local col = self:IsHovered() and Color(255,255,255,30) or Color(255,255,255,20)
            draw.RoundedBox(0,0,0,w,h,col)
            draw.Icon(2,2,h-4,h-4,mat_point,color_white)
            draw.SimpleText(name, "font_base_18", 24, h/2, Color( 255, 255, 255, 255 ), 0, 1)
        end

        nextbuy.DoClick = function( self )
            netstream.Start('NPCPortal_MakeProtals', { name = name, ent_index = ent_index })
            Menu:Remove()
        end

        vehicles:Add( nextbuy )
    end
end)
