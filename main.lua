--[[
 DAH POLISHED LITE - STUTTER REDUCTION EDITION (client-sided)
 Target selection / FOV / target dot / optional raycast silent aim / trigger / bring lock
 Designed for Da Hood Aim Trainer's GUID-named Workspace character containers.

 PERFORMANCE:
  * No Roblox Highlight instances (2D target dot instead)
  * No __index / Mouse.Hit hook
  * No Workspace:GetDescendants() during targeting, or during refresh
  * Workspace GUID container cache maintained with ChildAdded/ChildRemoved events
  * Character references validated incrementally, one player at a time
  * FOV target selection at ~12.5 Hz; HUD updates are capped and pixel-gated
  * Raycast hook is installed only when enabled, reused across reruns
  * Player selection changes only two row colours (no mass TweenService calls)
  * SELECTED targeting evaluates one cached player, not the whole server

 LIMITATIONS:
  * Other people's server-owned movement cannot be authoritatively frozen locally.
  * Silent aim only works with executor hooks + compatible client-side Workspace:Raycast weapons.
  * Triggerbot only fires if the executor exposes mouse1click / mouse1press & mouse1release.
  * You may need to REJOIN to clear hooks from earlier versions of this script.
]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Me = Players.LocalPlayer
if not Me then warn("DAH Lite: LocalPlayer missing") return end
local PlayerGui = Me:WaitForChild("PlayerGui", 10)
if not PlayerGui then warn("DAH Lite: PlayerGui missing") return end

local Env = _G
if type(getgenv) == "function" then
    local ok, result = pcall(getgenv)
    if ok and type(result) == "table" then Env = result end
end

-- Clean up old installations, including legacy scripts from this conversation.
for _, fn in ipairs({
    Env.DAH_PolishedCleanup, Env.DAH_LiteCleanup, Env.DAH_OptimizedCleanup, Env.DAH_AllInOne_Cleanup,
    Env.DAH_AimGuiCleanup, _G.DAHBringLockCleanup, _G.DAHBringFreezeCleanup
}) do
    if type(fn) == "function" then pcall(fn) end
end
for _, key in ipairs({
    "DAH_AllInOneHook", "DAH_RaycastAimHook", "DAH_OptimizedHook", "DAH_LowCostHook"
}) do
    local oldState = Env[key]
    if type(oldState) == "table" then
        oldState.enabled = false
        oldState.mouseCompat = false
        oldState.part = nil
        oldState.point = nil
    end
end
for _, name in ipairs({
    "DAH_StudioLite", "DAH_RebuiltLite", "DAH_OptimizedAllInOne", "DAH_AllInOne",
    "DAHAimGui", "DAHBringLockGUI", "DAHBringFreezeGUI"
}) do
    local existing = PlayerGui:FindFirstChild(name)
    if existing then existing:Destroy() end
end

local S = {
    closed = false,
    selected = nil,       -- player YOU click in the list; never overwritten by aim logic
    aimMode = "FOV",      -- "FOV" or "SELECTED"
    aimTarget = nil,      -- target automatically chosen for aiming
    aimRecord = nil,
    fov = 155,
    showFov = true,
    showDot = true,
    wallCheck = false,   -- off by default for maximum speed
    aimHead = true,
    lead = 0.025,
    trigger = false,
    silent = false,
    cameraAim = false,
    bringData = nil,
    ringSmooth = 28,
    dotSmooth = 24,
    lastShot = 0,
    triggerCooldown = 0.07,
}

local Connections = {}
local Rows = {}
local Registry = {}
local PlayerPool = Players:GetPlayers()
local ContainerList = {}
local ContainerSet = {}
-- The 3D Workspace lookup is essential in this game: keep the GUID folders.
-- Tune HUD_MAX_HZ down to 45 or 30 on weak hardware.
local HUD_MAX_HZ = 60
local CHARACTER_POLL_GAP = 0.018
local CHARACTER_POLL_PAUSE = 1.5
local Mouse = Me:GetMouse()
local Camera = Workspace.CurrentCamera

local PURPLE = Color3.fromRGB(147, 111, 255)
local CYAN = Color3.fromRGB(97, 219, 236)
local GREEN = Color3.fromRGB(59, 207, 157)
local OFF = Color3.fromRGB(36, 42, 61)
local BG = Color3.fromRGB(15, 18, 29)
local PANEL = Color3.fromRGB(23, 28, 43)
local TEXT = Color3.fromRGB(232, 239, 252)
local MUTED = Color3.fromRGB(140, 156, 183)
local function bind(c) Connections[#Connections + 1] = c; return c end
local function mk(class, props)
    local obj = Instance.new(class)
    for property, value in pairs(props) do obj[property] = value end
    return obj
end
local function rounded(obj, radius)
    mk("UICorner", {Parent = obj, CornerRadius = UDim.new(0, radius or 9)})
    return obj
end
local function outline(obj, color, thickness, transparency)
    return mk("UIStroke", {Parent = obj, Color = color or OFF,
        Thickness = thickness or 1, Transparency = transparency or 0})
end
local function tween(obj, fields, seconds)
    if S.closed or not obj or not obj.Parent then return end
    TweenService:Create(obj, TweenInfo.new(seconds or .16, Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out), fields):Play()
end
local function text(parent, content, x, y, w, h, size, color, bold)
    return mk("TextLabel", {Parent = parent, Position = UDim2.fromOffset(x,y),
        Size = UDim2.new(1, -x-w, 0,h), BackgroundTransparency=1,
        Text = content, Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham,
        TextSize = size or 12, TextColor3 = color or TEXT,
        TextXAlignment = Enum.TextXAlignment.Left, TextTruncate=Enum.TextTruncate.AtEnd})
end
local function button(parent, title, x, y, w, h, background)
    local b = rounded(mk("TextButton", {Parent=parent,
        Position = UDim2.fromOffset(x, y), Size=UDim2.fromOffset(w,h),
        BorderSizePixel=0, AutoButtonColor=false,
        BackgroundColor3=background or OFF, Text=title, TextColor3=TEXT,
        Font=Enum.Font.GothamBold, TextSize=11}))
    bind(b.MouseEnter:Connect(function()
        if not S.closed then tween(b,{TextColor3=Color3.new(1,1,1)},.12) end
    end))
    bind(b.MouseLeave:Connect(function()
        if not S.closed then tween(b,{TextColor3=TEXT},.12) end
    end))
    return b
end

-- HUD layer: only two moving frames. Never use Roblox Highlight.
local Gui = mk("ScreenGui", {Name="DAH_StudioLite", Parent=PlayerGui,
    ResetOnSpawn=false, IgnoreGuiInset=true, DisplayOrder=2200,
    ZIndexBehavior=Enum.ZIndexBehavior.Sibling})
local FovRing = rounded(mk("Frame", {Parent=Gui, Name="SmoothFOV",
    AnchorPoint=Vector2.new(.5,.5), Size=UDim2.fromOffset(S.fov*2,S.fov*2),
    BackgroundTransparency=1, ZIndex=1}),999)
FovRing:FindFirstChildOfClass("UICorner").CornerRadius = UDim.new(1,0)
outline(FovRing, PURPLE, 1.35, .12)
-- Four static reticle accents; only the parent ring gets moved.
for i = 0, 3 do
    local angle = i*math.pi/2
    local dot = mk("Frame", {Parent=FovRing, BorderSizePixel=0,
        BackgroundColor3=CYAN, BackgroundTransparency=.2,
        AnchorPoint=Vector2.new(.5,.5),
        Position=UDim2.new(.5+.5*math.cos(angle),0,.5+.5*math.sin(angle),0),
        Size=UDim2.fromOffset(4,4), ZIndex=2})
    rounded(dot, 4)
end
local TargetDot = rounded(mk("Frame", {Parent=Gui, Name="SmoothTargetDot",
    AnchorPoint=Vector2.new(.5,.5), Size=UDim2.fromOffset(9,9),
    BackgroundColor3=GREEN, BorderSizePixel=0, Visible=false, ZIndex=3}),999)
TargetDot:FindFirstChildOfClass("UICorner").CornerRadius = UDim.new(1,0)
outline(TargetDot, Color3.new(1,1,1),1.2,.14)
local TargetHalo=rounded(mk("Frame", {Parent=TargetDot,
    AnchorPoint=Vector2.new(.5,.5), Position=UDim2.fromScale(.5,.5),
    Size=UDim2.fromOffset(19,19), BackgroundTransparency=1,ZIndex=2}),999)
TargetHalo:FindFirstChildOfClass("UICorner").CornerRadius=UDim.new(1,0)
outline(TargetHalo,GREEN,1,.22)

local Shadow=rounded(mk("Frame", {Parent=Gui, Position=UDim2.fromOffset(30,98),
    Size=UDim2.fromOffset(388,574), BackgroundColor3=Color3.new(0,0,0),
    BackgroundTransparency=.55, BorderSizePixel=0,ZIndex=3}),18)
local Main=rounded(mk("Frame", {Parent=Gui, Position=UDim2.fromOffset(24,90),
    Size=UDim2.fromOffset(388,574), BackgroundColor3=BG,
    BorderSizePixel=0, Active=true, ClipsDescendants=true, ZIndex=5}),16)
outline(Main,Color3.fromRGB(86,99,134),1,.35)
mk("UIGradient",{Parent=Main, Rotation=120,
    Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(25,31,48)),
        ColorSequenceKeypoint.new(1,BG)})})
