-- // ui - modern redesign
local screen_gui = Instance.new("ScreenGui")
screen_gui.Name = "LaserLaggerUI"
screen_gui.ResetOnSpawn = false
screen_gui.Parent = local_player:WaitForChild("PlayerGui")

local main_frame = Instance.new("Frame")
main_frame.Size = UDim2.new(0, 220, 0, 100)
main_frame.Position = UDim2.new(0, 50, 0, 50)
main_frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
main_frame.BackgroundTransparency = 0.1
main_frame.BorderSizePixel = 0
main_frame.Active = true
main_frame.Draggable = true
main_frame.Parent = screen_gui

-- Glassmorphism effect
local glass = Instance.new("ImageLabel")
glass.Size = UDim2.new(1, 0, 1, 0)
glass.BackgroundTransparency = 1
glass.Image = "rbxassetid://186181232" -- Subtle noise texture
glass.ImageTransparency = 0.95
glass.ImageColor3 = Color3.fromRGB(255, 255, 255)
glass.Parent = main_frame

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)
corner.Parent = main_frame

local stroke = Instance.new("UIStroke")
stroke.Thickness = 1.5
stroke.Color = Color3.fromRGB(100, 150, 255)
stroke.Transparency = 0.7
stroke.Parent = main_frame

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 60)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 25))
})
gradient.Rotation = 135
gradient.Parent = main_frame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 30)
title.Position = UDim2.new(0, 10, 0, 8)
title.BackgroundTransparency = 1
title.Text = "Laser Lagger"
title.TextColor3 = Color3.fromRGB(200, 220, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main_frame

-- Status Icon
local status_icon = Instance.new("TextLabel")
status_icon.Size = UDim2.new(0, 24, 0, 24)
status_icon.Position = UDim2.new(1, -34, 0, 8)
status_icon.BackgroundTransparency = 1
status_icon.Text = "⏻"
status_icon.TextColor3 = Color3.fromRGB(255, 100, 100)
status_icon.Font = Enum.Font.GothamBold
status_icon.TextSize = 18
status_icon.Parent = main_frame

-- Toggle Button
local toggle_button = Instance.new("TextButton")
toggle_button.Size = UDim2.new(1, -30, 0, 40)
toggle_button.Position = UDim2.new(0, 15, 1, -55)
toggle_button.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
toggle_button.Text = ""
toggle_button.AutoButtonColor = false
toggle_button.Parent = main_frame

local button_corner = Instance.new("UICorner")
button_corner.CornerRadius = UDim.new(0, 12)
button_corner.Parent = toggle_button

local button_stroke = Instance.new("UIStroke")
button_stroke.Thickness = 1
button_stroke.Color = Color3.fromRGB(80, 120, 200)
button_stroke.Parent = toggle_button

-- Toggle Knob
local knob = Instance.new("Frame")
knob.Size = UDim2.new(0, 32, 0, 32)
knob.Position = UDim2.new(0, 4, 0.5, -16)
knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
knob.Parent = toggle_button

local knob_corner = Instance.new("UICorner")
knob_corner.CornerRadius = UDim.new(1, 0)
knob_corner.Parent = knob

local knob_shadow = Instance.new("ImageLabel")
knob_shadow.Size = UDim2.new(1, 6, 1, 6)
knob_shadow.Position = UDim2.new(0, -3, 0, -3)
knob_shadow.BackgroundTransparency = 1
knob_shadow.Image = "rbxassetid://1316045217" -- Soft shadow
knob_shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
knob_shadow.ImageTransparency = 0.8
knob_shadow.ZIndex = 0
knob_shadow.Parent = knob

-- Button Label
local button_label = Instance.new("TextLabel")
button_label.Size = UDim2.new(1, -50, 1, 0)
button_label.Position = UDim2.new(0, 45, 0, 0)
button_label.BackgroundTransparency = 1
button_label.Text = "OFF"
button_label.TextColor3 = Color3.fromRGB(180, 180, 180)
button_label.Font = Enum.Font.GothamSemibold
button_label.TextSize = 15
button_label.TextXAlignment = Enum.TextXAlignment.Left
button_label.Parent = toggle_button

-- Footer (optional info)
local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, -20, 0, 16)
footer.Position = UDim2.new(0, 10, 1, -22)
footer.BackgroundTransparency = 1
footer.Text = "Target: Nearest Player"
footer.TextColor3 = Color3.fromRGB(120, 160, 220)
footer.Font = Enum.Font.Gotham
footer.TextSize = 11
footer.TextXAlignment = Enum.TextXAlignment.Left
footer.Parent = main_frame

-- // toggle logic with smooth animation
local tween_service = game:GetService("TweenService")
local tween_info = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

local function update_toggle(enabled)
	lagger_enabled = enabled

	-- Animate knob
	local knob_goal = enabled and UDim2.new(1, -36, 0.5, -16) or UDim2.new(0, 4, 0.5, -16)
	local knob_tween = tween_service:Create(knob, tween_info, { Position = knob_goal })
	knob_tween:Play()

	-- Background color
	local bg_color = enabled and Color3.fromRGB(80, 180, 100) or Color3.fromRGB(60, 60, 80)
	local bg_tween = tween_service:Create(toggle_button, tween_info, { BackgroundColor3 = bg_color })
	bg_tween:Play()

	-- Label
	button_label.Text = enabled and "ON" or "OFF"
	button_label.TextColor3 = enabled and Color3.fromRGB(200, 255, 200) or Color3.fromRGB(180, 180, 180)

	-- Status icon
	status_icon.Text = enabled and "✓" or "⏻"
	status_icon.TextColor3 = enabled and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)

	-- Stroke glow
	button_stroke.Color = enabled and Color3.fromRGB(100, 255, 120) or Color3.fromRGB(80, 120, 200)
end

toggle_button.MouseButton1Click:Connect(function()
	update_toggle(not lagger_enabled)
end)

-- Initialize
update_toggle(false)

-- Optional: Close button
local close_btn = Instance.new("TextButton")
close_btn.Size = UDim2.new(0, 24, 0, 24)
close_btn.Position = UDim2.new(1, -32, 0, 8)
close_btn.BackgroundTransparency = 1
close_btn.Text = "✕"
close_btn.TextColor3 = Color3.fromRGB(255, 120, 120)
close_btn.Font = Enum.Font.GothamBold
close_btn.TextSize = 16
close_btn.Parent = main_frame

close_btn.MouseButton1Click:Connect(function()
	screen_gui:Destroy()
end)
