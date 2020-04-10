AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel('models/galactic/supnpc/shopdroid/shopdroid.mdl')

	self:SetHullType( HULL_HUMAN )
    self:SetHullSizeNormal()
    self:SetSolid( SOLID_BBOX )
    self:SetMoveType( MOVETYPE_STEP )
    self:CapabilitiesAdd( CAP_ANIMATEDFACE + CAP_TURN_HEAD )
    self:SetUseType( SIMPLE_USE )
    self:DropToFloor()
end


function ENT:OnTakeDamage(dmginfo)
	return
end

function ENT:AcceptInput(inputName, user)
    netstream.Start(user,'VehiclesSales_OpenMenu',nil)
end

netstream.Hook("VehiclesSales_ReturnVehicle", function(pPlayer, data)
    local class = data.class
    for k, e in pairs( ents.FindByClass(class) ) do
        if e.VehicleSalesPlayer == pPlayer then
            e:Remove()
        end
    end
end)

netstream.Hook("VehiclesSales_BuyVehicle", function(pPlayer, data)
    local class = data.class
    local vehicle = false

	local trace = pPlayer:GetEyeTrace()
	local target = trace.Entity

	if target:GetClass() ~= 'vehicles_sales' then return end

    local features = pPlayer:GetNVar('meta_features')
    for feature, data in pairs(VEHICLES_FEATURES) do
        for cl, veh in pairs(data) do
            if cl == class then
                if features[feature] then
                    vehicle = veh
                else
                    meta.util.Notify('red', pPlayer, 'Вам не доступна эта техника.')
                    return -- break
                end
                break
            end
        end
    end

    if vehicle and pPlayer:PS_GetPoints() >= vehicle.price then
        local tbl = pPlayer:GetNVar('meta_vehicles')
        tbl[class] = true

        pPlayer:SavePlayerData('vehicles', util.TableToJSON(tbl), false)
        pPlayer:SetNVar('meta_vehicles', tbl, NETWORK_PROTOCOL_PUBLIC)

        pPlayer:PS_TakePoints(vehicle.price)
    else
        meta.util.Notify('red', pPlayer, 'У вас не хватает денег.')
    end
end)

netstream.Hook("VehiclesSales_SpawnVehicle", function(pPlayer, data)
    local vehicle_class = data.class
    local point = data.point

    local tbl = pPlayer:GetNVar('meta_vehicles')

	local trace = pPlayer:GetEyeTrace()
	local target = trace.Entity

	if target:GetClass() ~= 'vehicles_sales' then return end

    local duble_spawn = true
    for _, ent in pairs(ents.GetAll()) do
        if ent:GetNWEntity('VehicleSalesPlayer') == pPlayer then
            -- print(ent)
            duble_spawn = false
            break
        end
    end

    if not duble_spawn then
        meta.util.Notify('red', pPlayer, "У вас уже есть транспорт.")
        return
    end

    local vehicle = false
    for feature, data in pairs(VEHICLES_FEATURES) do
        for class, veh in pairs(data) do
            if vehicle_class == class then
                vehicle = veh
                break
            end
        end
    end

    if tbl[vehicle_class] or (vehicle and vehicle.price == 0) then
        local veh = ents.Create(vehicle_class)
        veh:Spawn()
        -- veh:Activate()

        if VEHICLES_SPAWNPOINT then
            veh:SetPos(VEHICLES_SPAWNPOINT[point] and VEHICLES_SPAWNPOINT[point] or table.Random(VEHICLES_SPAWNPOINT))
        end
        veh.VehicleSalesPlayer = pPlayer
        veh:SetNWEntity('VehicleSalesPlayer', pPlayer)
    end
end)
