-- Speed Hub Library (Enhanced Version)
-- + Dragging GUI
-- + Toggle Button
-- + Logo beside Title

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local SpeedHub = {}
SpeedHub.__index = SpeedHub

SpeedHub.Colors = {
	Primary = Color3.fromRGB(0, 170, 255),
	Secondary = Color3.fromRGB(88, 101, 242),
	Background = Color3.fromRGB(30, 30, 35),
	Card = Color3.fromRGB(45, 45, 50),
	Text = Color3.fromRGB(255, 255, 255),
	TextSecondary = Color3.fromRGB(200, 200, 200),
	Success = Color3.fromRGB(76, 175, 80),
	Danger = Color3.fromRGB(220, 60, 60)
}

function SpeedHub:MakeWindow(config)
	config = config or {}

	if playerGui:FindFirstChild("SpeedHub") then
		playerGui.SpeedHub:Destroy()
	end

	-- 🌟 Toggle Button
	local ToggleButton = Instance.new("TextButton")
	ToggleButton.Name = "SpeedHubToggle"
	ToggleButton.Size = UDim2.new(0, 100, 0, 40)
	ToggleButton.Position = UDim2.new(0, 20, 0.5, -20)
	ToggleButton.BackgroundColor3 = SpeedHub.Colors.Primary
	ToggleButton.Text = "⚡ HUB"
	ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	ToggleButton.TextSize = 16
	ToggleButton.Font = Enum.Font.GothamBold
	ToggleButton.BorderSizePixel = 0

	local ToggleCorner = Instance.new("UICorner")
	ToggleCorner.CornerRadius = UDim.new(0, 8)
	ToggleCorner.Parent = ToggleButton

	ToggleButton.Parent = playerGui

	-- 🌙 Main GUI
	local Window = {}
	Window.Gui = Instance.new("ScreenGui")
	Window.Gui.Name = "SpeedHub"
	Window.Gui.ResetOnSpawn = false
	Window.Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	Window.Gui.Enabled = false -- ซ่อนตอนเริ่มต้น
	Window.Gui.Parent = playerGui

	-- 🧱 Main Frame
	Window.MainFrame = Instance.new("Frame")
	Window.MainFrame.Name = "MainFrame"
	Window.MainFrame.Size = UDim2.new(0, 520, 0, 460)
	Window.MainFrame.Position = UDim2.new(0.5, -260, 0.5, -230)
	Window.MainFrame.BackgroundColor3 = SpeedHub.Colors.Background
	Window.MainFrame.BorderSizePixel = 0
	Window.MainFrame.Active = true
	Window.MainFrame.Draggable = false
	Window.MainFrame.Parent = Window.Gui

	local Corner = Instance.new("UICorner", Window.MainFrame)
	Corner.CornerRadius = UDim.new(0, 12)

	local Stroke = Instance.new("UIStroke", Window.MainFrame)
	Stroke.Color = Color3.fromRGB(60, 60, 70)
	Stroke.Thickness = 2

	-- 🌟 Title Bar
	local TitleBar = Instance.new("Frame")
	TitleBar.Size = UDim2.new(1, 0, 0, 50)
	TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
	TitleBar.BorderSizePixel = 0
	TitleBar.Parent = Window.MainFrame

	local TitleCorner = Instance.new("UICorner", TitleBar)
	TitleCorner.CornerRadius = UDim.new(0, 12)

	-- 🪩 Logo beside Title
	local Logo = Instance.new("ImageLabel")
	Logo.Name = "Logo"
	Logo.Size = UDim2.new(0, 30, 0, 30)
	Logo.Position = UDim2.new(0, 10, 0, 10)
	Logo.BackgroundTransparency = 1
	Logo.Image = config.Logo or "rbxassetid://10709751939" -- << เปลี่ยนไอดีรูปได้
	Logo.Parent = TitleBar

	local Title = Instance.new("TextLabel")
	Title.Text = config.Title or "SpeedHub"
	Title.Size = UDim2.new(0, 400, 0, 40)
	Title.Position = UDim2.new(0, 50, 0, 5)
	Title.BackgroundTransparency = 1
	Title.TextColor3 = SpeedHub.Colors.Text
	Title.TextSize = 22
	Title.Font = Enum.Font.GothamBold
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.Parent = TitleBar

	-- ❌ Close Button
	local Close = Instance.new("TextButton")
	Close.Size = UDim2.new(0, 30, 0, 30)
	Close.Position = UDim2.new(1, -40, 0, 10)
	Close.BackgroundColor3 = SpeedHub.Colors.Danger
	Close.Text = "X"
	Close.TextColor3 = Color3.new(1, 1, 1)
	Close.Font = Enum.Font.GothamBold
	Close.TextSize = 16
	Close.BorderSizePixel = 0
	Close.Parent = TitleBar

	local CloseCorner = Instance.new("UICorner", Close)
	CloseCorner.CornerRadius = UDim.new(0, 8)

	Close.MouseButton1Click:Connect(function()
		Window.Gui.Enabled = false
	end)

	-- 🎯 Dragging System
	local dragging, dragStart, startPos
	TitleBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = Window.MainFrame.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			Window.MainFrame.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	-- 🌗 Toggle visibility
	local visible = false
	ToggleButton.MouseButton1Click:Connect(function()
		visible = not visible
		Window.Gui.Enabled = visible

		TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
			BackgroundColor3 = visible and SpeedHub.Colors.Secondary or SpeedHub.Colors.Primary
		}):Play()
	end)

	return Window
end

return SpeedHub
