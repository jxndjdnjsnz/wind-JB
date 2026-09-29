-- WindUI脚本加载器【手机Mobile适配版】
-- 适配手机Roblox执行器，移除多行输入，缩小UI尺寸，触屏友好
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local getgenv = getgenv or function() return _G end
local genv = getgenv()

genv.WindUILoaderData = genv.WindUILoaderData or {
    ScriptList = {
        {
            Name = "Wind‑JB原版",
            Url = "https://raw.githubusercontent.com/jxndjdnjsnz/wind-JB/refs/heads/main/wind JB ubg.txt",
            IsRemote = true
        }
    },
    CurrentRunning = nil
}

-- 加载Patriot UI库
local function LoadPatriotLib()
    local url = "https://raw.githubusercontent.com/jxndjdnjsnz/wind-JB/refs/heads/main/PatriotUi.luau.txt"
    local success, lib = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    if not success or not lib then
        warn("[Mobile‑Loader] Patriot库加载失败！网络或raw链接问题")
        return nil
    end
    return lib
end

-- 加载WindUI库
local function LoadWindUILib()
    local url = "https://raw.githubusercontent.com/jxndjdnjsnz/wind-JB/refs/heads/main/UI.lua.txt"
    local success, lib = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    if not success or not lib then
        warn("[Mobile‑Loader] WindUI库加载失败！")
        return nil
    end
    return lib
end

-- 运行远程url脚本
local function RunRemoteScript(url)
    genv.WindUILoaderData.CurrentRunning = "remote:"..url
    local ok,err = pcall(function()
        local code = game:HttpGet(url)
        loadstring(code)()
    end)
    if not ok then
        warn("[RunRemoteScript]执行错误:",err)
        genv.WindUILoaderData.CurrentRunning = nil
    end
end

-- 运行本地代码字符串
local function RunLocalCode(codeStr)
    genv.WindUILoaderData.CurrentRunning = "local"
    local ok,err = pcall(function()
        loadstring(codeStr)()
    end)
    if not ok then
        warn("[RunLocalCode]执行错误:",err)
        genv.WindUILoaderData.CurrentRunning = nil
    end
end

-- 标记停止脚本（仅全局标记，无法彻底销毁，需要重进游戏）
local function StopCurrentScript()
    genv.WindUILoaderData.CurrentRunning = nil
    genv.AddToArrayList = nil
    genv.RemoveFromArrayList = nil
    genv.UpdateModuleDisplay = nil
    print("[Mobile‑Loader]已标记停止，重进游戏彻底清除残留")
end

