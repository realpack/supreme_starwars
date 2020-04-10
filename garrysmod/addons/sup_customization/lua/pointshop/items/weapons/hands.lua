ITEM.Name = 'Кулаки'
ITEM.Price = 5000
ITEM.Model = 'models/starwars/items/bacta_small.mdl'
ITEM.WeaponClass = 'weapon_fists'
ITEM.Material = 'sup_ui/metaui/metainventory/fisticuffs.png'
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
