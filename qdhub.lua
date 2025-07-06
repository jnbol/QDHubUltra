-- QDHubUltra Loader (Updated with Installer Key Support)
if not isfile or not writefile or not readfile then
    return warn("Your executor does not support file I/O.")
end

local KEY_FILE = "QDHub_Key.txt"
local VALID_KEYS = { Owner = "ThugTown", User = "QD1234" }
local role = "Guest"

-- Use key from global if set by installer
if _G.QDHubUltraKey and type(_G.QDHubUltraKey) == "string" and #_G.QDHubUltraKey > 0 then
    writefile(KEY_FILE, _G.QDHubUltraKey)
end

-- Load saved key from file
local savedKey = nil
if isfile(KEY_FILE) then
    savedKey = readfile(KEY_FILE)
end

-- Validate key
local function validateKey(key)
    for k, v in pairs(VALID_KEYS) do
        if key == v then
            return k
        end
    end
    return "Guest"
end

role = validateKey(savedKey or "")

-- UI Setup
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()
local Window

local function createUI()
    Window = OrionLib:MakeWindow({
        Name = "QDHubUltra",
        HidePremium = false,
        SaveConfig = true,
        ConfigFolder = "QDHubUltra"
    })

    local Tabs = {
        Scripts = Window:MakeTab({ Name = "📜 Scripts", Icon = "rbxassetid://7733765398", PremiumOnly = false }),
        Games = Window:MakeTab({ Name = "🎮 Games", Icon = "rbxassetid://7734053495", PremiumOnly = false }),
        Settings = Window:MakeTab({ Name = "⚙️ Settings", Icon = "rbxassetid://7733911824", PremiumOnly = false }),
        Info = Window:MakeTab({ Name = "ℹ️ Info", Icon = "rbxassetid://7734053495", PremiumOnly = false }),
    }

    -- If guest, show key input tab
    if role == "Guest" then
        local KeyTab = Window:MakeTab({ Name = "🔑 Unlock", Icon = "rbxassetid://7734053495", PremiumOnly = false })

        KeyTab:AddTextbox({
            Name = "Enter Premium Key",
            Default = "",
            TextDisappear = false,
            Callback = function(key)
                if key == "" then
                    OrionLib:MakeNotification({ Name = "Error", Content = "Please enter a key!", Time = 3 })
                    return
                end

                local newRole = validateKey(key)
                if newRole == "Guest" then
                    OrionLib:MakeNotification({ Name = "Invalid Key", Content = "Key is not valid.", Time = 4 })
                else
                    writefile(KEY_FILE, key)
                    OrionLib:MakeNotification({ Name = "Access Granted", Content = "Welcome, " .. newRole .. "!", Time = 4 })
                    Window:Destroy()
                    task.wait(1)
                    role = newRole
                    createUI()
                end
            end
        })
        return
    end

    -- Scripts Tab Buttons
    Tabs.Scripts:AddButton({ Name = "Universal ESP", Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/jnbol/QDHubUltra/main/scripts/esp.lua"))()
    end })

    Tabs.Scripts:AddButton({ Name = "Silent Aim", Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/jnbol/QDHubUltra/main/scripts/silentaim.lua"))()
    end })

    Tabs.Scripts:AddButton({ Name = "Aimlock", Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/jnbol/QDHubUltra/main/scripts/aimlock.lua"))()
    end })

    Tabs.Scripts:AddButton({ Name = "FPS Boost", Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/jnbol/QDHubUltra/main/scripts/fpsboost.lua"))()
    end })

    -- Games Tab
    local GameScripts = {
        [286090429] = "Arsenal",
        [292439477] = "Phantom Forces",
        [142823291] = "Murder Mystery 2",
        [606849621] = "Jailbreak",
        [2338325648] = "NFL Universe Football"
    }

    local currentGame = GameScripts[game.PlaceId]
    if currentGame then
        Tabs.Games:AddButton({
            Name = "Load " .. currentGame .. " Script",
            Callback = function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/jnbol/QDHubUltra/main/scripts/games/" .. tostring(game.PlaceId) .. ".lua"))()
            end
        })
    else
        Tabs.Games:AddParagraph("Unsupported Game", "This game is not supported yet.")
    end

    -- Settings Tab
    Tabs.Settings:AddToggle({
        Name = "Controller Support",
        Default = true,
        Callback = function(value)
            OrionLib:MakeNotification({ Name = "Controller", Content = "Controller Support is " .. (value and "Enabled" or "Disabled"), Time = 3 })
        end
    })

    Tabs.Settings:AddButton({
        Name = "Reset Key",
        Callback = function()
            if isfile(KEY_FILE) then delfile(KEY_FILE) end
            OrionLib:MakeNotification({ Name = "Key Reset", Content = "Restart loader to re-enter key.", Time = 4 })
        end
    })

    -- Info Tab
    Tabs.Info:AddParagraph("QDHubUltra", "Creator: Laquahveon\nPremium Only Access\nLatest Version: Ultra Final")

    OrionLib:Init()
end

createUI()
