-- Variables

local QBCore = exports['qb-core']:GetCoreObject()
local lastLocation = nil
local route = 1
local max = 0

for k,v in pairs(Config.NPCLocations.Locations) do
    max = max + 1
end

local NpcData = {
    Active = false,
    CurrentNpc = nil,
    LastNpc = nil,
    CurrentDeliver = nil,
    LastDeliver = nil,
    Npc = nil,
    NpcBlip = nil,
    DeliveryBlip = nil,
    NpcTaken = false,
    NpcDelivered = false,
    CountDown = 180
}

local BusData = {
    Active = false,
}
-- Functions

local function ResetNpcTask()
    NpcData = {
        Active = false,
        CurrentNpc = nil,
        LastNpc = nil,
        CurrentDeliver = nil,
        LastDeliver = nil,
        Npc = nil,
        NpcBlip = nil,
        DeliveryBlip = nil,
        NpcTaken = false,
        NpcDelivered = false,
    }
end

local function whitelistedVehicle()
    local ped = PlayerPedId()
    local veh = GetEntityModel(GetVehiclePedIsIn(ped))
    local retval = false

    for i = 1, #Config.AllowedVehicles, 1 do
        if veh == GetHashKey(Config.AllowedVehicles[i].model) then
            retval = true
        end
    end

    if veh == GetHashKey("dynasty") then
        retval = true
    end

    return retval
end

local function IsDriver()
    return GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) == PlayerPedId()
end

