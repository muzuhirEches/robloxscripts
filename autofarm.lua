local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Anti-AFK
player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
    print("Anti-AFK triggered")
end)

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local MinimizeButton = Instance.new("TextButton")
local TabContainer = Instance.new("Frame")
local PumpkinTab = Instance.new("TextButton")
local EnemyTab = Instance.new("TextButton")

-- Minimized Frame
local MinimizedFrame = Instance.new("Frame")
local MinimizedTitle = Instance.new("TextLabel")
local RestoreButton = Instance.new("TextButton")

-- Pumpkin Farm UI
local PumpkinFrame = Instance.new("Frame")
local PumpkinToggle = Instance.new("TextButton")
local PumpkinStatus = Instance.new("TextLabel")
local PumpkinAutoHop = Instance.new("TextButton")
local PumpkinManualHop = Instance.new("TextButton")

-- Enemy Farm UI
local EnemyFrame = Instance.new("Frame")
local FloorJoinButton = Instance.new("TextButton")
local EnemyToggle = Instance.new("TextButton")
local EnemyStatus = Instance.new("TextLabel")
local CurrentRoomLabel = Instance.new("TextLabel")

-- UI Corners
local function addCorner(obj, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = obj
    return corner
end

ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Main Frame
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
MainFrame.Position = UDim2.new(0.5, -175, 0.1, 0)
MainFrame.Size = UDim2.new(0, 350, 0, 300)
MainFrame.Active = true
MainFrame.Draggable = true
addCorner(MainFrame, 10)

-- Title
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 10, 0, 10)
Title.Size = UDim2.new(1, -60, 0, 30)
Title.Font = Enum.Font.GothamBold
Title.Text = "Multi Auto Farm"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Minimize Button
MinimizeButton.Parent = MainFrame
MinimizeButton.BackgroundColor3 = Color3.fromRGB(220, 180, 50)
MinimizeButton.Position = UDim2.new(1, -40, 0, 10)
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Text = "−"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 20
addCorner(MinimizeButton, 6)

-- Minimized Frame
MinimizedFrame.Parent = ScreenGui
MinimizedFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
MinimizedFrame.Position = UDim2.new(0.5, -100, 0.1, 0)
MinimizedFrame.Size = UDim2.new(0, 200, 0, 40)
MinimizedFrame.Active = true
MinimizedFrame.Draggable = true
MinimizedFrame.Visible = false
addCorner(MinimizedFrame, 10)

MinimizedTitle.Parent = MinimizedFrame
MinimizedTitle.BackgroundTransparency = 1
MinimizedTitle.Position = UDim2.new(0, 10, 0, 0)
MinimizedTitle.Size = UDim2.new(1, -50, 1, 0)
MinimizedTitle.Font = Enum.Font.GothamBold
MinimizedTitle.Text = "Multi Auto Farm"
MinimizedTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizedTitle.TextSize = 14
MinimizedTitle.TextXAlignment = Enum.TextXAlignment.Left

RestoreButton.Parent = MinimizedFrame
RestoreButton.BackgroundColor3 = Color3.fromRGB(50, 220, 50)
RestoreButton.Position = UDim2.new(1, -35, 0.5, -12)
RestoreButton.Size = UDim2.new(0, 25, 0, 25)
RestoreButton.Font = Enum.Font.GothamBold
RestoreButton.Text = "+"
RestoreButton.TextColor3 = Color3.fromRGB(255, 255, 255)
RestoreButton.TextSize = 18
addCorner(RestoreButton, 6)

-- Tab Container
TabContainer.Parent = MainFrame
TabContainer.BackgroundTransparency = 1
TabContainer.Position = UDim2.new(0, 10, 0, 45)
TabContainer.Size = UDim2.new(1, -20, 0, 35)

-- Pumpkin Tab Button
PumpkinTab.Parent = TabContainer
PumpkinTab.BackgroundColor3 = Color3.fromRGB(50, 220, 50)
PumpkinTab.Position = UDim2.new(0, 0, 0, 0)
PumpkinTab.Size = UDim2.new(0.48, 0, 1, 0)
PumpkinTab.Font = Enum.Font.GothamBold
PumpkinTab.Text = "🎃 Pumpkin Farm"
PumpkinTab.TextColor3 = Color3.fromRGB(255, 255, 255)
PumpkinTab.TextSize = 14
addCorner(PumpkinTab, 8)

