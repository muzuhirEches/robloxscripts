local GUI = {}

local player = game:GetService("Players").LocalPlayer

local function addCorner(obj, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = obj
    return corner
end

function GUI.init()
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

    ScreenGui.Parent = player:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Name = "MultiAutoFarmGUI"

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

    FloorJoinButton.Parent = EnemyFrame
    FloorJoinButton.BackgroundColor3 = Color3.fromRGB(220, 150, 50)
    FloorJoinButton.Position = UDim2.new(0.5, -140, 0, 10)
    FloorJoinButton.Size = UDim2.new(0, 280, 0, 40)
    FloorJoinButton.Font = Enum.Font.GothamBold
    FloorJoinButton.Text = "Join Floor 500"
    FloorJoinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    FloorJoinButton.TextSize = 16
    addCorner(FloorJoinButton, 8)

    EnemyToggle.Parent = EnemyFrame
    EnemyToggle.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    EnemyToggle.Position = UDim2.new(0.5, -140, 0, 60)
    EnemyToggle.Size = UDim2.new(0, 280, 0, 40)
    EnemyToggle.Font = Enum.Font.GothamBold
    EnemyToggle.Text = "Start Enemy Farm"
    EnemyToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    EnemyToggle.TextSize = 16
    addCorner(EnemyToggle, 8)

    CurrentRoomLabel.Parent = EnemyFrame
    CurrentRoomLabel.BackgroundTransparency = 1
    CurrentRoomLabel.Position = UDim2.new(0, 0, 0, 110)
    CurrentRoomLabel.Size = UDim2.new(1, 0, 0, 25)
    CurrentRoomLabel.Font = Enum.Font.GothamBold
    CurrentRoomLabel.Text = "Current Room: Unknown"
    CurrentRoomLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
    CurrentRoomLabel.TextSize = 14

    local CastleStatusLabel = Instance.new("TextLabel")
    CastleStatusLabel.Parent = EnemyFrame
    CastleStatusLabel.BackgroundTransparency = 1
    CastleStatusLabel.Position = UDim2.new(0, 0, 0, 135)
    CastleStatusLabel.Size = UDim2.new(1, 0, 0, 20)
    CastleStatusLabel.Font = Enum.Font.GothamBold
    CastleStatusLabel.Text = "Castle: Checking..."
    CastleStatusLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
    CastleStatusLabel.TextSize = 12
    
    EnemyStatus.Parent = EnemyFrame
    EnemyStatus.BackgroundTransparency = 1
    EnemyStatus.Position = UDim2.new(0, 0, 0, 140)
    EnemyStatus.Size = UDim2.new(1, 0, 0, 40)
    EnemyStatus.Font = Enum.Font.Gotham
    EnemyStatus.Text = "Status: Ready to start"
    EnemyStatus.TextColor3 = Color3.fromRGB(200, 200, 200)
    EnemyStatus.TextSize = 14

    -- Minimize/Restore
    MinimizeButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        MinimizedFrame.Visible = true
    end)

    RestoreButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = true
        MinimizedFrame.Visible = false
    end)

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

    -- Store references
    GUI.PumpkinToggle = PumpkinToggle
    GUI.PumpkinStatus = PumpkinStatus
    GUI.PumpkinAutoHop = PumpkinAutoHop
    GUI.PumpkinManualHop = PumpkinManualHop
    GUI.FloorJoinButton = FloorJoinButton
    GUI.EnemyToggle = EnemyToggle
    GUI.EnemyStatus = EnemyStatus
    GUI.CurrentRoomLabel = CurrentRoomLabel
    GUI.CastleStatusLabel = CastleStatusLabel
end

return GUI
