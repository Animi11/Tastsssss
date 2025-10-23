-- Speed Hub Library for Xeno Delta
-- Advanced UI with Tabs, Sections, and Controls

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Speed Hub Library
local SpeedHub = {}
SpeedHub.__index = SpeedHub

-- Colors
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
    
    -- ตรวจสอบว่ามี UI อยู่แล้วหรือไม่
    if playerGui:FindFirstChild("SpeedHub") then
        playerGui.SpeedHub:Destroy()
    end

    -- สร้าง ScreenGui หลัก
    local Window = {}
    Window.Gui = Instance.new("ScreenGui")
    Window.Gui.Name = "SpeedHub"
    Window.Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    Window.Gui.ResetOnSpawn = false

    -- สร้าง Main Frame
    Window.MainFrame = Instance.new("Frame")
    Window.MainFrame.Name = "MainFrame"
    Window.MainFrame.Size = UDim2.new(0, 500, 0, 450)
    Window.MainFrame.Position = UDim2.new(0.5, -250, 0.5, -225)
    Window.MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    Window.MainFrame.BackgroundColor3 = SpeedHub.Colors.Background
    Window.MainFrame.BorderSizePixel = 0
    Window.MainFrame.ClipsDescendants = true

    -- Corner radius
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = Window.MainFrame

    -- Shadow effect
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(60, 60, 70)
    UIStroke.Thickness = 2
    UIStroke.Parent = Window.MainFrame

    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 50)
    TitleBar.Position = UDim2.new(0, 0, 0, 0)
    TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    TitleBar.BorderSizePixel = 0

    local TitleBarCorner = Instance.new("UICorner")
    TitleBarCorner.CornerRadius = UDim.new(0, 12)
    TitleBarCorner.Parent = TitleBar

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(0.7, 0, 0.6, 0)
    Title.Position = UDim2.new(0, 15, 0, 5)
    Title.BackgroundTransparency = 1
    Title.Text = config.Title or "SPEED HUB"
    Title.TextColor3 = SpeedHub.Colors.Text
    Title.TextSize = 20
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar

    local SubTitle = Instance.new("TextLabel")
    SubTitle.Name = "SubTitle"
    SubTitle.Size = UDim2.new(0.7, 0, 0.4, 0)
    SubTitle.Position = UDim2.new(0, 15, 0, 25)
    SubTitle.BackgroundTransparency = 1
    SubTitle.Text = config.SubTitle or "by Speed Hub"
    SubTitle.TextColor3 = SpeedHub.Colors.TextSecondary
    SubTitle.TextSize = 12
    SubTitle.Font = Enum.Font.Gotham
    SubTitle.TextXAlignment = Enum.TextXAlignment.Left
    SubTitle.Parent = TitleBar

    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0, 10)
    CloseButton.BackgroundColor3 = SpeedHub.Colors.Danger
    CloseButton.BorderSizePixel = 0
    CloseButton.Text = "X"
    CloseButton.TextColor3 = SpeedHub.Colors.Text
    CloseButton.TextSize = 14
    CloseButton.Font = Enum.Font.GothamBold

    local CloseButtonCorner = Instance.new("UICorner")
    CloseButtonCorner.CornerRadius = UDim.new(0, 6)
    CloseButtonCorner.Parent = CloseButton

    CloseButton.Parent = TitleBar

    -- Tab Buttons Container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(1, 0, 0, 40)
    TabContainer.Position = UDim2.new(0, 0, 0, 50)
    TabContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = Window.MainFrame

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.FillDirection = Enum.FillDirection.Horizontal
    TabListLayout.Padding = UDim.new(0, 5)
    TabListLayout.Parent = TabContainer

    -- Content Area
    Window.ContentFrame = Instance.new("Frame")
    Window.ContentFrame.Name = "ContentFrame"
    Window.ContentFrame.Size = UDim2.new(1, -20, 1, -110)
    Window.ContentFrame.Position = UDim2.new(0, 10, 0, 100)
    Window.ContentFrame.BackgroundTransparency = 1
    Window.ContentFrame.Parent = Window.MainFrame

    -- Tabs Management
    Window.Tabs = {}
    Window.CurrentTab = nil

    function Window:MakeTab(tabConfig)
        local Tab = {}
        Tab.Name = tabConfig[1] or "Tab"
        Tab.Icon = tabConfig[2] or "📁"
        
        -- Create Tab Button
        Tab.Button = Instance.new("TextButton")
        Tab.Button.Name = Tab.Name .. "TabButton"
        Tab.Button.Size = UDim2.new(0, 100, 0, 35)
        Tab.Button.Position = UDim2.new(0, 0, 0, 2)
        Tab.Button.BackgroundColor3 = SpeedHub.Colors.Card
        Tab.Button.BorderSizePixel = 0
        Tab.Button.Text = Tab.Icon .. " " .. Tab.Name
        Tab.Button.TextColor3 = SpeedHub.Colors.TextSecondary
        Tab.Button.TextSize = 14
        Tab.Button.Font = Enum.Font.GothamSemibold
        
        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 8)
        ButtonCorner.Parent = Tab.Button
        
        -- Create Tab Content
        Tab.Content = Instance.new("ScrollingFrame")
        Tab.Content.Name = Tab.Name .. "Content"
        Tab.Content.Size = UDim2.new(1, 0, 1, 0)
        Tab.Content.BackgroundTransparency = 1
        Tab.Content.BorderSizePixel = 0
        Tab.Content.ScrollBarThickness = 4
        Tab.Content.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 90)
        Tab.Content.CanvasSize = UDim2.new(0, 0, 0, 0)
        Tab.Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Tab.Content.Visible = false
        
        local ContentListLayout = Instance.new("UIListLayout")
        ContentListLayout.Padding = UDim.new(0, 10)
        ContentListLayout.Parent = Tab.Content
        
        -- Add to containers
        Tab.Button.Parent = TabContainer
        Tab.Content.Parent = Window.ContentFrame
        
        -- Tab selection function
        function Tab:Select()
            if Window.CurrentTab then
                Window.CurrentTab.Button.BackgroundColor3 = SpeedHub.Colors.Card
                Window.CurrentTab.Button.TextColor3 = SpeedHub.Colors.TextSecondary
                Window.CurrentTab.Content.Visible = false
                
                TweenService:Create(Window.CurrentTab.Button, TweenInfo.new(0.2), {
                    BackgroundColor3 = SpeedHub.Colors.Card
                }):Play()
            end
            
            Window.CurrentTab = Tab
            Tab.Button.BackgroundColor3 = SpeedHub.Colors.Primary
            Tab.Button.TextColor3 = SpeedHub.Colors.Text
            Tab.Content.Visible = true
            
            TweenService:Create(Tab.Button, TweenInfo.new(0.2), {
                BackgroundColor3 = SpeedHub.Colors.Primary
            }):Play()
        end
        
        -- Button click event
        Tab.Button.MouseButton1Click:Connect(function()
            Tab:Select()
        end)
        
        -- Hover effects
        Tab.Button.MouseEnter:Connect(function()
            if Window.CurrentTab ~= Tab then
                TweenService:Create(Tab.Button, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(55, 55, 60)
                }):Play()
            end
        end)
        
        Tab.Button.MouseLeave:Connect(function()
            if Window.CurrentTab ~= Tab then
                TweenService:Create(Tab.Button, TweenInfo.new(0.2), {
                    BackgroundColor3 = SpeedHub.Colors.Card
                }):Play()
            end
        end)
        
        -- Control creation functions
        function Tab:AddSection(sectionConfig)
            local Section = {}
            Section.Name = sectionConfig[1] or "Section"
            
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Name = Section.Name .. "Section"
            SectionFrame.Size = UDim2.new(1, 0, 0, 0)
            SectionFrame.BackgroundTransparency = 1
            SectionFrame.AutomaticSize = Enum.AutomaticSize.Y
            
            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Name = "SectionTitle"
            SectionTitle.Size = UDim2.new(1, 0, 0, 25)
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Text = Section.Name
            SectionTitle.TextColor3 = SpeedHub.Colors.Text
            SectionTitle.TextSize = 16
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            SectionTitle.Parent = SectionFrame
            
            local SectionContent = Instance.new("Frame")
            SectionContent.Name = "SectionContent"
            SectionContent.Size = UDim2.new(1, -10, 0, 0)
            SectionContent.Position = UDim2.new(0, 10, 0, 25)
            SectionContent.BackgroundTransparency = 1
            SectionContent.AutomaticSize = Enum.AutomaticSize.Y
            SectionContent.Parent = SectionFrame
            
            local SectionListLayout = Instance.new("UIListLayout")
            SectionListLayout.Padding = UDim.new(0, 8)
            SectionListLayout.Parent = SectionContent
            
            SectionFrame.Parent = Tab.Content
            
            return Section
        end
        
        function Tab:AddButton(buttonConfig)
            local Button = {}
            Button.Name = buttonConfig[1] or "Button"
            Button.Callback = buttonConfig[2] or function() end
            
            local ButtonFrame = Instance.new("TextButton")
            ButtonFrame.Name = Button.Name .. "Button"
            ButtonFrame.Size = UDim2.new(1, 0, 0, 40)
            ButtonFrame.BackgroundColor3 = SpeedHub.Colors.Card
            ButtonFrame.BorderSizePixel = 0
            ButtonFrame.Text = Button.Name
            ButtonFrame.TextColor3 = SpeedHub.Colors.Text
            ButtonFrame.TextSize = 14
            ButtonFrame.Font = Enum.Font.GothamSemibold
            ButtonFrame.AutoButtonColor = false
            
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 8)
            ButtonCorner.Parent = ButtonFrame
            
            local ButtonStroke = Instance.new("UIStroke")
            ButtonStroke.Color = Color3.fromRGB(70, 70, 80)
            ButtonStroke.Thickness = 1
            ButtonStroke.Parent = ButtonFrame
            
            -- Hover effects
            ButtonFrame.MouseEnter:Connect(function()
                TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {
                    BackgroundColor3 = SpeedHub.Colors.Primary
                }):Play()
            end)
            
            ButtonFrame.MouseLeave:Connect(function()
                TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {
                    BackgroundColor3 = SpeedHub.Colors.Card
                }):Play()
            end)
            
            -- Click event
            ButtonFrame.MouseButton1Click:Connect(function()
                Button.Callback()
                
                -- Click animation
                TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {
                    BackgroundColor3 = SpeedHub.Colors.Secondary
                }):Play()
                wait(0.1)
                TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {
                    BackgroundColor3 = SpeedHub.Colors.Primary
                }):Play()
            end)
            
            ButtonFrame.Parent = Tab.Content
            
            return Button
        end
        
        function Tab:AddToggle(toggleConfig)
            local Toggle = {}
            Toggle.Name = toggleConfig.Name or "Toggle"
            Toggle.Description = toggleConfig.Description or ""
            Toggle.Default = toggleConfig.Default or false
            Toggle.Value = Toggle.Default
            
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Name = Toggle.Name .. "Toggle"
            ToggleFrame.Size = UDim2.new(1, 0, 0, 50)
            ToggleFrame.BackgroundColor3 = SpeedHub.Colors.Card
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.AutomaticSize = Enum.AutomaticSize.Y
            
            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 8)
            ToggleCorner.Parent = ToggleFrame
            
            local ToggleStroke = Instance.new("UIStroke")
            ToggleStroke.Color = Color3.fromRGB(70, 70, 80)
            ToggleStroke.Thickness = 1
            ToggleStroke.Parent = ToggleFrame
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Name = "ToggleLabel"
            ToggleLabel.Size = UDim2.new(0.7, 0, 0, 25)
            ToggleLabel.Position = UDim2.new(0, 10, 0, 5)
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Text = Toggle.Name
            ToggleLabel.TextColor3 = SpeedHub.Colors.Text
            ToggleLabel.TextSize = 14
            ToggleLabel.Font = Enum.Font.GothamSemibold
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.Parent = ToggleFrame
            
            local ToggleDescription = Instance.new("TextLabel")
            ToggleDescription.Name = "ToggleDescription"
            ToggleDescription.Size = UDim2.new(0.7, 0, 0, 20)
            ToggleDescription.Position = UDim2.new(0, 10, 0, 25)
            ToggleDescription.BackgroundTransparency = 1
            ToggleDescription.Text = Toggle.Description
            ToggleDescription.TextColor3 = SpeedHub.Colors.TextSecondary
            ToggleDescription.TextSize = 11
            ToggleDescription.Font = Enum.Font.Gotham
            ToggleDescription.TextXAlignment = Enum.TextXAlignment.Left
            ToggleDescription.RichText = true
            ToggleDescription.Parent = ToggleFrame
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Name = "ToggleButton"
            ToggleButton.Size = UDim2.new(0, 40, 0, 20)
            ToggleButton.Position = UDim2.new(1, -50, 0, 15)
            ToggleButton.BackgroundColor3 = Toggle.Default and SpeedHub.Colors.Primary or SpeedHub.Colors.Card
            ToggleButton.BorderSizePixel = 0
            ToggleButton.Text = ""
            ToggleButton.AutoButtonColor = false
            
            local ToggleButtonCorner = Instance.new("UICorner")
            ToggleButtonCorner.CornerRadius = UDim.new(0, 10)
            ToggleButtonCorner.Parent = ToggleButton
            
            local ToggleIndicator = Instance.new("Frame")
            ToggleIndicator.Name = "ToggleIndicator"
            ToggleIndicator.Size = UDim2.new(0, 16, 0, 16)
            ToggleIndicator.Position = UDim2.new(0, Toggle.Default and 20 or 2, 0, 2)
            ToggleIndicator.BackgroundColor3 = SpeedHub.Colors.Text
            ToggleIndicator.BorderSizePixel = 0
            
            local ToggleIndicatorCorner = Instance.new("UICorner")
            ToggleIndicatorCorner.CornerRadius = UDim.new(0, 8)
            ToggleIndicatorCorner.Parent = ToggleIndicator
            
            ToggleIndicator.Parent = ToggleButton
            ToggleButton.Parent = ToggleFrame
            
            function Toggle:SetValue(value)
                self.Value = value
                
                if value then
                    TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
                        BackgroundColor3 = SpeedHub.Colors.Primary
                    }):Play()
                    TweenService:Create(ToggleIndicator, TweenInfo.new(0.2), {
                        Position = UDim2.new(0, 20, 0, 2)
                    }):Play()
                else
                    TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
                        BackgroundColor3 = SpeedHub.Colors.Card
                    }):Play()
                    TweenService:Create(ToggleIndicator, TweenInfo.new(0.2), {
                        Position = UDim2.new(0, 2, 0, 2)
                    }):Play()
                end
            end
            
            Toggle.Callback = function(value) end
            
            function Toggle:Callback(func)
                self.Callback = func
            end
            
            -- Toggle click event
            ToggleButton.MouseButton1Click:Connect(function()
                Toggle.Value = not Toggle.Value
                Toggle:SetValue(Toggle.Value)
                Toggle.Callback(Toggle.Value)
            end)
            
            ToggleFrame.Parent = Tab.Content
            
            -- Set initial value
            Toggle:SetValue(Toggle.Default)
            
            return Toggle
        end
        
        function Tab:AddSlider(sliderConfig)
            local Slider = {}
            Slider.Name = sliderConfig.Name or "Slider"
            Slider.Min = sliderConfig.Min or 0
            Slider.Max = sliderConfig.Max or 100
            Slider.Increase = sliderConfig.Increase or 1
            Slider.Default = sliderConfig.Default or Slider.Min
            Slider.Value = Slider.Default
            
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Name = Slider.Name .. "Slider"
            SliderFrame.Size = UDim2.new(1, 0, 0, 60)
            SliderFrame.BackgroundColor3 = SpeedHub.Colors.Card
            SliderFrame.BorderSizePixel = 0
            
            local SliderCorner = Instance.new("UICorner")
            SliderCorner.CornerRadius = UDim.new(0, 8)
            SliderCorner.Parent = SliderFrame
            
            local SliderStroke = Instance.new("UIStroke")
            SliderStroke.Color = Color3.fromRGB(70, 70, 80)
            SliderStroke.Thickness = 1
            SliderStroke.Parent = SliderFrame
            
            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Name = "SliderLabel"
            SliderLabel.Size = UDim2.new(1, -20, 0, 20)
            SliderLabel.Position = UDim2.new(0, 10, 0, 5)
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Text = Slider.Name .. ": " .. Slider.Value
            SliderLabel.TextColor3 = SpeedHub.Colors.Text
            SliderLabel.TextSize = 14
            SliderLabel.Font = Enum.Font.GothamSemibold
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            SliderLabel.Parent = SliderFrame
            
            local SliderTrack = Instance.new("Frame")
            SliderTrack.Name = "SliderTrack"
            SliderTrack.Size = UDim2.new(1, -20, 0, 6)
            SliderTrack.Position = UDim2.new(0, 10, 0, 35)
            SliderTrack.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            SliderTrack.BorderSizePixel = 0
            
            local SliderTrackCorner = Instance.new("UICorner")
            SliderTrackCorner.CornerRadius = UDim.new(0, 3)
            SliderTrackCorner.Parent = SliderTrack
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Name = "SliderFill"
            SliderFill.Size = UDim2.new((Slider.Value - Slider.Min) / (Slider.Max - Slider.Min), 0, 1, 0)
            SliderFill.BackgroundColor3 = SpeedHub.Colors.Primary
            SliderFill.BorderSizePixel = 0
            
            local SliderFillCorner = Instance.new("UICorner")
            SliderFillCorner.CornerRadius = UDim.new(0, 3)
            SliderFillCorner.Parent = SliderFill
            
            local SliderButton = Instance.new("TextButton")
            SliderButton.Name = "SliderButton"
            SliderButton.Size = UDim2.new(0, 16, 0, 16)
            SliderButton.Position = UDim2.new((Slider.Value - Slider.Min) / (Slider.Max - Slider.Min), -8, 0.5, -8)
            SliderButton.BackgroundColor3 = SpeedHub.Colors.Text
            SliderButton.BorderSizePixel = 0
            SliderButton.Text = ""
            SliderButton.AutoButtonColor = false
            
            local SliderButtonCorner = Instance.new("UICorner")
            SliderButtonCorner.CornerRadius = UDim.new(0, 8)
            SliderButtonCorner.Parent = SliderButton
            
            SliderFill.Parent = SliderTrack
            SliderButton.Parent = SliderTrack
            SliderTrack.Parent = SliderFrame
            
            function Slider:SetValue(value)
                value = math.clamp(value, self.Min, self.Max)
                self.Value = value
                SliderLabel.Text = self.Name .. ": " .. value
                
                local fillSize = (value - self.Min) / (self.Max - self.Min)
                SliderFill.Size = UDim2.new(fillSize, 0, 1, 0)
                SliderButton.Position = UDim2.new(fillSize, -8, 0.5, -8)
            end
            
            Slider.Callback = function(value) end
            
            -- Slider dragging
            local dragging = false
            
            local function updateSlider(input)
                local relativeX = (input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X
                local value = math.floor(Slider.Min + relativeX * (Slider.Max - Slider.Min))
                value = math.clamp(value, Slider.Min, Slider.Max)
                
                Slider:SetValue(value)
                Slider.Callback(value)
            end
            
            SliderButton.MouseButton1Down:Connect(function()
                dragging = true
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateSlider(input)
                end
            end)
            
            SliderTrack.MouseButton1Down:Connect(function(input)
                updateSlider(input)
            end)
            
            SliderFrame.Parent = Tab.Content
            
            -- Set initial value
            Slider:SetValue(Slider.Default)
            
            return Slider
        end
        
        function Tab:AddDropdown(dropdownConfig)
            local Dropdown = {}
            Dropdown.Name = dropdownConfig.Name or "Dropdown"
            Dropdown.Description = dropdownConfig.Description or ""
            Dropdown.Options = dropdownConfig.Options or {}
            Dropdown.Default = dropdownConfig.Default or Dropdown.Options[1]
            Dropdown.Value = Dropdown.Default
            Dropdown.Open = false
            
            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Name = Dropdown.Name .. "Dropdown"
            DropdownFrame.Size = UDim2.new(1, 0, 0, 40)
            DropdownFrame.BackgroundColor3 = SpeedHub.Colors.Card
            DropdownFrame.BorderSizePixel = 0
            DropdownFrame.AutomaticSize = Enum.AutomaticSize.Y
            
            local DropdownCorner = Instance.new("UICorner")
            DropdownCorner.CornerRadius = UDim.new(0, 8)
            DropdownCorner.Parent = DropdownFrame
            
            local DropdownStroke = Instance.new("UIStroke")
            DropdownStroke.Color = Color3.fromRGB(70, 70, 80)
            DropdownStroke.Thickness = 1
            DropdownStroke.Parent = DropdownFrame
            
            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Name = "DropdownButton"
            DropdownButton.Size = UDim2.new(1, 0, 0, 40)
            DropdownButton.BackgroundTransparency = 1
            DropdownButton.Text = ""
            DropdownButton.AutoButtonColor = false
            DropdownButton.Parent = DropdownFrame
            
            local DropdownLabel = Instance.new("TextLabel")
            DropdownLabel.Name = "DropdownLabel"
            DropdownLabel.Size = UDim2.new(0.7, 0, 0, 20)
            DropdownLabel.Position = UDim2.new(0, 10, 0, 5)
            DropdownLabel.BackgroundTransparency = 1
            DropdownLabel.Text = Dropdown.Name
            DropdownLabel.TextColor3 = SpeedHub.Colors.Text
            DropdownLabel.TextSize = 14
            DropdownLabel.Font = Enum.Font.GothamSemibold
            DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            DropdownLabel.Parent = DropdownFrame
            
            local DropdownValue = Instance.new("TextLabel")
            DropdownValue.Name = "DropdownValue"
            DropdownValue.Size = UDim2.new(0.7, 0, 0, 15)
            DropdownValue.Position = UDim2.new(0, 10, 0, 22)
            DropdownValue.BackgroundTransparency = 1
            DropdownValue.Text = Dropdown.Value
            DropdownValue.TextColor3 = SpeedHub.Colors.TextSecondary
            DropdownValue.TextSize = 12
            DropdownValue.Font = Enum.Font.Gotham
            DropdownValue.TextXAlignment = Enum.TextXAlignment.Left
            DropdownValue.Parent = DropdownFrame
            
            local DropdownArrow = Instance.new("TextLabel")
            DropdownArrow.Name = "DropdownArrow"
            DropdownArrow.Size = UDim2.new(0, 20, 0, 20)
            DropdownArrow.Position = UDim2.new(1, -25, 0, 10)
            DropdownArrow.BackgroundTransparency = 1
            DropdownArrow.Text = "▼"
            DropdownArrow.TextColor3 = SpeedHub.Colors.TextSecondary
            DropdownArrow.TextSize = 12
            DropdownArrow.Font = Enum.Font.GothamBold
            DropdownArrow.Parent = DropdownFrame
            
            local DropdownList = Instance.new("Frame")
            DropdownList.Name = "DropdownList"
            DropdownList.Size = UDim2.new(1, 0, 0, 0)
            DropdownList.Position = UDim2.new(0, 0, 0, 40)
            DropdownList.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            DropdownList.BorderSizePixel = 0
            DropdownList.Visible = false
            DropdownList.AutomaticSize = Enum.AutomaticSize.Y
            
            local DropdownListCorner = Instance.new("UICorner")
            DropdownListCorner.CornerRadius = UDim.new(0, 8)
            DropdownListCorner.Parent = DropdownList
            
            local DropdownListLayout = Instance.new("UIListLayout")
            DropdownListLayout.Padding = UDim.new(0, 2)
            DropdownListLayout.Parent = DropdownList
            
            DropdownList.Parent = DropdownFrame
            
            function Dropdown:SetValue(value)
                self.Value = value
                DropdownValue.Text = value
                self.Callback(value)
            end
            
            Dropdown.Callback = function(value) end
            
            -- Create option buttons
            for _, option in ipairs(Dropdown.Options) do
                local OptionButton = Instance.new("TextButton")
                OptionButton.Name = option .. "Option"
                OptionButton.Size = UDim2.new(1, -10, 0, 30)
                OptionButton.Position = UDim2.new(0, 5, 0, 0)
                OptionButton.BackgroundColor3 = SpeedHub.Colors.Card
                OptionButton.BorderSizePixel = 0
                OptionButton.Text = option
                OptionButton.TextColor3 = SpeedHub.Colors.Text
                OptionButton.TextSize = 12
                OptionButton.Font = Enum.Font.Gotham
                OptionButton.AutoButtonColor = false
                
                local OptionCorner = Instance.new("UICorner")
                OptionCorner.CornerRadius = UDim.new(0, 6)
                OptionCorner.Parent = OptionButton
                
                OptionButton.MouseEnter:Connect(function()
                    TweenService:Create(OptionButton, TweenInfo.new(0.2), {
                        BackgroundColor3 = SpeedHub.Colors.Primary
                    }):Play()
                end)
                
                OptionButton.MouseLeave:Connect(function()
                    TweenService:Create(OptionButton, TweenInfo.new(0.2), {
                        BackgroundColor3 = SpeedHub.Colors.Card
                    }):Play()
                end)
                
                OptionButton.MouseButton1Click:Connect(function()
                    Dropdown:SetValue(option)
                    Dropdown:Toggle()
                end)
                
                OptionButton.Parent = DropdownList
            end
            
            function Dropdown:Toggle()
                self.Open = not self.Open
                DropdownList.Visible = self.Open
                
                if self.Open then
                    DropdownArrow.Text = "▲"
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {
                        Size = UDim2.new(1, 0, 0, 40 + #self.Options * 32)
                    }):Play()
                else
                    DropdownArrow.Text = "▼"
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {
                        Size = UDim2.new(1, 0, 0, 40)
                    }):Play()
                end
            end
            
            DropdownButton.MouseButton1Click:Connect(function()
                Dropdown:Toggle()
            end)
            
            DropdownFrame.Parent = Tab.Content
            
            return Dropdown
        end
        
        function Tab:AddTextBox(textboxConfig)
            local TextBox = {}
            TextBox.Name = textboxConfig.Name or "TextBox"
            TextBox.Description = textboxConfig.Description or ""
            TextBox.PlaceholderText = textboxConfig.PlaceholderText or "Enter text..."
            
            local TextBoxFrame = Instance.new("Frame")
            TextBoxFrame.Name = TextBox.Name .. "TextBox"
            TextBoxFrame.Size = UDim2.new(1, 0, 0, 60)
            TextBoxFrame.BackgroundColor3 = SpeedHub.Colors.Card
            TextBoxFrame.BorderSizePixel = 0
            
            local TextBoxCorner = Instance.new("UICorner")
            TextBoxCorner.CornerRadius = UDim.new(0, 8)
            TextBoxCorner.Parent = TextBoxFrame
            
            local TextBoxStroke = Instance.new("UIStroke")
            TextBoxStroke.Color = Color3.fromRGB(70, 70, 80)
            TextBoxStroke.Thickness = 1
            TextBoxStroke.Parent = TextBoxFrame
            
            local TextBoxLabel = Instance.new("TextLabel")
            TextBoxLabel.Name = "TextBoxLabel"
            TextBoxLabel.Size = UDim2.new(1, -20, 0, 20)
            TextBoxLabel.Position = UDim2.new(0, 10, 0, 5)
            TextBoxLabel.BackgroundTransparency = 1
            TextBoxLabel.Text = TextBox.Name
            TextBoxLabel.TextColor3 = SpeedHub.Colors.Text
            TextBoxLabel.TextSize = 14
            TextBoxLabel.Font = Enum.Font.GothamSemibold
            TextBoxLabel.TextXAlignment = Enum.TextXAlignment.Left
            TextBoxLabel.Parent = TextBoxFrame
            
            local TextBoxDescription = Instance.new("TextLabel")
            TextBoxDescription.Name = "TextBoxDescription"
            TextBoxDescription.Size = UDim2.new(1, -20, 0, 15)
            TextBoxDescription.Position = UDim2.new(0, 10, 0, 22)
            TextBoxDescription.BackgroundTransparency = 1
            TextBoxDescription.Text = TextBox.Description
            TextBoxDescription.TextColor3 = SpeedHub.Colors.TextSecondary
            TextBoxDescription.TextSize = 11
            TextBoxDescription.Font = Enum.Font.Gotham
            TextBoxDescription.TextXAlignment = Enum.TextXAlignment.Left
            TextBoxDescription.Parent = TextBoxFrame
            
            local InputBox = Instance.new("TextBox")
            InputBox.Name = "InputBox"
            InputBox.Size = UDim2.new(1, -20, 0, 25)
            InputBox.Position = UDim2.new(0, 10, 0, 40)
            InputBox.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            InputBox.BorderSizePixel = 0
            InputBox.Text = ""
            InputBox.PlaceholderText = TextBox.PlaceholderText
            InputBox.TextColor3 = SpeedHub.Colors.Text
            InputBox.TextSize = 12
            InputBox.Font = Enum.Font.Gotham
            InputBox.ClearTextOnFocus = false
            
            local InputBoxCorner = Instance.new("UICorner")
            InputBoxCorner.CornerRadius = UDim.new(0, 6)
            InputBoxCorner.Parent = InputBox
            
            InputBox.FocusLost:Connect(function(enterPressed)
                if enterPressed then
                    TextBox.Callback(InputBox.Text)
                end
            end)
            
            InputBox.Parent = TextBoxFrame
            TextBoxFrame.Parent = Tab.Content
            
            TextBox.Callback = function(value) end
            
            return TextBox
        end
        
        -- Add to window tabs
        table.insert(Window.Tabs, Tab)
        
        -- Select first tab by default
        if #Window.Tabs == 1 then
            Tab:Select()
        end
        
        return Tab
    end
    
    function Window:SelectTab(tab)
        if tab and tab.Select then
            tab:Select()
        end
    end
    
    -- Dragging Functionality
    local dragging = false
    local dragInput, dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        Window.MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Window.MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
    
    -- Close Button Functionality
    CloseButton.MouseButton1Click:Connect(function()
        Window.Gui:Destroy()
    end)
    
    -- Keybind เพื่อเปิด/ปิด UI (F5)
    Window.Visible = true
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.F5 then
            Window.Visible = not Window.Visible
            Window.Gui.Enabled = Window.Visible
        end
    end)
    
    -- เพิ่ม UI ไปยัง PlayerGui
    TitleBar.Parent = Window.MainFrame
    Window.MainFrame.Parent = Window.Gui
    Window.Gui.Parent = playerGui
    
    warn("🎮 Speed Hub Library Loaded Successfully!")
    warn("📱 Press F5 to show/hide the menu")
    warn("📍 Drag the title bar to move the window")
    
    return Window
end

return SpeedHub
