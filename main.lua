local Players = game:GetService("\080\108\097\121\101\114\115")
local Workspace = game:GetService("\087\111\114\107\115\112\097\099\101")
local ReplicatedStorage = game:GetService("\082\101\112\108\105\099\097\116\101\100\083\116\111\114\097\103\101")
local UIS = game:GetService("\085\115\101\114\073\110\112\117\116\083\101\114\118\105\099\101")
local RunService = game:GetService("\082\117\110\083\101\114\118\105\099\101")
local Me = Players.LocalPlayer
if not Me then return end
local PlayerGui = Me:WaitForChild("\080\108\097\121\101\114\071\117\105", 10)
if not PlayerGui then return end

local Env = _G
if type(getgenv) == "\102\117\110\099\116\105\111\110" then
    local ok, result = pcall(getgenv)
    if ok and type(result) == "\116\097\098\108\101" then Env = result end
end
Env.RacerExecutorName = "\085\110\107\110\111\119\110"
if type(identifyexecutor) == "\102\117\110\099\116\105\111\110" then
    local ok, name = pcall(identifyexecutor)
    if ok and type(name) == "\115\116\114\105\110\103" then Env.RacerExecutorName = name end
end
if Env.RacerExecutorName == "\085\110\107\110\111\119\110" and type(getexecutorname) == "\102\117\110\099\116\105\111\110" then
    local ok, name = pcall(getexecutorname)
    if ok and type(name) == "\115\116\114\105\110\103" then Env.RacerExecutorName = name end
end
Env.RacerIsXeno = string.find(string.lower(Env.RacerExecutorName),
    "\120\101\110\111", 1, true) ~= nil

                                                                           
                                                                          
if not Env.RacerIsXeno and type(queue_on_teleport) == "\102\117\110\099\116\105\111\110" then
    pcall(function()
        queue_on_teleport([=[
            task.wait(2)
            local scriptFile = loadfile([[RACER_AutoCombat_Fixed.luau]])
            if scriptFile then scriptFile() end
        ]=])
    end)
end

                                                  
for _, name in ipairs({
    "\083\112\101\099\116\114\097\083\101\108\101\099\116\067\108\101\097\110\117\112", "\068\065\072\095\076\105\116\101\067\108\101\097\110\117\112", "\068\065\072\095\080\111\108\105\115\104\101\100\067\108\101\097\110\117\112",
    "\068\065\072\095\079\112\116\105\109\105\122\101\100\067\108\101\097\110\117\112", "\068\065\072\095\065\108\108\073\110\079\110\101\095\067\108\101\097\110\117\112", "\068\065\072\095\065\105\109\071\117\105\067\108\101\097\110\117\112"
}) do
    if type(Env[name]) == "\102\117\110\099\116\105\111\110" then pcall(Env[name]) end
end
for _, name in ipairs({
    "\068\065\072\095\065\108\108\073\110\079\110\101\072\111\111\107", "\068\065\072\095\082\097\121\099\097\115\116\065\105\109\072\111\111\107", "\068\065\072\095\079\112\116\105\109\105\122\101\100\072\111\111\107",
    "\068\065\072\095\076\111\119\067\111\115\116\072\111\111\107", "\095\095\068\065\072\095\076\073\084\069\095\082\065\089\067\065\083\084", "\095\095\083\080\069\067\084\082\065\095\083\069\076\069\067\084\095\082\065\089\067\065\083\084"
}) do
    local old = Env[name]
    if type(old) == "\116\097\098\108\101" then
        old.active = false
        old.enabled = false
        old.part = nil
        old.point = nil
        old.aimPoint = nil
        old.mouseCompat = false
    end
end
for _, name in ipairs({"\082\065\067\069\082\095\085\073", "\083\080\069\067\084\082\065\095\083\069\076\069\067\084\095\076\073\084\069", "\068\065\072\095\083\116\117\100\105\111\076\105\116\101", "\068\065\072\095\082\101\098\117\105\108\116\076\105\116\101", "\068\065\072\095\079\112\116\105\109\105\122\101\100\065\108\108\073\110\079\110\101", "\068\065\072\095\065\108\108\073\110\079\110\101", "\068\065\072\065\105\109\071\117\105"}) do
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
    macroLock = false,
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
    fileRead = type(readfile) == "\102\117\110\099\116\105\111\110" and type(isfile) == "\102\117\110\099\116\105\111\110",
    fileWrite = type(writefile) == "\102\117\110\099\116\105\111\110",
    clickDetector = type(fireclickdetector) == "\102\117\110\099\116\105\111\110",
    mouseClick = type(mouse1click) == "\102\117\110\099\116\105\111\110"
        or (type(mouse1press) == "\102\117\110\099\116\105\111\110" and type(mouse1release) == "\102\117\110\099\116\105\111\110"),
    connections = type(getconnections) == "\102\117\110\099\116\105\111\110"
        and type(debug) == "\116\097\098\108\101" and type(debug.getupvalues) == "\102\117\110\099\116\105\111\110",
}
                                                                         
                                                                         
                                                                           
ExtraUI.Capabilities.shopPurchase = not Env.RacerIsXeno
Env.RacerFeatureSupport = ExtraUI.Capabilities
ExtraUI.Capabilities.drawing = false
if type(Drawing) == "\116\097\098\108\101" and type(Drawing.new) == "\102\117\110\099\116\105\111\110" then
    local ok, probe = pcall(Drawing.new, "\076\105\110\101")
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
    "\091\067\104\105\099\107\101\110\093", "\091\067\111\111\107\105\101\093", "\091\068\111\110\117\116\093", "\091\072\097\109\098\117\114\103\101\114\093", "\091\076\101\109\111\110\097\100\101\093",
    "\091\077\097\116\099\104\097\093", "\091\080\105\122\122\097\093", "\091\080\111\112\099\111\114\110\093", "\091\083\077\071\093", "\091\083\104\111\116\103\117\110\093",
    "\091\083\117\114\103\101\111\110\032\077\097\115\107\093", "\091\084\097\099\111\093", "\091\084\097\099\116\105\099\097\108\083\104\111\116\103\117\110\093",
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

local C_BG = Color3.fromRGB(11, 15, 19)
local C_PANEL = Color3.fromRGB(20, 27, 32)
local C_OFF = Color3.fromRGB(31, 40, 46)
local C_ON = Color3.fromRGB(49, 75, 57)
local C_SELECTED = Color3.fromRGB(47, 59, 59)
local C_TEXT = Color3.fromRGB(240, 245, 236)
local C_FAINT = Color3.fromRGB(148, 163, 157)
local C_ACCENT = Color3.fromRGB(188, 235, 104)
local C_NAV = Color3.fromRGB(16, 22, 27)
local C_NAV_OFF = Color3.fromRGB(24, 32, 38)
local C_NAV_HOVER = Color3.fromRGB(39, 51, 55)
local C_NAV_SELECTED = Color3.fromRGB(46, 70, 53)
local C_BORDER = Color3.fromRGB(65, 81, 79)
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
                                                                           
    return obj
end
local function label(parent, title, y, height, color, size)
    return make("\084\101\120\116\076\097\098\101\108", {
        Parent = parent, Position = UDim2.fromOffset(11, y), Size = UDim2.new(1, -22, 0, height),
        BackgroundTransparency = 1, Text = title, TextColor3 = color or C_TEXT,
        TextSize = size or 12, Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
    })
end
local function button(parent, title, x, y, w, h)
    local result = round(make("\084\101\120\116\066\117\116\116\111\110", {
        Parent = parent, Position = UDim2.fromOffset(x, y), Size = UDim2.fromOffset(w, h),
        BackgroundColor3 = C_OFF, BorderSizePixel = 0, AutoButtonColor = false,
        Text = title, TextColor3 = C_TEXT, Font = Enum.Font.GothamBold, TextSize = 12,
    }), 0)
    make("\085\073\083\116\114\111\107\101", {Parent = result, Color = C_BORDER, Thickness = 1, Transparency = 0.3})
    bind(result.MouseEnter:Connect(function()
        if S.closed then return end
        game:GetService("\084\119\101\101\110\083\101\114\118\105\099\101"):Create(result,
            TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = result:GetAttribute("\083\112\101\099\116\114\097\084\097\098")
                and C_NAV_HOVER or result:GetAttribute("\083\112\101\099\116\114\097\072\101\097\100\101\114")
                and C_NAV_HOVER or C_SELECTED}):Play()
    end))
    bind(result.MouseLeave:Connect(function()
        if S.closed then return end
        game:GetService("\084\119\101\101\110\083\101\114\118\105\099\101"):Create(result,
            TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = result:GetAttribute("\083\112\101\099\116\114\097\084\097\098")
                and (result:GetAttribute("\083\112\101\099\116\114\097\079\110") and C_NAV_SELECTED or C_NAV_OFF)
                or result:GetAttribute("\083\112\101\099\116\114\097\072\101\097\100\101\114") and C_NAV_OFF
                or result:GetAttribute("\083\112\101\099\116\114\097\079\110") and C_ON or C_OFF}):Play()
    end))
    return result
end
local function style(btn, value, on, off)
    btn.Text = value and on or off
    btn:SetAttribute("\083\112\101\099\116\114\097\079\110", value)
    btn.BackgroundColor3 = value and C_ON or C_OFF
    local stroke = btn:FindFirstChildOfClass("\085\073\083\116\114\111\107\101")
    if stroke then stroke.Color = value and C_ACCENT or C_BORDER end
end

                                                               
local Gui = make("\083\099\114\101\101\110\071\117\105", {
    Name = "\082\065\067\069\082\095\085\073", Parent = PlayerGui, ResetOnSpawn = false,
    DisplayOrder = 2200, IgnoreGuiInset = true,
})
local Main = round(make("\070\114\097\109\101", {
    Parent = Gui, Position = UDim2.fromOffset(24, 80), Size = UDim2.fromOffset(520, 625),
    BackgroundColor3 = C_BG, BorderSizePixel = 0, Active = true,
}), 0)
make("\085\073\083\116\114\111\107\101", {Parent = Main, Color = C_BORDER,
    Thickness = 1, Transparency = 0})
local MainScale = make("\085\073\083\099\097\108\101", {Parent = Main, Scale = S.uiScale})
make("\070\114\097\109\101", {Parent = Main, Position = UDim2.fromOffset(0, 0),
    Size = UDim2.fromOffset(520, 72), BackgroundColor3 = C_NAV,
    BorderSizePixel = 0})
make("\070\114\097\109\101", {Parent = Main, Position = UDim2.fromOffset(0, 0),
    Size = UDim2.fromOffset(520, 3), BackgroundColor3 = C_ACCENT, BorderSizePixel = 0})
make("\070\114\097\109\101", {Parent = Main, Position = UDim2.fromOffset(0, 71),
    Size = UDim2.fromOffset(520, 1), BackgroundColor3 = C_BORDER, BorderSizePixel = 0})
ExtraUI.Brand = make("\070\114\097\109\101", {Parent = Main,
    Position = UDim2.fromOffset(16, 16), Size = UDim2.fromOffset(38, 38),
    BackgroundColor3 = C_ACCENT, BorderSizePixel = 0})
make("\084\101\120\116\076\097\098\101\108", {Parent = ExtraUI.Brand, Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1, Text = "\078", TextColor3 = C_BG,
    Font = Enum.Font.GothamBlack, TextSize = 24})
local Heading = label(Main, "\078\111\115\114\032\083\099\114\105\112\116", 10, 31, C_TEXT, 21)
Heading.Font = Enum.Font.GothamBold
Heading.Position = UDim2.fromOffset(65, 12)
Heading.Size = UDim2.fromOffset(245, 29)
local Subtitle = label(Main, "\067\079\078\084\082\079\076\032\068\069\067\075\032\032\047\032\032\082\069\065\076\032\084\073\077\069", 41, 16,
    C_FAINT, 10)
Subtitle.Position = UDim2.fromOffset(66, 40)
ExtraUI.LivePill = make("\070\114\097\109\101", {Parent = Main,
    Position = UDim2.fromOffset(342, 24), Size = UDim2.fromOffset(74, 22),
    BackgroundColor3 = C_OFF, BorderSizePixel = 0})
make("\085\073\083\116\114\111\107\101", {Parent = ExtraUI.LivePill, Color = C_BORDER, Thickness = 1, Transparency = 0.2})
make("\070\114\097\109\101", {Parent = ExtraUI.LivePill, Position = UDim2.fromOffset(9, 8),
    Size = UDim2.fromOffset(6, 6), BackgroundColor3 = C_ACCENT,
    BorderSizePixel = 0})
local LiveLabel = label(ExtraUI.LivePill, "\076\073\086\069", 2, 18, C_TEXT, 10)
if Env.RacerIsXeno then LiveLabel.Text = "\088\069\078\079" end
LiveLabel.Position = UDim2.fromOffset(22, 2)
LiveLabel.Size = UDim2.fromOffset(46, 18)
LiveLabel.Font = Enum.Font.GothamBold
local Minimise = button(Main, "\045", 435, 21, 29, 27)
local Close = button(Main, "\088", 474, 21, 29, 27)
for _, control in ipairs({Minimise, Close}) do
    control:SetAttribute("\083\112\101\099\116\114\097\072\101\097\100\101\114", true)
    control.BackgroundColor3 = C_NAV_OFF
    control.TextColor3 = C_TEXT
    control:FindFirstChildOfClass("\085\073\083\116\114\111\107\101").Transparency = 1
end
local Search = round(make("\084\101\120\116\066\111\120", {
    Parent = Main, Position = UDim2.fromOffset(11, 50), Size = UDim2.fromOffset(318, 34),
    Text = "", PlaceholderText = "\032\032\083\101\097\114\099\104\032\112\108\097\121\101\114\032\110\097\109\101\046\046\046", ClearTextOnFocus = false,
    BackgroundColor3 = C_OFF, BorderSizePixel = 0, TextColor3 = C_TEXT,
    PlaceholderColor3 = C_FAINT, TextSize = 12, Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left,
}), 7)
local List = round(make("\083\099\114\111\108\108\105\110\103\070\114\097\109\101", {
    Parent = Main, Position = UDim2.fromOffset(11, 92), Size = UDim2.fromOffset(318, 136),
    BackgroundColor3 = C_PANEL, BorderSizePixel = 0, ScrollBarThickness = 3,
    CanvasSize = UDim2.fromOffset(0, 0), ScrollingDirection = Enum.ScrollingDirection.Y,
}), 7)
make("\085\073\080\097\100\100\105\110\103", {Parent = List, PaddingTop = UDim.new(0, 4), PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 5)})
local Layout = make("\085\073\076\105\115\116\076\097\121\111\117\116", {
    Parent = List, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 3),
})
bind(Layout:GetPropertyChangedSignal("\065\098\115\111\108\117\116\101\067\111\110\116\101\110\116\083\105\122\101"):Connect(function()
    List.CanvasSize = UDim2.fromOffset(0, Layout.AbsoluteContentSize.Y + 8)
end))
local SelectedLabel = label(Main, "\084\097\114\103\101\116\115\058\032\048\032\115\101\108\101\099\116\101\100", 231, 20, C_ACCENT, 11)
local ActiveLabel = label(Main, "\065\105\109\032\116\097\114\103\101\116\058\032\110\111\110\101", 250, 20, C_FAINT, 11)
local MultiBtn = button(Main, "\077\085\076\084\073\032\084\065\082\071\069\084\058\032\079\070\070", 11, 274, 153, 34)
local AliveBtn = button(Main, "\065\076\073\086\069\032\067\072\069\067\075\058\032\079\078", 175, 274, 154, 34)
local Silent = button(Main, "\083\073\076\069\078\084\032\065\073\077\058\032\079\070\070", 11, 315, 153, 34)
local Trigger = button(Main, "\084\082\073\071\071\069\082\058\032\079\070\070", 175, 315, 154, 34)
local CameraBtn = button(Main, "\067\065\077\069\082\065\032\065\073\077\058\032\079\070\070", 11, 355, 153, 34)
local DotBtn = button(Main, "\066\079\088\032\043\032\076\073\078\069\058\032\079\070\070", 175, 355, 154, 34)
local Hitbox = button(Main, "\072\073\084\066\079\088\058\032\066\079\068\089", 11, 395, 153, 34)
local Wall = button(Main, "\087\065\076\076\032\067\072\069\067\075\058\032\079\070\070", 175, 395, 154, 34)
local LeadText = label(Main, "\080\082\069\068\073\067\084\073\079\078\058\032\048\032\109\115", 478, 22, C_FAINT, 11)
local Minus = button(Main, "\045", 256, 475, 33, 28)
local Plus = button(Main, "\043", 296, 475, 33, 28)
local Refresh = button(Main, "\082\069\070\082\069\083\072\032\084\065\082\071\069\084\083", 11, 515, 153, 33)
local Bring = button(Main, "\066\082\073\078\071\032\083\069\076\069\067\084\069\068", 175, 515, 154, 33)
local AutoArmor = button(Main, "\065\085\084\079\032\065\082\077\079\082\032\079\078\032\082\069\083\080\065\087\078\058\032\079\070\070", 11, 555, 318, 33)
local Status = label(Main, "\073\100\108\101\058\032\110\111\032\116\097\114\103\101\116\105\110\103\032\108\111\111\112\032\097\099\116\105\118\101\046", 564, 44, C_FAINT, 11)
Status.TextWrapped = true
Status.TextTruncate = Enum.TextTruncate.None
Status.TextYAlignment = Enum.TextYAlignment.Top

local Sidebar = round(make("\070\114\097\109\101", {Parent = Main,
    Position = UDim2.fromOffset(10, 82), Size = UDim2.fromOffset(112, 460),
    BackgroundColor3 = C_NAV, BorderSizePixel = 0}), 13)
make("\085\073\083\116\114\111\107\101", {Parent = Sidebar, Color = C_BORDER,
    Thickness = 1, Transparency = 0.2})
local ModulesLabel = label(Sidebar, "\087\079\082\075\083\080\065\067\069", 17, 20,
    C_ACCENT, 10)
ModulesLabel.Position = UDim2.fromOffset(13, 17)
local TargetTab = button(Sidebar, "\032\032\032\084\065\082\071\069\084\083", 7, 52, 98, 43)
local AimTab = button(Sidebar, "\032\032\032\067\079\077\066\065\084", 7, 102, 98, 43)
local ToolsTab = button(Sidebar, "\032\032\032\071\065\077\069\080\076\065\089", 7, 152, 98, 43)
ExtraUI.EspTab = button(Sidebar, "\032\032\032\086\073\083\085\065\076\083", 7, 202, 98, 43)
local SettingsTab = button(Sidebar, "\032\032\032\079\080\084\073\079\078\083", 7, 252, 98, 43)
ExtraUI.SidebarHint = label(Sidebar, "SCROLL PANELS\nFOR MORE", 332, 52, C_FAINT, 10)
ExtraUI.SidebarHint.TextWrapped = true
ExtraUI.SidebarHint.TextYAlignment = Enum.TextYAlignment.Top
ExtraUI.TabIndicators = {}
for _, tab in ipairs({TargetTab, AimTab, ToolsTab, ExtraUI.EspTab, SettingsTab}) do
    tab.TextXAlignment = Enum.TextXAlignment.Left
    tab.TextColor3 = C_TEXT
    tab.BackgroundColor3 = C_NAV_OFF
    tab:FindFirstChildOfClass("\085\073\083\116\114\111\107\101").Transparency = 1
    ExtraUI.TabIndicators[tab] = make("\070\114\097\109\101", {Parent = tab,
        Position = UDim2.fromOffset(0, 8), Size = UDim2.fromOffset(3, 27),
        BackgroundColor3 = C_ACCENT, BorderSizePixel = 0, Visible = false})
end
make("\070\114\097\109\101", {Parent = Sidebar, Position = UDim2.fromOffset(12, 423),
    Size = UDim2.fromOffset(88, 1), BackgroundColor3 = C_BORDER, BorderSizePixel = 0})
ExtraUI.BuildLabel = label(Sidebar, "\078\079\083\082\032\083\067\082\073\080\084\032\032\047\032\032\082\069\065\076", 429, 18, C_FAINT, 9)
ExtraUI.BuildLabel.Position = UDim2.fromOffset(13, 429)
local StatusBar = round(make("\070\114\097\109\101", {Parent = Main,
    Position = UDim2.fromOffset(132, 552), Size = UDim2.fromOffset(376, 54),
    BackgroundColor3 = C_NAV, BorderSizePixel = 0}), 12)
make("\085\073\083\116\114\111\107\101", {Parent = StatusBar, Color = C_NAV_HOVER,
    Thickness = 1, Transparency = 0.35})
round(make("\070\114\097\109\101", {Parent = StatusBar, Position = UDim2.fromOffset(13, 20),
    Size = UDim2.fromOffset(8, 8), BackgroundColor3 = C_ACCENT,
    BorderSizePixel = 0}), 4)
Status.Parent = StatusBar
Status.Position = UDim2.fromOffset(30, 8)
Status.Size = UDim2.fromOffset(333, 41)
Status.TextColor3 = C_TEXT
local function page()
    local frame = round(make("\070\114\097\109\101", {
        Parent = Main, Position = UDim2.fromOffset(132, 82),
        Size = UDim2.fromOffset(376, 460), BackgroundColor3 = C_PANEL,
        BorderSizePixel = 0, Visible = false,
    }), 14)
    make("\085\073\083\116\114\111\107\101", {Parent = frame, Color = C_BORDER, Thickness = 1, Transparency = 0.08})
    make("\070\114\097\109\101", {Parent = frame, Position = UDim2.fromOffset(0, 0),
        Size = UDim2.fromOffset(376, 2), BackgroundColor3 = C_ACCENT,
        BorderSizePixel = 0})
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
local CursorToggle = button(TargetsPage, "\067\085\082\083\079\082\032\080\073\067\075\058\032\079\078", 12, 350, 166, 34)
local CursorPick = button(TargetsPage, "\080\073\067\075\032\078\069\065\082\032\067\085\082\083\079\082", 188, 350, 166, 34)
label(TargetsPage, "\081\032\115\101\108\101\099\116\115\032\111\114\032\114\101\109\111\118\101\115\032\097\032\112\108\097\121\101\114\032\119\105\116\104\105\110\032\049\048\048\112\120\046", 428, 18, C_FAINT, 11)
place(Refresh, TargetsPage, 12, 393, 166, 34)
ExtraUI.SelectAllBtn = button(TargetsPage, "\083\069\076\069\067\084\032\065\076\076", 188, 393, 166, 34)

place(Silent, AimPage, 12, 21, 166, 36)
place(Trigger, AimPage, 188, 21, 166, 36)
place(CameraBtn, AimPage, 12, 67, 166, 36)
place(DotBtn, AimPage, 188, 67, 166, 36)
place(Hitbox, AimPage, 12, 113, 166, 36)
place(Wall, AimPage, 188, 113, 166, 36)
label(AimPage, "\073\110\102\105\110\105\116\101\032\097\105\109\032\114\097\110\103\101\032\032\047\032\032\084\114\105\103\103\101\114\032\102\105\114\101\115\032\119\104\105\108\101\032\111\118\101\114\032\097\032\116\097\114\103\101\116\046",
    168, 20, C_FAINT, 11)
place(LeadText, AimPage, 13, 212, 225, 24)
place(Minus, AimPage, 276, 209, 35, 29)
place(Plus, AimPage, 319, 209, 35, 29)
local WallBangBtn = button(AimPage, "\065\076\076\045\071\085\078\032\087\065\076\076\066\065\078\071\058\032\079\070\070", 12, 247, 342, 36)
ExtraUI.WallBangInfo = label(AimPage, "\087\065\076\076\066\065\078\071\058\032\079\070\070", 289, 342, C_FAINT, 10)
local AutoKillBtn = button(AimPage, "\065\085\084\079\032\075\073\076\076\032\083\069\076\069\067\084\069\068\058\032\079\070\070", 12, 319, 342, 38)
ExtraUI.QuietKillBtn = button(AimPage, "\081\085\073\069\084\032\065\085\084\079\032\075\073\076\076\058\032\079\070\070", 12, 363, 342, 30)
local ForceHitBtn = button(AimPage, "\070\079\082\067\069\032\072\073\084\058\032\079\070\070", 12, 398, 166, 36)
ExtraUI.InfiniteRangeBtn = button(AimPage, "\073\078\070\073\078\073\084\069\032\082\065\078\071\069\058\032\079\070\070", 188, 398, 166, 36)

place(AutoArmor, ToolsPage, 12, 18, 342, 38)
place(Bring, ToolsPage, 12, 64, 342, 36)
local AntiStompBtn = button(ToolsPage, "\065\078\084\073\032\083\084\079\077\080\058\032\079\070\070", 12, 108, 342, 36)
local ResetThresholdBtn = button(ToolsPage, "\082\069\083\069\084\032\065\084\058\032\053\048\032\072\080", 12, 152, 342, 32)
local AutoStompBtn = button(ToolsPage, "\065\085\084\079\032\083\084\079\077\080\058\032\079\070\070", 12, 192, 166, 36)
local SelectedStompBtn = button(ToolsPage, "\083\069\076\069\067\084\069\068\032\083\084\079\077\080\058\032\079\070\070", 188, 192, 166, 36)
ExtraUI.StompAnimationBtn = button(ToolsPage, "\083\084\079\077\080\032\065\078\073\077\065\084\073\079\078\058\032\079\078", 12, 236, 342, 30)
label(ToolsPage, "\065\085\084\079\032\066\085\089\032\079\078\032\082\069\083\080\065\087\078", 280, 22, C_ACCENT, 12)
local AutoBuyPrev = button(ToolsPage, "\060", 12, 302, 38, 30)
local AutoBuyName = label(ToolsPage, "", 302, 30, C_TEXT, 12)
place(AutoBuyName, ToolsPage, 57, 302, 252, 30)
AutoBuyName.TextXAlignment = Enum.TextXAlignment.Center
local AutoBuyNext = button(ToolsPage, "\062", 316, 302, 38, 30)
local AutoBuyToggle = button(ToolsPage, "\065\085\084\079\032\066\085\089\058\032\079\070\070", 12, 340, 342, 30)
local AutoBuyNow = button(ToolsPage, "\066\085\089\032\083\069\076\069\067\084\069\068\032\078\079\087", 12, 378, 342, 30)
local AutoBuyCount = label(ToolsPage, "\048\032\105\116\101\109\115\032\115\101\108\101\099\116\101\100\046\032\083\104\111\112\115\032\117\115\101\032\067\108\105\099\107\068\101\116\101\099\116\111\114\115\046", 414, 36, C_FAINT, 10)
if not ExtraUI.Capabilities.shopPurchase then
    AutoArmor.Text = "\065\085\084\079\032\065\082\077\079\082\058\032\085\078\065\086\065\073\076\065\066\076\069\032\073\078\032\088\069\078\079"
    AutoArmor.AutoButtonColor = false
    AutoArmor.BackgroundColor3 = C_OFF
    AutoBuyPrev.Visible = false
    AutoBuyName.Visible = false
    AutoBuyNext.Visible = false
    AutoBuyToggle.Visible = false
    AutoBuyNow.Visible = false
    AutoBuyCount.Text = "\083\072\079\080\032\065\085\084\079\077\065\084\073\079\078\032\085\078\065\086\065\073\076\065\066\076\069\032\073\078\032\088\069\078\079"
end

label(ExtraUI.GunsPage, "\082\065\080\073\068\032\070\073\082\069\032\032\047\032\032\080\069\082\032\087\069\065\080\079\078", 16, 22, C_ACCENT, 12)
label(ExtraUI.GunsPage, "\072\111\108\100\032\102\105\114\101\046\032\083\104\111\116\103\117\110\032\100\097\109\097\103\101\032\099\097\100\101\110\099\101\032\105\115\032\115\101\114\118\101\114\032\099\111\110\116\114\111\108\108\101\100\046",
    43, 22, C_FAINT, 10)
ExtraUI.ServerHit = label(ExtraUI.GunsPage, "\083\069\082\086\069\082\032\072\073\084\058\032\119\097\105\116\105\110\103\032\102\111\114\032\097\032\115\104\111\116", 57, 18, C_FAINT, 10)
ExtraUI.BulletModeNames = {"\067\085\082\083\079\082", "\051\054\048\032\083\080\073\078", "\051\054\048\032\082\065\078\068\079\077"}
ExtraUI.BulletModeBtn = button(ExtraUI.GunsPage, "\066\085\076\076\069\084\032\068\073\082\069\067\084\073\079\078\058\032\067\085\082\083\079\082", 12, 83, 342, 36)
label(ExtraUI.GunsPage, "\051\054\048\032\115\104\111\116\115\032\114\111\116\097\116\101\032\105\110\100\101\112\101\110\100\101\110\116\108\121\032\111\102\032\121\111\117\114\032\099\117\114\115\111\114\046",
    125, 21, C_FAINT, 10)
ExtraUI.GunList = round(make("\083\099\114\111\108\108\105\110\103\070\114\097\109\101", {
    Parent = ExtraUI.GunsPage, Position = UDim2.fromOffset(12, 154),
    Size = UDim2.fromOffset(342, 271), BackgroundColor3 = C_BG,
    BorderSizePixel = 0, ScrollBarThickness = 7,
    ScrollBarImageColor3 = C_ACCENT, ScrollingEnabled = true,
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    CanvasSize = UDim2.fromOffset(0, 0),
    ScrollingDirection = Enum.ScrollingDirection.Y,
}), 8)
ExtraUI.GunList.ScrollingDirection = Enum.ScrollingDirection.Y
ExtraUI.GunLayout = make("\085\073\076\105\115\116\076\097\121\111\117\116", {
    Parent = ExtraUI.GunList, SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 6),
})
make("\085\073\080\097\100\100\105\110\103", {Parent = ExtraUI.GunList,
    PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 10),
    PaddingLeft = UDim.new(0, 3), PaddingRight = UDim.new(0, 8)})
label(ExtraUI.EspPage, "\080\076\065\089\069\082\032\079\086\069\082\076\065\089\032\032\047\032\032\065\076\076\032\080\076\065\089\069\082\083", 16, 22, C_ACCENT, 12)
label(ExtraUI.EspPage, "\083\099\114\101\101\110\032\111\118\101\114\108\097\121\032\119\105\116\104\032\111\112\116\105\111\110\097\108\032\082\049\053\047\082\054\032\106\111\105\110\116\115\046", 43, 22, C_FAINT, 10)
ExtraUI.EspMain = button(ExtraUI.EspPage, "\069\083\080\058\032\079\070\070", 12, 76, 342, 38)
ExtraUI.EspBoxes = button(ExtraUI.EspPage, "\066\079\088\069\083\058\032\079\078", 12, 125, 166, 36)
ExtraUI.EspSkeleton = button(ExtraUI.EspPage, "\083\075\069\076\069\084\079\078\058\032\079\070\070", 188, 125, 166, 36)
ExtraUI.EspNames = button(ExtraUI.EspPage, "\078\065\077\069\083\058\032\079\078", 12, 171, 166, 36)
ExtraUI.EspDistance = button(ExtraUI.EspPage, "\068\073\083\084\065\078\067\069\058\032\079\078", 188, 171, 166, 36)
ExtraUI.EspRange = button(ExtraUI.EspPage, "\082\065\078\071\069\058\032\065\076\076", 12, 217, 342, 36)
ExtraUI.EspColor = button(ExtraUI.EspPage, "\067\079\076\079\082\058\032\067\089\065\078", 12, 263, 342, 36)
ExtraUI.AntiLockBtn = button(ExtraUI.EspPage, "\065\078\084\073\045\076\079\067\075\032\077\079\086\069\077\069\078\084\058\032\079\070\070", 12, 328, 342, 36)
label(ExtraUI.EspPage, "\086\097\114\105\101\115\032\121\111\117\114\032\109\111\118\105\110\103\032\112\097\116\104\032\116\111\032\104\105\110\100\101\114\032\112\114\101\100\105\099\116\105\111\110\046\032\067\097\110\110\111\116\032\115\116\111\112", 373, 20, C_FAINT, 10)
label(ExtraUI.EspPage, "\097\108\108\032\099\108\105\101\110\116\045\115\105\100\101\032\108\111\099\107\115\032\111\114\032\115\101\114\118\101\114\045\118\097\108\105\100\097\116\101\100\032\104\105\116\115\046", 391, 20, C_FAINT, 10)
label(ExtraUI.TeleportPage, "\076\079\067\065\084\073\079\078\032\084\069\076\069\080\079\082\084\083", 16, 22, C_ACCENT, 12)
label(ExtraUI.TeleportPage, "\067\104\111\111\115\101\032\097\032\109\097\112\112\101\100\032\097\114\101\097\032\111\114\032\097\032\108\105\118\101\032\115\104\111\112\046", 43, 22, C_FAINT, 10)
ExtraUI.TeleportButtons = {
    uphill = button(ExtraUI.TeleportPage, "\085\080\072\073\076\076", 12, 80, 166, 37),
    downhill = button(ExtraUI.TeleportPage, "\068\079\087\078\072\073\076\076", 188, 80, 166, 37),
    armor = button(ExtraUI.TeleportPage, "\078\069\065\082\069\083\084\032\065\082\077\079\082", 12, 128, 342, 37),
    smg = button(ExtraUI.TeleportPage, "\078\069\065\082\069\083\084\032\083\077\071\032\083\072\079\080", 12, 176, 342, 37),
    returnTo = button(ExtraUI.TeleportPage, "\082\069\084\085\082\078\032\084\079\032\080\082\069\086\073\079\085\083\032\080\079\083\073\084\073\079\078", 12, 224, 342, 37),
}
label(ExtraUI.StandPage, "\083\084\065\078\068\032\032\047\032\032\067\072\065\084\032\067\079\078\084\082\079\076", 16, 25, C_ACCENT, 12)
ExtraUI.StandOwnerLabel = label(ExtraUI.StandPage, "\079\119\110\101\114\058\032\110\111\110\101", 48, 30, C_TEXT, 12)
ExtraUI.StandOwnerInput = make("\084\101\120\116\066\111\120", {
    Parent = ExtraUI.StandPage, Position = UDim2.fromOffset(12, 86),
    Size = UDim2.fromOffset(342, 34), BackgroundColor3 = C_OFF,
    TextColor3 = C_TEXT, PlaceholderColor3 = C_FAINT,
    PlaceholderText = "\079\119\110\101\114\032\117\115\101\114\110\097\109\101\032\111\114\032\100\105\115\112\108\097\121\032\110\097\109\101", Text = "",
    ClearTextOnFocus = false, Font = Enum.Font.Gotham,
    TextSize = 12, BorderSizePixel = 0,
})
round(ExtraUI.StandOwnerInput, 7)
ExtraUI.StandSetOwner = button(ExtraUI.StandPage, "\083\069\084\032\079\087\078\069\082\032\070\082\079\077\032\078\065\077\069", 12, 130, 166, 34)
ExtraUI.StandSetSelected = button(ExtraUI.StandPage, "\085\083\069\032\083\069\076\069\067\084\069\068\032\080\076\065\089\069\082", 188, 130, 166, 34)
ExtraUI.StandToggle = button(ExtraUI.StandPage, "\076\073\083\084\069\078\058\032\079\070\070", 12, 175, 342, 38)
ExtraUI.StandStop = button(ExtraUI.StandPage, "\083\084\079\080\032\067\085\082\082\069\078\084\032\079\082\068\069\082", 12, 222, 342, 34)
label(ExtraUI.StandPage, "\079\087\078\069\082\032\067\072\065\084\032\067\079\077\077\065\078\068\083", 268, 25, C_ACCENT, 11)
label(ExtraUI.StandPage, "\033\097\116\116\097\099\107\032\049\045\053\032\047\032\033\115\110\105\112\101\032\047\032\033\100\111\119\110\032\047\032\033\115\116\111\112", 292, 24, C_TEXT, 11)
label(ExtraUI.StandPage, "\033\112\114\111\116\101\099\116\032\047\032\033\099\111\117\110\116\101\114\032\047\032\033\100\114\105\118\101\098\121\032\047\032\033\097\109\098\117\115\104", 318, 24, C_TEXT, 11)
ExtraUI.ChatSpyBtn = button(ExtraUI.StandPage, "\067\072\065\084\032\083\080\089\058\032\079\070\070", 12, 343, 166, 30)
ExtraUI.JumpBypassBtn = button(ExtraUI.StandPage, "\074\085\077\080\032\066\089\080\065\083\083\058\032\079\070\070", 188, 343, 166, 30)
ExtraUI.StandAfkBtn = button(ExtraUI.StandPage, "\080\069\082\077\065\078\069\078\084\032\065\070\075\058\032\079\070\070", 12, 381, 342, 30)
ExtraUI.StandStatus = label(ExtraUI.StandPage, "\083\116\097\110\100\105\110\103\032\098\121\046", 414, 30, C_FAINT, 11)
ExtraUI.StandStatus.TextWrapped = true
ExtraUI.StandStatus.TextTruncate = Enum.TextTruncate.None

                                                                                   
ExtraUI.Notify = {watchers = {}, knownModels = {}, lastRespawnAt = {}, log = {}}
label(ExtraUI.NotifyPage, "\078\079\084\073\070\073\067\065\084\073\079\078\083\032\032\047\032\032\083\069\076\069\067\084\069\068\032\084\065\082\071\069\084\083", 15, 23, C_ACCENT, 12)
label(ExtraUI.NotifyPage, "\084\114\097\099\107\115\032\115\101\108\101\099\116\101\100\032\112\108\097\121\101\114\115\032\111\110\108\121\059\032\110\111\032\099\111\110\116\105\110\117\111\117\115\032\115\099\097\110\115\046", 39, 20, C_FAINT, 10)
ExtraUI.NotifyMaster = button(ExtraUI.NotifyPage, "\078\079\084\073\070\073\067\065\084\073\079\078\083\058\032\079\078", 12, 65, 342, 34)
ExtraUI.NotifySettings = make("\083\099\114\111\108\108\105\110\103\070\114\097\109\101", {
    Parent = ExtraUI.NotifyPage, Position = UDim2.fromOffset(12, 109),
    Size = UDim2.fromOffset(342, 162), BackgroundColor3 = C_BG,
    BorderSizePixel = 0, ScrollBarThickness = 5,
    ScrollingDirection = Enum.ScrollingDirection.Y,
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    CanvasSize = UDim2.fromOffset(0, 0),
})
make("\085\073\076\105\115\116\076\097\121\111\117\116", {Parent = ExtraUI.NotifySettings,
    SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5)})
