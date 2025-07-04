local blankfunction=function(...)return...end
local cloneref=cloneref or blankfunction

local functions = {}
functions.services = {}

functions.getService = function(s) if not functions.services[s] then functions.services[s] = cloneref(game:GetService(s)) end return functions.services[s] end
functions.loadedModules = {}
functions.Farms = workspace:WaitForChild("Farm")
functions.extractDigitsFromText = function(t) return tonumber(t:match("%d+")) or 0 end
functions.getPlayerMoney = function() return functions.getService("Players").LocalPlayer.leaderstats.Sheckles.Value end
functions.tweenService       =functions.getService("TweenService")
functions.runService         =functions.getService("RunService")
functions.players            =functions.getService("Players")
functions.userInputService   =functions.getService("UserInputService")
functions.guiService         =functions.getService("GuiService")
functions.replicatedStorage  =functions.getService("ReplicatedStorage")
functions.virtualInputManager=functions.getService("VirtualInputManager")
functions.coreGui            =functions.getService("CoreGui")
functions.lighting           =functions.getService("Lighting")
functions.httpService        =functions.getService("HttpService")
functions.teleportService    =functions.getService("TeleportService")
functions.marketplaceService =functions.getService("MarketplaceService")
functions.collectionService  =functions.getService("CollectionService")
functions.terrain            =workspace and workspace.Terrain

functions.seedList = {"Aloe Vera Seed", "Apple Seed", "Avocado Seed", "Bamboo Seed", "Banana Seed", "Beanstalk Seed", "Bee Balm", "Bell Pepper Seed", "Bendboo", "Blood Banana Seed", "Blueberry Seed", "Bone Blossom Seed", "Boneboo Seed", "Burning Bud", "Cacao Seed", "Cactus Seed", "Candy Blossom Seed", "Candy Sunflower Seed", "Cantaloupe Seed", "Carrot Seed", "Cauliflower Seed", "Celestiberry Seed", "Cherry Blossom Seed", "Chocolate Carrot Seed", "Coconut Seed", "Cocovine", "Corn Seed", "Cranberry Seed", "Crimson Vine Seed", "Crocus", "Cursed Fruit Seed", "Daffodil Seed", "Dandelion", "Delphinium Seed", "Dragon Fruit Seed", "Dragon Pepper", "Durian Seed", "Easter Egg Seed", "Eggplant Seed", "Elephant Ears", "Ember Lily", "Feijoa Seed", "Firefly Fern Seed", "Firework Flower Seed", "Fossilight Seed", "Foxglove", "Glowshroom Seed", "Grape Seed", "Green Apple Seed", "Guanabana Seed", "Hive Fruit", "Honeysuckle", "Horned Dinoshroom Seed", "Ice Cream Bean Seed", "Kiwi Seed", "Lavender", "Lemon Seed", "Liberty Lily Seed", "Lilac", "Lily of the Valley Seed", "Lime Seed", "Loquat Seed", "Lotus Seed", "Lumira", "Mango Seed", "Manuka Flower", "Merica Mushroom Seed", "Mint Seed", "Moon Blossom Seed", "Moon Mango Seed", "Moon Melon Seed", "Moonflower Seed", "Moonglow Seed", "Mushroom Seed", "Nectar Thorn", "Nectarine", "Nectarshade", "Nightshade Seed", "Noble Flower", "Orange Tulip", "Papaya Seed", "Paradise Petal Seed", "Parasol Flower", "Passionfruit Seed", "Peace Lily Seed", "Peach Seed", "Pear Seed", "Pepper Seed", "Pineapple Seed", "Pink Lily Seed", "Pitcher Plant", "Prickly Pear Seed", "Pumpkin Seed", "Purple Dahlia Seed", "Rafflesia Seed", "Raspberry Seed", "Red Lollipop Seed", "Rose", "Rosy Delight Seed", "Soul Fruit Seed", "Starfruit Seed", "Stonebite Seed", "Strawberry Seed", "Succulent Seed", "Sugar Apple", "Suncoil", "Sunflower", "Tomato Seed", "Traveler's Fruit", "Venus Fly Trap Seed", "Violet Corn", "Watermelon Seed", "White Mulberry Seed", "Wild Carrot Seed"}
table.sort( functions.seedList )

