AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function SWEP:PrimaryAttack()
    -- print(self.Owner)
    local player = self.Owner
    local trace = player:GetEyeTrace()

    local target = trace.Entity

    local bool = not target.IsHandcuffed
    if bool and target.GetPlayerHandcuffed then return end

    if target and IsValid(target) and target:IsPlayer() and not target.IsHandcuffed then
        if target:GetPos():DistToSqr(player:GetPos()) < 13000 then
            -- target.IsHandcuffed = target.IsHandcuffed and true or false
            
            target:ProgressCuffed(true,player)
        end
    end

	return
end

function SWEP:SecondaryAttack()
    local player = self.Owner
    local trace = player:GetEyeTrace()

    local target = trace.Entity

    -- if target.GetPlayerHandcuffed and IsValid(target.GetPlayerHandcuffed) and target.GetPlayerHandcuffed:GetClass() == 'handcuffs_point' then
    --     target.GetPlayerHandcuffed:Remove()
    --     target:ProgressCuffed(true,player)
    -- end
    
    if target.GetPlayerHandcuffed and target.GetPlayerHandcuffed ~= player and target.GetPlayerHandcuffed:GetClass() == 'handcuffs_point' then return end

    if target and IsValid(target) and target:IsPlayer() then
        target:ProgressCuffed(false, target.GetPlayerHandcuffed)
    end

	return
end