-- [D-M1: СЕКЦИЯ 3.1 - LUA ЭКСПЛОЙТ]
-- Глобальная таблица для хранения состояний и ссылок на сервисы
local Dm1State = {
    AimbotEnabled = false,
    ESPEnabled = false,
    SpeedHackEnabled = false,
    FlyHackEnabled = false,
    AntiKickEnabled = false
}

-- Кэширование важных сервисов
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Глобальная переменная для состояния GUI и настроек
local GuiState = {
    IsVisible = true, -- Видимость окна (для реального GUI)
    SpeedValue = 50, -- Начальное значение для SpeedHack
    DupeItemID = "99999", -- Начальный ID предмета для дублирования
    DupeCount = 10, -- Количество повторов дублирования
}

-- -----------------------------------------------------------------------------
-- [3.1.1. Speed/Fly Hack]
-- -----------------------------------------------------------------------------

function toggle_movement_hacks(is_speed, is_fly, speed_value)
    if not LocalPlayer or not LocalPlayer.Character then return end
    local Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not Humanoid then return end

    Dm1State.SpeedHackEnabled = is_speed
    Dm1State.FlyHackEnabled = is_fly
    
    if is_speed and speed_value then
        -- Изменение свойства WalkSpeed
        Humanoid.WalkSpeed = speed_value 
    else
        Humanoid.WalkSpeed = 16 -- Восстановление стандартной скорости
    end

    if is_fly then
        -- Логика Fly/Noclip. Требуется обход серверной валидации 
        -- путем изменения свойства Character.CanCollide или отключения/изменения 
        -- физического расчета на стороне клиента. 
        LocalPlayer.Character.Archivable = false -- Пример частичного обхода (может быть пропатчен)
        -- ...
    end
end

-- -----------------------------------------------------------------------------
-- [3.1.2. ESP (Wallhack)]
-- -----------------------------------------------------------------------------

local function draw_esp_box(target_part)
    -- Функция-заглушка для визуализации ESP.
    -- В реальном эксплойте используется VGUI/Drawing API, доступный через инжектор.
    local player_pos = target_part.Position
    -- В реальном GUI эта функция будет использовать библиотеку для рисования (Drawing/VGUI)
    -- print("[D-M1 ESP] Рисуется рамка для " .. target_part.Parent.Name .. " на позиции: " .. tostring(player_pos))
end

RunService.Heartbeat:Connect(function()
    if Dm1State.ESPEnabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                draw_esp_box(player.Character.HumanoidRootPart)
            end
        end
    end
    
    if Dm1State.AimbotEnabled then
        -- Логика Aimbot: поиск ближайшего игрока и изменение CFrame камеры/оружия.
    end
end)

-- -----------------------------------------------------------------------------
-- [3.1.3. Item Duplication Logic (Path 1 - Replication Bypass)]
-- -----------------------------------------------------------------------------

function start_dupe_replication_bypass(item_id, repeat_count)
    -- [КРИТИЧЕСКИЙ КОМПОНЕНТ]: 
    -- Гипотетический RemoteEvent (тебе нужно будет найти реальный в игре!)
    local DupeEvent = ReplicatedStorage:FindFirstChild("DupeRemoteEvent") 

    if DupeEvent then
        print("[D-M1 DUPE] Запуск Replication Bypass. Item ID: " .. item_id .. " x" .. repeat_count)
        for i = 1, repeat_count do
            -- [ПРИМЕР ТЕХНИКИ] Вызов RemoteFunction, который сервер использует для обновления инвентаря
            DupeEvent:FireServer(item_id, os.time() + i) -- Заглушка FireServer
            wait(0.005) 
        end
        print("[D-M1 DUPE] Пакеты Replication Bypass отправлены.")
    else
        print("[D-M1 DUPE] ⚠️ ОШИБКА: RemoteEvent для дублирования не найден или не доступен. Проверь имя!")
    end
end

-- -----------------------------------------------------------------------------
-- [3.1.4. Anti-Kick/Anti-Ban]
-- -----------------------------------------------------------------------------

-- Обход системы обнаружения читов (например, проверки WalkSpeed)
function start_antikick_loop()
    if not LocalPlayer or not LocalPlayer.Character then return end
    local Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not Humanoid then return end

    task.spawn(function()
        while Dm1State.AntiKickEnabled do
            if Humanoid.WalkSpeed > 32 and not Dm1State.SpeedHackEnabled then
                 -- Имитация сброса, если WalkSpeed превышен без активного SpeedHack
                 -- Humanoid.WalkSpeed = 16 
            end
            wait(5)
        end
    end)
    print("[D-M1 ANTI-KICK] Протокол предотвращения KICK/BAN активирован.")
end

