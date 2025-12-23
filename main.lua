-- Simple Cheat GUI with Tabs + Advanced TP
local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- GUI
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "PotopimMenu"
gui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.fromScale(0.45, 0.45)
mainFrame.Position = UDim2.fromScale(0.275, 0.25)
mainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
mainFrame.Active = true
mainFrame.Draggable = true

-- Title
local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1,0,0.12,0)
title.Text = "Potopim Menu"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.BackgroundColor3 = Color3.fromRGB(35,35,35)
title.Font = Enum.Font.GothamBold
title.TextSize = 20

-- Tabs buttons
local tabs = Instance.new("Frame", mainFrame)
tabs.Position = UDim2.new(0,0,0.12,0)
tabs.Size = UDim2.new(0.25,0,0.88,0)
tabs.BackgroundColor3 = Color3.fromRGB(30,30,30)

local function createTabButton(text, y)
    local btn = Instance.new("TextButton", tabs)
    btn.Size = UDim2.new(1,0,0.1,0)
    btn.Position = UDim2.new(0,0,y,0)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    return btn
end

local mainBtn = createTabButton("Main",0)
local stealerBtn = createTabButton("Stealer",0.12)
local visualBtn = createTabButton("Visual",0.24)

-- Pages
local pages = Instance.new("Frame", mainFrame)
pages.Position = UDim2.new(0.25,0,0.12,0)
pages.Size = UDim2.new(0.75,0,0.88,0)
pages.BackgroundTransparency = 1

local function createPage()
    local f = Instance.new("Frame", pages)
    f.Size = UDim2.new(1,0,1,0)
    f.Visible = false
    f.BackgroundTransparency = 1
    return f
end

local mainPage = createPage()
local stealerPage = createPage()
local visualPage = createPage()
mainPage.Visible = true

-- Switch tabs
local function show(page)
    for _,v in pairs(pages:GetChildren()) do
        v.Visible = false
    end
    page.Visible = true
end

mainBtn.MouseButton1Click:Connect(function() show(mainPage) end)
stealerBtn.MouseButton1Click:Connect(function() show(stealerPage) end)
visualBtn.MouseButton1Click:Connect(function() show(visualPage) end)

-- Button creator
local function createActionButton(parent,text,y)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.fromScale(0.6,0.12)
    b.Position = UDim2.fromScale(0.2,y)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(60,60,60)
    b.TextColor3 = Color3.fromRGB(255,255,255)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    return b
end

-- 🟥 ADVANCED TP FUNCTIONS
local savedCFrame = nil
local isTping = false

-- Method 1: Smooth Lerp TP (найбезпечніший)
local function smoothTP(targetCF, speed)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = char.HumanoidRootPart
    isTping = true
    
    local startCF = hrp.CFrame
    local distance = (targetCF.Position - startCF.Position).Magnitude
    local steps = math.ceil(distance / (speed or 5))
    
    for i = 0, steps do
        if not isTping then break end
        local alpha = i / steps
        hrp.CFrame = startCF:Lerp(targetCF, alpha)
        RunService.Heartbeat:Wait()
    end
    
    isTping = false
end

-- Method 2: Velocity-based TP (імітація руху)
local function velocityTP(targetCF)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = char.HumanoidRootPart
    local humanoid = char:FindFirstChild("Humanoid")
    
    -- Вимикаємо фізику на мить
    local oldColl = hrp.CanCollide
    hrp.CanCollide = false
    
    if humanoid then
        humanoid.PlatformStand = true
    end
    
    -- Створюємо BodyVelocity для "природного" руху
    local bv = Instance.new("BodyVelocity", hrp)
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    
    local direction = (targetCF.Position - hrp.Position).Unit
    local distance = (targetCF.Position - hrp.Position).Magnitude
    
    -- Розраховуємо швидкість
    bv.Velocity = direction * math.min(distance * 2, 100)
    
    wait(0.1)
    
    -- Фінальне позиціонування
    hrp.CFrame = targetCF
    
    -- Відновлюємо фізику
    bv:Destroy()
    hrp.CanCollide = oldColl
    
    if humanoid then
        humanoid.PlatformStand = false
    end
end

-- Method 3: Tween-based TP (через TweenService)
local function tweenTP(targetCF, duration)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local TweenService = game:GetService("TweenService")
    local hrp = char.HumanoidRootPart
    
    local tweenInfo = TweenInfo.new(
        duration or 0.5,
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.InOut
    )
    
    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCF})
    tween:Play()
    tween.Completed:Wait()
end

-- Method 4: Bypass через Network Ownership (експериментальний)
local function bypassTP(targetCF)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = char.HumanoidRootPart
    
    -- Спроба обійти через зміну Network Owner
    pcall(function()
        hrp:SetNetworkOwner(nil)
    end)
    
    -- Вимикаємо collision
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
    
    -- Instant TP
    hrp.CFrame = targetCF
    
    wait(0.1)
    
    -- Відновлюємо collision
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = true
        end
    end
end

-- 🟥 STEALER GUI BUTTONS
local savedCFrame = nil

local saveBtn = createActionButton(stealerPage,"Save TP Position",0.05)
saveBtn.MouseButton1Click:Connect(function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        savedCFrame = char.HumanoidRootPart.CFrame
        saveBtn.Text = "Position Saved ✔"
        wait(1)
        saveBtn.Text = "Save TP Position"
    end
end)

local tpSmooth = createActionButton(stealerPage,"TP (Smooth)",0.20)
tpSmooth.MouseButton1Click:Connect(function()
    if savedCFrame then
        smoothTP(savedCFrame, 8)
    end
end)

local tpVelocity = createActionButton(stealerPage,"TP (Velocity)",0.35)
tpVelocity.MouseButton1Click:Connect(function()
    if savedCFrame then
        velocityTP(savedCFrame)
    end
end)

local tpTween = createActionButton(stealerPage,"TP (Tween)",0.50)
tpTween.MouseButton1Click:Connect(function()
    if savedCFrame then
        tweenTP(savedCFrame, 0.3)
    end
end)

local tpBypass = createActionButton(stealerPage,"TP (Force)",0.65)
tpBypass.MouseButton1Click:Connect(function()
    if savedCFrame then
        bypassTP(savedCFrame)
    end
end)

local stopBtn = createActionButton(stealerPage,"Stop TP",0.80)
stopBtn.BackgroundColor3 = Color3.fromRGB(120,30,30)
stopBtn.MouseButton1Click:Connect(function()
    isTping = false
end)

-- Visual placeholder
local visualText = Instance.new("TextLabel", visualPage)
visualText.Size = UDim2.fromScale(1,0.2)
visualText.Position = UDim2.fromScale(0,0.1)
visualText.Text = "Visual (soon)"
visualText.TextColor3 = Color3.fromRGB(200,200,200)
visualText.BackgroundTransparency = 1
visualText.Font = Enum.Font.Gotham
visualText.TextSize = 16
