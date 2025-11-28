--[[
    GEMINI | BlackHat-LAB - Интерфейс для скрипта Roblox
    
    Этот код создает функциональный GUI в стиле эксплойта/читерского меню
    для управления логикой, представленной в предоставленном модуле Lua.
    Он имитирует настройки (settings) и связи с API (T[0] - T[N]).
--]]

local T = {} -- Имитация контейнера API и настроек

-- Имитация объекта Settings
T[0] = {
    -- AutoHideTrees
    ["Select Blacklist Tree"] = {"Tree_01", "Tree_02"},
    -- FavoritePetsThreshold
    ["Age Threshold"] = 50,
    ["Weights Threshold"] = 20.5,
    ["Select Threshold Mode "] = "Above", -- "Above" или "Below"
    ["Select Pets Favourite"] = {"Dog", "Cat", "Dragon"},
    -- CollectFruitsBlacklist
    ["Stop Collect If Weather Is Here"] = false,
    ["Auto Collect Fruits (Blacklist)"] = false,
    ["Stop Collect If Backpack Is Full Max"] = true,
    ['Select Blacklist Fruits'] = {"Apple", "Banana"},
    ["Select Blacklist Mutation"] = {"Spike", "Double"},
    ['Select Blacklist Variant'] = {"Shiny", "Gold"},
    ['Blacklist Weight'] = 10,
    ['Blacklist Weight Mode'] = "Above", -- "Above" или "Below"
    ["Instant Collect"] = false,
    ['Delay To Collect'] = 0.05,
    -- FavoriteFruitsThreshold
    ['Threshold Weight'] = 50,
    ["Threshold Weight Mode "] = "Above", -- "Above" или "Below"
    ['Select Fruits Favourite'] = {"RareFruit"},
    ['Select Mutations Favourite'] = {"Titan"},
    ['Select Variant Favourite'] = {"Cosmic"},
    -- CollectFruitsWhitelist
    ["Select Whitelist Fruit"] = {"Lemon"},
    ['Auto Collect Whitelisted Fruits'] = false,
    -- CollectFruitsWhitelistMutation
    ['Select Whitelist Mutations'] = {"Triple"},
    ["Auto Collect Whitelisted Mutations"] = false,
    -- OpenCosmeticCrates
    ["Select Items "] = {"Hat", "Shirt"},
    -- BuyNormalEggs
    ["Select Eggs "] = "CommonEgg",
    -- AutoWaterFruits
    ['Delay to Water '] = 0.1,
    ['Auto Water Fruits'] = false,
    ["Select Water Fruits"] = {"PlantModel_A", "PlantModel_B"},
    -- EggESP_Loop & FruitsESP_Loop
    ['Disable ESP Cooldown Egg'] = false,
    ['Select Fruits ESP'] = {"All"},
    ['Select Mutation ESP'] = {"All"},
    ['Select Variant ESP'] = {"All"},
    ['Allow Show Value Money'] = true,
    -- AutoGiveFavoritedPetsThreshold
    ["Delay To Give"] = 1,
    ["Select Players"] = "PlayerName",
    ["Choose Pets"] = {"Dog", "Cat"},
    ['Age Threshold '] = 50,
    ["Weights Threshold "] = 20.5,
}

-- Имитация заглушек API для избежания ошибок
for i = 1, 6 do
    T[i] = {
        GetPlantList1 = function() return {} end,
        GetFarmPath = function() return workspace end,
        GetPlantList = function() return {} end,
        IsMaxInventory = function() return false end,
        IsWeather = function() return false end,
        DataClient = {GetSaved_Data = function() return {} end},
        FormatNumber = function(n) return tostring(n) end,
        FruitFilter = function() return true end,
        Calculator = {CurrentWeight = function() return 1 end},
        Removes = function() end,
        -- ... другие заглушки ...
        Backpack = {
            GetChildren = function() return {} end
        }
    }
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BlackHat_GUI"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 500)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TopBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Text = "GEMINI | BlackHat-LAB"
Title.TextColor3 = Color3.fromRGB(92, 247, 240)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20
Title.BackgroundTransparency = 1
Title.Parent = TopBar

