
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
    Tab:Section({Title = "请选择服务器"})
    Tab:Button({
        Title = "被遗弃",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/jxndjdnjsnz/wind-JB/refs/heads/main/wind%20jb%20.txt"))() 
        end
    })
    Tab:Button({
        Title = "UBG 终极战场",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/jxndjdnjsnz/wind-JB/refs/heads/main/wind%20JB%20ubg.txt"))() 
        end
    })
    ContyTab:Section({Title = "其他脚本"})
    ContyTab:Button({
        Title = "RB脚本付费版",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/jxndjdnjsnz/wind-JB/refs/heads/main/Rb%E8%84%9A%E6%9C%AC%E4%B8%AD%E5%BF%83%E6%BA%90%E7%A0%81.lua"))() 
        end
    })
    ContyTab:Button({
        Title = "xi pro",
        Callback = function()
            loadstring(request({Url = "https://raw.githubusercontent.com/Zer0neK/SB-Xi-pro/refs/heads/main/SBXiPro.lua"}).Body)()
        end
    })
    ContyTab:Button({
        Title = "XK旧版",
        Callback = function()
            loadstring(game:HttpGet(('https://github.com/devslopo/DVES/raw/main/XK%20Hub')))()
        end
    })
    ContyTab:Button({
        Title = "XKRemake",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/SyndromeXph/XK-Script/refs/heads/main/XoneK-Loader.luau"))()
        end
    })
    ContyTab:Button({
        Title = "XK测试版",
        Callback = function()
            loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/6c338d109dba8545edae479e7e2c793d.lua"))()
        end
    })
    Window:OnClose(function()
        antiAfkRunning = false
        if antiAfkConnection then
            antiAfkConnection:Disconnect()
            antiAfkConnection = nil
        end
    end)
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
