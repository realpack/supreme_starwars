ITEM.Name = 'GILE-45'
ITEM.Price = 300000
ITEM.Model = 'models/galactic/weapons/vmodels/supde10.mdl'
ITEM.WeaponClass = 'sup_de10'
ITEM.Material = 'sup_ui/metaui/metainventory/dc17.png'
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
