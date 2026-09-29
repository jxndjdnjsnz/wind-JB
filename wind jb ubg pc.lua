-- wind‑JB 电脑适配版
local PATRIOT_RAW_URL = "https://raw.githubusercontent.com/jxndjdnjsnz/wind-JB/refs/heads/main/PatriotUi.luau.txt"
local SCRIPT_TITLE = "wind JB [PC适配版]"
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
Patriot.Callbacks.OnSuccess = function()
    local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/jxndjdnjsnz/wind-JB/refs/heads/main/UI.lua.txt"))()
    local _env = (getgenv and getgenv()) or _G
    _env.AddToArrayList = _env.AddToArrayList or function() end
    _env.RemoveFromArrayList = _env.RemoveFromArrayList or function() end
    _env.UpdateModuleDisplay = _env.UpdateModuleDisplay or function() end
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local RunService = game:GetService("RunService")
    local VirtualUser = game:GetService("VirtualUser")
    local UserInputService = game:GetService("UserInputService")
    local localPlayer = Players.LocalPlayer
    local cooldownActive = false
    local cooldownTime = 3
    local antiAfkRunning = false
    local antiAfkConnection = nil
    local Window = WindUI:CreateWindow({
        Title = "wind JB [PC适配版]",
        Icon = "swords",
        Author = "终极战场",
        Folder = "WindJB",
        Size = UDim2.fromOffset(500, 400),
        Transparent = true,
        Theme = "Light",
        SideBarWidth = 200,
        ScrollBarEnabled = true,
    })
    local TabOther = Window:Tab({
        Title = "挂机防踢",
        Icon = "shield",
        Locked = false,
    })
    TabOther:Section({ Title = "挂机防踢" })
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
    local TimeTag = Window:Tag({
        Title = "--:--",
        Radius = 999,
        Color = Color3.fromRGB(255, 255, 255),
    })
    task.spawn(function()
        while true do
            local now = os.date("*t")
            local hours = string.format("%02d", now.hour)
            local minutes = string.format("%02d", now.min)
            TimeTag:SetTitle(hours .. ":" .. minutes)
            task.wait(0.06)
        end
    end)
    local Tab = Window:Tab({
        Title = "主要功能",
        Icon = "sword",
        Locked = false,
    })
    Tab:Button({
        Flag = "1",
        Title = "篡改",
        Desc = "玩的时候第一先开启这个功能",
        Callback = function()
            pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/dream77239/ubg-script/refs/heads/main/%E6%8B%A6%E6%88%AA.txt"))()
            end)
        end
    })
local fakeBlockEnabled = false
local loopRunning = false
Tab:Toggle({
    Flag = "2",
    Title = "假防(关闭功能后按一次防御即可取消假防)",
    Value = false,
    Callback = function(state)
        if state then AddToArrayList("假防") else RemoveFromArrayList("假防") end
        fakeBlockEnabled = state
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local BlockRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Combat"):WaitForChild("Block")
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local function enableBlock()
            pcall(function()
                BlockRemote:FireServer(true)
            end)
        end
        if fakeBlockEnabled then
            enableBlock()
        end
        if not loopRunning then
            loopRunning = true
            task.spawn(function()
                while true do
                    task.wait(0.01)
                    if fakeBlockEnabled then
                        local success, isBlocking = pcall(function()
                            return character:GetAttribute("IsBlocking")
                        end)
                        if success and not isBlocking then
                            enableBlock()
                        end
                        -- 角色刷新重新获取
                        if not character or not character.Parent then
                            character = player.Character or player.CharacterAdded:Wait()
                        end
                    end
                end
            end)
        end
    end
})
local defaultCooldown = game:GetService("ReplicatedStorage").Settings.Cooldowns.Dash.Value
Tab:Toggle({
    Flag = "3",
    Title = "侧闪无冷却",
    Value = false,
    Callback = function(state)
        if state then AddToArrayList("侧闪无冷却") else RemoveFromArrayList("侧闪无冷却") end
        local dashCooldown = game:GetService("ReplicatedStorage").Settings.Cooldowns.Dash
        if state then
            dashCooldown.Value = 1
        else
            dashCooldown.Value = defaultCooldown
        end
    end
})
local defaultMeleeCooldown = game:GetService("ReplicatedStorage").Settings.Cooldowns.Melee.Value
Tab:Toggle({
    Flag = "4",
    Title = "近战无冷却",
    Value = false,
    Callback = function(state)
        if state then AddToArrayList("近战无冷却") else RemoveFromArrayList("近战无冷却") end
        local meleeCooldown = game:GetService("ReplicatedStorage").Settings.Cooldowns.Melee
        if state then
            meleeCooldown.Value = 1
        else
            meleeCooldown.Value = defaultMeleeCooldown
        end
    end
})
local rs = game:GetService("ReplicatedStorage")
local settings = rs.Settings
local defaultAbility = settings.Cooldowns.Ability.Value
Tab:Toggle({
    Flag = "5",
    Title = "技能无冷却(仅宿傩角色)",
    Value = false,
    Callback = function(state)
        if state then AddToArrayList("技能无冷却") else RemoveFromArrayList("技能无冷却") end
        settings.Cooldowns.Ability.Value = state and 1 or defaultAbility
    end
})
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage.Remotes
local Combat = Remotes.Combat
local EmoteClaim = Combat.EmoteClaim
local emoteClaimActive = false
local emoteClaimConnection = nil
local function startEmoteClaim()
    emoteClaimConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if emoteClaimActive then
            EmoteClaim:FireServer()
        end
    end)
end
local function stopEmoteClaim()
    if emoteClaimConnection then
        emoteClaimConnection:Disconnect()
        emoteClaimConnection = nil
    end
