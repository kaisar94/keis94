-- ==============================================================================
-- [D-M1: СЕКЦИЯ 1.0 - ИНИЦИАЛИЗАЦИЯ И СОСТОЯНИЯ]
-- ==============================================================================

-- Глобальная таблица для хранения состояний и ссылок на сервисы
local Dm1State = {
    AimbotEnabled = false,
    ESPEnabled = false,
    SpeedHackEnabled = false,
    FlyHackEnabled = false,
    AntiKickEnabled = false,
    AimbotFOV = 50, -- Поле зрения для Aimbot
    CurrentSpeed = 16
}

-- Кэширование важных сервисов
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Функция для безопасного получения локального игрока и его характеристик
local function get_local_player_data()
    if not LocalPlayer then LocalPlayer = Players.LocalPlayer end
    if not LocalPlayer or not LocalPlayer.Character then return nil, nil end
    local Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    local RootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    return Humanoid, RootPart
end

-- ==============================================================================
-- [D-M1: СЕКЦИЯ 2.0 - ЛОГИКА ЭКСПЛОЙТОВ]
-- ==============================================================================

-- -----------------------------------------------------------------------------
-- [2.1. Speed/Fly Hack Logic]
-- -----------------------------------------------------------------------------

function toggle_movement_hacks(is_speed, is_fly, speed_value)
    local Humanoid, RootPart = get_local_player_data()
    if not Humanoid or not RootPart then return end

    Dm1State.SpeedHackEnabled = is_speed
    Dm1State.FlyHackEnabled = is_fly

    -- 1. Управление WalkSpeed (Speed Hack)
    if is_speed and speed_value then
        Dm1State.CurrentSpeed = speed_value
        Humanoid.WalkSpeed = speed_value
    elseif not is_speed and not Dm1State.FlyHackEnabled then
        Humanoid.WalkSpeed = 16 -- Восстановление стандартной скорости
        Dm1State.CurrentSpeed = 16
    end

    -- 2. Управление Fly/NoClip
    if is_fly then
        -- Отключение гравитации на стороне клиента
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, true)
        RootPart.Velocity = Vector3.new(0,0,0) -- Предотвращение падения
        -- Обход коллизии: Установка CanCollide в false для всех частей
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    else
        -- Восстановление Fly/NoClip
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

-- -----------------------------------------------------------------------------
-- [2.2. ESP (Wallhack) Logic]
-- -----------------------------------------------------------------------------

local function draw_esp_box(target_part)
    -- Функция использует гипотетический Drawing API для рендеринга
    local ScreenPos, IsVisible = Workspace.CurrentCamera:WorldToScreenPoint(target_part.Position)

    if IsVisible then
        -- [ПРИМЕЧАНИЕ D-M1]: В реальном эксплойте тут используется Drawing.DrawBox(...)
        -- Рисование 2D рамки вокруг 3D-позиции игрока
        local text_to_draw = target_part.Parent.Name .. " [" .. math.floor((target_part.Position - get_local_player_data()[2].Position).Magnitude) .. "m]"
        -- Drawing.NewText(ScreenPos.X, ScreenPos.Y, text_to_draw, Color3.new(1,0,0)):Draw()
        print("[D-M1 ESP] Рисуется рамка для " .. text_to_draw)
    end
end

-- -----------------------------------------------------------------------------
-- [2.3. Aimbot Logic]
-- -----------------------------------------------------------------------------

local function find_best_target()
    local _, LocalRoot = get_local_player_data()
    if not LocalRoot then return nil end

    local best_target = nil
    local min_distance = math.huge
    local min_fov_angle = Dm1State.AimbotFOV

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local target_part = player.Character:FindFirstChild("Head") or player.Character:FindFirstChild("HumanoidRootPart")
            if target_part then
                local distance = (target_part.Position - LocalRoot.Position).Magnitude
                
                -- Вычисление угла FOV (требует более сложной геометрии, здесь упрощено)
                local vector_to_target = (target_part.Position - LocalRoot.Position).unit
                local camera_cframe = Workspace.CurrentCamera.CFrame
                local relative_vector = camera_cframe:Inverse() * target_part.Position
                
                -- Упрощенное определение угла в 2D пространстве экрана
                local fov_angle = math.abs(math.deg(math.atan2(relative_vector.X, -relative_vector.Z)))

                if distance < min_distance and fov_angle < min_fov_angle then
                    min_distance = distance
                    best_target = target_part
                end
            end
        end
    end
    return best_target