local Accent=mk("Frame",{Parent=Main,Position=UDim2.fromOffset(0,0),
    Size=UDim2.new(1,0,0,3),BackgroundColor3=PURPLE,BorderSizePixel=0,ZIndex=8})
mk("UIGradient",{Parent=Accent,
    Color=ColorSequence.new({ColorSequenceKeypoint.new(0,PURPLE),
        ColorSequenceKeypoint.new(1,CYAN)})})
-- Subtle static header background details (no render loop / particles).
local Bar=mk("Frame",{Parent=Main,Size=UDim2.new(1,0,0,88),
    BackgroundColor3=PANEL,BorderSizePixel=0,Active=true,ZIndex=6})
mk("UIGradient",{Parent=Bar,Rotation=0,
    Color=ColorSequence.new(Color3.fromRGB(30,36,58),PANEL)})
for i=0,4 do
    mk("Frame",{Parent=Bar,Position=UDim2.new(1,-80+i*16,0,6+i*3),
        Size=UDim2.fromOffset(1,63),Rotation=22,BorderSizePixel=0,
        BackgroundColor3=CYAN,BackgroundTransparency=.94,ZIndex=7})
end
text(Bar,"SPECTRA",16,14,185,29,22,TEXT,true)
text(Bar,"DAH  /  TARGETING STUDIO",17,44,160,17,10,MUTED,true)
local LiveTag=rounded(mk("Frame",{Parent=Bar,Position=UDim2.fromOffset(225,19),
    Size=UDim2.fromOffset(62,22),BackgroundColor3=Color3.fromRGB(29,64,63),
    BorderSizePixel=0,ZIndex=7}),11)
mk("Frame",{Parent=LiveTag,Position=UDim2.fromOffset(8,8),
    Size=UDim2.fromOffset(6,6),BackgroundColor3=GREEN,BorderSizePixel=0,ZIndex=8})
local LiveText=mk("TextLabel",{Parent=LiveTag,Size=UDim2.new(1,0,1,0),
    Text="  READY",BackgroundTransparency=1,TextColor3=GREEN,
    Font=Enum.Font.GothamBold,TextSize=9,ZIndex=8})
local Collapse=button(Bar,"−",302,16,31,29)
local Close=button(Bar,"×",341,16,31,29,Color3.fromRGB(110,44,66))
Collapse.TextSize=20; Close.TextSize=19
local TabBar=mk("Frame",{Parent=Main,Position=UDim2.fromOffset(12,96),
    Size=UDim2.fromOffset(364,42),BackgroundColor3=Color3.fromRGB(19,24,38),
    BorderSizePixel=0,ZIndex=7})
rounded(TabBar,9)
local TabIndicator=rounded(mk("Frame",{Parent=TabBar,
    Position=UDim2.fromOffset(3,3),Size=UDim2.fromOffset(118,36),
    BackgroundColor3=Color3.fromRGB(59,51,104),BorderSizePixel=0,ZIndex=7}),7)
local Tabs={}
local TabNames={"PLAYERS","TARGETING","VISUALS"}
for i,name in ipairs(TabNames) do
    local tab=mk("TextButton",{Parent=TabBar,Position=UDim2.fromOffset(3+(i-1)*120,3),
        Size=UDim2.fromOffset(118,36),Text=name,TextSize=10,
        Font=Enum.Font.GothamBold,TextColor3=i==1 and TEXT or MUTED,
        BackgroundTransparency=1,ZIndex=8})
    Tabs[i]=tab
