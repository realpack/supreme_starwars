AddCSLuaFile("cl_init.lua") -- Make sure clientside
AddCSLuaFile("shared.lua") -- and shared scripts are sent.
include('shared.lua')
local PLUGIN = PLUGIN

-- Forcefield is taken from nutscript, which is released under a MIT License.
-- https://github.com/Chessnut/hl2rp/blob/1.1/LICENSE
function ENT:SpawnFunction(client, trace)
    local angles = (client:GetPos() - trace.HitPos):Angle()
    angles.p = 0
    angles.r = 0
    angles:RotateAroundAxis(angles:Up(), 270)
    local entity = ents.Create("forcefield_new")
    entity:SetPos(trace.HitPos + Vector(0, 0, 40))
    entity:SetAngles(angles:SnapTo("y", 90))
    entity:Spawn()
    entity:SetName("Forcefield" .. entity:EntIndex())

    return entity
end

function ENT:Initialize()
    self:SetModel("models/props_combine/combine_fence01b.mdl")
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    self:PhysicsInit(SOLID_VPHYSICS)
    local data = {}
    data.start = self:GetPos() + self:GetRight() * -16
    data.endpos = self:GetPos() + self:GetRight() * -480
    data.filter = self
    local trace = util.TraceLine(data)
    local angles = self:GetAngles()
    angles:RotateAroundAxis(angles:Up(), 180)
    self.dummy = ents.Create("prop_physics")
    self.dummy:SetModel(self:GetModel())
    self.dummy:SetPos(trace.HitPos)
    self.dummy:SetAngles(angles)
    self.dummy:Spawn()
    self.dummy.PhysgunDisabled = false
    self:DeleteOnRemove(self.dummy)
    self.dummy:SetName("Forcefield" .. self:EntIndex())

    local verts = {
        {
            pos = Vector(0, 0, -25)
        },
        {
            pos = Vector(0, 0, 150)
        },
        {
            pos = self:WorldToLocal(self.dummy:GetPos()) + Vector(0, 0, 150)
        },
        {
            pos = self:WorldToLocal(self.dummy:GetPos()) + Vector(0, 0, 150)
        },
        {
            pos = self:WorldToLocal(self.dummy:GetPos()) - Vector(0, 0, 25)
        },
        {
            pos = Vector(0, 0, -25)
        }
    }

    self:PhysicsFromMesh(verts)
    self:SetCustomCollisionCheck(true)
    self:EnableCustomCollisions(true)
    self:SetNWEntity("dummynum", self.dummy)
    self:SetName("Forcefield" .. self:EntIndex())
    local physObj = self:GetPhysicsObject()

    if (IsValid(physObj)) then
        physObj:EnableMotion(false)
        physObj:Sleep()
    end

    physObj = self.dummy:GetPhysicsObject()

    if (IsValid(physObj)) then
        physObj:EnableMotion(false)
        physObj:Sleep()
    end

    self:SetMoveType(MOVETYPE_NOCLIP)
    self:SetMoveType(MOVETYPE_PUSH)
    self:MakePhysicsObjectAShadow()
    self.mode = 1

    if engine.ActiveGamemode() == "cwhl2rp" then
        self.HL2RP = true
    end

    timer.Simple(0.5, function()
        if not self:IsValid() then return end
        local plug = ents.Create("plug")
        plug:SetPos(self:GetPos() + self:GetRight() * -20.525 + self:GetUp() * -16)
        plug:SetAngles(self:GetAngles())
        plug:SetModel("models/props_lab/tpplug.mdl")
        plug:Activate()
        plug:SetName("Forcefield" .. self:EntIndex())
        plug:Spawn()
        constraint.Rope(plug, self, 0, 0, Vector(12, 0, 0), Vector(0, 11, 5), 350, 0, 0, 1, "Cable/cable2", false)
    end)

    timer.Create("Forcefield_timer" .. self:EntIndex(), 1.5, 0, function()
        for k, v in pairs(ents.FindByClass("plug")) do
            if v:GetName() == "Forcefield" .. self:EntIndex() then
                if v:GetNWBool("Plugged") == true then
                    TurnOn(self)
					if (!self.loop) then
						self.loop = CreateSound(self, "ambient/machines/combine_shield_loop3.wav")
						self.loop:Play()
						self.loop:ChangeVolume(0.5, 0)
					end
                else
                    TurnOff(self)
					if (self.loop) then
						self.loop:ChangeVolume(0, 0)
						self.loop:Stop()
						self.loop = nil
					end
                end
            end
        end
    end)

	
