local QBCore = exports['qb-core']:GetCoreObject()

-- Events
RegisterServerEvent('Simple-Lumberjack:server:getItem', function(itemlist)
    local Player = QBCore.Functions.GetPlayer(source)
    local itemlist = itemlist
    local removed = false
    for k, v in pairs(itemlist) do
        if v.threshold > math.random(0, 100) then
            Player.Functions.AddItem(v.name, math.random(1, v.max))
            TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[v.name], "add")
            if v.remove ~= nil and not removed then
                removed = true
                Player.Functions.RemoveItem(v.remove, 1)
                TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[v.remove], "remove")
            end
        end
    end
end)

RegisterNetEvent('Simple-Lumberjack:server:sellplanke', function(args) 
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
	local args = tonumber(args)
	if args == 1 then 
		local planke = Player.Functions.GetItemByName("planke")
		if planke ~= nil then
			local payment = 200 -- sell price for item
			Player.Functions.RemoveItem("planke", 1, k)
			Player.Functions.AddMoney('bank', payment , "planke-sell")
			TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items["planke"], "remove", 1)
			TriggerClientEvent('QBCore:Notify', src, " 1 Sold for $"..payment, "success")
			TriggerClientEvent("Simple-Lumberjack:client:sellplanke", source)
		else
		    TriggerClientEvent('QBCore:Notify', src, "you have no planke to sell", "error")
        end 
    end
end)

QBCore.Functions.CreateUseableItem("battleaxe", function(source, item)
	local src = source
    TriggerClientEvent('Simple-Lumberjack:client:startpicking', src)
end)

QBCore.Functions.CreateUseableItem("cutter", function(source, item)
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local item = Player.Functions.GetItemByName("tommer")
    if item ~= nil then
        TriggerClientEvent('Simple-Lumberjack:client:startdry', src)
    else
        TriggerClientEvent('QBCore:Notify', src, 'You have nothing to Cut!..', 'error')
    end
end)
