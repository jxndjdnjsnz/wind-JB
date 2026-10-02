
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "Wind JB 加载器",
    Icon = "swords",
    Author = "Wind JB",
    Folder = "WindJBLoader",
    Size = UDim2.fromOffset(500, 350),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 180,
    ScrollBarEnabled = false,
})

local Tab = Window:Tab({
    Title = "脚本列表",
    Icon = "list",
})
Tab:Section({ Title = "选择一个脚本加载" })
local function loadScript(name, url)
    -- 显示正在加载的提示
    WindUI:Notify({
        Title = "Wind JB",
        Content = "正在加载: " .. name,
        Duration = 3,
        Icon = "loader",
    })

    local success, err = pcall(function()
        local code = game:HttpGet(url)
        if not code or #code < 10 then
            error("下载内容为空或过短")
        end
        local func = loadstring(code)
        if not func then
            error("编译失败")
        end
        func()
    end)

    if success then
        WindUI:Notify({
            Title = "Wind JB",
            Content = name .. " 加载成功！",
            Duration = 3,
            Icon = "check",
        })
    else
        WindUI:Notify({
            Title = "Wind JB - 错误",
            Content = name .. " 加载失败: " .. tostring(err),
            Duration = 5,
            Icon = "x",
        })
    end
end

Tab:Button({
    Title = "终极战场 (UBG)",
    Description = "需要输入密钥",
    Icon = "sword",
    Callback = function()
        loadScript(
            "终极战场",
            "https://raw.githubusercontent.com/jxndjdnjsnz/wind-JB/refs/heads/main/wind%20JB%20ubg.txt"
        )
    end,
})

Tab:Button({
    Title = "落叶 Pro",
    Description = "通用脚本",
    Icon = "crown",
    Callback = function()
        loadScript(
            "落叶 Pro",
            "https://raw.githubusercontent.com/SyndromeXph/Luoye-Pro-Hub/refs/heads/main/Script/%E9%80%9A%E7%94%A8.lua"
        )
    end,
})
Tab:Button({
    Title = "JB HUB (无密钥)",
    Description = "直接运行，无需密钥",
    Icon = "shield",
    Callback = function()
        loadScript(
            "JB HUB",
            "https://raw.githubusercontent.com/jxndjdnjsnz/wind-JB/refs/heads/main/Wind%20jb%20%E9%80%9A%E7%94%A8%E6%97%A0%E5%AF%86%E9%92%A5.lua"
        )
    end,
})
WindUI:Notify({
    Title = "Wind JB 加载器",
    Content = "加载器已就绪，请选择脚本。",
    Duration = 3,
    Icon = "check",
})