if not SERVER then return end
function antipidormap()
	for _, v in pairs( ents.FindByName("aie5auiayuawyaawyawyw4u7")) do v:Remove() end
	for _, v in pairs( ents.FindByClass( "trigger_hurt" ) ) do v:Remove() end
end

concommand.Add("admin", function(ply, cmd, args)
    if ply:IsAdmin() then
        ply:SendLua("adminMenu()")
    end
end)

hook.Add("InitPostEntity", "antipidormap", antipidormap)

function antipidormapclenup()
	for _, v in pairs( ents.FindByName("aie5auiayuawyaawyawyw4u7")) do v:Remove() end
	for _, v in pairs( ents.FindByClass( "trigger_hurt" ) ) do v:Remove() end
end

hook.Add("PostCleanupMap", "antipidormapclenup", antipidormapclenup)

hook.Add("PlayerShouldTakeDamage", "No trigger_hurt", function(ply, attacker)
	if (attacker:GetClass() == "trigger_hurt") then
        return false;
    end
end);
