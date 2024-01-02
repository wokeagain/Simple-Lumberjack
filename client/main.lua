-- Variables

local QBCore = exports['qb-core']:GetCoreObject()
local inPickingArea = false
local inDryingArea = false
local currentspot = nil
local previousspot = nil
local PickingLocations = {}
local DryingLocations = {}
local Blips = {}
local mineWait = false

-- Functions

local function dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k,v in pairs(o) do
            if type(k) ~= 'number' then k = '"'..k..'"' end
            s = s .. '['..k..'] = ' .. dump(v) .. ','
        end
        return s .. '} '
    else
       return tostring(o)
    end
end

local function loadModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
        RequestModel(model)
    end
    return model
end

local function loadDict(dict, anim)
    while not HasAnimDictLoaded(dict) do
        Wait(0)
        RequestAnimDict(dict)
    end
    return dict
end

local function helpText(msg)
    BeginTextCommandDisplayHelp('STRING')
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

local function addBlip(coords, sprite, colour, scale, text)
    local blip = AddBlipForCoord(coords)
    SetBlipSprite(blip, sprite)
    SetBlipColour(blip, colour)
    SetBlipScale(blip, scale)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(text)
    EndTextCommandSetBlipName(blip)
end

local function CreateBlips() -- Create mining blips
	for k, v in pairs(Config.Blips) do
        Blips[k] = AddBlipForCoord(v.blippoint)
        SetBlipSprite(Blips[k], v.blipsprite)
        SetBlipDisplay(Blips[k], 4)
        SetBlipScale(Blips[k], v.blipscale)
        SetBlipAsShortRange(Blips[k], true)
        SetBlipColour(Blips[k], v.blipcolour)
        SetBlipAlpha(Blips[k], 0.7)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(v.label)
        EndTextCommandSetBlipName(Blips[k])
    end
end

-- Events

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function() -- Event when player has successfully loaded
    TriggerEvent('Simple-Lumberjack:client:DestroyZones') -- Destroy all zones
	Wait(100)
	TriggerEvent('Simple-Lumberjack:client:UpdatePickingZones') -- Reload mining information
	Wait(100)
	TriggerEvent('Simple-Lumberjack:client:UpdateDryingZones') -- Reload smelting information
	Wait(100)
	CreateBlips() --Reload blips
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function() -- Reset all variables
	TriggerEvent('Simple-Lumberjack:client:DestroyZones') -- Destroy all zones
	inPickingArea = false
    currentspot = nil
    previousspot = nil
    PickingLocations = {}
    DryingLocations = {}
	Blips = {}
	Peds = {}
end)

AddEventHandler('onResourceStart', function(resource) -- Event when resource is reloaded
    if resource == GetCurrentResourceName() then -- Reload player information
		TriggerEvent('Simple-Lumberjack:client:DestroyZones') -- Destroy all zones
		Wait(100)
		TriggerEvent('Simple-Lumberjack:client:UpdatePickingZones') -- Reload mining information
		Wait(100)
		TriggerEvent('Simple-Lumberjack:client:UpdateDryingZones') -- Reload smelting information
		Wait(100)
		CreateBlips()
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then -- Reload player information
		TriggerEvent('Simple-Lumberjack:client:DestroyZones') -- Destroy all zones
    end
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo) --Events when players change jobs
    TriggerEvent('Simple-Lumberjack:client:DestroyZones') -- Destroy all zones
	Wait(100)
	TriggerEvent('Simple-Lumberjack:client:UpdatePickingZones') -- Reload mining information
	Wait(100)
	TriggerEvent('Simple-Lumberjack:client:UpdateDryingZones') -- Reload smelting information
	Wait(100)
	CreateBlips() --Reload blips
end)

RegisterNetEvent('Simple-Lumberjack:client:UpdatePickingZones', function() -- Update Picking Zones
    for k, v in pairs(Config.Picking) do
        PickingLocations[k] = PolyZone:Create(v.zones, {
            name='Picking '..k,
            minZ = 	v.minz,
            maxZ = v.maxz,
            debugPoly = false
        })
    end
end)

RegisterNetEvent('Simple-Lumberjack:client:UpdateDryingZones', function() -- Update Drying Zones
    for k, v in pairs(Config.Drying) do
        DryingLocations[k] = PolyZone:Create(v.zones, {
            name='DryingStation '..k,
            minZ = 	v.minz,
            maxZ = v.maxz,
            debugPoly = false
        })
    end
end)

RegisterNetEvent('Simple-Lumberjack:client:DestroyZones', function() -- Destroy all zones
    if PickingLocations then
		for k, v in pairs(PickingLocations) do
			PickingLocations[k]:destroy()
		end
	end
    if DryingLocations then
		for k, v in pairs(DryingLocations) do
			DryingLocations[k]:destroy()
		end
	end
	PickingLocations = {}
    DryingLocations = {}
end)

