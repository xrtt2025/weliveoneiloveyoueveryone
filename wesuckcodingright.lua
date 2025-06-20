local blankfunction = function(...) return ... end
local cloneref = cloneref or blankfunction
local services = {}
_G.loadedModules = {}
_G.getService = function(s) services[s] = services[s] or cloneref(game:GetService(s)) return services[s] end
_G.extractDigitsFromText = function(text) return tonumber(text:match("%d+")) or 0 end
_G.getPlayerMoney = function() local player = _G.getService("Players").LocalPlayer return (player and player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Sheckles") and player.leaderstats.Sheckles.Value) or 0 end
_G.tweenService        = _G.getService("TweenService")
_G.runService          = _G.getService("RunService")
players                = _G.getService("Players")
_G.userInputService    = _G.getService("UserInputService")
_G.guiService          = _G.getService("GuiService")
_G.replicatedStorage   = _G.getService("ReplicatedStorage")
_G.virtualInputManager = _G.getService("VirtualInputManager")
_G.coreGui             = _G.getService("CoreGui")
_G.lighting            = _G.getService("Lighting")
_G.terrain             = workspace and workspace.Terrain
_G.httpService         = _G.getService("HttpService")
_G.teleportService     = _G.getService("TeleportService")
_G.marketplaceService  = _G.getService("MarketplaceService")
_G.collectionService   = _G.getService("CollectionService")
_G.localPlayer            = players.LocalPlayer
_G.playerGui           = _G.localPlayer:WaitForChild("PlayerGui", 10)
_G.camera              = workspace.CurrentCamera
_G.localPlayerBag      = _G.localPlayer.Backpack
_G.ByteNetReliable     = _G.replicatedStorage:WaitForChild("ByteNetReliable", 10)
_G.harvestBuffer       = buffer.fromstring("\1\1\0\1")
_G.Farms               = workspace:FindFirstChild("Farm")

if not _G.runService or not _G.players or not _G.lighting then warn("⚠️ Critical services failed to load") return end
_G.getCharacter = function() return _G.localPlayer and (_G.localPlayer.Character or _G.localPlayer.CharacterAdded:Wait()) end
_G.getCurrentCharacter = function() return _G.localPlayer and _G.localPlayer.Character end
_G.getHumanoidRootPart = function() local char = _G.getCurrentCharacter() return char and char:FindFirstChild("HumanoidRootPart") end
_G.getHumanoid = function() local char = _G.getCurrentCharacter() return char and char:FindFirstChild("Humanoid") end
_G.isShowNotification = true
_G.notify = function(m, d, i) if not _G.isShowNotification then return true end task.spawn(function() while not _G.WindUI do task.wait(0.1) end local s = pcall(function() if _G.WindUI and typeof(_G.WindUI.Notify) == "function" then _G.WindUI:Notify({ Title = _G.gameData.Name .. " Hub", Content = m, Duration = d or 3, Icon = i or "info" }) else error("WindUI unavailable") end end) if not s then warn("Custom notification failed. Trying Roblox notification:", m) local f = pcall(function() _G.getService("StarterGui"):SetCore("SendNotification", { Title = _G.gameData.Name .. " Hub", Text = m, Duration = d or 3, Icon = i or nil }) end) if not f then warn("Roblox notification also failed. Printing instead:") print("[NOTIFY]", m) end end end) end
_G.unequip_tool = function() for _, c in ipairs(_G.getCharacter():GetChildren()) do if c:IsA("Tool") then c.Parent = _G.localPlayerBag end end end

_G.GetTool = function(character) return character and character:FindFirstChildOfClass("Tool") end
_G.GetCrops = function() local Crops = {} local HoldingCrop = nil if not _G.localPlayerBag or #_G.localPlayerBag:GetChildren() == 0 then return Crops end HoldingCrop = _G.GetTool(character) for _, Tool in ipairs(_G.localPlayerBag:GetChildren()) do if Tool:GetAttribute("b") == "j" then table.insert(Crops, Tool) end end
    if HoldingCrop and HoldingCrop:GetAttribute("b") == "j" and not table.find(Crops, HoldingCrop) then 
        table.insert(Crops, HoldingCrop)
    end
    return Crops
end

_G.getPlayerData = function() local data = _G.dataService:GetData() return data, data and data.Sheckles, data and data.SpecialCurrency and data.SpecialCurrency.Honey end
_G.getStock = function(name) local data  = _G.dataService:GetData() return data and data[name] and data[name].Stocks or {} end
_G.getStockchild = function(parent, child) local data = _G.dataService:GetData() return data and data[parent] and data[parent][child] or {} end
_G.waitFor       = function(childName, parent) return parent:WaitForChild(childName, 60) end
_G.getModule = function(p, n) if not _G.loadedModules[n] then local m=p:FindFirstChild(n) if not m or not m:IsA("ModuleScript") then warn("❌ Module not found or invalid -> Trash exec", n) return end local s,r=pcall(require,m) if s then _G.loadedModules[n]=r else warn("❌ Failed to load module -> Trash exec", n, r) return end end return _G.loadedModules[n] end

_G.addConnection = function(n,c) if not n or not c then return end if Connections[n] then pcall(function() Connections[n]:Disconnect() end) end Connections[n]=c end
_G.cleanupConnections = function(n) if n then if Connections[n] then pcall(function() Connections[n]:Disconnect() end) Connections[n]=nil end else for k,v in pairs(Connections) do if v then pcall(function() v:Disconnect() end) end end Connections={} end end
_G.safeGet = function(i,...) for _,n in ipairs({...}) do if not i or not i:WaitForChild(n, 10) then return nil end i=i:WaitForChild(n, 10) end return i end
_G.touch = function(e) if e then local h=_G.getHumanoidRootPart() if h then local s=pcall(function() firetouchinterest(h,e,0) task.wait() firetouchinterest(h,e,1) end) if not s then warn("Touch function failed - firetouchinterest may not be available") end end end end
task.defer(function() workspace.ChildAdded:Connect(function(c) if c:IsA("Model") then task.wait(1) if c:GetAttribute("SEED_GIVEN") and c:GetAttribute("OWNER")==_G.localPlayer.Name then task.wait(2) local p=c:FindFirstChildOfClass("Part") if p then _G.touch(p) end end end end) end)


--// AD here for event checking..
_G.getExitButton = function(g, p) local c=g for _,s in ipairs(p) do task.wait() c=c:WaitForChild(s,10) if not c then return nil end end return c end
_G.toggleShop    = function(n) local d,s=shops[n],shops[n] and shops[n].gui if not s then _G.notify("Event Shop Ended - "..n,3,"check") warn("[toggleShop] GUI does not exist for shop:",n) return end for on,od in pairs(shops) do if on~=n and od.gui and od.gui.Enabled then od.gui.Enabled=false _G.notify(on.." closed",2,"check") task.wait(0.05) end end if s.Enabled then s.Enabled=false _G.notify(n.." closed",3,"check") return end s.Enabled=true _G.notify(n.." opened",3,"check") if _G.exitConnections[n] then pcall(function() _G.exitConnections[n]:Disconnect() end) end local b=_G.getExitButton(s,d.exitPath or _G.defaultExitPath) if b then _G.exitConnections[n]=b.Activated:Connect(function() s.Enabled=false _G.notify(n.." closed",3,"check") end) else warn("[toggleShop] No exit button found for shop:",n) end end

--[[
_G
_G
_G
_G
_G
_G
_G
_G
_G
_G
_G
_G
_G
_G
_G
_G
_G
_G
_G
_G
_G
_G
_G
_G
_G
_G
_G
_G
_G
_G
_G
_G
_G
_G
_G
_G
_G
_G]]