-- Enemy Tab Button
EnemyTab.Parent = TabContainer
EnemyTab.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
EnemyTab.Position = UDim2.new(0.52, 0, 0, 0)
EnemyTab.Size = UDim2.new(0.48, 0, 1, 0)
EnemyTab.Font = Enum.Font.GothamBold
EnemyTab.Text = "⚔️ Enemy Farm"
EnemyTab.TextColor3 = Color3.fromRGB(255, 255, 255)
EnemyTab.TextSize = 14
addCorner(EnemyTab, 8)

-- PUMPKIN FRAME
PumpkinFrame.Parent = MainFrame
PumpkinFrame.BackgroundTransparency = 1
PumpkinFrame.Position = UDim2.new(0, 10, 0, 90)
PumpkinFrame.Size = UDim2.new(1, -20, 1, -100)
PumpkinFrame.Visible = true

PumpkinToggle.Parent = PumpkinFrame
PumpkinToggle.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
PumpkinToggle.Position = UDim2.new(0.5, -140, 0, 10)
PumpkinToggle.Size = UDim2.new(0, 280, 0, 35)
PumpkinToggle.Font = Enum.Font.GothamBold
PumpkinToggle.Text = "Start Farming"
PumpkinToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
PumpkinToggle.TextSize = 16
addCorner(PumpkinToggle, 8)

PumpkinAutoHop.Parent = PumpkinFrame
PumpkinAutoHop.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
PumpkinAutoHop.Position = UDim2.new(0.5, -140, 0, 55)
PumpkinAutoHop.Size = UDim2.new(0, 280, 0, 35)
PumpkinAutoHop.Font = Enum.Font.GothamBold
PumpkinAutoHop.Text = "Auto Hop: OFF"
PumpkinAutoHop.TextColor3 = Color3.fromRGB(255, 255, 255)
PumpkinAutoHop.TextSize = 14
addCorner(PumpkinAutoHop, 8)

PumpkinManualHop.Parent = PumpkinFrame
PumpkinManualHop.BackgroundColor3 = Color3.fromRGB(100, 100, 220)
PumpkinManualHop.Position = UDim2.new(0.5, -140, 0, 100)
PumpkinManualHop.Size = UDim2.new(0, 280, 0, 35)
PumpkinManualHop.Font = Enum.Font.GothamBold
PumpkinManualHop.Text = "Server Hop Now"
PumpkinManualHop.TextColor3 = Color3.fromRGB(255, 255, 255)
PumpkinManualHop.TextSize = 14
addCorner(PumpkinManualHop, 8)

PumpkinStatus.Parent = PumpkinFrame
PumpkinStatus.BackgroundTransparency = 1
PumpkinStatus.Position = UDim2.new(0, 0, 0, 145)
PumpkinStatus.Size = UDim2.new(1, 0, 0, 40)
PumpkinStatus.Font = Enum.Font.Gotham
PumpkinStatus.Text = "Status: Idle"
PumpkinStatus.TextColor3 = Color3.fromRGB(200, 200, 200)
PumpkinStatus.TextSize = 13

-- ENEMY FRAME
EnemyFrame.Parent = MainFrame
EnemyFrame.BackgroundTransparency = 1
EnemyFrame.Position = UDim2.new(0, 10, 0, 90)
EnemyFrame.Size = UDim2.new(1, -20, 1, -100)
EnemyFrame.Visible = false

-- Floor Join Button
FloorJoinButton.Parent = EnemyFrame
FloorJoinButton.BackgroundColor3 = Color3.fromRGB(220, 150, 50)
FloorJoinButton.Position = UDim2.new(0.5, -140, 0, 10)
FloorJoinButton.Size = UDim2.new(0, 280, 0, 40)
FloorJoinButton.Font = Enum.Font.GothamBold
FloorJoinButton.Text = "Join Floor 500"
FloorJoinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FloorJoinButton.TextSize = 16
addCorner(FloorJoinButton, 8)

