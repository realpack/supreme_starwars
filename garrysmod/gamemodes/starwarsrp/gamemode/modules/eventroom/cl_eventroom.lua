
netstream.Hook("OpenEventroomMenu", function(characters)
	if IsValid(CreationMenu) then CreationMenu:Remove() end

	CreationMenu = vgui.Create("DFrame")
	CreationMenu:SetSize(ScrW(),ScrH())
    CreationMenu:SetPos(0,0)
	CreationMenu:SetDraggable(false)
	CreationMenu:SetTitle('')
	CreationMenu.Paint = function( self, w, h )
		local x, y = self:GetPos()
		draw.DrawBlur( x, y, self:GetWide(), self:GetTall(), 2 )

        draw.RoundedBox(0,0,0,w,h,Color(52, 73, 94, 250))
	end

    CreationMenu:MakePopup()

	local DPanel = vgui.Create("DPanel", CreationMenu)
	DPanel:SetSize(ScrW()/2.6,ScrH()/1.8)
	DPanel:SetPos(CreationMenu:GetWide()*.5 - DPanel:GetWide()*.5,CreationMenu:GetTall()*.5 - DPanel:GetTall()*.5)

	local DButton = vgui.Create("DButton", CreationMenu)
	DButton:SetSize(200,30)
    DButton:SetText('')
	DButton:SetPos(CreationMenu:GetWide()*.5 - DButton:GetWide()*.5,CreationMenu:GetTall()*.5 + DPanel:GetTall()*.5 + 2)
	DButton.Paint = function( self, w, h )
        draw.RoundedBox(0, 0, 0, w, h, Color(92,184,92))
        draw.SimpleText('Сохранить', "font_base_22", w/2, h/2, Color( 255, 255, 255, 255 ), 1, 1)
    end

    local TextEntry = vgui.Create( "DTextEntry", DPanel ) -- create the form as a child of frame
    TextEntry:SetPos( 0, 0 )
    TextEntry:SetSize( ScrW()/2.6, DPanel:GetTall() )
    TextEntry:SetMultiline( true )
    TextEntry:SetText( GetGlobalString('EventTask') or '' )

    -- local parsed = markup.Parse( "" )
    -- TextEntry.OnTextChanged = function( value )
    --     parsed = markup.Parse( TextEntry:GetValue() )
    -- end
	-- DPanel.Paint = function( self, w, h )
    --     parsed:Draw( TextEntry:GetWide(), 0, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
    -- end
    DButton.DoClick = function()
        netstream.Start("OpenChangeEventTask", TextEntry:GetValue())
        CreationMenu:Close()
    end
end)
