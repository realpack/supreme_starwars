function Decals.Chat( text, ... )
    local c = 0
    local opts = { ... }
    local msg = text:gsub( "#", function() c = c + 1 return opts[ c ] end )

    return chat.AddText( Decals.cfg.Color, "[Decals] ", color_white, msg )
end

function Decals.NetChat()
    Decals.Chat( net.ReadString() )
end
net.Receive( "Decals.Chat", Decals.NetChat )
