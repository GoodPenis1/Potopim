-- Simple Cheat GUI with Tabs + Network Bypass TP
local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- GUI
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "PotopimMenu"
gui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.fromScale(0.45, 0.55)
mainFrame.Position = UDim2.fromScale(0.275, 0.225)
mainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
mainFrame.Active = true
mainFrame.Draggable = true

-- Title
local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1,0,0.09,0)
title.Text = "Potopim Menu"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.BackgroundColor3 = Color3.fromRGB(35,35,35)
title.Font = Enum.Font.GothamBold
title.TextSize = 20

-- Tabs buttons
local tabs = Instance.new("Frame", mainFrame)
tabs.Position = UDim2.new(0,0,0.09,0)
tabs.Size = UDim2.new(0.25,0,0.91,0)
tabs.BackgroundColor3 = Color3.fromRGB(30,30,30)

local function createTabButton(text, y)
    local btn = Instance.new("TextButton", tabs)
    btn.Size = UDim2.new(1,0,0.09,0)
    btn.Position = UDim2.new(0,0,y,0)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    return btn
end

local mainBtn = createTabButton("Main",0)
local stealerBtn = createTabButton("Stealer",0.11)
local visualBtn = createTabButton("Visual",0.22)

-- Pages
local pages = Instance.new("Frame", mainFrame)
pages.Position = UDim2.new(0.25,0,0.09,0)
pages.Size = UDim2.new(0.75,0,0.91,0)
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
    b.Size = UDim2.fromScale(0.7,0.07)
    b.Position = UDim2.fromScale(0.15,y)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(60,60,60)
    b.TextColor3 = Color3.fromRGB(255,255,255)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 12
    return b
end

-- Label creator
local function createLabel(parent, text, y)
    local l = Instance.new("TextLabel", parent)
    l.Size = UDim2.fromScale(0.7, 0.05)
    l.Position = UDim2.fromScale(0.15, y)
    l.Text = text
    l.TextColor3 = Color3.fromRGB(200,200,200)
    l.BackgroundTransparency = 1
    l.Font = Enum.Font.Gotham
    l.TextSize = 11
    l.TextXAlignment = Enum.TextXAlignment.Left
    return l
end

-- 🟥 NETWORK BYPASS METHODS
local savedCFrame = nil

-- Method 1: Packet Loss Simulation (імітація втрати пакетів)
local function packetLossTP(targetCF)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = char.HumanoidRootPart
    
    -- Створюємо штучну втрату пакетів
    pcall(function()
        settings().Network.IncomingReplicationLag = 500
    end)
    
    -- Спам позицій під час "втрати пакетів"
    task.spawn(function()
        for i = 1, 20 do
            hrp.CFrame = hrp.CFrame * CFrame.new(math.random(-1,1), 0, math.random(-1,1))
            task.wait(0.05)
        end
    end)
    
    task.wait(0.5)
    
    -- Телепортуємось під час "лагу"
    hrp.CFrame = targetCF
    
    task.wait(2.5)
    
    -- Відновлюємо з'єднання
    pcall(function()
        settings().Network.IncomingReplicationLag = 0
    end)
end

-- Method 2: Desync Attack (десинхронізація клієнт-сервер)
local function desyncTP(targetCF)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = char.HumanoidRootPart
    
    -- Десинхронізуємо через багато CFrame змін за кадр
    local realPos = hrp.CFrame
    
    task.spawn(function()
        for i = 1, 50 do
            hrp.CFrame = realPos * CFrame.new(math.random(-5,5), 0, math.random(-5,5))
            RunService.Heartbeat:Wait()
        end
    end)
    
    task.wait(0.3)
    
    -- Під час десинхронізації телепортуємось
    hrp.CFrame = targetCF
    
    task.wait(2.5)
end

-- Method 3: Bandwidth Throttle (обмеження пропускної здатності)
local function bandwidthTP(targetCF)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = char.HumanoidRootPart
    
    -- Імітуємо низьку пропускну здатність
    pcall(function()
        settings().Network.IncomingReplicationLag = 800
        settings().Network.PhysicsSend = 1
        settings().Network.ExperimentalPhysicsEnabled = false
    end)
    
    task.wait(0.7)
    
    hrp.CFrame = targetCF
    
    task.wait(2.5)
    
    -- Відновлюємо
    pcall(function()
        settings().Network.IncomingReplicationLag = 0
        settings().Network.PhysicsSend = 20
        settings().Network.ExperimentalPhysicsEnabled = true
    end)