local function BuildMobileLoaderUI()
    local Patriot = LoadPatriotLib()
    if not Patriot then return end

    Patriot.Appearance.Title = "WindUI加载器【手机版】"
    Patriot.Appearance.Subtitle = "触屏脚本管理器"
    Patriot.Options.Keyless = true
    Patriot.Storage.Remember = false
    Patriot.Options.Draggable = true
    Patriot.Callbacks.OnSuccess = function()
        local WindUI = LoadWindUILib()
        if not WindUI then return end

        -- 缩小窗口适配手机屏幕
        local MainWindow = WindUI:CreateWindow({
            Title = "WindUI加载器",
            Icon = "folder-code",
            Author = "Mobile",
            Folder = "WindUILoaderMobile",
            Size = UDim2.fromOffset(340,320),
            Transparent = true,
            Theme = "Dark",
            SideBarWidth = 110
        })

        local TabMain = MainWindow:Tab({Title="脚本列表",Icon="book"})
        local TabRemote = MainWindow:Tab({Title="远程URL",Icon="link"})
        local TabLocal = MainWindow:Tab({Title="本地代码",Icon="file-code"})

        -- ========= 脚本列表页面 =========
        TabMain:Section({Title="已保存脚本"})
        local scriptNameList = {}
        for _,item in ipairs(genv.WindUILoaderData.ScriptList) do
            table.insert(scriptNameList, item.Name)
        end

        local selectedScriptIndex = nil
        local scriptDropdown = TabMain:Dropdown({
            Title = "选择脚本",
            Values = scriptNameList,
            AllowNone = true,
            Callback = function(name)
                for i,v in ipairs(genv.WindUILoaderData.ScriptList) do
                    if v.Name == name then
                        selectedScriptIndex = i
                        break
                    end
                end
            end
        })

        TabMain:Button({
            Title = "▶运行选中",
            Callback = function()
                if not selectedScriptIndex then
                    WindUI:Notify({Title="提示",Content="请先选择脚本",Icon="alert-triangle"})
                    return
                end
                local sel = genv.WindUILoaderData.ScriptList[selectedScriptIndex]
                if sel.IsRemote then
                    RunRemoteScript(sel.Url)
                else
                    RunLocalCode(sel.Code)
                end
                WindUI:Notify({Title="执行",Content="运行: "..sel.Name,Icon="play"})
            end
        })

        TabMain:Button({
            Title = "⏹标记停止",
            Callback = function()
                StopCurrentScript()
                WindUI:Notify({Title="停止",Content="已标记停止脚本",Icon="stop-circle"})
            end
        })

        TabMain:Button({
            Title = "🔄刷新列表",
            Callback = function()
                local newNames = {}
                for _,v in ipairs(genv.WindUILoaderData.ScriptList) do
                    table.insert(newNames, v.Name)
                end
                scriptDropdown:Refresh(newNames)
            end
        })

        -- ========= 远程URL页面（手机推荐优先用这个） =========
        TabRemote:Section({Title="远程脚本URL【手机推荐】"})
        local urlInputValue = ""
        TabRemote:Input({
            Title = "脚本Raw链接",
            Value = "",
            Callback = function(text)
                urlInputValue = text
            end
        })
        local saveRemoteName = ""
        TabRemote:Input({
            Title = "保存脚本名字",
            Value = "MyScript",
            Callback = function(text)
                saveRemoteName = text
            end
        })

        TabRemote:Button({
            Title = "▶直接运行URL",
            Callback = function()
                if urlInputValue == "" then return end
                RunRemoteScript(urlInputValue)
                WindUI:Notify({Title="加载",Content="正在加载远程脚本",Icon="globe"})
            end
        })

        TabRemote:Button({
            Title = "💾保存到列表",
            Callback = function()
                if urlInputValue == "" or saveRemoteName == "" then return end
                table.insert(genv.WindUILoaderData.ScriptList,{
                    Name = saveRemoteName,
                    Url = urlInputValue,
                    IsRemote = true
                })
                WindUI:Notify({Title="保存成功",Content=saveRemoteName.."已加入列表",Icon="check"})
            end
        })

        -- ========= 本地代码页面（手机无多行输入，只适合小段代码） =========
        TabLocal:Section({Title="本地代码（仅小段代码）"})
        TabLocal:Section({Title="⚠️长脚本请上传gist/github用远程URL！"})
        local localCode = ""
        TabLocal:Input({
            Title = "粘贴Lua单行代码",
            Value = "",
            Callback = function(text)
                localCode = text
            end
        })
        local localSaveName = ""
        TabLocal:Input({
            Title = "脚本保存名字",
            Value = "LocalScript",
            Callback = function(text)
                localSaveName = text
            end
        })

        TabLocal:Button({
            Title = "▶运行本地代码",
            Callback = function()
                if localCode == "" then return end
                RunLocalCode(localCode)
                WindUI:Notify({Title="本地执行",Content="运行粘贴代码",Icon="code"})
            end
        })
        TabLocal:Button({
            Title = "💾保存到列表",
            Callback = function()
                if localCode == "" or localSaveName == "" then return end
                table.insert(genv.WindUILoaderData.ScriptList,{
                    Name = localSaveName,
                    Code = localCode,
                    IsRemote = false
                })
                WindUI:Notify({Title="保存成功",Content=localSaveName.."已加入列表",Icon="check"})
            end
        })

        MainWindow:OnClose(function()
            print("[Mobile‑Loader]窗口关闭")
        end
    end
    Patriot:Launch()
end

-- 启动手机版加载器
BuildMobileLoaderUI()
print("✅ WindUI手机版加载器启动完成")
