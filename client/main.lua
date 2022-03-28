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
    local inRange = false
    local PolyZone = CircleZone:Create(vector3(Config.NPCLocations.Locations[route].x, Config.NPCLocations.Locations[route].y, Config.NPCLocations.Locations[route].z), 5, {
        name="busjobdeliver",
        useZ=true,
        -- debugPoly=true
    })
    PolyZone:onPlayerInOut(function(isPointInside)
        if isPointInside then
            inRange = true
            exports["qb-core"]:DrawText(Lang:t('info.busstop_text'), 'rgb(220, 20, 60)')
            CreateThread(function()
                repeat
                    Wait(0)
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
                        PolyZone:destroy()
                        break
                    end
                until not inRange
            end)
        else
            exports["qb-core"]:HideText()
            inRange = false
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
            local inRange = false
            local PolyZone = CircleZone:Create(vector3(Config.NPCLocations.Locations[route].x, Config.NPCLocations.Locations[route].y, Config.NPCLocations.Locations[route].z), 5, {
                name="busjobdeliver",
                useZ=true,
                -- debugPoly=true
            })
            PolyZone:onPlayerInOut(function(isPointInside)
                if isPointInside then
                    inRange = true
                    exports["qb-core"]:DrawText(Lang:t('info.busstop_text'), 'rgb(220, 20, 60)')
                    CreateThread(function()
                        repeat
                            Wait(0)
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
                                PolyZone:destroy()
                                break
                            end
                        until not inRange
                    end)
                else
                    exports["qb-core"]:HideText()
                    inRange = false
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
    local inRange = false
    local PolyZone = CircleZone:Create(vector3(Config.Location.x, Config.Location.y, Config.Location.z), 5, {
        name="busMain",
        useZ=true,
        debugPoly=false
    })
    PolyZone:onPlayerInOut(function(isPointInside)
        local Player = QBCore.Functions.GetPlayerData()
        local inVeh = whitelistedVehicle()
        if Player.job.name == "bus" then
            if isPointInside then
                inRange = true
                CreateThread(function()
                    repeat
                        Wait(0)
                        if not inVeh then
                            exports["qb-core"]:DrawText(Lang:t('info.busstop_text'), 'left')
                            if IsControlJustReleased(0, 38) then
                                BusGarage()
                                exports["qb-core"]:HideText()
                                break
                            end
                        else
                            exports["qb-core"]:DrawText(Lang:t('info.bus_stop_work'), 'left')
                            if IsControlJustReleased(0, 38) then
                                if (not NpcData.Active or NpcData.Active and NpcData.NpcTaken == false) then
                                    if IsPedInAnyVehicle(PlayerPedId(), false) then
                                        BusData.Active = false;
                                        DeleteVehicle(GetVehiclePedIsIn(PlayerPedId()))
                                        RemoveBlip(NpcData.NpcBlip)
                                        exports["qb-core"]:HideText()
                                        break
                                    end
                                else
                                    QBCore.Functions.Notify(Lang:t('error.drop_off_passengers'), 'error')
                                end
                            end
                        end
                    until not inRange
                end)
            else
                exports["qb-core"]:HideText()
                inRange = false
            end
        end
    end)
end)