-- Enemy Toggle Button
EnemyToggle.Parent = EnemyFrame
EnemyToggle.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
EnemyToggle.Position = UDim2.new(0.5, -140, 0, 60)
EnemyToggle.Size = UDim2.new(0, 280, 0, 40)
EnemyToggle.Font = Enum.Font.GothamBold
EnemyToggle.Text = "Start Enemy Farm"
EnemyToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
EnemyToggle.TextSize = 16
addCorner(EnemyToggle, 8)

-- Current Room Label
CurrentRoomLabel.Parent = EnemyFrame
CurrentRoomLabel.BackgroundTransparency = 1
CurrentRoomLabel.Position = UDim2.new(0, 0, 0, 110)
CurrentRoomLabel.Size = UDim2.new(1, 0, 0, 25)
CurrentRoomLabel.Font = Enum.Font.GothamBold
CurrentRoomLabel.Text = "Current Room: Unknown"
CurrentRoomLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
CurrentRoomLabel.TextSize = 14

EnemyStatus.Parent = EnemyFrame
EnemyStatus.BackgroundTransparency = 1
EnemyStatus.Position = UDim2.new(0, 0, 0, 140)
EnemyStatus.Size = UDim2.new(1, 0, 0, 40)
EnemyStatus.Font = Enum.Font.Gotham
EnemyStatus.Text = "Status: Ready to start"
EnemyStatus.TextColor3 = Color3.fromRGB(200, 200, 200)
EnemyStatus.TextSize = 14

-- Minimize/Restore Functions
local function minimizeGUI()
    MainFrame.Visible = false
    MinimizedFrame.Visible = true
    print("GUI minimized")
end

local function restoreGUI()
    MainFrame.Visible = true
    MinimizedFrame.Visible = false
    print("GUI restored")
end

MinimizeButton.MouseButton1Click:Connect(minimizeGUI)
RestoreButton.MouseButton1Click:Connect(restoreGUI)

-- Tab switching
local function switchTab(tab)
    if tab == "pumpkin" then
        PumpkinFrame.Visible = true
        EnemyFrame.Visible = false
        PumpkinTab.BackgroundColor3 = Color3.fromRGB(50, 220, 50)
        EnemyTab.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    else
        PumpkinFrame.Visible = false
        EnemyFrame.Visible = true
        PumpkinTab.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        EnemyTab.BackgroundColor3 = Color3.fromRGB(50, 220, 50)
    end
end

PumpkinTab.MouseButton1Click:Connect(function()
    switchTab("pumpkin")
end)

EnemyTab.MouseButton1Click:Connect(function()
    switchTab("enemy")
end)

-- PUMPKIN FARMING LOGIC
local pumpkinRunning = false
local autoHopEnabled = false

local function serverHop()
    PumpkinStatus.Text = "Status: Finding new server..."
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
            TeleportService:TeleportToPlaceInstance(placeId, randomServer, player)
        else
            TeleportService:Teleport(placeId, player)
        end
    end)
    
    if not success then
        warn("Server hop failed:", errorMessage)
        PumpkinStatus.Text = "Status: Server hop failed, retrying..."
        wait(2)
        TeleportService:Teleport(game.PlaceId, player)
    end
end

