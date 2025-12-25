local EnemyFarm = {}

local running = false
local teamSwitchRunning = false
local GUI, Utils, Config
local lastSpeedRoom = nil  -- Track last room where speed was set

function EnemyFarm.init(guiModule, utilsModule, configModule)
    GUI = guiModule
    Utils = utilsModule
    Config = configModule
    
    -- Update castle status continuously
    task.spawn(function()
        while true do
            local status = Utils.getCastleStatus()
            
            if status.available then
                GUI.CastleStatusLabel.Text = "Castle: " .. status.message
                GUI.CastleStatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100) -- Green
            else
                GUI.CastleStatusLabel.Text = "Castle: " .. status.message
                GUI.CastleStatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100) -- Red
            end
            
            wait(10) -- Update every 10 seconds
        end
    end)
    
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
            EnemyFarm.start(false) -- false = need to join floor
        end
    end)
end

-- Wait for castle availability and AUTO-JOIN when ready
local function waitForCastleAndJoin()
    while not Utils.isCastleAvailable() do
        local status = Utils.getCastleStatus()
        GUI.EnemyStatus.Text = "Status: " .. status.message
        print("Waiting for castle:", status.message)
        wait(30)
        
        if not running then return false end
    end
    
    -- Castle is now available - AUTO JOIN
    print("Castle is available! Auto-joining floor 500...")
    GUI.EnemyStatus.Text = "Status: Castle open! Joining floor 500..."
    wait(1)
    
    local joined = EnemyFarm.joinFloor()
    if joined then
        wait(3) -- Wait for teleport to complete
        GUI.EnemyStatus.Text = "Status: Restarted from floor 500"
        lastSpeedRoom = nil  -- Reset speed tracking after rejoin
        return true
    else
        GUI.EnemyStatus.Text = "Status: Failed to join castle"
        return false
    end
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

-- Join floor 500
function EnemyFarm.joinFloor()
    -- Check if castle is available first
    if not Utils.isCastleAvailable() then
        local status = Utils.getCastleStatus()
        GUI.EnemyStatus.Text = "Status: Castle not available! " .. status.message
        print("Cannot join - castle is closed")
        return false
    end
    
    print("Joining floor 500...")
    GUI.EnemyStatus.Text = "Status: Joining floor 500..."
    
    buyCastleTicket()
    wait(1)
    
    local args = {
        {
            {
                Check = true,
                Action = "Join",
                Floor = "500",
                Event = "CastleAction"
            },
            "\004"
        }
    }
    Utils.sendRemote(args)
    
    wait(2)
    GUI.FloorJoinButton.BackgroundColor3 = Color3.fromRGB(50, 220, 50)
    GUI.FloorJoinButton.Text = "Floor 500 Joined ✓"
    GUI.EnemyStatus.Text = "Status: Ready to farm!"
    return true
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
    print("Speed set to:", speed)
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
-- skipJoin: true if already in castle, false if need to join
function EnemyFarm.start(skipJoin)
    -- If not in castle and not skipping join, must join first
    if not skipJoin and not Utils.isPlayerInCastle() then
        local joined = EnemyFarm.joinFloor()
        if not joined then
            GUI.EnemyStatus.Text = "Status: Failed to join castle"
            return
        end
        -- Wait for teleport to castle
        wait(3)
    end
    
    running = true
    Config.update("enemyFarmEnabled", true)  -- Save state
    GUI.EnemyToggle.BackgroundColor3 = Color3.fromRGB(50, 220, 50)
    GUI.EnemyToggle.Text = "Stop Enemy Farm"
    
    startTeamSwitching()
    
    task.spawn(function()
        while running do
            local currentRoom = Utils.getPlayerCurrentRoom()
            if currentRoom then
                GUI.CurrentRoomLabel.Text = "Current Room: " .. currentRoom
                
                -- Set speed based on current room (only when room changes)
                if currentRoom ~= lastSpeedRoom then
                    if currentRoom == 500 then
                        setSpeed(4)
                        lastSpeedRoom = currentRoom
                        print("Speed set to 4 (Room 500)")
                    elseif currentRoom == 1 then
                        setSpeed(1)
                        lastSpeedRoom = currentRoom
                        print("Speed set to 1 (Room 1)")
                    end
                end
            end
            
            -- Floor 500 restart logic
            if currentRoom and currentRoom >= 1000 and checkAllEnemiesDead() then
                GUI.EnemyStatus.Text = "Status: Floor 500 reached! Waiting for castle..."
                print("Floor 500 completed, waiting for castle availability...")
                
                -- Wait for castle and auto-join when available
                local success = waitForCastleAndJoin()
                
                if success and running then
                    print("Successfully rejoined castle, continuing farm...")
                    -- Continue farming loop
                else
                    print("Failed to rejoin or farming stopped")
                    break
                end
            elseif checkAllEnemiesDead() then
                GUI.EnemyStatus.Text = "Status: All enemies defeated!"
                
                if currentRoom and currentRoom >= 1000 then
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
    lastSpeedRoom = nil  -- Reset speed tracking
    Config.update("enemyFarmEnabled", false)  -- Save state
    GUI.EnemyToggle.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    GUI.EnemyToggle.Text = "Start Enemy Farm"
    GUI.EnemyStatus.Text = "Status: Idle"
end

return EnemyFarm
