--[[
 RACER | event-driven Workspace targeting (low CPU)

 - Choose a single player or toggle up to 6 explicitly selected players.
 - Character resolution supports Workspace GUID-named containers.
 - Alive check uses Humanoid health on the resolved Workspace rig.
 - Target references exist ONLY for explicitly selected players.
 - No server-wide character polling, constant Workspace scans, or idle render loop.
 - Search reuses GUI rows. Trigger checks run while enabled.
 - The target dot uses one projection per frame only while enabled.
 - Wall-check casts at most two rays per targeting tick, and only when enabled.
 - Silent aim redirects only this game's GunManager raycast while enabled.

 Limitations: server validation, cover, range and weapon spread can still reject hits.
 Targeting cannot change server-owned character state. Rejoin may be needed
 to dispose of hooks from older script versions.
]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Me = Players.LocalPlayer
if not Me then return end
local PlayerGui = Me:WaitForChild("PlayerGui", 10)
if not PlayerGui then return end

local Env = _G
if type(getgenv) == "function" then
    local ok, result = pcall(getgenv)
    if ok and type(result) == "table" then Env = result end
end

-- This place moves players between servers. Restore protection in the next
-- client as soon as Real makes the local file available after a teleport.
if type(queue_on_teleport) == "function" then
    pcall(function()
        queue_on_teleport([=[
            task.wait(2)
            local scriptFile = loadfile([[C:\Users\Hayden\AppData\Local\Real\scripts\MCP\Racer.luau]])
            if scriptFile then scriptFile() end
        ]=])
    end)
end

-- Stop older versions before installing this one.
for _, name in ipairs({
    "SpectraSelectCleanup", "DAH_LiteCleanup", "DAH_PolishedCleanup",
    "DAH_OptimizedCleanup", "DAH_AllInOne_Cleanup", "DAH_AimGuiCleanup"
}) do
    if type(Env[name]) == "function" then pcall(Env[name]) end
end
for _, name in ipairs({
    "DAH_AllInOneHook", "DAH_RaycastAimHook", "DAH_OptimizedHook",
    "DAH_LowCostHook", "__DAH_LITE_RAYCAST", "__SPECTRA_SELECT_RAYCAST"
}) do
    local old = Env[name]
    if type(old) == "table" then
        old.active = false
        old.enabled = false
        old.part = nil
        old.point = nil
        old.aimPoint = nil
        old.mouseCompat = false
    end
end
for _, name in ipairs({"RACER_UI", "SPECTRA_SELECT_LITE", "DAH_StudioLite", "DAH_RebuiltLite", "DAH_OptimizedAllInOne", "DAH_AllInOne", "DAHAimGui"}) do
    local old = PlayerGui:FindFirstChild(name)
    if old then old:Destroy() end
end

local MAX_TARGETS = 6
local S = {
    closed = false,
    multi = false,
    aliveOnly = true,     -- Humanoid health on the Workspace rig
    primary = nil,        -- last clicked / Bring target
    aimPlayer = nil,
    aimRecord = nil,
    silent = false,
    wallBang = false,
    forceHit = false,
    trigger = false,
    cameraAim = false,
    dot = false,
    wall = false,
    head = true,
    lead = 0.035,
    screenDistance2 = math.huge,
    permitted = false,
    bring = nil,
    autoArmor = true,
    armorGeneration = 0,
    autoBuys = {},
    autoBuyIndex = 1,
    antiStomp = true,
    autoStomp = true,
    selectedStomp = false,
    selectedStompTarget = nil,
    selectedStompGeneration = 0,
    selectedStompAnchors = nil,
    selectedStompModel = nil,
    selectedStompFollowConnection = nil,
    stompAnimationEnabled = true,
    standEnabled = false,
    standOwner = nil,
    standAttackTarget = nil,
    standDownOnlyTarget = nil,
    standFollow = false,
    standFollowGeneration = 0,
    standOrderGeneration = 0,
    standFlingGeneration = 0,
    standFlinging = false,
    standFlingRestore = nil,
    standCinematicRestore = nil,
    standAttack2Target = nil,
    standAttack3Target = nil,
    standAttack2FinisherPlayed = false,
    standAttack2LaunchQueued = false,
    standLastCommand = nil,
    standLastCommandAt = 0,
    bringStompRestore = nil,
    bringStompGeneration = 0,
    stompPace = 0.04,
    autoKill = false,
    lastConfirmedHitAt = 0,
    lastAdaptiveSwitchAt = 0,
    killBringDestination = nil,
    quietAutoKill = false,
    respawnAtDeath = false,
    autoKillVoid = true,
    antiVoid = true,
    voidBlinking = false,
    voidDepth = -120,
    voidDwell = 0.02,
    strafeRadius = 7.5,
    uiScale = 1,
    rapidWeapons = {},
    adaptiveRapid = true,
    lastAttemptWeaponName = nil,
    noRecoil = false,
    invisibleShot = false,
    noSpread = false,
    infiniteSmg = false,
    autoReloadAll = false,
    esp = {enabled = false, boxes = true, skeleton = false,
        names = true, distance = true, rangeIndex = 4, colorIndex = 1},
    themeIndex = 1,
    autoKillGeneration = 0,
    resetThresholdIndex = 5,
    resetCharacter = nil,
    resetInFlight = false,
    antiStompReady = false,
    lastResetAt = 0,
    cursorKeyEnabled = true,
    macroLock = false,
}
local Connections = {}
local ExtraUI = {}
local DeathPosition = nil
local PlayerConnections = {} -- ONLY selected players get character listeners
local RowConnections = {}
local Rows = {}
local TargetSet, TargetList, Records = {}, {}, {}
local TargetByModelName = {} -- selected name / id -> Player
local Folders = {} -- Workspace GUID folder ChildAdded connections, NOT character cache
local ResolutionTokens = {} -- only selected players have an active token
local NextResolutionToken = 0
local TickGeneration = 0
local RenderConnection = nil
local OwnRoot = nil
local TriggerPressed = false
local ArmorShops = {}
local ShopNames = {
    "[Chicken]", "[Cookie]", "[Donut]", "[Hamburger]", "[Lemonade]",
    "[Matcha]", "[Pizza]", "[Popcorn]", "[SMG]", "[Shotgun]",
    "[Surgeon Mask]", "[Taco]", "[TacticalShotgun]",
}
local ResetThresholds = {10, 20, 30, 40, 50}
local MinStompPaceExponent = 282
local OwnCharacterConnections = {}
local AutoStompGeneration = 0
local NextAutoStompAt = 0
local AutoStompTrackCharacter = nil
local AutoStompTrack = nil
local updateLoops -- defined below; selection changes can stop/start it immediately
local targetTick -- Q picker uses this after selecting a record

local C_BG = Color3.fromRGB(22, 22, 22)
local C_PANEL = Color3.fromRGB(32, 32, 32)
local C_OFF = Color3.fromRGB(46, 46, 46)
local C_ON = Color3.fromRGB(38, 78, 141)
local C_SELECTED = Color3.fromRGB(48, 66, 92)
local C_TEXT = Color3.fromRGB(246, 246, 246)
local C_FAINT = Color3.fromRGB(169, 169, 169)
local C_ACCENT = Color3.fromRGB(78, 142, 255)
local C_NAV = Color3.fromRGB(15, 15, 15)
local C_NAV_OFF = Color3.fromRGB(34, 34, 34)
local C_NAV_HOVER = Color3.fromRGB(56, 56, 56)
local C_NAV_SELECTED = Color3.fromRGB(38, 78, 141)
local C_BORDER = Color3.fromRGB(75, 75, 75)
local function bind(connection)
    Connections[#Connections + 1] = connection
    return connection
end
local function disconnectMany(connections)
    for _, connection in ipairs(connections) do connection:Disconnect() end
    table.clear(connections)
end
local function make(className, props)
    local instance = Instance.new(className)
    for property, value in pairs(props) do instance[property] = value end
    return instance
end
local function round(obj, radius)
    -- Deliberately square: the panel uses a strict grid and flat controls.
    return obj
end
local function label(parent, title, y, height, color, size)
    return make("TextLabel", {
        Parent = parent, Position = UDim2.fromOffset(11, y), Size = UDim2.new(1, -22, 0, height),
        BackgroundTransparency = 1, Text = title, TextColor3 = color or C_TEXT,
        TextSize = size or 12, Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
    })
end
local function button(parent, title, x, y, w, h)
    local result = round(make("TextButton", {
        Parent = parent, Position = UDim2.fromOffset(x, y), Size = UDim2.fromOffset(w, h),
        BackgroundColor3 = C_OFF, BorderSizePixel = 0, AutoButtonColor = false,
        Text = title, TextColor3 = C_TEXT, Font = Enum.Font.GothamBold, TextSize = 11,
    }), 0)
    make("UIStroke", {Parent = result, Color = C_BORDER, Thickness = 1, Transparency = 0.12})
    bind(result.MouseEnter:Connect(function()
        if S.closed then return end
        game:GetService("TweenService"):Create(result,
            TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = result:GetAttribute("SpectraTab")
                and C_NAV_HOVER or result:GetAttribute("SpectraHeader")
                and C_NAV_HOVER or C_SELECTED}):Play()
    end))
    bind(result.MouseLeave:Connect(function()
        if S.closed then return end
        game:GetService("TweenService"):Create(result,
            TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = result:GetAttribute("SpectraTab")
                and (result:GetAttribute("SpectraOn") and C_NAV_SELECTED or C_NAV_OFF)
                or result:GetAttribute("SpectraHeader") and C_NAV_OFF
                or result:GetAttribute("SpectraOn") and C_ON or C_OFF}):Play()
    end))
    return result
end
local function style(btn, value, on, off)
    btn.Text = value and on or off
    btn:SetAttribute("SpectraOn", value)
    btn.BackgroundColor3 = value and C_ON or C_OFF
    local stroke = btn:FindFirstChildOfClass("UIStroke")
    if stroke then stroke.Color = value and C_ACCENT or C_BORDER end
end

-- Custom tabbed control surface with event-driven transitions.
local Gui = make("ScreenGui", {
    Name = "RACER_UI", Parent = PlayerGui, ResetOnSpawn = false,
    DisplayOrder = 2200, IgnoreGuiInset = true,
})
local Main = round(make("Frame", {
    Parent = Gui, Position = UDim2.fromOffset(24, 80), Size = UDim2.fromOffset(520, 625),
    BackgroundColor3 = C_BG, BorderSizePixel = 0, Active = true,
}), 0)
make("UIStroke", {Parent = Main, Color = C_BORDER,
    Thickness = 1, Transparency = 0})
local MainScale = make("UIScale", {Parent = Main, Scale = S.uiScale})
make("Frame", {Parent = Main, Position = UDim2.fromOffset(0, 0),
    Size = UDim2.fromOffset(520, 64), BackgroundColor3 = C_NAV,
    BorderSizePixel = 0})
make("Frame", {Parent = Main, Position = UDim2.fromOffset(0, 42),
    Size = UDim2.fromOffset(520, 22), BackgroundColor3 = C_NAV, BorderSizePixel = 0})
make("Frame", {Parent = Main, Position = UDim2.fromOffset(0, 0),
    Size = UDim2.fromOffset(5, 64), BackgroundColor3 = C_ACCENT, BorderSizePixel = 0})
make("Frame", {Parent = Main, Position = UDim2.fromOffset(0, 64),
    Size = UDim2.fromOffset(520, 1), BackgroundColor3 = C_BORDER, BorderSizePixel = 0})
local Heading = label(Main, "RACER", 8, 31, C_TEXT, 24)
Heading.Font = Enum.Font.GothamBold
Heading.Position = UDim2.fromOffset(19, 7)
Heading.Size = UDim2.fromOffset(245, 32)
local Subtitle = label(Main, "TARGETING  /  COMBAT  /  UTILITIES", 39, 16,
    C_FAINT, 10)
Subtitle.Position = UDim2.fromOffset(20, 39)
make("Frame", {Parent = Main, Position = UDim2.fromOffset(366, 24),
    Size = UDim2.fromOffset(6, 6), BackgroundColor3 = Color3.fromRGB(74, 180, 129),
    BorderSizePixel = 0})
local LiveLabel = label(Main, "LIVE", 19, 20, C_FAINT, 10)
LiveLabel.Position = UDim2.fromOffset(379, 18)
LiveLabel.Size = UDim2.fromOffset(42, 20)
LiveLabel.Font = Enum.Font.GothamBold
local Minimise = button(Main, "-", 443, 14, 29, 27)
local Close = button(Main, "X", 478, 14, 29, 27)
for _, control in ipairs({Minimise, Close}) do
    control:SetAttribute("SpectraHeader", true)
    control.BackgroundColor3 = C_NAV_OFF
    control.TextColor3 = C_TEXT
    control:FindFirstChildOfClass("UIStroke").Transparency = 1
end
local Search = round(make("TextBox", {
    Parent = Main, Position = UDim2.fromOffset(11, 50), Size = UDim2.fromOffset(318, 34),
    Text = "", PlaceholderText = "  Search player name...", ClearTextOnFocus = false,
    BackgroundColor3 = C_OFF, BorderSizePixel = 0, TextColor3 = C_TEXT,
    PlaceholderColor3 = C_FAINT, TextSize = 12, Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left,
}), 7)
local List = round(make("ScrollingFrame", {
    Parent = Main, Position = UDim2.fromOffset(11, 92), Size = UDim2.fromOffset(318, 136),
    BackgroundColor3 = C_PANEL, BorderSizePixel = 0, ScrollBarThickness = 3,
    CanvasSize = UDim2.fromOffset(0, 0), ScrollingDirection = Enum.ScrollingDirection.Y,
}), 7)
make("UIPadding", {Parent = List, PaddingTop = UDim.new(0, 4), PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 5)})
local Layout = make("UIListLayout", {
    Parent = List, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 3),
})
bind(Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    List.CanvasSize = UDim2.fromOffset(0, Layout.AbsoluteContentSize.Y + 8)
end))
local SelectedLabel = label(Main, "Targets: 0/6", 231, 20, C_ACCENT, 11)
local ActiveLabel = label(Main, "Aim target: none", 250, 20, C_FAINT, 11)
local MultiBtn = button(Main, "MULTI TARGET: OFF", 11, 274, 153, 34)
local AliveBtn = button(Main, "ALIVE CHECK: ON", 175, 274, 154, 34)
local Silent = button(Main, "SILENT AIM: OFF", 11, 315, 153, 34)
local Trigger = button(Main, "TRIGGER: OFF", 175, 315, 154, 34)
local CameraBtn = button(Main, "CAMERA AIM: OFF", 11, 355, 153, 34)
local DotBtn = button(Main, "BOX + LINE: OFF", 175, 355, 154, 34)
local Hitbox = button(Main, "HITBOX: HEAD", 11, 395, 153, 34)
local Wall = button(Main, "WALL CHECK: OFF", 175, 395, 154, 34)
local LeadText = label(Main, "PREDICTION: 35 ms", 478, 22, C_FAINT, 11)
local Minus = button(Main, "-", 256, 475, 33, 28)
local Plus = button(Main, "+", 296, 475, 33, 28)
local Refresh = button(Main, "REFRESH TARGETS", 11, 515, 153, 33)
local Bring = button(Main, "BRING SELECTED", 175, 515, 154, 33)
local AutoArmor = button(Main, "AUTO ARMOR ON RESPAWN: OFF", 11, 555, 318, 33)
local Status = label(Main, "Idle: no targeting loop active.", 564, 44, C_FAINT, 11)
Status.TextWrapped = true
Status.TextTruncate = Enum.TextTruncate.None
Status.TextYAlignment = Enum.TextYAlignment.Top

local Sidebar = round(make("Frame", {Parent = Main,
    Position = UDim2.fromOffset(11, 91), Size = UDim2.fromOffset(111, 449),
    BackgroundColor3 = C_NAV, BorderSizePixel = 0}), 13)
make("UIStroke", {Parent = Sidebar, Color = Color3.fromRGB(94, 102, 99),
    Thickness = 1, Transparency = 0.65})
local ModulesLabel = label(Sidebar, "WORKSPACE", 13, 20,
    C_ACCENT, 10)
ModulesLabel.Position = UDim2.fromOffset(13, 13)
local TargetTab = button(Sidebar, "  TARGETS", 8, 44, 95, 38)
local AimTab = button(Sidebar, "  AIM", 8, 88, 95, 38)
local ToolsTab = button(Sidebar, "  TOOLS", 8, 132, 95, 38)
local SettingsTab = button(Sidebar, "  SETTINGS", 8, 176, 95, 38)
ExtraUI.GunsTab = button(Sidebar, "  GUNS", 8, 220, 95, 38)
ExtraUI.EspTab = button(Sidebar, "  ESP", 8, 264, 95, 38)
ExtraUI.TeleportTab = button(Sidebar, "  TELEPORT", 8, 308, 95, 38)
ExtraUI.StandTab = button(Sidebar, "  STAND", 8, 352, 95, 38)
ExtraUI.ConfigTab = button(Sidebar, "  CONFIGS", 8, 396, 95, 38)
for _, tab in ipairs({TargetTab, AimTab, ToolsTab, SettingsTab,
    ExtraUI.GunsTab, ExtraUI.EspTab, ExtraUI.TeleportTab,
    ExtraUI.StandTab, ExtraUI.ConfigTab}) do
    tab.TextXAlignment = Enum.TextXAlignment.Left
    tab.TextColor3 = C_TEXT
    tab.BackgroundColor3 = C_NAV_OFF
    tab:FindFirstChildOfClass("UIStroke").Transparency = 1
end
local StatusBar = round(make("Frame", {Parent = Main,
    Position = UDim2.fromOffset(132, 550), Size = UDim2.fromOffset(376, 55),
    BackgroundColor3 = C_NAV, BorderSizePixel = 0}), 12)
make("UIStroke", {Parent = StatusBar, Color = C_NAV_HOVER,
    Thickness = 1, Transparency = 0.35})
round(make("Frame", {Parent = StatusBar, Position = UDim2.fromOffset(13, 20),
    Size = UDim2.fromOffset(8, 8), BackgroundColor3 = C_ACCENT,
    BorderSizePixel = 0}), 4)
Status.Parent = StatusBar
Status.Position = UDim2.fromOffset(30, 8)
Status.Size = UDim2.fromOffset(333, 41)
Status.TextColor3 = Color3.fromRGB(226, 229, 224)
local function page()
    local frame = round(make("Frame", {
        Parent = Main, Position = UDim2.fromOffset(132, 91),
        Size = UDim2.fromOffset(376, 449), BackgroundColor3 = C_PANEL,
        BorderSizePixel = 0, Visible = false,
    }), 14)
    make("UIStroke", {Parent = frame, Color = C_BORDER, Thickness = 1, Transparency = 0.08})
    make("Frame", {Parent = frame, Position = UDim2.fromOffset(0, 0),
        Size = UDim2.fromOffset(376, 3), BackgroundColor3 = C_ACCENT,
        BorderSizePixel = 0})
    return frame
end
local TargetsPage, AimPage, ToolsPage, SettingsPage =
    page(), page(), page(), page()
ExtraUI.GunsPage = page()
ExtraUI.EspPage = page()
ExtraUI.TeleportPage = page()
ExtraUI.StandPage = page()
ExtraUI.ConfigPage = page()
local function place(control, parent, x, y, width, height)
    control.Parent = parent
    control.Position = UDim2.fromOffset(x, y)
    control.Size = UDim2.fromOffset(width, height)
end
place(Search, TargetsPage, 12, 16, 342, 34)
place(List, TargetsPage, 12, 59, 342, 188)
place(SelectedLabel, TargetsPage, 12, 255, 342, 19)
place(ActiveLabel, TargetsPage, 12, 276, 342, 19)
place(MultiBtn, TargetsPage, 12, 307, 166, 34)
place(AliveBtn, TargetsPage, 188, 307, 166, 34)
local CursorToggle = button(TargetsPage, "CURSOR PICK: ON", 12, 350, 166, 34)
local CursorPick = button(TargetsPage, "PICK NEAR CURSOR", 188, 350, 166, 34)
label(TargetsPage, "Q selects or removes a player within 100px.", 428, 18, C_FAINT, 11)
place(Refresh, TargetsPage, 12, 393, 342, 34)

place(Silent, AimPage, 12, 21, 166, 36)
place(Trigger, AimPage, 188, 21, 166, 36)
place(CameraBtn, AimPage, 12, 67, 166, 36)
place(DotBtn, AimPage, 188, 67, 166, 36)
place(Hitbox, AimPage, 12, 113, 166, 36)
place(Wall, AimPage, 188, 113, 166, 36)
label(AimPage, "Infinite aim range  /  Trigger fires while over a target.",
    168, 20, C_FAINT, 11)
place(LeadText, AimPage, 13, 212, 225, 24)
place(Minus, AimPage, 276, 209, 35, 29)
place(Plus, AimPage, 319, 209, 35, 29)
local WallBangBtn = button(AimPage, "WALLBANG: OFF", 12, 247, 342, 36)
label(AimPage, "Routes selected-target shots through map cover.", 289, 342, C_FAINT, 11)
local AutoKillBtn = button(AimPage, "AUTO KILL SELECTED: OFF", 12, 319, 342, 38)
ExtraUI.QuietKillBtn = button(AimPage, "QUIET AUTO KILL: OFF", 12, 363, 342, 30)
local ForceHitBtn = button(AimPage, "FORCE HIT: OFF", 12, 398, 342, 36)

place(AutoArmor, ToolsPage, 12, 18, 342, 38)
place(Bring, ToolsPage, 12, 64, 342, 36)
local AntiStompBtn = button(ToolsPage, "ANTI STOMP: OFF", 12, 108, 342, 36)
local ResetThresholdBtn = button(ToolsPage, "RESET AT: 50 HP", 12, 152, 342, 32)
local AutoStompBtn = button(ToolsPage, "AUTO STOMP: OFF", 12, 192, 166, 36)
local SelectedStompBtn = button(ToolsPage, "SELECTED STOMP: OFF", 188, 192, 166, 36)
ExtraUI.StompAnimationBtn = button(ToolsPage, "STOMP ANIMATION: ON", 12, 236, 342, 30)
label(ToolsPage, "AUTO BUY ON RESPAWN", 280, 22, C_ACCENT, 12)
local AutoBuyPrev = button(ToolsPage, "<", 12, 302, 38, 30)
local AutoBuyName = label(ToolsPage, "", 302, 30, C_TEXT, 12)
place(AutoBuyName, ToolsPage, 57, 302, 252, 30)
AutoBuyName.TextXAlignment = Enum.TextXAlignment.Center
local AutoBuyNext = button(ToolsPage, ">", 316, 302, 38, 30)
local AutoBuyToggle = button(ToolsPage, "AUTO BUY: OFF", 12, 340, 342, 30)
local AutoBuyNow = button(ToolsPage, "BUY SELECTED NOW", 12, 378, 342, 30)
local AutoBuyCount = label(ToolsPage, "0 items selected. Shops use ClickDetectors.", 414, 36, C_FAINT, 10)

label(ExtraUI.GunsPage, "RAPID FIRE  /  PER WEAPON", 16, 22, C_ACCENT, 12)
label(ExtraUI.GunsPage, "Hold fire. Shotgun damage cadence is server controlled.",
    43, 22, C_FAINT, 10)
ExtraUI.ServerHit = label(ExtraUI.GunsPage, "SERVER HIT: waiting for a shot", 57, 18, C_FAINT, 10)
ExtraUI.GunList = round(make("ScrollingFrame", {
    Parent = ExtraUI.GunsPage, Position = UDim2.fromOffset(12, 80),
    Size = UDim2.fromOffset(342, 345), BackgroundColor3 = C_BG,
    BorderSizePixel = 0, ScrollBarThickness = 7,
    ScrollBarImageColor3 = C_ACCENT, ScrollingEnabled = true,
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    CanvasSize = UDim2.fromOffset(0, 0),
    ScrollingDirection = Enum.ScrollingDirection.Y,
}), 8)
ExtraUI.GunList.ScrollingDirection = Enum.ScrollingDirection.Y
ExtraUI.GunLayout = make("UIListLayout", {
    Parent = ExtraUI.GunList, SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 6),
})
make("UIPadding", {Parent = ExtraUI.GunList,
    PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 10),
    PaddingLeft = UDim.new(0, 3), PaddingRight = UDim.new(0, 8)})
