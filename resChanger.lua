local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera

local configFile = "m7za_config.txt"
local defaultScale = 0.95

local function loadConfig()
    if isfile and readfile and isfile(configFile) then
        local content = readfile(configFile)
        local parsed = tonumber(content)
        if parsed then
            return parsed
        end
    end
    return defaultScale
end

local function saveConfig(val)
    if writefile then
        writefile(configFile, tostring(val))
    end
end

local function sendNotification(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = 3
        })
    end)
end

getgenv().m7za = loadConfig()
saveConfig(getgenv().m7za)

if getgenv().m7za_gui then
    getgenv().m7za_gui:Destroy()
end
if getgenv().m7za_connection then
    getgenv().m7za_connection:Disconnect()
    getgenv().m7za_connection = nil
end

local isEnabled = true
local function startResolution()
    if getgenv().m7za_connection then
        getgenv().m7za_connection:Disconnect()
    end
    getgenv().m7za_connection = RunService.RenderStepped:Connect(function()
        local scale = tonumber(getgenv().m7za) or 1
        Camera.CFrame = Camera.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, scale, 0, 0, 0, 1)
    end)
end

local function stopResolution()
    if getgenv().m7za_connection then
        getgenv().m7za_connection:Disconnect()
        getgenv().m7za_connection = nil
    end
end

startResolution()

local parentGui = (gethui and gethui()) or game:GetService("CoreGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ResolutionGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = parentGui
getgenv().m7za_gui = ScreenGui

local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "OpenCloseToggle"
ToggleButton.Size = UDim2.new(0, 42, 0, 42)
ToggleButton.Position = UDim2.new(0.02, 0, 0.4, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
ToggleButton.Text = "Res"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 13
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 10)
ToggleCorner.Parent = ToggleButton

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(60, 60, 70)
ToggleStroke.Thickness = 1.2
ToggleStroke.Parent = ToggleButton

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 220, 0, 126)
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -63)
MainFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(45, 45, 55)
MainStroke.Thickness = 1.2
MainStroke.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -64, 0, 36)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Resolution Changer"
Title.TextColor3 = Color3.fromRGB(230, 230, 230)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 22, 0, 22)
MinBtn.Position = UDim2.new(1, -54, 0, 7)
MinBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
MinBtn.Text = "—"
MinBtn.TextColor3 = Color3.fromRGB(180, 180, 190)
MinBtn.TextSize = 11
MinBtn.Font = Enum.Font.GothamBold
MinBtn.Parent = MainFrame

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 5)
MinCorner.Parent = MinBtn

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 22, 0, 22)
CloseBtn.Position = UDim2.new(1, -28, 0, 7)
CloseBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(180, 180, 190)
CloseBtn.TextSize = 11
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = MainFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 5)
CloseCorner.Parent = CloseBtn

local ResLabel = Instance.new("TextLabel")
ResLabel.Size = UDim2.new(0, 100, 0, 26)
ResLabel.Position = UDim2.new(0, 12, 0, 44)
ResLabel.BackgroundTransparency = 1
ResLabel.Text = "Resolution"
ResLabel.TextColor3 = Color3.fromRGB(180, 180, 190)
ResLabel.Font = Enum.Font.GothamMedium
ResLabel.TextSize = 13
ResLabel.TextXAlignment = Enum.TextXAlignment.Left
ResLabel.Parent = MainFrame

local InputBox = Instance.new("TextBox")
InputBox.Size = UDim2.new(0, 60, 0, 26)
InputBox.Position = UDim2.new(1, -72, 0, 44)
InputBox.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
InputBox.Text = tostring(getgenv().m7za)
InputBox.PlaceholderText = "0.95"
InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
InputBox.Font = Enum.Font.GothamMedium
InputBox.TextSize = 12
InputBox.ClearTextOnFocus = false
InputBox.Parent = MainFrame

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 6)
InputCorner.Parent = InputBox

local SwitchBtn = Instance.new("TextButton")
SwitchBtn.Size = UDim2.new(1, -24, 0, 30)
SwitchBtn.Position = UDim2.new(0, 12, 0, 82)
SwitchBtn.BackgroundColor3 = Color3.fromRGB(45, 125, 75)
SwitchBtn.Text = "Status: ON"
SwitchBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SwitchBtn.Font = Enum.Font.GothamBold
SwitchBtn.TextSize = 12
SwitchBtn.Parent = MainFrame

local SwitchCorner = Instance.new("UICorner")
SwitchCorner.CornerRadius = UDim.new(0, 6)
SwitchCorner.Parent = SwitchBtn

local function toggleUI()
    MainFrame.Visible = not MainFrame.Visible
end

ToggleButton.MouseButton1Click:Connect(toggleUI)

local isMinimized = false
local animInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

MinBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    MinBtn.Text = isMinimized and "+" or "—"
    local targetSize = isMinimized and UDim2.new(0, 220, 0, 36) or UDim2.new(0, 220, 0, 126)
    TweenService:Create(MainFrame, animInfo, {Size = targetSize}):Play()
end)

InputBox.FocusLost:Connect(function()
    local val = tonumber(InputBox.Text)
    if val then
        getgenv().m7za = val
        saveConfig(val)
    else
        InputBox.Text = tostring(getgenv().m7za)
    end
end)

SwitchBtn.MouseButton1Click:Connect(function()
    isEnabled = not isEnabled
    if isEnabled then
        SwitchBtn.Text = "Status: ON"
        SwitchBtn.BackgroundColor3 = Color3.fromRGB(45, 125, 75)
        startResolution()
    else
        SwitchBtn.Text = "Status: OFF"
        SwitchBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        stopResolution()
    end
end)

local deleteArmed = false
local resetThread = nil

CloseBtn.MouseButton1Click:Connect(function()
    if not deleteArmed then
        deleteArmed = true
        CloseBtn.BackgroundColor3 = Color3.fromRGB(210, 30, 30)
        CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

        sendNotification("Resolution Changer", "Click '✕' again to delete script.")

        resetThread = task.delay(3, function()
            deleteArmed = false
            CloseBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
            CloseBtn.TextColor3 = Color3.fromRGB(180, 180, 190)
        end)
    else
        if resetThread then
            task.cancel(resetThread)
        end
        sendNotification("Resolution Changer", "Script deleted successfully.")
        stopResolution()
        getgenv().m7za_gui = nil
        ScreenGui:Destroy()
    end
end)

local function makeDraggable(guiObject)
    local dragging, dragStart, startPos = false, nil, nil

    guiObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = guiObject.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            guiObject.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

makeDraggable(MainFrame)
makeDraggable(ToggleButton)