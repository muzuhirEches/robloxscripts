local EnemyFarm = {}

local running = false
local teamSwitchRunning = false
local GUI, Utils

function EnemyFarm.init(guiModule, utilsModule)
    GUI = guiModule
    Utils = utilsModule
    
    -- Update room label continuously
    task.spawn(function()
        while true do
            local currentRoom = Utils.getPlayerCurrentRoom()
            if currentRoom then
                GUI.CurrentRoomLabel.Text = "Current Room: " .. currentRoom
            else
                GUI.CurrentRoomLabel.Text = "Current Room: Unknown"
            end
            wait(1)
        end
    end)
    
    -- Button connections
    GUI.FloorJoinButton.MouseButton1Click:Connect(function()
        EnemyFarm.joinFloor()
    end)
    
    GUI.EnemyToggle.MouseButton1Click:Connect(function()
        if running then
            EnemyFarm.stop()
        else
            EnemyFarm.start()
        end
    end)
end

-- Wait for castle availability
local function waitForCastleAvailability()
    while not Utils.isCastleAvailable() do
        local currentTime = os.date("*t")
        local minute = currentTime.min
        local secondsToWait
        
        if minute < 15 then
            secondsToWait = (15 - minute) * 60 - currentTime.sec
        elseif minute < 45 then
            secondsToWait = (45 - minute) * 60 - currentTime.sec
        else
            secondsToWait = (75 - minute) * 60 - currentTime.sec
        end
        
        GUI.EnemyStatus.Text = "Status: Waiting for castle (" .. math.ceil(secondsToWait / 60) .. " min)"
        wait(30)
        
        if not running then return false end
    end
    
    return true
end

-- Buy castle ticket
local function buyCastleTicket()
    GUI.EnemyStatus.Text = "Status: Buying castle ticket..."
    
    local args = {
        {
            {
                Type = "Gems",
                Event = "CastleAction",
                Action = "BuyTicket"
            },
            "\004"
        }
    }
    Utils.sendRemote(args)
    wait(1)
end

-- Join floor 400
function EnemyFarm.joinFloor()
    print("Joining floor 400...")
    GUI.EnemyStatus.Text = "Status: Joining floor 400..."
    
    buyCastleTicket()
    wait(1)
    
    local args = {
        {
            {
                Check = true,
                Action = "Join",
                Floor = "400",
                Event = "CastleAction"
            },
            "\004"
        }
    }
    Utils.sendRemote(args)
    
    wait(2)
    GUI.FloorJoinButton.BackgroundColor3 = Color3.fromRGB(50, 220, 50)
    GUI.FloorJoinButton.Text = "Floor 400 Joined ✓"
    GUI.EnemyStatus.Text = "Status: Ready to farm!"
end

-- Switch team
local function switchTeam(teamId)
    local args = {
        {
            {
                Action = "Equip",
                Event = "Teams",
                TeamId = teamId
            },
            "\004"
        }
    }
    Utils.sendRemote(args)
end

-- Set speed
local function setSpeed(speed)
    local args = {
        {
            {
                Speed = speed,
                Event = "CastleAction",
                Action = "SpeedUp"
            },
            "\004"
        }
    }
    Utils.sendRemote(args)
end

-- Check if current room has FirePortal
local function doesCurrentRoomHaveFirePortal()
    local currentRoomNum, currentRoomModel = Utils.getPlayerCurrentRoom()
    if not currentRoomModel then return false end
    
    local firePortal = currentRoomModel:FindFirstChild("FirePortal")
    return firePortal ~= nil
end

-- Teleport to FirePortal and activate
local function teleportToFirePortalAndActivate()
    local currentRoomNum, currentRoomModel = Utils.getPlayerCurrentRoom()
    if not currentRoomModel then
        GUI.EnemyStatus.Text = "Status: Can't find current room"
        return false
    end
    
    local firePortal = currentRoomModel:FindFirstChild("FirePortal")
    if not firePortal or not firePortal:IsA("BasePart") then
        GUI.EnemyStatus.Text = "Status: No FirePortal in current room"
        return false
    end
    
    Utils.humanoidRootPart.CFrame = firePortal.CFrame
    GUI.EnemyStatus.Text = "Status: At FirePortal, activating..."
    wait(0.5)
    
    local proximityPrompt = firePortal:FindFirstChildOfClass("ProximityPrompt", true)
    if not proximityPrompt then
        for _, descendant in pairs(currentRoomModel:GetDescendants()) do
            if descendant:IsA("ProximityPrompt") and descendant.Enabled then
                proximityPrompt = descendant
                break
            end
        end
    end
    
    if proximityPrompt then
        fireproximityprompt(proximityPrompt)
        wait(2)
        GUI.EnemyStatus.Text = "Status: FirePortal activated!"
        return true
    else
        GUI.EnemyStatus.Text = "Status: FirePortal prompt not found"
        return false
    end
