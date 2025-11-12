local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

-- Saved CFrame
local savedCFrame = nil

-- Secret Fling Up + TP (makes it look like a glitch/lag)
local function flingThenTP()
    if not savedCFrame or not character or not character:FindFirstChild("HumanoidRootPart") then return end

    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 300, 0) -- Fling upward
    bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
    bodyVelocity.Parent = hrp

    -- Remove fling after 0.4s, then TP
    task.delay(0.4, function()
        if bodyVelocity and bodyVelocity.Parent then
            bodyVelocity:Destroy()
        end
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = savedCFrame
        end
    end)

    -- Optional tiny camera shake for realism (silent)
    local cam = workspace.CurrentCamera
    local start = tick()
    local shakeConn
    shakeConn = RunService.Heartbeat:Connect(function()
        local t = tick() - start
        if t > 0.6 then shakeConn:Disconnect() return end
        local intensity = 8 * (1 - t / 0.6)
        local offset = Vector3.new(
            math.random(-intensity, intensity),
            math.random(-intensity, intensity),
            0
        ) * 0.3
        cam.CFrame = cam.CFrame * CFrame.new(offset)
    end)
end

-- Save Position
local function savePos()
    if hrp then
        savedCFrame = hrp.CFrame
        game.StarterGui:SetCore("ChatMakeSystemMessage", {
            Text = "[Cloud Hub] Position saved!",
            Color = Color3.fromRGB(100, 255, 255)
        })
    end
end

-- === GUI ===
local gui = Instance.new("ScreenGui")
gui.Name = "CloudHub"
gui.ResetOnSpawn = false
gui.Parent = CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 180, 0, 100)
frame.Position = UDim2.new(0.02, 0, 0.35, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(80, 200, 255)
stroke.Thickness = 2
stroke.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundTransparency = 1
title.Text = "Cloud Hub"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.Parent = frame

-- Save Button
local saveBtn = Instance.new("TextButton")
saveBtn.Size = UDim2.new(0.8, 0, 0.25, 0)
saveBtn.Position = UDim2.new(0.1, 0, 0.4, 0)
saveBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
saveBtn.Text = "SAVE"
saveBtn.TextColor3 = Color3.new(1,1,1)
saveBtn.Font = Enum.Font.GothamSemibold
saveBtn.TextScaled = true
saveBtn.Parent = frame

local saveCorner = Instance.new("UICorner")
saveCorner.CornerRadius = UDim.new(0, 6)
saveCorner.Parent = saveBtn

-- TP Button
local tpBtn = Instance.new("TextButton")
tpBtn.Size = UDim2.new(0.8, 0, 0.25, 0)
tpBtn.Position = UDim2.new(0.1, 0, 0.7, 0)
tpBtn.BackgroundColor3 = Color3.fromRGB(120, 50, 200)
tpBtn.Text = "TP"
tpBtn.TextColor3 = Color3.new(1,1,1)
tpBtn.Font = Enum.Font.GothamSemibold
tpBtn.TextScaled = true
tpBtn.Parent = frame

local tpCorner = Instance.new("UICorner")
tpCorner.CornerRadius = UDim.new(0, 6)
tpCorner.Parent = tpBtn

-- Hover Effects
local function hover(btn, enterColor, leaveColor)
    btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = enterColor}):Play() end)
    btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = leaveColor}):Play() end)
end

hover(saveBtn, Color3.fromRGB(0, 200, 255), Color3.fromRGB(0, 170, 255))
hover(tpBtn, Color3.fromRGB(150, 80, 240), Color3.fromRGB(120, 50, 200))

-- Connect Buttons
saveBtn.MouseButton1Click:Connect(savePos)
tpBtn.MouseButton1Click:Connect(function()
    if savedCFrame then
        flingThenTP()
        game.StarterGui:SetCore("ChatMakeSystemMessage", {
            Text = "[Cloud Hub] Teleporting...",
            Color = Color3.fromRGB(200, 200, 255)
        })
    else
        game.StarterGui:SetCore("ChatMakeSystemMessage", {
            Text = "[Cloud Hub] Save a position first!",
            Color = Color3.fromRGB(255, 100, 100)
        })
    end
end)

-- Respawn Handler
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    hrp = newChar:WaitForChild("HumanoidRootPart")
end)

-- Startup
game.StarterGui:SetCore("ChatMakeSystemMessage", {
    Text = "[Cloud Hub] GUI Loaded. SAVE → TP",
    Color = Color3.fromRGB(100, 255, 255)
})
]])()
