--hook.Add( "PlayerSpawn", "First_Spawn", function( ply )
 --   ply.var = ply:health
	
--end );


--hook.Add("PlayerSpawn", "JobHealth", function(player)
--    player.varg = ent:Health
--	PrintMessage( HUD_PRINTTALK, player.varg)
--	end)

function playerRespawn( ply )
	--ply.var = 100
	--print(ply:Health())
	timer.Simple(1, function()
		ply.var = ply:Health()
		end)
    --ply.var = ply:Health()
	
end

hook.Add( "PlayerSpawn", "First_Spawn", playerRespawn );


function jobChange( ply, cat, cat2 )
--ply.var = 100
	--print(ply:Health())
	timer.Simple(1, function()
		ply.var = ply:Health()
		end)
    --ply.var = ply:Health()
	
end

hook.Add("OnPlayerChangedTeam", "Job_Change", jobChange);