end

-- Method 4: Jitter Exploit (нестабільний пінг)
local function jitterTP(targetCF)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = char.HumanoidRootPart
    
    -- Створюємо jitter (стрибки пінгу)
    task.spawn(function()
        for i = 1, 30 do
            pcall(function()
                settings().Network.IncomingReplicationLag = math.random(100, 900)
            end)
            task.wait(0.05)
        end
    end)
    
    task.wait(0.5)
    
    hrp.CFrame = targetCF
    
    task.wait(2.5)
    
    pcall(function()
        settings().Network.IncomingReplicationLag = 0
    end)
end

-- Method 5: Frame Skip TP (пропускаємо кадри)
local function frameSkipTP(targetCF)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = char.HumanoidRootPart
    
    -- Заморожуємо рендеринг
    local oldFPS = tonumber(game:GetService("UserSettings").GameSettings.SavedQualityLevel)
    
    game:GetService("UserSettings").GameSettings.SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
    
    -- Телепортуємось між "замороженими" кадрами
    local steps = 0
    local connection
    connection = RunService.Heartbeat:Connect(function()
        steps = steps + 1
        if steps % 5 == 0 then -- Кожен 5-й кадр
            hrp.CFrame = hrp.CFrame:Lerp(targetCF, 0.2)
        end
        
        if steps >= 50 then
            hrp.CFrame = targetCF
            connection:Disconnect()
        end
    end)
    
    task.wait(3)
    
    game:GetService("UserSettings").GameSettings.SavedQualityLevel = oldFPS or Enum.SavedQualitySetting.Automatic
end

-- Method 6: Replication Lag Bomb (бомба затримки реплікації)
local function replicationBombTP(targetCF)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = char.HumanoidRootPart
    
    -- Створюємо масу об'єктів для перевантаження реплікації
    local parts = {}
    for i = 1, 50 do
        local p = Instance.new("Part")
        p.Size = Vector3.new(0.1, 0.1, 0.1)
        p.Position = hrp.Position + Vector3.new(math.random(-10,10), 5, math.random(-10,10))
        p.Anchored = true
        p.Transparency = 1
        p.CanCollide = false
        p.Parent = workspace
        table.insert(parts, p)
    end
    
    task.wait(0.3)
    
    -- Телепортуємось під час перевантаження
    hrp.CFrame = targetCF
    
    task.wait(2.5)
    
    -- Очищуємо
    for _, p in pairs(parts) do
        p:Destroy()
    end
end

-- Method 7: Ping Spoof (підробка пінгу)
local function pingSpoofTP(targetCF)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = char.HumanoidRootPart
    
    -- Спуфимо пінг через затримку отримання даних
    pcall(function()
        settings().Network.IncomingReplicationLag = 1500
        settings().Network.RoundTripLatency = 1500
    end)
    
    -- Рухаємося поки "пінг високий"
    local startPos = hrp.Position
    
    for i = 1, 10 do
        local alpha = i / 10
        hrp.CFrame = CFrame.new(startPos:Lerp(targetCF.Position, alpha))
        task.wait(0.15)
    end
    
    hrp.CFrame = targetCF
    
    task.wait(2)
    
    pcall(function()
        settings().Network.IncomingReplicationLag = 0
        settings().Network.RoundTripLatency = 0
    end)
end

-- Method 8: Server Stall (затримка обробки сервером)
local function serverStallTP(targetCF)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = char.HumanoidRootPart
    
    -- Створюємо велику кількість RemoteEvent спаму
    task.spawn(function()
        for i = 1, 100 do
            for _, remote in pairs(game:GetDescendants()) do
                if remote:IsA("RemoteEvent") then
                    pcall(function()
                        remote:FireServer("spam", i)
                    end)
                end
            end
            task.wait(0.01)
        end
    end)
    
    task.wait(0.5)
    
    hrp.CFrame = targetCF
    
    task.wait(2.5)
