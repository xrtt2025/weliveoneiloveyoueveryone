-- Full Bypassed Shovel Script
-- Allows shoveling all objects including sprinklers and carrots

local UIS = game:GetService("UserInputService")
local CS = game:GetService("CollectionService")
local RS = game:GetService("ReplicatedStorage")
local TS = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local GameEvents = RS:WaitForChild("GameEvents")
local Remove_Item = GameEvents:WaitForChild("Remove_Item")
local DeleteObject = GameEvents:WaitForChild("DeleteObject")

local GetFarm = require(RS.Modules.GetFarm)
local Notify = require(RS.Modules.Notification)
local SeedData = require(RS.Data.SeedData)
local EventGearData = require(RS.Data.EventGearData)
local ItemModule = require(RS.Item_Module)

local LocalPlayer = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera

local ShovelPrompt = LocalPlayer.PlayerGui:WaitForChild("ShovelPrompt")
local ConfirmFrame = ShovelPrompt:WaitForChild("ConfirmFrame")
local Confirm = ConfirmFrame:WaitForChild("Confirm")
local Cancel = ConfirmFrame:WaitForChild("Cancel")
local ExitButton = ConfirmFrame:WaitForChild("ExitButton")
local FruitName = ConfirmFrame:WaitForChild("FruitName")
local Highlight = game:GetService("Players").LocalPlayer.PlayerScripts.Shovel_Client.Highlight

local Selection = {
    Instance = nil,
    IsPlaceableObject = false
}

local ValuableList = {
    "Coconut", "Cactus", "Dragon Fruit", "Mango", "Grape", "Mushroom", "Pepper", "Cacao", "Beanstalk", "Ember Lily",
    "Sugar Apple", "Burning Bud", "Pineapple", "Cauliflower", "Green Apple", "Banana", "Avocado", "Kiwi", "Bell Pepper",
    "Prickly Pear", "Feijoa", "Loquat", "Rafflesia", "Pitcher Plant", "Lily of the Valley", "Traveler's Fruit",
    "Aloe Vera", "Guanabana", "Pear", "Cantaloupe", "Parasol Flower", "Rosy Delight", "Elephant Ears", "Peach",
    "Raspberry", "Papaya", "Passionfruit", "Soul Fruit", "Cursed Fruit", "Cranberry", "Durian", "Eggplant", "Lotus",
    "Venus Fly Trap", "Candy Blossom", "Easter Egg", "Moonflower", "Starfruit", "Moonglow", "Moon Blossom",
    "Glowshroom", "Nightshade", "Blood Banana", "Moon Melon", "Celestiberry", "Moon Mango", "Rose", "Foxglove", "Lilac",
    "Pink Lily", "Purple Dahlia", "Sunflower", "Hive Fruit", "Nectarine", "Dandelion", "Lumira", "Honeysuckle",
    "Succulent", "Violet Corn", "Bendboo", "Cocovine", "Dragon Pepper", "Bee Balm", "Nectar Thorn", "Suncoil",
    "Bone Blossom", "Cherry Blossom", "Lemon", "Purple Cabbage", "Crimson Vine", "White Mulberry", "Liberty Lily",
    "Merica Mushroom", "Firework Flower"
}

local function IsValuable(name)
    for _, v in ipairs(ValuableList) do
        if string.find(string.lower(name), string.lower(v)) then
            return true
        end
    end
    return false
end

local rainbowTweenConnection = nil
local function StartRainbowTween(label)
    if rainbowTweenConnection then rainbowTweenConnection:Disconnect() end
    local hue = 0
    rainbowTweenConnection = RunService.RenderStepped:Connect(function(dt)
        hue = (hue + dt * 0.2) % 1
        local color = Color3.fromHSV(hue, 1, 1)
        label.Text = string.format("<font color=\"#%02X%02X%02X\">%s</font>", color.R*255, color.G*255, color.B*255, label.Text:gsub("<.->", ""))
    end)
end

local function StopRainbowTween()
    if rainbowTweenConnection then
        rainbowTweenConnection:Disconnect()
        rainbowTweenConnection = nil
    end
end

