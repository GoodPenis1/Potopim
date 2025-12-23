-- Simple Cheat GUI with Tabs + Stealth TP
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

-- 🟥 ULTRA STEALTH TP FUNCTIONS
local savedCFrame = nil
local isTping = false
local walkSpeed = 16

-- Method 1: Micro-step TP (дуже маленькі кроки як ходьба)
local function microStepTP(targetCF)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = char.HumanoidRootPart
    local humanoid = char:FindFirstChild("Humanoid")
    isTping = true
    
    if humanoid then
        walkSpeed = humanoid.WalkSpeed
    end
    
    local startPos = hrp.Position
    local targetPos = targetCF.Position
    local distance = (targetPos - startPos).Magnitude
    
    -- Дуже маленькі кроки (0.5 studs за раз)
    local stepSize = 0.5
    local steps = math.ceil(distance / stepSize)
    
    for i = 1, steps do
        if not isTping then break end
        
        local alpha = i / steps
        local newPos = startPos:Lerp(targetPos, alpha)
        
        -- Зберігаємо орієнтацію
        hrp.CFrame = CFrame.new(newPos) * (hrp.CFrame - hrp.CFrame.Position)
        
        -- Рандомна мікро-затримка для імітації реального руху
        wait(0.02 + math.random() * 0.01)
    end
    
    isTping = false
end

