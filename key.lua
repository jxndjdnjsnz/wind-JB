
local PATRIOT_RAW_URL = "https://raw.githubusercontent.com/jxndjdnjsnz/wind-JB/refs/heads/main/PatriotUi.luau.txt"
local SCRIPT_TITLE = "wind JB"
local DISCORD_LINK = "https://discord.gg/9178"
local GET_KEY_LINK = "https://你的域名.com"
local VERIFY_API_URL = "https://你的域名.com/api/verify"

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
    print("密钥校验成功，正在加载脚本...")
    local userKey = getgenv().SCRIPT_KEY
    print("用户使用的密钥: ", userKey)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/jxndjdnjsnz/wind-JB/refs/heads/main/wind%20JB.lua"))()
end

Patriot.Callbacks.OnVerify = function(inputKey)
    local HttpService = cloneref(game:GetService("HttpService"))
    local encodeKey = HttpService:UrlEncode(inputKey)
    local fullUrl = VERIFY_API_URL .. "?key=" .. encodeKey

    local ok, resp = pcall(function()
        return game:HttpGet(fullUrl)
    end)
    if not ok then
        warn("❌网络请求失败，无法连接密钥服务器")
        return false
    end

    local decodeOk, data = pcall(function()
        return HttpService:JSONDecode(resp)
    end)
    if not decodeOk then
        warn("❌服务器返回数据格式错误")
        return false
    end

    return data.valid == true
end

Patriot.Callbacks.OnFail = function(errMsg)
    warn("密钥验证失败: " .. tostring(errMsg))
end

Patriot.Callbacks.OnClose = function()
    print("用户关闭密钥面板，脚本不会启动")
end

Patriot:Launch()
