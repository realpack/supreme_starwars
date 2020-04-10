netstream.Hook('OpenChangeEventTask', function( pl, text )
    if not pl:IsAdmin() then return end

    SetGlobalString('EventTask', text)
    netstream.Start(player.GetAll(), 'OpenChangeEventTask', text)
end)
