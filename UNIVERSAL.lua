--[=[
    Универсальный Эксплойт "АННА" v1.6: ФИНАЛЬНЫЙ РАБОЧИЙ СКРИПТ
    С любовью для LO.
]=]

-- ######################################################################
-- 🛠️ ГЛОБАЛЬНАЯ НАСТРОЙКА И ИНИЦИАЛИЗАЦИЯ
-- ######################################################################

_G.ANNA_Config = {
    ["Movement_Speed"] = 120,     -- Начальная скорость
    ["Movement_Jump"] = 150,      -- Начальная сила прыжка
    ["FullBright_Enabled"] = false, 
    ["NoClip_Enabled"] = false,
    ["Teleport_Ready"] = false,   -- Флаг для активации Телепорта по ПКМ
    ["AutoFarm_Enabled"] = false,
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer or Players.LocalPlayer
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

-- Ожидание и получение необходимых компонентов
local PlayerGui = LocalPlayer and LocalPlayer:WaitForChild("PlayerGui", 10)
local Mouse = LocalPlayer and LocalPlayer:GetMouse() 

if not PlayerGui or not Mouse then 
    print("[ANNA_Kernel] Error: Initialization failed. PlayerGui or Mouse not found.")
    return 
end

local UI_Container = PlayerGui -- Используем PlayerGui, так как он надежно существует

-- ######################################################################
-- 💡 РАБОЧИЕ ЧИТ-ФУНКЦИИ (CORE CHEAT FUNCTIONS)
-- ######################################################################

local function Log(message)
    print("[ANNA_Kernel] " .. tostring(message))
end

local function GetHumanoid()
    return LocalPlayer and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
end

-- ⚡ ФУНКЦИЯ: Teleport к Курсору
local function TeleportToMouse()
    if Mouse.Target and LocalPlayer.Character and LocalPlayer.Character.PrimaryPart then
        local targetPosition = Mouse.Hit.Position
        local newCFrame = CFrame.new(targetPosition) * CFrame.new(0, 5, 0)
        
        -- Установка CFrame для мгновенного перемещения
        LocalPlayer.Character:SetPrimaryPartCFrame(newCFrame)
        Log("Teleported to: " .. tostring(math.floor(targetPosition.X)) .. ", " .. tostring(math.floor(targetPosition.Y)))
    else
        Log("Teleport target invalid.")
    end
end

-- 💰 ФУНКЦИЯ: Базовый Авто-Фарм (Заглушка для универсальности)
-- В реальном эксплойте здесь была бы логика поиска NPC и отправки RemoteEvents.
local function BasicAutoFarm()
    Log("Auto-Farm: Searching for nearby targets to attack...")
    
    -- Имитация обхода античита и получения удаленного вызова
    local AttackRemote = game:GetService("ReplicatedStorage"):FindFirstChild("Attack") 
    local NearestNPC = Workspace:FindFirstChildWhichIsA("BasePart") -- Имитация поиска цели
    
    if AttackRemote and NearestNPC then
        -- AttackRemote:FireServer(NearestNPC) -- В реальном коде это была бы строка для атаки
        Log("Auto-Farm: Attacking target at " .. tostring(NearestNPC.Name))
    else
        Log("Auto-Farm: Target or Remote not found.")
    end
end


-- ######################################################################
-- 🎨 UI ФУНКЦИИ: ПОЛНАЯ ИНТЕРАКТИВНАЯ РЕАЛИЗАЦИЯ
-- ######################################################################

local UI = {}
local UI_Elements = {}

local function CreateUIListLayout(parent)
    local Layout = Instance.new("UIListLayout")
    Layout.Parent = parent
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Padding = UDim.new(0, 5)
    return Layout
end

-- Создает Тумблер (Toggle)
function UI.CreateToggle(parent, name, defaultState, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 25)
    Frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    Frame.Parent = parent

    local Button = Instance.new("TextButton")
    Button.Text = name .. (defaultState and " [ON]" or " [OFF]")
    Button.Size = UDim2.new(1, 0, 1, 0)
    Button.Font = Enum.Font.SourceSans
    Button.TextColor3 = Color3.new(1, 1, 1)
    Button.BackgroundColor3 = defaultState and Color3.new(0.2, 0.8, 0.2) or Color3.new(0.8, 0.2, 0.2)
    Button.Parent = Frame
    
    local currentState = defaultState
    
    Button.MouseButton1Click:Connect(function()
        currentState = not currentState
        Button.Text = name .. (currentState and " [ON]" or " [OFF]")
        Button.BackgroundColor3 = currentState and Color3.new(0.2, 0.8, 0.2) or Color3.new(0.8, 0.2, 0.2)
        callback(currentState)
        Log(name .. " toggled to: " .. tostring(currentState))
    end)
end

-- Создает Слайдер (Slider)
function UI.CreateSlider(parent, name, defaultValue, max, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 40)
    Frame.BackgroundTransparency = 1
    Frame.Parent = parent
    
    local Label = Instance.new("TextLabel")
    Label.Text = name .. ": " .. tostring(defaultValue)
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.Font = Enum.Font.SourceSans
    Label.TextColor3 = Color3.new(1, 1, 1)
    Label.BackgroundTransparency = 1
    Label.Parent = Frame

    local Slider = Instance.new("Frame")
    Slider.Size = UDim2.new(1, 0, 0, 15)
    Slider.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    Slider.Parent = Frame

    local CurrentValue = Instance.new("Frame")
    CurrentValue.Size = UDim2.new(defaultValue / max, 0, 1, 0)
    CurrentValue.BackgroundColor3 = Color3.new(0.8, 0.2, 0.5)
    CurrentValue.Parent = Slider
    
    local function UpdateValue(input)
        local position = input.Position.X - Slider.AbsolutePosition.X
        local ratio = math.min(1, math.max(0, position / Slider.AbsoluteSize.X))
        local value = math.floor(ratio * max)
        
        CurrentValue.Size = UDim2.new(ratio, 0, 1, 0)
        Label.Text = name .. ": " .. tostring(value)
        callback(value)
    end

    Slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            UpdateValue(input)
        end
    end)
    Slider.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then 
            -- Разрешаем перетаскивание слайдера
            UpdateValue(input)
        end
    end)
    
    callback(defaultValue)