RegisterNetEvent('Simple-Lumberjack:client:startpicking', function() -- Start mining
	if not pickWait then
		pickWait = true
		SetTimeout(5000, function()
			pickWait = false
		end)
		local Ped = PlayerPedId()
		local coord = GetEntityCoords(Ped)
		for k, v in pairs(PickingLocations) do
			if PickingLocations[k] then
				if PickingLocations[k]:isPointInside(coord) then
					local model = loadModel(`prop_w_me_hatchet`)
					local axe = CreateObject(model, GetEntityCoords(Ped), true, false, false)
					AttachEntityToEntity(axe, Ped, GetPedBoneIndex(Ped, 57005), 0.09, 0.03, -0.02, -78.0, 13.0, 28.0, false, true, true, true, 0, true)
					QBCore.Functions.Progressbar("startpicking", "Cutting down Tree", 3000, false, false, {
						disableMovement = true,
						disableCarMovement = true,
						disableMouse = false,
						disableCombat = true,
                    }, {
						animDict = "melee@hatchet@streamed_core", 
						anim = "plyr_rear_takedown_b", 
						flags = 8,
					}, {}, {}, function() -- Done
						Wait(1000)
                                                StopAnimTask(Ped, "mini@repair", "startpicking", 1.0)
						ClearPedTasks(Ped)
						DeleteObject(axe)
						TriggerServerEvent('Simple-Lumberjack:server:getItem', Config.PickingItems)
						QBCore.Functions.Notify("You picked Tree go Process it..", "success")
					end)
				end
			end
		end
	else
		QBCore.Functions.Notify("You need to wait a few more seconds to sharpen your blade.", "error")
	end
end)

RegisterNetEvent('Simple-Lumberjack:client:startdry', function() -- Start smelting
	local Ped = PlayerPedId()
	local coord = GetEntityCoords(Ped)
	for k, v in pairs(DryingLocations) do
		if DryingLocations[k] then 
			if DryingLocations[k]:isPointInside(coord) then
				QBCore.Functions.Progressbar("startdry", "Proccesing the Tommer", 6000, false, false, {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				}, {
					animDict = "mp_arresting", 
					anim = "a_uncuff", 
					flags = 8,
				}, {}, {}, function() -- Done
					StopAnimTask(Ped, "mp_arresting", "startdry", 1.0)
					ClearPedTasks(Ped)
					TriggerServerEvent('Simple-Lumberjack:server:getItem', Config.DryingItems)
					QBCore.Functions.Notify("You processed your Tree!..", "success")					
				end)
			end
		end
	end
end)

-- Selling
local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('Simple-Lumberjack:client:sellplanke')
AddEventHandler('Simple-Lumberjack:client:sellplanke', function()
    exports['qb-menu']:openMenu({
		{
            header = "Dealer",
            isMenuHeader = true
        },
        {
            header = "Lumber Dealer",
            txt = "Sell your Planke here",
            params = {
				isServer = true,
                event = "Simple-Lumberjack:server:sellplanke",
				args = 1 
            }
        },			
        {
            header = "Close",
            txt = "",
            params = {
                event = "qb-menu:closeMenu"
            }
        },
    })
end)

-- Ped Spawn
local dealerPed = {
	{598.9048, -3124.0042, 5.0693,"EL Trope",177.0480,0x7E4F763F,"g_m_m_chigoon_01"}, -- Ped dealer
  
  }
  Citizen.CreateThread(function()
	  for _,v in pairs(dealerPed) do
		  RequestModel(GetHashKey(v[7]))
		  while not HasModelLoaded(GetHashKey(v[7])) do
			  Wait(1)
		  end
		  CokeProcPed =  CreatePed(4, v[6],v[1],v[2],v[3], 3374176, false, true)
		  SetEntityHeading(CokeProcPed, v[5])
		  FreezeEntityPosition(CokeProcPed, true)
		  SetEntityInvincible(CokeProcPed, true)
		  SetBlockingOfNonTemporaryEvents(CokeProcPed, true)
		  TaskStartScenarioInPlace(CokeProcPed, "WORLD_HUMAN_AA_SMOKE", 0, true) 
	  end
  end)

-- Target
exports['qb-target']:AddBoxZone("lumberjack", vector3(598.859, -3123.936, 6.069), 1, 1, {
	name = "lumberjack",
	heading = 174,
	debugPoly = false,
	minZ = 5.30,
	maxZ = 7.0,
}, {
	options = {
		{
                type = "client",
                event = "Simple-Lumberjack:client:sellplanke",
	        icon = "fas fa-seedling",
		label = "Sell Planke",

		},
	},
	distance = 2.5
})