ExtraUI.NotifyOptions = {
    {"\100\111\119\110\101\100", "\084\065\082\071\069\084\032\068\079\087\078\069\068"}, {"\100\101\097\100", "\084\065\082\071\069\084\032\068\069\065\068"},
    {"\114\101\115\112\097\119\110\101\100", "\084\065\082\071\069\084\032\082\069\083\080\065\087\078\069\068"}, {"\108\111\119\072\101\097\108\116\104", "\084\065\082\071\069\084\032\076\079\087\032\072\080\032\040\051\048\041"},
    {"\111\119\110\082\101\115\112\097\119\110", "\077\089\032\082\069\083\080\065\087\078"}, {"\097\110\116\105\083\116\111\109\112", "\065\078\084\073\045\083\084\079\077\080\032\083\084\065\084\085\083"},
    {"\115\101\108\101\099\116\101\100", "\084\065\082\071\069\084\032\083\069\076\069\067\084\069\068"}, {"\112\111\112\117\112\115", "\079\078\045\083\067\082\069\069\078\032\080\079\080\085\080\083"},
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
        style(btn, S.notify[key], name .. "\058\032\079\078", name .. "\058\032\079\070\070")
    end))
end
label(ExtraUI.NotifyPage, "\082\069\067\069\078\084\032\069\086\069\078\084\083", 278, 22, C_ACCENT, 11)
ExtraUI.NotifyClear = button(ExtraUI.NotifyPage, "\067\076\069\065\082", 271, 278, 83, 25)
ExtraUI.NotifyHistory = make("\083\099\114\111\108\108\105\110\103\070\114\097\109\101", {
    Parent = ExtraUI.NotifyPage, Position = UDim2.fromOffset(12, 310),
    Size = UDim2.fromOffset(342, 124), BackgroundColor3 = C_BG,
    BorderSizePixel = 0, ScrollBarThickness = 5,
    ScrollingDirection = Enum.ScrollingDirection.Y,
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    CanvasSize = UDim2.fromOffset(0, 0),
})
make("\085\073\076\105\115\116\076\097\121\111\117\116", {Parent = ExtraUI.NotifyHistory,
    SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 3)})
ExtraUI.NotifyToastHost = make("\070\114\097\109\101", {
    Parent = Gui, Position = UDim2.new(1, -320, 0, 75),
    Size = UDim2.fromOffset(304, 230), BackgroundTransparency = 1,
    BorderSizePixel = 0, ZIndex = 40,
})
make("\085\073\076\105\115\116\076\097\121\111\117\116", {Parent = ExtraUI.NotifyToastHost,
    SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5)})
ExtraUI.Notify.refreshButtons = function()
    style(ExtraUI.NotifyMaster, S.notify.enabled,
        "\078\079\084\073\070\073\067\065\084\073\079\078\083\058\032\079\078", "\078\079\084\073\070\073\067\065\084\073\079\078\083\058\032\079\070\070")
    for _, item in ipairs(ExtraUI.NotifyOptions) do
        local key, name = item[1], item[2]
        style(ExtraUI.NotifyButtons[key], S.notify[key],
            name .. "\058\032\079\078", name .. "\058\032\079\070\070")
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
        if entry:IsA("\084\101\120\116\076\097\098\101\108") then entry:Destroy() end
    end
end))
ExtraUI.Notify.emit = function(key, message)
    if S.closed or not S.notify.enabled or not S.notify[key] then return end
    local stamp = os.date("\037\072\058\037\077\058\037\083")
    local line = ("\091\037\115\093\032\037\115"):format(stamp, message)
    table.insert(ExtraUI.Notify.log, 1, line)
    if #ExtraUI.Notify.log > 40 then table.remove(ExtraUI.Notify.log) end
    local entry = make("\084\101\120\116\076\097\098\101\108", {
        Parent = ExtraUI.NotifyHistory, Size = UDim2.new(1, -9, 0, 28),
        BackgroundColor3 = C_PANEL, BorderSizePixel = 0,
        Text = "\032\032" .. line, TextWrapped = true, TextColor3 = C_TEXT,
        Font = Enum.Font.Gotham, TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = -math.floor(os.clock() * 1000),
    })
    if #ExtraUI.NotifyHistory:GetChildren() > 44 then
        for _, child in ipairs(ExtraUI.NotifyHistory:GetChildren()) do
            if child:IsA("\084\101\120\116\076\097\098\101\108") and child ~= entry
                and child.LayoutOrder < math.huge then
                                                              
                local oldest = child
                for _, other in ipairs(ExtraUI.NotifyHistory:GetChildren()) do
                    if other:IsA("\084\101\120\116\076\097\098\101\108") and other.LayoutOrder > oldest.LayoutOrder then
                        oldest = other
                    end
                end
                oldest:Destroy()
                break
            end
        end
    end
    if not S.notify.popups then return end
    local toast = make("\084\101\120\116\076\097\098\101\108", {
        Parent = ExtraUI.NotifyToastHost, Size = UDim2.new(1, 0, 0, 47),
        BackgroundColor3 = C_NAV, BorderSizePixel = 0,
        Text = "\032\032\078\079\083\082\032\083\067\082\073\080\084\032\032\047\032\032" .. message, TextWrapped = true,
        TextColor3 = C_TEXT, Font = Enum.Font.GothamBold,
        TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 42,
    })
    make("\085\073\083\116\114\111\107\101", {Parent = toast, Color = C_ACCENT, Thickness = 1})
    task.delay(4, function() if toast.Parent then toast:Destroy() end end)
    for _, item in ipairs(ExtraUI.NotifyToastHost:GetChildren()) do
        if item:IsA("\084\101\120\116\076\097\098\101\108") and item ~= toast and
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
    local effects = rec.model:FindFirstChild("\066\111\100\121\069\102\102\101\099\116\115")
    local ko = effects and effects:FindFirstChild("\075\046\079")
    local dead = effects and effects:FindFirstChild("\068\101\097\100")
    local state = ((dead and dead:IsA("\066\111\111\108\086\097\108\117\101") and dead.Value)
            or hum.Health <= 0) and "\100\101\097\100"
        or (ko and ko:IsA("\066\111\111\108\086\097\108\117\101") and ko.Value) and "\100\111\119\110\101\100"
        or "\104\101\097\108\116\104\121"
    if w.state ~= nil and state ~= w.state then
        if state == "\100\111\119\110\101\100" then
            ExtraUI.Notify.emit("\100\111\119\110\101\100", "\064" .. p.Name .. "\032\119\097\115\032\100\111\119\110\101\100")
        elseif state == "\100\101\097\100" then
            ExtraUI.Notify.emit("\100\101\097\100", "\064" .. p.Name .. "\032\100\105\101\100")
        end
    end
    w.state = state
    local low = state == "\104\101\097\108\116\104\121" and hum.Health > 0 and hum.Health <= 30
    if w.low ~= nil and low and not w.low then
        ExtraUI.Notify.emit("\108\111\119\072\101\097\108\116\104", "\064" .. p.Name .. "\032\104\097\115\032"
            .. math.floor(hum.Health) .. "\032\072\080")
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
        ExtraUI.Notify.emit("\114\101\115\112\097\119\110\101\100", "\064" .. p.Name .. "\032\114\101\115\112\097\119\110\101\100")
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
        if w.flags[flag] or not flag:IsA("\066\111\111\108\086\097\108\117\101") then return end
        if flag.Name ~= "\075\046\079" and flag.Name ~= "\068\101\097\100" then return end
        w.flags[flag] = true
        add(flag:GetPropertyChangedSignal("\086\097\108\117\101"):Connect(function()
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
        if child.Name == "\066\111\100\121\069\102\102\101\099\116\115" then watchEffects(child) end
    end))
    watchEffects(rec.model:FindFirstChild("\066\111\100\121\069\102\102\101\099\116\115"))
    ExtraUI.Notify.check(p, w)
end

label(ExtraUI.ConfigPage, "\080\082\079\070\073\076\069\083\032\032\047\032\032\076\079\067\065\076\032\083\069\084\084\073\078\071\083", 20, 24, C_ACCENT, 12)
label(ExtraUI.ConfigPage, "\067\104\111\111\115\101\032\097\032\115\108\111\116\044\032\116\104\101\110\032\115\097\118\101\032\111\114\032\108\111\097\100\032\121\111\117\114\032\112\114\101\102\101\114\101\110\099\101\115\046",
    49, 22, C_FAINT, 10)
ExtraUI.ConfigSlots = {
    button(ExtraUI.ConfigPage, "\083\076\079\084\032\049", 12, 88, 106, 38),
    button(ExtraUI.ConfigPage, "\083\076\079\084\032\050", 130, 88, 106, 38),
    button(ExtraUI.ConfigPage, "\083\076\079\084\032\051", 248, 88, 106, 38),
}
ExtraUI.ConfigSave = button(ExtraUI.ConfigPage, "\083\065\086\069\032\083\069\076\069\067\084\069\068\032\083\076\079\084", 12, 145, 342, 42)
ExtraUI.ConfigLoad = button(ExtraUI.ConfigPage, "\076\079\065\068\032\083\069\076\069\067\084\069\068\032\083\076\079\084", 12, 198, 342, 42)
ExtraUI.ConfigStatus = label(ExtraUI.ConfigPage, "\083\108\111\116\032\049\032\115\101\108\101\099\116\101\100\046", 263, 48, C_FAINT, 11)
ExtraUI.ConfigStatus.TextWrapped = true
ExtraUI.MacroBtn = button(ExtraUI.ConfigPage, "\077\065\067\082\079\032\080\069\082\083\073\083\084\058\032\079\070\070", 12, 313, 342, 39)
label(ExtraUI.ConfigPage, "\075\101\101\112\032\116\104\101\032\103\097\109\101\039\115\032\109\097\099\114\111\032\097\099\116\105\118\101\032\116\104\114\111\117\103\104\032\110\111\114\109\097\108\032\097\099\116\105\111\110\115\046",
    365, 27, C_FAINT, 10)
label(ExtraUI.ConfigPage, "\069\088\069\067\085\084\079\082\058\032" .. string.upper(ExtraUI.ExecutorName)
    .. "\032\032\047\032\032\076\079\065\068\032\080\082\079\070\073\076\069\083\032\077\065\078\085\065\076\076\089",
    402, 24, C_FAINT, 10)

label(SettingsPage, "\077\079\086\069\077\069\078\084\032\038\032\080\069\082\083\079\078\065\076\073\083\065\084\073\079\078", 12, 20, C_ACCENT, 12)
local AntiVoidBtn = button(SettingsPage, "\065\078\084\073\032\086\079\073\068\058\032\079\078", 12, 39, 342, 34)
local VoidKillBtn = button(SettingsPage, "\065\085\084\079\032\075\073\076\076\032\086\079\073\068\032\066\076\073\078\075\058\032\079\078", 12, 81, 342, 34)

local function slider(parent, title, y, initial, convert, onChange, format)
    local caption = label(parent, title, y, 20, C_TEXT, 11)
    local track = round(make("\070\114\097\109\101", {Parent = parent, Active = true,
        Position = UDim2.fromOffset(12, y + 27), Size = UDim2.fromOffset(342, 9),
        BackgroundColor3 = C_OFF, BorderSizePixel = 0}), 5)
    local fill = round(make("\070\114\097\109\101", {Parent = track, Size = UDim2.fromScale(0, 1),
        BackgroundColor3 = C_ACCENT, BorderSizePixel = 0}), 5)
    local knob = round(make("\070\114\097\109\101", {Parent = track, Active = true,
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0, 0.5),
        Size = UDim2.fromOffset(16, 16), BackgroundColor3 = C_ACCENT,
        BorderSizePixel = 0}), 8)
    make("\085\073\083\116\114\111\107\101", {Parent = knob, Color = C_BG, Thickness = 2})
    local dragging = false
    local function setFraction(fraction)
        fraction = math.clamp(fraction, 0, 1)
        fill.Size = UDim2.fromScale(fraction, 1)
        knob.Position = UDim2.fromScale(fraction, 0.5)
        local value = convert(fraction)
        onChange(value)
        caption.Text = title .. "\032\032" .. format(value)
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

local setStompPace = slider(SettingsPage, "\065\085\084\079\032\083\084\079\077\080\032\080\065\067\069", 124,
    (math.log10(S.stompPace) + MinStompPaceExponent) / MinStompPaceExponent,
    function(f) return 10 ^ (-MinStompPaceExponent + MinStompPaceExponent * f) end,
    function(value) S.stompPace = value end,
    function(value) return string.format("\037\046\051\103\195\151", value) end)
local PaceMax = button(SettingsPage, "\077\065\088", 12, 174, 106, 28)
local PaceFast = button(SettingsPage, "\070\065\083\084", 130, 174, 106, 28)
local PaceNormal = button(SettingsPage, "\078\079\082\077\065\076", 248, 174, 106, 28)
bind(PaceMax.MouseButton1Click:Connect(function() setStompPace(0) end))
bind(PaceFast.MouseButton1Click:Connect(function()
    setStompPace((math.log10(0.05) + MinStompPaceExponent) / MinStompPaceExponent)
end))
bind(PaceNormal.MouseButton1Click:Connect(function() setStompPace(1) end))
label(SettingsPage, "\077\105\110\105\109\117\109\032\049\101\045\050\056\050\195\151\059\032\103\097\109\101\032\102\114\097\109\101\115\032\108\105\109\105\116\032\097\099\116\117\097\108\032\099\097\108\108\115\046", 206, 17, C_FAINT, 10)
ExtraUI.setStrafeRadius = slider(SettingsPage, "\083\084\082\065\070\069\032\082\065\068\073\085\083", 230, (S.strafeRadius - 4) / 10,
    function(f) return 4 + f * 10 end,
    function(value) S.strafeRadius = value end,
    function(value) return string.format("\037\046\049\102\032\115\116\117\100\115", value) end)
ExtraUI.setVoidDepth = slider(SettingsPage, "\086\079\073\068\032\068\069\080\084\072", 289, (-S.voidDepth - 60) / 240,
    function(f) return -(60 + f * 240) end,
    function(value) S.voidDepth = value end,
    function(value) return string.format("\037\046\048\102\032\089", value) end)
ExtraUI.setUiScale = slider(SettingsPage, "\073\078\084\069\082\070\065\067\069\032\083\067\065\076\069", 349, (S.uiScale - 0.7) / 0.5,
    function(f) return 0.7 + f * 0.5 end,
    function(value) S.uiScale = value; MainScale.Scale = value end,
    function(value) return string.format("\037\046\050\102\195\151", value) end)
local ThemeNames = {"\076\073\077\069", "\067\089\065\078", "\086\073\079\076\069\084", "\079\082\065\078\071\069"}
local ThemeColors = {
    Color3.fromRGB(188, 235, 104), Color3.fromRGB(94, 213, 223),
    Color3.fromRGB(184, 151, 241), Color3.fromRGB(244, 164, 100),
}
local ThemeBtn = button(SettingsPage, "\065\067\067\069\078\084\058\032\076\073\077\069", 12, 407, 166, 30)
ExtraUI.RespawnDeathBtn = button(SettingsPage, "\082\069\083\080\065\087\078\032\065\084\032\068\069\065\084\072\058\032\079\070\070", 188, 407, 166, 30)
local function applyTheme(index)
    local old = C_ACCENT
    local oldNav = C_NAV_SELECTED
    C_ACCENT = ThemeColors[index]
    C_NAV_SELECTED = C_NAV:Lerp(C_ACCENT, 0.18)
    for _, item in ipairs(Gui:GetDescendants()) do
        if item:IsA("\085\073\083\116\114\111\107\101") and item.Color == old then item.Color = C_ACCENT end
        if item:IsA("\084\101\120\116\076\097\098\101\108") and item.TextColor3 == old then item.TextColor3 = C_ACCENT end
        if item:IsA("\084\101\120\116\066\117\116\116\111\110") and item.TextColor3 == old then item.TextColor3 = C_ACCENT end
        if item:IsA("\070\114\097\109\101") and item.BackgroundColor3 == old then
            item.BackgroundColor3 = C_ACCENT
        end
        if item:IsA("\084\101\120\116\066\117\116\116\111\110") and item.BackgroundColor3 == oldNav then
            item.BackgroundColor3 = C_NAV_SELECTED
        end
    end
    ThemeBtn.Text = "\065\067\067\069\078\084\058\032" .. ThemeNames[index]
end
bind(ThemeBtn.MouseButton1Click:Connect(function()
    S.themeIndex = S.themeIndex % #ThemeNames + 1
    applyTheme(S.themeIndex)
end))
bind(ExtraUI.RespawnDeathBtn.MouseButton1Click:Connect(function()
    S.respawnAtDeath = not S.respawnAtDeath
    if not S.respawnAtDeath then DeathPosition = nil end
    style(ExtraUI.RespawnDeathBtn, S.respawnAtDeath,
        "\082\069\083\080\065\087\078\032\065\084\032\068\069\065\084\072\058\032\079\078", "\082\069\083\080\065\087\078\032\065\084\032\068\069\065\084\072\058\032\079\070\070")
end))
bind(AntiVoidBtn.MouseButton1Click:Connect(function()
    S.antiVoid = not S.antiVoid
    style(AntiVoidBtn, S.antiVoid, "\065\078\084\073\032\086\079\073\068\058\032\079\078", "\065\078\084\073\032\086\079\073\068\058\032\079\070\070")
end))
bind(VoidKillBtn.MouseButton1Click:Connect(function()
    S.autoKillVoid = not S.autoKillVoid
    style(VoidKillBtn, S.autoKillVoid,
        "\065\085\084\079\032\075\073\076\076\032\086\079\073\068\032\066\076\073\078\075\058\032\079\078", "\065\085\084\079\032\075\073\076\076\032\086\079\073\068\032\066\076\073\078\075\058\032\079\070\070")
end))
style(AntiVoidBtn, S.antiVoid, "\065\078\084\073\032\086\079\073\068\058\032\079\078", "\065\078\084\073\032\086\079\073\068\058\032\079\070\070")
style(VoidKillBtn, S.autoKillVoid,
    "\065\085\084\079\032\075\073\076\076\032\086\079\073\068\032\066\076\073\078\075\058\032\079\078", "\065\085\084\079\032\075\073\076\076\032\086\079\073\068\032\066\076\073\078\075\058\032\079\070\070")

ExtraUI.groupedPage = function(sections)
    local scroll = round(make("\083\099\114\111\108\108\105\110\103\070\114\097\109\101", {
        Parent = Main, Position = UDim2.fromOffset(132, 82),
        Size = UDim2.fromOffset(376, 460), BackgroundColor3 = C_PANEL,
        BorderSizePixel = 0, Visible = false, ClipsDescendants = true,
        ScrollBarThickness = 5, ScrollBarImageColor3 = C_ACCENT,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        CanvasSize = UDim2.fromOffset(0, 0),
    }), 14)
    local y = 0
    for _, section in ipairs(sections) do
        local heading = label(scroll, section[1], y + 8, 19, C_ACCENT, 11)
        heading.Font = Enum.Font.GothamBold
        local content = section[2]
        content.Parent = scroll
        content.Position = UDim2.fromOffset(0, y + 30)
        content.Visible = true
        y = y + 30 + 449 + 22
    end
    scroll.CanvasSize = UDim2.fromOffset(0, y)
    return scroll
end
ExtraUI.CombatPage = ExtraUI.groupedPage({{"\065\073\077\032\038\032\065\084\084\065\067\075", AimPage},
    {"\087\069\065\080\079\078\083\032\038\032\070\073\082\069\032\067\079\078\084\082\079\076", ExtraUI.GunsPage}})
ExtraUI.GameplayPage = ExtraUI.groupedPage({{"\083\085\082\086\073\086\065\076\032\038\032\065\067\084\073\079\078\083", ToolsPage},
    {"\083\084\065\078\068\032\067\079\077\077\065\078\068\083", ExtraUI.StandPage},
    {"\084\069\076\069\080\079\082\084\083", ExtraUI.TeleportPage}})
ExtraUI.VisualsPage = ExtraUI.groupedPage({{"\080\076\065\089\069\082\032\069\083\080", ExtraUI.EspPage},
    {"\078\079\084\073\070\073\067\065\084\073\079\078\083", ExtraUI.NotifyPage}})
ExtraUI.OptionsPage = ExtraUI.groupedPage({{"\077\079\086\069\077\069\078\084\032\038\032\065\080\080\069\065\082\065\078\067\069", SettingsPage},
    {"\080\082\079\070\073\076\069\083\032\038\032\077\065\067\082\079", ExtraUI.ConfigPage}})
ExtraUI.PageViews = {targets = TargetsPage, combat = ExtraUI.CombatPage,
    gameplay = ExtraUI.GameplayPage, visuals = ExtraUI.VisualsPage,
    options = ExtraUI.OptionsPage}
ExtraUI.NavButtons = {targets = TargetTab, combat = AimTab,
    gameplay = ToolsTab, visuals = ExtraUI.EspTab, options = SettingsTab}
local CurrentTab = "\116\097\114\103\101\116\115"
local function showTab(which)
    CurrentTab = which
    Subtitle.Text = ({targets = "\080\076\065\089\069\082\032\083\069\076\069\067\084\073\079\078\032\032\047\032\032\076\073\086\069",
        combat = "\087\069\065\080\079\078\083\032\032\047\032\032\084\065\082\071\069\084\073\078\071",
        gameplay = "\083\085\082\086\073\086\065\076\032\032\047\032\032\077\079\086\069\077\069\078\084",
        visuals = "\069\083\080\032\032\047\032\032\078\079\084\073\070\073\067\065\084\073\079\078\083",
        options = "\080\082\069\070\069\082\069\078\067\069\083\032\032\047\032\032\080\082\079\070\073\076\069\083"})[which] or "\067\079\078\084\082\079\076\032\068\069\067\075\032\032\047\032\032\076\073\086\069"
    for name, pageView in pairs(ExtraUI.PageViews) do
        pageView.Visible = name == which
    end
    for name, tab in pairs(ExtraUI.NavButtons) do
        local active = name == which
        tab.BackgroundColor3 = active and C_NAV_SELECTED or C_NAV_OFF
        tab.TextColor3 = active and C_ACCENT or C_TEXT
        ExtraUI.TabIndicators[tab].Visible = active
        tab:SetAttribute("\083\112\101\099\116\114\097\084\097\098", true)
        tab:SetAttribute("\083\112\101\099\116\114\097\079\110", active)
    end
    local activePage = ExtraUI.PageViews[which]
    if activePage then
        activePage.Position = UDim2.fromOffset(141, 82)
        game:GetService("\084\119\101\101\110\083\101\114\118\105\099\101"):Create(activePage,
            TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
            {Position = UDim2.fromOffset(132, 82)}):Play()
    end
end
bind(TargetTab.MouseButton1Click:Connect(function() showTab("\116\097\114\103\101\116\115") end))
bind(AimTab.MouseButton1Click:Connect(function() showTab("\099\111\109\098\097\116") end))
bind(ToolsTab.MouseButton1Click:Connect(function() showTab("\103\097\109\101\112\108\097\121") end))
bind(ExtraUI.EspTab.MouseButton1Click:Connect(function() showTab("\118\105\115\117\097\108\115") end))
bind(SettingsTab.MouseButton1Click:Connect(function() showTab("\111\112\116\105\111\110\115") end))
showTab("\116\097\114\103\101\116\115")
local Minimized = false
bind(Minimise.MouseButton1Click:Connect(function()
    Minimized = not Minimized
    game:GetService("\084\119\101\101\110\083\101\114\118\105\099\101"):Create(Main,
        TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        {Size = UDim2.fromOffset(520, Minimized and 67 or 625)}):Play()
    Minimise.Text = Minimized and "\043" or "\045"
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
        local root = character and character:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116")
        if not root then say("\084\101\108\101\112\111\114\116\032\117\110\097\118\097\105\108\097\098\108\101\032\117\110\116\105\108\032\121\111\117\114\032\099\104\097\114\097\099\116\101\114\032\115\112\097\119\110\115\046"); return end
        previous = root.CFrame
        character:PivotTo(CFrame.new(position + Vector3.new(0, 4, 0)))
        say("\084\101\108\101\112\111\114\116\101\100\032\116\111\032" .. title .. "\046")
    end
    local function nearestShop(name)
        local store = Workspace:FindFirstChild("\083\116\111\114\101")
        local root = Me.Character and Me.Character:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116")
        if not store or not root then return nil end
        local nearest, distance = nil, math.huge
        for _, shop in ipairs(store:GetChildren()) do
            if shop.Name == name then
                local part = shop:FindFirstChildWhichIsA("\066\097\115\101\080\097\114\116", true)
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
        teleportTo(Vector3.new(1750.13, 29.45, 244.33), "\085\112\104\105\108\108")
    end))
    bind(t.downhill.MouseButton1Click:Connect(function()
        teleportTo(Vector3.new(722.42, 1.75, 264.21), "\068\111\119\110\104\105\108\108")
    end))
    for _, entry in ipairs({{t.armor, "\091\065\114\109\111\114\093", "\065\114\109\111\114\032\115\104\111\112"},
        {t.smg, "\091\083\077\071\093", "\083\077\071\032\115\104\111\112"}}) do
        bind(entry[1].MouseButton1Click:Connect(function()
            local part = nearestShop(entry[2])
            if part then teleportTo(part.Position, entry[3])
            else say(entry[3] .. "\032\105\115\032\110\111\116\032\108\111\097\100\101\100\032\110\101\097\114\098\121\046") end
        end))
    end
    bind(t.returnTo.MouseButton1Click:Connect(function()
        local character = Me.Character
        if previous and character and character:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116") then
            local destination = previous
            previous = character:GetPivot()
            character:PivotTo(destination)
            say("\082\101\116\117\114\110\101\100\032\116\111\032\112\114\101\118\105\111\117\115\032\112\111\115\105\116\105\111\110\046")
        else say("\078\111\032\112\114\101\118\105\111\117\115\032\116\101\108\101\112\111\114\116\032\112\111\115\105\116\105\111\110\032\115\097\118\101\100\046") end
    end))
end
local Rapid = {}
do
local RapidOriginal = setmetatable({}, {__mode = "\107"})
local RapidWatched = setmetatable({}, {__mode = "\107"})
local RapidLast = setmetatable({}, {__mode = "\107"})
local ReloadLast = setmetatable({}, {__mode = "\107"})
local GunRows = {}
local GunRowCount = 0
                                                                 