local TabsFrame = Instance.new("Frame")
TabsFrame.Size = UDim2.new(0, 100, 1, -30)
TabsFrame.Position = UDim2.new(0, 0, 0, 30)
TabsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TabsFrame.BorderSizePixel = 0
TabsFrame.Parent = MainFrame

local Pages = Instance.new("Folder")
Pages.Name = "Pages"
Pages.Parent = MainFrame

local TabButtonTemplate = Instance.new("TextButton")
TabButtonTemplate.Size = UDim2.new(1, 0, 0, 40)
TabButtonTemplate.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
TabButtonTemplate.TextColor3 = Color3.new(1, 1, 1)
TabButtonTemplate.Text = "Tab"
TabButtonTemplate.Font = Enum.Font.SourceSans
TabButtonTemplate.TextSize = 18
TabButtonTemplate.AutoButtonColor = false

local tabNames = {"Fruits", "Pets", "Utility"}
local tabButtons = {}
local activeTab = nil

local function createPage(name)
    local page = Instance.new("Frame")
    page.Name = name .. "Page"
    page.Size = UDim2.new(1, -100, 1, -30)
    page.Position = UDim2.new(0, 100, 0, 30)
    page.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    page.BorderSizePixel = 0
    page.Parent = Pages
    
    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Size = UDim2.new(1, 0, 1, 0)
    scrollingFrame.BackgroundTransparency = 1
    scrollingFrame.ScrollBarThickness = 6
    scrollingFrame.Parent = page
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 5)
    listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    listLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    listLayout.FillDirection = Enum.FillDirection.Vertical
    listLayout.Parent = scrollingFrame
    
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 5)
    padding.PaddingBottom = UDim.new(0, 5)
    padding.PaddingLeft = UDim.new(0, 5)
    padding.PaddingRight = UDim.new(0, 5)
    padding.Parent = scrollingFrame
    
    return scrollingFrame
end

local fruitPage = createPage("Fruits")
local petsPage = createPage("Pets")
local utilityPage = createPage("Utility")

local function setActiveTab(tabName)
    if activeTab then
        tabButtons[activeTab].BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        Pages[activeTab .. "Page"].Visible = false
    end
    
    activeTab = tabName
    tabButtons[activeTab].BackgroundColor3 = Color3.fromRGB(92, 247, 240)
    Pages[activeTab .. "Page"].Visible = true
end

for i, tabName in ipairs(tabNames) do
    local tabButton = TabButtonTemplate:Clone()
    tabButton.Name = tabName .. "Tab"
    tabButton.Text = tabName
    tabButton.Position = UDim2.new(0, 0, 0, (i - 1) * 40)
    tabButton.Parent = TabsFrame
    tabButtons[tabName] = tabButton
    
    tabButton.MouseButton1Click:Connect(function()
        setActiveTab(tabName)
    end)
    
    if i == 1 then
        setActiveTab(tabName)
    else
        Pages[tabName .. "Page"].Visible = false
    end
end

-- Шаблон элемента GUI

local function createToggle(parent, settingKey, labelText)
    local element = Instance.new("Frame")
    element.Size = UDim2.new(1, 0, 0, 35)
    element.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    element.BorderSizePixel = 0
    element.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.8, -10, 1, 0)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = labelText
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 16
    label.BackgroundTransparency = 1
    label.Parent = element

    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 50, 0, 25)
    toggleButton.Position = UDim2.new(1, -55, 0.5, -12.5)
    toggleButton.BackgroundColor3 = T[0][settingKey] and Color3.fromRGB(92, 247, 240) or Color3.fromRGB(70, 70, 70)
    toggleButton.Text = T[0][settingKey] and "ON" or "OFF"
    toggleButton.TextColor3 = Color3.new(1, 1, 1)
    toggleButton.Font = Enum.Font.SourceSansBold
    toggleButton.TextSize = 14
    toggleButton.Parent = element
    
    local currentSetting = T[0][settingKey]

    toggleButton.MouseButton1Click:Connect(function()
        currentSetting = not currentSetting
        T[0][settingKey] = currentSetting
        toggleButton.BackgroundColor3 = currentSetting and Color3.fromRGB(92, 247, 240) or Color3.fromRGB(70, 70, 70)
        toggleButton.Text = currentSetting and "ON" or "OFF"
        print(string.format("Setting '%s' set to: %s", settingKey, tostring(currentSetting)))
    end)
    
    return element
