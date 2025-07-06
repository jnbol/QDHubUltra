-- QDHubUltra Final Loader (by Laquahveon)
if not isfile or not writefile or not readfile then
    return warn("Your executor does not support file I/O.")
end

local KEY_FILE = "QDHub_Key.txt"
local VALID_KEYS = { Owner = "ThugTown", User = "QD1234" }
local role = "Guest"

-- UI Setup
local function createUI()
    local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()
    local Window = OrionLib:MakeWindow({
        Name = "QDHubUltra",
        HidePremium = false,
        SaveConfig = true,
        ConfigFolder = "QDHubUltra"
    })

    -- Tabs
    local Tabs = {
        Scripts = Window:MakeTab({ Name = "📜 Scripts", Icon = "rbxassetid://7733765398", PremiumOnly = false }),
        Games = Window:MakeTab({ Name = "🎮 Games", Icon = "rbxassetid://7734053495", PremiumOnly = false }),
        Settings = Window:MakeTab({ Name = "⚙️ Settings", Icon = "rbxassetid://7733911824", PremiumOnly = false }),
        Info = Window:MakeTab({ Name = "ℹ️ Info", Icon = "rbxassetid://7734053495", PremiumOnly = false }),
    }

    -- Key System
    if isfile(KEY_FILE) then
        local savedKey = readfile(KEY_FILE)
        for k, v in pairs(VALID_KEYS) do
            if savedKey == v then
                role = k
            end
        end
    end

    if role == "Guest" then
        OrionLib:MakeNotification({ Name = "Authentication Required", Content = "Enter your premium key to unlock full access", Time = 5 })
        OrionLib:MakeTab({ Name = "🔑 Unlock", Icon = "rbxassetid://7734053495", PremiumOnly = false })
            :AddTextbox({
                Name = "Enter Key",
                Default = "",
                TextDisappear = false,
                Callback = function(key)
                    for k, v in pairs(VALID_KEYS) do
                        if key == v then
                            writefile(KEY_FILE, key)
                            role = k
                            OrionLib:MakeNotification({ Name = "Access Granted", Content = "Welcome, " .. role, Time = 4 })
                            task.wait(2)
                            OrionLib:Destroy()
                            task.wait(1)
                            createUI()
                        end
                    end
                end
            })
        return
    end

    -- Scripts Tab
    Tabs.Scripts:AddButton({ Name = "Universal ESP", Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/qdhub/scripts/main/esp.lua"))()
    end })

    Tabs.Scripts:AddButton({ Name = "Silent Aim", Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/qdhub/scripts/main/silentaim.lua"))()
    end })

    Tabs.Scripts:AddButton({ Name = "Aimlock", Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/qdhub/scripts/main/aimlock.lua"))()
    end })

    Tabs.Scripts:AddButton({ Name = "FPS Boost", Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/qdhub/scripts/main/fpsboost.lua"))()
    end })

    -- Games Tab (auto detects PlaceId)
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
                loadstring(game:HttpGet("https://raw.githubusercontent.com/qdhub/scripts/games/" .. tostring(game.PlaceId) .. ".lua"))()
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