label(ExtraUI.EspPage, "PLAYER OVERLAY  /  ALL PLAYERS", 16, 22, C_ACCENT, 12)
label(ExtraUI.EspPage, "Screen overlay with optional R15/R6 joints.", 43, 22, C_FAINT, 10)
ExtraUI.EspMain = button(ExtraUI.EspPage, "ESP: OFF", 12, 76, 342, 38)
ExtraUI.EspBoxes = button(ExtraUI.EspPage, "BOXES: ON", 12, 125, 166, 36)
ExtraUI.EspSkeleton = button(ExtraUI.EspPage, "SKELETON: OFF", 188, 125, 166, 36)
ExtraUI.EspNames = button(ExtraUI.EspPage, "NAMES: ON", 12, 171, 166, 36)
ExtraUI.EspDistance = button(ExtraUI.EspPage, "DISTANCE: ON", 188, 171, 166, 36)
ExtraUI.EspRange = button(ExtraUI.EspPage, "RANGE: ALL", 12, 217, 342, 36)
ExtraUI.EspColor = button(ExtraUI.EspPage, "COLOR: CYAN", 12, 263, 342, 36)
label(ExtraUI.TeleportPage, "LOCATION TELEPORTS", 16, 22, C_ACCENT, 12)
label(ExtraUI.TeleportPage, "Choose a mapped area or a live shop.", 43, 22, C_FAINT, 10)
ExtraUI.TeleportButtons = {
    uphill = button(ExtraUI.TeleportPage, "UPHILL", 12, 80, 166, 37),
    downhill = button(ExtraUI.TeleportPage, "DOWNHILL", 188, 80, 166, 37),
    armor = button(ExtraUI.TeleportPage, "NEAREST ARMOR", 12, 128, 342, 37),
    smg = button(ExtraUI.TeleportPage, "NEAREST SMG SHOP", 12, 176, 342, 37),
    returnTo = button(ExtraUI.TeleportPage, "RETURN TO PREVIOUS POSITION", 12, 224, 342, 37),
}
label(ExtraUI.StandPage, "STAND  /  CHAT CONTROL", 16, 25, C_ACCENT, 12)
ExtraUI.StandOwnerLabel = label(ExtraUI.StandPage, "Owner: none", 48, 30, C_TEXT, 12)
ExtraUI.StandOwnerInput = make("TextBox", {
    Parent = ExtraUI.StandPage, Position = UDim2.fromOffset(12, 86),
    Size = UDim2.fromOffset(342, 34), BackgroundColor3 = C_OFF,
    TextColor3 = C_TEXT, PlaceholderColor3 = C_FAINT,
    PlaceholderText = "Owner username or display name", Text = "",
    ClearTextOnFocus = false, Font = Enum.Font.Gotham,
    TextSize = 12, BorderSizePixel = 0,
})
round(ExtraUI.StandOwnerInput, 7)
ExtraUI.StandSetOwner = button(ExtraUI.StandPage, "SET OWNER FROM NAME", 12, 130, 166, 34)
ExtraUI.StandSetSelected = button(ExtraUI.StandPage, "USE SELECTED PLAYER", 188, 130, 166, 34)
ExtraUI.StandToggle = button(ExtraUI.StandPage, "LISTEN: OFF", 12, 175, 342, 38)
ExtraUI.StandStop = button(ExtraUI.StandPage, "STOP CURRENT ORDER", 12, 222, 342, 34)
label(ExtraUI.StandPage, "OWNER CHAT COMMANDS", 268, 25, C_ACCENT, 11)
label(ExtraUI.StandPage, "!attack / !attack2 / !attack3 <name>", 292, 24, C_TEXT, 11)
label(ExtraUI.StandPage, "!bring / !fling <name>", 318, 24, C_TEXT, 11)
label(ExtraUI.StandPage, "!come / !follow / !stay / !stop", 344, 24, C_TEXT, 11)
label(ExtraUI.StandPage, "!jump / !sit / !stand / !spin / !status", 370, 24, C_TEXT, 11)
ExtraUI.StandStatus = label(ExtraUI.StandPage, "Standing by.", 405, 30, C_FAINT, 11)

label(ExtraUI.ConfigPage, "PROFILES  /  LOCAL SETTINGS", 20, 24, C_ACCENT, 12)
label(ExtraUI.ConfigPage, "Choose a slot, then save or load your preferences.",
    49, 22, C_FAINT, 10)
ExtraUI.ConfigSlots = {
    button(ExtraUI.ConfigPage, "SLOT 1", 12, 88, 106, 38),
    button(ExtraUI.ConfigPage, "SLOT 2", 130, 88, 106, 38),
    button(ExtraUI.ConfigPage, "SLOT 3", 248, 88, 106, 38),
}
ExtraUI.ConfigSave = button(ExtraUI.ConfigPage, "SAVE SELECTED SLOT", 12, 145, 342, 42)
ExtraUI.ConfigLoad = button(ExtraUI.ConfigPage, "LOAD SELECTED SLOT", 12, 198, 342, 42)
ExtraUI.ConfigStatus = label(ExtraUI.ConfigPage, "Slot 1 selected.", 263, 48, C_FAINT, 11)
ExtraUI.ConfigStatus.TextWrapped = true
ExtraUI.MacroBtn = button(ExtraUI.ConfigPage, "MACRO PERSIST: OFF", 12, 313, 342, 39)
label(ExtraUI.ConfigPage, "Keep the game's macro active through normal actions.",
    365, 27, C_FAINT, 10)
label(ExtraUI.ConfigPage, "Profiles load only when you press LOAD.",
    402, 24, C_FAINT, 10)

label(SettingsPage, "MOVEMENT & PERSONALISATION", 12, 20, C_ACCENT, 12)
local AntiVoidBtn = button(SettingsPage, "ANTI VOID: ON", 12, 39, 342, 34)
local VoidKillBtn = button(SettingsPage, "AUTO KILL VOID BLINK: ON", 12, 81, 342, 34)

local function slider(parent, title, y, initial, convert, onChange, format)
    local caption = label(parent, title, y, 20, C_TEXT, 11)
    local track = round(make("Frame", {Parent = parent, Active = true,
        Position = UDim2.fromOffset(12, y + 27), Size = UDim2.fromOffset(342, 9),
        BackgroundColor3 = C_OFF, BorderSizePixel = 0}), 5)
    local fill = round(make("Frame", {Parent = track, Size = UDim2.fromScale(0, 1),
        BackgroundColor3 = C_ACCENT, BorderSizePixel = 0}), 5)
    local knob = round(make("Frame", {Parent = track, Active = true,
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0, 0.5),
        Size = UDim2.fromOffset(16, 16), BackgroundColor3 = C_ACCENT,
        BorderSizePixel = 0}), 8)
    make("UIStroke", {Parent = knob, Color = C_BG, Thickness = 2})
    local dragging = false
    local function setFraction(fraction)
        fraction = math.clamp(fraction, 0, 1)
        fill.Size = UDim2.fromScale(fraction, 1)
        knob.Position = UDim2.fromScale(fraction, 0.5)
        local value = convert(fraction)
        onChange(value)
        caption.Text = title .. "  " .. format(value)
    end
    local function fromInput(input)
        local width = math.max(1, track.AbsoluteSize.X)
        setFraction((input.Position.X - track.AbsolutePosition.X) / width)
    end
    for _, item in ipairs({track, knob}) do
        bind(item.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                fromInput(input)
            end
        end))
    end
    bind(UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then fromInput(input) end
    end))
    bind(UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end))
    setFraction(initial)
    return setFraction
end

local setStompPace = slider(SettingsPage, "AUTO STOMP PACE", 124,
    (math.log10(S.stompPace) + MinStompPaceExponent) / MinStompPaceExponent,
    function(f) return 10 ^ (-MinStompPaceExponent + MinStompPaceExponent * f) end,
    function(value) S.stompPace = value end,
    function(value) return string.format("%.3g×", value) end)
local PaceMax = button(SettingsPage, "MAX", 12, 174, 106, 28)
local PaceFast = button(SettingsPage, "FAST", 130, 174, 106, 28)
local PaceNormal = button(SettingsPage, "NORMAL", 248, 174, 106, 28)
bind(PaceMax.MouseButton1Click:Connect(function() setStompPace(0) end))
bind(PaceFast.MouseButton1Click:Connect(function()
    setStompPace((math.log10(0.05) + MinStompPaceExponent) / MinStompPaceExponent)
end))
bind(PaceNormal.MouseButton1Click:Connect(function() setStompPace(1) end))
label(SettingsPage, "Minimum 1e-282×; game frames limit actual calls.", 206, 17, C_FAINT, 10)
ExtraUI.setStrafeRadius = slider(SettingsPage, "STRAFE RADIUS", 230, (S.strafeRadius - 4) / 10,
    function(f) return 4 + f * 10 end,
    function(value) S.strafeRadius = value end,
    function(value) return string.format("%.1f studs", value) end)
ExtraUI.setVoidDepth = slider(SettingsPage, "VOID DEPTH", 289, (-S.voidDepth - 60) / 240,
    function(f) return -(60 + f * 240) end,
    function(value) S.voidDepth = value end,
    function(value) return string.format("%.0f Y", value) end)
ExtraUI.setUiScale = slider(SettingsPage, "INTERFACE SCALE", 349, (S.uiScale - 0.7) / 0.5,
    function(f) return 0.7 + f * 0.5 end,
    function(value) S.uiScale = value; MainScale.Scale = value end,
    function(value) return string.format("%.2f×", value) end)
local ThemeNames = {"BLUE", "VIOLET", "GREEN", "AMBER"}
local ThemeColors = {
    Color3.fromRGB(78, 142, 255), Color3.fromRGB(165, 106, 236),
    Color3.fromRGB(74, 180, 129), Color3.fromRGB(230, 159, 64),
}
local ThemeBtn = button(SettingsPage, "ACCENT: BLUE", 12, 407, 166, 30)
ExtraUI.RespawnDeathBtn = button(SettingsPage, "RESPAWN AT DEATH: OFF", 188, 407, 166, 30)
local function applyTheme(index)
    local old = C_ACCENT
    local oldNav = C_NAV_SELECTED
    C_ACCENT = ThemeColors[index]
    C_NAV_SELECTED = C_ACCENT:Lerp(C_NAV, 0.18)
    for _, item in ipairs(Gui:GetDescendants()) do
        if item:IsA("UIStroke") and item.Color == old then item.Color = C_ACCENT end
        if item:IsA("TextLabel") and item.TextColor3 == old then item.TextColor3 = C_ACCENT end
        if item:IsA("Frame") and item.BackgroundColor3 == old then
            item.BackgroundColor3 = C_ACCENT
        end
        if item:IsA("TextButton") and item.BackgroundColor3 == oldNav then
            item.BackgroundColor3 = C_NAV_SELECTED
        end
    end
    ThemeBtn.Text = "ACCENT: " .. ThemeNames[index]
end
bind(ThemeBtn.MouseButton1Click:Connect(function()
    S.themeIndex = S.themeIndex % #ThemeNames + 1
    applyTheme(S.themeIndex)
end))
bind(ExtraUI.RespawnDeathBtn.MouseButton1Click:Connect(function()
    S.respawnAtDeath = not S.respawnAtDeath
    if not S.respawnAtDeath then DeathPosition = nil end
    style(ExtraUI.RespawnDeathBtn, S.respawnAtDeath,
        "RESPAWN AT DEATH: ON", "RESPAWN AT DEATH: OFF")
end))
bind(AntiVoidBtn.MouseButton1Click:Connect(function()
    S.antiVoid = not S.antiVoid
    style(AntiVoidBtn, S.antiVoid, "ANTI VOID: ON", "ANTI VOID: OFF")
end))
bind(VoidKillBtn.MouseButton1Click:Connect(function()
    S.autoKillVoid = not S.autoKillVoid
    style(VoidKillBtn, S.autoKillVoid,
        "AUTO KILL VOID BLINK: ON", "AUTO KILL VOID BLINK: OFF")
end))
style(AntiVoidBtn, S.antiVoid, "ANTI VOID: ON", "ANTI VOID: OFF")
style(VoidKillBtn, S.autoKillVoid,
    "AUTO KILL VOID BLINK: ON", "AUTO KILL VOID BLINK: OFF")

local CurrentTab = "targets"
local function showTab(which)
    CurrentTab = which
    TargetsPage.Visible = which == "targets"
    AimPage.Visible = which == "aim"
    ToolsPage.Visible = which == "tools"
    SettingsPage.Visible = which == "settings"
    ExtraUI.GunsPage.Visible = which == "guns"
    ExtraUI.EspPage.Visible = which == "esp"
    ExtraUI.TeleportPage.Visible = which == "teleport"
    ExtraUI.StandPage.Visible = which == "stand"
    ExtraUI.ConfigPage.Visible = which == "configs"
    TargetTab.BackgroundColor3 = TargetsPage.Visible and C_NAV_SELECTED or C_NAV_OFF
    AimTab.BackgroundColor3 = AimPage.Visible and C_NAV_SELECTED or C_NAV_OFF
    ToolsTab.BackgroundColor3 = ToolsPage.Visible and C_NAV_SELECTED or C_NAV_OFF
    SettingsTab.BackgroundColor3 = SettingsPage.Visible and C_NAV_SELECTED or C_NAV_OFF
    ExtraUI.GunsTab.BackgroundColor3 = ExtraUI.GunsPage.Visible and C_NAV_SELECTED or C_NAV_OFF
    ExtraUI.EspTab.BackgroundColor3 = ExtraUI.EspPage.Visible and C_NAV_SELECTED or C_NAV_OFF
    ExtraUI.TeleportTab.BackgroundColor3 = ExtraUI.TeleportPage.Visible and C_NAV_SELECTED or C_NAV_OFF
    ExtraUI.StandTab.BackgroundColor3 = ExtraUI.StandPage.Visible and C_NAV_SELECTED or C_NAV_OFF
    ExtraUI.ConfigTab.BackgroundColor3 = ExtraUI.ConfigPage.Visible and C_NAV_SELECTED or C_NAV_OFF
    for _, tab in ipairs({TargetTab, AimTab, ToolsTab, SettingsTab,
        ExtraUI.GunsTab, ExtraUI.EspTab, ExtraUI.TeleportTab,
        ExtraUI.StandTab, ExtraUI.ConfigTab}) do
        tab:SetAttribute("SpectraTab", true)
        tab:SetAttribute("SpectraOn", tab.BackgroundColor3 == C_NAV_SELECTED)
    end
    local activePage = which == "targets" and TargetsPage
        or which == "aim" and AimPage
        or which == "tools" and ToolsPage
        or which == "settings" and SettingsPage
        or which == "guns" and ExtraUI.GunsPage
        or which == "esp" and ExtraUI.EspPage
        or which == "teleport" and ExtraUI.TeleportPage
        or which == "stand" and ExtraUI.StandPage
        or ExtraUI.ConfigPage
    activePage.Position = UDim2.fromOffset(143, 91)
    game:GetService("TweenService"):Create(activePage,
        TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        {Position = UDim2.fromOffset(132, 91)}):Play()
end
bind(TargetTab.MouseButton1Click:Connect(function() showTab("targets") end))
bind(AimTab.MouseButton1Click:Connect(function() showTab("aim") end))
bind(ToolsTab.MouseButton1Click:Connect(function() showTab("tools") end))
bind(SettingsTab.MouseButton1Click:Connect(function() showTab("settings") end))
bind(ExtraUI.GunsTab.MouseButton1Click:Connect(function() showTab("guns") end))
bind(ExtraUI.EspTab.MouseButton1Click:Connect(function() showTab("esp") end))
bind(ExtraUI.TeleportTab.MouseButton1Click:Connect(function() showTab("teleport") end))
bind(ExtraUI.StandTab.MouseButton1Click:Connect(function() showTab("stand") end))
bind(ExtraUI.ConfigTab.MouseButton1Click:Connect(function() showTab("configs") end))
showTab("targets")
local Minimized = false
bind(Minimise.MouseButton1Click:Connect(function()
    Minimized = not Minimized
    game:GetService("TweenService"):Create(Main,
        TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        {Size = UDim2.fromOffset(520, Minimized and 67 or 625)}):Play()
    Minimise.Text = Minimized and "+" or "-"
    Subtitle.Visible = not Minimized
    TargetTab.Visible = not Minimized
    AimTab.Visible = not Minimized
    ToolsTab.Visible = not Minimized
    SettingsTab.Visible = not Minimized
    ExtraUI.GunsTab.Visible = not Minimized
    ExtraUI.EspTab.Visible = not Minimized
    ExtraUI.TeleportTab.Visible = not Minimized
    ExtraUI.StandTab.Visible = not Minimized
    ExtraUI.ConfigTab.Visible = not Minimized
    Status.Visible = not Minimized
    StatusBar.Visible = not Minimized
    Sidebar.Visible = not Minimized
    if Minimized then
        TargetsPage.Visible, AimPage.Visible, ToolsPage.Visible,
            SettingsPage.Visible, ExtraUI.GunsPage.Visible,
            ExtraUI.EspPage.Visible, ExtraUI.TeleportPage.Visible,
            ExtraUI.StandPage.Visible, ExtraUI.ConfigPage.Visible =
            false, false, false, false, false, false, false, false, false
    else
        showTab(CurrentTab)
    end
end))

local function say(message)
    if not S.closed then Status.Text = message end
end
do
    local previous = nil
    local function teleportTo(position, title)
        local character = Me.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if not root then say("Teleport unavailable until your character spawns."); return end
        previous = root.CFrame
        character:PivotTo(CFrame.new(position + Vector3.new(0, 4, 0)))
        say("Teleported to " .. title .. ".")
    end
    local function nearestShop(name)
        local store = Workspace:FindFirstChild("Store")
        local root = Me.Character and Me.Character:FindFirstChild("HumanoidRootPart")
        if not store or not root then return nil end
        local nearest, distance = nil, math.huge
        for _, shop in ipairs(store:GetChildren()) do
            if shop.Name == name then
                local part = shop:FindFirstChildWhichIsA("BasePart", true)
                if part then
                    local d = (part.Position - root.Position).Magnitude
                    if d < distance then nearest, distance = part, d end
                end
            end
        end
        return nearest
    end
    local t = ExtraUI.TeleportButtons
    bind(t.uphill.MouseButton1Click:Connect(function()
        teleportTo(Vector3.new(1750.13, 29.45, 244.33), "Uphill")
    end))
    bind(t.downhill.MouseButton1Click:Connect(function()
        teleportTo(Vector3.new(722.42, 1.75, 264.21), "Downhill")
    end))
    for _, entry in ipairs({{t.armor, "[Armor]", "Armor shop"},
        {t.smg, "[SMG]", "SMG shop"}}) do
        bind(entry[1].MouseButton1Click:Connect(function()
            local part = nearestShop(entry[2])
            if part then teleportTo(part.Position, entry[3])
            else say(entry[3] .. " is not loaded nearby.") end
        end))
    end
    bind(t.returnTo.MouseButton1Click:Connect(function()
        local character = Me.Character
        if previous and character and character:FindFirstChild("HumanoidRootPart") then
            local destination = previous
            previous = character:GetPivot()
            character:PivotTo(destination)
            say("Returned to previous position.")
        else say("No previous teleport position saved.") end
    end))
