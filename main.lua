-- Simple Cheat GUI with Tabs + Ping Bypass TP
local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- GUI
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "PotopimMenu"
gui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.fromScale(0.45, 0.5)
mainFrame.Position = UDim2.fromScale(0.275, 0.25)
mainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
mainFrame.Active = true
mainFrame.Draggable = true

-- Title
local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1,0,0.1,0)
title.Text = "Potopim Menu"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.BackgroundColor3 = Color3.fromRGB(35,35,35)
title.Font = Enum.Font.GothamBold
title.TextSize = 20

-- Tabs buttons
local tabs = Instance.new("Frame", mainFrame)
tabs.Position = UDim2.new(0,0,0.1,0)
tabs.Size = UDim2.new(0.25,0,0.9,0)
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
pages.Position = UDim2.new(0.25,0,0.1,0)
pages.Size = UDim2.new(0.75,0,0.9,0)
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
    b.Size = UDim2.fromScale(0.7,0.08)
    b.Position = UDim2.fromScale(0.15,y)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(60,60,60)
    b.TextColor3 = Color3.fromRGB(255,255,255)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    return b
end

-- Label creator
local function createLabel(parent, text, y)
    local l = Instance.new("TextLabel", parent)
    l.Size = UDim2.fromScale(0.7, 0.06)
    l.Position = UDim2.fromScale(0.15, y)
    l.Text = text
    l.TextColor3 = Color3.fromRGB(200,200,200)
    l.BackgroundTransparency = 1
    l.Font = Enum.Font.Gotham
    l.TextSize = 12
    l.TextXAlignment = Enum.TextXAlignment.Left
    return l
end

-- 🟥 PING & NETWORK BYPASS METHODS
local savedCFrame = nil

-- Method 1: Flying Platform TP (невидима платформа)
local platformActive = false
local platform = nil

local function flyingPlatformTP(targetCF)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = char.HumanoidRootPart
    
    -- Створюємо невидиму платформу
    platform = Instance.new("Part")
    platform.Size = Vector3.new(6, 1, 6)
    platform.Position = hrp.Position + Vector3.new(0, -3, 0)
    platform.Anchored = true
    platform.Transparency = 1
    platform.CanCollide = true
    platform.Name = "FlyPlatform"
    platform.Parent = workspace
    
    platformActive = true
    
    -- Піднімаємо вгору (50 studs)
    local startHeight = platform.Position.Y
    local targetHeight = startHeight + 50
    
    for i = 1, 25 do
        if not platformActive then break end
        local newY = startHeight + (50 * (i/25))
        platform.Position = Vector3.new(platform.Position.X, newY, platform.Position.Z)
        hrp.CFrame = CFrame.new(platform.Position + Vector3.new(0, 4, 0))
        task.wait(0.05)
    end
    
    task.wait(0.2)
    
    -- Летимо до цілі
    local startPos = platform.Position
    local targetPos = Vector3.new(targetCF.Position.X, targetHeight, targetCF.Position.Z)
    
    local distance = (targetPos - startPos).Magnitude
    local steps = math.ceil(distance / 5)
    
    for i = 1, steps do
        if not platformActive then break end
        platform.Position = startPos:Lerp(targetPos, i/steps)
        hrp.CFrame = CFrame.new(platform.Position + Vector3.new(0, 4, 0))
        task.wait(0.05)
    end
    
    task.wait(0.2)
    
    -- Опускаємось вниз
    for i = 1, 25 do
        if not platformActive then break end
        local newY = targetHeight - (50 * (i/25))
        platform.Position = Vector3.new(platform.Position.X, newY, platform.Position.Z)
        hrp.CFrame = CFrame.new(platform.Position + Vector3.new(0, 4, 0))
        task.wait(0.05)
    end
    
    -- Фінальне позиціонування
    hrp.CFrame = targetCF
    
    task.wait(2.5)
    
    -- Видаляємо платформу
    if platform then
        platform:Destroy()
        platform = nil
    end
    platformActive = false
end

-- Method 2: Lag Save & Invisible Walk (залагав на місці)
local lagSaveActive = false
local lagClone = nil
local lagSavedPos = nil
local invisConnection = nil

