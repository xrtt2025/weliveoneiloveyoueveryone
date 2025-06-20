-- Service Management
local blankfunction = function(...) return ... end
local cloneref = cloneref or blankfunction
local services = {}
_G.loadedModules = {}

-- Core service getter with error handling
_G.getService = function(serviceName)
    if not services[serviceName] then
        local success, service = pcall(function()
            return cloneref(game:GetService(serviceName))
        end)
        
        if success then
            services[serviceName] = service
        else
            warn("⚠️ Failed to get service:", serviceName)
            return nil
        end
    end
    return services[serviceName]
end

-- Utility Functions
_G.extractDigitsFromText = function(text)
    if type(text) ~= "string" then return 0 end
    return tonumber(text:match("%d+")) or 0
end

_G.getPlayerMoney = function()
    local player = _G.getService("Players").LocalPlayer
    if not player then return 0 end
    
    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then return 0 end
    
    local sheckles = leaderstats:FindFirstChild("Sheckles")
    return (sheckles and sheckles.Value) or 0
end

-- Service Initialization with error checking
local function initializeServices()
    local requiredServices = {
        "TweenService", "RunService", "Players", "UserInputService",
        "GuiService", "ReplicatedStorage", "VirtualInputManager",
        "CoreGui", "Lighting", "HttpService", "TeleportService",
        "MarketplaceService", "CollectionService"
    }
    
    for _, serviceName in ipairs(requiredServices) do
        local service = _G.getService(serviceName)
        if not service then
            warn("⚠️ Critical service failed to load:", serviceName)
            return false
        end
    end
    return true
end

-- Initialize services and check if successful
if not initializeServices() then
    warn("⚠️ Critical services failed to load")
    return
end

-- Service References
_G.tweenService = _G.getService("TweenService")
_G.runService = _G.getService("RunService")
_G.players = _G.getService("Players")
_G.userInputService = _G.getService("UserInputService")
_G.guiService = _G.getService("GuiService")
_G.replicatedStorage = _G.getService("ReplicatedStorage")
_G.virtualInputManager = _G.getService("VirtualInputManager")
_G.coreGui = _G.getService("CoreGui")
_G.lighting = _G.getService("Lighting")
_G.terrain = workspace and workspace.Terrain
_G.httpService = _G.getService("HttpService")
_G.teleportService = _G.getService("TeleportService")
_G.marketplaceService = _G.getService("MarketplaceService")
_G.collectionService = _G.getService("CollectionService")

-- Player References
local localPlayer = _G.players.LocalPlayer
if not localPlayer then
    warn("⚠️ LocalPlayer not found")
    return
end

_G.playerGui = localPlayer:WaitForChild("PlayerGui", 10)
_G.camera = workspace.CurrentCamera
_G.localPlayerBag = localPlayer.Backpack

-- Game-specific references with error handling
local success, byteNetReliable = pcall(function()
    return _G.replicatedStorage:WaitForChild("ByteNetReliable", 10)
end)

if success then
    _G.ByteNetReliable = byteNetReliable
else
    warn("⚠️ ByteNetReliable not found")
end

_G.harvestBuffer = buffer.fromstring("\1\1\0\1")
_G.Farms = workspace:FindFirstChild("Farm")

-- Character Functions
_G.getCharacter = function()
    if not localPlayer then return nil end
    return localPlayer.Character or localPlayer.CharacterAdded:Wait()
end

_G.getCurrentCharacter = function()
    return localPlayer and localPlayer.Character
end

_G.getHumanoidRootPart = function()
    local char = _G.getCurrentCharacter()
    return char and char:FindFirstChild("HumanoidRootPart")
end

_G.getHumanoid = function()
    local char = _G.getCurrentCharacter()
    return char and char:FindFirstChild("Humanoid")
end

-- Notification System
_G.isShowNotification = true

