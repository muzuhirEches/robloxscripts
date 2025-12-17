-- Anti-AFK
local VirtualUser = game:GetService("VirtualUser")
local player = game:GetService("Players").LocalPlayer

player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
    print("Anti-AFK triggered")
end)

-- Load modules
local baseURL = "https://raw.githubusercontent.com/muzuhirEches/robloxscripts/main/"

print("Loading config...")
local Config = loadstring(game:HttpGet(baseURL .. "config.lua"))()

print("Loading GUI...")
local GUI = loadstring(game:HttpGet(baseURL .. "gui.lua"))()

print("Loading utilities...")
local Utils = loadstring(game:HttpGet(baseURL .. "utils.lua"))()

print("Loading pumpkin farm...")
local PumpkinFarm = loadstring(game:HttpGet(baseURL .. "pumpkin.lua"))()

print("Loading enemy farm...")
local EnemyFarm = loadstring(game:HttpGet(baseURL .. "enemy.lua"))()

-- Initialize
GUI.init()
PumpkinFarm.init(GUI, Utils, Config)
EnemyFarm.init(GUI, Utils, Config)

-- Restore previous state if applicable
local savedConfig = Config.load()

-- Check if we're in castle and should auto-resume
if Utils.isPlayerInCastle() then
    print("Player is in castle")
    
    -- Auto-resume enemy farm if it was enabled before
    if savedConfig.enemyFarmEnabled then
        print("Auto-resuming enemy farm...")
        wait(2) -- Wait for everything to load
        EnemyFarm.start(true) -- true = skip join floor
    end
end

-- Auto-resume pumpkin farm if it was enabled
if savedConfig.pumpkinFarmEnabled then
    print("Auto-resuming pumpkin farm...")
    wait(2)
    PumpkinFarm.start()
end

print("Multi Auto Farm loaded successfully!")
print("Anti-AFK enabled")
