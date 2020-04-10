AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "Дефибриллятор"
	SWEP.Slot = 2
	SWEP.SlotPos = 1
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end

SWEP.Author				= "pack"
SWEP.Purpose    			= ""

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false

SWEP.AnimPrefix	 = "rpg"
SWEP.UseHands = true

SWEP.Category = "SUP | Медицина"
SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.ViewModel				= "models/weapons/custom/v_defib.mdl"
SWEP.WorldModel				= "models/weapons/custom/w_defib.mdl"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

if CLIENT then
	function SWEP:GetViewModelPosition( Pos, Ang )
		//Ang:RotateAroundAxis(Ang:Forward(), 90);
		//Pos = Pos + Ang:Forward() * 3;
		-- Pos = Pos + Ang:Up() * 6;

		return Pos, Ang;
	end
end

function SWEP:Initialize()
	self:SetHoldType( "pistol" )
end

function SWEP:Deploy()
	self:SetHoldType("duel")
	self.Owner:GetViewModel():SetPlaybackRate(5)
	return true
end

function SWEP:PrimaryAttack()
	timer.Simple(0.9,function()
		if SERVER then
			local eTrace = self.Owner:GetEyeTrace().Entity
			local pPlayer = eTrace.player
			if eTrace:GetClass() == 'prop_ragdoll' and (pPlayer and IsValid(pPlayer)) then
				pPlayer:Spawn()
				pPlayer:SetHealth(math.random(100))
				pPlayer:SetPos(eTrace:GetPos())
				for _, strWep in pairs(pPlayer.OldWeapons) do
					pPlayer:Give(strWep)
				end

				self.Owner:PS_GivePoints(150)
				meta.util.Notify('green', self.Owner, "Вы вернули к жизни раненного бойца! Республика поощряет такие действия, получите 150 РК")
			elseif (eTrace:IsPlayer() and IsValid(eTrace)) then
				eTrace:TakeDamage(math.random(10))
			elseif eTrace:GetClass() == 'money_printer' then
				eTrace:TakeDamage(100)
			end
		end
		self:EmitSound("ambient/energy/zap1.wav",40)
		self.Owner:SetAnimation(PLAYER_ATTACK1)
	end)
	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK);
	self:SetNextPrimaryFire(CurTime() + 6)
end

function SWEP:PreDrawViewModel( vm,pl,wep)
	return false
end