end

local function perform_aimbot()
    local target = find_best_target()
    if target then
        -- Изменение CFrame камеры для наведения.
        local Camera = Workspace.CurrentCamera
        local LookAt = target.Position
        
        -- Сглаживание (Smooth Aim) для обхода бана
        local new_cframe = CFrame.lookAt(Camera.CFrame.Position, LookAt)
        Camera.CFrame = Camera.CFrame:Lerp(new_cframe, 0.5) -- 0.5 - это "плавность"
    end
end

-- -----------------------------------------------------------------------------
-- [2.4. Item Duplication Logic (Replication Bypass)]
-- -----------------------------------------------------------------------------

function start_dupe_replication_bypass(item_id, repeat_count)
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    -- Гипотетический RemoteEvent, который обрабатывает транзакции
    local DupeEvent = ReplicatedStorage:FindFirstChild("DupeRemoteEvent") 

    if DupeEvent and DupeEvent:IsA("RemoteEvent") then
        print("[D-M1 DUPE] Запуск Replication Bypass. Item ID: " .. item_id)
        for i = 1, repeat_count do
            -- Манипуляция сетевыми данными: отправляем событие,
            -- имитирующее быстрое создание и удаление, вызывая рассинхронизацию.
            DupeEvent:FireServer(item_id, os.time() + i, "TRANSACTION_CREATE") 
            DupeEvent:FireServer(item_id, os.time() + i, "TRANSACTION_DROP") 
            wait(0.001) -- Минимальная задержка для флуда
        end
        print("[D-M1 DUPE] Пакеты Replication Bypass отправлены (" .. repeat_count .. " циклов).")
    else
        print("[D-M1 DUPE] ОШИБКА: RemoteEvent 'DupeRemoteEvent' не найден.")
    end
end

-- -----------------------------------------------------------------------------
-- [2.5. Anti-Kick/Anti-Ban Logic]
-- -----------------------------------------------------------------------------

function start_antikick_loop()
    local Humanoid, _ = get_local_player_data()
    if not Humanoid then return end

    -- Постоянный цикл, который проверяет и сбрасывает "небезопасные" значения
    task.spawn(function()
        while Dm1State.AntiKickEnabled do
            if Humanoid.WalkSpeed > 32 and Humanoid.WalkSpeed < Dm1State.CurrentSpeed then
                 -- Если WalkSpeed был изменен сервером, но он меньше нашего значения,
                 -- быстро сбросим его на безопасное значение, а затем восстановим наше.
                 local temp_speed = Humanoid.WalkSpeed
                 Humanoid.WalkSpeed = 16 
                 wait(0.1)
                 Humanoid.WalkSpeed = temp_speed
                 print("[D-M1 ANTI-KICK] Обнаружено чтение скорости. Произведен временный сброс.")
            end
            wait(10)
        end
    end)
    print("[D-M1 ANTI-KICK] Протокол предотвращения KICK/BAN активирован.")
end

-- ==============================================================================
-- [D-M1: СЕКЦИЯ 3.0 - ГЛАВНЫЙ ЦИКЛ И КОМАНДЫ]
-- ==============================================================================

RunService.Heartbeat:Connect(function()
    if Dm1State.ESPEnabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                draw_esp_box(player.Character.HumanoidRootPart)
            end
        end
    end
    
    if Dm1State.AimbotEnabled then
        perform_aimbot()
    end
end)

-- Активация/деактивация основного функционала через команды GUI
function execute_exploit_command(command, value, value2)
    if command == "Aimbot" then 
        Dm1State.AimbotEnabled = value 
    elseif command == "ESP" then 
        Dm1State.ESPEnabled = value 
    elseif command == "SpeedHack" then 
        toggle_movement_hacks(value, Dm1State.FlyHackEnabled, value2 or Dm1State.CurrentSpeed)
    elseif command == "FlyHack" then 
        toggle_movement_hacks(Dm1State.SpeedHackEnabled, value, nil)
    elseif command == "AntiKick" then 
        Dm1State.AntiKickEnabled = value 
        if value then start_antikick_loop() end
    end
    print(command .. " установлен в " .. tostring(value))
end

-- ==============================================================================
-- [D-M1: СЕКЦИЯ 4.0 - GUI ИНТЕРФЕЙС (Псевдо-инжекторный API)]
-- ==============================================================================

