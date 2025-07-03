local p=game:GetService("Players").LocalPlayer
local c=p.Character or p.CharacterAdded:Wait()
local s=p:WaitForChild("PlayerScripts",60)
local cam=workspace.CurrentCamera
local f=workspace:WaitForChild("Farm",60)
local m=game:GetService("ReplicatedStorage"):WaitForChild("Modules",60)
local ge=game:GetService("ReplicatedStorage"):WaitForChild("GameEvents",60)
local tr=ge:WaitForChild("TrowelRemote",60)
local notify=require(m:WaitForChild("Notification"))
local uis=game:GetService("UserInputService")
local conns,plant,farm,plants={},nil,nil,nil
local function n(t,col) if notify then notify:CreateNotification(t,col) else print("[Trowel]",t) end end
local function getFarm(plr) for _,v in pairs(f:GetChildren()) do local d=v:FindFirstChild("Important") and v.Important:FindFirstChild("Data") local o=d and d:FindFirstChild("Owner") if o and o.Value==plr.Name then return v,v.Important:FindFirstChild("Plants_Physical") end end end
local function getPlant(ins) if not plants then return end if ins.Parent==plants then return ins end local cur=ins.Parent while cur and cur.Parent~=plants do cur=cur.Parent end return cur end
local function cancel(tool) if not plant then return end pcall(function() tr:InvokeServer("Cancel",tool,plant) end) local h=plant:FindFirstChild("PlantHighlight") if h then h:Destroy() end for _,v in pairs(plant:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide=true v.CanQuery=true end end n("Cancelled "..plant.Name,Color3.fromRGB(255,0,0)) plant=nil end
local function handle(tool)
    local m=uis:GetMouseLocation()
    local r=cam:ViewportPointToRay(m.X,m.Y)
    local pms=RaycastParams.new()
    pms.FilterDescendantsInstances={c}
    pms.FilterType=Enum.RaycastFilterType.Exclude
    local hit=workspace:Raycast(r.Origin,r.Direction*1000,pms)
    if not hit or not hit.Instance then return end
    if plant then
        if hit.Instance.Name=="Can_Plant" and hit.Instance:IsDescendantOf(farm) then
            local cf=CFrame.new(hit.Position)
            pcall(function() tr:InvokeServer("Place",tool,plant,cf) end)
            plant:PivotTo(cf)
            local h=plant:FindFirstChild("PlantHighlight") if h then h:Destroy() end
            for _,v in pairs(plant:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide=true v.CanQuery=true end end
            n("Placed "..plant.Name,Color3.fromRGB(0,255,0)) plant=nil
        else
            n("Can't place here!",Color3.fromRGB(255,0,0))
        end
    else
        local target=getPlant(hit.Instance)
        if target then
            plant=target
            pcall(function() tr:InvokeServer("Pickup",tool,plant) end)
            n("Picked "..plant.Name,Color3.fromRGB(0,255,0))
            for _,v in pairs(plant:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide=false v.CanQuery=false end end
            local h=Instance.new("Highlight")
            h.Name="PlantHighlight" h.Parent=plant h.Adornee=plant h.FillTransparency=1
            h.OutlineTransparency=0 h.OutlineColor=Color3.fromRGB(0,255,0)
        end
    end
end
local function cleanup()
    for _,v in pairs(conns) do if v then v:Disconnect() end end conns={}
    if plant then cancel(nil) end
    local sc=s:FindFirstChild("Trowel_Client") if sc then sc.Disabled=false end
end
local function setup()
    conns["ToolAdd"]=c.ChildAdded:Connect(function(t)
        if t:IsA("Tool") and t.Name:find("Trowel") then
            local sc=s:FindFirstChild("Trowel_Client")
            if sc then sc.Disabled=true end
            conns["Click"]=t.Activated:Connect(function() handle(t) end)
        end
    end)
    conns["ToolRemove"]=c.ChildRemoved:Connect(function(t)
        if t:IsA("Tool") and t.Name:find("Trowel") then
            local sc=s:FindFirstChild("Trowel_Client") if sc then sc.Disabled=false end
            if conns["Click"] then conns["Click"]:Disconnect() conns["Click"]=nil end
            cancel(t)
        end
    end)
end
conns["CharAdd"]=p.CharacterAdded:Connect(function(chr) c=chr setup() end)
conns["CharRemove"]=p.CharacterRemoving:Connect(function() c=nil cancel(nil) end)
farm,plants=getFarm(p)
setup()
n("Click-to-Trowel Enabled",Color3.fromRGB(255,170,0))