end

-- Team switching loop
local function startTeamSwitching()
    teamSwitchRunning = true
    task.spawn(function()
        while teamSwitchRunning do
            wait(15)
            if not running then break end
            
            switchTeam("74bd")
            wait(2)
            if not running then break end
            
            switchTeam("e654")
        end
    end)
end

-- Teleport to next enemy
local function teleportToNextEnemy()
    local main = workspace:FindFirstChild("__Main")
    if not main then
        GUI.EnemyStatus.Text = "Status: Waiting for __Main..."
        return false
    end
    
    local enemies = main:FindFirstChild("__Enemies")
    if not enemies then
        GUI.EnemyStatus.Text = "Status: Waiting for __Enemies..."
        return false
    end
    
    local server = enemies:FindFirstChild("Server")
    if not server then
        GUI.EnemyStatus.Text = "Status: Waiting for Server..."
        return false
    end
    
    for _, child in pairs(server:GetDescendants()) do
        if child:IsA("BasePart") then
            local HP = child:GetAttribute("HP")
            
            if HP and HP > 0 then
                GUI.EnemyStatus.Text = "Status: Teleporting to enemy..."
                Utils.humanoidRootPart.CFrame = child.CFrame * CFrame.new(10, 5, 0)
                wait(0.5)
                GUI.EnemyStatus.Text = "Status: Fighting (HP: " .. tostring(HP) .. ")"
                return true
            end
        end
    end
    
    GUI.EnemyStatus.Text = "Status: No alive enemies"
    return false
end

-- Check if all enemies dead
local function checkAllEnemiesDead()
    local main = workspace:FindFirstChild("__Main")
    if not main then return false end
    
    local enemies = main:FindFirstChild("__Enemies")
    if not enemies then return false end
    
    local server = enemies:FindFirstChild("Server")
    if not server then return false end
    
    for _, child in pairs(server:GetDescendants()) do
        if child:IsA("BasePart") then
            local HP = child:GetAttribute("HP")
            if HP and HP > 0 then
                return false
            end
        end
    end
    
    return true
end

-- Start farming
function EnemyFarm.start()
    running = true
    GUI.EnemyToggle.BackgroundColor3 = Color3.fromRGB(50, 220, 50)
    GUI.EnemyToggle.Text = "Stop Enemy Farm"
    
    startTeamSwitching()
    
    task.spawn(function()
        while running do
            local currentRoom = Utils.getPlayerCurrentRoom()
            if currentRoom then
                GUI.CurrentRoomLabel.Text = "Current Room: " .. currentRoom
                
                -- Set speed based on current room
                if currentRoom >= 490 then
                    setSpeed(4)
                else
                    setSpeed(1)
                end
            end
            
            -- Floor 500 restart logic
            if currentRoom and currentRoom >= 500 and checkAllEnemiesDead() then
                GUI.EnemyStatus.Text = "Status: Floor 500 reached! Restarting..."
                
                local castleReady = waitForCastleAvailability()
                
                if castleReady and running then
                    GUI.EnemyStatus.Text = "Status: Castle available! Rejoining..."
                    EnemyFarm.joinFloor()
                    wait(3)
                else
                    break
                end
            elseif checkAllEnemiesDead() then
                GUI.EnemyStatus.Text = "Status: All enemies defeated!"
                
                if currentRoom and currentRoom >= 500 then
                    GUI.EnemyStatus.Text = "Status: Floor 500 - Complete!"
                    wait(5)
                else
                    if doesCurrentRoomHaveFirePortal() then
                        GUI.EnemyStatus.Text = "Status: Going to FirePortal..."
                        wait(1)
                        teleportToFirePortalAndActivate()
                        wait(3)
                    else
                        GUI.EnemyStatus.Text = "Status: Waiting for FirePortal..."
                        wait(3)
                    end
                end
            else
                local success = teleportToNextEnemy()
                if not success then
                    wait(3)
                else
                    wait(1)
                end
            end
            
            Utils.refreshCharacter()
        end
    end)
end

-- Stop farming
function EnemyFarm.stop()
    running = false
    teamSwitchRunning = false
    GUI.EnemyToggle.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    GUI.EnemyToggle.Text = "Start Enemy Farm"
    GUI.EnemyStatus.Text = "Status: Idle"
end

return EnemyFarm