local function teleportAndCollectPumpkin()
    local extra = workspace:FindFirstChild("__Extra")
    if not extra then
        PumpkinStatus.Text = "Status: Waiting for __Extra..."
        return false
    end
    
    local pumps = extra:FindFirstChild("__Pumps")
    if not pumps then
        PumpkinStatus.Text = "Status: Waiting for __Pumps..."
        return false
    end
    
    for _, pumpkin in pairs(pumps:GetChildren()) do
        if pumpkin.Name == "Pumpkin" and pumpkin:IsA("Model") then
            local playersLeft = pumpkin:FindFirstChild("PlayersLeft")
            
            if playersLeft and playersLeft:IsA("IntValue") and playersLeft.Value > 0 then
                local targetPart = pumpkin:FindFirstChild("Origin") or pumpkin:FindFirstChild("Position") or pumpkin.PrimaryPart
                
                if targetPart then
                    PumpkinStatus.Text = "Status: Teleporting..."
                    humanoidRootPart.CFrame = targetPart.CFrame
                    print("Teleported to pumpkin with", playersLeft.Value, "players left")
                    
                    wait(1.5)
                    
                    PumpkinStatus.Text = "Status: Finding prompt..."
                    
                    local proximityPrompt = nil
                    local maxRetries = 5
                    
                    for i = 1, maxRetries do
                        proximityPrompt = pumpkin:FindFirstChildOfClass("ProximityPrompt", true)
                        
                        if proximityPrompt then
                            print("Found prompt on retry", i)
                            break
                        else
                            print("Retry", i, "- Prompt not found, waiting...")
                            wait(0.5)
                        end
                    end
                    
                    if not proximityPrompt then
                        print("Searching nearby area for prompt...")
                        local searchDistance = 15
                        
                        for _, descendant in pairs(workspace:GetDescendants()) do
                            if descendant:IsA("ProximityPrompt") and descendant.Enabled then
                                local promptPart = descendant.Parent
                                if promptPart and promptPart:IsA("BasePart") then
                                    local distance = (humanoidRootPart.Position - promptPart.Position).Magnitude
                                    
                                    if distance < searchDistance then
                                        proximityPrompt = descendant
                                        print("Found prompt nearby at distance:", distance)
                                        break
                                    end
                                end
                            end
                        end
                    end
                    
                    if proximityPrompt then
                        PumpkinStatus.Text = "Status: Collecting pumpkin..."
                        print("Activating prompt:", proximityPrompt:GetFullName())
                        
                        fireproximityprompt(proximityPrompt)
                        
                        wait(3)
                        
                        playersLeft:Destroy()
                        PumpkinStatus.Text = "Status: Pumpkin collected! ✓"
                        print("Pumpkin collected and marked")
                        
                        wait(2)
                        
                        return true
                    else
                        PumpkinStatus.Text = "Status: No prompt found after retries"
                        warn("No proximity prompt found in or near pumpkin after retries")
                        wait(2)
                    end
                end
            end
        end
    end
    
    PumpkinStatus.Text = "Status: No pumpkins available"
    return false
end

local function checkAllPumpkinsCollected()
    local extra = workspace:FindFirstChild("__Extra")
    if not extra then return false end
    
    local pumps = extra:FindFirstChild("__Pumps")
    if not pumps then return false end
    
    for _, pumpkin in pairs(pumps:GetChildren()) do
        if pumpkin.Name == "Pumpkin" and pumpkin:IsA("Model") then
            local playersLeft = pumpkin:FindFirstChild("PlayersLeft")
            if playersLeft and playersLeft:IsA("IntValue") and playersLeft.Value > 0 then
                return false
            end
        end
    end
    
    return true
end

local function startPumpkinFarming()
    pumpkinRunning = true
    PumpkinToggle.BackgroundColor3 = Color3.fromRGB(50, 220, 50)
    PumpkinToggle.Text = "Stop Farming"
    
    task.spawn(function()
        while pumpkinRunning do
            if checkAllPumpkinsCollected() then
                PumpkinStatus.Text = "Status: All pumpkins collected! ✓"
                print("All pumpkins have been collected!")
                
                if autoHopEnabled then
                    wait(2)
                    PumpkinStatus.Text = "Status: Auto hopping to new server..."
                    print("Auto hop enabled, switching servers...")
                    wait(1)
                    serverHop()
                    break
                else
                    wait(5)
                end
            else
                local success = teleportAndCollectPumpkin()
                if not success then
                    wait(3)
                end
            end
            
            character = player.Character or player.CharacterAdded:Wait()
            humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        end
    end)
end

local function stopPumpkinFarming()
    pumpkinRunning = false
    PumpkinToggle.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    PumpkinToggle.Text = "Start Farming"
    PumpkinStatus.Text = "Status: Idle"
end

PumpkinToggle.MouseButton1Click:Connect(function()
    if pumpkinRunning then
        stopPumpkinFarming()
    else
        startPumpkinFarming()
    end
end)

PumpkinAutoHop.MouseButton1Click:Connect(function()
    autoHopEnabled = not autoHopEnabled
    
    if autoHopEnabled then
        PumpkinAutoHop.BackgroundColor3 = Color3.fromRGB(50, 220, 50)
        PumpkinAutoHop.Text = "Auto Hop: ON"
    else
        PumpkinAutoHop.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
        PumpkinAutoHop.Text = "Auto Hop: OFF"
    end
end)

PumpkinManualHop.MouseButton1Click:Connect(function()
    serverHop()
end)

-- ENEMY FARMING LOGIC WITH TICKET BUYING AND CASTLE RESTART

