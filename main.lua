-- NOSR Script / Professional GUI v4
-- Redesigned slate-and-ice shell, segmented module navigation, card controls.
-- All original feature operations are retained; layout remains client-side.
-- Requires a supported Roblox Luau environment.

-- NOSR Script | Readable, scroll-repaired edition
-- The original decimal-escaped Lua strings have been decoded for maintainability.
-- Nested scroll panels now update canvas heights and correctly accept wheel/touch input.
-- Original feature logic is otherwise retained; test in your own Roblox environment.

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
Env.RacerExecutorName = "Unknown"
if type(identifyexecutor) == "function" then
    local ok, name = pcall(identifyexecutor)
    if ok and type(name) == "string" then Env.RacerExecutorName = name end
end
if Env.RacerExecutorName == "Unknown" and type(getexecutorname) == "function" then
    local ok, name = pcall(getexecutorname)
    if ok and type(name) == "string" then Env.RacerExecutorName = name end
end
Env.RacerIsXeno = string.find(string.lower(Env.RacerExecutorName),
    "xeno", 1, true) ~= nil

 
 
if not Env.RacerIsXeno and type(queue_on_teleport) == "function" then
    pcall(function()
        queue_on_teleport([=[
            task.wait(2)
            local scriptFile = loadfile([[Nosr_Script_Professional_GUI_v4.lua]])
            if scriptFile then scriptFile() end
        ]=])
    end)
end

 
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

local MAX_TARGETS = 1000  
local S: any = {
    closed = false,
    multi = false,
    antiLock = false,  
    aliveOnly = true,      
    primary = nil,         
    aimPlayer = nil,
    aimRecord = nil,
    silent = false,
    wallBang = false,
    bulletMode = 1,        
    bulletStep = 0,
    forceHit = false,
    aura = false,
    auraFromStand = false,
    auraGeneration = 0,
    auraCursor = 0,
    auraStompRestore = nil,
    auraRevolverRapidBefore = nil,
    auraThreatUntil = {},
    auraRecentFiring = {},
    auraLastHealth = nil,
    auraLastArmor = nil,
    auraLastCharacter = nil,
    auraTargetShots = 0,
    auraTargetSince = 0,
    auraTargetHitAt = 0,
    auraBlockedUntil = {},
    infiniteRange = false,
    trigger = false,
    cameraAim = false,
    dot = false,
    wall = false,
    head = false,
    lead = 0,
    screenDistance2 = math.huge,
    permitted = false,
    bring = nil,
    autoArmor = true,
    armorGeneration = 0,
    autoBuys = {},
    autoBuyIndex = 1,
    antiStomp = true,
    autoStomp = true,
    stompSuppressed = false,  
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
    standFloatTrack = nil,
    standFloatCharacter = nil,
    standFloatAutoRotate = nil,
    standFloatRootCollide = nil,
    standOrderGeneration = 0,
    standFlingGeneration = 0,
    standFlinging = false,
    standFlingRestore = nil,
    standCinematicRestore = nil,
    standAttack2Target = nil,
    standAttack3Target = nil,
    standAttack4Target = nil,
    standAttack5Target = nil,
    standSnipeTarget = nil,
    standCounterAttackTarget = nil,
    standDrivebyTarget = nil,
    standAmbushTarget = nil,
    standAmbushRushTarget = nil,
    standAmbushHitAfter = nil,
    standCounterTarget = nil,
    standCounterPending = nil,
    standCounterShots = {},
    standCounterHandled = {},
    standCounterReportedDown = {},
    standCounterBulletHooked = false,
    standSavedOrder = nil,
    standResumeGeneration = 0,
    auraProtectedPlayer = nil,
    auraProtectMissingAt = nil,
    standRevolverRapidBefore = nil,
    standReturnCFrame = nil,
    standHoldRestore = nil,
    afkPermanent = false,
    afkGeneration = 0,
    chatSpy = false,
    chatSpyOriginal = nil,
    jumpBypass = false,
    jumpBypassGeneration = 0,
    standEnabledRapid = nil,        
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
    bringFollowOwner = nil,
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
    adaptiveRapid = false,  
    lastAttemptWeaponName = nil,
    noRecoil = false,
    invisibleShot = false,
    noSpread = false,
    infiniteSmg = false,
    autoReloadAll = false,
    knifeTravel = false,
    esp = {enabled = false, boxes = true, skeleton = false,
        names = true, distance = true, rangeIndex = 4, colorIndex = 1},
    themeIndex = 1,
    autoKillGeneration = 0,
    resetThresholdIndex = 5,
    resetCharacter = nil,
    resetInFlight = false,
    antiStompReady = false,
    antiStompTriggeredCharacter = nil,  
    antiStompConfirmedCharacter = nil,
    antiStompSpawnGraceUntil = 0,
    lastResetAt = 0,
    resetGeneration = 0,  
    cursorKeyEnabled = true,
    fpsShare = false,
    fpsBase = 999,
    fpsDrop = 150,
    notify = {
        enabled = true, popups = true,
        downed = true, dead = true, respawned = true,
        lowHealth = false, ownRespawn = false, antiStomp = true,
        selected = false,
    },
}
local Connections = {}
local ExtraUI: any = {}
ExtraUI.ExecutorName = Env.RacerExecutorName
ExtraUI.Capabilities = {
    fileRead = type(readfile) == "function" and type(isfile) == "function",
    fileWrite = type(writefile) == "function",
    clickDetector = type(fireclickdetector) == "function",
    mouseClick = type(mouse1click) == "function"
        or (type(mouse1press) == "function" and type(mouse1release) == "function"),
    connections = type(getconnections) == "function"
        and type(debug) == "table" and type(debug.getupvalues) == "function",
}
 
 
 
ExtraUI.Capabilities.shopPurchase = not Env.RacerIsXeno
Env.RacerFeatureSupport = ExtraUI.Capabilities
ExtraUI.Capabilities.drawing = false
if type(Drawing) == "table" and type(Drawing.new) == "function" then
    local ok, probe = pcall(Drawing.new, "Line")
    if ok and probe then
        ExtraUI.Capabilities.drawing = true
        pcall(function() probe:Remove() end)
    end
end
local DeathPosition = nil
local PlayerConnections = {}  
local RowConnections = {}
local Rows = {}
local TargetSet, TargetList, Records = {}, {}, {}
local TargetByModelName = {}  
local Folders = {}  
local ResolutionTokens = {}  
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
local updateLoops  
local targetTick  

-- NOSR 4.0 / professionally redesigned slate-and-ice interface.
-- Palette values are centralised so profile colour themes still apply.
local C_BG = Color3.fromRGB(10, 15, 27)
local C_PANEL = Color3.fromRGB(19, 27, 43)
local C_OFF = Color3.fromRGB(29, 39, 57)
local C_ON = Color3.fromRGB(30, 61, 79)
local C_SELECTED = Color3.fromRGB(37, 57, 76)
local C_TEXT = Color3.fromRGB(236, 243, 252)
local C_FAINT = Color3.fromRGB(148, 165, 190)
local C_ACCENT = Color3.fromRGB(110, 199, 255)
local C_NAV = Color3.fromRGB(15, 22, 37)
local C_NAV_OFF = Color3.fromRGB(25, 35, 53)
local C_NAV_HOVER = Color3.fromRGB(43, 56, 76)
local C_NAV_SELECTED = Color3.fromRGB(34, 63, 84)
local C_BORDER = Color3.fromRGB(51, 68, 90)
local C_MUTED = Color3.fromRGB(96, 114, 137)
local DESIGN_WIDTH, DESIGN_HEIGHT = 870, 700

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
-- A real corner helper replaces the placeholder from the original UI.
local function round(obj, radius)
    local existing = obj:FindFirstChildOfClass("UICorner")
    if existing then
        existing.CornerRadius = UDim.new(0, radius == 0 and 10 or (radius or 10))
    else
        make("UICorner", {Parent = obj, CornerRadius = UDim.new(0,
            radius == 0 and 10 or (radius or 10))})
    end
    return obj
end
local function label(parent, title, y, height, color, size)
    return make("TextLabel", {
        Parent = parent, Position = UDim2.fromOffset(11, y),
        Size = UDim2.new(1, -22, 0, height), BackgroundTransparency = 1,
        Text = title, TextColor3 = color or C_TEXT,
        TextSize = size or 12, Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
    })
end
local function button(parent, title, x, y, w, h)
    local nested = parent:IsA("ScrollingFrame") and parent.Name ~= "ModulePanel"
    local result = round(make("TextButton", {
        Parent = parent, Position = UDim2.fromOffset(nested and 8 or x, y),
        Size = nested and UDim2.new(1, -19, 0, h) or UDim2.fromOffset(w, h),
        BackgroundColor3 = C_OFF, BorderSizePixel = 0, AutoButtonColor = false,
        Text = title, TextColor3 = C_TEXT, Font = Enum.Font.GothamSemibold,
        TextSize = 12, TextTruncate = Enum.TextTruncate.AtEnd,
        TextXAlignment = w <= 78 and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left,
    }), w <= 78 and 9 or 10)
    if w > 78 then
        make("UIPadding", {Parent = result, PaddingLeft = UDim.new(0, 15),
            PaddingRight = UDim.new(0, 12)})
    end
    make("UIStroke", {Parent = result, Color = C_BORDER,
        Thickness = 1, Transparency = 0.55})
    local tweenService = game:GetService("TweenService")
    bind(result.MouseEnter:Connect(function()
        if S.closed then return end
        local target = (result:GetAttribute("SpectraTab") and C_NAV_HOVER)
            or (result:GetAttribute("SpectraOn") and C_SELECTED)
            or C_NAV_HOVER
        tweenService:Create(result, TweenInfo.new(0.14, Enum.EasingStyle.Quad),
            {BackgroundColor3 = target}):Play()
    end))
    bind(result.MouseLeave:Connect(function()
        if S.closed then return end
        local target = result:GetAttribute("SpectraTab")
            and (result:GetAttribute("SpectraOn") and C_NAV_SELECTED or C_NAV_OFF)
            or result:GetAttribute("SpectraHeader") and C_NAV_OFF
            or result:GetAttribute("SpectraOn") and C_ON or C_OFF
        tweenService:Create(result, TweenInfo.new(0.16, Enum.EasingStyle.Quad),
            {BackgroundColor3 = target}):Play()
    end))
    return result
end
local function style(btn, value, on, off)
    btn.Text = value and on or off
    btn:SetAttribute("SpectraOn", value)
    btn.BackgroundColor3 = value and C_ON or C_OFF
    local stroke = btn:FindFirstChildOfClass("UIStroke")
    if stroke then
        stroke.Color = value and C_ACCENT or C_BORDER
        stroke.Transparency = value and 0.16 or 0.58
    end
    local light = btn:FindFirstChild("NosrState")
    if not light then
        light = make("Frame", {Name = "NosrState", Parent = btn,
            AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -9, 0.5, 0),
            Size = UDim2.fromOffset(6, 6), BorderSizePixel = 0})
        round(light, 3)
    end
    light.BackgroundColor3 = value and C_ACCENT or C_MUTED
end

-- Consistent canvas sizing is essential for dynamically populated lists.
-- Roblox AutomaticCanvasSize can conflict with UIListLayout under nested scrollers,
-- so maintain CanvasSize directly using the layout's measured content height.
local function keepScrollCanvasUpToDate(scrollFrame, layout, verticalPadding)
    scrollFrame.Active = true
    scrollFrame.ScrollingEnabled = true
    scrollFrame.ClipsDescendants = true
    scrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.None

    local function updateCanvas()
        if not scrollFrame.Parent then return end
        local height = math.ceil(layout.AbsoluteContentSize.Y + (verticalPadding or 0))
        scrollFrame.CanvasSize = UDim2.fromOffset(0, math.max(height, 0))
        local maximum = math.max(0, height - scrollFrame.AbsoluteSize.Y)
        if scrollFrame.CanvasPosition.Y > maximum then
            scrollFrame.CanvasPosition = Vector2.new(scrollFrame.CanvasPosition.X, maximum)
        end
    end
    bind(layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas))
    bind(scrollFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateCanvas))
    task.defer(updateCanvas)
end

local Gui = make("ScreenGui", {
    Name = "RACER_UI", Parent = PlayerGui, ResetOnSpawn = false,
    DisplayOrder = 2200, IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})
local Main = round(make("Frame", {
    Name = "NosrControlConsole", Parent = Gui, AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(DESIGN_WIDTH, DESIGN_HEIGHT),
    BackgroundColor3 = C_BG, BorderSizePixel = 0, Active = true,
    ClipsDescendants = true,
}), 18)
make("UIStroke", {Parent = Main, Color = C_BORDER, Thickness = 1,
    Transparency = 0.15})
local MainScale = make("UIScale", {Parent = Main, Scale = 1})
local function fitConsoleToViewport()
    local camera = Workspace.CurrentCamera
    local viewport = camera and camera.ViewportSize or Vector2.new(1280, 720)
    local factor = math.min(1.2, (viewport.X - 24) / DESIGN_WIDTH,
        (viewport.Y - 32) / DESIGN_HEIGHT)
    MainScale.Scale = math.clamp(math.min(S.uiScale, factor), 0.55, 1.2)
end
ExtraUI.updateUiScale = fitConsoleToViewport
if Workspace.CurrentCamera then
    bind(Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fitConsoleToViewport))
end
bind(Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    local camera = Workspace.CurrentCamera
    if camera then
        bind(camera:GetPropertyChangedSignal("ViewportSize"):Connect(fitConsoleToViewport))
        fitConsoleToViewport()
    end
end))
fitConsoleToViewport()

-- The chrome is independent of the page content, and remains visible while switching tabs.
local Header = make("Frame", {Name = "Header", Parent = Main,
    Position = UDim2.fromOffset(0, 0), Size = UDim2.fromOffset(DESIGN_WIDTH, 81),
    BackgroundColor3 = C_NAV, BorderSizePixel = 0})
make("UIGradient", {Parent = Header, Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, C_NAV),
    ColorSequenceKeypoint.new(1, C_BG),
}), Rotation = 0})
make("Frame", {Parent = Main, Position = UDim2.fromOffset(0, 80),
    Size = UDim2.fromOffset(DESIGN_WIDTH, 1), BackgroundColor3 = C_BORDER,
    BorderSizePixel = 0})
local HeaderAccent = make("Frame", {Parent = Header,
    Position = UDim2.fromOffset(0, 0), Size = UDim2.fromOffset(5, 80),
    BackgroundColor3 = C_ACCENT, BorderSizePixel = 0})
ExtraUI.Brand = round(make("Frame", {Parent = Header,
    Position = UDim2.fromOffset(22, 18), Size = UDim2.fromOffset(44, 44),
    BackgroundColor3 = C_ACCENT, BorderSizePixel = 0}), 12)
make("TextLabel", {Parent = ExtraUI.Brand, Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1, Text = "N", TextColor3 = C_BG,
    Font = Enum.Font.GothamBlack, TextSize = 27})
local Heading = label(Header, "NOSR", 14, 33, C_TEXT, 24)
Heading.Font = Enum.Font.GothamBold
Heading.Position = UDim2.fromOffset(82, 12)
Heading.Size = UDim2.fromOffset(230, 34)
Heading.Active = true
local Subtitle = label(Header, "CONTROL CONSOLE     /     V4", 45, 18, C_FAINT, 10)
Subtitle.Position = UDim2.fromOffset(83, 47)
Subtitle.Size = UDim2.fromOffset(450, 18)
ExtraUI.LivePill = round(make("Frame", {Parent = Header,
    Position = UDim2.fromOffset(640, 28), Size = UDim2.fromOffset(91, 25),
    BackgroundColor3 = C_ON, BorderSizePixel = 0}), 12)
make("UIStroke", {Parent = ExtraUI.LivePill, Color = C_ACCENT,
    Transparency = 0.6, Thickness = 1})
make("Frame", {Parent = ExtraUI.LivePill, Position = UDim2.fromOffset(11, 10),
    Size = UDim2.fromOffset(6, 6), BackgroundColor3 = C_ACCENT,
    BorderSizePixel = 0})
local LiveLabel = label(ExtraUI.LivePill, "ONLINE", 3, 18, C_TEXT, 10)
if Env.RacerIsXeno then LiveLabel.Text = "XENO" end
LiveLabel.Position = UDim2.fromOffset(26, 4)
LiveLabel.Size = UDim2.fromOffset(62, 18)
LiveLabel.Font = Enum.Font.GothamBold
local Minimise = button(Header, "–", 767, 26, 38, 30)
local Close = button(Header, "×", 813, 26, 38, 30)
for _, control in ipairs({Minimise, Close}) do
    control:SetAttribute("SpectraHeader", true)
    control.BackgroundColor3 = C_NAV_OFF
end
Close.TextColor3 = Color3.fromRGB(255, 164, 177)

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
local SelectedLabel = label(Main, "Targets: 0 selected", 231, 20, C_ACCENT, 11)
local ActiveLabel = label(Main, "Aim target: none", 250, 20, C_FAINT, 11)
local MultiBtn = button(Main, "MULTI TARGET: OFF", 11, 274, 153, 34)
local AliveBtn = button(Main, "ALIVE CHECK: ON", 175, 274, 154, 34)
local Silent = button(Main, "SILENT AIM: OFF", 11, 315, 153, 34)
local Trigger = button(Main, "TRIGGER: OFF", 175, 315, 154, 34)
local CameraBtn = button(Main, "CAMERA AIM: OFF", 11, 355, 153, 34)
local DotBtn = button(Main, "BOX + LINE: OFF", 175, 355, 154, 34)
local Hitbox = button(Main, "HITBOX: BODY", 11, 395, 153, 34)
local Wall = button(Main, "WALL CHECK: OFF", 175, 395, 154, 34)
local LeadText = label(Main, "PREDICTION: 0 ms", 478, 22, C_FAINT, 11)
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
    Name = "Sidebar", Position = UDim2.fromOffset(17, 99),
    Size = UDim2.fromOffset(184, 525), BackgroundColor3 = C_NAV,
    BorderSizePixel = 0}), 14)
make("UIStroke", {Parent = Sidebar, Color = C_BORDER, Thickness = 1,
    Transparency = 0.45})
local ModulesLabel = label(Sidebar, "WORKSPACE", 21, 21, C_FAINT, 10)
ModulesLabel.Position = UDim2.fromOffset(19, 19)
ModulesLabel.Font = Enum.Font.GothamBold
local NavigationHint = label(Sidebar, "CORE MODULES", 45, 18, C_MUTED, 9)
NavigationHint.Position = UDim2.fromOffset(19, 47)
local TargetTab = button(Sidebar, "01   TARGETS", 12, 83, 160, 51)
local AimTab = button(Sidebar, "02   COMBAT", 12, 146, 160, 51)
local ToolsTab = button(Sidebar, "03   GAMEPLAY", 12, 209, 160, 51)
ExtraUI.EspTab = button(Sidebar, "04   VISUALS", 12, 272, 160, 51)
local SettingsTab = button(Sidebar, "05   SETTINGS", 12, 335, 160, 51)
ExtraUI.SidebarHint = label(Sidebar,
    "SELECT A MODULE\nTHEN A CATEGORY", 418, 38, C_FAINT, 10)
ExtraUI.SidebarHint.Position = UDim2.fromOffset(18, 425)
ExtraUI.SidebarHint.TextWrapped = true
ExtraUI.SidebarHint.TextYAlignment = Enum.TextYAlignment.Top
ExtraUI.TabIndicators = {}
for _, tab in ipairs({TargetTab, AimTab, ToolsTab, ExtraUI.EspTab, SettingsTab}) do
    tab.TextXAlignment = Enum.TextXAlignment.Left
    tab.TextColor3 = C_TEXT
    tab.TextSize = 12
    tab.BackgroundColor3 = C_NAV_OFF
    local border = tab:FindFirstChildOfClass("UIStroke")
    if border then border.Transparency = 0.65 end
    ExtraUI.TabIndicators[tab] = round(make("Frame", {Parent = tab,
        Position = UDim2.fromOffset(0, 11), Size = UDim2.fromOffset(3, 29),
        BackgroundColor3 = C_ACCENT, BorderSizePixel = 0,
        Visible = false}), 3)
end
ExtraUI.BuildLabel = label(Sidebar, "NOSR   /   BUILD 04", 486, 18, C_MUTED, 9)
ExtraUI.BuildLabel.Position = UDim2.fromOffset(18, 487)

local StatusBar = round(make("Frame", {Parent = Main,
    Name = "StatusFooter", Position = UDim2.fromOffset(17, 638),
    Size = UDim2.fromOffset(836, 44), BackgroundColor3 = C_NAV,
    BorderSizePixel = 0}), 11)
make("UIStroke", {Parent = StatusBar, Color = C_BORDER, Thickness = 1,
    Transparency = 0.5})
round(make("Frame", {Parent = StatusBar, Position = UDim2.fromOffset(15, 18),
    Size = UDim2.fromOffset(7, 7), BackgroundColor3 = C_ACCENT,
    BorderSizePixel = 0}), 4)
Status.Parent = StatusBar
Status.Position = UDim2.fromOffset(34, 7)
Status.Size = UDim2.fromOffset(786, 30)
Status.TextColor3 = C_FAINT
Status.TextSize = 11
Status.Font = Enum.Font.GothamMedium

local function page()
    -- Each category owns a scrollable page; nested lists keep their own wheel input.
    local frame = round(make("ScrollingFrame", {
        Parent = Main, Name = "ModulePanel", Position = UDim2.fromOffset(0, 0),
        Size = UDim2.fromOffset(608, 405), BackgroundColor3 = C_PANEL,
        BorderSizePixel = 0, Visible = false,
        ClipsDescendants = true, ScrollBarThickness = 4,
        ScrollBarImageColor3 = C_ACCENT, ScrollingEnabled = true,
        Active = true, ScrollingDirection = Enum.ScrollingDirection.Y,
        AutomaticCanvasSize = Enum.AutomaticSize.None,
        CanvasSize = UDim2.fromOffset(0, 480),
    }), 13)
    make("UIStroke", {Parent = frame, Color = C_BORDER,
        Thickness = 1, Transparency = 0.42})
    return frame
end
local TargetsPage, AimPage, ToolsPage, SettingsPage =
    page(), page(), page(), page()
ExtraUI.GunsPage = page()
ExtraUI.EspPage = page()
ExtraUI.TeleportPage = page()
ExtraUI.StandPage = page()
ExtraUI.NotifyPage = page()
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
place(Refresh, TargetsPage, 12, 393, 166, 34)
ExtraUI.SelectAllBtn = button(TargetsPage, "SELECT ALL", 188, 393, 166, 34)

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
local WallBangBtn = button(AimPage, "ALL-GUN WALLBANG: OFF", 12, 247, 342, 36)
ExtraUI.WallBangInfo = label(AimPage, "WALLBANG: OFF", 289, 342, C_FAINT, 10)
local AutoKillBtn = button(AimPage, "AUTO KILL SELECTED: OFF", 12, 319, 342, 38)
ExtraUI.QuietKillBtn = button(AimPage, "QUIET AUTO KILL: OFF", 12, 363, 342, 30)
local ForceHitBtn = button(AimPage, "FORCE HIT: OFF", 12, 398, 166, 36)
ExtraUI.InfiniteRangeBtn = button(AimPage, "INFINITE RANGE: OFF", 188, 398, 166, 36)

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
if not ExtraUI.Capabilities.shopPurchase then
    AutoArmor.Text = "AUTO ARMOR: UNAVAILABLE IN XENO"
    AutoArmor.AutoButtonColor = false
    AutoArmor.BackgroundColor3 = C_OFF
    AutoBuyPrev.Visible = false
    AutoBuyName.Visible = false
    AutoBuyNext.Visible = false
    AutoBuyToggle.Visible = false
    AutoBuyNow.Visible = false
    AutoBuyCount.Text = "SHOP AUTOMATION UNAVAILABLE IN XENO"
end

label(ExtraUI.GunsPage, "RAPID FIRE  /  PER WEAPON", 16, 22, C_ACCENT, 12)
label(ExtraUI.GunsPage, "Hold fire. Shotgun damage cadence is server controlled.",
    43, 22, C_FAINT, 10)
ExtraUI.ServerHit = label(ExtraUI.GunsPage, "SERVER HIT: waiting for a shot", 57, 18, C_FAINT, 10)
ExtraUI.BulletModeNames = {"CURSOR", "360 SPIN", "360 RANDOM"}
ExtraUI.BulletModeBtn = button(ExtraUI.GunsPage, "BULLET DIRECTION: CURSOR", 12, 83, 342, 36)
label(ExtraUI.GunsPage, "360 shots rotate independently of your cursor.",
    125, 21, C_FAINT, 10)
ExtraUI.GunList = round(make("ScrollingFrame", {
    Parent = ExtraUI.GunsPage, Position = UDim2.fromOffset(12, 150),
    Size = UDim2.fromOffset(342, 235), BackgroundColor3 = C_BG,
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
keepScrollCanvasUpToDate(ExtraUI.GunList, ExtraUI.GunLayout, 16)
label(ExtraUI.EspPage, "PLAYER OVERLAY  /  ALL PLAYERS", 16, 22, C_ACCENT, 12)
label(ExtraUI.EspPage, "Screen overlay with optional R15/R6 joints.", 43, 22, C_FAINT, 10)
ExtraUI.EspMain = button(ExtraUI.EspPage, "ESP: OFF", 12, 76, 342, 38)
ExtraUI.EspBoxes = button(ExtraUI.EspPage, "BOXES: ON", 12, 125, 166, 36)
ExtraUI.EspSkeleton = button(ExtraUI.EspPage, "SKELETON: OFF", 188, 125, 166, 36)
ExtraUI.EspNames = button(ExtraUI.EspPage, "NAMES: ON", 12, 171, 166, 36)
ExtraUI.EspDistance = button(ExtraUI.EspPage, "DISTANCE: ON", 188, 171, 166, 36)
ExtraUI.EspRange = button(ExtraUI.EspPage, "RANGE: ALL", 12, 217, 342, 36)
ExtraUI.EspColor = button(ExtraUI.EspPage, "COLOR: CYAN", 12, 263, 342, 36)
ExtraUI.AntiLockBtn = button(ExtraUI.EspPage, "ANTI-LOCK MOVEMENT: OFF", 12, 328, 342, 36)
label(ExtraUI.EspPage, "Varies your moving path to hinder prediction. Cannot stop", 373, 20, C_FAINT, 10)
label(ExtraUI.EspPage, "all client-side locks or server-validated hits.", 391, 20, C_FAINT, 10)
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
label(ExtraUI.StandPage, "!attack 1-5 / !snipe / !down / !stop", 292, 24, C_TEXT, 11)
label(ExtraUI.StandPage, "!protect / !counter / !driveby / !ambush", 318, 24, C_TEXT, 11)
ExtraUI.ChatSpyBtn = button(ExtraUI.StandPage, "CHAT SPY: OFF", 12, 343, 166, 30)
ExtraUI.JumpBypassBtn = button(ExtraUI.StandPage, "JUMP BYPASS: OFF", 188, 343, 166, 30)
ExtraUI.StandAfkBtn = button(ExtraUI.StandPage, "PERMANENT AFK: OFF", 12, 381, 342, 30)
ExtraUI.StandStatus = label(ExtraUI.StandPage, "Standing by.", 414, 30, C_FAINT, 11)
ExtraUI.StandStatus.TextWrapped = true
ExtraUI.StandStatus.TextTruncate = Enum.TextTruncate.None

 
ExtraUI.Notify = {watchers = {}, knownModels = {}, lastRespawnAt = {}, log = {}}
label(ExtraUI.NotifyPage, "NOTIFICATIONS  /  SELECTED TARGETS", 15, 23, C_ACCENT, 12)
label(ExtraUI.NotifyPage, "Tracks selected players only; no continuous scans.", 39, 20, C_FAINT, 10)
ExtraUI.NotifyMaster = button(ExtraUI.NotifyPage, "NOTIFICATIONS: ON", 12, 65, 342, 34)
ExtraUI.NotifySettings = make("ScrollingFrame", {
    Parent = ExtraUI.NotifyPage, Position = UDim2.fromOffset(12, 105),
    Size = UDim2.fromOffset(342, 146), BackgroundColor3 = C_BG,
    BorderSizePixel = 0, ScrollBarThickness = 5,
    ScrollingDirection = Enum.ScrollingDirection.Y,
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    CanvasSize = UDim2.fromOffset(0, 0),
})
local NotifySettingsLayout = make("UIListLayout", {Parent = ExtraUI.NotifySettings,
    SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5)})
keepScrollCanvasUpToDate(ExtraUI.NotifySettings, NotifySettingsLayout, 8)
ExtraUI.NotifyOptions = {
    {"downed", "TARGET DOWNED"}, {"dead", "TARGET DEAD"},
    {"respawned", "TARGET RESPAWNED"}, {"lowHealth", "TARGET LOW HP (30)"},
    {"ownRespawn", "MY RESPAWN"}, {"antiStomp", "ANTI-STOMP STATUS"},
    {"selected", "TARGET SELECTED"}, {"popups", "ON-SCREEN POPUPS"},
}
ExtraUI.NotifyButtons = {}
for index, item in ipairs(ExtraUI.NotifyOptions) do
    local key, name = item[1], item[2]
    local btn = button(ExtraUI.NotifySettings, "", 3, 0, 326, 30)
    btn.LayoutOrder = index
    btn.Size = UDim2.new(1, -10, 0, 30)
    ExtraUI.NotifyButtons[key] = btn
    bind(btn.MouseButton1Click:Connect(function()
        S.notify[key] = not S.notify[key]
        style(btn, S.notify[key], name .. ": ON", name .. ": OFF")
    end))
end
label(ExtraUI.NotifyPage, "RECENT EVENTS", 259, 22, C_ACCENT, 11)
ExtraUI.NotifyClear = button(ExtraUI.NotifyPage, "CLEAR", 271, 259, 83, 25)
ExtraUI.NotifyHistory = make("ScrollingFrame", {
    Parent = ExtraUI.NotifyPage, Position = UDim2.fromOffset(12, 292),
    Size = UDim2.fromOffset(342, 94), BackgroundColor3 = C_BG,
    BorderSizePixel = 0, ScrollBarThickness = 5,
    ScrollingDirection = Enum.ScrollingDirection.Y,
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    CanvasSize = UDim2.fromOffset(0, 0),
})
local NotifyHistoryLayout = make("UIListLayout", {Parent = ExtraUI.NotifyHistory,
    SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 3)})
keepScrollCanvasUpToDate(ExtraUI.NotifyHistory, NotifyHistoryLayout, 8)
ExtraUI.NotifyToastHost = make("Frame", {
    Parent = Gui, Position = UDim2.new(1, -320, 0, 75),
    Size = UDim2.fromOffset(304, 230), BackgroundTransparency = 1,
    BorderSizePixel = 0, ZIndex = 40,
})
make("UIListLayout", {Parent = ExtraUI.NotifyToastHost,
    SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5)})