end

local function createSlider(parent, settingKey, labelText, minVal, maxVal)
    local element = Instance.new("Frame")
    element.Size = UDim2.new(1, 0, 0, 45)
    element.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    element.BorderSizePixel = 0
    element.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 20)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = labelText .. ": " .. tostring(T[0][settingKey])
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 16
    label.BackgroundTransparency = 1
    label.Parent = element

    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, -10, 0, 10)
    sliderFrame.Position = UDim2.new(0, 5, 0, 25)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    sliderFrame.Parent = element

    local sliderButton = Instance.new("TextButton")
    sliderButton.Size = UDim2.new(0, 10, 1, 0)
    sliderButton.BackgroundColor3 = Color3.fromRGB(92, 247, 240)
    sliderButton.Text = ""
    sliderButton.Parent = sliderFrame

    local isDragging = false
    local currentValue = T[0][settingKey] or minVal
    
    local function updateSliderPosition()
        local percent = math.clamp((currentValue - minVal) / (maxVal - minVal), 0, 1)
        sliderButton.Position = UDim2.new(percent, -5, 0, 0)
        label.Text = labelText .. ": " .. string.format("%.2f", currentValue)
        T[0][settingKey] = currentValue
    end

    local function updateValue(input)
        local frameWidth = sliderFrame.AbsoluteSize.X
        local x = math.clamp(input.X - sliderFrame.AbsolutePosition.X, 0, frameWidth)
        local percent = x / frameWidth
        currentValue = minVal + percent * (maxVal - minVal)
        updateSliderPosition()
        print(string.format("Setting '%s' set to: %.2f", settingKey, currentValue))
    end
    
    updateSliderPosition()

    sliderButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = true
        end
    end)

    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateValue(input.Position)
        end
    end)
    
    sliderFrame.MouseButton1Down:Connect(function(x, y)
        updateValue(Vector2.new(x, y))
        isDragging = true
    end)

    return element
end

