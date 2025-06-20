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
_G.GetCrops = function() local c={},h=nil if not _G.localPlayerBag or #_G.localPlayerBag:GetChildren()==0 then return c end h=_G.GetTool(character) for _,t in ipairs(_G.localPlayerBag:GetChildren()) do if t:GetAttribute("b")=="j" then table.insert(c,t) end end if h and h:GetAttribute("b")=="j" and not table.find(c,h) then table.insert(c,h) end return c end

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
_G.GetPlayerFarm = function(P) if not P then return end for _,F in ipairs(_G.Farms:GetChildren()) do local I=F:WaitForChild("Important",60) if I then local D=I:WaitForChild("Data",60) if D then local O=D:WaitForChild("Owner",60) if O and O.Value==P then return F,I,I:WaitForChild("Plants_Physical",60),I:WaitForChild("Objects_Physical",60) end end end end end

_G.refreshFruitsList = function(d,p) Farm,ImportantFolder,Plants_Physical,Objects_Physical=_G.GetPlayerFarm(p) local l={} if not Plants_Physical then warn("Plants_Physical folder not found") return end for _,v in ipairs(Plants_Physical:GetChildren()) do if v:IsA("Model") then local n=v.Name if not table.find(l,n) then table.insert(l,n) end end end table.sort(l) d:Refresh(l) end
_G.refreshPlayerList = function(d) local l={} for _,p in ipairs(game.Players:GetPlayers()) do if p~=_G.localPlayer then table.insert(l,p.Name) end end table.sort(l) d:Refresh(l) end
_G.parseTargetFruits = function(d) local u={},f={} for _,v in ipairs(d.Value or {}) do local n=v:match("^%s*(.-)%s*$"):lower() if n~="" then u[n]=true end end for k in pairs(u) do table.insert(f,k) end return f end
_G.hasAnyMutation = function(o,m) if not o or not o.GetAttributes then return false end for a in pairs(o:GetAttributes()) do local l=string.lower(a) if type(m)=="table" then for k,v in pairs(m) do if (v==true and l==string.lower(k)) or (type(k)=="number" and l==string.lower(v)) then return true end end end end return false end

_G.collectSelectedFruit = function() local n=false while _G.autoFarmRunning do if _G.checkEventStatus() then if not n then _G.notify("Paused: A selected event is active. Waiting...",3,"triangle-alert") n=true end while _G.checkEventStatus() and _G.autoFarmRunning do task.wait(1) end if _G.autoFarmRunning then _G.notify("Resuming selected fruit collection - event ended",2,"check") n=false end end if not _G.autoFarmRunning then break end local c=true local t={} if c then t=_G.parseTargetFruits(_G.fruitDropdown) if #t==0 then _G.notify("No fruits selected",3,"check") c=false end end if not c then task.wait(2) else Farm,ImportantFolder,Plants_Physical,Objects_Physical=_G.GetPlayerFarm(localPlayer.Name) for _,p in ipairs(Plants_Physical:GetChildren()) do if not _G.autoFarmRunning or _G.checkEventStatus() then break end if table.find(t,p.Name:lower()) then local f=p:FindFirstChild("Fruits") if f then for _,x in ipairs(f:GetChildren()) do if not _G.autoFarmRunning or _G.checkEventStatus() then break end if not _G.hasAnyMutation(x,_G.ignoreMutation) and not x:GetAttribute("Favorited") then pcall(function() _G.ByteNetReliable:FireServer(_G.harvestBuffer,{x}) _G.notify("Collected "..x.Name,1,"check") end) task.wait() end end else if not _G.hasAnyMutation(p,_G.ignoreMutation) then pcall(function() _G.ByteNetReliable:FireServer(_G.harvestBuffer,{p}) _G.notify("Collected "..p.Name,1,"check") end) task.wait() end end end end task.wait(1) end end _G.collectFruitThread=nil end
_G.collectNoneMutated = function() local n=false while _G.runningCollectNoneMutated do if _G.checkEventStatus() then if not n then _G.notify("Paused: A selected event is active. Waiting...",3,"triangle-alert") n=true end while _G.checkEventStatus() and _G.runningCollectNoneMutated do task.wait(1) end if _G.runningCollectNoneMutated then _G.notify("Resuming auto collection - event ended",2,"check") n=false end end if not _G.runningCollectNoneMutated then break end Farm,ImportantFolder,Plants_Physical,Objects_Physical=_G.GetPlayerFarm(localPlayer.Name) for _,p in ipairs(Plants_Physical:GetChildren()) do if not _G.runningCollectNoneMutated or _G.checkEventStatus() then break end if p:IsA("Model") then local f=p:FindFirstChild("Fruits") if f then for _,x in ipairs(f:GetChildren()) do if not _G.runningCollectNoneMutated or _G.checkEventStatus() then break end if not _G.hasAnyMutation(x,_G.sortedMutations) and not x:GetAttribute("Favorited") then pcall(function() _G.ByteNetReliable:FireServer(_G.harvestBuffer,{x}) _G.notify("Collected "..x.Name,1,"check") end) task.wait() end end elseif not _G.hasAnyMutation(p,_G.sortedMutations) and not p:GetAttribute("Favorited") then pcall(function() _G.ByteNetReliable:FireServer(_G.harvestBuffer,{p}) _G.notify("Collected "..p.Name,1,"check") end) task.wait() end end end task.wait(1) end _G.collectNoneThread=nil end