end
local PageHost=mk("Frame",{Parent=Main,Position=UDim2.fromOffset(12,147),
    Size=UDim2.fromOffset(364,340),BackgroundTransparency=1,ClipsDescendants=true,ZIndex=6})
local Pages={}
for i=1,3 do
    Pages[i]=mk("Frame",{Parent=PageHost,Size=UDim2.fromScale(1,1),
        BackgroundTransparency=1,Visible=i==1,ZIndex=6})
end
local PlayerPage,AimPage,VisualPage=Pages[1],Pages[2],Pages[3]
local function pageTitle(parent,heading,subheading)
    text(parent,heading,4,0,8,22,14,TEXT,true)
    text(parent,subheading,4,24,8,18,10,MUTED)
end
pageTitle(PlayerPage,"Players","Choose a player for Bring Lock or selected-target mode")
pageTitle(AimPage,"Targeting","Lightweight target selection and weapon controls")
pageTitle(VisualPage,"Visuals","Smooth HUD tracking without 3D highlighting")
local Search=rounded(mk("TextBox",{Parent=PlayerPage,
    Position=UDim2.fromOffset(3,54),Size=UDim2.fromOffset(358,35),
    BackgroundColor3=OFF, BorderSizePixel=0, Text="",ClearTextOnFocus=false,
    PlaceholderText="  Search username or display name...",
    PlaceholderColor3=MUTED,TextColor3=TEXT,TextSize=12,
    Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left}),9)
local PlayerList=rounded(mk("ScrollingFrame",{Parent=PlayerPage,
    Position=UDim2.fromOffset(3,98),Size=UDim2.fromOffset(358,176),
    BackgroundColor3=Color3.fromRGB(20,25,39),BorderSizePixel=0,
    ScrollBarThickness=3,CanvasSize=UDim2.fromOffset(0,0)}),9)
mk("UIPadding",{Parent=PlayerList,PaddingTop=UDim.new(0,5),
    PaddingLeft=UDim.new(0,5),PaddingRight=UDim.new(0,5)})
local RowLayout=mk("UIListLayout",{Parent=PlayerList,
    SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,4)})
bind(RowLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    PlayerList.CanvasSize=UDim2.fromOffset(0,RowLayout.AbsoluteContentSize.Y+10)
end))
local BringButton=button(PlayerPage,"BRING LOCK  ·  OFF",3,281,232,41)
local Refresh=button(PlayerPage,"REFRESH",243,281,118,41)

local ScopeButton=button(AimPage,"MODE  ·  NEAREST IN FOV",3,55,358,39)
local SilentButton=button(AimPage,"SILENT AIM  ·  OFF",3,102,174,40)
local TriggerButton=button(AimPage,"TRIGGER  ·  OFF",187,102,174,40)
local CameraButton=button(AimPage,"CAMERA AIM  ·  OFF",3,150,174,39)
local WallButton=button(AimPage,"WALL CHECK  ·  OFF",187,150,174,39)
local HeadButton=button(AimPage,"HITBOX  ·  HEAD",3,197,358,36)
local FovLabel=text(AimPage,"FOV RADIUS  ·  155 px",4,245,8,22,11,TEXT,true)
local fovMinus=button(AimPage,"−",3,277,34,34)
local fovPlus=button(AimPage,"+",327,277,34,34)
local FovTrack=rounded(mk("Frame",{Parent=AimPage,
    Position=UDim2.fromOffset(46,291),Size=UDim2.fromOffset(272,5),
    BackgroundColor3=OFF,BorderSizePixel=0,Active=true}),4)
local FovFill=rounded(mk("Frame",{Parent=FovTrack,
    Size=UDim2.fromScale((S.fov-35)/365,1),BackgroundColor3=PURPLE,
    BorderSizePixel=0}),4)
local FovThumb=rounded(mk("Frame",{Parent=FovTrack,
    AnchorPoint=Vector2.new(.5,.5), Position=UDim2.fromScale((S.fov-35)/365,.5),
    Size=UDim2.fromOffset(13,13),BackgroundColor3=TEXT,BorderSizePixel=0}),8)
local AimNote=text(AimPage,"Weapon compatibility depends on the game's firing system.",4,319,8,16,10,MUTED)

local FovButton=button(VisualPage,"FOV RING  ·  ON",3,56,358,40)
local DotButton=button(VisualPage,"TARGET DOT  ·  ON",3,103,358,40)
local DotSmoothLabel=text(VisualPage,"TARGET DOT RESPONSE  ·  24",4,163,8,21,11,TEXT,true)
local DotTrack=rounded(mk("Frame",{Parent=VisualPage,
    Position=UDim2.fromOffset(6,198),Size=UDim2.fromOffset(350,5),
    BackgroundColor3=OFF,BorderSizePixel=0,Active=true}),4)
local DotFill=rounded(mk("Frame",{Parent=DotTrack,Size=UDim2.fromScale((S.dotSmooth-6)/54,1),
    BackgroundColor3=CYAN,BorderSizePixel=0}),4)
local DotThumb=rounded(mk("Frame",{Parent=DotTrack,
    AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale((S.dotSmooth-6)/54,.5),
    Size=UDim2.fromOffset(13,13),BackgroundColor3=TEXT,BorderSizePixel=0}),8)
local RingSmoothLabel=text(VisualPage,"FOV FOLLOW RESPONSE  ·  28",4,228,8,21,11,TEXT,true)
local RingTrack=rounded(mk("Frame",{Parent=VisualPage,
    Position=UDim2.fromOffset(6,264),Size=UDim2.fromOffset(350,5),
    BackgroundColor3=OFF,BorderSizePixel=0,Active=true}),4)
local RingFill=rounded(mk("Frame",{Parent=RingTrack,
    Size=UDim2.fromScale((S.ringSmooth-6)/54,1),BackgroundColor3=CYAN,
    BorderSizePixel=0}),4)
local RingThumb=rounded(mk("Frame",{Parent=RingTrack,
    AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale((S.ringSmooth-6)/54,.5),
    Size=UDim2.fromOffset(13,13),BackgroundColor3=TEXT,BorderSizePixel=0}),8)
text(VisualPage,"Lower = smoother trail   •   Higher = faster tracking",4,294,8,18,10,MUTED)

