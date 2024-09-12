-----MOBIUS------
local QBCore = exports['qb-core']:GetCoreObject()

local PlayerJob = {}
local DeliveryBlips = {}
local TargetZones = {}
local TotalDeliveries = 0
local Prop = nil
local HasPapers = false
local RandomDeliveries = {}

local function PlaceNewspaperProp(location)
    local playerPed = PlayerPedId()
    local dict = "amb@medic@standing@kneel@base"
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(100)
    end
    TaskPlayAnim(playerPed, dict, "base", 8.0, -8.0, 2000, 0, 0, false, false, false)
    while IsEntityPlayingAnim(playerPed, dict, "base", 3) do
        Wait(100)
    end
    local propModel = "ng_proc_paper_news_rag"
    RequestModel(propModel)
    while not HasModelLoaded(propModel) do
        Wait(100)
    end
    local prop = CreateObject(GetHashKey(propModel), location.x, location.y, location.z, true, true, true)
    PlaceObjectOnGroundProperly(prop)
    SetEntityAsMissionEntity(prop, true, true)
    ClearPedTasks(playerPed)
    Wait(15000)
    DeleteObject(prop)
end

local function AddFinishShiftTarget()
    exports['qb-target']:AddCircleZone("finish_shift", vector3(Config.PickupPoint.x, Config.PickupPoint.y, Config.PickupPoint.z), 1.5, {
        name = "finish_shift",
        debugPoly = false,
        useZ = true
    }, {
        options = {
            {
                type = "client",
                event = "newsjob:client:FinishShift",
                icon = "fas fa-clipboard",
                label = "Finish Shift",
            },
        },
        distance = 2.5
    })
end

local function RemoveDeliveryBlipAndTarget(location)
    for i, blip in ipairs(DeliveryBlips) do
        local blipCoords = GetBlipCoords(blip)
        if #(blipCoords - vector3(location.x, location.y, location.z)) < 1.0 then
            RemoveBlip(blip)
            table.remove(DeliveryBlips, i)
            break
        end
    end
    for i, zoneName in ipairs(TargetZones) do
        local zoneCoords = vector3(Config.DeliveryPoints[i].x, Config.DeliveryPoints[i].y, Config.DeliveryPoints[i].z)
        if #(zoneCoords - vector3(location.x, location.y, location.z)) < 1.0 then
            exports['qb-target']:RemoveZone(zoneName)
            table.remove(TargetZones, i)
            break
        end
    end
end

local function GetRandomDeliveryPoints(count)
    local deliveryPoints = {}
    local shuffled = {}
    for i, point in ipairs(Config.DeliveryPoints) do
        table.insert(shuffled, point)
    end
    for i = #shuffled, 2, -1 do
        local j = math.random(i)
        shuffled[i], shuffled[j] = shuffled[j], shuffled[i]
    end
    for i = 1, count do
        table.insert(deliveryPoints, shuffled[i])
    end
    return deliveryPoints
end

local function StartMission()
    if HasPapers then
        TriggerEvent('QBCore:Notify', "You already have newspapers to deliver!", "error")
        return
    end
    exports['qb-target']:RemoveZone("newspaper_pickup")
    HasPapers = true
    TriggerServerEvent('newsjob:server:GiveNewspapers')
    TriggerEvent('QBCore:Notify', "You picked up some newspapers! Deliver them now.", "success")
    RandomDeliveries = GetRandomDeliveryPoints(math.random(2, 3))
    TriggerEvent('newsjob:client:ShowDeliveryLocations', RandomDeliveries)
    AddFinishShiftTarget()
end

local function DeliverPapers(location)
    TotalDeliveries = TotalDeliveries + 1
    TriggerServerEvent('newsjob:server:DeliverNewspaperReward')
    TriggerEvent('QBCore:Notify', "You delivered the newspaper and earned $" .. Config.PaymentPerPaper .. "!", "success")
    PlaceNewspaperProp(location)
    RemoveDeliveryBlipAndTarget(location)
    if TotalDeliveries >= #RandomDeliveries then
        TriggerEvent('QBCore:Notify', "All deliveries completed!", "success")
        HasPapers = false
        TotalDeliveries = 0
    end
end

local function AddPickupPapersTarget()
    exports['qb-target']:AddCircleZone("newspaper_pickup", vector3(Config.PickupPoint.x, Config.PickupPoint.y, Config.PickupPoint.z), 1.5, {
        name = "newspaper_pickup",
        debugPoly = false,
        useZ = true
    }, {
        options = {
            {
                type = "client",
                event = "newsjob:client:StartMission",
                icon = "fas fa-box",
                label = "Pick Up Newspapers",
                job = "reporter"
            },
        },
        distance = 2.5
    })
end

RegisterNetEvent('newsjob:client:ShowDeliveryLocations', function(selectedDeliveries)
    DeliveryBlips = {}
    TargetZones = {}
    for i, loc in ipairs(selectedDeliveries) do
        local blip = AddBlipForCoord(loc.x, loc.y, loc.z)
        SetBlipSprite(blip, 280)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.8)
        SetBlipColour(blip, 3)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName("Newspaper Delivery")
        EndTextCommandSetBlipName(blip)
        table.insert(DeliveryBlips, blip)
        local zoneName = "delivery_" .. i
        exports['qb-target']:AddCircleZone(zoneName, vector3(loc.x, loc.y, loc.z), 1.5, {
            name = zoneName,
            debugPoly = false,
            useZ = true
        }, {
            options = {
                {
                    type = "client",
                    event = "newsjob:client:DeliverPapers",
                    icon = "fas fa-newspaper",
                    label = "Deliver Newspaper",
                    job = "reporter",
                    location = loc
                },
            },
            distance = 2.5
        })
        table.insert(TargetZones, zoneName)
    end
end)

local function EndMission()
    for i, blip in ipairs(DeliveryBlips) do
        RemoveBlip(blip)
    end
    DeliveryBlips = {}
    for i, zone in ipairs(TargetZones) do
        exports['qb-target']:RemoveZone(zone)
    end
    TargetZones = {}
    exports['qb-target']:RemoveZone("finish_shift")
    AddPickupPapersTarget()
    TriggerEvent('QBCore:Notify', "Shift completed! Go back to News station to get more.", "success")
    HasPapers = false
    TotalDeliveries = 0
end

RegisterNetEvent('newsjob:client:DeliverPapers', function(data)
    DeliverPapers(data.location)
end)

RegisterNetEvent('newsjob:client:StartMission', function()
    StartMission()
end)

RegisterNetEvent('newsjob:client:FinishShift', function()
    EndMission()
end)

CreateThread(function()
    AddPickupPapersTarget()
end)