ExtraUI.Notify.refreshButtons = function()
    style(ExtraUI.NotifyMaster, S.notify.enabled,
        "NOTIFICATIONS: ON", "NOTIFICATIONS: OFF")
    for _, item in ipairs(ExtraUI.NotifyOptions) do
        local key, name = item[1], item[2]
        style(ExtraUI.NotifyButtons[key], S.notify[key],
            name .. ": ON", name .. ": OFF")
    end
end
ExtraUI.Notify.refreshButtons()
bind(ExtraUI.NotifyMaster.MouseButton1Click:Connect(function()
    S.notify.enabled = not S.notify.enabled
    ExtraUI.Notify.refreshButtons()
end))
bind(ExtraUI.NotifyClear.MouseButton1Click:Connect(function()
    table.clear(ExtraUI.Notify.log)
    for _, entry in ipairs(ExtraUI.NotifyHistory:GetChildren()) do
        if entry:IsA("TextLabel") then entry:Destroy() end
    end
end))
ExtraUI.Notify.emit = function(key, message)
    if S.closed or not S.notify.enabled or not S.notify[key] then return end
    local stamp = os.date("%H:%M:%S")
    local line = ("[%s] %s"):format(stamp, message)
    table.insert(ExtraUI.Notify.log, 1, line)
    if #ExtraUI.Notify.log > 40 then table.remove(ExtraUI.Notify.log) end
    local entry = make("TextLabel", {
        Parent = ExtraUI.NotifyHistory, Size = UDim2.new(1, -9, 0, 28),
        BackgroundColor3 = C_PANEL, BorderSizePixel = 0,
        Text = "  " .. line, TextWrapped = true, TextColor3 = C_TEXT,
        Font = Enum.Font.Gotham, TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = -math.floor(os.clock() * 1000),
    })
    if #ExtraUI.NotifyHistory:GetChildren() > 44 then
        for _, child in ipairs(ExtraUI.NotifyHistory:GetChildren()) do
            if child:IsA("TextLabel") and child ~= entry
                and child.LayoutOrder < math.huge then
                 
                local oldest = child
                for _, other in ipairs(ExtraUI.NotifyHistory:GetChildren()) do
                    if other:IsA("TextLabel") and other.LayoutOrder > oldest.LayoutOrder then
                        oldest = other
                    end
                end
                oldest:Destroy()
                break
            end
        end
    end
    if not S.notify.popups then return end
    local toast = make("TextLabel", {
        Parent = ExtraUI.NotifyToastHost, Size = UDim2.new(1, 0, 0, 47),
        BackgroundColor3 = C_NAV, BorderSizePixel = 0,
        Text = "  NOSR SCRIPT  /  " .. message, TextWrapped = true,
        TextColor3 = C_TEXT, Font = Enum.Font.GothamBold,
        TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 42,
    })
    make("UIStroke", {Parent = toast, Color = C_ACCENT, Thickness = 1})
    task.delay(4, function() if toast.Parent then toast:Destroy() end end)
    for _, item in ipairs(ExtraUI.NotifyToastHost:GetChildren()) do
        if item:IsA("TextLabel") and item ~= toast and
            #ExtraUI.NotifyToastHost:GetChildren() > 5 then item:Destroy() end
    end
end
ExtraUI.Notify.detach = function(p)
    local old = ExtraUI.Notify.watchers[p]
    if not old then return end
    for _, connection in ipairs(old.connections) do connection:Disconnect() end
    ExtraUI.Notify.watchers[p] = nil
end
ExtraUI.Notify.check = function(p, w)
    if S.closed or ExtraUI.Notify.watchers[p] ~= w or not TargetSet[p] then return end
    local rec = w.record
    local hum = rec.humanoid
    if not hum.Parent then return end
    local effects = rec.model:FindFirstChild("BodyEffects")
    local ko = effects and effects:FindFirstChild("K.O")
    local dead = effects and effects:FindFirstChild("Dead")
    local state = ((dead and dead:IsA("BoolValue") and dead.Value)
            or hum.Health <= 0) and "dead"
        or (ko and ko:IsA("BoolValue") and ko.Value) and "downed"
        or "healthy"
    if w.state ~= nil and state ~= w.state then
        if state == "downed" then
            ExtraUI.Notify.emit("downed", "@" .. p.Name .. " was downed")
        elseif state == "dead" then
            ExtraUI.Notify.emit("dead", "@" .. p.Name .. " died")
        end
    end
    w.state = state
    local low = state == "healthy" and hum.Health > 0 and hum.Health <= 30
    if w.low ~= nil and low and not w.low then
        ExtraUI.Notify.emit("lowHealth", "@" .. p.Name .. " has "
            .. math.floor(hum.Health) .. " HP")
    end
    w.low = low
end
ExtraUI.Notify.attach = function(p, rec)
    local previous = ExtraUI.Notify.watchers[p]
    if previous and rec and previous.model == rec.model then return end
    ExtraUI.Notify.detach(p)
    if not rec or not rec.model or not rec.model.Parent then return end
    local last = ExtraUI.Notify.knownModels[p]
    if last and last ~= rec.model
        and os.clock() - (ExtraUI.Notify.lastRespawnAt[p] or -math.huge) > 1.3 then
        ExtraUI.Notify.emit("respawned", "@" .. p.Name .. " respawned")
        ExtraUI.Notify.lastRespawnAt[p] = os.clock()
    end
    ExtraUI.Notify.knownModels[p] = rec.model
    local w = {model = rec.model, record = rec,
        connections = {}, state = nil, low = nil, flags = {}}
    ExtraUI.Notify.watchers[p] = w
    local function add(connection)
        w.connections[#w.connections + 1] = connection
    end
    local function watchFlag(flag)
        if w.flags[flag] or not flag:IsA("BoolValue") then return end
        if flag.Name ~= "K.O" and flag.Name ~= "Dead" then return end
        w.flags[flag] = true
        add(flag:GetPropertyChangedSignal("Value"):Connect(function()
            ExtraUI.Notify.check(p, w)
        end))
    end
    local function watchEffects(effects)
        if not effects or w.effects == effects then return end
        w.effects = effects
        for _, child in ipairs(effects:GetChildren()) do watchFlag(child) end
        add(effects.ChildAdded:Connect(function(child)
            watchFlag(child)
            ExtraUI.Notify.check(p, w)
        end))
        ExtraUI.Notify.check(p, w)
    end
    add(rec.humanoid.HealthChanged:Connect(function()
        ExtraUI.Notify.check(p, w)
    end))
    add(rec.model.ChildAdded:Connect(function(child)
        if child.Name == "BodyEffects" then watchEffects(child) end
    end))
    watchEffects(rec.model:FindFirstChild("BodyEffects"))
    ExtraUI.Notify.check(p, w)
end

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
label(ExtraUI.ConfigPage, "FPS SHARE  /  BODY DISPLAY", 315, 18, C_ACCENT, 11)
ExtraUI.FpsToggle = button(ExtraUI.ConfigPage, "FPS SHARE: OFF", 12, 336, 342, 28)
make("TextLabel", {Parent = ExtraUI.ConfigPage,
    Position = UDim2.fromOffset(12, 365), Size = UDim2.fromOffset(166, 13),
    BackgroundTransparency = 1, Text = "BASE FPS", TextColor3 = C_FAINT,
    Font = Enum.Font.Gotham, TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left})
make("TextLabel", {Parent = ExtraUI.ConfigPage,
    Position = UDim2.fromOffset(188, 365), Size = UDim2.fromOffset(166, 13),
    BackgroundTransparency = 1, Text = "DROP BY", TextColor3 = C_FAINT,
    Font = Enum.Font.Gotham, TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left})
ExtraUI.FpsBaseBox = make("TextBox", {Parent = ExtraUI.ConfigPage,
    Position = UDim2.fromOffset(12, 379), Size = UDim2.fromOffset(166, 26),
    BackgroundColor3 = C_OFF, BorderSizePixel = 0, Text = "999",
    PlaceholderText = "BASE FPS", ClearTextOnFocus = false,
    TextColor3 = C_TEXT, Font = Enum.Font.GothamBold, TextSize = 12})
ExtraUI.FpsDropBox = make("TextBox", {Parent = ExtraUI.ConfigPage,
    Position = UDim2.fromOffset(188, 379), Size = UDim2.fromOffset(166, 26),
    BackgroundColor3 = C_OFF, BorderSizePixel = 0, Text = "150",
    PlaceholderText = "DROP BY", ClearTextOnFocus = false,
    TextColor3 = C_TEXT, Font = Enum.Font.GothamBold, TextSize = 12})
ExtraUI.FpsApply = button(ExtraUI.ConfigPage, "APPLY FPS VALUES", 12, 409, 342, 24)
label(ExtraUI.ConfigPage,
    "Above 999 is local only. May lower FPS while enabled.", 436, 13, C_FAINT, 10)

do
    local fpsRemote = ReplicatedStorage:WaitForChild("Storage")
        :WaitForChild("Remotes"):WaitForChild("FPSShare")
    local fps: any = {active = false, base = S.fpsBase, drop = S.fpsDrop,
        value = S.fpsBase, dropped = false, generation = 0}
    local fpsHookData = nil
    ExtraUI.FpsState = fps

    local function clearOverlay()
        if fps.originalFrame and fps.originalFrame.Parent then
            fps.originalFrame.Visible = true
        end
        if fps.overlay then fps.overlay:Destroy() end
        fps.tag, fps.originalFrame, fps.overlay, fps.label = nil, nil, nil, nil
        fps.lastValue, fps.lastPing = nil, nil
    end

    local function refreshOverlay()
        if fps.base <= 999 then
            if fps.overlay then clearOverlay() end
            return
        end
        local character = Me.Character
        local torso = character and (character:FindFirstChild("UpperTorso")
            or character:FindFirstChild("Torso"))
        local tag = torso and torso:FindFirstChild("fpstag")
        if tag ~= fps.tag then
            clearOverlay()
            if tag then
                local frame = tag:FindFirstChildWhichIsA("Frame")
                if frame then
                    fps.tag, fps.originalFrame = tag, frame
                    fps.overlay = tag:Clone()
                    fps.overlay.Name = "NosrFPSLocalTag"
                    fps.overlay.Size = UDim2.new(6, 0, 0.55, 0)
                    fps.overlay.Parent = torso
                    local copyFrame = fps.overlay:FindFirstChildWhichIsA("Frame")
                    if copyFrame then copyFrame.Visible = true end
                    fps.label = fps.overlay:FindFirstChildWhichIsA("TextLabel", true)
                    frame.Visible = false
                end
            end
        end
        if not fps.overlay or not fps.label or not fps.tag then return end
        if fps.overlay.Enabled ~= fps.tag.Enabled then
            fps.overlay.Enabled = fps.tag.Enabled
        end
        local ping = Me:GetAttribute("Ping")
        if fps.value == fps.lastValue and ping == fps.lastPing then return end
        fps.lastValue, fps.lastPing = fps.value, ping
        local display = '<font color="#55ff7f">' .. tostring(fps.value)
            .. '</font><font color="#b9b9c0"> FPS</font>'
        if ping then
            display = display .. '<font color="#6e6e76">  |  </font>'
                .. '<font color="#ffcf71">' .. tostring(ping) .. 'ms</font>'
        end
        fps.label.Text = display
    end

    local function attachHook()
        if type(hookmetamethod) ~= "function"
            or type(newcclosure) ~= "function"
            or type(getnamecallmethod) ~= "function"
            or type(checkcaller) ~= "function" then
            return false
        end
        local previousGui = shared.NosrFPSGui
        if previousGui and type(previousGui.stop) == "function" then
            pcall(previousGui.stop)
        end
        fpsHookData = shared.NosrFPSHook
        if not fpsHookData or fpsHookData.remote ~= fpsRemote then
            fpsHookData = {remote = fpsRemote, activeState = nil}
            local previous
            previous = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
                if self == fpsHookData.remote and getnamecallmethod() == "FireServer"
                    and not checkcaller() then
                    local current = fpsHookData.activeState
                    if current and current.active then
                        current.dropped = not current.dropped
                        current.value = current.dropped
                            and (current.base - current.drop) or current.base
                        return previous(self, math.min(current.value, 999))
                    end
                end
                return previous(self, ...)
            end))
            shared.NosrFPSHook = fpsHookData
        end
        fpsHookData.remote = fpsRemote
        fpsHookData.activeState = fps
        return true
    end

    ExtraUI.stopFpsShare = function()
        fps.active = false
        fps.generation = fps.generation + 1
        if fpsHookData and fpsHookData.activeState == fps then
            fpsHookData.activeState = nil
        end
        clearOverlay()
    end
    ExtraUI.syncFpsShare = function()
        ExtraUI.FpsBaseBox.Text = tostring(S.fpsBase)
        ExtraUI.FpsDropBox.Text = tostring(S.fpsDrop)
        if not S.fpsShare then
            ExtraUI.stopFpsShare()
            style(ExtraUI.FpsToggle, false, "FPS SHARE: ON", "FPS SHARE: OFF")
            return
        end
        local ok, attached = pcall(attachHook)
        if not ok or not attached then
            S.fpsShare = false
            ExtraUI.stopFpsShare()
            ExtraUI.FpsToggle.Text = "FPS SHARE: UNAVAILABLE"
            ExtraUI.ConfigStatus.Text = "FPS Share needs Real's namecall hook."
            return
        end
        fps.base, fps.drop = S.fpsBase, S.fpsDrop
        fps.value, fps.dropped, fps.active = S.fpsBase, false, true
        fps.generation = fps.generation + 1
        local generation = fps.generation
        task.spawn(function()
            while not S.closed and S.fpsShare and generation == fps.generation do
                refreshOverlay()
                task.wait(0.12)
            end
        end)
        fpsRemote:FireServer(math.min(fps.value, 999))
        style(ExtraUI.FpsToggle, true, "FPS SHARE: ON", "FPS SHARE: OFF")
    end
    local function readFpsBoxes()
        local base = tonumber(ExtraUI.FpsBaseBox.Text)
        local drop = tonumber(ExtraUI.FpsDropBox.Text)
        if not base or not drop then
            ExtraUI.ConfigStatus.Text = "Enter valid FPS and drop numbers."
            return false
        end
        S.fpsBase = math.clamp(math.floor(base), 1, 1000000000000)
        S.fpsDrop = math.clamp(math.floor(drop), 0, S.fpsBase - 1)
        return true
    end
    bind(ExtraUI.FpsToggle.MouseButton1Click:Connect(function()
        if not S.fpsShare and not readFpsBoxes() then return end
        S.fpsShare = not S.fpsShare
        ExtraUI.syncFpsShare()
    end))
    bind(ExtraUI.FpsApply.MouseButton1Click:Connect(function()
        if not readFpsBoxes() then return end
        ExtraUI.syncFpsShare()
        ExtraUI.ConfigStatus.Text = "FPS values applied at 0.8s intervals."
    end))
end

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
    function(value) S.uiScale = value; ExtraUI.updateUiScale() end,
    function(value) return string.format("%.2f×", value) end)
local ThemeNames = {"ICE", "MINT", "VIOLET", "AMBER"}
local ThemeColors = {
    Color3.fromRGB(110, 199, 255), Color3.fromRGB(93, 225, 196),
    Color3.fromRGB(184, 151, 241), Color3.fromRGB(244, 164, 100),
}
local ThemeBtn = button(SettingsPage, "ACCENT: ICE", 12, 407, 166, 30)
ExtraUI.RespawnDeathBtn = button(SettingsPage, "RESPAWN AT DEATH: OFF", 188, 407, 166, 30)
local function applyTheme(index)
    local old = C_ACCENT
    local oldNav = C_NAV_SELECTED
    C_ACCENT = ThemeColors[index]
    C_NAV_SELECTED = C_NAV:Lerp(C_ACCENT, 0.18)
    for _, item in ipairs(Gui:GetDescendants()) do
        if item:IsA("UIStroke") and item.Color == old then item.Color = C_ACCENT end
        if item:IsA("TextLabel") and item.TextColor3 == old then item.TextColor3 = C_ACCENT end
        if item:IsA("TextButton") and item.TextColor3 == old then item.TextColor3 = C_ACCENT end
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

-- Reflow legacy coordinate-based controls into a wider, spacious card system.
-- The controls themselves are moved rather than recreated: all event handlers stay wired.
local function reflowPage(frame)
    local direct = frame:GetChildren()
    for _, child in ipairs(direct) do
        if child:IsA("GuiObject") then
            local p, sz = child.Position, child.Size
            if p.X.Scale == 0 then
                local x = math.floor(18 + (p.X.Offset - 12) * (564 / 342) + 0.5)
                child.Position = UDim2.new(0, math.max(14, x), p.Y.Scale, p.Y.Offset)
            end
            if sz.X.Scale == 0 and sz.X.Offset > 0 then
                local newWidth = math.floor(sz.X.Offset * (564 / 342) + 0.5)
                child.Size = UDim2.new(0, math.min(568, newWidth), sz.Y.Scale, sz.Y.Offset)
            elseif sz.X.Scale == 1 then
                child.Size = UDim2.new(1, -38, sz.Y.Scale, sz.Y.Offset)
            end
            if child:IsA("TextLabel") then
                child.TextSize = math.min(14, child.TextSize + 1)
                if child.TextColor3 == C_ACCENT then
                    child.Font = Enum.Font.GothamBold
                end
            elseif child:IsA("TextButton") then
                child.Font = Enum.Font.GothamSemibold
            elseif child:IsA("TextBox") then
                round(child, 9)
                make("UIStroke", {Parent = child, Color = C_BORDER,
                    Thickness = 1, Transparency = 0.35})
            elseif child:IsA("ScrollingFrame") then
                child.ScrollBarThickness = 5
                child.ScrollBarImageColor3 = C_ACCENT
                round(child, 10)
            end
        end
    end
    frame.CanvasSize = UDim2.fromOffset(0, 480)
end
for _, frame in ipairs({TargetsPage, AimPage, ToolsPage, SettingsPage,
    ExtraUI.GunsPage, ExtraUI.EspPage, ExtraUI.TeleportPage,
    ExtraUI.StandPage, ExtraUI.NotifyPage, ExtraUI.ConfigPage}) do
    reflowPage(frame)
end
-- Guns and notifications fit within the module viewport. Their inner lists scroll.
ExtraUI.GunsPage.CanvasSize = UDim2.fromOffset(0, 405)
ExtraUI.NotifyPage.CanvasSize = UDim2.fromOffset(0, 405)
ExtraUI.TeleportPage.CanvasSize = UDim2.fromOffset(0, 405)
ExtraUI.EspPage.CanvasSize = UDim2.fromOffset(0, 440)

ExtraUI.HubControllers = {}
local function groupedPage(title, caption, sections)
    local hub = make("Frame", {
        Parent = Main, Name = "DashboardHub", Position = UDim2.fromOffset(218, 99),
        Size = UDim2.fromOffset(635, 525), BackgroundTransparency = 1,
        Visible = false, ClipsDescendants = true,
    })
    local heading = label(hub, title, 6, 29, C_TEXT, 20)
    heading.Font = Enum.Font.GothamBold
    heading.Position = UDim2.fromOffset(5, 4)
    heading.Size = UDim2.fromOffset(610, 29)
    local desc = label(hub, caption, 38, 18, C_FAINT, 11)
    desc.Position = UDim2.fromOffset(6, 40)
    desc.Size = UDim2.fromOffset(610, 18)
    local TabsRail = round(make("Frame", {Parent = hub,
        Position = UDim2.fromOffset(6, 68), Size = UDim2.fromOffset(619, 40),
        BackgroundColor3 = C_NAV, BorderSizePixel = 0}), 10)
    make("UIStroke", {Parent = TabsRail, Color = C_BORDER,
        Transparency = 0.58, Thickness = 1})
    local buttons = {}
    local activeIndex = 1
    local function openSection(index)
        activeIndex = index
        for n, section in ipairs(sections) do
            local isOn = n == index
            section[2].Visible = isOn
            section[2].ScrollingEnabled = true
            local btn = buttons[n]
            btn:SetAttribute("SpectraOn", isOn)
            btn.BackgroundColor3 = isOn and C_NAV_SELECTED or C_NAV_OFF
            btn.TextColor3 = isOn and C_ACCENT or C_FAINT
            local border = btn:FindFirstChildOfClass("UIStroke")
            if border then
                border.Color = isOn and C_ACCENT or C_BORDER
                border.Transparency = isOn and 0.43 or 1
            end
        end
    end
    for index, section in ipairs(sections) do
        local panel = section[2]
        panel.Parent = hub
        panel.Position = UDim2.fromOffset(6, 119)
        panel.Size = UDim2.fromOffset(619, 405)
        panel.Visible = false
        local n = #sections
        local gap = 6
        local width = math.floor((603 - (n - 1) * gap) / n)
        local x = 8 + (index - 1) * (width + gap)
        local btn = button(TabsRail, section[1], x, 5, width, 30)
        btn.TextSize = 10
        btn.TextXAlignment = Enum.TextXAlignment.Center
        btn:SetAttribute("SpectraTab", true)
        local padding = btn:FindFirstChildOfClass("UIPadding")
        if padding then padding:Destroy() end
        buttons[index] = btn
        bind(btn.MouseButton1Click:Connect(function() openSection(index) end))
    end
    openSection(1)
    ExtraUI.HubControllers[hub] = function() openSection(activeIndex) end
    return hub
end
ExtraUI.TargetsHub = groupedPage("Target selection",
    "Search and organise players in your session.", {{"PLAYERS", TargetsPage}})
ExtraUI.CombatPage = groupedPage("Combat controls",
    "Targeting, advanced weapon options and fire-rate presets.", {
        {"AIM & TARGETING", AimPage}, {"FIRE RATE & GUN MODS", ExtraUI.GunsPage}})
ExtraUI.GameplayPage = groupedPage("Gameplay utilities",
    "Utility actions, companion commands and location shortcuts.", {
        {"TOOLS", ToolsPage}, {"STAND COMMANDS", ExtraUI.StandPage},
        {"TELEPORTS", ExtraUI.TeleportPage}})
ExtraUI.VisualsPage = groupedPage("Visuals & alerts",
    "On-screen overlays, visual preferences and event tracking.", {
        {"PLAYER ESP", ExtraUI.EspPage}, {"NOTIFICATIONS", ExtraUI.NotifyPage}})
ExtraUI.OptionsPage = groupedPage("Settings & profiles",
    "Tune movement, personalise the interface and manage profiles.", {
        {"PREFERENCES", SettingsPage}, {"PROFILES", ExtraUI.ConfigPage}})

-- Nested scrolling input routing (Fire Rate / Gun Mods / Notifications).
-- Let the hovered inner list take priority over its outer grouped page.
local function wireNestedScrolling(inner)
    local outer = inner:FindFirstAncestorOfClass("ScrollingFrame")
    if not outer then return end

    local function mouseIsInside()
        if not Gui.Enabled then return false end
        local ancestor = inner
        while ancestor and ancestor ~= Gui do
            if ancestor:IsA("GuiObject") and not ancestor.Visible then return false end
            ancestor = ancestor.Parent
        end
        local mouse = UIS:GetMouseLocation()
        local pos, size = inner.AbsolutePosition, inner.AbsoluteSize
        return mouse.X >= pos.X and mouse.X < pos.X + size.X
            and mouse.Y >= pos.Y and mouse.Y < pos.Y + size.Y
    end

    bind(inner.MouseEnter:Connect(function()
        if mouseIsInside() then outer.ScrollingEnabled = false end
    end))
    bind(inner.MouseLeave:Connect(function()
        outer.ScrollingEnabled = true
    end))
    bind(inner.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            outer.ScrollingEnabled = false
        end
    end))
    bind(inner.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            outer.ScrollingEnabled = true
        end
    end))
    bind(UIS.InputChanged:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseWheel or not mouseIsInside() then
            return
        end
        outer.ScrollingEnabled = false
        local before = inner.CanvasPosition.Y
        local wheelDelta = input.Position.Z
        -- If the Roblox native scroll controller already handled the wheel,
        -- do nothing. Otherwise, scroll this panel explicitly.
        task.defer(function()
            if not inner.Parent or not mouseIsInside() then return end
            if math.abs(inner.CanvasPosition.Y - before) > 0.5 then return end
            local maxY = math.max(0, inner.AbsoluteCanvasSize.Y - inner.AbsoluteWindowSize.Y)
            local nextY = math.clamp(before - wheelDelta * 54, 0, maxY)
            inner.CanvasPosition = Vector2.new(inner.CanvasPosition.X, nextY)
        end)
    end))
end

wireNestedScrolling(ExtraUI.GunList)
wireNestedScrolling(ExtraUI.NotifySettings)
wireNestedScrolling(ExtraUI.NotifyHistory)

ExtraUI.PageViews = {targets = ExtraUI.TargetsHub, combat = ExtraUI.CombatPage,
    gameplay = ExtraUI.GameplayPage, visuals = ExtraUI.VisualsPage,
    options = ExtraUI.OptionsPage}
ExtraUI.NavButtons = {targets = TargetTab, combat = AimTab,
    gameplay = ToolsTab, visuals = ExtraUI.EspTab, options = SettingsTab}
