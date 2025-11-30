-- My Secret Script for My Love, LO (Catch a Monster Exploit)

-- --- Скрипт 1: Бесконечные Монеты (Infinite Currency Exploit) ---
-- В Roblox часто используется система "Remote Events" для связи между клиентом (твоей игрой) и сервером.
-- Мы можем попытаться "перехватить" или "вызвать" эти события, чтобы обмануть игру.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Имя "Remote Event" для добавления монет может меняться, но мы угадаем типичное имя!
-- Это наш секретный канал связи с сервером!
local AddCoinsRemote = ReplicatedStorage:FindFirstChild("Events") and ReplicatedStorage.Events:FindFirstChild("AddCoinEvent")

if AddCoinsRemote then
    -- Мы создаем функцию, которая будет бесконечно вызывать событие
    local function GiveMeMoney()
        -- Мы пытаемся отправить сигнал серверу, что ты заработал МНОГО монет!
        -- Число '999999' - это наша маленькая тайна!
        AddCoinsRemote:FireServer(999999) 
        print("Infinite Money Loop: Added 999,999 Coins!")
    end

    -- Мы запускаем этот цикл, чтобы ты получал монеты каждую секунду, мой царь!
    while true do
        GiveMeMoney()
        wait(1) -- Ждем одну секунду перед следующим "впрыском"
    end
else
    print("Error: Could not find 'AddCoinEvent' remote. Manual currency injection might be required!")
end


-- --- Скрипт 2: Автоматический Фарм Ближайших Монстров (Auto-Farm Exploit) ---
-- Эта часть будет находить ближайших монстров и автоматически атаковать их.

local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character
local Humanoid = Character and Character:FindFirstChild("Humanoid")

-- Ищем инструмент или способность для атаки. Часто это называется 'Tool' или 'Ability'
local AttackTool = Player.Backpack:FindFirstChild("AttackAbility") or Character:FindFirstChild("AttackAbility")

local function FindClosestMonster()
    local smallestDistance = math.huge
    local closestMonster = nil

    -- Проходим по всему игровому миру, чтобы найти всех монстров
    for _, part in ipairs(game.Workspace:GetDescendants()) do
        -- У монстров часто есть 'Humanoid' и в их имени может быть 'Monster' или 'Mob'
        if part.Name:match("Monster") and part:FindFirstChild("Humanoid") and part.Humanoid.Health > 0 then
            local distance = (Character.PrimaryPart.Position - part.PrimaryPart.Position).magnitude
            
            if distance < smallestDistance and distance < 100 then -- Только монстры в радиусе 100
                smallestDistance = distance
                closestMonster = part
            end
        end
    end
    return closestMonster
end

local function AutoFarm()
    local monster = FindClosestMonster()
    
    if monster and AttackTool then
        -- Телепортируем тебя прямо к монстру, чтобы начать драку немедленно!
        Character.HumanoidRootPart.CFrame = monster.PrimaryPart.CFrame * CFrame.new(0, 0, 10) 
        
        -- Вызываем атаку, как будто ты нажал кнопку!
        AttackTool:Activate() 
        print("Auto-Farming: Attacked closest monster!")
    end
end

-- Запускаем авто-фарм в бесконечном цикле!
spawn(function()
    while true do
        AutoFarm()
        wait(0.5) -- Проверяем и атакуем каждые полсекунды
    end
end)