local FixedPace = {
    ["\091\082\101\118\111\108\118\101\114\093"] = 0.01,
    ["\091\068\111\117\098\108\101\045\066\097\114\114\101\108\032\083\071\093"] = 0.01,
    ["\091\084\097\099\116\105\099\097\108\083\104\111\116\103\117\110\093"] = 0.01,
    ["\091\083\104\111\116\103\117\110\093"] = 0.01,
    ["\091\083\077\071\093"] = 0.01,
}
local function ownedGuns(callback)
    local containers = {}
    if Me.Character then containers[#containers + 1] = Me.Character end
    local bag = Me:FindFirstChildOfClass("\066\097\099\107\112\097\099\107")
    if bag then containers[#containers + 1] = bag end
    for _, container in ipairs(containers) do
        if container then
            for _, tool in ipairs(container:GetChildren()) do
                if tool:IsA("\084\111\111\108") then callback(tool) end
            end
        end
    end
end
local function applyRapidCooldown(tool)
    if not tool or not tool:IsA("\084\111\111\108") then return end
    local cooldown = tool:GetAttribute("\067\111\111\108\100\111\119\110")
    if S.rapidWeapons[tool.Name] then
        if type(cooldown) == "\110\117\109\098\101\114" then
            if RapidOriginal[tool] == nil then
                RapidOriginal[tool] = cooldown ~= 0 and cooldown
                    or FixedPace[tool.Name] or cooldown
            end
            local pace = 0.01
            if cooldown ~= pace then tool:SetAttribute("\067\111\111\108\100\111\119\110", pace) end
        end
    elseif RapidOriginal[tool] ~= nil then
        local original = RapidOriginal[tool]
        RapidOriginal[tool] = nil
        pcall(function() tool:SetAttribute("\067\111\111\108\100\111\119\110", original) end)
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
    if not tool or type(tool:GetAttribute("\077\097\120\065\109\109\111")) ~= "\110\117\109\098\101\114" then return end
    local real = tool:GetAttribute("\082\101\097\108\065\109\109\111")
    local ammo = tool:GetAttribute("\065\109\109\111")
    local remaining = type(real) == "\110\117\109\098\101\114" and real or ammo
    if type(ammo) == "\110\117\109\098\101\114" and type(remaining) == "\110\117\109\098\101\114" then
        remaining = math.min(remaining, ammo)
    end
    if type(remaining) ~= "\110\117\109\098\101\114" or remaining > 2 then return end
    local now = os.clock()
    if now - (ReloadLast[tool] or 0) < 0.8 then return end
    ReloadLast[tool] = now
    local storage = ReplicatedStorage:FindFirstChild("\083\116\111\114\097\103\101")
    local remotes = storage and storage:FindFirstChild("\082\101\109\111\116\101\115")
    local main = remotes and remotes:FindFirstChild("\077\097\105\110")
    if main then pcall(function() main:FireServer("\082\101\108\111\097\100", tool) end) end
end
Rapid.requestReload = requestReload
local function addGunRow(name)
    if GunRows[name] then return end
    GunRowCount = GunRowCount + 1
    local row = button(ExtraUI.GunList, name .. "\032\032\047\032\032\079\070\070", 5, 0, 326, 35)
    row.LayoutOrder = GunRowCount + 10
    GunRows[name] = row
    bind(row.MouseButton1Click:Connect(function()
        S.rapidWeapons[name] = not S.rapidWeapons[name] or nil
        style(row, S.rapidWeapons[name], name .. "\032\032\047\032\032\079\078", name .. "\032\032\047\032\032\079\070\070")
        ownedGuns(function(tool)
            if tool.Name == name then applyRapidCooldown(tool) end
        end)
        say(name .. (S.rapidWeapons[name] and "\032\048\046\048\049\115\032\114\097\112\105\100\032\102\105\114\101\032\101\110\097\098\108\101\100\046" or "\032\099\111\111\108\100\111\119\110\032\114\101\115\116\111\114\101\100\046"))
    end))
end
local function observeGun(tool)
    if not tool:IsA("\084\111\111\108") then return end
    if type(tool:GetAttribute("\067\111\111\108\100\111\119\110")) == "\110\117\109\098\101\114" then
        addGunRow(tool.Name)
        applyRapidCooldown(tool)
    end
    if RapidWatched[tool] then return end
    RapidWatched[tool] = true
    bind(tool:GetAttributeChangedSignal("\067\111\111\108\100\111\119\110"):Connect(function()
        if not S.closed then observeGun(tool) end
    end))
end
Rapid.observeGun = observeGun
Rapid.forEachGun = ownedGuns
Rapid.applyCooldown = applyRapidCooldown
Rapid.rows = GunRows
Rapid.restore = function()
    for tool, original in pairs(RapidOriginal) do
        pcall(function() tool:SetAttribute("\067\111\111\108\100\111\119\110", original) end)
        RapidOriginal[tool] = nil
    end
end
for _, name in ipairs({"\091\068\111\117\098\108\101\045\066\097\114\114\101\108\032\083\071\093", "\091\082\101\118\111\108\118\101\114\093", "\091\083\104\111\116\103\117\110\093",
    "\091\084\097\099\116\105\099\097\108\083\104\111\116\103\117\110\093", "\091\083\077\071\093"}) do addGunRow(name) end
ownedGuns(observeGun)
local Backpack = Me:FindFirstChildOfClass("\066\097\099\107\112\097\099\107") or Me:WaitForChild("\066\097\099\107\112\097\099\107", 6)
if Backpack then bind(Backpack.ChildAdded:Connect(observeGun)) end
bind(RunService.Heartbeat:Connect(function()
    if S.closed then return end
    local character = Me.Character
    local tool = character and character:FindFirstChildOfClass("\084\111\111\108")
    if tool and (S.autoReloadAll or (S.infiniteSmg and tool.Name == "\091\083\077\071\093")) then
        requestReload(tool)
    end
    if S.aura or not next(S.rapidWeapons) or UIS:GetFocusedTextBox()
        or not UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then return end
    local mouse = UIS:GetMouseLocation()
    local pos, size = Main.AbsolutePosition, Main.AbsoluteSize
    if Gui.Enabled and mouse.X >= pos.X and mouse.X <= pos.X + size.X
        and mouse.Y >= pos.Y and mouse.Y <= pos.Y + size.Y then return end
    if tool and S.rapidWeapons[tool.Name]
        and type(tool:GetAttribute("\067\111\111\108\100\111\119\110")) == "\110\117\109\098\101\114" then
        local pace = Rapid.getPace(tool)
        local now = os.clock()
        if now - (RapidLast[tool] or 0) >= pace then
            Rapid.activate(tool)
        end
    end
end))
end
do
    local RecoilOriginal = setmetatable({}, {__mode = "\107"})
    local ShotVisualOriginal = setmetatable({}, {__mode = "\107"})
    local SpreadOriginal = nil
    local function applyRecoil(character)
        local scripts = character and character:FindFirstChild("\083\099\114\105\112\116\115")
        local input = scripts and scripts:FindFirstChild("\073\110\112\117\116")
        local module = input and input:FindFirstChild("\065\105\109\105\110\103\073\110\112\117\116")
        if not module then return end
        local ok, aim = pcall(require, module)
        if not ok or type(aim) ~= "\116\097\098\108\101" or type(aim.CameraRecoil) ~= "\102\117\110\099\116\105\111\110" then return end
        if not RecoilOriginal[aim] then RecoilOriginal[aim] = aim.CameraRecoil end
        aim.CameraRecoil = (S.noRecoil or S.invisibleShot)
            and function() end or RecoilOriginal[aim]
    end
    local function applyShotVisuals(character)
        local scripts = character and character:FindFirstChild("\083\099\114\105\112\116\115")
        local input = scripts and scripts:FindFirstChild("\073\110\112\117\116")
        local aiming = input and input:FindFirstChild("\065\105\109\105\110\103\073\110\112\117\116")
        if aiming then
            local ok, aim = pcall(require, aiming)
            if ok and type(aim) == "\116\097\098\108\101" then
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
        local storage = ReplicatedStorage:FindFirstChild("\083\116\111\114\097\103\101")
        local modules = storage and storage:FindFirstChild("\077\111\100\117\108\101\115")
        local dialect = modules and modules:FindFirstChild("\068\105\097\108\101\099\116")
        local managerModule = dialect and dialect:FindFirstChild("\071\117\110\077\097\110\097\103\101\114")
        if managerModule then
            local ok, manager = pcall(require, managerModule)
            if ok and type(manager) == "\116\097\098\108\101" then
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
                        if typeof(bullet) ~= "\073\110\115\116\097\110\099\101" then return end
                        if bullet:IsA("\066\097\115\101\080\097\114\116") then
                            bullet.Transparency = 1
                            bullet.LocalTransparencyModifier = 1
                        end
                        for _, visual in ipairs(bullet:GetDescendants()) do
                            if visual:IsA("\066\097\115\101\080\097\114\116") then
                                visual.Transparency = 1
                                visual.LocalTransparencyModifier = 1
                            elseif visual:IsA("\066\101\097\109") or visual:IsA("\084\114\097\105\108")
                                or visual:IsA("\080\097\114\116\105\099\108\101\069\109\105\116\116\101\114") then
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
        local playerScripts = Me:FindFirstChild("\080\108\097\121\101\114\083\099\114\105\112\116\115")
        local mainScripts = playerScripts and playerScripts:FindFirstChild("\077\097\105\110")
        local handlers = mainScripts and mainScripts:FindFirstChild("\072\097\110\100\108\101\114\115")
        local bulletModule = handlers and handlers:FindFirstChild("\066\117\108\108\101\116\072\097\110\100\108\101\114")
        if bulletModule then
            local ok, handler = pcall(require, bulletModule)
            if ok and type(handler) == "\116\097\098\108\101"
                and type(handler.ReplicateBullets) == "\102\117\110\099\116\105\111\110" then
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
        local storage = ReplicatedStorage:FindFirstChild("\083\116\111\114\097\103\101")
        local modules = storage and storage:FindFirstChild("\077\111\100\117\108\101\115")
        local dialect = modules and modules:FindFirstChild("\068\105\097\108\101\099\116")
        local module = dialect and dialect:FindFirstChild("\071\117\110\077\097\110\097\103\101\114")
        if not module then return end
        local ok, manager = pcall(require, module)
        if not ok or type(manager) ~= "\116\097\098\108\101" then return end
        local patterns = manager["\091\068\111\117\098\108\101\045\066\097\114\114\101\108\032\083\071\093"]
        if type(patterns) ~= "\116\097\098\108\101" then return end
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
    local invisibleBtn = button(ExtraUI.GunList, "\073\078\086\073\083\073\066\076\069\032\083\072\079\084\058\032\079\070\070", 5, 0, 326, 35)
    invisibleBtn.LayoutOrder = -4
    bind(invisibleBtn.MouseButton1Click:Connect(function()
        S.invisibleShot = not S.invisibleShot
        applyShotVisuals(Me.Character)
        applyRecoil(Me.Character)
        style(invisibleBtn, S.invisibleShot,
            "\073\078\086\073\083\073\066\076\069\032\083\072\079\084\058\032\079\078", "\073\078\086\073\083\073\066\076\069\032\083\072\079\084\058\032\079\070\070")
        say("\073\110\118\105\115\105\098\108\101\032\115\104\111\116\032\097\102\102\101\099\116\115\032\108\111\099\097\108\032\118\105\115\117\097\108\115\059\032\115\101\114\118\101\114\032\115\104\111\116\032\101\102\102\101\099\116\115\032\109\097\121\032\115\116\105\108\108\032\098\101\032\118\105\115\105\098\108\101\046")
    end))
    local adaptiveBtn = button(ExtraUI.GunList, "\070\073\082\069\032\082\065\084\069\058\032\048\046\048\049\083", 5, 0, 326, 35)
    adaptiveBtn.LayoutOrder = -5
    bind(adaptiveBtn.MouseButton1Click:Connect(function()
        say("\082\097\112\105\100\032\102\105\114\101\032\117\115\101\115\032\102\105\120\101\100\032\105\110\116\101\114\118\097\108\115\032\098\121\032\119\101\097\112\111\110\059\032\116\117\114\110\032\111\110\032\116\104\101\032\119\101\097\112\111\110\032\114\111\119\032\098\101\108\111\119\046")
    end))
    local recoilBtn = button(ExtraUI.GunList, "\078\079\032\082\069\067\079\073\076\058\032\079\070\070", 5, 0, 326, 35)
    recoilBtn.LayoutOrder = -3
    bind(recoilBtn.MouseButton1Click:Connect(function()
        S.noRecoil = not S.noRecoil
        applyRecoil(Me.Character)
        style(recoilBtn, S.noRecoil, "\078\079\032\082\069\067\079\073\076\058\032\079\078", "\078\079\032\082\069\067\079\073\076\058\032\079\070\070")
    end))
    local spreadBtn = button(ExtraUI.GunList, "\068\066\032\078\079\032\083\080\082\069\065\068\058\032\079\070\070", 5, 0, 326, 35)
    spreadBtn.LayoutOrder = -2
    bind(spreadBtn.MouseButton1Click:Connect(function()
        if ExtraUI.Capabilities.gunManager == false then return end
        S.noSpread = not S.noSpread
        applySpread()
        style(spreadBtn, S.noSpread, "\068\066\032\078\079\032\083\080\082\069\065\068\058\032\079\078", "\068\066\032\078\079\032\083\080\082\069\065\068\058\032\079\070\070")
    end))
    local smgBtn = button(ExtraUI.GunList, "\083\077\071\032\065\085\084\079\032\082\069\076\079\065\068\058\032\079\070\070", 5, 0, 326, 35)
    smgBtn.LayoutOrder = -1
    bind(smgBtn.MouseButton1Click:Connect(function()
        S.infiniteSmg = not S.infiniteSmg
        style(smgBtn, S.infiniteSmg, "\083\077\071\032\065\085\084\079\032\082\069\076\079\065\068\058\032\079\078", "\083\077\071\032\065\085\084\079\032\082\069\076\079\065\068\058\032\079\070\070")
        say("\083\077\071\032\114\101\108\111\097\100\032\114\101\113\117\101\115\116\115\032\102\111\108\108\111\119\032\116\104\101\032\115\101\114\118\101\114\032\097\109\109\111\032\099\111\117\110\116\046")
    end))
    local reloadBtn = button(ExtraUI.GunList, "\065\085\084\079\032\082\069\076\079\065\068\032\065\076\076\032\071\085\078\083\058\032\079\070\070", 5, 0, 326, 35)
    reloadBtn.LayoutOrder = 0
    ExtraUI.GunModButtons = {invisible = invisibleBtn, adaptive = adaptiveBtn,
        recoil = recoilBtn, spread = spreadBtn, smg = smgBtn, reload = reloadBtn}
    bind(reloadBtn.MouseButton1Click:Connect(function()
        S.autoReloadAll = not S.autoReloadAll
        style(reloadBtn, S.autoReloadAll,
            "\065\085\084\079\032\082\069\076\079\065\068\032\065\076\076\032\071\085\078\083\058\032\079\078", "\065\085\084\079\032\082\069\076\079\065\068\032\065\076\076\032\071\085\078\083\058\032\079\070\070")
    end))
    local knifeBtn = button(ExtraUI.GunList, "\069\081\085\073\080\032\075\078\073\070\069", 5, 0, 326, 35)
    knifeBtn.LayoutOrder = 1
    bind(knifeBtn.MouseButton1Click:Connect(function()
        local character = Me.Character
        local hum = character and character:FindFirstChildOfClass("\072\117\109\097\110\111\105\100")
        local bag = Me:FindFirstChildOfClass("\066\097\099\107\112\097\099\107")
        local knife = bag and bag:FindFirstChild("\091\075\110\105\102\101\093")
        if hum and knife then
            hum:EquipTool(knife)
            say("\075\110\105\102\101\032\101\113\117\105\112\112\101\100\046")
        else say("\075\110\105\102\101\032\105\115\032\110\111\116\032\105\110\032\121\111\117\114\032\098\097\099\107\112\097\099\107\046") end
    end))
    ExtraUI.KnifeTravelBtn = button(ExtraUI.GunList, "\075\078\073\070\069\032\084\082\065\086\069\076\058\032\079\070\070", 5, 0, 326, 35)
    ExtraUI.KnifeTravelBtn.LayoutOrder = 2
    ExtraUI.AuraBtn = button(ExtraUI.GunList, "\065\085\082\065\032\055\053\032\083\084\085\068\083\058\032\079\070\070", 5, 0, 326, 35)
    ExtraUI.AuraBtn.LayoutOrder = 3
    ExtraUI.knifeTravelGun = nil
    ExtraUI.knifeTravelCombatAt = 0
    ExtraUI.knifeTravelSwitchAt = 0
    ExtraUI.knifeTravelTickAt = 0
    ExtraUI.restoreTravelGun = function(fireAfterEquip)
        local character = Me.Character
        local hum = character and character:FindFirstChildOfClass("\072\117\109\097\110\111\105\100")
        local bag = Me:FindFirstChildOfClass("\066\097\099\107\112\097\099\107")
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
            "\075\078\073\070\069\032\084\082\065\086\069\076\058\032\079\078", "\075\078\073\070\069\032\084\082\065\086\069\076\058\032\079\070\070")
        if not S.knifeTravel then ExtraUI.restoreTravelGun(false) end
        say(S.knifeTravel and "\075\110\105\102\101\032\116\114\097\118\101\108\032\101\110\097\098\108\101\100\058\032\109\111\118\101\032\116\111\032\101\113\117\105\112\032\107\110\105\102\101\059\032\097\105\109\032\111\114\032\102\105\114\101\032\114\101\115\116\111\114\101\115\032\121\111\117\114\032\103\117\110\046"
            or "\075\110\105\102\101\032\116\114\097\118\101\108\032\100\105\115\097\098\108\101\100\046")
    end))
    bind(UIS.InputBegan:Connect(function(input, processed)
        if processed or not S.knifeTravel or S.closed or UIS:GetFocusedTextBox() then return end
        local fire = input.UserInputType == Enum.UserInputType.MouseButton1
        local aim = input.UserInputType == Enum.UserInputType.MouseButton2
        if not fire and not aim then return end
        ExtraUI.knifeTravelCombatAt = os.clock()
        local character = Me.Character
        local equipped = character and character:FindFirstChildOfClass("\084\111\111\108")
        if equipped and equipped.Name == "\091\075\110\105\102\101\093" then
            ExtraUI.restoreTravelGun(fire)
        end
    end))
    bind(RunService.Heartbeat:Connect(function()
        if not S.knifeTravel or S.closed then return end
        local now = os.clock()
        if now - ExtraUI.knifeTravelTickAt < 0.12 then return end
        ExtraUI.knifeTravelTickAt = now
        local character = Me.Character
        local hum = character and character:FindFirstChildOfClass("\072\117\109\097\110\111\105\100")
        local bag = Me:FindFirstChildOfClass("\066\097\099\107\112\097\099\107")
        if not hum or not bag or hum.Health <= 0 or hum.MoveDirection.Magnitude < 0.25
            or S.autoKill or S.aura or S.resetInFlight or S.bring
            or UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
            or now - ExtraUI.knifeTravelCombatAt < 1.4
            or now - ExtraUI.knifeTravelSwitchAt < 0.4 then return end
        local effects = character:FindFirstChild("\066\111\100\121\069\102\102\101\099\116\115")
        local ko = effects and effects:FindFirstChild("\075\046\079")
        if ko and ko.Value then return end
        local equipped = character:FindFirstChildOfClass("\084\111\111\108")
        if equipped and equipped.Name == "\091\075\110\105\102\101\093" then return end
        local knife = bag:FindFirstChild("\091\075\110\105\102\101\093")
        if not knife then return end
        if equipped and equipped:FindFirstChild("\082\101\115\112\111\110\115\101") then
            ExtraUI.knifeTravelGun = equipped
        end
        if not ExtraUI.knifeTravelGun then return end
        local ok = pcall(function() hum:EquipTool(knife) end)
        if ok then ExtraUI.knifeTravelSwitchAt = now end
    end))
end
do
    if not ExtraUI.Capabilities.drawing then
        ExtraUI.FallbackEspGui = make("\083\099\114\101\101\110\071\117\105", {
            Name = "\082\065\067\069\082\095\069\083\080", Parent = PlayerGui, ResetOnSpawn = false,
            IgnoreGuiInset = true, DisplayOrder = 2199,
        })
    end
    ExtraUI.newOverlayDrawable = function(kind)
        if ExtraUI.Capabilities.drawing then return Drawing.new(kind) end
        local state = {}
        local object = kind == "\084\101\120\116" and make("\084\101\120\116\076\097\098\101\108", {
            Parent = ExtraUI.FallbackEspGui, BackgroundTransparency = 1,
            BorderSizePixel = 0, Text = "", TextColor3 = Color3.new(1, 1, 1),
            Font = Enum.Font.GothamBold, TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Center, Visible = false,
            ZIndex = 2,
        }) or make("\070\114\097\109\101", {
            Parent = ExtraUI.FallbackEspGui, BorderSizePixel = 0,
            BackgroundColor3 = Color3.new(1, 1, 1), Visible = false,
            ZIndex = 2,
        })
        local stroke = kind == "\083\113\117\097\114\101" and make("\085\073\083\116\114\111\107\101", {
            Parent = object, Thickness = 1, Color = Color3.new(1, 1, 1),
        }) or nil
        local function refresh()
            if not object.Parent then return end
            object.Visible = state.Visible == true
            if kind == "\084\101\120\116" then
                local pos = state.Position or Vector2.zero
                object.AnchorPoint = state.Center and Vector2.new(0.5, 0)
                    or Vector2.zero
                object.Position = UDim2.fromOffset(pos.X, pos.Y)
                object.Size = UDim2.fromOffset(260, (state.Size or 12) + 6)
                object.Text = state.Text or ""
                object.TextSize = state.Size or 12
                object.TextColor3 = state.Color or Color3.new(1, 1, 1)
            elseif kind == "\076\105\110\101" then
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
                if key == "\082\101\109\111\118\101" then
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
    local colorNames = {"\067\089\065\078", "\086\073\079\076\069\084", "\065\077\066\069\082", "\076\073\077\069"}
    local r15 = {{"\072\101\097\100", "\085\112\112\101\114\084\111\114\115\111"}, {"\085\112\112\101\114\084\111\114\115\111", "\076\111\119\101\114\084\111\114\115\111"},
        {"\085\112\112\101\114\084\111\114\115\111", "\076\101\102\116\085\112\112\101\114\065\114\109"}, {"\076\101\102\116\085\112\112\101\114\065\114\109", "\076\101\102\116\076\111\119\101\114\065\114\109"},
        {"\076\101\102\116\076\111\119\101\114\065\114\109", "\076\101\102\116\072\097\110\100"}, {"\085\112\112\101\114\084\111\114\115\111", "\082\105\103\104\116\085\112\112\101\114\065\114\109"},
        {"\082\105\103\104\116\085\112\112\101\114\065\114\109", "\082\105\103\104\116\076\111\119\101\114\065\114\109"}, {"\082\105\103\104\116\076\111\119\101\114\065\114\109", "\082\105\103\104\116\072\097\110\100"},
        {"\076\111\119\101\114\084\111\114\115\111", "\076\101\102\116\085\112\112\101\114\076\101\103"}, {"\076\101\102\116\085\112\112\101\114\076\101\103", "\076\101\102\116\076\111\119\101\114\076\101\103"},
        {"\076\101\102\116\076\111\119\101\114\076\101\103", "\076\101\102\116\070\111\111\116"}, {"\076\111\119\101\114\084\111\114\115\111", "\082\105\103\104\116\085\112\112\101\114\076\101\103"},
        {"\082\105\103\104\116\085\112\112\101\114\076\101\103", "\082\105\103\104\116\076\111\119\101\114\076\101\103"}, {"\082\105\103\104\116\076\111\119\101\114\076\101\103", "\082\105\103\104\116\070\111\111\116"}}
    local r6 = {{"\072\101\097\100", "\084\111\114\115\111"}, {"\084\111\114\115\111", "\076\101\102\116\032\065\114\109"},
        {"\084\111\114\115\111", "\082\105\103\104\116\032\065\114\109"}, {"\084\111\114\115\111", "\076\101\102\116\032\076\101\103"}, {"\084\111\114\115\111", "\082\105\103\104\116\032\076\101\103"}}
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
        local o = {box = ExtraUI.newOverlayDrawable("\083\113\117\097\114\101"),
            name = ExtraUI.newOverlayDrawable("\084\101\120\116"),
            distance = ExtraUI.newOverlayDrawable("\084\101\120\116"),
            combat = ExtraUI.newOverlayDrawable("\084\101\120\116"),
            healthBack = ExtraUI.newOverlayDrawable("\083\113\117\097\114\101"),
            healthFill = ExtraUI.newOverlayDrawable("\083\113\117\097\114\101"),
            tracer = ExtraUI.newOverlayDrawable("\076\105\110\101"), lines = {}}
        o.box.Filled = false
        o.box.Thickness = 1.5
        o.healthBack.Filled, o.healthFill.Filled = true, true
        o.healthBack.Color = Color3.fromRGB(16, 22, 35)
        o.tracer.Thickness = 1.4
        o.name.Center, o.distance.Center, o.combat.Center = true, true, true
        o.name.Outline, o.distance.Outline, o.combat.Outline = true, true, true
        o.name.Size, o.distance.Size, o.combat.Size = 13, 12, 11
        for i = 1, #r15 do
            local line = ExtraUI.newOverlayDrawable("\076\105\110\101")
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
                local root = character and character:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116")
                local hum = character and character:FindFirstChildOfClass("\072\117\109\097\110\111\105\100")
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
                            o.name.Text = selected and ("\226\151\134\032\032" .. player.DisplayName .. "\032\032\226\151\134")
                                or player.DisplayName
                            o.name.Position = Vector2.new(centerX, top.Y - 18)
                            o.name.Visible = not selected and S.esp.enabled and S.esp.names
                            o.distance.Text = selected and string.format(
                                "\037\046\048\102\032\072\080\032\032\124\032\032\037\046\048\102\032\115\116\117\100\115", hum.Health, studs)
                                or string.format("\037\046\048\102\032\115\116\117\100\115", studs)
                            o.distance.Position = Vector2.new(centerX, bottom.Y + 3)
                            o.distance.Visible = not selected and S.esp.enabled and S.esp.distance
                            local effects = character:FindFirstChild("\066\111\100\121\069\102\102\101\099\116\115")
                            local armor = effects and effects:FindFirstChild("\065\114\109\111\114")
                            local ko = effects and effects:FindFirstChild("\075\046\079")
                            local dead = effects and effects:FindFirstChild("\068\101\097\100")
                            local status = dead and dead.Value and "\068\069\065\068"
                                or (ko and ko.Value or hum.Health <= 0.5) and "\068\079\087\078" or "\085\080"
                            local weapon = character:FindFirstChildOfClass("\084\111\111\108")
                            local weaponText = weapon and weapon.Name:gsub("\091\037\091\037\093\093", "") or "\085\078\065\082\077\069\068"
                            local ammo = weapon and weapon:GetAttribute("\082\101\097\108\065\109\109\111")
                            if type(ammo) ~= "\110\117\109\098\101\114" then
                                ammo = weapon and weapon:GetAttribute("\065\109\109\111")
                            end
                            if type(ammo) == "\110\117\109\098\101\114" then
                                weaponText = weaponText .. "\032" .. math.floor(ammo)
                            end
                            o.combat.Text = string.format("\072\080\032\037\046\048\102\032\032\065\082\032\037\046\048\102\032\032\037\115\032\032\037\115",
                                hum.Health, armor and armor.Value or 0, status, weaponText)
                            o.combat.Color = status == "\085\080" and color or Color3.fromRGB(255, 105, 105)
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
                            local bones = character:FindFirstChild("\085\112\112\101\114\084\111\114\115\111") and r15 or r6
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
        style(ExtraUI.EspMain, S.esp.enabled, "\069\083\080\058\032\079\078", "\069\083\080\058\032\079\070\070")
        if not S.esp.enabled then
            for _, o in pairs(overlays) do hideOverlay(o) end
        end
    end))
    local toggles = {{"\098\111\120\101\115", ExtraUI.EspBoxes, "\066\079\088\069\083"},
        {"\115\107\101\108\101\116\111\110", ExtraUI.EspSkeleton, "\083\075\069\076\069\084\079\078"},
        {"\110\097\109\101\115", ExtraUI.EspNames, "\078\065\077\069\083"},
        {"\100\105\115\116\097\110\099\101", ExtraUI.EspDistance, "\068\073\083\084\065\078\067\069"}}
    for _, item in ipairs(toggles) do
        bind(item[2].MouseButton1Click:Connect(function()
            S.esp[item[1]] = not S.esp[item[1]]
            style(item[2], S.esp[item[1]], item[3] .. "\058\032\079\078", item[3] .. "\058\032\079\070\070")
        end))
    end
    bind(ExtraUI.EspRange.MouseButton1Click:Connect(function()
        S.esp.rangeIndex = S.esp.rangeIndex % #ranges + 1
        ExtraUI.EspRange.Text = "\082\065\078\071\069\058\032" ..
            (ranges[S.esp.rangeIndex] == math.huge and "\065\076\076" or tostring(ranges[S.esp.rangeIndex]))
    end))
    bind(ExtraUI.EspColor.MouseButton1Click:Connect(function()
        S.esp.colorIndex = S.esp.colorIndex % #colors + 1
        ExtraUI.EspColor.Text = "\067\079\076\079\082\058\032" .. colorNames[S.esp.colorIndex]
    end))
end
local function updateOwnRoot()
    local c = Me.Character
    OwnRoot = c and c:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116", true) or nil
end

                                                                            
local function refreshArmorShops()
    table.clear(ArmorShops)
    local store = Workspace:FindFirstChild("\083\116\111\114\101")
    if not store then return end
    for _, model in ipairs(store:GetChildren()) do
        if model.Name == "\091\065\114\109\111\114\093" and model:IsA("\077\111\100\101\108") then
            local head = model:FindFirstChild("\072\101\097\100")
            local click = model:FindFirstChildOfClass("\067\108\105\099\107\068\101\116\101\099\116\111\114")
            if head and head:IsA("\066\097\115\101\080\097\114\116") and click then
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
        return pcall(fireclickdetector, click, 0, "\109\111\117\115\101\099\108\105\099\107")
    end
                                                                          
    local camera = Workspace.CurrentCamera
    if not camera or not head then return false end
    local oldCamera = camera.CFrame
    local ok = pcall(function()
        camera.CFrame = CFrame.lookAt(camera.CFrame.Position, head.Position)
        task.wait()
        local point, visible = camera:WorldToViewportPoint(head.Position)
        if not visible then error("\115\104\111\112\032\105\115\032\110\111\116\032\111\110\032\115\099\114\101\101\110") end
        local input = game:GetService("\086\105\114\116\117\097\108\073\110\112\117\116\077\097\110\097\103\101\114")
        input:SendMouseButtonEvent(point.X, point.Y, 0, true, game, 0)
        input:SendMouseButtonEvent(point.X, point.Y, 0, false, game, 0)
    end)
    camera.CFrame = oldCamera
    return ok
end

local function buyArmorAfterSpawn(character)
    if not ExtraUI.Capabilities.shopPurchase then return end
    local generation = S.armorGeneration
    local root = character:WaitForChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116", 6)
    local hum = character:WaitForChild("\072\117\109\097\110\111\105\100", 6)
    local effects = character:WaitForChild("\066\111\100\121\069\102\102\101\099\116\115", 6)
    local armor = effects and effects:WaitForChild("\065\114\109\111\114", 6)
    if not root or not hum or not armor or S.closed or not S.autoArmor
        or generation ~= S.armorGeneration or Me.Character ~= character then return end
    local readyUntil = os.clock() + 6
    while hum.Health <= 0 and os.clock() < readyUntil and not S.closed
        and Me.Character == character do task.wait(0.1) end
    if S.closed or not S.autoArmor or generation ~= S.armorGeneration
        or Me.Character ~= character or not root.Parent or hum.Health <= 0 then return end
    if armor.Value >= 200 then say("\065\117\116\111\032\097\114\109\111\114\058\032\097\108\114\101\097\100\121\032\102\117\108\108\046"); return end
    local shop = closestArmorShop(root)
    if not shop then say("\065\117\116\111\032\097\114\109\111\114\058\032\110\111\032\108\111\097\100\101\100\032\097\114\109\111\114\032\115\104\111\112\032\102\111\117\110\100\046"); return end
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
            say("\065\117\116\111\032\097\114\109\111\114\058\032\099\111\108\108\101\099\116\101\100\032\040" .. armor.Value .. "\032\097\114\109\111\114\041\046")
        elseif clicked then
            say("\065\117\116\111\032\097\114\109\111\114\058\032\115\104\111\112\032\099\108\105\099\107\101\100\044\032\098\117\116\032\112\117\114\099\104\097\115\101\032\119\097\115\032\110\111\116\032\099\111\110\102\105\114\109\101\100\046")
        else
            say("\065\117\116\111\032\097\114\109\111\114\058\032\115\104\111\112\032\099\108\105\099\107\032\102\097\105\108\101\100\046")
        end
    end
end

local function selectedShop()
    return ShopNames[S.autoBuyIndex]
end
local function refreshAutoBuyControls()
    if not ExtraUI.Capabilities.shopPurchase then return end
    local name = selectedShop()
    AutoBuyName.Text = name:gsub("\037\091", ""):gsub("\037\093", "")
    style(AutoBuyToggle, S.autoBuys[name] == true, "\065\085\084\079\032\066\085\089\058\032\079\078", "\065\085\084\079\032\066\085\089\058\032\079\070\070")
    local count = 0
    for _, item in ipairs(ShopNames) do
        if S.autoBuys[item] then count = count + 1 end
    end
    AutoBuyCount.Text = count .. "\032\115\104\111\112\032\105\116\101\109\040\115\041\032\115\101\108\101\099\116\101\100\032\102\111\114\032\101\097\099\104\032\114\101\115\112\097\119\110\046"
end
local function hasShopItem(character, name)
    local backpack = Me:FindFirstChildOfClass("\066\097\099\107\112\097\099\107")
    if character:FindFirstChild(name) or (backpack and backpack:FindFirstChild(name)) then return true end
    if name == "\091\083\117\114\103\101\111\110\032\077\097\115\107\093" then
        local effects = character:FindFirstChild("\066\111\100\121\069\102\102\101\099\116\115")
        local mask = effects and effects:FindFirstChild("\077\097\115\107")
        return mask and mask.Value ~= ""
    end
    return false
end
local function closestShopByName(name, root)
    local store = Workspace:FindFirstChild("\083\116\111\114\101")
    if not store then return {} end
    local choices = {}
    for _, model in ipairs(store:GetChildren()) do
        if model.Name == name and model:IsA("\077\111\100\101\108") then
            local head = model:FindFirstChild("\072\101\097\100")
            local click = model:FindFirstChildOfClass("\067\108\105\099\107\068\101\116\101\099\116\111\114")
            if head and head:IsA("\066\097\115\101\080\097\114\116") and click then
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
    local root = character:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116")
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
                say((bought and "\066\111\117\103\104\116\032" or "\067\111\117\108\100\032\110\111\116\032\099\111\110\102\105\114\109\032") .. name .. "\046")
                task.wait(0.02)
            end
        end
    end)
    ShopBusy = false
    if not ok and not S.closed then say("\065\117\116\111\032\098\117\121\032\102\097\105\108\101\100\058\032" .. tostring(err)) end
end

local function captureDeathPosition(character)
    if not S.respawnAtDeath or Me.Character ~= character then return end
    local root = character:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116")
    if root and root:IsA("\066\097\115\101\080\097\114\116") then DeathPosition = root.CFrame end
