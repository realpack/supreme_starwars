local function MakeInvisible(player, invisible)
	player:SetNoDraw(invisible);
	player:SetNotSolid(invisible);

	player:DrawViewModel(!invisible);
	player:DrawWorldModel(!invisible);

	if (invisible) then
		player:GodEnable();
	else
		player:GodDisable();
	end;
end;

local function PlayerSpawn(pPlayer)
	pPlayer:SetNWBool("Ragdolled", false)

	MakeInvisible(pPlayer, false);
	pPlayer:SetNWBool("Ragdolled", false)
	if pPlayer and pPlayer.eRagdoll and IsValid(pPlayer.eRagdoll) then
		netstream.Start(player.GetAll(), "DeleteRagdollClothes", pPlayer.eRagdoll)
		timer.Simple(0.3,function()
			pPlayer.eRagdoll:Remove();
		end)
	end

	-- pPlayer:SetParent(NULL);
	-- pPlayer:ConCommand("pp_motionblur 0")
	-- pPlayer:ConCommand("pp_colormod 0")
end
hook.Add("PlayerLoadout", "PlayerSpawnSF", PlayerSpawn)

local function CreateRagdoll(pPlayer)
	pPlayer:SetNWBool("Ragdolled", true)

	pPlayer.eRagdoll = ents.Create("prop_ragdoll");
	pPlayer.eRagdoll:SetPos(pPlayer:GetPos());
	pPlayer.eRagdoll:SetModel(pPlayer:GetModel());
	pPlayer.eRagdoll:SetAngles(pPlayer:GetAngles());
	pPlayer.eRagdoll:SetSkin(pPlayer:GetSkin());
	pPlayer.eRagdoll:SetMaterial(pPlayer:GetMaterial());
	pPlayer.eRagdoll:Spawn();
	pPlayer.eRagdoll.player = pPlayer
    pPlayer.eRagdoll:SetNWEntity('Player', pPlayer)
    pPlayer.eRagdoll:SetCustomCollisionCheck( true )

	pPlayer.eRagdoll:SetCollisionGroup(COLLISION_GROUP_NONE);

    -- print(pPlayer.eRagdoll)

	local velocity = pPlayer:GetVelocity();
	local physObjects = pPlayer.eRagdoll:GetPhysicsObjectCount() - 1;

	for i = 0, physObjects do
		local bone = pPlayer.eRagdoll:GetPhysicsObjectNum(i);

		if (IsValid(bone)) then
			local position, angle = pPlayer:GetBonePosition(pPlayer.eRagdoll:TranslatePhysBoneToBone(i));

			if (position and angle) then
				bone:SetPos(position);
				bone:SetAngles(angle);
			end;

			bone:AddVelocity(velocity);
		end;
	end;

	pPlayer.OldWeapons = {}
	for _, eWep in pairs(pPlayer:GetWeapons()) do
		table.insert(pPlayer.OldWeapons,eWep:GetClass())
	end

	pPlayer:StripWeapons();
	-- pPlayer:SetMoveType(MOVETYPE_OBSERVER);
	-- pPlayer:Spectate(OBS_MODE_CHASE);
	-- pPlayer:SpectateEntity(pPlayer.eRagdoll);
	-- pPlayer:SetParent(pPlayer.eRagdoll);

	MakeInvisible(pPlayer, true);
end

local function DoPlayerDeath( pPlayer)
	CreateRagdoll(pPlayer)
	return false
end
hook.Add("DoPlayerDeath", "GetRagdoll", DoPlayerDeath)

function PlayerDisconnected( pPlayer )
	if pPlayer.eRagdoll and IsValid(pPlayer.eRagdoll) then
		pPlayer.eRagdoll:Remove()
		pPlayer.eRagdoll = nil
	end
end
hook.Add("PlayerDisconnected", "RemoveRagdoll", PlayerDisconnected)