end
local Rapid = {}
do
local RapidOriginal = setmetatable({}, {__mode = "k"})
local PaceByName = {}
local RapidWatched = setmetatable({}, {__mode = "k"})
local RapidLast = setmetatable({}, {__mode = "k"})
local ReloadLast = setmetatable({}, {__mode = "k"})
local GunRows = {}
local GunRowCount = 0
local function ownedGuns(callback)
    local containers = {}
    if Me.Character then containers[#containers + 1] = Me.Character end
    local bag = Me:FindFirstChildOfClass("Backpack")
    if bag then containers[#containers + 1] = bag end
    for _, container in ipairs(containers) do
        if container then
            for _, tool in ipairs(container:GetChildren()) do
                if tool:IsA("Tool") then callback(tool) end
            end
        end
    end
end
local function applyRapidCooldown(tool)
    if not tool or not tool:IsA("Tool") then return end
    local cooldown = tool:GetAttribute("Cooldown")
    if S.rapidWeapons[tool.Name] then
        if type(cooldown) == "number" and cooldown ~= 0 then
            RapidOriginal[tool] = cooldown
            tool:SetAttribute("Cooldown", 0)
        end
    elseif RapidOriginal[tool] ~= nil then
        local original = RapidOriginal[tool]
        RapidOriginal[tool] = nil
        pcall(function() tool:SetAttribute("Cooldown", original) end)
    end
end
Rapid.getPace = function(tool)
    if not S.adaptiveRapid then return 0 end
    local name = tool.Name
    local base = RapidOriginal[tool] or tool:GetAttribute("Cooldown") or 0.2
    if type(base) ~= "number" or base <= 0 then base = 0.2 end
    local minimum = name == "[Revolver]" and 0.05
        or name == "[SMG]" and 0.045
        or (name == "[Double-Barrel SG]" or name == "[Shotgun]"
            or name == "[TacticalShotgun]") and 0.16 or 0.06
    local stats = PaceByName[name]
    if not stats then
        stats = {pace = math.max(minimum, base * 0.5),
            base = base, minimum = minimum, windowAt = os.clock(), hit = false}
        PaceByName[name] = stats
    end
    local now = os.clock()
    if now - stats.windowAt >= 1 then
        stats.pace = math.clamp(stats.pace * (stats.hit and 0.93 or 1.18),
            stats.minimum, math.max(stats.minimum, stats.base))
        stats.windowAt, stats.hit = now, false
    end
    return stats.pace
end
Rapid.noteShot = function(tool)
    S.lastAttemptWeaponName = tool.Name
end
Rapid.noteConfirmed = function(name)
    local stats = name and PaceByName[name]
    if stats then stats.hit = true end
end
local function requestReload(tool)
    if not tool or type(tool:GetAttribute("MaxAmmo")) ~= "number" then return end
    local real = tool:GetAttribute("RealAmmo")
    local ammo = tool:GetAttribute("Ammo")
    local remaining = type(real) == "number" and real or ammo
    if type(ammo) == "number" and type(remaining) == "number" then
        remaining = math.min(remaining, ammo)
    end
    if type(remaining) ~= "number" or remaining > 2 then return end
    local now = os.clock()
    if now - (ReloadLast[tool] or 0) < 0.8 then return end
    ReloadLast[tool] = now
    local storage = ReplicatedStorage:FindFirstChild("Storage")
    local remotes = storage and storage:FindFirstChild("Remotes")
    local main = remotes and remotes:FindFirstChild("Main")
    if main then pcall(function() main:FireServer("Reload", tool) end) end
end
Rapid.requestReload = requestReload
local function addGunRow(name)
    if GunRows[name] then return end
    GunRowCount = GunRowCount + 1
    local row = button(ExtraUI.GunList, name .. "  /  OFF", 5, 0, 326, 35)
    row.LayoutOrder = GunRowCount + 10
    GunRows[name] = row
    bind(row.MouseButton1Click:Connect(function()
        S.rapidWeapons[name] = not S.rapidWeapons[name] or nil
        style(row, S.rapidWeapons[name], name .. "  /  ON", name .. "  /  OFF")
        ownedGuns(function(tool)
            if tool.Name == name then applyRapidCooldown(tool) end
        end)
        say(name .. (S.rapidWeapons[name] and " rapid fire enabled." or " cooldown restored."))
    end))
end
local function observeGun(tool)
    if not tool:IsA("Tool") then return end
    if type(tool:GetAttribute("Cooldown")) == "number" then
        addGunRow(tool.Name)
        applyRapidCooldown(tool)
    end
    if RapidWatched[tool] then return end
    RapidWatched[tool] = true
    bind(tool:GetAttributeChangedSignal("Cooldown"):Connect(function()
        if not S.closed then observeGun(tool) end
    end))
end
Rapid.observeGun = observeGun
Rapid.forEachGun = ownedGuns
Rapid.applyCooldown = applyRapidCooldown
Rapid.rows = GunRows
Rapid.restore = function()
    for tool, original in pairs(RapidOriginal) do
        pcall(function() tool:SetAttribute("Cooldown", original) end)
        RapidOriginal[tool] = nil
    end
end
for _, name in ipairs({"[Double-Barrel SG]", "[Revolver]", "[Shotgun]",
    "[TacticalShotgun]", "[SMG]"}) do addGunRow(name) end
ownedGuns(observeGun)
local Backpack = Me:FindFirstChildOfClass("Backpack") or Me:WaitForChild("Backpack", 6)
if Backpack then bind(Backpack.ChildAdded:Connect(observeGun)) end
bind(RunService.Heartbeat:Connect(function()
    if S.closed then return end
    local character = Me.Character
    local tool = character and character:FindFirstChildOfClass("Tool")
    if tool and (S.autoReloadAll or (S.infiniteSmg and tool.Name == "[SMG]")) then
        requestReload(tool)
    end
    if not next(S.rapidWeapons) or UIS:GetFocusedTextBox()
        or not UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then return end
    local mouse = UIS:GetMouseLocation()
    local pos, size = Main.AbsolutePosition, Main.AbsoluteSize
    if Gui.Enabled and mouse.X >= pos.X and mouse.X <= pos.X + size.X
        and mouse.Y >= pos.Y and mouse.Y <= pos.Y + size.Y then return end
    if tool and S.rapidWeapons[tool.Name]
        and type(tool:GetAttribute("Cooldown")) == "number" then
        local pace = Rapid.getPace(tool)
        local now = os.clock()
        if now - (RapidLast[tool] or 0) >= pace then
            RapidLast[tool] = now
            Rapid.noteShot(tool)
            pcall(function() tool:Activate() end)
        end
    end
end))
end
do
    local RecoilOriginal = setmetatable({}, {__mode = "k"})
    local ShotVisualOriginal = setmetatable({}, {__mode = "k"})
    local SpreadOriginal = nil
    local function applyRecoil(character)
        local scripts = character and character:FindFirstChild("Scripts")
        local input = scripts and scripts:FindFirstChild("Input")
        local module = input and input:FindFirstChild("AimingInput")
        if not module then return end
        local ok, aim = pcall(require, module)
        if not ok or type(aim) ~= "table" or type(aim.CameraRecoil) ~= "function" then return end
        if not RecoilOriginal[aim] then RecoilOriginal[aim] = aim.CameraRecoil end
        aim.CameraRecoil = (S.noRecoil or S.invisibleShot)
            and function() end or RecoilOriginal[aim]
    end
    local function applyShotVisuals(character)
        local scripts = character and character:FindFirstChild("Scripts")
        local input = scripts and scripts:FindFirstChild("Input")
        local aiming = input and input:FindFirstChild("AimingInput")
        if aiming then
            local ok, aim = pcall(require, aiming)
            if ok and type(aim) == "table" then
                local originals = ShotVisualOriginal[aim]
                if S.invisibleShot then
                    if not originals then
                        originals = {
                            GunshotReticle = aim.GunshotReticle,
                            PlayShotAnimation = aim.PlayShotAnimation,
                        }
                        ShotVisualOriginal[aim] = originals
                    end
                    aim.GunshotReticle = function() end
                    aim.PlayShotAnimation = function() end
                elseif originals then
                    aim.GunshotReticle = originals.GunshotReticle
                    aim.PlayShotAnimation = originals.PlayShotAnimation
                    ShotVisualOriginal[aim] = nil
                end
            end
        end
        local storage = ReplicatedStorage:FindFirstChild("Storage")
        local modules = storage and storage:FindFirstChild("Modules")
        local dialect = modules and modules:FindFirstChild("Dialect")
        local managerModule = dialect and dialect:FindFirstChild("GunManager")
        if managerModule then
            local ok, manager = pcall(require, managerModule)
            if ok and type(manager) == "table" then
                local originals = ShotVisualOriginal[manager]
                if S.invisibleShot then
                    if not originals then
                        originals = {
                            BulletTrails = manager.BulletTrails,
                            ShootFXGui = manager.ShootFXGui,
                        }
                        ShotVisualOriginal[manager] = originals
                    end
                    -- GunManager parents the projectile before calling BulletTrails.
                    -- Skipping the animation alone leaves that part visible for 5s.
                    manager.BulletTrails = function(_, bullet)
                        if typeof(bullet) ~= "Instance" then return end
                        if bullet:IsA("BasePart") then
                            bullet.Transparency = 1
                            bullet.LocalTransparencyModifier = 1
                        end
                        for _, visual in ipairs(bullet:GetDescendants()) do
                            if visual:IsA("BasePart") then
                                visual.Transparency = 1
                                visual.LocalTransparencyModifier = 1
                            elseif visual:IsA("Beam") or visual:IsA("Trail")
                                or visual:IsA("ParticleEmitter") then
                                visual.Enabled = false
                            end
                        end
                    end
                    manager.ShootFXGui = function() end
                elseif originals then
                    manager.BulletTrails = originals.BulletTrails
                    manager.ShootFXGui = originals.ShootFXGui
                    ShotVisualOriginal[manager] = nil
                end
            end
        end
        local playerScripts = Me:FindFirstChild("PlayerScripts")
        local mainScripts = playerScripts and playerScripts:FindFirstChild("Main")
        local handlers = mainScripts and mainScripts:FindFirstChild("Handlers")
        local bulletModule = handlers and handlers:FindFirstChild("BulletHandler")
        if bulletModule then
            local ok, handler = pcall(require, bulletModule)
            if ok and type(handler) == "table"
                and type(handler.ReplicateBullets) == "function" then
                local originals = ShotVisualOriginal[handler]
                if S.invisibleShot then
                    if not originals then
                        originals = {ReplicateBullets = handler.ReplicateBullets}
                        ShotVisualOriginal[handler] = originals
                    end
                    handler.ReplicateBullets = function(self, shot)
                        if shot and shot.Player == Me then return end
                        return originals.ReplicateBullets(self, shot)
                    end
                elseif originals then
                    handler.ReplicateBullets = originals.ReplicateBullets
                    ShotVisualOriginal[handler] = nil
                end
            end
        end
    end
    local function applySpread()
        local storage = ReplicatedStorage:FindFirstChild("Storage")
        local modules = storage and storage:FindFirstChild("Modules")
        local dialect = modules and modules:FindFirstChild("Dialect")
        local module = dialect and dialect:FindFirstChild("GunManager")
        if not module then return end
        local ok, manager = pcall(require, module)
        if not ok or type(manager) ~= "table" then return end
        local patterns = manager["[Double-Barrel SG]"]
        if type(patterns) ~= "table" then return end
        if not SpreadOriginal then
            SpreadOriginal = {}
            for i, pattern in ipairs(patterns) do
                SpreadOriginal[i] = {}
                for j, offset in ipairs(pattern) do SpreadOriginal[i][j] = offset end
            end
        end
        for i, pattern in ipairs(patterns) do
            for j in ipairs(pattern) do
                pattern[j] = S.noSpread and Vector3.zero or SpreadOriginal[i][j]
            end
        end
    end
    ExtraUI.applyGunMods = function(character)
        applyRecoil(character)
        applyShotVisuals(character)
        applySpread()
    end
    ExtraUI.restoreGunMods = function()
        S.noRecoil, S.noSpread, S.invisibleShot = false, false, false
        for aim, original in pairs(RecoilOriginal) do
            pcall(function() aim.CameraRecoil = original end)
        end
        for module, originals in pairs(ShotVisualOriginal) do
            pcall(function()
                for method, original in pairs(originals) do module[method] = original end
            end)
            ShotVisualOriginal[module] = nil
        end
        applySpread()
    end
    local invisibleBtn = button(ExtraUI.GunList, "INVISIBLE SHOT: OFF", 5, 0, 326, 35)
    invisibleBtn.LayoutOrder = -4
    bind(invisibleBtn.MouseButton1Click:Connect(function()
        S.invisibleShot = not S.invisibleShot
        applyShotVisuals(Me.Character)
        applyRecoil(Me.Character)
        style(invisibleBtn, S.invisibleShot,
            "INVISIBLE SHOT: ON", "INVISIBLE SHOT: OFF")
        say("Invisible shot affects local visuals; server shot effects may still be visible.")
    end))
    local adaptiveBtn = button(ExtraUI.GunList, "ADAPTIVE RAPID: ON", 5, 0, 326, 35)
    adaptiveBtn.LayoutOrder = -5
    bind(adaptiveBtn.MouseButton1Click:Connect(function()
        S.adaptiveRapid = not S.adaptiveRapid
        style(adaptiveBtn, S.adaptiveRapid,
            "ADAPTIVE RAPID: ON", "ADAPTIVE RAPID: OFF")
        say("Adaptive rapid tunes each enabled gun from confirmed damage windows.")
    end))
    local recoilBtn = button(ExtraUI.GunList, "NO RECOIL: OFF", 5, 0, 326, 35)
    recoilBtn.LayoutOrder = -3
    bind(recoilBtn.MouseButton1Click:Connect(function()
        S.noRecoil = not S.noRecoil
        applyRecoil(Me.Character)
        style(recoilBtn, S.noRecoil, "NO RECOIL: ON", "NO RECOIL: OFF")
    end))
    local spreadBtn = button(ExtraUI.GunList, "DB NO SPREAD: OFF", 5, 0, 326, 35)
    spreadBtn.LayoutOrder = -2
    bind(spreadBtn.MouseButton1Click:Connect(function()
        S.noSpread = not S.noSpread
        applySpread()
        style(spreadBtn, S.noSpread, "DB NO SPREAD: ON", "DB NO SPREAD: OFF")
    end))
    local smgBtn = button(ExtraUI.GunList, "SMG AUTO RELOAD: OFF", 5, 0, 326, 35)
    smgBtn.LayoutOrder = -1
    bind(smgBtn.MouseButton1Click:Connect(function()
        S.infiniteSmg = not S.infiniteSmg
        style(smgBtn, S.infiniteSmg, "SMG AUTO RELOAD: ON", "SMG AUTO RELOAD: OFF")
        say("SMG reload requests follow the server ammo count.")
    end))
    local reloadBtn = button(ExtraUI.GunList, "AUTO RELOAD ALL GUNS: OFF", 5, 0, 326, 35)
    reloadBtn.LayoutOrder = 0
    ExtraUI.GunModButtons = {invisible = invisibleBtn, adaptive = adaptiveBtn,
        recoil = recoilBtn, spread = spreadBtn, smg = smgBtn, reload = reloadBtn}
    bind(reloadBtn.MouseButton1Click:Connect(function()
        S.autoReloadAll = not S.autoReloadAll
        style(reloadBtn, S.autoReloadAll,
            "AUTO RELOAD ALL GUNS: ON", "AUTO RELOAD ALL GUNS: OFF")
    end))
    local knifeBtn = button(ExtraUI.GunList, "EQUIP KNIFE", 5, 0, 326, 35)
    knifeBtn.LayoutOrder = 1
    bind(knifeBtn.MouseButton1Click:Connect(function()
        local character = Me.Character
        local hum = character and character:FindFirstChildOfClass("Humanoid")
        local bag = Me:FindFirstChildOfClass("Backpack")
        local knife = bag and bag:FindFirstChild("[Knife]")
        if hum and knife then
            hum:EquipTool(knife)
            say("Knife equipped.")
        else say("Knife is not in your backpack.") end
    end))
end
do
    local overlays = {}
    local ranges = {250, 500, 1000, math.huge}
    local colors = {Color3.fromRGB(75, 213, 224), Color3.fromRGB(186, 144, 253),
        Color3.fromRGB(238, 178, 89), Color3.fromRGB(143, 221, 120)}
    local colorNames = {"CYAN", "VIOLET", "AMBER", "LIME"}
    local r15 = {{"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"},
        {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"},
        {"LeftLowerArm", "LeftHand"}, {"UpperTorso", "RightUpperArm"},
        {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},
        {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"},
        {"LeftLowerLeg", "LeftFoot"}, {"LowerTorso", "RightUpperLeg"},
        {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"}}
    local r6 = {{"Head", "Torso"}, {"Torso", "Left Arm"},
        {"Torso", "Right Arm"}, {"Torso", "Left Leg"}, {"Torso", "Right Leg"}}
    local function clearOverlay(o)
        if not o then return end
        pcall(function() o.box:Remove() end)
        pcall(function() o.name:Remove() end)
        pcall(function() o.distance:Remove() end)
        pcall(function() o.combat:Remove() end)
        pcall(function() o.healthBack:Remove() end)
        pcall(function() o.healthFill:Remove() end)
        pcall(function() o.tracer:Remove() end)
        for _, line in ipairs(o.lines) do pcall(function() line:Remove() end) end
    end
    local function hideOverlay(o)
        o.box.Visible, o.name.Visible, o.distance.Visible, o.combat.Visible = false, false, false, false
        o.healthBack.Visible, o.healthFill.Visible, o.tracer.Visible = false, false, false
        for _, line in ipairs(o.lines) do line.Visible = false end
    end
    local function createOverlay()
        local o = {box = Drawing.new("Square"), name = Drawing.new("Text"),
            distance = Drawing.new("Text"), combat = Drawing.new("Text"),
            healthBack = Drawing.new("Square"),
            healthFill = Drawing.new("Square"), tracer = Drawing.new("Line"), lines = {}}
        o.box.Filled = false
        o.box.Thickness = 1.5
        o.healthBack.Filled, o.healthFill.Filled = true, true
        o.healthBack.Color = Color3.fromRGB(16, 22, 35)
        o.tracer.Thickness = 1.4
        o.name.Center, o.distance.Center, o.combat.Center = true, true, true
        o.name.Outline, o.distance.Outline, o.combat.Outline = true, true, true
        o.name.Size, o.distance.Size, o.combat.Size = 13, 12, 11
        for i = 1, #r15 do
            local line = Drawing.new("Line")
            line.Thickness = 1.4
            o.lines[i] = line
        end
        hideOverlay(o)
        return o
    end
    local function renderEsp()
        if not S.esp.enabled and not (S.dot and S.primary) then
            for _, o in pairs(overlays) do hideOverlay(o) end
            return
        end
        local camera = Workspace.CurrentCamera
        if not camera then return end
        local seen = {}
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= Me then
                seen[player] = true
                local selected = S.dot and player == S.primary
                local o = overlays[player]
                if (S.esp.enabled or selected) and not o then
                    o = createOverlay(); overlays[player] = o
                end
                if o then hideOverlay(o) end
                if not o or (not S.esp.enabled and not selected) then continue end
                local record = Records[player]
                local folder = Me.Character and Me.Character.Parent
                local character = selected and record and record.model
                    or player.Character or (folder and folder:FindFirstChild(player.Name))
                local root = character and character:FindFirstChild("HumanoidRootPart")
                local hum = character and character:FindFirstChildOfClass("Humanoid")
                if root and hum then
                    local studs = (root.Position - camera.CFrame.Position).Magnitude
                    if selected or studs <= ranges[S.esp.rangeIndex] then
                        local top, topOn = camera:WorldToViewportPoint(root.Position + Vector3.new(0, 3.4, 0))
                        local bottom, bottomOn = camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3.2, 0))
                        if topOn and bottomOn and top.Z > 0 and bottom.Z > 0 then
                            local height = math.abs(bottom.Y - top.Y)
                            local width = height * 0.55
                            local centerX = (top.X + bottom.X) * 0.5
                            local color = selected and C_ACCENT or colors[S.esp.colorIndex]
                            o.box.Color, o.name.Color, o.distance.Color = color, color, color
                            o.box.Thickness = selected and 2.5 or 1.5
                            o.box.Position = Vector2.new(centerX - width * 0.5, top.Y)
                            o.box.Size = Vector2.new(width, height)
                            o.box.Visible = selected or S.esp.boxes
                            o.name.Text = selected and ("◆  " .. player.DisplayName .. "  ◆")
                                or player.DisplayName
                            o.name.Position = Vector2.new(centerX, top.Y - 18)
                            o.name.Visible = not selected and S.esp.enabled and S.esp.names
                            o.distance.Text = selected and string.format(
                                "%.0f HP  |  %.0f studs", hum.Health, studs)
                                or string.format("%.0f studs", studs)
                            o.distance.Position = Vector2.new(centerX, bottom.Y + 3)
                            o.distance.Visible = not selected and S.esp.enabled and S.esp.distance
                            local effects = character:FindFirstChild("BodyEffects")
                            local armor = effects and effects:FindFirstChild("Armor")
                            local ko = effects and effects:FindFirstChild("K.O")
                            local dead = effects and effects:FindFirstChild("Dead")
                            local status = dead and dead.Value and "DEAD"
                                or (ko and ko.Value or hum.Health <= 0.5) and "DOWN" or "UP"
                            local weapon = character:FindFirstChildOfClass("Tool")
                            local weaponText = weapon and weapon.Name:gsub("[%[%]]", "") or "UNARMED"
                            local ammo = weapon and weapon:GetAttribute("RealAmmo")
                            if type(ammo) ~= "number" then
                                ammo = weapon and weapon:GetAttribute("Ammo")
                            end
                            if type(ammo) == "number" then
                                weaponText = weaponText .. " " .. math.floor(ammo)
                            end
                            o.combat.Text = string.format("HP %.0f  AR %.0f  %s  %s",
                                hum.Health, armor and armor.Value or 0, status, weaponText)
                            o.combat.Color = status == "UP" and color or Color3.fromRGB(255, 105, 105)
                            o.combat.Position = Vector2.new(centerX,
                                bottom.Y + ((selected or not S.esp.distance) and 3 or 18))
                            o.combat.Visible = selected or S.esp.enabled
                            if selected then
                                o.tracer.From = Vector2.new(camera.ViewportSize.X * 0.5,
                                    camera.ViewportSize.Y - 12)
                                o.tracer.To = Vector2.new(centerX, bottom.Y)
                                o.tracer.Color = color
                                o.tracer.Visible = true
                            end
                            local bones = character:FindFirstChild("UpperTorso") and r15 or r6
                            if S.esp.enabled and S.esp.skeleton and not selected then
                                for i, pair in ipairs(bones) do
                                    local a = character:FindFirstChild(pair[1])
                                    local b = character:FindFirstChild(pair[2])
                                    if a and b then
                                        local pa, va = camera:WorldToViewportPoint(a.Position)
                                        local pb, vb = camera:WorldToViewportPoint(b.Position)
                                        local line = o.lines[i]
                                        line.From = Vector2.new(pa.X, pa.Y)
                                        line.To = Vector2.new(pb.X, pb.Y)
                                        line.Color = color
                                        line.Visible = va and vb and pa.Z > 0 and pb.Z > 0
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        for player, o in pairs(overlays) do
            if not seen[player] then clearOverlay(o); overlays[player] = nil end
        end
    end
    bind(RunService.RenderStepped:Connect(renderEsp))
    ExtraUI.cleanupEsp = function()
        for player, o in pairs(overlays) do clearOverlay(o); overlays[player] = nil end
    end
    bind(ExtraUI.EspMain.MouseButton1Click:Connect(function()
        S.esp.enabled = not S.esp.enabled
        style(ExtraUI.EspMain, S.esp.enabled, "ESP: ON", "ESP: OFF")
        if not S.esp.enabled then
            for _, o in pairs(overlays) do hideOverlay(o) end
        end
    end))
    local toggles = {{"boxes", ExtraUI.EspBoxes, "BOXES"},
        {"skeleton", ExtraUI.EspSkeleton, "SKELETON"},
        {"names", ExtraUI.EspNames, "NAMES"},
        {"distance", ExtraUI.EspDistance, "DISTANCE"}}
    for _, item in ipairs(toggles) do
        bind(item[2].MouseButton1Click:Connect(function()
            S.esp[item[1]] = not S.esp[item[1]]
            style(item[2], S.esp[item[1]], item[3] .. ": ON", item[3] .. ": OFF")
        end))
    end
    bind(ExtraUI.EspRange.MouseButton1Click:Connect(function()
        S.esp.rangeIndex = S.esp.rangeIndex % #ranges + 1
        ExtraUI.EspRange.Text = "RANGE: " ..
            (ranges[S.esp.rangeIndex] == math.huge and "ALL" or tostring(ranges[S.esp.rangeIndex]))
    end))
    bind(ExtraUI.EspColor.MouseButton1Click:Connect(function()
        S.esp.colorIndex = S.esp.colorIndex % #colors + 1
        ExtraUI.EspColor.Text = "COLOR: " .. colorNames[S.esp.colorIndex]
    end))
end
local function updateOwnRoot()
    local c = Me.Character
    OwnRoot = c and c:FindFirstChild("HumanoidRootPart", true) or nil
end

-- Cache only the actual shop models. No map or player scan runs each frame.
local function refreshArmorShops()
    table.clear(ArmorShops)
    local store = Workspace:FindFirstChild("Store")
    if not store then return end
    for _, model in ipairs(store:GetChildren()) do
        if model.Name == "[Armor]" and model:IsA("Model") then
            local head = model:FindFirstChild("Head")
            local click = model:FindFirstChildOfClass("ClickDetector")
            if head and head:IsA("BasePart") and click then
                ArmorShops[#ArmorShops + 1] = {model = model, head = head, click = click}
            end
        end
    end
end

local function closestArmorShop(root, excluded)
    if #ArmorShops == 0 then refreshArmorShops() end
    local function choose()
        local best, distance = nil, math.huge
        for _, shop in ipairs(ArmorShops) do
            if shop.model ~= excluded and shop.model.Parent
                and shop.head.Parent and shop.click.Parent then
                local d = (shop.head.Position - root.Position).Magnitude
                if d < distance then best, distance = shop, d end
            end
        end
        return best
    end
    local best = choose()
    if not best then refreshArmorShops(); best = choose() end
    return best
end

local function buyArmorAfterSpawn(character)
    local generation = S.armorGeneration
    local root = character:WaitForChild("HumanoidRootPart", 6)
    local hum = character:WaitForChild("Humanoid", 6)
    local effects = character:WaitForChild("BodyEffects", 6)
    local armor = effects and effects:WaitForChild("Armor", 6)
    if not root or not hum or not armor or S.closed or not S.autoArmor
        or generation ~= S.armorGeneration or Me.Character ~= character then return end
    local readyUntil = os.clock() + 6
    while hum.Health <= 0 and os.clock() < readyUntil and not S.closed
        and Me.Character == character do task.wait(0.1) end
    if S.closed or not S.autoArmor or generation ~= S.armorGeneration
        or Me.Character ~= character or not root.Parent or hum.Health <= 0 then return end
    if armor.Value >= 200 then say("Auto armor: already full."); return end
    if type(fireclickdetector) ~= "function" then
        say("Auto armor: this executor has no ClickDetector interaction.")
        return
    end
    local shop = closestArmorShop(root)
    if not shop then say("Auto armor: no loaded armor shop found."); return end
    local before = armor.Value
    local original = character:GetPivot()
    local clicked = false
    for shopIndex = 1, 2 do
        if not shop or armor.Value > before then break end
        local destination = CFrame.new(shop.head.Position + Vector3.new(0, 2.8, 0))
        for attempt = 1, 3 do
            if Me.Character ~= character or not root.Parent
                or generation ~= S.armorGeneration or armor.Value > before then break end
            pcall(function() character:PivotTo(destination) end)
            task.wait(attempt == 1 and 0.24 or 0.18)
            if Me.Character ~= character or not root.Parent
                or generation ~= S.armorGeneration or armor.Value > before then break end
            local ok = pcall(fireclickdetector, shop.click, 0, "mouseclick")
            clicked = clicked or ok
            local untilAt = os.clock() + 0.35
            while os.clock() < untilAt and armor.Value <= before
                and Me.Character == character and not S.closed do task.wait(0.04) end
        end
        if armor.Value <= before then shop = closestArmorShop(root, shop.model) end
    end
    if armor.Value <= before then task.wait(0.25) end
    if Me.Character == character and root.Parent then
        pcall(function() character:PivotTo(original) end)
    end
    if not S.closed and generation == S.armorGeneration then
        if armor.Value > before then
            say("Auto armor: collected (" .. armor.Value .. " armor).")
        elseif clicked then
            say("Auto armor: shop clicked, but purchase was not confirmed.")
        else
            say("Auto armor: shop click failed.")
        end
    end
end

local function selectedShop()
    return ShopNames[S.autoBuyIndex]
end
local function refreshAutoBuyControls()
    local name = selectedShop()
    AutoBuyName.Text = name:gsub("%[", ""):gsub("%]", "")
    style(AutoBuyToggle, S.autoBuys[name] == true, "AUTO BUY: ON", "AUTO BUY: OFF")
    local count = 0
    for _, item in ipairs(ShopNames) do
        if S.autoBuys[item] then count = count + 1 end
    end
    AutoBuyCount.Text = count .. " shop item(s) selected for each respawn."
end
local function hasShopItem(character, name)
    local backpack = Me:FindFirstChildOfClass("Backpack")
    if character:FindFirstChild(name) or (backpack and backpack:FindFirstChild(name)) then return true end
    if name == "[Surgeon Mask]" then
        local effects = character:FindFirstChild("BodyEffects")
        local mask = effects and effects:FindFirstChild("Mask")
        return mask and mask.Value ~= ""
    end
    return false
end
local function closestShopByName(name, root)
    local store = Workspace:FindFirstChild("Store")
    if not store then return {} end
    local choices = {}
    for _, model in ipairs(store:GetChildren()) do
        if model.Name == name and model:IsA("Model") then
            local head = model:FindFirstChild("Head")
            local click = model:FindFirstChildOfClass("ClickDetector")
            if head and head:IsA("BasePart") and click then
                choices[#choices + 1] = {head = head, click = click,
                    distance = (head.Position - root.Position).Magnitude}
            end
        end
    end
    table.sort(choices, function(a, b) return a.distance < b.distance end)
    return choices
end
local function buyShopItem(character, name)
    if hasShopItem(character, name) then return true end
    if type(fireclickdetector) ~= "function" then return false end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root or Me.Character ~= character then return false end
    local shops = closestShopByName(name, root)
    if #shops == 0 then return false end
    local original = character:GetPivot()
    for shopIndex = 1, math.min(#shops, 3) do
        local shop = shops[shopIndex]
        local destination = CFrame.new(shop.head.Position + Vector3.new(0, 2.8, 0))
        for attempt = 1, 2 do
            if S.closed or Me.Character ~= character or not root.Parent
                or hasShopItem(character, name) then break end
            pcall(function() character:PivotTo(destination) end)
            task.wait(0.15)
            if S.closed or Me.Character ~= character or not root.Parent
                or hasShopItem(character, name) then break end
            pcall(fireclickdetector, shop.click, 0, "mouseclick")
            local untilAt = os.clock() + 0.35
            while os.clock() < untilAt and not hasShopItem(character, name)
                and Me.Character == character and not S.closed do task.wait(0.04) end
        end
        if hasShopItem(character, name) then break end
    end
    if Me.Character == character and root.Parent then
        pcall(function() character:PivotTo(original) end)
    end
    return hasShopItem(character, name)
end
local ShopBusy = false
local function buyAutoItems(character, onlyName)
    while ShopBusy and not S.closed and Me.Character == character do task.wait(0.03) end
    if S.closed or Me.Character ~= character then return end
    ShopBusy = true
    local ok, err = pcall(function()
        if not onlyName and S.autoArmor then buyArmorAfterSpawn(character) end
        for _, name in ipairs(ShopNames) do
            if (onlyName == name or (not onlyName and S.autoBuys[name]))
                and Me.Character == character and not S.closed then
                local bought = buyShopItem(character, name)
                say((bought and "Bought " or "Could not confirm ") .. name .. ".")
                task.wait(0.02)
            end
        end
    end)
    ShopBusy = false
    if not ok and not S.closed then say("Auto buy failed: " .. tostring(err)) end
end

local function captureDeathPosition(character)
    if not S.respawnAtDeath or Me.Character ~= character then return end
    local root = character:FindFirstChild("HumanoidRootPart")
    if root and root:IsA("BasePart") then DeathPosition = root.CFrame end
end
local function restoreDeathPosition(character)
    local destination = DeathPosition
    if not S.respawnAtDeath or not destination then return end
    task.spawn(function()
        local root = character:WaitForChild("HumanoidRootPart", 6)
        local hum = character:FindFirstChildOfClass("Humanoid")
        if not root or S.closed or Me.Character ~= character then return end
        for _ = 1, 3 do
            if S.closed or not S.respawnAtDeath or Me.Character ~= character
                or (hum and hum.Health <= 0) then return end
            pcall(function()
                character:PivotTo(destination)
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
            end)
            task.wait(0.15)
        end
        if DeathPosition == destination then DeathPosition = nil end
    end)
end
ExtraUI.runSpawnSequence = function(character)
    local now = os.clock()
    if ExtraUI.spawnSequenceCharacter == character
        and now - (ExtraUI.spawnSequenceAt or 0) < 1 then return end
    ExtraUI.spawnSequenceCharacter = character
    ExtraUI.spawnSequenceAt = now
    task.spawn(function()
        if S.autoArmor or next(S.autoBuys) then buyAutoItems(character) end
        restoreDeathPosition(character)
    end)
end
local function ownDangerReason(character)
    if not character or Me.Character ~= character then return nil end
    local effects = character:FindFirstChild("BodyEffects")
    local ko = effects and effects:FindFirstChild("K.O")
    local dead = effects and effects:FindFirstChild("Dead")
    local grabbed = effects and effects:FindFirstChild("Grabbed")
    local hum = character:FindFirstChildOfClass("Humanoid")
    if ko and ko:IsA("BoolValue") and ko.Value then return "K.O" end
    if dead and dead:IsA("BoolValue") and dead.Value then return "Dead" end
    if grabbed and grabbed:IsA("ObjectValue") and grabbed.Value then return "grabbed" end
    if hum and hum.Health <= ResetThresholds[S.resetThresholdIndex] then
        return "low health"
    end
    return nil
end
local function resetBeforeStomp(character, reason)
    if not reason or S.closed or not S.antiStomp or S.resetInFlight
        or S.resetCharacter == character
        or Me.Character ~= character then return end
    local hum = character:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    -- HealthChanged, K.O, Dead, and Humanoid state can arrive in any order.
    -- The per-character latch below permits the request even after Dead wins.
    local storage = ReplicatedStorage:FindFirstChild("Storage")
    local remotes = storage and storage:FindFirstChild("Remotes")
    local main = remotes and remotes:FindFirstChild("Main")
    if not main or not main:IsA("RemoteEvent") then return end
    S.resetCharacter = character
    S.resetInFlight = true
    S.antiStompReady = false
    S.lastResetAt = os.clock()
    S.autoKill = false
    S.autoKillGeneration = S.autoKillGeneration + 1
    style(AutoKillBtn, false, "AUTO KILL SELECTED: ON", "AUTO KILL SELECTED: OFF")
    captureDeathPosition(character)
    local ok = pcall(function() main:FireServer("ResetNew") end)
    if not ok then
        S.resetCharacter = nil
        S.resetInFlight = false
        S.antiStompReady = hum.Health > 0
        say("Anti stomp: reset request failed.")
        return
    end
    say("Anti stomp: one reset requested (" .. reason .. ").")
    task.spawn(function()
        -- Earlier working versions paired ResetNew with a short retry and a
        -- local death transition if the same downed rig stayed at zero HP.
        local started = os.clock()
        local shortRetrySent = false
        local forcedLocalDeath = false
        local attempts = 1
        local nextRetryAt = os.clock() + 3.6
        while not S.closed and Me.Character == character
            and S.resetCharacter == character do
            local hum = character:FindFirstChildOfClass("Humanoid")
            local effects = character:FindFirstChild("BodyEffects")
            local ko = effects and effects:FindFirstChild("K.O")
            local dead = effects and effects:FindFirstChild("Dead")
            if not shortRetrySent and os.clock() - started >=
                (hum and hum.Health <= 0 and 0.12 or 0.35)
                and ownDangerReason(character) then
                shortRetrySent = true
                attempts = attempts + 1
                pcall(function() main:FireServer("ResetNew") end)
            end
            if not forcedLocalDeath and os.clock() - started >= 0.65
                and hum and hum.Health <= 1 and ko and ko.Value
                and not (dead and dead.Value)
                and hum:GetState() ~= Enum.HumanoidStateType.Dead then
                forcedLocalDeath = true
                pcall(function()
                    hum:ChangeState(Enum.HumanoidStateType.Dead)
                    character:BreakJoints()
                end)
                say("Anti stomp: forced downed character death.")
            end
            if hum and hum.Health > 0 and not (ko and ko.Value)
                and not (dead and dead.Value)
                and not ownDangerReason(character)
                and os.clock() - S.lastResetAt >= 3.6 then
                S.resetInFlight = false
                S.resetCharacter = nil
                S.antiStompReady = true
                say("Anti stomp: character safe; protection re-armed.")
                return
            end
            if hum and hum.Health > 0 and ownDangerReason(character)
                and os.clock() >= nextRetryAt then
                attempts = attempts + 1
                nextRetryAt = os.clock() + 3.6
                pcall(function() main:FireServer("ResetNew") end)
                say("Anti stomp: reset retry " .. attempts .. " (still " .. reason .. ").")
            end
            task.wait(0.05)
        end
    end)
end
local OwnCharacterGeneration = 0
ExtraUI.ensureMacro = function(character)
    if not S.macroLock or S.closed or Me.Character ~= character then return end
    local enabled = ExtraUI.macroEnabled
    if not enabled or not enabled.Parent then return end
    local battle = ReplicatedStorage:FindFirstChild("Storage")
    battle = battle and battle:FindFirstChild("GameValues")
    battle = battle and battle:FindFirstChild("BattleRoyale")
    if Me:GetAttribute("DuelNoMacro") or (battle and battle.Value) then return end
    if not enabled.Value then pcall(function() enabled.Value = true end) end
end
local function watchOwnCharacter(character)
    disconnectMany(OwnCharacterConnections)
    ExtraUI.macroEnabled = nil
    OwnCharacterConnections[#OwnCharacterConnections + 1] =
        character.ChildAdded:Connect(Rapid.observeGun)
    for _, tool in ipairs(character:GetChildren()) do Rapid.observeGun(tool) end
    task.spawn(function()
        local scripts = character:WaitForChild("Scripts", 12)
        local input = scripts and scripts:WaitForChild("Input", 12)
        local macro = input and (input:FindFirstChild("RealMacroInput")
            or input:FindFirstChild("MacroInput")
            or input:WaitForChild("RealMacroInput", 3))
        local enabled = macro and (macro:FindFirstChild("Enabled")
            or macro:WaitForChild("Enabled", 3))
        if enabled and enabled:IsA("BoolValue") and not S.closed
            and Me.Character == character then
            ExtraUI.macroEnabled = enabled
            OwnCharacterConnections[#OwnCharacterConnections + 1] =
                enabled:GetPropertyChangedSignal("Value"):Connect(function()
                    if S.macroLock and not enabled.Value then
                        task.delay(0.08, function()
                            ExtraUI.ensureMacro(character)
                        end)
                    end
                end)
            ExtraUI.ensureMacro(character)
        end
        local aiming = input and input:WaitForChild("AimingInput", 12)
        if aiming and not S.closed and Me.Character == character then
            ExtraUI.applyGunMods(character)
        end
    end)
    OwnCharacterGeneration = OwnCharacterGeneration + 1
    local generation = OwnCharacterGeneration
    -- A genuinely new model always gets a fresh one-reset latch.
    if S.resetCharacter ~= character then
        S.resetCharacter = nil
        S.resetInFlight = false
        S.lastResetAt = 0
    end
    S.antiStompReady = false
    task.spawn(function()
        local hum = character:WaitForChild("Humanoid", 6)
        if S.closed or Me.Character ~= character or generation ~= OwnCharacterGeneration then return end
        local function evaluate()
            if not S.antiStompReady then
                -- Reloading the script while already injured must not leave
                -- anti stomp unarmed until health happens to exceed 90.
                if not hum or S.resetInFlight then return end
                S.antiStompReady = true
            end
            resetBeforeStomp(character, ownDangerReason(character))
        end
        if hum then
            OwnCharacterConnections[#OwnCharacterConnections + 1] = hum.HealthChanged:Connect(function(health)
                if health <= 0 then captureDeathPosition(character) end
                evaluate()
            end)
            OwnCharacterConnections[#OwnCharacterConnections + 1] = hum.Died:Connect(function()
                captureDeathPosition(character)
                evaluate()
            end)
            OwnCharacterConnections[#OwnCharacterConnections + 1] = hum.StateChanged:Connect(function(_, state)
                if state == Enum.HumanoidStateType.Dead then evaluate() end
            end)
        end
        local effects = character:FindFirstChild("BodyEffects")
            or character:WaitForChild("BodyEffects", 6)
        if S.closed or Me.Character ~= character or generation ~= OwnCharacterGeneration then return end
        if effects then
            local watched = {}
            local function watchFlag(value)
                if watched[value] then return end
                local statusFlag = (value.Name == "K.O" or value.Name == "Dead")
                    and value:IsA("BoolValue")
                local dangerValue = value.Name == "Grabbed" and value:IsA("ObjectValue")
                if not statusFlag and not dangerValue then return end
                watched[value] = true
                OwnCharacterConnections[#OwnCharacterConnections + 1] = value.Changed:Connect(evaluate)
                evaluate()
            end
            for _, value in ipairs(effects:GetChildren()) do watchFlag(value) end
            OwnCharacterConnections[#OwnCharacterConnections + 1] = effects.ChildAdded:Connect(watchFlag)
        end
        evaluate()
    end)
end
bind(ExtraUI.MacroBtn.MouseButton1Click:Connect(function()
    S.macroLock = not S.macroLock
    style(ExtraUI.MacroBtn, S.macroLock,
        "MACRO PERSIST: ON", "MACRO PERSIST: OFF")
    if S.macroLock then ExtraUI.ensureMacro(Me.Character) end
    say(S.macroLock and "Macro persist enabled." or "Macro persist disabled.")
end))

-- Match the game's own StompInput ray, then send its StompRemote arguments.
-- No player-list or Workspace scan runs while this toggle is off.
local function downedPlayerBelow(character)
    local lower = character:FindFirstChild("LowerTorso")
    local upper = character:FindFirstChild("UpperTorso")
    if not lower or not upper then return nil end
    local ignored = {character}
    local blacklisted = Workspace:FindFirstChild("Blacklisted")
    if blacklisted then ignored[#ignored + 1] = blacklisted end
    local ray = Ray.new(lower.Position, Vector3.new(0, -upper.Size.Y * 4.5, 0))
    local hit = Workspace:FindPartOnRayWithIgnoreList(ray, ignored)
    local node = hit
    while node and node ~= Workspace do
        if node:IsA("Model") and node ~= character then
            local victimPlayer = Players:FindFirstChild(node.Name)
            local hum = node:FindFirstChildOfClass("Humanoid")
            local effects = node:FindFirstChild("BodyEffects")
            local ko = effects and effects:FindFirstChild("K.O")
            local dead = effects and effects:FindFirstChild("Dead")
            local knocked = ko and ko:IsA("BoolValue") and ko.Value
            local finished = dead and dead:IsA("BoolValue") and dead.Value
            if victimPlayer and victimPlayer ~= Me and hum
                and (knocked or finished or hum.Health <= 0) then
                return node
            end
        end
        node = node.Parent
    end
    return nil
end
local function autoStompTick(expectedModel, allowSelected)
    if os.clock() < NextAutoStompAt then return end
    local character = Me.Character
    if not character or not character:FindFirstChild("FULLY_LOADED_CHAR")
        or character:FindFirstChildOfClass("ForceField")
        or character:FindFirstChild("GRABBING_CONSTRAINT") then return end
    local effects = character:FindFirstChild("BodyEffects")
    local ownKO = effects and effects:FindFirstChild("K.O")
    local grabbed = effects and effects:FindFirstChild("Grabbed")
    local firing = effects and effects:FindFirstChild("GunFiring")
    local backpack = Me:FindFirstChildOfClass("Backpack")
    if not effects or (ownKO and ownKO.Value)
        or (grabbed and grabbed.Value ~= nil)
        or (firing and firing.Value)
        or (backpack and backpack:FindFirstChild("Fly")) then return end

    local victim = expectedModel or downedPlayerBelow(character)
    if not victim then return end

    local lower = character:FindFirstChild("LowerTorso")
    local victimLower = victim:FindFirstChild("LowerTorso")
    local victimHumanoid = victim:FindFirstChildOfClass("Humanoid")
    if not lower or not victimLower or not victimHumanoid
        or (victimLower.Position - lower.Position).Magnitude > 8 then return end

    local storage = ReplicatedStorage:FindFirstChild("Storage")
    local remotes = storage and storage:FindFirstChild("Remotes")
    local main = remotes and remotes:FindFirstChild("Main")
    local animations = storage and storage:FindFirstChild("Animations")
    local stompAnimation = animations and animations:FindFirstChild("Stomp")
    local handler = game:GetService("ReplicatedFirst"):FindFirstChild("Handler")
    local infoModule = handler and handler:FindFirstChild("Info")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
    if not main or not main:IsA("RemoteEvent") or not stompAnimation
        or not infoModule or not animator then return end

    if AutoStompTrackCharacter ~= character or not AutoStompTrack then
        AutoStompTrackCharacter = character
        AutoStompTrack = animator:LoadAnimation(stompAnimation)
    end
    local proof = require(infoModule):CheckCredibility()
    if proof ~= true then return end

    if S.stompAnimationEnabled then
        AutoStompTrack:Play(0, 1, 5)
    else
        AutoStompTrack:Stop(0)
    end
    local victimEffects = victim:FindFirstChild("BodyEffects")
    local victimKO = victimEffects and victimEffects:FindFirstChild("K.O")
    local victimDead = victimEffects and victimEffects:FindFirstChild("Dead")
    local stillStompable = (victimKO and victimKO.Value)
        or (victimDead and victimDead.Value) or victimHumanoid.Health <= 0
    if S.closed or not (S.autoStomp or allowSelected) or Me.Character ~= character
        or not victimHumanoid.Parent or not stillStompable then return end
    main:FireServer("StompRemote", AutoStompTrack, effects, victimHumanoid, proof)
    NextAutoStompAt = os.clock() + S.stompPace * 0.75
    return true
end
local function updateAutoStomp()
    AutoStompGeneration = AutoStompGeneration + 1
    local generation = AutoStompGeneration
    if not S.autoStomp then return end
    NextAutoStompAt = 0
    task.spawn(function()
        while not S.closed and S.autoStomp and generation == AutoStompGeneration do
            local ok = pcall(autoStompTick)
            if not ok then
                S.autoStomp = false
                style(AutoStompBtn, false, "AUTO STOMP: ON", "AUTO STOMP: OFF")
                say("Auto stomp stopped after a raycast or remote error.")
                break
            end
            task.wait(math.min(0.05, S.stompPace * 0.75))
        end
    end)
end

refreshArmorShops()
updateOwnRoot()
bind(Me.CharacterAdded:Connect(function(character)
    -- One retry after spawn, rather than polling our character every frame.
    task.delay(0.25, function() if not S.closed then updateOwnRoot() end end)
    watchOwnCharacter(character)
    ExtraUI.runSpawnSequence(character)
end))
bind(Me.CharacterRemoving:Connect(function(character)
    local hum = character:FindFirstChildOfClass("Humanoid")
    if hum and hum.Health <= 0 then captureDeathPosition(character) end
    OwnRoot = nil
    OwnCharacterGeneration = OwnCharacterGeneration + 1
    disconnectMany(OwnCharacterConnections)
end))
if Me.Character then watchOwnCharacter(Me.Character) end

local SafeCharacter = nil
local LastSafeCFrame = nil
local NextVoidCheck = 0
bind(RunService.Heartbeat:Connect(function()
    if S.closed or not S.antiVoid or S.voidBlinking
        or os.clock() < NextVoidCheck then return end
    NextVoidCheck = os.clock() + 0.05
    local character = Me.Character
    if character ~= SafeCharacter then
        SafeCharacter, LastSafeCFrame = character, nil
    end
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local hum = character and character:FindFirstChildOfClass("Humanoid")
    if not root or not hum or hum.Health <= 0 then return end
    if root.Position.Y > -35 then
        LastSafeCFrame = root.CFrame
    elseif root.Position.Y < -45 then
        pcall(function()
            character:PivotTo(LastSafeCFrame
                or CFrame.new(root.Position.X, 12, root.Position.Z))
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end)
    end
end))

local function validModel(model)
    if not model or not model:IsA("Model") or not model:IsDescendantOf(Workspace) then return nil end
    local hum = model:FindFirstChildOfClass("Humanoid")
    local root = model:FindFirstChild("HumanoidRootPart", true)
    if not hum or not root or not root:IsA("BasePart") then return nil end
    return {
        model = model, humanoid = hum, root = root,
        head = model:FindFirstChild("Head", true),
    }
end
local function recordPresent(p, rec)
    return p and TargetSet[p] and p.Parent == Players and rec
        and rec.model.Parent and rec.root.Parent and rec.humanoid.Parent
end
local function alive(rec, requireAlive)
    if not rec then return false end
    if not requireAlive then return true end
    if rec.humanoid.Parent == nil or rec.humanoid.Health <= 0 then return false end
    local effects = rec.model:FindFirstChild("BodyEffects")
    local ko = effects and effects:FindFirstChild("K.O")
    local dead = effects and effects:FindFirstChild("Dead")
    return not ((ko and ko.Value) or (dead and dead.Value))
end
local function partFor(rec)
    if S.head and rec.head and rec.head.Parent and rec.head:IsA("BasePart") then return rec.head end
    return rec.root
end
local function predictedPoint(rec, part, lead)
    -- The root's velocity tracks translation; head velocity can include animation jitter.
    return part.Position + rec.root.AssemblyLinearVelocity * lead
end
local function isFolder(parent)
    if not (parent:IsA("Folder") or parent:IsA("Model")) then return false end
    local name = parent.Name
    return name == "Players" or name == "Characters" or name == "Live"
        or name == "Entities" or (#name >= 30 and name:find("%-") ~= nil)
end
local function candidateNamed(parent, player)
    if not parent or not player then return nil end
    return parent:FindFirstChild(player.Name)
        or parent:FindFirstChild(tostring(player.UserId))
end

local PreviousHook = Env.__SPECTRA_MULTI_RAYCAST
if type(PreviousHook) == "table" then PreviousHook.enabled = false end
local Hook = {
    installed = false, enabled = false, part = nil, record = nil,
    lockPlayer = nil, lockRecord = nil,
    manager = nil, original = nil, wrapper = nil,
    damageOriginal = nil, damageWrapper = nil,
    lead = S.lead, aliveOnly = S.aliveOnly, wallBang = false,
}
Env.__SPECTRA_MULTI_RAYCAST = Hook

-- This game routes weapon shots through GunManager:Raycast. Change only that
-- shot's aim point, then let the game's own raycast handle walls and hit parts.
local function installRaycastHook()
    if Hook.installed and Hook.manager and Hook.manager.Raycast == Hook.wrapper then return true end
    local storage = ReplicatedStorage:FindFirstChild("Storage")
    local modules = storage and storage:FindFirstChild("Modules")
    local dialect = modules and modules:FindFirstChild("Dialect")
    local module = dialect and dialect:FindFirstChild("GunManager")
    if not module then return false, "GunManager is not loaded yet; try again." end
    local ok, manager = pcall(require, module)
    if not ok or type(manager) ~= "table" or type(manager.Raycast) ~= "function" then
        return false, "Could not access this game's gun raycast."
    end
    local original = manager.Raycast
    local function redirect(self, tool, mousePoint, player, range, ...)
        if self == manager and (Hook.enabled or S.autoKill or S.forceHit) and player == Me
            and tool and tool:IsA("Tool") and tool.Parent == Me.Character then
            local lockedPlayer = S.autoKill and Hook.lockPlayer or nil
            local forcedPlayer = S.forceHit and S.primary or nil
            local selectedPlayer = lockedPlayer or forcedPlayer or S.aimPlayer
            local directTarget = lockedPlayer or forcedPlayer
            local rec = directTarget and Records[selectedPlayer] or Hook.record
            local part = directTarget and rec and partFor(rec) or Hook.part
            if rec and part and part.Parent and recordPresent(selectedPlayer, rec)
                and alive(rec, Hook.aliveOnly) then
                local handle = tool:FindFirstChild("Handle")
                if handle and handle:IsA("BasePart")
                    and handle:FindFirstChild("ShootFXGui") then
                    local point = predictedPoint(rec, part, Hook.lead)
                    local maxRange = typeof(range) == "number" and range or 200
                    local directHit = S.forceHit or (S.autoKill and S.quietAutoKill)
                    if directHit or (point - handle.Position).Magnitude <= maxRange then
                        mousePoint = point
                        if (directHit or Hook.wallBang) and rec.model
                            and part:IsDescendantOf(rec.model) then
                            local origin = handle.Position
                                + handle.CFrame:VectorToWorldSpace(
                                    handle.ShootFXGui.StudsOffsetWorldSpace)
                            local direction = point - origin
                            if direction.Magnitude > 0.01 then
                                return {
                                    Instance = part,
                                    Position = point,
                                    Normal = -direction.Unit,
                                    Material = part.Material,
                                }
                            end
                        end
                    end
                end
            end
        end
        return original(self, tool, mousePoint, player, range, ...)
    end
    local assigned = pcall(function() manager.Raycast = redirect end)
    if not assigned or manager.Raycast ~= redirect then
        return false, "Could not install the gun-specific aim path."
    end
    Hook.manager, Hook.original, Hook.wrapper = manager, original, redirect
    Hook.installed = true
    if type(manager.ReconcileDamageBatch) == "function" then
        local damageOriginal = manager.ReconcileDamageBatch
        local function readServerHit(self, predictions, response, ...)
            if self == manager and type(predictions) == "table" then
                local first = predictions[1]
                local state = first and first.State
                if state and typeof(response) == "table"
                    and typeof(response.Health) == "number"
                    and typeof(response.Revision) == "number"
                    and response.Revision >= (state.Revision or -math.huge) then
                    local oldHealth = state.ServerHealth or response.Health
                    local oldArmor = state.ServerArmor or response.Armor or 0
                    local newArmor = typeof(response.Armor) == "number"
                        and response.Armor or oldArmor
                    local healthDamage = math.max(0, oldHealth - response.Health)
                    local armorDamage = math.max(0, oldArmor - newArmor)
                    if healthDamage + armorDamage > 0 then
                        Rapid.noteConfirmed(S.lastAttemptWeaponName)
                    end
                    if healthDamage + armorDamage > 0 and S.autoKill
                        and Hook.lockRecord and state.Humanoid == Hook.lockRecord.humanoid then
                        S.lastConfirmedHitAt = os.clock()
                    end
                    local victim = state.Humanoid and state.Humanoid.Parent
                    local name = victim and victim.Name or "target"
                    ExtraUI.ServerHit.Text = ("SERVER HIT: %s  H -%.1f  A -%.1f")
                        :format(name, healthDamage, armorDamage)
                    ExtraUI.ServerHit.TextColor3 = (healthDamage + armorDamage > 0)
                        and C_ACCENT or C_FAINT
                end
            end
            return damageOriginal(self, predictions, response, ...)
        end
        local assignedDamage = pcall(function() manager.ReconcileDamageBatch = readServerHit end)
        if assignedDamage and manager.ReconcileDamageBatch == readServerHit then
            Hook.damageOriginal, Hook.damageWrapper = damageOriginal, readServerHit
        end
    end
    return true
end
task.defer(function()
    if not S.closed then installRaycastHook() end
end)

local function clearTarget()
    S.aimPlayer, S.aimRecord = nil, nil
    S.screenDistance2, S.permitted = math.huge, false
    Hook.part, Hook.record = nil, nil
    Hook.enabled = false
    if ActiveLabel.Text ~= "Aim target: none" then ActiveLabel.Text = "Aim target: none" end
end
local function stopBring()
    if S.bring then
        for part, oldAnchored in pairs(S.bring) do
            if part.Parent then pcall(function() part.Anchored = oldAnchored end) end
        end
        S.bring = nil
    end
    style(Bring, false, "BRING SELECTED: ON", "BRING SELECTED")
end
local function syncLabels()
    local count = #TargetList
    SelectedLabel.Text = ("Targets: %d/%d  |  Last: %s"):format(count, MAX_TARGETS,
        S.primary and ("@" .. S.primary.Name) or "none")
end
local function invalidatePlayer(p)
    Records[p] = nil
    if S.aimPlayer == p then clearTarget() end
    if S.primary == p and S.bring then stopBring() end
end
local function applyRecord(p, rec)
    if S.closed or not TargetSet[p] then return end
    local old = Records[p]
    if old and old.model ~= (rec and rec.model or nil) then
        if S.primary == p and S.bring then stopBring() end
        if S.aimPlayer == p then clearTarget() end
    end
    Records[p] = rec
end
local function findRecordInWorkspace(p, token)
    -- Cooperative, bounded one-off search. Yield after 18 containers so selecting
    -- someone cannot stall a frame in servers with lots of GUID folders.
    local rec = validModel(p.Character)
    if not rec then rec = validModel(candidateNamed(Workspace, p)) end
    if rec then return rec end
    local steps = 0
    for folder in pairs(Folders) do
        if S.closed or not TargetSet[p] or ResolutionTokens[p] ~= token then return nil end
        if folder.Parent == Workspace then
            rec = validModel(candidateNamed(folder, p))
            if rec then return rec end
        end
        steps = steps + 1
        if steps % 18 == 0 then task.wait() end
    end
    return nil
end
local function requestResolution(p)
    if not p or not TargetSet[p] or S.closed then return end
    NextResolutionToken = NextResolutionToken + 1
    ResolutionTokens[p] = NextResolutionToken
    local token = NextResolutionToken
    task.spawn(function()
        for attempt = 1, 3 do
            if S.closed or not TargetSet[p] or ResolutionTokens[p] ~= token then return end
            local rec = findRecordInWorkspace(p, token)
            if S.closed or not TargetSet[p] or ResolutionTokens[p] ~= token then return end
            if rec then applyRecord(p, rec); return end
            if attempt == 1 then task.wait(0.22)
            elseif attempt == 2 then task.wait(0.70) end
        end
        -- No automatic whole-server retry. CharacterAdded / GUID ChildAdded
        -- or the manual Refresh button starts a new one-off resolution.
        applyRecord(p, nil)
    end)
end
local function watchFolder(folder)
    if Folders[folder] or not isFolder(folder) then return end
    Folders[folder] = folder.ChildAdded:Connect(function(child)
        local p = TargetByModelName[child.Name]
        if p then requestResolution(p) end
    end)
    -- Some replicated folders arrive with their model children already attached.
    -- Inspect only selected names, one time when that container appears.
    for i = 1, #TargetList do
        local p = TargetList[i]
        if not recordPresent(p, Records[p]) and candidateNamed(folder, p) then
            requestResolution(p)
        end
    end
end
local function unwatchFolder(folder)
    local connection = Folders[folder]
    if connection then connection:Disconnect(); Folders[folder] = nil end
    for i = 1, #TargetList do
        local p = TargetList[i]
        local rec = Records[p]
        if rec and rec.model.Parent == folder then invalidatePlayer(p) end
    end
end
-- The only shallow Workspace snapshot occurs on startup; no periodic scan.
for _, child in ipairs(Workspace:GetChildren()) do watchFolder(child) end
bind(Workspace.ChildAdded:Connect(function(child)
    if isFolder(child) then watchFolder(child) end
    local p = TargetByModelName[child.Name]
    if p then requestResolution(p) end
end))
bind(Workspace.ChildRemoved:Connect(unwatchFolder))

local function deselectPlayer(p)
    if not TargetSet[p] then return end
    TargetSet[p] = nil
    TargetByModelName[p.Name] = nil
    TargetByModelName[tostring(p.UserId)] = nil
    ResolutionTokens[p] = nil -- cancels pending cooperative searches, no stale references
    local cs = PlayerConnections[p]
    if cs then disconnectMany(cs); PlayerConnections[p] = nil end
    for i = #TargetList, 1, -1 do
        if TargetList[i] == p then table.remove(TargetList, i); break end
    end
    invalidatePlayer(p)
    if Rows[p] then Rows[p].BackgroundColor3 = C_OFF end
    if S.primary == p then
        if S.bring then stopBring() end
        S.primary = TargetList[#TargetList]
    end
end
local function addTarget(p, knownRecord)
    if TargetSet[p] then
        if knownRecord then applyRecord(p, knownRecord) end
        return true
    end
    if #TargetList >= MAX_TARGETS then
        say("FPS guard: maximum " .. MAX_TARGETS .. " selected players.")
        return false
    end
    TargetSet[p] = true
    TargetList[#TargetList + 1] = p
    TargetByModelName[p.Name] = p
    TargetByModelName[tostring(p.UserId)] = p
    local cs = {
        p.CharacterAdded:Connect(function() requestResolution(p) end),
        p.CharacterRemoving:Connect(function() invalidatePlayer(p) end),
    }
    PlayerConnections[p] = cs
    if Rows[p] then Rows[p].BackgroundColor3 = C_SELECTED end
    if knownRecord then
        applyRecord(p, knownRecord)
    else
        requestResolution(p)
    end
    return true
end
local function choosePlayer(p, knownRecord)
    if S.closed or p == Me or (p and p.Parent ~= Players) then return end
    if not S.multi then
        if #TargetList == 1 and TargetSet[p] then
            if knownRecord then applyRecord(p, knownRecord) end
            S.primary = p
            syncLabels()
            return
        end
        -- Single mode: click chooses exactly one player.
        for i = #TargetList, 1, -1 do deselectPlayer(TargetList[i]) end
        if p and addTarget(p, knownRecord) then S.primary = p end
    else
        -- Multi mode: click toggles membership, never processes unselected players.
        if p then
            if TargetSet[p] then deselectPlayer(p)
            elseif addTarget(p, knownRecord) then S.primary = p end
        end
    end
    syncLabels()
    if updateLoops then updateLoops() end
    say(#TargetList > 0 and ("Checking only " .. #TargetList .. " selected Workspace model(s).")
        or "Idle: choose a player; no character checks active.")
end

local Picking = false
local function pickNearCursor()
    local cam = Workspace.CurrentCamera
    if not cam then say("Cursor pick: camera unavailable."); return end
    local cursor = UIS:GetMouseLocation()
    if UIS.MouseBehavior == Enum.MouseBehavior.LockCenter then
        cursor = cam.ViewportSize * 0.5
    end
    local radius = 100
    local bestPlayer, bestRecord, bestDistance2 = nil, nil, radius * radius
    local ownFolder = Me.Character and Me.Character.Parent
    -- A one-off lookup only when the key is pressed. The current GUID folder is
    -- checked first, then the already-watched containers if needed.
    local folderChecks = 0
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Me then
            local rec = Records[player]
            if not recordPresent(player, rec) then
                rec = validModel(player.Character)
                    or validModel(candidateNamed(ownFolder, player))
                if not rec then
                    for folder in pairs(Folders) do
                        if folder.Parent == Workspace then
                            rec = validModel(candidateNamed(folder, player))
                            if rec then break end
                        end
                        folderChecks = folderChecks + 1
                        if folderChecks % 16 == 0 then
                            task.wait()
                            if S.closed then return end
                        end
                    end
                end
            end
            if rec and alive(rec, S.aliveOnly) then
                local part = partFor(rec)
                if part and part.Parent then
                    local point, onScreen = cam:WorldToViewportPoint(part.Position)
                    if onScreen and point.Z > 0 then
                        local dx, dy = point.X - cursor.X, point.Y - cursor.Y
                        local distance2 = dx * dx + dy * dy
                        if distance2 < bestDistance2 then
                            bestPlayer, bestRecord, bestDistance2 = player, rec, distance2
                        end
                    end
                end
            end
        end
    end
    if not bestPlayer then
        say("Cursor pick: no living player within " .. radius .. "px.")
        return
    end
    if bestPlayer.Parent ~= Players or not bestRecord.model.Parent then return end
    if TargetSet[bestPlayer] then
        deselectPlayer(bestPlayer)
        syncLabels()
        updateLoops()
        say("Cursor pick: @" .. bestPlayer.Name .. " unselected.")
        return
    end
    -- Q explicitly selects a visible marker even if the dot was previously off.
    if not S.dot then
        S.dot = true
        style(DotBtn, true, "BOX + LINE: ON", "BOX + LINE: OFF")
    end
    if S.multi then
        if not TargetSet[bestPlayer] and not addTarget(bestPlayer, bestRecord) then return end
        S.primary = bestPlayer
        applyRecord(bestPlayer, bestRecord)
        syncLabels()
        updateLoops()
    else
        choosePlayer(bestPlayer, bestRecord)
    end
    if not RenderConnection then updateLoops() end
    -- Do the first selection immediately; the periodic loop maintains it.
    targetTick()
    say("Cursor pick: @" .. bestPlayer.Name .. " selected.")
end

-- Stable row instances: search only toggles visibility; no recreating UI.
local function filterRows()
    local query = Search.Text:lower()
    for p, row in pairs(Rows) do
        local matched = p.Name:lower():find(query, 1, true)
            or p.DisplayName:lower():find(query, 1, true)
        row.Visible = matched ~= nil and matched ~= false
    end
end
local function renumberRows()
    local all = {}
    for p in pairs(Rows) do all[#all + 1] = p end
    table.sort(all, function(a, b) return a.Name:lower() < b.Name:lower() end)
    for i, p in ipairs(all) do Rows[p].LayoutOrder = i end
end
local function addRow(p)
    if p == Me or Rows[p] then return end
    local row = round(make("TextButton", {
        Parent = List, Name = p.Name, Size = UDim2.new(1, -2, 0, 29),
        Text = "  " .. p.DisplayName .. " (@" .. p.Name .. ")",
        TextColor3 = C_TEXT, TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Gotham, TextSize = 11, BorderSizePixel = 0,
        BackgroundColor3 = TargetSet[p] and C_SELECTED or C_OFF,
    }), 5)
    Rows[p] = row
    RowConnections[p] = row.MouseButton1Click:Connect(function()
        if p.Parent == Players then choosePlayer(p) end
    end)
    filterRows()
end
local function removeRow(p)
    if TargetSet[p] then
        deselectPlayer(p)
        syncLabels()
        if updateLoops then updateLoops() end
    end
    if RowConnections[p] then RowConnections[p]:Disconnect(); RowConnections[p] = nil end
    if Rows[p] then Rows[p]:Destroy(); Rows[p] = nil end
end
for _, player in ipairs(Players:GetPlayers()) do addRow(player) end
renumberRows()
bind(Players.PlayerAdded:Connect(function(p) addRow(p); renumberRows() end))
bind(Players.PlayerRemoving:Connect(function(p) removeRow(p); renumberRows() end))
bind(Search:GetPropertyChangedSignal("Text"):Connect(filterRows))

local WallParams = RaycastParams.new()
WallParams.FilterType = Enum.RaycastFilterType.Exclude
WallParams.IgnoreWater = true
local WallModel = nil
local function withinWallLine(cam, part, rec)
    if not S.wall or S.wallBang or S.forceHit then return true end
    local ownModel = Me.Character
    if WallModel ~= ownModel then
        WallModel = ownModel
        local ignored = {}
        if ownModel then ignored[#ignored + 1] = ownModel end
        local blacklisted = Workspace:FindFirstChild("Blacklisted")
        if blacklisted then ignored[#ignored + 1] = blacklisted end
        WallParams.FilterDescendantsInstances = ignored
    end
    local origin = cam.CFrame.Position
    if S.silent and ownModel then
        local tool = ownModel:FindFirstChildOfClass("Tool")
        local handle = tool and tool:FindFirstChild("Handle")
        local fx = handle and handle:FindFirstChild("ShootFXGui")
        if handle and handle:IsA("BasePart") and fx and fx:IsA("BillboardGui") then
            origin = handle.Position + handle.CFrame:VectorToWorldSpace(fx.StudsOffsetWorldSpace)
        end
    end
    local ok, hit = pcall(Workspace.Raycast, Workspace, origin, part.Position - origin, WallParams)
    return ok and (not hit or hit.Instance:IsDescendantOf(rec.model))
end
local function center(cam)
    if UIS.MouseBehavior == Enum.MouseBehavior.LockCenter then
        local size = cam.ViewportSize
        return size.X * 0.5, size.Y * 0.5
    end
    local point = UIS:GetMouseLocation()
    return point.X, point.Y
end
targetTick = function()
    local cam = Workspace.CurrentCamera
    if not cam or #TargetList == 0 then clearTarget(); return end
    local cx, cy = center(cam)
    local firstP, secondP, firstRec, secondRec, firstPart, secondPart
    local firstPoint, secondPoint
    local firstScore, secondScore = math.huge, math.huge
    for i = 1, #TargetList do
        local p = TargetList[i]
        local rec = Records[p]
        if recordPresent(p, rec) and alive(rec, S.aliveOnly) then
            local part = partFor(rec)
            if part and part.Parent then
                local projected, onScreen = cam:WorldToViewportPoint(predictedPoint(rec, part, S.lead))
                if onScreen and projected.Z > 0 then
                    local dx, dy = projected.X - cx, projected.Y - cy
                    local distance2 = dx * dx + dy * dy
                    do
                        -- Slightly prefer the existing target to avoid flicker.
                        local score = distance2 * (S.aimPlayer == p and 0.78 or 1)
                        if score < firstScore then
                            secondP, secondRec, secondPart, secondPoint, secondScore =
                                firstP, firstRec, firstPart, firstPoint, firstScore
                            firstP, firstRec, firstPart, firstPoint, firstScore =
                                p, rec, part, projected, score
                        elseif score < secondScore then
                            secondP, secondRec, secondPart, secondPoint, secondScore =
                                p, rec, part, projected, score
                        end
                    end
                end
            end
        end
    end
    -- No raycast at all unless wall checking is enabled; maximum TWO when on.
    local p, rec, part, projected
    if firstRec and withinWallLine(cam, firstPart, firstRec) then
        p, rec, part, projected = firstP, firstRec, firstPart, firstPoint
    elseif secondRec and withinWallLine(cam, secondPart, secondRec) then
        p, rec, part, projected = secondP, secondRec, secondPart, secondPoint
    end
    -- Silent aim and force hit follow the explicitly selected player even
    -- when the rig is behind the camera or outside the viewport.
    if not rec and (S.silent or S.forceHit or S.wallBang) then
        local selected = S.primary
        local selectedRecord = selected and Records[selected]
        if recordPresent(selected, selectedRecord)
            and alive(selectedRecord, S.aliveOnly) then
            local selectedPart = partFor(selectedRecord)
            if selectedPart and selectedPart.Parent
                and withinWallLine(cam, selectedPart, selectedRecord) then
                p, rec, part = selected, selectedRecord, selectedPart
                projected = cam:WorldToViewportPoint(
                    predictedPoint(rec, part, S.lead))
            end
        end
    end
    if not rec then clearTarget(); return end
    if S.aimPlayer ~= p then ActiveLabel.Text = "Aim target: @" .. p.Name end
    S.aimPlayer, S.aimRecord = p, rec
    local dx, dy = projected.X - cx, projected.Y - cy
    S.screenDistance2 = dx * dx + dy * dy
    S.permitted = true
    Hook.part = (S.silent or S.wallBang) and part or nil
    Hook.record = (S.silent or S.wallBang) and rec or nil
    Hook.lead = S.lead
    Hook.aliveOnly = S.aliveOnly
    Hook.enabled = S.silent or S.wallBang
end
local function clickMouse()
    if type(mouse1click) == "function" then return pcall(mouse1click) end
    if type(mouse1press) == "function" and type(mouse1release) == "function" then
        if TriggerPressed then return false end
        local ok = pcall(mouse1press)
        if not ok then return false end
        TriggerPressed = true
        task.delay(0.025, function()
            pcall(mouse1release)
            TriggerPressed = false
        end)
        return true
    end
    return false
end
local Mouse = Me:GetMouse()
local function triggerTick()
    if not S.trigger or #TargetList == 0 or UIS:GetFocusedTextBox() then return end
    local shoot = false
    local hit = Mouse.Target
    if hit then
        for i = 1, #TargetList do
            local p = TargetList[i]
            local rec = Records[p]
            if recordPresent(p, rec) and alive(rec, S.aliveOnly)
                and hit:IsDescendantOf(rec.model) then
                shoot = true
                break
            end
        end
    end
    if not shoot then return end
    if not clickMouse() then
        S.trigger = false
        style(Trigger, false, "TRIGGER: ON", "TRIGGER: OFF")
        say("Trigger click unsupported by this executor.")
        updateLoops()
    end
end

-- No Heartbeat callback: one scheduled coroutine only while enabled.
    -- Refresh selected target while firing features are active.
updateLoops = function()
    local needTarget = #TargetList > 0 and (S.silent or S.forceHit or S.wallBang
        or S.trigger or S.cameraAim or S.dot)
    TickGeneration = TickGeneration + 1
    local generation = TickGeneration
    if needTarget then
        task.spawn(function()
            while not S.closed and generation == TickGeneration do
                targetTick()
                if S.trigger then triggerTick() end
                task.wait(S.trigger and 0.01 or (S.silent and 0.05 or 0.10))
            end
        end)
    else
        clearTarget()
    end
    -- The selected target's box and tracer are rendered by renderEsp.
    if S.cameraAim and #TargetList > 0 and not RenderConnection then
        RenderConnection = RunService.RenderStepped:Connect(function(dt)
            local rec = S.aimRecord
            if S.closed or not S.permitted or not rec or not alive(rec, S.aliveOnly) then
                return
            end
            local cam = Workspace.CurrentCamera
            local part = partFor(rec)
            if not cam or not part or not part.Parent then return end
            local aimPoint = predictedPoint(rec, part, S.lead)
            local from = cam.CFrame
            local goal = CFrame.lookAt(from.Position, aimPoint)
            cam.CFrame = from:Lerp(goal, 1 - math.exp(-12 * math.min(dt, 0.07)))
        end)
    elseif RenderConnection then
        RenderConnection:Disconnect()
        RenderConnection = nil
    end
end

bind(MultiBtn.MouseButton1Click:Connect(function()
    S.multi = not S.multi
    if not S.multi and #TargetList > 1 then
        local keep = S.primary or TargetList[1]
        for i = #TargetList, 1, -1 do
            if TargetList[i] ~= keep then deselectPlayer(TargetList[i]) end
        end
    end
    style(MultiBtn, S.multi, "MULTI TARGET: ON", "MULTI TARGET: OFF")
    syncLabels()
    updateLoops()
    say(S.multi and "Multi: click player rows to add/remove (max 6)."
        or "Single: click a row to choose one player.")
end))
bind(AliveBtn.MouseButton1Click:Connect(function()
    S.aliveOnly = not S.aliveOnly
    Hook.aliveOnly = S.aliveOnly
    style(AliveBtn, S.aliveOnly, "ALIVE CHECK: ON", "ALIVE CHECK: OFF")
    if S.silent or S.wallBang or S.trigger or S.cameraAim or S.dot then targetTick() end
end))
bind(Silent.MouseButton1Click:Connect(function()
    if not S.silent then
        local ok, reason = installRaycastHook()
        if not ok then say(reason); return end
    end
    S.silent = not S.silent
    Hook.enabled = (S.silent or S.wallBang) and S.aimRecord ~= nil
    if not S.silent and not S.wallBang then Hook.part, Hook.record = nil, nil end
    style(Silent, S.silent, "SILENT AIM: ON", "SILENT AIM: OFF")
    updateLoops()
end))
bind(WallBangBtn.MouseButton1Click:Connect(function()
    if not S.wallBang then
        local ok, reason = installRaycastHook()
        if not ok then say(reason); return end
    end
    S.wallBang = not S.wallBang
    Hook.wallBang = S.wallBang
    Hook.enabled = (S.silent or S.wallBang) and S.aimRecord ~= nil
    if not S.silent and not S.wallBang then Hook.part, Hook.record = nil, nil end
    style(WallBangBtn, S.wallBang, "WALLBANG: ON", "WALLBANG: OFF")
    updateLoops()
    say(S.wallBang and "Wallbang routes selected-target shots through cover."
        or "Wallbang disabled.")
end))
bind(ForceHitBtn.MouseButton1Click:Connect(function()
    if not S.forceHit then
        local ok, reason = installRaycastHook()
        if not ok then say(reason); return end
        if not S.primary then say("Select a player on TARGETS first."); return end
        if not recordPresent(S.primary, Records[S.primary]) then
            requestResolution(S.primary)
            say("Force hit: resolving selected player's live rig; try again shortly.")
            return
        end
    end
    S.forceHit = not S.forceHit
    style(ForceHitBtn, S.forceHit, "FORCE HIT: ON", "FORCE HIT: OFF")
    updateLoops()
    say(S.forceHit and "Force hit targets the selected player at any client distance."
        or "Force hit disabled.")
end))
bind(ExtraUI.QuietKillBtn.MouseButton1Click:Connect(function()
    S.quietAutoKill = not S.quietAutoKill
    style(ExtraUI.QuietKillBtn, S.quietAutoKill,
        "QUIET AUTO KILL: ON", "QUIET AUTO KILL: OFF")
    say(S.quietAutoKill and "Auto kill fires from your current position."
        or "Auto kill strafing enabled.")
end))
bind(Trigger.MouseButton1Click:Connect(function()
    if not S.trigger and type(mouse1click) ~= "function"
        and not (type(mouse1press) == "function" and type(mouse1release) == "function") then
        say("Trigger needs an executor mouse-click function.")
        return
    end
    S.trigger = not S.trigger
    style(Trigger, S.trigger, "TRIGGER: ON", "TRIGGER: OFF")
    updateLoops()
end))
bind(CameraBtn.MouseButton1Click:Connect(function()
    S.cameraAim = not S.cameraAim
    style(CameraBtn, S.cameraAim, "CAMERA AIM: ON", "CAMERA AIM: OFF")
    updateLoops()
end))
bind(DotBtn.MouseButton1Click:Connect(function()
    S.dot = not S.dot
    style(DotBtn, S.dot, "BOX + LINE: ON", "BOX + LINE: OFF")
    updateLoops()
end))
bind(Hitbox.MouseButton1Click:Connect(function()
    S.head = not S.head
    Hitbox.Text = S.head and "HITBOX: HEAD" or "HITBOX: BODY"
    if S.silent or S.trigger or S.dot or S.cameraAim then targetTick() end
end))
bind(Wall.MouseButton1Click:Connect(function()
    S.wall = not S.wall
    style(Wall, S.wall, "WALL CHECK: ON", "WALL CHECK: OFF")
    if S.silent or S.trigger or S.dot or S.cameraAim then targetTick() end
end))
bind(CursorToggle.MouseButton1Click:Connect(function()
    S.cursorKeyEnabled = not S.cursorKeyEnabled
    style(CursorToggle, S.cursorKeyEnabled, "CURSOR PICK: ON", "CURSOR PICK: OFF")
    say(S.cursorKeyEnabled and "Cursor selection enabled. Press Q near a player."
        or "Cursor selection disabled.")
end))
local function startCursorPick()
    if not S.cursorKeyEnabled or Picking then return end
    Picking = true
    task.spawn(function()
        local ok = pcall(pickNearCursor)
        Picking = false
        if not ok and not S.closed then say("Cursor pick failed; try Refresh Targets.") end
    end)
end
bind(CursorPick.MouseButton1Click:Connect(startCursorPick))
bind(UIS.InputBegan:Connect(function(input, processed)
    if not processed and not S.closed and not UIS:GetFocusedTextBox()
        and input.KeyCode == Enum.KeyCode.Q then
        startCursorPick()
    end
end))
local function setLead(val)
    S.lead = math.clamp(math.floor(val * 1000 + .5) / 1000, 0, .15)
    LeadText.Text = ("PREDICTION: %d ms"):format(math.floor(S.lead * 1000 + .5))
    Hook.lead = S.lead
end
bind(Minus.MouseButton1Click:Connect(function() setLead(S.lead - .005) end))
bind(Plus.MouseButton1Click:Connect(function() setLead(S.lead + .005) end))
bind(Refresh.MouseButton1Click:Connect(function()
    for i = 1, #TargetList do requestResolution(TargetList[i]) end
    say("One-off Workspace refresh for " .. #TargetList .. " selected player(s).")
end))
bind(AutoArmor.MouseButton1Click:Connect(function()
    S.autoArmor = not S.autoArmor
    S.armorGeneration = S.armorGeneration + 1
    style(AutoArmor, S.autoArmor, "AUTO ARMOR ON RESPAWN: ON", "AUTO ARMOR ON RESPAWN: OFF")
    if S.autoArmor then
        say("Auto armor enabled; it will collect once after each respawn.")
        if Me.Character then task.spawn(buyAutoItems, Me.Character) end
    else
        say("Auto armor disabled.")
    end
end))
bind(AntiStompBtn.MouseButton1Click:Connect(function()
    S.antiStomp = not S.antiStomp
    style(AntiStompBtn, S.antiStomp, "ANTI STOMP: ON", "ANTI STOMP: OFF")
    if S.antiStomp then
        resetBeforeStomp(Me.Character, ownDangerReason(Me.Character))
        say("Anti stomp requests one reset per death, then re-arms on respawn.")
    else
        say("Anti stomp disabled.")
    end
end))
bind(ResetThresholdBtn.MouseButton1Click:Connect(function()
    S.resetThresholdIndex = S.resetThresholdIndex % #ResetThresholds + 1
    ResetThresholdBtn.Text = "RESET AT: " .. ResetThresholds[S.resetThresholdIndex] .. " HP"
    resetBeforeStomp(Me.Character, ownDangerReason(Me.Character))
end))
bind(AutoStompBtn.MouseButton1Click:Connect(function()
    if S.bringStompRestore ~= nil then
        say("Auto stomp is paused for Bring.")
        return
    end
    S.autoStomp = not S.autoStomp
    style(AutoStompBtn, S.autoStomp, "AUTO STOMP: ON", "AUTO STOMP: OFF")
    updateAutoStomp()
    say(S.autoStomp and "Auto stomp: repeats StompRemote over K.O or dead bodies."
        or "Auto stomp disabled.")
end))
bind(ExtraUI.StompAnimationBtn.MouseButton1Click:Connect(function()
    S.stompAnimationEnabled = not S.stompAnimationEnabled
    style(ExtraUI.StompAnimationBtn, S.stompAnimationEnabled,
        "STOMP ANIMATION: ON", "STOMP ANIMATION: OFF")
    if not S.stompAnimationEnabled and AutoStompTrack then
        pcall(function() AutoStompTrack:Stop(0) end)
    end
    say(S.stompAnimationEnabled and "Stomp animation enabled."
        or "Stomp animation hidden locally; remote still receives its track.")
end))
local function releaseSelectedStompPin()
    if S.selectedStompFollowConnection then
        S.selectedStompFollowConnection:Disconnect()
        S.selectedStompFollowConnection = nil
    end
    if S.selectedStompAnchors then
        for part, wasAnchored in pairs(S.selectedStompAnchors) do
            if part.Parent then
                pcall(function() part.Anchored = wasAnchored end)
            end
        end
    end
    S.selectedStompAnchors = nil
    S.selectedStompModel = nil
end
ExtraUI.selectedStompRightLeg = function(character)
    return character and (character:FindFirstChild("Right Leg")
        or character:FindFirstChild("RightLowerLeg")
        or character:FindFirstChild("RightFoot"))
end
ExtraUI.pinSelectedStompModel = function(model)
    local character = Me.Character
    local leg = ExtraUI.selectedStompRightLeg(character)
    if not leg or not leg:IsA("BasePart") or not model.Parent then return end
    local targetLower = model:FindFirstChild("LowerTorso")
    if not targetLower then return end
    local desiredLower = leg.CFrame * CFrame.new(0,
        -(leg.Size.Y + targetLower.Size.Y) * 0.5, 0)
    local pivotOffset = targetLower.CFrame:ToObjectSpace(model:GetPivot())
    for part in pairs(S.selectedStompAnchors or {}) do
        if part.Parent then part.Anchored = true end
    end
    model:PivotTo(desiredLower * pivotOffset)
    local root = model:FindFirstChild("HumanoidRootPart")
    if root then
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end
end
bind(SelectedStompBtn.MouseButton1Click:Connect(function()
    if S.selectedStomp then
        S.selectedStomp = false
        S.selectedStompTarget = nil
        S.selectedStompGeneration = S.selectedStompGeneration + 1
        releaseSelectedStompPin()
        style(SelectedStompBtn, false, "SELECTED STOMP: ON", "SELECTED STOMP: OFF")
        say("Selected stomp disabled.")
        return
    end
    local target = S.primary
    local rec = target and Records[target]
    if not recordPresent(target, rec) then
        say("Select a player on TARGETS first.")
        return
    end
    S.selectedStomp = true
    S.selectedStompTarget = target
    S.selectedStompGeneration = S.selectedStompGeneration + 1
    local generation = S.selectedStompGeneration
    style(SelectedStompBtn, true, "SELECTED STOMP: ON", "SELECTED STOMP: OFF")
    say("Selected stomp watching @" .. target.Name .. " from your position.")
    task.spawn(function()
        local ownershipModel = nil
        while not S.closed and S.selectedStomp
            and generation == S.selectedStompGeneration do
            rec = Records[target]
            if not recordPresent(target, rec) then
                S.selectedStomp = false
                S.selectedStompTarget = nil
                releaseSelectedStompPin()
                style(SelectedStompBtn, false, "SELECTED STOMP: ON", "SELECTED STOMP: OFF")
                say("Selected stomp stopped: target left.")
                break
            end
            local effects = rec.model:FindFirstChild("BodyEffects")
            local ko = effects and effects:FindFirstChild("K.O")
            local dead = effects and effects:FindFirstChild("Dead")
            local downed = rec.humanoid.Health <= 0 or (ko and ko.Value)
                or (dead and dead.Value)
            if downed and S.bringStompRestore == nil and not S.autoKill
                and not S.resetInFlight then
                local character = Me.Character
                local rightLeg = ExtraUI.selectedStompRightLeg(character)
                local targetLower = rec.model:FindFirstChild("LowerTorso")
                local hum = character and character:FindFirstChildOfClass("Humanoid")
                if rightLeg and targetLower and hum and hum.Health > 0 then
                    if S.selectedStompModel ~= rec.model then
                        releaseSelectedStompPin()
                        S.selectedStompModel = rec.model
                        S.selectedStompAnchors = {}
                        for _, part in ipairs(rec.model:GetDescendants()) do
                            if part:IsA("BasePart") then
                                S.selectedStompAnchors[part] = part.Anchored
                            end
                        end
                        local model = rec.model
                        S.selectedStompFollowConnection = RunService.RenderStepped:Connect(function()
                            if S.closed or not S.selectedStomp or S.selectedStompModel ~= model
                                or Me.Character ~= character then return end
                            pcall(ExtraUI.pinSelectedStompModel, model)
                        end)
                    end
                    if ownershipModel ~= rec.model then
                        ownershipModel = rec.model
                        local ok, owns = pcall(isnetworkowner, rec.root)
                        if not ok or not owns then
                            say("Ragdoll follow is local; the server may reject distant stomps.")
                        else
                            say("Ragdoll physics owned locally; attempting stomp here.")
                        end
                    end
                    pcall(ExtraUI.pinSelectedStompModel, rec.model)
                    if not S.closed and S.selectedStomp
                        and generation == S.selectedStompGeneration
                        and Me.Character == character then
                        pcall(autoStompTick, rec.model, true)
                    end
                end
            else
                releaseSelectedStompPin()
                ownershipModel = nil
            end
            task.wait(downed and math.max(0.05, S.stompPace * 0.75) or 0.2)
        end
    end)
end))
bind(AutoBuyPrev.MouseButton1Click:Connect(function()
    S.autoBuyIndex = (S.autoBuyIndex - 2) % #ShopNames + 1
    refreshAutoBuyControls()
end))
bind(AutoBuyNext.MouseButton1Click:Connect(function()
    S.autoBuyIndex = S.autoBuyIndex % #ShopNames + 1
    refreshAutoBuyControls()
end))
bind(AutoBuyToggle.MouseButton1Click:Connect(function()
    local name = selectedShop()
    S.autoBuys[name] = not S.autoBuys[name] or nil
    refreshAutoBuyControls()
    say(name .. (S.autoBuys[name] and " will be bought on respawn." or " auto buy disabled."))
end))
bind(AutoBuyNow.MouseButton1Click:Connect(function()
    if not Me.Character then say("No character available for shopping."); return end
    task.spawn(buyAutoItems, Me.Character, selectedShop())
end))
local function restoreBringStomp()
    local previous = S.bringStompRestore
    if previous == nil then return end
    S.bringStompRestore = nil
    S.bringStompAwaitDistance = false
    S.bringStompGeneration = S.bringStompGeneration + 1
    S.autoStomp = previous
    style(AutoStompBtn, S.autoStomp, "AUTO STOMP: ON", "AUTO STOMP: OFF")
    updateAutoStomp()
end
local function pauseBringStomp()
    if S.bringStompRestore ~= nil then return end
    S.bringStompRestore = S.autoStomp
    S.bringStompAwaitDistance = false
    S.bringStompGeneration = S.bringStompGeneration + 1
    local generation = S.bringStompGeneration
    S.autoStomp = false
    style(AutoStompBtn, false, "AUTO STOMP: ON", "AUTO STOMP: OFF")
    updateAutoStomp()
    task.spawn(function()
        while not S.closed and generation == S.bringStompGeneration do
            if not S.autoKill and not S.bringStompAwaitDistance then
                restoreBringStomp()
                return
            end
            task.wait(0.15)
        end
    end)
end
local function restoreBringStompWhenClear(target)
    if S.bringStompRestore == nil then return end
    S.bringStompAwaitDistance = true
    local generation = S.bringStompGeneration
    task.spawn(function()
        while not S.closed and generation == S.bringStompGeneration do
            local ownCharacter = Me.Character
            local ownRoot = ownCharacter and ownCharacter:FindFirstChild("HumanoidRootPart")
            local rec = Records[target]
            local targetRoot = rec and rec.root
            local carrying = ownCharacter and ownCharacter:FindFirstChild("GRABBING_CONSTRAINT")
            if not carrying and (not ownRoot or not targetRoot or not targetRoot.Parent
                or (ownRoot.Position - targetRoot.Position).Magnitude >= 5) then
                restoreBringStomp()
                return
            end
            if carrying then
                local storage = ReplicatedStorage:FindFirstChild("Storage")
                local remotes = storage and storage:FindFirstChild("Remotes")
                local main = remotes and remotes:FindFirstChild("Main")
                if main then pcall(function() main:FireServer("Grabbing") end) end
                task.wait(0.55)
            end
            task.wait(0.1)
        end
    end)
end
local function stopAutoKill(message, keepStompPaused)
    if S.standAttackTarget then
        S.standAttackTarget = nil
        S.standDownOnlyTarget = nil
        S.standAttack2Target = nil
        S.standAttack3Target = nil
        S.standAttack2FinisherPlayed = false
        S.standAttack2LaunchQueued = false
        if ExtraUI.standEndCinematic then ExtraUI.standEndCinematic() end
        S.forceHit = S.standPreviousForceHit
        style(ForceHitBtn, S.forceHit, "FORCE HIT: ON", "FORCE HIT: OFF")
        S.quietAutoKill = S.standPreviousQuiet
        S.autoKillVoid = S.standPreviousVoid
        style(VoidKillBtn, S.autoKillVoid,
            "AUTO KILL VOID BLINK: ON", "AUTO KILL VOID BLINK: OFF")
        style(ExtraUI.QuietKillBtn, S.quietAutoKill,
            "QUIET AUTO KILL: ON", "QUIET AUTO KILL: OFF")
        S.rapidWeapons["[Revolver]"] = S.standPreviousRapid or nil
        Rapid.forEachGun(function(tool)
            if tool.Name == "[Revolver]" then Rapid.applyCooldown(tool) end
        end)
        if Rapid.rows["[Revolver]"] then
            style(Rapid.rows["[Revolver]"], S.rapidWeapons["[Revolver]"],
                "[Revolver]  /  ON", "[Revolver]  /  OFF")
        end
    end
    S.autoKill = false
    S.autoKillGeneration = S.autoKillGeneration + 1
    S.killBringDestination = nil
    if not keepStompPaused then restoreBringStomp() end
    style(Bring, false, "BRING SELECTED: ON", "BRING SELECTED")
    Hook.lockPlayer, Hook.lockRecord = nil, nil
    style(AutoKillBtn, false, "AUTO KILL SELECTED: ON", "AUTO KILL SELECTED: OFF")
    if not S.silent and not S.wallBang and not S.forceHit then Hook.enabled = false end
    if message then say(message) end
end
local function startAutoKill(bringDestination)
    if S.autoKill then stopAutoKill("Auto kill stopped."); return end
    local target = S.primary
    local rec = target and Records[target]
    if not recordPresent(target, rec)
        or (not bringDestination and not alive(rec, true)) then
        say("Select a player on TARGETS first.")
        return
    end
    local ok, err = installRaycastHook()
    if not ok then say(err); return end
    S.autoKill = true
    S.lastConfirmedHitAt = os.clock()
    S.lastAdaptiveSwitchAt = 0
    S.killBringDestination = bringDestination
    if bringDestination then pauseBringStomp() end
    style(Bring, bringDestination ~= nil, "BRING SELECTED: ON", "BRING SELECTED")
    Hook.lockPlayer, Hook.lockRecord = target, rec
    S.autoKillGeneration = S.autoKillGeneration + 1
    local generation = S.autoKillGeneration
    style(AutoKillBtn, true, "AUTO KILL SELECTED: ON", "AUTO KILL SELECTED: OFF")
    say((bringDestination and "Bring" or "Auto kill") .. " targeting @" .. target.Name .. ".")
    task.spawn(function()
        local angle = math.random() * math.pi * 2
        local downedAt = nil
        local function usableGun(tool)
            if not tool or not tool:IsA("Tool") then return false end
            local handle = tool:FindFirstChild("Handle")
            local ammo = tool:GetAttribute("Ammo")
            local realAmmo = tool:GetAttribute("RealAmmo")
            if type(ammo) == "number" and ammo <= 2 then Rapid.requestReload(tool) end
            return handle and handle:FindFirstChild("ShootFXGui")
                and type(tool:GetAttribute("Cooldown")) == "number"
                and (type(ammo) ~= "number" or ammo > 0)
                and (type(realAmmo) ~= "number" or realAmmo > 0)
        end
        while not S.closed and S.autoKill and generation == S.autoKillGeneration do
            rec = Records[target]
            Hook.lockRecord = rec
            if S.primary ~= target or not recordPresent(target, rec) then
                stopAutoKill("Auto kill stopped: target changed or left.")
                break
            end
            local effects = rec.model:FindFirstChild("BodyEffects")
            local ko = effects and effects:FindFirstChild("K.O")
            local dead = effects and effects:FindFirstChild("Dead")
            if dead and dead.Value and not S.killBringDestination then
                stopAutoKill("Auto kill: target finished before grab.")
                break
            end
            local character = Me.Character
            local hum = character and character:FindFirstChildOfClass("Humanoid")
            local root = character and character:FindFirstChild("HumanoidRootPart")
            if not hum or not root or hum.Health <= 0 then
                stopAutoKill("Auto kill stopped: your character is unavailable.")
                break
            end
            local downed = rec.humanoid.Health <= 0 or (ko and ko.Value)
                or (dead and dead.Value)
            if downed then
                downedAt = downedAt or os.clock()
                if S.standDownOnlyTarget == target then
                    stopAutoKill("Stand: @" .. target.Name .. " is down; no stomp.")
                    break
                end
                if S.standAttack2Target == target
                    and not S.standAttack2FinisherPlayed then
                    S.standAttack2FinisherPlayed = true
                    if ExtraUI.standCinematicFinish then
                        pcall(ExtraUI.standCinematicFinish, target, generation)
                    end
                end
                if S.killBringDestination then
                    local destination = S.killBringDestination
                    local targetLower = rec.model:FindFirstChild("LowerTorso")
                    local ownEffects = character:FindFirstChild("BodyEffects")
                    local attacking = ownEffects and ownEffects:FindFirstChild("Attacking")
                    local storage = ReplicatedStorage:FindFirstChild("Storage")
                    local remotes = storage and storage:FindFirstChild("Remotes")
                    local main = remotes and remotes:FindFirstChild("Main")
                    if targetLower and main and not (attacking and attacking.Value) then
                        pcall(function() hum:UnequipTools() end)
                        pcall(function()
                            character:PivotTo(CFrame.new(targetLower.Position + Vector3.new(0, 2.8, 0)))
                            root.AssemblyLinearVelocity = Vector3.zero
                        end)
                        task.wait(0.2)
                        if S.autoKill and generation == S.autoKillGeneration
                            and Me.Character == character then
                            local ownLower = character:FindFirstChild("LowerTorso")
                            if ownLower and (ownLower.Position - targetLower.Position).Magnitude <= 8 then
                                pcall(function() main:FireServer("Grabbing", rec.humanoid) end)
                            end
                        end
                        local grabUntil = os.clock() + 0.55
                        while os.clock() < grabUntil
                            and not character:FindFirstChild("GRABBING_CONSTRAINT")
                            and S.autoKill and generation == S.autoKillGeneration
                            and Me.Character == character do task.wait(0.04) end
                        if character:FindFirstChild("GRABBING_CONSTRAINT") then
                            pcall(function()
                                character:PivotTo(destination)
                                root.AssemblyLinearVelocity = Vector3.zero
                            end)
                            pcall(function() main:FireServer("Grabbing") end)
                            local dropUntil = os.clock() + 0.75
                            while os.clock() < dropUntil
                                and character:FindFirstChild("GRABBING_CONSTRAINT")
                                and S.autoKill and generation == S.autoKillGeneration do
                                task.wait(0.05)
                            end
                            if character:FindFirstChild("GRABBING_CONSTRAINT") then
                                pcall(function() main:FireServer("Grabbing") end)
                                task.wait(0.2)
                            end
                            if character:FindFirstChild("GRABBING_CONSTRAINT") then
                                stopAutoKill("Grab confirmed; drop not confirmed. Press G to release.", true)
                            else
                                restoreBringStompWhenClear(target)
                                stopAutoKill("Kill + bring: move 5 studs away to resume auto stomp.", true)
                            end
                            break
                        end
                    end
                    if os.clock() - downedAt > 6 then
                        stopAutoKill("Target downed, but the server did not confirm a grab.")
                        break
                    end
                    task.wait(0.12)
                    continue
                end
                if not S.quietAutoKill or S.standAttackTarget == target then
                    pcall(function()
                        character:PivotTo(CFrame.new(rec.root.Position + Vector3.new(0, 3, 0)))
                        root.AssemblyLinearVelocity = Vector3.zero
                    end)
                end
                local stompOk, stompSent = pcall(autoStompTick, rec.model, true)
                if S.standAttack2Target == target and stompOk and stompSent
                    and not S.standAttack2LaunchQueued then
                    S.standAttack2LaunchQueued = true
                    local orderGeneration = S.standOrderGeneration
                    task.delay(0.15, function()
                        if not S.closed and orderGeneration == S.standOrderGeneration
                            and ExtraUI.standLaunchTarget then
                            if S.autoKill and S.standAttack2Target == target then
                                stopAutoKill("Director's cut: launch attempted.")
                            end
                            pcall(ExtraUI.standLaunchTarget, target)
                        end
                    end)
                end
                if os.clock() - downedAt > 6 then
                    stopAutoKill("Auto kill: target downed; finish was not confirmed.")
                    break
                end
                task.wait(0.05)
                continue
            end
            downedAt = nil
            local tool = character:FindFirstChildOfClass("Tool")
            local distance = (rec.root.Position - root.Position).Magnitude
            local bag = Me:FindFirstChildOfClass("Backpack")
            if S.standAttackTarget == target and tool
                and tool.Name ~= "[Revolver]" and bag
                and usableGun(bag:FindFirstChild("[Revolver]")) then
                tool = bag:FindFirstChild("[Revolver]")
                hum:EquipTool(tool)
                task.wait(0.08)
            end
            if tool and tool.Name ~= "[Revolver]" and bag
                and os.clock() - S.lastConfirmedHitAt > 2.5
                and os.clock() - S.lastAdaptiveSwitchAt > 2.5
                and usableGun(bag:FindFirstChild("[Revolver]")) then
                S.lastAdaptiveSwitchAt = os.clock()
                tool = bag:FindFirstChild("[Revolver]")
                hum:EquipTool(tool)
                say("Auto kill: no confirmed shotgun damage; switched to revolver.")
                task.wait(0.08)
            end
            if distance > 75 and tool and tool.Name == "[Double-Barrel SG]"
                and bag and usableGun(bag:FindFirstChild("[Revolver]")) then
                tool = bag:FindFirstChild("[Revolver]")
                hum:EquipTool(tool)
                task.wait(0.08)
            end
            if not usableGun(tool) then
                tool = nil
                if bag then
                    local preferred = S.standAttackTarget == target
                        and {"[Revolver]"} or distance > 75
                        and {"[Revolver]", "[SMG]", "[Double-Barrel SG]", "[TacticalShotgun]", "[Shotgun]"}
                        or {"[Double-Barrel SG]", "[TacticalShotgun]", "[Shotgun]", "[Revolver]", "[SMG]"}
                    for _, name in ipairs(preferred) do
                        local candidate = bag:FindFirstChild(name)
                        if usableGun(candidate) then tool = candidate; break end
                    end
                    if not tool and S.standAttackTarget ~= target then
                        for _, candidate in ipairs(bag:GetChildren()) do
                            if usableGun(candidate) then tool = candidate; break end
                        end
                    end
                end
                if not tool then
                    local equipped = character:FindFirstChildOfClass("Tool")
                    if equipped then Rapid.requestReload(equipped) end
                    task.wait(0.15)
                    continue
                end
                hum:EquipTool(tool)
                task.wait(0.08)
            elseif rec.root and rec.root.Parent then
                angle = angle + (S.standAttack3Target == target and 0.08
                    or 0.62 + math.random() * 0.28)
                local radius = S.strafeRadius + (math.random() - 0.5) * 1.5
                local jitter = Vector3.new(math.random() - 0.5,
                    math.random() * 0.8, math.random() - 0.5)
                local lead = rec.root.AssemblyLinearVelocity * 0.045
                local offset = Vector3.new(math.cos(angle) * radius, 1.5,
                    math.sin(angle) * radius) + jitter
                local attackCFrame = CFrame.lookAt(rec.root.Position + lead + offset,
                    rec.root.Position + lead + Vector3.new(0, 1.5, 0))
                if S.standAttack3Target == target then
                    -- The revolver's actual Shoot range is 250 studs.
                    local skyHeight = 80
                    local skyRadius = math.sqrt(195 * 195 - skyHeight * skyHeight)
                    attackCFrame = CFrame.lookAt(rec.root.Position + Vector3.new(
                        math.cos(angle) * skyRadius, skyHeight,
                        math.sin(angle) * skyRadius),
                        rec.root.Position + Vector3.new(0, 1.5, 0))
                end
                S.aimPlayer, S.aimRecord = target, rec
                Hook.lockPlayer, Hook.lockRecord = target, rec
                Hook.record, Hook.part = rec, partFor(rec)
                Hook.enabled = true
                if (tool:GetAttribute("Ammo") or 1) <= 2 then Rapid.requestReload(tool) end
                local rapid = S.rapidWeapons[tool.Name]
                local cooldown = rapid and Rapid.getPace(tool)
                    or math.max(0.02, tool:GetAttribute("Cooldown") or 0.1)
                local lastShot = tool:GetAttribute("ShotCooldownStarted") or 0
                local readyToFire = rapid
                    and os.clock() - (RapidLast[tool] or 0) >= cooldown
                    or not rapid and tick() - lastShot >= cooldown
                if S.quietAutoKill and not S.killBringDestination then
                    if readyToFire then
                        RapidLast[tool] = os.clock()
                        Rapid.noteShot(tool)
                        pcall(function() tool:Activate() end)
                    end
                    task.wait(rapid and 0.02 or 0.045)
                    continue
                end
                if readyToFire and S.autoKillVoid then
                    S.voidBlinking = true
                    pcall(function()
                        character:PivotTo(CFrame.new(rec.root.Position.X,
                            S.voidDepth, rec.root.Position.Z))
                        root.AssemblyLinearVelocity = Vector3.zero
                    end)
                    task.wait(S.voidDwell)
                end
                if S.closed or not S.autoKill or generation ~= S.autoKillGeneration
                    or Me.Character ~= character then
                    S.voidBlinking = false
                    if not S.resetInFlight then
                        pcall(function() character:PivotTo(LastSafeCFrame or attackCFrame) end)
                    end
                    break
                end
                pcall(function()
                    character:PivotTo(attackCFrame)
                    root.AssemblyLinearVelocity = Vector3.zero
                    root.AssemblyAngularVelocity = Vector3.zero
                end)
                S.voidBlinking = false
                if readyToFire then
                    RapidLast[tool] = os.clock()
                    Rapid.noteShot(tool)
                    pcall(function() tool:Activate() end)
                end
                task.wait(rapid and 0.02 or 0.045)
            else
                task.wait(0.045)
            end
        end
    end)
end
ExtraUI.startAttackOne = function(target, downOnly, variant)
    if not target or S.primary ~= target then
        return false, "Select a player on TARGETS first."
    end
    local character = Me.Character
    local bag = Me:FindFirstChildOfClass("Backpack")
    local revolver = (character and character:FindFirstChild("[Revolver]"))
        or (bag and bag:FindFirstChild("[Revolver]"))
    if not revolver then return false, "Revolver is not in your inventory." end
    if S.autoKill then stopAutoKill() end
    S.standPreviousQuiet = S.quietAutoKill
    S.standPreviousRapid = S.rapidWeapons["[Revolver]"]
    S.standPreviousForceHit = S.forceHit
    S.standPreviousVoid = S.autoKillVoid
    S.quietAutoKill = false
    S.autoKillVoid = false
    S.rapidWeapons["[Revolver]"] = true
    S.forceHit = true
    S.standAttackTarget = target
    S.standDownOnlyTarget = downOnly and target or nil
    S.standAttack2Target = variant == "attack2" and not downOnly and target or nil
    S.standAttack3Target = variant == "attack3" and not downOnly and target or nil
    S.standAttack2FinisherPlayed = false
    S.standAttack2LaunchQueued = false
    style(ExtraUI.QuietKillBtn, false,
        "QUIET AUTO KILL: ON", "QUIET AUTO KILL: OFF")
    style(VoidKillBtn, false,
        "AUTO KILL VOID BLINK: ON", "AUTO KILL VOID BLINK: OFF")
    style(ForceHitBtn, true, "FORCE HIT: ON", "FORCE HIT: OFF")
    local started, startError = pcall(startAutoKill, nil)
    if not started or not S.autoKill then
        stopAutoKill()
        return false, started and "Target unavailable." or tostring(startError)
    end
    pcall(function()
        Rapid.forEachGun(function(tool)
            if tool.Name == "[Revolver]" then Rapid.applyCooldown(tool) end
        end)
        if Rapid.rows["[Revolver]"] then
            style(Rapid.rows["[Revolver]"], true,
                "[Revolver]  /  ON", "[Revolver]  /  OFF")
        end
    end)
    return true
end
bind(AutoKillBtn.MouseButton1Click:Connect(function()
    if S.autoKill then
        stopAutoKill("Auto kill stopped.")
        return
    end
    local target = S.primary
    if not target then say("Select a player on TARGETS first."); return end
    ExtraUI.attackButtonGeneration = (ExtraUI.attackButtonGeneration or 0) + 1
    local generation = ExtraUI.attackButtonGeneration
    task.spawn(function()
        if not recordPresent(target, Records[target]) then requestResolution(target) end
        local deadline = os.clock() + 3
        while not S.closed and generation == ExtraUI.attackButtonGeneration
            and S.primary == target and not recordPresent(target, Records[target])
            and os.clock() < deadline do task.wait(0.1) end
        if S.closed or generation ~= ExtraUI.attackButtonGeneration
            or S.primary ~= target then return end
        local started, issue = ExtraUI.startAttackOne(target, false, "attack")
        if not started then say("Auto kill: " .. issue) end
    end)
end))
ExtraUI.standStatus = function(message)
    ExtraUI.StandStatus.Text = message
    say("Stand: " .. message)
end
ExtraUI.standResolvePlayer = function(query)
    query = (query or ""):match("^%s*(.-)%s*$")
    query = query:gsub("^@", ""):gsub("^%((.-)%)$", "%1")
        :gsub('^"(.-)"$', "%1")
    query = string.lower(query)
    if query == "" then return nil, "Enter a player name." end
    local exactName, exactDisplay, matches = nil, nil, {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Me then
            local name = string.lower(player.Name)
            local display = string.lower(player.DisplayName)
            if name == query then exactName = player end
            if display == query then exactDisplay = player end
            if name:sub(1, #query) == query
                or display:sub(1, #query) == query then
                matches[#matches + 1] = player
            end
        end
    end
    if exactName then return exactName end
    if exactDisplay then return exactDisplay end
    if #matches == 1 then return matches[1] end
    if #matches > 1 then return nil, "Name matches several players; type more." end
    return nil, "No player matches that name."
end
ExtraUI.standOwnerRoot = function()
    local owner = S.standOwner
    if not owner or owner.Parent ~= Players then return nil end
    local model = owner.Character
    if not model or not model:FindFirstChild("HumanoidRootPart") then
        model = candidateNamed(Workspace, owner)
        if not model then
            for folder in pairs(Folders) do
                model = candidateNamed(folder, owner)
                if model then break end
            end
        end
    end
    return model and model:FindFirstChild("HumanoidRootPart")
end
ExtraUI.standMoveToOwner = function()
    local targetRoot = ExtraUI.standOwnerRoot()
    local character = Me.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local hum = character and character:FindFirstChildOfClass("Humanoid")
    if not targetRoot or not root or not hum or hum.Health <= 0 then return false end
    pcall(function()
        character:PivotTo(targetRoot.CFrame * CFrame.new(2.5, 0, 3.5))
        root.AssemblyLinearVelocity = Vector3.zero
    end)
    return true
end
ExtraUI.standTargetRoot = function(player)
    if not player or player.Parent ~= Players then return nil end
    local rec = Records[player]
    if rec and rec.root and rec.root.Parent then return rec.root end
    local model = player.Character
    if not model or not model:FindFirstChild("HumanoidRootPart") then
        model = candidateNamed(Workspace, player)
        if not model then
            for folder in pairs(Folders) do
                model = candidateNamed(folder, player)
                if model then break end
            end
        end
    end
    return model and model:FindFirstChild("HumanoidRootPart")
end
ExtraUI.standCancelFling = function()
    S.standFlingGeneration = S.standFlingGeneration + 1
    S.standFlinging = false
    if S.standFlingMover then
        pcall(function() S.standFlingMover:Destroy() end)
        S.standFlingMover = nil
    end
    local restore = S.standFlingRestore
    S.standFlingRestore = nil
    if restore then pcall(restore) end
end
ExtraUI.standEndCinematic = function()
    local restore = S.standCinematicRestore
    S.standCinematicRestore = nil
    if restore then pcall(restore) end
end
ExtraUI.standCinematicIntro = function(target, generation)
    local character = Me.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local hum = character and character:FindFirstChildOfClass("Humanoid")
    if not root or not hum or hum.Health <= 0 then return false end
    local targetRoot = ExtraUI.standTargetRoot(target)
    if not targetRoot then return false end
    local previousSpeed = hum.WalkSpeed
    S.standCinematicRestore = function()
        if hum.Parent then
            hum.WalkSpeed = previousSpeed
            if root.Parent then hum:MoveTo(root.Position) end
        end
    end
    local direction = root.Position - targetRoot.Position
    if direction.Magnitude < 1 then direction = -targetRoot.CFrame.LookVector end
    direction = direction.Unit
    local staging = targetRoot.Position + direction * 70 + Vector3.new(0, 0.5, 0)
    pcall(function()
        character:PivotTo(CFrame.lookAt(staging, targetRoot.Position))
        root.AssemblyLinearVelocity = Vector3.zero
    end)
    hum.WalkSpeed = math.max(previousSpeed, 72)
    local started = os.clock()
    local greeted = false
    local greetingAt = nil
    while os.clock() - started < 4 do
        if S.closed or not S.standEnabled
            or generation ~= S.standOrderGeneration
            or Me.Character ~= character or hum.Health <= 0 then
            ExtraUI.standEndCinematic()
            return false
        end
        targetRoot = ExtraUI.standTargetRoot(target)
        if not targetRoot then
            ExtraUI.standEndCinematic()
            return false
        end
        local distance = (root.Position - targetRoot.Position).Magnitude
        if distance <= 15 and not greeted then
            greeted = true
            greetingAt = os.clock()
            task.spawn(function()
                local chat = game:GetService("TextChatService")
                local channels = chat:FindFirstChild("TextChannels")
                local general = channels and channels:FindFirstChild("RBXGeneral")
                if general then pcall(function() general:SendAsync("heyyy") end) end
            end)
        end
        if distance <= 7 then break end
        local toward = targetRoot.Position - root.Position
        local flat = Vector3.new(toward.X, 0, toward.Z)
        if flat.Magnitude > 7 then
            local step = math.min(4.5, flat.Magnitude - 7)
            local nextPosition = root.Position + flat.Unit * step
            hum:Move(flat.Unit, false)
            hum:MoveTo(targetRoot.Position + direction * 3)
            character:PivotTo(CFrame.lookAt(nextPosition,
                Vector3.new(targetRoot.Position.X, nextPosition.Y, targetRoot.Position.Z)))
        end
        task.wait(0.055)
    end
    hum:Move(Vector3.zero, false)
    if not greeted then
        greetingAt = os.clock()
        task.spawn(function()
            local chat = game:GetService("TextChatService")
            local channels = chat:FindFirstChild("TextChannels")
            local general = channels and channels:FindFirstChild("RBXGeneral")
            if general then pcall(function() general:SendAsync("heyyy") end) end
        end)
    end
    if greetingAt then
        while os.clock() - greetingAt < 0.45 do
            if S.closed or not S.standEnabled
                or generation ~= S.standOrderGeneration
                or Me.Character ~= character or hum.Health <= 0 then
                ExtraUI.standEndCinematic()
                return false
            end
            task.wait(0.05)
        end
    end
    ExtraUI.standEndCinematic()
    return S.standEnabled and generation == S.standOrderGeneration
end
ExtraUI.standCinematicFinish = function(target, generation)
    local character = Me.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local targetRoot = ExtraUI.standTargetRoot(target)
    if root and targetRoot and S.autoKill
        and generation == S.autoKillGeneration then
        pcall(function()
            character:PivotTo(CFrame.new(
                targetRoot.Position + Vector3.new(0, 3, 0)))
            root.AssemblyLinearVelocity = Vector3.zero
        end)
    end
end
ExtraUI.standLaunchTarget = function(target)
    local targetRoot = ExtraUI.standTargetRoot(target)
    if not targetRoot then return end
    local model = targetRoot.Parent
    local effects = model and model:FindFirstChild("BodyEffects")
    local ko = effects and effects:FindFirstChild("K.O")
    local dead = effects and effects:FindFirstChild("Dead")
    local hum = model and model:FindFirstChildOfClass("Humanoid")
    if not ((ko and ko.Value) or (dead and dead.Value)
        or (hum and hum.Health <= 0)) then return end
    local ok, owns = pcall(isnetworkowner, targetRoot)
    if ok and owns then
        pcall(function()
            targetRoot.AssemblyLinearVelocity = Vector3.new(0, 280, 0)
            targetRoot:ApplyImpulse(Vector3.new(0,
                targetRoot.AssemblyMass * 350, 0))
        end)
    else
        -- When the server owns the ragdoll this is a local visual only.
        task.spawn(function()
            for _ = 1, 18 do
                if S.closed or not model.Parent then return end
                pcall(function()
                    model:PivotTo(model:GetPivot() + Vector3.new(0, 14, 0))
                end)
                task.wait(0.03)
            end
        end)
    end
end
ExtraUI.standStop = function(message)
    ExtraUI.standEndCinematic()
    ExtraUI.standCancelFling()
    S.standFollow = false
    S.standFollowGeneration = S.standFollowGeneration + 1
    S.standOrderGeneration = S.standOrderGeneration + 1
    if S.autoKill then stopAutoKill() end
    if message then ExtraUI.standStatus(message) end
end
ExtraUI.standStartFling = function(target)
    ExtraUI.standStop()
    local character = Me.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local hum = character and character:FindFirstChildOfClass("Humanoid")
    local targetRoot = target and ExtraUI.standTargetRoot(target)
    if not root or not hum or hum.Health <= 0 or (target and not targetRoot) then
        ExtraUI.standStatus("Fling needs a live character and target rig.")
        return
    end
    local originalCFrame = character:GetPivot()
    local originalCollision = root.CanCollide
    local originalAutoRotate = hum.AutoRotate
    S.standFlingRestore = function()
        if root.Parent then
            root.CanCollide = originalCollision
            root.AssemblyAngularVelocity = Vector3.zero
            root.AssemblyLinearVelocity = Vector3.zero
        end
        if hum.Parent then hum.AutoRotate = originalAutoRotate end
        if Me.Character == character and hum.Health > 0 and not S.resetInFlight then
            character:PivotTo(originalCFrame)
        end
    end
    S.standFlinging = true
    S.standFlingGeneration = S.standFlingGeneration + 1
    local generation = S.standFlingGeneration
    ExtraUI.standStatus(target and ("Flinging @" .. target.Name .. ".")
        or "Spinning in place.")
    task.spawn(function()
        local attempts = 0
        local flung = false
        local ok, err = pcall(function()
            while not S.closed and S.standEnabled and S.standFlinging
                and generation == S.standFlingGeneration
                and Me.Character == character and hum.Health > 0
                and (not target or target.Parent == Players) do
                local targetPart = target and ExtraUI.standTargetRoot(target)
                if target and not targetPart then
                    ExtraUI.standStatus("Waiting for @" .. target.Name .. " to respawn for fling.")
                    task.wait(0.4)
                else
                    attempts = attempts + 1
                    local started = os.clock()
                    local launchPosition = targetPart and targetPart.Position
                    local launched = false
                    if target then
                        ExtraUI.standStatus("Flinging @" .. target.Name
                            .. " (attempt " .. attempts .. ").")
                    end
                    while not S.closed and S.standEnabled and S.standFlinging
                        and generation == S.standFlingGeneration
                        and Me.Character == character and hum.Health > 0
                        and os.clock() - started < (target and 0.85 or 2.5) do
                        targetPart = target and ExtraUI.standTargetRoot(target)
                        if target and not targetPart then break end
                        local elapsed = os.clock() - started
                        local angle = elapsed * 35
                        local center = targetPart and targetPart.Position or originalCFrame.Position
                        local offset = targetPart and Vector3.new(
                            math.cos(angle) * 0.55, 0.2, math.sin(angle) * 0.55)
                            or Vector3.zero
                        root.CanCollide = true
                        hum.AutoRotate = false
                        character:PivotTo(CFrame.new(center + offset)
                            * CFrame.Angles(0, angle, 0))
                        root.AssemblyAngularVelocity = Vector3.new(0, 2400, 0)
                        root.AssemblyLinearVelocity = targetPart
                            and Vector3.new(-math.cos(angle) * 220, 105,
                                -math.sin(angle) * 220)
                            or Vector3.new(0, 25, 0)
                        if targetPart and elapsed >= 0.15 then
                            local ownerOk, ownsTarget = pcall(isnetworkowner, targetPart)
                            if ownerOk and ownsTarget then
                                local away = targetPart.Position - originalCFrame.Position
                                away = Vector3.new(away.X, 0, away.Z)
                                if away.Magnitude < 0.1 then
                                    away = targetPart.CFrame.LookVector
                                    away = Vector3.new(away.X, 0, away.Z)
                                end
                                if away.Magnitude < 0.1 then away = Vector3.xAxis end
                                local velocity = away.Unit * 320 + Vector3.new(0, 220, 0)
                                if not launched then
                                    local mover = Instance.new("BodyVelocity")
                                    mover.Name = "SpectraStandFling"
                                    mover.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                                    mover.P = 125000
                                    mover.Velocity = velocity
                                    mover.Parent = targetPart
                                    S.standFlingMover = mover
                                    launched = true
                                elseif S.standFlingMover then
                                    S.standFlingMover.Velocity = velocity
                                end
                                targetPart.AssemblyLinearVelocity = velocity
                                targetPart:ApplyImpulse(velocity * targetPart.AssemblyMass)
                                local model = targetPart.Parent
                                if model and model:IsA("Model") then
                                    for _, part in ipairs(model:GetChildren()) do
                                        if part:IsA("BasePart") and part ~= targetPart
                                            and not part.Anchored then
                                            part.AssemblyLinearVelocity = velocity
                                        end
                                    end
                                end
                            end
                        end
                        task.wait(0.03)
                    end
                    if not target then break end
                    task.wait(0.25)
                    targetPart = ExtraUI.standTargetRoot(target)
                    if targetPart and launchPosition and launched then
                        local delta = targetPart.Position - launchPosition
                        flung = delta.Y >= 20 or delta.Magnitude >= 45
                    end
                    if S.standFlingMover then
                        pcall(function() S.standFlingMover:Destroy() end)
                        S.standFlingMover = nil
                    end
                    if flung then break end
                    task.wait(0.2)
                end
            end
        end)
        if generation == S.standFlingGeneration then
            ExtraUI.standCancelFling()
            ExtraUI.standStatus(not ok and ("Fling stopped: " .. tostring(err))
                or (target and flung
                    and ("@" .. target.Name .. " flung after " .. attempts
                        .. (attempts == 1 and " attempt." or " attempts."))
                    or (target and "Fling stopped; target left or character reset."
                        or "Spin finished; position restored.")))
        end
    end)
end
ExtraUI.standSetOwner = function(owner)
    if not owner or owner == Me or owner.Parent ~= Players then
        ExtraUI.standStatus("Choose another player as owner.")
        return
    end
    ExtraUI.standStop()
    if S.standOwnerChatConnection then
        S.standOwnerChatConnection:Disconnect()
        S.standOwnerChatConnection = nil
    end
    S.standOwner = owner
    Env.SpectraStandOwnerUserId = owner.UserId
    ExtraUI.StandOwnerLabel.Text = "Owner: @" .. owner.Name .. " (" .. owner.DisplayName .. ")"
    ExtraUI.StandOwnerInput.Text = owner.Name
    S.standOwnerChatConnection = owner.Chatted:Connect(function(message)
        if ExtraUI.standHandleChat then ExtraUI.standHandleChat(owner, message) end
    end)
    ExtraUI.standStatus("Owner set to @" .. owner.Name .. ". Enable Listen.")
end
ExtraUI.standHandleChat = function(sender, message)
    if S.closed or not S.standEnabled or sender ~= S.standOwner
        or type(message) ~= "string" then return end
    local command, argument = message:match("^%s*!(%w+)%s*(.-)%s*$")
    if not command then return end
    command = string.lower(command)
    local signature = tostring(sender.UserId) .. ":" .. message
    local now = os.clock()
    if S.standLastCommand == signature and now - S.standLastCommandAt < 0.35 then return end
    S.standLastCommand, S.standLastCommandAt = signature, now
    if command == "stop" then
        ExtraUI.standStop("Stopped by owner.")
    elseif command == "stay" then
        S.standFollow = false
        S.standFollowGeneration = S.standFollowGeneration + 1
        ExtraUI.standStatus("Holding position.")
    elseif command == "come" then
        ExtraUI.standStop()
        ExtraUI.standStatus(ExtraUI.standMoveToOwner()
            and "Moved to owner." or "Owner position unavailable.")
    elseif command == "follow" then
        ExtraUI.standStop()
        S.standFollow = true
        S.standFollowGeneration = S.standFollowGeneration + 1
        local generation = S.standFollowGeneration
        ExtraUI.standStatus("Following owner.")
        task.spawn(function()
            while not S.closed and S.standEnabled and S.standFollow
                and generation == S.standFollowGeneration do
                local ownerRoot = ExtraUI.standOwnerRoot()
                local character = Me.Character
                local root = character and character:FindFirstChild("HumanoidRootPart")
                if ownerRoot and root
                    and (ownerRoot.Position - root.Position).Magnitude > 7 then
                    ExtraUI.standMoveToOwner()
                end
                task.wait(0.18)
            end
        end)
    elseif command == "fling" or command == "spin" then
        local target = nil
        if command == "fling" and argument ~= "" then
            local issue
            target, issue = ExtraUI.standResolvePlayer(argument)
            if not target then ExtraUI.standStatus(issue); return end
        end
        ExtraUI.standStartFling(target)
    elseif command == "jump" then
        local character = Me.Character
        local hum = character and character:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health > 0 then
            hum.Sit = false
            hum.Jump = true
            ExtraUI.standStatus("Jumping.")
        else ExtraUI.standStatus("Character unavailable.") end
    elseif command == "sit" then
        ExtraUI.standStop()
        local character = Me.Character
        local hum = character and character:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health > 0 then
            hum.Sit = true
            ExtraUI.standStatus("Sitting.")
        else ExtraUI.standStatus("Character unavailable.") end
    elseif command == "stand" then
        local character = Me.Character
        local hum = character and character:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health > 0 then
            hum.Sit = false
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            ExtraUI.standStatus("Standing.")
        else ExtraUI.standStatus("Character unavailable.") end
    elseif command == "bring" then
        local target, issue = ExtraUI.standResolvePlayer(argument)
        if not target then ExtraUI.standStatus(issue); return end
        if target == S.standOwner then
            ExtraUI.standStatus("Owner cannot be the bring target.")
            return
        end
        local ownerRoot = ExtraUI.standOwnerRoot()
        if not ownerRoot then
            ExtraUI.standStatus("Owner position unavailable.")
            return
        end
        ExtraUI.standStop()
        if TargetSet[target] then
            S.primary = target
            syncLabels()
        else
            choosePlayer(target)
        end
        if S.primary ~= target then
            ExtraUI.standStatus("Could not select bring target.")
            return
        end
        local generation = S.standOrderGeneration
        ExtraUI.standStatus("Resolving @" .. target.Name .. " for Bring.")
        task.spawn(function()
            local deadline = os.clock() + 3
            while S.standEnabled and generation == S.standOrderGeneration
                and S.primary == target and not recordPresent(target, Records[target])
                and os.clock() < deadline do
                task.wait(0.1)
            end
            if not S.standEnabled or generation ~= S.standOrderGeneration
                or S.primary ~= target then return end
            if not recordPresent(target, Records[target]) then
                ExtraUI.standStatus("Bring target rig unavailable.")
                return
            end
            local latestOwnerRoot = ExtraUI.standOwnerRoot()
            if not latestOwnerRoot then
                ExtraUI.standStatus("Owner position unavailable.")
                return
            end
            local ok, err = pcall(startAutoKill, latestOwnerRoot.CFrame)
            ExtraUI.standStatus(ok and S.autoKill
                and ("Bringing @" .. target.Name .. " to owner.")
                or ("Bring could not start: " .. tostring(err)))
        end)
    elseif command == "attack" or command == "attack2" or command == "attack3" then
        local target, issue = ExtraUI.standResolvePlayer(argument)
        if not target then ExtraUI.standStatus(issue); return end
        local ownerDownOnly = target == S.standOwner
        local bag = Me:FindFirstChildOfClass("Backpack")
        local character = Me.Character
        local revolver = (character and character:FindFirstChild("[Revolver]"))
            or (bag and bag:FindFirstChild("[Revolver]"))
        if not revolver then
            ExtraUI.standStatus("Revolver is not in your inventory.")
            return
        end
        ExtraUI.standStop()
        if TargetSet[target] then
            S.primary = target
            syncLabels()
        else
            choosePlayer(target)
        end
        if S.primary ~= target then
            ExtraUI.standStatus("Could not select target; check target limit.")
            return
        end
        local generation = S.standOrderGeneration
        ExtraUI.standStatus("Resolving @" .. target.Name .. " for attack.")
        task.spawn(function()
            local deadline = os.clock() + 3
            while S.standEnabled and generation == S.standOrderGeneration
                and S.primary == target and not recordPresent(target, Records[target])
                and os.clock() < deadline do
                task.wait(0.1)
            end
            if not S.standEnabled or generation ~= S.standOrderGeneration
                or S.primary ~= target then return end
            if not recordPresent(target, Records[target]) then
                ExtraUI.standStatus("Target rig unavailable; attack cancelled.")
                return
            end
            if command == "attack2" then
                ExtraUI.standStatus("Attack2: running in on @" .. target.Name .. ".")
                local played, completed = pcall(
                    ExtraUI.standCinematicIntro, target, generation)
                if not played or not completed then
                    ExtraUI.standEndCinematic()
                    if generation == S.standOrderGeneration then
                        ExtraUI.standStatus("Cinematic cancelled; target unavailable.")
                    end
                    return
                end
            end
            ExtraUI.standStatus("Starting Auto Kill on @" .. target.Name .. ".")
            local started, startError = ExtraUI.startAttackOne(
                target, ownerDownOnly, command)
            if not started then
                ExtraUI.standStatus("Auto Kill error: " .. tostring(startError))
                return
            end
            if S.autoKill then
                ExtraUI.standStatus(ownerDownOnly
                    and ("Attacking owner @" .. target.Name .. "; stop on down, no stomp.")
                    or command == "attack3"
                    and ("Sky attack on @" .. target.Name .. "; descend to stomp on down.")
                    or ("Attacking @" .. target.Name .. " with revolver; stomp on down."))
            else
                stopAutoKill()
                ExtraUI.standStatus("Attack could not start; target unavailable.")
            end
        end)
    elseif command == "status" then
        ExtraUI.standStatus(S.autoKill and "Attacking @" .. S.primary.Name
            or S.standFlinging and "Flinging."
            or S.standFollow and "Following owner." or "Standing by.")
    end
end
bind(ExtraUI.StandSetOwner.MouseButton1Click:Connect(function()
    local owner, issue = ExtraUI.standResolvePlayer(ExtraUI.StandOwnerInput.Text)
    if owner then ExtraUI.standSetOwner(owner)
    else ExtraUI.standStatus(issue) end
end))
bind(ExtraUI.StandSetSelected.MouseButton1Click:Connect(function()
    ExtraUI.standSetOwner(S.primary)
end))
bind(ExtraUI.StandToggle.MouseButton1Click:Connect(function()
    if not S.standEnabled and not S.standOwner then
        ExtraUI.standStatus("Set an owner first.")
        return
    end
    S.standEnabled = not S.standEnabled
    Env.SpectraStandEnabled = S.standEnabled
    style(ExtraUI.StandToggle, S.standEnabled, "LISTEN: ON", "LISTEN: OFF")
    if not S.standEnabled then ExtraUI.standStop("Listening stopped.")
    else ExtraUI.standStatus("Listening to @" .. S.standOwner.Name .. ".") end
end))
bind(ExtraUI.StandStop.MouseButton1Click:Connect(function()
    ExtraUI.standStop("Current order stopped.")
end))
pcall(function()
    local chat = game:GetService("TextChatService")
    bind(chat.MessageReceived:Connect(function(message)
        local source = message.TextSource
        if not source or not S.standOwner
            or source.UserId ~= S.standOwner.UserId then return end
        ExtraUI.standHandleChat(S.standOwner, message.Text)
    end))
end)
bind(Players.PlayerRemoving:Connect(function(player)
    if player ~= S.standOwner then return end
    ExtraUI.standStop("Owner left the server.")
    S.standEnabled = false
    S.standOwner = nil
    Env.SpectraStandOwnerUserId = nil
    Env.SpectraStandEnabled = false
    style(ExtraUI.StandToggle, false, "LISTEN: ON", "LISTEN: OFF")
    ExtraUI.StandOwnerLabel.Text = "Owner: none"
    if S.standOwnerChatConnection then
        S.standOwnerChatConnection:Disconnect()
        S.standOwnerChatConnection = nil
    end
end))
bind(Bring.MouseButton1Click:Connect(function()
    if S.autoKill and S.killBringDestination then
        stopAutoKill("Bring stopped.")
        return
    end
    if S.autoKill then stopAutoKill() end
    local character = Me.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then say("Your character root is unavailable."); return end
    startAutoKill(root.CFrame)
end))

-- Manual profile slots. Keep active orders and targets out of saved preferences.
ExtraUI.configSlot = 1
ExtraUI.configKeys = {"quietAutoKill", "autoKillVoid", "antiVoid", "autoArmor",
    "antiStomp", "autoStomp", "stompAnimationEnabled", "stompPace",
    "resetThresholdIndex", "strafeRadius", "voidDepth", "uiScale",
    "respawnAtDeath", "adaptiveRapid", "noRecoil", "noSpread",
    "invisibleShot", "infiniteSmg", "autoReloadAll", "themeIndex", "macroLock"}
ExtraUI.configPath = function()
    return "SpectraMulti_Config_" .. ExtraUI.configSlot .. ".json"
end
ExtraUI.syncConfigSlot = function()
    for index, slot in ipairs(ExtraUI.ConfigSlots) do
        slot.BackgroundColor3 = index == ExtraUI.configSlot and C_SELECTED or C_OFF
    end
end
for index, slot in ipairs(ExtraUI.ConfigSlots) do
    bind(slot.MouseButton1Click:Connect(function()
        ExtraUI.configSlot = index
        ExtraUI.syncConfigSlot()
        ExtraUI.ConfigStatus.Text = "Slot " .. index .. " selected."
    end))
end
ExtraUI.syncConfigSlot()
bind(ExtraUI.ConfigSave.MouseButton1Click:Connect(function()
    if type(writefile) ~= "function" then
        ExtraUI.ConfigStatus.Text = "This executor does not support saving files."
        return
    end
    local profile = {version = 1, settings = {}, rapidWeapons = {},
        autoBuys = {}, esp = {}}
    for _, key in ipairs(ExtraUI.configKeys) do
        profile.settings[key] = S[key]
    end
    for name, enabled in pairs(S.rapidWeapons) do
        if enabled then profile.rapidWeapons[name] = true end
    end
    for name, enabled in pairs(S.autoBuys) do
        if enabled then profile.autoBuys[name] = true end
    end
    for key, value in pairs(S.esp) do profile.esp[key] = value end
    local ok, err = pcall(function()
        writefile(ExtraUI.configPath(),
            game:GetService("HttpService"):JSONEncode(profile))
    end)
    ExtraUI.ConfigStatus.Text = ok and
        ("Saved slot " .. ExtraUI.configSlot .. ".") or
        ("Save failed: " .. tostring(err))
end))
bind(ExtraUI.ConfigLoad.MouseButton1Click:Connect(function()
    if type(readfile) ~= "function" or type(isfile) ~= "function" then
        ExtraUI.ConfigStatus.Text = "This executor does not support loading files."
        return
    end
    if not isfile(ExtraUI.configPath()) then
        ExtraUI.ConfigStatus.Text = "Slot " .. ExtraUI.configSlot .. " is empty."
        return
    end
    local ok, profile = pcall(function()
        return game:GetService("HttpService"):JSONDecode(readfile(ExtraUI.configPath()))
    end)
    if not ok or type(profile) ~= "table" or profile.version ~= 1
        or type(profile.settings) ~= "table" then
        ExtraUI.ConfigStatus.Text = "This slot has invalid config data."
        return
    end
    if S.autoKill then stopAutoKill("Loading config.") end
    local settings = profile.settings
    for _, key in ipairs(ExtraUI.configKeys) do
        if type(settings[key]) == type(S[key]) then S[key] = settings[key] end
    end
    S.stompPace = math.clamp(S.stompPace, 1e-282, 1)
    S.resetThresholdIndex = math.clamp(math.floor(S.resetThresholdIndex), 1, #ResetThresholds)
    S.themeIndex = math.clamp(math.floor(S.themeIndex), 1, #ThemeNames)
    S.strafeRadius = math.clamp(S.strafeRadius, 4, 14)
    S.voidDepth = math.clamp(S.voidDepth, -300, -60)
    S.uiScale = math.clamp(S.uiScale, 0.7, 1.2)
    Rapid.restore()
    table.clear(S.rapidWeapons)
    if type(profile.rapidWeapons) == "table" then
        for name, enabled in pairs(profile.rapidWeapons) do
            if type(name) == "string" and enabled == true then
                S.rapidWeapons[name] = true
            end
        end
    end
    Rapid.forEachGun(function(tool) Rapid.applyCooldown(tool) end)
    for name, row in pairs(Rapid.rows) do
        style(row, S.rapidWeapons[name], name .. "  /  ON", name .. "  /  OFF")
    end
    table.clear(S.autoBuys)
    if type(profile.autoBuys) == "table" then
        for name, enabled in pairs(profile.autoBuys) do
            if type(name) == "string" and enabled == true then
                S.autoBuys[name] = true
            end
        end
    end
    if type(profile.esp) == "table" then
        for key, value in pairs(S.esp) do
            if type(profile.esp[key]) == type(value) then S.esp[key] = profile.esp[key] end
        end
    end
    S.esp.rangeIndex = math.clamp(math.floor(S.esp.rangeIndex), 1, 4)
    S.esp.colorIndex = math.clamp(math.floor(S.esp.colorIndex), 1, 4)
    applyTheme(S.themeIndex)
    setStompPace((math.log10(S.stompPace) + MinStompPaceExponent)
        / MinStompPaceExponent)
    ExtraUI.setStrafeRadius((S.strafeRadius - 4) / 10)
    ExtraUI.setVoidDepth((-S.voidDepth - 60) / 240)
    ExtraUI.setUiScale((S.uiScale - 0.7) / 0.5)
    style(ExtraUI.QuietKillBtn, S.quietAutoKill,
        "QUIET AUTO KILL: ON", "QUIET AUTO KILL: OFF")
    style(VoidKillBtn, S.autoKillVoid,
        "AUTO KILL VOID BLINK: ON", "AUTO KILL VOID BLINK: OFF")
    style(AntiVoidBtn, S.antiVoid, "ANTI VOID: ON", "ANTI VOID: OFF")
    style(AutoArmor, S.autoArmor,
        "AUTO ARMOR ON RESPAWN: ON", "AUTO ARMOR ON RESPAWN: OFF")
    style(AntiStompBtn, S.antiStomp, "ANTI STOMP: ON", "ANTI STOMP: OFF")
    style(AutoStompBtn, S.autoStomp, "AUTO STOMP: ON", "AUTO STOMP: OFF")
    style(ExtraUI.StompAnimationBtn, S.stompAnimationEnabled,
        "STOMP ANIMATION: ON", "STOMP ANIMATION: OFF")
    style(ExtraUI.RespawnDeathBtn, S.respawnAtDeath,
        "RESPAWN AT DEATH: ON", "RESPAWN AT DEATH: OFF")
    style(ExtraUI.MacroBtn, S.macroLock,
        "MACRO PERSIST: ON", "MACRO PERSIST: OFF")
    if S.macroLock then ExtraUI.ensureMacro(Me.Character) end
    ResetThresholdBtn.Text = "RESET AT: " .. ResetThresholds[S.resetThresholdIndex] .. " HP"
    local guns = ExtraUI.GunModButtons
    style(guns.invisible, S.invisibleShot, "INVISIBLE SHOT: ON", "INVISIBLE SHOT: OFF")
    style(guns.adaptive, S.adaptiveRapid, "ADAPTIVE RAPID: ON", "ADAPTIVE RAPID: OFF")
    style(guns.recoil, S.noRecoil, "NO RECOIL: ON", "NO RECOIL: OFF")
    style(guns.spread, S.noSpread, "DB NO SPREAD: ON", "DB NO SPREAD: OFF")
    style(guns.smg, S.infiniteSmg, "SMG AUTO RELOAD: ON", "SMG AUTO RELOAD: OFF")
    style(guns.reload, S.autoReloadAll,
        "AUTO RELOAD ALL GUNS: ON", "AUTO RELOAD ALL GUNS: OFF")
    ExtraUI.applyGunMods(Me.Character)
    style(ExtraUI.EspMain, S.esp.enabled, "ESP: ON", "ESP: OFF")
    for _, item in ipairs({{"boxes", ExtraUI.EspBoxes, "BOXES"},
        {"skeleton", ExtraUI.EspSkeleton, "SKELETON"},
        {"names", ExtraUI.EspNames, "NAMES"},
        {"distance", ExtraUI.EspDistance, "DISTANCE"}}) do
        style(item[2], S.esp[item[1]], item[3] .. ": ON", item[3] .. ": OFF")
    end
    local espRanges = {"250", "500", "1000", "ALL"}
    local espColors = {"CYAN", "VIOLET", "AMBER", "LIME"}
    ExtraUI.EspRange.Text = "RANGE: " .. espRanges[S.esp.rangeIndex]
    ExtraUI.EspColor.Text = "COLOR: " .. espColors[S.esp.colorIndex]
    refreshAutoBuyControls()
    updateAutoStomp()
    ExtraUI.ConfigStatus.Text = "Loaded slot " .. ExtraUI.configSlot .. "."
end))

-- Drag is event-driven (mouse input only) rather than render-loop animation.
local Dragging, DragStart, GuiStart, DragInput = false, nil, nil, nil
bind(Heading.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        Dragging, DragStart, GuiStart = true, input.Position, Main.Position
    end
end))
bind(Heading.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then DragInput = input end
end))
bind(UIS.InputChanged:Connect(function(input)
    if Dragging and input == DragInput then
        local d = input.Position - DragStart
        Main.Position = UDim2.new(GuiStart.X.Scale, GuiStart.X.Offset + d.X,
            GuiStart.Y.Scale, GuiStart.Y.Offset + d.Y)
    end
end))
bind(UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then Dragging = false end
end))

local function cleanup()
    if S.closed then return end
    S.closed = true
    TickGeneration = TickGeneration + 1
    S.armorGeneration = S.armorGeneration + 1
    OwnCharacterGeneration = OwnCharacterGeneration + 1
    AutoStompGeneration = AutoStompGeneration + 1
    S.autoKill = false
    S.autoKillGeneration = S.autoKillGeneration + 1
    S.selectedStomp = false
    S.selectedStompGeneration = S.selectedStompGeneration + 1
    releaseSelectedStompPin()
    ExtraUI.standEndCinematic()
    ExtraUI.standCancelFling()
    S.standEnabled = false
    S.standFollow = false
    S.standFollowGeneration = S.standFollowGeneration + 1
    if S.standOwnerChatConnection then
        S.standOwnerChatConnection:Disconnect()
        S.standOwnerChatConnection = nil
    end
    S.voidBlinking = false
    Rapid.restore()
    ExtraUI.restoreGunMods()
    ExtraUI.cleanupEsp()
    if AutoStompTrack then pcall(function() AutoStompTrack:Stop(0.05) end) end
    disconnectMany(OwnCharacterConnections)
    Hook.enabled = false
    Hook.part, Hook.record = nil, nil
    if Hook.manager and Hook.manager.Raycast == Hook.wrapper then
        pcall(function() Hook.manager.Raycast = Hook.original end)
    end
    if Hook.manager and Hook.manager.ReconcileDamageBatch == Hook.damageWrapper then
        pcall(function() Hook.manager.ReconcileDamageBatch = Hook.damageOriginal end)
    end
    Hook.installed, Hook.manager, Hook.original, Hook.wrapper = false, nil, nil, nil
    S.silent, S.trigger = false, false
    if RenderConnection then RenderConnection:Disconnect(); RenderConnection = nil end
    stopBring()
    for _, cs in pairs(PlayerConnections) do disconnectMany(cs) end
    table.clear(PlayerConnections)
    for _, c in pairs(Folders) do c:Disconnect() end
    table.clear(Folders)
    for _, c in pairs(RowConnections) do c:Disconnect() end
    table.clear(RowConnections)
    disconnectMany(Connections)
    if Gui.Parent then Gui:Destroy() end
end

Env.SpectraSelectCleanup = cleanup
Env.DAH_LiteCleanup = cleanup
Env.DAH_PolishedCleanup = cleanup
bind(Close.MouseButton1Click:Connect(cleanup))
bind(Gui.Destroying:Connect(cleanup))
style(AliveBtn, true, "ALIVE CHECK: ON", "ALIVE CHECK: OFF")
style(AutoArmor, S.autoArmor, "AUTO ARMOR ON RESPAWN: ON", "AUTO ARMOR ON RESPAWN: OFF")
style(AntiStompBtn, S.antiStomp, "ANTI STOMP: ON", "ANTI STOMP: OFF")
style(AutoStompBtn, S.autoStomp, "AUTO STOMP: ON", "AUTO STOMP: OFF")
style(ExtraUI.StompAnimationBtn, S.stompAnimationEnabled,
    "STOMP ANIMATION: ON", "STOMP ANIMATION: OFF")
if type(Env.SpectraStandOwnerUserId) == "number" then
    task.defer(function()
        if S.closed then return end
        for _, player in ipairs(Players:GetPlayers()) do
            if player.UserId == Env.SpectraStandOwnerUserId then
                ExtraUI.standSetOwner(player)
                S.standEnabled = Env.SpectraStandEnabled == true
                style(ExtraUI.StandToggle, S.standEnabled,
                    "LISTEN: ON", "LISTEN: OFF")
                if S.standEnabled then
                    ExtraUI.standStatus("Listening to @" .. player.Name .. ".")
                end
                return
            end
        end
    end)
end
style(CursorToggle, S.cursorKeyEnabled, "CURSOR PICK: ON", "CURSOR PICK: OFF")
refreshAutoBuyControls()
syncLabels()
updateAutoStomp()
say("Ready: anti stomp resets early; auto stomp follows bodies beneath you.")
if Me.Character and (S.autoArmor or next(S.autoBuys)) then
    task.spawn(buyAutoItems, Me.Character)
end

-- One-shot loading scene; no persistent animation loop remains after reveal.
Main.Visible = false
ExtraUI.LoadOverlay = make("Frame", {Parent = Gui, Name = "RacerLoading",
    Size = UDim2.fromScale(1, 1), BackgroundColor3 = C_BG,
    BorderSizePixel = 0, ZIndex = 100})
ExtraUI.LoadCard = round(make("Frame", {Parent = ExtraUI.LoadOverlay,
    AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(390, 170), BackgroundColor3 = C_PANEL,
    BorderSizePixel = 0, ZIndex = 101}), 0)
make("UIStroke", {Parent = ExtraUI.LoadCard, Color = C_BORDER,
    Thickness = 1, Transparency = 0})
ExtraUI.LoadTitle = make("TextLabel", {Parent = ExtraUI.LoadCard,
    Position = UDim2.fromOffset(24, 25), Size = UDim2.fromOffset(342, 35),
    BackgroundTransparency = 1, Text = "RACER",
    TextColor3 = C_TEXT, Font = Enum.Font.GothamBold, TextSize = 23,
    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 102})
ExtraUI.LoadCaption = make("TextLabel", {Parent = ExtraUI.LoadCard,
    Position = UDim2.fromOffset(24, 68), Size = UDim2.fromOffset(342, 24),
    BackgroundTransparency = 1, Text = "PREPARING CONTROL CONSOLE",
    TextColor3 = C_FAINT, Font = Enum.Font.GothamMedium, TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 102})
ExtraUI.LoadTrack = round(make("Frame", {Parent = ExtraUI.LoadCard,
    Position = UDim2.fromOffset(24, 117), Size = UDim2.fromOffset(342, 6),
    BackgroundColor3 = C_OFF, BorderSizePixel = 0, ZIndex = 102}), 0)
ExtraUI.LoadFill = round(make("Frame", {Parent = ExtraUI.LoadTrack,
    Size = UDim2.fromScale(0, 1), BackgroundColor3 = C_ACCENT,
    BorderSizePixel = 0, ZIndex = 103}), 3)
ExtraUI.LoadPercent = make("TextLabel", {Parent = ExtraUI.LoadCard,
    Position = UDim2.fromOffset(24, 133), Size = UDim2.fromOffset(342, 18),
    BackgroundTransparency = 1, Text = "00%", TextColor3 = C_ACCENT,
    Font = Enum.Font.GothamBold, TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 102})
task.spawn(function()
    local tweenService = game:GetService("TweenService")
    for index, step in ipairs({
        {0.32, "Resolving player rigs"},
        {0.68, "Connecting controls"},
        {1, "Control deck ready"},
    }) do
        if S.closed or not ExtraUI.LoadOverlay.Parent then return end
        ExtraUI.LoadCaption.Text = step[2]
        ExtraUI.LoadPercent.Text = string.format("%02d%%", step[1] * 100)
        local tween = tweenService:Create(ExtraUI.LoadFill,
            TweenInfo.new(0.36, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
            {Size = UDim2.fromScale(step[1], 1)})
        tween:Play()
        tween.Completed:Wait()
    end
    if S.closed then return end
    Main.Position = UDim2.fromOffset(Main.Position.X.Offset, 96)
    Main.Visible = true
    tweenService:Create(Main,
        TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        {Position = UDim2.fromOffset(Main.Position.X.Offset, 80)}):Play()
    ExtraUI.LoadOverlay:Destroy()
end)
