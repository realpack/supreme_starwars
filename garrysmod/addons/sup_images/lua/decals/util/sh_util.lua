function Decals.Authed( ply )
    return Decals.cfg.Allowed[ ply:SteamID() ] or Decals.cfg.Allowed[ ply:SteamID64() ] or Decals.cfg.Allowed[ ply:GetUserGroup() ]
end
