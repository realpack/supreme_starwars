function Decals.SetupSaves()
    if !file.IsDir( "decals", "DATA" ) then
        file.CreateDir "decals"
    end

    if !file.IsDir( "decals/" .. game.GetMap(), "DATA" ) then
        file.CreateDir( "decals/" .. game.GetMap() )
    end
end

Decals.SetupSaves()

function Decals.Save( ent )
    if !ent or !ent:IsValid() then return end

    local base = "decals/" .. game.GetMap() .. "/"
    local files = file.Find( base .. "*.txt", "DATA" )
    local decal = file.Open( base .. #files + 1 .. ".txt", "wb", "DATA" )

    local pos = ent:GetPos()
    local ang = ent:GetAngles()
    local scale = ent:GetScale()
    local color = ent:GetDecalColor()

    decal:WriteFloat( pos.x )
    decal:WriteFloat( pos.y )
    decal:WriteFloat( pos.z )

    decal:WriteFloat( ang.p )
    decal:WriteFloat( ang.y )
    decal:WriteFloat( ang.r )

    decal:WriteFloat( scale.x )
    decal:WriteFloat( scale.y )
    decal:WriteFloat( scale.z )

    decal:WriteFloat( color.x )
    decal:WriteFloat( color.y )
    decal:WriteFloat( color.z )

    decal:WriteByte( ent:GetOpacity() )

    decal:Write( ent:GetURL() )

    decal:Close()
end

function Decals.SaveAll()
    local base = "decals/" .. game.GetMap() .. "/"

    for _, decal in ipairs( file.Find( base .. "*.txt", "DATA" ) ) do
        file.Delete( base .. decal )
    end

    for _, decal in ipairs( ents.FindByClass "decal" ) do
        Decals.Save( decal )
    end
end

function Decals.Load()
    local base = "decals/" .. game.GetMap() .. "/"

    for _, id in ipairs( file.Find( base .. "*.txt", "DATA" ) ) do
        local decal = file.Open( base .. id, "rb", "DATA" )

        local pos = Vector( decal:ReadFloat(), decal:ReadFloat(), decal:ReadFloat() )
        local ang = Angle( decal:ReadFloat(), decal:ReadFloat(), decal:ReadFloat() )
        local scale = Vector( decal:ReadFloat(), decal:ReadFloat(), decal:ReadFloat() )
        local color = Vector( decal:ReadFloat(), decal:ReadFloat(), decal:ReadFloat() )
        local alpha = decal:ReadByte()
        local url = decal:Read( decal:Size() )

        decal:Close()

        local ent = ents.Create "decal"
        ent:Spawn()

        ent:SetPos( pos )
        ent:SetAngles( ang )
        ent:SetScale( scale )
        ent:SetDecalColor( color )
        ent:SetOpacity( alpha )
        ent:SetURL( url )
        ent:GetPhysicsObject():EnableMotion( false )
    end
end
hook.Add( "InitPostEntity", "Decals.Load", Decals.Load )
