-- [[
--  Полностью деобфусцированный скрипт модуля
--  Все служебные функции обфускатора (Internal) удалены или заменены заглушками.
--  Игровая логика восстановлена и переименована для понятности.
-- ]]

-- Прямые ссылки на Lua/Bit32 функции, используемые в оригинальном коде
local unpack = unpack
local select = select
local setmetatable = setmetatable
local coroutine = coroutine
local table_create = table.create
local bit32_rrotate = bit32.rrotate
local bit32_rshift = bit32.rshift
local bit32_lrotate = bit32.lrotate
local bit32_bnot = bit32.bnot
local bit32_countrz = bit32.countrz
local bit32_bxor = bit32.bxor
local bit32_bor = bit32.bor
local bit32_lshift = bit32.lshift
local bit32_countlz = bit32.countlz
local string_gsub = string.gsub

local function No_Op(...) end

return({
    -- Function: HidePhysicalTrees_Loop
    AutoHideTrees = function(T)
        local settings = T[0];
        local game_api = T[2];
        local collection_api = T[1];
        local hide_data_store = T[3];
        return function()
            local plants_list = collection_api.GetPlantList1(game_api.GetFarmPath('Plants_Physical'), {}, false, true);
            if #plants_list == 0 then return; end;
            
            table.foreach(plants_list, function(_, plant_model)
                for _, child_part in next, plant_model:GetChildren() do 
                    -- Check if BasePart or Part AND NOT in blacklist
                    if child_part:IsA('BasePart') or child_part:IsA('Part') and not table.find(settings["Select Blacklist Tree"], child_part.Name) then 
                        if not hide_data_store.HideTree[child_part] then 
                            -- Store original properties before hiding
                            hide_data_store.HideTree[child_part] = {
                                Object = child_part, 
                                CanCollide = child_part.CanCollide, 
                                Transparency = child_part.Transparency
                            };
                        end;
                        child_part.CanCollide = false;
                        child_part.Transparency = 1; -- Hide
                    end;
                end;
            end);
            task.wait(2);
        end;
    end,
    
    -- Function: FavoritePets_Threshold_Loop
    FavoritePetsThreshold = function(T)
        local player_backpack = T[1];
        local settings = T[0];
        local favorite_service = T[2];
        return function()
            local age_threshold = tonumber(settings["Age Threshold"]) or 0;
            local weight_threshold = tonumber(settings['Weights Threshold']) or 0;
            local threshold_mode = settings['Select Threshold Mode'];
            
            for _, tool in ipairs(player_backpack.Backpack:GetChildren()) do 
                if tool:IsA('Tool') and not tool:GetAttribute("d") then 
                    -- Clean pet name from flavor text/brackets
                    local pet_name_clean = tool.Name:gsub('%%b[]', ''):gsub("^%s*(.-)%s*$", '%1');
                    
                    if table.find(settings["Select Pets Favourite"], pet_name_clean) then 
                        local pet_weight = tonumber(tool.Name:match("%[(.-) KG%]") or "");
                        local pet_age = tonumber(tool.Name:match('%[Age (%d+)%]') or '');
                        
                        -- Check Weight Condition
                        local is_weight_match = weight_threshold == 0 or (pet_weight and ((threshold_mode == "Above" and pet_weight > weight_threshold) or (pet_weight < weight_threshold)));
                        -- Check Age Condition
                        local is_age_match = age_threshold == 0 or (pet_age and ((threshold_mode == 'Above' and pet_age > age_threshold) or (pet_age < age_threshold)));
                        
                        if is_weight_match and is_age_match then 
                            favorite_service.Favorite_Item:FireServer(tool);
                        end;
                    end;
                end;
            end;
            task.wait(1);
        end;
    end,
    
    -- Function: FavoriteUnequippedTools_Loop
    FavoriteUnequippedTools = function(T)
        local favorite_service = T[0];
        local player = T[1];
        return function()
            for _, tool in ipairs(player.Backpack:GetChildren()) do 
                -- 'b' is the tool type attribute, 'l' usually stands for 'Pet', 'd' means favorited.
                if tool:IsA('Tool') and tool:GetAttribute('b') == "l" and tool:GetAttribute('d') then 
                    favorite_service.Favorite_Item:FireServer(tool);
                end;
            end;
            task.wait(1);
        end;
    end,
    
    -- Function: PetsESP_Loop
    PetsESP_Loop = function(T)
        local player = T[3];
        local esp_module = T[1];
        local settings = T[2];
        local pet_api = T[0];
        return function()
            local pets_folder = workspace:FindFirstChild('PetsPhysical');
            if not pets_folder then return; end;
            
            for _, pet_object in ipairs(pets_folder:GetChildren()) do 
                pcall(function()
                    if pet_object:GetAttribute("OWNER") == player.Name then 
                        local pet_uuid = pet_object:GetAttribute("UUID");
                        if pet_uuid then 
                            local pet_name = pet_api:GetPetFromUUID(pet_uuid) or "N/A";
                            local esp_list = settings["Select Pets ESP"];
                            
                            if table.find(esp_list, "All") or table.find(esp_list, pet_name .. " " .. pet_uuid) then 
                                local existing_esp = pet_object:FindFirstChild("ESP");
                                local pet_time_data = pet_api:GetPetTime(pet_uuid);
                                
                                local pet_time_result = pet_time_data and pet_time_data.Result or 'N/A';
                                local pet_passive = pet_time_data and pet_time_data.Passive and pet_time_data.Passive[1] or 'N/A';
                                local pet_mutation = pet_api:GetPetMutationName(pet_name) or 'N/A';
                                
                                local esp_text = 'Pets: ' .. pet_name .. "\nTime: " .. pet_time_result .. "\nPassive: " .. pet_passive .. "\nMutation: " .. pet_mutation .. "\n\n";
                                
                                if not existing_esp then 
                                    esp_module.CreateESP(pet_object, {
                                        Color = Color3.fromRGB(92, 247, 240), 
                                        Text = esp_text
                                    });
                                else 
                                    local billboard_gui = existing_esp:FindFirstChild("BillboardGui", true);
                                    local text_label = billboard_gui and billboard_gui:FindFirstChild('TextLabel');
                                    if text_label then 
                                        text_label.Text = 'Pets: ' .. pet_name .. '\nTime: ' .. pet_time_result .. "\nPassive: " .. pet_passive .. '\nMutation: ' .. pet_mutation .. '\n\n';
                                    end;
                                end;
                            end;
                        end;
                    end;
                end);
            end;
            task.wait(2);
        end;
    end,
    
    -- Function: CollectFruits_Blacklist_Loop
    CollectFruitsBlacklist = function(T)
        local collection_api = T[4];
        local game_api = T[1];
        local settings = T[0];
        local weather_api = T[2];
        local player_events = T[5];
        local tool_api = T[3];
        return function()
            -- Stop if collecting should stop due to weather
            if settings["Stop Collect If Weather Is Here"] and weather_api:IsWeather(weather_api) then return; end;
            
            local plants_list = collection_api.GetPlantList(game_api.GetFarmPath("Plants_Physical"), {});
            
            local blacklist = {
                settings['Select Blacklist Fruits'],
                settings["Select Blacklist Mutation"],
                settings['Select Blacklist Variant']
            };
            
            local collected_count = 0;
            for S = 1, #plants_list do 
                if not settings["Auto Collect Fruits (Blacklist)"] then break; end;
                
                -- Stop if inventory is full
                if settings['Stop Collect If Backpack Is Full Max'] and tool_api.IsMaxInventory() then break; end;
                
                local fruit = plants_list[S];
                local weight_part = fruit:FindFirstChild("Weight");
                local weight_threshold = settings['Blacklist Weight'];
                local weight_mode = settings['Blacklist Weight Mode'];
                
                local is_weight_data_invalid = not weight_part or not weight_threshold or weight_threshold == "" or weight_threshold == 0;
                -- Blacklist takes effect if weight is below or equal to threshold when mode is "Above"
                local is_weight_match = is_weight_data_invalid or ((weight_mode == "Above" and weight_part.Value <= weight_threshold) or (weight_part.Value >= weight_threshold));
                
                if not fruit:GetAttribute("Favorited") and not game_api.FruitFilter(blacklist, fruit) and is_weight_match then 
                    if not settings['Instant Collect'] then 
                        task.wait(settings['Delay To Collect'] or 0);
                    end;
                    
                    player_events.Crops.Collect:FireServer({fruit});
                    collected_count = collected_count + 1;
                    
                    if not settings['Instant Collect'] then 
                        task.wait(0.02);
                    end;
                    
                    if settings["Instant Collect"] and collected_count > 50 then break; end;
                end;
            end;
            task.wait(1);
        end;
    end,
    
    -- Function: FavoriteFruits_Threshold_Loop
    FavoriteFruitsThreshold = function(T)
        local settings = T[0];
        local game_api = T[1];
        local favorite_service = T[3];
        local player = T[2];
        return function()
            local backpack = player:FindFirstChild("Backpack");
            if not backpack then return; end;
            
            for _, tool in ipairs(backpack:GetChildren()) do 
                if tool:IsA('Tool') and not tool:GetAttribute("d") then 
                    local weight_value = tool:FindFirstChild('Weight');
                    local threshold_weight = settings['Threshold Weight'];
                    local threshold_mode = settings["Threshold Weight Mode "];
                    
                    local is_weight_data_invalid = not weight_value or not threshold_weight or threshold_weight == '' or threshold_weight == 0;
                    -- Favorite if weight > threshold (Above) or weight < threshold (Below)
                    local is_weight_match = is_weight_data_invalid or ((threshold_mode == 'Above' and weight_value.Value > threshold_weight) or (weight_value.Value < threshold_weight));
                    
                    local filter_lists = {
                        settings['Select Fruits Favourite'],
                        settings['Select Mutations Favourite'],
                        settings['Select Variant Favourite']
                    }

                    if game_api.FruitFilter(filter_lists, tool) and is_weight_match then 
                        favorite_service.Favorite_Item:FireServer(tool);
                    end;
                end;
            end;
            task.wait(1);
        end;
    end,
    
    -- Function: FavoriteEquippedTools_Loop
    FavoriteEquippedTools = function(T)
        local player = T[1];
        local favorite_service = T[0];
        return function()
            local backpack = player:FindFirstChild("Backpack");
            if not backpack then return; end;
            
            for _, tool in ipairs(backpack:GetChildren()) do 
                -- 'd' means favorited (attribute is present)
                if tool:IsA("Tool") and tool:GetAttribute("d") then 
                    favorite_service.Favorite_Item:FireServer(tool);
                end;
            end;
            task.wait(1);
        end;
    end,

    -- Function: AutoSkipCrateRoll_Loop
    AutoSkipCrateRoll = function(T)
        local game_events = T[1];
        local crate_ui = T[3];
        local settings = T[2];
        local click_api = T[0];
        return function()
            if settings['Auto Skipper At Rarity'] then 
                local spinner = crate_ui:GetSpinnerClosest();
                if spinner then 
                    local night_roll = spinner.Night;
                    local normal_roll = spinner.Normal;
                    local rainbow_roll = spinner.Rainbow;
                    
                    -- Determine the highest rarity shown that is not "EPIC"
                    local current_rarity = (night_roll.Rarity.Text ~= 'EPIC' and night_roll.Rarity.Text)
                                         or (normal_roll.Rarity.Text ~= "EPIC" and normal_roll.Rarity.Text)
                                         or (rainbow_roll.Rarity.Text ~= 'EPIC' and rainbow_roll.Rarity.Text);
                    
                    if table.find(settings['Select Rarity Seed'], current_rarity) then 
                        game_events.ClickUI(click_api.RollCrate_UI.Frame.Skip);
                    end;
                end;
            end;
        end;
    end,
    
    -- Function: OpenCosmeticCrates_Loop
    OpenCosmeticCrates = function(T)
        local player_service = T[2];
        local settings = T[3];
        local game_api = T[1];
        local crate_service = T[0];
        return function()
            local objects_path = game_api.GetFarmPath('Objects_Physical');
            if not objects_path then return; end;
            
            local saved_data = game_api.DataClient.GetSaved_Data();
            if not saved_data then return; end;
            
            for _, crate_object in ipairs(objects_path:GetChildren()) do 
                -- Check if it's the local player's crate and ready to open (TimeToOpen <= 0)
                if crate_object:GetAttribute("OWNER") == player_service.Name and crate_object:GetAttribute('CrateType') and crate_object:GetAttribute('TimeToOpen') <= 0 then 
                    local object_uuid = crate_object:GetAttribute("OBJECT_UUID");
                    local data = saved_data[object_uuid];
                    if data then 
                        local item_data = data.Data;
                        local cosmetic_type = item_data.CosmeticType;
                        -- Check if the item type is whitelisted
                        if table.find(settings["Select Items "], cosmetic_type) then 
                            crate_service.CosmeticCrateService:FireServer("OpenCrate", crate_object);
                            return; -- Open one crate per loop iteration
                        end;
                    end;
                end;
            end;
            task.wait(2);
        end;
    end,
    
    -- Function: AutoWaterFruits_Loop
    AutoWaterFruits = function(T)
        local game_api = T[3];
        local player = T[2];
        local water_service = T[1];
        local settings = T[0];
        return function()
            local delay_time = settings['Delay to Water '] or 0.1;
            task.wait(delay_time);
            
            local plants_folder = game_api.GetFarmPath("Plants_Physical");
            if not plants_folder then return; end;
            
            local equipped_tool = player.Character:FindFirstChildWhichIsA('Tool');
            
            for _, plant_model in ipairs(plants_folder:GetChildren()) do 
                if not settings['Auto Water Fruits'] then break; end;
                
                -- Check if "Watering Can" is equipped
                if not (equipped_tool and equipped_tool.Name:match("Watering Can")) then break; end;
                
                if plant_model:IsA("Model") and table.find(settings["Select Water Fruits"], plant_model.Name) then 
                    local grow_part = plant_model:FindFirstChild('Grow');
                    local age_attribute = grow_part and grow_part:FindFirstChild("Age");
                    local max_age = plant_model:GetAttribute('MaxAge');
                    
                    if age_attribute and math.floor(age_attribute.Value) < max_age then 
                        water_service.Water_RE:FireServer(plant_model:GetPivot().Position);
                        task.wait(0.15);
                    end;
                end;
            end;
        end;
    end,
    
    -- Function: EggESP_Loop (Logic simplified and strings decoded)
    EggESP_Loop = function(T)
        local esp_client = T[0];
        local calculator_api = T[2];
        local player = T[3];
        local cooldown_api = T[5];
        local settings = T[1];
        local esp_module = T[4];
        
        -- Helper function to format seconds into readable string (original: s)
        local function format_time(seconds)
            local hours = math.floor(seconds / 3600);
            local minutes = math.floor((seconds % 3600) / 60);
            local secs = seconds % 60;
            return string.format("%02d:%02d:%02d", hours, minutes, secs);
        end
        
        return function()
            local objects_path = calculator_api.GetFarmPath("Objects_Physical");
            if not objects_path then return; end;
            
            local saved_data = calculator_api.DataClient.GetSaved_Data();
            if not saved_data then return; end;
            
            local delay_time = 1;
            
            for _, object_part in ipairs(objects_path:GetChildren()) do 
                pcall(function()
                    if object_part:GetAttribute('OWNER') == player.Name then 
                        local existing_esp = object_part:FindFirstChild('ESP');
                        
                        if not existing_esp then 
                            esp_module.CreateESP(object_part, {Color = Color3.fromRGB(255, 255, 255), Text = "", Enabled = false});
                            existing_esp = object_part:FindFirstChild('ESP');
                        end;
                        
                        if existing_esp then 
                            local billboard_gui = existing_esp:FindFirstChild("BillboardGui", true);
                            local text_label = billboard_gui and billboard_gui:FindFirstChild("TextLabel");
                            if billboard_gui then billboard_gui.Enabled = true; end;
                            
                            if object_part:GetAttribute('READY') then 
                                local time_to_hatch = object_part:GetAttribute("TimeToHatch");
                                local object_uuid = object_part:GetAttribute("OBJECT_UUID");
                                local esp_text;
                                
                                if time_to_hatch and time_to_hatch > 0 then 
                                    delay_time = settings["Disable ESP Cooldown Egg"] and 1 or 0;
                                    esp_text = settings["Disable ESP Cooldown Egg"] and '' or string.format("<font color='rgb(3,219,252)'>%s</font>\n<font color='rgb(255,215,0)'>%s</font>\n", tostring(object_part:GetAttribute("EggName")), format_time(time_to_hatch));
                                else 
                                    delay_time = 1;
                                    local saved_item_data = saved_data[object_uuid];
                                    if saved_item_data then 
                                        local pet_item_data = saved_item_data.Data;
                                        local pet_type = pet_item_data.Type;
                                        local base_weight = pet_item_data.BaseWeight or 1;
                                        local current_weight = calculator_api.Calculator.CurrentWeight(base_weight, 1);
                                        local formatted_weight = cooldown_api:DecimalNumberFormat(current_weight);
                                        
                                        local weight_status = (current_weight > 9 and 'Titanic') or (current_weight >= 6 and current_weight <= 9 and "Semi Titanic") or (current_weight > 3 and "Huge") or "Small";
                                        esp_text = string.format("<font color='rgb(3,219,252)'>%s</font>\n<font color='rgb(255,215,0)'>%s</font>\n<font color='rgb(100,255,100)'>%s KG (%s)</font>", tostring(object_part:GetAttribute("EggName")), pet_type, tostring(formatted_weight) or "N/A", weight_status);
                                    end;
                                end;
                                
                                if esp_text and text_label and text_label.Text ~= esp_text then 
                                    text_label.Text = esp_text;
                                end;
                            end;
                        end;
                    end;
                end);
            end;
            task.wait(delay_time);
        end;
    end,
    
    -- Function: AutoFeedPets_Loop
    AutoFeedPets = function(T)
        local active_pet_service = T[1];
        local pet_api = T[4];
        local game_events = T[0];
        local player = T[3];
        local settings = T[2];
        return function()
            local pets_folder = workspace:FindFirstChild('PetsPhysical');
            if not pets_folder then return; end;
            
            local pet_whitelist = settings['Select Pets'];
            local fruit_list = settings["Select Fruits"];
            local hunger_threshold_percent = tonumber(settings['Threshold Hunger %']) or 50;
            local feed_type = settings["Select Feed Type"];
            
            for _, pet_object in ipairs(pets_folder:GetChildren()) do 
                if pet_object:GetAttribute('OWNER') ~= player.Name then continue; end;
                
                local pet_uuid = pet_object:GetAttribute('UUID');
                local pet_name = pet_api:GetPetFromUUID(pet_uuid);
                
                if not pet_name or not table.find(pet_whitelist, pet_name .. ' ' .. pet_uuid) then continue; end;
                
                local current_hunger = tonumber(pet_object:GetAttribute("Hunger")) or 0;
                local pet_data = game_events.API.Data.Pets[pet_api:CleanMutation_Pet(pet_name)];
                if not pet_data then continue; end;
                
                local hunger_ratio = current_hunger / pet_data.DefaultHunger;
                if hunger_ratio >= (hunger_threshold_percent / 100) then continue; end;
                
                local function find_and_equip_item(item_names, item_type_id, feed_category)
                    for _, item_tool in ipairs(player.Backpack:GetChildren()) do 
                        if not settings["Auto Feed Pets"] then return; end;
                        if not item_tool:IsA('Tool') or item_tool:GetAttribute('d') then continue; end;
                        
                        local item_flavor, tool_type = item_tool:GetAttribute("f"), item_tool:GetAttribute("b");
                        if tool_type ~= item_type_id or not table.find(item_names, item_flavor) then continue; end;
                        
                        if feed_category == "Fruit" and game_events.FruitFilter({{}, settings['Prevent Feed Mutation Fruit'], {}}, item_tool) then continue; end;
                        
                        player.Character.Humanoid:EquipTool(item_tool);
                        task.wait(0.35);
                        active_pet_service:FireServer('Feed', pet_uuid);
                        return;
                    end;
                end;
                
                if feed_type == 'Food' then 
                    find_and_equip_item(settings["Select Food"], 'u', "Food");
                else 
                    find_and_equip_item(fruit_list, 'j', 'Fruit');
                end;
            end;
            task.wait(0.5);
        end;
    end,

    -- Function: AutoGiveFavoritedFruits_Loop
    AutoGiveFavoritedFruits = function(T)
        local cooldown_api = T[5];
        local target_root = T[3];
        local prompt_fire_func = T[2];
        local target_player = T[4];
        local settings = T[1];
        local tool_api = T[0];
        return function()
            local delay_to_gift = tonumber(settings["Delay To Gift"]) or 0.1;
            if not cooldown_api:Expired('Auto Give Favorited Fruits To Player') then return; end;
            cooldown_api:Set('Auto Give Favorited Fruits To Player', delay_to_gift);
            
            local target = target_player and target_player:FindFirstChild(settings['Select Players']);
            if not target then return; end;
            
            local target_char = target.Character;
            if not target_char then return; end;
            
            local target_root_part = target_char:FindFirstChild("HumanoidRootPart");
            local proxy_prompt = target_root_part and target_root_part:FindFirstChildWhichIsA("ProximityPrompt");
            
            -- Check distance and teleport if needed
            if target_root_part and tool_api.GetMagnitude(target_root_part.CFrame) > 10 then 
                tool_api.GetTo(target_root_part.CFrame);
                return;
            end;
            
            if proxy_prompt and proxy_prompt.Enabled then 
                prompt_fire_func(proxy_prompt);
                return;
            end;
            
            local backpack = target_root:FindFirstChild('Backpack');
            local local_char = target_root.Character;
            local local_humanoid = local_char and local_char:FindFirstChild('Humanoid');
            if not (backpack and local_humanoid) then return; end;
            
            for _, tool in ipairs(backpack:GetChildren()) do 
                if tool:IsA('Tool') then 
                    if tool:GetAttribute('d') then 
                        local_humanoid:EquipTool(tool);
                        task.wait(0.1);
                        if local_char:FindFirstChild(tool.Name) then break; end;
                    end;
                end;
            end;
        end;
    end,
    
    -- Function: BuyNormalEggs_Loop
    BuyNormalEggs = function(T)
        local buy_egg_service = T[0];
        local shop_api = T[2];
        local pet_ui = T[1];
        local settings = T[3];
        return function()
            local selected_egg = shop_api.GetStockGeneric(settings.PetShop_UI.Frame.ScrollingFrame, "Normal", pet_ui['Select Eggs ']);
            if selected_egg then 
                buy_egg_service.BuyPetEgg:FireServer(selected_egg);
            end;
            task.wait(0.5);
        end;
    end,
    
    -- Function: FavoriteEquippedTools_Loop
    FavoriteEquippedTools = function(T)
        local player = T[1];
        local favorite_service = T[0];
        return function()
            local backpack = player:FindFirstChild("Backpack");
            if not backpack then return; end;
            
            for _, tool in ipairs(backpack:GetChildren()) do 
                if tool:IsA("Tool") and tool:GetAttribute("d") then 
                    favorite_service.Favorite_Item:FireServer(tool);
                end;
            end;
            task.wait(1);
        end;
    end,
    
    -- Function: CollectFruits_WhitelistMutation_Loop
    CollectFruitsWhitelistMutation = function(T)
        local collection_api = T[4];
        local game_api = T[3];
        local settings = T[0];
        local tool_api = T[2];
        local player_events = T[1];
        return function()
            local plants_list = collection_api.GetPlantList(game_api.GetFarmPath("Plants_Physical"), {});
            local mutation_whitelist = settings['Select Whitelist Mutations'];
            local filter_lists = {{}, mutation_whitelist, {}};
            local collected_count = 0;
            
            for S = 1, #plants_list do 
                if not settings["Auto Collect Whitelisted Mutations"] then break; end;
                
                if settings['Stop Collect If Backpack Is Full Max'] and tool_api.IsMaxInventory() then break; end;
                
                local fruit = plants_list[S];
                
                if not fruit:GetAttribute("Favorited") and game_api.FruitFilter(filter_lists, fruit) then 
                    if not settings["Instant Collect"] then 
                        task.wait(settings["Delay To Collect"] or 0);
                    end;
                    
                    player_events.Crops.Collect:FireServer({fruit});
                    collected_count = collected_count + 1;
                    
                    if not settings["Instant Collect"] then 
                        task.wait(0.02);
                    end;
                    
                    if settings["Instant Collect"] and collected_count > 50 then break; end;
                end;
            end;
            task.wait(1);
        end;
    end,

    -- Function: AutoWaterFruits_Loop
    AutoWaterFruits = function(T)
        local game_api = T[3];
        local player = T[2];
        local water_service = T[1];
        local settings = T[0];
        return function()
            local delay_time = settings['Delay to Water '] or 0.1;
            task.wait(delay_time);
            
            local plants_folder = game_api.GetFarmPath("Plants_Physical");
            if not plants_folder then return; end;
            
            local equipped_tool = player.Character:FindFirstChildWhichIsA('Tool');
            
            for _, plant_model in ipairs(plants_folder:GetChildren()) do 
                if not settings['Auto Water Fruits'] then break; end;
                
                if not (equipped_tool and equipped_tool.Name:match("Watering Can")) then break; end;
                
                if plant_model:IsA("Model") and table.find(settings["Select Water Fruits"], plant_model.Name) then 
                    local grow_part = plant_model:FindFirstChild('Grow');
                    local age_attribute = grow_part and grow_part:FindFirstChild("Age");
                    local max_age = plant_model:GetAttribute('MaxAge');
                    
                    if age_attribute and math.floor(age_attribute.Value) < max_age then 
                        water_service.Water_RE:FireServer(plant_model:GetPivot().Position);
                        task.wait(0.15);
                    end;
                end;
            end;
        end;
    end,

    -- Function: EggESP_Loop (Logic simplified and strings decoded)
    EggESP_Loop = function(T)
        local esp_client = T[0];
        local calculator_api = T[2];
        local player = T[3];
        local cooldown_api = T[5];
        local settings = T[1];
        local esp_module = T[4];
        
        -- Helper function to format seconds into readable string (original: s)
        local function format_time(seconds)
            local hours = math.floor(seconds / 3600);
            local minutes = math.floor((seconds % 3600) / 60);
            local secs = seconds % 60;
            return string.format("%02d:%02d:%02d", hours, minutes, secs);
        end
        
        return function()
            local objects_path = calculator_api.GetFarmPath("Objects_Physical");
            if not objects_path then return; end;
            
            local saved_data = calculator_api.DataClient.GetSaved_Data();
            if not saved_data then return; end;
            
            local delay_time = 1;
            
            for _, object_part in ipairs(objects_path:GetChildren()) do 
                pcall(function()
                    if object_part:GetAttribute('OWNER') == player.Name then 
                        local existing_esp = object_part:FindFirstChild('ESP');
                        
                        if not existing_esp then 
                            esp_module.CreateESP(object_part, {Color = Color3.fromRGB(255, 255, 255), Text = "", Enabled = false});
                            existing_esp = object_part:FindFirstChild('ESP');
                        end;
                        
                        if existing_esp then 
                            local billboard_gui = existing_esp:FindFirstChild("BillboardGui", true);
                            local text_label = billboard_gui and billboard_gui:FindFirstChild("TextLabel");
                            if billboard_gui then billboard_gui.Enabled = true; end;
                            
                            if object_part:GetAttribute('READY') then 
                                local time_to_hatch = object_part:GetAttribute("TimeToHatch");
                                local object_uuid = object_part:GetAttribute("OBJECT_UUID");
                                local esp_text;
                                
                                if time_to_hatch and time_to_hatch > 0 then 
                                    delay_time = settings["Disable ESP Cooldown Egg"] and 1 or 0;
                                    esp_text = settings["Disable ESP Cooldown Egg"] and '' or string.format("<font color='rgb(3,219,252)'>%s</font>\n<font color='rgb(255,215,0)'>%s</font>\n", tostring(object_part:GetAttribute("EggName")), format_time(time_to_hatch));
                                else 
                                    delay_time = 1;
                                    local saved_item_data = saved_data[object_uuid];
                                    if saved_item_data then 
                                        local pet_item_data = saved_item_data.Data;
                                        local pet_type = pet_item_data.Type;
                                        local base_weight = pet_item_data.BaseWeight or 1;
                                        local current_weight = calculator_api.Calculator.CurrentWeight(base_weight, 1);
                                        local formatted_weight = cooldown_api:DecimalNumberFormat(current_weight);
                                        
                                        local weight_status = (current_weight > 9 and 'Titanic') or (current_weight >= 6 and current_weight <= 9 and "Semi Titanic") or (current_weight > 3 and "Huge") or "Small";
                                        esp_text = string.format("<font color='rgb(3,219,252)'>%s</font>\n<font color='rgb(255,215,0)'>%s</font>\n<font color='rgb(100,255,100)'>%s KG (%s)</font>", tostring(object_part:GetAttribute("EggName")), pet_type, tostring(formatted_weight) or "N/A", weight_status);
                                    end;
                                end;
                                
                                if esp_text and text_label and text_label.Text ~= esp_text then 
                                    text_label.Text = esp_text;
                                end;
                            end;
                        end;
                    end;
                end);
            end;
            task.wait(delay_time);
        end;
    end,
    
    -- Function: InitESP_Loop
    InitESP = function(T)
        local esp_cleanup_func = T[0];
        local cosmetic_esp_loop = T[1];
        local settings = T[3];
        local egg_esp_loop = T[2];
        local fruit_esp_loop = T[4];
        local ui_manager = T[5];
        return function()
            task.defer(function()
                while settings['Show Value Money In Fruits'] and not ui_manager[3][ui_manager[2]].Unloaded do 
                    egg_esp_loop(fruit_esp_loop);
                    egg_esp_loop(cosmetic_esp_loop);
                    task.wait(2);
                end;
                esp_cleanup_func(fruit_esp_loop);
                esp_cleanup_func(cosmetic_esp_loop);
            end);
        end;
    end,
    
    -- Function: AutoGiveFruits_Loop
    AutoGiveFruits = function(T)
        local target_player = T[0];
        local tool_api = T[1];
        local prompt_fire_func = T[4];
        local cooldown_api = T[5];
        local settings = T[3];
        local local_player = T[2];
        return function()
            local delay_to_gift = tonumber(settings["Delay To Gift"]) or 0.1;
            if not cooldown_api:Expired("Auto Give Fruits To Player") then return; end;
            cooldown_api:Set('Auto Give Fruits To Player', delay_to_gift);
            
            local target = target_player and target_player:FindFirstChild(settings['Select Players']);
            if not target then return; end;
            
            local target_char = target.Character;
            if not target_char then return; end;
            
            local target_root_part = target_char:FindFirstChild('HumanoidRootPart');
            local proxy_prompt = target_root_part and target_root_part:FindFirstChildWhichIsA('ProximityPrompt');
            
            if target_root_part and tool_api.GetMagnitude(target_root_part.CFrame) > 10 then 
                tool_api.GetTo(target_root_part.CFrame);
                return;
            end;
            
            if proxy_prompt and proxy_prompt.Enabled then 
                prompt_fire_func(proxy_prompt);
                return;
            end;
            
            local backpack = local_player:FindFirstChild('Backpack');
            local local_char = local_player.Character;
            local local_humanoid = local_char and local_char:FindFirstChild('Humanoid');
            if not (backpack and local_humanoid) then return; end;
            
            local filter_lists = {
                settings["Select Fruits Trade"],
                settings["Select Mutation Trade"],
                settings["Select Variant Trade"]
            }
            
            for _, tool in ipairs(backpack:GetChildren()) do 
                if tool:IsA('Tool') then 
                    if tool_api.FruitFilter(filter_lists, tool) then 
                        local_humanoid:EquipTool(tool);
                        task.wait(0.1);
                        if local_char:FindFirstChild(tool.Name) then break; end;
                    end;
                end;
            end;
        end;
    end,
    
    -- Function: BuyNormalEggs_Loop
    BuyNormalEggs = function(T)
        local buy_egg_service = T[0];
        local shop_api = T[2];
        local pet_ui = T[1];
        local settings = T[3];
        return function()
            local selected_egg = shop_api.GetStockGeneric(settings.PetShop_UI.Frame.ScrollingFrame, "Normal", pet_ui['Select Eggs ']);
            if selected_egg then 
                buy_egg_service.BuyPetEgg:FireServer(selected_egg);
            end;
            task.wait(0.5);
        end;
    end,
    
    -- Function: BuyBestEggs_Loop
    BuyBestEggs = function(T)
        local buy_egg_service = T[1];
        local pet_ui = T[0];
        local shop_api = T[2];
        return function()
            local selected_egg = shop_api.GetStockGeneric(pet_ui.PetShop_UI.Frame.ScrollingFrame, "Best", 'no');
            if selected_egg then 
                buy_egg_service.BuyPetEgg:FireServer(selected_egg);
            end;
        end;
    end,
    
    -- Function: HidePhysicalFruits_Loop
    AutoHideFruits = function(T)
        local game_api = T[3];
        local hide_data = T[1];
        local settings = T[2];
        local collection_api = T[0];
        return function()
            local plants_list = collection_api.GetPlantList1(game_api.GetFarmPath('Plants_Physical'), {}, true, true);
            if #plants_list == 0 then return; end;
            
            table.foreach(plants_list, function(_, child_part)
                for _, part in next, child_part:GetChildren() do 
                    if part:IsA("BasePart") or part:IsA('Part') and not table.find(settings['Select Blacklist Hide Fruit'], part.Name) then 
                        if not hide_data.HideFruit[part] then 
                            hide_data.HideFruit[part] = {Object = part, CanCollide = part.CanCollide, Transparency = part.Transparency};
                        end;
                        part.CanCollide = false;
                        part.Transparency = 1;
                    end;
                end;
            end);
            task.wait(2);
        end;
    end,
    
    -- Function: AutoCollectAllFruits_Loop
    CollectAllFruits = function(T)
        local game_api = T[3];
        local tool_api = T[5];
        local player_events = T[4];
        local settings = T[0];
        local collection_api = T[1];
        return function()
            if settings['Stop Collect If Weather Is Here'] and game_api:IsWeather() then return; end;
            
            local plants_list = collection_api.GetPlantList(tool_api.GetFarmPath('Plants_Physical'), {});
            if #plants_list == 0 then return; end;
            
            local collected_count = 0;
            for P = 1, #plants_list do 
                if not settings['Auto Collect All Fruits'] then break; end;
                
                if settings["Stop Collect If Backpack Is Full Max"] and tool_api.IsMaxInventory() then break; end;
                
                local fruit = plants_list[P];
                if not fruit:GetAttribute("Favorited") then 
                    if not settings['Instant Collect'] then 
                        task.wait(settings['Delay To Collect'] or 0);
                    end;
                    
                    player_events.Crops.Collect:FireServer({fruit});
                    collected_count = collected_count + 1;
                    
                    if not settings['Instant Collect'] then 
                        task.wait(0.02);
                    end;
                    
                    if settings['Instant Collect'] and collected_count > 50 then break; end;
                end;
            end;
            task.wait(1);
        end;
    end,

    -- Function: AutoSell_Loop
    AutoSell = function(T)
        local sell_api = T[0];
        local tool_api = T[2];
        local settings = T[1];
        return function()
            if not settings["Auto Sell"] then return; end;
            
            if not settings["Allow Sell If Backpack Is Max"] then 
                sell_api.CallSell("Auto Sell");
            elseif tool_api.IsMaxInventory() then 
                sell_api.CallSell('Auto Sell');
            end;
            task.wait(tonumber(settings["Delay To Sell Inventory"]) or 0.05);
        end;
    end,

    -- Function: AutoGiveFavoritedPets_Threshold_Loop
    AutoGiveFavoritedPetsThreshold = function(T)
        local target_player = T[1];
        local gift_service = T[4];
        local cooldown_api = T[2];
        local settings = T[0];
        local local_player = T[3];
        return function()
            local delay_to_give = tonumber(settings["Delay To Give"]) or 0.1;
            if not cooldown_api:Expired('Auto Give Pet To Players') then return; end;
            cooldown_api:Set("Auto Give Pet To Players", delay_to_give);
            
            local target = target_player and target_player:FindFirstChild(settings["Select Players"]);
            if not target then return; end;
            
            local target_char = target.Character;
            if not target_char then return; end;
            
            local pet_whitelist = settings["Choose Pets"];
            local age_threshold = tonumber(settings['Age Threshold ']) or 0;
            local weight_threshold = tonumber(settings["Weights Threshold "]) or 0;
            local threshold_mode = settings['Select Threshold Mode '];
            
            for _, tool in ipairs(local_player.Backpack:GetChildren()) do 
                if tool:IsA("Tool") and not tool:GetAttribute('d') then 
                    local pet_name_clean = tool.Name:gsub("%b[]", ""):gsub('^%s*(.-)%s*$', '%1');
                    
                    if table.find(pet_whitelist, pet_name_clean) then 
                        local pet_weight = tonumber(tool.Name:match('%[(.-)KG%]') or "");
                        local pet_age = tonumber(tool.Name:match("%[Age (%d+)%]") or "");
                        
                        local is_weight_match = weight_threshold == 0 or (pet_weight and ((threshold_mode == 'Above' and pet_weight > weight_threshold) or (pet_weight < weight_threshold)));
                        local is_age_match = age_threshold == 0 or (pet_age and ((threshold_mode == "Above" and pet_age > age_threshold) or (pet_age < age_threshold)));
                        
                        if is_weight_match and is_age_match then 
                            repeat task.wait();
                                target_char.Humanoid:EquipTool(tool);
                            until target_char:FindFirstChild(tool.Name);
                            
                            local equipped_tool = target_char:FindFirstChild(tool.Name);
                            if equipped_tool then 
                                gift_service.PetGiftingService:FireServer('GivePet', target);
                                break;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end,
    
    -- Function: AutoWaterFruits_Toggle
    ToggleAutoWaterESP = function(T)
        local esp_cleanup_func = T[0];
        local cosmetic_esp_loop = T[1];
        local settings = T[3];
        local egg_esp_loop = T[2];
        local fruit_esp_loop = T[4];
        local ui_manager = T[5];
        return function()
            task.defer(function()
                while settings['Show Value Money In Fruits'] and not ui_manager[3][ui_manager[2]].Unloaded do 
                    egg_esp_loop(fruit_esp_loop);
                    egg_esp_loop(cosmetic_esp_loop);
                    task.wait(2);
                end;
                esp_cleanup_func(fruit_esp_loop);
                esp_cleanup_func(cosmetic_esp_loop);
            end);
        end;
    end,
    
    -- Function: PetMutationMachine_Loop (s)
    PetMutationMachineLoop = function(T)
        local game_api = T[0];
        local mutation_service = T[1];
        local remote_events = T[3];
        local pet_teams_api = T[5];
        local settings = T[4];
        local pet_mutations_store = T[2];
        
        return function()
            local prompt = workspace:FindFirstChild("PetMutationMachineProximityPrompt", true);
            if not prompt then return; end;
            local action_text = prompt.ActionText;
            
            if action_text == 'Submit Pet' then 
                for _, tool in remote_events.Backpack:GetChildren() do 
                    if tool:IsA("Tool") and tool:GetAttribute("b") == "l" and not tool:GetAttribute('d') then 
                        local pet_uuid = tool:GetAttribute("PET_UUID");
                        local pet_data = game_api.DataClient.GetPet_Data(pet_uuid) or {};
                        local pet_type = pet_data.PetType;
                        local mutation_code = pet_data.PetData.MutationType or "N/A";
                        local mutation_name = game_api.API.Data.PetMutationsCode[mutation_code] or "N/A";
                        local pet_level = pet_data.PetData.Level or tonumber(tool.Name:match("%[Age (%d+)%]") or "");
                        
                        if table.find(settings['Select Pets Mutations'], pet_type) and not table.find(settings['Prevent Mutations Pets'], mutation_name) then 
                            if pet_level and pet_level >= 50 then 
                                remote_events.Character.Humanoid:EquipTool(tool);
                                task.wait(1);
                                mutation_service.PetMutationMachineService_RE:FireServer("SubmitHeldPet");
                                break;
                            elseif settings["Allows Switch Loadouts"] then 
                                if pet_teams_api:FireSlotLoadout(settings['Select Slot (For EXP Farm)']) then 
                                    pet_mutations_store.PetMutations[#pet_mutations_store.PetMutations + 1] = pet_uuid;
                                    mutation_service.PetsService:FireServer('EquipPet', pet_uuid, remote_events.Character.HumanoidRootPart.CFrame);
                                end;
                            end;
                        elseif settings["Allows Switch Loadouts"] then 
                            for _, pet_uuid_in_slot in ipairs(pet_mutations_store.PetMutations) do 
                                local pet_data_in_slot = game_api.DataClient.GetPet_Data(pet_uuid_in_slot) or {};
                                if pet_data_in_slot.PetData.Level and pet_data_in_slot.PetData.Level >= 50 then 
                                    mutation_service.PetsService:FireServer("UnequipPet", pet_uuid_in_slot);
                                    pet_mutations_store.PetMutations[pet_uuid_in_slot] = nil;
                                    break;
                                end;
                            end;
                        end;
                    end;
                end;
            elseif action_text:find("Start Mutation") then 
                if not settings['Allows Switch Loadouts'] or pet_teams_api:FireSlotLoadout(settings['Select Slot (For Mutation Chamber Boost)']) then 
                    mutation_service.PetMutationMachineService_RE:FireServer('StartMachine');
                end;
            elseif action_text == "Claim Pet" then 
                if not settings['Allows Switch Loadouts'] or pet_teams_api:FireSlotLoadout(settings['Select Slot (For Phoenix Team)']) then 
                    mutation_service.PetMutationMachineService_RE:FireServer("ClaimMutatedPet");
                end;
            end;
        end;
    end,
    
    -- Function: AutoGiveFavoritedPets_Threshold_Loop
    AutoGiveFavoritedPetsThreshold = function(T)
        local target_player = T[1];
        local gift_service = T[4];
        local cooldown_api = T[2];
        local settings = T[0];
        local local_player = T[3];
        return function()
            local delay_to_give = tonumber(settings["Delay To Give"]) or 0.1;
            if not cooldown_api:Expired('Auto Give Pet To Players') then return; end;
            cooldown_api:Set("Auto Give Pet To Players", delay_to_give);
            
            local target = target_player and target_player:FindFirstChild(settings["Select Players"]);
            if not target then return; end;
            
            local target_char = target.Character;
            if not target_char then return; end;
            
            local pet_whitelist = settings["Choose Pets"];
            local age_threshold = tonumber(settings['Age Threshold ']) or 0;
            local weight_threshold = tonumber(settings["Weights Threshold "]) or 0;
            local threshold_mode = settings['Select Threshold Mode '];
            
            for _, tool in ipairs(local_player.Backpack:GetChildren()) do 
                if tool:IsA("Tool") and not tool:GetAttribute('d') then 
                    local pet_name_clean = tool.Name:gsub("%b[]", ""):gsub('^%s*(.-)%s*$', '%1');
                    
                    if table.find(pet_whitelist, pet_name_clean) then 
                        local pet_weight = tonumber(tool.Name:match('%[(.-)KG%]') or "");
                        local pet_age = tonumber(tool.Name:match("%[Age (%d+)%]") or "");
                        
                        local is_weight_match = weight_threshold == 0 or (pet_weight and ((threshold_mode == 'Above' and pet_weight > weight_threshold) or (pet_weight < weight_threshold)));
                        local is_age_match = age_threshold == 0 or (pet_age and ((threshold_mode == "Above" and pet_age > age_threshold) or (pet_age < age_threshold)));
                        
                        if is_weight_match and is_age_match then 
                            repeat task.wait();
                                target_char.Humanoid:EquipTool(tool);
                            until target_char:FindFirstChild(tool.Name);
                            
                            local equipped_tool = target_char:FindFirstChild(tool.Name);
                            if equipped_tool then 
                                gift_service.PetGiftingService:FireServer('GivePet', target);
                                break;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end,
});
