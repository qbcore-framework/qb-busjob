RegisterCommand("geefbus", function(source,args,raw)
	TriggerServerEvent('Job_Bus:Givelicense', args[1])
end, false)

RegisterCommand("neembus", function(source,args,raw)
	TriggerServerEvent('Job_Bus:Takelicense', args[1])
end, false)

local MinPeopleCount = 0
local MaxPeopleCount = 8
local MinPayOut = 20
local MaxPayOut = 60
local PeopleSpawnWidth = 1
IsWorking_Bus = true
local SpawningBus = false
local BusModel = GetHashKey("buslijn1")
--local BusModel = GetHashKey("bus")
local GetOutOfBusChange = 50
local AfspeelAfstand = 5

PedTypes = {}
function SetupPedTypes()
	PedTypes[#PedTypes+1] = "a_m_m_bevhills_01"
	PedTypes[#PedTypes+1] = "mp_f_boatstaff_01"
	PedTypes[#PedTypes+1] = "s_m_o_busker_01"
	PedTypes[#PedTypes+1] = "csb_car3guy2"
	PedTypes[#PedTypes+1] = "a_f_m_eastsa_01"
	PedTypes[#PedTypes+1] = "a_f_m_eastsa_02"
	PedTypes[#PedTypes+1] = "a_f_y_epsilon_01"
	PedTypes[#PedTypes+1] = "a_f_y_eastsa_03"
	PedTypes[#PedTypes+1] = "a_m_y_gay_01"
	PedTypes[#PedTypes+1] = "a_m_y_gay_02"
	PedTypes[#PedTypes+1] = "a_m_y_ktown_01"
	PedTypes[#PedTypes+1] = "a_m_y_ktown_02"
	PedTypes[#PedTypes+1] = "g_m_y_armgoon_02"
	PedTypes[#PedTypes+1] = "a_f_m_soucent_01"
	PedTypes[#PedTypes+1] = "a_f_m_soucent_02"
	Citizen.CreateThread(function() 
		for ListID,model in pairs(PedTypes) do
			RequestModel(GetHashKey(model))
			while (not HasModelLoaded(GetHashKey(model))) do
				Citizen.Wait(100)
			end
		end
	end)
end
SetupPedTypes()

Animations = {}
function SetupAnimations()
	Animations[#Animations+1] = "WORLD_HUMAN_AA_COFFEE"
	Animations[#Animations+1] = "WORLD_HUMAN_BUM_STANDING"
	Animations[#Animations+1] = "WORLD_HUMAN_COP_IDLES"
	Animations[#Animations+1] = "WORLD_HUMAN_DRINKING"
	Animations[#Animations+1] = "WORLD_HUMAN_HANG_OUT_STREET"
	Animations[#Animations+1] = "WORLD_HUMAN_STAND_IMPATIENT"
	Animations[#Animations+1] = "WORLD_HUMAN_STAND_IMPATIENT_UPRIGHT"
	Animations[#Animations+1] = "WORLD_HUMAN_STAND_MOBILE"
	Animations[#Animations+1] = "WORLD_HUMAN_STAND_MOBILE"
	Animations[#Animations+1] = "WORLD_HUMAN_STAND_MOBILE"
	Animations[#Animations+1] = "WORLD_HUMAN_STAND_MOBILE_UPRIGHT"
	Animations[#Animations+1] = "WORLD_HUMAN_TOURIST_MAP"
	Animations[#Animations+1] = "WORLD_HUMAN_TOURIST_MOBILE"
end
SetupAnimations()

-- function deur(status)
-- function stop(status)
-- function halte(naam)
-- function geld(amount)
-- function lijn(nummer)

JobsClientCore.Menus["Bus_DressingRoom"]= {
	Title="Bus Kleedruimte",
	Holder="Bus_Kleedruimte",
	item={
		["Burger Kleding"]={cb=function(name, item, menu) 
			JobsClientCore.NaarBurgerKledingFromDuty()
			-- JobsClientCore.DisplayNotification("Je kan je spullen verkopen bij de 24/7.")
			JobsClientCore.RunningRoute = false
			IsWorking_Bus = false
		end},
		["Bus Chauffeur"]={cb=
			function(name, item, menu) 
				--JobsClientCore.SetClientModel("a_m_m_farmer_01")
				JobsClientCore.NaarJobKleding()
				IsWorking_Bus = true
				-- StartBussen()
			end},
	},
}
LastMarker = nil
local i = 1
local Lijnen = 3
local items = {}
for i=1,Lijnen,1 do
	items["Buslijn "..i]={cb=function(name, item, menu) 
		Citizen.CreateThread(function() 
			if (IsWorking_Bus ~= true) then
				JobsClientCore.DisplayNotification("You have to put on the right outfit!")
				return false
			end
			if SpawningBus then
				JobsClientCore.DisplayNotification("Your bus is on its way!")
				return false
			end
			SpawningBus = true
			for ListID,ped in pairs(Peds) do
				if DoesEntityExist(ped) then
					SetEntityAsMissionEntity(ped, false, true)
					-- TriggerServerEvent("Job_Bus:BetaalPassenger", GetPedMoney(ped))
					-- TotalEarnd = TotalEarnd + GetPedMoney(ped)
					-- geld(TotalEarnd)
					SetPedAsNoLongerNeeded(ped)
				end
			end
			Peds = {}
			RemoveVehicle()
			RunRoute(DriveRoutes[i])
			if (GetVehiclePedIsIn(PlayerPedId(), true) ~= Bus) then
				BusModel = "buslijn"..i
				SpawnBus(LastMarker)
			end
			while (GetVehiclePedIsIn(PlayerPedId(), true) ~= Bus) do
				Citizen.Wait(100)
			end
			lijn(i)
		end)
	end}
end

JobsClientCore.Menus["Bus_SelectLijn"]= {
	Title="Selecteer Bus Lijn",
	Holder="Bus_SelectLijn",
	item=items,
}

-- lijn(marker.Buslijn)
-- if(marker.Buslijn == 1) then
	-- RunRoute(DriveRoute1)
-- elseif(marker.Buslijn == 2) then
	-- RunRoute(DriveRoute2)
-- else
	-- RunRoute(DriveRoute)
-- end
Citizen.CreateThread(function() 
	table.insert(JobsClientCore.jobs, "bus")
	table.insert(JobsClientCore.MarkerList, 
		{name="Bus_Kleedkamer",
			Job="bus",
			x=731.87,y=659.41,z=128.15,a=167.99, 
			r=50,g=50,b=204,
			MSizex=1.5,MSizey=1.5,MSizez=10,
			MarkerHelpTekst="",
			onClick=function(marker) end,
			onExit=function(marker) JobsClientCore.CloseMenus() end,
			onEnter=function(marker) JobsClientCore.CreateMenu(JobsClientCore.Menus["Bus_DressingRoom"]) end,
		}
	)
	table.insert(JobsClientCore.MarkerList, 
		{name="Bus_SpawnVeh",
			Job="bus",
			Buslijn=1,
			x=707.67,y=660.53,z=128.01,a=8.52,
			r=50,g=204,b=50,
			MSizex=1.5,MSizey=1.5,MSizez=10,
			MarkerHelpTekst="",
			onClick=function(marker) end,
			-- onClick=function(marker) 
				-- if(GetVehiclePedIsIn(PlayerPedId(), false) ~= Bus) then
					-- SpawnBus(marker)
					-- JobsClientCore.CreateMenu(JobsClientCore.Menus["Bus_SelectLijn"])
				-- end
			-- end,
			onExit=function(marker) JobsClientCore.CloseMenus() end,
			onEnter=function(marker) 
				LastMarker = marker
				JobsClientCore.CreateMenu(JobsClientCore.Menus["Bus_SelectLijn"])
			end,
		}
	)
	table.insert(JobsClientCore.MarkerList, 
		{name="Bus_DelVeh",
			Job="bus",
			x=723.42,y=656.08,z=128.01,a=10.19,
			r=204,g=50,b=50,
			MSizex=1.5,MSizey=1.5,MSizez=10,
			MarkerHelpTekst="Verwijder je Busje",
			onClick=function(marker) RemoveVehicle() end,
			onExit=function(marker) end,
			onEnter=function(marker) end,
		}
	)
end)
DriveRoutes = {}
Citizen.CreateThread(function() 
	while JobsClientCore.ESX == nil do Citizen.Wait(100) end
	Citizen.Wait(10000)
	JobsClientCore.ESX.TriggerServerCallback('esx_JobsCoreO:GetRoute',function(route)
		local Troute = {}
		--table.insert(Troute, {x=665.03,y=676.99,z=128.01,a=260.96,x2=657.35,y2=680.93,z2=128.01,a2=247.27,extra1="DendamCentraal",driveroute={}})
		for ListID,location in pairs(route) do
			table.insert(Troute, location)
		end
		DriveRoutes[1] = Troute
	end, "Bus_Route7")
	JobsClientCore.ESX.TriggerServerCallback('esx_JobsCoreO:GetRoute',function(route)
		local Troute = {}
		--table.insert(Troute, {x=665.03,y=676.99,z=128.01,a=260.96,x2=657.35,y2=680.93,z2=128.01,a2=247.27,extra1="DendamCentraal",driveroute={}})
		for ListID,location in pairs(route) do
			table.insert(Troute, location)
		end
		DriveRoutes[2] = Troute
	end, "Bus_Route8")
	JobsClientCore.ESX.TriggerServerCallback('esx_JobsCoreO:GetRoute',function(route)
		local Troute = {}
		for ListID,location in pairs(route) do
			table.insert(Troute, location)
		end
		DriveRoutes[3] = Troute
	end, "Bus_Route9")
	--end, "Bus_Route5")
	-- JobsClientCore.ESX.TriggerServerCallback('esx_JobsCoreO:GetRoute',function(route)
		-- local Troute = {}
		-- for ListID,location in pairs(route) do
			-- table.insert(Troute, location)
		-- end
		-- DriveRoutes[4] = Troute
	-- end, "Bus_RouteT3")
	Citizen.Wait(10000)
	
	-- for i=1,Lijnen,1 do
		-- for ListID,location in pairs(DriveRoutes[i]) do
			-- local asdads = AddBlipForCoord(location.x,location.y,location.z)
			-- SetBlipSprite(asdads, 78) --477
			-- SetBlipDisplay(asdads, 2)
			-- SetBlipScale(asdads, 1.2)
			-- SetBlipColour(asdads, i)
			-- SetBlipAsShortRange(asdads, true)
			-- BeginTextCommandSetBlipName("STRING")
			-- AddTextComponentString("Bus"..i)
			-- EndTextCommandSetBlipName(asdads)
		-- end
	-- end
	--end, "Bus_Route1")
end)
Peds = {}
--TriggerServerEvent("InteractSound_SV:PlayWithinDistance", AfspeelAfstand, "challaz", 0.2)
PedsToGoOut = {}
Bus = nil
LastRoute = nil
Dooropent = false
LastSaid = false
TotalEarnd = 0
LastLocation = nil
function RunRoute(Route)
	Peds = {}
	TotalEarnd = 0
	LastLocation = nil
	geld(0)
	stop('hidden')
	-- JobsClientCore.RunRoute(Route, Condition, Conditionmsg, cancelIf, Reward, AtStart) -- Make something like a race
	LastRoute = Route
	JobsClientCore.RunRoute(Route, {r=189,g=214,b=69,Blip=24,cat=2}, 20.5, 50.5,
		function(location) --Condition
			return (GetVehiclePedIsIn(PlayerPedId(), false) ~= Bus)
		end, 
		"You can only continue if you are on your bus!", 
		function(location) -- Cancel if
			if (GetVehiclePedIsIn(PlayerPedId(), true) ~= Bus) then
				Citizen.Wait(5500)
			end
			return (GetVehiclePedIsIn(PlayerPedId(), true) ~= Bus)
			--return false
			--return (IsVehicleModel(GetVehiclePedIsIn(PlayerPedId(), true), BusModel) == false)
		end, 
		function(location) --At location
			local posx2,posy2,posz2 = table.unpack(GetEntityCoords(PlayerPedId(),false))
			LastLocation = location
			SetTextComponentFormat('STRING')
			AddTextComponentString("~INPUT_DETONATE~ Deuren openen")
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)
			stop('hidden')
			while (IsControlPressed(0, 47) ~= true) and (Dooropent ~= true) and CheckDistance(location) do
				Citizen.Wait(7)
			end
			Citizen.Wait(1000)
			if CheckDistance(location) then
				while (Dooropent ~= true) do
					Citizen.Wait(50)
				end
				for ListID=#PedsToGoOut,1,-1 do
					ped = PedsToGoOut[ListID]
				-- end
				-- for ListID,ped in pairs(PedsToGoOut) do
					if(CheckDistance(location) and (DoesEntityExist(ped) and (ped ~= nil) and (IsPedDeadOrDying(ped) == false) and Dooropent and IsPedSittingInVehicle(ped, Bus)) ) then
						local posx,posy,posz = table.unpack(GetEntityCoords(ped,false))
						local Distance = #(posx,posy,posz - posx2,posy2,posz2)
						if(Distance2 <= 50) then
							SetEntityAsMissionEntity(ped, false, true)
							local seat = "empty"
							for i = 0,GetVehicleModelNumberOfSeats(BusModel)-2,1 do 
								if(GetPedInVehicleSeat(Bus, i) == ped) then
									seat = i
								end 
							end
							TaskLeaveVehicle(ped, Bus, 256)
							local Timer = 1
							while (seat ~= "empty") and (IsVehicleSeatFree(Bus, seat) == false) and (Timer < 75) and CheckDistance(location) and(Dooropent) do
								Citizen.Wait(100)
								Timer = Timer +1
							end
							TriggerServerEvent("Job_Bus:BetaalPassenger", GetPedMoney(ped))
							TotalEarnd = TotalEarnd + GetPedMoney(ped)
							geld(TotalEarnd)
							Citizen.Wait(math.random(750,4000))
							TriggerServerEvent("InteractSound_SV:PlayWithinDistance", AfspeelAfstand, "ov2", 0.03)
							SetEntityAsNoLongerNeeded(ped)
							if Dooropent then
								SetVehicleDoorOpen(Bus, 0, false)    
								SetVehicleDoorOpen(Bus, 1, false)    
								SetVehicleDoorOpen(Bus, 2, false)    
								SetVehicleDoorOpen(Bus, 3, false)   
							end
						else
							-- ??
						end
					else
						-- ??
					end
				end
				for ListID,ped in pairs(PedsToGoOut) do
					SetEntityAsMissionEntity(ped, false, true)
					SetPedAsNoLongerNeeded(ped)
				end
				PedsToGoOut = {}
				for ListID=#Peds,1,-1 do
					ped = Peds[ListID]
				-- for ListID,ped in pairs(Peds) do
					if(DoesEntityExist(ped))then
						ReviveInjuredPed(ped)
						Citizen.Wait(200)
					end
					if not DoesEntityExist(ped) and (ped ~= nil) then
						Peds[ListID] = CreatePed(26, PedTypes[math.random(1,#PedTypes)], location.x2+math.random(1,PeopleSpawnWidth), location.y2+math.random(1,PeopleSpawnWidth), location.z2, location.a2, true, false)
						ped = Peds[ListID]
					end
					if(CheckDistance(location) and DoesEntityExist(ped) and (ped ~= nil) and (IsPedDeadOrDying(ped) == false) and Dooropent ) then
						ClearPedTasksImmediately(ped)
						local posx,posy,posz = table.unpack(GetEntityCoords(ped,false))
						local Distance = #(posx,posy,posz - posx2,posy2,posz2)
						if(DoesEntityExist(ped) and (Distance <= 70)) and Dooropent and AreAnyVehicleSeatsFree(Bus) then
							SetEntityAsMissionEntity(ped, false, true)
							local Seat = "NotFound"
							while (Seat == "NotFound") do
								local SeatIndex = math.random(0,GetVehicleModelNumberOfSeats(BusModel)-2)
								if IsVehicleSeatFree(Bus, SeatIndex) then
									Seat = SeatIndex
								end
								Citizen.Wait(45)
							end
							TaskEnterVehicle(ped, Bus, 10000000, Seat, 1.0, 1, 0)
							local Timer = 1
							while IsVehicleSeatFree(Bus, Seat) and (Timer < 50) and CheckDistance(location) and(Dooropent) do
								Citizen.Wait(100)
								--TaskEnterVehicle(ped, Bus, 10000000, Seat, 1.0, 1, 0)
								Timer = Timer +1
							end
							TriggerServerEvent("InteractSound_SV:PlayWithinDistance", AfspeelAfstand, "ov", 0.03)
							if Dooropent then
								SetVehicleDoorOpen(Bus, 0, false)    
								SetVehicleDoorOpen(Bus, 1, false)    
								SetVehicleDoorOpen(Bus, 2, false)    
								SetVehicleDoorOpen(Bus, 3, false)   
							end
						else
							-- ??
						end
					else
						-- ??
					end
				end
				SetTextComponentFormat('STRING')
				AddTextComponentString("~INPUT_DETONATE~ Close doors")
				DisplayHelpTextFromStringLabel(0, 0, 1, -1)
				while (IsControlPressed(0, 47) ~= true) and (Dooropent) and CheckDistance(location) do
					Citizen.Wait(7)
				end
				--SetVehicleHandbrake(Bus, false)
				--SetVehicleDoorsShut(Bus, false)
				--FreezeEntityPosition(Bus, false)
			end
		end, 
		function(location) --At start
			
			for ListID,ped in pairs(Peds) do
				if DoesEntityExist(ped) then
					SetEntityAsMissionEntity(ped, false, true)
					if (IsPedSittingInAnyVehicle(ped)) then
						-- DeletePed(ped)
					else
						-- DeletePed(ped)
						-- TriggerServerEvent("Job_Bus:BetaalPassenger", GetPedMoney(ped))
						-- TotalEarnd = TotalEarnd + GetPedMoney(ped)
						-- geld(TotalEarnd)
						SetPedAsNoLongerNeeded(ped)
					end
				end
			end
			Peds = {}
			
			
			if(LastRoute[#LastRoute].id ~= location.id) then
				Peds = {}
				--Peds[#Peds+1] = CreatePed(26, PedTypes[math.random(1,#PedTypes)], location.x, location.y, location.z, location.a, false, false)
				for i = 1,math.random(MinPeopleCount, MaxPeopleCount),1 do 
					local Random = math.random(1, 4)
					if(Random==1) then
						Peds[#Peds+1] = CreatePed(26, PedTypes[math.random(1,#PedTypes)], location.x2+math.random(1,PeopleSpawnWidth), location.y2+math.random(1,PeopleSpawnWidth), location.z2, location.a2, true, false)
					elseif(Random==2) then
						Peds[#Peds+1] = CreatePed(26, PedTypes[math.random(1,#PedTypes)], location.x2-math.random(1,PeopleSpawnWidth), location.y2-math.random(1,PeopleSpawnWidth), location.z2, location.a2, true, false)
					elseif(Random==3) then
						Peds[#Peds+1] = CreatePed(26, PedTypes[math.random(1,#PedTypes)], location.x2+math.random(1,PeopleSpawnWidth), location.y2-math.random(1,PeopleSpawnWidth), location.z2, location.a2, true, false)
					elseif(Random==4) then
						Peds[#Peds+1] = CreatePed(26, PedTypes[math.random(1,#PedTypes)], location.x2-math.random(1,PeopleSpawnWidth), location.y2+math.random(1,PeopleSpawnWidth), location.z2, location.a2, true, false)
					end
					Citizen.Wait(50)
				end
				for ListID,ped in pairs(Peds) do
					SetPedMoney(ped, math.random(MinPayOut,MaxPayOut))
					--ped.locationidunique = location
					TaskStartScenarioInPlace(ped, Animations[math.random(1,#Animations)], 0, false)
					SetEntityAsMissionEntity(ped, false, true)
					SetPedCanBeTargetted(ped, false)
					SetEntityCanBeTargetedWithoutLos(ped, false)
				end
				halte(string.gsub(location.extra1:upper(), "_", " "))
				Citizen.CreateThread(function()
					Citizen.Wait(3000)
					TriggerServerEvent("InteractSound_SV:PlayWithinDistance", AfspeelAfstand, "next stop", 0.5)
					--TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5,GetPlayerServerId(PlayerId()), "volgendehalte", 0.2)
					Citizen.Wait(3200)
					TriggerServerEvent("InteractSound_SV:PlayWithinDistance", AfspeelAfstand, location.extra2, 0.5)
					-- TriggerServerEvent("InteractSound_SV:PlayWithinDistance", AfspeelAfstand, "vespucci", 0.2)
					--TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5,GetPlayerServerId(PlayerId()), "vespucci", 0.2)
				end)
			end
		end, 
		function(location) --Halfway
			if(LastLocation ~= nil) then
				if(LastRoute[#LastRoute].id == location.id) then
					PedsToGoOut = GetPedsInBus()
				else
					local PedsInsideBus = GetPedsInBus()
					for ListID=#PedsInsideBus,1,-1 do
						ped = PedsInsideBus[ListID]
						if (GetOutOfBusChange < math.random(1,100)) then
							SetPedMoney(ped, GetPedMoney(ped)+ math.random(MinPayOut,MaxPayOut))
							table.insert(PedsToGoOut, ped)
						else
							--SetPedMoney(ped, GetPedMoney(ped)+ math.random(6,50))
						end
					end
				end
			end
			if(#PedsToGoOut > 0) then
				TriggerServerEvent("InteractSound_SV:PlayWithinDistance", AfspeelAfstand, "stop button", 0.25)
				stop('visible')
			end
		end, 
		function(location) -- Almost at location
			if (#GetPedsInBus() >= 1)then
				Citizen.CreateThread(function() 
					if(LastRoute[#LastRoute].id == location.id) then
						TriggerServerEvent("Job_Bus:eindstop", 2000)
						TriggerServerEvent("InteractSound_SV:PlayWithinDistance", AfspeelAfstand, "end line", 0.5)
						Citizen.Wait(10000)
					else
						-- TriggerServerEvent("InteractSound_SV:PlayWithinDistance", AfspeelAfstand, "halte", 0.2)
						-- Citizen.Wait(800)
						-- TriggerServerEvent("InteractSound_SV:PlayWithinDistance", AfspeelAfstand, "vespucci", 0.2)
						TriggerServerEvent("InteractSound_SV:PlayWithinDistance", AfspeelAfstand, location.extra2, 0.5)
						Citizen.Wait(4000)
					end
					if(LastSaid ~= true) then
						LastSaid = true
						TriggerServerEvent("InteractSound_SV:PlayWithinDistance", AfspeelAfstand, "do not forget", 0.5)
					else
						LastSaid = false
					end
				end)
			end
		end)
end

function GetPedsInBus()
	local rtn = {}
	local i=1
	for i=-3, (GetVehicleModelNumberOfSeats(BusModel)), 1 do
		local Seat = i
		local pedInBus = GetPedInVehicleSeat(Bus, Seat)
		if DoesEntityExist(pedInBus) then
			if (GetPedType(pedInBus) == 4)then
				table.insert(rtn, pedInBus)
			end
		end
	end
	return rtn
end

RegisterNetEvent('JobsCoreO:UserPressedKey')
AddEventHandler('JobsCoreO:UserPressedKey', function(KeyId, KeyName)
	if(KeyId == 47) then
		if (Bus ~= nil) then
			if(GetVehiclePedIsIn(PlayerPedId(), true) == Bus) then
				Dooropent = not Dooropent
				if not Dooropent then 
					SetVehicleHandbrake(Bus, false)
					SetVehicleDoorsShut(Bus, false) 
					deur('deur-closed') 
				else
					SetVehicleHandbrake(Bus, true)
					SetVehicleDoorOpen(Bus, 0, false)    
					SetVehicleDoorOpen(Bus, 1, false)    
					SetVehicleDoorOpen(Bus, 2, false)    
					SetVehicleDoorOpen(Bus, 3, false)  
					deur('deur-open') 
				end
			end
		end
	end
	if(KeyId == 29) then
		if (Bus ~= nil) then
			if(GetVehiclePedIsIn(PlayerPedId(), true) == Bus) then
				local PedsInBus = GetPedsInBus()
				for ListID=#PedsInBus,1,-1 do
					ped = PedsInBus[ListID]
					TaskLeaveVehicle(ped, Bus, 256)
					SetPedAsNoLongerNeeded(ped)
				end
			end
		end
	end
end) 


function CheckDistance(location)
	local posx,posy,posz = table.unpack(GetEntityCoords(PlayerPedId(),false))
	Distance2 = #(posx,posy,posz - vector3(location.x,location.y,location.z))
	return ((Distance2 < 40) and true or false)
end

Citizen.CreateThread(function() 
	Citizen.Wait(2500)
	
	Blipje = AddBlipForCoord(731.87,659.41,128.15)
	SetBlipSprite(Blipje, 78) --477
	SetBlipDisplay(Blipje, 2)
	SetBlipScale(Blipje, 1.2)
	SetBlipColour(Blipje, 53)
	SetBlipAsShortRange(Blipje, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Bus")
	EndTextCommandSetBlipName(Blipje)
	
	SetVehicleModelIsSuppressed(BusModel, true)
end)

-- function deur(status)
-- function stop(status)
-- function halte(naam)
-- function geld(amount)
-- function lijn(nummer)


function SpawnBus(marker)
	if (IsAnyVehicleNearPoint(marker.x, marker.y, marker.z, 10.50) == false) then
		Citizen.CreateThread(function()
			RequestModel(BusModel)
			while (not HasModelLoaded(BusModel)) do
				Wait(1)
			end
			--if IsPedModel(PlayerPedId(), GetHashKey("a_m_m_farmer_01")) then
			if IsWorking_Bus then
				Peds = {}
				Bus = nil
				-- LastRoute = nil
				Dooropent = false
				TotalEarnd = 0
				LastLocation = nil
				geld(0)
				deur('deur-closed') 
				stop('hidden')
				Citizen.CreateThread(function() 
					ShowUI('open')
				end)
				lijn(999)
				Bus = CreateVehicle(BusModel, marker.x, marker.y, marker.z, marker.a, true, false)
				Wait(500)
				SetVehicleOnGroundProperly(Bus)
				SetPedIntoVehicle(PlayerPedId(), Bus, -1)
				SetEntityAsMissionEntity(Bus,  false,  true)
				SetVehicleCanBeTargetted(Bus, false)
				--SetEntityMaxSpeed(Bus, 25)
				TriggerServerEvent('Job_Bus:BetaalBorg')
				Dooropent = false
				SpawningBus = false
			else
				JobsClientCore.DisplayNotification("You have to put on the right outfit!")
			end
		end)
	else
		JobsClientCore.DisplayNotification("There is something close to the spawnpoint !!")
	end
end

function RemoveVehicle()
	SetEntityAsMissionEntity(GetVehiclePedIsIn(PlayerPedId(), false),  false,  true)
	if(GetVehiclePedIsIn(PlayerPedId(), false) == Bus) then
		TriggerServerEvent('Job_Bus:GetBorg')
	end
	Citizen.Wait(10)
	DeleteVehicle(GetVehiclePedIsIn(PlayerPedId(), false))
	JobsClientCore.RunningRoute = false
	for ListID,ped in pairs(Peds) do
		if DoesEntityExist(ped) then
			SetEntityAsMissionEntity(ped, false, true)
			-- TriggerServerEvent("Job_Bus:BetaalPassenger", GetPedMoney(ped))
			-- TotalEarnd = TotalEarnd + GetPedMoney(ped)
			-- geld(TotalEarnd)
			SetPedAsNoLongerNeeded(ped)
		end
	end
	Peds = {}
end