Confirm.MouseButton1Click:Connect(function()
    if Selection.Instance then
        if Selection.IsPlaceableObject then
            DeleteObject:FireServer(Selection.Instance)
        else
            Remove_Item:FireServer(Selection.Instance)
        end
    end
    Selection.Instance = nil
    Selection.IsPlaceableObject = false
    ShovelPrompt.Enabled = false
    StopRainbowTween()
end)

Cancel.MouseButton1Click:Connect(function()
    Selection.Instance = nil
    Selection.IsPlaceableObject = false
    ShovelPrompt.Enabled = false
    StopRainbowTween()
end)

ExitButton.MouseButton1Click:Connect(function()
    Selection.Instance = nil
    Selection.IsPlaceableObject = false
    ShovelPrompt.Enabled = false
    StopRainbowTween()
end)

local function RaycastToMouse(pos)
    local ray = Camera:ViewportPointToRay(pos.X, pos.Y)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = { CS:GetTagged("ShovelIgnore") }
    return workspace:Raycast(ray.Origin, ray.Direction * 500, params)
end

RunService.RenderStepped:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Shovel [Destroy Plants]") then
        local hit = RaycastToMouse(UIS:GetMouseLocation())
        if hit then
            local farm = GetFarm(LocalPlayer)
            if farm and hit.Instance:IsDescendantOf(farm) then
                local model = hit.Instance:FindFirstAncestorWhichIsA("Model")
                if model and (CS:HasTag(model, "Growable") or CS:HasTag(model, "PlaceableObject")) then
                    if Highlight.Adornee ~= model then
                        Highlight.FillTransparency = 1
                        TS:Create(Highlight, TweenInfo.new(0.25), { FillTransparency = 0.65 }):Play()
                    end
                    Highlight.Adornee = model
                else
                    Highlight.Adornee = nil
                end
            else
                Highlight.Adornee = nil
            end
        else
            Highlight.Adornee = nil
        end
    else
        Highlight.Adornee = nil
    end
end)

local function HandleInput(input, processed)
    if processed then return end
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("Shovel [Destroy Plants]") then return end

    local hit = RaycastToMouse(input)
    if not hit then return end

    local model = hit.Instance:FindFirstAncestorWhichIsA("Model")
    if not model then return end

    local farm = GetFarm(LocalPlayer)
    if not farm or not hit.Instance:IsDescendantOf(farm) then return end

    local name = model.Name

    if CS:HasTag(model, "PlaceableObject") then
        FruitName.Text = name
        StopRainbowTween()
        Selection.Instance = model
        Selection.IsPlaceableObject = true
        ShovelPrompt.Enabled = true
        return
    end

    if model:FindFirstChild("Grow") then
        if model:GetAttribute("Favorited") then
            Notify:CreateNotification("This plant is favorited!")
            return
        end

        local fruits = model:FindFirstChild("Fruits")
        if fruits then
            for _, fruit in ipairs(fruits:GetChildren()) do
                if fruit:GetAttribute("Favorited") then
                    Notify:CreateNotification("This plant has favorited fruit!")
                    return
                end
            end
        end

        if IsValuable(name) then
            local data = SeedData[name] or EventGearData[name]
            local rarity = data and ItemModule.Return_Rarity_Data(data.SeedRarity)
            FruitName.Text = string.format("<font color=\"%s\">%s</font>", rarity and string.format("#%02X%02X%02X", rarity[2].R*255, rarity[2].G*255, rarity[2].B*255) or "#FFFFFF", name)

            if data and data.SeedRarity == "Prismatic" then
                StartRainbowTween(FruitName)
            else
                StopRainbowTween()
            end

            Selection.Instance = hit.Instance
            Selection.IsPlaceableObject = false
            ShovelPrompt.Enabled = true
        else
            Remove_Item:FireServer(hit.Instance)
        end
    end
end

local InputConnection = nil
local function UpdateInput()
    if InputConnection then InputConnection:Disconnect() end
    if UIS:GetLastInputType() == Enum.UserInputType.Touch then
        InputConnection = UIS.TouchTapInWorld:Connect(HandleInput)
    else
        InputConnection = LocalPlayer:GetMouse().Button1Down:Connect(function()
            HandleInput(UIS:GetMouseLocation(), false)
        end)
    end
end

UIS.LastInputTypeChanged:Connect(UpdateInput)
task.spawn(UpdateInput)
