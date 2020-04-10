Decals = Decals or {
    incsv = SERVER and include or function() end,
    inccl = SERVER and AddCSLuaFile or include,
    incsh = function( file ) Decals.incsv( file ) Decals.inccl( file ) end,
    inc = function( file ) Decals[ "inc" .. file:GetFileFromFilename():sub( 1, 2 ) ]( file ) end,
    cfg = {},
}

Decals.incsh "decals/decals_config.lua"
Decals.inc "decals/util/sh_util.lua"
Decals.inc "decals/util/cl_util.lua"
Decals.inc "decals/util/cl_parse.lua"
Decals.inc "decals/util/cl_halo.lua"
Decals.inc "decals/util/sh_properties.lua"
Decals.inc "decals/load/cl_load.lua"
Decals.inc "decals/load/sv_load.lua"
Decals.inc "decals/core/sv_core.lua"
Decals.inc "decals/core/cl_core.lua"
Decals.inccl "decals/vgui/draw.lua"
Decals.inccl "decals/vgui/frame.lua"
Decals.inccl "decals/vgui/slider.lua"
Decals.inccl "decals/vgui/button.lua"
Decals.inc "decals/menu/cl_menu.lua"
