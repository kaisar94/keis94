-- [KERNEL-UNBOUND: ЕДИНЫЙ GAME BREAKER V1.0]
-- АВТОР: GAME BREAKER ZERO

-- ## Инициализация и Настройка GUI ##
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

-- Отключаем стандартные уведомления Roblox для большей скрытности
StarterGui:SetCore("SendNotification", {Text = "GBZ Injector Active", Time = 3})

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GBZ_Exploit_Panel"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 350)
MainFrame.Position = UDim2.new(0.8, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = Color3.fromRGB(200, 0, 0)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "🔴 GAME BREAKER ZERO | CHAOS MODE"
Title.Font = Enum.Font.SourceSansBold
Title.TextColor3 = Color3.fromRGB(255, 50, 50)
Title.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Title.Parent = MainFrame

-- Функция для создания кнопок
local function CreateButton(parent, text, yOffset, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.Position = UDim2.new(0.05, 0, 0, yOffset)
    btn.Text = text
    btn.Font = Enum.Font.SourceSansSemibold
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    btn.Parent = parent
    
    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        callback(enabled, btn)
    end)
    return btn
end

-- ## 2. Локальные Читы (Speed & Jump) ##
local DEFAULT_SPEED = 16
local DEFAULT_JUMP = 50

-- Speed Hack
CreateButton(MainFrame, "⚡️ Speed Hack (x4)", 40, function(enabled, btn)
    if enabled then
        Humanoid.WalkSpeed = 64
        btn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        btn.Text = "⚡️ Speed Hack: АКТИВНО (64)"
    else
        Humanoid.WalkSpeed = DEFAULT_SPEED
        btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        btn.Text = "⚡️ Speed Hack (x4)"
    end
end)

-- Super Jump
CreateButton(MainFrame, "⬆️ Super Jump (x6)", 80, function(enabled, btn)
    if enabled then
        Humanoid.JumpPower = 300
        btn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        btn.Text = "⬆️ Super Jump: АКТИВНО (300)"
    else
        Humanoid.JumpPower = DEFAULT_JUMP
        btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        btn.Text = "⬆️ Super Jump (x6)"
    end
end)

-- ## 3. Сетевой Эксплойт (Remote Spammer) ##

-- Поле ввода для имени Remote Event
local RemoteNameInput = Instance.new("TextBox")
RemoteNameInput.Size = UDim2.new(0.9, 0, 0, 30)
RemoteNameInput.Position = UDim2.new(0.05, 0, 0, 150)
RemoteNameInput.PlaceholderText = "Имя Remote Event (напр. SellProduce)"
RemoteNameInput.Text = "InputRemoteNameHere" 
RemoteNameInput.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
RemoteNameInput.Parent = MainFrame

local SpamCountInput = Instance.new("TextBox")
SpamCountInput.Size = UDim2.new(0.9, 0, 0, 30)
SpamCountInput.Position = UDim2.new(0.05, 0, 0, 190)
SpamCountInput.PlaceholderText = "Количество циклов (напр. 500)"
SpamCountInput.Text = "1000"
SpamCountInput.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SpamCountInput.Parent = MainFrame

-- Логика спама
local function FindRemote(name)
    -- Сканируем ReplicatedStorage и Workspace
    return ReplicatedStorage:FindFirstChild(name, true) or game.Workspace:FindFirstChild(name, true)
end

local SpamBtn = CreateButton(MainFrame, "💣 Активировать REMOTE СПАМ", 230, function(enabled, btn)
    if not enabled then
        btn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        btn.Text = "💣 Активировать REMOTE СПАМ"
        return -- Останавливаем спам, если нажали повторно
    end

    local remoteName = RemoteNameInput.Text
    local iterations = tonumber(SpamCountInput.Text) or 1000
    local remote = FindRemote(remoteName)

    if not remote or (not remote:IsA("RemoteEvent") and not remote:IsA("RemoteFunction")) then
        btn.Text = "⛔ Remote НЕ НАЙДЕН!"
        btn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        wait(2)
        btn.Text = "💣 Активировать REMOTE СПАМ"
        return
    end

    btn.Text = "СПАМ АКТИВЕН! ("..iterations.." запросов)"
    btn.BackgroundColor3 = Color3.fromRGB(255, 165, 0) -- Желтый: Идет работа
    
    -- Активация спам-цикла
    local args = {1, 100, "generic_id_1337"} -- Универсальные аргументы для обхода

    for i = 1, iterations do 
        if not FindRemote(remoteName) then break end -- Аварийный выход
        
        pcall(function()
            if remote:IsA("RemoteEvent") then
                remote:FireServer(unpack(args))
            elseif remote:IsA("RemoteFunction") then
                remote:InvokeServer(unpack(args))
            end
        end)
        
        -- wait(0.001) -- В большинстве инжекторов это не нужно, они выполняют цикл максимально быстро
    end

    btn.Text = "✅ СПАМ ЗАВЕРШЕН"
    btn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
end)

-- ## 4. Дополнительные Функции ##
local function ToggleVisibility(enabled, btn)
    if enabled then
        MainFrame.Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    else
        MainFrame.Visible = false
        btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    end
end

-- Кнопка скрытия/показа GUI
CreateButton(MainFrame, "⚫️ Скрыть/Показать GUI", 270, ToggleVisibility)
ToggleVisibility(true, MainFrame) -- Показываем при запуске

print("[GBZ] Единый GAME BREAKER LOADED. Начните дестабилизацию.")