local enemyRunning = false
local teamSwitchRunning = false

-- Check if player is in castle (Room_1 exists)
local function isPlayerInCastle()
    local main = workspace:FindFirstChild("__Main")
    if not main then return false end
    
    local world = main:FindFirstChild("__World")
    if not world then return false end
    
    local room1 = world:FindFirstChild("Room_1")
    return room1 ~= nil
end

-- Check if castle is available (xx:15 to xx:25 and xx:45 to xx:56)
local function isCastleAvailable()
    local currentTime = os.date("*t")
    local minute = currentTime.min
    
    if (minute >= 15 and minute <= 25) or (minute >= 45 and minute <= 56) then
        return true
    end
    return false
end

-- Wait until castle is available
local function waitForCastleAvailability()
    while not isCastleAvailable() do
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
        
        EnemyStatus.Text = "Status: Waiting for castle (" .. math.ceil(secondsToWait / 60) .. " min)"
        print("Waiting for castle availability:", secondsToWait, "seconds")
        wait(30)
        
        if not enemyRunning then return false end
    end
    
    return true
end

-- Buy castle ticket with gems
local function buyCastleTicket()
    print("Buying castle ticket with gems...")
    EnemyStatus.Text = "Status: Buying castle ticket..."
    
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
    ReplicatedStorage:WaitForChild("BridgeNet2"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))
    
    wait(1)
    print("Ticket purchase request sent")
end

-- Join floor 500
local function joinFloor()
    print("Joining floor 500...")
    EnemyStatus.Text = "Status: Joining floor 500..."
    
    -- First buy ticket
    buyCastleTicket()
    wait(1)
    
    -- Then join floor
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
    ReplicatedStorage:WaitForChild("BridgeNet2"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))
    
    wait(2)
    FloorJoinButton.BackgroundColor3 = Color3.fromRGB(50, 220, 50)
    FloorJoinButton.Text = "Floor 500 Joined ✓"
    EnemyStatus.Text = "Status: Ready to farm!"
    print("Floor join complete!")
end

-- Switch team
local function switchTeam(teamId)
    print("Switching to team:", teamId)
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
    ReplicatedStorage:WaitForChild("BridgeNet2"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))
end

-- Set speed
local function setSpeed(speed)
    print("Setting speed to:", speed)
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
    ReplicatedStorage:WaitForChild("BridgeNet2"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))
end

-- Get player's current room by checking which Room has PlayersSpawns
local function getPlayerCurrentRoom()
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

-- Check if current room has a FirePortal
local function doesCurrentRoomHaveFirePortal()
    local currentRoomNum, currentRoomModel = getPlayerCurrentRoom()
    if not currentRoomModel then return false end
    
    local firePortal = currentRoomModel:FindFirstChild("FirePortal")
    return firePortal ~= nil
end

-- Teleport to FirePortal and activate it
local function teleportToFirePortalAndActivate()
    local currentRoomNum, currentRoomModel = getPlayerCurrentRoom()
    if not currentRoomModel then
        EnemyStatus.Text = "Status: Can't find current room"
        return false
    end
    
    local firePortal = currentRoomModel:FindFirstChild("FirePortal")
    if not firePortal or not firePortal:IsA("BasePart") then
        EnemyStatus.Text = "Status: No FirePortal in current room"
        return false
    end
    
    humanoidRootPart.CFrame = firePortal.CFrame
    print("Teleported to FirePortal in Room_" .. currentRoomNum)
    EnemyStatus.Text = "Status: At FirePortal, activating..."
    
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
        print("Activating FirePortal prompt")
        fireproximityprompt(proximityPrompt)
        wait(2)
        EnemyStatus.Text = "Status: FirePortal activated!"
        return true
    else
        EnemyStatus.Text = "Status: FirePortal prompt not found"
        return false
    end
end

-- Team switching loop
local function startTeamSwitching()
    teamSwitchRunning = true
    task.spawn(function()
        while teamSwitchRunning do
            wait(15)
            
            if not enemyRunning then break end
            
            switchTeam("74bd")
            print("Switched to team 74bd")
            
            wait(2)
            
            if not enemyRunning then break end
            
            switchTeam("e654")
            print("Switched to team e654")
        end
    end)
end

