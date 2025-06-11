local HttpService = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "SorinGui"
gui.ResetOnSpawn = false

-- === Hauptframe ===
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 450, 0, 270)
frame.Position = UDim2.new(0.5, -225, 0.5, -135)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
frame.Active = true
frame.Draggable = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

-- === Minimiertes Fenster ===
local minimized = Instance.new("Frame")
minimized.Size = UDim2.new(0, 300, 0, 35)
minimized.Position = UDim2.new(0.5, -150, 0.5, -100)
minimized.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
minimized.Visible = false
minimized.Parent = gui
minimized.Active = true
minimized.Draggable = true
Instance.new("UICorner", minimized).CornerRadius = UDim.new(0, 12)

local minText = Instance.new("TextLabel", minimized)
minText.Size = UDim2.new(1, -40, 1, 0)
minText.Position = UDim2.new(0, 10, 0, 0)
minText.Text = "🔮 Sorin Scripts"
minText.TextColor3 = Color3.fromRGB(220, 190, 255)
minText.BackgroundTransparency = 1
minText.Font = Enum.Font.GothamSemibold
minText.TextSize = 16
minText.TextXAlignment = Enum.TextXAlignment.Left

local restoreButton = Instance.new("TextButton", minimized)
restoreButton.Size = UDim2.new(0, 30, 0, 30)
restoreButton.Position = UDim2.new(1, -35, 0, 2)
restoreButton.Text = "➕"
restoreButton.TextColor3 = Color3.fromRGB(150, 220, 255)
restoreButton.BackgroundTransparency = 1
restoreButton.Font = Enum.Font.GothamBold
restoreButton.TextSize = 18

restoreButton.MouseButton1Click:Connect(function()
	minimized.Visible = false
	frame.Visible = true
end)

-- === Titel & Buttons ===
local title = Instance.new("TextLabel", frame)
title.Text = "Sorin Scripts"
title.Font = Enum.Font.GothamSemibold
title.TextColor3 = Color3.fromRGB(200, 170, 255)
title.TextSize = 22
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, -80, 0, 30)
title.Position = UDim2.new(0, 10, 0, 5)
title.TextXAlignment = Enum.TextXAlignment.Left

local closeButton = Instance.new("TextButton", frame)
closeButton.Text = "✖"
closeButton.Font = Enum.Font.GothamBold
closeButton.TextColor3 = Color3.fromRGB(255, 100, 100)
closeButton.TextSize = 18
closeButton.BackgroundTransparency = 1
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)

closeButton.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

local minButton = closeButton:Clone()
minButton.Text = "—"
minButton.Position = UDim2.new(1, -70, 0, 5)
minButton.Parent = frame

minButton.MouseButton1Click:Connect(function()
	frame.Visible = false
	minimized.Visible = true
end)

-- === Statusanzeige ===
local status = Instance.new("TextLabel", frame)
status.Text = "Bitte gib deinen Key ein"
status.Font = Enum.Font.Gotham
status.TextColor3 = Color3.fromRGB(160, 160, 255)
status.TextSize = 16
status.BackgroundTransparency = 1
status.Size = UDim2.new(1, -20, 0, 25)
status.Position = UDim2.new(0, 10, 0, 40)

-- === Key Eingabe ===
local keyBox = Instance.new("TextBox", frame)
keyBox.Size = UDim2.new(1, -20, 0, 35)
keyBox.Position = UDim2.new(0, 10, 0, 70)
keyBox.PlaceholderText = "Enter your key here..."
keyBox.Font = Enum.Font.Gotham
keyBox.TextSize = 16
keyBox.Text = ""
keyBox.TextColor3 = Color3.new(1,1,1)
keyBox.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
Instance.new("UICorner", keyBox).CornerRadius = UDim.new(0, 6)

-- === Buttons ===
local function createButton(text, yPos)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -20, 0, 30)
	btn.Position = UDim2.new(0, 10, 0, yPos)
	btn.Text = text
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 16
	btn.BackgroundColor3 = Color3.fromRGB(100, 120, 255)
	btn.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	btn.Parent = frame
	return btn
end

local inputBtn = createButton("🔒 Input", 115)
local getKeyBtn = createButton("🌐 Get Key", 155)
local discordBtn = createButton("💬 Copy Discord", 195)

-- === Button-Aktionen ===
inputBtn.MouseButton1Click:Connect(function()
	local key = keyBox.Text
	if key == "" then
		status.Text = "❗ Kein Key eingegeben"
		return
	end

	local hwid = HttpService:GenerateGUID(false)
	local body = {
		key = key,
		roblox_id = tostring(player.UserId),
		hwid = hwid
	}

	local jsonBody = HttpService:JSONEncode(body)
	local success, response = pcall(function()
		return game:HttpPost(
			"https://iesugielppyhhvtdzsqq.supabase.co/functions/v1/validate-key",
			jsonBody,
			Enum.HttpContentType.ApplicationJson,
			false
		)
	end)

	if not success then
		warn("SERVER-ANTWORT:")
                warn(response)
                status.Text = "❌ Fehler: " .. tostring(response)
		return
	end

	local ok, data = pcall(function()
		return HttpService:JSONDecode(response)
	end)

	if ok and data.load then
		status.Text = "✅ Key gültig – lade..."
		wait(1)
		loadstring(data.load)()
	else
		status.Text = "❌ " .. (data.error or "Ungültiger Key")
	end
end)


getKeyBtn.MouseButton1Click:Connect(function()
	pcall(function()
		setclipboard("https://sorin.services/getkey")
	end)
	status.Text = "🔗 Link kopiert (Get Key)"
end)

discordBtn.MouseButton1Click:Connect(function()
	pcall(function()
		setclipboard("https://discord.gg/yXgtrQ4kPg")
	end)
	status.Text = "📎 Discord-Link kopiert"
end)

-- === Spieleranzeige ===
local nameTag = Instance.new("TextLabel", frame)
nameTag.Text = "👤 " .. player.Name
nameTag.Font = Enum.Font.Gotham
nameTag.TextSize = 14
nameTag.TextColor3 = Color3.fromRGB(200, 200, 200)
nameTag.BackgroundTransparency = 1
nameTag.Size = UDim2.new(1, -20, 0, 20)
nameTag.Position = UDim2.new(0, 10, 1, -25)

local avatar = Instance.new("ImageLabel", frame)
avatar.Size = UDim2.new(0, 40, 0, 40)
avatar.Position = UDim2.new(1, -50, 1, -50)
avatar.BackgroundTransparency = 1
avatar.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. player.UserId .. "&width=150&height=150&format=png"
Instance.new("UICorner", avatar).CornerRadius = UDim.new(1, 0)

-- === Konsole-Logs ===
print("Willkommen bei Sorin Scripts")
print("Version: 0.0.1 Alpha")
print("Join our Discord: discord.gg/yXgtrQ4kPg")
