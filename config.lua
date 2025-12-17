local Config = {}

local HttpService = game:GetService("HttpService")

-- Storage key for this game
local STORAGE_KEY = "MultiAutoFarm_Config_v1"

-- Default config
local defaultConfig = {
    enemyFarmEnabled = false,
    pumpkinFarmEnabled = false,
    autoHopEnabled = false,
    lastUpdated = 0
}

-- Save config to DataStore (uses game's built-in storage)
function Config.save(data)
    local success, err = pcall(function()
        local encoded = HttpService:JSONEncode(data)
        writefile(STORAGE_KEY .. ".json", encoded)
    end)
    
    if not success then
        warn("Failed to save config:", err)
    end
end

-- Load config from DataStore
function Config.load()
    local success, result = pcall(function()
        if isfile(STORAGE_KEY .. ".json") then
            local encoded = readfile(STORAGE_KEY .. ".json")
            return HttpService:JSONDecode(encoded)
        end
        return nil
    end)
    
    if success and result then
        print("Config loaded successfully")
        return result
    else
        print("No config found, using defaults")
        return defaultConfig
    end
end

-- Update specific config value
function Config.update(key, value)
    local current = Config.load()
    current[key] = value
    current.lastUpdated = os.time()
    Config.save(current)
end

-- Get specific config value
function Config.get(key)
    local current = Config.load()
    return current[key]
end

-- Clear all config
function Config.clear()
    local success, err = pcall(function()
        if isfile(STORAGE_KEY .. ".json") then
            delfile(STORAGE_KEY .. ".json")
        end
    end)
    
    if success then
        print("Config cleared")
    else
        warn("Failed to clear config:", err)
    end
end

return Config