end
Tab:Toggle({
    Flag = "6",
    Title = "自动签到表情",
    Value = false,
    Callback = function(state)
        if state then AddToArrayList("自动签到表情") else RemoveFromArrayList("自动签到表情") end
        emoteClaimActive = state
        if state then
            startEmoteClaim()
        else
            stopEmoteClaim()
        end
    end
})
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local noSlowdownsToggle = ReplicatedStorage.Settings.Toggles.NoSlowdowns
local defaultValue = false
Tab:Toggle({
    Flag = "7",
    Title = "无减速效果",
    Value = noSlowdownsToggle.Value,
    Callback = function(state)
        if state then AddToArrayList("无减速") else RemoveFromArrayList("无减速") end
        if state then
            noSlowdownsToggle.Value = true
        else
            noSlowdownsToggle.Value = defaultValue
        end
    end
})
local defaultDisableHitStun = settings.Toggles.DisableHitStun.Value
Tab:Toggle({
    Flag = "8",
    Title = "取消被攻击硬直",
    Value = false,
    Callback = function(state)
        if state then AddToArrayList("取消硬直") else RemoveFromArrayList("取消硬直") end
        settings.Toggles.DisableHitStun.Value = state
    end
})
local defaultDisableIntros = settings.Toggles.DisableIntros.Value
Tab:Toggle({
    Flag = "9",
    Title = "跳过角色开场动作",
    Value = false,
    Callback = function(state)
        if state then AddToArrayList("跳过开场") else RemoveFromArrayList("跳过开场") end
        settings.Toggles.DisableIntros.Value = state
    end
})
local defaultNoStunOnMiss = settings.Toggles.NoStunOnMiss.Value
Tab:Toggle({
    Flag = "10",
    Title = "普攻无僵直",
    Value = false,
    Callback = function(state)
        if state then AddToArrayList("普攻无僵直") else RemoveFromArrayList("普攻无僵直") end
        settings.Toggles.NoStunOnMiss.Value = state
    end
})
local defaultRagdollTimer = settings.Multipliers.RagdollTimer.Value
Tab:Toggle({
    Flag = "11",
    Title = "被别人击倒不会变成布娃娃",
    Value = false,
    Callback = function(state)
        if state then AddToArrayList("防布娃娃") else RemoveFromArrayList("防布娃娃") end
        settings.Multipliers.RagdollTimer.Value = state and 0.5 or defaultRagdollTimer
    end
})
local defaultUltimateTimer = settings.Multipliers.UltimateTimer.Value
Tab:Toggle({
    Flag = "12",
    Title = "延长大招时间",
    Value = false,
    Callback = function(state)
        if state then AddToArrayList("无限大招") else RemoveFromArrayList("无限大招") end
        settings.Multipliers.UltimateTimer.Value = state and 100000 or defaultUltimateTimer
    end
})
local defaultInstantTransformation = settings.Toggles.InstantTransformation.Value
Tab:Toggle({
    Flag = "13",
    Title = "秒开大",
    Value = false,
    Callback = function(state)
        if state then AddToArrayList("秒开大") else RemoveFromArrayList("秒开大") end
        settings.Toggles.InstantTransformation.Value = state
    end
})
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local Ping = player:WaitForChild("Info"):WaitForChild("Ping")
local loop
Tab:Toggle({
    Flag = "14",
    Title = "ping乱码",
    Value = false,
    Callback = function(state)
        if state then AddToArrayList("Ping乱码") else RemoveFromArrayList("Ping乱码") end
        if state then
            loop = task.spawn(function()
                while state do
                    for i = 0, 999, 25 do
                        if not state then break end
                        Ping.Value = i
                        task.wait(0.03)
                    end
                    for i = 999, 0, -25 do
                        if not state then break end
                        Ping.Value = i
                        task.wait(0.03)
                    end
                end
            end)
        else
            if loop then
                task.cancel(loop)
                loop = nil
            end
        end
    end
})
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MeleeDamage = ReplicatedStorage:WaitForChild("Settings"):WaitForChild("Multipliers"):WaitForChild("MeleeDamage")
MeleeDamage.Value = 100
Tab:Toggle({
    Flag = "15",
    Title = "一拳倒地",
    Value = false,
    Callback = function(state)
        if state then AddToArrayList("一拳倒地") else RemoveFromArrayList("一拳倒地") end
        if state then
            MeleeDamage.Value = 1000000
        else
            MeleeDamage.Value = 100
        end
    end
})
Tab:Toggle({
    Flag = "16",
    Title = "一拳击飞",
    Value = false,
    Callback = function(state)
        if state then AddToArrayList("一拳击飞") else RemoveFromArrayList("一拳击飞") end
        local Players = game:GetService("Players")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local RunService = game:GetService("RunService")
        local LocalPlayer = Players.LocalPlayer
        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
        local RagdollPower = ReplicatedStorage:WaitForChild("Settings"):WaitForChild("Multipliers"):WaitForChild("RagdollPower")
        local maxTeleportDistance = 50
        local lastPosition = HumanoidRootPart.Position
        local connection
        if state then
            RagdollPower.Value = 10000
            connection = RunService.RenderStepped:Connect(function()
                
                if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
                    lastPosition = HumanoidRootPart.Position
                end
                local currentPos = HumanoidRootPart.Position
                local distance = (currentPos - lastPosition).Magnitude
                if distance > maxTeleportDistance then
                    HumanoidRootPart.CFrame = CFrame.new(lastPosition)
                else
                    lastPosition = currentPos
                end
            end)
        else
            RagdollPower.Value = 100
            if connection then
                connection:Disconnect()
                connection = nil
            end
        end
    end
})
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local wallCombo = ReplicatedStorage.Settings.Cooldowns.WallCombo
Tab:Toggle({
    Flag = "17",
    Title = "墙打无冷却",
    Value = false,
    Callback = function(state)
        if state then AddToArrayList("墙打无冷却") else RemoveFromArrayList("墙打无冷却") end
        if state then
            wallCombo.Value = 0
            print("WallCombo cooldown set to 0")
        else
            wallCombo.Value = 100
            print("WallCombo cooldown reset to 100")
        end
    end
})
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local wall = nil
pcall(function()
    wall = workspace.Map.Structural.Terrain:GetChildren()[5]:GetChildren()[12]
end)
if not wall then
    wall = Instance.new("Part")
    wall.Parent = workspace
end
wall.Size = Vector3.new(12,6,2)
wall.Transparency = 0.6
wall.Material = Enum.Material.SmoothPlastic
wall.Anchored = true
wall.CanCollide = true
wall.CFrame = wall.CFrame or CFrame.new(0,5,0)
if getconnections then
    for _, conn in pairs(getconnections(wall.AncestryChanged)) do
        conn:Disable()
    end
end
local mt = getrawmetatable(game)
setreadonly(mt,false)
local old = mt.__namecall
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if self == wall and method == "Destroy" then
        return
    end
    return old(self, ...)
