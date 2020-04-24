function GM:Initialize()
    meta.config = {}
end

function GM:PlayerSpawn( pPlayer )
    hook.Call( "PlayerLoadout", GAMEMODE, pPlayer );

    player_manager.SetPlayerClass(pPlayer, team.playerClass or "player_metahub")

    hook.Run("PostPlayerSpawn", player)
    pPlayer.Initialized = true;

	local oldHands = pPlayer:GetHands()

	if (IsValid(oldHands)) then
		oldHands:Remove()
	end

	local handsEntity = ents.Create("gmod_hands")

	if (IsValid(handsEntity)) then
		pPlayer:SetHands(handsEntity)
		handsEntity:SetOwner(pPlayer)

		local info = player_manager.RunClass(pPlayer, "GetHandsModel")

		if (info) then
			handsEntity:SetModel(info.model)
			handsEntity:SetSkin(info.skin)
			handsEntity:SetBodyGroups(info.body)
		end

		local viewModel = pPlayer:GetViewModel(0)
		handsEntity:AttachToViewmodel(viewModel)

		viewModel:DeleteOnRemove(handsEntity)
		pPlayer:DeleteOnRemove(handsEntity)

		handsEntity:Spawn()
	end

	pPlayer:WOSRevive(false)
end

local curent_map = game.GetMap()
local spawn_positions = {}

function pMeta:SetMaxArmor(int)
    self:SetNVar('maxArmor', int or 255, NETWORK_PROTOCOL_PUBLIC)
end

util.AddNetworkString('Player_SetCustomCollisionCheck')

