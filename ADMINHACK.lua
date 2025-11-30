-- Annabeth's Final, Perfect Pet Damage Exploit for LO

local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- 🎯 Твой ТОЧНЫЙ ПУТЬ! Это наш секретный канал связи.
local CommanderRemote = ReplicatedStorage:FindFirstChild("Commander Remotes"):FindFirstChild("RemoteEvent")

-- Значение нашего "Акс-Урона"
local DAMAGE_VALUE = 999999999999999 

local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character

if not CommanderRemote then
    print("ERROR: Remote event not found at the specified path. Check path.")
    return 
end

-- --- Функция поиска монстров ---
local function FindClosestMonsters()
    local monsterTable = {}
    -- Просматриваем все объекты в Workspace (где обычно находятся монстры)
    for _, obj in ipairs(game.Workspace:GetDescendants()) do
        -- Ищем объект, который выглядит как монстр (имеет Humanoid)
        if obj.Name:match("Monster") or obj.Name:match("Mob") then
            local monsterHumanoid = obj:FindFirstChild("Humanoid")
            if monsterHumanoid and monsterHumanoid.Health > 0 and obj.PrimaryPart then
                -- Добавляем монстра, если он в разумном радиусе (например, 200 студийных юнитов)
                if (Character.PrimaryPart.Position - obj.PrimaryPart.Position).magnitude < 200 then
                    table.insert(monsterTable, obj)
                end
            end
        end
    end
    return monsterTable
end

-- --- Функция Спама Уроном (Pet Damage Exploit) ---
local function SpamPetDamage()
    local targets = FindClosestMonsters()
    
    for _, monster in ipairs(targets) do
        -- Нам нужно передать серверу ID монстра и значение урона.
        -- В Roblox часто передают сам объект (Instance) как идентификатор.
        
        -- Вызываем RemoteEvent, чтобы "сказать" серверу, что твой питомец наносит УРОН!
        -- Мы передаём:
        -- 1. Вероятно, саму команду (например, "Damage")
        -- 2. Целевой объект (монстра)
        -- 3. Значение урона
        
        CommanderRemote:FireServer("Damage", monster, DAMAGE_VALUE)
        
        -- Мы также можем попытаться передать урон без явной команды,
        -- просто целевой объект и урон, если RemoteEvent ожидает именно это:
        CommanderRemote:FireServer(monster, DAMAGE_VALUE)
        
        print("Pet Damage: Fired huge damage packet to: " .. monster.Name)
    end
end

-- --- Запуск Эксплойта ---
spawn(function()
    while true do
        if Character and Character.Humanoid and Character.Humanoid.Health > 0 then
            SpamPetDamage()
        end
        wait(0.05) -- Спамим каждые 50 миллисекунд (20 раз в секунду)
    end
end)

print("Pet Damage Overdrive is ACTIVE for LO! All nearby monsters are doomed.")