end)
setreadonly(mt,true)
local followConnection = nil
Tab:Toggle({
    Flag = "18",
    Title = "随处墙打",
    Value = false,
    Callback = function(state)
        if state then AddToArrayList("随处墙打") else RemoveFromArrayList("随处墙打") end
        if state then
            if not followConnection then
                followConnection = RunService.RenderStepped:Connect(function()
                    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        wall.CFrame = hrp.CFrame * CFrame.new(0,0,-8)
                    end
                end)
            end
        else
            if followConnection then
                followConnection:Disconnect()
                followConnection = nil
            end
        end
    end
})
local originalData = {}
local skyBackup = nil
Tab:Toggle({
    Flag = "19",
    Title = "防卡",
    Value = false,
    Callback = function(state)
        if state then AddToArrayList("防卡") else RemoveFromArrayList("防卡") end
        if state then
            originalData = {}
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Explosion") then
                    originalData[v] = v.Enabled
                    v.Enabled = false
                elseif v:IsA("Decal") or v:IsA("Texture") then
                    originalData[v] = v.Transparency
                    v.Transparency = 1
                elseif v:IsA("MeshPart") or v:IsA("UnionOperation") or v:IsA("Part") then
                    if v.Name ~= "HumanoidRootPart" then
                        originalData[v] = v.Material
                        v.Material = Enum.Material.SmoothPlastic
                    end
                elseif v:IsA("SurfaceGui") or v:IsA("BillboardGui") or v:IsA("Beam") then
                    if v:IsA("Beam") then
                        originalData[v] = v.Enabled
                        v.Enabled = false
                    else
                        originalData[v] = v.Enabled ~= nil and v.Enabled or true
                        if v.Enabled ~= nil then
                            v.Enabled = false
                        end
                    end
                end
            end
            originalData["GlobalShadows"] = game.Lighting.GlobalShadows
            originalData["FogEnd"] = game.Lighting.FogEnd
            game.Lighting.GlobalShadows = false
            game.Lighting.FogEnd = 9e9
            local sky = game.Lighting:FindFirstChildOfClass("Sky")
            if sky then
                skyBackup = sky:Clone()
                sky:Destroy()
            end
            local newSky = Instance.new("Sky")
            newSky.SkyboxBk = ""
            newSky.SkyboxDn = ""
            newSky.SkyboxFt = ""
            newSky.SkyboxLf = ""
            newSky.SkyboxRt = ""
            newSky.SkyboxUp = ""
            newSky.SunAngularSize = 0
            newSky.MoonAngularSize = 0
            newSky.Parent = game.Lighting
            game.Lighting.Ambient = Color3.fromRGB(128,128,128)
            game.Lighting.OutdoorAmbient = Color3.fromRGB(128,128,128)
        else
            for obj, value in pairs(originalData) do
                if typeof(obj) == "Instance" and obj.Parent then
                    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Explosion") then
                        obj.Enabled = value
                    elseif obj:IsA("Decal") or obj:IsA("Texture") then
                        obj.Transparency = value
                    elseif obj:IsA("MeshPart") or obj:IsA("UnionOperation") or obj:IsA("Part") then
                        obj.Material = value
                    elseif obj:IsA("SurfaceGui") or obj:IsA("BillboardGui") or obj:IsA("Beam") then
                        if obj:IsA("Beam") then
                            obj.Enabled = value
                        elseif obj.Enabled ~= nil then
                            obj.Enabled = value
                        end
                    end
                elseif obj == "GlobalShadows" then
                    game.Lighting.GlobalShadows = value
                elseif obj == "FogEnd" then
                    game.Lighting.FogEnd = value
                end
            end
            if skyBackup then
                local currentSky = game.Lighting:FindFirstChildOfClass("Sky")
                if currentSky then
                    currentSky:Destroy()
                end
                skyBackup.Parent = game.Lighting
                skyBackup = nil
            end
            originalData = {}
        end
    end
})
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Camera = workspace.CurrentCamera
local clone, platform, originalCFrame, originalCameraSubject
local function CreatePlatform(position)
    local part = Instance.new("Part")
    part.Size = Vector3.new(10, 1, 10)
    part.Position = position - Vector3.new(0, 3, 0)
    part.Anchored = true
    part.CanCollide = true
    part.Transparency = 0.5
    part.Parent = workspace
    return part
