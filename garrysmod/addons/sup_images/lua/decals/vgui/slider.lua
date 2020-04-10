local PANEL = {}

AccessorFunc( PANEL, "Color", "Color" )
AccessorFunc( PANEL, "SliderColor", "SliderColor" )

function PANEL:Init()
    self.Label:Hide()
    self.TextArea:Hide()

    self:SetColor( Color( 150, 150, 150 ) )
    self:SetSliderColor( color_white )

    self.TextArea:SetFont "Decals.Title"
    self.TextArea:SetTextColor( color_white )
    self.TextArea:DockMargin( 10, 0, 0, 0 )

    self.Slider.OnMousePressed = function( s, mouse )
        if mouse == MOUSE_RIGHT then
            self:OnMousePressed( mouse )
        else
            s:SetDragging( true )
            s:MouseCapture( true )

            local x, y = s:CursorPos()
            s:OnCursorMoved( x, y )
        end
    end

    self.Slider.Knob.Paint = function( s, w, h )
        Decals.Draw.Circle( h / 4, h / 4, ( h + 1 ) / 2, self:GetSliderColor() )
    end

    self.Slider.Paint = function( s, w, h )
        draw.RoundedBox( 8, 0, h / 4, w, h / 2, self:GetColor() )
    end
end

function PANEL:OnMousePressed( mouse )
    if mouse == MOUSE_RIGHT then
        if self.TextArea:IsVisible() then
            self.TextArea:Hide()

            self.Slider:SetWide( self:GetWide() )
        else
            self.TextArea:Show()

            self.Slider:StretchToParent( 0, 0, 0, 0 )
        end
    end
end

vgui.Register( "Decals.Slider", PANEL, "DNumSlider" )
