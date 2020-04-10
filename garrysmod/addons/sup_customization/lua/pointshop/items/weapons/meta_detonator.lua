ITEM.Name = 'Детонатор'
ITEM.Price = 500000
ITEM.Model = 'models/weapons/w_swrcdeton.mdl'
ITEM.WeaponClass = 'm9k_suicide_bomb'
ITEM.Material = 'sup_ui/metaui/metainventory/detonator.png'
-- ITEM.SingleUse = false

function ITEM:OnBuy(ply)
	ply:Give(self.WeaponClass)
	ply:SelectWeapon(self.WeaponClass)
end

function ITEM:OnHolster(ply)
	ply:StripWeapon(self.WeaponClass)
end

function ITEM:OnEquip(ply)
	ply:Give(self.WeaponClass)
	ply:SelectWeapon(self.WeaponClass)
end

function ITEM:OnSell(ply)
	ply:StripWeapon(self.WeaponClass)
end
