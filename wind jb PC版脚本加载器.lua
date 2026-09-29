-- WindUI脚本加载器 | PC版
-- 功能：远程url加载 / 本地粘贴脚本 / 脚本列表管理 / 一键运行停止
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local getgenv = getgenv or function() return _G end
local genv = getgenv()

-- 存储脚本列表
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

local WindUILoader
-- 加载Patriot依赖库
local function LoadPatriotLib()
    local url = "https://raw.githubusercontent.com/jxndjdnjsnz/wind-JB/refs/heads/main/PatriotUi.luau.txt"
    local success, lib = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    if not success or not lib then
        warn("[WindUILoader] Patriot库加载失败！链接失效或网络问题")
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
        warn("[WindUILoader] WindUI库加载失败！")
        return nil
    end
    return lib
end

-- 执行远程脚本
local function RunRemoteScript(url)
    genv.WindUILoaderData.CurrentRunning = "remote:"..url
    local ok,err = pcall(function()
        local code = game:HttpGet(url)
        loadstring(code)()
    end)
    if not ok then
        warn("[RunRemoteScript]执行失败:",err)
        genv.WindUILoaderData.CurrentRunning = nil
    end
end

-- 执行本地代码字符串
local function RunLocalCode(codeStr)
    genv.WindUILoaderData.CurrentRunning = "local"
    local ok,err = pcall(function()
        loadstring(codeStr)()
    end)
    if not ok then
        warn("[RunLocalCode]执行失败:",err)
        genv.WindUILoaderData.CurrentRunning = nil
    end
end

-- 终止标记（很多脚本没有完整销毁逻辑，仅置标记，部分脚本仍残留）
local function StopCurrentScript()
    genv.WindUILoaderData.CurrentRunning = nil
    -- 清空全局残留变量
    genv.AddToArrayList = nil
    genv.RemoveFromArrayList = nil
    genv.UpdateModuleDisplay = nil
    print("[WindUILoader]已标记停止，部分脚本需要重进游戏彻底清除")
end

-- 构建加载器UI（使用WindUI自身做加载器面板）
local function BuildLoaderUI()
    local Patriot = LoadPatriotLib()
    if not Patriot then return end
    Patriot.Appearance.Title = "WindUI 脚本加载器"
    Patriot.Appearance.Subtitle = "脚本管理器"
    Patriot.Options.Keyless = true
    Patriot.Storage.Remember = false
    Patriot.Callbacks.OnSuccess = function()
        local WindUI = LoadWindUILib()
        if not WindUI then return end

        local MainWindow = WindUI:CreateWindow({
            Title = "WindUI脚本加载器",
            Icon = "folder-code",
            Author = "Loader",
            Folder = "WindUILoader",
            Size = UDim2.fromOffset(520,420),
            Transparent = true,
            Theme = "Dark"
        })

        local TabMain = MainWindow:Tab({Title="脚本管理",Icon="book"})
        local TabRemote = MainWindow:Tab({Title="远程URL",Icon="link"})
        local TabLocal = MainWindow:Tab({Title="本地代码",Icon="file-code"})

        -- =========== 脚本列表页 ===========
        TabMain:Section({Title="已保存脚本列表"})
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
            Title = "运行选中脚本",
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
                WindUI:Notify({Title="执行",Content="开始运行脚本 "..sel.Name,Icon="play"})
            end
        })

        TabMain:Button({
            Title = "停止当前脚本(标记)",
            Callback = function()
                StopCurrentScript()
                WindUI:Notify({Title="停止",Content="已标记停止脚本",Icon="stop-circle"})
            end
        })

        TabMain:Button({
            Title = "刷新脚本列表",
            Callback = function()
                local newNames = {}
                for _,v in ipairs(genv.WindUILoaderData.ScriptList) do
                    table.insert(newNames, v.Name)
                end
                scriptDropdown:Refresh(newNames)
            end
        })

        -- =========== 远程URL标签页 ===========
        TabRemote:Section({Title="远程脚本URL加载"})
        local urlInputValue = ""
        TabRemote:Input({
            Title = "脚本URL地址",
            Value = "",
            Callback = function(text)
                urlInputValue = text
            end
        })
        local saveRemoteName = ""
        TabRemote:Input({
            Title = "保存脚本命名",
            Value = "MyRemoteScript",
            Callback = function(text)
                saveRemoteName = text
            end
        })
        TabRemote:Button({
            Title = "直接运行该URL",
            Callback = function()
                if urlInputValue == "" then return end
                RunRemoteScript(urlInputValue)
                WindUI:Notify({Title="远程加载",Content="正在执行远程脚本",Icon="globe"})
            end
        })
        TabRemote:Button({
            Title = "保存到脚本列表",
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

        -- =========== 本地粘贴代码标签页 ===========
        TabLocal:Section({Title="粘贴Lua代码直接运行"})
        local localCode = ""
        TabLocal:MultilineInput({
            Title="粘贴脚本代码",
            Value="--在此粘贴完整wind‑jb或者其他WindUI脚本代码",
            Callback = function(text)
                localCode = text
            end
        })
        local localSaveName = ""
        TabLocal:Input({
            Title="本地脚本保存名字",
            Value="MyLocalScript",
            Callback = function(text)
                localSaveName = text
            end
        })
        TabLocal:Button({
            Title = "直接运行本地代码",
            Callback = function()
                if localCode == "" then return end
                RunLocalCode(localCode)
                WindUI:Notify({Title="本地执行",Content="运行粘贴的脚本",Icon="code"})
            end
        })
        TabLocal:Button({
            Title = "保存到脚本列表",
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
            print("[WindUILoader]加载器窗口关闭")
        end)
    end
    Patriot:Launch()
end

-- 启动加载器
BuildLoaderUI()
print("✅ WindUI脚本加载器已启动")
