local PumpkinFarm = {}

local running = false
local autoHopEnabled = false
local GUI, Utils, Config

function PumpkinFarm.init(guiModule, utilsModule, configModule)
    GUI = guiModule
    Utils = utilsModule
    Config = configModule
    
    -- Restore auto hop state
    autoHopEnabled = Config.get("autoHopEnabled") or false
    if autoHopEnabled then
        GUI.PumpkinAutoHop.BackgroundColor3 = Color3.fromRGB(50, 220, 50)
        GUI.PumpkinAutoHop.Text = "Auto Hop: ON"
    end
    
    -- Button connections
    GUI.PumpkinToggle.MouseButton1Click:Connect(function()
        if running then
            PumpkinFarm.stop()
        else
            PumpkinFarm.start()
        end
    end)
    
    GUI.PumpkinAutoHop.MouseButton1Click:Connect(function()
        autoHopEnabled = not autoHopEnabled
        Config.update("autoHopEnabled", autoHopEnabled)
        
        if autoHopEnabled then
            GUI.PumpkinAutoHop.BackgroundColor3 = Color3.fromRGB(50, 220, 50)
            GUI.PumpkinAutoHop.Text = "Auto Hop: ON"
        else
            GUI.PumpkinAutoHop.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
            GUI.PumpkinAutoHop.Text = "Auto Hop: OFF"
        end
    end)
    
    GUI.PumpkinManualHop.MouseButton1Click:Connect(function()
        GUI.PumpkinStatus.Text = "Status: Finding new server..."
        Utils.serverHop()
    end)
end

-- ... (rest of pumpkin.lua code stays the same)

function PumpkinFarm.start()
    running = true
    Config.update("pumpkinFarmEnabled", true)  -- Save state
    GUI.PumpkinToggle.BackgroundColor3 = Color3.fromRGB(50, 220, 50)
    GUI.PumpkinToggle.Text = "Stop Farming"
    
    task.spawn(function()
        while running do
            -- ... (same logic)
        end
    end)
end

function PumpkinFarm.stop()
    running = false
    Config.update("pumpkinFarmEnabled", false)  -- Save state
    GUI.PumpkinToggle.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    GUI.PumpkinToggle.Text = "Start Farming"
    GUI.PumpkinStatus.Text = "Status: Idle"
end

return PumpkinFarm
