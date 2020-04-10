function Decals.Update()
    local ent = net.ReadEntity()

    ent:SetDecal( Material "icon16/error.png" )
    ent:SetLoaded( false )
end
net.Receive( "Decals.Update", Decals.Update )

function Decals.Open( len, ent )
    if Decals.Menu then return end

    if !ent then
        ent = net.ReadEntity()
    end

    local pos = ent:GetPos():ToScreen()

    local x = pos.x + pos.x / 4

    if x > ScrW() then
        x = x - pos.x / 2
    end

    local frame = vgui.Create "Decals.Menu"
    frame:SetSize( 320, 475 )
    frame:SetPos( x, 0 )
    frame:CenterVertical()
    frame:SetEnt( ent )
    frame:Setup()
    frame:MakePopup()

    Decals.Menu = frame
end
net.Receive( "Decals.Edit", Decals.Open )