-- Gold, Rainbow
functions.sortedMutations = {"Gold", "Rainbow", "Alienlike", "Amber", "AncientAmber", "Aurora", "Bloodlit", "Burnt", "Celestial", "Ceramic", "Chilled", "Choc", "Clay", "Cloudtouched", "Cooked", "Dawnbound", "Disco", "Drenched", "Fried", "Frozen", "Galactic", "Heavenly", "HoneyGlazed", "Meteoric", "Molten", "Moonlit", "OldAmber", "Paradisal", "Plasma", "Pollinated", "Sandy", "Shocked", "Sundried", "Twisted", "Verdant", "Voidtouched", "Wet", "Wiltproof", "Windstruck", "Zombified"}

table.sort( functions.sortedMutations )



functions.mutationColors = {
    ["Alienlike"] = Color3.fromRGB(0, 223, 197),
    ["Amber"] = Color3.fromRGB(255, 192, 0),
    ["AncientAmber"] = Color3.fromRGB(204, 68, 0),
    ["Aurora"] = Color3.fromRGB(99, 89, 175),
    ["Bloodlit"] = Color3.fromRGB(200, 0, 0),
    ["Burnt"] = Color3.fromRGB(40, 40, 40),
    ["Celestial"] = Color3.fromRGB(255, 0, 255),
    ["Ceramic"] = Color3.fromRGB(234, 184, 146),
    ["Chilled"] = Color3.fromRGB(135, 206, 250),
    ["Choc"] = Color3.fromRGB(92, 64, 51),
    ["Clay"] = Color3.fromRGB(150, 100, 80),
    ["Cloudtouched"] = Color3.fromRGB(225, 255, 255),
    ["Cooked"] = Color3.fromRGB(210, 120, 60),
    ["Dawnbound"] = Color3.fromRGB(255, 213, 0),
    ["Disco"] = Color3.fromRGB(255, 105, 180),
    ["Drenched"] = Color3.fromRGB(0, 55, 228),
    ["Fried"] = Color3.fromRGB(223, 110, 34),
    ["Frozen"] = Color3.fromRGB(108, 184, 255),
    ["Galactic"] = Color3.fromRGB(243, 148, 255),
    ["Heavenly"] = Color3.fromRGB(255, 249, 160),
    ["HoneyGlazed"] = Color3.fromRGB(255, 204, 0),
    ["Meteoric"] = Color3.fromRGB(73, 29, 193),
    ["Molten"] = Color3.fromRGB(223, 100, 0),
    ["Moonlit"] = Color3.fromRGB(153, 141, 255),
    ["OldAmber"] = Color3.fromRGB(252, 106, 33),
    ["Paradisal"] = Color3.fromRGB(176, 240, 0),
    ["Plasma"] = Color3.fromRGB(208, 43, 137),
    ["Pollinated"] = Color3.fromRGB(255, 170, 0),
    ["Sandy"] = Color3.fromRGB(212, 191, 141),
    ["Shocked"] = Color3.fromRGB(255, 255, 100),
    ["Sundried"] = Color3.fromRGB(207, 93, 0),
    ["Twisted"] = Color3.fromRGB(191, 191, 191),
    ["Verdant"] = Color3.fromRGB(34, 139, 34),
    ["Voidtouched"] = Color3.fromRGB(225, 0, 255),
    ["Wet"] = Color3.fromRGB(64, 164, 223),
    ["Wiltproof"] = Color3.fromRGB(0, 222, 155),
    ["Windstruck"] = Color3.fromRGB(162, 185, 209),
    ["Zombified"] = Color3.fromRGB(128, 199, 127),
}


functions.waitFor=function(n,p)return p:FindFirstChild(n,5)end
functions.getModule=function(p,n)if not functions.loadedModules[n]then local m=p:FindFirstChild(n)if not m or not m:IsA("ModuleScript")then warn("❌ Module not found or invalid -> Trash exec",n)return nil end;local s,r=pcall(require,m)if s then functions.loadedModules[n]=r else warn("❌ Failed to load module -> Trash exec",n,r)return nil end end;return functions.loadedModules[n]end
functions.GetTool = function(c)return c and c:FindFirstChildOfClass("Tool")end
functions.getHumanoidRootPart=function()local p=functions.players.LocalPlayer if p and p.Character then return p.Character:FindFirstChild("HumanoidRootPart")end return nil end
functions.refreshPlayerList = function(d)local t={}for _,p in ipairs(game.Players:GetPlayers())do if p~=functions.players.LocalPlayer then table.insert(t,p.Name)end end table.sort(t)d:Refresh(t)end
functions.parseTargetFruits = function(d)local u,p={},{};for _,f in ipairs(d.Value or {})do local c=f:match("^%s*(.-)%s*$"):lower()if c~=""then u[c]=true end end;for n in pairs(u)do table.insert(p,n)end;return p end