end



function ENT:StartTouch(entity)
	if (!self.buzzer) then
		self.buzzer = CreateSound(entity, "ambient/machines/combine_shield_touch_loop1.wav")
		self.buzzer:Play()
		self.buzzer:ChangeVolume(0.5, 0)
	else
		self.buzzer:ChangeVolume(0.5, 0.5)
		self.buzzer:Play()
	end

	self.entities = (self.entities or 0) + 1
end

function ENT:EndTouch(entity)
	self.entities = math.max((self.entities or 0) - 1, 0)

	if (self.buzzer and self.entities == 0) then
		self.buzzer:FadeOut(0.5)
	end
end

function ENT:OnRemove()
    if (self.buzzer) then
        self.buzzer:Stop()
        self.buzzer = nil
    end
	if (self.loop) then
	self.loop:ChangeVolume(0, 0)
	self.loop:Stop()
	self.loop = nil
	end
    for k, v in pairs(ents.FindByName("Forcefield" .. self:EntIndex())) do
        v:Remove()
    end

    timer.Remove("Forcefield_timer" .. self:EntIndex())
end

hook.Add("ShouldCollide", "realistic_forcefield", function(a, b)
    local client
    local entity

    if (a:IsPlayer()) then
        client = a
        entity = b
    elseif (b:IsPlayer()) then
        client = b
        entity = a
    elseif (a:GetClass() == "plug" and b:GetClass() == "forcefield_new") then
        return false
    elseif (b:GetClass() == "plug" and a:GetClass() == "forcefield_new") then
        return false
    elseif (a:GetClass() == "prop_physics" and b:GetSkin() == 1) then
        return false
    elseif (b:GetClass() == "prop_physics" and a:GetSkin() == 1) then
        return false
    elseif (a:GetClass() == "cw_item" and b:GetSkin() == 1) then
        return false
    elseif (b:GetClass() == "cw_item" and a:GetSkin() == 1) then
        return false
    elseif (a:IsVehicle() and b:GetSkin() == 1) then
        return false
    elseif (b:IsVehicle() and a:GetSkin() == 1) then
        return false
    elseif (a:GetModel() == "models/combine_apc.mdl") then
        return false
    elseif (b:GetModel() == "models/combine_apc.mdl") then
        return false
    elseif (a:IsNPC() and a:GetClass() == "npc_combine_s" or a:GetClass() == "npc_metropolice") then
        return false
    elseif (b:IsNPC() and b:GetClass() == "npc_combine_s" or a:GetClass() == "npc_metropolice") then
        return false
    elseif (a:IsNPC() and b:GetSkin() == 1) then
        return false
    elseif (b:IsNPC() and a:GetSkin() == 1) then
        return false
    end

    if (IsValid(entity) and entity:GetClass() == "forcefield_new") then
        if (IsValid(client)) then
            if (string.find(client:GetModel():lower(), "combine") or string.find(client:GetModel():lower(), "metrocop") or string.find(client:GetModel():lower(), "civilprotection") or string.find(client:GetModel():lower(), "police") or string.find(client:GetModel():lower(), "breen")) then return false end

            if entity.HL2RP == true then
                if (Schema:PlayerIsCombine(client)) then return false end
            end

            if (entity:GetSkin() == 1) then return false end

            return true
        end
    end
end)

function TurnOff(self)
    for k, v in pairs(ents.FindByName("Forcefield" .. self:EntIndex())) do
        v:SetSkin(1)
    end
end

function TurnOn(self)
    for k, v in pairs(ents.FindByName("Forcefield" .. self:EntIndex())) do
        v:SetSkin(0)
    end
end