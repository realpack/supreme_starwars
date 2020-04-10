util.AddNetworkString "Decals.Update"
util.AddNetworkString "Decals.Dupe"
util.AddNetworkString "Decals.Edit"
util.AddNetworkString "Decals.Chat"

function Decals.Update( len, ply )
    if !Decals.Authed( ply ) then
        ply:Kick "Attempting to exploit decals!"

        return
    end

    local ent = net.ReadEntity()
	
	if !ent:IsValid() then return end
	
    local url = net.ReadString()
    local col = net.ReadTable()
    local scaleX = net.ReadUInt( 14 )
    local scaleY = net.ReadUInt( 14 )

    ent:SetURL( url )
    ent:SetDecalColor( Vector( col.r / 255, col.g / 255, col.b / 255 ) )
    ent:SetOpacity( col.a )
    ent:SetScale( Vector( scaleX, scaleY, 0 ) )

    net.Start "Decals.Update"
    net.WriteEntity( ent )
    net.Broadcast()
end
net.Receive( "Decals.Update", Decals.Update )

function Decals.Dupe( len, ply, decal )
    if !Decals.Authed( ply ) then
        ply:Kick "Attempting to exploit decals!"

        return
    end

    if !decal then
        decal = net.ReadEntity()
    end
	
	if !decal:IsValid() then return end

    local ent = ents.Create "decal"
    ent:Spawn()

    ent:SetPos( decal:GetPos() )
    ent:SetAngles( decal:GetAngles() )
    ent:SetScale( decal:GetScale() )
    ent:SetDecalColor( decal:GetDecalColor() )
    ent:SetOpacity( decal:GetOpacity() )
    ent:SetURL( decal:GetURL() )
    ent:GetPhysicsObject():EnableMotion( true )

    net.Start "Decals.Chat"
    net.WriteString "Successfully duped the decal!"
    net.Send( ply )
end
net.Receive( "Decals.Dupe", Decals.Dupe )

function Decals.Chat( ply, text )
    if ply:IsValid() and Decals.Authed( ply ) then
        if text:match( "[!/:.]" .. Decals.cfg.ChatCommand ) then
            Decals.SaveAll()

            net.Start "Decals.Chat"
            net.WriteString "Successfully saved decals!"
            net.Send( ply )

            return ""
        elseif text:match( "[!/:.]" .. Decals.cfg.CopyCommand ) then
            local tr = ply:GetEyeTrace().Entity

            if !tr or !tr:IsValid() then
                net.Start "Decals.Chat"
                net.WriteString "You're not looking at a decal!"
                net.Send( ply )

                return
            end

            Decals.Dupe( nil, ply, tr )

            return ""
        end
    end
end
hook.Add( "PlayerSay", "Decals.Chat", Decals.Chat )