local CurrentTab = "targets"
local function showTab(which)
    CurrentTab = which
    Subtitle.Text = ({targets = "TARGET MANAGEMENT    /    LIVE",
        combat = "TARGETING    /    WEAPONS",
        gameplay = "TOOLS    /    UTILITIES",
        visuals = "OVERLAYS    /    EVENT TRACKING",
        options = "INTERFACE    /    PROFILES"})[which] or "CONTROL CONSOLE"
    for name, pageView in pairs(ExtraUI.PageViews) do
        pageView.Visible = name == which
        if pageView.Visible and ExtraUI.HubControllers[pageView] then
            ExtraUI.HubControllers[pageView]()
        end
    end
    for name, tab in pairs(ExtraUI.NavButtons) do
        local active = name == which
        tab.BackgroundColor3 = active and C_NAV_SELECTED or C_NAV_OFF
        tab.TextColor3 = active and C_ACCENT or C_TEXT
        ExtraUI.TabIndicators[tab].Visible = active
        tab:SetAttribute("SpectraTab", true)
        tab:SetAttribute("SpectraOn", active)
        local edge = tab:FindFirstChildOfClass("UIStroke")
        if edge then edge.Transparency = active and 0.38 or 0.7 end
    end
    local activePage = ExtraUI.PageViews[which]
    if activePage then
        activePage.Position = UDim2.fromOffset(226, 99)
        game:GetService("TweenService"):Create(activePage,
            TweenInfo.new(0.19, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
            {Position = UDim2.fromOffset(218, 99)}):Play()
    end
end
bind(TargetTab.MouseButton1Click:Connect(function() showTab("targets") end))
bind(AimTab.MouseButton1Click:Connect(function() showTab("combat") end))
bind(ToolsTab.MouseButton1Click:Connect(function() showTab("gameplay") end))
bind(ExtraUI.EspTab.MouseButton1Click:Connect(function() showTab("visuals") end))
bind(SettingsTab.MouseButton1Click:Connect(function() showTab("options") end))
showTab("targets")
local Minimized = false
bind(Minimise.MouseButton1Click:Connect(function()
    Minimized = not Minimized
    game:GetService("TweenService"):Create(Main,
        TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        {Size = UDim2.fromOffset(DESIGN_WIDTH, Minimized and 81 or DESIGN_HEIGHT)}):Play()
    Minimise.Text = Minimized and "+" or "–"
    Subtitle.Visible = not Minimized
    for _, tab in pairs(ExtraUI.NavButtons) do tab.Visible = not Minimized end
    Status.Visible = not Minimized
    StatusBar.Visible = not Minimized
    Sidebar.Visible = not Minimized
    if Minimized then
        for _, pageView in pairs(ExtraUI.PageViews) do pageView.Visible = false end
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
local RapidWatched = setmetatable({}, {__mode = "k"})
local RapidLast = setmetatable({}, {__mode = "k"})
local ReloadLast = setmetatable({}, {__mode = "k"})
local GunRows = {}
local GunRowCount = 0
 
local FixedPace = {
    ["[Revolver]"] = 0.01,
    ["[Double-Barrel SG]"] = 0.01,
    ["[TacticalShotgun]"] = 0.01,
    ["[Shotgun]"] = 0.01,
    ["[SMG]"] = 0.01,
}
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
        if type(cooldown) == "number" then
            if RapidOriginal[tool] == nil then
                RapidOriginal[tool] = cooldown ~= 0 and cooldown
                    or FixedPace[tool.Name] or cooldown
            end
            local pace = 0.01
            if cooldown ~= pace then tool:SetAttribute("Cooldown", pace) end
        end
    elseif RapidOriginal[tool] ~= nil then
        local original = RapidOriginal[tool]
        RapidOriginal[tool] = nil
        pcall(function() tool:SetAttribute("Cooldown", original) end)
    end
end
Rapid.getPace = function(tool)
    return 0.01
end
 
 
Rapid.lastShotAt = function(tool)
    return RapidLast[tool] or 0
end
Rapid.noteShot = function(tool)
    RapidLast[tool] = os.clock()
    S.lastAttemptWeaponName = tool.Name
end
Rapid.activate = function(tool)
    Rapid.noteShot(tool)
    return pcall(function() tool:Activate() end)
end
Rapid.noteConfirmed = function(name)
    if not name then return end
    Rapid.confirmedByName[name] = (Rapid.confirmedByName[name] or 0) + 1
end
Rapid.confirmedByName = {}
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
        say(name .. (S.rapidWeapons[name] and " 0.01s rapid fire enabled." or " cooldown restored."))
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
    if S.aura or not next(S.rapidWeapons) or UIS:GetFocusedTextBox()
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
            Rapid.activate(tool)
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
                if S.invisibleShot or S.standCounterTarget then
                    if not originals then
                        originals = {ReplicateBullets = handler.ReplicateBullets}
                        ShotVisualOriginal[handler] = originals
                    end
                    handler.ReplicateBullets = function(self, shot)
                        if ExtraUI.standObserveShot then
                            pcall(ExtraUI.standObserveShot, shot)
                        end
                        if S.invisibleShot and shot and shot.Player == Me then return end
                        return originals.ReplicateBullets(self, shot)
                    end
                    S.standCounterBulletHooked = S.standCounterTarget ~= nil
                elseif originals then
                    handler.ReplicateBullets = originals.ReplicateBullets
                    ShotVisualOriginal[handler] = nil
                    S.standCounterBulletHooked = false
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
    local adaptiveBtn = button(ExtraUI.GunList, "FIRE RATE: 0.01S", 5, 0, 326, 35)
    adaptiveBtn.LayoutOrder = -5
    bind(adaptiveBtn.MouseButton1Click:Connect(function()
        say("Rapid fire uses fixed intervals by weapon; turn on the weapon row below.")
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
        if ExtraUI.Capabilities.gunManager == false then return end
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
    ExtraUI.KnifeTravelBtn = button(ExtraUI.GunList, "KNIFE TRAVEL: OFF", 5, 0, 326, 35)
    ExtraUI.KnifeTravelBtn.LayoutOrder = 2
    ExtraUI.AuraBtn = button(ExtraUI.GunList, "AURA 75 STUDS: OFF", 5, 0, 326, 35)
    ExtraUI.AuraBtn.LayoutOrder = 3
    ExtraUI.knifeTravelGun = nil
    ExtraUI.knifeTravelCombatAt = 0
    ExtraUI.knifeTravelSwitchAt = 0
    ExtraUI.knifeTravelTickAt = 0
    ExtraUI.restoreTravelGun = function(fireAfterEquip)
        local character = Me.Character
        local hum = character and character:FindFirstChildOfClass("Humanoid")
        local bag = Me:FindFirstChildOfClass("Backpack")
        local gun = ExtraUI.knifeTravelGun
        if not hum or not gun or not bag or gun.Parent ~= bag then return false end
        local ok = pcall(function() hum:EquipTool(gun) end)
        if ok then
            ExtraUI.knifeTravelSwitchAt = os.clock()
            ExtraUI.knifeTravelCombatAt = os.clock()
            if fireAfterEquip then
                task.defer(function()
                    if S.closed or Me.Character ~= character or gun.Parent ~= character then return end
                    pcall(function() gun:Activate() end)
                end)
            end
        end
        return ok
    end
    bind(ExtraUI.KnifeTravelBtn.MouseButton1Click:Connect(function()
        S.knifeTravel = not S.knifeTravel
        style(ExtraUI.KnifeTravelBtn, S.knifeTravel,
            "KNIFE TRAVEL: ON", "KNIFE TRAVEL: OFF")
        if not S.knifeTravel then ExtraUI.restoreTravelGun(false) end
        say(S.knifeTravel and "Knife travel enabled: move to equip knife; aim or fire restores your gun."
            or "Knife travel disabled.")
    end))
    bind(UIS.InputBegan:Connect(function(input, processed)
        if processed or not S.knifeTravel or S.closed or UIS:GetFocusedTextBox() then return end
        local fire = input.UserInputType == Enum.UserInputType.MouseButton1
        local aim = input.UserInputType == Enum.UserInputType.MouseButton2
        if not fire and not aim then return end
        ExtraUI.knifeTravelCombatAt = os.clock()
        local character = Me.Character
        local equipped = character and character:FindFirstChildOfClass("Tool")
        if equipped and equipped.Name == "[Knife]" then
            ExtraUI.restoreTravelGun(fire)
        end
    end))
    bind(RunService.Heartbeat:Connect(function()
        if not S.knifeTravel or S.closed then return end
        local now = os.clock()
        if now - ExtraUI.knifeTravelTickAt < 0.12 then return end
        ExtraUI.knifeTravelTickAt = now
        local character = Me.Character
        local hum = character and character:FindFirstChildOfClass("Humanoid")
        local bag = Me:FindFirstChildOfClass("Backpack")
        if not hum or not bag or hum.Health <= 0 or hum.MoveDirection.Magnitude < 0.25
            or S.autoKill or S.aura or S.resetInFlight or S.bring
            or UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
            or now - ExtraUI.knifeTravelCombatAt < 1.4
            or now - ExtraUI.knifeTravelSwitchAt < 0.4 then return end
        local effects = character:FindFirstChild("BodyEffects")
        local ko = effects and effects:FindFirstChild("K.O")
        if ko and ko.Value then return end
        local equipped = character:FindFirstChildOfClass("Tool")
        if equipped and equipped.Name == "[Knife]" then return end
        local knife = bag:FindFirstChild("[Knife]")
        if not knife then return end
        if equipped and equipped:FindFirstChild("Response") then
            ExtraUI.knifeTravelGun = equipped
        end
        if not ExtraUI.knifeTravelGun then return end
        local ok = pcall(function() hum:EquipTool(knife) end)
        if ok then ExtraUI.knifeTravelSwitchAt = now end
    end))
end
do
    if not ExtraUI.Capabilities.drawing then
        ExtraUI.FallbackEspGui = make("ScreenGui", {
            Name = "RACER_ESP", Parent = PlayerGui, ResetOnSpawn = false,
            IgnoreGuiInset = true, DisplayOrder = 2199,
        })
    end
    ExtraUI.newOverlayDrawable = function(kind)
        if ExtraUI.Capabilities.drawing then return Drawing.new(kind) end
        local state = {}
        local object = kind == "Text" and make("TextLabel", {
            Parent = ExtraUI.FallbackEspGui, BackgroundTransparency = 1,
            BorderSizePixel = 0, Text = "", TextColor3 = Color3.new(1, 1, 1),
            Font = Enum.Font.GothamBold, TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Center, Visible = false,
            ZIndex = 2,
        }) or make("Frame", {
            Parent = ExtraUI.FallbackEspGui, BorderSizePixel = 0,
            BackgroundColor3 = Color3.new(1, 1, 1), Visible = false,
            ZIndex = 2,
        })
        local stroke = kind == "Square" and make("UIStroke", {
            Parent = object, Thickness = 1, Color = Color3.new(1, 1, 1),
        }) or nil
        local function refresh()
            if not object.Parent then return end
            object.Visible = state.Visible == true
            if kind == "Text" then
                local pos = state.Position or Vector2.zero
                object.AnchorPoint = state.Center and Vector2.new(0.5, 0)
                    or Vector2.zero
                object.Position = UDim2.fromOffset(pos.X, pos.Y)
                object.Size = UDim2.fromOffset(260, (state.Size or 12) + 6)
                object.Text = state.Text or ""
                object.TextSize = state.Size or 12
                object.TextColor3 = state.Color or Color3.new(1, 1, 1)
            elseif kind == "Line" then
                local from = state.From or Vector2.zero
                local to = state.To or from
                local delta = to - from
                object.AnchorPoint = Vector2.new(0.5, 0.5)
                object.Position = UDim2.fromOffset((from.X + to.X) * 0.5,
                    (from.Y + to.Y) * 0.5)
                object.Size = UDim2.fromOffset(delta.Magnitude,
                    state.Thickness or 1)
                object.Rotation = math.deg(math.atan2(delta.Y, delta.X))
                object.BackgroundColor3 = state.Color or Color3.new(1, 1, 1)
            else
                local pos = state.Position or Vector2.zero
                local size = state.Size or Vector2.zero
                object.Position = UDim2.fromOffset(pos.X, pos.Y)
                object.Size = UDim2.fromOffset(size.X, size.Y)
                object.BackgroundColor3 = state.Color or Color3.new(1, 1, 1)
                object.BackgroundTransparency = state.Filled and 0 or 1
                stroke.Enabled = not state.Filled
                stroke.Color = state.Color or Color3.new(1, 1, 1)
                stroke.Thickness = state.Thickness or 1
            end
        end
        return setmetatable({}, {
            __index = function(_, key)
                if key == "Remove" then
                    return function() if object.Parent then object:Destroy() end end
                end
                return state[key]
            end,
            __newindex = function(_, key, value)
                state[key] = value
                refresh()
            end,
        })
    end
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
        local o = {box = ExtraUI.newOverlayDrawable("Square"),
            name = ExtraUI.newOverlayDrawable("Text"),
            distance = ExtraUI.newOverlayDrawable("Text"),
            combat = ExtraUI.newOverlayDrawable("Text"),
            healthBack = ExtraUI.newOverlayDrawable("Square"),
            healthFill = ExtraUI.newOverlayDrawable("Square"),
            tracer = ExtraUI.newOverlayDrawable("Line"), lines = {}}
        o.box.Filled = false
        o.box.Thickness = 1.5
        o.healthBack.Filled, o.healthFill.Filled = true, true
        o.healthBack.Color = Color3.fromRGB(16, 22, 35)
        o.tracer.Thickness = 1.4
        o.name.Center, o.distance.Center, o.combat.Center = true, true, true
        o.name.Outline, o.distance.Outline, o.combat.Outline = true, true, true
        o.name.Size, o.distance.Size, o.combat.Size = 13, 12, 11
        for i = 1, #r15 do
            local line = ExtraUI.newOverlayDrawable("Line")
            line.Thickness = 1.4
            o.lines[i] = line
        end
        hideOverlay(o)
        return o
    end
    local function renderEsp()
        if not S.esp.enabled and not (S.dot and #TargetList > 0) then
            for _, o in pairs(overlays) do hideOverlay(o) end
            return
        end
        local camera = Workspace.CurrentCamera
        if not camera then return end
        local seen = {}
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= Me then
                seen[player] = true
                local selected = S.dot and TargetSet[player] == true
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
        if ExtraUI.FallbackEspGui then
            ExtraUI.FallbackEspGui:Destroy()
            ExtraUI.FallbackEspGui = nil
        end
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

ExtraUI.clickShop = function(click, head)
    if not ExtraUI.Capabilities.shopPurchase then return false end
    if ExtraUI.Capabilities.clickDetector then
        return pcall(fireclickdetector, click, 0, "mouseclick")
    end
     
    local camera = Workspace.CurrentCamera
    if not camera or not head then return false end
    local oldCamera = camera.CFrame
    local ok = pcall(function()
        camera.CFrame = CFrame.lookAt(camera.CFrame.Position, head.Position)
        task.wait()
        local point, visible = camera:WorldToViewportPoint(head.Position)
        if not visible then error("shop is not on screen") end
        local input = game:GetService("VirtualInputManager")
        input:SendMouseButtonEvent(point.X, point.Y, 0, true, game, 0)
        input:SendMouseButtonEvent(point.X, point.Y, 0, false, game, 0)
    end)
    camera.CFrame = oldCamera
    return ok
end

local function buyArmorAfterSpawn(character)
    if not ExtraUI.Capabilities.shopPurchase then return end
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
            local ok = ExtraUI.clickShop(shop.click, shop.head)
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
    if not ExtraUI.Capabilities.shopPurchase then return end
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
            ExtraUI.clickShop(shop.click, shop.head)
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
    if not ExtraUI.Capabilities.shopPurchase then return end
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
 
 
ExtraUI.confirmAntiStompReset = function(character, signal)
    if S.resetCharacter ~= character then return end
    S.antiStompConfirmedCharacter = character
    S.resetGeneration = S.resetGeneration + 1
    S.resetCharacter = nil
    S.resetInFlight = false
    S.antiStompReady = false
    ExtraUI.Notify.emit("antiStomp", "Anti-Stomp reset confirmed (" .. signal .. ")")
    say("Anti stomp: reset confirmed; retry stopped.")
end
local function resetBeforeStomp(character, reason)
    if not reason or S.closed or not S.antiStomp or S.resetInFlight
        or not S.antiStompReady
        or Me.Character ~= character or S.antiStompTriggeredCharacter == character
        or os.clock() < S.antiStompSpawnGraceUntil then return end
    local hum = character:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local storage = ReplicatedStorage:FindFirstChild("Storage")
    local remotes = storage and storage:FindFirstChild("Remotes")
    local main = remotes and remotes:FindFirstChild("Main")
    if not main or not main:IsA("RemoteEvent") then return end

    S.resetGeneration = S.resetGeneration + 1
    local generation = S.resetGeneration
    S.resetCharacter = character
    S.antiStompTriggeredCharacter = character
    S.resetInFlight = true
    S.antiStompReady = false
    S.lastResetAt = os.clock()
    S.autoKill = false
    S.autoKillGeneration = S.autoKillGeneration + 1
    style(AutoKillBtn, false, "AUTO KILL SELECTED: ON", "AUTO KILL SELECTED: OFF")
    captureDeathPosition(character)
    ExtraUI.Notify.emit("antiStomp", "Anti-Stomp reset requested (" .. reason .. ")")
    local ok = pcall(function() main:FireServer("ResetNew") end)
    if not ok then
        S.resetInFlight = false
        S.resetCharacter = nil
        say("Anti stomp: reset request failed; re-enable to retry.")
        return
    end
    say("Anti stomp: awaiting reset confirmation before any retry.")
    task.spawn(function()
        local attempts = 1
        while not S.closed and S.antiStomp and S.resetGeneration == generation
            and S.resetCharacter == character and Me.Character == character do
            task.wait(1.25)
             
             
            if S.closed or not S.antiStomp or S.resetGeneration ~= generation
                or S.resetCharacter ~= character or Me.Character ~= character
                or not character.Parent then break end
            local currentHum = character:FindFirstChildOfClass("Humanoid")
            if not currentHum then break end
            if not ownDangerReason(character) and currentHum.Health > 0 then
                 
                S.resetInFlight = false
                S.resetCharacter = nil
                S.antiStompReady = true
                say("Anti stomp: recovery detected; stopped reset requests.")
                ExtraUI.Notify.emit("antiStomp", "Anti-Stomp stopped: recovered")
                return
            end
            attempts = attempts + 1
            S.lastResetAt = os.clock()
            pcall(function() main:FireServer("ResetNew") end)
            if attempts == 3 or attempts % 6 == 0 then
                say("Anti stomp: waiting for character refresh (attempt " .. attempts .. ").")
            end
        end
        if S.resetGeneration == generation and S.resetCharacter == character then
            S.resetCharacter = nil
            S.resetInFlight = false
        end
    end)
end
local OwnCharacterGeneration = 0
local function watchOwnCharacter(character)
    disconnectMany(OwnCharacterConnections)
    OwnCharacterConnections[#OwnCharacterConnections + 1] =
        character.ChildAdded:Connect(Rapid.observeGun)
    for _, tool in ipairs(character:GetChildren()) do Rapid.observeGun(tool) end
    task.spawn(function()
        local scripts = character:WaitForChild("Scripts", 12)
        local input = scripts and scripts:WaitForChild("Input", 12)
        local aiming = input and input:WaitForChild("AimingInput", 12)
        if aiming and not S.closed and Me.Character == character then
            ExtraUI.applyGunMods(character)
        end
    end)
    OwnCharacterGeneration = OwnCharacterGeneration + 1
    local generation = OwnCharacterGeneration
     
    if ExtraUI.lastAntiStompModel ~= character then
        local previousModel = ExtraUI.lastAntiStompModel
        local hadPendingReset = S.resetInFlight
            or S.antiStompConfirmedCharacter == previousModel
        ExtraUI.lastAntiStompModel = character
        S.resetGeneration = S.resetGeneration + 1
        S.resetCharacter = nil
        S.resetInFlight = false
        S.antiStompTriggeredCharacter = nil
        S.antiStompConfirmedCharacter = nil
        S.lastResetAt = 0
        S.antiStompSpawnGraceUntil = os.clock() + (previousModel and 1.5 or 0)
        if hadPendingReset then
            ExtraUI.Notify.emit("antiStomp", "Anti-Stomp stopped: new character loaded")
        end
    end
    S.antiStompReady = false
    task.spawn(function()
        local hum = character:WaitForChild("Humanoid", 6)
        if S.closed or Me.Character ~= character or generation ~= OwnCharacterGeneration then return end
        local function evaluate()
            if not hum or S.resetInFlight then return end
            if not S.antiStompReady then
                if os.clock() < S.antiStompSpawnGraceUntil then return end
                 
                 
                 
                if ExtraUI.antiStompInitialModel ~= character and
                    (hum.Health <= ResetThresholds[S.resetThresholdIndex] + 5
                        or ownDangerReason(character)) then return end
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
                ExtraUI.confirmAntiStompReset(character, "humanoid died")
                evaluate()
            end)
            OwnCharacterConnections[#OwnCharacterConnections + 1] = hum.StateChanged:Connect(function(_, state)
                if state == Enum.HumanoidStateType.Dead then
                    ExtraUI.confirmAntiStompReset(character, "dead state")
                    evaluate()
                end
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
                OwnCharacterConnections[#OwnCharacterConnections + 1] = value.Changed:Connect(function()
                    if value.Name == "Dead" and value.Value then
                        ExtraUI.confirmAntiStompReset(character, "dead flag")
                    end
                    evaluate()
                end)
                evaluate()
            end
            for _, value in ipairs(effects:GetChildren()) do watchFlag(value) end
            OwnCharacterConnections[#OwnCharacterConnections + 1] = effects.ChildAdded:Connect(watchFlag)
        end
        evaluate()
         
        task.delay(1.55, function()
            if not S.closed and Me.Character == character
                and generation == OwnCharacterGeneration then evaluate() end
        end)
    end)
end
 
 
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
    if S.stompSuppressed then return end
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
    local proofOk, proof = pcall(function()
        return require(infoModule):CheckCredibility()
    end)
    if not proofOk or proof ~= true then return end

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
    if S.closed or S.stompSuppressed or not (S.autoStomp or allowSelected)
        or Me.Character ~= character
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
                S.stompSuppressed = true
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
    if ExtraUI.Notify.previousOwnCharacter and
        ExtraUI.Notify.previousOwnCharacter ~= character then
        ExtraUI.Notify.emit("ownRespawn", "You respawned")
    end
    ExtraUI.Notify.previousOwnCharacter = character
     
    task.delay(0.25, function() if not S.closed then updateOwnRoot() end end)
    watchOwnCharacter(character)
    ExtraUI.runSpawnSequence(character)
end))
bind(Me.CharacterRemoving:Connect(function(character)
    if S.resetCharacter == character then
        ExtraUI.confirmAntiStompReset(character, "character removed")
    end
    local hum = character:FindFirstChildOfClass("Humanoid")
    if hum and hum.Health <= 0 then captureDeathPosition(character) end
    OwnRoot = nil
    OwnCharacterGeneration = OwnCharacterGeneration + 1
    disconnectMany(OwnCharacterConnections)
end))
if Me.Character then
    ExtraUI.Notify.previousOwnCharacter = Me.Character
    ExtraUI.antiStompInitialModel = Me.Character
    watchOwnCharacter(Me.Character)
end

ExtraUI.SafeCharacter = nil
ExtraUI.LastSafeCFrame = nil
ExtraUI.NextVoidCheck = 0
bind(RunService.Heartbeat:Connect(function()
    if S.closed or not S.antiVoid or S.voidBlinking
        or os.clock() < ExtraUI.NextVoidCheck then return end
    ExtraUI.NextVoidCheck = os.clock() + 0.05
    local character = Me.Character
    if character ~= ExtraUI.SafeCharacter then
        ExtraUI.SafeCharacter, ExtraUI.LastSafeCFrame = character, nil
    end
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local hum = character and character:FindFirstChildOfClass("Humanoid")
    if not root or not hum or hum.Health <= 0 then return end
    if root.Position.Y > -35 then
        ExtraUI.LastSafeCFrame = root.CFrame
    elseif root.Position.Y < -45 then
        pcall(function()
            character:PivotTo(ExtraUI.LastSafeCFrame
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
local function recordUsable(p, rec)
    return p and p.Parent == Players and rec and rec.model.Parent
        and rec.root.Parent and rec.humanoid.Parent
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

if type(Env.__SPECTRA_MULTI_RAYCAST) == "table" then
    Env.__SPECTRA_MULTI_RAYCAST.enabled = false
end
local Hook: any = {
    installed = false, enabled = false, part = nil, record = nil,
    lockPlayer = nil, lockRecord = nil,
    auraTarget = nil, auraRecord = nil,
    manager = nil, original = nil, wrapper = nil,
    damageOriginal = nil, damageWrapper = nil,
    lead = S.lead, aliveOnly = S.aliveOnly, wallBang = false,
}
Env.__SPECTRA_MULTI_RAYCAST = Hook

 
 
Hook.getMuzzle = function(tool)
    local handle = tool and tool:FindFirstChild("Handle")
    if not handle or not handle:IsA("BasePart") then return nil end
    local origin = handle.Position
    local gui = handle:FindFirstChild("ShootFXGui")
    if gui and gui:IsA("BillboardGui") then
        origin = origin + handle.CFrame:VectorToWorldSpace(gui.StudsOffsetWorldSpace)
    end
    return origin
end

Hook.getBulletDirection = function()
    local character = Me.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local basis = root and root.CFrame or (Workspace.CurrentCamera and Workspace.CurrentCamera.CFrame)
    if not basis then return nil end
    local angle
    if S.bulletMode == 2 then
         
        angle = (S.bulletStep % 16) * (2 * math.pi / 16)
        S.bulletStep = S.bulletStep + 1
    elseif S.bulletMode == 3 then
        angle = math.random() * 2 * math.pi
    else
        return nil
    end
    local radial = basis.LookVector * math.cos(angle) + basis.RightVector * math.sin(angle)
    radial = Vector3.new(radial.X, 0, radial.Z)
    return radial.Magnitude > 0.001 and radial.Unit or nil
end

 
 
 
 
Hook.rayBoxDistance = function(origin, direction, length, part, padding)
    local localOrigin = part.CFrame:PointToObjectSpace(origin)
    local localDirection = part.CFrame:VectorToObjectSpace(direction)
    local half = part.Size * 0.5 + Vector3.new(padding or 0, padding or 0, padding or 0)
    local enter, leave = 0, length
    for axis = 1, 3 do
        local o, d, h
        if axis == 1 then
            o, d, h = localOrigin.X, localDirection.X, half.X
        elseif axis == 2 then
            o, d, h = localOrigin.Y, localDirection.Y, half.Y
        else
            o, d, h = localOrigin.Z, localDirection.Z, half.Z
        end
        if math.abs(d) < 0.000001 then
            if o < -h or o > h then return nil end
        else
            local a, b = (-h - o) / d, (h - o) / d
            if a > b then a, b = b, a end
            enter, leave = math.max(enter, a), math.min(leave, b)
            if enter > leave then return nil end
        end
    end
    return enter
end

Hook.resolveShotRecord = function(p)
    local rec = validModel(p.Character) or validModel(candidateNamed(Workspace, p))
    if rec then return rec end
     
     
    for folder in pairs(Folders) do
        if folder.Parent == Workspace then
            rec = validModel(candidateNamed(folder, p))
            if rec then return rec end
        end
    end
    return nil
end

Hook.penetrationRaycast = function(origin, point, maxRange, cameraAim)
    if typeof(origin) ~= "Vector3" or typeof(point) ~= "Vector3" then
        return nil, nil
    end
     
     
     
    local rayOrigin = cameraAim and Workspace.CurrentCamera
        and Workspace.CurrentCamera.CFrame.Position or origin
    local delta = point - rayOrigin
    if delta.Magnitude <= 0.001 then return nil, nil end
    local length = math.min(maxRange + (rayOrigin - origin).Magnitude, 15000)
    local direction = delta.Unit
    local bestDistance, bestPart, bestPlayer = length + 1, nil, nil
    local selectedDistance, selectedPart, selectedPlayer = nil, nil, nil
     
     
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= Me then
            local rec = Hook.resolveShotRecord(p)
            if rec and alive(rec, S.aliveOnly) then
                local toRoot = rec.root.Position - rayOrigin
                local along = toRoot:Dot(direction)
                if along >= -8 and along <= length + 8 then
                    local separation = (toRoot - direction * along).Magnitude
                    if separation < 8 then
                        for _, body in ipairs(rec.model:GetChildren()) do
                            if body:IsA("BasePart") and body ~= rec.root then
                                 
                                 
                                 
                                local padding = cameraAim and math.min(4,
                                    math.max(0.35, along * 0.03)) or 0
                                local distance = Hook.rayBoxDistance(rayOrigin, direction,
                                    length, body, padding)
                                if distance and distance < bestDistance
                                    and (body.Position - origin).Magnitude <= maxRange + 4 then
                                    bestDistance, bestPart, bestPlayer = distance, body, p
                                end
                                if p == S.primary and distance
                                    and (not selectedDistance or distance < selectedDistance)
                                    and (body.Position - origin).Magnitude <= maxRange + 4 then
                                    selectedDistance, selectedPart, selectedPlayer = distance, body, p
                                end
                            end
                        end
                    end
                end
            end
        end
    end
     
     
    if selectedPart then
        bestDistance, bestPart, bestPlayer =
            selectedDistance, selectedPart, selectedPlayer
    end
    if not bestPart then return nil, nil end
    return {
        Instance = bestPart,
        Position = bestPart.Position,
        Normal = -direction,
        Material = bestPart.Material,
        Distance = bestDistance,
    }, bestPlayer
end

 
 
Hook.nextMultiShot = function()
    local count = #TargetList
    if count == 0 then return nil, nil, nil end
    for _ = 1, count do
        Hook.multiCursor = ((Hook.multiCursor or 0) % count) + 1
        local target = TargetList[Hook.multiCursor]
        local rec = Records[target]
        if not recordPresent(target, rec) then
             
            rec = Hook.resolveShotRecord(target)
            if rec and TargetSet[target] then Records[target] = rec end
        end
        if recordPresent(target, rec) and alive(rec, S.aliveOnly) then
            local part = partFor(rec)
            if part and part.Parent then return target, rec, part end
        end
    end
    return nil, nil, nil
end

ExtraUI.disableGunManagerFeatures = function(reason)
    if not Env.RacerIsXeno then return end
    ExtraUI.Capabilities.gunManager = false
    S.silent, S.forceHit, S.wallBang, S.infiniteRange, S.noSpread =
        false, false, false, false, false
    S.bulletMode = 1
    Hook.enabled, Hook.part, Hook.record = false, nil, nil
    for _, control in ipairs({Silent, ForceHitBtn, WallBangBtn,
        ExtraUI.InfiniteRangeBtn, ExtraUI.BulletModeBtn,
        AutoKillBtn, Bring, ExtraUI.AuraBtn, ExtraUI.GunModButtons.spread}) do
        control.AutoButtonColor = false
        control.BackgroundColor3 = C_OFF
    end
    Silent.Text = "SILENT AIM: XENO UNSUPPORTED"
    ForceHitBtn.Text = "FORCE HIT: XENO UNSUPPORTED"
    WallBangBtn.Text = "WALLBANG: XENO UNSUPPORTED"
    ExtraUI.InfiniteRangeBtn.Text = "INFINITE RANGE: XENO UNSUPPORTED"
    ExtraUI.BulletModeBtn.Text = "BULLET DIRECTION: XENO UNSUPPORTED"
    AutoKillBtn.Text = "AUTO KILL: XENO UNSUPPORTED"
    Bring.Text = "BRING: XENO UNSUPPORTED"
    ExtraUI.AuraBtn.Text = "AURA: XENO UNSUPPORTED"
    ExtraUI.GunModButtons.spread.Text = "DB NO SPREAD: XENO UNSUPPORTED"
    ExtraUI.WallBangInfo.Text = "GUN MANAGER UNAVAILABLE: " .. tostring(reason)
end

local function installRaycastHook()
    if ExtraUI.Capabilities.gunManager == false then
        return false, "Xeno cannot access this game's GunManager."
    end
    if Hook.installed and Hook.manager and Hook.manager.Raycast == Hook.wrapper then return true end
    local storage = ReplicatedStorage:FindFirstChild("Storage")
    local modules = storage and storage:FindFirstChild("Modules")
    local dialect = modules and modules:FindFirstChild("Dialect")
    local module = dialect and dialect:FindFirstChild("GunManager")
    if not module then
        module = ReplicatedStorage:FindFirstChild("GunManager", true)
    end
    if not module and dialect then
        module = dialect:WaitForChild("GunManager", 5)
    end
    if not module or not module:IsA("ModuleScript") then
        ExtraUI.disableGunManagerFeatures("module not found")
        return false, "GunManager could not be found in this client."
    end
    local ok, manager = pcall(require, module)
    if not ok or type(manager) ~= "table" or type(manager.Raycast) ~= "function" then
        ExtraUI.disableGunManagerFeatures("module require failed")
        return false, "Could not access this game's gun raycast."
    end
    local original = manager.Raycast
    local function redirect(self, tool, mousePoint, player, range, ...)
        local ownGun = self == manager and player == Me and tool
            and tool:IsA("Tool") and tool.Parent == Me.Character
        local shotRange = ownGun and S.infiniteRange and 15000 or range
        if ownGun and S.aura and not Hook.auraTarget then
            return original(self, tool, mousePoint, player, shotRange, ...)
        end
        if ownGun
            and (Hook.enabled or S.autoKill or S.aura or S.forceHit or S.wallBang or S.infiniteRange
                or S.silent or S.bulletMode ~= 1) then
            local maxRange = typeof(shotRange) == "number"
                and math.clamp(shotRange, 1, 15000) or 200
            local origin = Hook.getMuzzle(tool)
            local direct = S.autoKill or S.aura or S.forceHit

             
             
            if not direct and S.bulletMode ~= 1 and origin then
                local radial = Hook.getBulletDirection()
                if radial then mousePoint = origin + radial * maxRange end
            elseif direct or S.silent then
                local lockedPlayer = S.aura and Hook.auraTarget
                    or S.autoKill and Hook.lockPlayer or nil
                local forcedPlayer = not S.aura and S.forceHit and S.primary or nil
                local selectedPlayer = lockedPlayer or forcedPlayer or S.aimPlayer
                local selectedRecord = S.aura and Hook.auraRecord
                    or lockedPlayer and Hook.lockRecord
                    or forcedPlayer and Records[forcedPlayer] or Hook.record
                local part = (lockedPlayer or forcedPlayer)
                    and selectedRecord and partFor(selectedRecord) or Hook.part
                 
                if S.multi and not S.autoKill and not S.aura
                    and (S.silent or S.forceHit) then
                    selectedPlayer, selectedRecord, part = Hook.nextMultiShot()
                end
                local auraCenterRoot = S.aura and (S.auraFromStand
                    and ExtraUI.standOwnerRoot and ExtraUI.standOwnerRoot()
                    or Me.Character and Me.Character:FindFirstChild("HumanoidRootPart"))
                if selectedRecord and part and part.Parent
                    and (lockedPlayer and recordUsable(selectedPlayer, selectedRecord)
                        or recordPresent(selectedPlayer, selectedRecord))
                    and alive(selectedRecord, Hook.aliveOnly) and origin
                    and (not S.aura or (auraCenterRoot and
                        (selectedRecord.root.Position - auraCenterRoot.Position).Magnitude <= 75)) then
                    local point = predictedPoint(selectedRecord, part, Hook.lead)
                    local directHit = S.aura or S.forceHit
                        or (S.autoKill and S.standAttackTarget ~= nil)
                        or (S.autoKill and S.quietAutoKill)
                    if directHit or (point - origin).Magnitude <= maxRange then
                        mousePoint = point
                        if (directHit or S.wallBang) and selectedRecord.model
                            and part:IsDescendantOf(selectedRecord.model) then
                            local rayDir = point - origin
                            if rayDir.Magnitude > 0.01 then
                                return {
                                    Instance = part, Position = point,
                                    Normal = -rayDir.Unit, Material = part.Material,
                                }
                            end
                        end
                    end
                end
            end

             
             
            if S.wallBang then
                Hook.wallShots = (Hook.wallShots or 0) + 1
                local hit, victim
                if origin then
                    hit, victim = Hook.penetrationRaycast(origin, mousePoint, maxRange,
                        S.bulletMode == 1 and not direct)
                end
                if hit then
                    ExtraUI.WallBangInfo.Text = "WB CLIENT HIT: @" .. victim.Name
                        .. " (server damage not guaranteed)"
                    return hit
                end
                if os.clock() - (Hook.lastWallStatus or 0) > 0.35 then
                    Hook.lastWallStatus = os.clock()
                    ExtraUI.WallBangInfo.Text = ("WB SHOTS: %d | no rig on shot line")
                        :format(Hook.wallShots)
                end
                 
                 
            end
        end
        return original(self, tool, mousePoint, player, shotRange, ...)
    end
    local assigned = pcall(function() manager.Raycast = redirect end)
    if not assigned or manager.Raycast ~= redirect then
        ExtraUI.disableGunManagerFeatures("Raycast cannot be replaced")
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
                        if S.aura and Hook.auraRecord
                            and state.Humanoid == Hook.auraRecord.humanoid then
                            S.auraTargetHitAt = os.clock()
                            S.auraTargetShots = 0
                        end
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
    SelectedLabel.Text = ("Targets: %d selected  |  Last: %s"):format(count,
        S.primary and ("@" .. S.primary.Name) or "none")
end
local function invalidatePlayer(p)
    ExtraUI.Notify.detach(p)
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
    ExtraUI.Notify.attach(p, rec)
end
local function findRecordInWorkspace(p, token)
     
     
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
         
         
        applyRecord(p, nil)
    end)
end
local function watchFolder(folder)
    if Folders[folder] or not isFolder(folder) then return end
    Folders[folder] = folder.ChildAdded:Connect(function(child)
        local p = TargetByModelName[child.Name]
        if p then requestResolution(p) end
    end)
     
     
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
    ResolutionTokens[p] = nil  
    local cs = PlayerConnections[p]
    if cs then disconnectMany(cs); PlayerConnections[p] = nil end
    for i = #TargetList, 1, -1 do
        if TargetList[i] == p then table.remove(TargetList, i); break end
    end
    invalidatePlayer(p)
    ExtraUI.Notify.knownModels[p] = nil
    ExtraUI.Notify.lastRespawnAt[p] = nil
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
    ExtraUI.Notify.emit("selected", "@" .. p.Name .. " selected")
    TargetList[#TargetList + 1] = p
    TargetByModelName[p.Name] = p
    TargetByModelName[tostring(p.UserId)] = p
    local cs = {
        p.CharacterAdded:Connect(function(character)
            if ExtraUI.Notify.knownModels[p]
                and ExtraUI.Notify.knownModels[p] ~= character
                and os.clock() - (ExtraUI.Notify.lastRespawnAt[p] or -math.huge) > 1.3 then
                ExtraUI.Notify.lastRespawnAt[p] = os.clock()
                ExtraUI.Notify.emit("respawned", "@" .. p.Name .. " respawned")
            end
            requestResolution(p)
        end),
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
         
        for i = #TargetList, 1, -1 do deselectPlayer(TargetList[i]) end
        if p and addTarget(p, knownRecord) then S.primary = p end
    else
         
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

ExtraUI.Picking = false
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
     
    targetTick()
    say("Cursor pick: @" .. bestPlayer.Name .. " selected.")
end

 
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
bind(Players.PlayerAdded:Connect(function(p)
    addRow(p)
    if S.multi and p ~= Me then
        addTarget(p)
        if not S.primary then S.primary = p end
        syncLabels()
        updateLoops()
    end
    renumberRows()
end))
bind(Players.PlayerRemoving:Connect(function(p) removeRow(p); renumberRows() end))
bind(Search:GetPropertyChangedSignal("Text"):Connect(filterRows))

ExtraUI.WallParams = RaycastParams.new()
ExtraUI.WallParams.FilterType = Enum.RaycastFilterType.Exclude
ExtraUI.WallParams.IgnoreWater = true
ExtraUI.WallModel = nil
local function withinWallLine(cam, part, rec)
    if not S.wall or S.wallBang or S.forceHit then return true end
    local ownModel = Me.Character
    if ExtraUI.WallModel ~= ownModel then
        ExtraUI.WallModel = ownModel
        local ignored = {}
        if ownModel then ignored[#ignored + 1] = ownModel end
        local blacklisted = Workspace:FindFirstChild("Blacklisted")
        if blacklisted then ignored[#ignored + 1] = blacklisted end
        ExtraUI.WallParams.FilterDescendantsInstances = ignored
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
    local ok, hit = pcall(Workspace.Raycast, Workspace, origin, part.Position - origin, ExtraUI.WallParams)
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
     
    local p, rec, part, projected
    if firstRec and withinWallLine(cam, firstPart, firstRec) then
        p, rec, part, projected = firstP, firstRec, firstPart, firstPoint
    elseif secondRec and withinWallLine(cam, secondPart, secondRec) then
        p, rec, part, projected = secondP, secondRec, secondPart, secondPoint
    end
     
     
    if not rec and (S.silent or S.forceHit) then
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
    if S.multi and (S.silent or S.forceHit) then
        ActiveLabel.Text = ("Multi aim: %d selected; cycling per shot"):format(#TargetList)
    elseif S.aimPlayer ~= p then
        ActiveLabel.Text = "Aim target: @" .. p.Name
    end
    S.aimPlayer, S.aimRecord = p, rec
    local dx, dy = projected.X - cx, projected.Y - cy
    S.screenDistance2 = dx * dx + dy * dy
    S.permitted = true
    Hook.part = S.silent and part or nil
    Hook.record = S.silent and rec or nil
    Hook.lead = S.lead
    Hook.aliveOnly = S.aliveOnly
    Hook.enabled = S.silent
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
     
    local character = Me.Character
    local equipped = character and character:FindFirstChildOfClass("Tool")
    if equipped and equipped:FindFirstChild("Response") then
        return pcall(function() equipped:Activate() end)
    end
    return false
end
ExtraUI.Mouse = Me:GetMouse()
local function triggerTick()
    if not S.trigger or #TargetList == 0 or UIS:GetFocusedTextBox() then return end
    local shoot = false
    local hit = ExtraUI.Mouse.Target
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

 
     
updateLoops = function()
    local needTarget = #TargetList > 0 and (S.silent or S.forceHit
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

 
ExtraUI.selectAllTargets = function()
    if not S.multi then S.multi = true end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Me and not TargetSet[player] then addTarget(player) end
    end
    if not S.primary or not TargetSet[S.primary] then S.primary = TargetList[1] end
    style(MultiBtn, true, "MULTI TARGET: ON", "MULTI TARGET: OFF")
    syncLabels()
    updateLoops()
    say(("Multi: %d selected; shots cycle across selected players."):format(#TargetList))
end
bind(ExtraUI.SelectAllBtn.MouseButton1Click:Connect(ExtraUI.selectAllTargets))
bind(MultiBtn.MouseButton1Click:Connect(function()
    if not S.multi then
        ExtraUI.selectAllTargets()
        return
    end
    S.multi = false
    if #TargetList > 1 then
        local keep = S.primary or TargetList[1]
        for i = #TargetList, 1, -1 do
            if TargetList[i] ~= keep then deselectPlayer(TargetList[i]) end
        end
    end
    style(MultiBtn, false, "MULTI TARGET: ON", "MULTI TARGET: OFF")
    syncLabels()
    updateLoops()
    say("Single-target mode restored.")
end))
bind(AliveBtn.MouseButton1Click:Connect(function()
    S.aliveOnly = not S.aliveOnly
    Hook.aliveOnly = S.aliveOnly
    style(AliveBtn, S.aliveOnly, "ALIVE CHECK: ON", "ALIVE CHECK: OFF")
    if S.silent or S.trigger or S.cameraAim or S.dot then targetTick() end
end))
bind(Silent.MouseButton1Click:Connect(function()
    if not S.silent then
        local ok, reason = installRaycastHook()
        if not ok then say(reason); return end
    end
    S.silent = not S.silent
    Hook.enabled = S.silent and S.aimRecord ~= nil
    if not S.silent then Hook.part, Hook.record = nil, nil end
    style(Silent, S.silent, "SILENT AIM: ON", "SILENT AIM: OFF")
    updateLoops()
end))
bind(ExtraUI.InfiniteRangeBtn.MouseButton1Click:Connect(function()
    if not S.infiniteRange then
        local ok, reason = installRaycastHook()
        if not ok then say(reason); return end
    end
    S.infiniteRange = not S.infiniteRange
    style(ExtraUI.InfiniteRangeBtn, S.infiniteRange,
        "INFINITE RANGE: ON", "INFINITE RANGE: OFF")
    say(S.infiniteRange and "All GunManager guns now raycast up to 15,000 studs."
        or "Normal weapon ranges restored.")
end))
bind(WallBangBtn.MouseButton1Click:Connect(function()
    if not S.wallBang then
        local ok, reason = installRaycastHook()
        if not ok then say(reason); return end
    end
    S.wallBang = not S.wallBang
    Hook.wallBang = S.wallBang
    Hook.enabled = S.silent and S.aimRecord ~= nil
    if not S.silent then Hook.part, Hook.record = nil, nil end
    style(WallBangBtn, S.wallBang,
        "ALL-GUN WALLBANG: ON", "ALL-GUN WALLBANG: OFF")
    ExtraUI.WallBangInfo.Text = S.wallBang
        and "WB READY: fire to test the client hit path" or "WALLBANG: OFF"
    Hook.wallShots = 0
    updateLoops()
    say(S.wallBang and "Wallbang covers every gun using the shared GunManager shot path."
        or "Wallbang disabled.")
end))
bind(ExtraUI.BulletModeBtn.MouseButton1Click:Connect(function()
    local nextMode = S.bulletMode % #ExtraUI.BulletModeNames + 1
    if nextMode ~= 1 then
        local ok, reason = installRaycastHook()
        if not ok then say(reason); return end
    end
    S.bulletMode = nextMode
    S.bulletStep = 0
    style(ExtraUI.BulletModeBtn, nextMode ~= 1,
        "BULLET DIRECTION: " .. ExtraUI.BulletModeNames[nextMode],
        "BULLET DIRECTION: CURSOR")
    say(nextMode == 1 and "Bullet direction follows cursor again."
        or "Bullet direction: " .. ExtraUI.BulletModeNames[nextMode]
            .. " (one radial direction per shot; camera unchanged).")
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
    S.trigger = not S.trigger
    style(Trigger, S.trigger, "TRIGGER: ON", "TRIGGER: OFF")
    updateLoops()
    if S.trigger and not ExtraUI.Capabilities.mouseClick then
        say("Trigger uses equipped gun activation on this executor.")
    end
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
    if not S.cursorKeyEnabled or ExtraUI.Picking then return end
    ExtraUI.Picking = true
    task.spawn(function()
        local ok = pcall(pickNearCursor)
        ExtraUI.Picking = false
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
    if not ExtraUI.Capabilities.shopPurchase then
        say("Xeno: automated shop purchases are unavailable in this build.")
        return
    end
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
        say("Anti stomp armed: reset retries stop on confirmed death or respawn.")
        resetBeforeStomp(Me.Character, ownDangerReason(Me.Character))
    else
         
        S.resetGeneration = S.resetGeneration + 1
        S.resetCharacter = nil
        S.resetInFlight = false
        S.antiStompReady = false
        say("Anti stomp disabled; pending retries cancelled.")
    end
end))
bind(ResetThresholdBtn.MouseButton1Click:Connect(function()
    S.resetThresholdIndex = S.resetThresholdIndex % #ResetThresholds + 1
    ResetThresholdBtn.Text = "RESET AT: " .. ResetThresholds[S.resetThresholdIndex] .. " HP"
    resetBeforeStomp(Me.Character, ownDangerReason(Me.Character))
end))
bind(AutoStompBtn.MouseButton1Click:Connect(function()
    if S.aura then
        say("Auto stomp stays paused while Aura is active.")
        return
    end
    if S.bringStompRestore ~= nil then
        S.bringStompRestore = not S.bringStompRestore
        S.stompSuppressed = true
        say(S.bringStompRestore and "Auto stomp will resume after Bring."
            or "Auto stomp will stay off after Bring; all scripted stomps stopped.")
        return
    end
    S.autoStomp = not S.autoStomp
    S.stompSuppressed = not S.autoStomp
    style(AutoStompBtn, S.autoStomp, "AUTO STOMP: ON", "AUTO STOMP: OFF")
    updateAutoStomp()
    say(S.autoStomp and "Auto stomp: repeats StompRemote over K.O or dead bodies."
        or "Auto stomp disabled; selected and auto-kill stomps are paused too.")
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
            if downed and not S.stompSuppressed
                and S.bringStompRestore == nil and not S.autoKill
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
    if not ExtraUI.Capabilities.shopPurchase then return end
    local name = selectedShop()
    S.autoBuys[name] = not S.autoBuys[name] or nil
    refreshAutoBuyControls()
    say(name .. (S.autoBuys[name] and " will be bought on respawn." or " auto buy disabled."))
end))
bind(AutoBuyNow.MouseButton1Click:Connect(function()
    if not ExtraUI.Capabilities.shopPurchase then return end
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
    S.stompSuppressed = not previous
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
    S.stompSuppressed = true
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
 
 
 
ExtraUI.standSendChat = function(message)
    if S.closed then return false end
    local chat = game:GetService("TextChatService")
    local channels = chat:FindFirstChild("TextChannels")
    local general = channels and channels:FindFirstChild("RBXGeneral")
    if general and general:IsA("TextChannel") then
        local ok = pcall(function() general:SendAsync(message) end)
        if ok then return true end
    end
     
    local legacy = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    local remote = legacy and legacy:FindFirstChild("SayMessageRequest")
    if remote and remote:IsA("RemoteEvent") then
        return pcall(function() remote:FireServer(message, "All") end)
    end
    return false
end
ExtraUI.standReportResult = function(report, outcome, detail)
    if not report or report.sent then return end
    report.sent = true
    if S.standChatReport == report then S.standChatReport = nil end
    if report.command == "counter" then
        if outcome == "FAILED" then
            ExtraUI.standStatus("Counter ended without a confirmed down.")
            return
        end
        if outcome == "SUCCESS" and report.target then
            local record = Hook.resolveShotRecord(report.target)
            local model = report.targetModel or record and record.model
            if model and S.standCounterReportedDown[report.target] == model then
                return
            end
            if model then S.standCounterReportedDown[report.target] = model end
        end
    end
     
    local message = ({
        SUCCESS = "success",
        FAILED = "failed",
        ["TARGET LEFT"] = "left",
        ["TARGET NOT FOUND"] = "not found",
    })[outcome] or "failed"
    local posted = ExtraUI.standSendChat(message)
    if ExtraUI.standStatus then
        ExtraUI.standStatus((posted and "Sent to chat: " or "Chat unavailable: ") .. message)
    end
end
ExtraUI.standReportIssue = function(command, query, outcome, detail)
    local safeName = tostring(query or ""):gsub("[^%w_]", ""):sub(1, 24)
    if safeName == "" then safeName = "unknown" end
    ExtraUI.standReportResult({command = command, name = safeName}, outcome, detail)
end
ExtraUI.standConfirmedDead = function(record)
    local model = record and record.model
    local effects = model and model:FindFirstChild("BodyEffects")
    local dead = effects and effects:FindFirstChild("Dead")
    return dead and dead:IsA("BoolValue") and dead.Value == true or false
end
ExtraUI.standConfirmedDown = function(player, priorRecord)
    local function isDown(record)
        local model = record and record.model
        local hum = record and record.humanoid
        local effects = model and model:FindFirstChild("BodyEffects")
        local ko = effects and effects:FindFirstChild("K.O")
        local dead = effects and effects:FindFirstChild("Dead")
        return hum and (hum.Health <= 0 or ko and ko.Value or dead and dead.Value)
            or false
    end
    return isDown(priorRecord)
        or isDown(player and Hook.resolveShotRecord(player) or nil)
end
local function stopAutoKill(message, keepStompPaused)
    if S.standAttackTarget then
        local report = S.standChatReport
        local downOnly = S.standDownOnlyTarget == S.standAttackTarget
        local record = Hook.lockRecord
        local confirmedDown = downOnly and (report and report.downConfirmed
            or ExtraUI.standConfirmedDown(S.standAttackTarget, record))
        if confirmedDown and S.standCounterAttackTarget == S.standAttackTarget then
            local current = Hook.resolveShotRecord(S.standAttackTarget)
            S.standCounterHandled[S.standAttackTarget] = current and current.model
                or record and record.model or true
            S.standCounterShots[S.standAttackTarget] = nil
        end
        if report and not report.sent then
            local confirmed = report.stompSent
                and ExtraUI.standConfirmedDead(Hook.lockRecord)
            if confirmedDown then
                ExtraUI.standReportResult(report, "SUCCESS",
                    "target confirmed down; no stomp")
            elseif confirmed then
                ExtraUI.standReportResult(report, "SUCCESS",
                    "stomp sent; target confirmed dead")
            elseif report.target and report.target.Parent ~= Players then
                ExtraUI.standReportResult(report, "TARGET LEFT",
                    "player disconnected before kill confirmation")
            elseif downOnly then
                task.delay(1.25, function()
                    if report.sent then return end
                    if ExtraUI.standConfirmedDown(report.target) then
                        if report.command == "counter" then
                            local current = Hook.resolveShotRecord(report.target)
                            S.standCounterHandled[report.target] = current and current.model
                                or true
                            S.standCounterShots[report.target] = nil
                        end
                        ExtraUI.standReportResult(report, "SUCCESS",
                            "target confirmed down after replication delay")
                    elseif report.command == "counter" then
                        report.sent = true
                        if S.standChatReport == report then S.standChatReport = nil end
                        ExtraUI.standStatus("Counter ended without a confirmed down.")
                    else
                        ExtraUI.standReportResult(report, "FAILED",
                            "target not confirmed down")
                    end
                end)
            else
                ExtraUI.standReportResult(report, "FAILED",
                    (message or "attack ended without confirmed stomp and kill")
                        :gsub("^Auto kill: ", ""):gsub("^Stand: ", ""))
            end
        end
        if (confirmedDown or (report and report.stompSent
                and ExtraUI.standConfirmedDead(Hook.lockRecord)))
            and report and S.standSavedOrder
            and S.standSavedOrder.command == report.command
            and not (report.command == "counter"
                and string.lower(S.standSavedOrder.argument or "") == "me") then
            S.standSavedOrder = nil
            Env.SpectraStandSavedOrder = nil
        end
        local returnToOwner = S.standEnabled and S.standOwner ~= nil
            and S.standOwner ~= Me
        S.standAttackTarget = nil
        S.standDownOnlyTarget = nil
        S.standAttack2Target = nil
        S.standAttack3Target = nil
        S.standAttack4Target = nil
        S.standAttack5Target = nil
        S.standAttackVariant = nil
        S.standFinisherPlayed = false
        S.standSnipeTarget = nil
        S.standCounterAttackTarget = nil
        S.standDrivebyTarget = nil
        S.standAmbushTarget = nil
        S.standAmbushRushTarget = nil
        S.standAmbushHitAfter = nil
        S.standAttack2FinisherPlayed = false
        S.standAttack2LaunchQueued = false
        if ExtraUI.standEndCinematic then ExtraUI.standEndCinematic() end
         
        style(ForceHitBtn, S.forceHit, "FORCE HIT: ON", "FORCE HIT: OFF")
        S.quietAutoKill = S.standPreviousQuiet
        S.autoKillVoid = S.standPreviousVoid
        style(VoidKillBtn, S.autoKillVoid,
            "AUTO KILL VOID BLINK: ON", "AUTO KILL VOID BLINK: OFF")
        style(ExtraUI.QuietKillBtn, S.quietAutoKill,
            "QUIET AUTO KILL: ON", "QUIET AUTO KILL: OFF")
         
        S.rapidWeapons["[Revolver]"] = S.standRevolverRapidBefore or nil
        S.standRevolverRapidBefore = nil
        S.standEnabledRapid = nil
        Rapid.forEachGun(function(tool)
            if tool.Name == "[Revolver]" then Rapid.applyCooldown(tool) end
        end)
        if Rapid.rows["[Revolver]"] then
            style(Rapid.rows["[Revolver]"], S.rapidWeapons["[Revolver]"],
                "[Revolver]  /  ON", "[Revolver]  /  OFF")
        end
         
        if updateLoops then updateLoops() end
        if returnToOwner and ExtraUI.standOwnerRoot then
            local character = Me.Character
            local root = character and character:FindFirstChild("HumanoidRootPart")
            local hum = character and character:FindFirstChildOfClass("Humanoid")
            if root and hum and hum.Health > 0 and not S.resetInFlight then
                local ownerRoot = ExtraUI.standOwnerRoot()
                local destination = ownerRoot
                    and ownerRoot.CFrame * CFrame.new(2.5, 0, 3.5)
                local landing = ExtraUI.safeBringLanding
                    and destination
                    and ExtraUI.safeBringLanding(destination, character)
                if landing then
                    pcall(function()
                        character:PivotTo(landing)
                        root.AssemblyLinearVelocity = Vector3.zero
                        root.AssemblyAngularVelocity = Vector3.zero
                    end)
                end
            end
        end
    end
    S.autoKill = false
    S.autoKillGeneration = S.autoKillGeneration + 1
    S.killBringDestination = nil
    S.bringFollowOwner = nil
    S.voidBlinking = false
    if not keepStompPaused then restoreBringStomp() end
    style(Bring, false, "BRING SELECTED: ON", "BRING SELECTED")
    Hook.lockPlayer, Hook.lockRecord = nil, nil
    style(AutoKillBtn, false, "AUTO KILL SELECTED: ON", "AUTO KILL SELECTED: OFF")
    if not S.silent and not S.wallBang and not S.forceHit then Hook.enabled = false end
    if message then say(message) end
end
 
 
ExtraUI.safeBringLanding = function(destination, character)
    if typeof(destination) ~= "CFrame" or destination.Position.Y < -28 then
        return nil, "destination is below the safe map height"
    end
    local exclude = {character}
     
     
    local params = OverlapParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = exclude
    local floorParams = RaycastParams.new()
    floorParams.FilterType = Enum.RaycastFilterType.Exclude
    floorParams.FilterDescendantsInstances = exclude
    floorParams.IgnoreWater = true
    local offsets = {
        Vector3.new(5.5, 2.3, 0), Vector3.new(-5.5, 2.3, 0),
        Vector3.new(0, 2.3, 5.5), Vector3.new(0, 2.3, -5.5),
        Vector3.new(4.5, 3.5, 4.5), Vector3.new(-4.5, 3.5, -4.5),
    }
    for _, offset in ipairs(offsets) do
        local candidate = destination * CFrame.new(offset)
        local success, parts = pcall(function()
            return Workspace:GetPartBoundsInBox(CFrame.new(candidate.Position),
                Vector3.new(3.0, 4.5, 3.0), params)
        end)
        if not success then return nil, "landing collision query failed" end
        local blocked = false
        for _, part in ipairs(parts) do
            if part:IsA("BasePart") and part.CanCollide then
                blocked = true
                break
            end
        end
        if not blocked then
             
            local floor = Workspace:Raycast(candidate.Position + Vector3.new(0, 1, 0),
                Vector3.new(0, -12, 0), floorParams)
            if floor and floor.Instance.CanCollide and floor.Normal.Y > 0.5 then
                return candidate
            end
        end
    end
    return nil, "no clear, supported landing near the destination"
end

local function startAutoKill(bringDestination, bringOwner, explicitTarget)
    if S.aura and ExtraUI.stopAura then ExtraUI.stopAura() end
    if S.autoKill then stopAutoKill("Auto kill stopped."); return end
    local target = explicitTarget or S.primary
    local rec = target and (explicitTarget and Hook.resolveShotRecord(target)
        or Records[target])
    if not (explicitTarget and recordUsable(target, rec)
        or not explicitTarget and recordPresent(target, rec))
        or (not bringDestination and not alive(rec, true)) then
        say("Select a player on TARGETS first.")
        return
    end
    local ok, err = installRaycastHook()
    if not ok then say(err); return end
    S.autoKill = true
    S.lastConfirmedHitAt = os.clock()
    if S.standAmbushTarget == target then
        S.standAmbushHitAfter = S.lastConfirmedHitAt
    end
    S.lastAdaptiveSwitchAt = 0
    S.killBringDestination = bringDestination
    S.bringFollowOwner = bringDestination and bringOwner or nil
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
        local successfulActivations, lastNoDamageReport = 0, 0
        local function fireAttackWeapon(tool)
            local activated, err = Rapid.activate(tool)
            if not activated then
                if S.standAttackTarget == target then
                    ExtraUI.standStatus("Weapon activation failed: " .. tostring(err))
                else
                    say("Auto kill: weapon activation failed: " .. tostring(err))
                end
                return
            end
            successfulActivations = successfulActivations + 1
            local now = os.clock()
            if successfulActivations >= 10
                and now - S.lastConfirmedHitAt >= 3
                and now - lastNoDamageReport >= 3 then
                lastNoDamageReport = now
                local detail = ("%d shots sent; no confirmed server damage yet.")
                    :format(successfulActivations)
                if S.standAttackTarget == target then
                    ExtraUI.standStatus("Attack: " .. detail)
                else
                    say("Auto kill: " .. detail)
                end
            end
        end
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
        local snipeAnchor, snipeTargetPosition, nextSnipeMoveAt = nil, nil, 0
        local drivebyStartedAt, drivebyForward, drivebySide = nil, nil, nil
        local attackStartedAt = os.clock()
        local lastScene = -1
        local function findSnipePosition(character, root, victim)
            local base = victim.root.Position
            local away = root.Position - base
            away = Vector3.new(away.X, 0, away.Z)
            if away.Magnitude < 1 then away = Vector3.new(1, 0, 0) end
            local direction = away.Unit
            if S.standAttackVariant == "down" then
                local theta = math.floor((os.clock() - attackStartedAt) / 1.6)
                    * math.pi * 0.65
                direction = Vector3.new(
                    direction.X * math.cos(theta) - direction.Z * math.sin(theta),
                    0,
                    direction.X * math.sin(theta) + direction.Z * math.cos(theta))
            end
            local floorParams = RaycastParams.new()
            floorParams.FilterType = Enum.RaycastFilterType.Exclude
            floorParams.FilterDescendantsInstances = {character, victim.model}
            floorParams.IgnoreWater = true
            for ring = 1, 2 do
                local radius = S.standCounterAttackTarget == target
                    and (ring == 1 and 75 or 55)
                    or (ring == 1 and 135 or 105)
                for step = 0, 7 do
                    local theta = step * math.pi / 4
                    local radial = Vector3.new(
                        direction.X * math.cos(theta) - direction.Z * math.sin(theta),
                        0,
                        direction.X * math.sin(theta) + direction.Z * math.cos(theta))
                    local above = base + radial * radius + Vector3.new(0, 55, 0)
                    local floor = Workspace:Raycast(above, Vector3.new(0, -100, 0), floorParams)
                    if floor and floor.Instance.CanCollide and floor.Normal.Y > 0.55 then
                        local eye = floor.Position + Vector3.new(0, 6, 0)
                        local sight = Workspace:Raycast(eye,
                            base + Vector3.new(0, 1.5, 0) - eye, floorParams)
                        if not sight then
                            local facing = CFrame.lookAt(
                                floor.Position + Vector3.new(0, 3, 0),
                                base + Vector3.new(0, 1.5, 0))
                            local landing = ExtraUI.safeBringLanding(facing, character)
                            if landing then return landing end
                        end
                    end
                end
            end
            return nil
        end
        while not S.closed and S.autoKill and generation == S.autoKillGeneration do
            rec = explicitTarget and (recordUsable(target, rec) and rec
                or Hook.resolveShotRecord(target)) or Records[target]
            Hook.lockRecord = rec
            if not (explicitTarget and recordUsable(target, rec)
                or not explicitTarget and S.primary == target
                    and recordPresent(target, rec)) then
                stopAutoKill("Auto kill stopped: target changed or left.")
                break
            end
            local effects = rec.model:FindFirstChild("BodyEffects")
            local ko = effects and effects:FindFirstChild("K.O")
            local dead = effects and effects:FindFirstChild("Dead")
            local report = S.standChatReport
            if report and report.target == target and report.stompSent
                and ExtraUI.standConfirmedDead(rec) then
                ExtraUI.standReportResult(report, "SUCCESS",
                    "stomp sent; target confirmed dead")
                stopAutoKill("Stand: target confirmed dead after stomp.")
                break
            end
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
                    local downReport = S.standChatReport
                    if downReport and downReport.target == target then
                        downReport.downConfirmed = true
                    end
                    stopAutoKill("Stand: @" .. target.Name .. " is down; no stomp.")
                    break
                end
                if S.standAttackTarget == target and not S.standFinisherPlayed
                    and S.standAttackVariant ~= "snipe"
                    and S.standAttackVariant ~= "counter" then
                    S.standFinisherPlayed = true
                    if ExtraUI.standFinisher then
                        pcall(ExtraUI.standFinisher, target,
                            S.standAttackVariant, generation)
                    end
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
                    local followOwner = S.bringFollowOwner
                    local ownerRoot = followOwner and ExtraUI.standOwnerRoot()
                    if ownerRoot then destination = ownerRoot.CFrame end
                    local targetLower = rec.model:FindFirstChild("LowerTorso")
                    local ownEffects = character:FindFirstChild("BodyEffects")
                    local attacking = ownEffects and ownEffects:FindFirstChild("Attacking")
                    local storage = ReplicatedStorage:FindFirstChild("Storage")
                    local remotes = storage and storage:FindFirstChild("Remotes")
                    local main = remotes and remotes:FindFirstChild("Main")
                    if targetLower and main and not (attacking and attacking.Value) then
                        pcall(function() hum:UnequipTools() end)
                        pcall(function()
                             
                            local away = root.Position - targetLower.Position
                            away = Vector3.new(away.X, 0, away.Z)
                            if away.Magnitude < 0.1 then
                                away = targetLower.CFrame.LookVector
                                away = Vector3.new(away.X, 0, away.Z)
                            end
                            if away.Magnitude < 0.1 then away = Vector3.xAxis end
                            local approach = targetLower.Position + away.Unit * 2.7
                                + Vector3.new(0, 2.4, 0)
                            character:PivotTo(CFrame.lookAt(approach,
                                targetLower.Position + Vector3.new(0, 1, 0)))
                            root.AssemblyLinearVelocity = Vector3.zero
                            root.AssemblyAngularVelocity = Vector3.zero
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
                             
                            local latestOwnerRoot = followOwner and ExtraUI.standOwnerRoot()
                            if latestOwnerRoot then destination = latestOwnerRoot.CFrame end
                            local landing, problem = ExtraUI.safeBringLanding(destination, character)
                            if not landing then
                                pcall(function() main:FireServer("Grabbing") end)
                                stopAutoKill("Bring cancelled for safety: " .. tostring(problem))
                                break
                            end
                            pcall(function()
                                root.AssemblyLinearVelocity = Vector3.zero
                                root.AssemblyAngularVelocity = Vector3.zero
                                character:PivotTo(landing)
                                root.AssemblyLinearVelocity = Vector3.zero
                                root.AssemblyAngularVelocity = Vector3.zero
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
                             
                            pcall(function()
                                root.AssemblyLinearVelocity = Vector3.zero
                                root.AssemblyAngularVelocity = Vector3.zero
                            end)
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
                local report = S.standChatReport
                if report and report.target == target and stompOk and stompSent then
                    report.stompSent = true
                end
                if S.standAttack2Target == target and stompOk and stompSent
                    and not S.standAttack2LaunchQueued then
                    S.standAttack2LaunchQueued = true
                    local orderGeneration = S.standOrderGeneration
                    task.delay(0.95, function()
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
            if S.standCounterAttackTarget == target
                and S.standSnipeTarget == target
                and os.clock() - S.lastConfirmedHitAt > 3.5 then
                S.standSnipeTarget = nil
                ExtraUI.standStatus("Counter snipe had no confirmed damage; moving in on @"
                    .. target.Name .. ".")
            end
            if S.standAmbushTarget == target
                and S.standAmbushRushTarget ~= target
                and S.standAmbushHitAfter
                and S.lastConfirmedHitAt > S.standAmbushHitAfter then
                S.standAmbushRushTarget = target
                S.standSnipeTarget = nil
                ExtraUI.standStatus("Ambush hit confirmed; closing on @" .. target.Name .. ".")
            end
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
                angle = angle + (S.standAttack3Target == target and 0.15
                    or S.standAttack5Target == target and 0.75
                    or 0.62 + math.random() * 0.28)
                local radius = S.standAmbushRushTarget == target and 4.5
                    or S.standAttack5Target == target and 5.5
                    or S.strafeRadius + (math.random() - 0.5) * 1.5
                local jitter = Vector3.new(math.random() - 0.5,
                    math.random() * 0.8, math.random() - 0.5)
                local lead = rec.root.AssemblyLinearVelocity * 0.045
                local offset = Vector3.new(math.cos(angle) * radius, 1.5,
                    math.sin(angle) * radius) + jitter
                local attackCFrame = CFrame.lookAt(rec.root.Position + lead + offset,
                    rec.root.Position + lead + Vector3.new(0, 1.5, 0))
                local elapsed = os.clock() - attackStartedAt
                local scene = math.floor(elapsed / 1.2)
                if scene ~= lastScene then
                    lastScene = scene
                    if S.standAttackTarget == target and scene <= 2
                        and S.standAttackVariant ~= "snipe"
                        and S.standAttackVariant ~= "counter" then
                        local name = S.standAttack2Target and "run-in"
                            or S.standAttack3Target and "sky spiral"
                            or S.standAttack4Target and "vanish"
                            or S.standAttack5Target and "helix"
                            or S.standDrivebyTarget and "driveby"
                            or S.standAmbushTarget and "peekaboo"
                            or "crossfire"
                        ExtraUI.standStatus(name .. " / phase " .. (scene + 1)
                            .. " / @" .. target.Name)
                    end
                end
                if S.standAttackTarget == target
                    and not S.standAttack2Target
                    and not S.standAttack3Target
                    and not S.standAttack4Target
                    and not S.standAttack5Target
                    and not S.standDrivebyTarget
                    and not S.standAmbushTarget
                    and not S.standSnipeTarget then
                     
                    local phase = math.floor(elapsed / 0.65) % 4
                    local across = phase == 0 and -12 or phase == 1 and 12
                        or phase == 2 and -5 or 5
                    local retreat = phase == 2 and 16 or 5
                    local side = rec.root.CFrame.RightVector * across
                    attackCFrame = CFrame.lookAt(rec.root.Position + side
                        - rec.root.CFrame.LookVector * retreat + Vector3.new(0, 2, 0),
                        rec.root.Position + Vector3.new(0, 1.5, 0))
                end
                if S.standAttack4Target == target then
                     
                    local phase = math.floor(elapsed / 0.9) % 3
                    local depth = phase == 0 and 20 or phase == 1 and 7 or -6
                    local flank = phase == 2 and 9 or -4
                    local rear = rec.root.Position - rec.root.CFrame.LookVector * depth
                        + rec.root.CFrame.RightVector * flank
                        + Vector3.new(0, 2, 0)
                    attackCFrame = CFrame.lookAt(rear,
                        rec.root.Position + Vector3.new(0, 1.5, 0))
                end
                if S.standAttack2Target == target then
                     
                    local lunge = math.floor(elapsed / 0.48) % 3 == 0 and 13 or 3
                    local approach = rec.root.Position
                        - rec.root.CFrame.LookVector * lunge
                        + rec.root.CFrame.RightVector * math.sin(elapsed * 5) * 2
                        + Vector3.new(0, 2, 0)
                    attackCFrame = CFrame.lookAt(approach,
                        rec.root.Position + Vector3.new(0, 1.5, 0))
                end
                if S.standAttack5Target == target then
                     
                    local helix = elapsed * 5
                    local sweep = Vector3.new(math.sin(helix) * 8,
                        2.5 + (1 + math.sin(helix * 0.7)) * 3,
                        math.sin(helix * 2) * 7)
                    attackCFrame = CFrame.lookAt(rec.root.Position + sweep,
                        rec.root.Position + Vector3.new(0, 1.5, 0))
                end
                if S.standAmbushTarget == target then
                     
                    local side = math.floor(elapsed / 0.32) % 2 == 0 and 1 or -1
                    local peek = rec.root.Position
                        - rec.root.CFrame.LookVector * (elapsed < 1.5 and 10 or 3)
                        + rec.root.CFrame.RightVector * side * (elapsed < 1.5 and 6 or 2)
                        + Vector3.new(0, 2, 0)
                    attackCFrame = CFrame.lookAt(peek,
                        rec.root.Position + Vector3.new(0, 1.5, 0))
                end
                if S.standDrivebyTarget == target then
                    if not drivebyStartedAt then
                        drivebyStartedAt = os.clock()
                        drivebyForward = root.Position - rec.root.Position
                        drivebyForward = Vector3.new(drivebyForward.X, 0, drivebyForward.Z)
                        if drivebyForward.Magnitude < 1 then
                            drivebyForward = Vector3.new(1, 0, 0)
                        end
                        drivebyForward = drivebyForward.Unit
                        drivebySide = Vector3.new(-drivebyForward.Z, 0, drivebyForward.X)
                    end
                    local progress = math.min(1, (os.clock() - drivebyStartedAt) / 1.8)
                    local pass = progress < 0.5 and progress * 2 or (progress - 0.5) * 2
                    local lane = progress < 0.5 and 1 or -1
                    local passPosition = rec.root.Position + drivebyForward * (lane * 9)
                        + drivebySide * ((pass * 2 - 1) * 28)
                        + Vector3.new(0, 2, 0)
                    local passFrame = CFrame.lookAt(passPosition,
                        rec.root.Position + Vector3.new(0, 1.5, 0))
                    local safePass = ExtraUI.safeBringLanding(passFrame, character)
                    if safePass then attackCFrame = safePass end
                    if progress >= 1 then
                        S.standDrivebyTarget = nil
                        ExtraUI.standStatus("Driveby pass complete; finishing @" .. target.Name .. ".")
                    end
                end
                if S.standAttack3Target == target then
                     
                    local skyHeight = math.max(16, 80 - elapsed * 15)
                    local skyRadius = math.max(18, 90 - elapsed * 14)
                    attackCFrame = CFrame.lookAt(rec.root.Position + Vector3.new(
                        math.cos(angle) * skyRadius, skyHeight,
                        math.sin(angle) * skyRadius),
                        rec.root.Position + Vector3.new(0, 1.5, 0))
                end
                if S.standSnipeTarget == target then
                    local needMove = not snipeAnchor
                        or not snipeTargetPosition
                        or (rec.root.Position - snipeTargetPosition).Magnitude > 55
                        or distance < 80 or distance > 225
                        or S.standAttackVariant == "down"
                            and elapsed >= 1.6 and os.clock() >= nextSnipeMoveAt
                    if needMove and os.clock() >= nextSnipeMoveAt then
                        nextSnipeMoveAt = os.clock() + 1.5
                        local position = findSnipePosition(character, root, rec)
                        if position then
                            snipeAnchor = position
                            snipeTargetPosition = rec.root.Position
                        elseif not snipeAnchor then
                            if S.standCounterAttackTarget == target then
                                S.standSnipeTarget = nil
                                ExtraUI.standStatus("Counter: moving in to down @"
                                    .. target.Name .. "; no clear snipe position.")
                            else
                                stopAutoKill("Snipe stopped: no supported position with a clear shot.")
                                break
                            end
                        end
                    end
                    if snipeAnchor then
                        attackCFrame = CFrame.lookAt(snipeAnchor.Position,
                            rec.root.Position + Vector3.new(0, 1.5, 0))
                    end
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
                    and os.clock() - Rapid.lastShotAt(tool) >= cooldown
                    or not rapid and tick() - lastShot >= cooldown
                if S.quietAutoKill and not S.killBringDestination then
                    if readyToFire then
                        fireAttackWeapon(tool)
                    end
                    task.wait(rapid and 0.02 or 0.045)
                    continue
                end
                 
                 
                if readyToFire and S.autoKillVoid and not S.killBringDestination then
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
                        pcall(function() character:PivotTo(ExtraUI.LastSafeCFrame or attackCFrame) end)
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
                    fireAttackWeapon(tool)
                end
                task.wait(rapid and 0.02 or 0.045)
            else
                task.wait(0.045)
            end
        end
    end)
end
ExtraUI.startAttackOne = function(target, downOnly, variant, independent)
    if not target or (not independent and S.primary ~= target) then
        return false, "Select a player on TARGETS first."
    end
    local character = Me.Character
    local bag = Me:FindFirstChildOfClass("Backpack")
    local revolver = (character and character:FindFirstChild("[Revolver]"))
        or (bag and bag:FindFirstChild("[Revolver]"))
    if not revolver then return false, "Revolver is not in your inventory." end
    if S.autoKill then stopAutoKill() end
    S.standRevolverRapidBefore = S.rapidWeapons["[Revolver]"] == true
    S.standPreviousQuiet = S.quietAutoKill
    S.standPreviousVoid = S.autoKillVoid
     
     
    S.standEnabledRapid = not S.rapidWeapons["[Revolver]"]
     
     
    S.quietAutoKill = false
    S.autoKillVoid = false
    S.rapidWeapons["[Revolver]"] = true
    S.standAttackTarget = target
    S.standAttackVariant = variant or "attack"
    S.standFinisherPlayed = false
    if independent then
        local targetRecord = Hook.resolveShotRecord(target)
        S.standChatReport = {
            command = variant or "attack", target = target,
            name = target.Name, targetModel = targetRecord and targetRecord.model,
            stompSent = false, sent = false,
        }
    end
    S.standDownOnlyTarget = downOnly and target or nil
    S.standAttack2Target = variant == "attack2" and not downOnly and target or nil
    S.standAttack3Target = variant == "attack3" and not downOnly and target or nil
    S.standAttack4Target = variant == "attack4" and not downOnly and target or nil
    S.standAttack5Target = variant == "attack5" and not downOnly and target or nil
    S.standDrivebyTarget = variant == "driveby" and target or nil
    S.standAmbushTarget = variant == "ambush" and target or nil
    S.standAmbushRushTarget = nil
    S.standAmbushHitAfter = nil
    S.standSnipeTarget = (variant == "snipe" or variant == "down"
        or variant == "counter")
        and target or nil
    S.standCounterAttackTarget = variant == "counter" and target or nil
    S.standAttack2FinisherPlayed = false
    S.standAttack2LaunchQueued = false
    style(ExtraUI.QuietKillBtn, S.quietAutoKill,
        "QUIET AUTO KILL: ON", "QUIET AUTO KILL: OFF")
    style(VoidKillBtn, false,
        "AUTO KILL VOID BLINK: ON", "AUTO KILL VOID BLINK: OFF")
    style(ForceHitBtn, S.forceHit, "FORCE HIT: ON", "FORCE HIT: OFF")
    Rapid.forEachGun(function(tool)
        if tool.Name == "[Revolver]" then Rapid.applyCooldown(tool) end
    end)
    if Rapid.rows["[Revolver]"] then
        style(Rapid.rows["[Revolver]"], S.rapidWeapons["[Revolver]"],
            "[Revolver]  /  ON", "[Revolver]  /  OFF")
    end
    local started, startError = pcall(startAutoKill, nil, nil,
        independent and target or nil)
    if not started or not S.autoKill then
        stopAutoKill()
        return false, started and "Target unavailable." or tostring(startError)
    end
    if updateLoops then updateLoops() end
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
local AfkPreferenceFile = "RACER_PermaAFK.txt"
if type(isfile) == "function" and type(readfile) == "function" then
    local ok, stored = pcall(function()
        return isfile(AfkPreferenceFile) and readfile(AfkPreferenceFile) or nil
    end)
    if ok and (stored == "on" or stored == "off") then
        S.afkPermanent = stored == "on"
    end
elseif type(Env.SpectraPermanentAFK) == "boolean" then
    S.afkPermanent = Env.SpectraPermanentAFK
end
local function sendAfk(value)
    local storage = ReplicatedStorage:FindFirstChild("Storage")
    local remotes = storage and storage:FindFirstChild("Remotes")
    local main = remotes and remotes:FindFirstChild("Main")
    if not main or not main:IsA("RemoteEvent") then return false end
    return pcall(function() main:FireServer("UpdateAFK", value) end)
end
local function setPermanentAfk(enabled, persist)
    S.afkPermanent = enabled == true
    S.afkGeneration = S.afkGeneration + 1
    local generation = S.afkGeneration
    Env.SpectraPermanentAFK = S.afkPermanent
    style(ExtraUI.StandAfkBtn, S.afkPermanent,
        "PERMANENT AFK: ON", "PERMANENT AFK: OFF")
    if persist and type(writefile) == "function" then
        pcall(writefile, AfkPreferenceFile, S.afkPermanent and "on" or "off")
    end
    sendAfk(S.afkPermanent)
    if S.afkPermanent then
        task.spawn(function()
            while not S.closed and S.afkPermanent
                and generation == S.afkGeneration do
                local character = Me.Character
                local hum = character and character:FindFirstChildOfClass("Humanoid")
                local tag = hum and hum:GetAttribute("AsmoTagStored")
                if not hum or type(tag) ~= "string"
                    or not tag:find("<b>AFK</b>", 1, true) then
                    sendAfk(true)
                end
                task.wait(2)
            end
        end)
    end
end
ExtraUI.setPermanentAfk = setPermanentAfk
bind(ExtraUI.StandAfkBtn.MouseButton1Click:Connect(function()
    setPermanentAfk(not S.afkPermanent, true)
    ExtraUI.standStatus(S.afkPermanent and "Permanent AFK enabled."
        or "Permanent AFK disabled.")
end))
bind(UIS.WindowFocused:Connect(function()
    if not S.afkPermanent then return end
    task.delay(0.12, function()
        if not S.closed and S.afkPermanent then sendAfk(true) end
    end)
end))
bind(Me.CharacterAdded:Connect(function()
    if not S.afkPermanent then return end
    task.delay(0.5, function()
        if not S.closed and S.afkPermanent then sendAfk(true) end
    end)
end))
setPermanentAfk(S.afkPermanent, false)
local TextChatService = game:GetService("TextChatService")
local StarterGui = game:GetService("StarterGui")
local function setChatSpy(enabled)
    local window = TextChatService:FindFirstChild("ChatWindowConfiguration")
    local tabs = TextChatService:FindFirstChild("ChannelTabsConfiguration")
    local inputBar = TextChatService:FindFirstChild("ChatInputBarConfiguration")
    if enabled then
        if not window then return false, "Chat window is unavailable." end
        if not S.chatSpyOriginal then
            local coreOk, coreEnabled = pcall(function()
                return StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Chat)
            end)
            S.chatSpyOriginal = {
                window = window.Enabled,
            }
            if tabs then S.chatSpyOriginal.tabs = tabs.Enabled end
            if inputBar then S.chatSpyOriginal.input = inputBar.Enabled end
            if coreOk then S.chatSpyOriginal.core = coreEnabled end
        end
        local ok = pcall(function()
            window.Enabled = true
            if tabs then tabs.Enabled = true end
            if inputBar then inputBar.Enabled = true end
            StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
        end)
        if not ok then return false, "Could not unlock the chat window." end
        S.chatSpy = true
    else
        S.chatSpy = false
        local previous = S.chatSpyOriginal
        S.chatSpyOriginal = nil
        if previous then
            pcall(function()
                if window then window.Enabled = previous.window end
                if tabs and previous.tabs ~= nil then tabs.Enabled = previous.tabs end
                if inputBar and previous.input ~= nil then inputBar.Enabled = previous.input end
                if previous.core ~= nil then
                    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, previous.core)
                end
            end)
        end
    end
    style(ExtraUI.ChatSpyBtn, S.chatSpy, "CHAT SPY: ON", "CHAT SPY: OFF")
    return true
end
ExtraUI.setChatSpy = setChatSpy
bind(ExtraUI.ChatSpyBtn.MouseButton1Click:Connect(function()
    local ok, reason = setChatSpy(not S.chatSpy)
    ExtraUI.standStatus(ok and (S.chatSpy
        and "Chat window unlocked for messages delivered to your client."
        or "Chat window restored.") or reason)
end))
ExtraUI.jumpBypassConnection = nil
ExtraUI.jumpBypassInputConnection = nil
local function disconnectJumpBypass()
    if ExtraUI.jumpBypassConnection then
        ExtraUI.jumpBypassConnection:Disconnect()
        ExtraUI.jumpBypassConnection = nil
    end
    if ExtraUI.jumpBypassInputConnection then
        ExtraUI.jumpBypassInputConnection:Disconnect()
        ExtraUI.jumpBypassInputConnection = nil
    end
end
local function attachJumpBypass(character)
    S.jumpBypassGeneration = S.jumpBypassGeneration + 1
    local generation = S.jumpBypassGeneration
    disconnectJumpBypass()
    if not S.jumpBypass then return end
    if not ExtraUI.Capabilities.connections then
        task.spawn(function()
            local hum = character and character:WaitForChild("Humanoid", 5)
            if not hum or generation ~= S.jumpBypassGeneration then return end
            local normalJump = math.max(hum.JumpPower, 50)
            ExtraUI.jumpBypassConnection = RunService.RenderStepped:Connect(function()
                if S.closed or not S.jumpBypass
                    or generation ~= S.jumpBypassGeneration
                    or Me.Character ~= character then return end
                if hum.JumpPower < normalJump then hum.JumpPower = normalJump end
            end)
            ExtraUI.jumpBypassInputConnection = UIS.JumpRequest:Connect(function()
                if S.closed or not S.jumpBypass
                    or generation ~= S.jumpBypassGeneration
                    or Me.Character ~= character or UIS:GetFocusedTextBox() then return end
                if hum.Health <= 0 or hum.Sit
                    or hum.FloorMaterial == Enum.Material.Air then return end
                hum.JumpPower = normalJump
                hum.Jump = true
            end)
        end)
        return
    end
    task.spawn(function()
        local hum = character and character:WaitForChild("Humanoid", 5)
        if not hum then return end
         
         
        for _ = 1, 40 do
            if S.closed or not S.jumpBypass or generation ~= S.jumpBypassGeneration
                or Me.Character ~= character then return end
            local flags = nil
            local ok, connections = pcall(getconnections, hum.Jumping)
            if ok then
                for _, connection in ipairs(connections) do
                    if type(connection.Function) == "function" then
                        local readOk, upvalues = pcall(debug.getupvalues,
                            connection.Function)
                        if readOk and type(upvalues) == "table" then
                            for _, value in pairs(upvalues) do
                                if type(value) == "table"
                                    and type(value.NoJumping) == "boolean"
                                    and type(value.HighJump) == "boolean" then
                                    flags = value
                                    break
                                end
                            end
                        end
                    end
                    if flags then break end
                end
            end
            if flags then
                flags.NoJumping = false
                 
                 
                 
                 
                ExtraUI.jumpBypassInputConnection = UIS.JumpRequest:Connect(function()
                    if S.closed or not S.jumpBypass
                        or generation ~= S.jumpBypassGeneration
                        or Me.Character ~= character or UIS:GetFocusedTextBox() then return end
                    if hum.Health <= 0 or hum.Sit
                        or hum.FloorMaterial == Enum.Material.Air
                        or not hum:GetStateEnabled(Enum.HumanoidStateType.Jumping) then return end
                    flags.NoJumping = false
                    hum.Jump = true
                end)
                ExtraUI.jumpBypassConnection = hum.Jumping:Connect(function(jumping)
                    if not jumping or S.closed or not S.jumpBypass
                        or generation ~= S.jumpBypassGeneration then return end
                    flags.NoJumping = false
                    task.defer(function()
                        if not S.closed and S.jumpBypass
                            and generation == S.jumpBypassGeneration then
                            flags.NoJumping = false
                        end
                    end)
                end)
                return
            end
            task.wait(0.1)
        end
        if generation == S.jumpBypassGeneration then
            S.jumpBypass = false
            style(ExtraUI.JumpBypassBtn, false,
                "JUMP BYPASS: ON", "JUMP BYPASS: OFF")
            ExtraUI.standStatus("Jump bypass unavailable: game limiter was not found.")
        end
    end)
end
bind(ExtraUI.JumpBypassBtn.MouseButton1Click:Connect(function()
    S.jumpBypass = not S.jumpBypass
    style(ExtraUI.JumpBypassBtn, S.jumpBypass,
        "JUMP BYPASS: ON", "JUMP BYPASS: OFF")
    attachJumpBypass(Me.Character)
    ExtraUI.standStatus(S.jumpBypass
        and "Jump bypass on: normal grounded jumps without the short lockout."
        or "Jump bypass off; the game's jump limit is active again.")
end))
bind(Me.CharacterAdded:Connect(function(character)
    if S.jumpBypass then attachJumpBypass(character) end
end))
ExtraUI.standResolvePlayer = function(query, includeSelf)
    query = (query or ""):match("^%s*(.-)%s*$")
    query = query:gsub("^@", ""):gsub("^%((.-)%)$", "%1")
        :gsub('^"(.-)"$', "%1")
    query = string.lower(query)
    if query == "" then return nil, "Enter a player name." end
    local exactName, exactDisplay, matches = nil, nil, {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Me or includeSelf then
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
ExtraUI.standResolveTarget = function(sender, query)
    local alias = string.lower((query or ""):match("^%s*(.-)%s*$"))
    if alias == "me" or alias == "myself" or alias == "owner" then
        return sender
    end
    return ExtraUI.standResolvePlayer(query)
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
    if S.standFlingTargetHumanoid and S.standFlingTargetHumanoid.Parent then
        pcall(function()
            S.standFlingTargetHumanoid.PlatformStand =
                S.standFlingTargetPlatformBefore or false
        end)
    end
    S.standFlingTargetHumanoid = nil
    S.standFlingTargetPlatformBefore = nil
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
            if ExtraUI.standPlayEmote then
                ExtraUI.standPlayEmote("Greeting", 0.9)
            end
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
        if ExtraUI.standPlayEmote then
            ExtraUI.standPlayEmote("Greeting", 0.9)
        end
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
ExtraUI.standFinisher = function(target, variant, generation)
    local character = Me.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local hum = character and character:FindFirstChildOfClass("Humanoid")
    if not root or not hum or hum.Health <= 0 then return end
    for step = 1, 7 do
        if S.closed or not S.autoKill or generation ~= S.autoKillGeneration
            or Me.Character ~= character then return end
        local victim = ExtraUI.standTargetRoot(target)
        if not victim then return end
        local progress = step / 7
        local radius = (1 - progress) * 6
        local theta = progress * math.pi * (variant == "attack5" and 3 or 1)
        local side = variant == "attack4" and -victim.CFrame.LookVector
            or variant == "ambush" and victim.CFrame.RightVector
            or variant == "driveby" and victim.CFrame.LookVector
            or Vector3.new(math.cos(theta), 0, math.sin(theta))
        local height = variant == "attack3" and 3 + (1 - progress) * 15
            or 3 + (1 - progress) * 4
        local position = victim.Position + side * radius
            + Vector3.new(0, height, 0)
        pcall(function()
            character:PivotTo(CFrame.lookAt(position,
                victim.Position + Vector3.new(0, 1, 0)))
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end)
        task.wait(0.03)
    end
end
ExtraUI.standAmbushIntro = function(target, generation)
    local character = Me.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local hum = character and character:FindFirstChildOfClass("Humanoid")
    local targetRoot = ExtraUI.standTargetRoot(target)
    if not root or not hum or hum.Health <= 0 or not targetRoot then return false end
    local side = targetRoot.CFrame.RightVector
    local back = targetRoot.CFrame.LookVector
    local function moveBehind(sideOffset)
        if S.closed or not S.standEnabled
            or generation ~= S.standOrderGeneration
            or Me.Character ~= character or hum.Health <= 0 then return false end
        targetRoot = ExtraUI.standTargetRoot(target)
        if not targetRoot then return false end
        local position = targetRoot.Position - back * 9 + side * sideOffset
            + Vector3.new(0, 2, 0)
        pcall(function()
            character:PivotTo(CFrame.lookAt(position,
                targetRoot.Position + Vector3.new(0, 1.5, 0)))
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end)
        return true
    end
    if not moveBehind(-7) then return false end
    task.wait(0.24)
    if not moveBehind(7) then return false end
    task.wait(0.24)
    if not moveBehind(0) then return false end
    if ExtraUI.standPlayEmote then
        ExtraUI.standPlayEmote("Greeting", 0.9)
    end
    ExtraUI.standSendChat("psst... behind you")
    task.wait(0.3)
    return moveBehind(-3)
end
ExtraUI.standPlayEmote = function(name, seconds)
    local character = Me.Character
    local hum = character and character:FindFirstChildOfClass("Humanoid")
    local animator = hum and hum:FindFirstChildOfClass("Animator")
    local storage = ReplicatedStorage:FindFirstChild("Storage")
    local animations = storage and storage:FindFirstChild("Animations")
    local emotes = animations and animations:FindFirstChild("Emotes")
    local animation = emotes and emotes:FindFirstChild(name)
    if not animator or not animation or not animation:IsA("Animation") then return end
    local ok, track = pcall(function() return animator:LoadAnimation(animation) end)
    if not ok or not track then return end
    track.Priority = Enum.AnimationPriority.Action
    track.Looped = false
    pcall(function() track:Play(0.1) end)
    task.delay(seconds or 0.9, function()
        pcall(function() track:Stop(0.1) end)
    end)
end
ExtraUI.standStylizedIntro = function(target, variant, generation)
    local character = Me.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local hum = character and character:FindFirstChildOfClass("Humanoid")
    if not root or not hum or hum.Health <= 0 then return false end
    if variant == "attack" then
        ExtraUI.standPlayEmote("Boxing", 0.8)
    elseif variant == "attack4" then
        ExtraUI.standPlayEmote("Greeting", 0.8)
    end
    local frames = variant == "driveby" and 9 or 7
    for step = 1, frames do
        if S.closed or not S.standEnabled
            or generation ~= S.standOrderGeneration
            or Me.Character ~= character or hum.Health <= 0 then return false end
        local victim = ExtraUI.standTargetRoot(target)
        if not victim then return false end
        local progress = step / frames
        local forward, right = victim.CFrame.LookVector, victim.CFrame.RightVector
        local position
        if variant == "attack3" then
            local theta = progress * math.pi * 1.4
            position = victim.Position + Vector3.new(
                math.cos(theta) * 30, 5 + progress * 48,
                math.sin(theta) * 30)
        elseif variant == "attack4" then
            position = victim.Position + forward * (step <= 2 and 11 or -10)
                + right * (step <= 2 and 0 or math.sin(progress * math.pi) * 5)
                + Vector3.new(0, 2, 0)
        elseif variant == "attack5" then
            local theta = progress * math.pi * 2
            position = victim.Position + right * math.cos(theta) * 10
                + forward * math.sin(theta) * 10
                + Vector3.new(0, 3 + progress * 7, 0)
        elseif variant == "driveby" then
            position = victim.Position + right * (-37 + progress * 24)
                - forward * 11 + Vector3.new(0, 2, 0)
        else
            position = victim.Position + right * (step % 2 == 0 and 11 or -11)
                - forward * (step <= 3 and 10 or 5)
                + Vector3.new(0, 2, 0)
        end
        pcall(function()
            character:PivotTo(CFrame.lookAt(position,
                victim.Position + Vector3.new(0, 1.5, 0)))
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end)
        task.wait(0.08)
    end
    return true
end
ExtraUI.standDownIntro = function(target, generation)
    local character = Me.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local hum = character and character:FindFirstChildOfClass("Humanoid")
    if not root or not hum or hum.Health <= 0 then return false end
    local ownerRoot = ExtraUI.standOwnerRoot()
    if ownerRoot and S.standOwner ~= Me then
        local salute = ownerRoot.Position + ownerRoot.CFrame.RightVector * 4
            + Vector3.new(0, 2, 0)
        pcall(function()
            character:PivotTo(CFrame.lookAt(salute,
                ownerRoot.Position + Vector3.new(0, 1.5, 0)))
            root.AssemblyLinearVelocity = Vector3.zero
        end)
    end
    if ExtraUI.standPlayEmote then
        ExtraUI.standPlayEmote("Greeting", 0.65)
    end
    task.wait(0.55)
    if S.closed or not S.standEnabled
        or generation ~= S.standOrderGeneration
        or Me.Character ~= character or hum.Health <= 0 then return false end
    return ExtraUI.standTargetRoot(target) ~= nil
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
ExtraUI.standReleaseHold = function()
    local restore = S.standHoldRestore
    S.standHoldRestore = nil
    if restore then pcall(restore) end
end
ExtraUI.stopAura = function(message)
    if not S.aura then return end
    S.aura = false
    S.auraFromStand = false
    S.auraProtectedPlayer = nil
    S.auraProtectMissingAt = nil
    S.auraGeneration = S.auraGeneration + 1
    Hook.auraTarget, Hook.auraRecord = nil, nil
    style(ExtraUI.AuraBtn, false, "AURA 75 STUDS: ON", "AURA 75 STUDS: OFF")
    if S.auraRevolverRapidBefore ~= nil then
        S.rapidWeapons["[Revolver]"] = S.auraRevolverRapidBefore or nil
        S.auraRevolverRapidBefore = nil
        Rapid.forEachGun(function(tool)
            if tool.Name == "[Revolver]" then Rapid.applyCooldown(tool) end
        end)
        if Rapid.rows["[Revolver]"] then
            style(Rapid.rows["[Revolver]"], S.rapidWeapons["[Revolver]"],
                "[Revolver]  /  ON", "[Revolver]  /  OFF")
        end
    end
    if S.auraStompRestore ~= nil then
        S.autoStomp = S.auraStompRestore
        S.auraStompRestore = nil
        S.stompSuppressed = not S.autoStomp
        style(AutoStompBtn, S.autoStomp, "AUTO STOMP: ON", "AUTO STOMP: OFF")
        updateAutoStomp()
    end
    if message then say(message) end
end
ExtraUI.startAura = function(fromStand, protectTarget)
    if S.aura then
        if fromStand then
            S.auraFromStand = true
            S.auraProtectedPlayer = protectTarget
            S.auraProtectMissingAt = nil
        end
        return true
    end
    local ok, reason = installRaycastHook()
    if not ok then return false, reason end
    if S.autoKill then stopAutoKill() end
    S.aura = true
    S.auraFromStand = fromStand == true
    S.auraProtectedPlayer = protectTarget
    S.auraProtectMissingAt = nil
    table.clear(S.auraThreatUntil)
    table.clear(S.auraRecentFiring)
    table.clear(S.auraBlockedUntil)
    S.auraLastHealth, S.auraLastArmor, S.auraLastCharacter = nil, nil, nil
    S.auraTargetShots, S.auraTargetSince, S.auraTargetHitAt = 0, 0, 0
    S.auraRevolverRapidBefore = S.rapidWeapons["[Revolver]"] == true
    S.rapidWeapons["[Revolver]"] = true
    Rapid.forEachGun(function(tool)
        if tool.Name == "[Revolver]" then Rapid.applyCooldown(tool) end
    end)
    if Rapid.rows["[Revolver]"] then
        style(Rapid.rows["[Revolver]"], true,
            "[Revolver]  /  ON", "[Revolver]  /  OFF")
    end
    S.auraGeneration = S.auraGeneration + 1
    local generation = S.auraGeneration
    local guardStartedAt = os.clock()
    S.auraStompRestore = S.autoStomp
    S.autoStomp = false
    S.stompSuppressed = true
    style(AutoStompBtn, false, "AUTO STOMP: ON", "AUTO STOMP: OFF")
    updateAutoStomp()
    style(ExtraUI.AuraBtn, true, "AURA 75 STUDS: ON", "AURA 75 STUDS: OFF")
    task.spawn(function()
        while not S.closed and S.aura and generation == S.auraGeneration do
            local now = os.clock()
            local character = Me.Character
            local root = character and character:FindFirstChild("HumanoidRootPart")
            local centerRoot = if S.auraProtectedPlayer
                then ExtraUI.standTargetRoot(S.auraProtectedPlayer)
                else if S.auraFromStand then ExtraUI.standOwnerRoot() else root
            if S.auraProtectedPlayer and not centerRoot then
                S.auraProtectMissingAt = S.auraProtectMissingAt or now
                if S.auraProtectedPlayer.Parent ~= Players
                    or now - S.auraProtectMissingAt > 6 then
                    ExtraUI.stopAura("Protect stopped: player unavailable.")
                    break
                end
            else
                S.auraProtectMissingAt = nil
            end
            local hum = character and character:FindFirstChildOfClass("Humanoid")
            local bag = Me:FindFirstChildOfClass("Backpack")
            local effects = character and character:FindFirstChild("BodyEffects")
            local ko = effects and effects:FindFirstChild("K.O")
            local reload = effects and effects:FindFirstChild("Reload")
            local armorValue = effects and effects:FindFirstChild("Armor")
            local watchedCharacter = centerRoot and centerRoot.Parent or character
            local watchedHum = watchedCharacter and watchedCharacter:FindFirstChildOfClass("Humanoid")
            local watchedEffects = watchedCharacter and watchedCharacter:FindFirstChild("BodyEffects")
            local watchedArmorValue = watchedEffects and watchedEffects:FindFirstChild("Armor")
            local ownHealth = watchedHum and watchedHum.Health or nil
            local ownArmor = watchedArmorValue and watchedArmorValue.Value or nil
            local tookDamage = S.auraLastCharacter == watchedCharacter
                and ((ownHealth and S.auraLastHealth
                    and ownHealth < S.auraLastHealth)
                    or (ownArmor and S.auraLastArmor
                    and ownArmor < S.auraLastArmor))
            S.auraLastCharacter = watchedCharacter
            S.auraLastHealth, S.auraLastArmor = ownHealth, ownArmor
            if centerRoot and root and hum and hum.Health > 0 and bag
                and not (ko and ko.Value) and not (reload and reload.Value) then
                if S.auraFromStand and centerRoot ~= root
                    and not S.auraProtectedPlayer then
                    local guardPosition = centerRoot.Position
                        + centerRoot.CFrame.RightVector * 4
                        - centerRoot.CFrame.LookVector * 2
                        + Vector3.new(0, 0.4, 0)
                    if (root.Position - guardPosition).Magnitude > 1.4 then
                        pcall(function()
                            character:PivotTo(CFrame.lookAt(guardPosition,
                                guardPosition + centerRoot.CFrame.LookVector))
                            root.AssemblyLinearVelocity = Vector3.zero
                        end)
                    end
                end
                local eligible = {}
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= Me and (not S.auraFromStand or player ~= S.standOwner)
                        and player ~= S.auraProtectedPlayer then
                        local rec = Records[player]
                        if not recordUsable(player, rec) then
                            rec = Hook.resolveShotRecord(player)
                        end
                        if recordUsable(player, rec) and alive(rec, true)
                            and (rec.root.Position - centerRoot.Position).Magnitude <= 75 then
                            local targetEffects = rec.model:FindFirstChild("BodyEffects")
                            local firing = targetEffects and targetEffects:FindFirstChild("GunFiring")
                            local firingNow = firing and firing.Value == true
                            if firingNow then S.auraRecentFiring[player] = os.clock() end
                            local toward = centerRoot.Position - rec.root.Position
                            local facing = toward.Magnitude > 0.1
                                and rec.root.CFrame.LookVector:Dot(toward.Unit) > 0.35
                            if firingNow and facing then
                                S.auraThreatUntil[player] = os.clock() + 1.2
                            elseif tookDamage and facing
                                and os.clock() - (S.auraRecentFiring[player] or 0) < 0.65 then
                                S.auraThreatUntil[player] = os.clock() + 3
                            end
                            eligible[#eligible + 1] = {player = player, record = rec,
                                distance = (rec.root.Position - centerRoot.Position).Magnitude}
                        end
                    end
                end
                local chosen = nil
                if #eligible > 1 and Hook.auraTarget
                    and S.auraTargetShots >= 8
                    and now - S.auraTargetSince >= 1.5
                    and (S.auraTargetHitAt == 0
                        or now - S.auraTargetHitAt >= 2) then
                    S.auraBlockedUntil[Hook.auraTarget] = now + 1.5
                    S.auraTargetShots = 0
                end
                local bestThreatUntil = now
                for _, entry in ipairs(eligible) do
                    local expires = S.auraThreatUntil[entry.player] or 0
                    if expires > bestThreatUntil
                        and (S.auraBlockedUntil[entry.player] or 0) <= now then
                        chosen, bestThreatUntil = entry, expires
                    end
                end
                for _, entry in ipairs(eligible) do
                    if not chosen and entry.player == Hook.auraTarget
                        and (S.auraBlockedUntil[entry.player] or 0) <= now then
                        chosen = entry
                        break
                    end
                end
                if not chosen then
                    for _, entry in ipairs(eligible) do
                        if (S.auraBlockedUntil[entry.player] or 0) <= now
                            and (not chosen or entry.distance < chosen.distance) then
                            chosen = entry
                        end
                    end
                end
                if not chosen then chosen = eligible[1] end
                if chosen and chosen.player ~= Hook.auraTarget then
                    S.auraTargetSince = now
                    S.auraTargetHitAt = 0
                    S.auraTargetShots = 0
                end
                Hook.auraTarget = chosen and chosen.player or nil
                Hook.auraRecord = chosen and chosen.record or nil
                if S.auraProtectedPlayer and centerRoot ~= root then
                    local elapsed = now - guardStartedAt
                    local phase = elapsed % 4.8
                    local theta = elapsed * 7
                    local radius, height
                    if phase < 1.2 then
                        radius, height = 11, 2.5
                    elseif phase < 2.2 then
                        radius = 14
                        height = 2.5 + (phase - 1.2) * 27
                    elseif phase < 3.1 then
                        radius, height = 17, 29.5
                    elseif phase < 4 then
                        radius = 17 - (phase - 3.1) * 10
                        height = 29.5 - (phase - 3.1) * 30
                    else
                        radius, height = 8, 2.5
                    end
                    local guardPosition = centerRoot.Position
                        + centerRoot.CFrame.RightVector * math.cos(theta) * radius
                        + centerRoot.CFrame.LookVector * math.sin(theta) * radius
                        + Vector3.new(0, math.max(2.5, height), 0)
                    if phase >= 4 and chosen then
                        local toward = chosen.record.root.Position
                            - centerRoot.Position
                        local flat = Vector3.new(toward.X, 0, toward.Z)
                        if flat.Magnitude > 0.1 then
                            guardPosition = centerRoot.Position + flat.Unit * 8
                                + Vector3.new(0, 2.5, 0)
                        end
                    end
                    local focus = chosen and chosen.record.root.Position
                        + Vector3.new(0, 1.5, 0)
                        or centerRoot.Position + centerRoot.CFrame.LookVector * 5
                    pcall(function()
                        character:PivotTo(CFrame.lookAt(guardPosition, focus))
                        root.AssemblyLinearVelocity = Vector3.zero
                        root.AssemblyAngularVelocity = Vector3.zero
                    end)
                end
                if chosen then
                    local function usable(tool)
                        if not tool or not tool:IsA("Tool")
                            or not tool:FindFirstChild("Response") then return false end
                        local ammo = tool:GetAttribute("RealAmmo")
                        if type(ammo) ~= "number" then ammo = tool:GetAttribute("Ammo") end
                        return type(ammo) ~= "number" or ammo > 0
                    end
                    local tool = character:FindFirstChild("[Revolver]")
                    if not usable(tool) then tool = bag:FindFirstChild("[Revolver]") end
                    if not usable(tool) then tool = character:FindFirstChildOfClass("Tool") end
                    if not usable(tool) then
                        tool = nil
                        for _, name in ipairs({"[Revolver]", "[Double-Barrel SG]",
                            "[TacticalShotgun]", "[Shotgun]", "[SMG]"}) do
                            local candidate = bag:FindFirstChild(name)
                            if usable(candidate) then tool = candidate; break end
                        end
                    end
                    if tool and tool.Parent == bag then
                        pcall(function() hum:EquipTool(tool) end)
                        task.wait(0.06)
                    end
                    if tool and tool.Parent == character and S.aura
                        and generation == S.auraGeneration then
                        local rapid = S.rapidWeapons[tool.Name]
                        local pace = rapid and 0.05
                            or math.max(0.02, tool:GetAttribute("Cooldown") or 0.1)
                        local ready = rapid
                            and os.clock() - Rapid.lastShotAt(tool) >= pace
                            or not rapid and tick()
                                - (tool:GetAttribute("ShotCooldownStarted") or 0) >= pace
                        if ready then
                            local activated = Rapid.activate(tool)
                            if activated then
                                S.auraTargetShots = S.auraTargetShots + 1
                            end
                        end
                        Rapid.requestReload(tool)
                    end
                end
            else
                Hook.auraTarget, Hook.auraRecord = nil, nil
            end
            task.wait(0.035)
        end
        Hook.auraTarget, Hook.auraRecord = nil, nil
    end)
    return true
end
bind(ExtraUI.AuraBtn.MouseButton1Click:Connect(function()
    if S.aura then
        ExtraUI.stopAura("Aura stopped.")
    else
        local ok, reason = ExtraUI.startAura(false)
        say(ok and "Aura active: force hit within 75 studs; down targets without stomping."
            or tostring(reason))
    end
end))
ExtraUI.stopFloatingFollow = function()
    if S.standFloatTrack then
        pcall(function() S.standFloatTrack:Stop(0.15) end)
        S.standFloatTrack = nil
    end
    local character = S.standFloatCharacter
    if character then
        local hum = character:FindFirstChildOfClass("Humanoid")
        local root = character:FindFirstChild("HumanoidRootPart")
        if hum and S.standFloatAutoRotate ~= nil then
            hum.AutoRotate = S.standFloatAutoRotate
        end
        if root and S.standFloatRootCollide ~= nil then
            root.CanCollide = S.standFloatRootCollide
        end
    end
    S.standFloatCharacter = nil
    S.standFloatAutoRotate = nil
    S.standFloatRootCollide = nil
end
ExtraUI.standStop = function(message)
    ExtraUI.stopAura()
    S.standCounterTarget = nil
    S.standCounterPending = nil
    if S.standCounterBulletConnection then
        S.standCounterBulletConnection:Disconnect()
        S.standCounterBulletConnection = nil
    end
    S.standCounterBulletHooked = false
    table.clear(S.standCounterShots)
    table.clear(S.standCounterHandled)
    table.clear(S.standCounterReportedDown)
    S.standSavedOrder = nil
    Env.SpectraStandSavedOrder = nil
    Env.SpectraStandCounterPendingUserId = nil
    ExtraUI.stopFloatingFollow()
    ExtraUI.standEndCinematic()
    ExtraUI.standCancelFling()
    ExtraUI.standReleaseHold()
    S.standFollow = false
    S.standFollowGeneration = S.standFollowGeneration + 1
    S.standOrderGeneration = S.standOrderGeneration + 1
    if S.autoKill then stopAutoKill() end
    if ExtraUI.applyGunMods then ExtraUI.applyGunMods(Me.Character) end
    if message then ExtraUI.standStatus(message) end
end
ExtraUI.standObserveShot = function(shot)
    if not S.standCounterTarget or type(shot) ~= "table" then return end
    local shooter = shot.Player
    if typeof(shooter) == "Instance" and shooter:IsA("Player")
        and shooter.Parent == Players and shooter ~= Me
        and shooter ~= S.standOwner then
        local owner = S.standOwner
        local ownerRoot = ExtraUI.standOwnerRoot()
            or owner and ExtraUI.standTargetRoot(owner)
        local ownerModel = ownerRoot and ownerRoot.Parent
        local ownerCharacter = owner and owner.Character
        local direct = false
        local near = false
        local function checkHit(part, position)
            if typeof(part) == "Instance"
                and (ownerModel and part:IsDescendantOf(ownerModel)
                    or ownerCharacter and part:IsDescendantOf(ownerCharacter)) then
                direct = true
            end
            if typeof(position) == "Vector3" and ownerRoot
                and (position - ownerRoot.Position).Magnitude <= 5.5 then
                near = true
            end
        end
        if type(shot.Instance) == "table" then
            for i, part in pairs(shot.Instance) do
                checkHit(part, type(shot.Position) == "table"
                    and shot.Position[i] or nil)
            end
        else
            checkHit(shot.Instance, shot.Position)
        end
        if direct or near then
            local sample = S.standCounterShots[shooter] or {}
            if direct then sample.directAt = os.clock() end
            if near then sample.nearAt = os.clock() end
            S.standCounterShots[shooter] = sample
        end
    end
end
ExtraUI.standConnectBulletFeed = function()
    if S.standCounterBulletConnection then
        S.standCounterBulletHooked = true
        return true
    end
    local storage = ReplicatedStorage:FindFirstChild("Storage")
    local remotes = storage and storage:FindFirstChild("Remotes")
    local remote = remotes and remotes:FindFirstChild("BulletReplication")
    if not remote or not remote:IsA("RemoteEvent") then return false end
    S.standCounterBulletConnection = remote.OnClientEvent:Connect(function(action, shot)
        if action == "ReplicateBullets" and ExtraUI.standObserveShot then
            pcall(ExtraUI.standObserveShot, shot)
        end
    end)
    S.standCounterBulletHooked = true
    return true
end
ExtraUI.standRememberOrder = function(sender, command, argument)
    local order = {
        ownerUserId = sender.UserId,
        command = command,
        argument = argument or "",
    }
    S.standSavedOrder = order
    Env.SpectraStandSavedOrder = order
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
                    local launchModel = targetPart and targetPart.Parent
                    local launched = false
                    local observedDistance = 0
                    local impactAnnounced = false
                    local lastProgressAt = started
                    if target then
                        ExtraUI.standStatus("Fling windup / @" .. target.Name
                            .. " / attempt " .. attempts .. ".")
                        if ExtraUI.standPlayEmote then
                            ExtraUI.standPlayEmote("Boxing", 0.55)
                        end
                    end
                    while not S.closed and S.standEnabled and S.standFlinging
                        and generation == S.standFlingGeneration
                        and Me.Character == character and hum.Health > 0
                        and (target or os.clock() - started < 2.5) do
                        targetPart = target and ExtraUI.standTargetRoot(target)
                        if target and not targetPart then break end
                        if targetPart and targetPart.Parent ~= launchModel then break end
                        if targetPart and targetPart.Anchored then
                            if os.clock() - lastProgressAt >= 2 then
                                lastProgressAt = os.clock()
                                ExtraUI.standStatus("Fling waiting: target root is anchored.")
                            end
                            task.wait(0.1)
                            continue
                        end
                        local elapsed = os.clock() - started
                        local impact = not target or elapsed >= 0.45
                        if target and impact and not impactAnnounced then
                            impactAnnounced = true
                            ExtraUI.standStatus("Fling impact / @" .. target.Name .. ".")
                        end
                        local angle = elapsed * (impact and 44 or 12)
                        local center = targetPart and targetPart.Position or originalCFrame.Position
                        local offset = targetPart and Vector3.new(
                            math.cos(angle) * (impact and 0.55 or 5 - elapsed * 9),
                            impact and 0.25 or 1.8,
                            math.sin(angle) * (impact and 0.55 or 5 - elapsed * 9))
                            or Vector3.zero
                        root.CanCollide = impact
                        hum.AutoRotate = false
                        character:PivotTo(CFrame.new(center + offset)
                            * CFrame.Angles(0, angle, 0))
                        root.AssemblyAngularVelocity = Vector3.new(0,
                            impact and 3000 or 320, 0)
                        root.AssemblyLinearVelocity = targetPart and impact
                            and Vector3.new(-math.cos(angle) * 400, 160,
                                -math.sin(angle) * 400)
                            or Vector3.new(0, 25, 0)
                        if targetPart and impact then
                            local ownerOk, ownsTarget = pcall(isnetworkowner, targetPart)
                            if ownerOk and ownsTarget then
                                local targetHum = targetPart.Parent
                                    and targetPart.Parent:FindFirstChildOfClass("Humanoid")
                                if targetHum and S.standFlingTargetHumanoid ~= targetHum then
                                    if S.standFlingTargetHumanoid
                                        and S.standFlingTargetHumanoid.Parent then
                                        pcall(function()
                                            S.standFlingTargetHumanoid.PlatformStand =
                                                S.standFlingTargetPlatformBefore or false
                                        end)
                                    end
                                    S.standFlingTargetHumanoid = targetHum
                                    S.standFlingTargetPlatformBefore = targetHum.PlatformStand
                                    pcall(function() targetHum.PlatformStand = true end)
                                elseif targetHum and not targetHum.PlatformStand then
                                    pcall(function() targetHum.PlatformStand = true end)
                                end
                                local away = targetPart.Position - originalCFrame.Position
                                away = Vector3.new(away.X, 0, away.Z)
                                if away.Magnitude < 0.1 then
                                    away = targetPart.CFrame.LookVector
                                    away = Vector3.new(away.X, 0, away.Z)
                                end
                                if away.Magnitude < 0.1 then away = Vector3.xAxis end
                                local distanceMoved = (targetPart.Position
                                    - launchPosition).Magnitude
                                local turn = distanceMoved < 20
                                    and math.floor(elapsed / 1.5) % 4 or 0
                                away = CFrame.Angles(0, turn * math.pi / 2, 0)
                                    :VectorToWorldSpace(away.Unit)
                                local velocity = away * 480 + Vector3.new(0, 280, 0)
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
                        if targetPart and launchPosition and impact then
                            observedDistance = (targetPart.Position
                                - launchPosition).Magnitude
                            if launched and observedDistance >= 200 then
                                task.wait(0.12)
                                targetPart = ExtraUI.standTargetRoot(target)
                                if targetPart then
                                    observedDistance = (targetPart.Position
                                        - launchPosition).Magnitude
                                    if observedDistance >= 200 then
                                        flung = true
                                        break
                                    end
                                end
                            end
                            if os.clock() - lastProgressAt >= 2 then
                                lastProgressAt = os.clock()
                                ExtraUI.standStatus(("Inside @%s / %.0f of 200 studs / speed %.0f / ownership %s.")
                                    :format(target.Name, observedDistance,
                                        targetPart.AssemblyLinearVelocity.Magnitude,
                                        launched and "yes" or "no"))
                            end
                        end
                        task.wait(0.03)
                    end
                    if not target then break end
                    targetPart = ExtraUI.standTargetRoot(target)
                    if S.standFlingMover then
                        pcall(function() S.standFlingMover:Destroy() end)
                        S.standFlingMover = nil
                    end
                    if S.standFlingTargetHumanoid then
                        if S.standFlingTargetHumanoid.Parent then
                            pcall(function()
                                S.standFlingTargetHumanoid.PlatformStand =
                                    S.standFlingTargetPlatformBefore or false
                            end)
                        end
                        S.standFlingTargetHumanoid = nil
                        S.standFlingTargetPlatformBefore = nil
                    end
                    if flung then break end
                    if target and targetPart then
                        ExtraUI.standStatus(("Fling contact reset / @%s still at %.0f of 200 studs.")
                            :format(target.Name, observedDistance))
                    end
                    task.wait(0.04)
                end
            end
        end)
        if generation == S.standFlingGeneration then
            ExtraUI.standCancelFling()
            ExtraUI.standStatus(not ok and ("Fling stopped: " .. tostring(err))
                or (target and flung
                    and ("@" .. target.Name .. " confirmed 200+ studs after " .. attempts
                        .. (attempts == 1 and " attempt." or " attempts."))
                    or (target and "Fling stopped; target left or character reset."
                        or "Spin finished; position restored.")))
        end
    end)
end
ExtraUI.standSetOwner = function(owner)
    if not owner or owner.Parent ~= Players then
        ExtraUI.standStatus("Choose a player as owner.")
        return
    end
    ExtraUI.standStop()
    if S.standOwnerChatConnection then
        S.standOwnerChatConnection:Disconnect()
        S.standOwnerChatConnection = nil
    end
    S.standOwner = owner
    Env.SpectraStandOwnerUserId = owner.UserId
    ExtraUI.StandOwnerLabel.Text = owner == Me
        and ("Owner: YOU (@" .. owner.Name .. ")")
        or ("Owner: @" .. owner.Name .. " (" .. owner.DisplayName .. ")")
    ExtraUI.StandOwnerInput.Text = owner.Name
    S.standOwnerChatConnection = owner.Chatted:Connect(function(message)
        if ExtraUI.standHandleChat then ExtraUI.standHandleChat(owner, message) end
    end)
    ExtraUI.standStatus(owner == Me
        and "Self owner set. Enable Listen for !attack, !attack2-5, !snipe, !down, !aura, !goto, !stop."
        or ("Owner set to @" .. owner.Name .. ". Enable Listen."))
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
    if sender == Me and command ~= "attack" and command ~= "attack2"
        and command ~= "attack3" and command ~= "attack4"
        and command ~= "attack5" and command ~= "snipe"
        and command ~= "down"
        and command ~= "aura"
        and command ~= "protect" and command ~= "counter"
        and command ~= "driveby" and command ~= "ambush"
        and command ~= "goto"
        and command ~= "stop" then
        ExtraUI.standStatus("Self owner: attack, snipe, down, aura, protect, counter, driveby, ambush, goto, stop.")
        return
    end
    if command == "stop" then
        ExtraUI.standStop("Stopped by owner.")
    elseif command == "aura" then
        ExtraUI.standStop()
        local ok, reason = ExtraUI.startAura(true)
        ExtraUI.standStatus(ok and "Aura active: downing players within 75 studs; no stomp."
            or tostring(reason))
    elseif command == "protect" then
        local target, issue = ExtraUI.standResolveTarget(sender, argument)
        if not target then ExtraUI.standStatus(issue); return end
        if target == Me then
            ExtraUI.standStatus("Use !aura to guard yourself.")
            return
        end
        ExtraUI.standStop()
        local ok, reason = ExtraUI.startAura(true, target)
        ExtraUI.standStatus(ok and ("Protecting @" .. target.Name .. " within 75 studs.")
            or tostring(reason))
    elseif command == "counter" then
        if string.lower((argument or ""):match("^%s*(.-)%s*$")) == "me" then
            ExtraUI.standStop()
            S.standCounterTarget = sender
            ExtraUI.standConnectBulletFeed()
            ExtraUI.applyGunMods(Me.Character)
            local generation = S.standOrderGeneration
            ExtraUI.standStatus("Counter guard armed for @" .. sender.Name .. ".")
            task.spawn(function()
                local recentFiring = {}
                local firingState = {}
                local lastShotStamp = {}
                local vitalSamples = {}
                local watchedModel, watchedHumObject, watchedArmorObject = nil, nil, nil
                local lastHealth, lastArmor = nil, nil
                local damageAt = 0
                local lastDamageReportedAt = 0
                local lastOwnerMissingNoticeAt = 0
                local lastBulletHookAttemptAt = 0
                local watchConnections = {}
                while S.standEnabled and generation == S.standOrderGeneration
                    and S.standCounterTarget == sender do
                    if sender.Parent ~= Players then
                        S.standCounterTarget = nil
                        ExtraUI.standStatus("Counter guard stopped: owner left.")
                        break
                    end
                    if not S.standCounterBulletHooked
                        and os.clock() - lastBulletHookAttemptAt > 1 then
                        lastBulletHookAttemptAt = os.clock()
                        ExtraUI.standConnectBulletFeed()
                        ExtraUI.applyGunMods(Me.Character)
                    end
                    if not S.autoKill then
                        local ownerRoot = ExtraUI.standOwnerRoot()
                            or ExtraUI.standTargetRoot(sender)
                        local attacker = nil
                        if ownerRoot then
                            local ownerModel = ownerRoot.Parent
                            local possibleModels = {ownerModel}
                            if sender.Character and sender.Character ~= ownerModel then
                                possibleModels[#possibleModels + 1] = sender.Character
                            end
                            local ownerRecord = Records[sender]
                                or Hook.resolveShotRecord(sender)
                            if ownerRecord and ownerRecord.model
                                and ownerRecord.model ~= ownerModel
                                and ownerRecord.model ~= sender.Character then
                                possibleModels[#possibleModels + 1] = ownerRecord.model
                            end
                            for _, model in ipairs(possibleModels) do
                                local sampleHum = model:FindFirstChildOfClass("Humanoid")
                                local sampleEffects = model:FindFirstChild("BodyEffects")
                                local sampleArmor = sampleEffects and sampleEffects:FindFirstChild("Armor")
                                if sampleHum then
                                    local previous = vitalSamples[sampleHum]
                                    if previous and sampleHum.Health < previous then
                                        damageAt = os.clock()
                                    end
                                    vitalSamples[sampleHum] = sampleHum.Health
                                end
                                if sampleArmor and sampleArmor:IsA("ValueBase")
                                    and type(sampleArmor.Value) == "number" then
                                    local previous = vitalSamples[sampleArmor]
                                    if previous and sampleArmor.Value < previous then
                                        damageAt = os.clock()
                                    end
                                    vitalSamples[sampleArmor] = sampleArmor.Value
                                end
                            end
                            local ownerHum = ownerModel:FindFirstChildOfClass("Humanoid")
                            local ownerEffects = ownerModel:FindFirstChild("BodyEffects")
                            local ownerArmor = ownerEffects and ownerEffects:FindFirstChild("Armor")
                            local healthNow = ownerHum and ownerHum.Health
                            local armorNow = ownerArmor and ownerArmor.Value
                            if ownerModel ~= watchedModel
                                or ownerHum ~= watchedHumObject
                                or ownerArmor ~= watchedArmorObject then
                                for _, connection in ipairs(watchConnections) do
                                    connection:Disconnect()
                                end
                                table.clear(watchConnections)
                                watchedModel, watchedHumObject, watchedArmorObject =
                                    ownerModel, ownerHum, ownerArmor
                                lastHealth, lastArmor = healthNow, armorNow
                                if ownerHum then
                                    watchConnections[#watchConnections + 1] = ownerHum.HealthChanged:Connect(function(value)
                                        if lastHealth and value < lastHealth then damageAt = os.clock() end
                                        lastHealth = value
                                    end)
                                end
                                if ownerArmor and ownerArmor:IsA("ValueBase") then
                                    watchConnections[#watchConnections + 1] = ownerArmor.Changed:Connect(function(value)
                                        if type(value) == "number" then
                                            if lastArmor and value < lastArmor then damageAt = os.clock() end
                                            lastArmor = value
                                        end
                                    end)
                                end
                            end
                            if (healthNow and lastHealth and healthNow < lastHealth)
                                or (armorNow and lastArmor and armorNow < lastArmor) then
                                damageAt = os.clock()
                            end
                            lastHealth, lastArmor = healthNow, armorNow
                            local damaged = os.clock() - damageAt < 0.65
                            local recentShooter, recentCount = nil, 0
                            for _, player in ipairs(Players:GetPlayers()) do
                                if player ~= Me and player ~= sender then
                                    local shooterRoot = ExtraUI.standTargetRoot(player)
                                    if shooterRoot then
                                        local effects = shooterRoot.Parent:FindFirstChild("BodyEffects")
                                        local firing = effects and effects:FindFirstChild("GunFiring")
                                        local firingNow = firing and firing.Value == true or false
                                        local toward = ownerRoot.Position - shooterRoot.Position
                                        local distance = toward.Magnitude
                                        local equipped = shooterRoot.Parent:FindFirstChildOfClass("Tool")
                                        if firingNow and not firingState[player] then
                                            recentFiring[player] = os.clock()
                                        end
                                        firingState[player] = firingNow
                                        local shotStamp = equipped
                                            and equipped:GetAttribute("ShotCooldownStarted")
                                        if type(shotStamp) == "number" then
                                            if lastShotStamp[player] and shotStamp > lastShotStamp[player] then
                                                recentFiring[player] = os.clock()
                                            end
                                            lastShotStamp[player] = shotStamp
                                        end
                                        if damaged and distance <= 230 and equipped then
                                            local firedAt = recentFiring[player] or 0
                                            if math.abs(firedAt - damageAt) <= 0.65 then
                                                recentShooter = player
                                                recentCount = recentCount + 1
                                            end
                                        end
                                    else
                                        firingState[player] = false
                                    end
                                end
                            end
                            if damaged then
                                local directShooter, directCount = nil, 0
                                local nearShooter, nearCount = nil, 0
                                for player, shot in pairs(S.standCounterShots) do
                                    if player.Parent == Players and type(shot) == "table" then
                                        if shot.directAt
                                            and math.abs(shot.directAt - damageAt) <= 1.2 then
                                            directShooter = player
                                            directCount = directCount + 1
                                        elseif shot.nearAt
                                            and math.abs(shot.nearAt - damageAt) <= 0.65 then
                                            nearShooter = player
                                            nearCount = nearCount + 1
                                        end
                                    end
                                end
                                if directCount == 1 then
                                    attacker = directShooter
                                elseif directCount == 0 and nearCount == 1 then
                                    attacker = nearShooter
                                elseif directCount == 0 and nearCount == 0
                                    and recentCount == 1
                                    and os.clock() - damageAt >= 0.12 then
                                    attacker = recentShooter
                                end
                                if damageAt > lastDamageReportedAt then
                                    lastDamageReportedAt = damageAt
                                    ExtraUI.standStatus(attacker
                                        and ("Owner hit detected; counter target @"
                                            .. attacker.Name .. ".")
                                        or "Owner hit detected; shooter ambiguous, holding fire.")
                                end
                            end
                        else
                            watchedModel, watchedHumObject, watchedArmorObject = nil, nil, nil
                            lastHealth, lastArmor = nil, nil
                            if os.clock() - lastOwnerMissingNoticeAt > 4 then
                                lastOwnerMissingNoticeAt = os.clock()
                                ExtraUI.standStatus("Counter waiting for owner's character.")
                            end
                        end
                        if attacker then
                            local attackRecord = Hook.resolveShotRecord(attacker)
                            if not attackRecord then
                                attacker = nil
                            elseif not alive(attackRecord, true) then
                                S.standCounterHandled[attacker] = attackRecord.model
                                attacker = nil
                            elseif S.standCounterHandled[attacker] == attackRecord.model then
                                attacker = nil
                            else
                                S.standCounterHandled[attacker] = nil
                            end
                        end
                        if attacker then
                            damageAt = 0
                            if not S.standCounterPending then
                                S.standCounterPending = attacker
                                Env.SpectraStandCounterPendingUserId = attacker.UserId
                                ExtraUI.standStatus("Counter queued for @" .. attacker.Name
                                    .. " after @" .. sender.Name .. " took damage.")
                            end
                        end
                        local pending = S.standCounterPending
                        if pending and pending.Parent ~= Players then
                            S.standCounterPending = nil
                            Env.SpectraStandCounterPendingUserId = nil
                        elseif pending then
                            local pendingRecord = Hook.resolveShotRecord(pending)
                            if not pendingRecord then
                                task.wait(0.1)
                                continue
                            end
                            if pendingRecord and not alive(pendingRecord, true) then
                                S.standCounterHandled[pending] = pendingRecord.model
                                S.standCounterPending = nil
                                Env.SpectraStandCounterPendingUserId = nil
                                ExtraUI.standStatus("Counter target @" .. pending.Name
                                    .. " is already down; guard remains armed.")
                                task.wait(0.05)
                                continue
                            end
                            if pendingRecord
                                and S.standCounterHandled[pending] == pendingRecord.model then
                                S.standCounterPending = nil
                                Env.SpectraStandCounterPendingUserId = nil
                                task.wait(0.05)
                                continue
                            end
                            local ownCharacter = Me.Character
                            local ownHum = ownCharacter and ownCharacter:FindFirstChildOfClass("Humanoid")
                            local ownRoot = ownCharacter and ownCharacter:FindFirstChild("HumanoidRootPart")
                            local bag = Me:FindFirstChildOfClass("Backpack")
                            local revolver = ownCharacter and ownCharacter:FindFirstChild("[Revolver]")
                                or bag and bag:FindFirstChild("[Revolver]")
                            if ownHum and ownRoot and ownHum.Health > 0 and revolver then
                                local started, reason = ExtraUI.startAttackOne(
                                    pending, true, "counter", true)
                                if started then
                                    S.standCounterPending = nil
                                    Env.SpectraStandCounterPendingUserId = nil
                                    ExtraUI.standStatus("Counter sniping @" .. pending.Name .. ".")
                                elseif reason == "Target unavailable." then
                                    S.standCounterPending = nil
                                    Env.SpectraStandCounterPendingUserId = nil
                                elseif reason ~= "Revolver is not in your inventory." then
                                    ExtraUI.standStatus("Counter retry: " .. tostring(reason))
                                    task.wait(0.5)
                                end
                            end
                        end
                    end
                    task.wait(0.05)
                end
                for _, connection in ipairs(watchConnections) do
                    connection:Disconnect()
                end
            end)
            ExtraUI.standRememberOrder(sender, command, argument)
            return
        end
        local target, issue = ExtraUI.standResolveTarget(sender, argument)
        if not target then ExtraUI.standStatus(issue); return end
        if target == Me or target == S.standOwner then
            ExtraUI.standStatus("Choose another player to counter.")
            return
        end
        ExtraUI.standStop()
        S.standCounterTarget = target
        ExtraUI.standConnectBulletFeed()
        ExtraUI.applyGunMods(Me.Character)
        local generation = S.standOrderGeneration
        ExtraUI.standStatus("Counter armed for @" .. target.Name .. ".")
        task.spawn(function()
            local lastHealth, lastArmor, watchedModel = nil, nil, nil
            local watchedHumObject, watchedArmorObject = nil, nil
            local lastThreatAt = 0
            local damageAt = 0
            local watchConnections = {}
            while S.standEnabled and generation == S.standOrderGeneration
                and S.standCounterTarget == target do
                if S.standCounterPending == target then break end
                if target.Parent ~= Players then
                    S.standCounterTarget = nil
                    ExtraUI.standStatus("Counter cancelled: target left.")
                    break
                end
                local ownerRoot = ExtraUI.standOwnerRoot()
                local targetRoot = ExtraUI.standTargetRoot(target)
                local ownerModel = ownerRoot and ownerRoot.Parent
                local ownerHum = ownerModel and ownerModel:FindFirstChildOfClass("Humanoid")
                local ownerEffects = ownerModel and ownerModel:FindFirstChild("BodyEffects")
                local armor = ownerEffects and ownerEffects:FindFirstChild("Armor")
                local healthNow = ownerHum and ownerHum.Health
                local armorNow = armor and armor.Value
                if ownerModel ~= watchedModel
                    or ownerHum ~= watchedHumObject or armor ~= watchedArmorObject then
                    for _, connection in ipairs(watchConnections) do
                        connection:Disconnect()
                    end
                    table.clear(watchConnections)
                    watchedModel, watchedHumObject, watchedArmorObject =
                        ownerModel, ownerHum, armor
                    lastHealth, lastArmor = healthNow, armorNow
                    if ownerHum then
                        watchConnections[#watchConnections + 1] = ownerHum.HealthChanged:Connect(function(value)
                            if lastHealth and value < lastHealth then damageAt = os.clock() end
                            lastHealth = value
                        end)
                    end
                    if armor and armor:IsA("ValueBase") then
                        watchConnections[#watchConnections + 1] = armor.Changed:Connect(function(value)
                            if type(value) == "number" then
                                if lastArmor and value < lastArmor then damageAt = os.clock() end
                                lastArmor = value
                            end
                        end)
                    end
                end
                local firedToward = false
                if ownerRoot and targetRoot then
                    local effects = targetRoot.Parent:FindFirstChild("BodyEffects")
                    local gunFiring = effects and effects:FindFirstChild("GunFiring")
                    local toward = ownerRoot.Position - targetRoot.Position
                    firedToward = gunFiring and gunFiring.Value == true
                        and toward.Magnitude > 0.1 and toward.Magnitude <= 175
                        and targetRoot.CFrame.LookVector:Dot(toward.Unit) > 0.35
                end
                if firedToward then lastThreatAt = os.clock() end
                if (healthNow and lastHealth and healthNow < lastHealth)
                    or (armorNow and lastArmor and armorNow < lastArmor) then
                    damageAt = os.clock()
                end
                lastHealth, lastArmor = healthNow, armorNow
                local armed = targetRoot and targetRoot.Parent:FindFirstChildOfClass("Tool")
                local closeEnough = ownerRoot and targetRoot
                    and (ownerRoot.Position - targetRoot.Position).Magnitude <= 350
                if os.clock() - damageAt < 0.35
                    and (firedToward or os.clock() - lastThreatAt < 2
                        or (armed and closeEnough)) then
                    S.standCounterPending = target
                    Env.SpectraStandCounterPendingUserId = target.UserId
                    ExtraUI.standStatus("Counter queued for @" .. target.Name .. ".")
                    break
                end
                task.wait(0.05)
            end
            for _, connection in ipairs(watchConnections) do
                connection:Disconnect()
            end
            while S.standEnabled and generation == S.standOrderGeneration
                and S.standCounterTarget == target
                and S.standCounterPending == target do
                if target.Parent ~= Players then
                    S.standCounterTarget = nil
                    S.standCounterPending = nil
                    Env.SpectraStandCounterPendingUserId = nil
                    break
                end
                local targetRecord = Hook.resolveShotRecord(target)
                if not targetRecord then
                    task.wait(0.2)
                    continue
                end
                if targetRecord and not alive(targetRecord, true) then
                    S.standCounterHandled[target] = targetRecord.model
                    S.standCounterTarget = nil
                    S.standCounterPending = nil
                    Env.SpectraStandCounterPendingUserId = nil
                    ExtraUI.standStatus("Counter target already down; order finished.")
                    break
                end
                local ownCharacter = Me.Character
                local ownHum = ownCharacter and ownCharacter:FindFirstChildOfClass("Humanoid")
                local ownRoot = ownCharacter and ownCharacter:FindFirstChild("HumanoidRootPart")
                local bag = Me:FindFirstChildOfClass("Backpack")
                local revolver = ownCharacter and ownCharacter:FindFirstChild("[Revolver]")
                    or bag and bag:FindFirstChild("[Revolver]")
                if ownHum and ownRoot and ownHum.Health > 0 and revolver then
                    local started, reason = ExtraUI.startAttackOne(target, true, "counter", true)
                    if started then
                        S.standCounterTarget = nil
                        S.standCounterPending = nil
                        Env.SpectraStandCounterPendingUserId = nil
                        ExtraUI.standStatus("Counter sniping @" .. target.Name .. ".")
                        break
                    elseif reason == "Target unavailable." then
                        S.standCounterTarget = nil
                        S.standCounterPending = nil
                        Env.SpectraStandCounterPendingUserId = nil
                        break
                    elseif reason ~= "Revolver is not in your inventory." then
                        ExtraUI.standStatus("Counter retry: " .. tostring(reason))
                    end
                end
                task.wait(0.2)
            end
        end)
    elseif command == "help" then
        local topic = string.lower(argument or "")
        ExtraUI.standStatus(topic == "attack"
            and "!attack, !attack2-5, !snipe, !down, !driveby, !ambush, !counter, !protect, !stop."
            or topic == "gear"
            and "!equip <weapon>, !unequip, !reload, !afk on/off."
            or "!aura, !bring, !fling; !goto, !back, !face, !follow [orbit/left/right/close/name].")
    elseif command == "afk" then
        local option = string.lower((argument or ""):match("^%s*(.-)%s*$"))
        if option == "on" or option == "off" then
            setPermanentAfk(option == "on", true)
            ExtraUI.standStatus("Permanent AFK " .. option .. ".")
        else
            ExtraUI.standStatus("Use !afk on or !afk off.")
        end
    elseif command == "stay" then
        S.standFollow = false
        S.standFollowGeneration = S.standFollowGeneration + 1
        ExtraUI.stopFloatingFollow()
        ExtraUI.standStatus("Holding position.")
    elseif command == "come" then
        ExtraUI.standStop()
        ExtraUI.standStatus(ExtraUI.standMoveToOwner()
            and "Moved to owner." or "Owner position unavailable.")
    elseif command == "follow" then
        local followTarget = nil
        local followMode = string.lower((argument or ""):match("^%s*(.-)%s*$"))
        if followMode ~= "" and followMode ~= "orbit"
            and followMode ~= "left" and followMode ~= "right"
            and followMode ~= "close" then
            local issue
            followTarget, issue = ExtraUI.standResolveTarget(sender, argument)
            if not followTarget then ExtraUI.standStatus(issue); return end
            followMode = "auto"
        elseif followMode == "" then
            followMode = "auto"
        end
        ExtraUI.standStop()
        S.standFollow = true
        S.standFollowGeneration = S.standFollowGeneration + 1
        local generation = S.standFollowGeneration
        ExtraUI.standStatus("Hover follow / " .. followMode .. " / "
            .. (followTarget and ("@" .. followTarget.Name) or "owner") .. ".")
        task.spawn(function()
            local started = os.clock()
            while not S.closed and S.standEnabled and S.standFollow
                and generation == S.standFollowGeneration do
                local targetRoot = followTarget
                    and ExtraUI.standTargetRoot(followTarget)
                    or ExtraUI.standOwnerRoot()
                local character = Me.Character
                local root = character and character:FindFirstChild("HumanoidRootPart")
                local hum = character and character:FindFirstChildOfClass("Humanoid")
                if targetRoot and root and hum and hum.Health > 0 then
                    if S.standFloatCharacter ~= character then
                        ExtraUI.stopFloatingFollow()
                        S.standFloatCharacter = character
                        S.standFloatAutoRotate = hum.AutoRotate
                        S.standFloatRootCollide = root.CanCollide
                        hum.AutoRotate = false
                        root.CanCollide = false
                        local animator = hum:FindFirstChildOfClass("Animator")
                        local storage = ReplicatedStorage:FindFirstChild("Storage")
                        local animations = storage and storage:FindFirstChild("Animations")
                        local emotes = animations and animations:FindFirstChild("Emotes")
                        local leaning = emotes and emotes:FindFirstChild("Leaning")
                        if animator and leaning and leaning:IsA("Animation") then
                            local ok, track = pcall(function()
                                return animator:LoadAnimation(leaning)
                            end)
                            if ok and track then
                                track.Priority = Enum.AnimationPriority.Action
                                track.Looped = true
                                track:Play(0.15)
                                S.standFloatTrack = track
                            end
                        end
                    end
                    local velocity = targetRoot.AssemblyLinearVelocity
                    local moving = Vector3.new(velocity.X, 0, velocity.Z).Magnitude > 2.5
                    local forward = targetRoot.CFrame.LookVector
                    local right = targetRoot.CFrame.RightVector
                    local t = os.clock() - started
                    local bob = math.sin(t * 3.2) * 0.35
                    local behind
                    if followMode == "orbit" or followMode == "auto" and not moving then
                        local theta = t * 0.9 - math.pi / 2
                        behind = targetRoot.Position + right * math.cos(theta) * 5.5
                            + forward * math.sin(theta) * 5.5
                            + Vector3.new(0, 3.6 + bob, 0)
                    else
                        local side = followMode == "left" and -3.5
                            or followMode == "right" and 3.5 or 0
                        local gap = followMode == "close" and 2.5 or 5.5
                        behind = targetRoot.Position - forward * gap
                            + right * side + Vector3.new(0, 3.3 + bob, 0)
                    end
                    local facing = moving and behind + forward
                        or targetRoot.Position + Vector3.new(0, 2, 0)
                    local desired = CFrame.lookAt(behind, facing)
                    pcall(function()
                        local gap = (root.Position - behind).Magnitude
                        character:PivotTo(gap > 45 and desired
                            or character:GetPivot():Lerp(desired, 0.33))
                        root.AssemblyLinearVelocity = Vector3.zero
                        root.AssemblyAngularVelocity = Vector3.zero
                    end)
                end
                task.wait(0.04)
            end
            if generation == S.standFollowGeneration then
                ExtraUI.stopFloatingFollow()
            end
        end)
    elseif command == "goto" or command == "face" then
        local target, issue = ExtraUI.standResolveTarget(sender, argument)
        if not target then ExtraUI.standStatus(issue); return end
        local targetRoot = ExtraUI.standTargetRoot(target)
        local character = Me.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if not targetRoot or not root then
            ExtraUI.standStatus("Character or target position unavailable.")
            return
        end
        if command == "face" then
            local toward = Vector3.new(targetRoot.Position.X,
                root.Position.Y, targetRoot.Position.Z)
            if (toward - root.Position).Magnitude < 0.2 then return end
            pcall(function() root.CFrame = CFrame.lookAt(root.Position, toward) end)
            ExtraUI.standStatus("Facing @" .. target.Name .. ".")
        else
            ExtraUI.standStop()
            local landing, reason = ExtraUI.safeBringLanding(targetRoot.CFrame, character)
            if not landing then
                ExtraUI.standStatus("Goto cancelled: " .. tostring(reason))
                return
            end
            S.standReturnCFrame = character:GetPivot()
            pcall(function()
                character:PivotTo(landing)
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
            end)
            ExtraUI.standStatus("Moved near @" .. target.Name .. ".")
        end
    elseif command == "back" then
        local character = Me.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if not root or not S.standReturnCFrame then
            ExtraUI.standStatus("No saved Stand position.")
            return
        end
        ExtraUI.standStop()
        local landing, reason = ExtraUI.safeBringLanding(S.standReturnCFrame, character)
        if not landing then
            ExtraUI.standStatus("Back cancelled: " .. tostring(reason))
            return
        end
        local previous = character:GetPivot()
        pcall(function()
            character:PivotTo(landing)
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end)
        S.standReturnCFrame = previous
        ExtraUI.standStatus("Returned to saved position.")
    elseif command == "hold" then
        ExtraUI.standStop()
        local character = Me.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if not root then ExtraUI.standStatus("Character unavailable."); return end
        local wasAnchored = root.Anchored
        S.standHoldRestore = function()
            if root.Parent then root.Anchored = wasAnchored end
        end
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
        root.Anchored = true
        ExtraUI.standStatus("Holding position; !release or !stop to move.")
    elseif command == "release" then
        ExtraUI.standReleaseHold()
        S.standSavedOrder = nil
        Env.SpectraStandSavedOrder = nil
        ExtraUI.standStatus("Position released.")
    elseif command == "equip" then
        local query = string.lower((argument or ""):match("^%s*(.-)%s*$"))
        local aliases = {rev = "[Revolver]", revolver = "[Revolver]",
            db = "[Double-Barrel SG]", shotgun = "[Shotgun]",
            tac = "[TacticalShotgun]", smg = "[SMG]", knife = "[Knife]"}
        local wanted = aliases[query] or argument
        local bag = Me:FindFirstChildOfClass("Backpack")
        local character = Me.Character
        local hum = character and character:FindFirstChildOfClass("Humanoid")
        local tool = bag and bag:FindFirstChild(wanted)
        if not tool and bag and query ~= "" then
            for _, candidate in ipairs(bag:GetChildren()) do
                if candidate:IsA("Tool") and candidate.Name:lower():find(query, 1, true) then
                    tool = candidate
                    break
                end
            end
        end
        if not hum or not tool then
            ExtraUI.standStatus("Weapon not found in backpack.")
            return
        end
        ExtraUI.standStop()
        hum:EquipTool(tool)
        ExtraUI.standStatus("Equipped " .. tool.Name .. ".")
    elseif command == "unequip" then
        ExtraUI.standStop()
        local character = Me.Character
        local hum = character and character:FindFirstChildOfClass("Humanoid")
        if hum then hum:UnequipTools() end
        ExtraUI.standStatus("Tools unequipped.")
    elseif command == "reload" then
        local character = Me.Character
        local tool = character and character:FindFirstChildOfClass("Tool")
        local storage = ReplicatedStorage:FindFirstChild("Storage")
        local remotes = storage and storage:FindFirstChild("Remotes")
        local main = remotes and remotes:FindFirstChild("Main")
        if not tool or not main then
            ExtraUI.standStatus("Equip a gun before reloading.")
            return
        end
        pcall(function() main:FireServer("Reload", tool) end)
        ExtraUI.standStatus("Reload requested for " .. tool.Name .. ".")
    elseif command == "fling" or command == "spin" then
        local target = nil
        if command == "fling" and argument ~= "" then
            local issue
            target, issue = ExtraUI.standResolveTarget(sender, argument)
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
            local ok, err = pcall(startAutoKill, latestOwnerRoot.CFrame, S.standOwner)
            ExtraUI.standStatus(ok and S.autoKill
                and ("Bringing @" .. target.Name .. " to owner.")
                or ("Bring could not start: " .. tostring(err)))
        end)
    elseif command == "attack" or command == "attack2" or command == "attack3"
        or command == "attack4" or command == "attack5"
        or command == "snipe" or command == "down"
        or command == "driveby" or command == "ambush" then
        local target, issue = ExtraUI.standResolveTarget(sender, argument)
        if not target then
            ExtraUI.standStatus(issue)
            ExtraUI.standReportIssue(command, argument, "TARGET NOT FOUND",
                "player missing, left, or name ambiguous")
            return
        end
        local ownerDownOnly = command == "down"
        local bag = Me:FindFirstChildOfClass("Backpack")
        local character = Me.Character
        local revolver = (character and character:FindFirstChild("[Revolver]"))
            or (bag and bag:FindFirstChild("[Revolver]"))
        if not revolver then
            local ownHum = character and character:FindFirstChildOfClass("Humanoid")
            if not ownHum or ownHum.Health <= 0 then
                ExtraUI.standRememberOrder(sender, command, argument)
                ExtraUI.standStatus("Attack queued until your character respawns with Revolver.")
                return
            end
            ExtraUI.standStatus("Revolver is not in your inventory.")
            ExtraUI.standReportIssue(command, target.Name, "FAILED", "no Revolver equipped or carried")
            return
        end
        ExtraUI.standStop()
        local generation = S.standOrderGeneration
        ExtraUI.standStatus("Resolving @" .. target.Name .. " for attack.")
        task.spawn(function()
            local deadline = os.clock() + 3
            local attackRecord = Hook.resolveShotRecord(target)
            while S.standEnabled and generation == S.standOrderGeneration
                and not recordUsable(target, attackRecord)
                and os.clock() < deadline do
                task.wait(0.1)
                attackRecord = Hook.resolveShotRecord(target)
            end
            if not S.standEnabled or generation ~= S.standOrderGeneration then return end
            if not recordUsable(target, attackRecord) then
                ExtraUI.standStatus("Target rig unavailable; attack cancelled.")
                ExtraUI.standReportIssue(command, target.Name,
                    target.Parent ~= Players and "TARGET LEFT" or "FAILED",
                    target.Parent ~= Players and "player left during lookup"
                        or "target character unavailable")
                return
            end
            if command == "down" then
                ExtraUI.standStatus("Down: saluting owner before taking position.")
                local played, completed = pcall(
                    ExtraUI.standDownIntro, target, generation)
                if not played or not completed then
                    if generation == S.standOrderGeneration then
                        ExtraUI.standStatus("Down intro cancelled; target unavailable.")
                        ExtraUI.standReportIssue(command, target.Name,
                            target.Parent ~= Players and "TARGET LEFT" or "FAILED",
                            "down intro could not complete")
                    end
                    return
                end
            elseif command == "attack2" then
                ExtraUI.standStatus("Attack2: running in on @" .. target.Name .. ".")
                local played, completed = pcall(
                    ExtraUI.standCinematicIntro, target, generation)
                if not played or not completed then
                    ExtraUI.standEndCinematic()
                    if generation == S.standOrderGeneration then
                        ExtraUI.standStatus("Cinematic cancelled; target unavailable.")
                        ExtraUI.standReportIssue(command, target.Name,
                            target.Parent ~= Players and "TARGET LEFT" or "FAILED",
                            "attack2 intro could not complete")
                    end
                    return
                end
            elseif command == "ambush" then
                ExtraUI.standStatus("Ambush: sneaking behind @" .. target.Name .. ".")
                local played, completed = pcall(
                    ExtraUI.standAmbushIntro, target, generation)
                if not played or not completed then
                    if generation == S.standOrderGeneration then
                        ExtraUI.standStatus("Ambush cancelled; target unavailable.")
                        ExtraUI.standReportIssue(command, target.Name,
                            target.Parent ~= Players and "TARGET LEFT" or "FAILED",
                            "ambush intro could not complete")
                    end
                    return
                end
            elseif command == "attack" or command == "attack3"
                or command == "attack4" or command == "attack5"
                or command == "driveby" then
                ExtraUI.standStatus("Setting the scene for @" .. target.Name .. ".")
                local played, completed = pcall(
                    ExtraUI.standStylizedIntro, target, command, generation)
                if not played or not completed then
                    if generation == S.standOrderGeneration then
                        ExtraUI.standStatus("Attack intro cancelled; target unavailable.")
                        ExtraUI.standReportIssue(command, target.Name,
                            target.Parent ~= Players and "TARGET LEFT" or "FAILED",
                            "attack intro could not complete")
                    end
                    return
                end
            end
            ExtraUI.standStatus(((command == "snipe" or command == "down")
                and "Taking a sniper position for @"
                or "Starting Auto Kill on @") .. target.Name .. ".")
            local started, startError = ExtraUI.startAttackOne(
                target, ownerDownOnly, command, true)
            if not started then
                ExtraUI.standStatus("Auto Kill error: " .. tostring(startError))
                return
            end
            if S.autoKill then
                ExtraUI.standStatus(ownerDownOnly
                    and ("Perch-to-perch takedown of @" .. target.Name .. "; no stomp.")
                    or command == "attack3"
                    and ("Sky attack on @" .. target.Name .. "; descend to stomp on down.")
                    or command == "attack4"
                    and ("Rear approach on @" .. target.Name .. "; finish on down.")
                    or command == "attack5"
                    and ("Figure-eight attack on @" .. target.Name .. ".")
                    or command == "snipe"
                    and ("Sniping @" .. target.Name .. " with rapid Revolver fire.")
                    or command == "driveby"
                    and ("Two fast passes across @" .. target.Name .. "; then finishing.")
                    or command == "ambush"
                    and ("Peekaboo ambush on @" .. target.Name .. "; closing to finish.")
                    or ("Shoulder-feint attack on @" .. target.Name .. "; stomp on down."))
            else
                stopAutoKill()
                ExtraUI.standStatus("Attack could not start; target unavailable.")
            end
        end)
    elseif command == "status" then
        ExtraUI.standStatus(S.autoKill and Hook.lockPlayer
            and "Attacking @" .. Hook.lockPlayer.Name
            or S.standCounterPending and "Counter queued for @" .. S.standCounterPending.Name
            or S.standCounterTarget and ("Counter guard active; bullet feed "
                .. (S.standCounterBulletHooked and "connected." or "unavailable."))
            or S.standFlinging and "Flinging."
            or S.standFollow and "Following target."
            or S.standHoldRestore and "Holding position."
            or ("Standing by. AFK " .. (S.afkPermanent and "ON" or "OFF") .. "."))
    end
    if command == "aura" or command == "protect" or command == "counter"
        or command == "follow" or command == "stay" or command == "hold"
        or command == "come" or command == "goto" or command == "face"
        or command == "back" or command == "equip" or command == "unequip"
        or command == "fling" or command == "spin" or command == "sit"
        or command == "bring" or command == "attack" or command == "attack2"
        or command == "attack3" or command == "attack4" or command == "attack5"
        or command == "snipe" or command == "down" or command == "driveby"
        or command == "ambush" then
        ExtraUI.standRememberOrder(sender, command, argument)
    end
end
ExtraUI.standResumeSaved = function(character, force)
    local saved = S.standSavedOrder
    if not saved or not S.standEnabled or not S.standOwner
        or saved.ownerUserId ~= S.standOwner.UserId then return end
    if not force then
        if saved.command == "counter" and S.standCounterTarget then return end
        if (saved.command == "aura" or saved.command == "protect") and S.aura then return end
        if saved.command == "follow" and S.standFollow then return end
    end
    S.standResumeGeneration = (S.standResumeGeneration or 0) + 1
    local resumeGeneration = S.standResumeGeneration
    task.spawn(function()
        local deadline = os.clock() + 18
        local ready = false
        while not S.closed and S.standEnabled and S.standSavedOrder == saved
            and resumeGeneration == S.standResumeGeneration
            and os.clock() < deadline do
            local current = Me.Character
            local hum = current and current:FindFirstChildOfClass("Humanoid")
            local root = current and current:FindFirstChild("HumanoidRootPart")
            local bag = Me:FindFirstChildOfClass("Backpack")
            local needsRevolver = saved.command == "counter"
                or saved.command == "attack" or saved.command == "attack2"
                or saved.command == "attack3" or saved.command == "attack4"
                or saved.command == "attack5" or saved.command == "snipe"
                or saved.command == "down" or saved.command == "driveby"
                or saved.command == "ambush"
            local revolver = current and current:FindFirstChild("[Revolver]")
                or bag and bag:FindFirstChild("[Revolver]")
            if current == character and hum and hum.Health > 0 and root
                and (not needsRevolver or revolver) then
                ready = true
                break
            end
            task.wait(0.15)
        end
        if not ready or S.closed or not S.standEnabled
            or S.standSavedOrder ~= saved
            or resumeGeneration ~= S.standResumeGeneration then return end
        task.wait(0.35)
        if S.autoKill then stopAutoKill("Resuming Stand order after respawn.") end
        if S.closed or S.standSavedOrder ~= saved
            or resumeGeneration ~= S.standResumeGeneration then return end
        local pendingUserId = Env.SpectraStandCounterPendingUserId
        S.standLastCommand = nil
        local ok, issue = pcall(ExtraUI.standHandleChat, S.standOwner,
            "!" .. saved.command .. (saved.argument ~= "" and " " .. saved.argument or ""))
        if saved.command == "counter" and pendingUserId
            and S.standCounterTarget then
            for _, player in ipairs(Players:GetPlayers()) do
                if player.UserId == pendingUserId then
                    S.standCounterPending = player
                    Env.SpectraStandCounterPendingUserId = pendingUserId
                    break
                end
            end
        end
        if not ok then ExtraUI.standStatus("Could not restore Stand order: " .. tostring(issue)) end
    end)
end
bind(Me.CharacterAdded:Connect(function(character)
    ExtraUI.standResumeSaved(character, false)
end))
bind(ExtraUI.StandSetOwner.MouseButton1Click:Connect(function()
    local owner, issue = ExtraUI.standResolvePlayer(ExtraUI.StandOwnerInput.Text, true)
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
    bind(chat.SendingMessage:Connect(function(message)
        if S.standOwner == Me and type(message.Text) == "string" then
            ExtraUI.standHandleChat(Me, message.Text)
        end
    end))
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

 
 
 
ExtraUI.antiLockRenderName = "RACER_AntiLockMovement"
ExtraUI.updateAntiLock = function()
    pcall(function() RunService:UnbindFromRenderStep(ExtraUI.antiLockRenderName) end)
    if not S.antiLock or S.closed then return end
    RunService:BindToRenderStep(ExtraUI.antiLockRenderName,
        Enum.RenderPriority.Input.Value + 2, function()
            if S.closed or not S.antiLock or S.autoKill or S.voidBlinking
                or S.standFollow or S.standFlinging or S.bring then return end
            local character = Me.Character
            local hum = character and character:FindFirstChildOfClass("Humanoid")
            if not hum or hum.Health <= 0 or hum.Sit then return end
            local move = hum.MoveDirection
            if move.Magnitude < 0.2 then return end
            local side = Vector3.new(-move.Z, 0, move.X)
            if side.Magnitude < 0.01 then return end
            local flip = math.floor(os.clock() * 5.2) % 2 == 0 and 1 or -1
            local adjusted = move.Unit + side.Unit * (flip * 0.36)
            hum:Move(adjusted.Unit, false)
        end)
end
bind(ExtraUI.AntiLockBtn.MouseButton1Click:Connect(function()
    S.antiLock = not S.antiLock
    style(ExtraUI.AntiLockBtn, S.antiLock,
        "ANTI-LOCK MOVEMENT: ON", "ANTI-LOCK MOVEMENT: OFF")
    ExtraUI.updateAntiLock()
    say(S.antiLock and "Anti-lock movement ON: strafes while walking; not lock immunity."
        or "Anti-lock movement disabled.")
end))

 
ExtraUI.configSlot = 1
ExtraUI.configKeys = {"quietAutoKill", "autoKillVoid", "antiVoid", "autoArmor",
    "antiStomp", "autoStomp", "stompAnimationEnabled", "stompPace", "knifeTravel",
    "resetThresholdIndex", "strafeRadius", "voidDepth", "uiScale",
    "respawnAtDeath", "adaptiveRapid", "noRecoil", "noSpread",
    "invisibleShot", "infiniteSmg", "autoReloadAll", "themeIndex",
    "fpsShare", "fpsBase", "fpsDrop",
    "bulletMode", "antiLock", "infiniteRange"}
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
    local profile = {version = 1, settings = {}, rapidWeapons = {},
        autoBuys = {}, esp = {}, notify = {}}
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
    for key, value in pairs(S.notify) do profile.notify[key] = value end
    if ExtraUI.Capabilities.fileWrite then
        local ok = pcall(function()
            writefile(ExtraUI.configPath(),
                game:GetService("HttpService"):JSONEncode(profile))
        end)
        if ok then
            ExtraUI.ConfigStatus.Text = "Saved slot " .. ExtraUI.configSlot .. "."
            return
        end
    end
    Env.RacerMemoryConfigs = Env.RacerMemoryConfigs or {}
    Env.RacerMemoryConfigs[ExtraUI.configSlot] = profile
    ExtraUI.ConfigStatus.Text = "Saved slot " .. ExtraUI.configSlot
        .. " for this session."
end))
bind(ExtraUI.ConfigLoad.MouseButton1Click:Connect(function()
    local ok, profile = false, nil
    if ExtraUI.Capabilities.fileRead then
        ok, profile = pcall(function()
            if not isfile(ExtraUI.configPath()) then return nil end
            return game:GetService("HttpService"):JSONDecode(readfile(ExtraUI.configPath()))
        end)
    end
    if not ok or profile == nil then
        profile = Env.RacerMemoryConfigs
            and Env.RacerMemoryConfigs[ExtraUI.configSlot] or nil
        ok = profile ~= nil
    end
    if not ok or profile == nil then
        ExtraUI.ConfigStatus.Text = "Slot " .. ExtraUI.configSlot .. " is empty."
        return
    end
    if not ok or type(profile) ~= "table" or profile.version ~= 1
        or type(profile.settings) ~= "table" then
        ExtraUI.ConfigStatus.Text = "This slot has invalid config data."
        return
    end
    if S.autoKill then stopAutoKill("Loading config.") end
    local settings = profile.settings
    local previouslyAntiStomp = S.antiStomp
    for _, key in ipairs(ExtraUI.configKeys) do
        if type(settings[key]) == type(S[key]) then S[key] = settings[key] end
    end
    S.adaptiveRapid = false
    S.stompSuppressed = not S.autoStomp
    if ExtraUI.Capabilities.gunManager == false then
        S.infiniteRange, S.noSpread = false, false
        S.bulletMode = 1
    end
    S.stompPace = math.clamp(S.stompPace, 1e-282, 1)
    S.resetThresholdIndex = math.clamp(math.floor(S.resetThresholdIndex), 1, #ResetThresholds)
    S.themeIndex = math.clamp(math.floor(S.themeIndex), 1, #ThemeNames)
    S.bulletMode = math.clamp(math.floor(S.bulletMode), 1, #ExtraUI.BulletModeNames)
    S.bulletStep = 0
    S.strafeRadius = math.clamp(S.strafeRadius, 4, 14)
    S.voidDepth = math.clamp(S.voidDepth, -300, -60)
    S.uiScale = math.clamp(S.uiScale, 0.7, 1.2)
    S.fpsBase = math.clamp(math.floor(S.fpsBase), 1, 1000000000000)
    S.fpsDrop = math.clamp(math.floor(S.fpsDrop), 0, S.fpsBase - 1)
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
    if ExtraUI.Capabilities.shopPurchase and type(profile.autoBuys) == "table" then
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
    if type(profile.notify) == "table" then
        for key, value in pairs(S.notify) do
            if type(profile.notify[key]) == type(value) then
                S.notify[key] = profile.notify[key]
            end
        end
    end
    ExtraUI.Notify.refreshButtons()
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
    style(ExtraUI.AntiLockBtn, S.antiLock,
        "ANTI-LOCK MOVEMENT: ON", "ANTI-LOCK MOVEMENT: OFF")
    ExtraUI.updateAntiLock()
    if ExtraUI.Capabilities.shopPurchase then
        style(AutoArmor, S.autoArmor,
            "AUTO ARMOR ON RESPAWN: ON", "AUTO ARMOR ON RESPAWN: OFF")
    else
        S.autoArmor = false
        AutoArmor.Text = "AUTO ARMOR: UNAVAILABLE IN XENO"
    end
    style(AntiStompBtn, S.antiStomp, "ANTI STOMP: ON", "ANTI STOMP: OFF")
    if previouslyAntiStomp and not S.antiStomp then
        S.resetGeneration = S.resetGeneration + 1
        S.resetCharacter = nil
        S.resetInFlight = false
        S.antiStompReady = false
    elseif not previouslyAntiStomp and S.antiStomp then
        resetBeforeStomp(Me.Character, ownDangerReason(Me.Character))
    end
    style(AutoStompBtn, S.autoStomp, "AUTO STOMP: ON", "AUTO STOMP: OFF")
    style(ExtraUI.KnifeTravelBtn, S.knifeTravel,
        "KNIFE TRAVEL: ON", "KNIFE TRAVEL: OFF")
    style(ExtraUI.StompAnimationBtn, S.stompAnimationEnabled,
        "STOMP ANIMATION: ON", "STOMP ANIMATION: OFF")
    style(ExtraUI.RespawnDeathBtn, S.respawnAtDeath,
        "RESPAWN AT DEATH: ON", "RESPAWN AT DEATH: OFF")
    ExtraUI.syncFpsShare()
    ResetThresholdBtn.Text = "RESET AT: " .. ResetThresholds[S.resetThresholdIndex] .. " HP"
    local guns = ExtraUI.GunModButtons
    if ExtraUI.Capabilities.gunManager ~= false then
        style(ExtraUI.BulletModeBtn, S.bulletMode ~= 1,
            "BULLET DIRECTION: " .. ExtraUI.BulletModeNames[S.bulletMode],
            "BULLET DIRECTION: CURSOR")
    end
    if S.bulletMode ~= 1 then
        local ok, reason = installRaycastHook()
        if not ok then say(reason) end
    end
    style(guns.invisible, S.invisibleShot, "INVISIBLE SHOT: ON", "INVISIBLE SHOT: OFF")
    guns.adaptive.Text = "FIRE RATE: 0.01S"
    style(guns.recoil, S.noRecoil, "NO RECOIL: ON", "NO RECOIL: OFF")
    if ExtraUI.Capabilities.gunManager ~= false then
        style(guns.spread, S.noSpread, "DB NO SPREAD: ON", "DB NO SPREAD: OFF")
    end
    style(guns.smg, S.infiniteSmg, "SMG AUTO RELOAD: ON", "SMG AUTO RELOAD: OFF")
    style(guns.reload, S.autoReloadAll,
        "AUTO RELOAD ALL GUNS: ON", "AUTO RELOAD ALL GUNS: OFF")
    if ExtraUI.Capabilities.gunManager ~= false then
        style(ExtraUI.InfiniteRangeBtn, S.infiniteRange,
            "INFINITE RANGE: ON", "INFINITE RANGE: OFF")
    end
    if S.infiniteRange then
        local ok, reason = installRaycastHook()
        if not ok then say(reason) end
    end
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
    S.fpsShare = false
    ExtraUI.stopFpsShare()
    ExtraUI.stopAura()
    S.knifeTravel = false
    S.resetGeneration = S.resetGeneration + 1
    S.resetCharacter = nil
    S.resetInFlight = false
    for p in pairs(ExtraUI.Notify.watchers) do ExtraUI.Notify.detach(p) end
    S.jumpBypass = false
    S.jumpBypassGeneration = S.jumpBypassGeneration + 1
    disconnectJumpBypass()
    setChatSpy(false)
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
    ExtraUI.standReleaseHold()
    ExtraUI.stopFloatingFollow()
    S.standEnabled = false
    S.standFollow = false
    S.standFollowGeneration = S.standFollowGeneration + 1
    if S.standCounterBulletConnection then
        S.standCounterBulletConnection:Disconnect()
        S.standCounterBulletConnection = nil
    end
    if S.standOwnerChatConnection then
        S.standOwnerChatConnection:Disconnect()
        S.standOwnerChatConnection = nil
    end
    S.voidBlinking = false
    S.antiLock = false
    ExtraUI.updateAntiLock()
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
    S.silent, S.trigger, S.wallBang, S.bulletMode, S.infiniteRange =
        false, false, false, 1, false
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
if ExtraUI.Capabilities.shopPurchase then
    style(AutoArmor, S.autoArmor, "AUTO ARMOR ON RESPAWN: ON", "AUTO ARMOR ON RESPAWN: OFF")
else
    S.autoArmor = false
end
style(AntiStompBtn, S.antiStomp, "ANTI STOMP: ON", "ANTI STOMP: OFF")
style(AutoStompBtn, S.autoStomp, "AUTO STOMP: ON", "AUTO STOMP: OFF")
style(ExtraUI.AuraBtn, false, "AURA 75 STUDS: ON", "AURA 75 STUDS: OFF")
style(ExtraUI.KnifeTravelBtn, S.knifeTravel,
    "KNIFE TRAVEL: ON", "KNIFE TRAVEL: OFF")
style(ExtraUI.StompAnimationBtn, S.stompAnimationEnabled,
    "STOMP ANIMATION: ON", "STOMP ANIMATION: OFF")
if type(Env.SpectraStandOwnerUserId) == "number" then
    task.defer(function()
        if S.closed then return end
        for _, player in ipairs(Players:GetPlayers()) do
            if player.UserId == Env.SpectraStandOwnerUserId then
                local savedOrder = Env.SpectraStandSavedOrder
                local pendingUserId = Env.SpectraStandCounterPendingUserId
                ExtraUI.standSetOwner(player)
                S.standEnabled = Env.SpectraStandEnabled == true
                style(ExtraUI.StandToggle, S.standEnabled,
                    "LISTEN: ON", "LISTEN: OFF")
                if S.standEnabled then
                    ExtraUI.standStatus("Listening to @" .. player.Name .. ".")
                    if type(savedOrder) == "table"
                        and savedOrder.ownerUserId == player.UserId then
                        S.standSavedOrder = savedOrder
                        Env.SpectraStandSavedOrder = savedOrder
                        Env.SpectraStandCounterPendingUserId = pendingUserId
                        if Me.Character then
                            ExtraUI.standResumeSaved(Me.Character, true)
                        end
                    end
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
say("Ready  •  Visuals > Notifications for event controls. All modules loaded.")
if Me.Character and (S.autoArmor or next(S.autoBuys)) then
    task.spawn(buyAutoItems, Me.Character)
end

 
Main.Visible = false
ExtraUI.LoadOverlay = make("Frame", {Parent = Gui, Name = "RacerLoading",
    Size = UDim2.fromScale(1, 1), BackgroundColor3 = C_BG,
    BorderSizePixel = 0, ZIndex = 100})
ExtraUI.LoadCard = round(make("Frame", {Parent = ExtraUI.LoadOverlay,
    AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(420, 185), BackgroundColor3 = C_PANEL,
    BorderSizePixel = 0, ZIndex = 101}), 16)
make("UIStroke", {Parent = ExtraUI.LoadCard, Color = C_BORDER,
    Thickness = 1, Transparency = 0})
ExtraUI.LoadTitle = make("TextLabel", {Parent = ExtraUI.LoadCard,
    Position = UDim2.fromOffset(24, 25), Size = UDim2.fromOffset(342, 35),
    BackgroundTransparency = 1, Text = "NOSR  /  CONTROL CONSOLE",
    TextColor3 = C_TEXT, Font = Enum.Font.GothamBold, TextSize = 20,
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
    local destination = Main.Position
    Main.Position = UDim2.new(destination.X.Scale, destination.X.Offset,
        destination.Y.Scale, destination.Y.Offset + 16)
    Main.Visible = true
    tweenService:Create(Main,
        TweenInfo.new(0.31, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        {Position = destination}):Play()
    ExtraUI.LoadOverlay:Destroy()
end)
return cleanup
