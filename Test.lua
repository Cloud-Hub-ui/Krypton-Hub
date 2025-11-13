-- // services
get_service = function(service)
	return cloneref(game:GetService(service))
end

local Players            = get_service("Players")
local ReplicatedStorage  = get_service("ReplicatedStorage")
local HttpService        = get_service("HttpService")
local RunService         = get_service("RunService")
local UserInputService   = get_service("UserInputService")
local TweenService       = get_service("TweenService")

-- // references
local LocalPlayer = Players.LocalPlayer
local Remote      = ReplicatedStorage.Packages.Net["RE/LaserGun_Fire"]
local Settings    = require(ReplicatedStorage.Shared.LaserGunsShared).Settings

-- // gun mods
Settings.Radius.Value        = 256
Settings.MaxBounces.Value    = 9999
Settings.MaxAge.Value        = 1e6
Settings.StunDuration.Value  = 60
Settings.ImpulseForce.Value  = 1e6
Settings.Cooldown.Value      = 0

-- // states
local lagger_enabled = false
local last_equipped   = false

----------------------------------------------------------------
-- // NEW MODERN GUI (replace everything from the old UI block)
----------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LaserLaggerUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 100)
MainFrame.Position = UDim2.new(0, 50, 0, 50)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Glassmorphism
local Glass = Instance.new("ImageLabel")
Glass.Size = UDim2.new(1, 0, 1, 0)
Glass.BackgroundTransparency = 1
Glass.Image = "rbxassetid://186181232"
Glass.ImageTransparency = 0.95
Glass.ImageColor3 = Color3.fromRGB(255, 255, 255)
Glass.Parent = MainFrame

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 16)
Corner.Parent = MainFrame

local Stroke = Instance.new("UIStroke")
Stroke.Thickness = 1.5
Stroke.Color = Color3.fromRGB(100, 150, 255)
Stroke.Transparency = 0.7
Stroke.Parent = MainFrame

local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 60)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 25))
}
Gradient.Rotation = 135
Gradient.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 0, 30)
Title.Position = UDim2.new(0, 10, 0, 8)
Title.BackgroundTransparency = 1
Title.Text = "Laser Lagger"
Title.TextColor3 = Color3.fromRGB(200, 220, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- Toggle Button
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(1, -30, 0, 40)
ToggleBtn.Position = UDim2.new(0, 15, 1, -55)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
ToggleBtn.Text = ""
ToggleBtn.AutoButtonColor = false
ToggleBtn.Parent = MainFrame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 12)
BtnCorner.Parent = ToggleBtn

local BtnStroke = Instance.new("UIStroke")
BtnStroke.Thickness = 1
BtnStroke.Color = Color3.fromRGB(80, 120, 200)
BtnStroke.Parent = ToggleBtn

-- Knob
local Knob = Instance.new("Frame")
Knob.Size = UDim2.new(0, 32, 0, 32)
Knob.Position = UDim2.new(0, 4, 0.5, -16)
Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Knob.Parent = ToggleBtn

local KnobCorner = Instance.new("UICorner")
KnobCorner.CornerRadius = UDim.new(1, 0)
KnobCorner.Parent = Knob

local KnobShadow = Instance.new("ImageLabel")
KnobShadow.Size = UDim2.new(1, 6, 1, 6)
KnobShadow.Position = UDim2.new(0, -3, 0, -3)
KnobShadow.BackgroundTransparency = 1
KnobShadow.Image = "rbxassetid://1316045217"
KnobShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
KnobShadow.ImageTransparency = 0.8
KnobShadow.ZIndex = 0
KnobShadow.Parent = Knob

-- Button Label
local BtnLabel = Instance.new("TextLabel")
BtnLabel.Size = UDim2.new(1, -50, 1, 0)
BtnLabel.Position = UDim2.new(0, 45, 0, 0)
BtnLabel.BackgroundTransparency = 1
BtnLabel.Text = "OFF"
BtnLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
BtnLabel.Font = Enum.Font.GothamSemibold
BtnLabel.TextSize = 15
BtnLabel.TextXAlignment = Enum.TextXAlignment.Left
BtnLabel.Parent = ToggleBtn

