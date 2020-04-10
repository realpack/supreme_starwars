include("shared.lua")
util.PrecacheModel("models/kingpommes/starwars/venator/vanilla/turbolaser_bolt.mdl")

function ENT:Initialize()
    self.bolt = ClientsideModel("models/kingpommes/starwars/venator/vanilla/turbolaser_bolt.mdl",RENDERGROUP_BOTH)
    if self:GetColour() == "Blue" then
        self.bolt:SetSkin(0)
    elseif self:GetColour() == "Red" then
        self.bolt:SetSkin(1)
    elseif self:GetColour() == "Green" then
        self.bolt:SetSkin(2)
    elseif self:GetColour() == "Orange" then
        self.bolt:SetSkin(3)
    elseif self:GetColour() == "Yellow" then
        self.bolt:SetSkin(4)
    elseif self:GetColour() == "Pink" then
        self.bolt:SetSkin(5)
    elseif self:GetColour() == "Black" then
        self.bolt:SetSkin(6)
    end
end

function ENT:Draw()
    --self:DrawModel()
end

function ENT:Think()
    self.bolt:SetPos(self:GetPos())
    self.bolt:SetAngles(self:GetAngles())
    if ! self:IsValid() then
        self.bolt:Remove()
    end
end

function ENT:OnRemove()
    self.bolt:Remove()
end

language.Add("turbolaser", "Turbolaser")

/*
    - Fixed a bug where an error would be displayed.
*/