local Footer=rounded(mk("Frame",{Parent=Main,
    Position=UDim2.fromOffset(12,497),Size=UDim2.fromOffset(364,63),
    BackgroundColor3=Color3.fromRGB(20,26,40),BorderSizePixel=0,ZIndex=7}),10)
outline(Footer,Color3.fromRGB(77,92,117),1,.74)
local SelectedText=text(Footer,"Selected  ·  none",11,8,18,17,11,MUTED,true)
local AimText=text(Footer,"Aim target  ·  none",11,25,18,17,11,TEXT,true)
local Status=text(Footer,"Ready. Low-cost target selection active.",11,43,18,17,10,CYAN)

local activeTab=1
local function chooseTab(tabNum)
    if activeTab==tabNum or S.closed then return end
    activeTab=tabNum
    for i,frame in ipairs(Pages) do
        frame.Visible=(i==tabNum)
        frame.Position=UDim2.fromOffset(i==tabNum and 8 or 0,0)
        if i==tabNum then tween(frame,{Position=UDim2.fromOffset(0,0)},.18) end
        tween(Tabs[i],{TextColor3=i==tabNum and TEXT or MUTED},.15)
    end
    tween(TabIndicator,{Position=UDim2.fromOffset(3+(tabNum-1)*120,3)},.20)
end
for i,tab in ipairs(Tabs) do
    bind(tab.MouseButton1Click:Connect(function() chooseTab(i) end))
end
local function status(msg)
    if not S.closed then Status.Text=msg end
end
local function style(btn, enabled, yes, no)
    btn.Text=enabled and yes or no
    tween(btn,{BackgroundColor3=enabled and Color3.fromRGB(40,91,86) or OFF},.17)
end
local function syncShadow()
    Shadow.Position=UDim2.new(Main.Position.X.Scale,Main.Position.X.Offset+6,
        Main.Position.Y.Scale,Main.Position.Y.Offset+8)
end

