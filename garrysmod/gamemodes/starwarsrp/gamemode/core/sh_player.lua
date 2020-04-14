local pmeta = FindMetaTable("Player")
pmeta.OldName = pmeta.OldName or pmeta.Name
function pmeta:Name()
	local rpname = self:GetNWString( "rpname" )
	local rpid = self:GetRPID()
	local rank = self:GetNWString('meta_rank')

	-- local cp_rpname = self:GetNWString( "cp_rpname" )

	-- if cp_rpname then
	-- 	local tm = self:Team()
	-- 	if tm and TEAMS_CP_PREFIXES and TEAMS_CP_PREFIXES[tm] then
	-- 		local cp_refix = TEAMS_CP_PREFIXES[tm]

	-- 		if cp_rpname ~= '' and cp_refix then
	-- 			return string.format(cp_refix, team.GetName(tm), cp_rpname)
	-- 		end
	-- 	end
	-- end

	-- if CLIENT and LocalPlayer():IsAdmin() then
	-- 	return (rpname or self:OldName()) .. (self:GetRPID() ~= '' and ' ['..self:GetRPID()..']' or '')
	-- end

	-- return self:OldName()

	if self:Team() == TEAM_SPECTATOR or self:Team() == TEAM_UNASSIGNED then
		return self:OldName()
	end

	if not HIDE_NICKS_RANKS[rank] then
		return rpname or self:OldName()
	end

	return rpid ~= '' and tostring(rpid) or rpname


	-- return (not rpid or rpid == '') and (tostring(rpid) or self:OldName() or rpname) or rpname
	-- return tostring(rpid ~= '' and HIDE_NICKS_RANKS[rank] and rpid or (rpname or self:OldName()))
end
pmeta.GetName = pmeta.Name
pmeta.Nick = pmeta.Name

function pMeta:GetRPID()
	local job = meta.jobs[self:Team()]
	if job and job.Type == TYPE_CLONE then
		return self:GetNWString('meta_rpid')
	end

	return ''
end

function pMeta:NameWithSteamID()
	local name = self:Name() or self:OldName()
	return name..'('..self:SteamID()..')'
end

function pMeta:GetMoney()
	return self:GetNVar('meta_money')
end

function pMeta:isEnoughMoney(intCount)
	return tonumber(self:GetMoney()) >= tonumber(intCount)
end

-- function GM:PlayerNoClip(ply)
--     return ply:IsAdmin()
-- end

function GM:PlayerShouldTaunt(pl, actid) return true end
function GM:CanTool(pl, trace, mode) return pl:IsAdmin() end

hook.Add("ShouldCollide", "SpawnPoints_ShouldCollide", function( ent1, ent2 )
    -- print(ent1, ent2)
    if IsValid( ent1 ) and IsValid( ent2 )  then
        if (ent1:IsPlayer() and ent2:GetClass() == 'spawn_point') or (ent2:IsPlayer() and ent1:GetClass() == 'spawn_point') then
            return false
        end
        
        if ent1:GetClass() == 'prop_ragdoll' or ent2:GetClass() == 'prop_ragdoll' then
            return false
        end
    end

    -- We must call this because anything else should return true.
    return true
end)
