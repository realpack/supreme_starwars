ITEM.Name = 'DC-15sa'
ITEM.Price = 250000
ITEM.Model = 'models/galactic/weapons/vmodels/supdc15sa.mdl'
ITEM.WeaponClass = 'sup_dc15sa'
ITEM.Material = 'sup_ui/metaui/metainventory/pistol.png'
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