-- Da Hood Aim Trainer keeps some live characters inside GUID-named Workspace
-- folders. Discover them once and track Workspace changes; don't repeatedly
-- allocate and traverse Workspace:GetChildren() in a periodic hot loop.
local function isCharacterContainer(parent)
    if not (parent:IsA("Folder") or parent:IsA("Model")) or parent.Name == "Map" then
        return false
    end
    local name = parent.Name
    return (#name >= 30 and name:find("%-") ~= nil)
        or name == "Players" or name == "Characters"
        or name == "Live" or name == "Entities"
end
local function registerContainer(parent)
    if not ContainerSet[parent] and isCharacterContainer(parent) then
        ContainerSet[parent] = true
        ContainerList[#ContainerList + 1] = parent
    end
end
local function unregisterContainer(parent)
    if not ContainerSet[parent] then return end
    ContainerSet[parent] = nil
    for i = #ContainerList, 1, -1 do
        if ContainerList[i] == parent then
            table.remove(ContainerList, i)
            break
        end
    end
end
local function rebuildContainerList()
    table.clear(ContainerSet)
    table.clear(ContainerList)
    for _, parent in ipairs(Workspace:GetChildren()) do
        registerContainer(parent)
    end
end
-- A new GUID folder must be usable immediately; do not wait for full scans.
bind(Workspace.ChildAdded:Connect(registerContainer))
bind(Workspace.ChildRemoved:Connect(unregisterContainer))

local function createRecord(p, model)
    if not model or not model:IsA("Model") or not model:IsDescendantOf(Workspace) then return nil end
    local hum = model:FindFirstChildOfClass("Humanoid")
    local root = model:FindFirstChild("HumanoidRootPart", true)
    if not (hum and root and root:IsA("BasePart")) then return nil end
    local rec = {player = p, model = model, humanoid = hum, root = root,
        head = model:FindFirstChild("Head", true)}
    Registry[p] = rec
    return rec
end
local function valid(rec)
    return rec ~= nil and rec.model.Parent ~= nil
        and rec.root.Parent ~= nil and rec.humanoid.Parent ~= nil
        and rec.player.Parent == Players
end
local function resolveRecord(p)
    if not p or p.Parent ~= Players then return nil end
    local rec = Registry[p]
    if valid(rec) and rec.humanoid.Health > 0 then
        if not p.Character or p.Character == rec.model then return rec end
        local newest = createRecord(p, p.Character)
        if newest then return newest end
        return rec
    end
    Registry[p] = nil
    if p.Character then
        rec = createRecord(p, p.Character)
        if rec then return rec end
    end
    local direct = Workspace:FindFirstChild(p.Name)
    if direct then
        rec = createRecord(p, direct)
        if rec then return rec end
    end
    for i = 1, #ContainerList do
        local folder = ContainerList[i]
        if folder.Parent then
            local candidate = folder:FindFirstChild(p.Name)
            if candidate then
                rec = createRecord(p, candidate)
                if rec then return rec end
            end
        end
    end
    return nil
end
local function refreshCharacterCache(forceRebuild)
    -- Forced rebuild is used only by the explicit REFRESH button and startup.
    if forceRebuild then rebuildContainerList() end
    for i = 1, #PlayerPool do
        resolveRecord(PlayerPool[i])
    end
end
local function aimPart(rec)
    if not valid(rec) then return nil end
    local h = rec.head
    if S.aimHead and h and h.Parent and h:IsA("BasePart") then return h end
    return rec.root
end

-- Global raycast hook persists between reruns, but is installed at most once.
-- No global __index / Mouse.Hit hook: those were a major FPS bottleneck.
local Hook = Env.__DAH_LITE_RAYCAST
if type(Hook) ~= "table" then
    Hook = {installed = false, active = false, part = nil,
        lead = 0, ownRoot = nil, skip = false}
    Env.__DAH_LITE_RAYCAST = Hook
end
Hook.active = false
Hook.part = nil
Hook.skip = false
local function installRayHook()
    if Hook.installed then return true end
    if type(hookmetamethod) ~= "function" or type(getnamecallmethod) ~= "function" then
        return false, "Silent unavailable: executor lacks raycast hooks."
    end
    local original
    local function hooked(self, ...)
        -- Very short fast path for normal engine namecalls.
        if not Hook.active or Hook.skip or self ~= Workspace or getnamecallmethod() ~= "Raycast" then
            return original(self, ...)
        end
        if type(checkcaller) == "function" and checkcaller() then
            return original(self, ...)
        end
        local origin, direction, rayParams = ...
        local part = Hook.part
        if not part or not part.Parent or typeof(origin) ~= "Vector3"
            or typeof(direction) ~= "Vector3" then
            return original(self, ...)
        end
        local distance = direction.Magnitude
        if distance < 18 then return original(self, ...) end
        -- Do not redirect incidental map rays originating far from your camera/body.
        local cam = Workspace.CurrentCamera
        if not cam then return original(self, ...) end
        if (origin - cam.CFrame.Position).Magnitude > 19 then
            local myRoot = Hook.ownRoot
            if not myRoot or not myRoot.Parent or (origin - myRoot.Position).Magnitude > 22 then
                return original(self, ...)
            end
        end
        local targetPos = part.Position + part.AssemblyLinearVelocity * Hook.lead
        local delta = targetPos - origin
        if delta.Magnitude <= 0.01 then return original(self, ...) end
        return original(self, origin, delta.Unit * distance, rayParams)
    end
    local wrapped = type(newcclosure) == "function" and newcclosure(hooked) or hooked
    local ok, old = pcall(function()
        return hookmetamethod(game, "__namecall", wrapped)
    end)
    if ok and type(old) == "function" then
        original = old
        Hook.installed = true
        return true
    end
    return false, "Silent unavailable: executor rejected hook."
end

-- Target selection updates at 12.5 Hz, NOT per frame.
-- In SELECTED mode, only evaluate the chosen player's cached record.
-- This avoids scanning every player when selection is already explicit.
local WallParams = RaycastParams.new()
WallParams.FilterType = Enum.RaycastFilterType.Exclude
WallParams.IgnoreWater = true
local LastOwnModel = nil
local function unobstructed(rec, part, cam)
    if not S.wallCheck then return true end
    local own = Registry[Me]
    local ownModel = own and own.model or nil
    if LastOwnModel ~= ownModel then
        LastOwnModel = ownModel
        WallParams.FilterDescendantsInstances = ownModel and {ownModel} or {}
    end
    local start = cam.CFrame.Position
    Hook.skip = true
    local ok, result = pcall(Workspace.Raycast, Workspace, start, part.Position - start, WallParams)
    Hook.skip = false
    if not ok then return false end
    return not result or result.Instance:IsDescendantOf(rec.model)
end
local function targetCenter(cam)
    local loc = UIS:GetMouseLocation()
    if UIS.MouseBehavior == Enum.MouseBehavior.LockCenter then
        local v = cam.ViewportSize
        return v.X * 0.5, v.Y * 0.5
    end
    return loc.X, loc.Y
end
local function selectTarget(cam)
    local cx, cy = targetCenter(cam)
    local maxDist2 = S.fov * S.fov
    if S.aimMode == "SELECTED" then
        -- Keep the exact same Workspace-resolved Registry, screen-FOV and
        -- wall-check rules; just skip the unnecessary PlayerPool traversal.
        local p = S.selected
        local rec = p and Registry[p] or nil
        if not rec or not valid(rec) or rec.humanoid.Health <= 0 then
            return nil
        end
        local part = aimPart(rec)
        if not part then return nil end
        local point, onScreen = cam:WorldToViewportPoint(part.Position)
        if not onScreen or point.Z <= 0 then return nil end
        local dx, dy = point.X - cx, point.Y - cy
        if dx * dx + dy * dy > maxDist2 then return nil end
        return unobstructed(rec, part, cam) and rec or nil
    end
    local previous = S.aimTarget
    local first, second, firstScore, secondScore
    firstScore, secondScore = math.huge, math.huge
    for i = 1, #PlayerPool do
        local p = PlayerPool[i]
        if p ~= Me and (S.aimMode ~= "SELECTED" or p == S.selected) then
            local rec = Registry[p]
            if valid(rec) and rec.humanoid.Health > 0 then
                local part = aimPart(rec)
                if part then
                    local point, onScreen = cam:WorldToViewportPoint(part.Position)
                    if onScreen and point.Z > 0 then
                        local dx, dy = point.X - cx, point.Y - cy
                        local distance2 = dx * dx + dy * dy
                        if distance2 <= maxDist2 then
                            -- Sticky target reduces rapid flicker between similar players.
                            local score = distance2 * (p == previous and 0.82 or 1)
                            if score < firstScore then
                                second, secondScore = first, firstScore
                                first, firstScore = rec, score
                            elseif score < secondScore then
                                second, secondScore = rec, score
                            end
                        end
                    end
                end
            end
        end
    end
    -- Wall check only the two closest candidates, never the whole server.
    if first and unobstructed(first, aimPart(first), cam) then return first end
    if second and unobstructed(second, aimPart(second), cam) then return second end
    return nil
end
local function setAimRecord(rec)
    if rec == S.aimRecord then return end
    S.aimRecord = rec
    S.aimTarget = rec and rec.player or nil
    AimText.Text = "Aim target  ·  " .. (rec and ("@" .. rec.player.Name) or "none")
    Hook.part = rec and aimPart(rec) or nil
end

local function stopBring()
    local b = S.bringData
    S.bringData = nil
    if b then
        for part, previous in pairs(b.parts) do
            if part.Parent then pcall(function() part.Anchored = previous end) end
        end
    end
    BringButton.Text = "BRING LOCK  ·  OFF"
    BringButton.BackgroundColor3 = OFF
end
local function startBring()
    if not S.selected then return status("Select someone in the player list first.") end
    if not valid(Registry[S.selected]) then resolveRecord(S.selected) end
    if not valid(Registry[Me]) then resolveRecord(Me) end
    local target, own = Registry[S.selected], Registry[Me]
    if not valid(target) then return status("Target model unavailable. Try REFRESH.") end
    if not valid(own) then return status("Your model unavailable. Try REFRESH.") end
    local snapshot = {}
    for _, obj in ipairs(target.model:GetDescendants()) do
        if obj:IsA("BasePart") then snapshot[obj] = obj.Anchored end
    end
    local desired = own.root.CFrame * CFrame.new(0, 0, -4)
    local pivot = desired * target.root.CFrame:Inverse() * target.model:GetPivot()
    local ok, err = pcall(function()
        target.model:PivotTo(pivot)
        for obj in pairs(snapshot) do
            if obj.Parent then
                obj.AssemblyLinearVelocity = Vector3.zero
                obj.AssemblyAngularVelocity = Vector3.zero
                obj.Anchored = true
            end
        end
    end)
    if not ok then
        for obj, previous in pairs(snapshot) do
            if obj.Parent then pcall(function() obj.Anchored = previous end) end
        end
        return status("Bring failed: " .. tostring(err))
    end
    S.bringData = {player = S.selected, parts = snapshot}
    BringButton.Text = "BRING LOCK  ·  ON"
    BringButton.BackgroundColor3 = Color3.fromRGB(40,91,86)
    status("Local bring/anchor applied once. Server may override.")
end

-- Player selection is constant-time: only TWO rows can change on a click.
-- Avoid creating one TweenService animation per player (the main click spike).
local SELECTED_ROW_COLOR = Color3.fromRGB(68,57,109)
local function updateRowSelection(previous, current)
    if previous == current then return end
    local oldRow = previous and Rows[previous] or nil
    if oldRow and oldRow.Parent then oldRow.BackgroundColor3 = OFF end
    local newRow = current and Rows[current] or nil
    if newRow and newRow.Parent then newRow.BackgroundColor3 = SELECTED_ROW_COLOR end
end
local function removeRows()
    for _, row in pairs(Rows) do row:Destroy() end
    table.clear(Rows)
end
local function refreshRows()
    if S.closed then return end
    removeRows()
    local query = Search.Text:lower()
    local matches = {}
    for i = 1, #PlayerPool do
        local p = PlayerPool[i]
        if p ~= Me and (p.Name:lower():find(query, 1, true)
            or p.DisplayName:lower():find(query, 1, true)) then
            matches[#matches + 1] = p
        end
    end
    table.sort(matches, function(a, b) return a.Name:lower() < b.Name:lower() end)
    for i = 1, #matches do
        local p = matches[i]
        local row = rounded(mk("TextButton", {
            Name = p.Name, Parent = PlayerList, LayoutOrder = i,
            Size = UDim2.new(1, 0, 0, 34), BorderSizePixel = 0,
            BackgroundColor3 = p == S.selected and SELECTED_ROW_COLOR or OFF,
            Text = "  " .. p.DisplayName .. " (@" .. p.Name .. ")",
            TextColor3 = TEXT, TextSize = 12,
            Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left
        }))
        outline(row,Color3.fromRGB(74,83,115),1,.83)
        Rows[p] = row
        row.MouseButton1Click:Connect(function()
            if S.closed or p.Parent ~= Players then return end
            local previous = S.selected
            if previous == p then return end -- repeat click = no work
            -- Stopping Bring Lock is only needed if it's actually active.
            -- Previously it also rewrote two GUI properties on every click.
            if S.bringData then stopBring() end
            S.selected = p
            updateRowSelection(previous, p)
            SelectedText.Text = "Selected  ·  @" .. p.Name
            status("Selected @" .. p.Name .. ". Aim mode: " .. S.aimMode)
            -- No list rebuild, per-player tweens, or synchronous Workspace scan.
        end)
    end
end

local function updatePool()
    PlayerPool = Players:GetPlayers()
    table.sort(PlayerPool, function(a, b) return a.Name < b.Name end)
    refreshRows()
end

-- Optional trigger: Mouse.Target avoids an extra Workspace raycast per check.
local canClick = type(mouse1click) == "function"
    or (type(mouse1press) == "function" and type(mouse1release) == "function")
local TriggerPressed = false
local function clickMouse()
    if type(mouse1click) == "function" then return pcall(mouse1click) end
    if type(mouse1press) == "function" and type(mouse1release) == "function" then
        if TriggerPressed then return false end
        local ok = pcall(mouse1press)
        if not ok then return false end
        TriggerPressed = true
        task.delay(0.022, function()
            pcall(mouse1release)
            TriggerPressed = false
        end)
        return true
    end
    return false
end
local function triggerTick(now)
    if not S.trigger or not S.aimRecord or (now - S.lastShot) < S.triggerCooldown
        or UIS:GetFocusedTextBox() then return end
    local hit = Mouse.Target
    if hit and hit:IsDescendantOf(S.aimRecord.model) then
        S.lastShot = now
        if not clickMouse() then
            S.trigger = false
            style(TriggerButton, false, "TRIGGER  ·  ON", "TRIGGER  ·  OFF")
            status("Trigger click failed / not supported by executor.")
        end
    end
end

-- BUTTONS
bind(BringButton.MouseButton1Click:Connect(function()
    if S.bringData then stopBring(); status("Bring Lock OFF.") else startBring() end
end))
bind(ScopeButton.MouseButton1Click:Connect(function()
    S.aimMode = S.aimMode == "FOV" and "SELECTED" or "FOV"
    ScopeButton.Text = S.aimMode == "FOV" and "MODE  ·  NEAREST IN FOV" or "MODE  ·  SELECTED PLAYER"
    if S.aimMode == "SELECTED" and not S.selected then
        status("Select a player in the Players tab first.")
    end
    setAimRecord(nil)
end))
bind(SilentButton.MouseButton1Click:Connect(function()
    if not S.silent then
        local ok, reason = installRayHook()
        if not ok then return status(reason) end
    end
    S.silent = not S.silent
    Hook.active = S.silent
    style(SilentButton,S.silent,"SILENT AIM  ·  ON","SILENT AIM  ·  OFF")
    status(S.silent and "Raycast hook active. Weapon compatibility varies." or "Silent aim OFF.")
end))
bind(TriggerButton.MouseButton1Click:Connect(function()
    if not S.trigger and not canClick then
        return status("Trigger unavailable: mouse-click API missing.")
    end
    S.trigger = not S.trigger
    style(TriggerButton,S.trigger,"TRIGGER  ·  ON","TRIGGER  ·  OFF")
end))
bind(CameraButton.MouseButton1Click:Connect(function()
    S.cameraAim=not S.cameraAim
    style(CameraButton,S.cameraAim,"CAMERA AIM  ·  ON","CAMERA AIM  ·  OFF")
end))
bind(WallButton.MouseButton1Click:Connect(function()
    S.wallCheck=not S.wallCheck
    style(WallButton,S.wallCheck,"WALL CHECK  ·  ON","WALL CHECK  ·  OFF")
end))
bind(HeadButton.MouseButton1Click:Connect(function()
    S.aimHead=not S.aimHead
    HeadButton.Text=S.aimHead and "HITBOX  ·  HEAD" or "HITBOX  ·  BODY"
    Hook.part=S.aimRecord and aimPart(S.aimRecord) or nil
end))
bind(DotButton.MouseButton1Click:Connect(function()
    S.showDot=not S.showDot
    style(DotButton,S.showDot,"TARGET DOT  ·  ON","TARGET DOT  ·  OFF")
    if not S.showDot then TargetDot.Visible=false end
end))
bind(FovButton.MouseButton1Click:Connect(function()
    S.showFov=not S.showFov
    style(FovButton,S.showFov,"FOV RING  ·  ON","FOV RING  ·  OFF")
    FovRing.Visible=S.showFov
end))
local function setFov(value)
    S.fov=math.clamp(math.floor(value+.5),35,400)
    FovLabel.Text="FOV RADIUS  ·  "..S.fov.." px"
    local v=(S.fov-35)/365
    FovFill.Size=UDim2.fromScale(v,1)
    FovThumb.Position=UDim2.fromScale(v,.5)
end
bind(fovMinus.MouseButton1Click:Connect(function() setFov(S.fov-20) end))
bind(fovPlus.MouseButton1Click:Connect(function() setFov(S.fov+20) end))
local activeSlider=nil
local function setSlider(name,x)
    if name=="FOV" then
        setFov(35+365*x)
    elseif name=="DOT" then
        S.dotSmooth=math.floor(6+x*54+.5)
        DotSmoothLabel.Text="TARGET DOT RESPONSE  ·  "..S.dotSmooth
        DotFill.Size=UDim2.fromScale(x,1)
        DotThumb.Position=UDim2.fromScale(x,.5)
    elseif name=="RING" then
        S.ringSmooth=math.floor(6+x*54+.5)
        RingSmoothLabel.Text="FOV FOLLOW RESPONSE  ·  "..S.ringSmooth
        RingFill.Size=UDim2.fromScale(x,1)
        RingThumb.Position=UDim2.fromScale(x,.5)
    end
end
local function setSliderFromInput(name,track,input)
    local x=math.clamp((input.Position.X-track.AbsolutePosition.X)/math.max(track.AbsoluteSize.X,1),0,1)
    setSlider(name,x)
end
for _,item in ipairs({{"FOV",FovTrack,FovThumb},{"DOT",DotTrack,DotThumb},{"RING",RingTrack,RingThumb}}) do
    local name,track,thumb=item[1],item[2],item[3]
    for _,hitArea in ipairs({track,thumb}) do
        bind(hitArea.InputBegan:Connect(function(input)
            if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
                activeSlider={name=name,track=track}
                setSliderFromInput(name,track,input)
            end
        end))
    end
end
bind(UIS.InputChanged:Connect(function(input)
    if activeSlider and (input.UserInputType==Enum.UserInputType.MouseMovement
        or input.UserInputType==Enum.UserInputType.Touch) then
        setSliderFromInput(activeSlider.name,activeSlider.track,input)
    end
end))
bind(UIS.InputEnded:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1
        or input.UserInputType==Enum.UserInputType.Touch then activeSlider=nil end
end))
bind(Refresh.MouseButton1Click:Connect(function()
    refreshCharacterCache(true)
    updatePool()
    status("Character cache refreshed.")
end))

bind(Search:GetPropertyChangedSignal("Text"):Connect(refreshRows))
bind(Players.PlayerAdded:Connect(function(p)
    updatePool()
    bind(p.CharacterAdded:Connect(function(model)
        task.delay(.35, function()
            if not S.closed and p.Parent == Players then createRecord(p, model) end
        end)
    end))
end))
bind(Players.PlayerRemoving:Connect(function(p)
    Registry[p] = nil
    if S.selected == p then
        stopBring()
        S.selected = nil
        SelectedText.Text = "Selected  ·  none"
    end
    if S.aimTarget == p then setAimRecord(nil) end
    updatePool()
end))
for i = 1, #PlayerPool do
    local p = PlayerPool[i]
    bind(p.CharacterAdded:Connect(function(model)
        task.delay(.35, function()
            if not S.closed and p.Parent == Players then createRecord(p, model) end
        end)
    end))
end

-- Render callback: aiming can still use the current frame (camera aim stays
-- smooth), but expensive GUI invalidations are capped and quantized.
local accumulatorSelect, accumulatorTrigger, accumulatorHud = 0, 0, 0
local HUD_INTERVAL = 1 / HUD_MAX_HZ
local smoothRingPos, smoothDotPos, shownRadius, lastDotRec = nil, nil, S.fov, nil
local ringX, ringY, ringDiameter = nil, nil, nil
local dotX, dotY = nil, nil
local function expAlpha(rate, dt)
    return 1 - math.exp(-rate * math.min(dt, .08))
end
local function setDotVisible(visible)
    if TargetDot.Visible ~= visible then TargetDot.Visible = visible end
end
bind(RunService.RenderStepped:Connect(function(dt)
    if S.closed then return end
    Camera = Workspace.CurrentCamera
    if not Camera then return end
    accumulatorSelect = accumulatorSelect + dt
    accumulatorTrigger = accumulatorTrigger + dt
    accumulatorHud = accumulatorHud + dt

    local needsAim = S.silent or S.trigger or S.cameraAim or S.showDot
    if needsAim and accumulatorSelect >= .08 then
        accumulatorSelect = 0
        setAimRecord(selectTarget(Camera))
        if S.silent then
            Hook.part = S.aimRecord and aimPart(S.aimRecord) or nil
            Hook.lead = S.lead
            local mine = Registry[Me]
            Hook.ownRoot = valid(mine) and mine.root or nil
        end
    elseif not needsAim and S.aimRecord then
        setAimRecord(nil)
    end

    if S.trigger and accumulatorTrigger >= .03 then
        accumulatorTrigger = 0
        triggerTick(os.clock())
    end

    local rec = S.aimRecord
    local cameraAimPart = S.cameraAim and rec and aimPart(rec) or nil
    -- Camera aim must not drop to the HUD rate: it stays at render frequency.
    if S.cameraAim and cameraAimPart and cameraAimPart.Parent then
        local from = Camera.CFrame
        local desired = CFrame.lookAt(from.Position, cameraAimPart.Position)
        Camera.CFrame = from:Lerp(desired, expAlpha(10, dt))
    end

    if accumulatorHud < HUD_INTERVAL then return end
    local visualDt = accumulatorHud
    -- Preserve the fractional remainder to avoid uneven 30/45 Hz updates on
    -- high-refresh displays (where dt rarely divides the HUD interval).
    accumulatorHud = accumulatorHud % HUD_INTERVAL

    if S.showFov then
        local x, y = targetCenter(Camera)
        local desired = Vector2.new(x, y)
        if not smoothRingPos or UIS.MouseBehavior == Enum.MouseBehavior.LockCenter then
            smoothRingPos = desired
        else
            smoothRingPos = smoothRingPos:Lerp(desired, expAlpha(S.ringSmooth, visualDt))
        end
        shownRadius = shownRadius + (S.fov - shownRadius) * expAlpha(21, visualDt)
        -- GUI property changes (especially size+UICorner+UIStroke) cause work.
        -- Only send a change to Roblox when a visible pixel actually changes.
        local newX = math.floor(smoothRingPos.X + .5)
        local newY = math.floor(smoothRingPos.Y + .5)
        if newX ~= ringX or newY ~= ringY then
            ringX, ringY = newX, newY
            FovRing.Position = UDim2.fromOffset(newX, newY)
        end
        local newDiameter = math.floor(shownRadius * 2 + .5)
        if newDiameter ~= ringDiameter then
            ringDiameter = newDiameter
            FovRing.Size = UDim2.fromOffset(newDiameter, newDiameter)
        end
    else
        smoothRingPos, ringX, ringY, ringDiameter = nil, nil, nil, nil
        shownRadius = S.fov
    end

    -- Maintain live Workspace-part projection; the dot is simply drawn less
    -- wastefully. Aim selection, the raycast hook, and target physics are intact.
    local dotPart = S.showDot and (cameraAimPart or (rec and aimPart(rec))) or nil
    if dotPart and dotPart.Parent then
        local pt, visible = Camera:WorldToViewportPoint(dotPart.Position)
        if visible and pt.Z > 0 then
            local desired = Vector2.new(pt.X, pt.Y)
            if lastDotRec ~= rec or not smoothDotPos then
                smoothDotPos, lastDotRec = desired, rec
            else
                smoothDotPos = smoothDotPos:Lerp(desired, expAlpha(S.dotSmooth, visualDt))
            end
            local newX = math.floor(smoothDotPos.X + .5)
            local newY = math.floor(smoothDotPos.Y + .5)
            if newX ~= dotX or newY ~= dotY then
                dotX, dotY = newX, newY
                TargetDot.Position = UDim2.fromOffset(newX, newY)
            end
            setDotVisible(true)
        else
            setDotVisible(false)
            lastDotRec, smoothDotPos, dotX, dotY = nil, nil, nil, nil
        end
    else
        setDotVisible(false)
        lastDotRec, smoothDotPos, dotX, dotY = nil, nil, nil, nil
    end
end))

-- Stagger cache validation so one frame doesn't resolve an entire server.
-- This retains the original fallback search inside GUID Workspace folders.
task.spawn(function()
    while not S.closed do
        local pool = PlayerPool
        for i = 1, #pool do
            if S.closed then break end
            local p = pool[i]
            if p.Parent == Players then resolveRecord(p) end
            task.wait(CHARACTER_POLL_GAP)
        end
        task.wait(CHARACTER_POLL_PAUSE)
    end
end)

-- Smooth panel drag and responsive collapse. No animation runs while idle.
local dragging, dragInput, dragStart, startPosition=false,nil,nil,nil
local dragEndConnection=nil
bind(Bar.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1
        or input.UserInputType==Enum.UserInputType.Touch then
        dragging=true
        dragStart=input.Position
        startPosition=Main.Position
        if dragEndConnection then dragEndConnection:Disconnect() end
        dragEndConnection=input.Changed:Connect(function()
            if input.UserInputState==Enum.UserInputState.End then
                dragging=false
                if dragEndConnection then dragEndConnection:Disconnect() end
                dragEndConnection=nil
            end
        end)
    end
end))
bind(Bar.InputChanged:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseMovement
        or input.UserInputType==Enum.UserInputType.Touch then dragInput=input end
end))
bind(UIS.InputChanged:Connect(function(input)
    if dragging and input==dragInput then
        local delta=input.Position-dragStart
        Main.Position=UDim2.new(startPosition.X.Scale,startPosition.X.Offset+delta.X,
            startPosition.Y.Scale,startPosition.Y.Offset+delta.Y)
        syncShadow()
    end
end))
local collapsed=false
bind(Collapse.MouseButton1Click:Connect(function()
    collapsed=not collapsed
    if collapsed then
        for _,page in ipairs(Pages) do page.Visible=false end
        TabBar.Visible=false; Footer.Visible=false; PageHost.Visible=false
        tween(Main,{Size=UDim2.fromOffset(388,88)},.23)
        tween(Shadow,{Size=UDim2.fromOffset(388,88)},.23)
    else
        TabBar.Visible=true; Footer.Visible=true; PageHost.Visible=true
        Pages[activeTab].Visible=true
        tween(Main,{Size=UDim2.fromOffset(388,574)},.23)
        tween(Shadow,{Size=UDim2.fromOffset(388,574)},.23)
    end
    Collapse.Text=collapsed and "+" or "−"
end))

