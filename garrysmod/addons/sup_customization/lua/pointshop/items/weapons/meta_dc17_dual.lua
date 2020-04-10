ITEM.Name = 'Двойные DC-17'
ITEM.Price = 600000
ITEM.Model = 'models/galactic/weapons/wmodels/supdc17sdualworld.mdl'
ITEM.WeaponClass = 'sup_dc17_dual'
ITEM.Material = 'sup_ui/metaui/metainventory/dc17_dual.png'
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
