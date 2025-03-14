local asphaltSurfaces = {
    1, 2, 3, 4, 5, 6, 7
}

local function isVehicleOnAsphalt(vehicle)
    for i = 0, 3 do
        local surfaceMaterial = GetVehicleWheelSurfaceMaterial(vehicle, i)
        if not surfaceMaterial then
            return false
        end
        
        local isAsphalt = false
        for _, asphaltID in ipairs(asphaltSurfaces) do
            if surfaceMaterial == asphaltID then
                isAsphalt = true
                break
            end
        end
        
        if not isAsphalt then
            return false
        end
    end
    return true
end

local function isVehicleNonSlippery(vehicle)
    local model = GetEntityModel(vehicle)
    for _, car in ipairs(Config.NonSlipperyVehicles) do
        if model == GetHashKey(car) then
            return true
        end
    end
    return false
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(Config.CheckInterval)
        local playerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        
        if vehicle and GetPedInVehicleSeat(vehicle, -1) == playerPed and not isVehicleNonSlippery(vehicle) then
            if not isVehicleOnAsphalt(vehicle) then
                local randomReduce = math.random(0, 1)
                Citizen.Wait(1000)
                SetVehicleReduceGrip(vehicle, randomReduce) --randomReduce yazması olup olmamasını rastgele belirler eğer süreklilik istiyorsanız bu değeri true yapın
                TriggerEvent("chat:addMessage", { args = { "Sistem", "Araç asfalt dışında olduğu için kaymaya başladı" } })
            else
                SetVehicleReduceGrip(vehicle, false)
            end
        end
    end
end)