-- Method 2: Humanoid WalkTo (використання вбудованої механіки)
local function walkToTP(targetCF)
    local char = player.Character
    if not char then return end
    
    local humanoid = char:FindFirstChild("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not hrp then return end
    
    -- Збільшуємо швидкість ходьби
    local oldSpeed = humanoid.WalkSpeed
    humanoid.WalkSpeed = 100
    
    -- Використовуємо вбудований WalkTo
    humanoid:MoveTo(targetCF.Position)
    
    -- Чекаємо поки дійде або таймаут
    local timeout = tick() + 5
    while (hrp.Position - targetCF.Position).Magnitude > 5 and tick() < timeout do
        wait(0.1)
    end
    
    humanoid.WalkSpeed = oldSpeed
end

-- Method 3: Improved Anchor method (тимчасово "заморожуємо" персонажа)
local function anchorTP(targetCF)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = char.HumanoidRootPart
    local humanoid = char:FindFirstChild("Humanoid")
    
    -- ВАЖЛИВО: Зберігаємо оригінальне здоров'я
    local originalHealth = humanoid and humanoid.Health or 100
    
    -- Заморожуємо всі частини тіла
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.Anchored = true
        end
    end
    
    -- Вимикаємо колізії на час TP
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
    
    wait(0.1)
    
    -- НАБАГАТО повільніший рух HRP (більше кроків)
    local distance = (targetCF.Position - hrp.Position).Magnitude
    local steps = math.max(100, math.ceil(distance / 1)) -- Мінімум 100 кроків
    local start = hrp.CFrame
    
    for i = 1, steps do
        if not char or not hrp then break end
        
        -- Захист здоров'я під час TP
        if humanoid and humanoid.Health < originalHealth then
            humanoid.Health = originalHealth
        end
        
        hrp.CFrame = start:Lerp(targetCF, i/steps)
        
        -- Випадкова затримка для "природності"
        wait(0.01 + math.random() * 0.02)
    end
    
    wait(0.15)
    
    -- Розморожуємо та відновлюємо колізії
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Anchored = false
            part.CanCollide = true
        end
    end
    
    -- Фінальне відновлення здоров'я
    if humanoid then
        humanoid.Health = originalHealth
    end
end

-- Method 4: CFrame offset spam (спам маленьких зміщень)
local function offsetTP(targetCF)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = char.HumanoidRootPart
    isTping = true
    
    local currentPos = hrp.Position
    local targetPos = targetCF.Position
    local distance = (targetPos - currentPos).Magnitude
    
    -- Кількість кроків залежить від дистанції
    local steps = math.max(50, math.ceil(distance / 2))
    
    for i = 1, steps do
        if not isTping then break end
        
        local progress = i / steps
        local newPos = currentPos:Lerp(targetPos, progress)
        
        -- Додаємо невеличкі випадкові зміщення для "природності"
        local randomOffset = Vector3.new(
            (math.random() - 0.5) * 0.1,
            (math.random() - 0.5) * 0.1,
            (math.random() - 0.5) * 0.1
        )
        
        hrp.CFrame = CFrame.new(newPos + randomOffset)
        
        RunService.Heartbeat:Wait()
    end
    
    -- Фінальна точна позиція
    hrp.CFrame = targetCF
    
    isTping = false
end

-- Method 6: Rapid micro-bursts (швидкі мікро-стрибки)
local function burstTP(targetCF)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = char.HumanoidRootPart
    local humanoid = char:FindFirstChild("Humanoid")
    
    -- Вимикаємо колізії
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
    
    local distance = (targetCF.Position - hrp.Position).Magnitude
    local jumpSize = 5 -- Стрибки по 5 studs
    local jumps = math.ceil(distance / jumpSize)
    
    for i = 1, jumps do
        if not char or not hrp then break end
        
        local progress = i / jumps
        local newPos = hrp.Position:Lerp(targetCF.Position, progress)
        hrp.CFrame = CFrame.new(newPos)
        
        -- Дуже коротка затримка (0.05 сек = під 2 секунди)
        task.wait(0.05)
    end
    
    -- Відновлюємо колізії
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = true
        end
    end
end

-- Method 7: Fake lag method (імітація лагу)
local function fakeLagTP(targetCF)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = char.HumanoidRootPart
    
    -- Створюємо "лаг" - швидко рухаємось вперед-назад
    local start = hrp.CFrame
    local mid = start:Lerp(targetCF, 0.3)
    
    for i = 1, 3 do
        hrp.CFrame = mid
        task.wait(0.05)
        hrp.CFrame = start
        task.wait(0.05)
    end
    
    -- Потім різко телепортуємось
    hrp.CFrame = targetCF
end

-- Method 8: Network delay exploit (затримка синхронізації)
local function networkTP(targetCF)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = char.HumanoidRootPart
    
    -- Спроба змінити Network Owner
    pcall(function()
        hrp:SetNetworkOwner(nil)
    end)
    
    -- Вимикаємо всі скрипти тимчасово
    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("Script") or v:IsA("LocalScript") then
            v.Disabled = true
        end
    end
    
    task.wait(0.1)
    
    -- Миттєвий TP поки скрипти вимкнені
    hrp.CFrame = targetCF
    
    task.wait(0.2)
    
    -- Вмикаємо скрипти назад
    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("Script") or v:IsA("LocalScript") then
            v.Disabled = false
        end
    end
end

-- Method 9: Clone swap method (підміна клона)
local function cloneSwapTP(targetCF)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    -- Створюємо клон персонажа
    local clone = char:Clone()
    clone.Parent = workspace
    
    -- Ставимо клон в стартову позицію
    if clone:FindFirstChild("HumanoidRootPart") then
        clone.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame
    end
    
    task.wait(0.1)
    
    -- Телепортуємо оригінал
    char.HumanoidRootPart.CFrame = targetCF
    
    task.wait(0.5)
    
    -- Видаляємо клон
    clone:Destroy()
end

-- Method 11: Disable AntiCheat Scripts (знаходимо і вимикаємо)
local function disableAC()
    -- Шукаємо античіт в різних місцях
    local acFound = false
    
    -- Перевіряємо ReplicatedStorage
    for _, obj in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
        if obj:IsA("Script") or obj:IsA("LocalScript") or obj:IsA("ModuleScript") then
            local name = obj.Name:lower()
            if name:find("anti") or name:find("cheat") or name:find("kick") or name:find("ban") or name:find("detect") then
                obj.Disabled = true
                obj:Destroy()
                acFound = true
                print("Знайшов і вимкнув:", obj.Name)
            end
        end
    end
    
    -- Перевіряємо StarterPlayer
    for _, obj in pairs(game:GetService("StarterPlayer"):GetDescendants()) do
        if obj:IsA("Script") or obj:IsA("LocalScript") or obj:IsA("ModuleScript") then
            local name = obj.Name:lower()
            if name:find("anti") or name:find("cheat") or name:find("kick") or name:find("ban") or name:find("detect") then
                obj.Disabled = true
                obj:Destroy()
                acFound = true
                print("Знайшов і вимкнув:", obj.Name)
            end
        end
    end
    
    -- Перевіряємо персонажа
    local char = player.Character
    if char then
        for _, obj in pairs(char:GetDescendants()) do
            if obj:IsA("Script") or obj:IsA("LocalScript") then
                local name = obj.Name:lower()
                if name:find("anti") or name:find("cheat") or name:find("kick") or name:find("ban") or name:find("detect") then
                    obj.Disabled = true
                    obj:Destroy()
                    acFound = true
                    print("Знайшов і вимкнув:", obj.Name)
                end
            end
        end
    end
    
    return acFound
end

-- Method 12: Hook RemoteEvents (блокуємо сигнали античіту)
local blockedRemotes = {}
local function blockACRemotes()
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        -- Блокуємо підозрілі RemoteEvent виклики
        if method == "FireServer" or method == "InvokeServer" then
            local remoteName = self.Name:lower()
            
            if remoteName:find("kick") or remoteName:find("ban") or 
               remoteName:find("anticheat") or remoteName:find("detect") or
               remoteName:find("flag") or remoteName:find("report") then
                
                print("Заблокував RemoteEvent:", self.Name)
                return
            end
        end
        
        return oldNamecall(self, ...)
    end)
