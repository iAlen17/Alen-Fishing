local QBCore = exports['qb-core']:GetCoreObject()

local ItemList = {
    ["fish"] = 65,
}

discord = {
    ['webhook'] = 'https://discord.com/api/webhooks/905764578372222986/is6jjORImn8kN-7eoocmim_Ps5VatcvMxXMnYemJTIyzOO0iJoDdI_hZXJ89KfoI1KCu',
    ['name'] = 'FIB Heist Logs',
    ['image'] = 'https://cdn.discordapp.com/attachments/774536621802389544/899986988386623498/logo.png'
}


RegisterServerEvent('Alen-Fishing:Add')
AddEventHandler('Alen-Fishing:Add', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local item = fish
    local chance = math.random(3,7)

    Player.Functions.AddItem("fish", chance)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["fish"], 'add')
    sendtodiscordaslog(Player.PlayerData.name ..  ' - ' .. Player.PlayerData.license, ' Caught '   ..  chance .. ' fishes!')
end)

RegisterServerEvent("Alen-Fishing:Sell")
AddEventHandler("Alen-Fishing:Sell", function()
    local src = source
    local price = 0
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then 
        for k, v in pairs(Player.PlayerData.items) do 
            if Player.PlayerData.items[k] ~= nil then 
                if ItemList[Player.PlayerData.items[k].name] ~= nil then 
                    price = price + (ItemList[Player.PlayerData.items[k].name] * Player.PlayerData.items[k].amount)
                    Player.Functions.RemoveItem(Player.PlayerData.items[k].name, Player.PlayerData.items[k].amount, k)
                end
            end
        end
        Player.Functions.AddMoney("cash", price)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["fish"], 'remove')
        sendtodiscordaslog(Player.PlayerData.name ..  ' - ' .. Player.PlayerData.license, ' Earned $' .. price .. ' By Selling fishes!')
    end
end)

QBCore.Functions.CreateCallback('Alen-Fishing:MathPrice', function(source, cb)
    local retval = 0
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then 
        for k, v in pairs(Player.PlayerData.items) do 
            if Player.PlayerData.items[k] ~= nil then 
                if ItemList[Player.PlayerData.items[k].name] ~= nil then 
                    retval = retval + (ItemList[Player.PlayerData.items[k].name] * Player.PlayerData.items[k].amount)
                end
            end
        end
    end
    cb(retval)
end)

QBCore.Functions.CreateUseableItem('fishingrod', function(source, item) 
    local Player = QBCore.Functions.GetPlayer(source)
		TriggerClientEvent('fishing:useRod', source)
        sendtodiscordaslog(Player.PlayerData.name ..  ' - ' .. Player.PlayerData.license .. ' - ' .. Player.PlayerData.job.name, ' Tried to start fishing')
end)

function sendtodiscordaslog(name, message)
    local data = {
        {
            ["color"] = '3553600',
            ["title"] = "**".. name .."**",
            ["description"] = message,
        }
    }
    PerformHttpRequest(discord['webhook'], function(err, text, headers) end, 'POST', json.encode({username = discord['name'], embeds = data, avatar_url = discord['image']}), { ['Content-Type'] = 'application/json' })
end