functions.hasAnyMutation = function(obj, m)
    return obj and obj.GetAttributes and (function()
        -- Check attributes
        local attributes = obj:GetAttributes()
        for a in pairs(attributes) do
            local l = string.lower(a)
            if type(m) == "table" then
                for k, v in pairs(m) do
                    if v and l == string.lower(k) then
                        return true
                    end
                end
                for _, v in ipairs(m) do
                    if l == string.lower(v) then
                        return true
                    end
                end
            end
        end

        -- Check Variant StringValue
        local variant = obj:FindFirstChild("Variant")
        if variant and variant:IsA("StringValue") then
            local variantLower = string.lower(variant.Value)
            for k, v in pairs(m) do
                if v and variantLower == string.lower(k) then
                    return true
                end
            end
            for _, v in ipairs(m) do
                if variantLower == string.lower(v) then
                    return true
                end
            end
        end

        return false
    end)() or false
end

functions.togglePrompts = function(enabled) for _, prompt in ipairs(functions.Farms:GetDescendants()) do if prompt:IsA("ProximityPrompt") and prompt.Enabled ~= enabled then prompt.Enabled = enabled end end end
functions.hidePlantVisualEffects=function(hide)if not functions.Farms then return end;local t=hide and 1 or 0.5;for _,d in ipairs(functions.Farms:GetDescendants())do if d:IsA("ParticleEmitter")then d.Enabled=not hide elseif d.Name=="FrozenShell"and d:IsA("BasePart")then d.Transparency=t end end end
functions.makeHttpRequest=function(requestData)
    local request_functions = {
        request,
        http_request,
        syn and syn.request,
        http and http.request,
        fluxus and fluxus.request,
        function(data)
            if functions.httpService.RequestInternal then
                return functions.httpService:RequestInternal(data)
            end
        end
    }

    for _, func in pairs(request_functions) do
        if func then
            local success, response = pcall(func, requestData)
            if success and response then
                return response
            end
        end
    end

    return nil
end

functions.setUniversalClipboard = function(text)
    local clipboard_functions = {
        setclipboard,
        toclipboard,
        writeclipboard,
        syn and syn.write_clipboard,
        Clipboard and Clipboard.set
    }

    for _, func in pairs(clipboard_functions) do
        if func then
            local success = pcall(func, text)
            if success then
                return true
            end
        end
    end

    return false
end

functions.getUniversalHWID = function()
    local function safeCall(fn)
        if typeof(fn) == "function" then
            local success, result = pcall(fn)
            if success and result and result ~= "" then
                return tostring(result)
            end
        end
        return nil
    end

    local hwid = nil

    local hwid_methods = {
        function()
            local success, result = pcall(function() return gethwid end)
            return success and typeof(result) == "function" and result() or nil
        end,
        function()
            local success, result = pcall(function() return gethardwareid end)
            return success and typeof(result) == "function" and result() or nil
        end,
        function()
            local success, result = pcall(function()
                return game:GetService("RbxAnalyticsService"):GetClientId()
            end)
            return success and result or nil
        end,
        function()
            local success, result = pcall(function()
                local player = game:GetService("Players").LocalPlayer
                return player and player.Name .. "_" .. game.JobId or nil
            end)
            return success and result or nil
        end
    }

    for _, method in ipairs(hwid_methods) do
        hwid = safeCall(method)
        if hwid then break end
    end

    return hwid or ("fallback-hwid-" .. tostring(tick()))
end

local BILLBOARD_SIZE = UDim2.new(0, 200, 0, 50)
local BILLBOARD_OFFSET = Vector3.new(0, 6, 0) 