end

-- Method 13: Bypass через Workspace Camera manipulation
local function cameraTP(targetCF)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = char.HumanoidRootPart
    local camera = workspace.CurrentCamera
    
    -- Зберігаємо камеру
    local oldCamType = camera.CameraType
    camera.CameraType = Enum.CameraType.Scriptable
    
    -- Рухаємо камеру до цілі першою
    camera.CFrame = targetCF
    
    task.wait(0.1)
    
    -- Потім телепортуємо персонажа
    hrp.CFrame = targetCF
    
    task.wait(0.2)
    
    -- Повертаємо камеру
    camera.CameraType = oldCamType
end

-- Method 14: Exploit через Humanoid.Died bypass
local function deathBypassTP(targetCF)
    local char = player.Character
    if not char then return end
    
    local humanoid = char:FindFirstChild("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not hrp then return end
    
    -- Робимо персонажа "нестворимим"
    local oldHealth = humanoid.Health
    local oldMaxHealth = humanoid.MaxHealth
    
    humanoid.MaxHealth = math.huge
    humanoid.Health = math.huge
    
    -- Вимикаємо всі Humanoid події
    for _, conn in pairs(getconnections(humanoid.Died)) do
        conn:Disable()
    end
    
    task.wait(0.1)
    
    -- Телепортуємось
    hrp.CFrame = targetCF
    
    task.wait(0.3)
    
    -- Відновлюємо здоров'я
    humanoid.MaxHealth = oldMaxHealth
    humanoid.Health = oldHealth
    
    -- Вмикаємо події назад
    for _, conn in pairs(getconnections(humanoid.Died)) do
        conn:Enable()
    end
end

-- Method 15: Spoof Position через metamethods
local spoofActive = false
local spoofTarget = nil

local function spoofPosition(targetCF)
    spoofActive = true
    spoofTarget = targetCF.Position
    
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    -- Підміняємо Position при зчитуванні
    local oldIndex
    oldIndex = hookmetamethod(game, "__index", function(self, key)
        if spoofActive and self == char.HumanoidRootPart and key == "Position" then
            return spoofTarget
        end
        return oldIndex(self, key)
    end)
    
    task.wait(0.5)
    
    -- Реально телепортуємось
    char.HumanoidRootPart.CFrame = targetCF
    
    task.wait(1)
    
    spoofActive = false
end

-- 🟥 STEALER GUI
local savedCFrame = nil

local saveBtn = createActionButton(stealerPage,"💾 Save Position",0.02)
saveBtn.MouseButton1Click:Connect(function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        savedCFrame = char.HumanoidRootPart.CFrame
        saveBtn.Text = "✔ Saved!"
        saveBtn.BackgroundColor3 = Color3.fromRGB(40,100,40)
        wait(1)
        saveBtn.Text = "💾 Save Position"
        saveBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    end
end)

createLabel(stealerPage, "Fast Methods (<2 sec):", 0.13)

local tpBurst = createActionButton(stealerPage,"⚡ Burst Jump",0.20)
tpBurst.MouseButton1Click:Connect(function()
    if savedCFrame then
        burstTP(savedCFrame)
    end
end)

local tpFakeLag = createActionButton(stealerPage,"📶 Fake Lag",0.30)
tpFakeLag.MouseButton1Click:Connect(function()
    if savedCFrame then
        fakeLagTP(savedCFrame)
    end
end)

local tpNetwork = createActionButton(stealerPage,"🌐 Network Delay",0.40)
tpNetwork.MouseButton1Click:Connect(function()
    if savedCFrame then
        networkTP(savedCFrame)
    end
end)

createLabel(stealerPage, "Experimental:", 0.51)

local tpClone = createActionButton(stealerPage,"👥 Clone Swap",0.58)
tpClone.MouseButton1Click:Connect(function()
    if savedCFrame then
        cloneSwapTP(savedCFrame)
    end
end)

local tpSeat = createActionButton(stealerPage,"💺 Seat Vehicle",0.68)
tpSeat.MouseButton1Click:Connect(function()
    if savedCFrame then
        seatTP(savedCFrame)
    end
end)

local stopBtn = createActionButton(stealerPage,"⛔ Stop All",0.82)
stopBtn.BackgroundColor3 = Color3.fromRGB(120,30,30)
stopBtn.MouseButton1Click:Connect(function()
    isTping = false
    stopBtn.Text = "✔ Stopped"
    wait(0.5)
    stopBtn.Text = "⛔ Stop All"
end)

-- Info label
local infoLabel = createLabel(stealerPage, "Tip: Try Micro Step first!", 0.92)
infoLabel.TextSize = 10
infoLabel.TextColor3 = Color3.fromRGB(150,150,150)

-- 🟥 MAIN PAGE - GODMODE
local godmodeActive = false
local originalHealth = 100
local healthConnection = nil
local forceFieldActive = false

-- Method 1: Health Reset Loop
local function healthGodMode(enabled)
    if enabled then
        local char = player.Character
        if not char then return end
        local humanoid = char:FindFirstChild("Humanoid")
        if not humanoid then return end
        
        originalHealth = humanoid.MaxHealth
        
        -- Постійно відновлюємо здоров'я
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

-- Method 2: Remove Humanoid (не можна вбити те чого нема)
local function removeHumanoidGod(enabled)
    local char = player.Character
    if not char then return end
    
    if enabled then
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.Name = "GodHumanoid"
            local newHum = humanoid:Clone()
            newHum.Name = "Humanoid"
            newHum.Parent = char
            humanoid:Destroy()
        end
    end
end

-- Method 3: ForceField spam
local function forceFieldGod(enabled)
    forceFieldActive = enabled
    
    if enabled then
        task.spawn(function()
            while forceFieldActive do
                local char = player.Character
                if char then
                    if not char:FindFirstChildOfClass("ForceField") then
                        local ff = Instance.new("ForceField")
                        ff.Visible = false
                        ff.Parent = char
                    end
                end
                wait(0.5)
            end
            
            -- Прибираємо ForceField коли вимкнено
            local char = player.Character
            if char then
                for _, ff in pairs(char:GetChildren()) do
                    if ff:IsA("ForceField") then
                        ff:Destroy()
                    end
                end
            end
        end)
    end
end

-- Method 4: Anchor всі частини (не можна кільнути закріплене)
local anchorGodActive = false
local function anchorGod(enabled)
    anchorGodActive = enabled
    local char = player.Character
    if not char then return end
    
    if enabled then
        task.spawn(function()
            while anchorGodActive do
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.Anchored = true
                    end
                end
                wait(0.1)
            end
            
            -- Розанкоримо коли вимкнено
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Anchored = false
                end
            end
        end)
    end
end

-- Method 5: Respawn Protection (телепортує назад при смерті)
local respawnPos = nil
local respawnProtection = false

local function respawnGod(enabled)
    respawnProtection = enabled
    
    if enabled then
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            respawnPos = char.HumanoidRootPart.CFrame
        end
        
        player.CharacterAdded:Connect(function(newChar)
            if respawnProtection and respawnPos then
                wait(0.5)
                if newChar:FindFirstChild("HumanoidRootPart") then
                    newChar.HumanoidRootPart.CFrame = respawnPos
                end
            end
        end)
    end
end

-- GUI для Main Page
createLabel(mainPage, "GodMode Methods:", 0.02)

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

local ffGodBtn = createActionButton(mainPage,"🛡️ ForceField: OFF",0.19)
ffGodBtn.MouseButton1Click:Connect(function()
    forceFieldActive = not forceFieldActive
    forceFieldGod(forceFieldActive)
    
    if forceFieldActive then
        ffGodBtn.Text = "🛡️ ForceField: ON"
        ffGodBtn.BackgroundColor3 = Color3.fromRGB(40,100,40)
    else
        ffGodBtn.Text = "🛡️ ForceField: OFF"
        ffGodBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    end
end)

local anchorGodBtn = createActionButton(mainPage,"🔒 Anchor God: OFF",0.29)
anchorGodBtn.MouseButton1Click:Connect(function()
    anchorGodActive = not anchorGodActive
    anchorGod(anchorGodActive)
    
    if anchorGodActive then
        anchorGodBtn.Text = "🔒 Anchor God: ON"
        anchorGodBtn.BackgroundColor3 = Color3.fromRGB(40,100,40)
    else
        anchorGodBtn.Text = "🔒 Anchor God: OFF"
        anchorGodBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    end
end)

local respawnGodBtn = createActionButton(mainPage,"♻️ Respawn Save: OFF",0.39)
respawnGodBtn.MouseButton1Click:Connect(function()
    respawnProtection = not respawnProtection
    respawnGod(respawnProtection)
    
    if respawnProtection then
        respawnGodBtn.Text = "♻️ Respawn Save: ON"
        respawnGodBtn.BackgroundColor3 = Color3.fromRGB(40,100,40)
    else
        respawnGodBtn.Text = "♻️ Respawn Save: OFF"
        respawnGodBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    end
end)

local removeHumBtn = createActionButton(mainPage,"⚠️ Remove Humanoid",0.49)
removeHumBtn.BackgroundColor3 = Color3.fromRGB(100,50,30)
removeHumBtn.MouseButton1Click:Connect(function()
    removeHumanoidGod(true)
    removeHumBtn.Text = "✔ Humanoid Removed"
    wait(2)
    removeHumBtn.Text = "⚠️ Remove Humanoid"
end)

local infoMain = createLabel(mainPage, "Tip: Use Health Loop + ForceField together!", 0.62)
infoMain.TextSize = 10
infoMain.TextColor3 = Color3.fromRGB(150,150,150)

-- Visual placeholder
local visualText = Instance.new("TextLabel", visualPage)
visualText.Size = UDim2.fromScale(1,0.2)
visualText.Position = UDim2.fromScale(0,0.1)
visualText.Text = "Visual (soon)"
visualText.TextColor3 = Color3.fromRGB(200,200,200)
visualText.BackgroundTransparency = 1
visualText.Font = Enum.Font.Gotham
visualText.TextSize = 16