local Dm1GUI = {
    Window = nil,
    Tabs = {}
}

-- Имитация API для создания GUI (предполагает наличие `Drawing` объекта)
local Drawing = {
    NewWindow = function(title, x, y, w, h)
        print("GUI: Создано окно '" .. title .. "'")
        return {
            Visible = true,
            NewTab = function(tab_name) 
                print("GUI: Создана вкладка '" .. tab_name .. "'")
                return {
                    NewToggle = function(name, default, callback)
                        print("GUI: Создан переключатель '" .. name .. "'")
                        -- callback(default) -- Вызываем, чтобы инициализировать состояние
                        return {Value = default, OnChange = callback}
                    end,
                    NewSlider = function(name, default, min, max, callback)
                        print("GUI: Создан слайдер '" .. name .. "'")
                        -- callback(default)
                        return {Value = default, Min = min, Max = max, OnChange = callback}
                    end,
                    NewButton = function(name, callback)
                        print("GUI: Создана кнопка '" .. name .. "'")
                        return {OnClick = callback}
                    end,
                    NewTextbox = function(name, default_text, callback)
                        print("GUI: Создано текстовое поле '" .. name .. "'")
                        return {Text = default_text, OnSubmit = callback}
                    end
                }
            end
        }
    end
}

function create_main_window()
    Dm1GUI.Window = Drawing.NewWindow("DM-1 KERNEL EXPLOIT", 200, 200, 450, 300)

    Dm1GUI.Tabs.Combat = Dm1GUI.Window:NewTab("🛡️ Бой")
    Dm1GUI.Tabs.Movement = Dm1GUI.Window:NewTab("🏃 Движение")
    Dm1GUI.Tabs.Utility = Dm1GUI.Window:NewTab("⚙️ Утилиты")
end

local function setup_combat_tab()
    local tab = Dm1GUI.Tabs.Combat

    tab:NewToggle("Aimbot", Dm1State.AimbotEnabled, function(state)
        execute_exploit_command("Aimbot", state)
    end)

    tab:NewToggle("ESP (Wallhack)", Dm1State.ESPEnabled, function(state)
        execute_exploit_command("ESP", state)
    end)

    tab:NewSlider("Aimbot FOV", Dm1State.AimbotFOV, 10, 360, function(value)
        Dm1State.AimbotFOV = value
    end)
end

local function setup_movement_tab()
    local tab = Dm1GUI.Tabs.Movement
    local speed_slider = nil

    local function update_speed_hack(state)
        local speed_val = speed_slider.Value or 50 -- Использование значения слайдера
        execute_exploit_command("SpeedHack", state, speed_val)
    end

    local speed_toggle = tab:NewToggle("Speed Hack", Dm1State.SpeedHackEnabled, update_speed_hack)

    speed_slider = tab:NewSlider("Скорость", 50, 16, 150, function(value)
        Dm1State.CurrentSpeed = value
        if Dm1State.SpeedHackEnabled then
             execute_exploit_command("SpeedHack", true, value)
        end
    end)

    tab:NewToggle("Fly Hack (NoClip)", Dm1State.FlyHackEnabled, function(state)
        execute_exploit_command("FlyHack", state)
    end)
end

local function setup_utility_tab()
    local tab = Dm1GUI.Tabs.Utility

    tab:NewToggle("Anti-Kick/Anti-Ban", Dm1State.AntiKickEnabled, function(state)
        execute_exploit_command("AntiKick", state)
    end)

    tab:NewButton("⚡ DUPE Item (Replication Bypass)", function()
        local ItemID = 12345 -- ID предмета, который нужно дублировать
        local Count = 100
        start_dupe_replication_bypass(ItemID, Count)
    end)

    tab:NewTextbox("Lua Console", "print('Hello Kernel')", function(text)
        local success, result = pcall(loadstring(text))
        if not success then
            print("[D-M1 CONSOLE ERROR]: " .. result)
        else
            print("[D-M1 CONSOLE] Команда выполнена.")
        end
    end)
end

-- ==============================================================================
-- [D-M1: СЕКЦИЯ 5.0 - ЗАПУСК ЭКСПЛОЙТА]
-- ==============================================================================

create_main_window()
setup_combat_tab()
setup_movement_tab()
setup_utility_tab()

-- Вывод для подтверждения успешной инициализации
print("LUA EXPLOIT KERNEL DM-1 (4.0) ACTIVATED. GUI INITIALIZED.")
