local Players = game:GetService("Players")
local VoiceChatService = game:GetService("VoiceChatService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer

-- UI erstellen
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SorinVCControl"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 230, 0, 150)
Frame.Position = UDim2.new(1, -250, 1, -180)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Frame.BorderSizePixel = 0
Frame.BackgroundTransparency = 0.1
Frame.Name = "SorinFrame"
Frame.Active = true
Frame.Draggable = true -- für Drag-Kompatibilität

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 10)
Frame.Parent = ScreenGui

-- Titel
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -10, 0, 30)
Title.Position = UDim2.new(0, 5, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "🎙 Voice Control"
Title.TextColor3 = Color3.fromRGB(180, 180, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamSemibold
Title.Parent = Frame

-- "Made by SorinHub"
local MadeBy = Instance.new("TextLabel")
MadeBy.Size = UDim2.new(1, -10, 0, 15)
MadeBy.Position = UDim2.new(0, 5, 1, -20)
MadeBy.BackgroundTransparency = 1
MadeBy.Text = "Made by SorinHub 🚀"
MadeBy.TextColor3 = Color3.fromRGB(100, 100, 120)
MadeBy.TextScaled = true
MadeBy.Font = Enum.Font.Code
MadeBy.Parent = Frame

-- Aktivieren Button
local JoinBtn = Instance.new("TextButton")
JoinBtn.Size = UDim2.new(0.45, 0, 0, 35)
JoinBtn.Position = UDim2.new(0.05, 0, 0, 50)
JoinBtn.BackgroundColor3 = Color3.fromRGB(60, 200, 130)
JoinBtn.Text = "🔊 Aktivieren"
JoinBtn.TextColor3 = Color3.new(1, 1, 1)
JoinBtn.TextScaled = true
JoinBtn.Font = Enum.Font.GothamBold
JoinBtn.Parent = Frame
Instance.new("UICorner", JoinBtn).CornerRadius = UDim.new(0, 6)

-- Deaktivieren Button
local LeaveBtn = Instance.new("TextButton")
LeaveBtn.Size = UDim2.new(0.45, 0, 0, 35)
LeaveBtn.Position = UDim2.new(0.5, 5, 0, 50)
LeaveBtn.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
LeaveBtn.Text = "🔇 Deaktivieren"
LeaveBtn.TextColor3 = Color3.new(1, 1, 1)
LeaveBtn.TextScaled = true
LeaveBtn.Font = Enum.Font.GothamBold
LeaveBtn.Parent = Frame
Instance.new("UICorner", LeaveBtn).CornerRadius = UDim.new(0, 6)

-- Schließen Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -30, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.TextScaled = true
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Frame
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)

-- Voice Join
JoinBtn.MouseButton1Click:Connect(function()
    local success, err = pcall(function()
        VoiceChatService:JoinVoice()
    end)
    if success then
        StarterGui:SetCore("SendNotification", {
            Title = "VC aktiviert",
            Text = "Du bist dem VoiceChat beigetreten.",
            Duration = 3
        })
    else
        StarterGui:SetCore("SendNotification", {
            Title = "Fehler",
            Text = "Voice konnte nicht aktiviert werden.",
            Duration = 3
        })
        warn(err)
    end
end)

-- Voice Leave
LeaveBtn.MouseButton1Click:Connect(function()
    local success, err = pcall(function()
        VoiceChatService:LeaveVoice()
    end)
    if success then
        StarterGui:SetCore("SendNotification", {
            Title = "VC deaktiviert",
            Text = "VoiceChat wurde verlassen.",
            Duration = 3
        })
    else
        StarterGui:SetCore("SendNotification", {
            Title = "Fehler",
            Text = "Voice konnte nicht deaktiviert werden.",
            Duration = 3
        })
        warn(err)
    end
end)

-- Fenster schließen
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)
