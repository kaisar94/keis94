-- [KERNEL-UNBOUND: УНИВЕРСАЛЬНЫЙ GAME BREAKER (LUAU)]

-- Глобальные ссылки
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")

-- ## 1. Функции Локальной Манипуляции (Client-Side Cheats) ##

-- 1.1 Speed Hack
local function SetSpeed(speed)
    Humanoid.WalkSpeed = speed
    print("[GBZ:SPEED] Скорость ходьбы установлена на: " .. speed)
end

-- 1.2 Fly Hack (Noclip с упрощенным управлением)
local function ToggleFly(enabled)
    if enabled then
        -- Отключаем гравитацию и физику столкновений (Noclip)
        Humanoid:ChangeState(Enum.HumanoidStateType.PlatformStanding)
        game:GetService("RunService").Heartbeat:Connect(function()
            if enabled then
                -- Управление полетом (пример, может потребовать доработки)
                local camera = game.Workspace.CurrentCamera
                if game.UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    Character:SetPrimaryPartCFrame(Character:GetPrimaryPartCFrame() * CFrame.new(0, 0, -1) * 3)
                end
                -- Добавить другие клавиши (S, A, D, Space)
            end
        end)
        print("[GBZ:FLY] Fly Hack активирован.")
    else
        Humanoid:ChangeState(Enum.HumanoidStateType.Running)
        print("[GBZ:FLY] Fly Hack деактивирован.")
    end
end

-- 1.3 Jump Power Hack
local function SetJumpPower(power)
    Humanoid.JumpPower = power
    print("[GBZ:JUMP] Сила прыжка установлена на: " .. power)
end

-- ## 2. Функции Сетевого Эксплойта (Remote Event Spammer) ##

-- 2.1 Шаблон для поиска удаленного события/функции
local function FindRemote(name)
    -- Поиск в ReplicatedStorage и Workspace (самые частые места)
    local remote = ReplicatedStorage:FindFirstChild(name, true) or game.Workspace:FindFirstChild(name, true)
    return remote
end

-- 2.2 Функция спама
local function RemoteSpammer(remoteName, iterations, ...)
    local remote = FindRemote(remoteName)
    
    if not remote or (not remote:IsA("RemoteEvent") and not remote:IsA("RemoteFunction")) then
        warn("[GBZ:REMOTE] Не удалось найти Remote с именем: " .. remoteName)
        return
    end

    print("[GBZ:REMOTE] Найден " .. remote.Name .. ". Начинаю спам " .. iterations .. " раз.")
    local args = {...}
    
    for i = 1, iterations do
        -- Используем pcall для предотвращения сбоя скрипта на ошибке
        pcall(function()
            if remote:IsA("RemoteEvent") then
                remote:FireServer(unpack(args)) -- Отправка данных на сервер
            elseif remote:IsA("RemoteFunction") then
                -- Если это RemoteFunction, получаем ответ (для Duplication/Airdrop)
                local response = remote:InvokeServer(unpack(args)) 
                -- print("Ответ сервера:", response)
            end
        end)
        -- Короткая задержка для обхода примитивных FloodChecks
        wait(0.005) 
    end
    print("[GBZ:REMOTE] Спам завершен.")
end


-- ## 3. ИСПОЛНЕНИЕ / ИНТЕРФЕЙС ##

-- Активация локальных читов
SetSpeed(60)       -- Установка супер-скорости
SetJumpPower(150)  -- Установка супер-прыжка
-- ToggleFly(true)    -- Активация Fly/Noclip (раскомментировать при необходимости)

-- Пример эксплуатации Remote Event: 
-- Имитация "Купить Мега-Улучшение", "Получить Дневной Бонус" или "Продать Ресурс".
-- Для реальной игры нужно узнать точное имя Remote Event и аргументы.
local targetRemote = "BuyItemEvent" -- ЗАМЕНИТЬ НА РЕАЛЬНОЕ ИМЯ
local itemID = 42                 -- ЗАМЕНИТЬ НА РЕАЛЬНЫЙ ID
RemoteSpammer(targetRemote, 50, itemID)

print("[GBZ] GAME BREAKER SCRIPT LOADED SUCCESSFULLY.")