end
local function CreateClone()
    local newClone = Character:Clone()
    for _, v in ipairs(newClone:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Transparency = 0.5
        end
    end
    newClone.Parent = workspace
    return newClone
end
local function ToggleInvisibility(state)
    Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    if state then
        originalCFrame = HumanoidRootPart.CFrame
        HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + Vector3.new(0, -50, 0)
        platform = CreatePlatform(HumanoidRootPart.Position)
        
        task.wait(1)
        
        clone = CreateClone()
        clone:MoveTo(originalCFrame.Position)
        Camera.CameraSubject = clone:FindFirstChildWhichIsA("Humanoid")
        LocalPlayer.Character = clone
    else
        if clone then
            clone:Destroy()
            clone = nil
        end
        
        if platform then
            platform:Destroy()
            platform = nil
        end
        
        if originalCFrame then
            HumanoidRootPart.CFrame = originalCFrame
            originalCFrame = nil
        end
        
        Camera.CameraSubject = Character:FindFirstChildWhichIsA("Humanoid")
        LocalPlayer.Character = Character
    end
end
Tab:Toggle({
    Flag = "20",
    Title = "隐身",
    Value = false,
    Callback = function(state)
        if state then AddToArrayList("隐身") else RemoveFromArrayList("隐身") end
        ToggleInvisibility(state)
    end
})
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local CircleParts = {}
local Connection
local function RainbowColor(t)
    local r = math.sin(t) * 40 + 180
    local g = math.sin(t + 2) * 40 + 180
    local b = math.sin(t + 4) * 40 + 180
    return Color3.fromRGB(r, g, b)
end
Tab:Toggle({
    Flag = "27",
    Title = "墙打/杀戮光环范围显示",
    Value = false,
    Callback = function(state)
        if state then AddToArrayList("范围显示") else RemoveFromArrayList("范围显示") end
        local function CreateCircle(radius, segments, thickness)
            local parts = {}
            for i = 1, segments do
                local part = Instance.new("Part")
                part.Anchored = true
                part.CanCollide = false
                part.Material = Enum.Material.Neon
                part.Size = Vector3.new(thickness, 0.2, radius * 2 * math.pi / segments)
                part.Color = Color3.fromRGB(180,180,180)
                part.Parent = workspace
                table.insert(parts, part)
            end
            return parts
        end
        local function DestroyCircle()
            if Connection then
                Connection:Disconnect()
                Connection = nil
            end
            for _, part in ipairs(CircleParts) do
                if part and part.Parent then
                    part:Destroy()
                end
            end
            CircleParts = {}
        end
        if state then
            DestroyCircle()
            local radius = 60
            local segments = 60
            local thickness = 0.2
            CircleParts = CreateCircle(radius, segments, thickness)
            local time = 0
            local updateAccumulator = 0
            local updateRate = 1/60
            Connection = RunService.RenderStepped:Connect(function(dt)
                time = time + dt
                updateAccumulator = updateAccumulator + dt
                if updateAccumulator < updateRate then return end
                updateAccumulator = 0
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local rootPos = char.HumanoidRootPart.Position
                    local humanoid = char:FindFirstChild("Humanoid")
                    local heightOffset = humanoid and humanoid.HipHeight / 2 + 0.1 or 0.9 
                    local pos = rootPos - Vector3.new(0, heightOffset, 0)
                    for i, part in ipairs(CircleParts) do
                        local angle = (i / #CircleParts) * 2 * math.pi
                        local x = pos.X + math.cos(angle) * radius
                        local z = pos.Z + math.sin(angle) * radius
                        part.Position = Vector3.new(x, pos.Y, z)
                        part.Orientation = Vector3.new(0, -math.deg(angle), 0)
                        part.Color = RainbowColor(time + i * 0.1)
                    end
                end
            end)
        else
            DestroyCircle()
        end
    end
})
Tab:Button({
    Flag = "28",
    Title = "删除墙打特效",
    Desc = "点了该功能就无法恢复墙打特效",
    Callback = function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local paths = {
            ReplicatedStorage.Characters.Gon.WallCombo.GonWallCombo.Center,
            ReplicatedStorage.Characters.Gon.WallCombo.GonWallCombo.Explosion,
            ReplicatedStorage.Characters.Gon.WallCombo.GonIntroHands,
            ReplicatedStorage.Characters.Mob.WallCombo.MobWallCombo.Center,
            ReplicatedStorage.Characters.Nanami.WallCombo.NanamiWallCombo.Center,
            ReplicatedStorage.Characters.Stark.WallCombo.StarkWallCombo.Center,
            ReplicatedStorage.Characters.Sukuna.WallCombo.SukunaTransformWallCombo,
            ReplicatedStorage.Characters.Sukuna.WallCombo.SukunaWallCombo
        }
        for _, obj in ipairs(paths) do
            if obj and obj:IsA("Instance") then
                for _, child in ipairs(obj:GetChildren()) do
                    child:Destroy()
                end
            end
        end
    end
})
Tab:Button({
    Flag = "29",
    Title = "删除击杀表情特效",
    Desc = "点击删除击杀表情的部分特效,不可恢复",
    Callback = function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local KillEmote = ReplicatedStorage:WaitForChild("Cosmetics"):WaitForChild("KillEmote")
        local function removeEffects(obj)
            for _, child in ipairs(obj:GetChildren()) do
                if child:IsA("ParticleEmitter") 
                or child:IsA("Trail") 
                or child:IsA("Beam") 
                or child:IsA("Fire") 
                or child:IsA("Smoke") 
                or child:IsA("Sparkles") 
                or child:IsA("Light") then
                    child:Destroy()
                else
                    removeEffects(child)
                end
            end
        end
        removeEffects(KillEmote)
        print("KillEmote 特效已删除（保留本体）")
    end
})
 local ReplicatedStorage = game:GetService("ReplicatedStorage")
local multiUseCutscenesToggle = ReplicatedStorage.Settings.Toggles.MultiUseCutscenes
local defaultValue = false
Tab:Toggle({
    Flag = "30",
    Title = "艾斯帕大招技能多次使用(全角色通用)",
    Value = multiUseCutscenesToggle.Value,
    Callback = function(state)
        if state then AddToArrayList("大招多次使用") else RemoveFromArrayList("大招多次使用") end
        if state then
            multiUseCutscenesToggle.Value = true
        else
            multiUseCutscenesToggle.Value = defaultValue
        end
    end
})
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local QEfly = true
local FLYING = false
local flyKeyDown, flyKeyUp
local iyflyspeed = 2
local vehicleflyspeed = 2
local function getRoot(char)
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
end
local function NOFLY()
    FLYING = false
    if flyKeyDown then flyKeyDown:Disconnect() flyKeyDown = nil end
    if flyKeyUp then flyKeyUp:Disconnect() flyKeyUp = nil end
    local char = LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        local root = getRoot(char)
        if humanoid then humanoid.PlatformStand = false end
        if root then
            for _, v in pairs(root:GetChildren()) do
                if v:IsA("BodyGyro") or v:IsA("BodyVelocity") then
                    v:Destroy()
                end
            end
        end
    end
    pcall(function()
        workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
    end)
end
local function sFLY(vfly)
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid")
    local root = getRoot(char)
    if flyKeyDown then flyKeyDown:Disconnect() end
    if flyKeyUp then flyKeyUp:Disconnect() end
    local CONTROL = {F=0,B=0,L=0,R=0,Q=0,E=0}
    local BG = Instance.new("BodyGyro")
    local BV = Instance.new("BodyVelocity")
    BG.P = 9e4
    BG.MaxTorque = Vector3.new(9e9,9e9,9e9)
    BG.CFrame = root.CFrame
    BG.Parent = root
    BV.MaxForce = Vector3.new(9e9,9e9,9e9)
    BV.Velocity = Vector3.new(0,0,0)
    BV.Parent = root
    FLYING = true
    flyKeyDown = UserInputService.InputBegan:Connect(function(input,gp)
        if gp then return end
        if input.UserInputType == Enum.UserInputType.Keyboard then
            if input.KeyCode == Enum.KeyCode.W then CONTROL.F = iyflyspeed end
            if input.KeyCode == Enum.KeyCode.S then CONTROL.B = -iyflyspeed end
            if input.KeyCode == Enum.KeyCode.A then CONTROL.L = -iyflyspeed end
            if input.KeyCode == Enum.KeyCode.D then CONTROL.R = iyflyspeed end
            if input.KeyCode == Enum.KeyCode.E and QEfly then CONTROL.Q = iyflyspeed*2 end
            if input.KeyCode == Enum.KeyCode.Q and QEfly then CONTROL.E = -iyflyspeed*2 end
        end
    end)
    flyKeyUp = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            if input.KeyCode == Enum.KeyCode.W then CONTROL.F = 0 end
            if input.KeyCode == Enum.KeyCode.S then CONTROL.B = 0 end
            if input.KeyCode == Enum.KeyCode.A then CONTROL.L = 0 end
            if input.KeyCode == Enum.KeyCode.D then CONTROL.R = 0 end
            if input.KeyCode == Enum.KeyCode.E then CONTROL.Q = 0 end
            if input.KeyCode == Enum.KeyCode.Q then CONTROL.E = 0 end
        end
    end)
    task.spawn(function()
        while FLYING do
            task.RenderStepped:Wait()
            local camera = workspace.CurrentCamera
            local moveVector = Vector3.new(CONTROL.L+CONTROL.R, CONTROL.Q+CONTROL.E, CONTROL.F+CONTROL.B)
            local ok, controlModule = pcall(function()
                return require(LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
            end)
            if ok and controlModule then
                local mv = controlModule:GetMoveVector()
                moveVector = Vector3.new(mv.X*(vfly and vehicleflyspeed or iyflyspeed), moveVector.Y, -mv.Z*(vfly and vehicleflyspeed or iyflyspeed))
            end
            BV.Velocity = (camera.CFrame.RightVector*moveVector.X + Vector3.new(0,moveVector.Y,0) + camera.CFrame.LookVector*moveVector.Z)*50
            BG.CFrame = camera.CFrame
            humanoid.PlatformStand = true
        end
    end)
end
local function applyFly()
    sFLY()
    LocalPlayer.CharacterAdded:Connect(function()
        if FLY_TOGGLE_STATE then
            task.wait(0.5)
            sFLY()
        end
    end)
end
local FLY_TOGGLE_STATE = false
Tab:Toggle({
    Flag = "31",
    Title = "飞行",
    Value = false,
    Callback = function(state)
        FLY_TOGGLE_STATE = state
        if state then AddToArrayList("飞行", iyflyspeed) else RemoveFromArrayList("飞行") end
        if state then
            applyFly()
        else
            NOFLY()
        end
    end
})
Tab:Slider({
    Flag = "32",
    Title = "飞行速度",
    Value = {
        Min = 1,
        Max = 10,
        Default = 2
    },
    Callback = function(value)
        iyflyspeed = value
        vehicleflyspeed = value
        if FLY_TOGGLE_STATE then UpdateModuleDisplay("飞行", value) end
    end
})
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local tpwalking = false
local tpwalkSpeed = 100
Tab:Toggle({
    Flag = "33",
    Title = "速度",
    Value = false,
    Callback = function(state)
        tpwalking = state
        if state then AddToArrayList("速度", tpwalkSpeed) else RemoveFromArrayList("速度") end
        if state then
            spawn(function()
                while tpwalking do
                    local chr = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                    local hrp = chr:FindFirstChild("HumanoidRootPart")
                    local hum = chr:FindFirstChildWhichIsA("Humanoid")
                    local delta = RunService.Heartbeat:Wait()
                    if hrp and hum and hum.MoveDirection.Magnitude > 0 then
                        hrp.CFrame = hrp.CFrame + (hum.MoveDirection * tpwalkSpeed * delta)
                    end
                end
            end)
        end
    end
})
Tab:Slider({
    Flag = "34",
    Title = "速度调节",
    Value = {
        Min = 0,
        Max = 250,
        Default = tpwalkSpeed,
    },
    Callback = function(value)
        tpwalkSpeed = value
        if tpwalking then UpdateModuleDisplay("速度", value) end
    end
})
Tab:Slider({
    Flag = "35",
    Title = "冲刺加速(默认值100)",
    Value = {
        Min = 0,
        Max = 1000,
        Default = 100,
    },
    Callback = function(value)
        game:GetService("ReplicatedStorage").Settings.Multipliers.DashSpeed.Value = value
    end
})
Tab:Slider({
    Flag = "36",
    Title = "跳跃增强(默认值100)",
    Value = {
        Min = 0,
        Max = 1000,
        Default = 100,
    },
    Callback = function(value)
        game:GetService("ReplicatedStorage").Settings.Multipliers.JumpHeight.Value = value
    end
})
Tab:Slider({
    Flag = "37",
    Title = "攻击加速(默认值100)",
    Value = {
        Min = 0,
        Max = 1000,
        Default = 100,
    },
    Callback = function(value)
        game:GetService("ReplicatedStorage").Settings.Multipliers.MeleeSpeed.Value = value
    end
})
local Tab = Window:Tab({  
    Title = "暴力功能",  
    Icon = "hand-fist",  
    Locked = false,
})
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local active = false
local function getLocalPlayerCharacter()
    return LocalPlayer.Character
end
local function generateActionNumber()
    return "Action" .. math.random(1000, 9999)
end
local function getServerTime()
    return tick()
end
local function wallcomboveryud()
    local playerChar = getLocalPlayerCharacter()
    if not playerChar then return false end
    local head = playerChar:FindFirstChild("Head")
    if not head then return false end
    local charData = LocalPlayer:FindFirstChild("Data")
    local charValue = charData and charData:FindFirstChild("Character") and charData.Character.Value
    if not charValue then return false end
    local charsFolder = ReplicatedStorage:FindFirstChild("Characters")
    if not charsFolder or not charsFolder:FindFirstChild(charValue) then return false end
    local wallComboAbility = charsFolder[charValue]:FindFirstChild("WallCombo")
    if not wallComboAbility then return false end
    local targetCharacter = playerChar
    if not targetCharacter then return false end
    local actionNumber = generateActionNumber()
    local serverTime = getServerTime()
    local randomId = math.random(100000, 999999)
    local remoteArgs = {
        wallComboAbility,
        "Characters:" .. charValue .. ":WallCombo",
        1,
        randomId,
        {
            HitboxCFrames = {nil},
            BestHitCharacter = targetCharacter,
            HitCharacters = {targetCharacter},
            Ignore = {[actionNumber] = {targetCharacter}},
            DeathInfo = {},
            Actions = {[actionNumber] = {}},
            HitInfo = {
                Blocked = false,
                IsFacing = true,
                IsInFront = true
            },
            BlockedCharacters = {},
            ServerTime = serverTime,
            FromCFrame = nil
        },
        actionNumber
    }
    pcall(function()
        ReplicatedStorage.Remotes.Abilities.Ability:FireServer(wallComboAbility, randomId)
    end)
    pcall(function()
        ReplicatedStorage.Remotes.Combat.Action:FireServer(unpack(remoteArgs))
    end)
end
task.spawn(function()
    while task.wait(0.01) do
        if active then
            pcall(wallcomboveryud)
        end
    end
end)
Tab:Toggle({
    Flag = "21",
    Title = "无敌",
    Value = false,
    Callback = function(state)
        if state then AddToArrayList("无敌") else RemoveFromArrayList("无敌") end
        active = state
    end
})
Tab:Button({
    Flag = "22",
    Title = "卡服",
    Callback = function()
        local Players = game:GetService("Players")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local RunService = game:GetService("RunService")
        local player = Players.LocalPlayer
        local active = true
        local spawnedTasks = {}
        local function buildCombatArgs()
            return {
                [1] = ReplicatedStorage.Characters.Gon.WallCombo,
                [2] = "Characters:Gon:WallCombo",
                [3] = 1,
                [4] = 33036,
                [5] = {
                    ["HitboxCFrames"] = {},
                    ["BestHitCharacter"] = workspace.Characters.NPCs:FindFirstChild("The Ultimate Bum"),
                    ["HitCharacters"] = {workspace.Characters.NPCs:FindFirstChild("The Ultimate Bum")},
                    ["Ignore"] = {},
                    ["DeathInfo"] = {},
                    ["Actions"] = {},
                    ["HitInfo"] = {
                        ["IsFacing"] = true,
                        ["IsInFront"] = true
                    },
                    ["BlockedCharacters"] = {},
                    ["ServerTime"] = os.clock(),
                    ["FromCFrame"] = CFrame.new(534.693, 5.532, 79.486)
                },
                [6] = "Action651",
                [7] = 0
            }
        end
        local abilityArgs = {
            [1] = ReplicatedStorage.Characters.Gon.WallCombo,
            [2] = 33036,
            [4] = workspace.Characters.NPCs:FindFirstChild("The Ultimate Bum"),
            [5] = Vector3.new(527.693, 4.532, 79.978)
        }
        for i = 1, 10000 do
            local t = task.spawn(function()
                if active then
                    pcall(function()
                        local combatArgs = buildCombatArgs()
                        ReplicatedStorage.Remotes.Abilities.Ability:FireServer(unpack(abilityArgs))
                        ReplicatedStorage.Remotes.Combat.Action:FireServer(unpack(combatArgs))
                    end)
                end
            end)
            table.insert(spawnedTasks, t)
        end
        task.delay(3, function()
            active = false
            for _, t in ipairs(spawnedTasks) do
                if task.cancel then
                    task.cancel(t)
                end
            end
            spawnedTasks = {}
            local localContainers = workspace:FindFirstChild("Container(Drawing)")
            if localContainers then
                for _, v in ipairs(localContainers:GetChildren()) do
                    if v.Name:match(tostring(player.UserId)) then
                        v:Destroy()
                    end
                end
            end
            print("已执行卡服")
        end)
    end
})
local _F = {}
_F.P = game:GetService("Players")
_F.R = game:GetService("RunService")
_F.RS = game:GetService("ReplicatedStorage")
_F.W = game:GetService("Workspace")
_F.L = _F.P.LocalPlayer
_F.Cfg = {
    Enabled = false,
    Range = 67.5,
    Friends = true,
    Target = "Closest" 
}
_F.Data = {
    List = {},
    Idx = 1,
    FCon = nil,
    KCon = nil,
    OSub = nil,
    OType = nil,
    SCFrame = nil,
    SCCFrame = nil,
    SCType = nil
}
_F.Dash = function()
    local char = _F.L.Character or _F.L.CharacterAdded:Wait()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then
        require(_F.RS:WaitForChild("Core")).Library("Remote").Send("Dash", hrp.CFrame, "L", 1)
    end
end
_F.HRP = function()
    local c = _F.L.Character
    if c and c:FindFirstChild('Humanoid') and c.Humanoid.RootPart then
        return c.Humanoid.RootPart
    end
    return nil
end
_F.IsF = function(p)
    if not p or p == _F.L then return false end
    return _F.L:IsFriendsWith(p.UserId)
end
_F.GetT = function()
    local tgs = {}
    local root = _F.HRP()
    if not root then return tgs end
    local pos = root.Position
    
    for _, v in ipairs(_F.P:GetPlayers()) do
        local char = v.Character
        if char and v ~= _F.L and char:FindFirstChild(' ') == nil then
            if _F.Cfg.Friends and _F.IsF(v) then continue end
            local hum = char:FindFirstChild('Humanoid')
            local hrp = char:FindFirstChild('HumanoidRootPart')
            
            if hum and hrp then
                local dist = (hrp.Position - pos).Magnitude
                if dist < _F.Cfg.Range then
                    local lchar = _F.L.Character
                    if lchar then
                        local lName = lchar.Name
                        local cs = char:GetAttribute("Cutscene")
                        local csV = not cs or cs == lchar:GetAttribute("Cutscene")
                        
                        if hrp and not char:GetAttribute("Ignore") and csV and 
                           ((not char:GetAttribute("Grabbed") or char:GetAttribute("Grabbed") == lName) and 
                           (not char:GetAttribute("Victim") or char:GetAttribute("Victim") == lName)) and 
                           not char:GetAttribute("Invincible") and not char:GetAttribute("Grabbing") then
                            
                            table.insert(tgs, {c = char, d = dist, h = hum:GetAttribute("Health") or hum.Health or 0})
                        end
                    end
                end
            end
        end
    end
    
    if _F.Cfg.Target == "Closest" and #tgs > 0 then
        table.sort(tgs, function(a, b) return a.d < b.d end)
        return {tgs[1]}
    end
    return tgs
end
_F.Aura = function(n)
    local root = _F.HRP()
    if not root then return end
    local tgs = _F.GetT()
    for _, data in ipairs(tgs) do
        if data.c then
            for i=1, n do
                _F.Data.List[_F.Data.Idx] = data.c
                _F.Data.Idx = _F.Data.Idx + 1
            end
        end
    end
    if _F.Data.Idx > 1 then
        local name = _F.L.Data.Character.Value
        local combo = _F.RS.Characters[name].WallCombo
        _F.RS.Remotes.Abilities.Ability:FireServer(combo, 69)
        _F.RS.Remotes.Combat.Action:FireServer(combo, "", 4, 69, {BestHitCharacter=nil, HitCharacters=_F.Data.List, Ignore={}, Actions={}})
        for k in pairs(_F.Data.List) do _F.Data.List[k] = nil end
        _F.Data.Idx = 1
    end
end
_F.GetR = function()
    local al = {}
    for _, p in ipairs(_F.P:GetPlayers()) do
        if p ~= _F.L and p.Character then
            local hu = p.Character:FindFirstChild("Humanoid")
            local hr = p.Character:FindFirstChild("HumanoidRootPart")
            if hu and hr and (hu:GetAttribute("Health") or 0) > 0 and not hu:GetAttribute("Godmode") then
                table.insert(al, p)
            end
        end
    end
    return #al > 0 and al[math.random(1, #al)] or nil
end
_F.TP = function(p)
    if not p or not p.Character then return false end
    local hr = p.Character:FindFirstChild("HumanoidRootPart")
    if not hr then return false end
    pcall(function()
        require(_F.L.PlayerScripts.Character.FullCustomReplication).Override(_F.L.Character, CFrame.new(hr.Position - Vector3.new(0, 30, 0)))
    end)
    return true
end
_F.Spec = function(p)
    local cam = _F.W.CurrentCamera
    if cam and p and p.Character then
        local hu = p.Character:FindFirstChildOfClass("Humanoid")
        if hu then cam.CameraType = Enum.CameraType.Custom cam.CameraSubject = hu end
    end
end
_F.Loop = function()
    local c = _F.L.Character
    if not c or not c.Parent then return end
    local r = _F.GetR()
    if r then
        _F.TP(r)
        _F.Spec(r)
        task.wait(0.5)
    end
end
_F.Grav = function(b)
    local c = _F.L.Character
    if not c then return end
    for _, p in ipairs(c:GetDescendants()) do
        if p:IsA("BasePart") then
            p.Anchored = not b
            if not b then p.Velocity = Vector3.new(0,0,0) end
        end
    end
end
_F.Save = function()
    local c = _F.L.Character
    local hr = c and c:FindFirstChild("HumanoidRootPart")
    if not hr then return false end
    _F.Data.SCFrame = hr.CFrame
    local cam = _F.W.CurrentCamera
    if cam then 
        _F.Data.SCCFrame = cam.CFrame 
        _F.Data.SCType = cam.CameraType 
    end
    return true
end
_F.Rest = function()
    if not _F.Data.SCFrame or not _F.L.Character then return end
    pcall(function() require(_F.L.PlayerScripts.Character.FullCustomReplication).Override(_F.L.Character, _F.Data.SCFrame) end)
    task.delay(0.1, function()
        local cam = _F.W.CurrentCamera
        if cam and _F.Data.SCCFrame then 
            cam.CameraType = _F.Data.SCType 
            cam.CFrame = _F.Data.SCCFrame 
        end
    end)
end
_F.Start = function()
    if not _F.Save() then return end
    _F.Grav(false)
    local cam = _F.W.CurrentCamera
    if cam then 
        _F.Data.OSub = cam.CameraSubject 
        _F.Data.OType = cam.CameraType 
    end
    _F.Data.FCon = _F.R.Heartbeat:Connect(_F.Loop)
    _F.Data.KCon = _F.R.Heartbeat:Connect(function()
        _F.Dash()
        local cn = _F.L.Data.Character.Value
        _F.Aura(cn == "Gon" and 20 or 50)
    end)
end
_F.Stop = function()
    if _F.Data.FCon then _F.Data.FCon:Disconnect() _F.Data.FCon = nil end
    if _F.Data.KCon then _F.Data.KCon:Disconnect() _F.Data.KCon = nil end
    _F.Rest()
    _F.Grav(true)
    local cam = _F.W.CurrentCamera
    if cam and _F.Data.OSub then 
        cam.CameraSubject = _F.Data.OSub 
        cam.CameraType = _F.Data.OType 
    end
end
Tab:Toggle({
    Title = "全图秒杀",
    Value = false,
    Callback = function(state)
        _F.Cfg.Enabled = state
        if _F.Cfg.Enabled then
            _F.Start()
        else
            _F.Stop()
        end
    end
})
_F.L.CharacterAdded:Connect(function()
    if _F.Cfg.Enabled then
        _F.Stop()
        _F.Cfg.Enabled = false
    end
end)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Core = require(ReplicatedStorage:WaitForChild("Core"))
local LocalPlayer = Players.LocalPlayer
local charValue = LocalPlayer:WaitForChild("Data"):WaitForChild("Character").Value
local chars = ReplicatedStorage:WaitForChild("Characters")
local ability = chars:WaitForChild(charValue):WaitForChild("WallCombo")
local interruptAttr = ability:GetAttribute("Interrupt")
local wallComboCooldown = 0.05
local lastWallComboTime = 0
local wallComboKey = Enum.KeyCode.E
local lastDashTime = 0
local wallComboEnabled = false
local ignoreFriends = false
local wallComboConn = nil
local dashConn = nil
local function isFriend(player)
    local ok, res = pcall(function() return LocalPlayer:IsFriendsWith(player.UserId) end)
    return ok and res
end
local function shouldIgnorePlayerModel(model)
    if not model then return false end
    if ignoreFriends then
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl ~= LocalPlayer and pl.Character == model then
                if isFriend(pl) then
                    return true
                end
            end
        end
    end
    return false
end
local function getHead()
    local character = LocalPlayer.Character
    if not character then return nil end
    return character:FindFirstChild("Head")
end
local function hasValidTargetsForWallCombo(range)
    local head = getHead()
    if not head then return false end
    local hrpPos = head.Position
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
            if not shouldIgnorePlayerModel(pl.Character) then
                local d = (pl.Character.HumanoidRootPart.Position - hrpPos).Magnitude
                if d <= range then return true end
            end
        end
    end
    return false
end
local function executeWallCombo()
    local head = getHead()
    if not head then return end
    local now = tick()
    if now - lastWallComboTime < wallComboCooldown then return end
    if not hasValidTargetsForWallCombo(100) then return end
    lastWallComboTime = now
    local res
    local success = pcall(function()
        res = Core.Get("Combat","Hit").Box(nil, LocalPlayer.Character, {Size = Vector3.new(100,100,100)})
    end)
    if not success or not res then return end
    pcall(function()
        Core.Get("Combat","Ability").Activate(chars[charValue].WallCombo, res, head.Position + Vector3.new(0,0,2.5))
    end)
end
local function fireDash()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local now = tick()
    if now - lastDashTime < 0.1 then return end
    lastDashTime = now
    local args = {
        [1] = hrp.CFrame,
        [2] = "F",
        [3] = hrp.CFrame.LookVector,
        [5] = now
    }
    if ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("Character") and ReplicatedStorage.Remotes.Character:FindFirstChild("Dash") then
        pcall(function()
            ReplicatedStorage.Remotes.Character.Dash:FireServer(unpack(args))
        end)
    end
end
local function toggleWallCombo(state)
    wallComboEnabled = state
    if wallComboConn then wallComboConn:Disconnect(); wallComboConn = nil end
    if dashConn then dashConn:Disconnect(); dashConn = nil end
    if wallComboEnabled then
        wallComboConn = RunService.Heartbeat:Connect(function()
            executeWallCombo()
        end)
        dashConn = RunService.Heartbeat:Connect(function()
            fireDash()
        end)
    end
end
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == wallComboKey then
        executeWallCombo()
    end
end)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Core = require(ReplicatedStorage:WaitForChild("Core"))
local LocalPlayer = Players.LocalPlayer
local Configs = {
    IgnoreFriends = false,
    MaxDistance = 100,
    Damage = 9999,
    HealthLimit = 0,
    DashInterval = 0.7,
    AttackInterval = 0.001
}
local running = false
local conn
local lastDash = 0
local lastAttack = 0
local data = LocalPlayer:WaitForChild("Data")
local charValue = data:WaitForChild("Character")
local localCharacterName = charValue.Value
local ability = ReplicatedStorage:WaitForChild("Characters"):WaitForChild(localCharacterName):WaitForChild("WallCombo")
local AbilitiesRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Abilities"):WaitForChild("Ability")
local CombatRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Combat"):WaitForChild("Action")
local function getLocalRootPart()
    local c = LocalPlayer.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end
local function triggerDash()
    if tick() - lastDash < Configs.DashInterval then return end
    lastDash = tick()
    local hrp = getLocalRootPart()
    if not hrp then return end
    local dashRemote = ReplicatedStorage.Remotes.Character:FindFirstChild("Dash")
    if dashRemote then
        pcall(function()
            dashRemote:FireServer(hrp.CFrame, "L", hrp.CFrame.LookVector, nil, tick())
        end)
    end
end
local function sendKillAura()
    if tick() - lastAttack < Configs.AttackInterval then return end
    lastAttack = tick()
    local localRootPart = getLocalRootPart()
    if not localRootPart then return end
    triggerDash()
    local maxDistSq = Configs.MaxDistance * Configs.MaxDistance
    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if targetPlayer ~= LocalPlayer then
            local targetChar = targetPlayer.Character
            if targetChar then
                local targetRootPart = targetChar:FindFirstChild("HumanoidRootPart")
                local targetHumanoid = targetChar:FindFirstChild("Humanoid")
                if targetRootPart and targetHumanoid and targetHumanoid.Health > Configs.HealthLimit then
                    if not (Configs.IgnoreFriends and LocalPlayer:IsFriendsWith(targetPlayer.UserId)) then
                        local delta = localRootPart.Position - targetRootPart.Position
                        if delta.Magnitude * delta.Magnitude <= maxDistSq then
                            pcall(function()
                                AbilitiesRemote:FireServer(ability, Configs.Damage, {}, targetRootPart.Position)
                            end)
                            pcall(function()
                                CombatRemote:FireServer(
                                    ability,
                                    localCharacterName .. ":WallCombo",
                                    2,
                                    Configs.Damage,
                                    {
                                        HitboxCFrames = {targetRootPart.CFrame, targetRootPart.CFrame},
                                        BestHitCharacter = targetChar,
                                        HitCharacters = {targetChar},
                                        Ignore = {},
                                        DeathInfo = {},
                                        BlockedCharacters = {},
                                        HitInfo = {IsFacing = false, IsInFront = true},
                                        ServerTime = os.time(),
                                        Actions = {
                                            ActionNumber1 = {
                                                [targetPlayer.Name] = {
                                                    StartCFrameStr = tostring(localRootPart.CFrame),
                                                    Local = true,
                                                    Collision = false,
                                                    Animation = "Punch1Hit",
                                                    Preset = "Punch",
                                                    Velocity = Vector3.zero,
                                                    FromPosition = targetRootPart.Position,
                                                    Seed = math.random(1,999999)
                                                }
                                            }
                                        },
                                        FromCFrame = targetRootPart.CFrame
                                    },
                                    "Action150",
                                    0
                                )
                            end)
                        end
                    end
                end
            end
        end
    end
end
local function startAura()
    if conn then conn:Disconnect() conn = nil end
    conn = RunService.Heartbeat:Connect(function()
        if running then
            sendKillAura()
        end
    end)
end
local function stopAura()
    if conn then conn:Disconnect() conn = nil end
end
Tab:Toggle({
    Flag = "23",
    Title = "杀戮光环v1(慢)",
    Value = false,
    Callback = function(state)
        if state then AddToArrayList("杀戮光环") else RemoveFromArrayList("杀戮光环") end
        running = state
        if running then
            startAura()
        else
            stopAura()
        end
    end
})
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local enabled = false
local conn
local PlayersList = {}
local index = 1
local RANGE = 70
local DASH_INTERVAL = 0.25
local lastDash = 0
local function C()
    return LocalPlayer.Character
end
local function HRP()
    if C() and C():FindFirstChild("Humanoid") then
        return C().Humanoid.RootPart
    end
end
local function isFriend(p)
    return LocalPlayer:IsFriendsWith(p.UserId)
end
local function triggerDash()
    local now = tick()
    if now - lastDash < DASH_INTERVAL then return end
    lastDash = now
    local hrp = HRP()
    if not hrp then return end
    local dashRemote = ReplicatedStorage.Remotes.Character:FindFirstChild("Dash")
    if dashRemote then
        pcall(function()
            dashRemote:FireServer(
                hrp.CFrame,
                "L",
                hrp.CFrame.LookVector,
                nil,
                now
            )
        end)
    end
end
local function getTargets()
    local targets = {}
    local hrp = HRP()
    if not hrp then return targets end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            if isFriend(p) then continue end
            local hum = p.Character:FindFirstChild("Humanoid")
            local root = p.Character:FindFirstChild("HumanoidRootPart")
            if hum and root and hum.Health > 0 then
                if (root.Position - hrp.Position).Magnitude <= RANGE then
                    if not p.Character:GetAttribute("Invincible") then
                        table.insert(targets, p.Character)
                    end
                end
            end
        end
    end
    return targets
end
local function KillAura(count)
    triggerDash()
    local targets = getTargets()
    for _, char in ipairs(targets) do
        for i = 1, count do
            PlayersList[index] = char
            index += 1
        end
    end
    if index > 1 then
        local combo = ReplicatedStorage.Characters[LocalPlayer.Data.Character.Value].WallCombo
        ReplicatedStorage.Remotes.Abilities.Ability:FireServer(combo, 69)
        ReplicatedStorage.Remotes.Combat.Action:FireServer(
            combo,
            "",
            4,
            69,
            {
                BestHitCharacter = nil,
                HitCharacters = PlayersList,
                Ignore = {},
                Actions = {}
            }
        )
        table.clear(PlayersList)
        index = 1
    end
end
Tab:Toggle({
    Flag = "23.5",
    Title = "杀戮光环v2(快)",
    Value = false,
    Callback = function(state)
        enabled = state
        if enabled then
            conn = RunService.Heartbeat:Connect(function()
                local count = (LocalPlayer.Data.Character.Value == "Gon") and 20 or 50
                KillAura(count)
            end)
        else
            if conn then
                conn:Disconnect()
                conn = nil
            end
        end
    end
})
Tab:Toggle({
    Flag = "24",
    Title = "杀戮光环忽略好友",
    Value = false,
    Callback = function(state)
        Configs.IgnoreFriends = state
    end
})
Tab:Toggle({
    Flag = "25",
    Title = "墙打秒杀",
    Value = false,
    Callback = function(state)
        if state then AddToArrayList("墙打秒杀") else RemoveFromArrayList("墙打秒杀") end
        toggleWallCombo(state)
    end
})
Tab:Toggle({
    Flag = "26",
    Title = "墙打秒杀忽略好友",
    Value = false,
    Callback = function(state)
        ignoreFriends = state
    end
})
local Tab = Window:Tab({
    Title = "碰撞箱扩大",
    Icon = "box",
    Locked = false,
})
pcall(function()
    setthreadidentity(8)
end)
local S = {
    Players = game:GetService("Players"),
    RunService = game:GetService("RunService"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
    Cfg = {
        Hitbox = false,
        X = 150,
        Y = 15
