local QBCore = exports['qb-core']:GetCoreObject()

function NearBus(src)
    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)
    for _, v in pairs(Config.NPCLocations.Locations) do
        local dist = #(coords - vector3(v.x,v.y,v.z))
        if dist < 20 then
            return true
        end
    end
end

RegisterNetEvent('qb-busjob:server:NpcPay', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local Payment = math.random(15, 25)
    if Player.PlayerData.job.name == Config.Jobname then
        if NearBus(src) then
            local randomAmount = math.random(1, 5)
            local r1, r2 = math.random(1, 5), math.random(1, 5)
            if randomAmount == r1 or randomAmount == r2 then Payment = Payment + math.random(10, 20) end
            if Config.Management then
                exports['qb-management']:AddMoney('bus', Payment)
            else
                Player.Functions.AddMoney('cash', Payment)
            end
            local chance = math.random(1, 1000)
            if chance < 10 then
                Player.Functions.AddItem(Config.item, 1, false)
                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.item], "add")
            end
        else
            DropPlayer(src, Lang:t('error.exploit'))
        end
    else
        DropPlayer(src, Lang:t('error.exploit'))
    end
end)
