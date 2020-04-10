SWEP.ViewModel = "models/weapons/v_slam.mdl"
SWEP.WorldModel = "models/weapons/w_suitcase_passenger.mdl"
SWEP.HoldType = "normal"
SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo		= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= "none"

SWEP.Category 				= "SUP | Разное"

function SWEP:SetupDataTables()
  self:NetworkVar("Bool",0,"AllTalk")
  self:NetworkVar("Int",0,"Distance")

  if SERVER then
    self:SetAllTalk(false)
    self:SetDistance(302500)
  end
end

list.Add( "NPCUsableWeapons", { class = "announce",	title = "Amplifier" } )

if CLIENT then
	function SWEP:DrawHUD()
		local ply = LocalPlayer()

		local x, y = ScrW()-350, ScrH()-50

		draw.ShadowSimpleText("R - Смена Голоса (На всю карту / Локальный)", "font_base_18", x, y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
		draw.ShadowSimpleText("ЛКМ / ПКМ - Отдаление Радиуса Голоса", "font_base_18", x, y+20, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
	end
end
