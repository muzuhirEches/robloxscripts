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
PumpkinFarm.init(GUI, Utils)
EnemyFarm.init(GUI, Utils)

print("Multi Auto Farm loaded successfully!")
print("Anti-AFK enabled")
