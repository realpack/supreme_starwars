
-- local CreationMenu = CreationMenu or nil
-- local function OpenWhitelistMenu()
-- 	if IsValid(CreationMenu) then CreationMenu:Remove() end

-- 	CreationMenu = vgui.Create("DFrame")
-- 	CreationMenu:SetSize(ScrW(),ScrH())
--     CreationMenu:SetPos(0,0)
-- 	CreationMenu:SetDraggable(false)
-- 	CreationMenu:SetTitle('')
-- 	-- CreationMenu:ShowCloseButton(false)
-- 	CreationMenu.Paint = function( self, w, h )
-- 		local x, y = self:GetPos()
-- 		draw.DrawBlur( x, y, self:GetWide(), self:GetTall(), 2 )

--         draw.RoundedBox(0,0,0,w,h,Color(52, 73, 94, 250))
-- 	end

--     timer.Simple(5, function()
--         err = nil
--     end)

--     CreationMenu:MakePopup()

-- 	local DPanel = vgui.Create("DPanel", CreationMenu)
-- 	DPanel:SetSize(ScrW()/1.2,ScrH()/1.8)
-- 	DPanel:SetPos(CreationMenu:GetWide()*.5 - DPanel:GetWide()*.5,CreationMenu:GetTall()*.5 - DPanel:GetTall()*.5)

-- 	local panel_wide, panel_tall = DPanel:GetWide(), DPanel:GetTall()
-- 	DPanel.Paint = function( self, w, h ) end
-- end

-- netstream.Hook("OpenWhitelistMenu", function(characters)
--     OpenWhitelistMenu(characters)
-- end)