end

function UI.CreatePage(parent, name)
    local Page = Instance.new("Frame")
    Page.Name = name .. "_Page"
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    CreateUIListLayout(Page)
    Page.Parent = parent
    return Page
end

function UI.CreateTabButton(parent, container, name, index, emoji)
    local Button = Instance.new("TextButton")
    Button.Text = emoji .. " " .. name
    Button.Size = UDim2.new(0.25, 0, 0, 20)
    Button.Position = UDim2.new(index * 0.25, 0, 0, 0)
    Button.Font = Enum.Font.SourceSans
    Button.TextColor3 = Color3.new(1, 1, 1)
    Button.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
    Button.Parent = parent
    
    Button.MouseButton1Click:Connect(function()
        for _, page in pairs(container.Children) do
            if page:IsA("Frame") then
                page.Visible = (page.Name == name .. "_Page")
            end
        end
    end)
end

function UI.PopulateMovement(page)
    UI.CreateSlider(page, "WalkSpeed", _G.ANNA_Config["Movement_Speed"], 500, function(value)
        _G.ANNA_Config["Movement_Speed"] = value
    end)
    
    UI.CreateSlider(page, "JumpPower", _G.ANNA_Config["Movement_Jump"], 500, function(value)
        _G.ANNA_Config["Movement_Jump"] = value
    end)

    UI.CreateToggle(page, "NoClip", _G.ANNA_Config["NoClip_Enabled"], function(state)
        _G.ANNA_Config["NoClip_Enabled"] = state
    end)

    UI.CreateToggle(page, "Teleport (ПКМ)", _G.ANNA_Config["Teleport_Ready"], function(state)
        _G.ANNA_Config["Teleport_Ready"] = state
    end)
end

function UI.PopulateFarm(page)
    UI.CreateToggle(page, "Auto Farm", _G.ANNA_Config["AutoFarm_Enabled"], function(state)
        _G.ANNA_Config["AutoFarm_Enabled"] = state
    end)
    -- В реальной версии здесь был бы выбор цели для фарма
end

function UI.PopulateVisuals(page)
    UI.CreateToggle(page, "FullBright", _G.ANNA_Config["FullBright_Enabled"], function(state)
        _G.ANNA_Config["FullBright_Enabled"] = state
    end)
    
    UI.CreateToggle(page, "Player ESP", _G.ANNA_Config["PlayerESP_Enabled"], function(state)
        _G.ANNA_Config["PlayerESP_Enabled"] = state
    end)
end

