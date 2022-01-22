local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('qb-busjob:server:NpcPay', function(Payment)
    TriggerEvent("qb-busjob:server:NpcPayed", source, Payment)
end)

RegisterNetEvent('qb-busjob:server:NpcPayed', function(user,Payment)
    local src = user
    if source == "" then
        local Player = QBCore.Functions.GetPlayer(src)
        local randomAmount = math.random(1, 5)
        local r1, r2 = math.random(1, 5), math.random(1, 5)
        if randomAmount == r1 or randomAmount == r2 then Payment = Payment + math.random(10, 20) end
        Player.Functions.AddMoney('cash', Payment)
    else
        DropPlayer(source, "Attempted exploit abuse")
    end
end)
