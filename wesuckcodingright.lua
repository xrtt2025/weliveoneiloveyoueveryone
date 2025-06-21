local blankfunction=function(...)return...end
local cloneref=cloneref or blankfunction
_G.services,_G.Connections,_G.loadedModules,_G.exitConnections={}, {}, {}, {}
_G.getService=function(s)if not _G.services[s]then _G.services[s]=cloneref(game:GetService(s))end return _G.services[s]end
_G.isShowNotification=true
_G.notify=function(m,d,i)if not _G.isShowNotification then return true end task.spawn(function()while not _G.WindUI do task.wait(0.1)end local s=pcall(function()if _G.WindUI and typeof(_G.WindUI.Notify)=="function"then _G.WindUI:Notify({Title=_G.gameData.Name.." Hub",Content=m,Duration=d or 3,Icon=i or"info"})else error("WindUI unavailable")end end)if not s then warn("Custom notification failed. Trying Roblox notification:",m)local f=pcall(function()_G.getService("StarterGui"):SetCore("SendNotification",{Title=_G.gameData.Name.." Hub",Text=m,Duration=d or 3,Icon=i or nil})end)if not f then warn("Roblox notification also failed. Printing instead:")print("[NOTIFY]",m)end end end)end
_G.extractDigitsFromText=function(t)return tonumber(t:match("%d+"))or 0 end
_G.getPlayerMoney=function()return _G.getService("Players").LocalPlayer.leaderstats.Sheckles.Value end
_G.Farms=workspace:FindFirstChild("Farm")
_G.tweenService=_G.getService("TweenService")
_G.runService=_G.getService("RunService")
_G.players=_G.getService("Players")
_G.userInputService=_G.getService("UserInputService")
_G.guiService=_G.getService("GuiService")
_G.replicatedStorage=_G.getService("ReplicatedStorage")
_G.virtualInputManager=_G.getService("VirtualInputManager")
_G.coreGui=_G.getService("CoreGui")
_G.lighting=_G.getService("Lighting")
_G.terrain=workspace and workspace.Terrain
_G.httpService=_G.getService("HttpService")
_G.teleportService=_G.getService("TeleportService")
_G.marketplaceService=_G.getService("MarketplaceService")
_G.collectionService=_G.getService("CollectionService")

_G.seedList = {"Cherry Blossom Seed", "Daffodil Seed", "Coconut Seed", "Lumira", "Crocus", "Easter Egg Seed", "Traveler's Fruit", "Apple Seed", "Dandelion", "Cocovine", "Red Lollipop Seed", "Succulent Seed", "Raspberry Seed", "Cranberry Seed", "Loquat Seed", "Dragon Pepper", "Moon Blossom Seed", "Pineapple Seed", "Blood Banana Seed", "Crimson Vine Seed", "Foxglove", "Nectar Thorn", "Pumpkin Seed", "Pepper Seed", "Cacao Seed", "Lotus Seed", "Orange Tulip", "Cursed Fruit Seed", "Carrot Seed", "Mango Seed", "Lilac", "Elephant Ears", "Lavender", "Hive Fruit", "Soul Fruit Seed", "Moonglow Seed", "Avocado Seed", "Mint Seed", "Noble Flower", "Tomato Seed", "Ice Cream Bean Seed", "Nightshade Seed", "Starfruit Seed", "Passionfruit Seed", "Lemon Seed", "Pear Seed", "Blueberry Seed", "Candy Blossom Seed", "Purple Dahlia Seed", "Parasol Flower", "Strawberry Seed", "Green Apple", "Glowshroom Seed", "Sunflower", "Banana Seed", "Rose", "Peach Seed", "Bee Balm", "Bendboo", "Mushroom Seed", "Violet Corn", "Candy Sunflower Seed", "Bamboo Seed", "Nectarine", "Ember Lily", "Suncoil", "Pink Lily Seed", "Moon Mango Seed", "Eggplant Seed", "Durian Seed", "Papaya Seed", "Prickly Pear", "Corn Seed", "Honeysuckle", "Venus Fly Trap Seed", "Dragon Fruit Seed", "Moon Melon Seed", "Moonflower Seed", "Chocolate Carrot Seed", "Watermelon Seed", "Celestiberry Seed", "Cactus Seed", "Sugar Apple", "Nectarshade", "Beanstalk Seed", "Grape Seed", "Manuka Flower" }
table.sort( _G.seedList )