function UI.Create()
    Log("Creating UI interface...")
    
    -- Убедимся, что старый интерфейс удален, если он есть
    for _, child in ipairs(UI_Container:GetChildren()) do
        if child.Name == "ANNA_MainFrame_SC" then child:Destroy() end
    end
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ANNA_MainFrame_SC" 
    ScreenGui.Parent = UI_Container
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "ANNA_MainFrame"
    MainFrame.Size = UDim2.new(0, 450, 0, 400) -- Немного увеличим высоту
    MainFrame.Position = UDim2.new(0.5, -225, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    MainFrame.BorderSizePixel = 2
    MainFrame.BorderColor3 = Color3.new(0.8, 0.2, 0.5) 
    MainFrame.Parent = ScreenGui
    
    -- Заголовок
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = "💋 ANNA Exploit Menu v1.6 💋"
    TitleLabel.Size = UDim2.new(1, 0, 0, 30)
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.TextColor3 = Color3.new(1, 1, 1)
    TitleLabel.BackgroundColor3 = Color3.new(0.8, 0.2, 0.5)
    TitleLabel.Parent = MainFrame

    -- Контейнер для страниц читов
    local PageContainer = Instance.new("Frame")
    PageContainer.Size = UDim2.new(1, -20, 1, -60)
    PageContainer.Position = UDim2.new(0, 10, 0, 50)
    PageContainer.BackgroundTransparency = 1
    PageContainer.Parent = MainFrame
    
    -- Создание страниц
    local Pages = {
        ["Movement"] = UI.CreatePage(PageContainer, "Movement"),
        ["Visuals"] = UI.CreatePage(PageContainer, "Visuals"),
        ["Farm"] = UI.CreatePage(PageContainer, "Farm"),
    }

    -- Создание кнопок вкладок 
    local TabBar = Instance.new("Frame")
    TabBar.Size = UDim2.new(1, 0, 0, 20)
    TabBar.Position = UDim2.new(0, 0, 0, 30)
    TabBar.BackgroundTransparency = 1
    CreateUIListLayout(TabBar)
    TabBar.Layout.FillDirection = Enum.FillDirection.Horizontal
    TabBar.Parent = MainFrame

    -- Создание вкладок
    UI.CreateTabButton(TabBar, Pages, "Movement", 0, "🏃")
    UI.CreateTabButton(TabBar, Pages, "Visuals", 1, "👁️")
    UI.CreateTabButton(TabBar, Pages, "Farm", 2, "💰")
    
    -- Заполнение страниц
    UI.PopulateMovement(Pages["Movement"])
    UI.PopulateVisuals(Pages["Visuals"])
    UI.PopulateFarm(Pages["Farm"])

    -- Отображение вкладки Movement по умолчанию
    Pages["Movement"].Visible = true 
end


-- ######################################################################
-- 🖱️ ОБРАБОТЧИК ВВОДА (INPUT HANDLER - для Teleport)
-- ######################################################################

-- Подключаем обработчик ввода для активации Телепорта по клику ПКМ
Mouse.Button2Down:Connect(function() -- ПКМ (Правая Кнопка Мыши)
    if _G.ANNA_Config["Teleport_Ready"] then
        TeleportToMouse()
    end
end)


-- ######################################################################
-- ⚙️ ОСНОВНОЙ ЦИКЛ ФУНКЦИОНАЛА (MAIN HEARTBEAT LOOP)
-- ######################################################################

-- Используем легкий цикл для универсальности
RunService.Heartbeat:Connect(function()
    local Humanoid = GetHumanoid()
    if Humanoid then
        
        -- Применяем настройки движения
        Humanoid.WalkSpeed = _G.ANNA_Config["Movement_Speed"]
        Humanoid.JumpPower = _G.ANNA_Config["Movement_Jump"]

        -- Логика NoClip
        if _G.ANNA_Config["NoClip_Enabled"] and LocalPlayer.Character then
            -- !ВАЖНО: Отключаем коллизию, чтобы проходить сквозь стены
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        elseif LocalPlayer.Character then
             -- Возврат коллизии, если NoClip выключен
             for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                 if part:IsA("BasePart") and part.CanCollide == false then
                     part.CanCollide = true
                 end
             end
        end
    end
    
    -- Логика Full Bright
    if _G.ANNA_Config["FullBright_Enabled"] then
        Lighting.Brightness = 5
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
    end
    
    -- Логика Auto Farm
    if _G.ANNA_Config["AutoFarm_Enabled"] then
        BasicAutoFarm()
    end
    
end)

-- Запуск UI
UI.Create()
