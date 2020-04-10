AddCSLuaFile()


SWEP.PrintName = 'Republic AT Launcher'
SWEP.Author = 'Scott'
SWEP.HoldType = 'rpg'
SWEP.Category = 'SUP Starwars Weapons'
SWEP.UseHands = false 

SWEP.Slot = 3
SWEP.SlotPos = 1
SWEP.Spawnable = true
SWEP.WorldModel = 'models/galactic/weapons/wmodels/supclonerocketworld.mdl'
SWEP.ViewModel = 'models/galactic/weapons/vmodels/supclonerocket.mdl'

local fire = Sound 'weapons/sw_rocket/rocket_fire.wav'
local reload = Sound 'weapons/dc17m_at_reload.wav'

game.AddAmmoType({
	name = 'ammo_e60r',
	dmgtype = DMG_BLAST,
	tracer = TRACER_LINE_AND_WHIZ,
	plydmg = 0,
	npcdmg = 0,
	force = 0,
	minsplash = 0,
	maxsplash = 0
})

SWEP.Primary.ClipSize = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = 'ammo_e60r'
SWEP.Primary.Tracer = 0
SWEP.Primary.TracerName = 'none'

SWEP.AnimPrefix = 'rpg'
SWEP.ViewModelFlip = false
SWEP.DrawCrosshair = false

function SWEP:Initialize()
	self:SetHoldType 'rpg'
end

function SWEP:CanPrimaryAttack()
	if self:Clip1() <= 0 then
		self:SetNextPrimaryFire(CurTime() + 0.2)
		self:EmitSound 'Weapon_Pistol.Empty'
		return false
	end
	return true
end

function SWEP:PrimaryAttack()
	if not IsFirstTimePredicted() then return end
	if not self:CanPrimaryAttack() then return end
	if CLIENT then return false end

	local owner = self:GetOwner()
	local ent = ents.Create 'e60r_rocket'
	if not IsValid(ent) then
		return
	end

	local aim = owner:GetAimVector()
	local side = aim:Cross(Vector(0,owner:Crouching() and 2.5 or 0,1))
	local up = side:Cross(aim)
	local pos = owner:GetShootPos() +  aim * 24 + side * 8 + up * -1

	ent:SetOwner(owner)
	ent:SetPos(pos)
	ent:SetAngles(aim:Angle())
	ent:Spawn()
	ent:Activate()

	self:EmitSound(fire)
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self:SetNextPrimaryFire(CurTime() + 1)
	self:SetClip1(0)
end

function SWEP:SecondaryAttack()
	return false
end

function SWEP:Reload()
	if not IsFirstTimePredicted() or (self.nextreload and self.nextreload > CurTime()) then 
		return 
	end

	self.nextreload = CurTime() + 20

	if self:Clip1() <= 0 then
		if self:DefaultReload(ACT_VM_RELOAD) then
			self:SetNextPrimaryFire(self.nextreload)
			self:EmitSound(reload)
		end
	end
end

function SWEP:Deploy()
	self:SetHoldType('rpg')
	if self:Clip1() > 0 then
		self:SendWeaponAnim(ACT_VM_DEPLOY)
	else
		self:SendWeaponAnim(ACT_VM_DEPLOY_EMPTY)
	end
end

function SWEP:Holster()
	return true
end