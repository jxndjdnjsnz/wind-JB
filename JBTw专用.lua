local WasUIPro = loadstring(game:HttpGet("https://github.com/WasKKal/WasUI-For-Roblox/raw/refs/heads/main/WasUIPro.lua"))()
local VirtualUserService = game:GetService("VirtualUser")
local Uis = game:GetService("UserInputService")
local Players = game:GetService("Players")

WasUIPro:SetDefaultTheme("Dark")
WasUIPro:SetDefaultRainbowMode("流动")
WasUIPro:SetLanguage("中文") 

local mainWindow = WasUIPro:CreateWindow({
    Title = "WasUIPro 完整演示",
    WelcomeText = "展示所有控件及动态功能",
    MinimizedText = "WasUIPro",
    Theme = "Dark",
    RainbowMode = "流动",
    DialogTitle = "确认关闭窗口",
    GroupText = "加入交流群",
    GroupCopy = "1070641947", 
    SnowEnabled = true,
    Background = "rbxassetid://1234567890",
    Folder = "WasUIPro_JB",
    TitleTag = {
        { text = "Demo", backgroundColor = Color3.fromRGB(0,152,211), textColor = Color3.fromRGB(255,255,255) },
        { text = "NEW", backgroundColor = Color3.fromRGB(255,80,80), textColor = Color3.fromRGB(255,255,255) }
    },
    FrameColor = nil,
--[[
    {
    Color3.fromRGB(255, 100, 100),
    Color3.fromRGB(100, 255, 100),
    Color3.fromRGB(100, 100, 255)
    },
    ]]
    FeatureNameColor = {Color3.fromRGB(255, 100, 200), Color3.fromRGB(255, 150, 50)}
})

task.spawn(function()
    task.wait(0.5)
    WasUIPro:Popup({
        title = "公告",
        titleIcon = "sparkles",
        content = "该脚本为旧版本,新版本已切换至wind ui,点击收到切换至新版本脚本",
        confirmText = "收到",
        onConfirm = function()
             loadstring(https://raw.githubusercontent.com/jxndjdnjsnz/wind-JB/refs/heads/main/key.lua"))()
        end
    })
end)

WasUIPro:Notify({ Title = "初始化", Content = "WasUIPro 示例加载完成", Duration = 4 })
