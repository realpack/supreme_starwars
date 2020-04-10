
local hooks = {
    "Effect",
    "NPC",
    "Ragdoll",
    "SENT",
    "Vehicle"
}


for _, v in pairs (hooks) do


    hook.Add("PlayerSpawn"..v, "Disallow_user_"..v, function(client)
        if (client:IsUserGroup("founder") or (client:IsUserGroup("commander") or (client:IsUserGroup("euclid") or (client:IsUserGroup("keter") or (client:IsUserGroup("thaumiel") or (client:IsUserGroup("afina") or (client:IsUserGroup("moderator") or client:IsUserGroup("serverstaff") or client:IsUserGroup("apollo")))))))) then
            return true
        end
        
        return false
    end)
    
end