surface.CreateFont( "Decals.Header", { font = "Roboto", size = 18, weight = 800 } )

local PANEL = {}

AccessorFunc( PANEL, "Ent", "Ent" )

function PANEL:Init()
    self.sections = {}
    self.rgbCols = {
        Color( 255, 80, 80 ),
        Color( 80, 255, 80 ),
        Color( 80, 80, 255 ),
        Color( 160, 160, 160 )
    }

    self:SetTitle "Decals"
    self:SetEnt( nil )

    local oldClose = self.CloseButton.DoClick

    self.CloseButton.DoClick = function( s )
        local ent = self:GetEnt()

        ent:ResetEditing()
        ent:SetEditing( false )

        ent:SetLoaded( false )
        ent:Load()

        if Decals.Menu then
            Decals.Menu = nil
        end

        oldClose( s )
    end
end

function PANEL:AddSection( name, type )
    local header = vgui.Create( "DLabel", self )
    header:Dock( TOP )
    header:DockMargin( 0, 0, 0, 5 )
    header:SetContentAlignment( 2 )
    header:SetFont "Decals.Header"
    header:SetText( name )
    header:SizeToContents()

    local element = vgui.Create( type, self )
    element:Dock( TOP )
    element:DockMargin( 0, 0, 0, 10 )

    self.sections[ name ] = element

    return element, header
end

function PANEL:Setup()
    self:GetEnt():ResetEditing()
    self:GetEnt():SetEditing( true )

    local url = self:AddSection( "URL", "DTextEntry" )
    url:SetFont "Decals.Title"
    url:SetText( self:GetEnt():GetURL() )
    url:SetTall( 24 )
    url.Paint = function( s, w, h )
        Decals.Draw.Rect( 0, 0, w, h, Color( 25, 28, 32 ) )

        s:DrawTextEntryText( Color( 160, 160, 160 ), Color( 0, 178, 238 ), color_white )
    end
    url.OnEnter = function( s )
        local text = s:GetText()
        local imgur = Decals.Parse.Imgur( text )
        local ent = self:GetEnt()

        if imgur then
            text = imgur
        end

        ent:SetEditURL( text )
        ent:Load()
        ent:SetLoaded( false )
    end
    url.OnGetFocus = function( s )
        self:SetEdited( true )
    end
    url.OnLoseFocus = function( s )
        if s:GetText() != self:GetEnt():GetEditURL() then
            s:OnEnter()
        end
    end

    local col = self:AddSection( "Color", "DColorMixer" )
    col:SetColor( self:GetEnt():GetDecalColor():ToColor() )
    col.ValueChanged = function( s, col )
        local ent = self:GetEnt()

        ent:SetEditColor( Vector( col.r / 255, col.g / 255, col.b / 255 ) )
        ent:SetEditOpacity( col.a )

        self:SetEdited( true )
    end

    for _, child in ipairs( col:GetChild( 2 ):GetChildren() ) do
        child:SetFont "Decals.Title"

        child.Paint = function( s, w, h )
            Decals.Draw.Rect( 0, 0, w, h, Color( 25, 28, 32 ) )

            s:DrawTextEntryText( self.rgbCols[ _ ], Color( 0, 178, 238 ), color_white )
            local s = 76561198389077220
        end
    end

    local scale = self:AddSection( "Scale", "Panel" )
    scale:SetTall( 55 )

    local scaleX = vgui.Create( "Decals.Slider", scale )
    scaleX:Dock( TOP )
    scaleX:SetColor( Color( 25, 28, 32 ) )
    scaleX:SetSliderColor( Color( 160, 160, 160 ) )
    scaleX:SetDecimals( 0 )
    scaleX:SetMinMax( 100, 10000 )
    scaleX:SetValue( self:GetEnt():GetScale().x )
    scaleX.OnValueChanged = function( s, val )
        local vec = self:GetEnt():GetEditScale()
        vec.x = val

        self:GetEnt():SetEditScale( vec )

        self:SetEdited( true )
    end

    local scaleY = vgui.Create( "Decals.Slider", scale )
    scaleY:Dock( BOTTOM )
    scaleY:SetColor( Color( 25, 28, 32 ) )
    scaleY:SetSliderColor( Color( 160, 160, 160 ) )
    scaleY:SetDecimals( 0 )
    scaleY:SetMinMax( 100, 10000 )
    scaleY:SetValue( self:GetEnt():GetScale().y )
    scaleY.OnValueChanged = function( s, val )
        local vec = self:GetEnt():GetEditScale()
        vec.y = val

        self:GetEnt():SetEditScale( vec )

        self:SetEdited( true )
    end

    self.sections.Scale:DockMargin( 0, 0, 0, 5 )

    local save = vgui.Create( "Decals.Button", self )
    save:Dock( TOP )
    save:SetAlpha( 0 )
    save:SetTall( 32 )
    save:SetText "Save"
    save.DoClick = function( s )
        local text = url:GetText()
        local ent = self:GetEnt()

        Decals.Load.URL( text, function( status )
            if !Decals.Parse.Error( text ) then
                Decals.Chat( "# has an invalid file extension! File extension must be either jpg, jpeg or png.", text )

                return
            end

            net.Start "Decals.Update"
            net.WriteEntity( self:GetEnt() )
            net.WriteString( text )
            net.WriteTable( col:GetColor() )
            net.WriteUInt( scaleX:GetValue(), 14 )
            net.WriteUInt( scaleY:GetValue(), 14 )
            net.SendToServer()

            ent:ResetEditing()
            ent:SetEditing( false )

            ent:SetLoaded( false )
            ent:Load()

            self.CloseButton.DoClick()
        end )
    end
    save.OnCursorEntered = function( s )
        s:SetCursor( s:GetAlpha() > 100 and "hand" or "arrow" )
    end

    self.sections.Save = save
end

vgui.Register( "Decals.Menu", PANEL, "Decals.Frame" )
