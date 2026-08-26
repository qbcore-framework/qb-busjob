local LastNpcPay = {}

function NearBus(src)
    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)
    for _, v in pairs(Config.NPCLocations.Locations) do
        local dist = #(coords - vector3(v.x, v.y, v.z))
        if dist < 20 then
            return true
        end
    end
end

RegisterNetEvent('qb-busjob:server:NpcPay', function()
    local src = source
    local Player = exports['qb-core']:GetPlayer(src)
    local now = os.time()
    local cooldownSeconds = 10
    local Payment = math.random(15, 25)
    if not Player then return end
    if Player.PlayerData.job.name == 'bus' then
        if LastNpcPay[src] and (now - LastNpcPay[src]) < cooldownSeconds then
            DropPlayer(src, Lang:t('error.exploit'))
            return
        end
        if NearBus(src) then
            local randomAmount = math.random(1, 5)
            local r1, r2 = math.random(1, 5), math.random(1, 5)
            if randomAmount == r1 or randomAmount == r2 then Payment = Payment + math.random(10, 20) end
            LastNpcPay[src] = now
            Player.AddMoney('cash', Payment, 'Bus job')
        else
            DropPlayer(src, Lang:t('error.exploit'))
        end
    else
        DropPlayer(src, Lang:t('error.exploit'))
    end
end)

AddEventHandler('playerDropped', function()
    LastNpcPay[source] = nil
end)
