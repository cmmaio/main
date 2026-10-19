local LOADER_URL = "https://api.luarmor.net/files/v4/loaders/17b518f7ad1d7fd4e7da01e56cae817a.lua"
local SCRIPT_ID = "17b518f7ad1d7fd4e7da01e56cae817a"
local GET_KEY_URL = "https://ads.luarmor.net/get_key?for=Aurum_key-mqYDIUEWozzr"
local KEY_FILE = "Aurum/key.txt"

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local BG = Color3.fromRGB(28, 28, 28)
local PANEL = Color3.fromRGB(36, 36, 36)
local OUTLINE = Color3.fromRGB(55, 55, 55)
local ACCENT = Color3.fromRGB(219, 68, 103)
local TEXT = Color3.fromRGB(255, 255, 255)
local MUTED = Color3.fromRGB(170, 170, 170)
local GOOD = Color3.fromRGB(125, 255, 125)
local BAD = Color3.fromRGB(255, 95, 95)

local api
pcall(function()
    api = loadstring(game:HttpGet("https://sdkapi-public.luarmor.net/library.lua"))()
    api.script_id = SCRIPT_ID
end)

local function readSavedKey()
    local ok, k = pcall(function()
        return isfile and isfile(KEY_FILE) and readfile(KEY_FILE) or nil
    end)
    return ok and k or nil
end

local function saveKey(k)
    pcall(function()
        if makefolder and isfolder and not isfolder("Aurum") then makefolder("Aurum") end
        writefile(KEY_FILE, k)
    end)
end

-- UI

local gui = Instance.new("ScreenGui")
gui.Name = "AurumKey"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() gui.Parent = (gethui and gethui()) or game:GetService("CoreGui") end)
if not gui.Parent then gui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local function corner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 6)
    c.Parent = p
end
local function stroke(p, col)
    local s = Instance.new("UIStroke")
    s.Color = col or OUTLINE
    s.Thickness = 1
    s.Parent = p
end

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(340, 270)
main.Position = UDim2.new(0.5, -170, 0.5, -135)
main.BackgroundColor3 = BG
main.Parent = gui
corner(main, 8)
stroke(main)

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Position = UDim2.fromOffset(16, 12)
title.Size = UDim2.new(1, -60, 0, 24)
title.Font = Enum.Font.GothamBold
title.Text = "Aurum"
title.TextColor3 = ACCENT
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

local sub = Instance.new("TextLabel")
sub.BackgroundTransparency = 1
sub.Position = UDim2.fromOffset(16, 36)
sub.Size = UDim2.new(1, -32, 0, 16)
sub.Font = Enum.Font.Gotham
sub.Text = "Enter your key to continue"
sub.TextColor3 = MUTED
sub.TextSize = 13
sub.TextXAlignment = Enum.TextXAlignment.Left
sub.Parent = main

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(28, 28)
close.Position = UDim2.new(1, -40, 0, 12)
close.BackgroundColor3 = PANEL
close.Font = Enum.Font.GothamBold
close.Text = "X"
close.TextColor3 = MUTED
close.TextSize = 14
close.AutoButtonColor = true
close.Parent = main
corner(close, 6)

local box = Instance.new("TextBox")
box.Size = UDim2.new(1, -32, 0, 38)
box.Position = UDim2.fromOffset(16, 64)
box.BackgroundColor3 = PANEL
box.ClearTextOnFocus = false
box.Font = Enum.Font.Gotham
box.PlaceholderText = "Enter key..."
box.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
box.Text = readSavedKey() or ""
box.TextColor3 = TEXT
box.TextSize = 14
box.TextXAlignment = Enum.TextXAlignment.Left
box.Parent = main
corner(box, 6)
stroke(box)
local pad = Instance.new("UIPadding")
pad.PaddingLeft = UDim.new(0, 10)
pad.PaddingRight = UDim.new(0, 10)
pad.Parent = box

