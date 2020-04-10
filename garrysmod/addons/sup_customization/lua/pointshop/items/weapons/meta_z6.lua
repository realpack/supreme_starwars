ITEM.Name = 'Пулемёт Z6'
ITEM.Price = 2500000
ITEM.Model = 'models/galactic/weapons/vmodels/supz6.mdl'
ITEM.WeaponClass = 'sup_z6'
ITEM.Material = 'sup_ui/metaui/metainventory/z6.png'
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