end

-- Method 9: Interpolation Abuse (зловживання інтерполяцією)
local function interpolationTP(targetCF)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = char.HumanoidRootPart
    
    -- Відключаємо interpolation
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
        end
    end
    
    -- Швидкі зміни позиції без інтерполяції
    local startPos = hrp.Position
    
    for i = 1, 20 do
        local alpha = i / 20
        hrp.CFrame = CFrame.new(startPos:Lerp(targetCF.Position, alpha))
        RunService.RenderStepped:Wait()
    end
    
    hrp.CFrame = targetCF
    
    task.wait(2.5)
    
    -- Відновлюємо фізику
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CustomPhysicalProperties = nil
        end
    end
end

-- 🟥 GODMODE
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

-- 🟥 MAIN PAGE
createLabel(mainPage, "GodMode:", 0.02)

local healthGodBtn = createActionButton(mainPage,"💚 Health Loop: OFF",0.08)
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

local infoMain = createLabel(mainPage, "Turn ON before stealing!", 0.20)
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

createLabel(stealerPage, "Network Lag Methods:", 0.10)

local tp1 = createActionButton(stealerPage,"📦 Packet Loss",0.16)
tp1.MouseButton1Click:Connect(function()
    if savedCFrame then
        tp1.Text = "⏳ TPing..."
        packetLossTP(savedCFrame)
        tp1.Text = "📦 Packet Loss"
    end
end)

local tp2 = createActionButton(stealerPage,"🔄 Desync Attack",0.25)
tp2.MouseButton1Click:Connect(function()
    if savedCFrame then
        tp2.Text = "⏳ TPing..."
        desyncTP(savedCFrame)
        tp2.Text = "🔄 Desync Attack"
    end
end)

local tp3 = createActionButton(stealerPage,"📉 Bandwidth Throttle",0.34)
tp3.MouseButton1Click:Connect(function()
    if savedCFrame then
        tp3.Text = "⏳ TPing..."
        bandwidthTP(savedCFrame)
        tp3.Text = "📉 Bandwidth Throttle"
    end
end)

local tp4 = createActionButton(stealerPage,"📊 Jitter Exploit",0.43)
tp4.MouseButton1Click:Connect(function()
    if savedCFrame then
        tp4.Text = "⏳ TPing..."
        jitterTP(savedCFrame)
        tp4.Text = "📊 Jitter Exploit"
    end
end)

createLabel(stealerPage, "Advanced Network:", 0.52)

local tp5 = createActionButton(stealerPage,"🎬 Frame Skip",0.58)
tp5.MouseButton1Click:Connect(function()
    if savedCFrame then
        tp5.Text = "⏳ TPing..."
        frameSkipTP(savedCFrame)
        tp5.Text = "🎬 Frame Skip"
    end
end)

local tp6 = createActionButton(stealerPage,"💣 Replication Bomb",0.67)
tp6.MouseButton1Click:Connect(function()
    if savedCFrame then
        tp6.Text = "⏳ TPing..."
        replicationBombTP(savedCFrame)
        tp6.Text = "💣 Replication Bomb"
    end
end)

local tp7 = createActionButton(stealerPage,"🎭 Ping Spoof",0.76)
tp7.MouseButton1Click:Connect(function()
    if savedCFrame then
        tp7.Text = "⏳ TPing..."
        pingSpoofTP(savedCFrame)
        tp7.Text = "🎭 Ping Spoof"
    end
end)

local tp8 = createActionButton(stealerPage,"⏸️ Server Stall",0.85)
tp8.MouseButton1Click:Connect(function()
    if savedCFrame then
        tp8.Text = "⏳ TPing..."
        serverStallTP(savedCFrame)
        tp8.Text = "⏸️ Server Stall"
    end
end)

local tp9 = createActionButton(stealerPage,"🌀 Interpolation",0.94)
tp9.MouseButton1Click:Connect(function()
    if savedCFrame then
        tp9.Text = "⏳ TPing..."
        interpolationTP(savedCFrame)
        tp9.Text = "🌀 Interpolation"
    end
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
