ITEM.Name = 'EMP Граната'
ITEM.Price = 500000
ITEM.Model = 'models/starwars/items/bacta_small.mdl'
ITEM.WeaponClass = 't3m4_empgrenade'
ITEM.Material = 'sup_ui/metaui/metainventory/thermal_grenade.png'
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
