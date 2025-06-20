local blankfunction = function(...) return ... end
local cloneref = cloneref or blankfunction

_G.services      = {}
_G.Connections   = {}
_G.loadedModules = {}
_G.exitConnections = {}
_G.getService=function(s) if not _G.services[s] then _G.services[s]=cloneref(game:GetService(s)) end return _G.services[s] end
_G.isShowNotification = true
_G.notify=function(m,d,i) if not _G.isShowNotification then return true end task.spawn(function() while not _G.WindUI do task.wait(0.1) end local s=pcall(function() if _G.WindUI and typeof(_G.WindUI.Notify)=="function" then _G.WindUI:Notify({Title=_G.gameData.Name.." Hub",Content=m,Duration=d or 3,Icon=i or "info"}) else error("WindUI unavailable") end end) if not s then warn("Custom notification failed. Trying Roblox notification:",m) local f=pcall(function() _G.getService("StarterGui"):SetCore("SendNotification",{Title=_G.gameData.Name.." Hub",Text=m,Duration=d or 3,Icon=i or nil}) end) if not f then warn("Roblox notification also failed. Printing instead:") print("[NOTIFY]",m) end end end)
_G.extractDigitsFromText=function(t) return tonumber(t:match("%d+")) or 0 end
_G.getPlayerMoney=function() return _G.getService("Players").LocalPlayer.leaderstats.Sheckles.Value end
_G.Farms = workspace:FindFirstChild("Farm")
_G.tweenService        = _G.getService("TweenService")
_G.runService          = _G.getService("RunService")
_G.players             = _G.getService("Players")
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

_G.addConnection = function(n,c) if not n or not c then return end if _G.Connections[n] then pcall(function() _G.Connections[n]:Disconnect() end) end _G.Connections[n]=c end
_G.cleanupConnections = function(n) if n then if _G.Connections[n] then pcall(function() _G.Connections[n]:Disconnect() end) _G.Connections[n]=nil end else for k,v in pairs(_G.Connections) do if v then pcall(function() v:Disconnect() end) end end _G.Connections={} end end
_G.safeGet=function(i,...) for _,n in ipairs({...}) do i=i:WaitForChild(n,10) if not i then return nil end end return i end
_G.waitFor=function(n,p) return p:WaitForChild(n,60) end
_G.getModule=function(p,n) if not _G.loadedModules[n] then local m=p:FindFirstChild(n) if not m or not m:IsA("ModuleScript") then warn("❌ Module not found or invalid -> Trash exec",n) return nil end local s,r=pcall(require,m) if s then _G.loadedModules[n]=r else warn("❌ Failed to load module -> Trash exec",n,r) return nil end end return _G.loadedModules[n] end
_G.GetTool=function(c) return c and c:FindFirstChildOfClass("Tool") end


task.defer(function() local function touch(e) if not e then return end local h=_G.getHumanoidRootPart() if not h then return end if not pcall(function() firetouchinterest(h,e,0) task.wait() firetouchinterest(h,e,1) end) then warn("Touch function failed - firetouchinterest may not be available") end end local p=_G.players.LocalPlayer workspace.ChildAdded:Connect(function(c) if not c:IsA("Model") then return end task.wait(1) if c:GetAttribute("SEED_GIVEN") and c:GetAttribute("OWNER")==p.Name then task.wait(2) local part=c:FindFirstChildOfClass("Part") if not part then return end touch(part) end end) end)
_G.unequip_tool = function() for _,c in ipairs(character:GetChildren()) do if c:IsA("Tool") then c.Parent=_G.localPlayerBag end end end
_G.GetCrops = function() local c,H={},_G.GetTool(character) if not _G.localPlayerBag or #_G.localPlayerBag:GetChildren()==0 then return c end for _,t in ipairs(_G.localPlayerBag:GetChildren()) do if t:GetAttribute("b")=="j" then table.insert(c,t) end end if H and H:GetAttribute("b")=="j" and not table.find(c,H) then table.insert(c,H) end return c end
_G.getExitButton=function(g,p) local c=g for _,s in ipairs(p) do task.wait() c=c:WaitForChild(s,10) if not c then return nil end end return c end


_G.shops = { 
    Seed = { gui = _G.playerGui:FindFirstChild("Seed_Shop") },
    BeeEvent = { gui = _G.playerGui:FindFirstChild("HoneyEventShop_UI") },
    Cosmetic = { gui = _G.playerGui:FindFirstChild("CosmeticShop_UI"), exitPath = { "Main", "Holder", "Header", "ExitButton" } },
    Gear = { gui = _G.playerGui:FindFirstChild("Gear_Shop") },
    Daily = { gui = _G.playerGui:FindFirstChild("DailyQuests_UI") },
    Event = { gui = _G.playerGui:FindFirstChild("EventShop_UI") }
}

_G.defaultExitPath = { "Frame", "Frame", "ExitButton" }

_G.toggleShop = function(name)
print(name)
    local shopData = _G.shops[name]
    local shop = shopData and shopData.gui

print(shopData.gui)


    if not shop then
        _G.notify("Event Shop Ended - " .. name, 3, "check")
        warn("[toggleShop] GUI does not exist for shop:", name)
        return
    end

    -- Close all other shops
    for otherName, otherData in pairs(_G.shops) do
        if otherName ~= name and otherData.gui and otherData.gui.Enabled then
            otherData.gui.Enabled = false
            _G.notify(otherName .. " closed", 2, "check")
            task.wait(0.05)
        end
    end

    -- Toggle current shop
    if shop.Enabled then
        shop.Enabled = false
        _G.notify(name .. " closed", 3, "check")
        return
    end

    shop.Enabled = true
    _G.notify(name .. " opened", 3, "check")

    if _G.exitConnections[name] then
        pcall(function() _G.exitConnections[name]:Disconnect() end)
    end

    -- Hook up the exit button
    local exitButton = _G.getExitButton(shop, shopData.exitPath or _G.defaultExitPath)
    if exitButton then
        _G.exitConnections[name] = exitButton.Activated:Connect(function()
            shop.Enabled = false
            _G.notify(name .. " closed", 3, "check")
        end)
    else
        warn("[toggleShop] No exit button found for shop:", name)
    end
end
