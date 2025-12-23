-- Simple Cheat GUI

local player = game.Players.LocalPlayer

local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "MyCheat"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.25, 0.25)
frame.Position = UDim2.fromScale(0.35, 0.35)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active = true
frame.Draggable = true

local button = Instance.new("TextButton", frame)
button.Size = UDim2.fromScale(0.8, 0.3)
button.Position = UDim2.fromScale(0.1, 0.35)
button.Text = "Speed ON"
button.BackgroundColor3 = Color3.fromRGB(70,70,70)

button.MouseButton1Click:Connect(function()
    local hum = player.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = 100
    end
end)