function GM:PlayerLoadout( pPlayer )
	local team = meta.jobs[pPlayer:Team()]

	-- print(team,pPlayer:Team())
	if not (team) then return end

    pPlayer:SetMaxHealth(team.maxHealth or 100);
	pPlayer:SetHealth(team.maxHealth or 100);
	pPlayer:SetArmor(team.maxArmor or 255);
    pPlayer:SetNVar('maxArmor', team.maxArmor or 255, NETWORK_PROTOCOL_PUBLIC)
    pPlayer:SetNVar('maxHealth', team.maxHealth or 100, NETWORK_PROTOCOL_PUBLIC)


    -- PrintTable(team)

	pPlayer:ShouldDropWeapon(false);

	if (pPlayer:FlashlightIsOn()) then
		pPlayer:Flashlight(false);
	end;

	if team.PlayerLoadout then
		timer.Simple(0.1, function()
			team.PlayerLoadout(pPlayer)
		end)
	end

	pPlayer:SetCollisionGroup(COLLISION_GROUP_PLAYER);
	pPlayer:SetMaterial("");
	pPlayer:SetMoveType(MOVETYPE_WALK);
	pPlayer:Extinguish();
	pPlayer:UnSpectate();
	pPlayer:GodDisable();
	pPlayer:ConCommand("-duck");
	pPlayer:SetColor(Color(255, 255, 255, 255));
	pPlayer:SetupHands();

	pPlayer:AllowFlashlight( pPlayer:IsUserGroup('user') or team.flashlight or false )

	pPlayer:SetModelScale(1)

    local rank = pPlayer:GetNVar('meta_rank')
    local feature_weapons = {}
    if rank then
        feature_weapons = (team.FeatureRanks and team.FeatureRanks[rank].weapons) and team.FeatureRanks[rank].weapons or {}
    end

    -- print(feature_weapons)
    -- PrintTable(feature_weapons)

	for _, wep in pairs(feature_weapons) do
		pPlayer:Give(wep)
	end

    pPlayer:SetNoTarget( team.notarget and team.notarget or false )

	for _, wep in pairs(team.weapons) do
		pPlayer:Give(wep)
	end

	pPlayer:Give('weapon_hands')
	pPlayer:SelectWeapon('weapon_hands')

	pPlayer:SetPlayerColor( Vector( 1, 1, 1 ) )

	-- Change some gmod defaults
	pPlayer:SetCrouchedWalkSpeed(0.5);
	pPlayer:SetWalkSpeed(DEFAULT_PLAYER_STATS['WalkSpeed']);
	pPlayer:SetJumpPower(DEFAULT_PLAYER_STATS['JumpPower']);
	pPlayer:SetRunSpeed(DEFAULT_PLAYER_STATS['RunSpeed']);

	pPlayer:SetCustomCollisionCheck(true)

	net.Start('Player_SetCustomCollisionCheck')
		net.WriteEntity(pPlayer)
	net.Broadcast()

    if pPlayer:GetNVar('meta_model') then
        pPlayer:SetModel(pPlayer:GetNVar('meta_model'))
    else
        if istable(team.WorldModel) then
            pPlayer:SetModel(team.WorldModel[math.random(1, #team.WorldModel)])
        else
            pPlayer:SetModel(team.WorldModel)
        end
    end

	-- local spawn_pos = spawn_positions[curent_map][pPlayer:Team()]
	-- if spawn_pos then
	-- 	pPlayer:SetPos(table.Random(spawn_pos))
	-- end

	if pPlayer and team.PlayerSpawn then
		team.PlayerSpawn(pPlayer)
	end

    -- pPlayer:SetCurrentSkillHooks()


	-- Prevent default Loadout.
	return true;
end

function GM:GetFallDamage( ply, flFallSpeed )
	local t = ply:Team()
	if t == TEAM_CONNECTING or t == TEAM_SPECTATOR or t == TEAM_UNASSIGNED then
		return 0
	end


	local features = ply:GetNVar('meta_features')
	if features and features['desu'] then
		return 0
	end

	return (flFallSpeed/10)
end

function GM:PlayerSpawnSWEP(ply, class, info)
	return ply:IsAdmin()
end

function GM:PlayerGiveSWEP(ply, class, info)
	return ply:IsAdmin()
end

function GM:PlayerSpawnEffect(ply, model)
	return ply:IsAdmin()
end

function GM:PlayerSpawnVehicle(ply, model, class, info)
	return ply:IsAdmin()
end

function GM:PlayerSpawnedVehicle(ply, ent)
	return ply:IsAdmin()
end

function GM:PlayerSpawnNPC(ply, type, weapon)
	return ply:IsAdmin()
end

function GM:PlayerSpawnedNPC(ply, ent)
	return ply:IsAdmin()
end

function GM:PlayerSpawnRagdoll(ply, model)
	return ply:IsAdmin()
end

function GM:PlayerSpawnedRagdoll(ply, model, ent)
	return ply:IsAdmin()
end

function GM:PlayerSpawnSENT(ply, class)
    return ply:IsAdmin()
end

function GM:PlayerSpawnProp(ply, model)
    return ply:IsAdmin()
end

function GM:CanPlayerEnterVehicle( pPlayer, vehicle, role )
    local job = meta.jobs[pPlayer:Team()]
    if job and job.candrive then
        return true
    end

    local vehicles = VEHICLES_TYPES
    local features = pPlayer:GetNVar('meta_features')
    -- PrintTable(features)
    -- print(vehicle:GetClass())
    if vehicles['air'][vehicle:GetClass()] then
        if features['air'] then
            return true
        else
            meta.util.Notify('red', pPlayer, 'Вам сначала нужно выучится на Пилота воздушной техники.')
            return false
        end
    end
    if vehicles['land'][vehicle:GetClass()] then
        if features['land'] then
            return true
        else
            meta.util.Notify('red', pPlayer, 'Вам сначала нужно выучится на Водителя наземной техники.')
            return false
        end
    end


    return true
    -- return true
end

function GM:PlayerEnteredVehicle( pPlayer, vehicle, role )
    return false
end

function GM:PlayerUse(pl, ent)
	return true
end

function GM:OnPhysgunFreeze(weapon, phys, ent, pl)
	if ent.PhysgunFreeze and (ent:PhysgunFreeze(pl) == false) then
		return false
	end

	if ( ent:GetPersistent() ) then return false end

	-- Object is already frozen (!?)
	if ( !phys:IsMoveable() ) then return false end
	if ( ent:GetUnFreezable() ) then return false end

	phys:EnableMotion( false )

	-- With the jeep we need to pause all of its physics objects
	-- to stop it spazzing out and killing the server.
	if ( ent:GetClass() == "prop_vehicle_jeep" ) then

		local objects = ent:GetPhysicsObjectCount()

		for i = 0, objects - 1 do

			local physobject = ent:GetPhysicsObjectNum( i )
			physobject:EnableMotion( false )

		end

	end

	-- Add it to the player's frozen props
	pl:AddFrozenPhysicsObject( ent, phys )

	return true
end