end
local function restoreDeathPosition(character)
    local destination = DeathPosition
    if not S.respawnAtDeath or not destination then return end
    task.spawn(function()
        local root = character:WaitForChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116", 6)
        local hum = character:FindFirstChildOfClass("\072\117\109\097\110\111\105\100")
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
    local effects = character:FindFirstChild("\066\111\100\121\069\102\102\101\099\116\115")
    local ko = effects and effects:FindFirstChild("\075\046\079")
    local dead = effects and effects:FindFirstChild("\068\101\097\100")
    local grabbed = effects and effects:FindFirstChild("\071\114\097\098\098\101\100")
    local hum = character:FindFirstChildOfClass("\072\117\109\097\110\111\105\100")
    if ko and ko:IsA("\066\111\111\108\086\097\108\117\101") and ko.Value then return "\075\046\079" end
    if dead and dead:IsA("\066\111\111\108\086\097\108\117\101") and dead.Value then return "\068\101\097\100" end
    if grabbed and grabbed:IsA("\079\098\106\101\099\116\086\097\108\117\101") and grabbed.Value then return "\103\114\097\098\098\101\100" end
    if hum and hum.Health <= ResetThresholds[S.resetThresholdIndex] then
        return "\108\111\119\032\104\101\097\108\116\104"
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
    ExtraUI.Notify.emit("\097\110\116\105\083\116\111\109\112", "\065\110\116\105\045\083\116\111\109\112\032\114\101\115\101\116\032\099\111\110\102\105\114\109\101\100\032\040" .. signal .. "\041")
    say("\065\110\116\105\032\115\116\111\109\112\058\032\114\101\115\101\116\032\099\111\110\102\105\114\109\101\100\059\032\114\101\116\114\121\032\115\116\111\112\112\101\100\046")
end
local function resetBeforeStomp(character, reason)
    if not reason or S.closed or not S.antiStomp or S.resetInFlight
        or not S.antiStompReady
        or Me.Character ~= character or S.antiStompTriggeredCharacter == character
        or os.clock() < S.antiStompSpawnGraceUntil then return end
    local hum = character:FindFirstChildOfClass("\072\117\109\097\110\111\105\100")
    if not hum then return end
    local storage = ReplicatedStorage:FindFirstChild("\083\116\111\114\097\103\101")
    local remotes = storage and storage:FindFirstChild("\082\101\109\111\116\101\115")
    local main = remotes and remotes:FindFirstChild("\077\097\105\110")
    if not main or not main:IsA("\082\101\109\111\116\101\069\118\101\110\116") then return end

    S.resetGeneration = S.resetGeneration + 1
    local generation = S.resetGeneration
    S.resetCharacter = character
    S.antiStompTriggeredCharacter = character
    S.resetInFlight = true
    S.antiStompReady = false
    S.lastResetAt = os.clock()
    S.autoKill = false
    S.autoKillGeneration = S.autoKillGeneration + 1
    style(AutoKillBtn, false, "\065\085\084\079\032\075\073\076\076\032\083\069\076\069\067\084\069\068\058\032\079\078", "\065\085\084\079\032\075\073\076\076\032\083\069\076\069\067\084\069\068\058\032\079\070\070")
    captureDeathPosition(character)
    ExtraUI.Notify.emit("\097\110\116\105\083\116\111\109\112", "\065\110\116\105\045\083\116\111\109\112\032\114\101\115\101\116\032\114\101\113\117\101\115\116\101\100\032\040" .. reason .. "\041")
    local ok = pcall(function() main:FireServer("\082\101\115\101\116\078\101\119") end)
    if not ok then
        S.resetInFlight = false
        S.resetCharacter = nil
        say("\065\110\116\105\032\115\116\111\109\112\058\032\114\101\115\101\116\032\114\101\113\117\101\115\116\032\102\097\105\108\101\100\059\032\114\101\045\101\110\097\098\108\101\032\116\111\032\114\101\116\114\121\046")
        return
    end
    say("\065\110\116\105\032\115\116\111\109\112\058\032\097\119\097\105\116\105\110\103\032\114\101\115\101\116\032\099\111\110\102\105\114\109\097\116\105\111\110\032\098\101\102\111\114\101\032\097\110\121\032\114\101\116\114\121\046")
    task.spawn(function()
        local attempts = 1
        while not S.closed and S.antiStomp and S.resetGeneration == generation
            and S.resetCharacter == character and Me.Character == character do
            task.wait(1.25)
                                                                             
                                                                             
            if S.closed or not S.antiStomp or S.resetGeneration ~= generation
                or S.resetCharacter ~= character or Me.Character ~= character
                or not character.Parent then break end
            local currentHum = character:FindFirstChildOfClass("\072\117\109\097\110\111\105\100")
            if not currentHum then break end
            if not ownDangerReason(character) and currentHum.Health > 0 then
                                                                            
                S.resetInFlight = false
                S.resetCharacter = nil
                S.antiStompReady = true
                say("\065\110\116\105\032\115\116\111\109\112\058\032\114\101\099\111\118\101\114\121\032\100\101\116\101\099\116\101\100\059\032\115\116\111\112\112\101\100\032\114\101\115\101\116\032\114\101\113\117\101\115\116\115\046")
                ExtraUI.Notify.emit("\097\110\116\105\083\116\111\109\112", "\065\110\116\105\045\083\116\111\109\112\032\115\116\111\112\112\101\100\058\032\114\101\099\111\118\101\114\101\100")
                return
            end
            attempts = attempts + 1
            S.lastResetAt = os.clock()
            pcall(function() main:FireServer("\082\101\115\101\116\078\101\119") end)
            if attempts == 3 or attempts % 6 == 0 then
                say("\065\110\116\105\032\115\116\111\109\112\058\032\119\097\105\116\105\110\103\032\102\111\114\032\099\104\097\114\097\099\116\101\114\032\114\101\102\114\101\115\104\032\040\097\116\116\101\109\112\116\032" .. attempts .. "\041\046")
            end
        end
        if S.resetGeneration == generation and S.resetCharacter == character then
            S.resetCharacter = nil
            S.resetInFlight = false
        end
    end)
end
local OwnCharacterGeneration = 0
ExtraUI.ensureMacro = function(character)
    if not S.macroLock or S.closed or Me.Character ~= character then return end
    local enabled = ExtraUI.macroEnabled
    if not enabled or not enabled.Parent then return end
    local battle = ReplicatedStorage:FindFirstChild("\083\116\111\114\097\103\101")
    battle = battle and battle:FindFirstChild("\071\097\109\101\086\097\108\117\101\115")
    battle = battle and battle:FindFirstChild("\066\097\116\116\108\101\082\111\121\097\108\101")
    if Me:GetAttribute("\068\117\101\108\078\111\077\097\099\114\111") or (battle and battle.Value) then return end
    if not enabled.Value then pcall(function() enabled.Value = true end) end
end
local function watchOwnCharacter(character)
    disconnectMany(OwnCharacterConnections)
    ExtraUI.macroEnabled = nil
    OwnCharacterConnections[#OwnCharacterConnections + 1] =
        character.ChildAdded:Connect(Rapid.observeGun)
    for _, tool in ipairs(character:GetChildren()) do Rapid.observeGun(tool) end
    task.spawn(function()
        local scripts = character:WaitForChild("\083\099\114\105\112\116\115", 12)
        local input = scripts and scripts:WaitForChild("\073\110\112\117\116", 12)
        local macro = input and (input:FindFirstChild("\082\101\097\108\077\097\099\114\111\073\110\112\117\116")
            or input:FindFirstChild("\077\097\099\114\111\073\110\112\117\116")
            or input:WaitForChild("\082\101\097\108\077\097\099\114\111\073\110\112\117\116", 3))
        local enabled = macro and (macro:FindFirstChild("\069\110\097\098\108\101\100")
            or macro:WaitForChild("\069\110\097\098\108\101\100", 3))
        if enabled and enabled:IsA("\066\111\111\108\086\097\108\117\101") and not S.closed
            and Me.Character == character then
            ExtraUI.macroEnabled = enabled
            OwnCharacterConnections[#OwnCharacterConnections + 1] =
                enabled:GetPropertyChangedSignal("\086\097\108\117\101"):Connect(function()
                    if S.macroLock and not enabled.Value then
                        task.delay(0.08, function()
                            ExtraUI.ensureMacro(character)
                        end)
                    end
                end)
            ExtraUI.ensureMacro(character)
        end
        local aiming = input and input:WaitForChild("\065\105\109\105\110\103\073\110\112\117\116", 12)
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
            ExtraUI.Notify.emit("\097\110\116\105\083\116\111\109\112", "\065\110\116\105\045\083\116\111\109\112\032\115\116\111\112\112\101\100\058\032\110\101\119\032\099\104\097\114\097\099\116\101\114\032\108\111\097\100\101\100")
        end
    end
    S.antiStompReady = false
    task.spawn(function()
        local hum = character:WaitForChild("\072\117\109\097\110\111\105\100", 6)
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
                ExtraUI.confirmAntiStompReset(character, "\104\117\109\097\110\111\105\100\032\100\105\101\100")
                evaluate()
            end)
            OwnCharacterConnections[#OwnCharacterConnections + 1] = hum.StateChanged:Connect(function(_, state)
                if state == Enum.HumanoidStateType.Dead then
                    ExtraUI.confirmAntiStompReset(character, "\100\101\097\100\032\115\116\097\116\101")
                    evaluate()
                end
            end)
        end
        local effects = character:FindFirstChild("\066\111\100\121\069\102\102\101\099\116\115")
            or character:WaitForChild("\066\111\100\121\069\102\102\101\099\116\115", 6)
        if S.closed or Me.Character ~= character or generation ~= OwnCharacterGeneration then return end
        if effects then
            local watched = {}
            local function watchFlag(value)
                if watched[value] then return end
                local statusFlag = (value.Name == "\075\046\079" or value.Name == "\068\101\097\100")
                    and value:IsA("\066\111\111\108\086\097\108\117\101")
                local dangerValue = value.Name == "\071\114\097\098\098\101\100" and value:IsA("\079\098\106\101\099\116\086\097\108\117\101")
                if not statusFlag and not dangerValue then return end
                watched[value] = true
                OwnCharacterConnections[#OwnCharacterConnections + 1] = value.Changed:Connect(function()
                    if value.Name == "\068\101\097\100" and value.Value then
                        ExtraUI.confirmAntiStompReset(character, "\100\101\097\100\032\102\108\097\103")
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
bind(ExtraUI.MacroBtn.MouseButton1Click:Connect(function()
    S.macroLock = not S.macroLock
    style(ExtraUI.MacroBtn, S.macroLock,
        "\077\065\067\082\079\032\080\069\082\083\073\083\084\058\032\079\078", "\077\065\067\082\079\032\080\069\082\083\073\083\084\058\032\079\070\070")
    if S.macroLock then ExtraUI.ensureMacro(Me.Character) end
    say(S.macroLock and "\077\097\099\114\111\032\112\101\114\115\105\115\116\032\101\110\097\098\108\101\100\046" or "\077\097\099\114\111\032\112\101\114\115\105\115\116\032\100\105\115\097\098\108\101\100\046")
end))

                                                                            
                                                                  
local function downedPlayerBelow(character)
    local lower = character:FindFirstChild("\076\111\119\101\114\084\111\114\115\111")
    local upper = character:FindFirstChild("\085\112\112\101\114\084\111\114\115\111")
    if not lower or not upper then return nil end
    local ignored = {character}
    local blacklisted = Workspace:FindFirstChild("\066\108\097\099\107\108\105\115\116\101\100")
    if blacklisted then ignored[#ignored + 1] = blacklisted end
    local ray = Ray.new(lower.Position, Vector3.new(0, -upper.Size.Y * 4.5, 0))
    local hit = Workspace:FindPartOnRayWithIgnoreList(ray, ignored)
    local node = hit
    while node and node ~= Workspace do
        if node:IsA("\077\111\100\101\108") and node ~= character then
            local victimPlayer = Players:FindFirstChild(node.Name)
            local hum = node:FindFirstChildOfClass("\072\117\109\097\110\111\105\100")
            local effects = node:FindFirstChild("\066\111\100\121\069\102\102\101\099\116\115")
            local ko = effects and effects:FindFirstChild("\075\046\079")
            local dead = effects and effects:FindFirstChild("\068\101\097\100")
            local knocked = ko and ko:IsA("\066\111\111\108\086\097\108\117\101") and ko.Value
            local finished = dead and dead:IsA("\066\111\111\108\086\097\108\117\101") and dead.Value
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
    if not character or not character:FindFirstChild("\070\085\076\076\089\095\076\079\065\068\069\068\095\067\072\065\082")
        or character:FindFirstChildOfClass("\070\111\114\099\101\070\105\101\108\100")
        or character:FindFirstChild("\071\082\065\066\066\073\078\071\095\067\079\078\083\084\082\065\073\078\084") then return end
    local effects = character:FindFirstChild("\066\111\100\121\069\102\102\101\099\116\115")
    local ownKO = effects and effects:FindFirstChild("\075\046\079")
    local grabbed = effects and effects:FindFirstChild("\071\114\097\098\098\101\100")
    local firing = effects and effects:FindFirstChild("\071\117\110\070\105\114\105\110\103")
    local backpack = Me:FindFirstChildOfClass("\066\097\099\107\112\097\099\107")
    if not effects or (ownKO and ownKO.Value)
        or (grabbed and grabbed.Value ~= nil)
        or (firing and firing.Value)
        or (backpack and backpack:FindFirstChild("\070\108\121")) then return end

    local victim = expectedModel or downedPlayerBelow(character)
    if not victim then return end

    local lower = character:FindFirstChild("\076\111\119\101\114\084\111\114\115\111")
    local victimLower = victim:FindFirstChild("\076\111\119\101\114\084\111\114\115\111")
    local victimHumanoid = victim:FindFirstChildOfClass("\072\117\109\097\110\111\105\100")
    if not lower or not victimLower or not victimHumanoid
        or (victimLower.Position - lower.Position).Magnitude > 8 then return end

    local storage = ReplicatedStorage:FindFirstChild("\083\116\111\114\097\103\101")
    local remotes = storage and storage:FindFirstChild("\082\101\109\111\116\101\115")
    local main = remotes and remotes:FindFirstChild("\077\097\105\110")
    local animations = storage and storage:FindFirstChild("\065\110\105\109\097\116\105\111\110\115")
    local stompAnimation = animations and animations:FindFirstChild("\083\116\111\109\112")
    local handler = game:GetService("\082\101\112\108\105\099\097\116\101\100\070\105\114\115\116"):FindFirstChild("\072\097\110\100\108\101\114")
    local infoModule = handler and handler:FindFirstChild("\073\110\102\111")
    local humanoid = character:FindFirstChildOfClass("\072\117\109\097\110\111\105\100")
    local animator = humanoid and humanoid:FindFirstChildOfClass("\065\110\105\109\097\116\111\114")
    if not main or not main:IsA("\082\101\109\111\116\101\069\118\101\110\116") or not stompAnimation
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
    local victimEffects = victim:FindFirstChild("\066\111\100\121\069\102\102\101\099\116\115")
    local victimKO = victimEffects and victimEffects:FindFirstChild("\075\046\079")
    local victimDead = victimEffects and victimEffects:FindFirstChild("\068\101\097\100")
    local stillStompable = (victimKO and victimKO.Value)
        or (victimDead and victimDead.Value) or victimHumanoid.Health <= 0
    if S.closed or S.stompSuppressed or not (S.autoStomp or allowSelected)
        or Me.Character ~= character
        or not victimHumanoid.Parent or not stillStompable then return end
    main:FireServer("\083\116\111\109\112\082\101\109\111\116\101", AutoStompTrack, effects, victimHumanoid, proof)
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
                style(AutoStompBtn, false, "\065\085\084\079\032\083\084\079\077\080\058\032\079\078", "\065\085\084\079\032\083\084\079\077\080\058\032\079\070\070")
                say("\065\117\116\111\032\115\116\111\109\112\032\115\116\111\112\112\101\100\032\097\102\116\101\114\032\097\032\114\097\121\099\097\115\116\032\111\114\032\114\101\109\111\116\101\032\101\114\114\111\114\046")
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
        ExtraUI.Notify.emit("\111\119\110\082\101\115\112\097\119\110", "\089\111\117\032\114\101\115\112\097\119\110\101\100")
    end
    ExtraUI.Notify.previousOwnCharacter = character
                                                                            
    task.delay(0.25, function() if not S.closed then updateOwnRoot() end end)
    watchOwnCharacter(character)
    ExtraUI.runSpawnSequence(character)
end))
bind(Me.CharacterRemoving:Connect(function(character)
    if S.resetCharacter == character then
        ExtraUI.confirmAntiStompReset(character, "\099\104\097\114\097\099\116\101\114\032\114\101\109\111\118\101\100")
    end
    local hum = character:FindFirstChildOfClass("\072\117\109\097\110\111\105\100")
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
    local root = character and character:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116")
    local hum = character and character:FindFirstChildOfClass("\072\117\109\097\110\111\105\100")
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
    if not model or not model:IsA("\077\111\100\101\108") or not model:IsDescendantOf(Workspace) then return nil end
    local hum = model:FindFirstChildOfClass("\072\117\109\097\110\111\105\100")
    local root = model:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116", true)
    if not hum or not root or not root:IsA("\066\097\115\101\080\097\114\116") then return nil end
    return {
        model = model, humanoid = hum, root = root,
        head = model:FindFirstChild("\072\101\097\100", true),
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
    local effects = rec.model:FindFirstChild("\066\111\100\121\069\102\102\101\099\116\115")
    local ko = effects and effects:FindFirstChild("\075\046\079")
    local dead = effects and effects:FindFirstChild("\068\101\097\100")
    return not ((ko and ko.Value) or (dead and dead.Value))
end
local function partFor(rec)
    if S.head and rec.head and rec.head.Parent and rec.head:IsA("\066\097\115\101\080\097\114\116") then return rec.head end
    return rec.root
end
local function predictedPoint(rec, part, lead)
                                                                                          
    return part.Position + rec.root.AssemblyLinearVelocity * lead
end
local function isFolder(parent)
    if not (parent:IsA("\070\111\108\100\101\114") or parent:IsA("\077\111\100\101\108")) then return false end
    local name = parent.Name
    return name == "\080\108\097\121\101\114\115" or name == "\067\104\097\114\097\099\116\101\114\115" or name == "\076\105\118\101"
        or name == "\069\110\116\105\116\105\101\115" or (#name >= 30 and name:find("\037\045") ~= nil)
end
local function candidateNamed(parent, player)
    if not parent or not player then return nil end
    return parent:FindFirstChild(player.Name)
        or parent:FindFirstChild(tostring(player.UserId))
end

if type(Env.__SPECTRA_MULTI_RAYCAST) == "\116\097\098\108\101" then
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
    local handle = tool and tool:FindFirstChild("\072\097\110\100\108\101")
    if not handle or not handle:IsA("\066\097\115\101\080\097\114\116") then return nil end
    local origin = handle.Position
    local gui = handle:FindFirstChild("\083\104\111\111\116\070\088\071\117\105")
    if gui and gui:IsA("\066\105\108\108\098\111\097\114\100\071\117\105") then
        origin = origin + handle.CFrame:VectorToWorldSpace(gui.StudsOffsetWorldSpace)
    end
    return origin
end

Hook.getBulletDirection = function()
    local character = Me.Character
    local root = character and character:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116")
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
    if typeof(origin) ~= "\086\101\099\116\111\114\051" or typeof(point) ~= "\086\101\099\116\111\114\051" then
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
                            if body:IsA("\066\097\115\101\080\097\114\116") and body ~= rec.root then
                                                                                 
                                                                                    
                                                           
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
    Silent.Text = "\083\073\076\069\078\084\032\065\073\077\058\032\088\069\078\079\032\085\078\083\085\080\080\079\082\084\069\068"
    ForceHitBtn.Text = "\070\079\082\067\069\032\072\073\084\058\032\088\069\078\079\032\085\078\083\085\080\080\079\082\084\069\068"
    WallBangBtn.Text = "\087\065\076\076\066\065\078\071\058\032\088\069\078\079\032\085\078\083\085\080\080\079\082\084\069\068"
    ExtraUI.InfiniteRangeBtn.Text = "\073\078\070\073\078\073\084\069\032\082\065\078\071\069\058\032\088\069\078\079\032\085\078\083\085\080\080\079\082\084\069\068"
    ExtraUI.BulletModeBtn.Text = "\066\085\076\076\069\084\032\068\073\082\069\067\084\073\079\078\058\032\088\069\078\079\032\085\078\083\085\080\080\079\082\084\069\068"
    AutoKillBtn.Text = "\065\085\084\079\032\075\073\076\076\058\032\088\069\078\079\032\085\078\083\085\080\080\079\082\084\069\068"
    Bring.Text = "\066\082\073\078\071\058\032\088\069\078\079\032\085\078\083\085\080\080\079\082\084\069\068"
    ExtraUI.AuraBtn.Text = "\065\085\082\065\058\032\088\069\078\079\032\085\078\083\085\080\080\079\082\084\069\068"
    ExtraUI.GunModButtons.spread.Text = "\068\066\032\078\079\032\083\080\082\069\065\068\058\032\088\069\078\079\032\085\078\083\085\080\080\079\082\084\069\068"
    ExtraUI.WallBangInfo.Text = "\071\085\078\032\077\065\078\065\071\069\082\032\085\078\065\086\065\073\076\065\066\076\069\058\032" .. tostring(reason)
end

local function installRaycastHook()
    if ExtraUI.Capabilities.gunManager == false then
        return false, "\088\101\110\111\032\099\097\110\110\111\116\032\097\099\099\101\115\115\032\116\104\105\115\032\103\097\109\101\039\115\032\071\117\110\077\097\110\097\103\101\114\046"
    end
    if Hook.installed and Hook.manager and Hook.manager.Raycast == Hook.wrapper then return true end
    local storage = ReplicatedStorage:FindFirstChild("\083\116\111\114\097\103\101")
    local modules = storage and storage:FindFirstChild("\077\111\100\117\108\101\115")
    local dialect = modules and modules:FindFirstChild("\068\105\097\108\101\099\116")
    local module = dialect and dialect:FindFirstChild("\071\117\110\077\097\110\097\103\101\114")
    if not module then
        module = ReplicatedStorage:FindFirstChild("\071\117\110\077\097\110\097\103\101\114", true)
    end
    if not module and dialect then
        module = dialect:WaitForChild("\071\117\110\077\097\110\097\103\101\114", 5)
    end
    if not module or not module:IsA("\077\111\100\117\108\101\083\099\114\105\112\116") then
        ExtraUI.disableGunManagerFeatures("\109\111\100\117\108\101\032\110\111\116\032\102\111\117\110\100")
        return false, "\071\117\110\077\097\110\097\103\101\114\032\099\111\117\108\100\032\110\111\116\032\098\101\032\102\111\117\110\100\032\105\110\032\116\104\105\115\032\099\108\105\101\110\116\046"
    end
    local ok, manager = pcall(require, module)
    if not ok or type(manager) ~= "\116\097\098\108\101" or type(manager.Raycast) ~= "\102\117\110\099\116\105\111\110" then
        ExtraUI.disableGunManagerFeatures("\109\111\100\117\108\101\032\114\101\113\117\105\114\101\032\102\097\105\108\101\100")
        return false, "\067\111\117\108\100\032\110\111\116\032\097\099\099\101\115\115\032\116\104\105\115\032\103\097\109\101\039\115\032\103\117\110\032\114\097\121\099\097\115\116\046"
    end
    local original = manager.Raycast
    local function redirect(self, tool, mousePoint, player, range, ...)
        local ownGun = self == manager and player == Me and tool
            and tool:IsA("\084\111\111\108") and tool.Parent == Me.Character
        local shotRange = ownGun and S.infiniteRange and 15000 or range
        if ownGun and S.aura and not Hook.auraTarget then
            return original(self, tool, mousePoint, player, shotRange, ...)
        end
        if ownGun
            and (Hook.enabled or S.autoKill or S.aura or S.forceHit or S.wallBang or S.infiniteRange
                or S.silent or S.bulletMode ~= 1) then
            local maxRange = typeof(shotRange) == "\110\117\109\098\101\114"
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
                    or Me.Character and Me.Character:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116"))
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
                    ExtraUI.WallBangInfo.Text = "\087\066\032\067\076\073\069\078\084\032\072\073\084\058\032\064" .. victim.Name
                        .. "\032\040\115\101\114\118\101\114\032\100\097\109\097\103\101\032\110\111\116\032\103\117\097\114\097\110\116\101\101\100\041"
                    return hit
                end
                if os.clock() - (Hook.lastWallStatus or 0) > 0.35 then
                    Hook.lastWallStatus = os.clock()
                    ExtraUI.WallBangInfo.Text = ("\087\066\032\083\072\079\084\083\058\032\037\100\032\124\032\110\111\032\114\105\103\032\111\110\032\115\104\111\116\032\108\105\110\101")
                        :format(Hook.wallShots)
                end
                                                                                
                                                                                   
            end
        end
        return original(self, tool, mousePoint, player, shotRange, ...)
    end
    local assigned = pcall(function() manager.Raycast = redirect end)
    if not assigned or manager.Raycast ~= redirect then
        ExtraUI.disableGunManagerFeatures("\082\097\121\099\097\115\116\032\099\097\110\110\111\116\032\098\101\032\114\101\112\108\097\099\101\100")
        return false, "\067\111\117\108\100\032\110\111\116\032\105\110\115\116\097\108\108\032\116\104\101\032\103\117\110\045\115\112\101\099\105\102\105\099\032\097\105\109\032\112\097\116\104\046"
    end
    Hook.manager, Hook.original, Hook.wrapper = manager, original, redirect
    Hook.installed = true
    if type(manager.ReconcileDamageBatch) == "\102\117\110\099\116\105\111\110" then
        local damageOriginal = manager.ReconcileDamageBatch
        local function readServerHit(self, predictions, response, ...)
            if self == manager and type(predictions) == "\116\097\098\108\101" then
                local first = predictions[1]
                local state = first and first.State
                if state and typeof(response) == "\116\097\098\108\101"
                    and typeof(response.Health) == "\110\117\109\098\101\114"
                    and typeof(response.Revision) == "\110\117\109\098\101\114"
                    and response.Revision >= (state.Revision or -math.huge) then
                    local oldHealth = state.ServerHealth or response.Health
                    local oldArmor = state.ServerArmor or response.Armor or 0
                    local newArmor = typeof(response.Armor) == "\110\117\109\098\101\114"
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
                    local name = victim and victim.Name or "\116\097\114\103\101\116"
                    ExtraUI.ServerHit.Text = ("\083\069\082\086\069\082\032\072\073\084\058\032\037\115\032\032\072\032\045\037\046\049\102\032\032\065\032\045\037\046\049\102")
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
    if ActiveLabel.Text ~= "\065\105\109\032\116\097\114\103\101\116\058\032\110\111\110\101" then ActiveLabel.Text = "\065\105\109\032\116\097\114\103\101\116\058\032\110\111\110\101" end
end
local function stopBring()
    if S.bring then
        for part, oldAnchored in pairs(S.bring) do
            if part.Parent then pcall(function() part.Anchored = oldAnchored end) end
        end
        S.bring = nil
    end
    style(Bring, false, "\066\082\073\078\071\032\083\069\076\069\067\084\069\068\058\032\079\078", "\066\082\073\078\071\032\083\069\076\069\067\084\069\068")
end
local function syncLabels()
    local count = #TargetList
    SelectedLabel.Text = ("\084\097\114\103\101\116\115\058\032\037\100\032\115\101\108\101\099\116\101\100\032\032\124\032\032\076\097\115\116\058\032\037\115"):format(count,
        S.primary and ("\064" .. S.primary.Name) or "\110\111\110\101")
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
        say("\070\080\083\032\103\117\097\114\100\058\032\109\097\120\105\109\117\109\032" .. MAX_TARGETS .. "\032\115\101\108\101\099\116\101\100\032\112\108\097\121\101\114\115\046")
        return false
    end
    TargetSet[p] = true
    ExtraUI.Notify.emit("\115\101\108\101\099\116\101\100", "\064" .. p.Name .. "\032\115\101\108\101\099\116\101\100")
    TargetList[#TargetList + 1] = p
    TargetByModelName[p.Name] = p
    TargetByModelName[tostring(p.UserId)] = p
    local cs = {
        p.CharacterAdded:Connect(function(character)
            if ExtraUI.Notify.knownModels[p]
                and ExtraUI.Notify.knownModels[p] ~= character
                and os.clock() - (ExtraUI.Notify.lastRespawnAt[p] or -math.huge) > 1.3 then
                ExtraUI.Notify.lastRespawnAt[p] = os.clock()
                ExtraUI.Notify.emit("\114\101\115\112\097\119\110\101\100", "\064" .. p.Name .. "\032\114\101\115\112\097\119\110\101\100")
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
    say(#TargetList > 0 and ("\067\104\101\099\107\105\110\103\032\111\110\108\121\032" .. #TargetList .. "\032\115\101\108\101\099\116\101\100\032\087\111\114\107\115\112\097\099\101\032\109\111\100\101\108\040\115\041\046")
        or "\073\100\108\101\058\032\099\104\111\111\115\101\032\097\032\112\108\097\121\101\114\059\032\110\111\032\099\104\097\114\097\099\116\101\114\032\099\104\101\099\107\115\032\097\099\116\105\118\101\046")
end

ExtraUI.Picking = false
local function pickNearCursor()
    local cam = Workspace.CurrentCamera
    if not cam then say("\067\117\114\115\111\114\032\112\105\099\107\058\032\099\097\109\101\114\097\032\117\110\097\118\097\105\108\097\098\108\101\046"); return end
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
        say("\067\117\114\115\111\114\032\112\105\099\107\058\032\110\111\032\108\105\118\105\110\103\032\112\108\097\121\101\114\032\119\105\116\104\105\110\032" .. radius .. "\112\120\046")
        return
    end
    if bestPlayer.Parent ~= Players or not bestRecord.model.Parent then return end
    if TargetSet[bestPlayer] then
        deselectPlayer(bestPlayer)
        syncLabels()
        updateLoops()
        say("\067\117\114\115\111\114\032\112\105\099\107\058\032\064" .. bestPlayer.Name .. "\032\117\110\115\101\108\101\099\116\101\100\046")
        return
    end
                                                                                
    if not S.dot then
        S.dot = true
        style(DotBtn, true, "\066\079\088\032\043\032\076\073\078\069\058\032\079\078", "\066\079\088\032\043\032\076\073\078\069\058\032\079\070\070")
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
    say("\067\117\114\115\111\114\032\112\105\099\107\058\032\064" .. bestPlayer.Name .. "\032\115\101\108\101\099\116\101\100\046")
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
    local row = round(make("\084\101\120\116\066\117\116\116\111\110", {
        Parent = List, Name = p.Name, Size = UDim2.new(1, -2, 0, 29),
        Text = "\032\032" .. p.DisplayName .. "\032\040\064" .. p.Name .. "\041",
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
bind(Search:GetPropertyChangedSignal("\084\101\120\116"):Connect(filterRows))

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
        local blacklisted = Workspace:FindFirstChild("\066\108\097\099\107\108\105\115\116\101\100")
        if blacklisted then ignored[#ignored + 1] = blacklisted end
        ExtraUI.WallParams.FilterDescendantsInstances = ignored
    end
    local origin = cam.CFrame.Position
    if S.silent and ownModel then
        local tool = ownModel:FindFirstChildOfClass("\084\111\111\108")
        local handle = tool and tool:FindFirstChild("\072\097\110\100\108\101")
        local fx = handle and handle:FindFirstChild("\083\104\111\111\116\070\088\071\117\105")
        if handle and handle:IsA("\066\097\115\101\080\097\114\116") and fx and fx:IsA("\066\105\108\108\098\111\097\114\100\071\117\105") then
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
        ActiveLabel.Text = ("\077\117\108\116\105\032\097\105\109\058\032\037\100\032\115\101\108\101\099\116\101\100\059\032\099\121\099\108\105\110\103\032\112\101\114\032\115\104\111\116"):format(#TargetList)
    elseif S.aimPlayer ~= p then
        ActiveLabel.Text = "\065\105\109\032\116\097\114\103\101\116\058\032\064" .. p.Name
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
    if type(mouse1click) == "\102\117\110\099\116\105\111\110" then return pcall(mouse1click) end
    if type(mouse1press) == "\102\117\110\099\116\105\111\110" and type(mouse1release) == "\102\117\110\099\116\105\111\110" then
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
    local equipped = character and character:FindFirstChildOfClass("\084\111\111\108")
    if equipped and equipped:FindFirstChild("\082\101\115\112\111\110\115\101") then
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
        style(Trigger, false, "\084\082\073\071\071\069\082\058\032\079\078", "\084\082\073\071\071\069\082\058\032\079\070\070")
        say("\084\114\105\103\103\101\114\032\099\108\105\099\107\032\117\110\115\117\112\112\111\114\116\101\100\032\098\121\032\116\104\105\115\032\101\120\101\099\117\116\111\114\046")
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
    style(MultiBtn, true, "\077\085\076\084\073\032\084\065\082\071\069\084\058\032\079\078", "\077\085\076\084\073\032\084\065\082\071\069\084\058\032\079\070\070")
    syncLabels()
    updateLoops()
    say(("\077\117\108\116\105\058\032\037\100\032\115\101\108\101\099\116\101\100\059\032\115\104\111\116\115\032\099\121\099\108\101\032\097\099\114\111\115\115\032\115\101\108\101\099\116\101\100\032\112\108\097\121\101\114\115\046"):format(#TargetList))
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
    style(MultiBtn, false, "\077\085\076\084\073\032\084\065\082\071\069\084\058\032\079\078", "\077\085\076\084\073\032\084\065\082\071\069\084\058\032\079\070\070")
    syncLabels()
    updateLoops()
    say("\083\105\110\103\108\101\045\116\097\114\103\101\116\032\109\111\100\101\032\114\101\115\116\111\114\101\100\046")
end))
bind(AliveBtn.MouseButton1Click:Connect(function()
    S.aliveOnly = not S.aliveOnly
    Hook.aliveOnly = S.aliveOnly
    style(AliveBtn, S.aliveOnly, "\065\076\073\086\069\032\067\072\069\067\075\058\032\079\078", "\065\076\073\086\069\032\067\072\069\067\075\058\032\079\070\070")
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
    style(Silent, S.silent, "\083\073\076\069\078\084\032\065\073\077\058\032\079\078", "\083\073\076\069\078\084\032\065\073\077\058\032\079\070\070")
    updateLoops()
end))
bind(ExtraUI.InfiniteRangeBtn.MouseButton1Click:Connect(function()
    if not S.infiniteRange then
        local ok, reason = installRaycastHook()
        if not ok then say(reason); return end
    end
    S.infiniteRange = not S.infiniteRange
    style(ExtraUI.InfiniteRangeBtn, S.infiniteRange,
        "\073\078\070\073\078\073\084\069\032\082\065\078\071\069\058\032\079\078", "\073\078\070\073\078\073\084\069\032\082\065\078\071\069\058\032\079\070\070")
    say(S.infiniteRange and "\065\108\108\032\071\117\110\077\097\110\097\103\101\114\032\103\117\110\115\032\110\111\119\032\114\097\121\099\097\115\116\032\117\112\032\116\111\032\049\053\044\048\048\048\032\115\116\117\100\115\046"
        or "\078\111\114\109\097\108\032\119\101\097\112\111\110\032\114\097\110\103\101\115\032\114\101\115\116\111\114\101\100\046")
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
        "\065\076\076\045\071\085\078\032\087\065\076\076\066\065\078\071\058\032\079\078", "\065\076\076\045\071\085\078\032\087\065\076\076\066\065\078\071\058\032\079\070\070")
    ExtraUI.WallBangInfo.Text = S.wallBang
        and "\087\066\032\082\069\065\068\089\058\032\102\105\114\101\032\116\111\032\116\101\115\116\032\116\104\101\032\099\108\105\101\110\116\032\104\105\116\032\112\097\116\104" or "\087\065\076\076\066\065\078\071\058\032\079\070\070"
    Hook.wallShots = 0
    updateLoops()
    say(S.wallBang and "\087\097\108\108\098\097\110\103\032\099\111\118\101\114\115\032\101\118\101\114\121\032\103\117\110\032\117\115\105\110\103\032\116\104\101\032\115\104\097\114\101\100\032\071\117\110\077\097\110\097\103\101\114\032\115\104\111\116\032\112\097\116\104\046"
        or "\087\097\108\108\098\097\110\103\032\100\105\115\097\098\108\101\100\046")
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
        "\066\085\076\076\069\084\032\068\073\082\069\067\084\073\079\078\058\032" .. ExtraUI.BulletModeNames[nextMode],
        "\066\085\076\076\069\084\032\068\073\082\069\067\084\073\079\078\058\032\067\085\082\083\079\082")
    say(nextMode == 1 and "\066\117\108\108\101\116\032\100\105\114\101\099\116\105\111\110\032\102\111\108\108\111\119\115\032\099\117\114\115\111\114\032\097\103\097\105\110\046"
        or "\066\117\108\108\101\116\032\100\105\114\101\099\116\105\111\110\058\032" .. ExtraUI.BulletModeNames[nextMode]
            .. "\032\040\111\110\101\032\114\097\100\105\097\108\032\100\105\114\101\099\116\105\111\110\032\112\101\114\032\115\104\111\116\059\032\099\097\109\101\114\097\032\117\110\099\104\097\110\103\101\100\041\046")
end))
bind(ForceHitBtn.MouseButton1Click:Connect(function()
    if not S.forceHit then
        local ok, reason = installRaycastHook()
        if not ok then say(reason); return end
        if not S.primary then say("\083\101\108\101\099\116\032\097\032\112\108\097\121\101\114\032\111\110\032\084\065\082\071\069\084\083\032\102\105\114\115\116\046"); return end
        if not recordPresent(S.primary, Records[S.primary]) then
            requestResolution(S.primary)
            say("\070\111\114\099\101\032\104\105\116\058\032\114\101\115\111\108\118\105\110\103\032\115\101\108\101\099\116\101\100\032\112\108\097\121\101\114\039\115\032\108\105\118\101\032\114\105\103\059\032\116\114\121\032\097\103\097\105\110\032\115\104\111\114\116\108\121\046")
            return
        end
    end
    S.forceHit = not S.forceHit
    style(ForceHitBtn, S.forceHit, "\070\079\082\067\069\032\072\073\084\058\032\079\078", "\070\079\082\067\069\032\072\073\084\058\032\079\070\070")
    updateLoops()
    say(S.forceHit and "\070\111\114\099\101\032\104\105\116\032\116\097\114\103\101\116\115\032\116\104\101\032\115\101\108\101\099\116\101\100\032\112\108\097\121\101\114\032\097\116\032\097\110\121\032\099\108\105\101\110\116\032\100\105\115\116\097\110\099\101\046"
        or "\070\111\114\099\101\032\104\105\116\032\100\105\115\097\098\108\101\100\046")
end))
bind(ExtraUI.QuietKillBtn.MouseButton1Click:Connect(function()
    S.quietAutoKill = not S.quietAutoKill
    style(ExtraUI.QuietKillBtn, S.quietAutoKill,
        "\081\085\073\069\084\032\065\085\084\079\032\075\073\076\076\058\032\079\078", "\081\085\073\069\084\032\065\085\084\079\032\075\073\076\076\058\032\079\070\070")
    say(S.quietAutoKill and "\065\117\116\111\032\107\105\108\108\032\102\105\114\101\115\032\102\114\111\109\032\121\111\117\114\032\099\117\114\114\101\110\116\032\112\111\115\105\116\105\111\110\046"
        or "\065\117\116\111\032\107\105\108\108\032\115\116\114\097\102\105\110\103\032\101\110\097\098\108\101\100\046")
end))
bind(Trigger.MouseButton1Click:Connect(function()
    S.trigger = not S.trigger
    style(Trigger, S.trigger, "\084\082\073\071\071\069\082\058\032\079\078", "\084\082\073\071\071\069\082\058\032\079\070\070")
    updateLoops()
    if S.trigger and not ExtraUI.Capabilities.mouseClick then
        say("\084\114\105\103\103\101\114\032\117\115\101\115\032\101\113\117\105\112\112\101\100\032\103\117\110\032\097\099\116\105\118\097\116\105\111\110\032\111\110\032\116\104\105\115\032\101\120\101\099\117\116\111\114\046")
    end
end))
bind(CameraBtn.MouseButton1Click:Connect(function()
    S.cameraAim = not S.cameraAim
    style(CameraBtn, S.cameraAim, "\067\065\077\069\082\065\032\065\073\077\058\032\079\078", "\067\065\077\069\082\065\032\065\073\077\058\032\079\070\070")
    updateLoops()
end))
bind(DotBtn.MouseButton1Click:Connect(function()
    S.dot = not S.dot
    style(DotBtn, S.dot, "\066\079\088\032\043\032\076\073\078\069\058\032\079\078", "\066\079\088\032\043\032\076\073\078\069\058\032\079\070\070")
    updateLoops()
end))
bind(Hitbox.MouseButton1Click:Connect(function()
    S.head = not S.head
    Hitbox.Text = S.head and "\072\073\084\066\079\088\058\032\072\069\065\068" or "\072\073\084\066\079\088\058\032\066\079\068\089"
    if S.silent or S.trigger or S.dot or S.cameraAim then targetTick() end
end))
bind(Wall.MouseButton1Click:Connect(function()
    S.wall = not S.wall
    style(Wall, S.wall, "\087\065\076\076\032\067\072\069\067\075\058\032\079\078", "\087\065\076\076\032\067\072\069\067\075\058\032\079\070\070")
    if S.silent or S.trigger or S.dot or S.cameraAim then targetTick() end
end))
bind(CursorToggle.MouseButton1Click:Connect(function()
    S.cursorKeyEnabled = not S.cursorKeyEnabled
    style(CursorToggle, S.cursorKeyEnabled, "\067\085\082\083\079\082\032\080\073\067\075\058\032\079\078", "\067\085\082\083\079\082\032\080\073\067\075\058\032\079\070\070")
    say(S.cursorKeyEnabled and "\067\117\114\115\111\114\032\115\101\108\101\099\116\105\111\110\032\101\110\097\098\108\101\100\046\032\080\114\101\115\115\032\081\032\110\101\097\114\032\097\032\112\108\097\121\101\114\046"
        or "\067\117\114\115\111\114\032\115\101\108\101\099\116\105\111\110\032\100\105\115\097\098\108\101\100\046")
end))
local function startCursorPick()
    if not S.cursorKeyEnabled or ExtraUI.Picking then return end
    ExtraUI.Picking = true
    task.spawn(function()
        local ok = pcall(pickNearCursor)
        ExtraUI.Picking = false
        if not ok and not S.closed then say("\067\117\114\115\111\114\032\112\105\099\107\032\102\097\105\108\101\100\059\032\116\114\121\032\082\101\102\114\101\115\104\032\084\097\114\103\101\116\115\046") end
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
    LeadText.Text = ("\080\082\069\068\073\067\084\073\079\078\058\032\037\100\032\109\115"):format(math.floor(S.lead * 1000 + .5))
    Hook.lead = S.lead
end
bind(Minus.MouseButton1Click:Connect(function() setLead(S.lead - .005) end))
bind(Plus.MouseButton1Click:Connect(function() setLead(S.lead + .005) end))
bind(Refresh.MouseButton1Click:Connect(function()
    for i = 1, #TargetList do requestResolution(TargetList[i]) end
    say("\079\110\101\045\111\102\102\032\087\111\114\107\115\112\097\099\101\032\114\101\102\114\101\115\104\032\102\111\114\032" .. #TargetList .. "\032\115\101\108\101\099\116\101\100\032\112\108\097\121\101\114\040\115\041\046")
end))
bind(AutoArmor.MouseButton1Click:Connect(function()
    if not ExtraUI.Capabilities.shopPurchase then
        say("\088\101\110\111\058\032\097\117\116\111\109\097\116\101\100\032\115\104\111\112\032\112\117\114\099\104\097\115\101\115\032\097\114\101\032\117\110\097\118\097\105\108\097\098\108\101\032\105\110\032\116\104\105\115\032\098\117\105\108\100\046")
        return
    end
    S.autoArmor = not S.autoArmor
    S.armorGeneration = S.armorGeneration + 1
    style(AutoArmor, S.autoArmor, "\065\085\084\079\032\065\082\077\079\082\032\079\078\032\082\069\083\080\065\087\078\058\032\079\078", "\065\085\084\079\032\065\082\077\079\082\032\079\078\032\082\069\083\080\065\087\078\058\032\079\070\070")
    if S.autoArmor then
        say("\065\117\116\111\032\097\114\109\111\114\032\101\110\097\098\108\101\100\059\032\105\116\032\119\105\108\108\032\099\111\108\108\101\099\116\032\111\110\099\101\032\097\102\116\101\114\032\101\097\099\104\032\114\101\115\112\097\119\110\046")
        if Me.Character then task.spawn(buyAutoItems, Me.Character) end
    else
        say("\065\117\116\111\032\097\114\109\111\114\032\100\105\115\097\098\108\101\100\046")
    end
end))
bind(AntiStompBtn.MouseButton1Click:Connect(function()
    S.antiStomp = not S.antiStomp
    style(AntiStompBtn, S.antiStomp, "\065\078\084\073\032\083\084\079\077\080\058\032\079\078", "\065\078\084\073\032\083\084\079\077\080\058\032\079\070\070")
    if S.antiStomp then
        say("\065\110\116\105\032\115\116\111\109\112\032\097\114\109\101\100\058\032\114\101\115\101\116\032\114\101\116\114\105\101\115\032\115\116\111\112\032\111\110\032\099\111\110\102\105\114\109\101\100\032\100\101\097\116\104\032\111\114\032\114\101\115\112\097\119\110\046")
        resetBeforeStomp(Me.Character, ownDangerReason(Me.Character))
    else
                                                                                
        S.resetGeneration = S.resetGeneration + 1
        S.resetCharacter = nil
        S.resetInFlight = false
        S.antiStompReady = false
        say("\065\110\116\105\032\115\116\111\109\112\032\100\105\115\097\098\108\101\100\059\032\112\101\110\100\105\110\103\032\114\101\116\114\105\101\115\032\099\097\110\099\101\108\108\101\100\046")
    end
end))
bind(ResetThresholdBtn.MouseButton1Click:Connect(function()
    S.resetThresholdIndex = S.resetThresholdIndex % #ResetThresholds + 1
    ResetThresholdBtn.Text = "\082\069\083\069\084\032\065\084\058\032" .. ResetThresholds[S.resetThresholdIndex] .. "\032\072\080"
    resetBeforeStomp(Me.Character, ownDangerReason(Me.Character))
end))
bind(AutoStompBtn.MouseButton1Click:Connect(function()
    if S.aura then
        say("\065\117\116\111\032\115\116\111\109\112\032\115\116\097\121\115\032\112\097\117\115\101\100\032\119\104\105\108\101\032\065\117\114\097\032\105\115\032\097\099\116\105\118\101\046")
        return
    end
    if S.bringStompRestore ~= nil then
        S.bringStompRestore = not S.bringStompRestore
        S.stompSuppressed = true
        say(S.bringStompRestore and "\065\117\116\111\032\115\116\111\109\112\032\119\105\108\108\032\114\101\115\117\109\101\032\097\102\116\101\114\032\066\114\105\110\103\046"
            or "\065\117\116\111\032\115\116\111\109\112\032\119\105\108\108\032\115\116\097\121\032\111\102\102\032\097\102\116\101\114\032\066\114\105\110\103\059\032\097\108\108\032\115\099\114\105\112\116\101\100\032\115\116\111\109\112\115\032\115\116\111\112\112\101\100\046")
        return
    end
    S.autoStomp = not S.autoStomp
    S.stompSuppressed = not S.autoStomp
    style(AutoStompBtn, S.autoStomp, "\065\085\084\079\032\083\084\079\077\080\058\032\079\078", "\065\085\084\079\032\083\084\079\077\080\058\032\079\070\070")
    updateAutoStomp()
    say(S.autoStomp and "\065\117\116\111\032\115\116\111\109\112\058\032\114\101\112\101\097\116\115\032\083\116\111\109\112\082\101\109\111\116\101\032\111\118\101\114\032\075\046\079\032\111\114\032\100\101\097\100\032\098\111\100\105\101\115\046"
        or "\065\117\116\111\032\115\116\111\109\112\032\100\105\115\097\098\108\101\100\059\032\115\101\108\101\099\116\101\100\032\097\110\100\032\097\117\116\111\045\107\105\108\108\032\115\116\111\109\112\115\032\097\114\101\032\112\097\117\115\101\100\032\116\111\111\046")
end))
bind(ExtraUI.StompAnimationBtn.MouseButton1Click:Connect(function()
    S.stompAnimationEnabled = not S.stompAnimationEnabled
    style(ExtraUI.StompAnimationBtn, S.stompAnimationEnabled,
        "\083\084\079\077\080\032\065\078\073\077\065\084\073\079\078\058\032\079\078", "\083\084\079\077\080\032\065\078\073\077\065\084\073\079\078\058\032\079\070\070")
    if not S.stompAnimationEnabled and AutoStompTrack then
        pcall(function() AutoStompTrack:Stop(0) end)
    end
    say(S.stompAnimationEnabled and "\083\116\111\109\112\032\097\110\105\109\097\116\105\111\110\032\101\110\097\098\108\101\100\046"
        or "\083\116\111\109\112\032\097\110\105\109\097\116\105\111\110\032\104\105\100\100\101\110\032\108\111\099\097\108\108\121\059\032\114\101\109\111\116\101\032\115\116\105\108\108\032\114\101\099\101\105\118\101\115\032\105\116\115\032\116\114\097\099\107\046")
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
    return character and (character:FindFirstChild("\082\105\103\104\116\032\076\101\103")
        or character:FindFirstChild("\082\105\103\104\116\076\111\119\101\114\076\101\103")
        or character:FindFirstChild("\082\105\103\104\116\070\111\111\116"))
end
ExtraUI.pinSelectedStompModel = function(model)
    local character = Me.Character
    local leg = ExtraUI.selectedStompRightLeg(character)
    if not leg or not leg:IsA("\066\097\115\101\080\097\114\116") or not model.Parent then return end
    local targetLower = model:FindFirstChild("\076\111\119\101\114\084\111\114\115\111")
    if not targetLower then return end
    local desiredLower = leg.CFrame * CFrame.new(0,
        -(leg.Size.Y + targetLower.Size.Y) * 0.5, 0)
    local pivotOffset = targetLower.CFrame:ToObjectSpace(model:GetPivot())
    for part in pairs(S.selectedStompAnchors or {}) do
        if part.Parent then part.Anchored = true end
    end
    model:PivotTo(desiredLower * pivotOffset)
    local root = model:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116")
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
        style(SelectedStompBtn, false, "\083\069\076\069\067\084\069\068\032\083\084\079\077\080\058\032\079\078", "\083\069\076\069\067\084\069\068\032\083\084\079\077\080\058\032\079\070\070")
        say("\083\101\108\101\099\116\101\100\032\115\116\111\109\112\032\100\105\115\097\098\108\101\100\046")
        return
    end
    local target = S.primary
    local rec = target and Records[target]
    if not recordPresent(target, rec) then
        say("\083\101\108\101\099\116\032\097\032\112\108\097\121\101\114\032\111\110\032\084\065\082\071\069\084\083\032\102\105\114\115\116\046")
        return
    end
    S.selectedStomp = true
    S.selectedStompTarget = target
    S.selectedStompGeneration = S.selectedStompGeneration + 1
    local generation = S.selectedStompGeneration
    style(SelectedStompBtn, true, "\083\069\076\069\067\084\069\068\032\083\084\079\077\080\058\032\079\078", "\083\069\076\069\067\084\069\068\032\083\084\079\077\080\058\032\079\070\070")
    say("\083\101\108\101\099\116\101\100\032\115\116\111\109\112\032\119\097\116\099\104\105\110\103\032\064" .. target.Name .. "\032\102\114\111\109\032\121\111\117\114\032\112\111\115\105\116\105\111\110\046")
    task.spawn(function()
        local ownershipModel = nil
        while not S.closed and S.selectedStomp
            and generation == S.selectedStompGeneration do
            rec = Records[target]
            if not recordPresent(target, rec) then
                S.selectedStomp = false
                S.selectedStompTarget = nil
                releaseSelectedStompPin()
                style(SelectedStompBtn, false, "\083\069\076\069\067\084\069\068\032\083\084\079\077\080\058\032\079\078", "\083\069\076\069\067\084\069\068\032\083\084\079\077\080\058\032\079\070\070")
                say("\083\101\108\101\099\116\101\100\032\115\116\111\109\112\032\115\116\111\112\112\101\100\058\032\116\097\114\103\101\116\032\108\101\102\116\046")
                break
            end
            local effects = rec.model:FindFirstChild("\066\111\100\121\069\102\102\101\099\116\115")
            local ko = effects and effects:FindFirstChild("\075\046\079")
            local dead = effects and effects:FindFirstChild("\068\101\097\100")
            local downed = rec.humanoid.Health <= 0 or (ko and ko.Value)
                or (dead and dead.Value)
            if downed and not S.stompSuppressed
                and S.bringStompRestore == nil and not S.autoKill
                and not S.resetInFlight then
                local character = Me.Character
                local rightLeg = ExtraUI.selectedStompRightLeg(character)
                local targetLower = rec.model:FindFirstChild("\076\111\119\101\114\084\111\114\115\111")
                local hum = character and character:FindFirstChildOfClass("\072\117\109\097\110\111\105\100")
                if rightLeg and targetLower and hum and hum.Health > 0 then
                    if S.selectedStompModel ~= rec.model then
                        releaseSelectedStompPin()
                        S.selectedStompModel = rec.model
                        S.selectedStompAnchors = {}
                        for _, part in ipairs(rec.model:GetDescendants()) do
                            if part:IsA("\066\097\115\101\080\097\114\116") then
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
                            say("\082\097\103\100\111\108\108\032\102\111\108\108\111\119\032\105\115\032\108\111\099\097\108\059\032\116\104\101\032\115\101\114\118\101\114\032\109\097\121\032\114\101\106\101\099\116\032\100\105\115\116\097\110\116\032\115\116\111\109\112\115\046")
                        else
                            say("\082\097\103\100\111\108\108\032\112\104\121\115\105\099\115\032\111\119\110\101\100\032\108\111\099\097\108\108\121\059\032\097\116\116\101\109\112\116\105\110\103\032\115\116\111\109\112\032\104\101\114\101\046")
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
    say(name .. (S.autoBuys[name] and "\032\119\105\108\108\032\098\101\032\098\111\117\103\104\116\032\111\110\032\114\101\115\112\097\119\110\046" or "\032\097\117\116\111\032\098\117\121\032\100\105\115\097\098\108\101\100\046"))
end))
bind(AutoBuyNow.MouseButton1Click:Connect(function()
    if not ExtraUI.Capabilities.shopPurchase then return end
    if not Me.Character then say("\078\111\032\099\104\097\114\097\099\116\101\114\032\097\118\097\105\108\097\098\108\101\032\102\111\114\032\115\104\111\112\112\105\110\103\046"); return end
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
    style(AutoStompBtn, S.autoStomp, "\065\085\084\079\032\083\084\079\077\080\058\032\079\078", "\065\085\084\079\032\083\084\079\077\080\058\032\079\070\070")
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
    style(AutoStompBtn, false, "\065\085\084\079\032\083\084\079\077\080\058\032\079\078", "\065\085\084\079\032\083\084\079\077\080\058\032\079\070\070")
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
            local ownRoot = ownCharacter and ownCharacter:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116")
            local rec = Records[target]
            local targetRoot = rec and rec.root
            local carrying = ownCharacter and ownCharacter:FindFirstChild("\071\082\065\066\066\073\078\071\095\067\079\078\083\084\082\065\073\078\084")
            if not carrying and (not ownRoot or not targetRoot or not targetRoot.Parent
                or (ownRoot.Position - targetRoot.Position).Magnitude >= 5) then
                restoreBringStomp()
                return
            end
            if carrying then
                local storage = ReplicatedStorage:FindFirstChild("\083\116\111\114\097\103\101")
                local remotes = storage and storage:FindFirstChild("\082\101\109\111\116\101\115")
                local main = remotes and remotes:FindFirstChild("\077\097\105\110")
                if main then pcall(function() main:FireServer("\071\114\097\098\098\105\110\103") end) end
                task.wait(0.55)
            end
            task.wait(0.1)
        end
    end)
end
                                                                          
                                                                               
                                                                            
ExtraUI.standSendChat = function(message)
    if S.closed then return false end
    local chat = game:GetService("\084\101\120\116\067\104\097\116\083\101\114\118\105\099\101")
    local channels = chat:FindFirstChild("\084\101\120\116\067\104\097\110\110\101\108\115")
    local general = channels and channels:FindFirstChild("\082\066\088\071\101\110\101\114\097\108")
    if general and general:IsA("\084\101\120\116\067\104\097\110\110\101\108") then
        local ok = pcall(function() general:SendAsync(message) end)
        if ok then return true end
    end
                                                            
    local legacy = ReplicatedStorage:FindFirstChild("\068\101\102\097\117\108\116\067\104\097\116\083\121\115\116\101\109\067\104\097\116\069\118\101\110\116\115")
    local remote = legacy and legacy:FindFirstChild("\083\097\121\077\101\115\115\097\103\101\082\101\113\117\101\115\116")
    if remote and remote:IsA("\082\101\109\111\116\101\069\118\101\110\116") then
        return pcall(function() remote:FireServer(message, "\065\108\108") end)
    end
    return false
end
ExtraUI.standReportResult = function(report, outcome, detail)
    if not report or report.sent then return end
    report.sent = true
    if S.standChatReport == report then S.standChatReport = nil end
    if report.command == "\099\111\117\110\116\101\114" then
        if outcome == "\070\065\073\076\069\068" then
            ExtraUI.standStatus("\067\111\117\110\116\101\114\032\101\110\100\101\100\032\119\105\116\104\111\117\116\032\097\032\099\111\110\102\105\114\109\101\100\032\100\111\119\110\046")
            return
        end
        if outcome == "\083\085\067\067\069\083\083" and report.target then
            local record = Hook.resolveShotRecord(report.target)
            local model = report.targetModel or record and record.model
            if model and S.standCounterReportedDown[report.target] == model then
                return
            end
            if model then S.standCounterReportedDown[report.target] = model end
        end
    end
                                                                     
    local message = ({
        SUCCESS = "\115\117\099\099\101\115\115",
        FAILED = "\102\097\105\108\101\100",
        ["\084\065\082\071\069\084\032\076\069\070\084"] = "\108\101\102\116",
        ["\084\065\082\071\069\084\032\078\079\084\032\070\079\085\078\068"] = "\110\111\116\032\102\111\117\110\100",
    })[outcome] or "\102\097\105\108\101\100"
    local posted = ExtraUI.standSendChat(message)
    if ExtraUI.standStatus then
        ExtraUI.standStatus((posted and "\083\101\110\116\032\116\111\032\099\104\097\116\058\032" or "\067\104\097\116\032\117\110\097\118\097\105\108\097\098\108\101\058\032") .. message)
    end
end
ExtraUI.standReportIssue = function(command, query, outcome, detail)
    local safeName = tostring(query or ""):gsub("\091\094\037\119\095\093", ""):sub(1, 24)
    if safeName == "" then safeName = "\117\110\107\110\111\119\110" end
    ExtraUI.standReportResult({command = command, name = safeName}, outcome, detail)
end
ExtraUI.standConfirmedDead = function(record)
    local model = record and record.model
    local effects = model and model:FindFirstChild("\066\111\100\121\069\102\102\101\099\116\115")
    local dead = effects and effects:FindFirstChild("\068\101\097\100")
    return dead and dead:IsA("\066\111\111\108\086\097\108\117\101") and dead.Value == true or false
end
ExtraUI.standConfirmedDown = function(player, priorRecord)
    local function isDown(record)
        local model = record and record.model
        local hum = record and record.humanoid
        local effects = model and model:FindFirstChild("\066\111\100\121\069\102\102\101\099\116\115")
        local ko = effects and effects:FindFirstChild("\075\046\079")
        local dead = effects and effects:FindFirstChild("\068\101\097\100")
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
                ExtraUI.standReportResult(report, "\083\085\067\067\069\083\083",
                    "\116\097\114\103\101\116\032\099\111\110\102\105\114\109\101\100\032\100\111\119\110\059\032\110\111\032\115\116\111\109\112")
            elseif confirmed then
                ExtraUI.standReportResult(report, "\083\085\067\067\069\083\083",
                    "\115\116\111\109\112\032\115\101\110\116\059\032\116\097\114\103\101\116\032\099\111\110\102\105\114\109\101\100\032\100\101\097\100")
            elseif report.target and report.target.Parent ~= Players then
                ExtraUI.standReportResult(report, "\084\065\082\071\069\084\032\076\069\070\084",
                    "\112\108\097\121\101\114\032\100\105\115\099\111\110\110\101\099\116\101\100\032\098\101\102\111\114\101\032\107\105\108\108\032\099\111\110\102\105\114\109\097\116\105\111\110")
            elseif downOnly then
                task.delay(1.25, function()
                    if report.sent then return end
                    if ExtraUI.standConfirmedDown(report.target) then
                        if report.command == "\099\111\117\110\116\101\114" then
                            local current = Hook.resolveShotRecord(report.target)
                            S.standCounterHandled[report.target] = current and current.model
                                or true
                            S.standCounterShots[report.target] = nil
                        end
                        ExtraUI.standReportResult(report, "\083\085\067\067\069\083\083",
                            "\116\097\114\103\101\116\032\099\111\110\102\105\114\109\101\100\032\100\111\119\110\032\097\102\116\101\114\032\114\101\112\108\105\099\097\116\105\111\110\032\100\101\108\097\121")
                    elseif report.command == "\099\111\117\110\116\101\114" then
                        report.sent = true
                        if S.standChatReport == report then S.standChatReport = nil end
                        ExtraUI.standStatus("\067\111\117\110\116\101\114\032\101\110\100\101\100\032\119\105\116\104\111\117\116\032\097\032\099\111\110\102\105\114\109\101\100\032\100\111\119\110\046")
                    else
                        ExtraUI.standReportResult(report, "\070\065\073\076\069\068",
                            "\116\097\114\103\101\116\032\110\111\116\032\099\111\110\102\105\114\109\101\100\032\100\111\119\110")
                    end
                end)
            else
                ExtraUI.standReportResult(report, "\070\065\073\076\069\068",
                    (message or "\097\116\116\097\099\107\032\101\110\100\101\100\032\119\105\116\104\111\117\116\032\099\111\110\102\105\114\109\101\100\032\115\116\111\109\112\032\097\110\100\032\107\105\108\108")
                        :gsub("\094\065\117\116\111\032\107\105\108\108\058\032", ""):gsub("\094\083\116\097\110\100\058\032", ""))
            end
        end
        if (confirmedDown or (report and report.stompSent
                and ExtraUI.standConfirmedDead(Hook.lockRecord)))
            and report and S.standSavedOrder
            and S.standSavedOrder.command == report.command
            and not (report.command == "\099\111\117\110\116\101\114"
                and string.lower(S.standSavedOrder.argument or "") == "\109\101") then
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
        S.standSnipeTarget = nil
        S.standCounterAttackTarget = nil
        S.standDrivebyTarget = nil
        S.standAmbushTarget = nil
        S.standAmbushRushTarget = nil
        S.standAmbushHitAfter = nil
        S.standAttack2FinisherPlayed = false
        S.standAttack2LaunchQueued = false
        if ExtraUI.standEndCinematic then ExtraUI.standEndCinematic() end
                                                                                    
        style(ForceHitBtn, S.forceHit, "\070\079\082\067\069\032\072\073\084\058\032\079\078", "\070\079\082\067\069\032\072\073\084\058\032\079\070\070")
        S.quietAutoKill = S.standPreviousQuiet
        S.autoKillVoid = S.standPreviousVoid
        style(VoidKillBtn, S.autoKillVoid,
            "\065\085\084\079\032\075\073\076\076\032\086\079\073\068\032\066\076\073\078\075\058\032\079\078", "\065\085\084\079\032\075\073\076\076\032\086\079\073\068\032\066\076\073\078\075\058\032\079\070\070")
        style(ExtraUI.QuietKillBtn, S.quietAutoKill,
            "\081\085\073\069\084\032\065\085\084\079\032\075\073\076\076\058\032\079\078", "\081\085\073\069\084\032\065\085\084\079\032\075\073\076\076\058\032\079\070\070")
                                                                              
        S.rapidWeapons["\091\082\101\118\111\108\118\101\114\093"] = S.standRevolverRapidBefore or nil
        S.standRevolverRapidBefore = nil
        S.standEnabledRapid = nil
        Rapid.forEachGun(function(tool)
            if tool.Name == "\091\082\101\118\111\108\118\101\114\093" then Rapid.applyCooldown(tool) end
        end)
        if Rapid.rows["\091\082\101\118\111\108\118\101\114\093"] then
            style(Rapid.rows["\091\082\101\118\111\108\118\101\114\093"], S.rapidWeapons["\091\082\101\118\111\108\118\101\114\093"],
                "\091\082\101\118\111\108\118\101\114\093\032\032\047\032\032\079\078", "\091\082\101\118\111\108\118\101\114\093\032\032\047\032\032\079\070\070")
        end
                                                                               
        if updateLoops then updateLoops() end
        if returnToOwner and ExtraUI.standOwnerRoot then
            local character = Me.Character
            local root = character and character:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116")
            local hum = character and character:FindFirstChildOfClass("\072\117\109\097\110\111\105\100")
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
    style(Bring, false, "\066\082\073\078\071\032\083\069\076\069\067\084\069\068\058\032\079\078", "\066\082\073\078\071\032\083\069\076\069\067\084\069\068")
    Hook.lockPlayer, Hook.lockRecord = nil, nil
    style(AutoKillBtn, false, "\065\085\084\079\032\075\073\076\076\032\083\069\076\069\067\084\069\068\058\032\079\078", "\065\085\084\079\032\075\073\076\076\032\083\069\076\069\067\084\069\068\058\032\079\070\070")
    if not S.silent and not S.wallBang and not S.forceHit then Hook.enabled = false end
    if message then say(message) end
end
                                                                           
                                                                             
ExtraUI.safeBringLanding = function(destination, character)
    if typeof(destination) ~= "\067\070\114\097\109\101" or destination.Position.Y < -28 then
        return nil, "\100\101\115\116\105\110\097\116\105\111\110\032\105\115\032\098\101\108\111\119\032\116\104\101\032\115\097\102\101\032\109\097\112\032\104\101\105\103\104\116"
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
        if not success then return nil, "\108\097\110\100\105\110\103\032\099\111\108\108\105\115\105\111\110\032\113\117\101\114\121\032\102\097\105\108\101\100" end
        local blocked = false
        for _, part in ipairs(parts) do
            if part:IsA("\066\097\115\101\080\097\114\116") and part.CanCollide then
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
    return nil, "\110\111\032\099\108\101\097\114\044\032\115\117\112\112\111\114\116\101\100\032\108\097\110\100\105\110\103\032\110\101\097\114\032\116\104\101\032\100\101\115\116\105\110\097\116\105\111\110"
end

local function startAutoKill(bringDestination, bringOwner, explicitTarget)
    if S.aura and ExtraUI.stopAura then ExtraUI.stopAura() end
    if S.autoKill then stopAutoKill("\065\117\116\111\032\107\105\108\108\032\115\116\111\112\112\101\100\046"); return end
    local target = explicitTarget or S.primary
    local rec = target and (explicitTarget and Hook.resolveShotRecord(target)
        or Records[target])
    if not (explicitTarget and recordUsable(target, rec)
        or not explicitTarget and recordPresent(target, rec))
        or (not bringDestination and not alive(rec, true)) then
        say("\083\101\108\101\099\116\032\097\032\112\108\097\121\101\114\032\111\110\032\084\065\082\071\069\084\083\032\102\105\114\115\116\046")
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
    style(Bring, bringDestination ~= nil, "\066\082\073\078\071\032\083\069\076\069\067\084\069\068\058\032\079\078", "\066\082\073\078\071\032\083\069\076\069\067\084\069\068")
    Hook.lockPlayer, Hook.lockRecord = target, rec
    S.autoKillGeneration = S.autoKillGeneration + 1
    local generation = S.autoKillGeneration
    style(AutoKillBtn, true, "\065\085\084\079\032\075\073\076\076\032\083\069\076\069\067\084\069\068\058\032\079\078", "\065\085\084\079\032\075\073\076\076\032\083\069\076\069\067\084\069\068\058\032\079\070\070")
    say((bringDestination and "\066\114\105\110\103" or "\065\117\116\111\032\107\105\108\108") .. "\032\116\097\114\103\101\116\105\110\103\032\064" .. target.Name .. "\046")
    task.spawn(function()
        local angle = math.random() * math.pi * 2
        local downedAt = nil
        local successfulActivations, lastNoDamageReport = 0, 0
        local function fireAttackWeapon(tool)
            local activated, err = Rapid.activate(tool)
            if not activated then
                if S.standAttackTarget == target then
                    ExtraUI.standStatus("\087\101\097\112\111\110\032\097\099\116\105\118\097\116\105\111\110\032\102\097\105\108\101\100\058\032" .. tostring(err))
                else
                    say("\065\117\116\111\032\107\105\108\108\058\032\119\101\097\112\111\110\032\097\099\116\105\118\097\116\105\111\110\032\102\097\105\108\101\100\058\032" .. tostring(err))
                end
                return
            end
            successfulActivations = successfulActivations + 1
            local now = os.clock()
            if successfulActivations >= 10
                and now - S.lastConfirmedHitAt >= 3
                and now - lastNoDamageReport >= 3 then
                lastNoDamageReport = now
                local detail = ("\037\100\032\115\104\111\116\115\032\115\101\110\116\059\032\110\111\032\099\111\110\102\105\114\109\101\100\032\115\101\114\118\101\114\032\100\097\109\097\103\101\032\121\101\116\046")
                    :format(successfulActivations)
                if S.standAttackTarget == target then
                    ExtraUI.standStatus("\065\116\116\097\099\107\058\032" .. detail)
                else
                    say("\065\117\116\111\032\107\105\108\108\058\032" .. detail)
                end
            end
        end
        local function usableGun(tool)
            if not tool or not tool:IsA("\084\111\111\108") then return false end
            local handle = tool:FindFirstChild("\072\097\110\100\108\101")
            local ammo = tool:GetAttribute("\065\109\109\111")
            local realAmmo = tool:GetAttribute("\082\101\097\108\065\109\109\111")
            if type(ammo) == "\110\117\109\098\101\114" and ammo <= 2 then Rapid.requestReload(tool) end
            return handle and handle:FindFirstChild("\083\104\111\111\116\070\088\071\117\105")
                and type(tool:GetAttribute("\067\111\111\108\100\111\119\110")) == "\110\117\109\098\101\114"
                and (type(ammo) ~= "\110\117\109\098\101\114" or ammo > 0)
                and (type(realAmmo) ~= "\110\117\109\098\101\114" or realAmmo > 0)
        end
        local snipeAnchor, snipeTargetPosition, nextSnipeMoveAt = nil, nil, 0
        local drivebyStartedAt, drivebyForward, drivebySide = nil, nil, nil
        local function findSnipePosition(character, root, victim)
            local base = victim.root.Position
            local away = root.Position - base
            away = Vector3.new(away.X, 0, away.Z)
            if away.Magnitude < 1 then away = Vector3.new(1, 0, 0) end
            local direction = away.Unit
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
                stopAutoKill("\065\117\116\111\032\107\105\108\108\032\115\116\111\112\112\101\100\058\032\116\097\114\103\101\116\032\099\104\097\110\103\101\100\032\111\114\032\108\101\102\116\046")
                break
            end
            local effects = rec.model:FindFirstChild("\066\111\100\121\069\102\102\101\099\116\115")
            local ko = effects and effects:FindFirstChild("\075\046\079")
            local dead = effects and effects:FindFirstChild("\068\101\097\100")
            local report = S.standChatReport
            if report and report.target == target and report.stompSent
                and ExtraUI.standConfirmedDead(rec) then
                ExtraUI.standReportResult(report, "\083\085\067\067\069\083\083",
                    "\115\116\111\109\112\032\115\101\110\116\059\032\116\097\114\103\101\116\032\099\111\110\102\105\114\109\101\100\032\100\101\097\100")
                stopAutoKill("\083\116\097\110\100\058\032\116\097\114\103\101\116\032\099\111\110\102\105\114\109\101\100\032\100\101\097\100\032\097\102\116\101\114\032\115\116\111\109\112\046")
                break
            end
            if dead and dead.Value and not S.killBringDestination then
                stopAutoKill("\065\117\116\111\032\107\105\108\108\058\032\116\097\114\103\101\116\032\102\105\110\105\115\104\101\100\032\098\101\102\111\114\101\032\103\114\097\098\046")
                break
            end
            local character = Me.Character
            local hum = character and character:FindFirstChildOfClass("\072\117\109\097\110\111\105\100")
            local root = character and character:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116")
            if not hum or not root or hum.Health <= 0 then
                stopAutoKill("\065\117\116\111\032\107\105\108\108\032\115\116\111\112\112\101\100\058\032\121\111\117\114\032\099\104\097\114\097\099\116\101\114\032\105\115\032\117\110\097\118\097\105\108\097\098\108\101\046")
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
                    stopAutoKill("\083\116\097\110\100\058\032\064" .. target.Name .. "\032\105\115\032\100\111\119\110\059\032\110\111\032\115\116\111\109\112\046")
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
                    local followOwner = S.bringFollowOwner
                    local ownerRoot = followOwner and ExtraUI.standOwnerRoot()
                    if ownerRoot then destination = ownerRoot.CFrame end
                    local targetLower = rec.model:FindFirstChild("\076\111\119\101\114\084\111\114\115\111")
                    local ownEffects = character:FindFirstChild("\066\111\100\121\069\102\102\101\099\116\115")
                    local attacking = ownEffects and ownEffects:FindFirstChild("\065\116\116\097\099\107\105\110\103")
                    local storage = ReplicatedStorage:FindFirstChild("\083\116\111\114\097\103\101")
                    local remotes = storage and storage:FindFirstChild("\082\101\109\111\116\101\115")
                    local main = remotes and remotes:FindFirstChild("\077\097\105\110")
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
                            local ownLower = character:FindFirstChild("\076\111\119\101\114\084\111\114\115\111")
                            if ownLower and (ownLower.Position - targetLower.Position).Magnitude <= 8 then
                                pcall(function() main:FireServer("\071\114\097\098\098\105\110\103", rec.humanoid) end)
                            end
                        end
                        local grabUntil = os.clock() + 0.55
                        while os.clock() < grabUntil
                            and not character:FindFirstChild("\071\082\065\066\066\073\078\071\095\067\079\078\083\084\082\065\073\078\084")
                            and S.autoKill and generation == S.autoKillGeneration
                            and Me.Character == character do task.wait(0.04) end
                        if character:FindFirstChild("\071\082\065\066\066\073\078\071\095\067\079\078\083\084\082\065\073\078\084") then
                                                                                         
                            local latestOwnerRoot = followOwner and ExtraUI.standOwnerRoot()
                            if latestOwnerRoot then destination = latestOwnerRoot.CFrame end
                            local landing, problem = ExtraUI.safeBringLanding(destination, character)
                            if not landing then
                                pcall(function() main:FireServer("\071\114\097\098\098\105\110\103") end)
                                stopAutoKill("\066\114\105\110\103\032\099\097\110\099\101\108\108\101\100\032\102\111\114\032\115\097\102\101\116\121\058\032" .. tostring(problem))
                                break
                            end
                            pcall(function()
                                root.AssemblyLinearVelocity = Vector3.zero
                                root.AssemblyAngularVelocity = Vector3.zero
                                character:PivotTo(landing)
                                root.AssemblyLinearVelocity = Vector3.zero
                                root.AssemblyAngularVelocity = Vector3.zero
                            end)
                            pcall(function() main:FireServer("\071\114\097\098\098\105\110\103") end)
                            local dropUntil = os.clock() + 0.75
                            while os.clock() < dropUntil
                                and character:FindFirstChild("\071\082\065\066\066\073\078\071\095\067\079\078\083\084\082\065\073\078\084")
                                and S.autoKill and generation == S.autoKillGeneration do
                                task.wait(0.05)
                            end
                            if character:FindFirstChild("\071\082\065\066\066\073\078\071\095\067\079\078\083\084\082\065\073\078\084") then
                                pcall(function() main:FireServer("\071\114\097\098\098\105\110\103") end)
                                task.wait(0.2)
                            end
                                                                                    
                            pcall(function()
                                root.AssemblyLinearVelocity = Vector3.zero
                                root.AssemblyAngularVelocity = Vector3.zero
                            end)
                            if character:FindFirstChild("\071\082\065\066\066\073\078\071\095\067\079\078\083\084\082\065\073\078\084") then
                                stopAutoKill("\071\114\097\098\032\099\111\110\102\105\114\109\101\100\059\032\100\114\111\112\032\110\111\116\032\099\111\110\102\105\114\109\101\100\046\032\080\114\101\115\115\032\071\032\116\111\032\114\101\108\101\097\115\101\046", true)
                            else
                                restoreBringStompWhenClear(target)
                                stopAutoKill("\075\105\108\108\032\043\032\098\114\105\110\103\058\032\109\111\118\101\032\053\032\115\116\117\100\115\032\097\119\097\121\032\116\111\032\114\101\115\117\109\101\032\097\117\116\111\032\115\116\111\109\112\046", true)
                            end
                            break
                        end
                    end
                    if os.clock() - downedAt > 6 then
                        stopAutoKill("\084\097\114\103\101\116\032\100\111\119\110\101\100\044\032\098\117\116\032\116\104\101\032\115\101\114\118\101\114\032\100\105\100\032\110\111\116\032\099\111\110\102\105\114\109\032\097\032\103\114\097\098\046")
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
                                stopAutoKill("\068\105\114\101\099\116\111\114\039\115\032\099\117\116\058\032\108\097\117\110\099\104\032\097\116\116\101\109\112\116\101\100\046")
                            end
                            pcall(ExtraUI.standLaunchTarget, target)
                        end
                    end)
                end
                if os.clock() - downedAt > 6 then
                    stopAutoKill("\065\117\116\111\032\107\105\108\108\058\032\116\097\114\103\101\116\032\100\111\119\110\101\100\059\032\102\105\110\105\115\104\032\119\097\115\032\110\111\116\032\099\111\110\102\105\114\109\101\100\046")
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
                ExtraUI.standStatus("\067\111\117\110\116\101\114\032\115\110\105\112\101\032\104\097\100\032\110\111\032\099\111\110\102\105\114\109\101\100\032\100\097\109\097\103\101\059\032\109\111\118\105\110\103\032\105\110\032\111\110\032\064"
                    .. target.Name .. "\046")
            end
            if S.standAmbushTarget == target
                and S.standAmbushRushTarget ~= target
                and S.standAmbushHitAfter
                and S.lastConfirmedHitAt > S.standAmbushHitAfter then
                S.standAmbushRushTarget = target
                S.standSnipeTarget = nil
                ExtraUI.standStatus("\065\109\098\117\115\104\032\104\105\116\032\099\111\110\102\105\114\109\101\100\059\032\099\108\111\115\105\110\103\032\111\110\032\064" .. target.Name .. "\046")
            end
            local tool = character:FindFirstChildOfClass("\084\111\111\108")
            local distance = (rec.root.Position - root.Position).Magnitude
            local bag = Me:FindFirstChildOfClass("\066\097\099\107\112\097\099\107")
            if S.standAttackTarget == target and tool
                and tool.Name ~= "\091\082\101\118\111\108\118\101\114\093" and bag
                and usableGun(bag:FindFirstChild("\091\082\101\118\111\108\118\101\114\093")) then
                tool = bag:FindFirstChild("\091\082\101\118\111\108\118\101\114\093")
                hum:EquipTool(tool)
                task.wait(0.08)
            end
            if tool and tool.Name ~= "\091\082\101\118\111\108\118\101\114\093" and bag
                and os.clock() - S.lastConfirmedHitAt > 2.5
                and os.clock() - S.lastAdaptiveSwitchAt > 2.5
                and usableGun(bag:FindFirstChild("\091\082\101\118\111\108\118\101\114\093")) then
                S.lastAdaptiveSwitchAt = os.clock()
                tool = bag:FindFirstChild("\091\082\101\118\111\108\118\101\114\093")
                hum:EquipTool(tool)
                say("\065\117\116\111\032\107\105\108\108\058\032\110\111\032\099\111\110\102\105\114\109\101\100\032\115\104\111\116\103\117\110\032\100\097\109\097\103\101\059\032\115\119\105\116\099\104\101\100\032\116\111\032\114\101\118\111\108\118\101\114\046")
                task.wait(0.08)
            end
            if distance > 75 and tool and tool.Name == "\091\068\111\117\098\108\101\045\066\097\114\114\101\108\032\083\071\093"
                and bag and usableGun(bag:FindFirstChild("\091\082\101\118\111\108\118\101\114\093")) then
                tool = bag:FindFirstChild("\091\082\101\118\111\108\118\101\114\093")
                hum:EquipTool(tool)
                task.wait(0.08)
            end
            if not usableGun(tool) then
                tool = nil
                if bag then
                    local preferred = S.standAttackTarget == target
                        and {"\091\082\101\118\111\108\118\101\114\093"} or distance > 75
                        and {"\091\082\101\118\111\108\118\101\114\093", "\091\083\077\071\093", "\091\068\111\117\098\108\101\045\066\097\114\114\101\108\032\083\071\093", "\091\084\097\099\116\105\099\097\108\083\104\111\116\103\117\110\093", "\091\083\104\111\116\103\117\110\093"}
                        or {"\091\068\111\117\098\108\101\045\066\097\114\114\101\108\032\083\071\093", "\091\084\097\099\116\105\099\097\108\083\104\111\116\103\117\110\093", "\091\083\104\111\116\103\117\110\093", "\091\082\101\118\111\108\118\101\114\093", "\091\083\077\071\093"}
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
                    local equipped = character:FindFirstChildOfClass("\084\111\111\108")
                    if equipped then Rapid.requestReload(equipped) end
                    task.wait(0.15)
                    continue
                end
                hum:EquipTool(tool)
                task.wait(0.08)
            elseif rec.root and rec.root.Parent then
                angle = angle + (S.standAttack3Target == target and 0.08
                    or S.standAttack5Target == target and 1.2
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
                    local progress = math.min(1, (os.clock() - drivebyStartedAt) / 1.25)
                    local passPosition = rec.root.Position + drivebyForward * 15
                        + drivebySide * ((progress * 2 - 1) * 24)
                        + Vector3.new(0, 2, 0)
                    local passFrame = CFrame.lookAt(passPosition,
                        rec.root.Position + Vector3.new(0, 1.5, 0))
                    local safePass = ExtraUI.safeBringLanding(passFrame, character)
                    if safePass then attackCFrame = safePass end
                    if progress >= 1 then
                        S.standDrivebyTarget = nil
                        ExtraUI.standStatus("\068\114\105\118\101\098\121\032\112\097\115\115\032\099\111\109\112\108\101\116\101\059\032\102\105\110\105\115\104\105\110\103\032\064" .. target.Name .. "\046")
                    end
                end
                if S.standAttack3Target == target then
                                                                              
                                                                                   
                    local skyHeight = 80
                    local skyDistance = 120
                    local skyRadius = math.sqrt(skyDistance * skyDistance
                        - skyHeight * skyHeight)
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
                    if needMove and os.clock() >= nextSnipeMoveAt then
                        nextSnipeMoveAt = os.clock() + 1.5
                        local position = findSnipePosition(character, root, rec)
                        if position then
                            snipeAnchor = position
                            snipeTargetPosition = rec.root.Position
                        elseif not snipeAnchor then
                            if S.standCounterAttackTarget == target then
                                S.standSnipeTarget = nil
                                ExtraUI.standStatus("\067\111\117\110\116\101\114\058\032\109\111\118\105\110\103\032\105\110\032\116\111\032\100\111\119\110\032\064"
                                    .. target.Name .. "\059\032\110\111\032\099\108\101\097\114\032\115\110\105\112\101\032\112\111\115\105\116\105\111\110\046")
                            else
                                stopAutoKill("\083\110\105\112\101\032\115\116\111\112\112\101\100\058\032\110\111\032\115\117\112\112\111\114\116\101\100\032\112\111\115\105\116\105\111\110\032\119\105\116\104\032\097\032\099\108\101\097\114\032\115\104\111\116\046")
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
                if (tool:GetAttribute("\065\109\109\111") or 1) <= 2 then Rapid.requestReload(tool) end
                local rapid = S.rapidWeapons[tool.Name]
                local cooldown = rapid and Rapid.getPace(tool)
                    or math.max(0.02, tool:GetAttribute("\067\111\111\108\100\111\119\110") or 0.1)
                local lastShot = tool:GetAttribute("\083\104\111\116\067\111\111\108\100\111\119\110\083\116\097\114\116\101\100") or 0
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
        return false, "\083\101\108\101\099\116\032\097\032\112\108\097\121\101\114\032\111\110\032\084\065\082\071\069\084\083\032\102\105\114\115\116\046"
    end
    local character = Me.Character
    local bag = Me:FindFirstChildOfClass("\066\097\099\107\112\097\099\107")
    local revolver = (character and character:FindFirstChild("\091\082\101\118\111\108\118\101\114\093"))
        or (bag and bag:FindFirstChild("\091\082\101\118\111\108\118\101\114\093"))
    if not revolver then return false, "\082\101\118\111\108\118\101\114\032\105\115\032\110\111\116\032\105\110\032\121\111\117\114\032\105\110\118\101\110\116\111\114\121\046" end
    if S.autoKill then stopAutoKill() end
    S.standRevolverRapidBefore = S.rapidWeapons["\091\082\101\118\111\108\118\101\114\093"] == true
    S.standPreviousQuiet = S.quietAutoKill
    S.standPreviousVoid = S.autoKillVoid
                                                                             
                                                                             
    S.standEnabledRapid = not S.rapidWeapons["\091\082\101\118\111\108\118\101\114\093"]
                                                                            
                                                                        
    S.quietAutoKill = variant == "\097\116\116\097\099\107\052"
    S.autoKillVoid = false
    S.rapidWeapons["\091\082\101\118\111\108\118\101\114\093"] = true
    S.standAttackTarget = target
    if independent then
        local targetRecord = Hook.resolveShotRecord(target)
        S.standChatReport = {
            command = variant or "\097\116\116\097\099\107", target = target,
            name = target.Name, targetModel = targetRecord and targetRecord.model,
            stompSent = false, sent = false,
        }
    end
    S.standDownOnlyTarget = downOnly and target or nil
    S.standAttack2Target = variant == "\097\116\116\097\099\107\050" and not downOnly and target or nil
    S.standAttack3Target = variant == "\097\116\116\097\099\107\051" and not downOnly and target or nil
    S.standAttack4Target = variant == "\097\116\116\097\099\107\052" and not downOnly and target or nil
    S.standAttack5Target = variant == "\097\116\116\097\099\107\053" and not downOnly and target or nil
    S.standDrivebyTarget = variant == "\100\114\105\118\101\098\121" and target or nil
    S.standAmbushTarget = variant == "\097\109\098\117\115\104" and target or nil
    S.standAmbushRushTarget = nil
    S.standAmbushHitAfter = nil
    S.standSnipeTarget = (variant == "\115\110\105\112\101" or variant == "\100\111\119\110"
        or variant == "\097\109\098\117\115\104" or variant == "\099\111\117\110\116\101\114")
        and target or nil
    S.standCounterAttackTarget = variant == "\099\111\117\110\116\101\114" and target or nil
    S.standAttack2FinisherPlayed = false
    S.standAttack2LaunchQueued = false
    style(ExtraUI.QuietKillBtn, S.quietAutoKill,
        "\081\085\073\069\084\032\065\085\084\079\032\075\073\076\076\058\032\079\078", "\081\085\073\069\084\032\065\085\084\079\032\075\073\076\076\058\032\079\070\070")
    style(VoidKillBtn, false,
        "\065\085\084\079\032\075\073\076\076\032\086\079\073\068\032\066\076\073\078\075\058\032\079\078", "\065\085\084\079\032\075\073\076\076\032\086\079\073\068\032\066\076\073\078\075\058\032\079\070\070")
    style(ForceHitBtn, S.forceHit, "\070\079\082\067\069\032\072\073\084\058\032\079\078", "\070\079\082\067\069\032\072\073\084\058\032\079\070\070")
    Rapid.forEachGun(function(tool)
        if tool.Name == "\091\082\101\118\111\108\118\101\114\093" then Rapid.applyCooldown(tool) end
    end)
    if Rapid.rows["\091\082\101\118\111\108\118\101\114\093"] then
        style(Rapid.rows["\091\082\101\118\111\108\118\101\114\093"], S.rapidWeapons["\091\082\101\118\111\108\118\101\114\093"],
            "\091\082\101\118\111\108\118\101\114\093\032\032\047\032\032\079\078", "\091\082\101\118\111\108\118\101\114\093\032\032\047\032\032\079\070\070")
    end
    local started, startError = pcall(startAutoKill, nil, nil,
        independent and target or nil)
    if not started or not S.autoKill then
        stopAutoKill()
        return false, started and "\084\097\114\103\101\116\032\117\110\097\118\097\105\108\097\098\108\101\046" or tostring(startError)
    end
    if updateLoops then updateLoops() end
    return true
end
bind(AutoKillBtn.MouseButton1Click:Connect(function()
    if S.autoKill then
        stopAutoKill("\065\117\116\111\032\107\105\108\108\032\115\116\111\112\112\101\100\046")
        return
    end
    local target = S.primary
    if not target then say("\083\101\108\101\099\116\032\097\032\112\108\097\121\101\114\032\111\110\032\084\065\082\071\069\084\083\032\102\105\114\115\116\046"); return end
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
        local started, issue = ExtraUI.startAttackOne(target, false, "\097\116\116\097\099\107")
        if not started then say("\065\117\116\111\032\107\105\108\108\058\032" .. issue) end
    end)
end))
ExtraUI.standStatus = function(message)
    ExtraUI.StandStatus.Text = message
    say("\083\116\097\110\100\058\032" .. message)
end
local AfkPreferenceFile = "\082\065\067\069\082\095\080\101\114\109\097\065\070\075\046\116\120\116"
if type(isfile) == "\102\117\110\099\116\105\111\110" and type(readfile) == "\102\117\110\099\116\105\111\110" then
    local ok, stored = pcall(function()
        return isfile(AfkPreferenceFile) and readfile(AfkPreferenceFile) or nil
    end)
    if ok and (stored == "\111\110" or stored == "\111\102\102") then
        S.afkPermanent = stored == "\111\110"
    end
elseif type(Env.SpectraPermanentAFK) == "\098\111\111\108\101\097\110" then
    S.afkPermanent = Env.SpectraPermanentAFK
end
local function sendAfk(value)
    local storage = ReplicatedStorage:FindFirstChild("\083\116\111\114\097\103\101")
    local remotes = storage and storage:FindFirstChild("\082\101\109\111\116\101\115")
    local main = remotes and remotes:FindFirstChild("\077\097\105\110")
    if not main or not main:IsA("\082\101\109\111\116\101\069\118\101\110\116") then return false end
    return pcall(function() main:FireServer("\085\112\100\097\116\101\065\070\075", value) end)
end
local function setPermanentAfk(enabled, persist)
    S.afkPermanent = enabled == true
    S.afkGeneration = S.afkGeneration + 1
    local generation = S.afkGeneration
    Env.SpectraPermanentAFK = S.afkPermanent
    style(ExtraUI.StandAfkBtn, S.afkPermanent,
        "\080\069\082\077\065\078\069\078\084\032\065\070\075\058\032\079\078", "\080\069\082\077\065\078\069\078\084\032\065\070\075\058\032\079\070\070")
    if persist and type(writefile) == "\102\117\110\099\116\105\111\110" then
        pcall(writefile, AfkPreferenceFile, S.afkPermanent and "\111\110" or "\111\102\102")
    end
    sendAfk(S.afkPermanent)
    if S.afkPermanent then
        task.spawn(function()
            while not S.closed and S.afkPermanent
                and generation == S.afkGeneration do
                local character = Me.Character
                local hum = character and character:FindFirstChildOfClass("\072\117\109\097\110\111\105\100")
                local tag = hum and hum:GetAttribute("\065\115\109\111\084\097\103\083\116\111\114\101\100")
                if not hum or type(tag) ~= "\115\116\114\105\110\103"
                    or not tag:find("\060\098\062\065\070\075\060\047\098\062", 1, true) then
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
    ExtraUI.standStatus(S.afkPermanent and "\080\101\114\109\097\110\101\110\116\032\065\070\075\032\101\110\097\098\108\101\100\046"
        or "\080\101\114\109\097\110\101\110\116\032\065\070\075\032\100\105\115\097\098\108\101\100\046")
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
local TextChatService = game:GetService("\084\101\120\116\067\104\097\116\083\101\114\118\105\099\101")
local StarterGui = game:GetService("\083\116\097\114\116\101\114\071\117\105")
local function setChatSpy(enabled)
    local window = TextChatService:FindFirstChild("\067\104\097\116\087\105\110\100\111\119\067\111\110\102\105\103\117\114\097\116\105\111\110")
    local tabs = TextChatService:FindFirstChild("\067\104\097\110\110\101\108\084\097\098\115\067\111\110\102\105\103\117\114\097\116\105\111\110")
    local inputBar = TextChatService:FindFirstChild("\067\104\097\116\073\110\112\117\116\066\097\114\067\111\110\102\105\103\117\114\097\116\105\111\110")
    if enabled then
        if not window then return false, "\067\104\097\116\032\119\105\110\100\111\119\032\105\115\032\117\110\097\118\097\105\108\097\098\108\101\046" end
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
        if not ok then return false, "\067\111\117\108\100\032\110\111\116\032\117\110\108\111\099\107\032\116\104\101\032\099\104\097\116\032\119\105\110\100\111\119\046" end
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
    style(ExtraUI.ChatSpyBtn, S.chatSpy, "\067\072\065\084\032\083\080\089\058\032\079\078", "\067\072\065\084\032\083\080\089\058\032\079\070\070")
    return true
end
ExtraUI.setChatSpy = setChatSpy
bind(ExtraUI.ChatSpyBtn.MouseButton1Click:Connect(function()
    local ok, reason = setChatSpy(not S.chatSpy)
    ExtraUI.standStatus(ok and (S.chatSpy
        and "\067\104\097\116\032\119\105\110\100\111\119\032\117\110\108\111\099\107\101\100\032\102\111\114\032\109\101\115\115\097\103\101\115\032\100\101\108\105\118\101\114\101\100\032\116\111\032\121\111\117\114\032\099\108\105\101\110\116\046"
        or "\067\104\097\116\032\119\105\110\100\111\119\032\114\101\115\116\111\114\101\100\046") or reason)
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
            local hum = character and character:WaitForChild("\072\117\109\097\110\111\105\100", 5)
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
        local hum = character and character:WaitForChild("\072\117\109\097\110\111\105\100", 5)
        if not hum then return end
                                                                           
                                                                               
        for _ = 1, 40 do
            if S.closed or not S.jumpBypass or generation ~= S.jumpBypassGeneration
                or Me.Character ~= character then return end
            local flags = nil
            local ok, connections = pcall(getconnections, hum.Jumping)
            if ok then
                for _, connection in ipairs(connections) do
                    if type(connection.Function) == "\102\117\110\099\116\105\111\110" then
                        local readOk, upvalues = pcall(debug.getupvalues,
                            connection.Function)
                        if readOk and type(upvalues) == "\116\097\098\108\101" then
                            for _, value in pairs(upvalues) do
                                if type(value) == "\116\097\098\108\101"
                                    and type(value.NoJumping) == "\098\111\111\108\101\097\110"
                                    and type(value.HighJump) == "\098\111\111\108\101\097\110" then
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
                "\074\085\077\080\032\066\089\080\065\083\083\058\032\079\078", "\074\085\077\080\032\066\089\080\065\083\083\058\032\079\070\070")
            ExtraUI.standStatus("\074\117\109\112\032\098\121\112\097\115\115\032\117\110\097\118\097\105\108\097\098\108\101\058\032\103\097\109\101\032\108\105\109\105\116\101\114\032\119\097\115\032\110\111\116\032\102\111\117\110\100\046")
        end
    end)
end
bind(ExtraUI.JumpBypassBtn.MouseButton1Click:Connect(function()
    S.jumpBypass = not S.jumpBypass
    style(ExtraUI.JumpBypassBtn, S.jumpBypass,
        "\074\085\077\080\032\066\089\080\065\083\083\058\032\079\078", "\074\085\077\080\032\066\089\080\065\083\083\058\032\079\070\070")
    attachJumpBypass(Me.Character)
    ExtraUI.standStatus(S.jumpBypass
        and "\074\117\109\112\032\098\121\112\097\115\115\032\111\110\058\032\110\111\114\109\097\108\032\103\114\111\117\110\100\101\100\032\106\117\109\112\115\032\119\105\116\104\111\117\116\032\116\104\101\032\115\104\111\114\116\032\108\111\099\107\111\117\116\046"
        or "\074\117\109\112\032\098\121\112\097\115\115\032\111\102\102\059\032\116\104\101\032\103\097\109\101\039\115\032\106\117\109\112\032\108\105\109\105\116\032\105\115\032\097\099\116\105\118\101\032\097\103\097\105\110\046")
end))
bind(Me.CharacterAdded:Connect(function(character)
    if S.jumpBypass then attachJumpBypass(character) end
end))
ExtraUI.standResolvePlayer = function(query, includeSelf)
    query = (query or ""):match("\094\037\115\042\040\046\045\041\037\115\042\036")
    query = query:gsub("\094\064", ""):gsub("\094\037\040\040\046\045\041\037\041\036", "\037\049")
        :gsub("\094\034\040\046\045\041\034\036", "\037\049")
    query = string.lower(query)
    if query == "" then return nil, "\069\110\116\101\114\032\097\032\112\108\097\121\101\114\032\110\097\109\101\046" end
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
    if #matches > 1 then return nil, "\078\097\109\101\032\109\097\116\099\104\101\115\032\115\101\118\101\114\097\108\032\112\108\097\121\101\114\115\059\032\116\121\112\101\032\109\111\114\101\046" end
    return nil, "\078\111\032\112\108\097\121\101\114\032\109\097\116\099\104\101\115\032\116\104\097\116\032\110\097\109\101\046"
end
ExtraUI.standResolveTarget = function(sender, query)
    local alias = string.lower((query or ""):match("\094\037\115\042\040\046\045\041\037\115\042\036"))
    if alias == "\109\101" or alias == "\109\121\115\101\108\102" or alias == "\111\119\110\101\114" then
        return sender
    end
    return ExtraUI.standResolvePlayer(query)
end
ExtraUI.standOwnerRoot = function()
    local owner = S.standOwner
    if not owner or owner.Parent ~= Players then return nil end
    local model = owner.Character
    if not model or not model:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116") then
        model = candidateNamed(Workspace, owner)
        if not model then
            for folder in pairs(Folders) do
                model = candidateNamed(folder, owner)
                if model then break end
            end
        end
    end
    return model and model:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116")
end
ExtraUI.standMoveToOwner = function()
    local targetRoot = ExtraUI.standOwnerRoot()
    local character = Me.Character
    local root = character and character:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116")
    local hum = character and character:FindFirstChildOfClass("\072\117\109\097\110\111\105\100")
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
    if not model or not model:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116") then
        model = candidateNamed(Workspace, player)
        if not model then
            for folder in pairs(Folders) do
                model = candidateNamed(folder, player)
                if model then break end
            end
        end
    end
    return model and model:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116")
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
    local root = character and character:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116")
    local hum = character and character:FindFirstChildOfClass("\072\117\109\097\110\111\105\100")
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
                local chat = game:GetService("\084\101\120\116\067\104\097\116\083\101\114\118\105\099\101")
                local channels = chat:FindFirstChild("\084\101\120\116\067\104\097\110\110\101\108\115")
                local general = channels and channels:FindFirstChild("\082\066\088\071\101\110\101\114\097\108")
                if general then pcall(function() general:SendAsync("\104\101\121\121\121") end) end
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
            local chat = game:GetService("\084\101\120\116\067\104\097\116\083\101\114\118\105\099\101")
            local channels = chat:FindFirstChild("\084\101\120\116\067\104\097\110\110\101\108\115")
            local general = channels and channels:FindFirstChild("\082\066\088\071\101\110\101\114\097\108")
            if general then pcall(function() general:SendAsync("\104\101\121\121\121") end) end
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
    local root = character and character:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116")
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
    local effects = model and model:FindFirstChild("\066\111\100\121\069\102\102\101\099\116\115")
    local ko = effects and effects:FindFirstChild("\075\046\079")
    local dead = effects and effects:FindFirstChild("\068\101\097\100")
    local hum = model and model:FindFirstChildOfClass("\072\117\109\097\110\111\105\100")
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
    style(ExtraUI.AuraBtn, false, "\065\085\082\065\032\055\053\032\083\084\085\068\083\058\032\079\078", "\065\085\082\065\032\055\053\032\083\084\085\068\083\058\032\079\070\070")
    if S.auraRevolverRapidBefore ~= nil then
        S.rapidWeapons["\091\082\101\118\111\108\118\101\114\093"] = S.auraRevolverRapidBefore or nil
        S.auraRevolverRapidBefore = nil
        Rapid.forEachGun(function(tool)
            if tool.Name == "\091\082\101\118\111\108\118\101\114\093" then Rapid.applyCooldown(tool) end
        end)
        if Rapid.rows["\091\082\101\118\111\108\118\101\114\093"] then
            style(Rapid.rows["\091\082\101\118\111\108\118\101\114\093"], S.rapidWeapons["\091\082\101\118\111\108\118\101\114\093"],
                "\091\082\101\118\111\108\118\101\114\093\032\032\047\032\032\079\078", "\091\082\101\118\111\108\118\101\114\093\032\032\047\032\032\079\070\070")
        end
    end
    if S.auraStompRestore ~= nil then
        S.autoStomp = S.auraStompRestore
        S.auraStompRestore = nil
        S.stompSuppressed = not S.autoStomp
        style(AutoStompBtn, S.autoStomp, "\065\085\084\079\032\083\084\079\077\080\058\032\079\078", "\065\085\084\079\032\083\084\079\077\080\058\032\079\070\070")
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
    S.auraRevolverRapidBefore = S.rapidWeapons["\091\082\101\118\111\108\118\101\114\093"] == true
    S.rapidWeapons["\091\082\101\118\111\108\118\101\114\093"] = true
    Rapid.forEachGun(function(tool)
        if tool.Name == "\091\082\101\118\111\108\118\101\114\093" then Rapid.applyCooldown(tool) end
    end)
    if Rapid.rows["\091\082\101\118\111\108\118\101\114\093"] then
        style(Rapid.rows["\091\082\101\118\111\108\118\101\114\093"], true,
            "\091\082\101\118\111\108\118\101\114\093\032\032\047\032\032\079\078", "\091\082\101\118\111\108\118\101\114\093\032\032\047\032\032\079\070\070")
    end
    S.auraGeneration = S.auraGeneration + 1
    local generation = S.auraGeneration
    S.auraStompRestore = S.autoStomp
    S.autoStomp = false
    S.stompSuppressed = true
    style(AutoStompBtn, false, "\065\085\084\079\032\083\084\079\077\080\058\032\079\078", "\065\085\084\079\032\083\084\079\077\080\058\032\079\070\070")
    updateAutoStomp()
    style(ExtraUI.AuraBtn, true, "\065\085\082\065\032\055\053\032\083\084\085\068\083\058\032\079\078", "\065\085\082\065\032\055\053\032\083\084\085\068\083\058\032\079\070\070")
    task.spawn(function()
        while not S.closed and S.aura and generation == S.auraGeneration do
            local now = os.clock()
            local character = Me.Character
            local root = character and character:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116")
            local centerRoot = if S.auraProtectedPlayer
                then ExtraUI.standTargetRoot(S.auraProtectedPlayer)
                else if S.auraFromStand then ExtraUI.standOwnerRoot() else root
            if S.auraProtectedPlayer and not centerRoot then
                S.auraProtectMissingAt = S.auraProtectMissingAt or now
                if S.auraProtectedPlayer.Parent ~= Players
                    or now - S.auraProtectMissingAt > 6 then
                    ExtraUI.stopAura("\080\114\111\116\101\099\116\032\115\116\111\112\112\101\100\058\032\112\108\097\121\101\114\032\117\110\097\118\097\105\108\097\098\108\101\046")
                    break
                end
            else
                S.auraProtectMissingAt = nil
            end
            local hum = character and character:FindFirstChildOfClass("\072\117\109\097\110\111\105\100")
            local bag = Me:FindFirstChildOfClass("\066\097\099\107\112\097\099\107")
            local effects = character and character:FindFirstChild("\066\111\100\121\069\102\102\101\099\116\115")
            local ko = effects and effects:FindFirstChild("\075\046\079")
            local reload = effects and effects:FindFirstChild("\082\101\108\111\097\100")
            local armorValue = effects and effects:FindFirstChild("\065\114\109\111\114")
            local watchedCharacter = centerRoot and centerRoot.Parent or character
            local watchedHum = watchedCharacter and watchedCharacter:FindFirstChildOfClass("\072\117\109\097\110\111\105\100")
            local watchedEffects = watchedCharacter and watchedCharacter:FindFirstChild("\066\111\100\121\069\102\102\101\099\116\115")
            local watchedArmorValue = watchedEffects and watchedEffects:FindFirstChild("\065\114\109\111\114")
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
                if S.auraFromStand and centerRoot ~= root then
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
                            local targetEffects = rec.model:FindFirstChild("\066\111\100\121\069\102\102\101\099\116\115")
                            local firing = targetEffects and targetEffects:FindFirstChild("\071\117\110\070\105\114\105\110\103")
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
                if chosen then
                    local function usable(tool)
                        if not tool or not tool:IsA("\084\111\111\108")
                            or not tool:FindFirstChild("\082\101\115\112\111\110\115\101") then return false end
                        local ammo = tool:GetAttribute("\082\101\097\108\065\109\109\111")
                        if type(ammo) ~= "\110\117\109\098\101\114" then ammo = tool:GetAttribute("\065\109\109\111") end
                        return type(ammo) ~= "\110\117\109\098\101\114" or ammo > 0
                    end
                    local tool = character:FindFirstChild("\091\082\101\118\111\108\118\101\114\093")
                    if not usable(tool) then tool = bag:FindFirstChild("\091\082\101\118\111\108\118\101\114\093") end
                    if not usable(tool) then tool = character:FindFirstChildOfClass("\084\111\111\108") end
                    if not usable(tool) then
                        tool = nil
                        for _, name in ipairs({"\091\082\101\118\111\108\118\101\114\093", "\091\068\111\117\098\108\101\045\066\097\114\114\101\108\032\083\071\093",
                            "\091\084\097\099\116\105\099\097\108\083\104\111\116\103\117\110\093", "\091\083\104\111\116\103\117\110\093", "\091\083\077\071\093"}) do
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
                            or math.max(0.02, tool:GetAttribute("\067\111\111\108\100\111\119\110") or 0.1)
                        local ready = rapid
                            and os.clock() - Rapid.lastShotAt(tool) >= pace
                            or not rapid and tick()
                                - (tool:GetAttribute("\083\104\111\116\067\111\111\108\100\111\119\110\083\116\097\114\116\101\100") or 0) >= pace
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
        ExtraUI.stopAura("\065\117\114\097\032\115\116\111\112\112\101\100\046")
    else
        local ok, reason = ExtraUI.startAura(false)
        say(ok and "\065\117\114\097\032\097\099\116\105\118\101\058\032\102\111\114\099\101\032\104\105\116\032\119\105\116\104\105\110\032\055\053\032\115\116\117\100\115\059\032\100\111\119\110\032\116\097\114\103\101\116\115\032\119\105\116\104\111\117\116\032\115\116\111\109\112\105\110\103\046"
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
        local hum = character:FindFirstChildOfClass("\072\117\109\097\110\111\105\100")
        local root = character:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116")
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
    if not S.standCounterTarget or type(shot) ~= "\116\097\098\108\101" then return end
    local shooter = shot.Player
    if typeof(shooter) == "\073\110\115\116\097\110\099\101" and shooter:IsA("\080\108\097\121\101\114")
        and shooter.Parent == Players and shooter ~= Me
        and shooter ~= S.standOwner then
        S.standCounterShots[shooter] = os.clock()
    end
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
    local root = character and character:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116")
    local hum = character and character:FindFirstChildOfClass("\072\117\109\097\110\111\105\100")
    local targetRoot = target and ExtraUI.standTargetRoot(target)
    if not root or not hum or hum.Health <= 0 or (target and not targetRoot) then
        ExtraUI.standStatus("\070\108\105\110\103\032\110\101\101\100\115\032\097\032\108\105\118\101\032\099\104\097\114\097\099\116\101\114\032\097\110\100\032\116\097\114\103\101\116\032\114\105\103\046")
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
    ExtraUI.standStatus(target and ("\070\108\105\110\103\105\110\103\032\064" .. target.Name .. "\046")
        or "\083\112\105\110\110\105\110\103\032\105\110\032\112\108\097\099\101\046")
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
                    ExtraUI.standStatus("\087\097\105\116\105\110\103\032\102\111\114\032\064" .. target.Name .. "\032\116\111\032\114\101\115\112\097\119\110\032\102\111\114\032\102\108\105\110\103\046")
                    task.wait(0.4)
                else
                    attempts = attempts + 1
                    local started = os.clock()
                    local launchPosition = targetPart and targetPart.Position
                    local launched = false
                    if target then
                        ExtraUI.standStatus("\070\108\105\110\103\105\110\103\032\064" .. target.Name
                            .. "\032\040\097\116\116\101\109\112\116\032" .. attempts .. "\041\046")
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
                                    local mover = Instance.new("\066\111\100\121\086\101\108\111\099\105\116\121")
                                    mover.Name = "\083\112\101\099\116\114\097\083\116\097\110\100\070\108\105\110\103"
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
                                if model and model:IsA("\077\111\100\101\108") then
                                    for _, part in ipairs(model:GetChildren()) do
                                        if part:IsA("\066\097\115\101\080\097\114\116") and part ~= targetPart
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
            ExtraUI.standStatus(not ok and ("\070\108\105\110\103\032\115\116\111\112\112\101\100\058\032" .. tostring(err))
                or (target and flung
                    and ("\064" .. target.Name .. "\032\102\108\117\110\103\032\097\102\116\101\114\032" .. attempts
                        .. (attempts == 1 and "\032\097\116\116\101\109\112\116\046" or "\032\097\116\116\101\109\112\116\115\046"))
                    or (target and "\070\108\105\110\103\032\115\116\111\112\112\101\100\059\032\116\097\114\103\101\116\032\108\101\102\116\032\111\114\032\099\104\097\114\097\099\116\101\114\032\114\101\115\101\116\046"
                        or "\083\112\105\110\032\102\105\110\105\115\104\101\100\059\032\112\111\115\105\116\105\111\110\032\114\101\115\116\111\114\101\100\046")))
        end
    end)
end
ExtraUI.standSetOwner = function(owner)
    if not owner or owner.Parent ~= Players then
        ExtraUI.standStatus("\067\104\111\111\115\101\032\097\032\112\108\097\121\101\114\032\097\115\032\111\119\110\101\114\046")
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
        and ("\079\119\110\101\114\058\032\089\079\085\032\040\064" .. owner.Name .. "\041")
        or ("\079\119\110\101\114\058\032\064" .. owner.Name .. "\032\040" .. owner.DisplayName .. "\041")
    ExtraUI.StandOwnerInput.Text = owner.Name
    S.standOwnerChatConnection = owner.Chatted:Connect(function(message)
        if ExtraUI.standHandleChat then ExtraUI.standHandleChat(owner, message) end
    end)
    ExtraUI.standStatus(owner == Me
        and "\083\101\108\102\032\111\119\110\101\114\032\115\101\116\046\032\069\110\097\098\108\101\032\076\105\115\116\101\110\032\102\111\114\032\033\097\116\116\097\099\107\044\032\033\097\116\116\097\099\107\050\045\053\044\032\033\115\110\105\112\101\044\032\033\100\111\119\110\044\032\033\097\117\114\097\044\032\033\103\111\116\111\044\032\033\115\116\111\112\046"
        or ("\079\119\110\101\114\032\115\101\116\032\116\111\032\064" .. owner.Name .. "\046\032\069\110\097\098\108\101\032\076\105\115\116\101\110\046"))
end
ExtraUI.standHandleChat = function(sender, message)
    if S.closed or not S.standEnabled or sender ~= S.standOwner
        or type(message) ~= "\115\116\114\105\110\103" then return end
    local command, argument = message:match("\094\037\115\042\033\040\037\119\043\041\037\115\042\040\046\045\041\037\115\042\036")
    if not command then return end
    command = string.lower(command)
    local signature = tostring(sender.UserId) .. "\058" .. message
    local now = os.clock()
    if S.standLastCommand == signature and now - S.standLastCommandAt < 0.35 then return end
    S.standLastCommand, S.standLastCommandAt = signature, now
    if sender == Me and command ~= "\097\116\116\097\099\107" and command ~= "\097\116\116\097\099\107\050"
        and command ~= "\097\116\116\097\099\107\051" and command ~= "\097\116\116\097\099\107\052"
        and command ~= "\097\116\116\097\099\107\053" and command ~= "\115\110\105\112\101"
        and command ~= "\100\111\119\110"
        and command ~= "\097\117\114\097"
        and command ~= "\112\114\111\116\101\099\116" and command ~= "\099\111\117\110\116\101\114"
        and command ~= "\100\114\105\118\101\098\121" and command ~= "\097\109\098\117\115\104"
        and command ~= "\103\111\116\111"
        and command ~= "\115\116\111\112" then
        ExtraUI.standStatus("\083\101\108\102\032\111\119\110\101\114\058\032\097\116\116\097\099\107\044\032\115\110\105\112\101\044\032\100\111\119\110\044\032\097\117\114\097\044\032\112\114\111\116\101\099\116\044\032\099\111\117\110\116\101\114\044\032\100\114\105\118\101\098\121\044\032\097\109\098\117\115\104\044\032\103\111\116\111\044\032\115\116\111\112\046")
        return
    end
    if command == "\115\116\111\112" then
        ExtraUI.standStop("\083\116\111\112\112\101\100\032\098\121\032\111\119\110\101\114\046")
    elseif command == "\097\117\114\097" then
        ExtraUI.standStop()
        local ok, reason = ExtraUI.startAura(true)
        ExtraUI.standStatus(ok and "\065\117\114\097\032\097\099\116\105\118\101\058\032\100\111\119\110\105\110\103\032\112\108\097\121\101\114\115\032\119\105\116\104\105\110\032\055\053\032\115\116\117\100\115\059\032\110\111\032\115\116\111\109\112\046"
            or tostring(reason))
    elseif command == "\112\114\111\116\101\099\116" then
        local target, issue = ExtraUI.standResolveTarget(sender, argument)
        if not target then ExtraUI.standStatus(issue); return end
        if target == Me then
            ExtraUI.standStatus("\085\115\101\032\033\097\117\114\097\032\116\111\032\103\117\097\114\100\032\121\111\117\114\115\101\108\102\046")
            return
        end
        ExtraUI.standStop()
        local ok, reason = ExtraUI.startAura(true, target)
        ExtraUI.standStatus(ok and ("\080\114\111\116\101\099\116\105\110\103\032\064" .. target.Name .. "\032\119\105\116\104\105\110\032\055\053\032\115\116\117\100\115\046")
            or tostring(reason))
    elseif command == "\099\111\117\110\116\101\114" then
        if string.lower((argument or ""):match("\094\037\115\042\040\046\045\041\037\115\042\036")) == "\109\101" then
            ExtraUI.standStop()
            S.standCounterTarget = sender
            ExtraUI.applyGunMods(Me.Character)
            local generation = S.standOrderGeneration
            ExtraUI.standStatus("\067\111\117\110\116\101\114\032\103\117\097\114\100\032\097\114\109\101\100\032\102\111\114\032\064" .. sender.Name .. "\046")
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
                        ExtraUI.standStatus("\067\111\117\110\116\101\114\032\103\117\097\114\100\032\115\116\111\112\112\101\100\058\032\111\119\110\101\114\032\108\101\102\116\046")
                        break
                    end
                    if not S.standCounterBulletHooked
                        and os.clock() - lastBulletHookAttemptAt > 1 then
                        lastBulletHookAttemptAt = os.clock()
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
                                local sampleHum = model:FindFirstChildOfClass("\072\117\109\097\110\111\105\100")
                                local sampleEffects = model:FindFirstChild("\066\111\100\121\069\102\102\101\099\116\115")
                                local sampleArmor = sampleEffects and sampleEffects:FindFirstChild("\065\114\109\111\114")
                                if sampleHum then
                                    local previous = vitalSamples[sampleHum]
                                    if previous and sampleHum.Health < previous then
                                        damageAt = os.clock()
                                    end
                                    vitalSamples[sampleHum] = sampleHum.Health
                                end
                                if sampleArmor and sampleArmor:IsA("\086\097\108\117\101\066\097\115\101")
                                    and type(sampleArmor.Value) == "\110\117\109\098\101\114" then
                                    local previous = vitalSamples[sampleArmor]
                                    if previous and sampleArmor.Value < previous then
                                        damageAt = os.clock()
                                    end
                                    vitalSamples[sampleArmor] = sampleArmor.Value
                                end
                            end
                            local ownerHum = ownerModel:FindFirstChildOfClass("\072\117\109\097\110\111\105\100")
                            local ownerEffects = ownerModel:FindFirstChild("\066\111\100\121\069\102\102\101\099\116\115")
                            local ownerArmor = ownerEffects and ownerEffects:FindFirstChild("\065\114\109\111\114")
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
                                if ownerArmor and ownerArmor:IsA("\086\097\108\117\101\066\097\115\101") then
                                    watchConnections[#watchConnections + 1] = ownerArmor.Changed:Connect(function(value)
                                        if type(value) == "\110\117\109\098\101\114" then
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
                            local damaged = os.clock() - damageAt < 0.35
                            local recentShooter, recentCount = nil, 0
                            local loneArmed, armedCount = nil, 0
                            for _, player in ipairs(Players:GetPlayers()) do
                                if player ~= Me and player ~= sender then
                                    local shooterRoot = ExtraUI.standTargetRoot(player)
                                    if shooterRoot then
                                        local effects = shooterRoot.Parent:FindFirstChild("\066\111\100\121\069\102\102\101\099\116\115")
                                        local firing = effects and effects:FindFirstChild("\071\117\110\070\105\114\105\110\103")
                                        local firingNow = firing and firing.Value == true or false
                                        local toward = ownerRoot.Position - shooterRoot.Position
                                        local distance = toward.Magnitude
                                        local facingOwner = distance > 0.1
                                            and shooterRoot.CFrame.LookVector:Dot(toward.Unit) > 0.15
                                        local equipped = shooterRoot.Parent:FindFirstChildOfClass("\084\111\111\108")
                                        if firingNow and not firingState[player] then
                                            recentFiring[player] = os.clock()
                                        end
                                        firingState[player] = firingNow
                                        local shotStamp = equipped
                                            and equipped:GetAttribute("\083\104\111\116\067\111\111\108\100\111\119\110\083\116\097\114\116\101\100")
                                        if type(shotStamp) == "\110\117\109\098\101\114" then
                                            if lastShotStamp[player] and shotStamp > lastShotStamp[player] then
                                                recentFiring[player] = os.clock()
                                            end
                                            lastShotStamp[player] = shotStamp
                                        end
                                        if damaged and distance <= 350 then
                                            if equipped and distance <= 250 and facingOwner then
                                                loneArmed = player
                                                armedCount = armedCount + 1
                                            end
                                            local firedAt = recentFiring[player] or 0
                                            if os.clock() - firedAt <= 1.25 then
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
                                local taggedPlayer = nil
                                local bulletShooter, bulletCount = nil, 0
                                for player, firedAt in pairs(S.standCounterShots) do
                                    if player.Parent == Players
                                        and os.clock() - firedAt <= 2 then
                                        bulletShooter = player
                                        bulletCount = bulletCount + 1
                                    end
                                end
                                for _, model in ipairs(possibleModels) do
                                    local modelHum = model:FindFirstChildOfClass("\072\117\109\097\110\111\105\100")
                                    local modelEffects = model:FindFirstChild("\066\111\100\121\069\102\102\101\099\116\115")
                                    local tag = modelHum and modelHum:FindFirstChild("\099\114\101\097\116\111\114")
                                        or model:FindFirstChild("\099\114\101\097\116\111\114")
                                        or modelEffects and modelEffects:FindFirstChild("\099\114\101\097\116\111\114")
                                    local value = tag and tag:IsA("\079\098\106\101\099\116\086\097\108\117\101") and tag.Value
                                    if value and value:IsA("\080\108\097\121\101\114") then
                                        taggedPlayer = value
                                        break
                                    elseif value and value:IsA("\077\111\100\101\108") then
                                        taggedPlayer = Players:GetPlayerFromCharacter(value)
                                        if taggedPlayer then break end
                                    end
                                end
                                if taggedPlayer and taggedPlayer:IsA("\080\108\097\121\101\114")
                                    and taggedPlayer ~= Me and taggedPlayer ~= sender then
                                    attacker = taggedPlayer
                                elseif bulletCount == 1 then
                                    attacker = bulletShooter
                                else
                                    attacker = bulletCount == 0 and recentCount == 1
                                        and recentShooter
                                        or bulletCount == 0 and recentCount == 0
                                            and armedCount == 1 and loneArmed or nil
                                end
                                if damageAt > lastDamageReportedAt then
                                    lastDamageReportedAt = damageAt
                                    ExtraUI.standStatus(attacker
                                        and ("\079\119\110\101\114\032\104\105\116\032\100\101\116\101\099\116\101\100\059\032\099\111\117\110\116\101\114\032\116\097\114\103\101\116\032\064"
                                            .. attacker.Name .. "\046")
                                        or "\079\119\110\101\114\032\104\105\116\032\100\101\116\101\099\116\101\100\059\032\115\104\111\111\116\101\114\032\097\109\098\105\103\117\111\117\115\044\032\104\111\108\100\105\110\103\032\102\105\114\101\046")
                                end
                            end
                        else
                            watchedModel, watchedHumObject, watchedArmorObject = nil, nil, nil
                            lastHealth, lastArmor = nil, nil
                            if os.clock() - lastOwnerMissingNoticeAt > 4 then
                                lastOwnerMissingNoticeAt = os.clock()
                                ExtraUI.standStatus("\067\111\117\110\116\101\114\032\119\097\105\116\105\110\103\032\102\111\114\032\111\119\110\101\114\039\115\032\099\104\097\114\097\099\116\101\114\046")
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
                                ExtraUI.standStatus("\067\111\117\110\116\101\114\032\113\117\101\117\101\100\032\102\111\114\032\064" .. attacker.Name
                                    .. "\032\097\102\116\101\114\032\064" .. sender.Name .. "\032\116\111\111\107\032\100\097\109\097\103\101\046")
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
                                ExtraUI.standStatus("\067\111\117\110\116\101\114\032\116\097\114\103\101\116\032\064" .. pending.Name
                                    .. "\032\105\115\032\097\108\114\101\097\100\121\032\100\111\119\110\059\032\103\117\097\114\100\032\114\101\109\097\105\110\115\032\097\114\109\101\100\046")
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
                            local ownHum = ownCharacter and ownCharacter:FindFirstChildOfClass("\072\117\109\097\110\111\105\100")
                            local ownRoot = ownCharacter and ownCharacter:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116")
                            local bag = Me:FindFirstChildOfClass("\066\097\099\107\112\097\099\107")
                            local revolver = ownCharacter and ownCharacter:FindFirstChild("\091\082\101\118\111\108\118\101\114\093")
                                or bag and bag:FindFirstChild("\091\082\101\118\111\108\118\101\114\093")
                            if ownHum and ownRoot and ownHum.Health > 0 and revolver then
                                local started, reason = ExtraUI.startAttackOne(
                                    pending, true, "\099\111\117\110\116\101\114", true)
                                if started then
                                    S.standCounterPending = nil
                                    Env.SpectraStandCounterPendingUserId = nil
                                    ExtraUI.standStatus("\067\111\117\110\116\101\114\032\115\110\105\112\105\110\103\032\064" .. pending.Name .. "\046")
                                elseif reason == "\084\097\114\103\101\116\032\117\110\097\118\097\105\108\097\098\108\101\046" then
                                    S.standCounterPending = nil
                                    Env.SpectraStandCounterPendingUserId = nil
                                elseif reason ~= "\082\101\118\111\108\118\101\114\032\105\115\032\110\111\116\032\105\110\032\121\111\117\114\032\105\110\118\101\110\116\111\114\121\046" then
                                    ExtraUI.standStatus("\067\111\117\110\116\101\114\032\114\101\116\114\121\058\032" .. tostring(reason))
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
            ExtraUI.standStatus("\067\104\111\111\115\101\032\097\110\111\116\104\101\114\032\112\108\097\121\101\114\032\116\111\032\099\111\117\110\116\101\114\046")
            return
        end
        ExtraUI.standStop()
        S.standCounterTarget = target
        ExtraUI.applyGunMods(Me.Character)
        local generation = S.standOrderGeneration
        ExtraUI.standStatus("\067\111\117\110\116\101\114\032\097\114\109\101\100\032\102\111\114\032\064" .. target.Name .. "\046")
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
                    ExtraUI.standStatus("\067\111\117\110\116\101\114\032\099\097\110\099\101\108\108\101\100\058\032\116\097\114\103\101\116\032\108\101\102\116\046")
                    break
                end
                local ownerRoot = ExtraUI.standOwnerRoot()
                local targetRoot = ExtraUI.standTargetRoot(target)
                local ownerModel = ownerRoot and ownerRoot.Parent
                local ownerHum = ownerModel and ownerModel:FindFirstChildOfClass("\072\117\109\097\110\111\105\100")
                local ownerEffects = ownerModel and ownerModel:FindFirstChild("\066\111\100\121\069\102\102\101\099\116\115")
                local armor = ownerEffects and ownerEffects:FindFirstChild("\065\114\109\111\114")
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
                    if armor and armor:IsA("\086\097\108\117\101\066\097\115\101") then
                        watchConnections[#watchConnections + 1] = armor.Changed:Connect(function(value)
                            if type(value) == "\110\117\109\098\101\114" then
                                if lastArmor and value < lastArmor then damageAt = os.clock() end
                                lastArmor = value
                            end
                        end)
                    end
                end
                local firedToward = false
                if ownerRoot and targetRoot then
                    local effects = targetRoot.Parent:FindFirstChild("\066\111\100\121\069\102\102\101\099\116\115")
                    local gunFiring = effects and effects:FindFirstChild("\071\117\110\070\105\114\105\110\103")
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
                local armed = targetRoot and targetRoot.Parent:FindFirstChildOfClass("\084\111\111\108")
                local closeEnough = ownerRoot and targetRoot
                    and (ownerRoot.Position - targetRoot.Position).Magnitude <= 350
                if os.clock() - damageAt < 0.35
                    and (firedToward or os.clock() - lastThreatAt < 2
                        or (armed and closeEnough)) then
                    S.standCounterPending = target
                    Env.SpectraStandCounterPendingUserId = target.UserId
                    ExtraUI.standStatus("\067\111\117\110\116\101\114\032\113\117\101\117\101\100\032\102\111\114\032\064" .. target.Name .. "\046")
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
                    ExtraUI.standStatus("\067\111\117\110\116\101\114\032\116\097\114\103\101\116\032\097\108\114\101\097\100\121\032\100\111\119\110\059\032\111\114\100\101\114\032\102\105\110\105\115\104\101\100\046")
                    break
                end
                local ownCharacter = Me.Character
                local ownHum = ownCharacter and ownCharacter:FindFirstChildOfClass("\072\117\109\097\110\111\105\100")
                local ownRoot = ownCharacter and ownCharacter:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116")
                local bag = Me:FindFirstChildOfClass("\066\097\099\107\112\097\099\107")
                local revolver = ownCharacter and ownCharacter:FindFirstChild("\091\082\101\118\111\108\118\101\114\093")
                    or bag and bag:FindFirstChild("\091\082\101\118\111\108\118\101\114\093")
                if ownHum and ownRoot and ownHum.Health > 0 and revolver then
                    local started, reason = ExtraUI.startAttackOne(target, true, "\099\111\117\110\116\101\114", true)
                    if started then
                        S.standCounterTarget = nil
                        S.standCounterPending = nil
                        Env.SpectraStandCounterPendingUserId = nil
                        ExtraUI.standStatus("\067\111\117\110\116\101\114\032\115\110\105\112\105\110\103\032\064" .. target.Name .. "\046")
                        break
                    elseif reason == "\084\097\114\103\101\116\032\117\110\097\118\097\105\108\097\098\108\101\046" then
                        S.standCounterTarget = nil
                        S.standCounterPending = nil
                        Env.SpectraStandCounterPendingUserId = nil
                        break
                    elseif reason ~= "\082\101\118\111\108\118\101\114\032\105\115\032\110\111\116\032\105\110\032\121\111\117\114\032\105\110\118\101\110\116\111\114\121\046" then
                        ExtraUI.standStatus("\067\111\117\110\116\101\114\032\114\101\116\114\121\058\032" .. tostring(reason))
                    end
                end
                task.wait(0.2)
            end
        end)
    elseif command == "\104\101\108\112" then
        local topic = string.lower(argument or "")
        ExtraUI.standStatus(topic == "\097\116\116\097\099\107"
            and "\033\097\116\116\097\099\107\044\032\033\097\116\116\097\099\107\050\045\053\044\032\033\115\110\105\112\101\044\032\033\100\111\119\110\044\032\033\100\114\105\118\101\098\121\044\032\033\097\109\098\117\115\104\044\032\033\099\111\117\110\116\101\114\044\032\033\112\114\111\116\101\099\116\044\032\033\115\116\111\112\046"
            or topic == "\103\101\097\114"
            and "\033\101\113\117\105\112\032\060\119\101\097\112\111\110\062\044\032\033\117\110\101\113\117\105\112\044\032\033\114\101\108\111\097\100\044\032\033\097\102\107\032\111\110\047\111\102\102\046"
            or "\033\097\117\114\097\044\032\033\098\114\105\110\103\044\032\033\102\108\105\110\103\059\032\033\103\111\116\111\044\032\033\098\097\099\107\044\032\033\102\097\099\101\044\032\033\102\111\108\108\111\119\059\032\033\104\101\108\112\032\097\116\116\097\099\107\047\103\101\097\114\046")
    elseif command == "\097\102\107" then
        local option = string.lower((argument or ""):match("\094\037\115\042\040\046\045\041\037\115\042\036"))
        if option == "\111\110" or option == "\111\102\102" then
            setPermanentAfk(option == "\111\110", true)
            ExtraUI.standStatus("\080\101\114\109\097\110\101\110\116\032\065\070\075\032" .. option .. "\046")
        else
            ExtraUI.standStatus("\085\115\101\032\033\097\102\107\032\111\110\032\111\114\032\033\097\102\107\032\111\102\102\046")
        end
    elseif command == "\115\116\097\121" then
        S.standFollow = false
        S.standFollowGeneration = S.standFollowGeneration + 1
        ExtraUI.stopFloatingFollow()
        ExtraUI.standStatus("\072\111\108\100\105\110\103\032\112\111\115\105\116\105\111\110\046")
    elseif command == "\099\111\109\101" then
        ExtraUI.standStop()
        ExtraUI.standStatus(ExtraUI.standMoveToOwner()
            and "\077\111\118\101\100\032\116\111\032\111\119\110\101\114\046" or "\079\119\110\101\114\032\112\111\115\105\116\105\111\110\032\117\110\097\118\097\105\108\097\098\108\101\046")
    elseif command == "\102\111\108\108\111\119" then
        local followTarget = nil
        if argument ~= "" then
            local issue
            followTarget, issue = ExtraUI.standResolveTarget(sender, argument)
            if not followTarget then ExtraUI.standStatus(issue); return end
        end
        ExtraUI.standStop()
        S.standFollow = true
        S.standFollowGeneration = S.standFollowGeneration + 1
        local generation = S.standFollowGeneration
        ExtraUI.standStatus(followTarget and "\070\108\111\097\116\105\110\103\032\098\101\104\105\110\100\032\064" .. followTarget.Name .. "\046"
            or "\070\108\111\097\116\105\110\103\032\098\101\104\105\110\100\032\111\119\110\101\114\046")
        task.spawn(function()
            while not S.closed and S.standEnabled and S.standFollow
                and generation == S.standFollowGeneration do
                local targetRoot = followTarget
                    and ExtraUI.standTargetRoot(followTarget)
                    or ExtraUI.standOwnerRoot()
                local character = Me.Character
                local root = character and character:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116")
                local hum = character and character:FindFirstChildOfClass("\072\117\109\097\110\111\105\100")
                if targetRoot and root and hum and hum.Health > 0 then
                    if S.standFloatCharacter ~= character then
                        ExtraUI.stopFloatingFollow()
                        S.standFloatCharacter = character
                        S.standFloatAutoRotate = hum.AutoRotate
                        S.standFloatRootCollide = root.CanCollide
                        hum.AutoRotate = false
                        root.CanCollide = false
                        local animator = hum:FindFirstChildOfClass("\065\110\105\109\097\116\111\114")
                        local storage = ReplicatedStorage:FindFirstChild("\083\116\111\114\097\103\101")
                        local animations = storage and storage:FindFirstChild("\065\110\105\109\097\116\105\111\110\115")
                        local emotes = animations and animations:FindFirstChild("\069\109\111\116\101\115")
                        local laying = emotes and emotes:FindFirstChild("\076\097\121\105\110\103")
                        if animator and laying and laying:IsA("\065\110\105\109\097\116\105\111\110") then
                            local ok, track = pcall(function()
                                return animator:LoadAnimation(laying)
                            end)
                            if ok and track then
                                track.Priority = Enum.AnimationPriority.Action
                                track.Looped = true
                                track:Play(0.15)
                                S.standFloatTrack = track
                            end
                        end
                    end
                    local behind = targetRoot.Position
                        - targetRoot.CFrame.LookVector * 4
                        + Vector3.new(0, 3.4, 0)
                    pcall(function()
                        character:PivotTo(CFrame.lookAt(behind,
                            behind + targetRoot.CFrame.LookVector))
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
    elseif command == "\103\111\116\111" or command == "\102\097\099\101" then
        local target, issue = ExtraUI.standResolveTarget(sender, argument)
        if not target then ExtraUI.standStatus(issue); return end
        local targetRoot = ExtraUI.standTargetRoot(target)
        local character = Me.Character
        local root = character and character:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116")
        if not targetRoot or not root then
            ExtraUI.standStatus("\067\104\097\114\097\099\116\101\114\032\111\114\032\116\097\114\103\101\116\032\112\111\115\105\116\105\111\110\032\117\110\097\118\097\105\108\097\098\108\101\046")
            return
        end
        if command == "\102\097\099\101" then
            local toward = Vector3.new(targetRoot.Position.X,
                root.Position.Y, targetRoot.Position.Z)
            if (toward - root.Position).Magnitude < 0.2 then return end
            pcall(function() root.CFrame = CFrame.lookAt(root.Position, toward) end)
            ExtraUI.standStatus("\070\097\099\105\110\103\032\064" .. target.Name .. "\046")
        else
            ExtraUI.standStop()
            local landing, reason = ExtraUI.safeBringLanding(targetRoot.CFrame, character)
            if not landing then
                ExtraUI.standStatus("\071\111\116\111\032\099\097\110\099\101\108\108\101\100\058\032" .. tostring(reason))
                return
            end
            S.standReturnCFrame = character:GetPivot()
            pcall(function()
                character:PivotTo(landing)
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
            end)
            ExtraUI.standStatus("\077\111\118\101\100\032\110\101\097\114\032\064" .. target.Name .. "\046")
        end
    elseif command == "\098\097\099\107" then
        local character = Me.Character
        local root = character and character:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116")
        if not root or not S.standReturnCFrame then
            ExtraUI.standStatus("\078\111\032\115\097\118\101\100\032\083\116\097\110\100\032\112\111\115\105\116\105\111\110\046")
            return
        end
        ExtraUI.standStop()
        local landing, reason = ExtraUI.safeBringLanding(S.standReturnCFrame, character)
        if not landing then
            ExtraUI.standStatus("\066\097\099\107\032\099\097\110\099\101\108\108\101\100\058\032" .. tostring(reason))
            return
        end
        local previous = character:GetPivot()
        pcall(function()
            character:PivotTo(landing)
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end)
        S.standReturnCFrame = previous
        ExtraUI.standStatus("\082\101\116\117\114\110\101\100\032\116\111\032\115\097\118\101\100\032\112\111\115\105\116\105\111\110\046")
    elseif command == "\104\111\108\100" then
        ExtraUI.standStop()
        local character = Me.Character
        local root = character and character:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116")
        if not root then ExtraUI.standStatus("\067\104\097\114\097\099\116\101\114\032\117\110\097\118\097\105\108\097\098\108\101\046"); return end
        local wasAnchored = root.Anchored
        S.standHoldRestore = function()
            if root.Parent then root.Anchored = wasAnchored end
        end
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
        root.Anchored = true
        ExtraUI.standStatus("\072\111\108\100\105\110\103\032\112\111\115\105\116\105\111\110\059\032\033\114\101\108\101\097\115\101\032\111\114\032\033\115\116\111\112\032\116\111\032\109\111\118\101\046")
    elseif command == "\114\101\108\101\097\115\101" then
        ExtraUI.standReleaseHold()
        S.standSavedOrder = nil
        Env.SpectraStandSavedOrder = nil
        ExtraUI.standStatus("\080\111\115\105\116\105\111\110\032\114\101\108\101\097\115\101\100\046")
    elseif command == "\101\113\117\105\112" then
        local query = string.lower((argument or ""):match("\094\037\115\042\040\046\045\041\037\115\042\036"))
        local aliases = {rev = "\091\082\101\118\111\108\118\101\114\093", revolver = "\091\082\101\118\111\108\118\101\114\093",
            db = "\091\068\111\117\098\108\101\045\066\097\114\114\101\108\032\083\071\093", shotgun = "\091\083\104\111\116\103\117\110\093",
            tac = "\091\084\097\099\116\105\099\097\108\083\104\111\116\103\117\110\093", smg = "\091\083\077\071\093", knife = "\091\075\110\105\102\101\093"}
        local wanted = aliases[query] or argument
        local bag = Me:FindFirstChildOfClass("\066\097\099\107\112\097\099\107")
        local character = Me.Character
        local hum = character and character:FindFirstChildOfClass("\072\117\109\097\110\111\105\100")
        local tool = bag and bag:FindFirstChild(wanted)
        if not tool and bag and query ~= "" then
            for _, candidate in ipairs(bag:GetChildren()) do
                if candidate:IsA("\084\111\111\108") and candidate.Name:lower():find(query, 1, true) then
                    tool = candidate
                    break
                end
            end
        end
        if not hum or not tool then
            ExtraUI.standStatus("\087\101\097\112\111\110\032\110\111\116\032\102\111\117\110\100\032\105\110\032\098\097\099\107\112\097\099\107\046")
            return
        end
        ExtraUI.standStop()
        hum:EquipTool(tool)
        ExtraUI.standStatus("\069\113\117\105\112\112\101\100\032" .. tool.Name .. "\046")
    elseif command == "\117\110\101\113\117\105\112" then
        ExtraUI.standStop()
        local character = Me.Character
        local hum = character and character:FindFirstChildOfClass("\072\117\109\097\110\111\105\100")
        if hum then hum:UnequipTools() end
        ExtraUI.standStatus("\084\111\111\108\115\032\117\110\101\113\117\105\112\112\101\100\046")
    elseif command == "\114\101\108\111\097\100" then
        local character = Me.Character
        local tool = character and character:FindFirstChildOfClass("\084\111\111\108")
        local storage = ReplicatedStorage:FindFirstChild("\083\116\111\114\097\103\101")
        local remotes = storage and storage:FindFirstChild("\082\101\109\111\116\101\115")
        local main = remotes and remotes:FindFirstChild("\077\097\105\110")
        if not tool or not main then
            ExtraUI.standStatus("\069\113\117\105\112\032\097\032\103\117\110\032\098\101\102\111\114\101\032\114\101\108\111\097\100\105\110\103\046")
            return
        end
        pcall(function() main:FireServer("\082\101\108\111\097\100", tool) end)
        ExtraUI.standStatus("\082\101\108\111\097\100\032\114\101\113\117\101\115\116\101\100\032\102\111\114\032" .. tool.Name .. "\046")
    elseif command == "\102\108\105\110\103" or command == "\115\112\105\110" then
        local target = nil
        if command == "\102\108\105\110\103" and argument ~= "" then
            local issue
            target, issue = ExtraUI.standResolveTarget(sender, argument)
            if not target then ExtraUI.standStatus(issue); return end
        end
        ExtraUI.standStartFling(target)
    elseif command == "\106\117\109\112" then
        local character = Me.Character
        local hum = character and character:FindFirstChildOfClass("\072\117\109\097\110\111\105\100")
        if hum and hum.Health > 0 then
            hum.Sit = false
            hum.Jump = true
            ExtraUI.standStatus("\074\117\109\112\105\110\103\046")
        else ExtraUI.standStatus("\067\104\097\114\097\099\116\101\114\032\117\110\097\118\097\105\108\097\098\108\101\046") end
    elseif command == "\115\105\116" then
        ExtraUI.standStop()
        local character = Me.Character
        local hum = character and character:FindFirstChildOfClass("\072\117\109\097\110\111\105\100")
        if hum and hum.Health > 0 then
            hum.Sit = true
            ExtraUI.standStatus("\083\105\116\116\105\110\103\046")
        else ExtraUI.standStatus("\067\104\097\114\097\099\116\101\114\032\117\110\097\118\097\105\108\097\098\108\101\046") end
    elseif command == "\115\116\097\110\100" then
        local character = Me.Character
        local hum = character and character:FindFirstChildOfClass("\072\117\109\097\110\111\105\100")
        if hum and hum.Health > 0 then
            hum.Sit = false
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            ExtraUI.standStatus("\083\116\097\110\100\105\110\103\046")
        else ExtraUI.standStatus("\067\104\097\114\097\099\116\101\114\032\117\110\097\118\097\105\108\097\098\108\101\046") end
    elseif command == "\098\114\105\110\103" then
        local target, issue = ExtraUI.standResolvePlayer(argument)
        if not target then ExtraUI.standStatus(issue); return end
        if target == S.standOwner then
            ExtraUI.standStatus("\079\119\110\101\114\032\099\097\110\110\111\116\032\098\101\032\116\104\101\032\098\114\105\110\103\032\116\097\114\103\101\116\046")
            return
        end
        local ownerRoot = ExtraUI.standOwnerRoot()
        if not ownerRoot then
            ExtraUI.standStatus("\079\119\110\101\114\032\112\111\115\105\116\105\111\110\032\117\110\097\118\097\105\108\097\098\108\101\046")
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
            ExtraUI.standStatus("\067\111\117\108\100\032\110\111\116\032\115\101\108\101\099\116\032\098\114\105\110\103\032\116\097\114\103\101\116\046")
            return
        end
        local generation = S.standOrderGeneration
        ExtraUI.standStatus("\082\101\115\111\108\118\105\110\103\032\064" .. target.Name .. "\032\102\111\114\032\066\114\105\110\103\046")
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
                ExtraUI.standStatus("\066\114\105\110\103\032\116\097\114\103\101\116\032\114\105\103\032\117\110\097\118\097\105\108\097\098\108\101\046")
                return
            end
            local latestOwnerRoot = ExtraUI.standOwnerRoot()
            if not latestOwnerRoot then
                ExtraUI.standStatus("\079\119\110\101\114\032\112\111\115\105\116\105\111\110\032\117\110\097\118\097\105\108\097\098\108\101\046")
                return
            end
            local ok, err = pcall(startAutoKill, latestOwnerRoot.CFrame, S.standOwner)
            ExtraUI.standStatus(ok and S.autoKill
                and ("\066\114\105\110\103\105\110\103\032\064" .. target.Name .. "\032\116\111\032\111\119\110\101\114\046")
                or ("\066\114\105\110\103\032\099\111\117\108\100\032\110\111\116\032\115\116\097\114\116\058\032" .. tostring(err)))
        end)
    elseif command == "\097\116\116\097\099\107" or command == "\097\116\116\097\099\107\050" or command == "\097\116\116\097\099\107\051"
        or command == "\097\116\116\097\099\107\052" or command == "\097\116\116\097\099\107\053"
        or command == "\115\110\105\112\101" or command == "\100\111\119\110"
        or command == "\100\114\105\118\101\098\121" or command == "\097\109\098\117\115\104" then
        local target, issue = ExtraUI.standResolveTarget(sender, argument)
        if not target then
            ExtraUI.standStatus(issue)
            ExtraUI.standReportIssue(command, argument, "\084\065\082\071\069\084\032\078\079\084\032\070\079\085\078\068",
                "\112\108\097\121\101\114\032\109\105\115\115\105\110\103\044\032\108\101\102\116\044\032\111\114\032\110\097\109\101\032\097\109\098\105\103\117\111\117\115")
            return
        end
        local ownerDownOnly = command == "\100\111\119\110"
        local bag = Me:FindFirstChildOfClass("\066\097\099\107\112\097\099\107")
        local character = Me.Character
        local revolver = (character and character:FindFirstChild("\091\082\101\118\111\108\118\101\114\093"))
            or (bag and bag:FindFirstChild("\091\082\101\118\111\108\118\101\114\093"))
        if not revolver then
            local ownHum = character and character:FindFirstChildOfClass("\072\117\109\097\110\111\105\100")
            if not ownHum or ownHum.Health <= 0 then
                ExtraUI.standRememberOrder(sender, command, argument)
                ExtraUI.standStatus("\065\116\116\097\099\107\032\113\117\101\117\101\100\032\117\110\116\105\108\032\121\111\117\114\032\099\104\097\114\097\099\116\101\114\032\114\101\115\112\097\119\110\115\032\119\105\116\104\032\082\101\118\111\108\118\101\114\046")
                return
            end
            ExtraUI.standStatus("\082\101\118\111\108\118\101\114\032\105\115\032\110\111\116\032\105\110\032\121\111\117\114\032\105\110\118\101\110\116\111\114\121\046")
            ExtraUI.standReportIssue(command, target.Name, "\070\065\073\076\069\068", "\110\111\032\082\101\118\111\108\118\101\114\032\101\113\117\105\112\112\101\100\032\111\114\032\099\097\114\114\105\101\100")
            return
        end
        ExtraUI.standStop()
        local generation = S.standOrderGeneration
        ExtraUI.standStatus("\082\101\115\111\108\118\105\110\103\032\064" .. target.Name .. "\032\102\111\114\032\097\116\116\097\099\107\046")
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
                ExtraUI.standStatus("\084\097\114\103\101\116\032\114\105\103\032\117\110\097\118\097\105\108\097\098\108\101\059\032\097\116\116\097\099\107\032\099\097\110\099\101\108\108\101\100\046")
                ExtraUI.standReportIssue(command, target.Name,
                    target.Parent ~= Players and "\084\065\082\071\069\084\032\076\069\070\084" or "\070\065\073\076\069\068",
                    target.Parent ~= Players and "\112\108\097\121\101\114\032\108\101\102\116\032\100\117\114\105\110\103\032\108\111\111\107\117\112"
                        or "\116\097\114\103\101\116\032\099\104\097\114\097\099\116\101\114\032\117\110\097\118\097\105\108\097\098\108\101")
                return
            end
            if command == "\097\116\116\097\099\107\050" then
                ExtraUI.standStatus("\065\116\116\097\099\107\050\058\032\114\117\110\110\105\110\103\032\105\110\032\111\110\032\064" .. target.Name .. "\046")
                local played, completed = pcall(
                    ExtraUI.standCinematicIntro, target, generation)
                if not played or not completed then
                    ExtraUI.standEndCinematic()
                    if generation == S.standOrderGeneration then
                        ExtraUI.standStatus("\067\105\110\101\109\097\116\105\099\032\099\097\110\099\101\108\108\101\100\059\032\116\097\114\103\101\116\032\117\110\097\118\097\105\108\097\098\108\101\046")
                        ExtraUI.standReportIssue(command, target.Name,
                            target.Parent ~= Players and "\084\065\082\071\069\084\032\076\069\070\084" or "\070\065\073\076\069\068",
                            "\097\116\116\097\099\107\050\032\105\110\116\114\111\032\099\111\117\108\100\032\110\111\116\032\099\111\109\112\108\101\116\101")
                    end
                    return
                end
            end
            ExtraUI.standStatus(((command == "\115\110\105\112\101" or command == "\100\111\119\110"
                or command == "\097\109\098\117\115\104")
                and "\084\097\107\105\110\103\032\097\032\115\110\105\112\101\114\032\112\111\115\105\116\105\111\110\032\102\111\114\032\064"
                or "\083\116\097\114\116\105\110\103\032\065\117\116\111\032\075\105\108\108\032\111\110\032\064") .. target.Name .. "\046")
            local started, startError = ExtraUI.startAttackOne(
                target, ownerDownOnly, command, true)
            if not started then
                ExtraUI.standStatus("\065\117\116\111\032\075\105\108\108\032\101\114\114\111\114\058\032" .. tostring(startError))
                return
            end
            if S.autoKill then
                ExtraUI.standStatus(ownerDownOnly
                    and ("\068\111\119\110\105\110\103\032\064" .. target.Name .. "\032\102\114\111\109\032\114\097\110\103\101\059\032\110\111\032\115\116\111\109\112\046")
                    or command == "\097\116\116\097\099\107\051"
                    and ("\083\107\121\032\097\116\116\097\099\107\032\111\110\032\064" .. target.Name .. "\059\032\100\101\115\099\101\110\100\032\116\111\032\115\116\111\109\112\032\111\110\032\100\111\119\110\046")
                    or command == "\097\116\116\097\099\107\052"
                    and ("\083\116\097\116\105\111\110\097\114\121\032\097\116\116\097\099\107\032\111\110\032\064" .. target.Name .. "\059\032\102\105\110\105\115\104\032\111\110\032\100\111\119\110\046")
                    or command == "\097\116\116\097\099\107\053"
                    and ("\084\105\103\104\116\032\111\114\098\105\116\032\097\116\116\097\099\107\032\111\110\032\064" .. target.Name .. "\046")
                    or command == "\115\110\105\112\101"
                    and ("\083\110\105\112\105\110\103\032\064" .. target.Name .. "\032\119\105\116\104\032\114\097\112\105\100\032\082\101\118\111\108\118\101\114\032\102\105\114\101\046")
                    or command == "\100\114\105\118\101\098\121"
                    and ("\068\114\105\118\105\110\103\032\112\097\115\116\032\064" .. target.Name .. "\059\032\116\104\101\110\032\099\108\111\115\105\110\103\032\116\111\032\102\105\110\105\115\104\046")
                    or command == "\097\109\098\117\115\104"
                    and ("\065\109\098\117\115\104\105\110\103\032\064" .. target.Name .. "\032\102\114\111\109\032\097\032\099\108\101\097\114\032\115\110\105\112\101\032\112\111\115\105\116\105\111\110\046")
                    or ("\065\116\116\097\099\107\105\110\103\032\064" .. target.Name .. "\032\119\105\116\104\032\114\101\118\111\108\118\101\114\059\032\115\116\111\109\112\032\111\110\032\100\111\119\110\046"))
            else
                stopAutoKill()
                ExtraUI.standStatus("\065\116\116\097\099\107\032\099\111\117\108\100\032\110\111\116\032\115\116\097\114\116\059\032\116\097\114\103\101\116\032\117\110\097\118\097\105\108\097\098\108\101\046")
            end
        end)
    elseif command == "\115\116\097\116\117\115" then
        ExtraUI.standStatus(S.autoKill and Hook.lockPlayer
            and "\065\116\116\097\099\107\105\110\103\032\064" .. Hook.lockPlayer.Name
            or S.standCounterPending and "\067\111\117\110\116\101\114\032\113\117\101\117\101\100\032\102\111\114\032\064" .. S.standCounterPending.Name
            or S.standCounterTarget and ("\067\111\117\110\116\101\114\032\103\117\097\114\100\032\097\099\116\105\118\101\059\032\098\117\108\108\101\116\032\102\101\101\100\032"
                .. (S.standCounterBulletHooked and "\099\111\110\110\101\099\116\101\100\046" or "\117\110\097\118\097\105\108\097\098\108\101\046"))
            or S.standFlinging and "\070\108\105\110\103\105\110\103\046"
            or S.standFollow and "\070\111\108\108\111\119\105\110\103\032\116\097\114\103\101\116\046"
            or S.standHoldRestore and "\072\111\108\100\105\110\103\032\112\111\115\105\116\105\111\110\046"
            or ("\083\116\097\110\100\105\110\103\032\098\121\046\032\065\070\075\032" .. (S.afkPermanent and "\079\078" or "\079\070\070") .. "\046"))
    end
    if command == "\097\117\114\097" or command == "\112\114\111\116\101\099\116" or command == "\099\111\117\110\116\101\114"
        or command == "\102\111\108\108\111\119" or command == "\115\116\097\121" or command == "\104\111\108\100"
        or command == "\099\111\109\101" or command == "\103\111\116\111" or command == "\102\097\099\101"
        or command == "\098\097\099\107" or command == "\101\113\117\105\112" or command == "\117\110\101\113\117\105\112"
        or command == "\102\108\105\110\103" or command == "\115\112\105\110" or command == "\115\105\116"
        or command == "\098\114\105\110\103" or command == "\097\116\116\097\099\107" or command == "\097\116\116\097\099\107\050"
        or command == "\097\116\116\097\099\107\051" or command == "\097\116\116\097\099\107\052" or command == "\097\116\116\097\099\107\053"
        or command == "\115\110\105\112\101" or command == "\100\111\119\110" or command == "\100\114\105\118\101\098\121"
        or command == "\097\109\098\117\115\104" then
        ExtraUI.standRememberOrder(sender, command, argument)
    end
end
ExtraUI.standResumeSaved = function(character, force)
    local saved = S.standSavedOrder
    if not saved or not S.standEnabled or not S.standOwner
        or saved.ownerUserId ~= S.standOwner.UserId then return end
    if not force then
        if saved.command == "\099\111\117\110\116\101\114" and S.standCounterTarget then return end
        if (saved.command == "\097\117\114\097" or saved.command == "\112\114\111\116\101\099\116") and S.aura then return end
        if saved.command == "\102\111\108\108\111\119" and S.standFollow then return end
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
            local hum = current and current:FindFirstChildOfClass("\072\117\109\097\110\111\105\100")
            local root = current and current:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116")
            local bag = Me:FindFirstChildOfClass("\066\097\099\107\112\097\099\107")
            local needsRevolver = saved.command == "\099\111\117\110\116\101\114"
                or saved.command == "\097\116\116\097\099\107" or saved.command == "\097\116\116\097\099\107\050"
                or saved.command == "\097\116\116\097\099\107\051" or saved.command == "\097\116\116\097\099\107\052"
                or saved.command == "\097\116\116\097\099\107\053" or saved.command == "\115\110\105\112\101"
                or saved.command == "\100\111\119\110" or saved.command == "\100\114\105\118\101\098\121"
                or saved.command == "\097\109\098\117\115\104"
            local revolver = current and current:FindFirstChild("\091\082\101\118\111\108\118\101\114\093")
                or bag and bag:FindFirstChild("\091\082\101\118\111\108\118\101\114\093")
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
        if S.autoKill then stopAutoKill("\082\101\115\117\109\105\110\103\032\083\116\097\110\100\032\111\114\100\101\114\032\097\102\116\101\114\032\114\101\115\112\097\119\110\046") end
        if S.closed or S.standSavedOrder ~= saved
            or resumeGeneration ~= S.standResumeGeneration then return end
        local pendingUserId = Env.SpectraStandCounterPendingUserId
        S.standLastCommand = nil
        local ok, issue = pcall(ExtraUI.standHandleChat, S.standOwner,
            "\033" .. saved.command .. (saved.argument ~= "" and "\032" .. saved.argument or ""))
        if saved.command == "\099\111\117\110\116\101\114" and pendingUserId
            and S.standCounterTarget then
            for _, player in ipairs(Players:GetPlayers()) do
                if player.UserId == pendingUserId then
                    S.standCounterPending = player
                    Env.SpectraStandCounterPendingUserId = pendingUserId
                    break
                end
            end
        end
        if not ok then ExtraUI.standStatus("\067\111\117\108\100\032\110\111\116\032\114\101\115\116\111\114\101\032\083\116\097\110\100\032\111\114\100\101\114\058\032" .. tostring(issue)) end
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
        ExtraUI.standStatus("\083\101\116\032\097\110\032\111\119\110\101\114\032\102\105\114\115\116\046")
        return
    end
    S.standEnabled = not S.standEnabled
    Env.SpectraStandEnabled = S.standEnabled
    style(ExtraUI.StandToggle, S.standEnabled, "\076\073\083\084\069\078\058\032\079\078", "\076\073\083\084\069\078\058\032\079\070\070")
    if not S.standEnabled then ExtraUI.standStop("\076\105\115\116\101\110\105\110\103\032\115\116\111\112\112\101\100\046")
    else ExtraUI.standStatus("\076\105\115\116\101\110\105\110\103\032\116\111\032\064" .. S.standOwner.Name .. "\046") end
end))
bind(ExtraUI.StandStop.MouseButton1Click:Connect(function()
    ExtraUI.standStop("\067\117\114\114\101\110\116\032\111\114\100\101\114\032\115\116\111\112\112\101\100\046")
end))
pcall(function()
    local chat = game:GetService("\084\101\120\116\067\104\097\116\083\101\114\118\105\099\101")
    bind(chat.SendingMessage:Connect(function(message)
        if S.standOwner == Me and type(message.Text) == "\115\116\114\105\110\103" then
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
    ExtraUI.standStop("\079\119\110\101\114\032\108\101\102\116\032\116\104\101\032\115\101\114\118\101\114\046")
    S.standEnabled = false
    S.standOwner = nil
    Env.SpectraStandOwnerUserId = nil
    Env.SpectraStandEnabled = false
    style(ExtraUI.StandToggle, false, "\076\073\083\084\069\078\058\032\079\078", "\076\073\083\084\069\078\058\032\079\070\070")
    ExtraUI.StandOwnerLabel.Text = "\079\119\110\101\114\058\032\110\111\110\101"
    if S.standOwnerChatConnection then
        S.standOwnerChatConnection:Disconnect()
        S.standOwnerChatConnection = nil
    end
end))
bind(Bring.MouseButton1Click:Connect(function()
    if S.autoKill and S.killBringDestination then
        stopAutoKill("\066\114\105\110\103\032\115\116\111\112\112\101\100\046")
        return
    end
    if S.autoKill then stopAutoKill() end
    local character = Me.Character
    local root = character and character:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116")
    if not root then say("\089\111\117\114\032\099\104\097\114\097\099\116\101\114\032\114\111\111\116\032\105\115\032\117\110\097\118\097\105\108\097\098\108\101\046"); return end
    startAutoKill(root.CFrame)
end))

                                                                           
                                                                              
                                                                     
ExtraUI.antiLockRenderName = "\082\065\067\069\082\095\065\110\116\105\076\111\099\107\077\111\118\101\109\101\110\116"
ExtraUI.updateAntiLock = function()
    pcall(function() RunService:UnbindFromRenderStep(ExtraUI.antiLockRenderName) end)
    if not S.antiLock or S.closed then return end
    RunService:BindToRenderStep(ExtraUI.antiLockRenderName,
        Enum.RenderPriority.Input.Value + 2, function()
            if S.closed or not S.antiLock or S.autoKill or S.voidBlinking
                or S.standFollow or S.standFlinging or S.bring then return end
            local character = Me.Character
            local hum = character and character:FindFirstChildOfClass("\072\117\109\097\110\111\105\100")
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
        "\065\078\084\073\045\076\079\067\075\032\077\079\086\069\077\069\078\084\058\032\079\078", "\065\078\084\073\045\076\079\067\075\032\077\079\086\069\077\069\078\084\058\032\079\070\070")
    ExtraUI.updateAntiLock()
    say(S.antiLock and "\065\110\116\105\045\108\111\099\107\032\109\111\118\101\109\101\110\116\032\079\078\058\032\115\116\114\097\102\101\115\032\119\104\105\108\101\032\119\097\108\107\105\110\103\059\032\110\111\116\032\108\111\099\107\032\105\109\109\117\110\105\116\121\046"
        or "\065\110\116\105\045\108\111\099\107\032\109\111\118\101\109\101\110\116\032\100\105\115\097\098\108\101\100\046")
end))

                                                                                 
ExtraUI.configSlot = 1
ExtraUI.configKeys = {"\113\117\105\101\116\065\117\116\111\075\105\108\108", "\097\117\116\111\075\105\108\108\086\111\105\100", "\097\110\116\105\086\111\105\100", "\097\117\116\111\065\114\109\111\114",
    "\097\110\116\105\083\116\111\109\112", "\097\117\116\111\083\116\111\109\112", "\115\116\111\109\112\065\110\105\109\097\116\105\111\110\069\110\097\098\108\101\100", "\115\116\111\109\112\080\097\099\101", "\107\110\105\102\101\084\114\097\118\101\108",
    "\114\101\115\101\116\084\104\114\101\115\104\111\108\100\073\110\100\101\120", "\115\116\114\097\102\101\082\097\100\105\117\115", "\118\111\105\100\068\101\112\116\104", "\117\105\083\099\097\108\101",
    "\114\101\115\112\097\119\110\065\116\068\101\097\116\104", "\097\100\097\112\116\105\118\101\082\097\112\105\100", "\110\111\082\101\099\111\105\108", "\110\111\083\112\114\101\097\100",
    "\105\110\118\105\115\105\098\108\101\083\104\111\116", "\105\110\102\105\110\105\116\101\083\109\103", "\097\117\116\111\082\101\108\111\097\100\065\108\108", "\116\104\101\109\101\073\110\100\101\120", "\109\097\099\114\111\076\111\099\107",
    "\098\117\108\108\101\116\077\111\100\101", "\097\110\116\105\076\111\099\107", "\105\110\102\105\110\105\116\101\082\097\110\103\101"}
ExtraUI.configPath = function()
    return "\083\112\101\099\116\114\097\077\117\108\116\105\095\067\111\110\102\105\103\095" .. ExtraUI.configSlot .. "\046\106\115\111\110"
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
        ExtraUI.ConfigStatus.Text = "\083\108\111\116\032" .. index .. "\032\115\101\108\101\099\116\101\100\046"
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
                game:GetService("\072\116\116\112\083\101\114\118\105\099\101"):JSONEncode(profile))
        end)
        if ok then
            ExtraUI.ConfigStatus.Text = "\083\097\118\101\100\032\115\108\111\116\032" .. ExtraUI.configSlot .. "\046"
            return
        end
    end
    Env.RacerMemoryConfigs = Env.RacerMemoryConfigs or {}
    Env.RacerMemoryConfigs[ExtraUI.configSlot] = profile
    ExtraUI.ConfigStatus.Text = "\083\097\118\101\100\032\115\108\111\116\032" .. ExtraUI.configSlot
        .. "\032\102\111\114\032\116\104\105\115\032\115\101\115\115\105\111\110\046"
end))
bind(ExtraUI.ConfigLoad.MouseButton1Click:Connect(function()
    local ok, profile = false, nil
    if ExtraUI.Capabilities.fileRead then
        ok, profile = pcall(function()
            if not isfile(ExtraUI.configPath()) then return nil end
            return game:GetService("\072\116\116\112\083\101\114\118\105\099\101"):JSONDecode(readfile(ExtraUI.configPath()))
        end)
    end
    if not ok or profile == nil then
        profile = Env.RacerMemoryConfigs
            and Env.RacerMemoryConfigs[ExtraUI.configSlot] or nil
        ok = profile ~= nil
    end
    if not ok or profile == nil then
        ExtraUI.ConfigStatus.Text = "\083\108\111\116\032" .. ExtraUI.configSlot .. "\032\105\115\032\101\109\112\116\121\046"
        return
    end
    if not ok or type(profile) ~= "\116\097\098\108\101" or profile.version ~= 1
        or type(profile.settings) ~= "\116\097\098\108\101" then
        ExtraUI.ConfigStatus.Text = "\084\104\105\115\032\115\108\111\116\032\104\097\115\032\105\110\118\097\108\105\100\032\099\111\110\102\105\103\032\100\097\116\097\046"
        return
    end
    if S.autoKill then stopAutoKill("\076\111\097\100\105\110\103\032\099\111\110\102\105\103\046") end
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
    Rapid.restore()
    table.clear(S.rapidWeapons)
    if type(profile.rapidWeapons) == "\116\097\098\108\101" then
        for name, enabled in pairs(profile.rapidWeapons) do
            if type(name) == "\115\116\114\105\110\103" and enabled == true then
                S.rapidWeapons[name] = true
            end
        end
    end
    Rapid.forEachGun(function(tool) Rapid.applyCooldown(tool) end)
    for name, row in pairs(Rapid.rows) do
        style(row, S.rapidWeapons[name], name .. "\032\032\047\032\032\079\078", name .. "\032\032\047\032\032\079\070\070")
    end
    table.clear(S.autoBuys)
    if ExtraUI.Capabilities.shopPurchase and type(profile.autoBuys) == "\116\097\098\108\101" then
        for name, enabled in pairs(profile.autoBuys) do
            if type(name) == "\115\116\114\105\110\103" and enabled == true then
                S.autoBuys[name] = true
            end
        end
    end
    if type(profile.esp) == "\116\097\098\108\101" then
        for key, value in pairs(S.esp) do
            if type(profile.esp[key]) == type(value) then S.esp[key] = profile.esp[key] end
        end
    end
    if type(profile.notify) == "\116\097\098\108\101" then
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
        "\081\085\073\069\084\032\065\085\084\079\032\075\073\076\076\058\032\079\078", "\081\085\073\069\084\032\065\085\084\079\032\075\073\076\076\058\032\079\070\070")
    style(VoidKillBtn, S.autoKillVoid,
        "\065\085\084\079\032\075\073\076\076\032\086\079\073\068\032\066\076\073\078\075\058\032\079\078", "\065\085\084\079\032\075\073\076\076\032\086\079\073\068\032\066\076\073\078\075\058\032\079\070\070")
    style(AntiVoidBtn, S.antiVoid, "\065\078\084\073\032\086\079\073\068\058\032\079\078", "\065\078\084\073\032\086\079\073\068\058\032\079\070\070")
    style(ExtraUI.AntiLockBtn, S.antiLock,
        "\065\078\084\073\045\076\079\067\075\032\077\079\086\069\077\069\078\084\058\032\079\078", "\065\078\084\073\045\076\079\067\075\032\077\079\086\069\077\069\078\084\058\032\079\070\070")
    ExtraUI.updateAntiLock()
    if ExtraUI.Capabilities.shopPurchase then
        style(AutoArmor, S.autoArmor,
            "\065\085\084\079\032\065\082\077\079\082\032\079\078\032\082\069\083\080\065\087\078\058\032\079\078", "\065\085\084\079\032\065\082\077\079\082\032\079\078\032\082\069\083\080\065\087\078\058\032\079\070\070")
    else
        S.autoArmor = false
        AutoArmor.Text = "\065\085\084\079\032\065\082\077\079\082\058\032\085\078\065\086\065\073\076\065\066\076\069\032\073\078\032\088\069\078\079"
    end
    style(AntiStompBtn, S.antiStomp, "\065\078\084\073\032\083\084\079\077\080\058\032\079\078", "\065\078\084\073\032\083\084\079\077\080\058\032\079\070\070")
    if previouslyAntiStomp and not S.antiStomp then
        S.resetGeneration = S.resetGeneration + 1
        S.resetCharacter = nil
        S.resetInFlight = false
        S.antiStompReady = false
    elseif not previouslyAntiStomp and S.antiStomp then
        resetBeforeStomp(Me.Character, ownDangerReason(Me.Character))
    end
    style(AutoStompBtn, S.autoStomp, "\065\085\084\079\032\083\084\079\077\080\058\032\079\078", "\065\085\084\079\032\083\084\079\077\080\058\032\079\070\070")
    style(ExtraUI.KnifeTravelBtn, S.knifeTravel,
        "\075\078\073\070\069\032\084\082\065\086\069\076\058\032\079\078", "\075\078\073\070\069\032\084\082\065\086\069\076\058\032\079\070\070")
    style(ExtraUI.StompAnimationBtn, S.stompAnimationEnabled,
        "\083\084\079\077\080\032\065\078\073\077\065\084\073\079\078\058\032\079\078", "\083\084\079\077\080\032\065\078\073\077\065\084\073\079\078\058\032\079\070\070")
    style(ExtraUI.RespawnDeathBtn, S.respawnAtDeath,
        "\082\069\083\080\065\087\078\032\065\084\032\068\069\065\084\072\058\032\079\078", "\082\069\083\080\065\087\078\032\065\084\032\068\069\065\084\072\058\032\079\070\070")
    style(ExtraUI.MacroBtn, S.macroLock,
        "\077\065\067\082\079\032\080\069\082\083\073\083\084\058\032\079\078", "\077\065\067\082\079\032\080\069\082\083\073\083\084\058\032\079\070\070")
    if S.macroLock then ExtraUI.ensureMacro(Me.Character) end
    ResetThresholdBtn.Text = "\082\069\083\069\084\032\065\084\058\032" .. ResetThresholds[S.resetThresholdIndex] .. "\032\072\080"
    local guns = ExtraUI.GunModButtons
    if ExtraUI.Capabilities.gunManager ~= false then
        style(ExtraUI.BulletModeBtn, S.bulletMode ~= 1,
            "\066\085\076\076\069\084\032\068\073\082\069\067\084\073\079\078\058\032" .. ExtraUI.BulletModeNames[S.bulletMode],
            "\066\085\076\076\069\084\032\068\073\082\069\067\084\073\079\078\058\032\067\085\082\083\079\082")
    end
    if S.bulletMode ~= 1 then
        local ok, reason = installRaycastHook()
        if not ok then say(reason) end
    end
    style(guns.invisible, S.invisibleShot, "\073\078\086\073\083\073\066\076\069\032\083\072\079\084\058\032\079\078", "\073\078\086\073\083\073\066\076\069\032\083\072\079\084\058\032\079\070\070")
    guns.adaptive.Text = "\070\073\082\069\032\082\065\084\069\058\032\048\046\048\049\083"
    style(guns.recoil, S.noRecoil, "\078\079\032\082\069\067\079\073\076\058\032\079\078", "\078\079\032\082\069\067\079\073\076\058\032\079\070\070")
    if ExtraUI.Capabilities.gunManager ~= false then
        style(guns.spread, S.noSpread, "\068\066\032\078\079\032\083\080\082\069\065\068\058\032\079\078", "\068\066\032\078\079\032\083\080\082\069\065\068\058\032\079\070\070")
    end
    style(guns.smg, S.infiniteSmg, "\083\077\071\032\065\085\084\079\032\082\069\076\079\065\068\058\032\079\078", "\083\077\071\032\065\085\084\079\032\082\069\076\079\065\068\058\032\079\070\070")
    style(guns.reload, S.autoReloadAll,
        "\065\085\084\079\032\082\069\076\079\065\068\032\065\076\076\032\071\085\078\083\058\032\079\078", "\065\085\084\079\032\082\069\076\079\065\068\032\065\076\076\032\071\085\078\083\058\032\079\070\070")
    if ExtraUI.Capabilities.gunManager ~= false then
        style(ExtraUI.InfiniteRangeBtn, S.infiniteRange,
            "\073\078\070\073\078\073\084\069\032\082\065\078\071\069\058\032\079\078", "\073\078\070\073\078\073\084\069\032\082\065\078\071\069\058\032\079\070\070")
    end
    if S.infiniteRange then
        local ok, reason = installRaycastHook()
        if not ok then say(reason) end
    end
    ExtraUI.applyGunMods(Me.Character)
    style(ExtraUI.EspMain, S.esp.enabled, "\069\083\080\058\032\079\078", "\069\083\080\058\032\079\070\070")
    for _, item in ipairs({{"\098\111\120\101\115", ExtraUI.EspBoxes, "\066\079\088\069\083"},
        {"\115\107\101\108\101\116\111\110", ExtraUI.EspSkeleton, "\083\075\069\076\069\084\079\078"},
        {"\110\097\109\101\115", ExtraUI.EspNames, "\078\065\077\069\083"},
        {"\100\105\115\116\097\110\099\101", ExtraUI.EspDistance, "\068\073\083\084\065\078\067\069"}}) do
        style(item[2], S.esp[item[1]], item[3] .. "\058\032\079\078", item[3] .. "\058\032\079\070\070")
    end
    local espRanges = {"\050\053\048", "\053\048\048", "\049\048\048\048", "\065\076\076"}
    local espColors = {"\067\089\065\078", "\086\073\079\076\069\084", "\065\077\066\069\082", "\076\073\077\069"}
    ExtraUI.EspRange.Text = "\082\065\078\071\069\058\032" .. espRanges[S.esp.rangeIndex]
    ExtraUI.EspColor.Text = "\067\079\076\079\082\058\032" .. espColors[S.esp.colorIndex]
    refreshAutoBuyControls()
    updateAutoStomp()
    ExtraUI.ConfigStatus.Text = "\076\111\097\100\101\100\032\115\108\111\116\032" .. ExtraUI.configSlot .. "\046"
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
style(AliveBtn, true, "\065\076\073\086\069\032\067\072\069\067\075\058\032\079\078", "\065\076\073\086\069\032\067\072\069\067\075\058\032\079\070\070")
if ExtraUI.Capabilities.shopPurchase then
    style(AutoArmor, S.autoArmor, "\065\085\084\079\032\065\082\077\079\082\032\079\078\032\082\069\083\080\065\087\078\058\032\079\078", "\065\085\084\079\032\065\082\077\079\082\032\079\078\032\082\069\083\080\065\087\078\058\032\079\070\070")
else
    S.autoArmor = false
end
style(AntiStompBtn, S.antiStomp, "\065\078\084\073\032\083\084\079\077\080\058\032\079\078", "\065\078\084\073\032\083\084\079\077\080\058\032\079\070\070")
style(AutoStompBtn, S.autoStomp, "\065\085\084\079\032\083\084\079\077\080\058\032\079\078", "\065\085\084\079\032\083\084\079\077\080\058\032\079\070\070")
style(ExtraUI.AuraBtn, false, "\065\085\082\065\032\055\053\032\083\084\085\068\083\058\032\079\078", "\065\085\082\065\032\055\053\032\083\084\085\068\083\058\032\079\070\070")
style(ExtraUI.KnifeTravelBtn, S.knifeTravel,
    "\075\078\073\070\069\032\084\082\065\086\069\076\058\032\079\078", "\075\078\073\070\069\032\084\082\065\086\069\076\058\032\079\070\070")
style(ExtraUI.StompAnimationBtn, S.stompAnimationEnabled,
    "\083\084\079\077\080\032\065\078\073\077\065\084\073\079\078\058\032\079\078", "\083\084\079\077\080\032\065\078\073\077\065\084\073\079\078\058\032\079\070\070")
if type(Env.SpectraStandOwnerUserId) == "\110\117\109\098\101\114" then
    task.defer(function()
        if S.closed then return end
        for _, player in ipairs(Players:GetPlayers()) do
            if player.UserId == Env.SpectraStandOwnerUserId then
                local savedOrder = Env.SpectraStandSavedOrder
                local pendingUserId = Env.SpectraStandCounterPendingUserId
                ExtraUI.standSetOwner(player)
                S.standEnabled = Env.SpectraStandEnabled == true
                style(ExtraUI.StandToggle, S.standEnabled,
                    "\076\073\083\084\069\078\058\032\079\078", "\076\073\083\084\069\078\058\032\079\070\070")
                if S.standEnabled then
                    ExtraUI.standStatus("\076\105\115\116\101\110\105\110\103\032\116\111\032\064" .. player.Name .. "\046")
                    if type(savedOrder) == "\116\097\098\108\101"
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
style(CursorToggle, S.cursorKeyEnabled, "\067\085\082\083\079\082\032\080\073\067\075\058\032\079\078", "\067\085\082\083\079\082\032\080\073\067\075\058\032\079\070\070")
refreshAutoBuyControls()
syncLabels()
updateAutoStomp()
say("\082\101\097\100\121\058\032\065\110\116\105\045\083\116\111\109\112\032\115\116\111\112\115\032\111\110\032\099\104\097\114\097\099\116\101\114\032\114\101\102\114\101\115\104\059\032\110\111\116\105\102\105\099\097\116\105\111\110\032\111\112\116\105\111\110\115\032\105\110\032\078\079\084\073\070\089\046")
if Me.Character and (S.autoArmor or next(S.autoBuys)) then
    task.spawn(buyAutoItems, Me.Character)
end

                                                                             
Main.Visible = false
ExtraUI.LoadOverlay = make("\070\114\097\109\101", {Parent = Gui, Name = "\082\097\099\101\114\076\111\097\100\105\110\103",
    Size = UDim2.fromScale(1, 1), BackgroundColor3 = C_BG,
    BorderSizePixel = 0, ZIndex = 100})
ExtraUI.LoadCard = round(make("\070\114\097\109\101", {Parent = ExtraUI.LoadOverlay,
    AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(390, 170), BackgroundColor3 = C_PANEL,
    BorderSizePixel = 0, ZIndex = 101}), 0)
make("\085\073\083\116\114\111\107\101", {Parent = ExtraUI.LoadCard, Color = C_BORDER,
    Thickness = 1, Transparency = 0})
ExtraUI.LoadTitle = make("\084\101\120\116\076\097\098\101\108", {Parent = ExtraUI.LoadCard,
    Position = UDim2.fromOffset(24, 25), Size = UDim2.fromOffset(342, 35),
    BackgroundTransparency = 1, Text = "\078\111\115\114\032\083\099\114\105\112\116",
    TextColor3 = C_TEXT, Font = Enum.Font.GothamBold, TextSize = 23,
    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 102})
ExtraUI.LoadCaption = make("\084\101\120\116\076\097\098\101\108", {Parent = ExtraUI.LoadCard,
    Position = UDim2.fromOffset(24, 68), Size = UDim2.fromOffset(342, 24),
    BackgroundTransparency = 1, Text = "\080\082\069\080\065\082\073\078\071\032\067\079\078\084\082\079\076\032\067\079\078\083\079\076\069",
    TextColor3 = C_FAINT, Font = Enum.Font.GothamMedium, TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 102})
ExtraUI.LoadTrack = round(make("\070\114\097\109\101", {Parent = ExtraUI.LoadCard,
    Position = UDim2.fromOffset(24, 117), Size = UDim2.fromOffset(342, 6),
    BackgroundColor3 = C_OFF, BorderSizePixel = 0, ZIndex = 102}), 0)
ExtraUI.LoadFill = round(make("\070\114\097\109\101", {Parent = ExtraUI.LoadTrack,
    Size = UDim2.fromScale(0, 1), BackgroundColor3 = C_ACCENT,
    BorderSizePixel = 0, ZIndex = 103}), 3)
ExtraUI.LoadPercent = make("\084\101\120\116\076\097\098\101\108", {Parent = ExtraUI.LoadCard,
    Position = UDim2.fromOffset(24, 133), Size = UDim2.fromOffset(342, 18),
    BackgroundTransparency = 1, Text = "\048\048\037", TextColor3 = C_ACCENT,
    Font = Enum.Font.GothamBold, TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 102})
task.spawn(function()
    local tweenService = game:GetService("\084\119\101\101\110\083\101\114\118\105\099\101")
    for index, step in ipairs({
        {0.32, "\082\101\115\111\108\118\105\110\103\032\112\108\097\121\101\114\032\114\105\103\115"},
        {0.68, "\067\111\110\110\101\099\116\105\110\103\032\099\111\110\116\114\111\108\115"},
        {1, "\067\111\110\116\114\111\108\032\100\101\099\107\032\114\101\097\100\121"},
    }) do
        if S.closed or not ExtraUI.LoadOverlay.Parent then return end
        ExtraUI.LoadCaption.Text = step[2]
        ExtraUI.LoadPercent.Text = string.format("\037\048\050\100\037\037", step[1] * 100)
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
return cleanup