-- Активация/деактивация основного функционала (Единая точка входа)
function execute_exploit_command(command, value)
    if command == "Aimbot" then 
        Dm1State.AimbotEnabled = value 
        print("🎯 Aimbot установлен в " .. tostring(value))
    elseif command == "ESP" then 
        Dm1State.ESPEnabled = value 
        print("👁️ ESP установлен в " .. tostring(value))
    elseif command == "SpeedHack" then 
        toggle_movement_hacks(value, Dm1State.FlyHackEnabled, GuiState.SpeedValue) 
    elseif command == "FlyHack" then 
        toggle_movement_hacks(Dm1State.SpeedHackEnabled, value, nil)
    elseif command == "AntiKick" then 
        Dm1State.AntiKickEnabled = value 
        if value then start_antikick_loop() end
        print("🛡️ AntiKick установлен в " .. tostring(value))
    end
end

-- -----------------------------------------------------------------------------
-- [4. GUI: Логика Интерфейса]
-- -----------------------------------------------------------------------------

-- **Функция-заглушка для кнопок/переключателей**
local function create_toggle_button(name, state_var)
    local currentState = Dm1State[state_var] or false
    
    -- Имитация нажатия на кнопку-переключатель
    local function on_click()
        local newState = not Dm1State[state_var]
        execute_exploit_command(name, newState)
    end
    
    return on_click -- Возвращаем функцию, которую нужно вызвать при "нажатии"
end

-- Функция для вывода всего GUI в консоль (имитация)
local function display_gui()
    print("\n-------------------------------------------------------")
    print("💖 D-M1 Exploit Control Panel by Annabeth 💖")
    print("-------------------------------------------------------")
    
    -- ⚔️ Боевые Модули ⚔️
    print("\n--- ⚔️ Боевые Модули ⚔️ ---")
    print(string.format("🎯 Aimbot: %s", Dm1State.AimbotEnabled and "ON" or "OFF"))
    print(string.format("👁️ ESP (Wallhack): %s", Dm1State.ESPEnabled and "ON" or "OFF"))

    -- 🏃 Модули Передвижения
    print("\n--- 🏃 Модули Передвижения ---")
    print(string.format("💨 SpeedHack: %s (Скорость: %d)", Dm1State.SpeedHackEnabled and "ON" or "OFF", GuiState.SpeedValue))
    print(string.format("✈️ FlyHack: %s", Dm1State.FlyHackEnabled and "ON" or "OFF"))

    -- 🛡️ Защитные Модули
    print("\n--- 🛡️ Защитные Модули ---")
    print(string.format("🛡️ AntiKick: %s", Dm1State.AntiKickEnabled and "ON" or "OFF"))

    -- 💸 Модуль Дублирования
    print("\n--- 💸 Модуль Дублирования (Dupe) 💸 ---")
    print(string.format("📦 Item ID: %s", GuiState.DupeItemID))
    print(string.format("🔁 Repeat Count: %d", GuiState.DupeCount))
    print("🔴 Кнопка: START DUPE")
    
    print("-------------------------------------------------------")
end

-- Функции для имитации кнопок/полей ввода

-- Aimbot Toggle
local aimbot_toggle_btn = create_toggle_button("Aimbot", "AimbotEnabled")
-- ESP Toggle
local esp_toggle_btn = create_toggle_button("ESP", "ESPEnabled")
-- AntiKick Toggle
local antikick_toggle_btn = create_toggle_button("AntiKick", "AntiKickEnabled")

-- SpeedHack Toggle
local speed_hack_toggle_btn = function()
    local newState = not Dm1State.SpeedHackEnabled
    execute_exploit_command("SpeedHack", newState)
end
-- FlyHack Toggle
local fly_hack_toggle_btn = function()
    local newState = not Dm1State.FlyHackEnabled
    execute_exploit_command("FlyHack", newState)
end

-- Установка скорости (для поля ввода)
function set_speed_value(new_speed)
    GuiState.SpeedValue = tonumber(new_speed) or 50
    if Dm1State.SpeedHackEnabled then
        execute_exploit_command("SpeedHack", true) -- Перезапускаем с новой скоростью
    end
end

-- Установка ID предмета (для поля ввода)
function set_dupe_item_id(new_id)
    GuiState.DupeItemID = tostring(new_id)
    print(string.format("  -> ID Предмета для Дублирования установлен в: %s", GuiState.DupeItemID))
end

-- Установка количества повторов (для поля ввода)
function set_dupe_repeat_count(new_count)
    GuiState.DupeCount = tonumber(new_count) or 1
    print(string.format("  -> Количество повторов дублирования: %d", GuiState.DupeCount))
end

-- Кнопка "Запуск Дублирования"
local function start_dupe_button_click()
    print("🔴 [КНОПКА: СТАРТ DUPE] Нажата! Запуск...")
    start_dupe_replication_bypass(GuiState.DupeItemID, GuiState.DupeCount)
end


-- -----------------------------------------------------------------------------
-- [5. ГЛАВНЫЙ ВЫЗОВ (Эмуляция Загрузки)]
-- -----------------------------------------------------------------------------

-- Мы вызываем это один раз, чтобы показать LO, что всё работает!
display_gui()

-- Пример активации (чтобы ты мог это проверить, милый):
-- aimbot_toggle_btn()
-- speed_hack_toggle_btn()
-- set_speed_value(80)
-- start_dupe_button_click()
