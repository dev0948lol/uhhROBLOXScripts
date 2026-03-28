local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local config = {
    enabled = false,
    radius = 0,
    height = 0,
    rotationSpeed = 0, -- 旋轉
    attractionStrength = 0, -- 吸引力
}

-- UI 
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "你敢給我改試試"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 300, 0, 520)
MainFrame.Position = UDim2.new(0.5, -180, 0.5, -260)
MainFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 20)

-- 標題與縮小按鈕
local TitleBar = Instance.new("Frame", MainFrame)
TitleBar.Size = UDim2.new(1, 0, 0, 45)
TitleBar.BackgroundTransparency = 1

local Title = Instance.new("TextLabel", TitleBar)
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = " 丟億點Part I by 0948_aac"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18

local MinimizeBtn = Instance.new("TextButton", TitleBar)
MinimizeBtn.Size = UDim2.new(0, 25, 0, 25)
MinimizeBtn.Position = UDim2.new(1, -35, 0, 10)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
-- --- 管大小啦 ---
-- 加入這兩行來放大文字
MinimizeBtn.TextSize = 25 -- 放大字體
MinimizeBtn.Font = Enum.Font.SourceSansBold -- 加粗字體
-- ----------------------
MinimizeBtn.Text = "X"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(1, 0)

-- eeee



-- 內容容器
local Content = Instance.new("Frame", MainFrame)
Content.Size = UDim2.new(1, 0, 1, -45)
Content.Position = UDim2.new(0, 0, 0, 45)
Content.BackgroundTransparency = 1

-- 啟動按鈕
local ToggleBtn = Instance.new("TextButton", Content)
ToggleBtn.Size = UDim2.new(0.9, 0, 0, 55)
ToggleBtn.Position = UDim2.new(0.05, 0, 0, 15)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
ToggleBtn.Text = "已關閉"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 20
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 10)

ToggleBtn.MouseButton1Click:Connect(function()
    config.enabled = not config.enabled
    ToggleBtn.Text = config.enabled and "運作中" or "已關閉"
    ToggleBtn.BackgroundColor3 = config.enabled and Color3.fromRGB(46, 125, 50) or Color3.fromRGB(200, 0, 0)
end)

-- 參數控制項
local function addSet(name, key, posY)
    local F = Instance.new("Frame", Content)
    F.Size = UDim2.new(0.9, 0, 0, 85)
    F.Position = UDim2.new(0.05, 0, 0, posY)
    F.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 12)

    local L = Instance.new("TextLabel", F)
    L.Size = UDim2.new(1, -20, 0, 30)
    L.Position = UDim2.new(0, 10, 0, 5)
    L.BackgroundTransparency = 1
    L.Text = name .. ": " .. config[key]
    L.TextColor3 = Color3.fromRGB(180, 180, 180)
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.Font = Enum.Font.SourceSans
    L.TextSize = 16

    local B = Instance.new("TextBox", F)
    B.Size = UDim2.new(1, -20, 0, 35)
    B.Position = UDim2.new(0, 10, 0, 40)
    B.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    B.PlaceholderText = "輸入數值..."
    B.Text = ""
    B.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", B).CornerRadius = UDim.new(0, 8)

    B.FocusLost:Connect(function(ent)
        if ent then
            local v = tonumber(B.Text)
            if v then config[key] = v L.Text = name .. ": " .. v end
            B.Text = ""
        end
    end)
end

addSet("範圍", "radius", 85)
addSet("高度", "height", 180)
addSet("旋轉速度", "rotationSpeed", 275)
addSet("吸引強度", "attractionStrength", 370)

-- FE
RunService.Heartbeat:Connect(function()
    if not config.enabled then return end
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local t = tick() * config.rotationSpeed
    -- IDK 
    local parts = workspace:GetPartBoundsInRadius(root.Position, config.radius + 100)

    for _, p in pairs(parts) do
         
        if p:IsA("BasePart") and not p.Anchored and not p:IsDescendantOf(char) then
            local targetPos = root.Position + Vector3.new(math.cos(t) * config.radius, config.height, math.sin(t) * config.radius)
            local offset = (targetPos - p.Position)
            
            
            
            p.Velocity = offset * (config.attractionStrength / 120)
            
            
            p.RotVelocity = Vector3.new(0, 0, 0)
            
           
            if offset.Magnitude < 5 then
                p.Velocity = p.Velocity + Vector3.new(0, math.sin(tick()*20)*2, 0)
            end
        end
    end
end)

-- 縮小與拖動
local min = false
MinimizeBtn.MouseButton1Click:Connect(function()
    min = not min
    MainFrame:TweenSize(min and UDim2.new(0, 360, 0, 45) or UDim2.new(0, 360, 0, 520), "Out", "Quad", 0.3, true)
    MinimizeBtn.Text = min and "+" or "X"
end)

local d, ds, sp
MainFrame.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = true ds = i.Position sp = MainFrame.Position end end)
UserInputService.InputChanged:Connect(function(i) if d and i.UserInputType == Enum.UserInputType.MouseMovement then
    local delta = i.Position - ds
    MainFrame.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y)
end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = false end end)