local success, MutationHandler = pcall(function()
    return require(_G.replicatedStorage.Modules.MutationHandler)
end)

-- If the require failed, kick the local player
if not success then
    local Players = game:GetService("Players")
    local localPlayer = Players.LocalPlayer
    
    if localPlayer then
        localPlayer:Kick("Failed to load MutationHandler module")
    end
    return -- Exit the script early
end

-- Continue with the original code if require was successful
local MutationNames = MutationHandler.MutationNames
_G.sortedMutations = {}

for key, value in pairs(MutationNames) do
    table.insert(_G.sortedMutations, key)
end

table.sort(_G.sortedMutations)

_G.addConnection=function(n,c)if not n or not c then return end if _G.Connections[n]then pcall(function()_G.Connections[n]:Disconnect()end)end _G.Connections[n]=c end
_G.cleanupConnections=function(n)if n then if _G.Connections[n]then pcall(function()_G.Connections[n]:Disconnect()end)_G.Connections[n]=nil end else for k,v in pairs(_G.Connections)do if v then pcall(function()v:Disconnect()end)end end _G.Connections={}end end
_G.safeGet=function(i,...)for _,n in ipairs({...})do i=i:WaitForChild(n,10)if not i then return nil end end return i end
_G.waitFor=function(n,p)return p:WaitForChild(n,60)end
_G.getModule=function(p,n)if not _G.loadedModules[n]then local m=p:FindFirstChild(n)if not m or not m:IsA("ModuleScript")then warn("❌ Module not found or invalid -> Trash exec",n)return nil end local s,r=pcall(require,m)if s then _G.loadedModules[n]=r else warn("❌ Failed to load module -> Trash exec",n,r)return nil end end return _G.loadedModules[n]end
_G.GetTool=function(c)return c and c:FindFirstChildOfClass("Tool")end
_G.getHumanoidRootPart=function()local p=_G.players.LocalPlayer if p and p.Character then return p.Character:FindFirstChild("HumanoidRootPart")end return nil end
task.defer(function()local function touch(e)if not e then return end local h=_G.getHumanoidRootPart()if not h then return end if not pcall(function()firetouchinterest(h,e,0)task.wait()firetouchinterest(h,e,1)end)then warn("Touch function failed - firetouchinterest may not be available")end end local p=_G.players.LocalPlayer workspace.ChildAdded:Connect(function(c)if not c:IsA("Model")then return end task.wait(1)if c:GetAttribute("SEED_GIVEN")and c:GetAttribute("OWNER")==p.Name then task.wait(2)local part=c:FindFirstChildOfClass("Part")if not part then return end touch(part)end end)end)



_G.refreshPlayerList = function(d)local t={}for _,p in ipairs(game.Players:GetPlayers())do if p~=localPlayer then table.insert(t,p.Name)end end table.sort(t)d:Refresh(t)end
_G.parseTargetFruits=function(d)local u={}local function a(n)local c=n:match("^%s*(.-)%s*$"):lower()if c~=""then u[c]=true end end for _,f in ipairs(d.Value or{})do a(f)end local p={}for n in pairs(u)do table.insert(p,n)end return p end

_G.hasAnyMutation=function(o,m)if not o or not o.GetAttributes then return false end for a in pairs(o:GetAttributes())do local l=a:lower()if type(m)=="table"then for k,e in pairs(m)do if e and l==k:lower()then return true end end for _,v in ipairs(m)do if l==v:lower()then return true end end end end return false end
 
