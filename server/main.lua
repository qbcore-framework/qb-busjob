local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('qb-busjob:server:NpcPay', function(Payment)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local randomAmount = math.random(1, 5)
    local r1, r2 = math.random(1, 5), math.random(1, 5)
    if randomAmount == r1 or randomAmount == r2 then Payment = Payment + math.random(10, 20) end
    Player.Functions.AddMoney('cash', Payment)
end)