functions.CreateHatchingBillboard = function(egg)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "HatchingPetBillboard"
    billboard.Adornee = egg
    billboard.Size = BILLBOARD_SIZE
    billboard.StudsOffset = BILLBOARD_OFFSET
    billboard.AlwaysOnTop = false
    billboard.LightInfluence = 0
    billboard.MaxDistance = 150
    billboard.Enabled = true
    billboard.Parent = egg
    
    -- Background frame
    local background = Instance.new("Frame")
    background.Name = "Background"
    background.Size = UDim2.new(1, 0, 1, 0)
    background.BackgroundColor3 = Color3.fromRGB(0, 200, 0) 
    background.BackgroundTransparency = 0.2
    background.BorderSizePixel = 0
    background.Parent = billboard
    
    -- Rounded corners
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 8)
    uiCorner.Parent = background
    
    -- Border stroke
    local uiStroke = Instance.new("UIStroke")
    uiStroke.Color = Color3.fromRGB(255, 255, 255)
    uiStroke.Thickness = 2
    uiStroke.Parent = background
    
    -- Padding
    local uiPadding = Instance.new("UIPadding")
    uiPadding.PaddingTop = UDim.new(0, 4)
    uiPadding.PaddingBottom = UDim.new(0, 4)
    uiPadding.PaddingLeft = UDim.new(0, 8)
    uiPadding.PaddingRight = UDim.new(0, 8)
    uiPadding.Parent = background
    
    -- Text label
    local label = Instance.new("TextLabel")
    label.Name = "HatchingPetLabel"
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    label.TextStrokeTransparency = 0.3
    label.TextWrapped = true
    label.Text = "READY TO HATCH!"
    label.Parent = background
    
    return billboard
end

cgo = functions.replicatedStorage:WaitForChild("GameEvents"):WaitForChild("CraftingGlobalObjectService")

functions.UpdateBillboardText = function(billboard, petName)
                local background = billboard:FindFirstChild("Background")
                if background then
                    local label = background:FindFirstChild("HatchingPetLabel")
                    if label then
                        local displayName = petName or "Unknown Pet"
                        label.Text = displayName
                    end
                end
            end

functions.RemoveEggESP = function(egg)
                local billboard = egg:FindFirstChild("HatchingPetBillboard")
                if billboard then
                    billboard:Destroy()
                end
            end

functions.getPlayerData = function()
    local dataService = require(game:GetService("ReplicatedStorage").Modules.DataService)
    local data = dataService:GetData() 
    return data, 
           data and data.Sheckles, 
           data and data.SpecialCurrency and data.SpecialCurrency.Honey, 
           data and data.SpecialCurrency and data.SpecialCurrency.SummerCoins, 
           data and data.CraftingData.GlobalCraftingObjectData, 
           data and data.InventoryData
end

functions.hasEnoughCurrency = function(recipe, Sheckles, Honey)
    local cost = recipe.Cost
    if cost.CurrencyType == "Sheckles" then
        return Sheckles >= cost.Amount, "Sheckles"
    elseif cost.CurrencyType == "Honey" then
        return Honey >= cost.Amount, "Honey"
    end
    return true
end

functions.isMachineAvailable = function(machineData, machineId, v8)
    if not machineData or not machineData[v8] then
        return true -- If no machine data, assume available
    end
    
    local craftingItems = machineData[v8].CraftingItems or {}
    
    -- Check if there are any items in the machine at all
    if #craftingItems == 0 then
        return true -- Machine is completely empty
    end
    
    -- Check if all jobs are completed
    for _, job in ipairs(craftingItems) do
        if not job.IsDone then
            return false -- There's still an active/pending job
        end
    end
    
    return true -- All jobs are done, machine is ready
end

functions.addRecipeItems = function(inputs, inventory, machine, machineId, cgo)
    for i, input in ipairs(inputs) do
        local found = false
        for uid, item in pairs(inventory) do
            local compare
            if input.ItemType == "Sprinkler" or input.ItemType == "Holdable" or input.ItemType == "Seed" then
                compare = item.ItemData.ItemName
            elseif input.ItemType == "PetEgg" then
                compare = item.ItemData.EggName
            elseif input.ItemType == "SprayBottle" then
                compare = item.ItemData.SprayType
            elseif input.ItemType == "Seed Pack" then
                compare = item.ItemData.Type
            elseif input.ItemType == "Harvest Tool" then
                compare = item.ItemType
            else
                compare = item.ItemData.ItemName
            end

            if compare == input.ItemName and input.ItemType == item.ItemType then
                if item.ItemData.IsFavorite then
                    print("Unfavorite:", input.ItemName)
                else
                    cgo:FireServer("InputItem", machine, machineId, i, { ItemType = input.ItemType, ItemData = { UUID = uid } })
                    print("Added item:", input.ItemName)
                    found = true
                end
                break
            end
        end
        if not found then
            print("Missing item:", input.ItemName)
            return false -- Return false if any item is missing
        end
    end
    return true -- All items added successfully
end


