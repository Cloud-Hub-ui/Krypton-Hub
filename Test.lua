-- Save & Teleport Script (LocalScript)
-- Place this in StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Storage for saved position
local savedPosition = nil
local savedCFrame = nil

-- Command prefix
local PREFIX = "/"

-- Function to save position
local function savePosition()
	if humanoidRootPart then
		savedCFrame = humanoidRootPart.CFrame
		savedPosition = humanoidRootPart.Position
		print("Position saved at:", savedPosition)
		-- Optional: Show message in chat or GUI
		game.StarterGui:SetCore("ChatMakeSystemMessage", {
			Text = "[SaveTP] Position saved!";
			Color = Color3.fromRGB(0, 255, 0);
		})
	end
end

-- Function to teleport to saved position
local function teleportToSaved()
	if savedCFrame and humanoidRootPart then
		humanoidRootPart.CFrame = savedCFrame
		print("Teleported to saved position:", savedPosition)
		game.StarterGui:SetCore("ChatMakeSystemMessage", {
			Text = "[SaveTP] Teleported to saved spot!";
			Color = Color3.fromRGB(0, 170, 255);
		})
	else
		game.StarterGui:SetCore("ChatMakeSystemMessage", {
			Text = "[SaveTP] No saved position! Use /save first.";
			Color = Color3.fromRGB(255, 100, 100);
		})
	end
end

-- Handle chat commands
player.Chatted:Connect(function(message)
	local cmd = string.lower(message)

	if cmd == PREFIX .. "save" then
		savePosition()
	elseif cmd == PREFIX .. "tp" or cmd == PREFIX .. "teleport" then
		teleportToSaved()
	end
end)

-- Optional: Bind to keys (e.g., F5 to save, F6 to TP)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end

	if input.KeyCode == Enum.KeyCode.F5 then
		savePosition()
	elseif input.KeyCode == Enum.KeyCode.F6 then
		teleportToSaved()
	end
end)

-- Update character reference if player respawns
player.CharacterAdded:Connect(function(newChar)
	character = newChar
	humanoidRootPart = character:WaitForChild("HumanoidRootPart")
end)

print("SaveTP Script loaded! Use /save and /tp in chat, or F5/F6 keys.")
