local QBCore = exports['qb-core']:GetCoreObject()

local NearArea = false
local List = false
local Reward = 0



RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    NearArea = false
end)

CreateThread(function()
    while true do
    Citizen.Wait(1)
    local NearArea = false
		local pos = GetEntityCoords(PlayerPedId())
		if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, -1844.858, -1195.674, 19.18, true) < 5.0 then
			NearArea = true
			if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, -1844.858, -1195.674, 19.18, true) < 1.5 then
					if not List then 
						Reward = MathPrice()
						List = true
					elseif List and Reward ~= 0 then
						DrawText3D(Config['SellFish'].x,Config['SellFish'].y,Config['SellFish'].z, "~o~[E]~w~ - To Sell Fish")
						if IsControlJustReleased(1, 38) then
							TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_STAND_IMPATIENT", 0, true)
                                Wait(8000)
                                ClearPedTasks(PlayerPedId())
								TriggerServerEvent("Alen-Fishing:Sell")
								PlaySoundFrontend(-1, "Mission_Pass_Notify", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 0)
								List = false
								Reward = 0
							end
						end
			end
		end
		if not NearArea then
			Reward = 0
			List = false
			Wait(2500)
		end
	end
end)

RegisterNetEvent('fishing:useRod')
AddEventHandler('fishing:useRod', function()
    local Ped = PlayerPedId()
	local pos = GetEntityCoords(PlayerPedId())
	if IsPedInAnyVehicle(Ped) then
		QBCore.Functions.Notify('You are not close to the fishing area!', 'error')
	else
		if pos.y >= 7700 or pos.y <= -4000 or pos.x <= -3700 or pos.x >= 4300 then
        StartFishing()
		else
			QBCore.Functions.Notify('You are not close to the fishing area!', 'error')
		end
	end
	
end)





 StartFishing = function()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(PlayerPedId())
    ClearPedTasks(ped)
    SetEntityHeading(ped, 147.46)
    TaskStartScenarioInPlace(ped, "WORLD_HUMAN_STAND_FISHING", 0, false)
    Wait(5000)
    local example = exports['cd_keymaster']:StartKeyMaster()
    if example then
        TriggerServerEvent('Alen-Fishing:Add')
		QBCore.Functions.Notify('You caught some fishes!', 'success')
		PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 0)
    else
		QBCore.Functions.Notify('Fishes got away!', 'error')
		PlaySoundFrontend(-1, "MP_Flash", "WastedSounds", 0)
    end
    local Rod = GetClosestObjectOfType(coords, 40.0, GetHashKey("prop_fishing_rod_01"), false, false, false)
	ClearPedTasks(ped)
	SetEntityAsMissionEntity(Rod, true, true)
	DeleteEntity(Rod)
end

 DrawText3D = function(x, y, z, text)
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

MathPrice = function()
	local alen = 0
	QBCore.Functions.TriggerCallback('Alen-Fishing:MathPrice', function(result)
		alen = result
	end)
	Citizen.Wait(500)
	return alen
end