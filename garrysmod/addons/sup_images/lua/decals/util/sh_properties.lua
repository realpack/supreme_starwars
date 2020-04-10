properties.Add( "Edit Decal", {
    MenuLabel = "Edit Decal",
    Order = 5000,
    MenuIcon = "icon16/pencil.png",
    Filter = function( self, ent, ply )
        if !ent:IsValid() or ent:GetClass() != "decal" or !Decals.Authed( ply ) then return false end

        return true
    end,
    Action = function( self, ent )
        Decals.Open( nil, ent )
    end,
    Receive = function( self, len, ply )
    end,
} )

properties.Add( "Duplicate Decal", {
    MenuLabel = "Duplicate Decal",
    Order = 5011,
    MenuIcon = "icon16/database_add.png",
    Filter = function( self, ent, ply )
        if !ent:IsValid() or ent:GetClass() != "decal" or !Decals.Authed( ply ) then return false end

        return true
    end,
    Action = function( self, ent )
        net.Start "Decals.Dupe"
        net.WriteEntity( ent )
        net.SendToServer()
    end,
    Receive = function( self, len, ply )
    end,
} )