local function button(text, x, w, primary, y)
    local b = Instance.new("TextButton")
    b.Size = UDim2.fromOffset(w, 36)
    b.Position = UDim2.fromOffset(x, y or 114)
    b.BackgroundColor3 = primary and ACCENT or PANEL
    b.Font = Enum.Font.GothamBold
    b.Text = text
    b.TextColor3 = TEXT
    b.TextSize = 14
    b.AutoButtonColor = true
    b.Parent = main
    corner(b, 6)
    if not primary then stroke(b) end
    return b
end
local checkBtn = button("Check Key", 16, 150, true)
local getBtn = button("Get Key (work.ink)", 174, 150, false)
local freeBtn = button("Continue without key (free)", 16, 308, false, 158)

local status = Instance.new("TextLabel")
status.BackgroundTransparency = 1
status.Position = UDim2.fromOffset(16, 204)
status.Size = UDim2.new(1, -32, 0, 52)
status.Font = Enum.Font.Gotham
status.Text = "No key? Continue for free. Premium features need a premium key."
status.TextColor3 = MUTED
status.TextSize = 13
status.TextWrapped = true
status.TextXAlignment = Enum.TextXAlignment.Left
status.TextYAlignment = Enum.TextYAlignment.Top
status.Parent = main

local function setStatus(text, color)
    status.Text = text
    status.TextColor3 = color or MUTED
end

do
    local dragging, start, startPos
    main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging, start, startPos = true, input.Position, main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - start
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
end

-- buttons

close.MouseButton1Click:Connect(function() gui:Destroy() end)

getBtn.MouseButton1Click:Connect(function()
    local copied = pcall(function() setclipboard(GET_KEY_URL) end)
    if copied then
        setStatus("Key link copied! Paste it in your browser to get a key from work.ink.", GOOD)
    else
        setStatus("Open this link in your browser: " .. GET_KEY_URL, TEXT)
    end
end)

local MESSAGES = {
    KEY_HWID_LOCKED = "This key is linked to another device. Reset your HWID on the key page.",
    KEY_INCORRECT = "That key is wrong or doesn't exist.",
    KEY_INVALID = "That key is wrong or doesn't exist.",
    KEY_EXPIRED = "This key has expired. Get a new one with the work.ink button.",
    INVALID_EXECUTOR = "Your executor isn't supported.",
    SECURITY_ERROR = "Security check failed. Try again.",
    TIME_ERROR = "Your device clock is off. Fix it and try again.",
}

local busy = false

local function load(key)
    gui:Destroy()
    getgenv().script_key = key
    script_key = key
    local ok, err = pcall(function()
        loadstring(game:HttpGet(LOADER_URL))()
    end)
    if not ok then warn("[Aurum] Failed to load: " .. tostring(err)) end
end

freeBtn.MouseButton1Click:Connect(function()
    if busy then return end
    busy = true
    setStatus("Loading Aurum (free)...", GOOD)
    task.delay(0.3, load, nil)
end)

checkBtn.MouseButton1Click:Connect(function()
    if busy then return end
    local key = (box.Text or ""):gsub("%s", "")
    if key == "" then
        setStatus("Enter your key first.", BAD)
        return
    end
    busy = true
    setStatus("Checking key...", TEXT)
    task.spawn(function()
        local code = "KEY_VALID"
        if api and api.check_key then
            local ok, res = pcall(api.check_key, key)
            if ok and type(res) == "table" then
                code = tostring(res.code)
            elseif not ok then
                code = "UNKNOWN_ERROR"
            end
        end
        if code ~= "KEY_VALID" then
            setStatus(MESSAGES[code] or ("Couldn't check the key (" .. code .. "). Try again."), BAD)
            busy = false
            return
        end
        saveKey(key)
        setStatus("Key valid! Loading Aurum...", GOOD)
        task.wait(0.5)
        load(key)
    end)
end)

main.BackgroundTransparency = 1
TweenService:Create(main, TweenInfo.new(0.25), { BackgroundTransparency = 0 }):Play()
