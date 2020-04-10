Decals.Draw = Decals.Draw or {}

function Decals.Draw.Rect( x, y, w, h, col )
    surface.SetDrawColor( col )
    surface.DrawRect( x, y, w, h )
end

function Decals.Draw.Circle( x, y, r, col )
    local circle = {}
    local c = 0

    for i = 1, 360 do
        c = math.rad( i )

        circle[ i ] = {
            x = x + r / 2 + math.cos( c ) * r,
            y = y + r / 2 + math.sin( c ) * r
        }
    end

    draw.NoTexture()
    surface.SetDrawColor( col )
    surface.DrawPoly( circle )
end

function Decals.Draw.LerpColor( oldCol, newCol, ease )
    return Color( Lerp( ease, oldCol.r, newCol.r ), Lerp( ease, oldCol.g, newCol.g ), Lerp( ease, oldCol.b, newCol.b ), Lerp( ease, oldCol.a, newCol.a ) )
end

FindMetaTable "Panel" .LerpColor = function( self, oldCol, newCol )
    return Decals.Draw.LerpColor( oldCol, newCol, self.ease )
end
