local decalsHalo = CreateClientConVar( "decals_halo", 1, true, false )

Decals.Halo = Decals.Halo or {}

function Decals.Halo.Draw()
    local ent = LocalPlayer():GetEyeTrace().Entity

    if ent and ent:IsValid() and ent:GetClass() == "decal" and EyePos():Distance( ent:GetPos() ) < 1000 then
        halo.Add( { ent }, Decals.cfg.Color, 5, 5, 2 )
    end
end

function Decals.Halo.Callback( name, old, new )
    if !Decals.Authed( LocalPlayer() ) then
        new = "0"
    end

    local hookCall = hook[ tobool( new ) and "Add" or "Remove" ]

    hookCall( "PreDrawHalos", "Decals.Halo.Draw", Decals.Halo.Draw )
end
cvars.AddChangeCallback( "decals_halo", Decals.Halo.Callback )

function Decals.Halo.Initialize()
    Decals.Halo.Callback( nil, nil, decalsHalo:GetBool() )
end
hook.Add( "InitPostEntity", "Decals.Halo.Initialize", Decals.Halo.Initialize )