_G.notify = function(message, duration, icon)
    if not _G.isShowNotification then return true end
    
    task.spawn(function()
        -- Wait for WindUI if it exists
        local maxWait = 50 -- 5 seconds max wait
        local waitCount = 0
        while not _G.WindUI and waitCount < maxWait do
            task.wait(0.1)
            waitCount = waitCount + 1
        end
        
        local success = false
        
        -- Try WindUI notification first
        if _G.WindUI and typeof(_G.WindUI.Notify) == "function" then
            success = pcall(function()
                _G.WindUI:Notify({
                    Title = (_G.gameData and _G.gameData.Name or "Game") .. " Hub",
                    Content = message,
                    Duration = duration or 3,
                    Icon = icon or "info"
                })
            end)
        end
        
        -- Fallback to Roblox notification
        if not success then
            success = pcall(function()
                _G.getService("StarterGui"):SetCore("SendNotification", {
                    Title = (_G.gameData and _G.gameData.Name or "Game") .. " Hub",
                    Text = message,
                    Duration = duration or 3,
                    Icon = icon
                })
            end)
        end
        
        -- Final fallback to print
        if not success then
            print("[NOTIFY]", message)
        end
    end)
end

-- Tool Management
_G.unequip_tool = function()
    local character = _G.getCharacter()
    if not character then return end
    
    for _, child in ipairs(character:GetChildren()) do
        if child:IsA("Tool") then
            child.Parent = _G.localPlayerBag
        end
    end
end

_G.GetTool = function(character)
    return character and character:FindFirstChildOfClass("Tool")
end

_G.GetCrops = function()
    local crops = {}
    
    if not _G.localPlayerBag then return crops end
    
    local character = _G.getCurrentCharacter()
    local holdingCrop = _G.GetTool(character)
    
    -- Get crops from backpack
    for _, tool in ipairs(_G.localPlayerBag:GetChildren()) do
        if tool:GetAttribute("b") == "j" then
            table.insert(crops, tool)
        end
    end
    
    -- Add held crop if it's not already in the list
    if holdingCrop and holdingCrop:GetAttribute("b") == "j" then
        local found = false
        for _, crop in ipairs(crops) do
            if crop == holdingCrop then
                found = true
                break
            end
        end
        if not found then
            table.insert(crops, holdingCrop)
        end
    end
    
    return crops
end

-- Data Functions (assuming _G.dataService exists)
_G.getPlayerData = function()
    if not _G.dataService then return nil, 0, 0 end
    
    local data = _G.dataService:GetData()
    if not data then return nil, 0, 0 end
    
    local sheckles = data.Sheckles or 0
    local honey = data.SpecialCurrency and data.SpecialCurrency.Honey or 0
    
    return data, sheckles, honey
end

_G.getStock = function(name)
    if not _G.dataService or not name then return {} end
    
    local data = _G.dataService:GetData()
    return data and data[name] and data[name].Stocks or {}
end

_G.getStockchild = function(parent, child)
    if not _G.dataService or not parent or not child then return {} end
    
    local data = _G.dataService:GetData()
    return data and data[parent] and data[parent][child] or {}
end

-- Utility Functions
_G.waitFor = function(childName, parent)
    if not parent or not childName then return nil end
    return parent:WaitForChild(childName, 60)
end

_G.getModule = function(path, name)
    if not path or not name then
        warn("❌ Invalid parameters for getModule")
        return nil
    end
    
    if not _G.loadedModules[name] then
        local moduleScript = path:FindFirstChild(name)
        if not moduleScript or not moduleScript:IsA("ModuleScript") then
            warn("❌ Module not found or invalid:", name)
            return nil
        end

        local success, result = pcall(require, moduleScript)
        if success then
            _G.loadedModules[name] = result
        else
            warn("❌ Failed to load module:", name, result)
            return nil
        end
    end
    return _G.loadedModules[name]
end

print("✅ Script initialization completed successfully")
