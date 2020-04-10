cleanup.Register( "props" )
cleanup.Register( "ragdolls" )
cleanup.Register( "effects" )
cleanup.Register( "npcs" )
cleanup.Register( "constraints" )
cleanup.Register( "ropeconstraints" )
cleanup.Register( "sents" )
cleanup.Register( "vehicles" )


local function MakeInvisible(ply, invisible)
    ply:SetNoDraw(invisible)
    ply:SetNotSolid(invisible)

    ply:DrawViewModel(not invisible)
    ply:DrawWorldModel(not invisible)

    if (invisible) then
        ply:GodEnable()
    else
        ply:GodDisable()
    end
end

-- function GM:PlayerNoClip( pl, on )
	-- return true
-- end


if (SERVER) then
	function GM:PlayerShouldTakeDamage( ply, attacker )
		return true
	end

	function GM:CreateEntityRagdoll( entity, ragdoll )
		-- Replace the entity with the ragdoll in cleanups etc
		undo.ReplaceEntity( entity, ragdoll )
		cleanup.ReplaceEntity( entity, ragdoll )
	end

	function GM:CanEditVariable( ent, ply, key, val, editor )
		return false
	end

	return
end

function GM:OnUndo(name, strCustomString)
	notification.AddLegacy((strCustomString and strCustomString or "#Undone_" .. name), NOTIFY_UNDO, 2)

	surface.PlaySound( "buttons/button15.wav" )
end

function GM:OnCleanup( name )
	notification.AddLegacy("#Cleaned_" .. name, NOTIFY_CLEANUP, 5)

	surface.PlaySound( "buttons/button15.wav" )
end

-- function PLAYER:GetTool( mode )
-- 	local wep = self:GetWeapon( 'gmod_tool' )
-- 	if (!wep || !wep:IsValid()) then return nil end

-- 	local tool = wep:GetToolObject( mode )
-- 	if (!tool) then return nil end

-- 	return tool
-- end

function PLAYER:GetTool( mode )

    local wep
    for _, ent in pairs( ents.FindByClass( "gmod_tool" ) ) do
        if ( ent:GetOwner() == self ) then wep = ent break end
    end
    if (!IsValid( wep )) then return nil end

    local tool = wep:GetToolObject( mode )
    if ( !tool ) then return nil end

    return tool

end
