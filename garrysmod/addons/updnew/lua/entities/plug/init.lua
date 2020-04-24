AddCSLuaFile("cl_init.lua") -- Make sure clientside
AddCSLuaFile("shared.lua") -- and shared scripts are sent.
include('shared.lua')

function ENT:Initialize()
    self:PhysicsInit(SOLID_VPHYSICS) -- Make us work with physics,
	self:SetCollisionGroup(COLLISION_GROUP_NONE);
    self:SetSolid(SOLID_VPHYSICS) -- Toolbox
    self:SetUseType(SIMPLE_USE)
	self:SetMoveType(MOVETYPE_VPHYSICS) -- after all, gmod is a physics
    local phys = self:GetPhysicsObject()
	self:SetNWBool("CanPlug", true)
	self:SetModel("models/props_lab/tpplug.mdl")
	

    if (phys:IsValid()) then
        phys:Wake()
    end

    self:SetNWBool("Plugged", false)
	
	if engine.ActiveGamemode() == "cwhl2rp" then
		self.HL2RP = true
	end
end

function ENT:FindPlayerPlug(pos, range)
    local nearestEnt

    for i, entity in ipairs(player.GetAll()) do
        local distance = pos:Distance(entity:GetPos())

        if (distance <= range) then
            nearestEnt = entity
            range = distance
        end
    end

    self:ForceDropEntity2(nearestEnt)
end

function ENT:ForceDropEntity2(player)
    local holdingGrab = player.cwHoldingGrab
    local curTime = CurTime()
    local entity = player.cwHoldingEnt

    if (IsValid(holdingGrab)) then
        constraint.RemoveAll(holdingGrab)
        holdingGrab:Remove()
    end

    if (IsValid(entity)) then
        entity.cwNextTakeDmg = curTime + 1
        entity.cwHoldingGrab = nil
        entity.cwDamageImmunity = CurTime() + 60
    end

    player.nextPunchTime = curTime + 1
    player.cwHoldingEnt = nil
    player.cwHoldingGrab = nil

    return entity
end

function ENT:StartTouch(other)
    if self:GetNWBool("Plugged") == false and self:GetNWBool("CanPlug") == true then
        if other:GetModel() == "models/props_lab/tpplugholder_single.mdl" then
            self:SetNWBool("Plugged", true)
            local phys = self:GetPhysicsObject()
            if phys and phys:IsValid() then
                phys:EnableMotion(false) -- Freezes the object in place.
            end
            self:SetAngles(other:GetAngles() * 1)

			--if self:GetAngles()[2] == -90.00 then
				self:SetPos(other:GetPos() + other:GetForward() * 5 + other:GetUp() * 10 + other:GetRight() * -13)
		--	end


            self:EmitSound("ambient/energy/spark" .. math.random(1, 6) .. ".wav")
			if self.HL2RP == true then
				self:FindPlayerPlug(self:GetPos(), 500)
			end
		if math.random(1,2) == 1 then
		effect = EffectData()
		effect:SetOrigin( self:GetPos() )
		effect:SetEntity( self )
		effect:SetMagnitude( 2 )
		
		util.Effect( "ElectricSpark", effect, true, true )
		end
        end
    end
end

function ENT:Use(activator, caller)


    if self:GetNWBool("Plugged") == true then
		self:SetNWBool("CanPlug", false)
		timer.Simple(3, function()
			self:SetNWBool("CanPlug", true)
		end)
        self:SetNWBool("Plugged", false)
        self:SetPos(self:GetPos() + self:GetForward() * 8)
		timer.Simple(0.01, function()
        local phys = self:GetPhysicsObject()
		 if phys and phys:IsValid() then
            phys:EnableMotion(true) -- Freezes the object in place.
			phys:Wake()
        end
		end)
    end
end

function ENT:Think()
    -- We don't need to think, we are just a prop after all!
end

hook.Add( "EntityTakeDamage", "PlugBlowUp", function( target, dmginfo )

	if ( target:GetClass() == "plug" and dmginfo:IsExplosionDamage() ) then

    if target:GetNWBool("Plugged") == true then
		target:SetNWBool("CanPlug", false)
		timer.Simple(3, function()
			target:SetNWBool("CanPlug", true)
		end)
        target:SetNWBool("Plugged", false)
        target:SetPos(target:GetPos() + target:GetForward() * 8)
		timer.Simple(0.01, function()
        local phys = target:GetPhysicsObject()
		 if phys and phys:IsValid() then
            phys:EnableMotion(true) -- Freezes the object in place.
			phys:Wake()
        end
		end)
    end

	end

end )