local function teleportToNextEnemy()
    local main = workspace:FindFirstChild("__Main")
    if not main then
        EnemyStatus.Text = "Status: Waiting for __Main..."
        return false
    end
    
    local enemies = main:FindFirstChild("__Enemies")
    if not enemies then
        EnemyStatus.Text = "Status: Waiting for __Enemies..."
        return false
    end
    
    local server = enemies:FindFirstChild("Server")
    if not server then
        EnemyStatus.Text = "Status: Waiting for Server..."
        return false
    end
    
    for _, child in pairs(server:GetDescendants()) do
        if child:IsA("BasePart") then
            local HP = child:GetAttribute("HP")
            
            if HP and HP > 0 then
                EnemyStatus.Text = "Status: Teleporting to enemy..."
                humanoidRootPart.CFrame = child.CFrame * CFrame.new(10, 5, 0)
                print("Teleported near enemy with HP:", HP)
                wait(0.5)
                EnemyStatus.Text = "Status: Fighting (HP: " .. tostring(HP) .. ")"
                return true
            end
        end
    end
    
    EnemyStatus.Text = "Status: No alive enemies"
    return false
end

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

-- Update room label continuously
task.spawn(function()
    while true do
        local currentRoom = getPlayerCurrentRoom()
        if currentRoom then
            CurrentRoomLabel.Text = "Current Room: " .. currentRoom
        else
            CurrentRoomLabel.Text = "Current Room: Unknown"
        end
        wait(1)
    end
end)

local function startEnemyFarming()
    enemyRunning = true
    EnemyToggle.BackgroundColor3 = Color3.fromRGB(50, 220, 50)
    EnemyToggle.Text = "Stop Enemy Farm"
    
    startTeamSwitching()
    
    task.spawn(function()
        while enemyRunning do
            local currentRoom = getPlayerCurrentRoom()
            if currentRoom then
                CurrentRoomLabel.Text = "Current Room: " .. currentRoom
                
                -- Set speed based on current room
                if currentRoom == 517 then
                    setSpeed(4)
                else if currentRoom == 1 then
                    setSpeed(1)
                end
            end
            
            -- Check if floor 500 reached with all enemies dead
            if currentRoom and currentRoom >= 1000 and checkAllEnemiesDead() then
                EnemyStatus.Text = "Status: Floor 500 reached! Restarting..."
                print("Floor 500 completed, waiting for castle availability...")
                
                local castleReady = waitForCastleAvailability()
                
                if castleReady and enemyRunning then
                    EnemyStatus.Text = "Status: Castle available! Rejoining floor 500..."
                    print("Castle is now available, rejoining floor 500")
                    joinFloor()
                    wait(3)
                    EnemyStatus.Text = "Status: Restarted from floor 500"
                else
                    break
                end
            elseif checkAllEnemiesDead() then
                EnemyStatus.Text = "Status: All enemies defeated!"
                print("All enemies defeated!")
                
                if currentRoom and currentRoom >= 1000 then
                    print("Floor 500 reached, no FirePortal expected")
                    EnemyStatus.Text = "Status: Floor 500 - Complete!"
                    wait(5)
                else
                    if doesCurrentRoomHaveFirePortal() then
                        print("FirePortal detected, room finished!")
                        EnemyStatus.Text = "Status: Going to FirePortal..."
                        wait(1)
                        teleportToFirePortalAndActivate()
                        wait(3)
                    else
                        print("No FirePortal yet, waiting...")
                        EnemyStatus.Text = "Status: Waiting for FirePortal..."
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
            
            character = player.Character or player.CharacterAdded:Wait()
            humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        end
    end)
end

local function stopEnemyFarming()
    enemyRunning = false
    teamSwitchRunning = false
    EnemyToggle.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    EnemyToggle.Text = "Start Enemy Farm"
    EnemyStatus.Text = "Status: Idle"
end

FloorJoinButton.MouseButton1Click:Connect(function()
    joinFloor()
end)

EnemyToggle.MouseButton1Click:Connect(function()
    if enemyRunning then
        stopEnemyFarming()
    else
        startEnemyFarming()
    end
end)

print("Multi Auto Farm GUI loaded!")
print("Anti-AFK enabled")
print("Click buttons to start farming manually")
print("Use minimize button (−) to hide GUI")