functions.claimCompletedJobs = function(machineData, machine, machineId, cgo)
    local claimed = false
    if machineData and machineData[machineId] then
        for index, job in ipairs(machineData[machineId].CraftingItems or {}) do
            print("Job", index, "done:", job.IsDone)
            if job.IsDone then
                cgo:FireServer("Claim", machine, machineId, index)
                print("Claimed completed job at index:", index)
                task.wait(0.5)
                claimed = true
            end
        end
    else
        print("No machine data for ID:", machineId)
    end
    return claimed
end


functions.waitForMachineIdle = function(machine, machineId, v8)
    print("Waiting for machine to become idle...")
    while true do
        task.wait(2) -- Increased wait time for better performance
        local _, _, _, _, data = functions.getPlayerData()
        local machineData = data and data[machineId] and data[machineId].MachineData

        -- Claim any completed jobs first
        local claimed = functions.claimCompletedJobs(machineData, machine, v8, cgo)
        
        -- If we claimed something, wait a bit more for the machine to update
        if claimed then
            task.wait(1)
            _, _, _, _, data = functions.getPlayerData()
            machineData = data and data[machineId] and data[machineId].MachineData
        end
        
        -- Check if machine is now available
        if functions.isMachineAvailable(machineData, machineId, v8) then
            print("Machine is now idle and ready")
            break
        else
            print("Machine still busy, continuing to wait...")
        end
    end
end

