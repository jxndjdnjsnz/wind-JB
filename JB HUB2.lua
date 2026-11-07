local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "JB HUB",
    Icon = "zap",
    Theme = "Dark",
    Size = UDim2.fromOffset(520,380),
    Resizable = true
})

local TabMain = Window:CreateTab("主页", "home")
local TabSettings = Window:CreateTab("设置", "settings")

-- 按钮
TabMain:CreateButton("测试按钮", function()
    WindUI:Notify("提示","按钮已点击")
end)

-- 开关Toggle
local toggleVal = false
TabMain:CreateToggle("功能开关", false, function(v)
    toggleVal = v
end)

-- 滑块Slider
TabMain:CreateSlider("移动速度", 16, 100, 16, function(v)
    print("Speed:",v)
end)

-- 下拉选择Dropdown
TabMain:CreateDropdown("选择选项", {"A","B","C"}, function(v)
    print("选中:",v)
end)

-- 输入框
TabMain:CreateInput("输入内容", "", function(v)
    print("输入：",v)
end)

-- 按键绑定
TabSettings:CreateKeybind("UI开关", Enum.KeyCode.RightControl, function()
    Window:Toggle()
end)

-- 标签文本
TabSettings:CreateLabel("WindUI Template")
