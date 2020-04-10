ITEM.Name = 'Термальный Детонатор'
ITEM.Price = 400000
ITEM.Model = 'models/starwars/items/bacta_small.mdl'
ITEM.WeaponClass = 'zeus_thermaldet'
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
