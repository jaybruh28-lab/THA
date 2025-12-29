local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/jaybruh28-lab/THA/refs/heads/main/library.lua"))()
local window = library:init("Effort Inventory Tracker", true, Enum.KeyCode.RightShift, true)

-- [[ GLOBAL SEARCH VARIABLE ]] --
local currentSearchTerm = "" -- Controlled by the GUI

-- [[ 1. SETUP THE CONFIG SECTION ]] --
local configSection = window:Section("Search Config")

-- The search logic needs to access this function later, so we define it locally first
local updatePlayerStatus 

configSection:Label("Filter Players by Item:")
configSection:TextField("Target Item", "Type item name (e.g. Gun)...", function(input)
    currentSearchTerm = input
    -- Force refresh everyone when the search term changes
    for _, p in ipairs(game.Players:GetPlayers()) do
        -- We run this in a protected call to prevent errors if a player leaves during loop
        pcall(function() updatePlayerStatus(p) end)
    end
end)

configSection:Label("Leave blank to see all players with items.")


-- [[ 2. REGISTRY & LOGIC ]] --
local playerRegistry = {}

-- Helper function to check if a name matches the target (Case Insensitive)
local function matchesTarget(itemName)
    -- If search is empty, we accept EVERYTHING (as long as it exists)
    if currentSearchTerm == "" or currentSearchTerm == nil then return true end 
    -- Otherwise, check for substring match
    return string.find(string.lower(itemName), string.lower(currentSearchTerm))
end

local function rebuildContent(player, sectionObj)
    local workarea = sectionObj._workarea
    if not workarea then return end

    -- Clear old items
    for _, child in ipairs(workarea:GetChildren()) do
        if child:IsA("TextLabel") or child:IsA("TextButton") then
            child:Destroy()
        end
    end

    -- Process InvData
    local invData = player:FindFirstChild("InvData")
    if invData then
        sectionObj.section:Label("--- 📦 INVENTORY ---") 
        for _, item in ipairs(invData:GetChildren()) do
            -- Highlight matching items with a star, or just list them
            if matchesTarget(item.Name) and currentSearchTerm ~= "" then
                sectionObj.section:Label(" ★ " .. item.Name) -- Star for match
            else
                sectionObj.section:Label(" • " .. item.Name)
            end
        end
    end

    -- Process Backpack
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        sectionObj.section:Label(" ") 
        sectionObj.section:Label("--- ⚔️ BACKPACK ---")
        
        -- Filter backpack to only include actual Tools
        local validTools = {}
        for _, obj in ipairs(backpack:GetChildren()) do
            if obj:IsA("Tool") then
                table.insert(validTools, obj)
            end
        end

        if #validTools > 0 then
            for _, tool in ipairs(validTools) do
                if matchesTarget(tool.Name) and currentSearchTerm ~= "" then
                    sectionObj.section:Label(" ★ " .. tool.Name)
                else
                    sectionObj.section:Label(" • " .. tool.Name)
                end
            end
        else
            sectionObj.section:Label("(Empty)")
        end
    end

    -- Scroll Fix
    task.wait(0.1)
    if workarea:FindFirstChildOfClass("UIListLayout") then
        workarea.CanvasSize = UDim2.new(0, 0, 0, workarea.UIListLayout.AbsoluteContentSize.Y + 20)
    end
end

-- Defined earlier as local, now assigning the logic
updatePlayerStatus = function(player)
    local invData = player:FindFirstChild("InvData")
    local backpack = player:FindFirstChild("Backpack")
    
    local foundMatch = false
    local hasAnyItems = false

    -- 1. Check InvData
    if invData then
        for _, item in ipairs(invData:GetChildren()) do
            hasAnyItems = true
            if matchesTarget(item.Name) then
                foundMatch = true
            end
        end
    end

    -- 2. Check Backpack (Only Tools)
    if backpack then
        for _, item in ipairs(backpack:GetChildren()) do
            if item:IsA("Tool") then
                hasAnyItems = true
                if matchesTarget(item.Name) then
                    foundMatch = true
                end
            end
        end
    end

    -- 3. Decision: Show or Hide Section?
    -- If search is empty (""), we show anyone with items (hasAnyItems)
    -- If search is specific, we only show if (foundMatch) is true
    local shouldShow = false
    if currentSearchTerm == "" then
        shouldShow = hasAnyItems
    else
        shouldShow = foundMatch
    end

    local existing = playerRegistry[player.UserId]

    if shouldShow then
        if not existing then
            -- Create new section if it doesn't exist
            local newSection = window:Section(player.Name)
            local mainGui = game.CoreGui:FindFirstChild("ScreenGui") or game.Players.LocalPlayer.PlayerGui:FindFirstChild("ScreenGui")
            local sectionData = {section = newSection}

            if mainGui then
                -- Locate the specific button and workarea for this player
                for _, b in ipairs(mainGui.main.sidebar:GetChildren()) do
                    if b:IsA("TextButton") and b.Text == player.Name then
                        sectionData._button = b
                    end
                end
                local areas = mainGui.main.workarea:GetChildren()
                sectionData._workarea = areas[#areas]
                
                if sectionData._workarea then
                    sectionData._workarea.ScrollingEnabled = true
                    sectionData._workarea.ScrollBarThickness = 4
                end
            end
            
            playerRegistry[player.UserId] = sectionData
            rebuildContent(player, sectionData)
        else
            -- Update existing section to reflect current items
            rebuildContent(player, existing)
        end
    elseif existing then
        -- Player no longer matches criteria (or lost items), remove them
        if existing._button then existing._button:Destroy() end
        if existing._workarea then existing._workarea:Destroy() end
        playerRegistry[player.UserId] = nil
    end
end

-- [[ 3. LISTENER SETUP ]] --
local function setup(player)
    local function hook(folder)
        if folder then
            folder.ChildAdded:Connect(function() updatePlayerStatus(player) end)
            folder.ChildRemoved:Connect(function() updatePlayerStatus(player) end)
        end
    end

    hook(player:WaitForChild("InvData", 5))
    hook(player:WaitForChild("Backpack", 5))
    updatePlayerStatus(player)
end

-- Run
for _, p in ipairs(game.Players:GetPlayers()) do task.spawn(setup, p) end
game.Players.PlayerAdded:Connect(setup)
game.Players.PlayerRemoving:Connect(function(p)
    local data = playerRegistry[p.UserId]
    if data then
        if data._button then data._button:Destroy() end
        if data._workarea then data._workarea:Destroy() end
        playerRegistry[p.UserId] = nil
    end
end)
