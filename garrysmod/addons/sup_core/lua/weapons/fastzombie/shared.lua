if SERVER then AddCSLuaFile() end

if CLIENT then

    SWEP.PrintName      = "R2D2 Sound Gun"
    SWEP.Author         = "Ukushino"
    SWEP.Slot           = 0
    SWEP.SlotPos        = 1
    
end

SWEP.Category               = "Star Wars"
SWEP.ViewModelFlip          = false
SWEP.ViewModelFOV           = 60

SWEP.Spawnable              = true
SWEP.AdminOnly              = false
SWEP.UseHands               = false

SWEP.ViewModel              = "models/weapons/c_arms_hev.mdl"
SWEP.WorldModel             = ""

SWEP.Weight                 = 1
SWEP.AutoSwitchTo           = true
SWEP.AutoSwitchFrom         = true

SWEP.Primary.Recoil         = 0
SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = false
SWEP.Primary.Ammo           = "none"
SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo         = "none"

function SWEP:Initialize()
    timer.Simple(0.2, function()
        self:SetHoldType("idle")
    end)
    self:SetHoldType("idle")
end


local a = "ambient/creatures/town_scared_sob2.wav"
local b = "ambient/creatures/town_scared_breathing1.wav"
local c = "ambient/creatures/town_zombie_call1.wav" 

function SWEP:PrimaryAttack()
    self:EmitSound(a)
end

function SWEP:SecondaryAttack()
    self:EmitSound(b)
end

function SWEP:Reload()
    self:EmitSound(c)
end
