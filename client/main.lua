local C = Config
local npcPos = vector3(C.Int.npc.x, C.Int.npc.y, C.Int.npc.z) -- Posición del NPC
local teleportPos = C.Int.tp.TpEnter -- Posición a la que se teletransporta el jugador
local TpKilledPos = C.Int.tp.TpDie -- Posición a la que se teletransporta el jugador cuando muere
local PlayerJoined = false



function notify(msg, type)
    if C.Framework == 'QBCore' then
        local QBCore = exports['qb-core']:GetCoreObject()
        QBCore.Functions.Notify(msg, type, 3500)
    else
        local ESX = exports["es_extended"]:getSharedObject()
        ESX.ShowNotification(msg, type, 3500)
    end
    
end

-- Bucle principal para detectar cuando el jugador pulsa la tecla "E" cerca del NPC
Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(0) 
        local playerPed = PlayerPedId() 
        local playerPos = GetEntityCoords(playerPed) 
        local distance = GetDistanceBetweenCoords(playerPos, npcPos) 
        if distance < 5 then 
            if IsControlJustPressed(0, 38) then 
                if not PlayerJoined then
                    PlayerJoined = true
                    SetEntityCoords(playerPed, teleportPos) 
                    TriggerEvent('ab-counter:cl:UIstatus', 'yes')
                    TriggerServerEvent("ab-counter:sv:JoinAlivePlayers") 
                else
                    notify(C.Int.notify.CantJoinAgain, 'error')
                end
            end 
        end 
    end 
end)

local playersAlive = 0
local kills = 0

-- Función para dibujar el texto en la pantalla
function DrawCounter()
    SendNUIMessage({ 
        type = "actualizarContadores",
        numJugadores = playersAlive,
        numBajas = kills
    })
end

-- Evento para actualizar el contador con los datos recibidos desde el servidor
RegisterNetEvent("ab-cnntador:cl:UpdateCounter")
AddEventHandler("UpdateCounter", function(alive, killed)
    playersAlive = alive
    kills = killed
    if PlayerJoined then
        DrawCounter()
    end
end)

-- Bucle principal para dibujar el contador cada frame
Citizen.CreateThread(function()
    while PlayerJoined do 
        Wait(100)  
        DrawCounter() 
    end 
end)




-- crear npc

local coordNpc = {
    {C.Int.npc.x, C.Int.npc.y, C.Int.npc.z -1,C.Int.npc.Name,C.Int.npc.h,C.Int.npc.hash,C.Int.npc.model},
	
}

Citizen.CreateThread(function()

    for _,v in pairs(coordNpc) do
      RequestModel(GetHashKey(v[7]))
      while not HasModelLoaded(GetHashKey(v[7])) do
        Wait(1)
      end
  
      ped =  CreatePed(4, v[6],v[1],v[2],v[3], 3374176, false, true)
      SetEntityHeading(ped, v[5])
      FreezeEntityPosition(ped, true)
      SetEntityInvincible(ped, true)
      SetBlockingOfNonTemporaryEvents(ped, true)
    end
end)

Citizen.CreateThread(function()
    while true do
        local pos = GetEntityCoords(GetPlayerPed(-1), true)
        Citizen.Wait(0)
        for _,v in pairs(coordNpc) do
            x = v[1]
            y = v[2]
            z = v[3]
            if(Vdist(pos.x, pos.y, pos.z, x, y, z) < 3.0)then
                DrawText3D(x,y,z+2.10, C.Int.npc.message, 1.2, 1)
            end
        end
    end
end)


function DrawText3D(x,y,z, text, scl, font) 

    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
    local scale = (1/dist)*scl
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
   
    if onScreen then
        SetTextScale(0.0*scale, 1.1*scale)
        SetTextFont(font)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

AddEventHandler('gameEventTriggered', function(event, data)
    if event == "CEventNetworkEntityDamage" then
        local victim, attacker, victimDied = data[1], data[2], data[4]
        if not IsEntityAPed(victim) then return end
        if victimDied and NetworkGetPlayerIndexFromPed(victim) == PlayerId() and IsEntityDead(PlayerPedId()) then
            if not isDead then
                local killer = NetworkGetPlayerIndexFromPed(attacker)
                local killerId = GetPlayerServerId(killer)
                local victima = NetworkGetPlayerIndexFromPed(victim)
                local IDvictima = GetPlayerServerId(victima)
                --print("killer: "..killerId)
                --print("victim: ".."IDvictima)
                TriggerServerEvent('ab-counter:sv:playerKilled', killerId, IDvictima) 
            end
        end
    end
end)

RegisterNetEvent('ab-counter:cl:tpvictima', function()
    SetEntityCoords(PlayerPedId(), TpKilledPos)
    TriggerEvent('ab-counter:cl:UIstatus', 'no')
end)

RegisterNetEvent('ab-counter:cl:UIstatus', function(data)
    if data == 'yes' then
        SendNUIMessage({
            type = "ShowBox",
        })
    elseif data == 'no' then
        SendNUIMessage({
            type = "HideBox"})
    end
end)
