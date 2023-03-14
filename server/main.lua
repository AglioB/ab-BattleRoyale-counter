local playersAlive = 0 -- Variable para guardar los jugadores vivos
local kills = {} -- Tabla para guardar las bajas realizadas por cada jugador

-- Función para enviar el evento "UpdateCounter" a todos los clientes conectados
function UpdateCounter()
    for _, player in ipairs(GetPlayers()) do 
        local playerId = tonumber(player) 
        local playerKills = kills[playerId] or 0 
        TriggerClientEvent("ab-counter:cl:UpdateCounter", playerId, playersAlive, playerKills) 
    end 
end

-- Evento para integrar a un jugador a los jugadores vivos cuando se teletransporta desde el NPC
RegisterServerEvent("ab-counter:sv:JoinAlivePlayers")
AddEventHandler("ab-counter:sv:JoinAlivePlayers", function()
    playersAlive = playersAlive + 1 
    UpdateCounter()  
end)

-- Evento para actualizar el contador cuando un jugador se desconecta del servidor
AddEventHandler("playerDropped", function()
    playersAlive = playersAlive - 1  
    UpdateCounter() 
end)

-- Evento para actualizar el contador cuando un jugador mata a otro jugador 
RegisterServerEvent("ab-counter:sv:playerKilled")
AddEventHandler("ab-counter:sv:playerKilled", function(killerId, playerKilled)
    kills[killerId] = (kills[killerId] or 0) + 1 
    playersAlive = playersAlive - 1
    TriggerClientEvent('ab-counter:cl:tpvictima', source)
    UpdateCounter() 
end)
