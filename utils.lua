local Utils = {}

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

Utils.player = Players.LocalPlayer
Utils.character = Utils.player.Character or Utils.player.CharacterAdded:Wait()
Utils.humanoidRootPart = Utils.character:WaitForChild("HumanoidRootPart")

-- Refresh character reference
function Utils.refreshCharacter()
    Utils.character = Utils.player.Character or Utils.player.CharacterAdded:Wait()
    Utils.humanoidRootPart = Utils.character:WaitForChild("HumanoidRootPart")
end

-- Server hop
function Utils.serverHop()
    print("Attempting to server hop...")
    
    local success, errorMessage = pcall(function()
        local serverList = {}
        local placeId = game.PlaceId
        
        local servers = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100"))
        
        for _, server in pairs(servers.data) do
            if server.id ~= game.JobId and server.playing < server.maxPlayers then
                table.insert(serverList, server.id)
            end
        end
        
        if #serverList > 0 then
            local randomServer = serverList[math.random(1, #serverList)]
            TeleportService:TeleportToPlaceInstance(placeId, randomServer, Utils.player)
        else
            TeleportService:Teleport(placeId, Utils.player)
        end
    end)
    
    if not success then
        warn("Server hop failed:", errorMessage)
        wait(2)
        TeleportService:Teleport(game.PlaceId, Utils.player)
    end
end

-- Get player's current room
function Utils.getPlayerCurrentRoom()
    local main = workspace:FindFirstChild("__Main")
    if not main then return nil end
    
    local world = main:FindFirstChild("__World")
    if not world then return nil end
    
    for _, child in pairs(world:GetChildren()) do
        if child:IsA("Model") and string.match(child.Name, "^Room_(%d+)$") then
            local playersSpawns = child:FindFirstChild("PlayersSpawns")
            if playersSpawns then
                local roomNumber = tonumber(string.match(child.Name, "^Room_(%d+)$"))
                return roomNumber, child
            end
        end
    end
    
    return nil, nil
end

-- Check if player is in castle
function Utils.isPlayerInCastle()
    local main = workspace:FindFirstChild("__Main")
    if not main then return false end
    
    local world = main:FindFirstChild("__World")
    if not world then return false end
    
    local room1 = world:FindFirstChild("Room_1")
    return room1 ~= nil
end

-- Get castle availability status with time info
function Utils.getCastleStatus()
    local currentTime = os.date("*t")
    local minute = currentTime.min
    
    local isAvailable = (minute >= 15 and minute <= 26) or (minute >= 45 and minute <= 56)
    
    local nextAvailableMinute
    local minutesUntil
    
    if minute < 15 then
        nextAvailableMinute = 15
        minutesUntil = 15 - minute
    elseif minute > 26 and minute < 45 then
        nextAvailableMinute = 45
        minutesUntil = 45 - minute
    elseif minute > 56 then
        nextAvailableMinute = 15
        minutesUntil = (60 - minute) + 15
    else
        -- Currently available
        local minutesLeft
        if minute >= 15 and minute <= 26 then
            minutesLeft = 26 - minute
        else
            minutesLeft = 56 - minute
        end
        
        return {
            available = true,
            minutesLeft = minutesLeft,
            message = "OPEN (" .. minutesLeft .. " min left)"
        }
    end
    
    return {
        available = false,
        minutesUntil = minutesUntil,
        message = "CLOSED (" .. minutesUntil .. " min until open)"
    }
end

-- Check if castle is available
function Utils.isCastleAvailable()
    return Utils.getCastleStatus().available
end

-- Send remote event
function Utils.sendRemote(args)
    ReplicatedStorage:WaitForChild("BridgeNet2"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))
end

return Utils
