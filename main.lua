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

-- Method 1: Lag Switch TP (імітує високий пінг)
local function lagSwitchTP(targetCF)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = char.HumanoidRootPart
    
    -- "Заморожуємо" з'єднання
    settings().Network.IncomingReplicationLag = 1000
    
    task.wait(0.5)
    
    -- Телепортуємось під час "лагу"
    hrp.CFrame = targetCF
    
    task.wait(2.5) -- Чекаємо щоб зарахувалось
    
    -- Відновлюємо з'єднання
    settings().Network.IncomingReplicationLag = 0
end

-- Method 2: Heartbeat manipulation (обходимо через цикл рендерингу)
local function heartbeatTP(targetCF)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = char.HumanoidRootPart
    
    -- Відключаємо фізику
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
            part.Massless = true
        end
    end
    
    local startPos = hrp.Position
    local endPos = targetCF.Position
    local distance = (endPos - startPos).Magnitude
    
    -- Дуже швидкі маленькі кроки на кожен Heartbeat
    local steps = 0
    local maxSteps = 60 -- ~1 секунда
    
    local connection
    connection = RunService.Heartbeat:Connect(function()
        steps = steps + 1
        
        if steps >= maxSteps then
            hrp.CFrame = targetCF
            connection:Disconnect()
            
            -- Відновлюємо фізику
            task.wait(2.5)
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                    part.Massless = false
                end
            end
        else
            local alpha = steps / maxSteps
            hrp.CFrame = CFrame.new(startPos:Lerp(endPos, alpha))
        end
    end)
end

-- Method 3: Physics bypass (вимикаємо фізику повністю)
local function physicsTP(targetCF)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = char.HumanoidRootPart
    
    -- Зберігаємо властивості
    local oldAssembly = hrp.AssemblyLinearVelocity
    local oldCan = hrp.CanCollide
    
    -- Вимикаємо фізику
    hrp.AssemblyLinearVelocity = Vector3.new(0,0,0)
    hrp.CanCollide = false
    hrp.Anchored = true
    
    task.wait(0.1)
    
    -- Миттєвий TP
    hrp.CFrame = targetCF
    hrp.Anchored = false
    
    task.wait(2.5)
    
    -- Відновлюємо
    hrp.CanCollide = oldCan
end

-- Method 4: CFrame lerp with yield (повільний але стабільний)
local function yieldTP(targetCF)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = char.HumanoidRootPart
    
    local start = hrp.CFrame
    local steps = 30
    
    for i = 1, steps do
        hrp.CFrame = start:Lerp(targetCF, i/steps)
        task.wait(0.03) -- Загалом ~0.9 секунди
    end
    
    -- Доповнюємо до 2 секунд
    task.wait(1.1)
end

-- Method 5: Simulation radius exploit
local function simRadiusTP(targetCF)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = char.HumanoidRootPart
    
    -- Збільшуємо simulation radius
    pcall(function()
        player.MaximumSimulationRadius = math.huge
        player.SimulationRadius = math.huge
    end)
    
    task.wait(0.2)
    
    -- Телепортуємось
    hrp.CFrame = targetCF
    
    task.wait(2.5)
    
    -- Повертаємо назад
    pcall(function()
        player.MaximumSimulationRadius = 1000
        player.SimulationRadius = 1000
    end)
end

-- Method 6: Network Owner bypass
local function networkOwnerTP(targetCF)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = char.HumanoidRootPart
    
    -- Забираємо Network Ownership у сервера
    pcall(function()
        hrp:SetNetworkOwner(player)
    end)
    
    -- Вимикаємо всі bodymovers
    for _, obj in pairs(char:GetDescendants()) do
        if obj:IsA("BodyMover") then
            obj:Destroy()
        end
    end
    
    task.wait(0.1)
    
    hrp.CFrame = targetCF
    
    task.wait(2.5)
    
    -- Повертаємо ownership серверу
    pcall(function()
        hrp:SetNetworkOwner(nil)
    end)
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

createLabel(stealerPage, "Ping/Network Methods:", 0.13)

local tpLag = createActionButton(stealerPage,"🌐 Lag Switch TP",0.20)
tpLag.MouseButton1Click:Connect(function()
    if savedCFrame then
        tpLag.Text = "⏳ TPing..."
        lagSwitchTP(savedCFrame)
        tpLag.Text = "🌐 Lag Switch TP"
    end
end)

local tpHeart = createActionButton(stealerPage,"💓 Heartbeat TP",0.30)
tpHeart.MouseButton1Click:Connect(function()
    if savedCFrame then
        tpHeart.Text = "⏳ TPing..."
        heartbeatTP(savedCFrame)
        tpHeart.Text = "💓 Heartbeat TP"
    end
end)

local tpPhysics = createActionButton(stealerPage,"⚛️ Physics Bypass",0.40)
tpPhysics.MouseButton1Click:Connect(function()
    if savedCFrame then
        tpPhysics.Text = "⏳ TPing..."
        physicsTP(savedCFrame)
        tpPhysics.Text = "⚛️ Physics Bypass"
    end
end)

createLabel(stealerPage, "Slower Methods:", 0.51)

local tpYield = createActionButton(stealerPage,"🐢 Yield TP (safe)",0.58)
tpYield.MouseButton1Click:Connect(function()
    if savedCFrame then
        tpYield.Text = "⏳ TPing..."
        yieldTP(savedCFrame)
        tpYield.Text = "🐢 Yield TP (safe)"
    end
end)

local tpSim = createActionButton(stealerPage,"📡 Sim Radius",0.68)
tpSim.MouseButton1Click:Connect(function()
    if savedCFrame then
        tpSim.Text = "⏳ TPing..."
        simRadiusTP(savedCFrame)
        tpSim.Text = "📡 Sim Radius"
    end
end)

local tpNetwork = createActionButton(stealerPage,"🔧 Network Owner",0.78)
tpNetwork.MouseButton1Click:Connect(function()
    if savedCFrame then
        tpNetwork.Text = "⏳ TPing..."
        networkOwnerTP(savedCFrame)
        tpNetwork.Text = "🔧 Network Owner"
    end
end)

local infoStealer = createLabel(stealerPage, "Tip: Try Lag Switch first!", 0.90)
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