functions.loadCraftingRecipes = function()
    local seedRecipes = { "Off" }
    local gearRecipes = { "Off" }
    local dinoRecipes = { "Off" }
    local outputTable = {}
    
    local success, error = pcall(function()
        local CraftingData = require(game:GetService("ReplicatedStorage").Data.CraftingData)
        local Recipes = CraftingData.CraftingRecipeRegistry.ItemRecipes
        
        local processedCount = 0
        local totalRecipes = 0
        
        -- Count total recipes first
        for _ in pairs(Recipes) do
            totalRecipes = totalRecipes + 1
        end
        
        -- Process recipes with yield points
        for recipeName, recipeData in pairs(Recipes) do
            local recipeEntry = {}
            recipeEntry.MachineTypes = {}
            
            -- MachineTypes
            if recipeData.MachineTypes and #recipeData.MachineTypes > 0 then
                for _, machineType in ipairs(recipeData.MachineTypes) do
                    table.insert(recipeEntry.MachineTypes, machineType)
                end
            end
            
            -- Inputs
            recipeEntry.Inputs = {}
            if recipeData.Inputs then
                for _, input in ipairs(recipeData.Inputs) do
                    local itemName = input.ItemData and input.ItemData.ItemName or "(unknown)"
                    local itemType = input.ItemType or "(unknown)"
                    table.insert(recipeEntry.Inputs, {
                        ItemName = itemName,
                        ItemType = itemType
                    })
                end
            end
            
            -- Cost
            if recipeData.Cost then
                recipeEntry.Cost = {
                    CurrencyType = recipeData.Cost.CurrencyType or "(unknown)",
                    Amount = recipeData.Cost.Amount or 0
                }
            else
                recipeEntry.Cost = {
                    CurrencyType = "None",
                    Amount = 0
                }
            end
            
            outputTable[recipeName] = recipeEntry
            
            -- Categorize recipe
            local hasSeedEventWorkbench = false
            local hasthenewevent = false
            for _, machineType in ipairs(recipeEntry.MachineTypes) do
                if machineType == "SeedEventWorkbench" then
                    hasSeedEventWorkbench = true
                    break
                elseif machineType == "DinoEventWorkbench" then
                    hasthenewevent = true
                    break
                end
            end
            
            if hasSeedEventWorkbench then
                table.insert(seedRecipes, recipeName)
            elseif hasthenewevent then
                table.insert(dinoRecipes, recipeName)
            else
                table.insert(gearRecipes, recipeName)
            end
            
            processedCount = processedCount + 1
            
            -- Yield every 10 recipes to prevent lag
            if processedCount % 10 == 0 then
                task.wait()
                print(string.format("Processed %d/%d recipes...", processedCount, totalRecipes))
            end
        end
        
        print(string.format("Loaded %d seed recipes and %d gear recipes", #seedRecipes - 1, #gearRecipes - 1))
    end)
    
    if not success then
        print("Error loading recipes:", error)
        return nil, nil, nil
    end
    
    return seedRecipes, gearRecipes, dinoRecipes, outputTable
end

-- Create auto-crafting coroutine
functions.createAutoCraftingCoroutine = function(machine, machineId, v8, selectedRecipe, outputTable, isActive)
    return coroutine.create(function()
        
        while isActive() do
            task.wait(1)
            local _, Sheckles, Honey, _, data, inventory = functions.getPlayerData()
            local machineData = data and data[machineId] and data[machineId].MachineData

            -- First, claim any completed jobs
            functions.claimCompletedJobs(machineData, machine, v8, cgo)
            
            -- Wait a moment for the machine data to update after claiming
            task.wait(0.5)
            _, _, _, _, data, inventory = functions.getPlayerData()
            machineData = data and data[machineId] and data[machineId].MachineData

            -- Check if machine is available for new crafting
            if functions.isMachineAvailable(machineData, machineId, v8) then
                local recipe = outputTable[selectedRecipe()]
                if not recipe then 
                    print("Recipe not found:", selectedRecipe()) 
                    break 
                end
                
                print("Starting new craft for:", selectedRecipe())
                cgo:FireServer("SetRecipe", machine, v8, selectedRecipe())
                task.wait(0.5) -- Small delay after setting recipe
                
                -- Add items and check if successful
                local itemsAdded = functions.addRecipeItems(recipe.Inputs, inventory, machine, v8, cgo)
                if not itemsAdded then
                    print("Failed to add all required items, retrying...")
                    task.wait(3)
                    continue
                end

                -- Check currency before starting
                local enoughCurrency, currencyType = functions.hasEnoughCurrency(recipe, Sheckles, Honey)
                if not enoughCurrency then
                    print("Waiting for enough", currencyType)
                    task.wait(5) -- Wait longer before checking again
                    continue
                end
                
                task.wait(0.5) -- Small delay after adding items
                
                cgo:FireServer("Craft", machine, v8)
                print("Crafting started:", selectedRecipe())
                
                -- Wait for this crafting job to complete before starting next
                functions.waitForMachineIdle(machine, machineId, v8)
            else
                print("Machine busy, waiting for completion...")
                functions.waitForMachineIdle(machine, machineId, v8)
            end
        end
        print("Auto-crafting stopped:", selectedRecipe())
    end)
end

local Connections = {}

functions.addConnection = function(name, connection)
    if not name or not connection then return end
    if Connections[name] then
        pcall(function()
            Connections[name]:Disconnect()
        end)
    end
    Connections[name] = connection
end

functions.cleanupConnections = function(name)
    if name then
        if Connections[name] then
            pcall(function()
                Connections[name]:Disconnect()
            end)
            Connections[name] = nil
        end
    else
        for k, v in pairs(Connections) do
            if v then
                pcall(function()
                    v:Disconnect()
                end)
            end
        end
        Connections = {}
    end
end

functions.safeGet = function(instance, ...)
    for _, name in ipairs({...}) do
        if not instance or not instance:WaitForChild(name, 10) then
            return nil
        end
        instance = instance:WaitForChild(name, 10)
    end
    return instance
end

functions.GetPlayerFarm = function(Player)
    if not Player then
        return
    end
    for _, Farm in ipairs(functions.Farms:GetChildren()) do
        local i = Farm:WaitForChild("Important", 60)
        if i then
            local d = i:WaitForChild("Data", 60)
            if d then
                local o = d:WaitForChild("Owner", 60)
                if o and o.Value == Player then
                    return Farm, i, i:WaitForChild("Plants_Physical", 60), i:WaitForChild("Objects_Physical", 60)
                end
            end
        end
    end
end

task.defer(function()local function t(e)if not e then return end;local h=functions.getHumanoidRootPart()if not h then return end;if not pcall(function()firetouchinterest(h,e,0)task.wait()firetouchinterest(h,e,1)end)then warn("Touch function failed - firetouchinterest may not be available")end end;local p=game:GetService("Players").LocalPlayer;workspace.ChildAdded:Connect(function(c)if not c:IsA("Model")then return end;task.wait(1)if c:GetAttribute("SEED_GIVEN")and c:GetAttribute("OWNER")==p.Name then task.wait(2)local part=c:FindFirstChildOfClass("Part")if not part then return end;t(part)end end)end)




task.defer(function()
    local Players = functions.getService("Players")
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    local pg = playerGui:WaitForChild("Teleport_UI", 10)
    local frame = pg and pg:WaitForChild("Frame", 10)

    if frame then
        for _, name in ipairs({ "Gear", "Pets" }) do
            local element = frame:WaitForChild(name, 10)
            if element and not element.Visible then
                element.Visible = true
            end
            task.wait()
        end
    else
        if cores and cores.notify then
            cores.notify("Teleport UI frame missing", 3, "x")
        else
            warn("Teleport UI frame missing")
        end
    end
end)

return functions
