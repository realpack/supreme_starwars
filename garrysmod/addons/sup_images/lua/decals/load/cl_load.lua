Decals.Load = Decals.Load or {
    Materials = {},
    Valid = {
        jpg = true,
        jpeg = true,
        png = true
    }
}

function Decals.Load.Initialize()
    if !file.IsDir( "decals", "DATA" ) then
        file.CreateDir "decals"
    end
end

Decals.Load.Initialize()

function Decals.Load.URL( url, callback )
    if Decals.Load.Materials[ url ] then
        callback( Decals.Load.Materials[ url ] )

        return
    end

    local fileExt = url:GetExtensionFromFilename()

    if !fileExt then
        Decals.Chat( "# does not have a file extension! File extension must be either jpg, jpeg or png.", url )

        callback( nil )

        return
    end

    local fileName = "decals/" .. util.CRC( url ) .. "." .. fileExt

    if !Decals.Load.Valid[ fileExt:lower() ] then
        Decals.Chat( "# has an invalid file extension! File extension must be either jpg, jpeg or png.", url )

        callback( nil )

        return
    end

    if file.Exists( fileName, "DATA" ) then
        Decals.Load.Materials[ url ] = Material( "data/" .. fileName )

        callback( Decals.Load.Materials[ url ] )

        return
    end

    Decals.Load.Materials[ url ] = Material "icon16/error.png"

    http.Fetch( url, function( body )
        file.Write( fileName, body )

        Decals.Load.Materials[ url ] = Material( "data/" .. fileName )

        callback( Decals.Load.Materials[ url ] )
    end, function()
        Decals.Chat( "# failed to load!", url )

        callback( nil )
    end )
end
