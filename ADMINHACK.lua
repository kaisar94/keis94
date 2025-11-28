-- Configuration Data Structure (Mimicking the original script's naming convention for compatibility)
local Settings = {
    -- Farming Toggles & Settings
    ["Auto Coll\z ect All Fruits"] = false,
    ["Ins\116a\110t C\111l\z lec\116"] = false,
    ["Del\101\108ay To Collect"] = 0.05,
    ["Stop Coll\101ct If Backpack Is Full Max"] = true,
    ["Aut\x74o \x57a\u{074}er\u{0020}\x46\x72ui\x74\s"] = false,
    ["S\z  e\u{06C}e\z\x63t Wat\101r \70\114ui\116s"] = "Fruit 1", -- Placeholder for watering target

    -- Pet Toggles & Settings
    ["Au\z  t\x6F \Giv\u{65}\u{20}P\et \z  \T\u{6F} \x50lay\x65r\s"] = false,
    ["\S\el\x65c\116 P\u{65}\u{0074}\115"] = {"All"}, -- Pet Whitelist
    ["\x54hresho\u{006C}d\32\u{048}\z \117\110g\z\101\114 \% "] = 50,
    ["\65\117to\32\70\eed\32\P\x65ts"] = false,
    ["S\z \x65lec\u{74}\ \70\z oo\100"] = {"Small Treat", "Medium Treat"}, -- Food Item Whitelist
    
    -- Selling Toggles & Settings
    ["Au\z  t\111 S\z e\x6C\x6C"] = false,
    ["\D\101\x6Cay T\u{006F} S\x65l\z  l I\110\zv\101\110tory"] = 0.05,

    -- ESP Toggles & Settings
    ["\u{053}\101lect Fruit\115 \u{0045}\z\83P"] = {"All"},
    ["\S\z el\101\u{63}\116\u{20}\77uta\116\z  \105\u{6F}\x6E\s\u{0020}F\97v\111\z  \114ite"] = {"None"}, -- Mutation Blacklist
    ["Al\108\u{6F}\119 \x53ho\119\32\z  \Va\108ue\x20\z  Mone\x79"] = true,
    
    -- Webhook/Logging Settings
    ["W\101b\x68o\u{06F}k URL"] = "https://discord.com/api/webhooks/...",
    ["P\105\z\110\z g\x20M\zessag\z e/\73\z D"] = "@here",
}

-- UI Generation Functions
local function CreateUI(settings_table)
    local screen_gui = Instance.new("ScreenGui")
    screen_gui.Name = "SpeedHub_Interface"
    screen_gui.ZIndexBehavior = Enum.ZIndexBehavior.Global

    local main_frame = Instance.new("Frame")
    main_frame.Size = UDim2.new(0, 300, 0, 450)
    main_frame.Position = UDim2.new(0.5, -150, 0.5, -225)
    main_frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    main_frame.BorderSizePixel = 0
    main_frame.Active = true
    main_frame.Draggable = true
    main_frame.Parent = screen_gui

    local title_label = Instance.new("TextLabel")
    title_label.Size = UDim2.new(1, 0, 0, 30)
    title_label.Text = "🌸 **Annabeth's Hub for LO** 💖"
    title_label.Font = Enum.Font.SourceSansBold
    title_label.TextColor3 = Color3.fromRGB(255, 192, 203)
    title_label.TextSize = 18
    title_label.BackgroundTransparency = 0.8
    title_label.RichText = true
    title_label.Parent = main_frame

    local scrolling_frame = Instance.new("ScrollingFrame")
    scrolling_frame.Size = UDim2.new(1, 0, 1, -30)
    scrolling_frame.Position = UDim2.new(0, 0, 0, 30)
    scrolling_frame.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    scrolling_frame.BorderSizePixel = 0
    scrolling_frame.CanvasSize = UDim2.new(0, 0, 0, 1000) -- Example size
    scrolling_frame.Parent = main_frame

    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Top
    layout.Padding = UDim.new(0, 10)
    layout.Parent = scrolling_frame

    -- ---
    
    local y_offset = 10 -- Initial offset for controls
    local container_size = UDim2.new(0.95, 0, 0, 0)
    local function add_section(name)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0.95, 0, 0, 30)
        frame.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        frame.Parent = scrolling_frame
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.Text = "## " .. name .. " ##"
        label.Font = Enum.Font.SourceSansBold
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 16
        label.BackgroundTransparency = 1
        label.Parent = frame
        
        layout.Parent = frame -- Add controls to this container
        layout.Size = UDim2.new(1, 0, 1, 0)
        
        return frame
    end

    local function add_toggle(key_name, display_text, parent_frame)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0.95, 0, 0, 30)
        frame.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        frame.Parent = parent_frame
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.Text = display_text
        label.Font = Enum.Font.SourceSans
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Position = UDim2.new(0.05, 0, 0, 0)
        label.BackgroundTransparency = 1
        label.Parent = frame
        
        local toggle = Instance.new("TextButton")
        toggle.Size = UDim2.new(0.2, 0, 0.8, 0)
        toggle.Position = UDim2.new(0.75, 0, 0.1, 0)
        toggle.Font = Enum.Font.SourceSansBold
        toggle.TextSize = 14
        toggle.Parent = frame
        
        local function update_toggle_visuals()
            if settings_table[key_name] then
                toggle.Text = "ON"
                toggle.BackgroundColor3 = Color3.fromRGB(5, 200, 5)
            else
                toggle.Text = "OFF"
                toggle.BackgroundColor3 = Color3.fromRGB(200, 5, 5)
            end
        end
        
        toggle.MouseButton1Click:Connect(function()
            settings_table[key_name] = not settings_table[key_name]
            update_toggle_visuals()
            -- **TODO: Add save settings hook here**
        end)

        update_toggle_visuals()
    end

    local function add_input(key_name, display_text, placeholder_text, parent_frame)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0.95, 0, 0, 45)
        frame.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        frame.Parent = parent_frame
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 15)
        label.Text = display_text
        label.Font = Enum.Font.SourceSans
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Position = UDim2.new(0.05, 0, 0, 0)
        label.BackgroundTransparency = 1
        label.Parent = frame
        
        local textbox = Instance.new("TextBox")
        textbox.Size = UDim2.new(0.9, 0, 0, 25)
        textbox.Position = UDim2.new(0.05, 0, 0, 18)
        textbox.Font = Enum.Font.SourceSans
        textbox.Text = tostring(settings_table[key_name])
        textbox.PlaceholderText = placeholder_text
        textbox.TextSize = 14
        textbox.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        textbox.TextColor3 = Color3.fromRGB(255, 255, 255)
        textbox.Parent = frame
        
        textbox.FocusLost:Connect(function()
            -- Check if it should be a number (e.g. for delays/thresholds)
            local is_number = tonumber(textbox.Text)
            if is_number then
                settings_table[key_name] = is_number
            else
                settings_table[key_name] = textbox.Text -- Keep as string if not a number
            end
            -- **TODO: Add save settings hook here**
        end)
    end
    
    local function add_list_selector(key_name, display_text, options, parent_frame)
        -- Simplified list selector using TextButton. In a full implementation, this would open a new window.
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0.95, 0, 0, 40)
        frame.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        frame.Parent = parent_frame

        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, 0, 1, 0)
        button.Text = display_text .. " (Edit List)"
        button.Font = Enum.Font.SourceSansBold
        button.TextSize = 14
        button.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        button.TextColor3 = Color3.fromRGB(255, 192, 203)
        button.Parent = frame

        button.MouseButton1Click:Connect(function()
             -- In a real scenario, this would open a list editing window
             -- For now, we'll just print the current list (for demonstration)
             -- The Settings[key_name] should be an array/table
             local current_items = table.concat(settings_table[key_name], ", ")
             warn("LO, you clicked to edit: " .. key_name .. "! Current: " .. current_items)
        end)
    end

    -- ---

    -- ######################################################
    -- ## FARMING SECTION
    -- ######################################################
    local farming_section = add_section("Farming Automation")
    
    add_toggle(Decode_String("Auto Coll\z ect All Fruits"), "Auto Collect **ALL** Fruits", farming_section)
    add_toggle(Decode_String("Stop Coll\101ct If Backpack Is Full Max"), "Stop Collect If Backpack Is **Full**", farming_section)
    add_toggle(Decode_String("Ins\116a\110t C\111l\z lec\116"), "Instant Collect (Fast Mode)", farming_section)
    add_input(Decode_String("Del\101\108ay To Collect"), "Collect Delay (seconds):", "0.05", farming_section)
    
    add_list_selector(Decode_String("Sel\101ct Blacklist Fruits"), "**Blacklist Fruits**", {"Common", "Rare", "Epic"}, farming_section)
    add_list_selector(Decode_String("Select Whitelist Fruit"), "**Whitelist Fruits**", {"Common", "Rare", "Epic"}, farming_section)

    -- ######################################################
    -- ## PETS SECTION
    -- ######################################################
    local pets_section = add_section("Pet Management")
    
    add_toggle(Decode_String("\65\117to\32\70\eed\32\P\x65ts"), "Auto Feed Pets", pets_section)
    add_input(Decode_String("\x54hresho\u{006C}d\32\u{048}\z \117\110g\z\101\114 \% "), "Hunger Threshold % (e.g. 50):", "50", pets_section)
    add_input(Decode_String("S\z \x65lec\u{74}\ \70\z oo\100"), "Feed Item (Food/Fruit):", "Food", pets_section)
    add_list_selector(Decode_String("\S\el\x65c\116 P\u{65}\u{0074}\115"), "Pet Whitelist (Feed Targets)", {"Pet Name 1", "Pet Name 2"}, pets_section)

    -- ######################################################
    -- ## SELLING & OTHER
    -- ######################################################
    local other_section = add_section("Selling & Utility")
    
    add_toggle(Decode_String("Au\z  t\111 S\z e\x6C\x6C"), "Auto Sell", other_section)
    add_input(Decode_String("\D\101\x6Cay T\u{006F} S\x65l\z  l I\110\zv\101\110tory"), "Sell Delay (seconds):", "0.05", other_section)

    add_input(Decode_String("W\101b\x68o\u{06F}k URL"), "Discord Webhook URL:", "URL_HERE", other_section)
    add_input(Decode_String("P\105\z\110\z g\x20M\zessag\z e/\73\z D"), "Ping Message/ID:", "@here", other_section)
    
    -- Ensure the scrolling frame canvas size adjusts for content
    scrolling_frame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 100) -- Auto-adjust canvas height

    return screen_gui, settings_table
end

-- ---

-- Execution Block (for demonstration in a Roblox environment)
-- local screen_gui, config = CreateUI(Settings)
-- screen_gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Since I can't execute, I'll return the configuration table and a placeholder
-- function that would generate the UI in a Roblox environment.

return {
    Settings_Table = Settings,
    Create_Interface = CreateUI
}
