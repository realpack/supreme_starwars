TOOL.Category		=	"MetaHub tools"
TOOL.Name			=	"Spawn Points"
TOOL.Command		=	nil
TOOL.ConfigName		=	""

if CLIENT then
	language.Add("tool.spawn_points.name", "Spawn Points")
	language.Add("tool.spawn_points.0", "Гайд для дауна:\n Как юзать спавнпоинты.\n 1 - выбираем категорию\n 2 - ставим спавн\n ЛКМ - поставить спавнер\n R по спавнеру - обновление категории\n ПКМ - удалить спавнер")
	language.Add("tool.spawn_points.desc", "Взрывает пуканы других инвентолгов")
end

-- local category
-- timer.Simple(0, function()
--     category = CreateClientConVar( "spawnpoints_category_new", 'cadets', true, false )
-- end)
TOOL.ClientConVar[ "category" ] = 'cadets'
TOOL.ClientConVar[ "control" ] = 0

function TOOL:LeftClick( trace )
	if CLIENT and (self.NextUse or 0) <= CurTime() then
        netstream.Start('SpawnPoint_Create', { vector = trace.HitPos, category = self:GetClientInfo( "category" ), control_dep=self:GetClientInfo( "control" ) })
        self.NextUse = CurTime() + 1
        return true
    elseif SERVER then
        timer.Simple(0, function()
            netstream.Start(self:GetOwner(), 'SpawnPoints_SendAllPlayerInfoStarts', GetInfoAllSpawns())
        end)
    end
end

function TOOL:Deploy()
    if SERVER and (self.NextQuery or 0) <= CurTime() then
        self.NextQuery = CurTime() + 1
        local spawns = GetInfoAllSpawns()

	    netstream.Start(self:GetOwner(), 'SpawnPoints_SendAllPlayerInfoStarts', spawns)
    end
end

if CLIENT then
    meta.spawns = meta.spawns or {}
    netstream.Hook('SpawnPoints_SendAllPlayerInfoStarts', function(spawns)
        meta.spawns = spawns
    end)
end

local function CanDrawSpawnPoints()
    if LocalPlayer() and IsValid(LocalPlayer()) and
        LocalPlayer():Alive() and IsValid(LocalPlayer():GetActiveWeapon()) and
        LocalPlayer():GetActiveWeapon():GetClass() ~= 'gmod_tool' or (LocalPlayer():GetTool() and LocalPlayer():GetTool().Mode ~= 'spawn_points') then
        return true
    end

    return false
end

hook.Add( "PostDrawTranslucentRenderables", "test", function()
    if CanDrawSpawnPoints() then
        return
    end

    local tool = LocalPlayer():GetTool()

	render.SetColorMaterial()

    if meta.spawns then
        for k, ent in pairs(meta.spawns) do
            render.DrawBox( ent.pos, Angle(0,0,0), Vector(16,16,0), Vector(-16,-16,80), Color( 0, 175, 175, 100 ), true )
            local ang = Angle(0, EyeAngles().y - 90, 90)
        end
    end
end )

function TOOL:DrawHUD()
    if CanDrawSpawnPoints() then
        return
    end

    for k, ent in pairs(ents.FindByClass('spawn_point')) do
        local v = (ent:GetPos()+Vector(0,0,0)):ToScreen()
        local category = ent.category and ent.category or 'Нету'

        -- draw.ShadowSimpleText('ID: '..ent:GetNWString('SpawnPointID'), "font_base_12", v.x, v.y-12, Color( 255, 255, 255, 255 ), 1, 1)
        draw.ShadowSimpleText('Category: '..ent:GetNWString('Category'), "font_base_12", v.x, v.y, Color( 255, 255, 255, 255 ), 1, 1)
    end
end

function TOOL:RightClick( trace )
    if SERVER then
        local owner = self:GetOwner()
        local target = trace.Entity

        MySQLite.query( string.format( "DELETE FROM `metahub_spawnpoints` WHERE map = %s AND vector = %s;", MySQLite.SQLStr(game.GetMap()), MySQLite.SQLStr(target:GetPos()) ), function(data)
            target:Remove()
        end)
    end

    return true
end

function TOOL:Reload( trace )
    local owner = self:GetOwner()
    local target = trace.Entity

    netstream.Start('SpawnPoint_Reload', {vector=tostring(target:GetPos()), category=self:GetClientInfo( "category" ), target=target, control_dep=self:GetClientInfo( "control" )})

    return true
end

print(1)
function TOOL.BuildCPanel( CPanel )
    print(2)

    local control_dep = CPanel:AddControl( "CheckBox", { Label = "Зависимость от Control Points", Command = "spawn_points_control" } )
    local combo = CPanel:ComboBox("Катигория профессий", "spawn_points_category")
    for name, teams in pairs(SPAWNPOINTS_CATEGORIES) do
		combo:AddChoice( name )
	end

    function control_dep:Think()
        combo:SetDisabled(control_dep:GetChecked())
    end
end