local function cleanup()
    if S.closed then return end
    S.closed = true
    S.silent = false
    S.trigger = false
    Hook.active = false
    Hook.part = nil
    stopBring()
    for i = 1, #Connections do Connections[i]:Disconnect() end
    table.clear(Connections)
    if dragEndConnection then dragEndConnection:Disconnect(); dragEndConnection = nil end
    if Gui.Parent then Gui:Destroy() end
end
Env.DAH_LiteCleanup = cleanup
Env.DAH_PolishedCleanup = cleanup
bind(Close.MouseButton1Click:Connect(cleanup))
bind(Gui.Destroying:Connect(cleanup))

-- INITIAL STATE
refreshCharacterCache(true)
refreshRows()
FovRing.Visible = S.showFov
style(DotButton, S.showDot, "TARGET DOT  ·  ON", "TARGET DOT  ·  OFF")
style(FovButton, S.showFov, "FOV RING  ·  ON", "FOV RING  ·  OFF")
status("Ready  ·  Staggered Workspace cache / capped HUD")
-- Subtle entrance animation, once per execution.
Main.Position=UDim2.fromOffset(24,108)
Main.BackgroundTransparency=.18
tween(Main,{Position=UDim2.fromOffset(24,90),BackgroundTransparency=0},.35)
Shadow.Position=UDim2.fromOffset(30,116)
tween(Shadow,{Position=UDim2.fromOffset(30,98)},.35)
