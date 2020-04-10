ITEM.Name = 'Сумка'
ITEM.Price = 240000
ITEM.Model = 'models/galactic/cosmetics/phase1cosmetics/l3pouch.mdl'
ITEM.Bone = true
ITEM.Slot = 3

function ITEM:OnEquip(ply, modifications)
	ply:PS_AddClientsideModel(self.ID)
end

function ITEM:OnHolster(ply)
	ply:PS_RemoveClientsideModel(self.ID)

    -- PrintTable(PS.ClientsideModels)

    -- PS.ClientsideModels[ply][self.ID]:SetNoDraw(true)
end

function ITEM:ModifyClientsideModel(ply, model, pos, ang)
    -- model:SetParent(ply)
    -- model:AddEffects(EF_BONEMERGE)

	-- model:SetModelScale(0.8, 0)
	-- pos = pos + (ang:Right() * 5) + (ang:Up() * 6) + (ang:Forward() * 2)

	return model, pos, ang
end
