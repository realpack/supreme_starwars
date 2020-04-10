meta.util.include_sv = (SERVER) and include or function() end
meta.util.include_cl = (SERVER) and AddCSLuaFile or include

meta.util.include_sh = function(f)
	meta.util.include_sv(f)
	meta.util.include_cl(f)
end

PLAYER	= FindMetaTable 'Player'
ENTITY	= FindMetaTable 'Entity'
VECTOR	= FindMetaTable 'Vector'

-- Includes a file from the prefix.
function meta.util.include_load(fileName, strState)
	-- Only include server-side if we're on the server.
	if ((strState == "server" or string.find(fileName, "sv_")) and SERVER) then
		meta.util.include_sv(fileName)
	-- Shared is included by both server and client.
	elseif (strState == "shared" or string.find(fileName, "sh_")) then
		meta.util.include_sh(fileName)
	-- File is sent to client, included on client.
	elseif (strState == "client" or string.find(fileName, "cl_")) then
		meta.util.include_cl(fileName)
	end
end


-- Include files based off the prefix within a directory.
function meta.util.include_dir(directory, re) -- Depruciated
    local fol = GM.FolderName .. '/gamemode/' .. directory .. '/'

	-- Find all of the files within the directory.
	for k, v in ipairs(file.Find(fol .. '*', 'LUA')) do
		local fileName = directory..'/'..v
		meta.util.include_load(fileName)
	end

    if re == true then
        local _, folders = file.Find(fol .. '*', 'LUA')
        if folders then
            for _, f in ipairs(folders) do
                meta.util.include_dir(directory .. '/' .. f)
            end
        end
    end
end

local libraries_isload

if !libraries_isload then -- include libraries
	-- meta.util.include_sh 'libraries/config.lua'
	meta.util.include_sh 'libraries/pon.lua'
	meta.util.include_sh 'libraries/netstream.lua'
	meta.util.include_sh 'libraries/nw.lua'
	meta.util.include_sv 'libraries/mysqlite.lua'
	meta.util.include_cl 'libraries/draw.lua'
	-- meta.util.include_sh 'libraries/shits.lua'

	libraries_isload = true
end

-- meta.util.include_cl 'cfg/cl_fonts.lua'
-- meta.util.include_sv 'cfg/sv_config.lua'
meta.util.include_sv 'config/sv_mysql_config.lua'
meta.util.include_sh 'config/sh_config.lua'
meta.util.include_sv 'config/sv_whitelist.lua'
-- meta.util.include_sh 'config/sh_npcs.lua'

-- fpp
-- meta.util.include_sv 'core/fpp/server/defaultblockedmodels.lua'
-- meta.util.include_sv 'core/fpp/server/settings.lua'
-- meta.util.include_sv 'core/fpp/server/core.lua'
-- meta.util.include_sv 'core/fpp/server/antispam.lua'
-- meta.util.include_sv 'core/fpp/server/ownability.lua'

-- meta.util.include_cl 'core/fpp/client/menu.lua'
-- meta.util.include_cl 'core/fpp/client/hud.lua'
-- meta.util.include_cl 'core/fpp/client/buddies.lua'
-- meta.util.include_cl 'core/fpp/client/ownability.lua'

-- meta.util.include_sh 'core/fpp/sh_settings.lua'
-- end fpp

meta.util.include_dir('core/sandbox',true)

meta.util.include_sh 'core/sh_jobs.lua'
meta.util.include_sh 'config/sh_jobs_config.lua'
-- meta.util.include_sh 'core/sh_logs.lua'

meta.util.include_cl 'core/cl_core.lua'
meta.util.include_sh 'core/sh_player.lua'
meta.util.include_sv 'core/sv_player.lua'
meta.util.include_sh 'core/sh_playerclass.lua'
meta.util.include_dir('core', false)

hook.Run("PreLoadModules")

meta.util.include_dir('modules', true)

hook.Run("OnLoadModules")