-- Target Footer
local TargetFooter = Instance.new("TextLabel")
TargetFooter.Size = UDim2.new(1, -20, 0, 16)
TargetFooter.Position = UDim2.new(0, 10, 1, -22)
TargetFooter.BackgroundTransparency = 1
TargetFooter.Text = "Target: None"
TargetFooter.TextColor3 = Color3.fromRGB(120, 160, 220)
TargetFooter.Font = Enum.Font.Gotham
TargetFooter.TextSize = 11
TargetFooter.TextXAlignment = Enum.TextXAlignment.Left
TargetFooter.Parent = MainFrame

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 24, 0, 24)
CloseBtn.Position = UDim2.new(1, -32, 0, 8)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 120, 120)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.Parent = MainFrame

CloseBtn.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

-- // toggle animation
local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

local function updateToggle(enabled)
	lagger_enabled = enabled

	-- knob
	local knobGoal = enabled and UDim2.new(1, -36, 0.5, -16) or UDim2.new(0, 4, 0.5, -16)
	TweenService:Create(Knob, tweenInfo, {Position = knobGoal}):Play()

	-- button bg
	local bgGoal = enabled and Color3.fromRGB(80, 180, 100) or Color3.fromRGB(60, 60, 80)
	TweenService:Create(ToggleBtn, tweenInfo, {BackgroundColor3 = bgGoal}):Play()

	-- label
	BtnLabel.Text = enabled and "ON" or "OFF"
	BtnLabel.TextColor3 = enabled and Color3.fromRGB(200, 255, 200) or Color3.fromRGB(180, 180, 180)

	-- status icon
	StatusIcon.Text = enabled and "Check" or "Power"
	StatusIcon.TextColor3 = enabled and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)

	-- stroke glow
	BtnStroke.Color = enabled and Color3.fromRGB(100, 255, 120) or Color3.fromRGB(80, 120, 200)
end

ToggleBtn.MouseButton1Click:Connect(function()
	updateToggle(not lagger_enabled)
end)

-- initialise
updateToggle(false)

----------------------------------------------------------------
-- // helper: nearest player
----------------------------------------------------------------
local function getNearest()
	local char = LocalPlayer.Character
	if not (char and char.PrimaryPart) then return nil end

	local myPos = char.PrimaryPart.Position
	local nearest, shortest = nil, math.huge

	for _, plr in Players:GetPlayers() do
		if plr ~= LocalPlayer then
			local other = plr.Character
			if other and other.PrimaryPart then
				local dist = (myPos - other.PrimaryPart.Position).Magnitude
				if dist < shortest then
					shortest = dist
					nearest = plr
				end
			end
		end
	end
	return nearest
end

----------------------------------------------------------------
-- // main loop
----------------------------------------------------------------
RunService.RenderStepped:Connect(function()
	local char = LocalPlayer.Character
	if not char then return end

	local tool = char:FindFirstChildOfClass("Tool")
	local equipped = tool and tool.Name == "Laser Gun"

	if equipped ~= last_equipped then
		last_equipped = equipped
	end

	if not (lagger_enabled and equipped) then
		TargetFooter.Text = "Target: None"
		return
	end

	local target = getNearest()
	if not target then
		TargetFooter.Text = "Target: None"
		return
	end

	TargetFooter.Text = "Target: " .. target.DisplayName

	local tChar = target.Character
	if not (tChar and tChar.PrimaryPart and char.PrimaryPart) then return end

	local pos1 = char.PrimaryPart.Position
	local pos2 = tChar.PrimaryPart.Position
	local dir  = (pos2 - pos1).Unit
	local id   = HttpService:GenerateGUID(false):lower():gsub("%-", "")

	Remote:FireServer(id, pos1, dir, workspace:GetServerTimeNow())
end)
