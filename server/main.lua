

AllowedIdentifiers = {
    ["steam:110000100da693a"] = true, -- MP - Stefan
	["steam:110000133ae202e"] = true, -- ADMIN - Mark2
	["steam:11000010ba7977c"] = true, -- ADMIN - Quimey :P	
	["steam:110000102fca591"] = true, -- ADMIN - Mark
	["steam:11000010877eef9"] = true, -- ADMIN - Robin
	["steam:11000010774b0a7"] = true,	-- DEV - Onno 
	["steam:1100001096efa6b"] = true, -- DEV - Koen
	["steam:110000105b4cde7"] = true, -- Mod Kevin
}


TriggerEvent('esx_phone:registerNumber', 'bus', "Someone needs a bus", true, true)


RegisterServerEvent('Job_Bus:Givelicense')
AddEventHandler('Job_Bus:Givelicense', function(id)
	
	if (AllowedIdentifiers[tostring(GetPlayerIdentifiers(source)[1])] == true) then
		local xPlayer = JobsClientCore.ESX.GetPlayerFromId(id)
		xPlayer.removeMoney(1000)
		TriggerEvent('esx_license:addLicense', id, 'drive_bus', function() end)
		TriggerClientEvent('JobsCoreO:DisplayNotification', source, "You have ~g~"..xPlayer.name.." ~s~een bus rijbewijs gegeven!")
		TriggerClientEvent('JobsCoreO:DisplayNotification', id, "You have je ~g~bus rijbewijs ~s~gekregen!")
	else
		TriggerClientEvent('JobsCoreO:DisplayNotification', source, "~o~Wat denk jij?!")
	end
end)

RegisterServerEvent('Job_Bus:Takelicense')
AddEventHandler('Job_Bus:Takelicense', function(id)
	if (AllowedIdentifiers[tostring(GetPlayerIdentifiers(source)[1])] == true) then
		local xPlayer = JobsClientCore.ESX.GetPlayerFromId(id)
		TriggerEvent('esx_license:removeLicense', id, 'bus', function() end)
		TriggerClientEvent('JobsCoreO:DisplayNotification', source, "You have ~g~"..xPlayer.name.." ~s~take his bus proof!")
		TriggerClientEvent('JobsCoreO:DisplayNotification', id, "Je ~g~bus drivers license ~s~is taken!")
	else
		TriggerClientEvent('JobsCoreO:DisplayNotification', source, "~o~What do you think")
	end
end)


RegisterServerEvent('Job_Bus:BetaalBorg')
AddEventHandler('Job_Bus:BetaalBorg', function()
	local xPlayer = JobsClientCore.ESX.GetPlayerFromId(source)
	xPlayer.removeMoney(1000)
	TriggerClientEvent('JobsCoreO:DisplayNotification', source, "You have ~g~1000 ~s~euro deposti paid")
end)

RegisterServerEvent('Job_Bus:GetBorg')
AddEventHandler('Job_Bus:GetBorg', function()
	local xPlayer = JobsClientCore.ESX.GetPlayerFromId(source)
	xPlayer.addMoney(1000)
	TriggerClientEvent('JobsCoreO:DisplayNotification', source, "You have ~g~1000 ~s~euro deposit returned!")
end)

RegisterServerEvent('Job_Bus:BetaalPassenger')
AddEventHandler('Job_Bus:BetaalPassenger', function(amount)
	local xPlayer = JobsClientCore.ESX.GetPlayerFromId(source)
	local GiveMoney = amount
	xPlayer.addMoney(GiveMoney)
	TriggerClientEvent('JobsCoreO:DisplayNotification', source, "Your passenger has ~b~"..GiveMoney.." ~s~euro paid with his ~g~OV~s~.")
end)

RegisterServerEvent('Job_Bus:eindstop')
AddEventHandler('Job_Bus:eindstop', function(amount)
	local xPlayer = JobsClientCore.ESX.GetPlayerFromId(source)
	local GiveMoney = amount
	xPlayer.addMoney(GiveMoney)
	TriggerClientEvent('JobsCoreO:DisplayNotification', source, "You have a bonus of it ~b~"..GiveMoney.." ~s~euro got~s~.")
end)











