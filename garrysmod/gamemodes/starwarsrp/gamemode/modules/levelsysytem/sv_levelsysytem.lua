-- function pMeta:SetLevel(intCount)
-- 	-- self:SavePlayerData('level',intCount)
--     MySQLite.query( string.format( "UPDATE metahub_player_levelsystem SET %s = %s WHERE steam_id = %s;",
--         'level',
--         MySQLite.SQLStr( intCount ),
--         MySQLite.SQLStr( self:SteamID() )
--     ))

-- 	self:SetNVar('meta_level',intCount,NETWORK_PROTOCOL_PUBLIC)

-- 	local effectdata = EffectData()
-- 	effectdata:SetEntity(self)
-- 	effectdata:SetStart(self:GetPos())
-- 	effectdata:SetOrigin(self:GetPos())
-- 	effectdata:SetScale(1)
-- 	util.Effect("entity_remove", effectdata)

-- 	-- self:EmitSound('garrysmod/save_load'..math.random(4)..'.wav')
-- 	self:EmitSound('ui/achievement_earned.wav')
-- end

-- function pMeta:AddLevel(intCount)
-- 	intCount = self:GetLevel() + intCount
-- 	self:SetLevel(intCount)
-- end

-- function pMeta:SetExperience(intCount)
-- 	-- self:SavePlayerData('experience',intCount)
--     MySQLite.query( string.format( "UPDATE metahub_player_levelsystem SET %s = %s WHERE steam_id = %s;",
--         'experience',
--         MySQLite.SQLStr( intCount ),
--         MySQLite.SQLStr( self:SteamID() )
--     ))

-- 	self:SetNVar('meta_experience',intCount,NETWORK_PROTOCOL_PUBLIC)

-- 	self:isPassedLevel()
-- end

-- function pMeta:AddExperience(intCount)
-- 	intCount = self:GetExperience() + intCount
-- 	self:SetExperience(intCount)
-- end

-- function pMeta:isPassedLevel()
-- 	if (self:GetExperience() >= self:GetNeedExperience()) then
-- 		self:AddLevel(1)
-- 		self:SetExperience(0)
-- 	end
-- end

-- timer.Create("LevelTimer",60,0,function()
-- 	for _, pPlayer in ipairs(player.GetAll()) do
-- 		if not IsValid(pPlayer) or not pPlayer:Alive() then continue end

-- 		local expCount = math.random(30,60)*(pPlayer:GetLevel() or 0)
-- 		pPlayer:AddExperience(expCount)
-- 		-- TODO: notify
-- 		-- print(expCount..' > '..pPlayer:Name())
-- 	end
-- end)

-- timer.Create("MoneyTimer",1200,0,function()
-- 	for _, pPlayer in ipairs(player.GetAll()) do
-- 		if not IsValid(pPlayer) or not pPlayer:Alive() then continue end

-- 		-- local expCount = math.random(30,60)*pPlayer:GetLevel()
-- 		-- pPlayer:AddExperience(expCount)

--         -- local job_price = meta.jobs[pPlayer:Team()].Salary

--         if job_price then
--             meta.util.Notify('blue', pPlayer, 'Вы получили '..formatMoney(job_price)..' за то что играете на нашем сервере.')
--             pPlayer:AddMoney(job_price)
--         end
-- 		-- TODO: notify
-- 		-- print(expCount..' > '..pPlayer:Name())
-- 	end
-- end)

local npc_price = 8
hook.Add('OnNPCKilled', 'Levelsystem_OnNPCKilled', function( npc, attacker, inflictor )
    if attacker and attacker:IsPlayer() then
        meta.util.Notify('blue', attacker, 'Вы убили NPC, и получили за это '..formatMoney(npc_price)..'.')
        attacker:AddMoney(npc_price)
    end
end)

local player_price = 200
hook.Add('PlayerDeath', 'Levelsystem_PlayerDeath', function( victim, inflictor, attacker )
    if attacker and attacker:IsPlayer() and victim ~= attacker then
        meta.util.Notify('blue', attacker, 'Вы убили игрока, и получили за это '..formatMoney(player_price)..'.')
        attacker:AddMoney(player_price)
    end
end)