local function DrawText3D(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

local function GetDeliveryLocation()
    if route <= (max - 1) then
        route = route + 1
    else
        route = 1
    end

    if NpcData.DeliveryBlip ~= nil then
        RemoveBlip(NpcData.DeliveryBlip)
    end
    NpcData.DeliveryBlip = AddBlipForCoord(Config.NPCLocations.Locations[route].x, Config.NPCLocations.Locations[route].y, Config.NPCLocations.Locations[route].z)
    SetBlipColour(NpcData.DeliveryBlip, 3)
    SetBlipRoute(NpcData.DeliveryBlip, true)
    SetBlipRouteColour(NpcData.DeliveryBlip, 3)
    NpcData.LastDeliver = route

    CreateThread(function()
        while true do
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            local dist = #(pos - vector3(Config.NPCLocations.Locations[route].x, Config.NPCLocations.Locations[route].y, Config.NPCLocations.Locations[route].z))
            if dist < 20 then
                DrawMarker(2, Config.NPCLocations.Locations[route].x, Config.NPCLocations.Locations[route].y, Config.NPCLocations.Locations[route].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 255, 255, 0, 0, 0, 1, 0, 0, 0)
                if dist < 5 then
                    DrawText3D(Config.NPCLocations.Locations[route].x, Config.NPCLocations.Locations[route].y, Config.NPCLocations.Locations[route].z, Lang:t('info.busstop_text'))
                    if IsControlJustPressed(0, 38) then
                        local veh = GetVehiclePedIsIn(ped, 0)
                        TaskLeaveVehicle(NpcData.Npc, veh, 0)
                        SetEntityAsMissionEntity(NpcData.Npc, false, true)
                        SetEntityAsNoLongerNeeded(NpcData.Npc)
                        local targetCoords = Config.NPCLocations.Locations[NpcData.LastNpc]
                        TaskGoStraightToCoord(NpcData.Npc, targetCoords.x, targetCoords.y, targetCoords.z, 1.0, -1, 0.0, 0.0)
                        QBCore.Functions.Notify(Lang:t('success.dropped_off'), 'success')
                        if NpcData.DeliveryBlip ~= nil then
                            RemoveBlip(NpcData.DeliveryBlip)
                        end
                        local RemovePed = function(ped)
                            SetTimeout(60000, function()
                                DeletePed(ped)
                            end)
                        end
                        RemovePed(NpcData.Npc)
                        ResetNpcTask()
                        route = route + 1
                        TriggerEvent('qb-busjob:client:DoBusNpc')
                        break
                    end
                end
            end
            Wait(1)
        end
    end)
end

-- Old Menu Code (being removed)

function BusGarage()
    local vehicleMenu = {
        {
            header = Lang:t('menu.bus_header'),
            isMenuHeader = true
        }
    }
    for veh, v in pairs(Config.AllowedVehicles) do
        vehicleMenu[#vehicleMenu+1] = {
            header = v.label,
            params = {
                event = "qb-busjob:client:TakeVehicle",
                args = {
                    model = v.model
                }
            }
        }
    end
    vehicleMenu[#vehicleMenu+1] = {
        header = Lang:t('menu.bus_close'),
        params = {
            event = "qb-menu:client:closeMenu"
        }
    }
    exports['qb-menu']:openMenu(vehicleMenu)
end

RegisterNetEvent("qb-busjob:client:TakeVehicle", function(data)
    local coords = Config.Location
    if(BusData.Active) then
        QBCore.Functions.Notify(Lang:t('error.one_bus_active'), 'error')
        return
    else
    QBCore.Functions.SpawnVehicle(data.model, function(veh)
        SetVehicleNumberPlateText(veh, Lang:t('info.bus_plate')..tostring(math.random(1000, 9999)))
        exports['LegacyFuel']:SetFuel(veh, 100.0)
        closeMenuFull()
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
        SetVehicleEngineOn(veh, true, true)
    end, coords, true)
    Wait(1000)
    TriggerEvent('qb-busjob:client:DoBusNpc')
    end
end)

function closeMenuFull()
    exports['qb-menu']:closeMenu()
end

-- Events

RegisterNetEvent('qb-busjob:client:DoBusNpc', function()
    if whitelistedVehicle() then
        if not NpcData.Active then
            local Gender = math.random(1, #Config.NpcSkins)
            local PedSkin = math.random(1, #Config.NpcSkins[Gender])
            local model = GetHashKey(Config.NpcSkins[Gender][PedSkin])
            RequestModel(model)
            while not HasModelLoaded(model) do
                Wait(0)
            end
            NpcData.Npc = CreatePed(3, model, Config.NPCLocations.Locations[route].x, Config.NPCLocations.Locations[route].y, Config.NPCLocations.Locations[route].z - 0.98, Config.NPCLocations.Locations[route].w, false, true)
            PlaceObjectOnGroundProperly(NpcData.Npc)
            FreezeEntityPosition(NpcData.Npc, true)
            if NpcData.NpcBlip ~= nil then
                RemoveBlip(NpcData.NpcBlip)
            end
            QBCore.Functions.Notify(Lang:t('info.goto_busstop'), 'primary')
            NpcData.NpcBlip = AddBlipForCoord(Config.NPCLocations.Locations[route].x, Config.NPCLocations.Locations[route].y, Config.NPCLocations.Locations[route].z)
            SetBlipColour(NpcData.NpcBlip, 3)
            SetBlipRoute(NpcData.NpcBlip, true)
            SetBlipRouteColour(NpcData.NpcBlip, 3)
            NpcData.LastNpc = route
            NpcData.Active = true

            CreateThread(function()
                while not NpcData.NpcTaken do

                    local ped = PlayerPedId()
                    local pos = GetEntityCoords(ped)
                    local dist = #(pos - vector3(Config.NPCLocations.Locations[route].x, Config.NPCLocations.Locations[route].y, Config.NPCLocations.Locations[route].z))

                    if dist < 20 then
                        DrawMarker(2, Config.NPCLocations.Locations[route].x, Config.NPCLocations.Locations[route].y, Config.NPCLocations.Locations[route].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 255, 255, 0, 0, 0, 1, 0, 0, 0)

                        if dist < 5 then
                            DrawText3D(Config.NPCLocations.Locations[route].x, Config.NPCLocations.Locations[route].y, Config.NPCLocations.Locations[route].z, Lang:t('info.busstop_text'))
                            if IsControlJustPressed(0, 38) then
                                local veh = GetVehiclePedIsIn(ped, 0)
                                local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(veh)

                                for i=maxSeats - 1, 0, -1 do
                                    if IsVehicleSeatFree(veh, i) then
                                        freeSeat = i
                                        break
                                    end
                                end

                                lastLocation = GetEntityCoords(PlayerPedId())
                                ClearPedTasksImmediately(NpcData.Npc)
                                FreezeEntityPosition(NpcData.Npc, false)
                                TaskEnterVehicle(NpcData.Npc, veh, -1, freeSeat, 1.0, 0)
                                QBCore.Functions.Notify(Lang:t('info.goto_busstop'), 'primary')
                                if NpcData.NpcBlip ~= nil then
                                    RemoveBlip(NpcData.NpcBlip)
                                end
                                GetDeliveryLocation()
                                NpcData.NpcTaken = true
                                TriggerServerEvent('qb-busjob:server:NpcPay', math.random(15, 25))
                            end
                        end
                    end
                    Wait(1)
                end
            end)
        else
            QBCore.Functions.Notify(Lang:t('error.already_driving_bus'), 'error')
        end
    else
        QBCore.Functions.Notify(Lang:t('error.not_in_bus'), 'error')
    end
end)

-- Threads

CreateThread(function()
    BusBlip = AddBlipForCoord(Config.Location)
    SetBlipSprite (BusBlip, 513)
    SetBlipDisplay(BusBlip, 4)
    SetBlipScale  (BusBlip, 0.6)
    SetBlipAsShortRange(BusBlip, true)
    SetBlipColour(BusBlip, 49)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(Lang:t('info.bus_depot'))
    EndTextCommandSetBlipName(BusBlip)
end)

CreateThread(function()
    while true do
        inRange = false
        if LocalPlayer.state.isLoggedIn then
            local Player = QBCore.Functions.GetPlayerData()
            if Player.job.name == "bus" then
                local ped = PlayerPedId()
                local pos = GetEntityCoords(ped)
                local vehDist = #(pos - vector3(Config.Location.x, Config.Location.y, Config.Location.z))

                if vehDist < 30 then
                    inRange = true
                    DrawMarker(2, Config.Location.x, Config.Location.y, Config.Location.z, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.3, 0.5, 0.2, 200, 0, 0, 222, false, false, false, true, false, false, false)

                    if vehDist < 1.5 then
                        if whitelistedVehicle() then
                            DrawText3D(Config.Location.x, Config.Location.y, Config.Location.z + 0.3, Lang:t('info.bus_stop_work'))
                            if IsControlJustReleased(0, 38) then
                                if (not NpcData.Active or NpcData.Active and NpcData.NpcTaken == false)then
                                    if IsPedInAnyVehicle(PlayerPedId(), false) then
                                        BusData.Active = false;
                                        DeleteVehicle(GetVehiclePedIsIn(PlayerPedId()))
                                        RemoveBlip(NpcData.NpcBlip)
                                    end
                                else
                                    QBCore.Functions.Notify(Lang:t('error.drop_off_passengers'), 'error')
                                end
                            end
                        else
                            DrawText3D(Config.Location.x, Config.Location.y, Config.Location.z + 0.3, Lang:t('info.bus_job_vehicles'))
                            if IsControlJustReleased(0, 38) then
                                BusGarage()
                            end
                        end
                    end
                end
            end
        end

        if not inRange then
            Wait(3000)
        end

        Wait(3)
    end
end)