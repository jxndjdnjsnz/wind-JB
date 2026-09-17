local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local VirtualUser = game:GetService("VirtualUser")
local function GetNil(Name, DebugId)
	for _, Object in getnilinstances() do
		if Object.Name == Name and Object:GetDebugId() == DebugId then
			return Object
		end
	end
end
local Window = WindUI:CreateWindow({
    Title = "JB Hub",
    Folder = "JBHub_WindUI",
    Icon = "solar:home-2-bold-duotone",
    Size = UDim2.fromOffset(420, 340),
    OpenButton = {
        Title = "Open",
        CornerRadius = UDim.new(1,0),
        Enabled = true,
        Draggable = true,
        Scale = 0.3
    },
    Topbar = {
        Height = 36,
        ButtonsType = "Mac"
    }
})
local uiDestroyed = false
Window.OnDestroy:Connect(function()
    uiDestroyed = true
end)

Window:Tag({
    Title = "准备就绪",
    Color = Color3.fromHex("#22bb55"),
    Border = true
})
local Green = Color3.fromHex("#10C550")
local Blue = Color3.fromHex("#257AF7")
local Orange = Color3.fromHex("#ECA201")
local Red = Color3.fromHex("#ef4f1d")
local MainTab = Window:Tab({
    Title = "Twsited X15.0.1",
    Icon = "solar:settings-bold"
})
local MainGroup = MainTab:Group({})
local antiAfkRunning = false
MainGroup:Label({
    Title = "异环牛逼不解释"
})
MainGroup:Space()
local carCooldown = false
local cooldownTime = 3
MainGroup:Button({
    Title = "召唤Dominator1",
    Desc = "召唤车辆",
    Callback = function(state)
        if carCooldown then
             WindUI:Notify({Title="冷却提示",Content="请等待 "..cooldownTime.." 秒后再召唤！",Duration=2})
             return
         end
         carCooldown = true

         local Event = game:GetService("ReplicatedStorage").DeleteCar
         Event:FireServer(GetNil("PlayersCar", "1_45299137"))
         local Event = game:GetService("ReplicatedStorage").SpawnCar
         if Event and Event:IsA("RemoteEvent") then
             Event:FireServer("Dominator 1")
             WindUI:Notify({Title="车辆召唤",Content="Dominator 1 请求已发送",Duration=2})
         else
             WindUI:Notify({Title="错误",Content="找不到SpawnCar事件",Duration=3})
         end

         task.spawn(function()
             task.wait(cooldownTime)
             if not uiDestroyed then
                 carCooldown = false
             end
         end)
    end
})

MainGroup:Button({
    Title = "召唤Dominator2",
    Desc = "召唤车辆",
    Callback = function(state)
        if carCooldown then
             WindUI:Notify({Title="冷却提示",Content="请等待 "..cooldownTime.." 秒后再召唤！",Duration=2})
             return
         end
         carCooldown = true

         local Event = game:GetService("ReplicatedStorage").DeleteCar
         Event:FireServer(GetNil("PlayersCar", "1_45299137"))
         local Event = game:GetService("ReplicatedStorage").SpawnCar
         if Event and Event:IsA("RemoteEvent") then
             Event:FireServer("Dominator 2")
             WindUI:Notify({Title="车辆召唤",Content="Dominator 2 请求已发送",Duration=2})
         else
             WindUI:Notify({Title="错误",Content="找不到SpawnCar事件",Duration=3})
         end

         task.spawn(function()
             task.wait(cooldownTime)
             if not uiDestroyed then
                 carCooldown = false
             end
         end)
    end
})

MainGroup:Button({
    Title = "召唤Dominator3",
    Desc = "召唤车辆",
    Callback = function(state)
        if carCooldown then
             WindUI:Notify({Title="冷却提示",Content="请等待 "..cooldownTime.." 秒后再召唤！",Duration=2})
             return
         end
         carCooldown = true

         local Event = game:GetService("ReplicatedStorage").DeleteCar
         Event:FireServer(GetNil("PlayersCar", "1_45299137"))
         local Event = game:GetService("ReplicatedStorage").SpawnCar
         if Event and Event:IsA("RemoteEvent") then
             Event:FireServer("Dominator 3")
             WindUI:Notify({Title="车辆召唤",Content="Dominator 3 请求已发送",Duration=2})
         else
             WindUI:Notify({Title="错误",Content="找不到SpawnCar事件",Duration=3})
         end

         task.spawn(function()
             task.wait(cooldownTime)
             if not uiDestroyed then
                 carCooldown = false
             end
         end)
    end
})

local VisualTab = Window:Tab({
    Title = "其他脚本(以后再做)",
    Icon = "solar:settings-bold"
})
VisualTab:Button({
    Title = "kanl破解版",
    Desc = "使用其他脚本",
    Callback = function()
        
    end
})

local AncestorTab = Window:Tab({
    Title = "综合",
    Icon = "solar:settings-bold"
})
AncestorTab:Toggle({
    Title = "挂机防踢",
    Desc = "模拟输入防止闲置踢出",
    Value = false,
    Callback = function(state)
        antiAfkRunning = state
        if state then
            WindUI:Notify({
                Title = "防踢已开启",
                Content = "将持续模拟用户输入",
                Duration = 2
            })
            task.spawn(function()
                while antiAfkRunning do
                    VirtualUser:CaptureMousePosition(Vector2.new(0,0))
                     VirtualUser:Button1Down(Enum.UserInputState.Begin)
                     task.wait(58)
                 end
             end)
         else
             WindUI:Notify({
                 Title = "防踢已关闭",
                 Duration = 2
             })
         end
     end
 })
