local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local isMobile = UserInputService.TouchEnabled

function Library:CreateWindow(titleText, iconId, thumbnailId)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "DynamicDetectionUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local coreGuiSuccess, _ = pcall(function()
        ScreenGui.Parent = game:GetService("CoreGui")
    end)
    if not coreGuiSuccess then
        ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    end

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, math.min(580, workspace.CurrentCamera.ViewportSize.X - 20), 0, math.min(380, workspace.CurrentCamera.ViewportSize.Y - 20))
    MainFrame.Position = UDim2.new(0.5, -MainFrame.Size.X.Offset/2, 0.5, -MainFrame.Size.Y.Offset/2)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 9)
    UICorner.Parent = MainFrame

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Thickness = 1
    UIStroke.Color = Color3.fromRGB(45, 45, 48)
    UIStroke.Parent = MainFrame

    local dragging, dragInput, dragStart, startPos
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local Topbar = Instance.new("Frame")
    Topbar.Name = "Topbar"
    Topbar.Size = UDim2.new(1, 0, 0, 40)
    Topbar.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
    Topbar.BorderSizePixel = 0
    Topbar.Parent = MainFrame

    local TopbarCorner = Instance.new("UICorner")
    TopbarCorner.CornerRadius = UDim.new(0, 9)
    TopbarCorner.Parent = Topbar

    local TopbarFix = Instance.new("Frame")
    TopbarFix.Size = UDim2.new(1, 0, 0, 10)
    TopbarFix.Position = UDim2.new(0, 0, 1, -10)
    TopbarFix.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
    TopbarFix.BorderSizePixel = 0
    TopbarFix.Parent = Topbar

    local TitleText = Instance.new("TextLabel")
    TitleText.Name = "Title"
    TitleText.Size = UDim2.new(0, 250, 1, 0)
    TitleText.BackgroundTransparency = 1
    TitleText.TextColor3 = Color3.fromRGB(245, 245, 247)
    TitleText.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
    TitleText.TextSize = 14
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    TitleText.Parent = Topbar

    if iconId and iconId ~= "" then
        local Icon = Instance.new("ImageLabel")
        Icon.Name = "Icon"
        Icon.Size = UDim2.new(0, 22, 0, 22)
        Icon.Position = UDim2.new(0, 12, 0.5, -11)
        Icon.BackgroundTransparency = 1
        Icon.Image = iconId
        Icon.Parent = Topbar
        TitleText.Position = UDim2.new(0, 42, 0, 0)
    else
        TitleText.Position = UDim2.new(0, 12, 0, 0)
    end
    TitleText.Text = titleText

    local ButtonContainer = Instance.new("Frame")
    ButtonContainer.Size = UDim2.new(0, 100, 1, 0)
    ButtonContainer.Position = UDim2.new(1, -110, 0, 0)
    ButtonContainer.BackgroundTransparency = 1
    ButtonContainer.Parent = Topbar

    local UIList = Instance.new("UIListLayout")
    UIList.FillDirection = Enum.FillDirection.Horizontal
    UIList.HorizontalAlignment = Enum.HorizontalAlignment.Right
    UIList.VerticalAlignment = Enum.VerticalAlignment.Center
    UIList.Padding = UDim.new(0, 8)
    UIList.Parent = ButtonContainer

    local function createTerminalBtn(color, name)
        local btn = Instance.new("TextButton")
        btn.Name = name
        btn.Size = UDim2.new(0, 13, 0, 13)
        btn.BackgroundColor3 = color
        btn.Text = ""
        btn.Parent = ButtonContainer
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = btn
        return btn
    end

    local MaxBtn = createTerminalBtn(Color3.fromRGB(255, 95, 85), "Maximize")
    local MinBtn = createTerminalBtn(Color3.fromRGB(255, 189, 46), "Minimize")
    local CloseBtn = createTerminalBtn(Color3.fromRGB(39, 201, 63), "Close")

    local MobileToggle = Instance.new("TextButton")
    MobileToggle.Name = "MobileToggle"
    MobileToggle.Size = UDim2.new(0, 110, 0, 36)
    MobileToggle.Position = UDim2.new(0.5, -55, 0, 15)
    MobileToggle.BackgroundColor3 = Color3.fromRGB(32, 32, 35)
    MobileToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    MobileToggle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)
    MobileToggle.TextSize = 13
    MobileToggle.Text = "Toggle UI"
    MobileToggle.BackgroundTransparency = 1
    MobileToggle.TextTransparency = 1
    MobileToggle.Visible = false
    MobileToggle.Parent = ScreenGui

    local MTCorner = Instance.new("UICorner")
    MTCorner.CornerRadius = UDim.new(1, 0)
    MTCorner.Parent = MobileToggle

    local MTStroke = Instance.new("UIStroke")
    MTStroke.Thickness = 1
    MTStroke.Color = Color3.fromRGB(60, 60, 65)
    MTStroke.Transparency = 1
    MTStroke.Parent = MobileToggle

    local isOpen = true
    local originPos = MainFrame.Position

    local function toggleUI(state)
        isOpen = state
        if isOpen then
            MainFrame.Visible = true
            TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = originPos}):Play()
            if isMobile then
                TweenService:Create(MobileToggle, TweenInfo.new(0.3), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
                TweenService:Create(MTStroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
                task.delay(0.3, function() if isOpen then MobileToggle.Visible = false end end)
            end
        else
            originPos = MainFrame.Position
            local targetPos = UDim2.new(originPos.X.Scale, originPos.X.Offset, 1, 60)
            local t = TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = targetPos})
            t:Play()
            t.Completed:Connect(function()
                if not isOpen then MainFrame.Visible = false end
            end)
            if isMobile then
                MobileToggle.Visible = true
                TweenService:Create(MobileToggle, TweenInfo.new(0.3), {BackgroundTransparency = 0, TextTransparency = 0}):Play()
                TweenService:Create(MTStroke, TweenInfo.new(0.3), {Transparency = 0}):Play()
            end
        end
    end

    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    MinBtn.MouseButton1Click:Connect(function()
        toggleUI(false)
    end)

    MobileToggle.MouseButton1Click:Connect(function()
        toggleUI(true)
    end)

    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == Enum.KeyCode.K then
            if not isMobile then
                toggleUI(not isOpen)
            end
        end
    end)

    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 160, 1, -40)
    Sidebar.Position = UDim2.new(0, 0, 0, 40)
    Sidebar.BackgroundColor3 = Color3.fromRGB(24, 24, 26)
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame

    local Thumbnail = Instance.new("ImageLabel")
    Thumbnail.Name = "Thumbnail"
    Thumbnail.Size = UDim2.new(1, -20, 0, 85)
    Thumbnail.Position = UDim2.new(0, 10, 0, 10)
    Thumbnail.BackgroundColor3 = Color3.fromRGB(32, 32, 35)
    Thumbnail.Image = thumbnailId or ""
    Thumbnail.ClipsDescendants = true
    Thumbnail.Parent = Sidebar

    local ThumbCorner = Instance.new("UICorner")
    ThumbCorner.CornerRadius = UDim.new(0, 6)
    ThumbCorner.Parent = Thumbnail

    local TabScroll = Instance.new("ScrollingFrame")
    TabScroll.Name = "TabScroll"
    TabScroll.Size = UDim2.new(1, 0, 1, -110)
    TabScroll.Position = UDim2.new(0, 0, 0, 105)
    TabScroll.BackgroundTransparency = 1
    TabScroll.BorderSizePixel = 0
    TabScroll.ScrollBarThickness = 0
    TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabScroll.AutomaticCanvasSize = Enum.AutomaticCanvasSize.Y
    TabScroll.Parent = Sidebar

    local SidebarList = Instance.new("UIListLayout")
    SidebarList.Padding = UDim.new(0, 5)
    SidebarList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    SidebarList.Parent = TabScroll

    local ContainerFolder = Instance.new("Folder")
    ContainerFolder.Name = "Containers"
    ContainerFolder.Parent = MainFrame

    local tabs = {}
    local firstTab = true

    function tabs:CreateTab(tabName, tabIcon)
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName .. "Tab"
        TabButton.Size = UDim2.new(1, -20, 0, 36)
        TabButton.BackgroundColor3 = Color3.fromRGB(32, 32, 35)
        TabButton.BackgroundTransparency = 1
        TabButton.Text = ""
        TabButton.Parent = TabScroll

        local TBCorner = Instance.new("UICorner")
        TBCorner.CornerRadius = UDim.new(0, 6)
        TBCorner.Parent = TabButton

        local TabText = Instance.new("TextLabel")
        TabText.Size = UDim2.new(1, -10, 1, 0)
        TabText.BackgroundTransparency = 1
        TabText.Text = tabName
        TabText.TextColor3 = Color3.fromRGB(140, 140, 145)
        TabText.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)
        TabText.TextSize = 13
        TabText.TextXAlignment = Enum.TextXAlignment.Left
        TabText.Parent = TabButton

        if tabIcon and tabIcon ~= "" then
            local TIcon = Instance.new("ImageLabel")
            TIcon.Size = UDim2.new(0, 18, 0, 18)
            TIcon.Position = UDim2.new(0, 10, 0.5, -9)
            TIcon.BackgroundTransparency = 1
            TIcon.Image = tabIcon
            TIcon.ImageColor3 = Color3.fromRGB(140, 140, 145)
            TIcon.Parent = TabButton
            TabText.Position = UDim2.new(0, 36, 0, 0)
        else
            TabText.Position = UDim2.new(0, 10, 0, 0)
        end

        local Container = Instance.new("ScrollingFrame")
        Container.Name = tabName .. "Container"
        Container.Size = UDim2.new(1, -175, 1, -55)
        Container.Position = UDim2.new(0, 170, 0, 48)
        Container.BackgroundTransparency = 1
        Container.BorderSizePixel = 0
        Container.ScrollBarThickness = 3
        Container.ScrollBarImageColor3 = Color3.fromRGB(65, 65, 70)
        Container.AutomaticCanvasSize = Enum.AutomaticCanvasSize.Y
        Container.CanvasSize = UDim2.new(0, 0, 0, 0)
        Container.Visible = false
        Container.Parent = ContainerFolder

        local ContainerList = Instance.new("UIListLayout")
        ContainerList.Padding = UDim.new(0, 8)
        ContainerList.SortOrder = Enum.SortOrder.LayoutOrder
        ContainerList.Parent = Container

        local function activate()
            for _, c in ipairs(ContainerFolder:GetChildren()) do
                c.Visible = false
            end
            for _, b in ipairs(TabScroll:GetChildren()) do
                if b:IsA("TextButton") then
                    TweenService:Create(b, TweenInfo.new(0.25), {BackgroundTransparency = 1}):Play()
                    TweenService:Create(b.TextLabel, TweenInfo.new(0.25), {TextColor3 = Color3.fromRGB(140, 140, 145)}):Play()
                    local ic = b:FindFirstChildOfClass("ImageLabel")
                    if ic then
                        TweenService:Create(ic, TweenInfo.new(0.25), {ImageColor3 = Color3.fromRGB(140, 140, 145)}):Play()
                    end
                end
            end
            Container.Visible = true
            TweenService:Create(TabButton, TweenInfo.new(0.25), {BackgroundTransparency = 0}):Play()
            TweenService:Create(TabText, TweenInfo.new(0.25), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            local ic = TabButton:FindFirstChildOfClass("ImageLabel")
            if ic then
                TweenService:Create(ic, TweenInfo.new(0.25), {ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            end
        end

        TabButton.MouseButton1Click:Connect(activate)

        if firstTab then
            firstTab = false
            activate()
        end

        local elements = {}

        function elements:CreateSection(sectionName)
            local SecLabel = Instance.new("TextLabel")
            SecLabel.Size = UDim2.new(1, -10, 0, 26)
            SecLabel.BackgroundTransparency = 1
            SecLabel.Text = sectionName
            SecLabel.TextColor3 = Color3.fromRGB(165, 165, 170)
            SecLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
            SecLabel.TextSize = 13
            SecLabel.TextXAlignment = Enum.TextXAlignment.Left
            SecLabel.Parent = Container
            
            local obj = {}
            function obj:Update(newName)
                SecLabel.Text = newName
            end
            return obj
        end

        function elements:CreateButton(btnText, callback)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, -10, 0, 38)
            Btn.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
            Btn.Text = ""
            Btn.Parent = Container

            local bc = Instance.new("UICorner")
            bc.CornerRadius = UDim.new(0, 6)
            bc.Parent = Btn

            local bs = Instance.new("UIStroke")
            bs.Thickness = 1
            bs.Color = Color3.fromRGB(45, 45, 48)
            bs.Parent = Btn

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -40, 1, 0)
            Label.Position = UDim2.new(0, 12, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = btnText
            Label.TextColor3 = Color3.fromRGB(235, 235, 240)
            Label.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Btn

            local Icon = Instance.new("ImageLabel")
            Icon.Size = UDim2.new(0, 16, 0, 16)
            Icon.Position = UDim2.new(1, -28, 0.5, -8)
            Icon.BackgroundTransparency = 1
            Icon.Image = "rbxassetid://10747372992"
            Icon.ImageColor3 = Color3.fromRGB(180, 180, 185)
            Icon.Parent = Btn

            Btn.MouseButton1Click:Connect(function()
                Btn.BackgroundColor3 = Color3.fromRGB(38, 38, 40)
                TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(28, 28, 30)}):Play()
                if callback then callback() end
            end)

            local obj = {}
            function obj:Update(newText, newCallback)
                Label.Text = newText
                if newCallback then callback = newCallback end
            end
            return obj
        end

        function elements:CreateToggle(toggleText, default, callback)
            local toggled = default or false
            local Tgl = Instance.new("TextButton")
            Tgl.Size = UDim2.new(1, -10, 0, 38)
            Tgl.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
            Tgl.Text = ""
            Tgl.Parent = Container

            local tc = Instance.new("UICorner")
            tc.CornerRadius = UDim.new(0, 6)
            tc.Parent = Tgl

            local ts = Instance.new("UIStroke")
            ts.Thickness = 1
            ts.Color = Color3.fromRGB(45, 45, 48)
            ts.Parent = Tgl

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -70, 1, 0)
            Label.Position = UDim2.new(0, 12, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = toggleText
            Label.TextColor3 = Color3.fromRGB(235, 235, 240)
            Label.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Tgl

            local Track = Instance.new("Frame")
            Track.Size = UDim2.new(0, 36, 0, 20)
            Track.Position = UDim2.new(1, -48, 0.5, -10)
            Track.BackgroundColor3 = toggled and Color3.fromRGB(50, 215, 75) or Color3.fromRGB(60, 60, 65)
            Track.Parent = Tgl

            local trc = Instance.new("UICorner")
            trc.CornerRadius = UDim.new(1, 0)
            trc.Parent = Track

            local Dot = Instance.new("Frame")
            Dot.Size = UDim2.new(0, 14, 0, 14)
            Dot.Position = toggled and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
            Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Dot.Parent = Track

            local dc = Instance.new("UICorner")
            dc.CornerRadius = UDim.new(1, 0)
            dc.Parent = Dot

            local function updateView()
                TweenService:Create(Track, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = toggled and Color3.fromRGB(50, 215, 75) or Color3.fromRGB(60, 60, 65)}):Play()
                TweenService:Create(Dot, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = toggled and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)}):Play()
            end

            Tgl.MouseButton1Click:Connect(function()
                toggled = not toggled
                updateView()
                if callback then callback(toggled) end
            end)

            local obj = {}
            function obj:Update(newState)
                toggled = newState
                updateView()
                if callback then callback(toggled) end
            end
            return obj
        end

        function elements:CreateSlider(sliderText, min, max, default, callback)
            local Sld = Instance.new("Frame")
            Sld.Size = UDim2.new(1, -10, 0, 48)
            Sld.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
            Sld.Parent = Container

            local sc = Instance.new("UICorner")
            sc.CornerRadius = UDim.new(0, 6)
            sc.Parent = Sld

            local ss = Instance.new("UIStroke")
            ss.Thickness = 1
            ss.Color = Color3.fromRGB(45, 45, 48)
            ss.Parent = Sld

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -70, 0, 22)
            Label.Position = UDim2.new(0, 12, 0, 5)
            Label.BackgroundTransparency = 1
            Label.Text = sliderText
            Label.TextColor3 = Color3.fromRGB(235, 235, 240)
            Label.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Sld

            local ValLabel = Instance.new("TextLabel")
            ValLabel.Size = UDim2.new(0, 50, 0, 22)
            ValLabel.Position = UDim2.new(1, -62, 0, 5)
            ValLabel.BackgroundTransparency = 1
            ValLabel.Text = tostring(default)
            ValLabel.TextColor3 = Color3.fromRGB(150, 150, 155)
            ValLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)
            ValLabel.TextSize = 13
            ValLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValLabel.Parent = Sld

            local Track = Instance.new("TextButton")
            Track.Size = UDim2.new(1, -24, 0, 6)
            Track.Position = UDim2.new(0, 12, 1, -12)
            Track.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
            Track.Text = ""
            Track.Parent = Sld

            local trkc = Instance.new("UICorner")
            trkc.CornerRadius = UDim.new(1, 0)
            trkc.Parent = Track

            local Fill = Instance.new("Frame")
            Fill.Size = UDim2.new(math.clamp((default - min) / (max - min), 0, 1), 0, 1, 0)
            Fill.BackgroundColor3 = Color3.fromRGB(10, 132, 255)
            Fill.Parent = Track

            local fc = Instance.new("UICorner")
            fc.CornerRadius = UDim.new(1, 0)
            fc.Parent = Fill

            local sliding = false

            local function move(input)
                local pos = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                local val = math.floor(min + (max - min) * pos)
                Fill.Size = UDim2.new(pos, 0, 1, 0)
                ValLabel.Text = tostring(val)
                if callback then callback(val) end
            end

            Track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = true
                    move(input)
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    move(input)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = false
                end
            end)

            local obj = {}
            function obj:Update(newVal)
                newVal = math.clamp(newVal, min, max)
                local pos = (newVal - min) / (max - min)
                Fill.Size = UDim2.new(pos, 0, 1, 0)
                ValLabel.Text = tostring(newVal)
                if callback then callback(newVal) end
            end
            return obj
        end

        function elements:CreateInput(inputText, placeholder, callback)
            local Inp = Instance.new("Frame")
            Inp.Size = UDim2.new(1, -10, 0, 38)
            Inp.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
            Inp.Parent = Container

            local ic = Instance.new("UICorner")
            ic.CornerRadius = UDim.new(0, 6)
            ic.Parent = Inp

            local is = Instance.new("UIStroke")
            is.Thickness = 1
            is.Color = Color3.fromRGB(45, 45, 48)
            is.Parent = Inp

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(0, 140, 1, 0)
            Label.Position = UDim2.new(0, 12, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = inputText
            Label.TextColor3 = Color3.fromRGB(235, 235, 240)
            Label.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Inp

            local TextBox = Instance.new("TextBox")
            TextBox.Size = UDim2.new(1, -164, 0, 26)
            TextBox.Position = UDim2.new(1, -112, 0.5, -13)
            TextBox.BackgroundColor3 = Color3.fromRGB(44, 44, 46)
            TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextBox.PlaceholderText = placeholder or "Type tools..."
            TextBox.Text = ""
            TextBox.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular)
            TextBox.TextSize = 12
            TextBox.ClipsDescendants = true
            TextBox.Parent = Inp

            local tbc = Instance.new("UICorner")
            tbc.CornerRadius = UDim.new(0, 5)
            tbc.Parent = TextBox

            local tbs = Instance.new("UIStroke")
            tbs.Thickness = 1
            tbs.Color = Color3.fromRGB(60, 60, 65)
            tbs.Parent = TextBox

            TextBox.FocusLost:Connect(function()
                if callback then callback(TextBox.Text) end
            end)

            local obj = {}
            function obj:Update(newVal)
                TextBox.Text = newVal
                if callback then callback(newVal) end
            end
            return obj
        end

        function elements:CreateKeybind(bindText, default, callback)
            local currentBind = default
            local Kbd = Instance.new("Frame")
            Kbd.Size = UDim2.new(1, -10, 0, 38)
            Kbd.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
            Kbd.Parent = Container

            local kc = Instance.new("UICorner")
            kc.CornerRadius = UDim.new(0, 6)
            kc.Parent = Kbd

            local ks = Instance.new("UIStroke")
            ks.Thickness = 1
            ks.Color = Color3.fromRGB(45, 45, 48)
            ks.Parent = Kbd

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -110, 1, 0)
            Label.Position = UDim2.new(0, 12, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = bindText
            Label.TextColor3 = Color3.fromRGB(235, 235, 240)
            Label.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Kbd

            local BindBtn = Instance.new("TextButton")
            BindBtn.Size = UDim2.new(0, 84, 0, 26)
            BindBtn.Position = UDim2.new(1, -96, 0.5, -13)
            BindBtn.BackgroundColor3 = Color3.fromRGB(44, 44, 46)
            BindBtn.TextColor3 = Color3.fromRGB(200, 200, 205)
            BindBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)
            BindBtn.TextSize = 12
            BindBtn.Text = currentBind and currentBind.Name or "None"
            BindBtn.Parent = Kbd

            local bbc = Instance.new("UICorner")
            bbc.CornerRadius = UDim.new(0, 5)
            bbc.Parent = BindBtn

            local bbs = Instance.new("UIStroke")
            bbs.Thickness = 1
            bbs.Color = Color3.fromRGB(60, 60, 65)
            bbs.Parent = BindBtn

            local listening = false

            BindBtn.MouseButton1Click:Connect(function()
                listening = true
                BindBtn.Text = "..."
            end)

            UserInputService.InputBegan:Connect(function(input, processed)
                if listening and not processed then
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        listening = false
                        currentBind = input.KeyCode
                        BindBtn.Text = currentBind.Name
                        if callback then callback(currentBind) end
                    end
                elseif not listening and not processed and currentBind and input.KeyCode == currentBind then
                    if callback then callback(currentBind) end
                end
            end)

            local obj = {}
            function obj:Update(newBind)
                currentBind = newBind
                BindBtn.Text = currentBind and currentBind.Name or "None"
            end
            return obj
        end

        function elements:CreateDropdown(dropText, list, callback)
            local Drop = Instance.new("Frame")
            Drop.Size = UDim2.new(1, -10, 0, 38)
            Drop.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
            Drop.ClipsDescendants = true
            Drop.Parent = Container

            local dc = Instance.new("UICorner")
            dc.CornerRadius = UDim.new(0, 6)
            dc.Parent = Drop

            local ds = Instance.new("UIStroke")
            ds.Thickness = 1
            ds.Color = Color3.fromRGB(45, 45, 48)
            ds.Parent = Drop

            local TopContainer = Instance.new("TextButton")
            TopContainer.Size = UDim2.new(1, 0, 0, 38)
            TopContainer.BackgroundTransparency = 1
            TopContainer.Text = ""
            TopContainer.Parent = Drop

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -45, 1, 0)
            Label.Position = UDim2.new(0, 12, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = dropText
            Label.TextColor3 = Color3.fromRGB(235, 235, 240)
            Label.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = TopContainer

            local Indicator = Instance.new("ImageLabel")
            Indicator.Size = UDim2.new(0, 14, 0, 14)
            Indicator.Position = UDim2.new(1, -28, 0.5, -7)
            Indicator.BackgroundTransparency = 1
            Indicator.Image = "rbxassetid://10747383819"
            Indicator.ImageColor3 = Color3.fromRGB(180, 180, 185)
            Indicator.Parent = TopContainer

            local ListFrame = Instance.new("Frame")
            ListFrame.Size = UDim2.new(1, 0, 0, 0)
            ListFrame.Position = UDim2.new(0, 0, 0, 38)
            ListFrame.BackgroundTransparency = 1
            ListFrame.Parent = Drop

            local ListLayout = Instance.new("UIListLayout")
            ListLayout.Parent = ListFrame

            local open = false

            local function populate(newList)
                for _, child in ipairs(ListFrame:GetChildren()) do
                    if child:IsA("TextButton") then child:Destroy() end
                end
                for _, item in ipairs(newList) do
                    local ItemBtn = Instance.new("TextButton")
                    ItemBtn.Size = UDim2.new(1, 0, 0, 32)
                    ItemBtn.BackgroundColor3 = Color3.fromRGB(34, 34, 37)
                    ItemBtn.BorderSizePixel = 0
                    ItemBtn.Text = "   " .. tostring(item)
                    ItemBtn.TextColor3 = Color3.fromRGB(195, 195, 200)
                    ItemBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)
                    ItemBtn.TextSize = 12
                    ItemBtn.TextXAlignment = Enum.TextXAlignment.Left
                    ItemBtn.Parent = ListFrame

                    ItemBtn.MouseButton1Click:Connect(function()
                        Label.Text = dropText .. " (" .. tostring(item) .. ")"
                        open = false
                        TweenService:Create(Drop, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, -10, 0, 38)}):Play()
                        TweenService:Create(Indicator, TweenInfo.new(0.25), {Rotation = 0}):Play()
                        if callback then callback(item) end
                    end)
                end
            end

            populate(list)

            TopContainer.MouseButton1Click:Connect(function()
                open = not open
                local targetHeight = open and (38 + (#ListFrame:GetChildren() - 1) * 32) or 38
                TweenService:Create(Drop, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, -10, 0, targetHeight)}):Play()
                TweenService:Create(Indicator, TweenInfo.new(0.25), {Rotation = open and 180 or 0}):Play()
            end)

            local obj = {}
            function obj:Update(newList)
                populate(newList)
            end
            return obj
        end

        return elements
    end

    return tabs
end

return Library