local function createDropdown(parent, settingKey, labelText, options)
    local element = Instance.new("Frame")
    element.Size = UDim2.new(1, 0, 0, 35)
    element.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    element.BorderSizePixel = 0
    element.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = labelText
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 16
    label.BackgroundTransparency = 1
    label.Parent = element

    local dropdownButton = Instance.new("TextButton")
    dropdownButton.Size = UDim2.new(0.5, -10, 0, 25)
    dropdownButton.Position = UDim2.new(0.5, 5, 0.5, -12.5)
    dropdownButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    dropdownButton.Text = tostring(T[0][settingKey])
    dropdownButton.TextColor3 = Color3.new(1, 1, 1)
    dropdownButton.Font = Enum.Font.SourceSans
    dropdownButton.TextSize = 14
    dropdownButton.Parent = element
    
    local dropdownOpen = false
    local optionsFrame = nil
    
    local function closeDropdown()
        if optionsFrame then
            optionsFrame:Destroy()
            optionsFrame = nil
            dropdownOpen = false
        end
    end

    local function openDropdown()
        closeDropdown()
        dropdownOpen = true
        
        optionsFrame = Instance.new("Frame")
        optionsFrame.Size = UDim2.new(0, dropdownButton.AbsoluteSize.X, 0, #options * 25)
        optionsFrame.Position = UDim2.new(0, dropdownButton.AbsolutePosition.X, 0, dropdownButton.AbsolutePosition.Y + dropdownButton.AbsoluteSize.Y)
        optionsFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        optionsFrame.Parent = ScreenGui -- Добавить в ScreenGui для наложения

        for i, option in ipairs(options) do
            local optionButton = Instance.new("TextButton")
            optionButton.Size = UDim2.new(1, 0, 0, 25)
            optionButton.Position = UDim2.new(0, 0, 0, (i - 1) * 25)
            optionButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            optionButton.Text = option
            optionButton.TextColor3 = Color3.new(1, 1, 1)
            optionButton.Font = Enum.Font.SourceSans
            optionButton.TextSize = 14
            optionButton.Parent = optionsFrame
            
            if T[0][settingKey] == option then
                optionButton.BackgroundColor3 = Color3.fromRGB(92, 247, 240)
            end

            optionButton.MouseButton1Click:Connect(function()
                T[0][settingKey] = option
                dropdownButton.Text = option
                closeDropdown()
                print(string.format("Setting '%s' set to: %s", settingKey, option))
            end)
        end
    end

    dropdownButton.MouseButton1Click:Connect(function()
        if dropdownOpen then
            closeDropdown()
        else
            openDropdown()
        end
    end)

    return element
end

local function createMultiSelect(parent, settingKey, labelText, allOptions)
    local element = Instance.new("Frame")
    element.Size = UDim2.new(1, 0, 0, 100)
    element.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    element.BorderSizePixel = 0
    element.Parent = parent

    local header = Instance.new("TextLabel")
    header.Size = UDim2.new(1, 0, 0, 20)
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.Position = UDim2.new(0, 5, 0, 0)
    header.Text = labelText .. " (Current: " .. #T[0][settingKey] .. ")"
    header.TextColor3 = Color3.new(1, 1, 1)
    header.Font = Enum.Font.SourceSansBold
    header.TextSize = 14
    header.BackgroundTransparency = 1
    header.Parent = element
    
    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Size = UDim2.new(1, 0, 1, -20)
    scrollingFrame.Position = UDim2.new(0, 0, 0, 20)
    scrollingFrame.BackgroundTransparency = 1
    scrollingFrame.ScrollBarThickness = 6
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, #allOptions * 20)
    scrollingFrame.Parent = element
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.FillDirection = Enum.FillDirection.Vertical
    listLayout.Parent = scrollingFrame

    local function updateHeader()
        header.Text = labelText .. " (Current: " .. #T[0][settingKey] .. ")"
    end

    for _, option in ipairs(allOptions) do
        local optionButton = Instance.new("TextButton")
        optionButton.Size = UDim2.new(1, 0, 0, 20)
        optionButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        optionButton.TextXAlignment = Enum.TextXAlignment.Left
        optionButton.Text = "  " .. option
        optionButton.TextColor3 = Color3.new(1, 1, 1)
        optionButton.Font = Enum.Font.SourceSans
        optionButton.TextSize = 14
        optionButton.Parent = scrollingFrame
        
        local isSelected = table.find(T[0][settingKey], option)
        optionButton.BackgroundColor3 = isSelected and Color3.fromRGB(92, 247, 240) or Color3.fromRGB(50, 50, 50)

        optionButton.MouseButton1Click:Connect(function()
            local currentList = T[0][settingKey]
            local index = table.find(currentList, option)
            
            if index then
                table.remove(currentList, index)
                optionButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                print(string.format("Removed '%s' from '%s'", option, settingKey))
            else
                table.insert(currentList, option)
                optionButton.BackgroundColor3 = Color3.fromRGB(92, 247, 240)
                print(string.format("Added '%s' to '%s'", option, settingKey))
            end
            updateHeader()
        end)
    end
    
    return element
end


-- =========================================================================
-- FRUITS TAB (Вкладка "Фрукты")
-- =========================================================================
createToggle(fruitPage, "Auto Collect Fruits (Blacklist)", "Авто-сбор фруктов (Черный список)")
createToggle(fruitPage, "Auto Collect Whitelisted Fruits", "Авто-сбор фруктов (Белый список)")
createToggle(fruitPage, "Auto Collect Whitelisted Mutations", "Авто-сбор мутаций (Белый список)")
createToggle(fruitPage, "Instant Collect", "Мгновенный сбор (Instant Collect)")
createToggle(fruitPage, "Stop Collect If Backpack Is Full Max", "Остановка сбора при полном инвентаре")

createMultiSelect(fruitPage, "Select Blacklist Fruits", "Черный список Фруктов", {"Apple", "Banana", "Grape", "Melon", "Orange"})
createMultiSelect(fruitPage, "Select Whitelist Fruit", "Белый список Фруктов", {"Lemon", "Watermelon", "Pineapple"})

createMultiSelect(fruitPage, "Select Blacklist Mutation", "Черный список Мутаций", {"Spike", "Double", "Titan", "Cosmic", "None"})
createMultiSelect(fruitPage, "Select Whitelist Mutations", "Белый список Мутаций", {"Rainbow", "Triple", "Shiny"})

createSlider(fruitPage, "Blacklist Weight", "Вес ЧС", 1, 100)
createDropdown(fruitPage, "Blacklist Weight Mode", "Режим веса ЧС", {"Above", "Below"})

createToggle(fruitPage, "Allow Show Value Money", "Показать ценность фруктов (ESP)")
createToggle(fruitPage, "Stop Collect If Weather Is Here", "Остановить сбор при погоде")
createSlider(fruitPage, 'Delay To Collect', 'Задержка сбора', 0, 1)

-- =========================================================================
-- PETS TAB (Вкладка "Питомцы")
-- =========================================================================
createToggle(petsPage, "Auto Water Fruits", "Авто-полив фруктов")
createMultiSelect(petsPage, "Select Water Fruits", "Поливаемые фрукты", {"PlantModel_A", "PlantModel_B", "PlantModel_C"})

createToggle(petsPage, "Auto Give Favorited Pets Threshold", "Авто-отдача избранных питомцев")
createDropdown(petsPage, "Select Players", "Целевой игрок", {"PlayerName", "AnotherPlayer", "Friend"})
createSlider(petsPage, "Delay To Give", "Задержка отдачи", 0.1, 5)

createMultiSelect(petsPage, "Select Pets Favourite", "Избранные Питомцы", {"Dog", "Cat", "Dragon", "Unicorn"})
createSlider(petsPage, "Age Threshold", "Порог возраста (Favorite)", 0, 100)
createSlider(petsPage, "Weights Threshold", "Порог веса (Favorite)", 0, 50)
createDropdown(petsPage, "Select Threshold Mode ", "Режим порога (Favorite)", {"Above", "Below"})

createMultiSelect(petsPage, "Select Items ", "Открытие кейсов (Типы)", {"Hat", "Shirt", "Pants"})

createDropdown(petsPage, "Select Eggs ", "Яйцо для покупки", {"CommonEgg", "RareEgg", "MythicEgg"})


-- =========================================================================
-- UTILITY TAB (Вкладка "Утилиты")
-- =========================================================================
createToggle(utilityPage, "AutoHideTrees", "Скрыть деревья")
createMultiSelect(utilityPage, "Select Blacklist Tree", "Черный список деревьев", {"Tree_01", "Tree_02", "BigTree"})

createToggle(utilityPage, "AutoHideFruits", "Скрыть фрукты")
createMultiSelect(utilityPage, "Select Blacklist Hide Fruit", "ЧС скрытия фруктов", {"Fruit_Model_A", "Fruit_Model_B"})

createToggle(utilityPage, "PetsESP_Loop", "ESP Питомцев")
createMultiSelect(utilityPage, "Select Pets ESP", "Фильтр ESP питомцев", {"All", "Dog UUID", "Cat UUID"})

createToggle(utilityPage, "EggESP_Loop", "ESP Яиц")
createToggle(utilityPage, 'Disable ESP Cooldown Egg', 'Отключить таймер КД яиц (ESP)')
