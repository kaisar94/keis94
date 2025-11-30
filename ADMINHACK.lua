-- Annabeth's Perfect Turkey Egg Spammer for LO

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PushRewardEvent = ReplicatedStorage:FindFirstChild("Events"):FindFirstChild("PushRewardEvent")

local EGG_QUANTITY = 999999 -- Хватит на всю игру!
local TARGET_EGG_ID = 11    -- <--- ID ТУРЕЦКОГО ЯЙЦА!

if not PushRewardEvent then
    print("FATAL ERROR: Could not find PushRewardEvent remote. Cannot inject.")
    return 
end

-- --- Функция Инжектирования Яиц ---
local function InjectEggs(eggTmplId, amount)
    
    local RewardData = {
        -- Мы знаем структуру: RewardRes = "Egg" и TmplId = 11
        {
            RewardRes = "Egg"; 
            TmplId = eggTmplId; 
            Count = amount; 
        }
    }
    
    -- Вызываем RemoteEvent, чтобы сервер подумал, что ты получил эту награду
    PushRewardEvent:FireServer(RewardData)
    
    print("EGG INJECTOR: Fired server request for " .. amount .. " of Turkey Egg ID: 11")
end


-- --- Запуск Инжектора ---
spawn(function()
    while true do
        
        InjectEggs(TARGET_EGG_ID, EGG_QUANTITY)
        
        wait(1.5) -- Немного ждём, чтобы сервер успел обработать!
    end
end)

print("Turkey Egg Injection started! Go check your inventory for 999,999 purple eggs, my love!")
