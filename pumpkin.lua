local PumpkinFarm = {}

local running = false
local autoHopEnabled = false
local GUI, Utils

function PumpkinFarm.init(guiModule, utilsModule)
    GUI = guiModule
    Utils = utilsModule
    
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

local function teleportAndCollectPumpkin()
    local extra = workspace:FindFirstChild("__Extra")
    if not extra then
        GUI.PumpkinStatus.Text = "Status: Waiting for __Extra..."
        return false
    end
    
    local pumps = extra:FindFirstChild("__Pumps")
    if not pumps then
        GUI.PumpkinStatus.Text = "Status: Waiting for __Pumps..."
        return false
    end
    
    for _, pumpkin in pairs(pumps:GetChildren()) do
        if pumpkin.Name == "Pumpkin" and pumpkin:IsA("Model") then
            local playersLeft = pumpkin:FindFirstChild("PlayersLeft")
            
            if playersLeft and playersLeft:IsA("IntValue") and playersLeft.Value > 0 then
                local targetPart = pumpkin:FindFirstChild("Origin") or pumpkin:FindFirstChild("Position") or pumpkin.PrimaryPart
                
                if targetPart then
                    GUI.PumpkinStatus.Text = "Status: Teleporting..."
                    Utils.humanoidRootPart.CFrame = targetPart.CFrame
                    print("Teleported to pumpkin with", playersLeft.Value, "players left")
                    
                    wait(1.5)
                    
                    GUI.PumpkinStatus.Text = "Status: Finding prompt..."
                    
                    local proximityPrompt = nil
                    local maxRetries = 5
                    
                    for i = 1, maxRetries do
                        proximityPrompt = pumpkin:FindFirstChildOfClass("ProximityPrompt", true)
                        
                        if proximityPrompt then
                            print("Found prompt on retry", i)
                            break
                        else
                            wait(0.5)
                        end
                    end
                    
                    if not proximityPrompt then
                        local searchDistance = 15
                        
                        for _, descendant in pairs(workspace:GetDescendants()) do
                            if descendant:IsA("ProximityPrompt") and descendant.Enabled then
                                local promptPart = descendant.Parent
                                if promptPart and promptPart:IsA("BasePart") then
                                    local distance = (Utils.humanoidRootPart.Position - promptPart.Position).Magnitude
                                    
                                    if distance < searchDistance then
                                        proximityPrompt = descendant
                                        break
                                    end
                                end
                            end
                        end
                    end
                    
                    if proximityPrompt then
                        GUI.PumpkinStatus.Text = "Status: Collecting pumpkin..."
                        fireproximityprompt(proximityPrompt)
                        wait(3)
                        playersLeft:Destroy()
                        GUI.PumpkinStatus.Text = "Status: Pumpkin collected! ✓"
                        wait(2)
                        return true
                    else
                        GUI.PumpkinStatus.Text = "Status: No prompt found"
                        wait(2)
                    end
                end
            end
        end
    end
    
    GUI.PumpkinStatus.Text = "Status: No pumpkins available"
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

function PumpkinFarm.start()
    running = true
    GUI.PumpkinToggle.BackgroundColor3 = Color3.fromRGB(50, 220, 50)
    GUI.PumpkinToggle.Text = "Stop Farming"
    
    task.spawn(function()
        while running do
            if checkAllPumpkinsCollected() then
                GUI.PumpkinStatus.Text = "Status: All pumpkins collected! ✓"
                
                if autoHopEnabled then
                    wait(2)
                    GUI.PumpkinStatus.Text = "Status: Auto hopping..."
                    wait(1)
                    Utils.serverHop()
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
            
            Utils.refreshCharacter()
        end
    end)
end

function PumpkinFarm.stop()
    running = false
    GUI.PumpkinToggle.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    GUI.PumpkinToggle.Text = "Start Farming"
    GUI.PumpkinStatus.Text = "Status: Idle"
end

return PumpkinFarm