_G.togglePrompts = function(e) for _,p in ipairs(_G.Farms:GetDescendants()) do if p:IsA("ProximityPrompt") and p.Enabled~=e then p.Enabled=e end end end

_G.autoplantSeed = function() local h=_G.getHumanoidRootPart() if not h then return end local p=h.Position local c=getCurrentCharacter() while _G.AutoPlantSeed do if c then for _,t in ipairs(c:GetChildren()) do if t:IsA("Tool") and t.Name:lower():find("seed") then local a={Vector3.new(p.X,p.Y,p.Z),t:GetAttribute("Seed")} pcall(function() _G.plantEvent:FireServer(unpack(a)) end) task.wait() end end end task.wait() end end
_G.autoholdSeed = function() while _G.AutoHoldSeedCheck do local h=_G.getHumanoidRootPart() local c=_G.getCurrentCharacter() if not h or not c then return end for _,t in ipairs(c:GetChildren()) do if t:IsA("Tool") and t.Name:lower():find("seed") and t:GetAttribute("n")~="Flower Seed Pack" then for b,e in pairs(_G.donotPlantSeed) do if e and t.Name:lower():find(b:lower()) then t.Parent=_G.localPlayerBag end end end end for _,t in ipairs(_G.localPlayerBag:GetChildren()) do if t:IsA("Tool") and t.Name:lower():find("seed") and t:GetAttribute("n")~="Flower Seed Pack" then local s=false for b,e in pairs(_G.donotPlantSeed) do if e and t.Name:lower():find(b:lower()) then s=true break end end if not s then t.Parent=c end end end task.wait(1) end end

_G.shouldCollect = function() for _,e in pairs(_G.enabledMutations) do if e then return true end task.wait() end return false end

_G.collectspecial = function() if not _G.shouldCollect() then return end local l={} Farm,ImportantFolder,Plants_Physical,Objects_Physical=_G.GetPlayerFarm(_G.localPlayer.Name) for _,m in ipairs(Plants_Physical:GetChildren()) do if m:IsA("Model") then local f=m:WaitForChild("Fruits",60) local a=false if f then for _,x in ipairs(f:GetChildren()) do if x:IsA("Model") and _G.hasAnyMutation(x,_G.enabledMutations) and not x:GetAttribute("Favorited") and not _G.hasAnyMutation(x,_G.ignoreMutation) then table.insert(l,x) a=true break end end end if not a and _G.hasAnyMutation(m,_G.enabledMutations) and not m:GetAttribute("Favorited") and not _G.hasAnyMutation(m,_G.ignoreMutation) then table.insert(l,m) end end end for _,i in ipairs(l) do if not _G.shouldCollect() or _G.checkEventStatus() then break end pcall(function() _G.ByteNetReliable:FireServer(harvestBuffer,{i}) _G.notify("Collected "..i.Name,1,"check") end) task.wait() end end
_G.createToggle = function(t,i,n,r,a,c) local d=string.format("%s (%s)",n,r or "???") local g=t:Toggle({Title=d,Icon="shopping-cart",Default=false,Callback=function(v) i[a:lower()]=v end}) c:Register("AutoShop"..d,g) end
_G.getSortedKeys = function(t) local k={} for i in pairs(t) do table.insert(k,i) end table.sort(k) return k end

task.spawn(function() while task.wait(0.5) do local d,s,h=_G.getPlayerData() for c,i in pairs(_G.getStockchild("CosmeticStock","CrateStocks")) do if _G.wantedCrates[c:lower()] and i.Stock>0 and _G.requiredCratesData[c].Price<=s then pcall(function() _G.Remotes.buyCratesRemote:FireServer(c) _G.notify("Bought seed: "..c,1,"shopping-cart") task.wait() end) end end for n,i in pairs(_G.getStockchild("CosmeticStock","ItemStocks")) do if _G.wantedItems[n:lower()] and i.Stock>0 and _G.requiredItemData[n].Price<=s then pcall(function() _G.Remotes.buyItemRemote:FireServer(n) _G.notify("Bought seed: "..n,1,"shopping-cart") task.wait() end) print("found") end end for n,i in pairs(_G.getStock("SeedStock")) do if _G.seedShopWanted[n:lower()] and i.Stock>0 and _G.requiredSeedData[n].Price<=s then pcall(function() _G.Remotes.buySeedStockRemote:FireServer(n) _G.notify("Bought seed: "..n,1,"shopping-cart") task.wait() end) end end for n,i in pairs(_G.getStock("GearStock")) do if _G.gearShopWanted[n:lower()] and i.Stock>0 and _G.requiredGearData[n].Price<=s then pcall(function() _G.Remotes.buyGearStockRemote:FireServer(n) _G.notify("Bought gear: "..n,1,"shopping-cart") task.wait() end) end end for n,i in pairs(_G.getStock("PetEggStock")) do local e=i.EggName if _G.wantedEggs[e:lower()] and i.Stock>0 and _G.requiredPetEggData[e].Price<=s then pcall(function() _G.Remotes.buyPetEggRemote:FireServer(n) _G.notify("Bought egg: "..e,1,"shopping-cart") task.wait() end) end end for n,i in pairs(_G.getStock("EventShopStock")) do if _G.wantedEventItems[n:lower()] and i.Stock>0 and _G.requiredEventShopData[n].Price<=h then pcall(function() _G.Remotes.buyEventShopStockRemote:FireServer(n) _G.notify("Bought event item: "..n,1,"shopping-cart") task.wait() end) end end end end)