local function startLagSave()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    lagSaveActive = true
    lagSavedPos = char.HumanoidRootPart.CFrame
    
    -- Створюємо клон який "залагав"
    lagClone = char:Clone()
    
    -- Робимо клон напівпрозорим
    for _, part in pairs(lagClone:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = 0.5
            part.CanCollide = false
        elseif part:IsA("Decal") or part:IsA("Texture") then
            part.Transparency = 0.5
        end
    end
    
    -- Видаляємо скрипти з клона
    for _, obj in pairs(lagClone:GetDescendants()) do
        if obj:IsA("Script") or obj:IsA("LocalScript") then
            obj:Destroy()
        end
    end
    
    lagClone.Parent = workspace
    
    if lagClone:FindFirstChild("HumanoidRootPart") then
        lagClone.HumanoidRootPart.CFrame = lagSavedPos
        lagClone.HumanoidRootPart.Anchored = true
    end
    
    -- Робимо реального персонажа невидимим
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = 1
        elseif part:IsA("Decal") or part:IsA("Texture") then
            part.Transparency = 1
        end
    end
    
    -- Тримаємо клон на місці
    task.spawn(function()
        while lagSaveActive and lagClone do
            if lagClone:FindFirstChild("HumanoidRootPart") then
                lagClone.HumanoidRootPart.CFrame = lagSavedPos
            end
            task.wait(0.1)
        end
    end)
    
    print("Lag Save активовано! Ходи крадь предмет.")
end

local function executeLagTP(targetCF)
    if not lagSaveActive then return end
    
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    -- "Розлагуємо" - телепортуємо реального персонажа
    char.HumanoidRootPart.CFrame = targetCF or lagSavedPos
    
    task.wait(0.2)
    
    -- Робимо персонажа видимим
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = 0
        elseif part:IsA("Decal") or part:IsA("Texture") then
            part.Transparency = 0
        end
    end
    
    -- Видаляємо клон
    if lagClone then
        lagClone:Destroy()
        lagClone = nil
    end
    
    lagSaveActive = false
    
    task.wait(2.5)
    
    print("Lag TP виконано!")
end

-- Method 3: Stealth Dash (швидкий dash невидимістю)
local function stealthDash(targetCF)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = char.HumanoidRootPart
    
    -- Робимо невидимим
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = 1
            part.CanCollide = false
        end
    end
    
    -- Дуже швидкий dash (0.3 секунди)
    local startPos = hrp.Position
    local endPos = targetCF.Position
    
    for i = 1, 15 do
        local alpha = i / 15
        hrp.CFrame = CFrame.new(startPos:Lerp(endPos, alpha))
        task.wait(0.02)
    end
    
    -- Чекаємо 2 секунди
    task.wait(2)
    
    -- Робимо видимим
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = 0
            part.CanCollide = true
        end
    end
end

-- Method 4: Fake Death TP (вдаємо смерть)
local function fakeDeathTP(targetCF)
    local char = player.Character
    if not char then return end
    
    local humanoid = char:FindFirstChild("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not hrp then return end
    
    -- Робимо вигляд що помер
    humanoid.Health = 0
    
    task.wait(0.5)
    
    -- Телепортуємо "мертве" тіло
    hrp.CFrame = targetCF
    
    task.wait(0.5)
    
    -- "Оживаємо"
    humanoid.Health = humanoid.MaxHealth
    
    task.wait(2)
end

-- Method 5: Quantum Blink (телепорт маленькими "блінками")
local function quantumBlink(targetCF)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = char.HumanoidRootPart
    
    local startPos = hrp.Position
    local endPos = targetCF.Position
    local distance = (endPos - startPos).Magnitude
    
    -- Блінки по 10 studs
    local blinkSize = 10
    local blinks = math.ceil(distance / blinkSize)
    
    for i = 1, blinks do
        -- Короткочасна невидимість під час блінку
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 1
            end
        end
        
        task.wait(0.05)
        
        -- Блінк
        local alpha = i / blinks
        hrp.CFrame = CFrame.new(startPos:Lerp(endPos, alpha))
        
        -- З'являємось
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 0
            end
        end
        
        task.wait(0.1)
    end
    
    hrp.CFrame = targetCF
    task.wait(2.5)
end

-- Method 6: Velocity Push (штовхає через velocity)
local function velocityPush(targetCF)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = char.HumanoidRootPart
    
    -- Створюємо BodyVelocity
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Parent = hrp
    
    local direction = (targetCF.Position - hrp.Position).Unit
    local distance = (targetCF.Position - hrp.Position).Magnitude
    
    -- Розраховуємо velocity для досягнення за ~1 секунду
    bv.Velocity = direction * (distance * 1.5)
    
    task.wait(1)
    
    -- Видаляємо velocity і позиціонуємо точно
    bv:Destroy()
    hrp.CFrame = targetCF
    
    task.wait(2)
end

-- 🟥 GODMODE METHODS
local godmodeActive = false
local healthConnection = nil

local function healthGodMode(enabled)
    if enabled then
        local char = player.Character
        if not char then return end
        local humanoid = char:FindFirstChild("Humanoid")
        if not humanoid then return end
        
        healthConnection = RunService.Heartbeat:Connect(function()
            if humanoid and humanoid.Health < humanoid.MaxHealth then
                humanoid.Health = humanoid.MaxHealth
            end
        end)
    else
        if healthConnection then
            healthConnection:Disconnect()
            healthConnection = nil
        end
    end
end

-- 🟥 MAIN PAGE - GODMODE
createLabel(mainPage, "GodMode:", 0.02)

local healthGodBtn = createActionButton(mainPage,"💚 Health Loop: OFF",0.09)
healthGodBtn.MouseButton1Click:Connect(function()
    godmodeActive = not godmodeActive
    healthGodMode(godmodeActive)
    
    if godmodeActive then
        healthGodBtn.Text = "💚 Health Loop: ON"
        healthGodBtn.BackgroundColor3 = Color3.fromRGB(40,100,40)
    else
        healthGodBtn.Text = "💚 Health Loop: OFF"
        healthGodBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    end
end)

local infoMain = createLabel(mainPage, "Turn ON before stealing!", 0.25)
infoMain.TextSize = 11
infoMain.TextColor3 = Color3.fromRGB(150,150,150)

-- 🟥 STEALER PAGE
local saveBtn = createActionButton(stealerPage,"💾 Save Zone Position",0.02)
saveBtn.MouseButton1Click:Connect(function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        savedCFrame = char.HumanoidRootPart.CFrame
        saveBtn.Text = "✔ Zone Saved!"
        saveBtn.BackgroundColor3 = Color3.fromRGB(40,100,40)
        wait(1.5)
        saveBtn.Text = "💾 Save Zone Position"
        saveBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    end
end)

createLabel(stealerPage, "Creative Methods:", 0.13)

local tpPlatform = createActionButton(stealerPage,"🚁 Flying Platform",0.20)
tpPlatform.MouseButton1Click:Connect(function()
    if savedCFrame then
        tpPlatform.Text = "✈️ Flying..."
        flyingPlatformTP(savedCFrame)
        tpPlatform.Text = "🚁 Flying Platform"
    end
end)

local lagSaveBtn = createActionButton(stealerPage,"👻 Start Lag Save",0.30)
lagSaveBtn.MouseButton1Click:Connect(function()
    if lagSaveActive then
        executeLagTP(savedCFrame)
        lagSaveBtn.Text = "👻 Start Lag Save"
        lagSaveBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    else
        startLagSave()
        lagSaveBtn.Text = "⚡ Execute Lag TP"
        lagSaveBtn.BackgroundColor3 = Color3.fromRGB(100,100,30)
    end
end)

local tpDash = createActionButton(stealerPage,"⚡ Stealth Dash",0.40)
tpDash.MouseButton1Click:Connect(function()
    if savedCFrame then
        tpDash.Text = "💨 Dashing..."
        stealthDash(savedCFrame)
        tpDash.Text = "⚡ Stealth Dash"
    end
end)

createLabel(stealerPage, "Other Methods:", 0.51)

local tpDeath = createActionButton(stealerPage,"💀 Fake Death",0.58)
tpDeath.MouseButton1Click:Connect(function()
    if savedCFrame then
        tpDeath.Text = "☠️ Dying..."
        fakeDeathTP(savedCFrame)
        tpDeath.Text = "💀 Fake Death"
    end
end)

local tpBlink = createActionButton(stealerPage,"✨ Quantum Blink",0.68)
tpBlink.MouseButton1Click:Connect(function()
    if savedCFrame then
        tpBlink.Text = "⚡ Blinking..."
        quantumBlink(savedCFrame)
        tpBlink.Text = "✨ Quantum Blink"
    end
end)

local tpVelocity = createActionButton(stealerPage,"🚀 Velocity Push",0.78)
tpVelocity.MouseButton1Click:Connect(function()
    if savedCFrame then
        tpVelocity.Text = "💨 Pushing..."
        velocityPush(savedCFrame)
        tpVelocity.Text = "🚀 Velocity Push"
    end
end)

local infoStealer = createLabel(stealerPage, "Lag Save: invisible walk + TP!", 0.90)
infoStealer.TextSize = 10
infoStealer.TextColor3 = Color3.fromRGB(150,150,150)

-- Visual placeholder
local visualText = Instance.new("TextLabel", visualPage)
visualText.Size = UDim2.fromScale(1,0.2)
visualText.Position = UDim2.fromScale(0,0.1)
visualText.Text = "Visual (soon)"
visualText.TextColor3 = Color3.fromRGB(200,200,200)
visualText.BackgroundTransparency = 1
visualText.Font = Enum.Font.Gotham
visualText.TextSize = 16
