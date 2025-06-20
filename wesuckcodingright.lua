local blankfunction = function(...) return ... end
local cloneref = cloneref or blankfunction

_G.services = {}
_G.getService=function(s) if not _G.services[s] then _G.services[s]=cloneref(game:GetService(s)) end return _G.services[s] end
_G.isShowNotification = true
_G.notify=function(m,d,i) if not _G.isShowNotification then return true end task.spawn(function() while not _G.WindUI do task.wait(0.1) end local s=pcall(function() if _G.WindUI and typeof(_G.WindUI.Notify)=="function" then _G.WindUI:Notify({Title=_G.gameData.Name.." Hub",Content=m,Duration=d or 3,Icon=i or "info"}) else error("WindUI unavailable") end end) if not s then warn("Custom notification failed. Trying Roblox notification:",m) local f=pcall(function() _G.getService("StarterGui"):SetCore("SendNotification",{Title=_G.gameData.Name.." Hub",Text=m,Duration=d or 3,Icon=i or nil}) end) if not f then warn("Roblox notification also failed. Printing instead:") print("[NOTIFY]",m) end end end)
_G.extractDigitsFromText=function(t) return tonumber(t:match("%d+")) or 0 end
_G.getPlayerMoney=function() return _G.getService("Players").LocalPlayer.leaderstats.Sheckles.Value end
_G.Farms = workspace:FindFirstChild("Farm")
