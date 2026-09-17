
local PATRIOT_RAW_URL = "https://github.com/SyndromeXph/Patriot-Key-System-Ui-Library"
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
    print("✅ 密钥校验成功，正在加载脚本...")
    local userKey = getgenv().SCRIPT_KEY
    print("用户使用的密钥: ", userKey)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/jxndjdnjsnz/wind-JB/refs/heads/main/wind%20JB.lua"))()
end

Patriot.Callbacks.OnVerify = function(inputKey)
    local validKeys = {
        "LUQENBINGSHIGAY",
        "820819QWE"
    }
    for _, k in ipairs(validKeys) do
        if inputKey == k then
            return true
        end
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
