
local PATRIOT_RAW_URL = "https://raw.githubusercontent.com/jxndjdnjsnz/wind-JB/refs/heads/main/PatriotUi.luau.txt"
local SCRIPT_TITLE = "wind JB"
local DISCORD_LINK = "https://discord.gg/9178"
local GET_KEY_LINK = ""

local success, Patriot = pcall(function()
    return loadstring(game:HttpGet(PATRIOT_RAW_URL))()
end)
if not success or not Patriot then
    warn("Patriot 库加载失败！检查你的raw链接是否有效")
    return
end

Patriot.Appearance.Title = SCRIPT_TITLE
Patriot.Appearance.Subtitle = "请输入密钥以继续使用脚本"
Patriot.Links.Discord = DISCORD_LINK
Patriot.Links.GetKey = GET_KEY_LINK
Patriot.Theme.Accent = Color3.fromRGB(139, 0, 0)

Patriot.Options.Blur = true
Patriot.Options.Draggable = true
Patriot.Options.Keyless = false
Patriot.Options.KeylessUI = true

Patriot.Storage.Remember = true
Patriot.Storage.AutoLoad = true

Patriot.Callbacks.OnSuccess = function()
    local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/jxndjdnjsnz/wind-JB/refs/heads/main/UI.lua.txt"))()

    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local RunService = game:GetService("RunService")
    local VirtualUser = game:GetService("VirtualUser")
    local localPlayer = Players.LocalPlayer

    local cooldownActive = false
    local cooldownTime = 3
    local antiAfkRunning = false
    local antiAfkConnection = nil

    local Window = WindUI:CreateWindow({
        Title = "JB Hub",
        Size = UDim2.fromOffset(440, 340),
        Theme = "Dark"
    })

    -- 标签页
    local TabVehicle = Window:Tab({
        Title = "Twsited X15.0.1",
        Icon = "car"
    })
    local TabOther = Window:Tab({
        Title = "其他功能",
        Icon = "settings"
    })
    local function SpawnCar(carName)
        if cooldownActive then return end
        cooldownActive = true
        task.spawn(function()
            for _, v in pairs(workspace:GetChildren()) do
                if v:IsA("Model") and v:FindFirstChild("Humanoid") and v ~= localPlayer.Character then
                    local seat = v:FindFirstChildWhichIsA("VehicleSeat", true)
                    if seat and seat.Occupant and seat.Occupant:IsDescendantOf(localPlayer.Character) then
                        v:Destroy()
                        task.wait(0.2)
                        break
                    end
                end
            end

            local char = localPlayer.Character or localPlayer.CharacterAdded:Wait()
            char:WaitForChild("HumanoidRootPart")
            local SpawnCarEvent = ReplicatedStorage:WaitForChild("SpawnCar")
            SpawnCarEvent:FireServer(carName)

            task.wait(cooldownTime)
            cooldownActive = false
        end)
    end

    TabVehicle:Section({Title = "车辆召唤"})

    TabVehicle:Button({
        Title = "召唤 Dominator 1",
        Callback = function()
            SpawnCar("Dominator 1")
        end
    })
    TabVehicle:Button({
        Title = "召唤 Dominator 2",
        Callback = function()
            SpawnCar("Dominator 2")
        end
    })
    TabVehicle:Button({
        Title = "召唤 Dominator 3",
        Callback = function()
            SpawnCar("Dominator 3")
        end
    })

    TabOther:Section({Title = "挂机防踢"})
    TabOther:Toggle({
        Title = "开启挂机防踢",
        Value = false,
        Callback = function(state)
            antiAfkRunning = state
            if state then
                antiAfkConnection = RunService.Heartbeat:Connect(function()
                    VirtualUser:CaptureController()
                    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                    task.wait(0.25)
                    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                end)
            else
                if antiAfkConnection then
                    antiAfkConnection:Disconnect()
                    antiAfkConnection = nil
                end
            end
        end
    })

    Window:OnClose(function()
        antiAfkRunning = false
        if antiAfkConnection then
            antiAfkConnection:Disconnect()
            antiAfkConnection = nil
        end
    end)
end

Patriot.Callbacks.OnVerify = function(inputKey)
    local validKeys = {
        "LUQENBINGSHIGAY",
        "820819QWE"
    }
    for _, k in ipairs(validKeys) do
        if inputKey == k then return true end
    end
    return false
end

Patriot.Callbacks.OnFail = function(errMsg)
    warn("密钥验证失败: " .. tostring(errMsg))
end

Patriot.Callbacks.OnClose = function()
    print("用户关闭密钥面板，脚本不会启动")
end

Patriot:Launch()
