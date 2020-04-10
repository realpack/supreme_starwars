surface.CreateFont( "Decals.Title", { font = "Roboto", size = 16, weight = 500 } )
surface.CreateFont( "Decals.Close", { font = "Roboto", size = 20, weight = 500 } )

local PANEL = {}

AccessorFunc( PANEL, "Edited", "Edited", FORCE_BOOL )
AccessorFunc( PANEL, "Resizing", "Resizing", FORCE_BOOL )

function PANEL:Init()
    self.btnMaxim:Remove()
    self.btnMinim:Remove()
    self.btnClose:Remove()

    self.lblTitle:SetFont "Decals.Title"

    self.ease = FrameTime() * 10

    self.closeColor = Color( 190, 90, 90 )

    self:SetEdited( false )
    self:SetResizing( false )

    self:SetAlpha( 0 )
    self:AlphaTo( 255, .2 )

    self.topPadding = 30

    self:DockPadding( 5, self.topPadding + 5, 5, 5 )

    self.CloseButton = vgui.Create( "DButton", self )
    self.CloseButton:SetText "✕"
    self.CloseButton:SetTextColor( color_white )
    self.CloseButton:SetFont "Decals.Close"
    self.CloseButton.Paint = function()
    end
    self.CloseButton.Think = function( s )
        s:SetTextColor( self:LerpColor( s:GetTextColor(), ( s.Hovered and Color( 190, 90, 90 ) or color_white ) ) )
    end
    self.CloseButton.DoClick = function( s )
        self:AlphaTo( 0, .2, 0, function()
            self:Remove()
        end )
    end
end

function PANEL:Think()
    DFrame.Think( self )

    if self:GetEdited() and !self:GetResizing() then
        self:SetResizing( true )

        local child = self:GetChild( #self:GetChildren() - 1 )

        child:AlphaTo( 255, .3 )
    end
end

function PANEL:PerformLayout( w, h )
    self.lblTitle:SizeToContents()
    self.lblTitle:SetPos( 10, self.topPadding / 2 - self.lblTitle:GetTall() / 2 )

    self.CloseButton:SizeToContents()
    self.CloseButton:SetPos( w - self.CloseButton:GetWide() - 5, self.topPadding / 2 - self.CloseButton:GetTall() / 2  )
end

function PANEL:Paint( w, h )
    -- sizeto kept breaking
    -- hacky boiz
    local child = self.sections.Save

    h = h - 31 - 10
    h = h + ( ( child:GetTall() + 20 ) ) * ( child:GetAlpha() * 2 / 255 * 2 )

    Decals.Draw.Rect( 0, 0, w, h, Color( 36, 41, 47 ) )
    Decals.Draw.Rect( 0, 0, w, self.topPadding, Color( 24, 27, 30 ) )
end

vgui.Register( "Decals.Frame", PANEL, "DFrame" )
