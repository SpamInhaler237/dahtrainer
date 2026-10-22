-- RACER Luau source (obfuscated; no runtime loader required).

local _vcd60f2e5219a = game : GetService ( "\080\108\097\121\101\114\115" )
local _v8b8ca6137d87 = game : GetService ( "\087\111\114\107\115\112\097\099\101" )
local _v7ab6349c26e8 = game : GetService ( "\082\101\112\108\105\099\097\116\101\100\083\116\111\114\097\103\101" )
local _vcb684e26a41a = game : GetService ( "\085\115\101\114\073\110\112\117\116\083\101\114\118\105\099\101" )
local _v286a8fc93150 = game : GetService ( "\082\117\110\083\101\114\118\105\099\101" )
local _vad430fdb5ce8 = _vcd60f2e5219a . LocalPlayer
if not _vad430fdb5ce8 then return end
local _v1a7872bd90b1 = _vad430fdb5ce8 : WaitForChild ( "\080\108\097\121\101\114\071\117\105" , 10 )
if not _v1a7872bd90b1 then return end
local _v5680cea30ae2 = _G
if type ( getgenv ) == "\102\117\110\099\116\105\111\110" then
local ok , result = pcall ( getgenv )
if ok and type ( result ) == "\116\097\098\108\101" then _v5680cea30ae2 = result end
end
if type ( queue_on_teleport ) == "\102\117\110\099\116\105\111\110" then
pcall ( function ( )
queue_on_teleport ( [=[
            task.wait(2)
            local scriptFile = loadfile([[RACER_AutoCombat_Fixed.luau]])
            if scriptFile then scriptFile() end
        ]=] )
end )
end
for _ , name in ipairs ( {
"\083\112\101\099\116\114\097\083\101\108\101\099\116\067\108\101\097\110\117\112" , "\068\065\072\095\076\105\116\101\067\108\101\097\110\117\112" , "\068\065\072\095\080\111\108\105\115\104\101\100\067\108\101\097\110\117\112" ,
"\068\065\072\095\079\112\116\105\109\105\122\101\100\067\108\101\097\110\117\112" , "\068\065\072\095\065\108\108\073\110\079\110\101\095\067\108\101\097\110\117\112" , "\068\065\072\095\065\105\109\071\117\105\067\108\101\097\110\117\112"
} ) do
if type ( _v5680cea30ae2 [ name ] ) == "\102\117\110\099\116\105\111\110" then pcall ( _v5680cea30ae2 [ name ] ) end
end
for _ , name in ipairs ( {
"\068\065\072\095\065\108\108\073\110\079\110\101\072\111\111\107" , "\068\065\072\095\082\097\121\099\097\115\116\065\105\109\072\111\111\107" , "\068\065\072\095\079\112\116\105\109\105\122\101\100\072\111\111\107" ,
"\068\065\072\095\076\111\119\067\111\115\116\072\111\111\107" , "\095\095\068\065\072\095\076\073\084\069\095\082\065\089\067\065\083\084" , "\095\095\083\080\069\067\084\082\065\095\083\069\076\069\067\084\095\082\065\089\067\065\083\084"
} ) do
local old = _v5680cea30ae2 [ name ]
if type ( old ) == "\116\097\098\108\101" then
old . active = false
old . enabled = false
old . part = nil
old . point = nil
old . aimPoint = nil
old . mouseCompat = false
end
end
for _ , name in ipairs ( { "\082\065\067\069\082\095\085\073" , "\083\080\069\067\084\082\065\095\083\069\076\069\067\084\095\076\073\084\069" , "\068\065\072\095\083\116\117\100\105\111\076\105\116\101" , "\068\065\072\095\082\101\098\117\105\108\116\076\105\116\101" , "\068\065\072\095\079\112\116\105\109\105\122\101\100\065\108\108\073\110\079\110\101" , "\068\065\072\095\065\108\108\073\110\079\110\101" , "\068\065\072\065\105\109\071\117\105" } ) do
local old = _v1a7872bd90b1 : FindFirstChild ( name )
if old then old : Destroy ( ) end
end
local MAX_TARGETS = 1000
local _v94b7adb6cdb9 : any = {
closed = false ,
multi = false ,
antiLock = false ,
aliveOnly = true ,
primary = nil ,
aimPlayer = nil ,
aimRecord = nil ,
silent = false ,
wallBang = false ,
bulletMode = 1 ,
bulletStep = 0 ,
forceHit = false ,
trigger = false ,
cameraAim = false ,
dot = false ,
wall = false ,
head = false ,
lead = 0 ,
screenDistance2 = math . huge ,
permitted = false ,
bring = nil ,
autoArmor = true ,
armorGeneration = 0 ,
autoBuys = { } ,
autoBuyIndex = 1 ,
antiStomp = true ,
autoStomp = true ,
selectedStomp = false ,
selectedStompTarget = nil ,
selectedStompGeneration = 0 ,
selectedStompAnchors = nil ,
selectedStompModel = nil ,
selectedStompFollowConnection = nil ,
stompAnimationEnabled = true ,
standEnabled = false ,
standOwner = nil ,
standAttackTarget = nil ,
standDownOnlyTarget = nil ,
standFollow = false ,
standFollowGeneration = 0 ,
standOrderGeneration = 0 ,
standFlingGeneration = 0 ,
standFlinging = false ,
standFlingRestore = nil ,
standCinematicRestore = nil ,
standAttack2Target = nil ,
standAttack3Target = nil ,
standAttack4Target = nil ,
standAttack5Target = nil ,
standSnipeTarget = nil ,
standSnipeReturnCFrame = nil ,
standRevolverRapidBefore = nil ,
standReturnCFrame = nil ,
standHoldRestore = nil ,
afkPermanent = false ,
afkGeneration = 0 ,
chatSpy = false ,
chatSpyOriginal = nil ,
jumpBypass = false ,
jumpBypassGeneration = 0 ,
standEnabledRapid = nil ,
standAttack2FinisherPlayed = false ,
standAttack2LaunchQueued = false ,
standLastCommand = nil ,
standLastCommandAt = 0 ,
bringStompRestore = nil ,
bringStompGeneration = 0 ,
stompPace = 0.04 ,
autoKill = false ,
lastConfirmedHitAt = 0 ,
lastAdaptiveSwitchAt = 0 ,
killBringDestination = nil ,
bringFollowOwner = nil ,
quietAutoKill = false ,
respawnAtDeath = false ,
autoKillVoid = true ,
antiVoid = true ,
voidBlinking = false ,
voidDepth = - 120 ,
voidDwell = 0.02 ,
strafeRadius = 7.5 ,
uiScale = 1 ,
rapidWeapons = { } ,
adaptiveRapid = true ,
lastAttemptWeaponName = nil ,
noRecoil = false ,
invisibleShot = false ,
noSpread = false ,
infiniteSmg = false ,
autoReloadAll = false ,
esp = { enabled = false , boxes = true , skeleton = false ,
names = true , distance = true , rangeIndex = 4 , colorIndex = 1 } ,
themeIndex = 1 ,
autoKillGeneration = 0 ,
resetThresholdIndex = 5 ,
resetCharacter = nil ,
resetInFlight = false ,
antiStompReady = false ,
antiStompTriggeredCharacter = nil ,
antiStompSpawnGraceUntil = 0 ,
lastResetAt = 0 ,
resetGeneration = 0 ,
cursorKeyEnabled = true ,
macroLock = false ,
notify = {
enabled = true , popups = true ,
downed = true , dead = true , respawned = true ,
lowHealth = false , ownRespawn = false , antiStomp = true ,
selected = false ,
} ,
}
local _v85313cbfddb5 = { }
local _ve76b6087628a : any = { }
local DeathPosition = nil
local _vd12b30d97e97 = { }
local RowConnections = { }
local Rows = { }
local _vfc22e7e5f23c , _v71f22c1d3c92 , Records = { } , { } , { }
local _vc1e4e252f800 = { }
local Folders = { }
local ResolutionTokens = { }
local NextResolutionToken = 0
local _ve9c0e81b802b = 0
local _v1861b000f64a = nil
local _v3de27fce3ddc = nil
local TriggerPressed = false
local ArmorShops = { }
local ShopNames = {
"\091\067\104\105\099\107\101\110\093" , "\091\067\111\111\107\105\101\093" , "\091\068\111\110\117\116\093" , "\091\072\097\109\098\117\114\103\101\114\093" , "\091\076\101\109\111\110\097\100\101\093" ,
"\091\077\097\116\099\104\097\093" , "\091\080\105\122\122\097\093" , "\091\080\111\112\099\111\114\110\093" , "\091\083\077\071\093" , "\091\083\104\111\116\103\117\110\093" ,
"\091\083\117\114\103\101\111\110\032\077\097\115\107\093" , "\091\084\097\099\111\093" , "\091\084\097\099\116\105\099\097\108\083\104\111\116\103\117\110\093" ,
}
local ResetThresholds = { 10 , 20 , 30 , 40 , 50 }
local MinStompPaceExponent = 282
local _va6ba7af26ac1 = { }
local _v1a80223b8c3b = 0
local NextAutoStompAt = 0
local AutoStompTrackCharacter = nil
local AutoStompTrack = nil
local updateLoops
local targetTick
local C_BG = Color3 . fromRGB ( 22 , 22 , 22 )
local C_PANEL = Color3 . fromRGB ( 32 , 32 , 32 )
local C_OFF = Color3 . fromRGB ( 46 , 46 , 46 )
local C_ON = Color3 . fromRGB ( 38 , 78 , 141 )
local C_SELECTED = Color3 . fromRGB ( 48 , 66 , 92 )
local C_TEXT = Color3 . fromRGB ( 246 , 246 , 246 )
local C_FAINT = Color3 . fromRGB ( 169 , 169 , 169 )
local C_ACCENT = Color3 . fromRGB ( 78 , 142 , 255 )
local C_NAV = Color3 . fromRGB ( 15 , 15 , 15 )
local C_NAV_OFF = Color3 . fromRGB ( 34 , 34 , 34 )
local C_NAV_HOVER = Color3 . fromRGB ( 56 , 56 , 56 )
local C_NAV_SELECTED = Color3 . fromRGB ( 38 , 78 , 141 )
local C_BORDER = Color3 . fromRGB ( 75 , 75 , 75 )
local function bind ( connection )
_v85313cbfddb5 [ # _v85313cbfddb5 + 1 ] = connection
return connection
end
local function disconnectMany ( connections )
for _ , connection in ipairs ( connections ) do connection : Disconnect ( ) end
table . clear ( connections )
end
local function make ( className , props )
local instance = Instance . new ( className )
for property , value in pairs ( props ) do instance [ property ] = value end
return instance
end
local function round ( obj , radius )
return obj
end
local function label ( parent , title , y , height , color , size )
return make ( "\084\101\120\116\076\097\098\101\108" , {
Parent = parent , Position = UDim2 . fromOffset ( 11 , y ) , Size = UDim2 . new ( 1 , - 22 , 0 , height ) ,
BackgroundTransparency = 1 , Text = title , TextColor3 = color or C_TEXT ,
TextSize = size or 12 , Font = Enum . Font . Gotham ,
TextXAlignment = Enum . TextXAlignment . Left , TextTruncate = Enum . TextTruncate . AtEnd ,
} )
end
local function button ( parent , title , x , y , w , h )
local result = round ( make ( "\084\101\120\116\066\117\116\116\111\110" , {
Parent = parent , Position = UDim2 . fromOffset ( x , y ) , Size = UDim2 . fromOffset ( w , h ) ,
BackgroundColor3 = C_OFF , BorderSizePixel = 0 , AutoButtonColor = false ,
Text = title , TextColor3 = C_TEXT , Font = Enum . Font . GothamBold , TextSize = 11 ,
} ) , 0 )
make ( "\085\073\083\116\114\111\107\101" , { Parent = result , Color = C_BORDER , Thickness = 1 , Transparency = 0.12 } )
bind ( result . MouseEnter : Connect ( function ( )
if _v94b7adb6cdb9 . closed then return end
game : GetService ( "\084\119\101\101\110\083\101\114\118\105\099\101" ) : Create ( result ,
TweenInfo . new ( 0.16 , Enum . EasingStyle . Quad , Enum . EasingDirection . Out ) ,
{ BackgroundColor3 = result : GetAttribute ( "\083\112\101\099\116\114\097\084\097\098" )
and C_NAV_HOVER or result : GetAttribute ( "\083\112\101\099\116\114\097\072\101\097\100\101\114" )
and C_NAV_HOVER or C_SELECTED } ) : Play ( )
end ) )
bind ( result . MouseLeave : Connect ( function ( )
if _v94b7adb6cdb9 . closed then return end
game : GetService ( "\084\119\101\101\110\083\101\114\118\105\099\101" ) : Create ( result ,
TweenInfo . new ( 0.18 , Enum . EasingStyle . Quad , Enum . EasingDirection . Out ) ,
{ BackgroundColor3 = result : GetAttribute ( "\083\112\101\099\116\114\097\084\097\098" )
and ( result : GetAttribute ( "\083\112\101\099\116\114\097\079\110" ) and C_NAV_SELECTED or C_NAV_OFF )
or result : GetAttribute ( "\083\112\101\099\116\114\097\072\101\097\100\101\114" ) and C_NAV_OFF
or result : GetAttribute ( "\083\112\101\099\116\114\097\079\110" ) and C_ON or C_OFF } ) : Play ( )
end ) )
return result
end
local function style ( btn , value , on , off )
btn . Text = value and on or off
btn : SetAttribute ( "\083\112\101\099\116\114\097\079\110" , value )
btn . BackgroundColor3 = value and C_ON or C_OFF
local stroke = btn : FindFirstChildOfClass ( "\085\073\083\116\114\111\107\101" )
if stroke then stroke . Color = value and C_ACCENT or C_BORDER end
end
local _v5e8292a54b81 = make ( "\083\099\114\101\101\110\071\117\105" , {
Name = "\082\065\067\069\082\095\085\073" , Parent = _v1a7872bd90b1 , ResetOnSpawn = false ,
DisplayOrder = 2200 , IgnoreGuiInset = true ,
} )
local _v373596433c68 = round ( make ( "\070\114\097\109\101" , {
Parent = _v5e8292a54b81 , Position = UDim2 . fromOffset ( 24 , 80 ) , Size = UDim2 . fromOffset ( 520 , 625 ) ,
BackgroundColor3 = C_BG , BorderSizePixel = 0 , Active = true ,
} ) , 0 )
make ( "\085\073\083\116\114\111\107\101" , { Parent = _v373596433c68 , Color = C_BORDER ,
Thickness = 1 , Transparency = 0 } )
local MainScale = make ( "\085\073\083\099\097\108\101" , { Parent = _v373596433c68 , Scale = _v94b7adb6cdb9 . uiScale } )
make ( "\070\114\097\109\101" , { Parent = _v373596433c68 , Position = UDim2 . fromOffset ( 0 , 0 ) ,
Size = UDim2 . fromOffset ( 520 , 64 ) , BackgroundColor3 = C_NAV ,
BorderSizePixel = 0 } )
make ( "\070\114\097\109\101" , { Parent = _v373596433c68 , Position = UDim2 . fromOffset ( 0 , 42 ) ,
Size = UDim2 . fromOffset ( 520 , 22 ) , BackgroundColor3 = C_NAV , BorderSizePixel = 0 } )
make ( "\070\114\097\109\101" , { Parent = _v373596433c68 , Position = UDim2 . fromOffset ( 0 , 0 ) ,
Size = UDim2 . fromOffset ( 5 , 64 ) , BackgroundColor3 = C_ACCENT , BorderSizePixel = 0 } )
make ( "\070\114\097\109\101" , { Parent = _v373596433c68 , Position = UDim2 . fromOffset ( 0 , 64 ) ,
Size = UDim2 . fromOffset ( 520 , 1 ) , BackgroundColor3 = C_BORDER , BorderSizePixel = 0 } )
local Heading = label ( _v373596433c68 , "\082\065\067\069\082" , 8 , 31 , C_TEXT , 24 )
Heading . Font = Enum . Font . GothamBold
Heading . Position = UDim2 . fromOffset ( 19 , 7 )
Heading . Size = UDim2 . fromOffset ( 245 , 32 )
local Subtitle = label ( _v373596433c68 , "\084\065\082\071\069\084\073\078\071\032\032\047\032\032\067\079\077\066\065\084\032\032\047\032\032\085\084\073\076\073\084\073\069\083" , 39 , 16 ,
C_FAINT , 10 )
Subtitle . Position = UDim2 . fromOffset ( 20 , 39 )
make ( "\070\114\097\109\101" , { Parent = _v373596433c68 , Position = UDim2 . fromOffset ( 366 , 24 ) ,
Size = UDim2 . fromOffset ( 6 , 6 ) , BackgroundColor3 = Color3 . fromRGB ( 74 , 180 , 129 ) ,
BorderSizePixel = 0 } )
local LiveLabel = label ( _v373596433c68 , "\076\073\086\069" , 19 , 20 , C_FAINT , 10 )
LiveLabel . Position = UDim2 . fromOffset ( 379 , 18 )
LiveLabel . Size = UDim2 . fromOffset ( 42 , 20 )
LiveLabel . Font = Enum . Font . GothamBold
local Minimise = button ( _v373596433c68 , "\045" , 443 , 14 , 29 , 27 )
local Close = button ( _v373596433c68 , "\088" , 478 , 14 , 29 , 27 )
for _ , control in ipairs ( { Minimise , Close } ) do
control : SetAttribute ( "\083\112\101\099\116\114\097\072\101\097\100\101\114" , true )
control . BackgroundColor3 = C_NAV_OFF
control . TextColor3 = C_TEXT
control : FindFirstChildOfClass ( "\085\073\083\116\114\111\107\101" ) . Transparency = 1
end
local Search = round ( make ( "\084\101\120\116\066\111\120" , {
Parent = _v373596433c68 , Position = UDim2 . fromOffset ( 11 , 50 ) , Size = UDim2 . fromOffset ( 318 , 34 ) ,
Text = "" , PlaceholderText = "\032\032\083\101\097\114\099\104\032\112\108\097\121\101\114\032\110\097\109\101\046\046\046" , ClearTextOnFocus = false ,
BackgroundColor3 = C_OFF , BorderSizePixel = 0 , TextColor3 = C_TEXT ,
PlaceholderColor3 = C_FAINT , TextSize = 12 , Font = Enum . Font . Gotham ,
TextXAlignment = Enum . TextXAlignment . Left ,
} ) , 7 )
local List = round ( make ( "\083\099\114\111\108\108\105\110\103\070\114\097\109\101" , {
Parent = _v373596433c68 , Position = UDim2 . fromOffset ( 11 , 92 ) , Size = UDim2 . fromOffset ( 318 , 136 ) ,
BackgroundColor3 = C_PANEL , BorderSizePixel = 0 , ScrollBarThickness = 3 ,
CanvasSize = UDim2 . fromOffset ( 0 , 0 ) , ScrollingDirection = Enum . ScrollingDirection . Y ,
} ) , 7 )
make ( "\085\073\080\097\100\100\105\110\103" , { Parent = List , PaddingTop = UDim . new ( 0 , 4 ) , PaddingLeft = UDim . new ( 0 , 4 ) , PaddingRight = UDim . new ( 0 , 5 ) } )
local Layout = make ( "\085\073\076\105\115\116\076\097\121\111\117\116" , {
Parent = List , SortOrder = Enum . SortOrder . LayoutOrder , Padding = UDim . new ( 0 , 3 ) ,
} )
bind ( Layout : GetPropertyChangedSignal ( "\065\098\115\111\108\117\116\101\067\111\110\116\101\110\116\083\105\122\101" ) : Connect ( function ( )
List . CanvasSize = UDim2 . fromOffset ( 0 , Layout . AbsoluteContentSize . Y + 8 )
end ) )
local SelectedLabel = label ( _v373596433c68 , "\084\097\114\103\101\116\115\058\032\048\032\115\101\108\101\099\116\101\100" , 231 , 20 , C_ACCENT , 11 )
local ActiveLabel = label ( _v373596433c68 , "\065\105\109\032\116\097\114\103\101\116\058\032\110\111\110\101" , 250 , 20 , C_FAINT , 11 )
local MultiBtn = button ( _v373596433c68 , "\077\085\076\084\073\032\084\065\082\071\069\084\058\032\079\070\070" , 11 , 274 , 153 , 34 )
local AliveBtn = button ( _v373596433c68 , "\065\076\073\086\069\032\067\072\069\067\075\058\032\079\078" , 175 , 274 , 154 , 34 )
local Silent = button ( _v373596433c68 , "\083\073\076\069\078\084\032\065\073\077\058\032\079\070\070" , 11 , 315 , 153 , 34 )
local Trigger = button ( _v373596433c68 , "\084\082\073\071\071\069\082\058\032\079\070\070" , 175 , 315 , 154 , 34 )
local CameraBtn = button ( _v373596433c68 , "\067\065\077\069\082\065\032\065\073\077\058\032\079\070\070" , 11 , 355 , 153 , 34 )
local DotBtn = button ( _v373596433c68 , "\066\079\088\032\043\032\076\073\078\069\058\032\079\070\070" , 175 , 355 , 154 , 34 )
local Hitbox = button ( _v373596433c68 , "\072\073\084\066\079\088\058\032\066\079\068\089" , 11 , 395 , 153 , 34 )
local Wall = button ( _v373596433c68 , "\087\065\076\076\032\067\072\069\067\075\058\032\079\070\070" , 175 , 395 , 154 , 34 )
local LeadText = label ( _v373596433c68 , "\080\082\069\068\073\067\084\073\079\078\058\032\048\032\109\115" , 478 , 22 , C_FAINT , 11 )
local Minus = button ( _v373596433c68 , "\045" , 256 , 475 , 33 , 28 )
local Plus = button ( _v373596433c68 , "\043" , 296 , 475 , 33 , 28 )
local Refresh = button ( _v373596433c68 , "\082\069\070\082\069\083\072\032\084\065\082\071\069\084\083" , 11 , 515 , 153 , 33 )
local Bring = button ( _v373596433c68 , "\066\082\073\078\071\032\083\069\076\069\067\084\069\068" , 175 , 515 , 154 , 33 )
local AutoArmor = button ( _v373596433c68 , "\065\085\084\079\032\065\082\077\079\082\032\079\078\032\082\069\083\080\065\087\078\058\032\079\070\070" , 11 , 555 , 318 , 33 )
local _v31d991e95e81 = label ( _v373596433c68 , "\073\100\108\101\058\032\110\111\032\116\097\114\103\101\116\105\110\103\032\108\111\111\112\032\097\099\116\105\118\101\046" , 564 , 44 , C_FAINT , 11 )
_v31d991e95e81 . TextWrapped = true
_v31d991e95e81 . TextTruncate = Enum . TextTruncate . None
_v31d991e95e81 . TextYAlignment = Enum . TextYAlignment . Top
local Sidebar = round ( make ( "\070\114\097\109\101" , { Parent = _v373596433c68 ,
Position = UDim2 . fromOffset ( 11 , 91 ) , Size = UDim2 . fromOffset ( 111 , 449 ) ,
BackgroundColor3 = C_NAV , BorderSizePixel = 0 } ) , 13 )
make ( "\085\073\083\116\114\111\107\101" , { Parent = Sidebar , Color = Color3 . fromRGB ( 94 , 102 , 99 ) ,
Thickness = 1 , Transparency = 0.65 } )
local ModulesLabel = label ( Sidebar , "\087\079\082\075\083\080\065\067\069" , 13 , 20 ,
C_ACCENT , 10 )
ModulesLabel . Position = UDim2 . fromOffset ( 13 , 13 )
local TargetTab = button ( Sidebar , "\032\032\084\065\082\071\069\084\083" , 8 , 44 , 95 , 34 )
local AimTab = button ( Sidebar , "\032\032\065\073\077" , 8 , 83 , 95 , 34 )
local ToolsTab = button ( Sidebar , "\032\032\084\079\079\076\083" , 8 , 122 , 95 , 34 )
local SettingsTab = button ( Sidebar , "\032\032\083\069\084\084\073\078\071\083" , 8 , 161 , 95 , 34 )
_ve76b6087628a . GunsTab = button ( Sidebar , "\032\032\071\085\078\083" , 8 , 200 , 95 , 34 )
_ve76b6087628a . EspTab = button ( Sidebar , "\032\032\069\083\080" , 8 , 239 , 95 , 34 )
_ve76b6087628a . TeleportTab = button ( Sidebar , "\032\032\084\069\076\069\080\079\082\084" , 8 , 278 , 95 , 34 )
_ve76b6087628a . StandTab = button ( Sidebar , "\032\032\083\084\065\078\068" , 8 , 317 , 95 , 34 )
_ve76b6087628a . NotifyTab = button ( Sidebar , "\032\032\078\079\084\073\070\089" , 8 , 356 , 95 , 34 )
_ve76b6087628a . ConfigTab = button ( Sidebar , "\032\032\067\079\078\070\073\071\083" , 8 , 395 , 95 , 34 )
for _ , tab in ipairs ( { TargetTab , AimTab , ToolsTab , SettingsTab ,
_ve76b6087628a . GunsTab , _ve76b6087628a . EspTab , _ve76b6087628a . TeleportTab ,
_ve76b6087628a . StandTab , _ve76b6087628a . NotifyTab , _ve76b6087628a . ConfigTab } ) do
tab . TextXAlignment = Enum . TextXAlignment . Left
tab . TextColor3 = C_TEXT
tab . BackgroundColor3 = C_NAV_OFF
tab : FindFirstChildOfClass ( "\085\073\083\116\114\111\107\101" ) . Transparency = 1
end
local StatusBar = round ( make ( "\070\114\097\109\101" , { Parent = _v373596433c68 ,
Position = UDim2 . fromOffset ( 132 , 550 ) , Size = UDim2 . fromOffset ( 376 , 55 ) ,
BackgroundColor3 = C_NAV , BorderSizePixel = 0 } ) , 12 )
make ( "\085\073\083\116\114\111\107\101" , { Parent = StatusBar , Color = C_NAV_HOVER ,
Thickness = 1 , Transparency = 0.35 } )
round ( make ( "\070\114\097\109\101" , { Parent = StatusBar , Position = UDim2 . fromOffset ( 13 , 20 ) ,
Size = UDim2 . fromOffset ( 8 , 8 ) , BackgroundColor3 = C_ACCENT ,
BorderSizePixel = 0 } ) , 4 )
_v31d991e95e81 . Parent = StatusBar
_v31d991e95e81 . Position = UDim2 . fromOffset ( 30 , 8 )
_v31d991e95e81 . Size = UDim2 . fromOffset ( 333 , 41 )
_v31d991e95e81 . TextColor3 = Color3 . fromRGB ( 226 , 229 , 224 )
local function page ( )
local frame = round ( make ( "\070\114\097\109\101" , {
Parent = _v373596433c68 , Position = UDim2 . fromOffset ( 132 , 91 ) ,
Size = UDim2 . fromOffset ( 376 , 449 ) , BackgroundColor3 = C_PANEL ,
BorderSizePixel = 0 , Visible = false ,
} ) , 14 )
make ( "\085\073\083\116\114\111\107\101" , { Parent = frame , Color = C_BORDER , Thickness = 1 , Transparency = 0.08 } )
make ( "\070\114\097\109\101" , { Parent = frame , Position = UDim2 . fromOffset ( 0 , 0 ) ,
Size = UDim2 . fromOffset ( 376 , 3 ) , BackgroundColor3 = C_ACCENT ,
BorderSizePixel = 0 } )
return frame
end
local _v3d850843c1c9 , _v3aa54b3310d7 , _v0fe2b2daf78a , SettingsPage =
page ( ) , page ( ) , page ( ) , page ( )
_ve76b6087628a . GunsPage = page ( )
_ve76b6087628a . EspPage = page ( )
_ve76b6087628a . TeleportPage = page ( )
_ve76b6087628a . StandPage = page ( )
_ve76b6087628a . NotifyPage = page ( )
_ve76b6087628a . ConfigPage = page ( )
local function place ( control , parent , x , y , width , height )
control . Parent = parent
control . Position = UDim2 . fromOffset ( x , y )
control . Size = UDim2 . fromOffset ( width , height )
end
place ( Search , _v3d850843c1c9 , 12 , 16 , 342 , 34 )
place ( List , _v3d850843c1c9 , 12 , 59 , 342 , 188 )
place ( SelectedLabel , _v3d850843c1c9 , 12 , 255 , 342 , 19 )
place ( ActiveLabel , _v3d850843c1c9 , 12 , 276 , 342 , 19 )
place ( MultiBtn , _v3d850843c1c9 , 12 , 307 , 166 , 34 )
place ( AliveBtn , _v3d850843c1c9 , 188 , 307 , 166 , 34 )
local CursorToggle = button ( _v3d850843c1c9 , "\067\085\082\083\079\082\032\080\073\067\075\058\032\079\078" , 12 , 350 , 166 , 34 )
local CursorPick = button ( _v3d850843c1c9 , "\080\073\067\075\032\078\069\065\082\032\067\085\082\083\079\082" , 188 , 350 , 166 , 34 )
label ( _v3d850843c1c9 , "\081\032\115\101\108\101\099\116\115\032\111\114\032\114\101\109\111\118\101\115\032\097\032\112\108\097\121\101\114\032\119\105\116\104\105\110\032\049\048\048\112\120\046" , 428 , 18 , C_FAINT , 11 )
place ( Refresh , _v3d850843c1c9 , 12 , 393 , 166 , 34 )
_ve76b6087628a . SelectAllBtn = button ( _v3d850843c1c9 , "\083\069\076\069\067\084\032\065\076\076" , 188 , 393 , 166 , 34 )
place ( Silent , _v3aa54b3310d7 , 12 , 21 , 166 , 36 )
place ( Trigger , _v3aa54b3310d7 , 188 , 21 , 166 , 36 )
place ( CameraBtn , _v3aa54b3310d7 , 12 , 67 , 166 , 36 )
place ( DotBtn , _v3aa54b3310d7 , 188 , 67 , 166 , 36 )
place ( Hitbox , _v3aa54b3310d7 , 12 , 113 , 166 , 36 )
place ( Wall , _v3aa54b3310d7 , 188 , 113 , 166 , 36 )
label ( _v3aa54b3310d7 , "\073\110\102\105\110\105\116\101\032\097\105\109\032\114\097\110\103\101\032\032\047\032\032\084\114\105\103\103\101\114\032\102\105\114\101\115\032\119\104\105\108\101\032\111\118\101\114\032\097\032\116\097\114\103\101\116\046" ,
168 , 20 , C_FAINT , 11 )
place ( LeadText , _v3aa54b3310d7 , 13 , 212 , 225 , 24 )
place ( Minus , _v3aa54b3310d7 , 276 , 209 , 35 , 29 )
place ( Plus , _v3aa54b3310d7 , 319 , 209 , 35 , 29 )
local _v9a74e4ff6523 = button ( _v3aa54b3310d7 , "\087\065\076\076\066\065\078\071\058\032\079\070\070" , 12 , 247 , 342 , 36 )
_ve76b6087628a . WallBangInfo = label ( _v3aa54b3310d7 , "\087\065\076\076\066\065\078\071\058\032\079\070\070" , 289 , 342 , C_FAINT , 10 )
local AutoKillBtn = button ( _v3aa54b3310d7 , "\065\085\084\079\032\075\073\076\076\032\083\069\076\069\067\084\069\068\058\032\079\070\070" , 12 , 319 , 342 , 38 )
_ve76b6087628a . QuietKillBtn = button ( _v3aa54b3310d7 , "\081\085\073\069\084\032\065\085\084\079\032\075\073\076\076\058\032\079\070\070" , 12 , 363 , 342 , 30 )
local ForceHitBtn = button ( _v3aa54b3310d7 , "\070\079\082\067\069\032\072\073\084\058\032\079\070\070" , 12 , 398 , 342 , 36 )
place ( AutoArmor , _v0fe2b2daf78a , 12 , 18 , 342 , 38 )
place ( Bring , _v0fe2b2daf78a , 12 , 64 , 342 , 36 )
local _v961187159855 = button ( _v0fe2b2daf78a , "\065\078\084\073\032\083\084\079\077\080\058\032\079\070\070" , 12 , 108 , 342 , 36 )
local ResetThresholdBtn = button ( _v0fe2b2daf78a , "\082\069\083\069\084\032\065\084\058\032\053\048\032\072\080" , 12 , 152 , 342 , 32 )
local AutoStompBtn = button ( _v0fe2b2daf78a , "\065\085\084\079\032\083\084\079\077\080\058\032\079\070\070" , 12 , 192 , 166 , 36 )
local SelectedStompBtn = button ( _v0fe2b2daf78a , "\083\069\076\069\067\084\069\068\032\083\084\079\077\080\058\032\079\070\070" , 188 , 192 , 166 , 36 )
_ve76b6087628a . StompAnimationBtn = button ( _v0fe2b2daf78a , "\083\084\079\077\080\032\065\078\073\077\065\084\073\079\078\058\032\079\078" , 12 , 236 , 342 , 30 )
label ( _v0fe2b2daf78a , "\065\085\084\079\032\066\085\089\032\079\078\032\082\069\083\080\065\087\078" , 280 , 22 , C_ACCENT , 12 )
local AutoBuyPrev = button ( _v0fe2b2daf78a , "\060" , 12 , 302 , 38 , 30 )
local AutoBuyName = label ( _v0fe2b2daf78a , "" , 302 , 30 , C_TEXT , 12 )
place ( AutoBuyName , _v0fe2b2daf78a , 57 , 302 , 252 , 30 )
AutoBuyName . TextXAlignment = Enum . TextXAlignment . Center
local AutoBuyNext = button ( _v0fe2b2daf78a , "\062" , 316 , 302 , 38 , 30 )
local AutoBuyToggle = button ( _v0fe2b2daf78a , "\065\085\084\079\032\066\085\089\058\032\079\070\070" , 12 , 340 , 342 , 30 )
local AutoBuyNow = button ( _v0fe2b2daf78a , "\066\085\089\032\083\069\076\069\067\084\069\068\032\078\079\087" , 12 , 378 , 342 , 30 )
local AutoBuyCount = label ( _v0fe2b2daf78a , "\048\032\105\116\101\109\115\032\115\101\108\101\099\116\101\100\046\032\083\104\111\112\115\032\117\115\101\032\067\108\105\099\107\068\101\116\101\099\116\111\114\115\046" , 414 , 36 , C_FAINT , 10 )
label ( _ve76b6087628a . GunsPage , "\082\065\080\073\068\032\070\073\082\069\032\032\047\032\032\080\069\082\032\087\069\065\080\079\078" , 16 , 22 , C_ACCENT , 12 )
label ( _ve76b6087628a . GunsPage , "\072\111\108\100\032\102\105\114\101\046\032\083\104\111\116\103\117\110\032\100\097\109\097\103\101\032\099\097\100\101\110\099\101\032\105\115\032\115\101\114\118\101\114\032\099\111\110\116\114\111\108\108\101\100\046" ,
43 , 22 , C_FAINT , 10 )
_ve76b6087628a . ServerHit = label ( _ve76b6087628a . GunsPage , "\083\069\082\086\069\082\032\072\073\084\058\032\119\097\105\116\105\110\103\032\102\111\114\032\097\032\115\104\111\116" , 57 , 18 , C_FAINT , 10 )
_ve76b6087628a . BulletModeNames = { "\067\085\082\083\079\082" , "\051\054\048\032\083\080\073\078" , "\051\054\048\032\082\065\078\068\079\077" }
_ve76b6087628a . BulletModeBtn = button ( _ve76b6087628a . GunsPage , "\066\085\076\076\069\084\032\068\073\082\069\067\084\073\079\078\058\032\067\085\082\083\079\082" , 12 , 83 , 342 , 36 )
label ( _ve76b6087628a . GunsPage , "\051\054\048\032\115\104\111\116\115\032\114\111\116\097\116\101\032\105\110\100\101\112\101\110\100\101\110\116\108\121\032\111\102\032\121\111\117\114\032\099\117\114\115\111\114\046" ,
125 , 21 , C_FAINT , 10 )
_ve76b6087628a . GunList = round ( make ( "\083\099\114\111\108\108\105\110\103\070\114\097\109\101" , {
Parent = _ve76b6087628a . GunsPage , Position = UDim2 . fromOffset ( 12 , 154 ) ,
Size = UDim2 . fromOffset ( 342 , 271 ) , BackgroundColor3 = C_BG ,
BorderSizePixel = 0 , ScrollBarThickness = 7 ,
ScrollBarImageColor3 = C_ACCENT , ScrollingEnabled = true ,
AutomaticCanvasSize = Enum . AutomaticSize . Y ,
CanvasSize = UDim2 . fromOffset ( 0 , 0 ) ,
ScrollingDirection = Enum . ScrollingDirection . Y ,
} ) , 8 )
_ve76b6087628a . GunList . ScrollingDirection = Enum . ScrollingDirection . Y
_ve76b6087628a . GunLayout = make ( "\085\073\076\105\115\116\076\097\121\111\117\116" , {
Parent = _ve76b6087628a . GunList , SortOrder = Enum . SortOrder . LayoutOrder ,
Padding = UDim . new ( 0 , 6 ) ,
} )
make ( "\085\073\080\097\100\100\105\110\103" , { Parent = _ve76b6087628a . GunList ,
PaddingTop = UDim . new ( 0 , 6 ) , PaddingBottom = UDim . new ( 0 , 10 ) ,
PaddingLeft = UDim . new ( 0 , 3 ) , PaddingRight = UDim . new ( 0 , 8 ) } )
label ( _ve76b6087628a . EspPage , "\080\076\065\089\069\082\032\079\086\069\082\076\065\089\032\032\047\032\032\065\076\076\032\080\076\065\089\069\082\083" , 16 , 22 , C_ACCENT , 12 )
label ( _ve76b6087628a . EspPage , "\083\099\114\101\101\110\032\111\118\101\114\108\097\121\032\119\105\116\104\032\111\112\116\105\111\110\097\108\032\082\049\053\047\082\054\032\106\111\105\110\116\115\046" , 43 , 22 , C_FAINT , 10 )
_ve76b6087628a . EspMain = button ( _ve76b6087628a . EspPage , "\069\083\080\058\032\079\070\070" , 12 , 76 , 342 , 38 )
_ve76b6087628a . EspBoxes = button ( _ve76b6087628a . EspPage , "\066\079\088\069\083\058\032\079\078" , 12 , 125 , 166 , 36 )
_ve76b6087628a . EspSkeleton = button ( _ve76b6087628a . EspPage , "\083\075\069\076\069\084\079\078\058\032\079\070\070" , 188 , 125 , 166 , 36 )
_ve76b6087628a . EspNames = button ( _ve76b6087628a . EspPage , "\078\065\077\069\083\058\032\079\078" , 12 , 171 , 166 , 36 )
_ve76b6087628a . EspDistance = button ( _ve76b6087628a . EspPage , "\068\073\083\084\065\078\067\069\058\032\079\078" , 188 , 171 , 166 , 36 )
_ve76b6087628a . EspRange = button ( _ve76b6087628a . EspPage , "\082\065\078\071\069\058\032\065\076\076" , 12 , 217 , 342 , 36 )
_ve76b6087628a . EspColor = button ( _ve76b6087628a . EspPage , "\067\079\076\079\082\058\032\067\089\065\078" , 12 , 263 , 342 , 36 )
_ve76b6087628a . AntiLockBtn = button ( _ve76b6087628a . EspPage , "\065\078\084\073\045\076\079\067\075\032\077\079\086\069\077\069\078\084\058\032\079\070\070" , 12 , 328 , 342 , 36 )
label ( _ve76b6087628a . EspPage , "\086\097\114\105\101\115\032\121\111\117\114\032\109\111\118\105\110\103\032\112\097\116\104\032\116\111\032\104\105\110\100\101\114\032\112\114\101\100\105\099\116\105\111\110\046\032\067\097\110\110\111\116\032\115\116\111\112" , 373 , 20 , C_FAINT , 10 )
label ( _ve76b6087628a . EspPage , "\097\108\108\032\099\108\105\101\110\116\045\115\105\100\101\032\108\111\099\107\115\032\111\114\032\115\101\114\118\101\114\045\118\097\108\105\100\097\116\101\100\032\104\105\116\115\046" , 391 , 20 , C_FAINT , 10 )
label ( _ve76b6087628a . TeleportPage , "\076\079\067\065\084\073\079\078\032\084\069\076\069\080\079\082\084\083" , 16 , 22 , C_ACCENT , 12 )
label ( _ve76b6087628a . TeleportPage , "\067\104\111\111\115\101\032\097\032\109\097\112\112\101\100\032\097\114\101\097\032\111\114\032\097\032\108\105\118\101\032\115\104\111\112\046" , 43 , 22 , C_FAINT , 10 )
_ve76b6087628a . TeleportButtons = {
uphill = button ( _ve76b6087628a . TeleportPage , "\085\080\072\073\076\076" , 12 , 80 , 166 , 37 ) ,
downhill = button ( _ve76b6087628a . TeleportPage , "\068\079\087\078\072\073\076\076" , 188 , 80 , 166 , 37 ) ,
armor = button ( _ve76b6087628a . TeleportPage , "\078\069\065\082\069\083\084\032\065\082\077\079\082" , 12 , 128 , 342 , 37 ) ,
smg = button ( _ve76b6087628a . TeleportPage , "\078\069\065\082\069\083\084\032\083\077\071\032\083\072\079\080" , 12 , 176 , 342 , 37 ) ,
returnTo = button ( _ve76b6087628a . TeleportPage , "\082\069\084\085\082\078\032\084\079\032\080\082\069\086\073\079\085\083\032\080\079\083\073\084\073\079\078" , 12 , 224 , 342 , 37 ) ,
}
label ( _ve76b6087628a . StandPage , "\083\084\065\078\068\032\032\047\032\032\067\072\065\084\032\067\079\078\084\082\079\076" , 16 , 25 , C_ACCENT , 12 )
_ve76b6087628a . StandOwnerLabel = label ( _ve76b6087628a . StandPage , "\079\119\110\101\114\058\032\110\111\110\101" , 48 , 30 , C_TEXT , 12 )
_ve76b6087628a . StandOwnerInput = make ( "\084\101\120\116\066\111\120" , {
Parent = _ve76b6087628a . StandPage , Position = UDim2 . fromOffset ( 12 , 86 ) ,
Size = UDim2 . fromOffset ( 342 , 34 ) , BackgroundColor3 = C_OFF ,
TextColor3 = C_TEXT , PlaceholderColor3 = C_FAINT ,
PlaceholderText = "\079\119\110\101\114\032\117\115\101\114\110\097\109\101\032\111\114\032\100\105\115\112\108\097\121\032\110\097\109\101" , Text = "" ,
ClearTextOnFocus = false , Font = Enum . Font . Gotham ,
TextSize = 12 , BorderSizePixel = 0 ,
} )
round ( _ve76b6087628a . StandOwnerInput , 7 )
_ve76b6087628a . StandSetOwner = button ( _ve76b6087628a . StandPage , "\083\069\084\032\079\087\078\069\082\032\070\082\079\077\032\078\065\077\069" , 12 , 130 , 166 , 34 )
_ve76b6087628a . StandSetSelected = button ( _ve76b6087628a . StandPage , "\085\083\069\032\083\069\076\069\067\084\069\068\032\080\076\065\089\069\082" , 188 , 130 , 166 , 34 )
_ve76b6087628a . StandToggle = button ( _ve76b6087628a . StandPage , "\076\073\083\084\069\078\058\032\079\070\070" , 12 , 175 , 342 , 38 )
_ve76b6087628a . StandStop = button ( _ve76b6087628a . StandPage , "\083\084\079\080\032\067\085\082\082\069\078\084\032\079\082\068\069\082" , 12 , 222 , 342 , 34 )
label ( _ve76b6087628a . StandPage , "\079\087\078\069\082\032\067\072\065\084\032\067\079\077\077\065\078\068\083" , 268 , 25 , C_ACCENT , 11 )
label ( _ve76b6087628a . StandPage , "\033\097\116\116\097\099\107\032\049\045\053\032\047\032\033\115\110\105\112\101\032\060\110\097\109\101\062\032\047\032\033\098\114\105\110\103" , 292 , 24 , C_TEXT , 11 )
label ( _ve76b6087628a . StandPage , "\033\099\111\109\101\032\047\032\033\102\111\108\108\111\119\032\047\032\033\103\111\116\111\032\047\032\033\098\097\099\107\032\047\032\033\102\097\099\101" , 318 , 24 , C_TEXT , 11 )
_ve76b6087628a . ChatSpyBtn = button ( _ve76b6087628a . StandPage , "\067\072\065\084\032\083\080\089\058\032\079\070\070" , 12 , 343 , 166 , 30 )
_ve76b6087628a . JumpBypassBtn = button ( _ve76b6087628a . StandPage , "\074\085\077\080\032\066\089\080\065\083\083\058\032\079\070\070" , 188 , 343 , 166 , 30 )
_ve76b6087628a . StandAfkBtn = button ( _ve76b6087628a . StandPage , "\080\069\082\077\065\078\069\078\084\032\065\070\075\058\032\079\070\070" , 12 , 381 , 342 , 30 )
_ve76b6087628a . StandStatus = label ( _ve76b6087628a . StandPage , "\083\116\097\110\100\105\110\103\032\098\121\046" , 414 , 30 , C_FAINT , 11 )
_ve76b6087628a . StandStatus . TextWrapped = true
_ve76b6087628a . StandStatus . TextTruncate = Enum . TextTruncate . None
_ve76b6087628a . Notify = { watchers = { } , knownModels = { } , lastRespawnAt = { } , log = { } }
label ( _ve76b6087628a . NotifyPage , "\078\079\084\073\070\073\067\065\084\073\079\078\083\032\032\047\032\032\083\069\076\069\067\084\069\068\032\084\065\082\071\069\084\083" , 15 , 23 , C_ACCENT , 12 )
label ( _ve76b6087628a . NotifyPage , "\084\114\097\099\107\115\032\115\101\108\101\099\116\101\100\032\112\108\097\121\101\114\115\032\111\110\108\121\059\032\110\111\032\099\111\110\116\105\110\117\111\117\115\032\115\099\097\110\115\046" , 39 , 20 , C_FAINT , 10 )
_ve76b6087628a . NotifyMaster = button ( _ve76b6087628a . NotifyPage , "\078\079\084\073\070\073\067\065\084\073\079\078\083\058\032\079\078" , 12 , 65 , 342 , 34 )
_ve76b6087628a . NotifySettings = make ( "\083\099\114\111\108\108\105\110\103\070\114\097\109\101" , {
Parent = _ve76b6087628a . NotifyPage , Position = UDim2 . fromOffset ( 12 , 109 ) ,
Size = UDim2 . fromOffset ( 342 , 162 ) , BackgroundColor3 = C_BG ,
BorderSizePixel = 0 , ScrollBarThickness = 5 ,
ScrollingDirection = Enum . ScrollingDirection . Y ,
AutomaticCanvasSize = Enum . AutomaticSize . Y ,
CanvasSize = UDim2 . fromOffset ( 0 , 0 ) ,
} )
make ( "\085\073\076\105\115\116\076\097\121\111\117\116" , { Parent = _ve76b6087628a . NotifySettings ,
SortOrder = Enum . SortOrder . LayoutOrder , Padding = UDim . new ( 0 , 5 ) } )
_ve76b6087628a . NotifyOptions = {
{ "\100\111\119\110\101\100" , "\084\065\082\071\069\084\032\068\079\087\078\069\068" } , { "\100\101\097\100" , "\084\065\082\071\069\084\032\068\069\065\068" } ,
{ "\114\101\115\112\097\119\110\101\100" , "\084\065\082\071\069\084\032\082\069\083\080\065\087\078\069\068" } , { "\108\111\119\072\101\097\108\116\104" , "\084\065\082\071\069\084\032\076\079\087\032\072\080\032\040\051\048\041" } ,
{ "\111\119\110\082\101\115\112\097\119\110" , "\077\089\032\082\069\083\080\065\087\078" } , { "\097\110\116\105\083\116\111\109\112" , "\065\078\084\073\045\083\084\079\077\080\032\083\084\065\084\085\083" } ,
{ "\115\101\108\101\099\116\101\100" , "\084\065\082\071\069\084\032\083\069\076\069\067\084\069\068" } , { "\112\111\112\117\112\115" , "\079\078\045\083\067\082\069\069\078\032\080\079\080\085\080\083" } ,
}
_ve76b6087628a . NotifyButtons = { }
for index , item in ipairs ( _ve76b6087628a . NotifyOptions ) do
local key , name = item [ 1 ] , item [ 2 ]
local btn = button ( _ve76b6087628a . NotifySettings , "" , 3 , 0 , 326 , 30 )
btn . LayoutOrder = index
btn . Size = UDim2 . new ( 1 , - 10 , 0 , 30 )
_ve76b6087628a . NotifyButtons [ key ] = btn
bind ( btn . MouseButton1Click : Connect ( function ( )
_v94b7adb6cdb9 . notify [ key ] = not _v94b7adb6cdb9 . notify [ key ]
style ( btn , _v94b7adb6cdb9 . notify [ key ] , name .. "\058\032\079\078" , name .. "\058\032\079\070\070" )
end ) )
end
label ( _ve76b6087628a . NotifyPage , "\082\069\067\069\078\084\032\069\086\069\078\084\083" , 278 , 22 , C_ACCENT , 11 )
_ve76b6087628a . NotifyClear = button ( _ve76b6087628a . NotifyPage , "\067\076\069\065\082" , 271 , 278 , 83 , 25 )
_ve76b6087628a . NotifyHistory = make ( "\083\099\114\111\108\108\105\110\103\070\114\097\109\101" , {
Parent = _ve76b6087628a . NotifyPage , Position = UDim2 . fromOffset ( 12 , 310 ) ,
Size = UDim2 . fromOffset ( 342 , 124 ) , BackgroundColor3 = C_BG ,
BorderSizePixel = 0 , ScrollBarThickness = 5 ,
ScrollingDirection = Enum . ScrollingDirection . Y ,
AutomaticCanvasSize = Enum . AutomaticSize . Y ,
CanvasSize = UDim2 . fromOffset ( 0 , 0 ) ,
} )
make ( "\085\073\076\105\115\116\076\097\121\111\117\116" , { Parent = _ve76b6087628a . NotifyHistory ,
SortOrder = Enum . SortOrder . LayoutOrder , Padding = UDim . new ( 0 , 3 ) } )
_ve76b6087628a . NotifyToastHost = make ( "\070\114\097\109\101" , {
Parent = _v5e8292a54b81 , Position = UDim2 . new ( 1 , - 320 , 0 , 75 ) ,
Size = UDim2 . fromOffset ( 304 , 230 ) , BackgroundTransparency = 1 ,
BorderSizePixel = 0 , ZIndex = 40 ,
} )
make ( "\085\073\076\105\115\116\076\097\121\111\117\116" , { Parent = _ve76b6087628a . NotifyToastHost ,
SortOrder = Enum . SortOrder . LayoutOrder , Padding = UDim . new ( 0 , 5 ) } )
_ve76b6087628a . Notify . refreshButtons = function ( )
style ( _ve76b6087628a . NotifyMaster , _v94b7adb6cdb9 . notify . enabled ,
"\078\079\084\073\070\073\067\065\084\073\079\078\083\058\032\079\078" , "\078\079\084\073\070\073\067\065\084\073\079\078\083\058\032\079\070\070" )
for _ , item in ipairs ( _ve76b6087628a . NotifyOptions ) do
local key , name = item [ 1 ] , item [ 2 ]
style ( _ve76b6087628a . NotifyButtons [ key ] , _v94b7adb6cdb9 . notify [ key ] ,
name .. "\058\032\079\078" , name .. "\058\032\079\070\070" )
end
end
_ve76b6087628a . Notify . refreshButtons ( )
bind ( _ve76b6087628a . NotifyMaster . MouseButton1Click : Connect ( function ( )
_v94b7adb6cdb9 . notify . enabled = not _v94b7adb6cdb9 . notify . enabled
_ve76b6087628a . Notify . refreshButtons ( )
end ) )
bind ( _ve76b6087628a . NotifyClear . MouseButton1Click : Connect ( function ( )
table . clear ( _ve76b6087628a . Notify . log )
for _ , entry in ipairs ( _ve76b6087628a . NotifyHistory : GetChildren ( ) ) do
if entry : IsA ( "\084\101\120\116\076\097\098\101\108" ) then entry : Destroy ( ) end
end
end ) )
_ve76b6087628a . Notify . emit = function ( key , message )
if _v94b7adb6cdb9 . closed or not _v94b7adb6cdb9 . notify . enabled or not _v94b7adb6cdb9 . notify [ key ] then return end
local stamp = os . date ( "\037\072\058\037\077\058\037\083" )
local line = ( "\091\037\115\093\032\037\115" ) : format ( stamp , message )
table . insert ( _ve76b6087628a . Notify . log , 1 , line )
if # _ve76b6087628a . Notify . log > 40 then table . remove ( _ve76b6087628a . Notify . log ) end
local entry = make ( "\084\101\120\116\076\097\098\101\108" , {
Parent = _ve76b6087628a . NotifyHistory , Size = UDim2 . new ( 1 , - 9 , 0 , 28 ) ,
BackgroundColor3 = C_PANEL , BorderSizePixel = 0 ,
Text = "\032\032" .. line , TextWrapped = true , TextColor3 = C_TEXT ,
Font = Enum . Font . Gotham , TextSize = 10 ,
TextXAlignment = Enum . TextXAlignment . Left ,
LayoutOrder = - math . floor ( os . clock ( ) * 1000 ) ,
} )
if # _ve76b6087628a . NotifyHistory : GetChildren ( ) > 44 then
for _ , child in ipairs ( _ve76b6087628a . NotifyHistory : GetChildren ( ) ) do
if child : IsA ( "\084\101\120\116\076\097\098\101\108" ) and child ~= entry
and child . LayoutOrder < math . huge then
local oldest = child
for _ , other in ipairs ( _ve76b6087628a . NotifyHistory : GetChildren ( ) ) do
if other : IsA ( "\084\101\120\116\076\097\098\101\108" ) and other . LayoutOrder > oldest . LayoutOrder then
oldest = other
end
end
oldest : Destroy ( )
break
end
end
end
if not _v94b7adb6cdb9 . notify . popups then return end
local toast = make ( "\084\101\120\116\076\097\098\101\108" , {
Parent = _ve76b6087628a . NotifyToastHost , Size = UDim2 . new ( 1 , 0 , 0 , 47 ) ,
BackgroundColor3 = C_NAV , BorderSizePixel = 0 ,
Text = "\032\032\082\065\067\069\082\032\032\047\032\032" .. message , TextWrapped = true ,
TextColor3 = C_TEXT , Font = Enum . Font . GothamBold ,
TextSize = 11 , TextXAlignment = Enum . TextXAlignment . Left ,
ZIndex = 42 ,
} )
make ( "\085\073\083\116\114\111\107\101" , { Parent = toast , Color = C_ACCENT , Thickness = 1 } )
task . delay ( 4 , function ( ) if toast . Parent then toast : Destroy ( ) end end )
for _ , item in ipairs ( _ve76b6087628a . NotifyToastHost : GetChildren ( ) ) do
if item : IsA ( "\084\101\120\116\076\097\098\101\108" ) and item ~= toast and
# _ve76b6087628a . NotifyToastHost : GetChildren ( ) > 5 then item : Destroy ( ) end
end
end
_ve76b6087628a . Notify . detach = function ( p )
local old = _ve76b6087628a . Notify . watchers [ p ]
if not old then return end
for _ , connection in ipairs ( old . connections ) do connection : Disconnect ( ) end
_ve76b6087628a . Notify . watchers [ p ] = nil
end
_ve76b6087628a . Notify . check = function ( p , w )
if _v94b7adb6cdb9 . closed or _ve76b6087628a . Notify . watchers [ p ] ~= w or not _vfc22e7e5f23c [ p ] then return end
local rec = w . record
local hum = rec . humanoid
if not hum . Parent then return end
local effects = rec . model : FindFirstChild ( "\066\111\100\121\069\102\102\101\099\116\115" )
local ko = effects and effects : FindFirstChild ( "\075\046\079" )
local dead = effects and effects : FindFirstChild ( "\068\101\097\100" )
local state = ( ( dead and dead : IsA ( "\066\111\111\108\086\097\108\117\101" ) and dead . Value )
or hum . Health <= 0 ) and "\100\101\097\100"
or ( ko and ko : IsA ( "\066\111\111\108\086\097\108\117\101" ) and ko . Value ) and "\100\111\119\110\101\100"
or "\104\101\097\108\116\104\121"
if w . state ~= nil and state ~= w . state then
if state == "\100\111\119\110\101\100" then
_ve76b6087628a . Notify . emit ( "\100\111\119\110\101\100" , "\064" .. p . Name .. "\032\119\097\115\032\100\111\119\110\101\100" )
elseif state == "\100\101\097\100" then
_ve76b6087628a . Notify . emit ( "\100\101\097\100" , "\064" .. p . Name .. "\032\100\105\101\100" )
end
end
w . state = state
local low = state == "\104\101\097\108\116\104\121" and hum . Health > 0 and hum . Health <= 30
if w . low ~= nil and low and not w . low then
_ve76b6087628a . Notify . emit ( "\108\111\119\072\101\097\108\116\104" , "\064" .. p . Name .. "\032\104\097\115\032"
.. math . floor ( hum . Health ) .. "\032\072\080" )
end
w . low = low
end
_ve76b6087628a . Notify . attach = function ( p , rec )
local previous = _ve76b6087628a . Notify . watchers [ p ]
if previous and rec and previous . model == rec . model then return end
_ve76b6087628a . Notify . detach ( p )
if not rec or not rec . model or not rec . model . Parent then return end
local last = _ve76b6087628a . Notify . knownModels [ p ]
if last and last ~= rec . model
and os . clock ( ) - ( _ve76b6087628a . Notify . lastRespawnAt [ p ] or - math . huge ) > 1.3 then
_ve76b6087628a . Notify . emit ( "\114\101\115\112\097\119\110\101\100" , "\064" .. p . Name .. "\032\114\101\115\112\097\119\110\101\100" )
_ve76b6087628a . Notify . lastRespawnAt [ p ] = os . clock ( )
end
_ve76b6087628a . Notify . knownModels [ p ] = rec . model
local w = { model = rec . model , record = rec ,
connections = { } , state = nil , low = nil , flags = { } }
_ve76b6087628a . Notify . watchers [ p ] = w
local function add ( connection )
w . connections [ # w . connections + 1 ] = connection
end
local function watchFlag ( flag )
if w . flags [ flag ] or not flag : IsA ( "\066\111\111\108\086\097\108\117\101" ) then return end
if flag . Name ~= "\075\046\079" and flag . Name ~= "\068\101\097\100" then return end
w . flags [ flag ] = true
add ( flag : GetPropertyChangedSignal ( "\086\097\108\117\101" ) : Connect ( function ( )
_ve76b6087628a . Notify . check ( p , w )
end ) )
end
local function watchEffects ( effects )
if not effects or w . effects == effects then return end
w . effects = effects
for _ , child in ipairs ( effects : GetChildren ( ) ) do watchFlag ( child ) end
add ( effects . ChildAdded : Connect ( function ( child )
watchFlag ( child )
_ve76b6087628a . Notify . check ( p , w )
end ) )
_ve76b6087628a . Notify . check ( p , w )
end
add ( rec . humanoid . HealthChanged : Connect ( function ( )
_ve76b6087628a . Notify . check ( p , w )
end ) )
add ( rec . model . ChildAdded : Connect ( function ( child )
if child . Name == "\066\111\100\121\069\102\102\101\099\116\115" then watchEffects ( child ) end
end ) )
watchEffects ( rec . model : FindFirstChild ( "\066\111\100\121\069\102\102\101\099\116\115" ) )
_ve76b6087628a . Notify . check ( p , w )
end
label ( _ve76b6087628a . ConfigPage , "\080\082\079\070\073\076\069\083\032\032\047\032\032\076\079\067\065\076\032\083\069\084\084\073\078\071\083" , 20 , 24 , C_ACCENT , 12 )
label ( _ve76b6087628a . ConfigPage , "\067\104\111\111\115\101\032\097\032\115\108\111\116\044\032\116\104\101\110\032\115\097\118\101\032\111\114\032\108\111\097\100\032\121\111\117\114\032\112\114\101\102\101\114\101\110\099\101\115\046" ,
49 , 22 , C_FAINT , 10 )
_ve76b6087628a . ConfigSlots = {
button ( _ve76b6087628a . ConfigPage , "\083\076\079\084\032\049" , 12 , 88 , 106 , 38 ) ,
button ( _ve76b6087628a . ConfigPage , "\083\076\079\084\032\050" , 130 , 88 , 106 , 38 ) ,
button ( _ve76b6087628a . ConfigPage , "\083\076\079\084\032\051" , 248 , 88 , 106 , 38 ) ,
}
_ve76b6087628a . ConfigSave = button ( _ve76b6087628a . ConfigPage , "\083\065\086\069\032\083\069\076\069\067\084\069\068\032\083\076\079\084" , 12 , 145 , 342 , 42 )
_ve76b6087628a . ConfigLoad = button ( _ve76b6087628a . ConfigPage , "\076\079\065\068\032\083\069\076\069\067\084\069\068\032\083\076\079\084" , 12 , 198 , 342 , 42 )
_ve76b6087628a . ConfigStatus = label ( _ve76b6087628a . ConfigPage , "\083\108\111\116\032\049\032\115\101\108\101\099\116\101\100\046" , 263 , 48 , C_FAINT , 11 )
_ve76b6087628a . ConfigStatus . TextWrapped = true
_ve76b6087628a . MacroBtn = button ( _ve76b6087628a . ConfigPage , "\077\065\067\082\079\032\080\069\082\083\073\083\084\058\032\079\070\070" , 12 , 313 , 342 , 39 )
label ( _ve76b6087628a . ConfigPage , "\075\101\101\112\032\116\104\101\032\103\097\109\101\039\115\032\109\097\099\114\111\032\097\099\116\105\118\101\032\116\104\114\111\117\103\104\032\110\111\114\109\097\108\032\097\099\116\105\111\110\115\046" ,
365 , 27 , C_FAINT , 10 )
label ( _ve76b6087628a . ConfigPage , "\080\114\111\102\105\108\101\115\032\108\111\097\100\032\111\110\108\121\032\119\104\101\110\032\121\111\117\032\112\114\101\115\115\032\076\079\065\068\046" ,
402 , 24 , C_FAINT , 10 )
label ( SettingsPage , "\077\079\086\069\077\069\078\084\032\038\032\080\069\082\083\079\078\065\076\073\083\065\084\073\079\078" , 12 , 20 , C_ACCENT , 12 )
local AntiVoidBtn = button ( SettingsPage , "\065\078\084\073\032\086\079\073\068\058\032\079\078" , 12 , 39 , 342 , 34 )
local VoidKillBtn = button ( SettingsPage , "\065\085\084\079\032\075\073\076\076\032\086\079\073\068\032\066\076\073\078\075\058\032\079\078" , 12 , 81 , 342 , 34 )
local function slider ( parent , title , y , initial , convert , onChange , format )
local caption = label ( parent , title , y , 20 , C_TEXT , 11 )
local track = round ( make ( "\070\114\097\109\101" , { Parent = parent , Active = true ,
Position = UDim2 . fromOffset ( 12 , y + 27 ) , Size = UDim2 . fromOffset ( 342 , 9 ) ,
BackgroundColor3 = C_OFF , BorderSizePixel = 0 } ) , 5 )
local fill = round ( make ( "\070\114\097\109\101" , { Parent = track , Size = UDim2 . fromScale ( 0 , 1 ) ,
BackgroundColor3 = C_ACCENT , BorderSizePixel = 0 } ) , 5 )
local knob = round ( make ( "\070\114\097\109\101" , { Parent = track , Active = true ,
AnchorPoint = Vector2 . new ( 0.5 , 0.5 ) , Position = UDim2 . fromScale ( 0 , 0.5 ) ,
Size = UDim2 . fromOffset ( 16 , 16 ) , BackgroundColor3 = C_ACCENT ,
BorderSizePixel = 0 } ) , 8 )
make ( "\085\073\083\116\114\111\107\101" , { Parent = knob , Color = C_BG , Thickness = 2 } )
local dragging = false
local function setFraction ( fraction )
fraction = math . clamp ( fraction , 0 , 1 )
fill . Size = UDim2 . fromScale ( fraction , 1 )
knob . Position = UDim2 . fromScale ( fraction , 0.5 )
local value = convert ( fraction )
onChange ( value )
caption . Text = title .. "\032\032" .. format ( value )
end
local function fromInput ( input )
local width = math . max ( 1 , track . AbsoluteSize . X )
setFraction ( ( input . Position . X - track . AbsolutePosition . X ) / width )
end
for _ , item in ipairs ( { track , knob } ) do
bind ( item . InputBegan : Connect ( function ( input )
if input . UserInputType == Enum . UserInputType . MouseButton1
or input . UserInputType == Enum . UserInputType . Touch then
dragging = true
fromInput ( input )
end
end ) )
end
bind ( _vcb684e26a41a . InputChanged : Connect ( function ( input )
if dragging and ( input . UserInputType == Enum . UserInputType . MouseMovement
or input . UserInputType == Enum . UserInputType . Touch ) then fromInput ( input ) end
end ) )
bind ( _vcb684e26a41a . InputEnded : Connect ( function ( input )
if input . UserInputType == Enum . UserInputType . MouseButton1
or input . UserInputType == Enum . UserInputType . Touch then dragging = false end
end ) )
setFraction ( initial )
return setFraction
end
local setStompPace = slider ( SettingsPage , "\065\085\084\079\032\083\084\079\077\080\032\080\065\067\069" , 124 ,
( math . log10 ( _v94b7adb6cdb9 . stompPace ) + MinStompPaceExponent ) / MinStompPaceExponent ,
function ( f ) return 10 ^ ( - MinStompPaceExponent + MinStompPaceExponent * f ) end ,
function ( value ) _v94b7adb6cdb9 . stompPace = value end ,
function ( value ) return string . format ( "%.3g×" , value ) end )
local PaceMax = button ( SettingsPage , "\077\065\088" , 12 , 174 , 106 , 28 )
local PaceFast = button ( SettingsPage , "\070\065\083\084" , 130 , 174 , 106 , 28 )
local PaceNormal = button ( SettingsPage , "\078\079\082\077\065\076" , 248 , 174 , 106 , 28 )
bind ( PaceMax . MouseButton1Click : Connect ( function ( ) setStompPace ( 0 ) end ) )
bind ( PaceFast . MouseButton1Click : Connect ( function ( )
setStompPace ( ( math . log10 ( 0.05 ) + MinStompPaceExponent ) / MinStompPaceExponent )
end ) )
bind ( PaceNormal . MouseButton1Click : Connect ( function ( ) setStompPace ( 1 ) end ) )
label ( SettingsPage , "Minimum 1e-282×; game frames limit actual calls." , 206 , 17 , C_FAINT , 10 )
_ve76b6087628a . setStrafeRadius = slider ( SettingsPage , "\083\084\082\065\070\069\032\082\065\068\073\085\083" , 230 , ( _v94b7adb6cdb9 . strafeRadius - 4 ) / 10 ,
function ( f ) return 4 + f * 10 end ,
function ( value ) _v94b7adb6cdb9 . strafeRadius = value end ,
function ( value ) return string . format ( "\037\046\049\102\032\115\116\117\100\115" , value ) end )
_ve76b6087628a . setVoidDepth = slider ( SettingsPage , "\086\079\073\068\032\068\069\080\084\072" , 289 , ( - _v94b7adb6cdb9 . voidDepth - 60 ) / 240 ,
function ( f ) return - ( 60 + f * 240 ) end ,
function ( value ) _v94b7adb6cdb9 . voidDepth = value end ,
function ( value ) return string . format ( "\037\046\048\102\032\089" , value ) end )
_ve76b6087628a . setUiScale = slider ( SettingsPage , "\073\078\084\069\082\070\065\067\069\032\083\067\065\076\069" , 349 , ( _v94b7adb6cdb9 . uiScale - 0.7 ) / 0.5 ,
function ( f ) return 0.7 + f * 0.5 end ,
function ( value ) _v94b7adb6cdb9 . uiScale = value ; MainScale . Scale = value end ,
function ( value ) return string . format ( "%.2f×" , value ) end )
local ThemeNames = { "\066\076\085\069" , "\086\073\079\076\069\084" , "\071\082\069\069\078" , "\065\077\066\069\082" }
local ThemeColors = {
Color3 . fromRGB ( 78 , 142 , 255 ) , Color3 . fromRGB ( 165 , 106 , 236 ) ,
Color3 . fromRGB ( 74 , 180 , 129 ) , Color3 . fromRGB ( 230 , 159 , 64 ) ,
}
local ThemeBtn = button ( SettingsPage , "\065\067\067\069\078\084\058\032\066\076\085\069" , 12 , 407 , 166 , 30 )
_ve76b6087628a . RespawnDeathBtn = button ( SettingsPage , "\082\069\083\080\065\087\078\032\065\084\032\068\069\065\084\072\058\032\079\070\070" , 188 , 407 , 166 , 30 )
local function applyTheme ( index )
local old = C_ACCENT
local oldNav = C_NAV_SELECTED
C_ACCENT = ThemeColors [ index ]
C_NAV_SELECTED = C_ACCENT : Lerp ( C_NAV , 0.18 )
for _ , item in ipairs ( _v5e8292a54b81 : GetDescendants ( ) ) do
if item : IsA ( "\085\073\083\116\114\111\107\101" ) and item . Color == old then item . Color = C_ACCENT end
if item : IsA ( "\084\101\120\116\076\097\098\101\108" ) and item . TextColor3 == old then item . TextColor3 = C_ACCENT end
if item : IsA ( "\070\114\097\109\101" ) and item . BackgroundColor3 == old then
item . BackgroundColor3 = C_ACCENT
end
if item : IsA ( "\084\101\120\116\066\117\116\116\111\110" ) and item . BackgroundColor3 == oldNav then
item . BackgroundColor3 = C_NAV_SELECTED
end
end
ThemeBtn . Text = "\065\067\067\069\078\084\058\032" .. ThemeNames [ index ]
end
bind ( ThemeBtn . MouseButton1Click : Connect ( function ( )
_v94b7adb6cdb9 . themeIndex = _v94b7adb6cdb9 . themeIndex % # ThemeNames + 1
applyTheme ( _v94b7adb6cdb9 . themeIndex )
end ) )
bind ( _ve76b6087628a . RespawnDeathBtn . MouseButton1Click : Connect ( function ( )
_v94b7adb6cdb9 . respawnAtDeath = not _v94b7adb6cdb9 . respawnAtDeath
if not _v94b7adb6cdb9 . respawnAtDeath then DeathPosition = nil end
style ( _ve76b6087628a . RespawnDeathBtn , _v94b7adb6cdb9 . respawnAtDeath ,
"\082\069\083\080\065\087\078\032\065\084\032\068\069\065\084\072\058\032\079\078" , "\082\069\083\080\065\087\078\032\065\084\032\068\069\065\084\072\058\032\079\070\070" )
end ) )
bind ( AntiVoidBtn . MouseButton1Click : Connect ( function ( )
_v94b7adb6cdb9 . antiVoid = not _v94b7adb6cdb9 . antiVoid
style ( AntiVoidBtn , _v94b7adb6cdb9 . antiVoid , "\065\078\084\073\032\086\079\073\068\058\032\079\078" , "\065\078\084\073\032\086\079\073\068\058\032\079\070\070" )
end ) )
bind ( VoidKillBtn . MouseButton1Click : Connect ( function ( )
_v94b7adb6cdb9 . autoKillVoid = not _v94b7adb6cdb9 . autoKillVoid
style ( VoidKillBtn , _v94b7adb6cdb9 . autoKillVoid ,
"\065\085\084\079\032\075\073\076\076\032\086\079\073\068\032\066\076\073\078\075\058\032\079\078" , "\065\085\084\079\032\075\073\076\076\032\086\079\073\068\032\066\076\073\078\075\058\032\079\070\070" )
end ) )
style ( AntiVoidBtn , _v94b7adb6cdb9 . antiVoid , "\065\078\084\073\032\086\079\073\068\058\032\079\078" , "\065\078\084\073\032\086\079\073\068\058\032\079\070\070" )
style ( VoidKillBtn , _v94b7adb6cdb9 . autoKillVoid ,
"\065\085\084\079\032\075\073\076\076\032\086\079\073\068\032\066\076\073\078\075\058\032\079\078" , "\065\085\084\079\032\075\073\076\076\032\086\079\073\068\032\066\076\073\078\075\058\032\079\070\070" )
local _v36cf7598a9cb = "\116\097\114\103\101\116\115"
local function showTab ( which )
_v36cf7598a9cb = which
_v3d850843c1c9 . Visible = which == "\116\097\114\103\101\116\115"
_v3aa54b3310d7 . Visible = which == "\097\105\109"
_v0fe2b2daf78a . Visible = which == "\116\111\111\108\115"
SettingsPage . Visible = which == "\115\101\116\116\105\110\103\115"
_ve76b6087628a . GunsPage . Visible = which == "\103\117\110\115"
_ve76b6087628a . EspPage . Visible = which == "\101\115\112"
_ve76b6087628a . TeleportPage . Visible = which == "\116\101\108\101\112\111\114\116"
_ve76b6087628a . StandPage . Visible = which == "\115\116\097\110\100"
_ve76b6087628a . NotifyPage . Visible = which == "\110\111\116\105\102\121"
_ve76b6087628a . ConfigPage . Visible = which == "\099\111\110\102\105\103\115"
TargetTab . BackgroundColor3 = _v3d850843c1c9 . Visible and C_NAV_SELECTED or C_NAV_OFF
AimTab . BackgroundColor3 = _v3aa54b3310d7 . Visible and C_NAV_SELECTED or C_NAV_OFF
ToolsTab . BackgroundColor3 = _v0fe2b2daf78a . Visible and C_NAV_SELECTED or C_NAV_OFF
SettingsTab . BackgroundColor3 = SettingsPage . Visible and C_NAV_SELECTED or C_NAV_OFF
_ve76b6087628a . GunsTab . BackgroundColor3 = _ve76b6087628a . GunsPage . Visible and C_NAV_SELECTED or C_NAV_OFF
_ve76b6087628a . EspTab . BackgroundColor3 = _ve76b6087628a . EspPage . Visible and C_NAV_SELECTED or C_NAV_OFF
_ve76b6087628a . TeleportTab . BackgroundColor3 = _ve76b6087628a . TeleportPage . Visible and C_NAV_SELECTED or C_NAV_OFF
_ve76b6087628a . StandTab . BackgroundColor3 = _ve76b6087628a . StandPage . Visible and C_NAV_SELECTED or C_NAV_OFF
_ve76b6087628a . NotifyTab . BackgroundColor3 = _ve76b6087628a . NotifyPage . Visible and C_NAV_SELECTED or C_NAV_OFF
_ve76b6087628a . ConfigTab . BackgroundColor3 = _ve76b6087628a . ConfigPage . Visible and C_NAV_SELECTED or C_NAV_OFF
for _ , tab in ipairs ( { TargetTab , AimTab , ToolsTab , SettingsTab ,
_ve76b6087628a . GunsTab , _ve76b6087628a . EspTab , _ve76b6087628a . TeleportTab ,
_ve76b6087628a . StandTab , _ve76b6087628a . NotifyTab , _ve76b6087628a . ConfigTab } ) do
tab : SetAttribute ( "\083\112\101\099\116\114\097\084\097\098" , true )
tab : SetAttribute ( "\083\112\101\099\116\114\097\079\110" , tab . BackgroundColor3 == C_NAV_SELECTED )
end
local activePage = which == "\116\097\114\103\101\116\115" and _v3d850843c1c9
or which == "\097\105\109" and _v3aa54b3310d7
or which == "\116\111\111\108\115" and _v0fe2b2daf78a
or which == "\115\101\116\116\105\110\103\115" and SettingsPage
or which == "\103\117\110\115" and _ve76b6087628a . GunsPage
or which == "\101\115\112" and _ve76b6087628a . EspPage
or which == "\116\101\108\101\112\111\114\116" and _ve76b6087628a . TeleportPage
or which == "\115\116\097\110\100" and _ve76b6087628a . StandPage
or which == "\110\111\116\105\102\121" and _ve76b6087628a . NotifyPage
or _ve76b6087628a . ConfigPage
activePage . Position = UDim2 . fromOffset ( 143 , 91 )
game : GetService ( "\084\119\101\101\110\083\101\114\118\105\099\101" ) : Create ( activePage ,
TweenInfo . new ( 0.22 , Enum . EasingStyle . Quart , Enum . EasingDirection . Out ) ,
{ Position = UDim2 . fromOffset ( 132 , 91 ) } ) : Play ( )
end
bind ( TargetTab . MouseButton1Click : Connect ( function ( ) showTab ( "\116\097\114\103\101\116\115" ) end ) )
bind ( AimTab . MouseButton1Click : Connect ( function ( ) showTab ( "\097\105\109" ) end ) )
bind ( ToolsTab . MouseButton1Click : Connect ( function ( ) showTab ( "\116\111\111\108\115" ) end ) )
bind ( SettingsTab . MouseButton1Click : Connect ( function ( ) showTab ( "\115\101\116\116\105\110\103\115" ) end ) )
bind ( _ve76b6087628a . GunsTab . MouseButton1Click : Connect ( function ( ) showTab ( "\103\117\110\115" ) end ) )
bind ( _ve76b6087628a . EspTab . MouseButton1Click : Connect ( function ( ) showTab ( "\101\115\112" ) end ) )
bind ( _ve76b6087628a . TeleportTab . MouseButton1Click : Connect ( function ( ) showTab ( "\116\101\108\101\112\111\114\116" ) end ) )
bind ( _ve76b6087628a . StandTab . MouseButton1Click : Connect ( function ( ) showTab ( "\115\116\097\110\100" ) end ) )
bind ( _ve76b6087628a . NotifyTab . MouseButton1Click : Connect ( function ( ) showTab ( "\110\111\116\105\102\121" ) end ) )
bind ( _ve76b6087628a . ConfigTab . MouseButton1Click : Connect ( function ( ) showTab ( "\099\111\110\102\105\103\115" ) end ) )
showTab ( "\116\097\114\103\101\116\115" )
local Minimized = false
bind ( Minimise . MouseButton1Click : Connect ( function ( )
Minimized = not Minimized
game : GetService ( "\084\119\101\101\110\083\101\114\118\105\099\101" ) : Create ( _v373596433c68 ,
TweenInfo . new ( 0.25 , Enum . EasingStyle . Quart , Enum . EasingDirection . Out ) ,
{ Size = UDim2 . fromOffset ( 520 , Minimized and 67 or 625 ) } ) : Play ( )
Minimise . Text = Minimized and "\043" or "\045"
Subtitle . Visible = not Minimized
TargetTab . Visible = not Minimized
AimTab . Visible = not Minimized
ToolsTab . Visible = not Minimized
SettingsTab . Visible = not Minimized
_ve76b6087628a . GunsTab . Visible = not Minimized
_ve76b6087628a . EspTab . Visible = not Minimized
_ve76b6087628a . TeleportTab . Visible = not Minimized
_ve76b6087628a . StandTab . Visible = not Minimized
_ve76b6087628a . NotifyTab . Visible = not Minimized
_ve76b6087628a . ConfigTab . Visible = not Minimized
_v31d991e95e81 . Visible = not Minimized
StatusBar . Visible = not Minimized
Sidebar . Visible = not Minimized
if Minimized then
_v3d850843c1c9 . Visible , _v3aa54b3310d7 . Visible , _v0fe2b2daf78a . Visible ,
SettingsPage . Visible , _ve76b6087628a . GunsPage . Visible ,
_ve76b6087628a . EspPage . Visible , _ve76b6087628a . TeleportPage . Visible ,
_ve76b6087628a . StandPage . Visible , _ve76b6087628a . NotifyPage . Visible ,
_ve76b6087628a . ConfigPage . Visible =
false , false , false , false , false , false , false , false , false , false
else
showTab ( _v36cf7598a9cb )
end
end ) )
local function say ( message )
if not _v94b7adb6cdb9 . closed then _v31d991e95e81 . Text = message end
end
do
local previous = nil
local function teleportTo ( position , title )
local character = _vad430fdb5ce8 . Character
local root = character and character : FindFirstChild ( "\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116" )
if not root then say ( "\084\101\108\101\112\111\114\116\032\117\110\097\118\097\105\108\097\098\108\101\032\117\110\116\105\108\032\121\111\117\114\032\099\104\097\114\097\099\116\101\114\032\115\112\097\119\110\115\046" ) ; return end
previous = root . CFrame
character : PivotTo ( CFrame . new ( position + Vector3 . new ( 0 , 4 , 0 ) ) )
say ( "\084\101\108\101\112\111\114\116\101\100\032\116\111\032" .. title .. "\046" )
end
local function nearestShop ( name )
local store = _v8b8ca6137d87 : FindFirstChild ( "\083\116\111\114\101" )
local root = _vad430fdb5ce8 . Character and _vad430fdb5ce8 . Character : FindFirstChild ( "\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116" )
if not store or not root then return nil end
local nearest , distance = nil , math . huge
for _ , shop in ipairs ( store : GetChildren ( ) ) do
if shop . Name == name then
local part = shop : FindFirstChildWhichIsA ( "\066\097\115\101\080\097\114\116" , true )
if part then
local d = ( part . Position - root . Position ) . Magnitude
if d < distance then nearest , distance = part , d end
end
end
end
return nearest
end
local t = _ve76b6087628a . TeleportButtons
bind ( t . uphill . MouseButton1Click : Connect ( function ( )
teleportTo ( Vector3 . new ( 1750.13 , 29.45 , 244.33 ) , "\085\112\104\105\108\108" )
end ) )
bind ( t . downhill . MouseButton1Click : Connect ( function ( )
teleportTo ( Vector3 . new ( 722.42 , 1.75 , 264.21 ) , "\068\111\119\110\104\105\108\108" )
end ) )
for _ , entry in ipairs ( { { t . armor , "\091\065\114\109\111\114\093" , "\065\114\109\111\114\032\115\104\111\112" } ,
{ t . smg , "\091\083\077\071\093" , "\083\077\071\032\115\104\111\112" } } ) do
bind ( entry [ 1 ] . MouseButton1Click : Connect ( function ( )
local part = nearestShop ( entry [ 2 ] )
if part then teleportTo ( part . Position , entry [ 3 ] )
else say ( entry [ 3 ] .. "\032\105\115\032\110\111\116\032\108\111\097\100\101\100\032\110\101\097\114\098\121\046" ) end
end ) )
end
bind ( t . returnTo . MouseButton1Click : Connect ( function ( )
local character = _vad430fdb5ce8 . Character
if previous and character and character : FindFirstChild ( "\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116" ) then
local destination = previous
previous = character : GetPivot ( )
character : PivotTo ( destination )
say ( "\082\101\116\117\114\110\101\100\032\116\111\032\112\114\101\118\105\111\117\115\032\112\111\115\105\116\105\111\110\046" )
else say ( "\078\111\032\112\114\101\118\105\111\117\115\032\116\101\108\101\112\111\114\116\032\112\111\115\105\116\105\111\110\032\115\097\118\101\100\046" ) end
end ) )
end
local _vf7c4bc36ea3b = { }
do
local RapidOriginal = setmetatable ( { } , { __mode = "\107" } )
local PaceByName = { }
local RapidWatched = setmetatable ( { } , { __mode = "\107" } )
local RapidLast = setmetatable ( { } , { __mode = "\107" } )
local ReloadLast = setmetatable ( { } , { __mode = "\107" } )
local GunRows = { }
local GunRowCount = 0
local function ownedGuns ( callback )
local containers = { }
if _vad430fdb5ce8 . Character then containers [ # containers + 1 ] = _vad430fdb5ce8 . Character end
local bag = _vad430fdb5ce8 : FindFirstChildOfClass ( "\066\097\099\107\112\097\099\107" )
if bag then containers [ # containers + 1 ] = bag end
for _ , container in ipairs ( containers ) do
if container then
for _ , tool in ipairs ( container : GetChildren ( ) ) do
if tool : IsA ( "\084\111\111\108" ) then callback ( tool ) end
end
end
end
end
local function applyRapidCooldown ( tool )
if not tool or not tool : IsA ( "\084\111\111\108" ) then return end
local cooldown = tool : GetAttribute ( "\067\111\111\108\100\111\119\110" )
if _v94b7adb6cdb9 . rapidWeapons [ tool . Name ] then
if type ( cooldown ) == "\110\117\109\098\101\114" and cooldown ~= 0 then
RapidOriginal [ tool ] = cooldown
tool : SetAttribute ( "\067\111\111\108\100\111\119\110" , 0 )
end
elseif RapidOriginal [ tool ] ~= nil then
local original = RapidOriginal [ tool ]
RapidOriginal [ tool ] = nil
pcall ( function ( ) tool : SetAttribute ( "\067\111\111\108\100\111\119\110" , original ) end )
end
end
_vf7c4bc36ea3b . getPace = function ( tool )
if not _v94b7adb6cdb9 . adaptiveRapid then return 0 end
local name = tool . Name
local base = RapidOriginal [ tool ] or tool : GetAttribute ( "\067\111\111\108\100\111\119\110" ) or 0.2
if type ( base ) ~= "\110\117\109\098\101\114" or base <= 0 then base = 0.2 end
local minimum = name == "\091\082\101\118\111\108\118\101\114\093" and 0.05
or name == "\091\083\077\071\093" and 0.045
or ( name == "\091\068\111\117\098\108\101\045\066\097\114\114\101\108\032\083\071\093" or name == "\091\083\104\111\116\103\117\110\093"
or name == "\091\084\097\099\116\105\099\097\108\083\104\111\116\103\117\110\093" ) and 0.16 or 0.06
local stats = PaceByName [ name ]
if not stats then
stats = { pace = math . max ( minimum , base * 0.5 ) ,
base = base , minimum = minimum , windowAt = os . clock ( ) , hit = false }
PaceByName [ name ] = stats
end
local now = os . clock ( )
if now - stats . windowAt >= 1 then
stats . pace = math . clamp ( stats . pace * ( stats . hit and 0.93 or 1.18 ) ,
stats . minimum , math . max ( stats . minimum , stats . base ) )
stats . windowAt , stats . hit = now , false
end
return stats . pace
end
_vf7c4bc36ea3b . lastShotAt = function ( tool )
return RapidLast [ tool ] or 0
end
_vf7c4bc36ea3b . noteShot = function ( tool )
RapidLast [ tool ] = os . clock ( )
_v94b7adb6cdb9 . lastAttemptWeaponName = tool . Name
end
_vf7c4bc36ea3b . activate = function ( tool )
_vf7c4bc36ea3b . noteShot ( tool )
return pcall ( function ( ) tool : Activate ( ) end )
end
_vf7c4bc36ea3b . noteConfirmed = function ( name )
local stats = name and PaceByName [ name ]
if stats then stats . hit = true end
end
local function requestReload ( tool )
if not tool or type ( tool : GetAttribute ( "\077\097\120\065\109\109\111" ) ) ~= "\110\117\109\098\101\114" then return end
local real = tool : GetAttribute ( "\082\101\097\108\065\109\109\111" )
local ammo = tool : GetAttribute ( "\065\109\109\111" )
local remaining = type ( real ) == "\110\117\109\098\101\114" and real or ammo
if type ( ammo ) == "\110\117\109\098\101\114" and type ( remaining ) == "\110\117\109\098\101\114" then
remaining = math . min ( remaining , ammo )
end
if type ( remaining ) ~= "\110\117\109\098\101\114" or remaining > 2 then return end
local now = os . clock ( )
if now - ( ReloadLast [ tool ] or 0 ) < 0.8 then return end
ReloadLast [ tool ] = now
local storage = _v7ab6349c26e8 : FindFirstChild ( "\083\116\111\114\097\103\101" )
local remotes = storage and storage : FindFirstChild ( "\082\101\109\111\116\101\115" )
local main = remotes and remotes : FindFirstChild ( "\077\097\105\110" )
if main then pcall ( function ( ) main : FireServer ( "\082\101\108\111\097\100" , tool ) end ) end
end
_vf7c4bc36ea3b . requestReload = requestReload
local function addGunRow ( name )
if GunRows [ name ] then return end
GunRowCount = GunRowCount + 1
local row = button ( _ve76b6087628a . GunList , name .. "\032\032\047\032\032\079\070\070" , 5 , 0 , 326 , 35 )
row . LayoutOrder = GunRowCount + 10
GunRows [ name ] = row
bind ( row . MouseButton1Click : Connect ( function ( )
_v94b7adb6cdb9 . rapidWeapons [ name ] = not _v94b7adb6cdb9 . rapidWeapons [ name ] or nil
style ( row , _v94b7adb6cdb9 . rapidWeapons [ name ] , name .. "\032\032\047\032\032\079\078" , name .. "\032\032\047\032\032\079\070\070" )
ownedGuns ( function ( tool )
if tool . Name == name then applyRapidCooldown ( tool ) end
end )
say ( name .. ( _v94b7adb6cdb9 . rapidWeapons [ name ] and "\032\114\097\112\105\100\032\102\105\114\101\032\101\110\097\098\108\101\100\046" or "\032\099\111\111\108\100\111\119\110\032\114\101\115\116\111\114\101\100\046" ) )
end ) )
end
local function observeGun ( tool )
if not tool : IsA ( "\084\111\111\108" ) then return end
if type ( tool : GetAttribute ( "\067\111\111\108\100\111\119\110" ) ) == "\110\117\109\098\101\114" then
addGunRow ( tool . Name )
applyRapidCooldown ( tool )
end
if RapidWatched [ tool ] then return end
RapidWatched [ tool ] = true
bind ( tool : GetAttributeChangedSignal ( "\067\111\111\108\100\111\119\110" ) : Connect ( function ( )
if not _v94b7adb6cdb9 . closed then observeGun ( tool ) end
end ) )
end
_vf7c4bc36ea3b . observeGun = observeGun
_vf7c4bc36ea3b . forEachGun = ownedGuns
_vf7c4bc36ea3b . applyCooldown = applyRapidCooldown
_vf7c4bc36ea3b . rows = GunRows
_vf7c4bc36ea3b . restore = function ( )
for tool , original in pairs ( RapidOriginal ) do
pcall ( function ( ) tool : SetAttribute ( "\067\111\111\108\100\111\119\110" , original ) end )
RapidOriginal [ tool ] = nil
end
end
for _ , name in ipairs ( { "\091\068\111\117\098\108\101\045\066\097\114\114\101\108\032\083\071\093" , "\091\082\101\118\111\108\118\101\114\093" , "\091\083\104\111\116\103\117\110\093" ,
"\091\084\097\099\116\105\099\097\108\083\104\111\116\103\117\110\093" , "\091\083\077\071\093" } ) do addGunRow ( name ) end
ownedGuns ( observeGun )
local Backpack = _vad430fdb5ce8 : FindFirstChildOfClass ( "\066\097\099\107\112\097\099\107" ) or _vad430fdb5ce8 : WaitForChild ( "\066\097\099\107\112\097\099\107" , 6 )
if Backpack then bind ( Backpack . ChildAdded : Connect ( observeGun ) ) end
bind ( _v286a8fc93150 . Heartbeat : Connect ( function ( )
if _v94b7adb6cdb9 . closed then return end
local character = _vad430fdb5ce8 . Character
local tool = character and character : FindFirstChildOfClass ( "\084\111\111\108" )
if tool and ( _v94b7adb6cdb9 . autoReloadAll or ( _v94b7adb6cdb9 . infiniteSmg and tool . Name == "\091\083\077\071\093" ) ) then
requestReload ( tool )
end
if not next ( _v94b7adb6cdb9 . rapidWeapons ) or _vcb684e26a41a : GetFocusedTextBox ( )
or not _vcb684e26a41a : IsMouseButtonPressed ( Enum . UserInputType . MouseButton1 ) then return end
local mouse = _vcb684e26a41a : GetMouseLocation ( )
local pos , size = _v373596433c68 . AbsolutePosition , _v373596433c68 . AbsoluteSize
if _v5e8292a54b81 . Enabled and mouse . X >= pos . X and mouse . X <= pos . X + size . X
and mouse . Y >= pos . Y and mouse . Y <= pos . Y + size . Y then return end
if tool and _v94b7adb6cdb9 . rapidWeapons [ tool . Name ]
and type ( tool : GetAttribute ( "\067\111\111\108\100\111\119\110" ) ) == "\110\117\109\098\101\114" then
local pace = _vf7c4bc36ea3b . getPace ( tool )
local now = os . clock ( )
if now - ( RapidLast [ tool ] or 0 ) >= pace then
_vf7c4bc36ea3b . activate ( tool )
end
end
end ) )
end
do
local RecoilOriginal = setmetatable ( { } , { __mode = "\107" } )
local ShotVisualOriginal = setmetatable ( { } , { __mode = "\107" } )
local SpreadOriginal = nil
local function applyRecoil ( character )
local scripts = character and character : FindFirstChild ( "\083\099\114\105\112\116\115" )
local input = scripts and scripts : FindFirstChild ( "\073\110\112\117\116" )
local module = input and input : FindFirstChild ( "\065\105\109\105\110\103\073\110\112\117\116" )
if not module then return end
local ok , aim = pcall ( require , module )
if not ok or type ( aim ) ~= "\116\097\098\108\101" or type ( aim . CameraRecoil ) ~= "\102\117\110\099\116\105\111\110" then return end
if not RecoilOriginal [ aim ] then RecoilOriginal [ aim ] = aim . CameraRecoil end
aim . CameraRecoil = ( _v94b7adb6cdb9 . noRecoil or _v94b7adb6cdb9 . invisibleShot )
and function ( ) end or RecoilOriginal [ aim ]
end
local function applyShotVisuals ( character )
local scripts = character and character : FindFirstChild ( "\083\099\114\105\112\116\115" )
local input = scripts and scripts : FindFirstChild ( "\073\110\112\117\116" )
local aiming = input and input : FindFirstChild ( "\065\105\109\105\110\103\073\110\112\117\116" )
if aiming then
local ok , aim = pcall ( require , aiming )
if ok and type ( aim ) == "\116\097\098\108\101" then
local originals = ShotVisualOriginal [ aim ]
if _v94b7adb6cdb9 . invisibleShot then
if not originals then
originals = {
GunshotReticle = aim . GunshotReticle ,
PlayShotAnimation = aim . PlayShotAnimation ,
}
ShotVisualOriginal [ aim ] = originals
end
aim . GunshotReticle = function ( ) end
aim . PlayShotAnimation = function ( ) end
elseif originals then
aim . GunshotReticle = originals . GunshotReticle
aim . PlayShotAnimation = originals . PlayShotAnimation
ShotVisualOriginal [ aim ] = nil
end
end
end
local storage = _v7ab6349c26e8 : FindFirstChild ( "\083\116\111\114\097\103\101" )
local modules = storage and storage : FindFirstChild ( "\077\111\100\117\108\101\115" )
local dialect = modules and modules : FindFirstChild ( "\068\105\097\108\101\099\116" )
local managerModule = dialect and dialect : FindFirstChild ( "\071\117\110\077\097\110\097\103\101\114" )
if managerModule then
local ok , manager = pcall ( require , managerModule )
if ok and type ( manager ) == "\116\097\098\108\101" then
local originals = ShotVisualOriginal [ manager ]
if _v94b7adb6cdb9 . invisibleShot then
if not originals then
originals = {
BulletTrails = manager . BulletTrails ,
ShootFXGui = manager . ShootFXGui ,
}
ShotVisualOriginal [ manager ] = originals
end
manager . BulletTrails = function ( _ , bullet )
if typeof ( bullet ) ~= "\073\110\115\116\097\110\099\101" then return end
if bullet : IsA ( "\066\097\115\101\080\097\114\116" ) then
bullet . Transparency = 1
bullet . LocalTransparencyModifier = 1
end
for _ , visual in ipairs ( bullet : GetDescendants ( ) ) do
if visual : IsA ( "\066\097\115\101\080\097\114\116" ) then
visual . Transparency = 1
visual . LocalTransparencyModifier = 1
elseif visual : IsA ( "\066\101\097\109" ) or visual : IsA ( "\084\114\097\105\108" )
or visual : IsA ( "\080\097\114\116\105\099\108\101\069\109\105\116\116\101\114" ) then
visual . Enabled = false
end
end
end
manager . ShootFXGui = function ( ) end
elseif originals then
manager . BulletTrails = originals . BulletTrails
manager . ShootFXGui = originals . ShootFXGui
ShotVisualOriginal [ manager ] = nil
end
end
end
local playerScripts = _vad430fdb5ce8 : FindFirstChild ( "\080\108\097\121\101\114\083\099\114\105\112\116\115" )
local mainScripts = playerScripts and playerScripts : FindFirstChild ( "\077\097\105\110" )
local handlers = mainScripts and mainScripts : FindFirstChild ( "\072\097\110\100\108\101\114\115" )
local bulletModule = handlers and handlers : FindFirstChild ( "\066\117\108\108\101\116\072\097\110\100\108\101\114" )
if bulletModule then
local ok , handler = pcall ( require , bulletModule )
if ok and type ( handler ) == "\116\097\098\108\101"
and type ( handler . ReplicateBullets ) == "\102\117\110\099\116\105\111\110" then
local originals = ShotVisualOriginal [ handler ]
if _v94b7adb6cdb9 . invisibleShot then
if not originals then
originals = { ReplicateBullets = handler . ReplicateBullets }
ShotVisualOriginal [ handler ] = originals
end
handler . ReplicateBullets = function ( self , shot )
if shot and shot . Player == _vad430fdb5ce8 then return end
return originals . ReplicateBullets ( self , shot )
end
elseif originals then
handler . ReplicateBullets = originals . ReplicateBullets
ShotVisualOriginal [ handler ] = nil
end
end
end
end
local function applySpread ( )
local storage = _v7ab6349c26e8 : FindFirstChild ( "\083\116\111\114\097\103\101" )
local modules = storage and storage : FindFirstChild ( "\077\111\100\117\108\101\115" )
local dialect = modules and modules : FindFirstChild ( "\068\105\097\108\101\099\116" )
local module = dialect and dialect : FindFirstChild ( "\071\117\110\077\097\110\097\103\101\114" )
if not module then return end
local ok , manager = pcall ( require , module )
if not ok or type ( manager ) ~= "\116\097\098\108\101" then return end
local patterns = manager [ "\091\068\111\117\098\108\101\045\066\097\114\114\101\108\032\083\071\093" ]
if type ( patterns ) ~= "\116\097\098\108\101" then return end
if not SpreadOriginal then
SpreadOriginal = { }
for i , pattern in ipairs ( patterns ) do
SpreadOriginal [ i ] = { }
for j , offset in ipairs ( pattern ) do SpreadOriginal [ i ] [ j ] = offset end
end
end
for i , pattern in ipairs ( patterns ) do
for j in ipairs ( pattern ) do
pattern [ j ] = _v94b7adb6cdb9 . noSpread and Vector3 . zero or SpreadOriginal [ i ] [ j ]
end
end
end
_ve76b6087628a . applyGunMods = function ( character )
applyRecoil ( character )
applyShotVisuals ( character )
applySpread ( )
end
_ve76b6087628a . restoreGunMods = function ( )
_v94b7adb6cdb9 . noRecoil , _v94b7adb6cdb9 . noSpread , _v94b7adb6cdb9 . invisibleShot = false , false , false
for aim , original in pairs ( RecoilOriginal ) do
pcall ( function ( ) aim . CameraRecoil = original end )
end
for module , originals in pairs ( ShotVisualOriginal ) do
pcall ( function ( )
for method , original in pairs ( originals ) do module [ method ] = original end
end )
ShotVisualOriginal [ module ] = nil
end
applySpread ( )
end
local invisibleBtn = button ( _ve76b6087628a . GunList , "\073\078\086\073\083\073\066\076\069\032\083\072\079\084\058\032\079\070\070" , 5 , 0 , 326 , 35 )
invisibleBtn . LayoutOrder = - 4
bind ( invisibleBtn . MouseButton1Click : Connect ( function ( )
_v94b7adb6cdb9 . invisibleShot = not _v94b7adb6cdb9 . invisibleShot
applyShotVisuals ( _vad430fdb5ce8 . Character )
applyRecoil ( _vad430fdb5ce8 . Character )
style ( invisibleBtn , _v94b7adb6cdb9 . invisibleShot ,
"\073\078\086\073\083\073\066\076\069\032\083\072\079\084\058\032\079\078" , "\073\078\086\073\083\073\066\076\069\032\083\072\079\084\058\032\079\070\070" )
say ( "\073\110\118\105\115\105\098\108\101\032\115\104\111\116\032\097\102\102\101\099\116\115\032\108\111\099\097\108\032\118\105\115\117\097\108\115\059\032\115\101\114\118\101\114\032\115\104\111\116\032\101\102\102\101\099\116\115\032\109\097\121\032\115\116\105\108\108\032\098\101\032\118\105\115\105\098\108\101\046" )
end ) )
local adaptiveBtn = button ( _ve76b6087628a . GunList , "\065\068\065\080\084\073\086\069\032\082\065\080\073\068\058\032\079\078" , 5 , 0 , 326 , 35 )
adaptiveBtn . LayoutOrder = - 5
bind ( adaptiveBtn . MouseButton1Click : Connect ( function ( )
_v94b7adb6cdb9 . adaptiveRapid = not _v94b7adb6cdb9 . adaptiveRapid
style ( adaptiveBtn , _v94b7adb6cdb9 . adaptiveRapid ,
"\065\068\065\080\084\073\086\069\032\082\065\080\073\068\058\032\079\078" , "\065\068\065\080\084\073\086\069\032\082\065\080\073\068\058\032\079\070\070" )
say ( "\065\100\097\112\116\105\118\101\032\114\097\112\105\100\032\116\117\110\101\115\032\101\097\099\104\032\101\110\097\098\108\101\100\032\103\117\110\032\102\114\111\109\032\099\111\110\102\105\114\109\101\100\032\100\097\109\097\103\101\032\119\105\110\100\111\119\115\046" )
end ) )
local recoilBtn = button ( _ve76b6087628a . GunList , "\078\079\032\082\069\067\079\073\076\058\032\079\070\070" , 5 , 0 , 326 , 35 )
recoilBtn . LayoutOrder = - 3
bind ( recoilBtn . MouseButton1Click : Connect ( function ( )
_v94b7adb6cdb9 . noRecoil = not _v94b7adb6cdb9 . noRecoil
applyRecoil ( _vad430fdb5ce8 . Character )
style ( recoilBtn , _v94b7adb6cdb9 . noRecoil , "\078\079\032\082\069\067\079\073\076\058\032\079\078" , "\078\079\032\082\069\067\079\073\076\058\032\079\070\070" )
end ) )
local spreadBtn = button ( _ve76b6087628a . GunList , "\068\066\032\078\079\032\083\080\082\069\065\068\058\032\079\070\070" , 5 , 0 , 326 , 35 )
spreadBtn . LayoutOrder = - 2
bind ( spreadBtn . MouseButton1Click : Connect ( function ( )
_v94b7adb6cdb9 . noSpread = not _v94b7adb6cdb9 . noSpread
applySpread ( )
style ( spreadBtn , _v94b7adb6cdb9 . noSpread , "\068\066\032\078\079\032\083\080\082\069\065\068\058\032\079\078" , "\068\066\032\078\079\032\083\080\082\069\065\068\058\032\079\070\070" )
end ) )
local smgBtn = button ( _ve76b6087628a . GunList , "\083\077\071\032\065\085\084\079\032\082\069\076\079\065\068\058\032\079\070\070" , 5 , 0 , 326 , 35 )
smgBtn . LayoutOrder = - 1
bind ( smgBtn . MouseButton1Click : Connect ( function ( )
_v94b7adb6cdb9 . infiniteSmg = not _v94b7adb6cdb9 . infiniteSmg
style ( smgBtn , _v94b7adb6cdb9 . infiniteSmg , "\083\077\071\032\065\085\084\079\032\082\069\076\079\065\068\058\032\079\078" , "\083\077\071\032\065\085\084\079\032\082\069\076\079\065\068\058\032\079\070\070" )
say ( "\083\077\071\032\114\101\108\111\097\100\032\114\101\113\117\101\115\116\115\032\102\111\108\108\111\119\032\116\104\101\032\115\101\114\118\101\114\032\097\109\109\111\032\099\111\117\110\116\046" )
end ) )
local reloadBtn = button ( _ve76b6087628a . GunList , "\065\085\084\079\032\082\069\076\079\065\068\032\065\076\076\032\071\085\078\083\058\032\079\070\070" , 5 , 0 , 326 , 35 )
reloadBtn . LayoutOrder = 0
_ve76b6087628a . GunModButtons = { invisible = invisibleBtn , adaptive = adaptiveBtn ,
recoil = recoilBtn , spread = spreadBtn , smg = smgBtn , reload = reloadBtn }
bind ( reloadBtn . MouseButton1Click : Connect ( function ( )
_v94b7adb6cdb9 . autoReloadAll = not _v94b7adb6cdb9 . autoReloadAll
style ( reloadBtn , _v94b7adb6cdb9 . autoReloadAll ,
"\065\085\084\079\032\082\069\076\079\065\068\032\065\076\076\032\071\085\078\083\058\032\079\078" , "\065\085\084\079\032\082\069\076\079\065\068\032\065\076\076\032\071\085\078\083\058\032\079\070\070" )
end ) )
local knifeBtn = button ( _ve76b6087628a . GunList , "\069\081\085\073\080\032\075\078\073\070\069" , 5 , 0 , 326 , 35 )
knifeBtn . LayoutOrder = 1
bind ( knifeBtn . MouseButton1Click : Connect ( function ( )
local character = _vad430fdb5ce8 . Character
local hum = character and character : FindFirstChildOfClass ( "\072\117\109\097\110\111\105\100" )
local bag = _vad430fdb5ce8 : FindFirstChildOfClass ( "\066\097\099\107\112\097\099\107" )
local knife = bag and bag : FindFirstChild ( "\091\075\110\105\102\101\093" )
if hum and knife then
hum : EquipTool ( knife )
say ( "\075\110\105\102\101\032\101\113\117\105\112\112\101\100\046" )
else say ( "\075\110\105\102\101\032\105\115\032\110\111\116\032\105\110\032\121\111\117\114\032\098\097\099\107\112\097\099\107\046" ) end
end ) )
end
do
local overlays = { }
local ranges = { 250 , 500 , 1000 , math . huge }
local colors = { Color3 . fromRGB ( 75 , 213 , 224 ) , Color3 . fromRGB ( 186 , 144 , 253 ) ,
Color3 . fromRGB ( 238 , 178 , 89 ) , Color3 . fromRGB ( 143 , 221 , 120 ) }
local colorNames = { "\067\089\065\078" , "\086\073\079\076\069\084" , "\065\077\066\069\082" , "\076\073\077\069" }
local r15 = { { "\072\101\097\100" , "\085\112\112\101\114\084\111\114\115\111" } , { "\085\112\112\101\114\084\111\114\115\111" , "\076\111\119\101\114\084\111\114\115\111" } ,
{ "\085\112\112\101\114\084\111\114\115\111" , "\076\101\102\116\085\112\112\101\114\065\114\109" } , { "\076\101\102\116\085\112\112\101\114\065\114\109" , "\076\101\102\116\076\111\119\101\114\065\114\109" } ,
{ "\076\101\102\116\076\111\119\101\114\065\114\109" , "\076\101\102\116\072\097\110\100" } , { "\085\112\112\101\114\084\111\114\115\111" , "\082\105\103\104\116\085\112\112\101\114\065\114\109" } ,
{ "\082\105\103\104\116\085\112\112\101\114\065\114\109" , "\082\105\103\104\116\076\111\119\101\114\065\114\109" } , { "\082\105\103\104\116\076\111\119\101\114\065\114\109" , "\082\105\103\104\116\072\097\110\100" } ,
{ "\076\111\119\101\114\084\111\114\115\111" , "\076\101\102\116\085\112\112\101\114\076\101\103" } , { "\076\101\102\116\085\112\112\101\114\076\101\103" , "\076\101\102\116\076\111\119\101\114\076\101\103" } ,
{ "\076\101\102\116\076\111\119\101\114\076\101\103" , "\076\101\102\116\070\111\111\116" } , { "\076\111\119\101\114\084\111\114\115\111" , "\082\105\103\104\116\085\112\112\101\114\076\101\103" } ,
{ "\082\105\103\104\116\085\112\112\101\114\076\101\103" , "\082\105\103\104\116\076\111\119\101\114\076\101\103" } , { "\082\105\103\104\116\076\111\119\101\114\076\101\103" , "\082\105\103\104\116\070\111\111\116" } }
local r6 = { { "\072\101\097\100" , "\084\111\114\115\111" } , { "\084\111\114\115\111" , "\076\101\102\116\032\065\114\109" } ,
{ "\084\111\114\115\111" , "\082\105\103\104\116\032\065\114\109" } , { "\084\111\114\115\111" , "\076\101\102\116\032\076\101\103" } , { "\084\111\114\115\111" , "\082\105\103\104\116\032\076\101\103" } }
local function clearOverlay ( o )
if not o then return end
pcall ( function ( ) o . box : Remove ( ) end )
pcall ( function ( ) o . name : Remove ( ) end )
pcall ( function ( ) o . distance : Remove ( ) end )
pcall ( function ( ) o . combat : Remove ( ) end )
pcall ( function ( ) o . healthBack : Remove ( ) end )
pcall ( function ( ) o . healthFill : Remove ( ) end )
pcall ( function ( ) o . tracer : Remove ( ) end )
for _ , line in ipairs ( o . lines ) do pcall ( function ( ) line : Remove ( ) end ) end
end
local function hideOverlay ( o )
o . box . Visible , o . name . Visible , o . distance . Visible , o . combat . Visible = false , false , false , false
o . healthBack . Visible , o . healthFill . Visible , o . tracer . Visible = false , false , false
for _ , line in ipairs ( o . lines ) do line . Visible = false end
end
local function createOverlay ( )
local o = { box = Drawing . new ( "\083\113\117\097\114\101" ) , name = Drawing . new ( "\084\101\120\116" ) ,
distance = Drawing . new ( "\084\101\120\116" ) , combat = Drawing . new ( "\084\101\120\116" ) ,
healthBack = Drawing . new ( "\083\113\117\097\114\101" ) ,
healthFill = Drawing . new ( "\083\113\117\097\114\101" ) , tracer = Drawing . new ( "\076\105\110\101" ) , lines = { } }
o . box . Filled = false
o . box . Thickness = 1.5
o . healthBack . Filled , o . healthFill . Filled = true , true
o . healthBack . Color = Color3 . fromRGB ( 16 , 22 , 35 )
o . tracer . Thickness = 1.4
o . name . Center , o . distance . Center , o . combat . Center = true , true , true
o . name . Outline , o . distance . Outline , o . combat . Outline = true , true , true
o . name . Size , o . distance . Size , o . combat . Size = 13 , 12 , 11
for i = 1 , # r15 do
local line = Drawing . new ( "\076\105\110\101" )
line . Thickness = 1.4
o . lines [ i ] = line
end
hideOverlay ( o )
return o
end
local function renderEsp ( )
if not _v94b7adb6cdb9 . esp . enabled and not ( _v94b7adb6cdb9 . dot and # _v71f22c1d3c92 > 0 ) then
for _ , o in pairs ( overlays ) do hideOverlay ( o ) end
return
end
local camera = _v8b8ca6137d87 . CurrentCamera
if not camera then return end
local seen = { }
for _ , player in ipairs ( _vcd60f2e5219a : GetPlayers ( ) ) do
if player ~= _vad430fdb5ce8 then
seen [ player ] = true
local selected = _v94b7adb6cdb9 . dot and _vfc22e7e5f23c [ player ] == true
local o = overlays [ player ]
if ( _v94b7adb6cdb9 . esp . enabled or selected ) and not o then
o = createOverlay ( ) ; overlays [ player ] = o
end
if o then hideOverlay ( o ) end
if not o or ( not _v94b7adb6cdb9 . esp . enabled and not selected ) then continue end
local record = Records [ player ]
local folder = _vad430fdb5ce8 . Character and _vad430fdb5ce8 . Character . Parent
local character = selected and record and record . model
or player . Character or ( folder and folder : FindFirstChild ( player . Name ) )
local root = character and character : FindFirstChild ( "\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116" )
local hum = character and character : FindFirstChildOfClass ( "\072\117\109\097\110\111\105\100" )
if root and hum then
local studs = ( root . Position - camera . CFrame . Position ) . Magnitude
if selected or studs <= ranges [ _v94b7adb6cdb9 . esp . rangeIndex ] then
local top , topOn = camera : WorldToViewportPoint ( root . Position + Vector3 . new ( 0 , 3.4 , 0 ) )
local bottom , bottomOn = camera : WorldToViewportPoint ( root . Position - Vector3 . new ( 0 , 3.2 , 0 ) )
if topOn and bottomOn and top . Z > 0 and bottom . Z > 0 then
local height = math . abs ( bottom . Y - top . Y )
local width = height * 0.55
local centerX = ( top . X + bottom . X ) * 0.5
local color = selected and C_ACCENT or colors [ _v94b7adb6cdb9 . esp . colorIndex ]
o . box . Color , o . name . Color , o . distance . Color = color , color , color
o . box . Thickness = selected and 2.5 or 1.5
o . box . Position = Vector2 . new ( centerX - width * 0.5 , top . Y )
o . box . Size = Vector2 . new ( width , height )
o . box . Visible = selected or _v94b7adb6cdb9 . esp . boxes
o . name . Text = selected and ( "◆  " .. player . DisplayName .. "  ◆" )
or player . DisplayName
o . name . Position = Vector2 . new ( centerX , top . Y - 18 )
o . name . Visible = not selected and _v94b7adb6cdb9 . esp . enabled and _v94b7adb6cdb9 . esp . names
o . distance . Text = selected and string . format (
"\037\046\048\102\032\072\080\032\032\124\032\032\037\046\048\102\032\115\116\117\100\115" , hum . Health , studs )
or string . format ( "\037\046\048\102\032\115\116\117\100\115" , studs )
o . distance . Position = Vector2 . new ( centerX , bottom . Y + 3 )
o . distance . Visible = not selected and _v94b7adb6cdb9 . esp . enabled and _v94b7adb6cdb9 . esp . distance
local effects = character : FindFirstChild ( "\066\111\100\121\069\102\102\101\099\116\115" )
local armor = effects and effects : FindFirstChild ( "\065\114\109\111\114" )
local ko = effects and effects : FindFirstChild ( "\075\046\079" )
local dead = effects and effects : FindFirstChild ( "\068\101\097\100" )
local status = dead and dead . Value and "\068\069\065\068"
or ( ko and ko . Value or hum . Health <= 0.5 ) and "\068\079\087\078" or "\085\080"
local weapon = character : FindFirstChildOfClass ( "\084\111\111\108" )
local weaponText = weapon and weapon . Name : gsub ( "\091\037\091\037\093\093" , "" ) or "\085\078\065\082\077\069\068"
local ammo = weapon and weapon : GetAttribute ( "\082\101\097\108\065\109\109\111" )
if type ( ammo ) ~= "\110\117\109\098\101\114" then
ammo = weapon and weapon : GetAttribute ( "\065\109\109\111" )
end
if type ( ammo ) == "\110\117\109\098\101\114" then
weaponText = weaponText .. "\032" .. math . floor ( ammo )
end
o . combat . Text = string . format ( "\072\080\032\037\046\048\102\032\032\065\082\032\037\046\048\102\032\032\037\115\032\032\037\115" ,
hum . Health , armor and armor . Value or 0 , status , weaponText )
o . combat . Color = status == "\085\080" and color or Color3 . fromRGB ( 255 , 105 , 105 )
o . combat . Position = Vector2 . new ( centerX ,
bottom . Y + ( ( selected or not _v94b7adb6cdb9 . esp . distance ) and 3 or 18 ) )
o . combat . Visible = selected or _v94b7adb6cdb9 . esp . enabled
if selected then
o . tracer . From = Vector2 . new ( camera . ViewportSize . X * 0.5 ,
camera . ViewportSize . Y - 12 )
o . tracer . To = Vector2 . new ( centerX , bottom . Y )
o . tracer . Color = color
o . tracer . Visible = true
end
local bones = character : FindFirstChild ( "\085\112\112\101\114\084\111\114\115\111" ) and r15 or r6
if _v94b7adb6cdb9 . esp . enabled and _v94b7adb6cdb9 . esp . skeleton and not selected then
for i , pair in ipairs ( bones ) do
local a = character : FindFirstChild ( pair [ 1 ] )
local b = character : FindFirstChild ( pair [ 2 ] )
if a and b then
local pa , va = camera : WorldToViewportPoint ( a . Position )
local pb , vb = camera : WorldToViewportPoint ( b . Position )
local line = o . lines [ i ]
line . From = Vector2 . new ( pa . X , pa . Y )
line . To = Vector2 . new ( pb . X , pb . Y )
line . Color = color
line . Visible = va and vb and pa . Z > 0 and pb . Z > 0
end
end
end
end
end
end
end
end
for player , o in pairs ( overlays ) do
if not seen [ player ] then clearOverlay ( o ) ; overlays [ player ] = nil end
end
end
bind ( _v286a8fc93150 . RenderStepped : Connect ( renderEsp ) )
_ve76b6087628a . cleanupEsp = function ( )
for player , o in pairs ( overlays ) do clearOverlay ( o ) ; overlays [ player ] = nil end
end
bind ( _ve76b6087628a . EspMain . MouseButton1Click : Connect ( function ( )
_v94b7adb6cdb9 . esp . enabled = not _v94b7adb6cdb9 . esp . enabled
style ( _ve76b6087628a . EspMain , _v94b7adb6cdb9 . esp . enabled , "\069\083\080\058\032\079\078" , "\069\083\080\058\032\079\070\070" )
if not _v94b7adb6cdb9 . esp . enabled then
for _ , o in pairs ( overlays ) do hideOverlay ( o ) end
end
end ) )
local toggles = { { "\098\111\120\101\115" , _ve76b6087628a . EspBoxes , "\066\079\088\069\083" } ,
{ "\115\107\101\108\101\116\111\110" , _ve76b6087628a . EspSkeleton , "\083\075\069\076\069\084\079\078" } ,
{ "\110\097\109\101\115" , _ve76b6087628a . EspNames , "\078\065\077\069\083" } ,
{ "\100\105\115\116\097\110\099\101" , _ve76b6087628a . EspDistance , "\068\073\083\084\065\078\067\069" } }
for _ , item in ipairs ( toggles ) do
bind ( item [ 2 ] . MouseButton1Click : Connect ( function ( )
_v94b7adb6cdb9 . esp [ item [ 1 ] ] = not _v94b7adb6cdb9 . esp [ item [ 1 ] ]
style ( item [ 2 ] , _v94b7adb6cdb9 . esp [ item [ 1 ] ] , item [ 3 ] .. "\058\032\079\078" , item [ 3 ] .. "\058\032\079\070\070" )
end ) )
end
bind ( _ve76b6087628a . EspRange . MouseButton1Click : Connect ( function ( )
_v94b7adb6cdb9 . esp . rangeIndex = _v94b7adb6cdb9 . esp . rangeIndex % # ranges + 1
_ve76b6087628a . EspRange . Text = "\082\065\078\071\069\058\032" ..
( ranges [ _v94b7adb6cdb9 . esp . rangeIndex ] == math . huge and "\065\076\076" or tostring ( ranges [ _v94b7adb6cdb9 . esp . rangeIndex ] ) )
end ) )
bind ( _ve76b6087628a . EspColor . MouseButton1Click : Connect ( function ( )
_v94b7adb6cdb9 . esp . colorIndex = _v94b7adb6cdb9 . esp . colorIndex % # colors + 1
_ve76b6087628a . EspColor . Text = "\067\079\076\079\082\058\032" .. colorNames [ _v94b7adb6cdb9 . esp . colorIndex ]
end ) )
end
local function updateOwnRoot ( )
local c = _vad430fdb5ce8 . Character
_v3de27fce3ddc = c and c : FindFirstChild ( "\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116" , true ) or nil
end
local function refreshArmorShops ( )
table . clear ( ArmorShops )
local store = _v8b8ca6137d87 : FindFirstChild ( "\083\116\111\114\101" )
if not store then return end
for _ , model in ipairs ( store : GetChildren ( ) ) do
if model . Name == "\091\065\114\109\111\114\093" and model : IsA ( "\077\111\100\101\108" ) then
local head = model : FindFirstChild ( "\072\101\097\100" )
local click = model : FindFirstChildOfClass ( "\067\108\105\099\107\068\101\116\101\099\116\111\114" )
if head and head : IsA ( "\066\097\115\101\080\097\114\116" ) and click then
ArmorShops [ # ArmorShops + 1 ] = { model = model , head = head , click = click }
end
end
end
end
local function closestArmorShop ( root , excluded )
if # ArmorShops == 0 then refreshArmorShops ( ) end
local function choose ( )
local best , distance = nil , math . huge
for _ , shop in ipairs ( ArmorShops ) do
if shop . model ~= excluded and shop . model . Parent
and shop . head . Parent and shop . click . Parent then
local d = ( shop . head . Position - root . Position ) . Magnitude
if d < distance then best , distance = shop , d end
end
end
return best
end
local best = choose ( )
if not best then refreshArmorShops ( ) ; best = choose ( ) end
return best
end
local function buyArmorAfterSpawn ( character )
local generation = _v94b7adb6cdb9 . armorGeneration
local root = character : WaitForChild ( "\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116" , 6 )
local hum = character : WaitForChild ( "\072\117\109\097\110\111\105\100" , 6 )
local effects = character : WaitForChild ( "\066\111\100\121\069\102\102\101\099\116\115" , 6 )
local armor = effects and effects : WaitForChild ( "\065\114\109\111\114" , 6 )
if not root or not hum or not armor or _v94b7adb6cdb9 . closed or not _v94b7adb6cdb9 . autoArmor
or generation ~= _v94b7adb6cdb9 . armorGeneration or _vad430fdb5ce8 . Character ~= character then return end
local readyUntil = os . clock ( ) + 6
while hum . Health <= 0 and os . clock ( ) < readyUntil and not _v94b7adb6cdb9 . closed
and _vad430fdb5ce8 . Character == character do task . wait ( 0.1 ) end
if _v94b7adb6cdb9 . closed or not _v94b7adb6cdb9 . autoArmor or generation ~= _v94b7adb6cdb9 . armorGeneration
or _vad430fdb5ce8 . Character ~= character or not root . Parent or hum . Health <= 0 then return end
if armor . Value >= 200 then say ( "\065\117\116\111\032\097\114\109\111\114\058\032\097\108\114\101\097\100\121\032\102\117\108\108\046" ) ; return end
if type ( fireclickdetector ) ~= "\102\117\110\099\116\105\111\110" then
say ( "\065\117\116\111\032\097\114\109\111\114\058\032\116\104\105\115\032\101\120\101\099\117\116\111\114\032\104\097\115\032\110\111\032\067\108\105\099\107\068\101\116\101\099\116\111\114\032\105\110\116\101\114\097\099\116\105\111\110\046" )
return
end
local shop = closestArmorShop ( root )
if not shop then say ( "\065\117\116\111\032\097\114\109\111\114\058\032\110\111\032\108\111\097\100\101\100\032\097\114\109\111\114\032\115\104\111\112\032\102\111\117\110\100\046" ) ; return end
local before = armor . Value
local original = character : GetPivot ( )
local clicked = false
for shopIndex = 1 , 2 do
if not shop or armor . Value > before then break end
local destination = CFrame . new ( shop . head . Position + Vector3 . new ( 0 , 2.8 , 0 ) )
for attempt = 1 , 3 do
if _vad430fdb5ce8 . Character ~= character or not root . Parent
or generation ~= _v94b7adb6cdb9 . armorGeneration or armor . Value > before then break end
pcall ( function ( ) character : PivotTo ( destination ) end )
task . wait ( attempt == 1 and 0.24 or 0.18 )
if _vad430fdb5ce8 . Character ~= character or not root . Parent
or generation ~= _v94b7adb6cdb9 . armorGeneration or armor . Value > before then break end
local ok = pcall ( fireclickdetector , shop . click , 0 , "\109\111\117\115\101\099\108\105\099\107" )
clicked = clicked or ok
local untilAt = os . clock ( ) + 0.35
while os . clock ( ) < untilAt and armor . Value <= before
and _vad430fdb5ce8 . Character == character and not _v94b7adb6cdb9 . closed do task . wait ( 0.04 ) end
end
if armor . Value <= before then shop = closestArmorShop ( root , shop . model ) end
end
if armor . Value <= before then task . wait ( 0.25 ) end
if _vad430fdb5ce8 . Character == character and root . Parent then
pcall ( function ( ) character : PivotTo ( original ) end )
end
if not _v94b7adb6cdb9 . closed and generation == _v94b7adb6cdb9 . armorGeneration then
if armor . Value > before then
say ( "\065\117\116\111\032\097\114\109\111\114\058\032\099\111\108\108\101\099\116\101\100\032\040" .. armor . Value .. "\032\097\114\109\111\114\041\046" )
elseif clicked then
say ( "\065\117\116\111\032\097\114\109\111\114\058\032\115\104\111\112\032\099\108\105\099\107\101\100\044\032\098\117\116\032\112\117\114\099\104\097\115\101\032\119\097\115\032\110\111\116\032\099\111\110\102\105\114\109\101\100\046" )
else
say ( "\065\117\116\111\032\097\114\109\111\114\058\032\115\104\111\112\032\099\108\105\099\107\032\102\097\105\108\101\100\046" )
end
end
end
local function selectedShop ( )
return ShopNames [ _v94b7adb6cdb9 . autoBuyIndex ]
end
local function refreshAutoBuyControls ( )
local name = selectedShop ( )
AutoBuyName . Text = name : gsub ( "\037\091" , "" ) : gsub ( "\037\093" , "" )
style ( AutoBuyToggle , _v94b7adb6cdb9 . autoBuys [ name ] == true , "\065\085\084\079\032\066\085\089\058\032\079\078" , "\065\085\084\079\032\066\085\089\058\032\079\070\070" )
local count = 0
for _ , item in ipairs ( ShopNames ) do
if _v94b7adb6cdb9 . autoBuys [ item ] then count = count + 1 end
end
AutoBuyCount . Text = count .. "\032\115\104\111\112\032\105\116\101\109\040\115\041\032\115\101\108\101\099\116\101\100\032\102\111\114\032\101\097\099\104\032\114\101\115\112\097\119\110\046"
end
local function hasShopItem ( character , name )
local backpack = _vad430fdb5ce8 : FindFirstChildOfClass ( "\066\097\099\107\112\097\099\107" )
if character : FindFirstChild ( name ) or ( backpack and backpack : FindFirstChild ( name ) ) then return true end
if name == "\091\083\117\114\103\101\111\110\032\077\097\115\107\093" then
local effects = character : FindFirstChild ( "\066\111\100\121\069\102\102\101\099\116\115" )
local mask = effects and effects : FindFirstChild ( "\077\097\115\107" )
return mask and mask . Value ~= ""
end
return false
end
local function closestShopByName ( name , root )
local store = _v8b8ca6137d87 : FindFirstChild ( "\083\116\111\114\101" )
if not store then return { } end
local choices = { }
for _ , model in ipairs ( store : GetChildren ( ) ) do
if model . Name == name and model : IsA ( "\077\111\100\101\108" ) then
local head = model : FindFirstChild ( "\072\101\097\100" )
local click = model : FindFirstChildOfClass ( "\067\108\105\099\107\068\101\116\101\099\116\111\114" )
if head and head : IsA ( "\066\097\115\101\080\097\114\116" ) and click then
choices [ # choices + 1 ] = { head = head , click = click ,
distance = ( head . Position - root . Position ) . Magnitude }
end
end
end
table . sort ( choices , function ( a , b ) return a . distance < b . distance end )
return choices
end
local function buyShopItem ( character , name )
if hasShopItem ( character , name ) then return true end
if type ( fireclickdetector ) ~= "\102\117\110\099\116\105\111\110" then return false end
local root = character : FindFirstChild ( "\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116" )
if not root or _vad430fdb5ce8 . Character ~= character then return false end
local shops = closestShopByName ( name , root )
if # shops == 0 then return false end
local original = character : GetPivot ( )
for shopIndex = 1 , math . min ( # shops , 3 ) do
local shop = shops [ shopIndex ]
local destination = CFrame . new ( shop . head . Position + Vector3 . new ( 0 , 2.8 , 0 ) )
for attempt = 1 , 2 do
if _v94b7adb6cdb9 . closed or _vad430fdb5ce8 . Character ~= character or not root . Parent
or hasShopItem ( character , name ) then break end
pcall ( function ( ) character : PivotTo ( destination ) end )
task . wait ( 0.15 )
if _v94b7adb6cdb9 . closed or _vad430fdb5ce8 . Character ~= character or not root . Parent
or hasShopItem ( character , name ) then break end
pcall ( fireclickdetector , shop . click , 0 , "\109\111\117\115\101\099\108\105\099\107" )
local untilAt = os . clock ( ) + 0.35
while os . clock ( ) < untilAt and not hasShopItem ( character , name )
and _vad430fdb5ce8 . Character == character and not _v94b7adb6cdb9 . closed do task . wait ( 0.04 ) end
end
if hasShopItem ( character , name ) then break end
end
if _vad430fdb5ce8 . Character == character and root . Parent then
pcall ( function ( ) character : PivotTo ( original ) end )
end
return hasShopItem ( character , name )
end
local ShopBusy = false
local function buyAutoItems ( character , onlyName )
while ShopBusy and not _v94b7adb6cdb9 . closed and _vad430fdb5ce8 . Character == character do task . wait ( 0.03 ) end
if _v94b7adb6cdb9 . closed or _vad430fdb5ce8 . Character ~= character then return end
ShopBusy = true
local ok , err = pcall ( function ( )
if not onlyName and _v94b7adb6cdb9 . autoArmor then buyArmorAfterSpawn ( character ) end
for _ , name in ipairs ( ShopNames ) do
if ( onlyName == name or ( not onlyName and _v94b7adb6cdb9 . autoBuys [ name ] ) )
and _vad430fdb5ce8 . Character == character and not _v94b7adb6cdb9 . closed then
local bought = buyShopItem ( character , name )
say ( ( bought and "\066\111\117\103\104\116\032" or "\067\111\117\108\100\032\110\111\116\032\099\111\110\102\105\114\109\032" ) .. name .. "\046" )
task . wait ( 0.02 )
end
end
end )
ShopBusy = false
if not ok and not _v94b7adb6cdb9 . closed then say ( "\065\117\116\111\032\098\117\121\032\102\097\105\108\101\100\058\032" .. tostring ( err ) ) end
end
local function captureDeathPosition ( character )
if not _v94b7adb6cdb9 . respawnAtDeath or _vad430fdb5ce8 . Character ~= character then return end
local root = character : FindFirstChild ( "\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116" )
if root and root : IsA ( "\066\097\115\101\080\097\114\116" ) then DeathPosition = root . CFrame end
end
local function restoreDeathPosition ( character )
local destination = DeathPosition
if not _v94b7adb6cdb9 . respawnAtDeath or not destination then return end
task . spawn ( function ( )
local root = character : WaitForChild ( "\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116" , 6 )
local hum = character : FindFirstChildOfClass ( "\072\117\109\097\110\111\105\100" )
if not root or _v94b7adb6cdb9 . closed or _vad430fdb5ce8 . Character ~= character then return end
for _ = 1 , 3 do
if _v94b7adb6cdb9 . closed or not _v94b7adb6cdb9 . respawnAtDeath or _vad430fdb5ce8 . Character ~= character
or ( hum and hum . Health <= 0 ) then return end
pcall ( function ( )
character : PivotTo ( destination )
root . AssemblyLinearVelocity = Vector3 . zero
root . AssemblyAngularVelocity = Vector3 . zero
end )
task . wait ( 0.15 )
end
if DeathPosition == destination then DeathPosition = nil end
end )
end
_ve76b6087628a . runSpawnSequence = function ( character )
local now = os . clock ( )
if _ve76b6087628a . spawnSequenceCharacter == character
and now - ( _ve76b6087628a . spawnSequenceAt or 0 ) < 1 then return end
_ve76b6087628a . spawnSequenceCharacter = character
_ve76b6087628a . spawnSequenceAt = now
task . spawn ( function ( )
if _v94b7adb6cdb9 . autoArmor or next ( _v94b7adb6cdb9 . autoBuys ) then buyAutoItems ( character ) end
restoreDeathPosition ( character )
end )
end
local function ownDangerReason ( character )
if not character or _vad430fdb5ce8 . Character ~= character then return nil end
local effects = character : FindFirstChild ( "\066\111\100\121\069\102\102\101\099\116\115" )
local ko = effects and effects : FindFirstChild ( "\075\046\079" )
local dead = effects and effects : FindFirstChild ( "\068\101\097\100" )
local grabbed = effects and effects : FindFirstChild ( "\071\114\097\098\098\101\100" )
local hum = character : FindFirstChildOfClass ( "\072\117\109\097\110\111\105\100" )
if ko and ko : IsA ( "\066\111\111\108\086\097\108\117\101" ) and ko . Value then return "\075\046\079" end
if dead and dead : IsA ( "\066\111\111\108\086\097\108\117\101" ) and dead . Value then return "\068\101\097\100" end
if grabbed and grabbed : IsA ( "\079\098\106\101\099\116\086\097\108\117\101" ) and grabbed . Value then return "\103\114\097\098\098\101\100" end
if hum and hum . Health <= ResetThresholds [ _v94b7adb6cdb9 . resetThresholdIndex ] then
return "\108\111\119\032\104\101\097\108\116\104"
end
return nil
end
local function resetBeforeStomp ( character , reason )
if not reason or _v94b7adb6cdb9 . closed or not _v94b7adb6cdb9 . antiStomp or _v94b7adb6cdb9 . resetInFlight
or not _v94b7adb6cdb9 . antiStompReady
or _vad430fdb5ce8 . Character ~= character or _v94b7adb6cdb9 . antiStompTriggeredCharacter == character
or os . clock ( ) < _v94b7adb6cdb9 . antiStompSpawnGraceUntil then return end
local hum = character : FindFirstChildOfClass ( "\072\117\109\097\110\111\105\100" )
if not hum then return end
local storage = _v7ab6349c26e8 : FindFirstChild ( "\083\116\111\114\097\103\101" )
local remotes = storage and storage : FindFirstChild ( "\082\101\109\111\116\101\115" )
local main = remotes and remotes : FindFirstChild ( "\077\097\105\110" )
if not main or not main : IsA ( "\082\101\109\111\116\101\069\118\101\110\116" ) then return end
_v94b7adb6cdb9 . resetGeneration = _v94b7adb6cdb9 . resetGeneration + 1
local generation = _v94b7adb6cdb9 . resetGeneration
_v94b7adb6cdb9 . resetCharacter = character
_v94b7adb6cdb9 . antiStompTriggeredCharacter = character
_v94b7adb6cdb9 . resetInFlight = true
_v94b7adb6cdb9 . antiStompReady = false
_v94b7adb6cdb9 . lastResetAt = os . clock ( )
_v94b7adb6cdb9 . autoKill = false
_v94b7adb6cdb9 . autoKillGeneration = _v94b7adb6cdb9 . autoKillGeneration + 1
style ( AutoKillBtn , false , "\065\085\084\079\032\075\073\076\076\032\083\069\076\069\067\084\069\068\058\032\079\078" , "\065\085\084\079\032\075\073\076\076\032\083\069\076\069\067\084\069\068\058\032\079\070\070" )
captureDeathPosition ( character )
_ve76b6087628a . Notify . emit ( "\097\110\116\105\083\116\111\109\112" , "\065\110\116\105\045\083\116\111\109\112\032\114\101\115\101\116\032\114\101\113\117\101\115\116\101\100\032\040" .. reason .. "\041" )
local ok = pcall ( function ( ) main : FireServer ( "\082\101\115\101\116\078\101\119" ) end )
if not ok then
_v94b7adb6cdb9 . resetInFlight = false
_v94b7adb6cdb9 . resetCharacter = nil
say ( "\065\110\116\105\032\115\116\111\109\112\058\032\114\101\115\101\116\032\114\101\113\117\101\115\116\032\102\097\105\108\101\100\059\032\114\101\045\101\110\097\098\108\101\032\116\111\032\114\101\116\114\121\046" )
return
end
say ( "\065\110\116\105\032\115\116\111\109\112\058\032\097\119\097\105\116\105\110\103\032\110\101\119\032\099\104\097\114\097\099\116\101\114\059\032\114\101\116\114\105\101\115\032\101\118\101\114\121\032\048\046\053\032\115\101\099\111\110\100\115\046" )
task . spawn ( function ( )
local attempts = 1
while not _v94b7adb6cdb9 . closed and _v94b7adb6cdb9 . antiStomp and _v94b7adb6cdb9 . resetGeneration == generation
and _v94b7adb6cdb9 . resetCharacter == character and _vad430fdb5ce8 . Character == character do
task . wait ( 0.5 )
if _v94b7adb6cdb9 . closed or not _v94b7adb6cdb9 . antiStomp or _v94b7adb6cdb9 . resetGeneration ~= generation
or _v94b7adb6cdb9 . resetCharacter ~= character or _vad430fdb5ce8 . Character ~= character
or not character . Parent then break end
local currentHum = character : FindFirstChildOfClass ( "\072\117\109\097\110\111\105\100" )
if not currentHum then break end
if not ownDangerReason ( character ) and currentHum . Health > 0 then
_v94b7adb6cdb9 . resetInFlight = false
_v94b7adb6cdb9 . resetCharacter = nil
_v94b7adb6cdb9 . antiStompReady = true
say ( "\065\110\116\105\032\115\116\111\109\112\058\032\114\101\099\111\118\101\114\121\032\100\101\116\101\099\116\101\100\059\032\115\116\111\112\112\101\100\032\114\101\115\101\116\032\114\101\113\117\101\115\116\115\046" )
_ve76b6087628a . Notify . emit ( "\097\110\116\105\083\116\111\109\112" , "\065\110\116\105\045\083\116\111\109\112\032\115\116\111\112\112\101\100\058\032\114\101\099\111\118\101\114\101\100" )
return
end
attempts = attempts + 1
_v94b7adb6cdb9 . lastResetAt = os . clock ( )
pcall ( function ( ) main : FireServer ( "\082\101\115\101\116\078\101\119" ) end )
if attempts == 3 or attempts % 6 == 0 then
say ( "\065\110\116\105\032\115\116\111\109\112\058\032\119\097\105\116\105\110\103\032\102\111\114\032\099\104\097\114\097\099\116\101\114\032\114\101\102\114\101\115\104\032\040\097\116\116\101\109\112\116\032" .. attempts .. "\041\046" )
end
end
if _v94b7adb6cdb9 . resetGeneration == generation and _v94b7adb6cdb9 . resetCharacter == character then
_v94b7adb6cdb9 . resetCharacter = nil
_v94b7adb6cdb9 . resetInFlight = false
end
end )
end
local OwnCharacterGeneration = 0
_ve76b6087628a . ensureMacro = function ( character )
if not _v94b7adb6cdb9 . macroLock or _v94b7adb6cdb9 . closed or _vad430fdb5ce8 . Character ~= character then return end
local enabled = _ve76b6087628a . macroEnabled
if not enabled or not enabled . Parent then return end
local battle = _v7ab6349c26e8 : FindFirstChild ( "\083\116\111\114\097\103\101" )
battle = battle and battle : FindFirstChild ( "\071\097\109\101\086\097\108\117\101\115" )
battle = battle and battle : FindFirstChild ( "\066\097\116\116\108\101\082\111\121\097\108\101" )
if _vad430fdb5ce8 : GetAttribute ( "\068\117\101\108\078\111\077\097\099\114\111" ) or ( battle and battle . Value ) then return end
if not enabled . Value then pcall ( function ( ) enabled . Value = true end ) end
end
local function watchOwnCharacter ( character )
disconnectMany ( _va6ba7af26ac1 )
_ve76b6087628a . macroEnabled = nil
_va6ba7af26ac1 [ # _va6ba7af26ac1 + 1 ] =
character . ChildAdded : Connect ( _vf7c4bc36ea3b . observeGun )
for _ , tool in ipairs ( character : GetChildren ( ) ) do _vf7c4bc36ea3b . observeGun ( tool ) end
task . spawn ( function ( )
local scripts = character : WaitForChild ( "\083\099\114\105\112\116\115" , 12 )
local input = scripts and scripts : WaitForChild ( "\073\110\112\117\116" , 12 )
local macro = input and ( input : FindFirstChild ( "\082\101\097\108\077\097\099\114\111\073\110\112\117\116" )
or input : FindFirstChild ( "\077\097\099\114\111\073\110\112\117\116" )
or input : WaitForChild ( "\082\101\097\108\077\097\099\114\111\073\110\112\117\116" , 3 ) )
local enabled = macro and ( macro : FindFirstChild ( "\069\110\097\098\108\101\100" )
or macro : WaitForChild ( "\069\110\097\098\108\101\100" , 3 ) )
if enabled and enabled : IsA ( "\066\111\111\108\086\097\108\117\101" ) and not _v94b7adb6cdb9 . closed
and _vad430fdb5ce8 . Character == character then
_ve76b6087628a . macroEnabled = enabled
_va6ba7af26ac1 [ # _va6ba7af26ac1 + 1 ] =
enabled : GetPropertyChangedSignal ( "\086\097\108\117\101" ) : Connect ( function ( )
if _v94b7adb6cdb9 . macroLock and not enabled . Value then
task . delay ( 0.08 , function ( )
_ve76b6087628a . ensureMacro ( character )
end )
end
end )
_ve76b6087628a . ensureMacro ( character )
end
local aiming = input and input : WaitForChild ( "\065\105\109\105\110\103\073\110\112\117\116" , 12 )
if aiming and not _v94b7adb6cdb9 . closed and _vad430fdb5ce8 . Character == character then
_ve76b6087628a . applyGunMods ( character )
end
end )
OwnCharacterGeneration = OwnCharacterGeneration + 1
local generation = OwnCharacterGeneration
if _ve76b6087628a . lastAntiStompModel ~= character then
local previousModel = _ve76b6087628a . lastAntiStompModel
local hadPendingReset = _v94b7adb6cdb9 . resetInFlight
_ve76b6087628a . lastAntiStompModel = character
_v94b7adb6cdb9 . resetGeneration = _v94b7adb6cdb9 . resetGeneration + 1
_v94b7adb6cdb9 . resetCharacter = nil
_v94b7adb6cdb9 . resetInFlight = false
_v94b7adb6cdb9 . antiStompTriggeredCharacter = nil
_v94b7adb6cdb9 . lastResetAt = 0
_v94b7adb6cdb9 . antiStompSpawnGraceUntil = os . clock ( ) + ( previousModel and 1.5 or 0 )
if hadPendingReset then
_ve76b6087628a . Notify . emit ( "\097\110\116\105\083\116\111\109\112" , "\065\110\116\105\045\083\116\111\109\112\032\115\116\111\112\112\101\100\058\032\110\101\119\032\099\104\097\114\097\099\116\101\114\032\108\111\097\100\101\100" )
end
end
_v94b7adb6cdb9 . antiStompReady = false
task . spawn ( function ( )
local hum = character : WaitForChild ( "\072\117\109\097\110\111\105\100" , 6 )
if _v94b7adb6cdb9 . closed or _vad430fdb5ce8 . Character ~= character or generation ~= OwnCharacterGeneration then return end
local function evaluate ( )
if not hum or _v94b7adb6cdb9 . resetInFlight then return end
if not _v94b7adb6cdb9 . antiStompReady then
if os . clock ( ) < _v94b7adb6cdb9 . antiStompSpawnGraceUntil then return end
if _ve76b6087628a . antiStompInitialModel ~= character and
( hum . Health <= ResetThresholds [ _v94b7adb6cdb9 . resetThresholdIndex ] + 5
or ownDangerReason ( character ) ) then return end
_v94b7adb6cdb9 . antiStompReady = true
end
resetBeforeStomp ( character , ownDangerReason ( character ) )
end
if hum then
_va6ba7af26ac1 [ # _va6ba7af26ac1 + 1 ] = hum . HealthChanged : Connect ( function ( health )
if health <= 0 then captureDeathPosition ( character ) end
evaluate ( )
end )
_va6ba7af26ac1 [ # _va6ba7af26ac1 + 1 ] = hum . Died : Connect ( function ( )
captureDeathPosition ( character )
evaluate ( )
end )
_va6ba7af26ac1 [ # _va6ba7af26ac1 + 1 ] = hum . StateChanged : Connect ( function ( _ , state )
if state == Enum . HumanoidStateType . Dead then evaluate ( ) end
end )
end
local effects = character : FindFirstChild ( "\066\111\100\121\069\102\102\101\099\116\115" )
or character : WaitForChild ( "\066\111\100\121\069\102\102\101\099\116\115" , 6 )
if _v94b7adb6cdb9 . closed or _vad430fdb5ce8 . Character ~= character or generation ~= OwnCharacterGeneration then return end
if effects then
local watched = { }
local function watchFlag ( value )
if watched [ value ] then return end
local statusFlag = ( value . Name == "\075\046\079" or value . Name == "\068\101\097\100" )
and value : IsA ( "\066\111\111\108\086\097\108\117\101" )
local dangerValue = value . Name == "\071\114\097\098\098\101\100" and value : IsA ( "\079\098\106\101\099\116\086\097\108\117\101" )
if not statusFlag and not dangerValue then return end
watched [ value ] = true
_va6ba7af26ac1 [ # _va6ba7af26ac1 + 1 ] = value . Changed : Connect ( evaluate )
evaluate ( )
end
for _ , value in ipairs ( effects : GetChildren ( ) ) do watchFlag ( value ) end
_va6ba7af26ac1 [ # _va6ba7af26ac1 + 1 ] = effects . ChildAdded : Connect ( watchFlag )
end
evaluate ( )
task . delay ( 1.55 , function ( )
if not _v94b7adb6cdb9 . closed and _vad430fdb5ce8 . Character == character
and generation == OwnCharacterGeneration then evaluate ( ) end
end )
end )
end
bind ( _ve76b6087628a . MacroBtn . MouseButton1Click : Connect ( function ( )
_v94b7adb6cdb9 . macroLock = not _v94b7adb6cdb9 . macroLock
style ( _ve76b6087628a . MacroBtn , _v94b7adb6cdb9 . macroLock ,
"\077\065\067\082\079\032\080\069\082\083\073\083\084\058\032\079\078" , "\077\065\067\082\079\032\080\069\082\083\073\083\084\058\032\079\070\070" )
if _v94b7adb6cdb9 . macroLock then _ve76b6087628a . ensureMacro ( _vad430fdb5ce8 . Character ) end
say ( _v94b7adb6cdb9 . macroLock and "\077\097\099\114\111\032\112\101\114\115\105\115\116\032\101\110\097\098\108\101\100\046" or "\077\097\099\114\111\032\112\101\114\115\105\115\116\032\100\105\115\097\098\108\101\100\046" )
end ) )
local function downedPlayerBelow ( character )
local lower = character : FindFirstChild ( "\076\111\119\101\114\084\111\114\115\111" )
local upper = character : FindFirstChild ( "\085\112\112\101\114\084\111\114\115\111" )
if not lower or not upper then return nil end
local ignored = { character }
local blacklisted = _v8b8ca6137d87 : FindFirstChild ( "\066\108\097\099\107\108\105\115\116\101\100" )
if blacklisted then ignored [ # ignored + 1 ] = blacklisted end
local ray = Ray . new ( lower . Position , Vector3 . new ( 0 , - upper . Size . Y * 4.5 , 0 ) )
local hit = _v8b8ca6137d87 : FindPartOnRayWithIgnoreList ( ray , ignored )
local node = hit
while node and node ~= _v8b8ca6137d87 do
if node : IsA ( "\077\111\100\101\108" ) and node ~= character then
local victimPlayer = _vcd60f2e5219a : FindFirstChild ( node . Name )
local hum = node : FindFirstChildOfClass ( "\072\117\109\097\110\111\105\100" )
local effects = node : FindFirstChild ( "\066\111\100\121\069\102\102\101\099\116\115" )
local ko = effects and effects : FindFirstChild ( "\075\046\079" )
local dead = effects and effects : FindFirstChild ( "\068\101\097\100" )
local knocked = ko and ko : IsA ( "\066\111\111\108\086\097\108\117\101" ) and ko . Value
local finished = dead and dead : IsA ( "\066\111\111\108\086\097\108\117\101" ) and dead . Value
if victimPlayer and victimPlayer ~= _vad430fdb5ce8 and hum
and ( knocked or finished or hum . Health <= 0 ) then
return node
end
end
node = node . Parent
end
return nil
end
local function autoStompTick ( expectedModel , allowSelected )
if os . clock ( ) < NextAutoStompAt then return end
local character = _vad430fdb5ce8 . Character
if not character or not character : FindFirstChild ( "\070\085\076\076\089\095\076\079\065\068\069\068\095\067\072\065\082" )
or character : FindFirstChildOfClass ( "\070\111\114\099\101\070\105\101\108\100" )
or character : FindFirstChild ( "\071\082\065\066\066\073\078\071\095\067\079\078\083\084\082\065\073\078\084" ) then return end
local effects = character : FindFirstChild ( "\066\111\100\121\069\102\102\101\099\116\115" )
local ownKO = effects and effects : FindFirstChild ( "\075\046\079" )
local grabbed = effects and effects : FindFirstChild ( "\071\114\097\098\098\101\100" )
local firing = effects and effects : FindFirstChild ( "\071\117\110\070\105\114\105\110\103" )
local backpack = _vad430fdb5ce8 : FindFirstChildOfClass ( "\066\097\099\107\112\097\099\107" )
if not effects or ( ownKO and ownKO . Value )
or ( grabbed and grabbed . Value ~= nil )
or ( firing and firing . Value )
or ( backpack and backpack : FindFirstChild ( "\070\108\121" ) ) then return end
local victim = expectedModel or downedPlayerBelow ( character )
if not victim then return end
local lower = character : FindFirstChild ( "\076\111\119\101\114\084\111\114\115\111" )
local victimLower = victim : FindFirstChild ( "\076\111\119\101\114\084\111\114\115\111" )
local victimHumanoid = victim : FindFirstChildOfClass ( "\072\117\109\097\110\111\105\100" )
if not lower or not victimLower or not victimHumanoid
or ( victimLower . Position - lower . Position ) . Magnitude > 8 then return end
local storage = _v7ab6349c26e8 : FindFirstChild ( "\083\116\111\114\097\103\101" )
local remotes = storage and storage : FindFirstChild ( "\082\101\109\111\116\101\115" )
local main = remotes and remotes : FindFirstChild ( "\077\097\105\110" )
local animations = storage and storage : FindFirstChild ( "\065\110\105\109\097\116\105\111\110\115" )
local stompAnimation = animations and animations : FindFirstChild ( "\083\116\111\109\112" )
local handler = game : GetService ( "\082\101\112\108\105\099\097\116\101\100\070\105\114\115\116" ) : FindFirstChild ( "\072\097\110\100\108\101\114" )
local infoModule = handler and handler : FindFirstChild ( "\073\110\102\111" )
local humanoid = character : FindFirstChildOfClass ( "\072\117\109\097\110\111\105\100" )
local animator = humanoid and humanoid : FindFirstChildOfClass ( "\065\110\105\109\097\116\111\114" )
if not main or not main : IsA ( "\082\101\109\111\116\101\069\118\101\110\116" ) or not stompAnimation
or not infoModule or not animator then return end
if AutoStompTrackCharacter ~= character or not AutoStompTrack then
AutoStompTrackCharacter = character
AutoStompTrack = animator : LoadAnimation ( stompAnimation )
end
local proof = require ( infoModule ) : CheckCredibility ( )
if proof ~= true then return end
if _v94b7adb6cdb9 . stompAnimationEnabled then
AutoStompTrack : Play ( 0 , 1 , 5 )
else
AutoStompTrack : Stop ( 0 )
end
local victimEffects = victim : FindFirstChild ( "\066\111\100\121\069\102\102\101\099\116\115" )
local victimKO = victimEffects and victimEffects : FindFirstChild ( "\075\046\079" )
local victimDead = victimEffects and victimEffects : FindFirstChild ( "\068\101\097\100" )
local stillStompable = ( victimKO and victimKO . Value )
or ( victimDead and victimDead . Value ) or victimHumanoid . Health <= 0
if _v94b7adb6cdb9 . closed or not ( _v94b7adb6cdb9 . autoStomp or allowSelected ) or _vad430fdb5ce8 . Character ~= character
or not victimHumanoid . Parent or not stillStompable then return end
main : FireServer ( "\083\116\111\109\112\082\101\109\111\116\101" , AutoStompTrack , effects , victimHumanoid , proof )
NextAutoStompAt = os . clock ( ) + _v94b7adb6cdb9 . stompPace * 0.75
return true
end
local function updateAutoStomp ( )
_v1a80223b8c3b = _v1a80223b8c3b + 1
local generation = _v1a80223b8c3b
if not _v94b7adb6cdb9 . autoStomp then return end
NextAutoStompAt = 0
task . spawn ( function ( )
while not _v94b7adb6cdb9 . closed and _v94b7adb6cdb9 . autoStomp and generation == _v1a80223b8c3b do
local ok = pcall ( autoStompTick )
if not ok then
_v94b7adb6cdb9 . autoStomp = false
style ( AutoStompBtn , false , "\065\085\084\079\032\083\084\079\077\080\058\032\079\078" , "\065\085\084\079\032\083\084\079\077\080\058\032\079\070\070" )
say ( "\065\117\116\111\032\115\116\111\109\112\032\115\116\111\112\112\101\100\032\097\102\116\101\114\032\097\032\114\097\121\099\097\115\116\032\111\114\032\114\101\109\111\116\101\032\101\114\114\111\114\046" )
break
end
task . wait ( math . min ( 0.05 , _v94b7adb6cdb9 . stompPace * 0.75 ) )
end
end )
end
refreshArmorShops ( )
updateOwnRoot ( )
bind ( _vad430fdb5ce8 . CharacterAdded : Connect ( function ( character )
if _ve76b6087628a . Notify . previousOwnCharacter and
_ve76b6087628a . Notify . previousOwnCharacter ~= character then
_ve76b6087628a . Notify . emit ( "\111\119\110\082\101\115\112\097\119\110" , "\089\111\117\032\114\101\115\112\097\119\110\101\100" )
end
_ve76b6087628a . Notify . previousOwnCharacter = character
task . delay ( 0.25 , function ( ) if not _v94b7adb6cdb9 . closed then updateOwnRoot ( ) end end )
watchOwnCharacter ( character )
_ve76b6087628a . runSpawnSequence ( character )
end ) )
bind ( _vad430fdb5ce8 . CharacterRemoving : Connect ( function ( character )
if _v94b7adb6cdb9 . resetCharacter == character then
_v94b7adb6cdb9 . resetGeneration = _v94b7adb6cdb9 . resetGeneration + 1
_v94b7adb6cdb9 . resetCharacter = nil
_v94b7adb6cdb9 . resetInFlight = false
end
local hum = character : FindFirstChildOfClass ( "\072\117\109\097\110\111\105\100" )
if hum and hum . Health <= 0 then captureDeathPosition ( character ) end
_v3de27fce3ddc = nil
OwnCharacterGeneration = OwnCharacterGeneration + 1
disconnectMany ( _va6ba7af26ac1 )
end ) )
if _vad430fdb5ce8 . Character then
_ve76b6087628a . Notify . previousOwnCharacter = _vad430fdb5ce8 . Character
_ve76b6087628a . antiStompInitialModel = _vad430fdb5ce8 . Character
watchOwnCharacter ( _vad430fdb5ce8 . Character )
end
_ve76b6087628a . SafeCharacter = nil
_ve76b6087628a . LastSafeCFrame = nil
_ve76b6087628a . NextVoidCheck = 0
bind ( _v286a8fc93150 . Heartbeat : Connect ( function ( )
if _v94b7adb6cdb9 . closed or not _v94b7adb6cdb9 . antiVoid or _v94b7adb6cdb9 . voidBlinking
or os . clock ( ) < _ve76b6087628a . NextVoidCheck then return end
_ve76b6087628a . NextVoidCheck = os . clock ( ) + 0.05
local character = _vad430fdb5ce8 . Character
if character ~= _ve76b6087628a . SafeCharacter then
_ve76b6087628a . SafeCharacter , _ve76b6087628a . LastSafeCFrame = character , nil
end
local root = character and character : FindFirstChild ( "\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116" )
local hum = character and character : FindFirstChildOfClass ( "\072\117\109\097\110\111\105\100" )
if not root or not hum or hum . Health <= 0 then return end
if root . Position . Y > - 35 then
_ve76b6087628a . LastSafeCFrame = root . CFrame
elseif root . Position . Y < - 45 then
pcall ( function ( )
character : PivotTo ( _ve76b6087628a . LastSafeCFrame
or CFrame . new ( root . Position . X , 12 , root . Position . Z ) )
root . AssemblyLinearVelocity = Vector3 . zero
root . AssemblyAngularVelocity = Vector3 . zero
end )
end
end ) )
local function validModel ( model )
if not model or not model : IsA ( "\077\111\100\101\108" ) or not model : IsDescendantOf ( _v8b8ca6137d87 ) then return nil end
local hum = model : FindFirstChildOfClass ( "\072\117\109\097\110\111\105\100" )
local root = model : FindFirstChild ( "\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116" , true )
if not hum or not root or not root : IsA ( "\066\097\115\101\080\097\114\116" ) then return nil end
return {
model = model , humanoid = hum , root = root ,
head = model : FindFirstChild ( "\072\101\097\100" , true ) ,
}
end
local function recordPresent ( p , rec )
return p and _vfc22e7e5f23c [ p ] and p . Parent == _vcd60f2e5219a and rec
and rec . model . Parent and rec . root . Parent and rec . humanoid . Parent
end
local function recordUsable ( p , rec )
return p and p . Parent == _vcd60f2e5219a and rec and rec . model . Parent
and rec . root . Parent and rec . humanoid . Parent
end
local function alive ( rec , requireAlive )
if not rec then return false end
if not requireAlive then return true end
if rec . humanoid . Parent == nil or rec . humanoid . Health <= 0 then return false end
local effects = rec . model : FindFirstChild ( "\066\111\100\121\069\102\102\101\099\116\115" )
local ko = effects and effects : FindFirstChild ( "\075\046\079" )
local dead = effects and effects : FindFirstChild ( "\068\101\097\100" )
return not ( ( ko and ko . Value ) or ( dead and dead . Value ) )
end
local function partFor ( rec )
if _v94b7adb6cdb9 . head and rec . head and rec . head . Parent and rec . head : IsA ( "\066\097\115\101\080\097\114\116" ) then return rec . head end
return rec . root
end
local function predictedPoint ( rec , part , lead )
return part . Position + rec . root . AssemblyLinearVelocity * lead
end
local function isFolder ( parent )
if not ( parent : IsA ( "\070\111\108\100\101\114" ) or parent : IsA ( "\077\111\100\101\108" ) ) then return false end
local name = parent . Name
return name == "\080\108\097\121\101\114\115" or name == "\067\104\097\114\097\099\116\101\114\115" or name == "\076\105\118\101"
or name == "\069\110\116\105\116\105\101\115" or ( # name >= 30 and name : find ( "\037\045" ) ~= nil )
end
local function candidateNamed ( parent , player )
if not parent or not player then return nil end
return parent : FindFirstChild ( player . Name )
or parent : FindFirstChild ( tostring ( player . UserId ) )
end
if type ( _v5680cea30ae2 . __SPECTRA_MULTI_RAYCAST ) == "\116\097\098\108\101" then
_v5680cea30ae2 . __SPECTRA_MULTI_RAYCAST . enabled = false
end
local _v1f40472bbaea : any = {
installed = false , enabled = false , part = nil , record = nil ,
lockPlayer = nil , lockRecord = nil ,
manager = nil , original = nil , wrapper = nil ,
damageOriginal = nil , damageWrapper = nil ,
lead = _v94b7adb6cdb9 . lead , aliveOnly = _v94b7adb6cdb9 . aliveOnly , wallBang = false ,
}
_v5680cea30ae2 . __SPECTRA_MULTI_RAYCAST = _v1f40472bbaea
_v1f40472bbaea . getMuzzle = function ( tool )
local handle = tool and tool : FindFirstChild ( "\072\097\110\100\108\101" )
if not handle or not handle : IsA ( "\066\097\115\101\080\097\114\116" ) then return nil end
local origin = handle . Position
local gui = handle : FindFirstChild ( "\083\104\111\111\116\070\088\071\117\105" )
if gui and gui : IsA ( "\066\105\108\108\098\111\097\114\100\071\117\105" ) then
origin = origin + handle . CFrame : VectorToWorldSpace ( gui . StudsOffsetWorldSpace )
end
return origin
end
_v1f40472bbaea . getBulletDirection = function ( )
local character = _vad430fdb5ce8 . Character
local root = character and character : FindFirstChild ( "\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116" )
local basis = root and root . CFrame or ( _v8b8ca6137d87 . CurrentCamera and _v8b8ca6137d87 . CurrentCamera . CFrame )
if not basis then return nil end
local angle
if _v94b7adb6cdb9 . bulletMode == 2 then
angle = ( _v94b7adb6cdb9 . bulletStep % 16 ) * ( 2 * math . pi / 16 )
_v94b7adb6cdb9 . bulletStep = _v94b7adb6cdb9 . bulletStep + 1
elseif _v94b7adb6cdb9 . bulletMode == 3 then
angle = math . random ( ) * 2 * math . pi
else
return nil
end
local radial = basis . LookVector * math . cos ( angle ) + basis . RightVector * math . sin ( angle )
radial = Vector3 . new ( radial . X , 0 , radial . Z )
return radial . Magnitude > 0.001 and radial . Unit or nil
end
_v1f40472bbaea . rayBoxDistance = function ( origin , direction , length , part , padding )
local localOrigin = part . CFrame : PointToObjectSpace ( origin )
local localDirection = part . CFrame : VectorToObjectSpace ( direction )
local half = part . Size * 0.5 + Vector3 . new ( padding or 0 , padding or 0 , padding or 0 )
local enter , leave = 0 , length
for axis = 1 , 3 do
local o , d , h
if axis == 1 then
o , d , h = localOrigin . X , localDirection . X , half . X
elseif axis == 2 then
o , d , h = localOrigin . Y , localDirection . Y , half . Y
else
o , d , h = localOrigin . Z , localDirection . Z , half . Z
end
if math . abs ( d ) < 0.000001 then
if o < - h or o > h then return nil end
else
local a , b = ( - h - o ) / d , ( h - o ) / d
if a > b then a , b = b , a end
enter , leave = math . max ( enter , a ) , math . min ( leave , b )
if enter > leave then return nil end
end
end
return enter
end
_v1f40472bbaea . resolveShotRecord = function ( p )
local rec = validModel ( p . Character ) or validModel ( candidateNamed ( _v8b8ca6137d87 , p ) )
if rec then return rec end
for folder in pairs ( Folders ) do
if folder . Parent == _v8b8ca6137d87 then
rec = validModel ( candidateNamed ( folder , p ) )
if rec then return rec end
end
end
return nil
end
_v1f40472bbaea . penetrationRaycast = function ( origin , point , maxRange , cameraAim )
if typeof ( origin ) ~= "\086\101\099\116\111\114\051" or typeof ( point ) ~= "\086\101\099\116\111\114\051" then
return nil , nil
end
local rayOrigin = cameraAim and _v8b8ca6137d87 . CurrentCamera
and _v8b8ca6137d87 . CurrentCamera . CFrame . Position or origin
local delta = point - rayOrigin
if delta . Magnitude <= 0.001 then return nil , nil end
local length = math . min ( maxRange + ( rayOrigin - origin ) . Magnitude , 15000 )
local direction = delta . Unit
local bestDistance , bestPart , bestPlayer = length + 1 , nil , nil
local selectedDistance , selectedPart , selectedPlayer = nil , nil , nil
for _ , p in ipairs ( _vcd60f2e5219a : GetPlayers ( ) ) do
if p ~= _vad430fdb5ce8 then
local rec = _v1f40472bbaea . resolveShotRecord ( p )
if rec and alive ( rec , _v94b7adb6cdb9 . aliveOnly ) then
local toRoot = rec . root . Position - rayOrigin
local along = toRoot : Dot ( direction )
if along >= - 8 and along <= length + 8 then
local separation = ( toRoot - direction * along ) . Magnitude
if separation < 8 then
for _ , body in ipairs ( rec . model : GetChildren ( ) ) do
if body : IsA ( "\066\097\115\101\080\097\114\116" ) and body ~= rec . root then
local padding = cameraAim and math . min ( 4 ,
math . max ( 0.35 , along * 0.03 ) ) or 0
local distance = _v1f40472bbaea . rayBoxDistance ( rayOrigin , direction ,
length , body , padding )
if distance and distance < bestDistance
and ( body . Position - origin ) . Magnitude <= maxRange + 4 then
bestDistance , bestPart , bestPlayer = distance , body , p
end
if p == _v94b7adb6cdb9 . primary and distance
and ( not selectedDistance or distance < selectedDistance )
and ( body . Position - origin ) . Magnitude <= maxRange + 4 then
selectedDistance , selectedPart , selectedPlayer = distance , body , p
end
end
end
end
end
end
end
end
if selectedPart then
bestDistance , bestPart , bestPlayer =
selectedDistance , selectedPart , selectedPlayer
end
if not bestPart then return nil , nil end
return {
Instance = bestPart ,
Position = bestPart . Position ,
Normal = - direction ,
Material = bestPart . Material ,
Distance = bestDistance ,
} , bestPlayer
end
_v1f40472bbaea . nextMultiShot = function ( )
local count = # _v71f22c1d3c92
if count == 0 then return nil , nil , nil end
for _ = 1 , count do
_v1f40472bbaea . multiCursor = ( ( _v1f40472bbaea . multiCursor or 0 ) % count ) + 1
local target = _v71f22c1d3c92 [ _v1f40472bbaea . multiCursor ]
local rec = Records [ target ]
if not recordPresent ( target , rec ) then
rec = _v1f40472bbaea . resolveShotRecord ( target )
if rec and _vfc22e7e5f23c [ target ] then Records [ target ] = rec end
end
if recordPresent ( target , rec ) and alive ( rec , _v94b7adb6cdb9 . aliveOnly ) then
local part = partFor ( rec )
if part and part . Parent then return target , rec , part end
end
end
return nil , nil , nil
end
local function installRaycastHook ( )
if _v1f40472bbaea . installed and _v1f40472bbaea . manager and _v1f40472bbaea . manager . Raycast == _v1f40472bbaea . wrapper then return true end
local storage = _v7ab6349c26e8 : FindFirstChild ( "\083\116\111\114\097\103\101" )
local modules = storage and storage : FindFirstChild ( "\077\111\100\117\108\101\115" )
local dialect = modules and modules : FindFirstChild ( "\068\105\097\108\101\099\116" )
local module = dialect and dialect : FindFirstChild ( "\071\117\110\077\097\110\097\103\101\114" )
if not module then return false , "\071\117\110\077\097\110\097\103\101\114\032\105\115\032\110\111\116\032\108\111\097\100\101\100\032\121\101\116\059\032\116\114\121\032\097\103\097\105\110\046" end
local ok , manager = pcall ( require , module )
if not ok or type ( manager ) ~= "\116\097\098\108\101" or type ( manager . Raycast ) ~= "\102\117\110\099\116\105\111\110" then
return false , "\067\111\117\108\100\032\110\111\116\032\097\099\099\101\115\115\032\116\104\105\115\032\103\097\109\101\039\115\032\103\117\110\032\114\097\121\099\097\115\116\046"
end
local original = manager . Raycast
local function redirect ( self , tool , mousePoint , player , range , ... )
if self == manager and player == _vad430fdb5ce8 and tool and tool : IsA ( "\084\111\111\108" )
and tool . Parent == _vad430fdb5ce8 . Character
and ( _v1f40472bbaea . enabled or _v94b7adb6cdb9 . autoKill or _v94b7adb6cdb9 . forceHit or _v94b7adb6cdb9 . wallBang
or _v94b7adb6cdb9 . silent or _v94b7adb6cdb9 . bulletMode ~= 1 ) then
local maxRange = typeof ( range ) == "\110\117\109\098\101\114" and math . clamp ( range , 1 , 15000 ) or 200
local origin = _v1f40472bbaea . getMuzzle ( tool )
local direct = _v94b7adb6cdb9 . autoKill or _v94b7adb6cdb9 . forceHit
if not direct and _v94b7adb6cdb9 . bulletMode ~= 1 and origin then
local radial = _v1f40472bbaea . getBulletDirection ( )
if radial then mousePoint = origin + radial * maxRange end
elseif direct or _v94b7adb6cdb9 . silent then
local lockedPlayer = _v94b7adb6cdb9 . autoKill and _v1f40472bbaea . lockPlayer or nil
local forcedPlayer = _v94b7adb6cdb9 . forceHit and _v94b7adb6cdb9 . primary or nil
local selectedPlayer = lockedPlayer or forcedPlayer or _v94b7adb6cdb9 . aimPlayer
local selectedRecord = lockedPlayer and _v1f40472bbaea . lockRecord
or forcedPlayer and Records [ forcedPlayer ] or _v1f40472bbaea . record
local part = ( lockedPlayer or forcedPlayer )
and selectedRecord and partFor ( selectedRecord ) or _v1f40472bbaea . part
if _v94b7adb6cdb9 . multi and not _v94b7adb6cdb9 . autoKill and ( _v94b7adb6cdb9 . silent or _v94b7adb6cdb9 . forceHit ) then
selectedPlayer , selectedRecord , part = _v1f40472bbaea . nextMultiShot ( )
end
if selectedRecord and part and part . Parent
and ( lockedPlayer and recordUsable ( selectedPlayer , selectedRecord )
or recordPresent ( selectedPlayer , selectedRecord ) )
and alive ( selectedRecord , _v1f40472bbaea . aliveOnly ) and origin then
local point = predictedPoint ( selectedRecord , part , _v1f40472bbaea . lead )
local directHit = _v94b7adb6cdb9 . forceHit or ( _v94b7adb6cdb9 . autoKill and _v94b7adb6cdb9 . standAttackTarget ~= nil )
or ( _v94b7adb6cdb9 . autoKill and _v94b7adb6cdb9 . quietAutoKill )
if directHit or ( point - origin ) . Magnitude <= maxRange then
mousePoint = point
if ( directHit or _v94b7adb6cdb9 . wallBang ) and selectedRecord . model
and part : IsDescendantOf ( selectedRecord . model ) then
local rayDir = point - origin
if rayDir . Magnitude > 0.01 then
return {
Instance = part , Position = point ,
Normal = - rayDir . Unit , Material = part . Material ,
}
end
end
end
end
end
if _v94b7adb6cdb9 . wallBang then
_v1f40472bbaea . wallShots = ( _v1f40472bbaea . wallShots or 0 ) + 1
local hit , victim
if origin then
hit , victim = _v1f40472bbaea . penetrationRaycast ( origin , mousePoint , maxRange ,
_v94b7adb6cdb9 . bulletMode == 1 and not direct )
end
if hit then
_ve76b6087628a . WallBangInfo . Text = "\087\066\032\067\076\073\069\078\084\032\072\073\084\058\032\064" .. victim . Name
.. "\032\040\115\101\114\118\101\114\032\100\097\109\097\103\101\032\110\111\116\032\103\117\097\114\097\110\116\101\101\100\041"
return hit
end
if os . clock ( ) - ( _v1f40472bbaea . lastWallStatus or 0 ) > 0.35 then
_v1f40472bbaea . lastWallStatus = os . clock ( )
_ve76b6087628a . WallBangInfo . Text = ( "\087\066\032\083\072\079\084\083\058\032\037\100\032\124\032\110\111\032\114\105\103\032\111\110\032\115\104\111\116\032\108\105\110\101" )
: format ( _v1f40472bbaea . wallShots )
end
end
end
return original ( self , tool , mousePoint , player , range , ... )
end
local assigned = pcall ( function ( ) manager . Raycast = redirect end )
if not assigned or manager . Raycast ~= redirect then
return false , "\067\111\117\108\100\032\110\111\116\032\105\110\115\116\097\108\108\032\116\104\101\032\103\117\110\045\115\112\101\099\105\102\105\099\032\097\105\109\032\112\097\116\104\046"
end
_v1f40472bbaea . manager , _v1f40472bbaea . original , _v1f40472bbaea . wrapper = manager , original , redirect
_v1f40472bbaea . installed = true
if type ( manager . ReconcileDamageBatch ) == "\102\117\110\099\116\105\111\110" then
local damageOriginal = manager . ReconcileDamageBatch
local function readServerHit ( self , predictions , response , ... )
if self == manager and type ( predictions ) == "\116\097\098\108\101" then
local first = predictions [ 1 ]
local state = first and first . State
if state and typeof ( response ) == "\116\097\098\108\101"
and typeof ( response . Health ) == "\110\117\109\098\101\114"
and typeof ( response . Revision ) == "\110\117\109\098\101\114"
and response . Revision >= ( state . Revision or - math . huge ) then
local oldHealth = state . ServerHealth or response . Health
local oldArmor = state . ServerArmor or response . Armor or 0
local newArmor = typeof ( response . Armor ) == "\110\117\109\098\101\114"
and response . Armor or oldArmor
local healthDamage = math . max ( 0 , oldHealth - response . Health )
local armorDamage = math . max ( 0 , oldArmor - newArmor )
if healthDamage + armorDamage > 0 then
_vf7c4bc36ea3b . noteConfirmed ( _v94b7adb6cdb9 . lastAttemptWeaponName )
end
if healthDamage + armorDamage > 0 and _v94b7adb6cdb9 . autoKill
and _v1f40472bbaea . lockRecord and state . Humanoid == _v1f40472bbaea . lockRecord . humanoid then
_v94b7adb6cdb9 . lastConfirmedHitAt = os . clock ( )
end
local victim = state . Humanoid and state . Humanoid . Parent
local name = victim and victim . Name or "\116\097\114\103\101\116"
_ve76b6087628a . ServerHit . Text = ( "\083\069\082\086\069\082\032\072\073\084\058\032\037\115\032\032\072\032\045\037\046\049\102\032\032\065\032\045\037\046\049\102" )
: format ( name , healthDamage , armorDamage )
_ve76b6087628a . ServerHit . TextColor3 = ( healthDamage + armorDamage > 0 )
and C_ACCENT or C_FAINT
end
end
return damageOriginal ( self , predictions , response , ... )
end
local assignedDamage = pcall ( function ( ) manager . ReconcileDamageBatch = readServerHit end )
if assignedDamage and manager . ReconcileDamageBatch == readServerHit then
_v1f40472bbaea . damageOriginal , _v1f40472bbaea . damageWrapper = damageOriginal , readServerHit
end
end
return true
end
task . defer ( function ( )
if not _v94b7adb6cdb9 . closed then installRaycastHook ( ) end
end )
local function clearTarget ( )
_v94b7adb6cdb9 . aimPlayer , _v94b7adb6cdb9 . aimRecord = nil , nil
_v94b7adb6cdb9 . screenDistance2 , _v94b7adb6cdb9 . permitted = math . huge , false
_v1f40472bbaea . part , _v1f40472bbaea . record = nil , nil
_v1f40472bbaea . enabled = false
if ActiveLabel . Text ~= "\065\105\109\032\116\097\114\103\101\116\058\032\110\111\110\101" then ActiveLabel . Text = "\065\105\109\032\116\097\114\103\101\116\058\032\110\111\110\101" end
end
local function stopBring ( )
if _v94b7adb6cdb9 . bring then
for part , oldAnchored in pairs ( _v94b7adb6cdb9 . bring ) do
if part . Parent then pcall ( function ( ) part . Anchored = oldAnchored end ) end
end
_v94b7adb6cdb9 . bring = nil
end
style ( Bring , false , "\066\082\073\078\071\032\083\069\076\069\067\084\069\068\058\032\079\078" , "\066\082\073\078\071\032\083\069\076\069\067\084\069\068" )
end
local function syncLabels ( )
local count = # _v71f22c1d3c92
SelectedLabel . Text = ( "\084\097\114\103\101\116\115\058\032\037\100\032\115\101\108\101\099\116\101\100\032\032\124\032\032\076\097\115\116\058\032\037\115" ) : format ( count ,
_v94b7adb6cdb9 . primary and ( "\064" .. _v94b7adb6cdb9 . primary . Name ) or "\110\111\110\101" )
end
local function invalidatePlayer ( p )
_ve76b6087628a . Notify . detach ( p )
Records [ p ] = nil
if _v94b7adb6cdb9 . aimPlayer == p then clearTarget ( ) end
if _v94b7adb6cdb9 . primary == p and _v94b7adb6cdb9 . bring then stopBring ( ) end
end
local function applyRecord ( p , rec )
if _v94b7adb6cdb9 . closed or not _vfc22e7e5f23c [ p ] then return end
local old = Records [ p ]
if old and old . model ~= ( rec and rec . model or nil ) then
if _v94b7adb6cdb9 . primary == p and _v94b7adb6cdb9 . bring then stopBring ( ) end
if _v94b7adb6cdb9 . aimPlayer == p then clearTarget ( ) end
end
Records [ p ] = rec
_ve76b6087628a . Notify . attach ( p , rec )
end
local function findRecordInWorkspace ( p , token )
local rec = validModel ( p . Character )
if not rec then rec = validModel ( candidateNamed ( _v8b8ca6137d87 , p ) ) end
if rec then return rec end
local steps = 0
for folder in pairs ( Folders ) do
if _v94b7adb6cdb9 . closed or not _vfc22e7e5f23c [ p ] or ResolutionTokens [ p ] ~= token then return nil end
if folder . Parent == _v8b8ca6137d87 then
rec = validModel ( candidateNamed ( folder , p ) )
if rec then return rec end
end
steps = steps + 1
if steps % 18 == 0 then task . wait ( ) end
end
return nil
end
local function requestResolution ( p )
if not p or not _vfc22e7e5f23c [ p ] or _v94b7adb6cdb9 . closed then return end
NextResolutionToken = NextResolutionToken + 1
ResolutionTokens [ p ] = NextResolutionToken
local token = NextResolutionToken
task . spawn ( function ( )
for attempt = 1 , 3 do
if _v94b7adb6cdb9 . closed or not _vfc22e7e5f23c [ p ] or ResolutionTokens [ p ] ~= token then return end
local rec = findRecordInWorkspace ( p , token )
if _v94b7adb6cdb9 . closed or not _vfc22e7e5f23c [ p ] or ResolutionTokens [ p ] ~= token then return end
if rec then applyRecord ( p , rec ) ; return end
if attempt == 1 then task . wait ( 0.22 )
elseif attempt == 2 then task . wait ( 0.70 ) end
end
applyRecord ( p , nil )
end )
end
local function watchFolder ( folder )
if Folders [ folder ] or not isFolder ( folder ) then return end
Folders [ folder ] = folder . ChildAdded : Connect ( function ( child )
local p = _vc1e4e252f800 [ child . Name ]
if p then requestResolution ( p ) end
end )
for i = 1 , # _v71f22c1d3c92 do
local p = _v71f22c1d3c92 [ i ]
if not recordPresent ( p , Records [ p ] ) and candidateNamed ( folder , p ) then
requestResolution ( p )
end
end
end
local function unwatchFolder ( folder )
local connection = Folders [ folder ]
if connection then connection : Disconnect ( ) ; Folders [ folder ] = nil end
for i = 1 , # _v71f22c1d3c92 do
local p = _v71f22c1d3c92 [ i ]
local rec = Records [ p ]
if rec and rec . model . Parent == folder then invalidatePlayer ( p ) end
end
end
for _ , child in ipairs ( _v8b8ca6137d87 : GetChildren ( ) ) do watchFolder ( child ) end
bind ( _v8b8ca6137d87 . ChildAdded : Connect ( function ( child )
if isFolder ( child ) then watchFolder ( child ) end
local p = _vc1e4e252f800 [ child . Name ]
if p then requestResolution ( p ) end
end ) )
bind ( _v8b8ca6137d87 . ChildRemoved : Connect ( unwatchFolder ) )
local function deselectPlayer ( p )
if not _vfc22e7e5f23c [ p ] then return end
_vfc22e7e5f23c [ p ] = nil
_vc1e4e252f800 [ p . Name ] = nil
_vc1e4e252f800 [ tostring ( p . UserId ) ] = nil
ResolutionTokens [ p ] = nil
local cs = _vd12b30d97e97 [ p ]
if cs then disconnectMany ( cs ) ; _vd12b30d97e97 [ p ] = nil end
for i = # _v71f22c1d3c92 , 1 , - 1 do
if _v71f22c1d3c92 [ i ] == p then table . remove ( _v71f22c1d3c92 , i ) ; break end
end
invalidatePlayer ( p )
_ve76b6087628a . Notify . knownModels [ p ] = nil
_ve76b6087628a . Notify . lastRespawnAt [ p ] = nil
if Rows [ p ] then Rows [ p ] . BackgroundColor3 = C_OFF end
if _v94b7adb6cdb9 . primary == p then
if _v94b7adb6cdb9 . bring then stopBring ( ) end
_v94b7adb6cdb9 . primary = _v71f22c1d3c92 [ # _v71f22c1d3c92 ]
end
end
local function addTarget ( p , knownRecord )
if _vfc22e7e5f23c [ p ] then
if knownRecord then applyRecord ( p , knownRecord ) end
return true
end
if # _v71f22c1d3c92 >= MAX_TARGETS then
say ( "\070\080\083\032\103\117\097\114\100\058\032\109\097\120\105\109\117\109\032" .. MAX_TARGETS .. "\032\115\101\108\101\099\116\101\100\032\112\108\097\121\101\114\115\046" )
return false
end
_vfc22e7e5f23c [ p ] = true
_ve76b6087628a . Notify . emit ( "\115\101\108\101\099\116\101\100" , "\064" .. p . Name .. "\032\115\101\108\101\099\116\101\100" )
_v71f22c1d3c92 [ # _v71f22c1d3c92 + 1 ] = p
_vc1e4e252f800 [ p . Name ] = p
_vc1e4e252f800 [ tostring ( p . UserId ) ] = p
local cs = {
p . CharacterAdded : Connect ( function ( character )
if _ve76b6087628a . Notify . knownModels [ p ]
and _ve76b6087628a . Notify . knownModels [ p ] ~= character
and os . clock ( ) - ( _ve76b6087628a . Notify . lastRespawnAt [ p ] or - math . huge ) > 1.3 then
_ve76b6087628a . Notify . lastRespawnAt [ p ] = os . clock ( )
_ve76b6087628a . Notify . emit ( "\114\101\115\112\097\119\110\101\100" , "\064" .. p . Name .. "\032\114\101\115\112\097\119\110\101\100" )
end
requestResolution ( p )
end ) ,
p . CharacterRemoving : Connect ( function ( ) invalidatePlayer ( p ) end ) ,
}
_vd12b30d97e97 [ p ] = cs
if Rows [ p ] then Rows [ p ] . BackgroundColor3 = C_SELECTED end
if knownRecord then
applyRecord ( p , knownRecord )
else
requestResolution ( p )
end
return true
end
local function choosePlayer ( p , knownRecord )
if _v94b7adb6cdb9 . closed or p == _vad430fdb5ce8 or ( p and p . Parent ~= _vcd60f2e5219a ) then return end
if not _v94b7adb6cdb9 . multi then
if # _v71f22c1d3c92 == 1 and _vfc22e7e5f23c [ p ] then
if knownRecord then applyRecord ( p , knownRecord ) end
_v94b7adb6cdb9 . primary = p
syncLabels ( )
return
end
for i = # _v71f22c1d3c92 , 1 , - 1 do deselectPlayer ( _v71f22c1d3c92 [ i ] ) end
if p and addTarget ( p , knownRecord ) then _v94b7adb6cdb9 . primary = p end
else
if p then
if _vfc22e7e5f23c [ p ] then deselectPlayer ( p )
elseif addTarget ( p , knownRecord ) then _v94b7adb6cdb9 . primary = p end
end
end
syncLabels ( )
if updateLoops then updateLoops ( ) end
say ( # _v71f22c1d3c92 > 0 and ( "\067\104\101\099\107\105\110\103\032\111\110\108\121\032" .. # _v71f22c1d3c92 .. "\032\115\101\108\101\099\116\101\100\032\087\111\114\107\115\112\097\099\101\032\109\111\100\101\108\040\115\041\046" )
or "\073\100\108\101\058\032\099\104\111\111\115\101\032\097\032\112\108\097\121\101\114\059\032\110\111\032\099\104\097\114\097\099\116\101\114\032\099\104\101\099\107\115\032\097\099\116\105\118\101\046" )
end
_ve76b6087628a . Picking = false
local function pickNearCursor ( )
local cam = _v8b8ca6137d87 . CurrentCamera
if not cam then say ( "\067\117\114\115\111\114\032\112\105\099\107\058\032\099\097\109\101\114\097\032\117\110\097\118\097\105\108\097\098\108\101\046" ) ; return end
local cursor = _vcb684e26a41a : GetMouseLocation ( )
if _vcb684e26a41a . MouseBehavior == Enum . MouseBehavior . LockCenter then
cursor = cam . ViewportSize * 0.5
end
local radius = 100
local bestPlayer , bestRecord , bestDistance2 = nil , nil , radius * radius
local ownFolder = _vad430fdb5ce8 . Character and _vad430fdb5ce8 . Character . Parent
local folderChecks = 0
for _ , player in ipairs ( _vcd60f2e5219a : GetPlayers ( ) ) do
if player ~= _vad430fdb5ce8 then
local rec = Records [ player ]
if not recordPresent ( player , rec ) then
rec = validModel ( player . Character )
or validModel ( candidateNamed ( ownFolder , player ) )
if not rec then
for folder in pairs ( Folders ) do
if folder . Parent == _v8b8ca6137d87 then
rec = validModel ( candidateNamed ( folder , player ) )
if rec then break end
end
folderChecks = folderChecks + 1
if folderChecks % 16 == 0 then
task . wait ( )
if _v94b7adb6cdb9 . closed then return end
end
end
end
end
if rec and alive ( rec , _v94b7adb6cdb9 . aliveOnly ) then
local part = partFor ( rec )
if part and part . Parent then
local point , onScreen = cam : WorldToViewportPoint ( part . Position )
if onScreen and point . Z > 0 then
local dx , dy = point . X - cursor . X , point . Y - cursor . Y
local distance2 = dx * dx + dy * dy
if distance2 < bestDistance2 then
bestPlayer , bestRecord , bestDistance2 = player , rec , distance2
end
end
end
end
end
end
if not bestPlayer then
say ( "\067\117\114\115\111\114\032\112\105\099\107\058\032\110\111\032\108\105\118\105\110\103\032\112\108\097\121\101\114\032\119\105\116\104\105\110\032" .. radius .. "\112\120\046" )
return
end
if bestPlayer . Parent ~= _vcd60f2e5219a or not bestRecord . model . Parent then return end
if _vfc22e7e5f23c [ bestPlayer ] then
deselectPlayer ( bestPlayer )
syncLabels ( )
updateLoops ( )
say ( "\067\117\114\115\111\114\032\112\105\099\107\058\032\064" .. bestPlayer . Name .. "\032\117\110\115\101\108\101\099\116\101\100\046" )
return
end
if not _v94b7adb6cdb9 . dot then
_v94b7adb6cdb9 . dot = true
style ( DotBtn , true , "\066\079\088\032\043\032\076\073\078\069\058\032\079\078" , "\066\079\088\032\043\032\076\073\078\069\058\032\079\070\070" )
end
if _v94b7adb6cdb9 . multi then
if not _vfc22e7e5f23c [ bestPlayer ] and not addTarget ( bestPlayer , bestRecord ) then return end
_v94b7adb6cdb9 . primary = bestPlayer
applyRecord ( bestPlayer , bestRecord )
syncLabels ( )
updateLoops ( )
else
choosePlayer ( bestPlayer , bestRecord )
end
if not _v1861b000f64a then updateLoops ( ) end
targetTick ( )
say ( "\067\117\114\115\111\114\032\112\105\099\107\058\032\064" .. bestPlayer . Name .. "\032\115\101\108\101\099\116\101\100\046" )
end
local function filterRows ( )
local query = Search . Text : lower ( )
for p , row in pairs ( Rows ) do
local matched = p . Name : lower ( ) : find ( query , 1 , true )
or p . DisplayName : lower ( ) : find ( query , 1 , true )
row . Visible = matched ~= nil and matched ~= false
end
end
local function renumberRows ( )
local all = { }
for p in pairs ( Rows ) do all [ # all + 1 ] = p end
table . sort ( all , function ( a , b ) return a . Name : lower ( ) < b . Name : lower ( ) end )
for i , p in ipairs ( all ) do Rows [ p ] . LayoutOrder = i end
end
local function addRow ( p )
if p == _vad430fdb5ce8 or Rows [ p ] then return end
local row = round ( make ( "\084\101\120\116\066\117\116\116\111\110" , {
Parent = List , Name = p . Name , Size = UDim2 . new ( 1 , - 2 , 0 , 29 ) ,
Text = "\032\032" .. p . DisplayName .. "\032\040\064" .. p . Name .. "\041" ,
TextColor3 = C_TEXT , TextXAlignment = Enum . TextXAlignment . Left ,
Font = Enum . Font . Gotham , TextSize = 11 , BorderSizePixel = 0 ,
BackgroundColor3 = _vfc22e7e5f23c [ p ] and C_SELECTED or C_OFF ,
} ) , 5 )
Rows [ p ] = row
RowConnections [ p ] = row . MouseButton1Click : Connect ( function ( )
if p . Parent == _vcd60f2e5219a then choosePlayer ( p ) end
end )
filterRows ( )
end
local function removeRow ( p )
if _vfc22e7e5f23c [ p ] then
deselectPlayer ( p )
syncLabels ( )
if updateLoops then updateLoops ( ) end
end
if RowConnections [ p ] then RowConnections [ p ] : Disconnect ( ) ; RowConnections [ p ] = nil end
if Rows [ p ] then Rows [ p ] : Destroy ( ) ; Rows [ p ] = nil end
end
for _ , player in ipairs ( _vcd60f2e5219a : GetPlayers ( ) ) do addRow ( player ) end
renumberRows ( )
bind ( _vcd60f2e5219a . PlayerAdded : Connect ( function ( p )
addRow ( p )
if _v94b7adb6cdb9 . multi and p ~= _vad430fdb5ce8 then
addTarget ( p )
if not _v94b7adb6cdb9 . primary then _v94b7adb6cdb9 . primary = p end
syncLabels ( )
updateLoops ( )
end
renumberRows ( )
end ) )
bind ( _vcd60f2e5219a . PlayerRemoving : Connect ( function ( p ) removeRow ( p ) ; renumberRows ( ) end ) )
bind ( Search : GetPropertyChangedSignal ( "\084\101\120\116" ) : Connect ( filterRows ) )
_ve76b6087628a . WallParams = RaycastParams . new ( )
_ve76b6087628a . WallParams . FilterType = Enum . RaycastFilterType . Exclude
_ve76b6087628a . WallParams . IgnoreWater = true
_ve76b6087628a . WallModel = nil
local function withinWallLine ( cam , part , rec )
if not _v94b7adb6cdb9 . wall or _v94b7adb6cdb9 . wallBang or _v94b7adb6cdb9 . forceHit then return true end
local ownModel = _vad430fdb5ce8 . Character
if _ve76b6087628a . WallModel ~= ownModel then
_ve76b6087628a . WallModel = ownModel
local ignored = { }
if ownModel then ignored [ # ignored + 1 ] = ownModel end
local blacklisted = _v8b8ca6137d87 : FindFirstChild ( "\066\108\097\099\107\108\105\115\116\101\100" )
if blacklisted then ignored [ # ignored + 1 ] = blacklisted end
_ve76b6087628a . WallParams . FilterDescendantsInstances = ignored
end
local origin = cam . CFrame . Position
if _v94b7adb6cdb9 . silent and ownModel then
local tool = ownModel : FindFirstChildOfClass ( "\084\111\111\108" )
local handle = tool and tool : FindFirstChild ( "\072\097\110\100\108\101" )
local fx = handle and handle : FindFirstChild ( "\083\104\111\111\116\070\088\071\117\105" )
if handle and handle : IsA ( "\066\097\115\101\080\097\114\116" ) and fx and fx : IsA ( "\066\105\108\108\098\111\097\114\100\071\117\105" ) then
origin = handle . Position + handle . CFrame : VectorToWorldSpace ( fx . StudsOffsetWorldSpace )
end
end
local ok , hit = pcall ( _v8b8ca6137d87 . Raycast , _v8b8ca6137d87 , origin , part . Position - origin , _ve76b6087628a . WallParams )
return ok and ( not hit or hit . Instance : IsDescendantOf ( rec . model ) )
end
local function center ( cam )
if _vcb684e26a41a . MouseBehavior == Enum . MouseBehavior . LockCenter then
local size = cam . ViewportSize
return size . X * 0.5 , size . Y * 0.5
end
local point = _vcb684e26a41a : GetMouseLocation ( )
return point . X , point . Y
end
targetTick = function ( )
local cam = _v8b8ca6137d87 . CurrentCamera
if not cam or # _v71f22c1d3c92 == 0 then clearTarget ( ) ; return end
local cx , cy = center ( cam )
local firstP , secondP , firstRec , secondRec , firstPart , secondPart
local firstPoint , secondPoint
local firstScore , secondScore = math . huge , math . huge
for i = 1 , # _v71f22c1d3c92 do
local p = _v71f22c1d3c92 [ i ]
local rec = Records [ p ]
if recordPresent ( p , rec ) and alive ( rec , _v94b7adb6cdb9 . aliveOnly ) then
local part = partFor ( rec )
if part and part . Parent then
local projected , onScreen = cam : WorldToViewportPoint ( predictedPoint ( rec , part , _v94b7adb6cdb9 . lead ) )
if onScreen and projected . Z > 0 then
local dx , dy = projected . X - cx , projected . Y - cy
local distance2 = dx * dx + dy * dy
do
local score = distance2 * ( _v94b7adb6cdb9 . aimPlayer == p and 0.78 or 1 )
if score < firstScore then
secondP , secondRec , secondPart , secondPoint , secondScore =
firstP , firstRec , firstPart , firstPoint , firstScore
firstP , firstRec , firstPart , firstPoint , firstScore =
p , rec , part , projected , score
elseif score < secondScore then
secondP , secondRec , secondPart , secondPoint , secondScore =
p , rec , part , projected , score
end
end
end
end
end
end
local p , rec , part , projected
if firstRec and withinWallLine ( cam , firstPart , firstRec ) then
p , rec , part , projected = firstP , firstRec , firstPart , firstPoint
elseif secondRec and withinWallLine ( cam , secondPart , secondRec ) then
p , rec , part , projected = secondP , secondRec , secondPart , secondPoint
end
if not rec and ( _v94b7adb6cdb9 . silent or _v94b7adb6cdb9 . forceHit ) then
local selected = _v94b7adb6cdb9 . primary
local selectedRecord = selected and Records [ selected ]
if recordPresent ( selected , selectedRecord )
and alive ( selectedRecord , _v94b7adb6cdb9 . aliveOnly ) then
local selectedPart = partFor ( selectedRecord )
if selectedPart and selectedPart . Parent
and withinWallLine ( cam , selectedPart , selectedRecord ) then
p , rec , part = selected , selectedRecord , selectedPart
projected = cam : WorldToViewportPoint (
predictedPoint ( rec , part , _v94b7adb6cdb9 . lead ) )
end
end
end
if not rec then clearTarget ( ) ; return end
if _v94b7adb6cdb9 . multi and ( _v94b7adb6cdb9 . silent or _v94b7adb6cdb9 . forceHit ) then
ActiveLabel . Text = ( "\077\117\108\116\105\032\097\105\109\058\032\037\100\032\115\101\108\101\099\116\101\100\059\032\099\121\099\108\105\110\103\032\112\101\114\032\115\104\111\116" ) : format ( # _v71f22c1d3c92 )
elseif _v94b7adb6cdb9 . aimPlayer ~= p then
ActiveLabel . Text = "\065\105\109\032\116\097\114\103\101\116\058\032\064" .. p . Name
end
_v94b7adb6cdb9 . aimPlayer , _v94b7adb6cdb9 . aimRecord = p , rec
local dx , dy = projected . X - cx , projected . Y - cy
_v94b7adb6cdb9 . screenDistance2 = dx * dx + dy * dy
_v94b7adb6cdb9 . permitted = true
_v1f40472bbaea . part = _v94b7adb6cdb9 . silent and part or nil
_v1f40472bbaea . record = _v94b7adb6cdb9 . silent and rec or nil
_v1f40472bbaea . lead = _v94b7adb6cdb9 . lead
_v1f40472bbaea . aliveOnly = _v94b7adb6cdb9 . aliveOnly
_v1f40472bbaea . enabled = _v94b7adb6cdb9 . silent
end
local function clickMouse ( )
if type ( mouse1click ) == "\102\117\110\099\116\105\111\110" then return pcall ( mouse1click ) end
if type ( mouse1press ) == "\102\117\110\099\116\105\111\110" and type ( mouse1release ) == "\102\117\110\099\116\105\111\110" then
if TriggerPressed then return false end
local ok = pcall ( mouse1press )
if not ok then return false end
TriggerPressed = true
task . delay ( 0.025 , function ( )
pcall ( mouse1release )
TriggerPressed = false
end )
return true
end
return false
end
_ve76b6087628a . Mouse = _vad430fdb5ce8 : GetMouse ( )
local function triggerTick ( )
if not _v94b7adb6cdb9 . trigger or # _v71f22c1d3c92 == 0 or _vcb684e26a41a : GetFocusedTextBox ( ) then return end
local shoot = false
local hit = _ve76b6087628a . Mouse . Target
if hit then
for i = 1 , # _v71f22c1d3c92 do
local p = _v71f22c1d3c92 [ i ]
local rec = Records [ p ]
if recordPresent ( p , rec ) and alive ( rec , _v94b7adb6cdb9 . aliveOnly )
and hit : IsDescendantOf ( rec . model ) then
shoot = true
break
end
end
end
if not shoot then return end
if not clickMouse ( ) then
_v94b7adb6cdb9 . trigger = false
style ( Trigger , false , "\084\082\073\071\071\069\082\058\032\079\078" , "\084\082\073\071\071\069\082\058\032\079\070\070" )
say ( "\084\114\105\103\103\101\114\032\099\108\105\099\107\032\117\110\115\117\112\112\111\114\116\101\100\032\098\121\032\116\104\105\115\032\101\120\101\099\117\116\111\114\046" )
updateLoops ( )
end
end
updateLoops = function ( )
local needTarget = # _v71f22c1d3c92 > 0 and ( _v94b7adb6cdb9 . silent or _v94b7adb6cdb9 . forceHit
or _v94b7adb6cdb9 . trigger or _v94b7adb6cdb9 . cameraAim or _v94b7adb6cdb9 . dot )
_ve9c0e81b802b = _ve9c0e81b802b + 1
local generation = _ve9c0e81b802b
if needTarget then
task . spawn ( function ( )
while not _v94b7adb6cdb9 . closed and generation == _ve9c0e81b802b do
targetTick ( )
if _v94b7adb6cdb9 . trigger then triggerTick ( ) end
task . wait ( _v94b7adb6cdb9 . trigger and 0.01 or ( _v94b7adb6cdb9 . silent and 0.05 or 0.10 ) )
end
end )
else
clearTarget ( )
end
if _v94b7adb6cdb9 . cameraAim and # _v71f22c1d3c92 > 0 and not _v1861b000f64a then
_v1861b000f64a = _v286a8fc93150 . RenderStepped : Connect ( function ( dt )
local rec = _v94b7adb6cdb9 . aimRecord
if _v94b7adb6cdb9 . closed or not _v94b7adb6cdb9 . permitted or not rec or not alive ( rec , _v94b7adb6cdb9 . aliveOnly ) then
return
end
local cam = _v8b8ca6137d87 . CurrentCamera
local part = partFor ( rec )
if not cam or not part or not part . Parent then return end
local aimPoint = predictedPoint ( rec , part , _v94b7adb6cdb9 . lead )
local from = cam . CFrame
local goal = CFrame . lookAt ( from . Position , aimPoint )
cam . CFrame = from : Lerp ( goal , 1 - math . exp ( - 12 * math . min ( dt , 0.07 ) ) )
end )
elseif _v1861b000f64a then
_v1861b000f64a : Disconnect ( )
_v1861b000f64a = nil
end
end
_ve76b6087628a . selectAllTargets = function ( )
if not _v94b7adb6cdb9 . multi then _v94b7adb6cdb9 . multi = true end
for _ , player in ipairs ( _vcd60f2e5219a : GetPlayers ( ) ) do
if player ~= _vad430fdb5ce8 and not _vfc22e7e5f23c [ player ] then addTarget ( player ) end
end
if not _v94b7adb6cdb9 . primary or not _vfc22e7e5f23c [ _v94b7adb6cdb9 . primary ] then _v94b7adb6cdb9 . primary = _v71f22c1d3c92 [ 1 ] end
style ( MultiBtn , true , "\077\085\076\084\073\032\084\065\082\071\069\084\058\032\079\078" , "\077\085\076\084\073\032\084\065\082\071\069\084\058\032\079\070\070" )
syncLabels ( )
updateLoops ( )
say ( ( "\077\117\108\116\105\058\032\037\100\032\115\101\108\101\099\116\101\100\059\032\115\104\111\116\115\032\099\121\099\108\101\032\097\099\114\111\115\115\032\115\101\108\101\099\116\101\100\032\112\108\097\121\101\114\115\046" ) : format ( # _v71f22c1d3c92 ) )
end
bind ( _ve76b6087628a . SelectAllBtn . MouseButton1Click : Connect ( _ve76b6087628a . selectAllTargets ) )
bind ( MultiBtn . MouseButton1Click : Connect ( function ( )
if not _v94b7adb6cdb9 . multi then
_ve76b6087628a . selectAllTargets ( )
return
end
_v94b7adb6cdb9 . multi = false
if # _v71f22c1d3c92 > 1 then
local keep = _v94b7adb6cdb9 . primary or _v71f22c1d3c92 [ 1 ]
for i = # _v71f22c1d3c92 , 1 , - 1 do
if _v71f22c1d3c92 [ i ] ~= keep then deselectPlayer ( _v71f22c1d3c92 [ i ] ) end
end
end
style ( MultiBtn , false , "\077\085\076\084\073\032\084\065\082\071\069\084\058\032\079\078" , "\077\085\076\084\073\032\084\065\082\071\069\084\058\032\079\070\070" )
syncLabels ( )
updateLoops ( )
say ( "\083\105\110\103\108\101\045\116\097\114\103\101\116\032\109\111\100\101\032\114\101\115\116\111\114\101\100\046" )
end ) )
bind ( AliveBtn . MouseButton1Click : Connect ( function ( )
_v94b7adb6cdb9 . aliveOnly = not _v94b7adb6cdb9 . aliveOnly
_v1f40472bbaea . aliveOnly = _v94b7adb6cdb9 . aliveOnly
style ( AliveBtn , _v94b7adb6cdb9 . aliveOnly , "\065\076\073\086\069\032\067\072\069\067\075\058\032\079\078" , "\065\076\073\086\069\032\067\072\069\067\075\058\032\079\070\070" )
if _v94b7adb6cdb9 . silent or _v94b7adb6cdb9 . trigger or _v94b7adb6cdb9 . cameraAim or _v94b7adb6cdb9 . dot then targetTick ( ) end
end ) )
bind ( Silent . MouseButton1Click : Connect ( function ( )
if not _v94b7adb6cdb9 . silent then
local ok , reason = installRaycastHook ( )
if not ok then say ( reason ) ; return end
end
_v94b7adb6cdb9 . silent = not _v94b7adb6cdb9 . silent
_v1f40472bbaea . enabled = _v94b7adb6cdb9 . silent and _v94b7adb6cdb9 . aimRecord ~= nil
if not _v94b7adb6cdb9 . silent then _v1f40472bbaea . part , _v1f40472bbaea . record = nil , nil end
style ( Silent , _v94b7adb6cdb9 . silent , "\083\073\076\069\078\084\032\065\073\077\058\032\079\078" , "\083\073\076\069\078\084\032\065\073\077\058\032\079\070\070" )
updateLoops ( )
end ) )
bind ( _v9a74e4ff6523 . MouseButton1Click : Connect ( function ( )
if not _v94b7adb6cdb9 . wallBang then
local ok , reason = installRaycastHook ( )
if not ok then say ( reason ) ; return end
end
_v94b7adb6cdb9 . wallBang = not _v94b7adb6cdb9 . wallBang
_v1f40472bbaea . wallBang = _v94b7adb6cdb9 . wallBang
_v1f40472bbaea . enabled = _v94b7adb6cdb9 . silent and _v94b7adb6cdb9 . aimRecord ~= nil
if not _v94b7adb6cdb9 . silent then _v1f40472bbaea . part , _v1f40472bbaea . record = nil , nil end
style ( _v9a74e4ff6523 , _v94b7adb6cdb9 . wallBang , "\087\065\076\076\066\065\078\071\058\032\079\078" , "\087\065\076\076\066\065\078\071\058\032\079\070\070" )
_ve76b6087628a . WallBangInfo . Text = _v94b7adb6cdb9 . wallBang
and "\087\066\032\082\069\065\068\089\058\032\102\105\114\101\032\116\111\032\116\101\115\116\032\116\104\101\032\099\108\105\101\110\116\032\104\105\116\032\112\097\116\104" or "\087\065\076\076\066\065\078\071\058\032\079\070\070"
_v1f40472bbaea . wallShots = 0
updateLoops ( )
say ( _v94b7adb6cdb9 . wallBang and "\087\097\108\108\098\097\110\103\032\079\078\058\032\116\101\115\116\115\032\112\108\097\121\101\114\115\032\111\110\032\101\097\099\104\032\115\104\111\116\032\108\105\110\101\044\032\119\105\116\104\032\110\111\032\115\101\108\101\099\116\101\100\032\116\097\114\103\101\116\046"
or "\087\097\108\108\098\097\110\103\032\100\105\115\097\098\108\101\100\046" )
end ) )
bind ( _ve76b6087628a . BulletModeBtn . MouseButton1Click : Connect ( function ( )
local nextMode = _v94b7adb6cdb9 . bulletMode % # _ve76b6087628a . BulletModeNames + 1
if nextMode ~= 1 then
local ok , reason = installRaycastHook ( )
if not ok then say ( reason ) ; return end
end
_v94b7adb6cdb9 . bulletMode = nextMode
_v94b7adb6cdb9 . bulletStep = 0
style ( _ve76b6087628a . BulletModeBtn , nextMode ~= 1 ,
"\066\085\076\076\069\084\032\068\073\082\069\067\084\073\079\078\058\032" .. _ve76b6087628a . BulletModeNames [ nextMode ] ,
"\066\085\076\076\069\084\032\068\073\082\069\067\084\073\079\078\058\032\067\085\082\083\079\082" )
say ( nextMode == 1 and "\066\117\108\108\101\116\032\100\105\114\101\099\116\105\111\110\032\102\111\108\108\111\119\115\032\099\117\114\115\111\114\032\097\103\097\105\110\046"
or "\066\117\108\108\101\116\032\100\105\114\101\099\116\105\111\110\058\032" .. _ve76b6087628a . BulletModeNames [ nextMode ]
.. "\032\040\111\110\101\032\114\097\100\105\097\108\032\100\105\114\101\099\116\105\111\110\032\112\101\114\032\115\104\111\116\059\032\099\097\109\101\114\097\032\117\110\099\104\097\110\103\101\100\041\046" )
end ) )
bind ( ForceHitBtn . MouseButton1Click : Connect ( function ( )
if not _v94b7adb6cdb9 . forceHit then
local ok , reason = installRaycastHook ( )
if not ok then say ( reason ) ; return end
if not _v94b7adb6cdb9 . primary then say ( "\083\101\108\101\099\116\032\097\032\112\108\097\121\101\114\032\111\110\032\084\065\082\071\069\084\083\032\102\105\114\115\116\046" ) ; return end
if not recordPresent ( _v94b7adb6cdb9 . primary , Records [ _v94b7adb6cdb9 . primary ] ) then
requestResolution ( _v94b7adb6cdb9 . primary )
say ( "\070\111\114\099\101\032\104\105\116\058\032\114\101\115\111\108\118\105\110\103\032\115\101\108\101\099\116\101\100\032\112\108\097\121\101\114\039\115\032\108\105\118\101\032\114\105\103\059\032\116\114\121\032\097\103\097\105\110\032\115\104\111\114\116\108\121\046" )
return
end
end
_v94b7adb6cdb9 . forceHit = not _v94b7adb6cdb9 . forceHit
style ( ForceHitBtn , _v94b7adb6cdb9 . forceHit , "\070\079\082\067\069\032\072\073\084\058\032\079\078" , "\070\079\082\067\069\032\072\073\084\058\032\079\070\070" )
updateLoops ( )
say ( _v94b7adb6cdb9 . forceHit and "\070\111\114\099\101\032\104\105\116\032\116\097\114\103\101\116\115\032\116\104\101\032\115\101\108\101\099\116\101\100\032\112\108\097\121\101\114\032\097\116\032\097\110\121\032\099\108\105\101\110\116\032\100\105\115\116\097\110\099\101\046"
or "\070\111\114\099\101\032\104\105\116\032\100\105\115\097\098\108\101\100\046" )
end ) )
bind ( _ve76b6087628a . QuietKillBtn . MouseButton1Click : Connect ( function ( )
_v94b7adb6cdb9 . quietAutoKill = not _v94b7adb6cdb9 . quietAutoKill
style ( _ve76b6087628a . QuietKillBtn , _v94b7adb6cdb9 . quietAutoKill ,
"\081\085\073\069\084\032\065\085\084\079\032\075\073\076\076\058\032\079\078" , "\081\085\073\069\084\032\065\085\084\079\032\075\073\076\076\058\032\079\070\070" )
say ( _v94b7adb6cdb9 . quietAutoKill and "\065\117\116\111\032\107\105\108\108\032\102\105\114\101\115\032\102\114\111\109\032\121\111\117\114\032\099\117\114\114\101\110\116\032\112\111\115\105\116\105\111\110\046"
or "\065\117\116\111\032\107\105\108\108\032\115\116\114\097\102\105\110\103\032\101\110\097\098\108\101\100\046" )
end ) )
bind ( Trigger . MouseButton1Click : Connect ( function ( )
if not _v94b7adb6cdb9 . trigger and type ( mouse1click ) ~= "\102\117\110\099\116\105\111\110"
and not ( type ( mouse1press ) == "\102\117\110\099\116\105\111\110" and type ( mouse1release ) == "\102\117\110\099\116\105\111\110" ) then
say ( "\084\114\105\103\103\101\114\032\110\101\101\100\115\032\097\110\032\101\120\101\099\117\116\111\114\032\109\111\117\115\101\045\099\108\105\099\107\032\102\117\110\099\116\105\111\110\046" )
return
end
_v94b7adb6cdb9 . trigger = not _v94b7adb6cdb9 . trigger
style ( Trigger , _v94b7adb6cdb9 . trigger , "\084\082\073\071\071\069\082\058\032\079\078" , "\084\082\073\071\071\069\082\058\032\079\070\070" )
updateLoops ( )
end ) )
bind ( CameraBtn . MouseButton1Click : Connect ( function ( )
_v94b7adb6cdb9 . cameraAim = not _v94b7adb6cdb9 . cameraAim
style ( CameraBtn , _v94b7adb6cdb9 . cameraAim , "\067\065\077\069\082\065\032\065\073\077\058\032\079\078" , "\067\065\077\069\082\065\032\065\073\077\058\032\079\070\070" )
updateLoops ( )
end ) )
bind ( DotBtn . MouseButton1Click : Connect ( function ( )
_v94b7adb6cdb9 . dot = not _v94b7adb6cdb9 . dot
style ( DotBtn , _v94b7adb6cdb9 . dot , "\066\079\088\032\043\032\076\073\078\069\058\032\079\078" , "\066\079\088\032\043\032\076\073\078\069\058\032\079\070\070" )
updateLoops ( )
end ) )
bind ( Hitbox . MouseButton1Click : Connect ( function ( )
_v94b7adb6cdb9 . head = not _v94b7adb6cdb9 . head
Hitbox . Text = _v94b7adb6cdb9 . head and "\072\073\084\066\079\088\058\032\072\069\065\068" or "\072\073\084\066\079\088\058\032\066\079\068\089"
if _v94b7adb6cdb9 . silent or _v94b7adb6cdb9 . trigger or _v94b7adb6cdb9 . dot or _v94b7adb6cdb9 . cameraAim then targetTick ( ) end
end ) )
bind ( Wall . MouseButton1Click : Connect ( function ( )
_v94b7adb6cdb9 . wall = not _v94b7adb6cdb9 . wall
style ( Wall , _v94b7adb6cdb9 . wall , "\087\065\076\076\032\067\072\069\067\075\058\032\079\078" , "\087\065\076\076\032\067\072\069\067\075\058\032\079\070\070" )
if _v94b7adb6cdb9 . silent or _v94b7adb6cdb9 . trigger or _v94b7adb6cdb9 . dot or _v94b7adb6cdb9 . cameraAim then targetTick ( ) end
end ) )
bind ( CursorToggle . MouseButton1Click : Connect ( function ( )
_v94b7adb6cdb9 . cursorKeyEnabled = not _v94b7adb6cdb9 . cursorKeyEnabled
style ( CursorToggle , _v94b7adb6cdb9 . cursorKeyEnabled , "\067\085\082\083\079\082\032\080\073\067\075\058\032\079\078" , "\067\085\082\083\079\082\032\080\073\067\075\058\032\079\070\070" )
say ( _v94b7adb6cdb9 . cursorKeyEnabled and "\067\117\114\115\111\114\032\115\101\108\101\099\116\105\111\110\032\101\110\097\098\108\101\100\046\032\080\114\101\115\115\032\081\032\110\101\097\114\032\097\032\112\108\097\121\101\114\046"
or "\067\117\114\115\111\114\032\115\101\108\101\099\116\105\111\110\032\100\105\115\097\098\108\101\100\046" )
end ) )
local function startCursorPick ( )
if not _v94b7adb6cdb9 . cursorKeyEnabled or _ve76b6087628a . Picking then return end
_ve76b6087628a . Picking = true
task . spawn ( function ( )
local ok = pcall ( pickNearCursor )
_ve76b6087628a . Picking = false
if not ok and not _v94b7adb6cdb9 . closed then say ( "\067\117\114\115\111\114\032\112\105\099\107\032\102\097\105\108\101\100\059\032\116\114\121\032\082\101\102\114\101\115\104\032\084\097\114\103\101\116\115\046" ) end
end )
end
bind ( CursorPick . MouseButton1Click : Connect ( startCursorPick ) )
bind ( _vcb684e26a41a . InputBegan : Connect ( function ( input , processed )
if not processed and not _v94b7adb6cdb9 . closed and not _vcb684e26a41a : GetFocusedTextBox ( )
and input . KeyCode == Enum . KeyCode . Q then
startCursorPick ( )
end
end ) )
local function setLead ( val )
_v94b7adb6cdb9 . lead = math . clamp ( math . floor ( val * 1000 + .5 ) / 1000 , 0 , .15 )
LeadText . Text = ( "\080\082\069\068\073\067\084\073\079\078\058\032\037\100\032\109\115" ) : format ( math . floor ( _v94b7adb6cdb9 . lead * 1000 + .5 ) )
_v1f40472bbaea . lead = _v94b7adb6cdb9 . lead
end
bind ( Minus . MouseButton1Click : Connect ( function ( ) setLead ( _v94b7adb6cdb9 . lead - .005 ) end ) )
bind ( Plus . MouseButton1Click : Connect ( function ( ) setLead ( _v94b7adb6cdb9 . lead + .005 ) end ) )
bind ( Refresh . MouseButton1Click : Connect ( function ( )
for i = 1 , # _v71f22c1d3c92 do requestResolution ( _v71f22c1d3c92 [ i ] ) end
say ( "\079\110\101\045\111\102\102\032\087\111\114\107\115\112\097\099\101\032\114\101\102\114\101\115\104\032\102\111\114\032" .. # _v71f22c1d3c92 .. "\032\115\101\108\101\099\116\101\100\032\112\108\097\121\101\114\040\115\041\046" )
end ) )
bind ( AutoArmor . MouseButton1Click : Connect ( function ( )
_v94b7adb6cdb9 . autoArmor = not _v94b7adb6cdb9 . autoArmor
_v94b7adb6cdb9 . armorGeneration = _v94b7adb6cdb9 . armorGeneration + 1
style ( AutoArmor , _v94b7adb6cdb9 . autoArmor , "\065\085\084\079\032\065\082\077\079\082\032\079\078\032\082\069\083\080\065\087\078\058\032\079\078" , "\065\085\084\079\032\065\082\077\079\082\032\079\078\032\082\069\083\080\065\087\078\058\032\079\070\070" )
if _v94b7adb6cdb9 . autoArmor then
say ( "\065\117\116\111\032\097\114\109\111\114\032\101\110\097\098\108\101\100\059\032\105\116\032\119\105\108\108\032\099\111\108\108\101\099\116\032\111\110\099\101\032\097\102\116\101\114\032\101\097\099\104\032\114\101\115\112\097\119\110\046" )
if _vad430fdb5ce8 . Character then task . spawn ( buyAutoItems , _vad430fdb5ce8 . Character ) end
else
say ( "\065\117\116\111\032\097\114\109\111\114\032\100\105\115\097\098\108\101\100\046" )
end
end ) )
bind ( _v961187159855 . MouseButton1Click : Connect ( function ( )
_v94b7adb6cdb9 . antiStomp = not _v94b7adb6cdb9 . antiStomp
style ( _v961187159855 , _v94b7adb6cdb9 . antiStomp , "\065\078\084\073\032\083\084\079\077\080\058\032\079\078" , "\065\078\084\073\032\083\084\079\077\080\058\032\079\070\070" )
if _v94b7adb6cdb9 . antiStomp then
say ( "\065\110\116\105\032\115\116\111\109\112\032\097\114\109\101\100\058\032\111\110\101\032\114\101\115\101\116\032\101\112\105\115\111\100\101\032\112\101\114\032\099\104\097\114\097\099\116\101\114\032\040\048\046\053\115\032\114\101\116\114\105\101\115\041\046" )
resetBeforeStomp ( _vad430fdb5ce8 . Character , ownDangerReason ( _vad430fdb5ce8 . Character ) )
else
_v94b7adb6cdb9 . resetGeneration = _v94b7adb6cdb9 . resetGeneration + 1
_v94b7adb6cdb9 . resetCharacter = nil
_v94b7adb6cdb9 . resetInFlight = false
_v94b7adb6cdb9 . antiStompReady = false
say ( "\065\110\116\105\032\115\116\111\109\112\032\100\105\115\097\098\108\101\100\059\032\112\101\110\100\105\110\103\032\114\101\116\114\105\101\115\032\099\097\110\099\101\108\108\101\100\046" )
end
end ) )
bind ( ResetThresholdBtn . MouseButton1Click : Connect ( function ( )
_v94b7adb6cdb9 . resetThresholdIndex = _v94b7adb6cdb9 . resetThresholdIndex % # ResetThresholds + 1
ResetThresholdBtn . Text = "\082\069\083\069\084\032\065\084\058\032" .. ResetThresholds [ _v94b7adb6cdb9 . resetThresholdIndex ] .. "\032\072\080"
resetBeforeStomp ( _vad430fdb5ce8 . Character , ownDangerReason ( _vad430fdb5ce8 . Character ) )
end ) )
bind ( AutoStompBtn . MouseButton1Click : Connect ( function ( )
if _v94b7adb6cdb9 . bringStompRestore ~= nil then
say ( "\065\117\116\111\032\115\116\111\109\112\032\105\115\032\112\097\117\115\101\100\032\102\111\114\032\066\114\105\110\103\046" )
return
end
_v94b7adb6cdb9 . autoStomp = not _v94b7adb6cdb9 . autoStomp
style ( AutoStompBtn , _v94b7adb6cdb9 . autoStomp , "\065\085\084\079\032\083\084\079\077\080\058\032\079\078" , "\065\085\084\079\032\083\084\079\077\080\058\032\079\070\070" )
updateAutoStomp ( )
say ( _v94b7adb6cdb9 . autoStomp and "\065\117\116\111\032\115\116\111\109\112\058\032\114\101\112\101\097\116\115\032\083\116\111\109\112\082\101\109\111\116\101\032\111\118\101\114\032\075\046\079\032\111\114\032\100\101\097\100\032\098\111\100\105\101\115\046"
or "\065\117\116\111\032\115\116\111\109\112\032\100\105\115\097\098\108\101\100\046" )
end ) )
bind ( _ve76b6087628a . StompAnimationBtn . MouseButton1Click : Connect ( function ( )
_v94b7adb6cdb9 . stompAnimationEnabled = not _v94b7adb6cdb9 . stompAnimationEnabled
style ( _ve76b6087628a . StompAnimationBtn , _v94b7adb6cdb9 . stompAnimationEnabled ,
"\083\084\079\077\080\032\065\078\073\077\065\084\073\079\078\058\032\079\078" , "\083\084\079\077\080\032\065\078\073\077\065\084\073\079\078\058\032\079\070\070" )
if not _v94b7adb6cdb9 . stompAnimationEnabled and AutoStompTrack then
pcall ( function ( ) AutoStompTrack : Stop ( 0 ) end )
end
say ( _v94b7adb6cdb9 . stompAnimationEnabled and "\083\116\111\109\112\032\097\110\105\109\097\116\105\111\110\032\101\110\097\098\108\101\100\046"
or "\083\116\111\109\112\032\097\110\105\109\097\116\105\111\110\032\104\105\100\100\101\110\032\108\111\099\097\108\108\121\059\032\114\101\109\111\116\101\032\115\116\105\108\108\032\114\101\099\101\105\118\101\115\032\105\116\115\032\116\114\097\099\107\046" )
end ) )
local function releaseSelectedStompPin ( )
if _v94b7adb6cdb9 . selectedStompFollowConnection then
_v94b7adb6cdb9 . selectedStompFollowConnection : Disconnect ( )
_v94b7adb6cdb9 . selectedStompFollowConnection = nil
end
if _v94b7adb6cdb9 . selectedStompAnchors then
for part , wasAnchored in pairs ( _v94b7adb6cdb9 . selectedStompAnchors ) do
if part . Parent then
pcall ( function ( ) part . Anchored = wasAnchored end )
end
end
end
_v94b7adb6cdb9 . selectedStompAnchors = nil
_v94b7adb6cdb9 . selectedStompModel = nil
end
_ve76b6087628a . selectedStompRightLeg = function ( character )
return character and ( character : FindFirstChild ( "\082\105\103\104\116\032\076\101\103" )
or character : FindFirstChild ( "\082\105\103\104\116\076\111\119\101\114\076\101\103" )
or character : FindFirstChild ( "\082\105\103\104\116\070\111\111\116" ) )
end
_ve76b6087628a . pinSelectedStompModel = function ( model )
local character = _vad430fdb5ce8 . Character
local leg = _ve76b6087628a . selectedStompRightLeg ( character )
if not leg or not leg : IsA ( "\066\097\115\101\080\097\114\116" ) or not model . Parent then return end
local targetLower = model : FindFirstChild ( "\076\111\119\101\114\084\111\114\115\111" )
if not targetLower then return end
local desiredLower = leg . CFrame * CFrame . new ( 0 ,
- ( leg . Size . Y + targetLower . Size . Y ) * 0.5 , 0 )
local pivotOffset = targetLower . CFrame : ToObjectSpace ( model : GetPivot ( ) )
for part in pairs ( _v94b7adb6cdb9 . selectedStompAnchors or { } ) do
if part . Parent then part . Anchored = true end
end
model : PivotTo ( desiredLower * pivotOffset )
local root = model : FindFirstChild ( "\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116" )
if root then
root . AssemblyLinearVelocity = Vector3 . zero
root . AssemblyAngularVelocity = Vector3 . zero
end
end
bind ( SelectedStompBtn . MouseButton1Click : Connect ( function ( )
if _v94b7adb6cdb9 . selectedStomp then
_v94b7adb6cdb9 . selectedStomp = false
_v94b7adb6cdb9 . selectedStompTarget = nil
_v94b7adb6cdb9 . selectedStompGeneration = _v94b7adb6cdb9 . selectedStompGeneration + 1
releaseSelectedStompPin ( )
style ( SelectedStompBtn , false , "\083\069\076\069\067\084\069\068\032\083\084\079\077\080\058\032\079\078" , "\083\069\076\069\067\084\069\068\032\083\084\079\077\080\058\032\079\070\070" )
say ( "\083\101\108\101\099\116\101\100\032\115\116\111\109\112\032\100\105\115\097\098\108\101\100\046" )
return
end
local target = _v94b7adb6cdb9 . primary
local rec = target and Records [ target ]
if not recordPresent ( target , rec ) then
say ( "\083\101\108\101\099\116\032\097\032\112\108\097\121\101\114\032\111\110\032\084\065\082\071\069\084\083\032\102\105\114\115\116\046" )
return
end
_v94b7adb6cdb9 . selectedStomp = true
_v94b7adb6cdb9 . selectedStompTarget = target
_v94b7adb6cdb9 . selectedStompGeneration = _v94b7adb6cdb9 . selectedStompGeneration + 1
local generation = _v94b7adb6cdb9 . selectedStompGeneration
style ( SelectedStompBtn , true , "\083\069\076\069\067\084\069\068\032\083\084\079\077\080\058\032\079\078" , "\083\069\076\069\067\084\069\068\032\083\084\079\077\080\058\032\079\070\070" )
say ( "\083\101\108\101\099\116\101\100\032\115\116\111\109\112\032\119\097\116\099\104\105\110\103\032\064" .. target . Name .. "\032\102\114\111\109\032\121\111\117\114\032\112\111\115\105\116\105\111\110\046" )
task . spawn ( function ( )
local ownershipModel = nil
while not _v94b7adb6cdb9 . closed and _v94b7adb6cdb9 . selectedStomp
and generation == _v94b7adb6cdb9 . selectedStompGeneration do
rec = Records [ target ]
if not recordPresent ( target , rec ) then
_v94b7adb6cdb9 . selectedStomp = false
_v94b7adb6cdb9 . selectedStompTarget = nil
releaseSelectedStompPin ( )
style ( SelectedStompBtn , false , "\083\069\076\069\067\084\069\068\032\083\084\079\077\080\058\032\079\078" , "\083\069\076\069\067\084\069\068\032\083\084\079\077\080\058\032\079\070\070" )
say ( "\083\101\108\101\099\116\101\100\032\115\116\111\109\112\032\115\116\111\112\112\101\100\058\032\116\097\114\103\101\116\032\108\101\102\116\046" )
break
end
local effects = rec . model : FindFirstChild ( "\066\111\100\121\069\102\102\101\099\116\115" )
local ko = effects and effects : FindFirstChild ( "\075\046\079" )
local dead = effects and effects : FindFirstChild ( "\068\101\097\100" )
local downed = rec . humanoid . Health <= 0 or ( ko and ko . Value )
or ( dead and dead . Value )
if downed and _v94b7adb6cdb9 . bringStompRestore == nil and not _v94b7adb6cdb9 . autoKill
and not _v94b7adb6cdb9 . resetInFlight then
local character = _vad430fdb5ce8 . Character
local rightLeg = _ve76b6087628a . selectedStompRightLeg ( character )
local targetLower = rec . model : FindFirstChild ( "\076\111\119\101\114\084\111\114\115\111" )
local hum = character and character : FindFirstChildOfClass ( "\072\117\109\097\110\111\105\100" )
if rightLeg and targetLower and hum and hum . Health > 0 then
if _v94b7adb6cdb9 . selectedStompModel ~= rec . model then
releaseSelectedStompPin ( )
_v94b7adb6cdb9 . selectedStompModel = rec . model
_v94b7adb6cdb9 . selectedStompAnchors = { }
for _ , part in ipairs ( rec . model : GetDescendants ( ) ) do
if part : IsA ( "\066\097\115\101\080\097\114\116" ) then
_v94b7adb6cdb9 . selectedStompAnchors [ part ] = part . Anchored
end
end
local model = rec . model
_v94b7adb6cdb9 . selectedStompFollowConnection = _v286a8fc93150 . RenderStepped : Connect ( function ( )
if _v94b7adb6cdb9 . closed or not _v94b7adb6cdb9 . selectedStomp or _v94b7adb6cdb9 . selectedStompModel ~= model
or _vad430fdb5ce8 . Character ~= character then return end
pcall ( _ve76b6087628a . pinSelectedStompModel , model )
end )
end
if ownershipModel ~= rec . model then
ownershipModel = rec . model
local ok , owns = pcall ( isnetworkowner , rec . root )
if not ok or not owns then
say ( "\082\097\103\100\111\108\108\032\102\111\108\108\111\119\032\105\115\032\108\111\099\097\108\059\032\116\104\101\032\115\101\114\118\101\114\032\109\097\121\032\114\101\106\101\099\116\032\100\105\115\116\097\110\116\032\115\116\111\109\112\115\046" )
else
say ( "\082\097\103\100\111\108\108\032\112\104\121\115\105\099\115\032\111\119\110\101\100\032\108\111\099\097\108\108\121\059\032\097\116\116\101\109\112\116\105\110\103\032\115\116\111\109\112\032\104\101\114\101\046" )
end
end
pcall ( _ve76b6087628a . pinSelectedStompModel , rec . model )
if not _v94b7adb6cdb9 . closed and _v94b7adb6cdb9 . selectedStomp
and generation == _v94b7adb6cdb9 . selectedStompGeneration
and _vad430fdb5ce8 . Character == character then
pcall ( autoStompTick , rec . model , true )
end
end
else
releaseSelectedStompPin ( )
ownershipModel = nil
end
task . wait ( downed and math . max ( 0.05 , _v94b7adb6cdb9 . stompPace * 0.75 ) or 0.2 )
end
end )
end ) )
bind ( AutoBuyPrev . MouseButton1Click : Connect ( function ( )
_v94b7adb6cdb9 . autoBuyIndex = ( _v94b7adb6cdb9 . autoBuyIndex - 2 ) % # ShopNames + 1
refreshAutoBuyControls ( )
end ) )
bind ( AutoBuyNext . MouseButton1Click : Connect ( function ( )
_v94b7adb6cdb9 . autoBuyIndex = _v94b7adb6cdb9 . autoBuyIndex % # ShopNames + 1
refreshAutoBuyControls ( )
end ) )
bind ( AutoBuyToggle . MouseButton1Click : Connect ( function ( )
local name = selectedShop ( )
_v94b7adb6cdb9 . autoBuys [ name ] = not _v94b7adb6cdb9 . autoBuys [ name ] or nil
refreshAutoBuyControls ( )
say ( name .. ( _v94b7adb6cdb9 . autoBuys [ name ] and "\032\119\105\108\108\032\098\101\032\098\111\117\103\104\116\032\111\110\032\114\101\115\112\097\119\110\046" or "\032\097\117\116\111\032\098\117\121\032\100\105\115\097\098\108\101\100\046" ) )
end ) )
bind ( AutoBuyNow . MouseButton1Click : Connect ( function ( )
if not _vad430fdb5ce8 . Character then say ( "\078\111\032\099\104\097\114\097\099\116\101\114\032\097\118\097\105\108\097\098\108\101\032\102\111\114\032\115\104\111\112\112\105\110\103\046" ) ; return end
task . spawn ( buyAutoItems , _vad430fdb5ce8 . Character , selectedShop ( ) )
end ) )
local function restoreBringStomp ( )
local previous = _v94b7adb6cdb9 . bringStompRestore
if previous == nil then return end
_v94b7adb6cdb9 . bringStompRestore = nil
_v94b7adb6cdb9 . bringStompAwaitDistance = false
_v94b7adb6cdb9 . bringStompGeneration = _v94b7adb6cdb9 . bringStompGeneration + 1
_v94b7adb6cdb9 . autoStomp = previous
style ( AutoStompBtn , _v94b7adb6cdb9 . autoStomp , "\065\085\084\079\032\083\084\079\077\080\058\032\079\078" , "\065\085\084\079\032\083\084\079\077\080\058\032\079\070\070" )
updateAutoStomp ( )
end
local function pauseBringStomp ( )
if _v94b7adb6cdb9 . bringStompRestore ~= nil then return end
_v94b7adb6cdb9 . bringStompRestore = _v94b7adb6cdb9 . autoStomp
_v94b7adb6cdb9 . bringStompAwaitDistance = false
_v94b7adb6cdb9 . bringStompGeneration = _v94b7adb6cdb9 . bringStompGeneration + 1
local generation = _v94b7adb6cdb9 . bringStompGeneration
_v94b7adb6cdb9 . autoStomp = false
style ( AutoStompBtn , false , "\065\085\084\079\032\083\084\079\077\080\058\032\079\078" , "\065\085\084\079\032\083\084\079\077\080\058\032\079\070\070" )
updateAutoStomp ( )
task . spawn ( function ( )
while not _v94b7adb6cdb9 . closed and generation == _v94b7adb6cdb9 . bringStompGeneration do
if not _v94b7adb6cdb9 . autoKill and not _v94b7adb6cdb9 . bringStompAwaitDistance then
restoreBringStomp ( )
return
end
task . wait ( 0.15 )
end
end )
end
local function restoreBringStompWhenClear ( target )
if _v94b7adb6cdb9 . bringStompRestore == nil then return end
_v94b7adb6cdb9 . bringStompAwaitDistance = true
local generation = _v94b7adb6cdb9 . bringStompGeneration
task . spawn ( function ( )
while not _v94b7adb6cdb9 . closed and generation == _v94b7adb6cdb9 . bringStompGeneration do
local ownCharacter = _vad430fdb5ce8 . Character
local ownRoot = ownCharacter and ownCharacter : FindFirstChild ( "\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116" )
local rec = Records [ target ]
local targetRoot = rec and rec . root
local carrying = ownCharacter and ownCharacter : FindFirstChild ( "\071\082\065\066\066\073\078\071\095\067\079\078\083\084\082\065\073\078\084" )
if not carrying and ( not ownRoot or not targetRoot or not targetRoot . Parent
or ( ownRoot . Position - targetRoot . Position ) . Magnitude >= 5 ) then
restoreBringStomp ( )
return
end
if carrying then
local storage = _v7ab6349c26e8 : FindFirstChild ( "\083\116\111\114\097\103\101" )
local remotes = storage and storage : FindFirstChild ( "\082\101\109\111\116\101\115" )
local main = remotes and remotes : FindFirstChild ( "\077\097\105\110" )
if main then pcall ( function ( ) main : FireServer ( "\071\114\097\098\098\105\110\103" ) end ) end
task . wait ( 0.55 )
end
task . wait ( 0.1 )
end
end )
end
local function stopAutoKill ( message , keepStompPaused )
if _v94b7adb6cdb9 . standAttackTarget then
local snipeReturn = _v94b7adb6cdb9 . standSnipeTarget and _v94b7adb6cdb9 . standSnipeReturnCFrame
_v94b7adb6cdb9 . standAttackTarget = nil
_v94b7adb6cdb9 . standDownOnlyTarget = nil
_v94b7adb6cdb9 . standAttack2Target = nil
_v94b7adb6cdb9 . standAttack3Target = nil
_v94b7adb6cdb9 . standAttack4Target = nil
_v94b7adb6cdb9 . standAttack5Target = nil
_v94b7adb6cdb9 . standSnipeTarget = nil
_v94b7adb6cdb9 . standSnipeReturnCFrame = nil
_v94b7adb6cdb9 . standAttack2FinisherPlayed = false
_v94b7adb6cdb9 . standAttack2LaunchQueued = false
if _ve76b6087628a . standEndCinematic then _ve76b6087628a . standEndCinematic ( ) end
style ( ForceHitBtn , _v94b7adb6cdb9 . forceHit , "\070\079\082\067\069\032\072\073\084\058\032\079\078" , "\070\079\082\067\069\032\072\073\084\058\032\079\070\070" )
_v94b7adb6cdb9 . quietAutoKill = _v94b7adb6cdb9 . standPreviousQuiet
_v94b7adb6cdb9 . autoKillVoid = _v94b7adb6cdb9 . standPreviousVoid
style ( VoidKillBtn , _v94b7adb6cdb9 . autoKillVoid ,
"\065\085\084\079\032\075\073\076\076\032\086\079\073\068\032\066\076\073\078\075\058\032\079\078" , "\065\085\084\079\032\075\073\076\076\032\086\079\073\068\032\066\076\073\078\075\058\032\079\070\070" )
style ( _ve76b6087628a . QuietKillBtn , _v94b7adb6cdb9 . quietAutoKill ,
"\081\085\073\069\084\032\065\085\084\079\032\075\073\076\076\058\032\079\078" , "\081\085\073\069\084\032\065\085\084\079\032\075\073\076\076\058\032\079\070\070" )
_v94b7adb6cdb9 . rapidWeapons [ "\091\082\101\118\111\108\118\101\114\093" ] = _v94b7adb6cdb9 . standRevolverRapidBefore or nil
_v94b7adb6cdb9 . standRevolverRapidBefore = nil
_v94b7adb6cdb9 . standEnabledRapid = nil
_vf7c4bc36ea3b . forEachGun ( function ( tool )
if tool . Name == "\091\082\101\118\111\108\118\101\114\093" then _vf7c4bc36ea3b . applyCooldown ( tool ) end
end )
if _vf7c4bc36ea3b . rows [ "\091\082\101\118\111\108\118\101\114\093" ] then
style ( _vf7c4bc36ea3b . rows [ "\091\082\101\118\111\108\118\101\114\093" ] , _v94b7adb6cdb9 . rapidWeapons [ "\091\082\101\118\111\108\118\101\114\093" ] ,
"\091\082\101\118\111\108\118\101\114\093\032\032\047\032\032\079\078" , "\091\082\101\118\111\108\118\101\114\093\032\032\047\032\032\079\070\070" )
end
if updateLoops then updateLoops ( ) end
if snipeReturn then
local character = _vad430fdb5ce8 . Character
local root = character and character : FindFirstChild ( "\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116" )
local hum = character and character : FindFirstChildOfClass ( "\072\117\109\097\110\111\105\100" )
if root and hum and hum . Health > 0 and not _v94b7adb6cdb9 . resetInFlight then
local landing = _ve76b6087628a . safeBringLanding
and _ve76b6087628a . safeBringLanding ( snipeReturn , character )
if landing then
pcall ( function ( )
character : PivotTo ( landing )
root . AssemblyLinearVelocity = Vector3 . zero
root . AssemblyAngularVelocity = Vector3 . zero
end )
end
end
end
end
_v94b7adb6cdb9 . autoKill = false
_v94b7adb6cdb9 . autoKillGeneration = _v94b7adb6cdb9 . autoKillGeneration + 1
_v94b7adb6cdb9 . killBringDestination = nil
_v94b7adb6cdb9 . bringFollowOwner = nil
_v94b7adb6cdb9 . voidBlinking = false
if not keepStompPaused then restoreBringStomp ( ) end
style ( Bring , false , "\066\082\073\078\071\032\083\069\076\069\067\084\069\068\058\032\079\078" , "\066\082\073\078\071\032\083\069\076\069\067\084\069\068" )
_v1f40472bbaea . lockPlayer , _v1f40472bbaea . lockRecord = nil , nil
style ( AutoKillBtn , false , "\065\085\084\079\032\075\073\076\076\032\083\069\076\069\067\084\069\068\058\032\079\078" , "\065\085\084\079\032\075\073\076\076\032\083\069\076\069\067\084\069\068\058\032\079\070\070" )
if not _v94b7adb6cdb9 . silent and not _v94b7adb6cdb9 . wallBang and not _v94b7adb6cdb9 . forceHit then _v1f40472bbaea . enabled = false end
if message then say ( message ) end
end
_ve76b6087628a . safeBringLanding = function ( destination , character )
if typeof ( destination ) ~= "\067\070\114\097\109\101" or destination . Position . Y < - 28 then
return nil , "\100\101\115\116\105\110\097\116\105\111\110\032\105\115\032\098\101\108\111\119\032\116\104\101\032\115\097\102\101\032\109\097\112\032\104\101\105\103\104\116"
end
local exclude = { character }
local params = OverlapParams . new ( )
params . FilterType = Enum . RaycastFilterType . Exclude
params . FilterDescendantsInstances = exclude
local floorParams = RaycastParams . new ( )
floorParams . FilterType = Enum . RaycastFilterType . Exclude
floorParams . FilterDescendantsInstances = exclude
floorParams . IgnoreWater = true
local offsets = {
Vector3 . new ( 5.5 , 2.3 , 0 ) , Vector3 . new ( - 5.5 , 2.3 , 0 ) ,
Vector3 . new ( 0 , 2.3 , 5.5 ) , Vector3 . new ( 0 , 2.3 , - 5.5 ) ,
Vector3 . new ( 4.5 , 3.5 , 4.5 ) , Vector3 . new ( - 4.5 , 3.5 , - 4.5 ) ,
}
for _ , offset in ipairs ( offsets ) do
local candidate = destination * CFrame . new ( offset )
local success , parts = pcall ( function ( )
return _v8b8ca6137d87 : GetPartBoundsInBox ( CFrame . new ( candidate . Position ) ,
Vector3 . new ( 3.0 , 4.5 , 3.0 ) , params )
end )
if not success then return nil , "\108\097\110\100\105\110\103\032\099\111\108\108\105\115\105\111\110\032\113\117\101\114\121\032\102\097\105\108\101\100" end
local blocked = false
for _ , part in ipairs ( parts ) do
if part : IsA ( "\066\097\115\101\080\097\114\116" ) and part . CanCollide then
blocked = true
break
end
end
if not blocked then
local floor = _v8b8ca6137d87 : Raycast ( candidate . Position + Vector3 . new ( 0 , 1 , 0 ) ,
Vector3 . new ( 0 , - 12 , 0 ) , floorParams )
if floor and floor . Instance . CanCollide and floor . Normal . Y > 0.5 then
return candidate
end
end
end
return nil , "\110\111\032\099\108\101\097\114\044\032\115\117\112\112\111\114\116\101\100\032\108\097\110\100\105\110\103\032\110\101\097\114\032\116\104\101\032\100\101\115\116\105\110\097\116\105\111\110"
end
local function startAutoKill ( bringDestination , bringOwner , explicitTarget )
if _v94b7adb6cdb9 . autoKill then stopAutoKill ( "\065\117\116\111\032\107\105\108\108\032\115\116\111\112\112\101\100\046" ) ; return end
local target = explicitTarget or _v94b7adb6cdb9 . primary
local rec = target and ( explicitTarget and _v1f40472bbaea . resolveShotRecord ( target )
or Records [ target ] )
if not ( explicitTarget and recordUsable ( target , rec )
or not explicitTarget and recordPresent ( target , rec ) )
or ( not bringDestination and not alive ( rec , true ) ) then
say ( "\083\101\108\101\099\116\032\097\032\112\108\097\121\101\114\032\111\110\032\084\065\082\071\069\084\083\032\102\105\114\115\116\046" )
return
end
local ok , err = installRaycastHook ( )
if not ok then say ( err ) ; return end
_v94b7adb6cdb9 . autoKill = true
_v94b7adb6cdb9 . lastConfirmedHitAt = os . clock ( )
_v94b7adb6cdb9 . lastAdaptiveSwitchAt = 0
_v94b7adb6cdb9 . killBringDestination = bringDestination
_v94b7adb6cdb9 . bringFollowOwner = bringDestination and bringOwner or nil
if bringDestination then pauseBringStomp ( ) end
style ( Bring , bringDestination ~= nil , "\066\082\073\078\071\032\083\069\076\069\067\084\069\068\058\032\079\078" , "\066\082\073\078\071\032\083\069\076\069\067\084\069\068" )
_v1f40472bbaea . lockPlayer , _v1f40472bbaea . lockRecord = target , rec
_v94b7adb6cdb9 . autoKillGeneration = _v94b7adb6cdb9 . autoKillGeneration + 1
local generation = _v94b7adb6cdb9 . autoKillGeneration
style ( AutoKillBtn , true , "\065\085\084\079\032\075\073\076\076\032\083\069\076\069\067\084\069\068\058\032\079\078" , "\065\085\084\079\032\075\073\076\076\032\083\069\076\069\067\084\069\068\058\032\079\070\070" )
say ( ( bringDestination and "\066\114\105\110\103" or "\065\117\116\111\032\107\105\108\108" ) .. "\032\116\097\114\103\101\116\105\110\103\032\064" .. target . Name .. "\046" )
task . spawn ( function ( )
local angle = math . random ( ) * math . pi * 2
local downedAt = nil
local successfulActivations , lastNoDamageReport = 0 , 0
local function fireAttackWeapon ( tool )
local activated , err = _vf7c4bc36ea3b . activate ( tool )
if not activated then
if _v94b7adb6cdb9 . standAttackTarget == target then
_ve76b6087628a . standStatus ( "\087\101\097\112\111\110\032\097\099\116\105\118\097\116\105\111\110\032\102\097\105\108\101\100\058\032" .. tostring ( err ) )
else
say ( "\065\117\116\111\032\107\105\108\108\058\032\119\101\097\112\111\110\032\097\099\116\105\118\097\116\105\111\110\032\102\097\105\108\101\100\058\032" .. tostring ( err ) )
end
return
end
successfulActivations = successfulActivations + 1
local now = os . clock ( )
if successfulActivations >= 10
and now - _v94b7adb6cdb9 . lastConfirmedHitAt >= 3
and now - lastNoDamageReport >= 3 then
lastNoDamageReport = now
local detail = ( "\037\100\032\115\104\111\116\115\032\115\101\110\116\059\032\110\111\032\099\111\110\102\105\114\109\101\100\032\115\101\114\118\101\114\032\100\097\109\097\103\101\032\121\101\116\046" )
: format ( successfulActivations )
if _v94b7adb6cdb9 . standAttackTarget == target then
_ve76b6087628a . standStatus ( "\065\116\116\097\099\107\058\032" .. detail )
else
say ( "\065\117\116\111\032\107\105\108\108\058\032" .. detail )
end
end
end
local function usableGun ( tool )
if not tool or not tool : IsA ( "\084\111\111\108" ) then return false end
local handle = tool : FindFirstChild ( "\072\097\110\100\108\101" )
local ammo = tool : GetAttribute ( "\065\109\109\111" )
local realAmmo = tool : GetAttribute ( "\082\101\097\108\065\109\109\111" )
if type ( ammo ) == "\110\117\109\098\101\114" and ammo <= 2 then _vf7c4bc36ea3b . requestReload ( tool ) end
return handle and handle : FindFirstChild ( "\083\104\111\111\116\070\088\071\117\105" )
and type ( tool : GetAttribute ( "\067\111\111\108\100\111\119\110" ) ) == "\110\117\109\098\101\114"
and ( type ( ammo ) ~= "\110\117\109\098\101\114" or ammo > 0 )
and ( type ( realAmmo ) ~= "\110\117\109\098\101\114" or realAmmo > 0 )
end
local snipeAnchor , snipeTargetPosition , nextSnipeMoveAt = nil , nil , 0
local function findSnipePosition ( character , root , victim )
local base = victim . root . Position
local away = root . Position - base
away = Vector3 . new ( away . X , 0 , away . Z )
if away . Magnitude < 1 then away = Vector3 . new ( 1 , 0 , 0 ) end
local direction = away . Unit
local floorParams = RaycastParams . new ( )
floorParams . FilterType = Enum . RaycastFilterType . Exclude
floorParams . FilterDescendantsInstances = { character , victim . model }
floorParams . IgnoreWater = true
for ring = 1 , 2 do
local radius = ring == 1 and 135 or 105
for step = 0 , 7 do
local theta = step * math . pi / 4
local radial = Vector3 . new (
direction . X * math . cos ( theta ) - direction . Z * math . sin ( theta ) ,
0 ,
direction . X * math . sin ( theta ) + direction . Z * math . cos ( theta ) )
local above = base + radial * radius + Vector3 . new ( 0 , 55 , 0 )
local floor = _v8b8ca6137d87 : Raycast ( above , Vector3 . new ( 0 , - 100 , 0 ) , floorParams )
if floor and floor . Instance . CanCollide and floor . Normal . Y > 0.55 then
local eye = floor . Position + Vector3 . new ( 0 , 6 , 0 )
local sight = _v8b8ca6137d87 : Raycast ( eye ,
base + Vector3 . new ( 0 , 1.5 , 0 ) - eye , floorParams )
if not sight then
local facing = CFrame . lookAt (
floor . Position + Vector3 . new ( 0 , 3 , 0 ) ,
base + Vector3 . new ( 0 , 1.5 , 0 ) )
local landing = _ve76b6087628a . safeBringLanding ( facing , character )
if landing then return landing end
end
end
end
end
return nil
end
while not _v94b7adb6cdb9 . closed and _v94b7adb6cdb9 . autoKill and generation == _v94b7adb6cdb9 . autoKillGeneration do
rec = explicitTarget and ( recordUsable ( target , rec ) and rec
or _v1f40472bbaea . resolveShotRecord ( target ) ) or Records [ target ]
_v1f40472bbaea . lockRecord = rec
if not ( explicitTarget and recordUsable ( target , rec )
or not explicitTarget and _v94b7adb6cdb9 . primary == target
and recordPresent ( target , rec ) ) then
stopAutoKill ( "\065\117\116\111\032\107\105\108\108\032\115\116\111\112\112\101\100\058\032\116\097\114\103\101\116\032\099\104\097\110\103\101\100\032\111\114\032\108\101\102\116\046" )
break
end
local effects = rec . model : FindFirstChild ( "\066\111\100\121\069\102\102\101\099\116\115" )
local ko = effects and effects : FindFirstChild ( "\075\046\079" )
local dead = effects and effects : FindFirstChild ( "\068\101\097\100" )
if dead and dead . Value and not _v94b7adb6cdb9 . killBringDestination then
stopAutoKill ( "\065\117\116\111\032\107\105\108\108\058\032\116\097\114\103\101\116\032\102\105\110\105\115\104\101\100\032\098\101\102\111\114\101\032\103\114\097\098\046" )
break
end
local character = _vad430fdb5ce8 . Character
local hum = character and character : FindFirstChildOfClass ( "\072\117\109\097\110\111\105\100" )
local root = character and character : FindFirstChild ( "\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116" )
if not hum or not root or hum . Health <= 0 then
stopAutoKill ( "\065\117\116\111\032\107\105\108\108\032\115\116\111\112\112\101\100\058\032\121\111\117\114\032\099\104\097\114\097\099\116\101\114\032\105\115\032\117\110\097\118\097\105\108\097\098\108\101\046" )
break
end
local downed = rec . humanoid . Health <= 0 or ( ko and ko . Value )
or ( dead and dead . Value )
if downed then
downedAt = downedAt or os . clock ( )
if _v94b7adb6cdb9 . standDownOnlyTarget == target then
stopAutoKill ( "\083\116\097\110\100\058\032\064" .. target . Name .. "\032\105\115\032\100\111\119\110\059\032\110\111\032\115\116\111\109\112\046" )
break
end
if _v94b7adb6cdb9 . standAttack2Target == target
and not _v94b7adb6cdb9 . standAttack2FinisherPlayed then
_v94b7adb6cdb9 . standAttack2FinisherPlayed = true
if _ve76b6087628a . standCinematicFinish then
pcall ( _ve76b6087628a . standCinematicFinish , target , generation )
end
end
if _v94b7adb6cdb9 . killBringDestination then
local destination = _v94b7adb6cdb9 . killBringDestination
local followOwner = _v94b7adb6cdb9 . bringFollowOwner
local ownerRoot = followOwner and _ve76b6087628a . standOwnerRoot ( )
if ownerRoot then destination = ownerRoot . CFrame end
local targetLower = rec . model : FindFirstChild ( "\076\111\119\101\114\084\111\114\115\111" )
local ownEffects = character : FindFirstChild ( "\066\111\100\121\069\102\102\101\099\116\115" )
local attacking = ownEffects and ownEffects : FindFirstChild ( "\065\116\116\097\099\107\105\110\103" )
local storage = _v7ab6349c26e8 : FindFirstChild ( "\083\116\111\114\097\103\101" )
local remotes = storage and storage : FindFirstChild ( "\082\101\109\111\116\101\115" )
local main = remotes and remotes : FindFirstChild ( "\077\097\105\110" )
if targetLower and main and not ( attacking and attacking . Value ) then
pcall ( function ( ) hum : UnequipTools ( ) end )
pcall ( function ( )
local away = root . Position - targetLower . Position
away = Vector3 . new ( away . X , 0 , away . Z )
if away . Magnitude < 0.1 then
away = targetLower . CFrame . LookVector
away = Vector3 . new ( away . X , 0 , away . Z )
end
if away . Magnitude < 0.1 then away = Vector3 . xAxis end
local approach = targetLower . Position + away . Unit * 2.7
+ Vector3 . new ( 0 , 2.4 , 0 )
character : PivotTo ( CFrame . lookAt ( approach ,
targetLower . Position + Vector3 . new ( 0 , 1 , 0 ) ) )
root . AssemblyLinearVelocity = Vector3 . zero
root . AssemblyAngularVelocity = Vector3 . zero
end )
task . wait ( 0.2 )
if _v94b7adb6cdb9 . autoKill and generation == _v94b7adb6cdb9 . autoKillGeneration
and _vad430fdb5ce8 . Character == character then
local ownLower = character : FindFirstChild ( "\076\111\119\101\114\084\111\114\115\111" )
if ownLower and ( ownLower . Position - targetLower . Position ) . Magnitude <= 8 then
pcall ( function ( ) main : FireServer ( "\071\114\097\098\098\105\110\103" , rec . humanoid ) end )
end
end
local grabUntil = os . clock ( ) + 0.55
while os . clock ( ) < grabUntil
and not character : FindFirstChild ( "\071\082\065\066\066\073\078\071\095\067\079\078\083\084\082\065\073\078\084" )
and _v94b7adb6cdb9 . autoKill and generation == _v94b7adb6cdb9 . autoKillGeneration
and _vad430fdb5ce8 . Character == character do task . wait ( 0.04 ) end
if character : FindFirstChild ( "\071\082\065\066\066\073\078\071\095\067\079\078\083\084\082\065\073\078\084" ) then
local latestOwnerRoot = followOwner and _ve76b6087628a . standOwnerRoot ( )
if latestOwnerRoot then destination = latestOwnerRoot . CFrame end
local landing , problem = _ve76b6087628a . safeBringLanding ( destination , character )
if not landing then
pcall ( function ( ) main : FireServer ( "\071\114\097\098\098\105\110\103" ) end )
stopAutoKill ( "\066\114\105\110\103\032\099\097\110\099\101\108\108\101\100\032\102\111\114\032\115\097\102\101\116\121\058\032" .. tostring ( problem ) )
break
end
pcall ( function ( )
root . AssemblyLinearVelocity = Vector3 . zero
root . AssemblyAngularVelocity = Vector3 . zero
character : PivotTo ( landing )
root . AssemblyLinearVelocity = Vector3 . zero
root . AssemblyAngularVelocity = Vector3 . zero
end )
pcall ( function ( ) main : FireServer ( "\071\114\097\098\098\105\110\103" ) end )
local dropUntil = os . clock ( ) + 0.75
while os . clock ( ) < dropUntil
and character : FindFirstChild ( "\071\082\065\066\066\073\078\071\095\067\079\078\083\084\082\065\073\078\084" )
and _v94b7adb6cdb9 . autoKill and generation == _v94b7adb6cdb9 . autoKillGeneration do
task . wait ( 0.05 )
end
if character : FindFirstChild ( "\071\082\065\066\066\073\078\071\095\067\079\078\083\084\082\065\073\078\084" ) then
pcall ( function ( ) main : FireServer ( "\071\114\097\098\098\105\110\103" ) end )
task . wait ( 0.2 )
end
pcall ( function ( )
root . AssemblyLinearVelocity = Vector3 . zero
root . AssemblyAngularVelocity = Vector3 . zero
end )
if character : FindFirstChild ( "\071\082\065\066\066\073\078\071\095\067\079\078\083\084\082\065\073\078\084" ) then
stopAutoKill ( "\071\114\097\098\032\099\111\110\102\105\114\109\101\100\059\032\100\114\111\112\032\110\111\116\032\099\111\110\102\105\114\109\101\100\046\032\080\114\101\115\115\032\071\032\116\111\032\114\101\108\101\097\115\101\046" , true )
else
restoreBringStompWhenClear ( target )
stopAutoKill ( "\075\105\108\108\032\043\032\098\114\105\110\103\058\032\109\111\118\101\032\053\032\115\116\117\100\115\032\097\119\097\121\032\116\111\032\114\101\115\117\109\101\032\097\117\116\111\032\115\116\111\109\112\046" , true )
end
break
end
end
if os . clock ( ) - downedAt > 6 then
stopAutoKill ( "\084\097\114\103\101\116\032\100\111\119\110\101\100\044\032\098\117\116\032\116\104\101\032\115\101\114\118\101\114\032\100\105\100\032\110\111\116\032\099\111\110\102\105\114\109\032\097\032\103\114\097\098\046" )
break
end
task . wait ( 0.12 )
continue
end
if not _v94b7adb6cdb9 . quietAutoKill or _v94b7adb6cdb9 . standAttackTarget == target then
pcall ( function ( )
character : PivotTo ( CFrame . new ( rec . root . Position + Vector3 . new ( 0 , 3 , 0 ) ) )
root . AssemblyLinearVelocity = Vector3 . zero
end )
end
local stompOk , stompSent = pcall ( autoStompTick , rec . model , true )
if _v94b7adb6cdb9 . standAttack2Target == target and stompOk and stompSent
and not _v94b7adb6cdb9 . standAttack2LaunchQueued then
_v94b7adb6cdb9 . standAttack2LaunchQueued = true
local orderGeneration = _v94b7adb6cdb9 . standOrderGeneration
task . delay ( 0.15 , function ( )
if not _v94b7adb6cdb9 . closed and orderGeneration == _v94b7adb6cdb9 . standOrderGeneration
and _ve76b6087628a . standLaunchTarget then
if _v94b7adb6cdb9 . autoKill and _v94b7adb6cdb9 . standAttack2Target == target then
stopAutoKill ( "\068\105\114\101\099\116\111\114\039\115\032\099\117\116\058\032\108\097\117\110\099\104\032\097\116\116\101\109\112\116\101\100\046" )
end
pcall ( _ve76b6087628a . standLaunchTarget , target )
end
end )
end
if os . clock ( ) - downedAt > 6 then
stopAutoKill ( "\065\117\116\111\032\107\105\108\108\058\032\116\097\114\103\101\116\032\100\111\119\110\101\100\059\032\102\105\110\105\115\104\032\119\097\115\032\110\111\116\032\099\111\110\102\105\114\109\101\100\046" )
break
end
task . wait ( 0.05 )
continue
end
downedAt = nil
local tool = character : FindFirstChildOfClass ( "\084\111\111\108" )
local distance = ( rec . root . Position - root . Position ) . Magnitude
local bag = _vad430fdb5ce8 : FindFirstChildOfClass ( "\066\097\099\107\112\097\099\107" )
if _v94b7adb6cdb9 . standAttackTarget == target and tool
and tool . Name ~= "\091\082\101\118\111\108\118\101\114\093" and bag
and usableGun ( bag : FindFirstChild ( "\091\082\101\118\111\108\118\101\114\093" ) ) then
tool = bag : FindFirstChild ( "\091\082\101\118\111\108\118\101\114\093" )
hum : EquipTool ( tool )
task . wait ( 0.08 )
end
if tool and tool . Name ~= "\091\082\101\118\111\108\118\101\114\093" and bag
and os . clock ( ) - _v94b7adb6cdb9 . lastConfirmedHitAt > 2.5
and os . clock ( ) - _v94b7adb6cdb9 . lastAdaptiveSwitchAt > 2.5
and usableGun ( bag : FindFirstChild ( "\091\082\101\118\111\108\118\101\114\093" ) ) then
_v94b7adb6cdb9 . lastAdaptiveSwitchAt = os . clock ( )
tool = bag : FindFirstChild ( "\091\082\101\118\111\108\118\101\114\093" )
hum : EquipTool ( tool )
say ( "\065\117\116\111\032\107\105\108\108\058\032\110\111\032\099\111\110\102\105\114\109\101\100\032\115\104\111\116\103\117\110\032\100\097\109\097\103\101\059\032\115\119\105\116\099\104\101\100\032\116\111\032\114\101\118\111\108\118\101\114\046" )
task . wait ( 0.08 )
end
if distance > 75 and tool and tool . Name == "\091\068\111\117\098\108\101\045\066\097\114\114\101\108\032\083\071\093"
and bag and usableGun ( bag : FindFirstChild ( "\091\082\101\118\111\108\118\101\114\093" ) ) then
tool = bag : FindFirstChild ( "\091\082\101\118\111\108\118\101\114\093" )
hum : EquipTool ( tool )
task . wait ( 0.08 )
end
if not usableGun ( tool ) then
tool = nil
if bag then
local preferred = _v94b7adb6cdb9 . standAttackTarget == target
and { "\091\082\101\118\111\108\118\101\114\093" } or distance > 75
and { "\091\082\101\118\111\108\118\101\114\093" , "\091\083\077\071\093" , "\091\068\111\117\098\108\101\045\066\097\114\114\101\108\032\083\071\093" , "\091\084\097\099\116\105\099\097\108\083\104\111\116\103\117\110\093" , "\091\083\104\111\116\103\117\110\093" }
or { "\091\068\111\117\098\108\101\045\066\097\114\114\101\108\032\083\071\093" , "\091\084\097\099\116\105\099\097\108\083\104\111\116\103\117\110\093" , "\091\083\104\111\116\103\117\110\093" , "\091\082\101\118\111\108\118\101\114\093" , "\091\083\077\071\093" }
for _ , name in ipairs ( preferred ) do
local candidate = bag : FindFirstChild ( name )
if usableGun ( candidate ) then tool = candidate ; break end
end
if not tool and _v94b7adb6cdb9 . standAttackTarget ~= target then
for _ , candidate in ipairs ( bag : GetChildren ( ) ) do
if usableGun ( candidate ) then tool = candidate ; break end
end
end
end
if not tool then
local equipped = character : FindFirstChildOfClass ( "\084\111\111\108" )
if equipped then _vf7c4bc36ea3b . requestReload ( equipped ) end
task . wait ( 0.15 )
continue
end
hum : EquipTool ( tool )
task . wait ( 0.08 )
elseif rec . root and rec . root . Parent then
angle = angle + ( _v94b7adb6cdb9 . standAttack3Target == target and 0.08
or _v94b7adb6cdb9 . standAttack5Target == target and 1.2
or 0.62 + math . random ( ) * 0.28 )
local radius = _v94b7adb6cdb9 . standAttack5Target == target and 5.5
or _v94b7adb6cdb9 . strafeRadius + ( math . random ( ) - 0.5 ) * 1.5
local jitter = Vector3 . new ( math . random ( ) - 0.5 ,
math . random ( ) * 0.8 , math . random ( ) - 0.5 )
local lead = rec . root . AssemblyLinearVelocity * 0.045
local offset = Vector3 . new ( math . cos ( angle ) * radius , 1.5 ,
math . sin ( angle ) * radius ) + jitter
local attackCFrame = CFrame . lookAt ( rec . root . Position + lead + offset ,
rec . root . Position + lead + Vector3 . new ( 0 , 1.5 , 0 ) )
if _v94b7adb6cdb9 . standAttack3Target == target then
local skyHeight = 80
local skyDistance = 120
local skyRadius = math . sqrt ( skyDistance * skyDistance
- skyHeight * skyHeight )
attackCFrame = CFrame . lookAt ( rec . root . Position + Vector3 . new (
math . cos ( angle ) * skyRadius , skyHeight ,
math . sin ( angle ) * skyRadius ) ,
rec . root . Position + Vector3 . new ( 0 , 1.5 , 0 ) )
end
if _v94b7adb6cdb9 . standSnipeTarget == target then
local needMove = not snipeAnchor
or not snipeTargetPosition
or ( rec . root . Position - snipeTargetPosition ) . Magnitude > 55
or distance < 80 or distance > 225
if needMove and os . clock ( ) >= nextSnipeMoveAt then
nextSnipeMoveAt = os . clock ( ) + 1.5
local position = findSnipePosition ( character , root , rec )
if position then
snipeAnchor = position
snipeTargetPosition = rec . root . Position
elseif not snipeAnchor then
stopAutoKill ( "\083\110\105\112\101\032\115\116\111\112\112\101\100\058\032\110\111\032\115\117\112\112\111\114\116\101\100\032\112\111\115\105\116\105\111\110\032\119\105\116\104\032\097\032\099\108\101\097\114\032\115\104\111\116\046" )
break
end
end
if snipeAnchor then
attackCFrame = CFrame . lookAt ( snipeAnchor . Position ,
rec . root . Position + Vector3 . new ( 0 , 1.5 , 0 ) )
end
end
_v94b7adb6cdb9 . aimPlayer , _v94b7adb6cdb9 . aimRecord = target , rec
_v1f40472bbaea . lockPlayer , _v1f40472bbaea . lockRecord = target , rec
_v1f40472bbaea . record , _v1f40472bbaea . part = rec , partFor ( rec )
_v1f40472bbaea . enabled = true
if ( tool : GetAttribute ( "\065\109\109\111" ) or 1 ) <= 2 then _vf7c4bc36ea3b . requestReload ( tool ) end
local rapid = _v94b7adb6cdb9 . rapidWeapons [ tool . Name ]
local cooldown = rapid and _vf7c4bc36ea3b . getPace ( tool )
or math . max ( 0.02 , tool : GetAttribute ( "\067\111\111\108\100\111\119\110" ) or 0.1 )
local lastShot = tool : GetAttribute ( "\083\104\111\116\067\111\111\108\100\111\119\110\083\116\097\114\116\101\100" ) or 0
local readyToFire = rapid
and os . clock ( ) - _vf7c4bc36ea3b . lastShotAt ( tool ) >= cooldown
or not rapid and tick ( ) - lastShot >= cooldown
if _v94b7adb6cdb9 . quietAutoKill and not _v94b7adb6cdb9 . killBringDestination then
if readyToFire then
fireAttackWeapon ( tool )
end
task . wait ( rapid and 0.02 or 0.045 )
continue
end
if readyToFire and _v94b7adb6cdb9 . autoKillVoid and not _v94b7adb6cdb9 . killBringDestination then
_v94b7adb6cdb9 . voidBlinking = true
pcall ( function ( )
character : PivotTo ( CFrame . new ( rec . root . Position . X ,
_v94b7adb6cdb9 . voidDepth , rec . root . Position . Z ) )
root . AssemblyLinearVelocity = Vector3 . zero
end )
task . wait ( _v94b7adb6cdb9 . voidDwell )
end
if _v94b7adb6cdb9 . closed or not _v94b7adb6cdb9 . autoKill or generation ~= _v94b7adb6cdb9 . autoKillGeneration
or _vad430fdb5ce8 . Character ~= character then
_v94b7adb6cdb9 . voidBlinking = false
if not _v94b7adb6cdb9 . resetInFlight then
pcall ( function ( ) character : PivotTo ( _ve76b6087628a . LastSafeCFrame or attackCFrame ) end )
end
break
end
pcall ( function ( )
character : PivotTo ( attackCFrame )
root . AssemblyLinearVelocity = Vector3 . zero
root . AssemblyAngularVelocity = Vector3 . zero
end )
_v94b7adb6cdb9 . voidBlinking = false
if readyToFire then
fireAttackWeapon ( tool )
end
task . wait ( rapid and 0.02 or 0.045 )
else
task . wait ( 0.045 )
end
end
end )
end
_ve76b6087628a . startAttackOne = function ( target , downOnly , variant , independent )
if not target or ( not independent and _v94b7adb6cdb9 . primary ~= target ) then
return false , "\083\101\108\101\099\116\032\097\032\112\108\097\121\101\114\032\111\110\032\084\065\082\071\069\084\083\032\102\105\114\115\116\046"
end
local character = _vad430fdb5ce8 . Character
local bag = _vad430fdb5ce8 : FindFirstChildOfClass ( "\066\097\099\107\112\097\099\107" )
local revolver = ( character and character : FindFirstChild ( "\091\082\101\118\111\108\118\101\114\093" ) )
or ( bag and bag : FindFirstChild ( "\091\082\101\118\111\108\118\101\114\093" ) )
if not revolver then return false , "\082\101\118\111\108\118\101\114\032\105\115\032\110\111\116\032\105\110\032\121\111\117\114\032\105\110\118\101\110\116\111\114\121\046" end
if _v94b7adb6cdb9 . autoKill then stopAutoKill ( ) end
_v94b7adb6cdb9 . standRevolverRapidBefore = _v94b7adb6cdb9 . rapidWeapons [ "\091\082\101\118\111\108\118\101\114\093" ] == true
_v94b7adb6cdb9 . standPreviousQuiet = _v94b7adb6cdb9 . quietAutoKill
_v94b7adb6cdb9 . standPreviousVoid = _v94b7adb6cdb9 . autoKillVoid
_v94b7adb6cdb9 . standEnabledRapid = not _v94b7adb6cdb9 . rapidWeapons [ "\091\082\101\118\111\108\118\101\114\093" ]
_v94b7adb6cdb9 . quietAutoKill = variant == "\097\116\116\097\099\107\052"
_v94b7adb6cdb9 . autoKillVoid = false
_v94b7adb6cdb9 . rapidWeapons [ "\091\082\101\118\111\108\118\101\114\093" ] = true
_v94b7adb6cdb9 . standAttackTarget = target
_v94b7adb6cdb9 . standDownOnlyTarget = downOnly and target or nil
_v94b7adb6cdb9 . standAttack2Target = variant == "\097\116\116\097\099\107\050" and not downOnly and target or nil
_v94b7adb6cdb9 . standAttack3Target = variant == "\097\116\116\097\099\107\051" and not downOnly and target or nil
_v94b7adb6cdb9 . standAttack4Target = variant == "\097\116\116\097\099\107\052" and not downOnly and target or nil
_v94b7adb6cdb9 . standAttack5Target = variant == "\097\116\116\097\099\107\053" and not downOnly and target or nil
_v94b7adb6cdb9 . standSnipeTarget = variant == "\115\110\105\112\101" and not downOnly and target or nil
_v94b7adb6cdb9 . standSnipeReturnCFrame = _v94b7adb6cdb9 . standSnipeTarget
and character and character : GetPivot ( ) or nil
_v94b7adb6cdb9 . standAttack2FinisherPlayed = false
_v94b7adb6cdb9 . standAttack2LaunchQueued = false
style ( _ve76b6087628a . QuietKillBtn , _v94b7adb6cdb9 . quietAutoKill ,
"\081\085\073\069\084\032\065\085\084\079\032\075\073\076\076\058\032\079\078" , "\081\085\073\069\084\032\065\085\084\079\032\075\073\076\076\058\032\079\070\070" )
style ( VoidKillBtn , false ,
"\065\085\084\079\032\075\073\076\076\032\086\079\073\068\032\066\076\073\078\075\058\032\079\078" , "\065\085\084\079\032\075\073\076\076\032\086\079\073\068\032\066\076\073\078\075\058\032\079\070\070" )
style ( ForceHitBtn , _v94b7adb6cdb9 . forceHit , "\070\079\082\067\069\032\072\073\084\058\032\079\078" , "\070\079\082\067\069\032\072\073\084\058\032\079\070\070" )
_vf7c4bc36ea3b . forEachGun ( function ( tool )
if tool . Name == "\091\082\101\118\111\108\118\101\114\093" then _vf7c4bc36ea3b . applyCooldown ( tool ) end
end )
if _vf7c4bc36ea3b . rows [ "\091\082\101\118\111\108\118\101\114\093" ] then
style ( _vf7c4bc36ea3b . rows [ "\091\082\101\118\111\108\118\101\114\093" ] , _v94b7adb6cdb9 . rapidWeapons [ "\091\082\101\118\111\108\118\101\114\093" ] ,
"\091\082\101\118\111\108\118\101\114\093\032\032\047\032\032\079\078" , "\091\082\101\118\111\108\118\101\114\093\032\032\047\032\032\079\070\070" )
end
local started , startError = pcall ( startAutoKill , nil , nil ,
independent and target or nil )
if not started or not _v94b7adb6cdb9 . autoKill then
stopAutoKill ( )
return false , started and "\084\097\114\103\101\116\032\117\110\097\118\097\105\108\097\098\108\101\046" or tostring ( startError )
end
if updateLoops then updateLoops ( ) end
return true
end
bind ( AutoKillBtn . MouseButton1Click : Connect ( function ( )
if _v94b7adb6cdb9 . autoKill then
stopAutoKill ( "\065\117\116\111\032\107\105\108\108\032\115\116\111\112\112\101\100\046" )
return
end
local target = _v94b7adb6cdb9 . primary
if not target then say ( "\083\101\108\101\099\116\032\097\032\112\108\097\121\101\114\032\111\110\032\084\065\082\071\069\084\083\032\102\105\114\115\116\046" ) ; return end
_ve76b6087628a . attackButtonGeneration = ( _ve76b6087628a . attackButtonGeneration or 0 ) + 1
local generation = _ve76b6087628a . attackButtonGeneration
task . spawn ( function ( )
if not recordPresent ( target , Records [ target ] ) then requestResolution ( target ) end
local deadline = os . clock ( ) + 3
while not _v94b7adb6cdb9 . closed and generation == _ve76b6087628a . attackButtonGeneration
and _v94b7adb6cdb9 . primary == target and not recordPresent ( target , Records [ target ] )
and os . clock ( ) < deadline do task . wait ( 0.1 ) end
if _v94b7adb6cdb9 . closed or generation ~= _ve76b6087628a . attackButtonGeneration
or _v94b7adb6cdb9 . primary ~= target then return end
local started , issue = _ve76b6087628a . startAttackOne ( target , false , "\097\116\116\097\099\107" )
if not started then say ( "\065\117\116\111\032\107\105\108\108\058\032" .. issue ) end
end )
end ) )
_ve76b6087628a . standStatus = function ( message )
_ve76b6087628a . StandStatus . Text = message
say ( "\083\116\097\110\100\058\032" .. message )
end
local AfkPreferenceFile = "\082\065\067\069\082\095\080\101\114\109\097\065\070\075\046\116\120\116"
if type ( isfile ) == "\102\117\110\099\116\105\111\110" and type ( readfile ) == "\102\117\110\099\116\105\111\110" then
local ok , stored = pcall ( function ( )
return isfile ( AfkPreferenceFile ) and readfile ( AfkPreferenceFile ) or nil
end )
if ok and ( stored == "\111\110" or stored == "\111\102\102" ) then
_v94b7adb6cdb9 . afkPermanent = stored == "\111\110"
end
elseif type ( _v5680cea30ae2 . SpectraPermanentAFK ) == "\098\111\111\108\101\097\110" then
_v94b7adb6cdb9 . afkPermanent = _v5680cea30ae2 . SpectraPermanentAFK
end
local function sendAfk ( value )
local storage = _v7ab6349c26e8 : FindFirstChild ( "\083\116\111\114\097\103\101" )
local remotes = storage and storage : FindFirstChild ( "\082\101\109\111\116\101\115" )
local main = remotes and remotes : FindFirstChild ( "\077\097\105\110" )
if not main or not main : IsA ( "\082\101\109\111\116\101\069\118\101\110\116" ) then return false end
return pcall ( function ( ) main : FireServer ( "\085\112\100\097\116\101\065\070\075" , value ) end )
end
local function setPermanentAfk ( enabled , persist )
_v94b7adb6cdb9 . afkPermanent = enabled == true
_v94b7adb6cdb9 . afkGeneration = _v94b7adb6cdb9 . afkGeneration + 1
local generation = _v94b7adb6cdb9 . afkGeneration
_v5680cea30ae2 . SpectraPermanentAFK = _v94b7adb6cdb9 . afkPermanent
style ( _ve76b6087628a . StandAfkBtn , _v94b7adb6cdb9 . afkPermanent ,
"\080\069\082\077\065\078\069\078\084\032\065\070\075\058\032\079\078" , "\080\069\082\077\065\078\069\078\084\032\065\070\075\058\032\079\070\070" )
if persist and type ( writefile ) == "\102\117\110\099\116\105\111\110" then
pcall ( writefile , AfkPreferenceFile , _v94b7adb6cdb9 . afkPermanent and "\111\110" or "\111\102\102" )
end
sendAfk ( _v94b7adb6cdb9 . afkPermanent )
if _v94b7adb6cdb9 . afkPermanent then
task . spawn ( function ( )
while not _v94b7adb6cdb9 . closed and _v94b7adb6cdb9 . afkPermanent
and generation == _v94b7adb6cdb9 . afkGeneration do
local character = _vad430fdb5ce8 . Character
local hum = character and character : FindFirstChildOfClass ( "\072\117\109\097\110\111\105\100" )
local tag = hum and hum : GetAttribute ( "\065\115\109\111\084\097\103\083\116\111\114\101\100" )
if not hum or type ( tag ) ~= "\115\116\114\105\110\103"
or not tag : find ( "\060\098\062\065\070\075\060\047\098\062" , 1 , true ) then
sendAfk ( true )
end
task . wait ( 2 )
end
end )
end
end
_ve76b6087628a . setPermanentAfk = setPermanentAfk
bind ( _ve76b6087628a . StandAfkBtn . MouseButton1Click : Connect ( function ( )
setPermanentAfk ( not _v94b7adb6cdb9 . afkPermanent , true )
_ve76b6087628a . standStatus ( _v94b7adb6cdb9 . afkPermanent and "\080\101\114\109\097\110\101\110\116\032\065\070\075\032\101\110\097\098\108\101\100\046"
or "\080\101\114\109\097\110\101\110\116\032\065\070\075\032\100\105\115\097\098\108\101\100\046" )
end ) )
bind ( _vcb684e26a41a . WindowFocused : Connect ( function ( )
if not _v94b7adb6cdb9 . afkPermanent then return end
task . delay ( 0.12 , function ( )
if not _v94b7adb6cdb9 . closed and _v94b7adb6cdb9 . afkPermanent then sendAfk ( true ) end
end )
end ) )
bind ( _vad430fdb5ce8 . CharacterAdded : Connect ( function ( )
if not _v94b7adb6cdb9 . afkPermanent then return end
task . delay ( 0.5 , function ( )
if not _v94b7adb6cdb9 . closed and _v94b7adb6cdb9 . afkPermanent then sendAfk ( true ) end
end )
end ) )
setPermanentAfk ( _v94b7adb6cdb9 . afkPermanent , false )
local TextChatService = game : GetService ( "\084\101\120\116\067\104\097\116\083\101\114\118\105\099\101" )
local StarterGui = game : GetService ( "\083\116\097\114\116\101\114\071\117\105" )
local function setChatSpy ( enabled )
local window = TextChatService : FindFirstChild ( "\067\104\097\116\087\105\110\100\111\119\067\111\110\102\105\103\117\114\097\116\105\111\110" )
local tabs = TextChatService : FindFirstChild ( "\067\104\097\110\110\101\108\084\097\098\115\067\111\110\102\105\103\117\114\097\116\105\111\110" )
local inputBar = TextChatService : FindFirstChild ( "\067\104\097\116\073\110\112\117\116\066\097\114\067\111\110\102\105\103\117\114\097\116\105\111\110" )
if enabled then
if not window then return false , "\067\104\097\116\032\119\105\110\100\111\119\032\105\115\032\117\110\097\118\097\105\108\097\098\108\101\046" end
if not _v94b7adb6cdb9 . chatSpyOriginal then
local coreOk , coreEnabled = pcall ( function ( )
return StarterGui : GetCoreGuiEnabled ( Enum . CoreGuiType . Chat )
end )
_v94b7adb6cdb9 . chatSpyOriginal = {
window = window . Enabled ,
}
if tabs then _v94b7adb6cdb9 . chatSpyOriginal . tabs = tabs . Enabled end
if inputBar then _v94b7adb6cdb9 . chatSpyOriginal . input = inputBar . Enabled end
if coreOk then _v94b7adb6cdb9 . chatSpyOriginal . core = coreEnabled end
end
local ok = pcall ( function ( )
window . Enabled = true
if tabs then tabs . Enabled = true end
if inputBar then inputBar . Enabled = true end
StarterGui : SetCoreGuiEnabled ( Enum . CoreGuiType . Chat , true )
end )
if not ok then return false , "\067\111\117\108\100\032\110\111\116\032\117\110\108\111\099\107\032\116\104\101\032\099\104\097\116\032\119\105\110\100\111\119\046" end
_v94b7adb6cdb9 . chatSpy = true
else
_v94b7adb6cdb9 . chatSpy = false
local previous = _v94b7adb6cdb9 . chatSpyOriginal
_v94b7adb6cdb9 . chatSpyOriginal = nil
if previous then
pcall ( function ( )
if window then window . Enabled = previous . window end
if tabs and previous . tabs ~= nil then tabs . Enabled = previous . tabs end
if inputBar and previous . input ~= nil then inputBar . Enabled = previous . input end
if previous . core ~= nil then
StarterGui : SetCoreGuiEnabled ( Enum . CoreGuiType . Chat , previous . core )
end
end )
end
end
style ( _ve76b6087628a . ChatSpyBtn , _v94b7adb6cdb9 . chatSpy , "\067\072\065\084\032\083\080\089\058\032\079\078" , "\067\072\065\084\032\083\080\089\058\032\079\070\070" )
return true
end
_ve76b6087628a . setChatSpy = setChatSpy
bind ( _ve76b6087628a . ChatSpyBtn . MouseButton1Click : Connect ( function ( )
local ok , reason = setChatSpy ( not _v94b7adb6cdb9 . chatSpy )
_ve76b6087628a . standStatus ( ok and ( _v94b7adb6cdb9 . chatSpy
and "\067\104\097\116\032\119\105\110\100\111\119\032\117\110\108\111\099\107\101\100\032\102\111\114\032\109\101\115\115\097\103\101\115\032\100\101\108\105\118\101\114\101\100\032\116\111\032\121\111\117\114\032\099\108\105\101\110\116\046"
or "\067\104\097\116\032\119\105\110\100\111\119\032\114\101\115\116\111\114\101\100\046" ) or reason )
end ) )
_ve76b6087628a . jumpBypassConnection = nil
_ve76b6087628a . jumpBypassInputConnection = nil
local function disconnectJumpBypass ( )
if _ve76b6087628a . jumpBypassConnection then
_ve76b6087628a . jumpBypassConnection : Disconnect ( )
_ve76b6087628a . jumpBypassConnection = nil
end
if _ve76b6087628a . jumpBypassInputConnection then
_ve76b6087628a . jumpBypassInputConnection : Disconnect ( )
_ve76b6087628a . jumpBypassInputConnection = nil
end
end
local function attachJumpBypass ( character )
_v94b7adb6cdb9 . jumpBypassGeneration = _v94b7adb6cdb9 . jumpBypassGeneration + 1
local generation = _v94b7adb6cdb9 . jumpBypassGeneration
disconnectJumpBypass ( )
if not _v94b7adb6cdb9 . jumpBypass then return end
task . spawn ( function ( )
local hum = character and character : WaitForChild ( "\072\117\109\097\110\111\105\100" , 5 )
if not hum then return end
for _ = 1 , 40 do
if _v94b7adb6cdb9 . closed or not _v94b7adb6cdb9 . jumpBypass or generation ~= _v94b7adb6cdb9 . jumpBypassGeneration
or _vad430fdb5ce8 . Character ~= character then return end
local flags = nil
local ok , connections = pcall ( getconnections , hum . Jumping )
if ok then
for _ , connection in ipairs ( connections ) do
if type ( connection . Function ) == "\102\117\110\099\116\105\111\110" then
local readOk , upvalues = pcall ( debug . getupvalues ,
connection . Function )
if readOk and type ( upvalues ) == "\116\097\098\108\101" then
for _ , value in pairs ( upvalues ) do
if type ( value ) == "\116\097\098\108\101"
and type ( value . NoJumping ) == "\098\111\111\108\101\097\110"
and type ( value . HighJump ) == "\098\111\111\108\101\097\110" then
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
flags . NoJumping = false
_ve76b6087628a . jumpBypassInputConnection = _vcb684e26a41a . JumpRequest : Connect ( function ( )
if _v94b7adb6cdb9 . closed or not _v94b7adb6cdb9 . jumpBypass
or generation ~= _v94b7adb6cdb9 . jumpBypassGeneration
or _vad430fdb5ce8 . Character ~= character or _vcb684e26a41a : GetFocusedTextBox ( ) then return end
if hum . Health <= 0 or hum . Sit
or hum . FloorMaterial == Enum . Material . Air
or not hum : GetStateEnabled ( Enum . HumanoidStateType . Jumping ) then return end
flags . NoJumping = false
hum . Jump = true
end )
_ve76b6087628a . jumpBypassConnection = hum . Jumping : Connect ( function ( jumping )
if not jumping or _v94b7adb6cdb9 . closed or not _v94b7adb6cdb9 . jumpBypass
or generation ~= _v94b7adb6cdb9 . jumpBypassGeneration then return end
flags . NoJumping = false
task . defer ( function ( )
if not _v94b7adb6cdb9 . closed and _v94b7adb6cdb9 . jumpBypass
and generation == _v94b7adb6cdb9 . jumpBypassGeneration then
flags . NoJumping = false
end
end )
end )
return
end
task . wait ( 0.1 )
end
if generation == _v94b7adb6cdb9 . jumpBypassGeneration then
_v94b7adb6cdb9 . jumpBypass = false
style ( _ve76b6087628a . JumpBypassBtn , false ,
"\074\085\077\080\032\066\089\080\065\083\083\058\032\079\078" , "\074\085\077\080\032\066\089\080\065\083\083\058\032\079\070\070" )
_ve76b6087628a . standStatus ( "\074\117\109\112\032\098\121\112\097\115\115\032\117\110\097\118\097\105\108\097\098\108\101\058\032\103\097\109\101\032\108\105\109\105\116\101\114\032\119\097\115\032\110\111\116\032\102\111\117\110\100\046" )
end
end )
end
bind ( _ve76b6087628a . JumpBypassBtn . MouseButton1Click : Connect ( function ( )
_v94b7adb6cdb9 . jumpBypass = not _v94b7adb6cdb9 . jumpBypass
style ( _ve76b6087628a . JumpBypassBtn , _v94b7adb6cdb9 . jumpBypass ,
"\074\085\077\080\032\066\089\080\065\083\083\058\032\079\078" , "\074\085\077\080\032\066\089\080\065\083\083\058\032\079\070\070" )
attachJumpBypass ( _vad430fdb5ce8 . Character )
_ve76b6087628a . standStatus ( _v94b7adb6cdb9 . jumpBypass
and "\074\117\109\112\032\098\121\112\097\115\115\032\111\110\058\032\110\111\114\109\097\108\032\103\114\111\117\110\100\101\100\032\106\117\109\112\115\032\119\105\116\104\111\117\116\032\116\104\101\032\115\104\111\114\116\032\108\111\099\107\111\117\116\046"
or "\074\117\109\112\032\098\121\112\097\115\115\032\111\102\102\059\032\116\104\101\032\103\097\109\101\039\115\032\106\117\109\112\032\108\105\109\105\116\032\105\115\032\097\099\116\105\118\101\032\097\103\097\105\110\046" )
end ) )
bind ( _vad430fdb5ce8 . CharacterAdded : Connect ( function ( character )
if _v94b7adb6cdb9 . jumpBypass then attachJumpBypass ( character ) end
end ) )
_ve76b6087628a . standResolvePlayer = function ( query )
query = ( query or "" ) : match ( "\094\037\115\042\040\046\045\041\037\115\042\036" )
query = query : gsub ( "\094\064" , "" ) : gsub ( "\094\037\040\040\046\045\041\037\041\036" , "\037\049" )
: gsub ( "\094\034\040\046\045\041\034\036" , "\037\049" )
query = string . lower ( query )
if query == "" then return nil , "\069\110\116\101\114\032\097\032\112\108\097\121\101\114\032\110\097\109\101\046" end
local exactName , exactDisplay , matches = nil , nil , { }
for _ , player in ipairs ( _vcd60f2e5219a : GetPlayers ( ) ) do
if player ~= _vad430fdb5ce8 then
local name = string . lower ( player . Name )
local display = string . lower ( player . DisplayName )
if name == query then exactName = player end
if display == query then exactDisplay = player end
if name : sub ( 1 , # query ) == query
or display : sub ( 1 , # query ) == query then
matches [ # matches + 1 ] = player
end
end
end
if exactName then return exactName end
if exactDisplay then return exactDisplay end
if # matches == 1 then return matches [ 1 ] end
if # matches > 1 then return nil , "\078\097\109\101\032\109\097\116\099\104\101\115\032\115\101\118\101\114\097\108\032\112\108\097\121\101\114\115\059\032\116\121\112\101\032\109\111\114\101\046" end
return nil , "\078\111\032\112\108\097\121\101\114\032\109\097\116\099\104\101\115\032\116\104\097\116\032\110\097\109\101\046"
end
_ve76b6087628a . standResolveTarget = function ( sender , query )
local alias = string . lower ( ( query or "" ) : match ( "\094\037\115\042\040\046\045\041\037\115\042\036" ) )
if alias == "\109\101" or alias == "\109\121\115\101\108\102" or alias == "\111\119\110\101\114" then
return sender
end
return _ve76b6087628a . standResolvePlayer ( query )
end
_ve76b6087628a . standOwnerRoot = function ( )
local owner = _v94b7adb6cdb9 . standOwner
if not owner or owner . Parent ~= _vcd60f2e5219a then return nil end
local model = owner . Character
if not model or not model : FindFirstChild ( "\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116" ) then
model = candidateNamed ( _v8b8ca6137d87 , owner )
if not model then
for folder in pairs ( Folders ) do
model = candidateNamed ( folder , owner )
if model then break end
end
end
end
return model and model : FindFirstChild ( "\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116" )
end
_ve76b6087628a . standMoveToOwner = function ( )
local targetRoot = _ve76b6087628a . standOwnerRoot ( )
local character = _vad430fdb5ce8 . Character
local root = character and character : FindFirstChild ( "\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116" )
local hum = character and character : FindFirstChildOfClass ( "\072\117\109\097\110\111\105\100" )
if not targetRoot or not root or not hum or hum . Health <= 0 then return false end
pcall ( function ( )
character : PivotTo ( targetRoot . CFrame * CFrame . new ( 2.5 , 0 , 3.5 ) )
root . AssemblyLinearVelocity = Vector3 . zero
end )
return true
end
_ve76b6087628a . standTargetRoot = function ( player )
if not player or player . Parent ~= _vcd60f2e5219a then return nil end
local rec = Records [ player ]
if rec and rec . root and rec . root . Parent then return rec . root end
local model = player . Character
if not model or not model : FindFirstChild ( "\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116" ) then
model = candidateNamed ( _v8b8ca6137d87 , player )
if not model then
for folder in pairs ( Folders ) do
model = candidateNamed ( folder , player )
if model then break end
end
end
end
return model and model : FindFirstChild ( "\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116" )
end
_ve76b6087628a . standCancelFling = function ( )
_v94b7adb6cdb9 . standFlingGeneration = _v94b7adb6cdb9 . standFlingGeneration + 1
_v94b7adb6cdb9 . standFlinging = false
if _v94b7adb6cdb9 . standFlingMover then
pcall ( function ( ) _v94b7adb6cdb9 . standFlingMover : Destroy ( ) end )
_v94b7adb6cdb9 . standFlingMover = nil
end
local restore = _v94b7adb6cdb9 . standFlingRestore
_v94b7adb6cdb9 . standFlingRestore = nil
if restore then pcall ( restore ) end
end
_ve76b6087628a . standEndCinematic = function ( )
local restore = _v94b7adb6cdb9 . standCinematicRestore
_v94b7adb6cdb9 . standCinematicRestore = nil
if restore then pcall ( restore ) end
end
_ve76b6087628a . standCinematicIntro = function ( target , generation )
local character = _vad430fdb5ce8 . Character
local root = character and character : FindFirstChild ( "\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116" )
local hum = character and character : FindFirstChildOfClass ( "\072\117\109\097\110\111\105\100" )
if not root or not hum or hum . Health <= 0 then return false end
local targetRoot = _ve76b6087628a . standTargetRoot ( target )
if not targetRoot then return false end
local previousSpeed = hum . WalkSpeed
_v94b7adb6cdb9 . standCinematicRestore = function ( )
if hum . Parent then
hum . WalkSpeed = previousSpeed
if root . Parent then hum : MoveTo ( root . Position ) end
end
end
local direction = root . Position - targetRoot . Position
if direction . Magnitude < 1 then direction = - targetRoot . CFrame . LookVector end
direction = direction . Unit
local staging = targetRoot . Position + direction * 70 + Vector3 . new ( 0 , 0.5 , 0 )
pcall ( function ( )
character : PivotTo ( CFrame . lookAt ( staging , targetRoot . Position ) )
root . AssemblyLinearVelocity = Vector3 . zero
end )
hum . WalkSpeed = math . max ( previousSpeed , 72 )
local started = os . clock ( )
local greeted = false
local greetingAt = nil
while os . clock ( ) - started < 4 do
if _v94b7adb6cdb9 . closed or not _v94b7adb6cdb9 . standEnabled
or generation ~= _v94b7adb6cdb9 . standOrderGeneration
or _vad430fdb5ce8 . Character ~= character or hum . Health <= 0 then
_ve76b6087628a . standEndCinematic ( )
return false
end
targetRoot = _ve76b6087628a . standTargetRoot ( target )
if not targetRoot then
_ve76b6087628a . standEndCinematic ( )
return false
end
local distance = ( root . Position - targetRoot . Position ) . Magnitude
if distance <= 15 and not greeted then
greeted = true
greetingAt = os . clock ( )
task . spawn ( function ( )
local chat = game : GetService ( "\084\101\120\116\067\104\097\116\083\101\114\118\105\099\101" )
local channels = chat : FindFirstChild ( "\084\101\120\116\067\104\097\110\110\101\108\115" )
local general = channels and channels : FindFirstChild ( "\082\066\088\071\101\110\101\114\097\108" )
if general then pcall ( function ( ) general : SendAsync ( "\104\101\121\121\121" ) end ) end
end )
end
if distance <= 7 then break end
local toward = targetRoot . Position - root . Position
local flat = Vector3 . new ( toward . X , 0 , toward . Z )
if flat . Magnitude > 7 then
local step = math . min ( 4.5 , flat . Magnitude - 7 )
local nextPosition = root . Position + flat . Unit * step
hum : Move ( flat . Unit , false )
hum : MoveTo ( targetRoot . Position + direction * 3 )
character : PivotTo ( CFrame . lookAt ( nextPosition ,
Vector3 . new ( targetRoot . Position . X , nextPosition . Y , targetRoot . Position . Z ) ) )
end
task . wait ( 0.055 )
end
hum : Move ( Vector3 . zero , false )
if not greeted then
greetingAt = os . clock ( )
task . spawn ( function ( )
local chat = game : GetService ( "\084\101\120\116\067\104\097\116\083\101\114\118\105\099\101" )
local channels = chat : FindFirstChild ( "\084\101\120\116\067\104\097\110\110\101\108\115" )
local general = channels and channels : FindFirstChild ( "\082\066\088\071\101\110\101\114\097\108" )
if general then pcall ( function ( ) general : SendAsync ( "\104\101\121\121\121" ) end ) end
end )
end
if greetingAt then
while os . clock ( ) - greetingAt < 0.45 do
if _v94b7adb6cdb9 . closed or not _v94b7adb6cdb9 . standEnabled
or generation ~= _v94b7adb6cdb9 . standOrderGeneration
or _vad430fdb5ce8 . Character ~= character or hum . Health <= 0 then
_ve76b6087628a . standEndCinematic ( )
return false
end
task . wait ( 0.05 )
end
end
_ve76b6087628a . standEndCinematic ( )
return _v94b7adb6cdb9 . standEnabled and generation == _v94b7adb6cdb9 . standOrderGeneration
end
_ve76b6087628a . standCinematicFinish = function ( target , generation )
local character = _vad430fdb5ce8 . Character
local root = character and character : FindFirstChild ( "\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116" )
local targetRoot = _ve76b6087628a . standTargetRoot ( target )
if root and targetRoot and _v94b7adb6cdb9 . autoKill
and generation == _v94b7adb6cdb9 . autoKillGeneration then
pcall ( function ( )
character : PivotTo ( CFrame . new (
targetRoot . Position + Vector3 . new ( 0 , 3 , 0 ) ) )
root . AssemblyLinearVelocity = Vector3 . zero
end )
end
end
_ve76b6087628a . standLaunchTarget = function ( target )
local targetRoot = _ve76b6087628a . standTargetRoot ( target )
if not targetRoot then return end
local model = targetRoot . Parent
local effects = model and model : FindFirstChild ( "\066\111\100\121\069\102\102\101\099\116\115" )
local ko = effects and effects : FindFirstChild ( "\075\046\079" )
local dead = effects and effects : FindFirstChild ( "\068\101\097\100" )
local hum = model and model : FindFirstChildOfClass ( "\072\117\109\097\110\111\105\100" )
if not ( ( ko and ko . Value ) or ( dead and dead . Value )
or ( hum and hum . Health <= 0 ) ) then return end
local ok , owns = pcall ( isnetworkowner , targetRoot )
if ok and owns then
pcall ( function ( )
targetRoot . AssemblyLinearVelocity = Vector3 . new ( 0 , 280 , 0 )
targetRoot : ApplyImpulse ( Vector3 . new ( 0 ,
targetRoot . AssemblyMass * 350 , 0 ) )
end )
else
task . spawn ( function ( )
for _ = 1 , 18 do
if _v94b7adb6cdb9 . closed or not model . Parent then return end
pcall ( function ( )
model : PivotTo ( model : GetPivot ( ) + Vector3 . new ( 0 , 14 , 0 ) )
end )
task . wait ( 0.03 )
end
end )
end
end
_ve76b6087628a . standReleaseHold = function ( )
local restore = _v94b7adb6cdb9 . standHoldRestore
_v94b7adb6cdb9 . standHoldRestore = nil
if restore then pcall ( restore ) end
end
_ve76b6087628a . standStop = function ( message )
_ve76b6087628a . standEndCinematic ( )
_ve76b6087628a . standCancelFling ( )
_ve76b6087628a . standReleaseHold ( )
_v94b7adb6cdb9 . standFollow = false
_v94b7adb6cdb9 . standFollowGeneration = _v94b7adb6cdb9 . standFollowGeneration + 1
_v94b7adb6cdb9 . standOrderGeneration = _v94b7adb6cdb9 . standOrderGeneration + 1
if _v94b7adb6cdb9 . autoKill then stopAutoKill ( ) end
if message then _ve76b6087628a . standStatus ( message ) end
end
_ve76b6087628a . standStartFling = function ( target )
_ve76b6087628a . standStop ( )
local character = _vad430fdb5ce8 . Character
local root = character and character : FindFirstChild ( "\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116" )
local hum = character and character : FindFirstChildOfClass ( "\072\117\109\097\110\111\105\100" )
local targetRoot = target and _ve76b6087628a . standTargetRoot ( target )
if not root or not hum or hum . Health <= 0 or ( target and not targetRoot ) then
_ve76b6087628a . standStatus ( "\070\108\105\110\103\032\110\101\101\100\115\032\097\032\108\105\118\101\032\099\104\097\114\097\099\116\101\114\032\097\110\100\032\116\097\114\103\101\116\032\114\105\103\046" )
return
end
local originalCFrame = character : GetPivot ( )
local originalCollision = root . CanCollide
local originalAutoRotate = hum . AutoRotate
_v94b7adb6cdb9 . standFlingRestore = function ( )
if root . Parent then
root . CanCollide = originalCollision
root . AssemblyAngularVelocity = Vector3 . zero
root . AssemblyLinearVelocity = Vector3 . zero
end
if hum . Parent then hum . AutoRotate = originalAutoRotate end
if _vad430fdb5ce8 . Character == character and hum . Health > 0 and not _v94b7adb6cdb9 . resetInFlight then
character : PivotTo ( originalCFrame )
end
end
_v94b7adb6cdb9 . standFlinging = true
_v94b7adb6cdb9 . standFlingGeneration = _v94b7adb6cdb9 . standFlingGeneration + 1
local generation = _v94b7adb6cdb9 . standFlingGeneration
_ve76b6087628a . standStatus ( target and ( "\070\108\105\110\103\105\110\103\032\064" .. target . Name .. "\046" )
or "\083\112\105\110\110\105\110\103\032\105\110\032\112\108\097\099\101\046" )
task . spawn ( function ( )
local attempts = 0
local flung = false
local ok , err = pcall ( function ( )
while not _v94b7adb6cdb9 . closed and _v94b7adb6cdb9 . standEnabled and _v94b7adb6cdb9 . standFlinging
and generation == _v94b7adb6cdb9 . standFlingGeneration
and _vad430fdb5ce8 . Character == character and hum . Health > 0
and ( not target or target . Parent == _vcd60f2e5219a ) do
local targetPart = target and _ve76b6087628a . standTargetRoot ( target )
if target and not targetPart then
_ve76b6087628a . standStatus ( "\087\097\105\116\105\110\103\032\102\111\114\032\064" .. target . Name .. "\032\116\111\032\114\101\115\112\097\119\110\032\102\111\114\032\102\108\105\110\103\046" )
task . wait ( 0.4 )
else
attempts = attempts + 1
local started = os . clock ( )
local launchPosition = targetPart and targetPart . Position
local launched = false
if target then
_ve76b6087628a . standStatus ( "\070\108\105\110\103\105\110\103\032\064" .. target . Name
.. "\032\040\097\116\116\101\109\112\116\032" .. attempts .. "\041\046" )
end
while not _v94b7adb6cdb9 . closed and _v94b7adb6cdb9 . standEnabled and _v94b7adb6cdb9 . standFlinging
and generation == _v94b7adb6cdb9 . standFlingGeneration
and _vad430fdb5ce8 . Character == character and hum . Health > 0
and os . clock ( ) - started < ( target and 0.85 or 2.5 ) do
targetPart = target and _ve76b6087628a . standTargetRoot ( target )
if target and not targetPart then break end
local elapsed = os . clock ( ) - started
local angle = elapsed * 35
local center = targetPart and targetPart . Position or originalCFrame . Position
local offset = targetPart and Vector3 . new (
math . cos ( angle ) * 0.55 , 0.2 , math . sin ( angle ) * 0.55 )
or Vector3 . zero
root . CanCollide = true
hum . AutoRotate = false
character : PivotTo ( CFrame . new ( center + offset )
* CFrame . Angles ( 0 , angle , 0 ) )
root . AssemblyAngularVelocity = Vector3 . new ( 0 , 2400 , 0 )
root . AssemblyLinearVelocity = targetPart
and Vector3 . new ( - math . cos ( angle ) * 220 , 105 ,
- math . sin ( angle ) * 220 )
or Vector3 . new ( 0 , 25 , 0 )
if targetPart and elapsed >= 0.15 then
local ownerOk , ownsTarget = pcall ( isnetworkowner , targetPart )
if ownerOk and ownsTarget then
local away = targetPart . Position - originalCFrame . Position
away = Vector3 . new ( away . X , 0 , away . Z )
if away . Magnitude < 0.1 then
away = targetPart . CFrame . LookVector
away = Vector3 . new ( away . X , 0 , away . Z )
end
if away . Magnitude < 0.1 then away = Vector3 . xAxis end
local velocity = away . Unit * 320 + Vector3 . new ( 0 , 220 , 0 )
if not launched then
local mover = Instance . new ( "\066\111\100\121\086\101\108\111\099\105\116\121" )
mover . Name = "\083\112\101\099\116\114\097\083\116\097\110\100\070\108\105\110\103"
mover . MaxForce = Vector3 . new ( 1e9 , 1e9 , 1e9 )
mover . P = 125000
mover . Velocity = velocity
mover . Parent = targetPart
_v94b7adb6cdb9 . standFlingMover = mover
launched = true
elseif _v94b7adb6cdb9 . standFlingMover then
_v94b7adb6cdb9 . standFlingMover . Velocity = velocity
end
targetPart . AssemblyLinearVelocity = velocity
targetPart : ApplyImpulse ( velocity * targetPart . AssemblyMass )
local model = targetPart . Parent
if model and model : IsA ( "\077\111\100\101\108" ) then
for _ , part in ipairs ( model : GetChildren ( ) ) do
if part : IsA ( "\066\097\115\101\080\097\114\116" ) and part ~= targetPart
and not part . Anchored then
part . AssemblyLinearVelocity = velocity
end
end
end
end
end
task . wait ( 0.03 )
end
if not target then break end
task . wait ( 0.25 )
targetPart = _ve76b6087628a . standTargetRoot ( target )
if targetPart and launchPosition and launched then
local delta = targetPart . Position - launchPosition
flung = delta . Y >= 20 or delta . Magnitude >= 45
end
if _v94b7adb6cdb9 . standFlingMover then
pcall ( function ( ) _v94b7adb6cdb9 . standFlingMover : Destroy ( ) end )
_v94b7adb6cdb9 . standFlingMover = nil
end
if flung then break end
task . wait ( 0.2 )
end
end
end )
if generation == _v94b7adb6cdb9 . standFlingGeneration then
_ve76b6087628a . standCancelFling ( )
_ve76b6087628a . standStatus ( not ok and ( "\070\108\105\110\103\032\115\116\111\112\112\101\100\058\032" .. tostring ( err ) )
or ( target and flung
and ( "\064" .. target . Name .. "\032\102\108\117\110\103\032\097\102\116\101\114\032" .. attempts
.. ( attempts == 1 and "\032\097\116\116\101\109\112\116\046" or "\032\097\116\116\101\109\112\116\115\046" ) )
or ( target and "\070\108\105\110\103\032\115\116\111\112\112\101\100\059\032\116\097\114\103\101\116\032\108\101\102\116\032\111\114\032\099\104\097\114\097\099\116\101\114\032\114\101\115\101\116\046"
or "\083\112\105\110\032\102\105\110\105\115\104\101\100\059\032\112\111\115\105\116\105\111\110\032\114\101\115\116\111\114\101\100\046" ) ) )
end
end )
end
_ve76b6087628a . standSetOwner = function ( owner )
if not owner or owner == _vad430fdb5ce8 or owner . Parent ~= _vcd60f2e5219a then
_ve76b6087628a . standStatus ( "\067\104\111\111\115\101\032\097\110\111\116\104\101\114\032\112\108\097\121\101\114\032\097\115\032\111\119\110\101\114\046" )
return
end
_ve76b6087628a . standStop ( )
if _v94b7adb6cdb9 . standOwnerChatConnection then
_v94b7adb6cdb9 . standOwnerChatConnection : Disconnect ( )
_v94b7adb6cdb9 . standOwnerChatConnection = nil
end
_v94b7adb6cdb9 . standOwner = owner
_v5680cea30ae2 . SpectraStandOwnerUserId = owner . UserId
_ve76b6087628a . StandOwnerLabel . Text = "\079\119\110\101\114\058\032\064" .. owner . Name .. "\032\040" .. owner . DisplayName .. "\041"
_ve76b6087628a . StandOwnerInput . Text = owner . Name
_v94b7adb6cdb9 . standOwnerChatConnection = owner . Chatted : Connect ( function ( message )
if _ve76b6087628a . standHandleChat then _ve76b6087628a . standHandleChat ( owner , message ) end
end )
_ve76b6087628a . standStatus ( "\079\119\110\101\114\032\115\101\116\032\116\111\032\064" .. owner . Name .. "\046\032\069\110\097\098\108\101\032\076\105\115\116\101\110\046" )
end
_ve76b6087628a . standHandleChat = function ( sender , message )
if _v94b7adb6cdb9 . closed or not _v94b7adb6cdb9 . standEnabled or sender ~= _v94b7adb6cdb9 . standOwner
or type ( message ) ~= "\115\116\114\105\110\103" then return end
local command , argument = message : match ( "\094\037\115\042\033\040\037\119\043\041\037\115\042\040\046\045\041\037\115\042\036" )
if not command then return end
command = string . lower ( command )
local signature = tostring ( sender . UserId ) .. "\058" .. message
local now = os . clock ( )
if _v94b7adb6cdb9 . standLastCommand == signature and now - _v94b7adb6cdb9 . standLastCommandAt < 0.35 then return end
_v94b7adb6cdb9 . standLastCommand , _v94b7adb6cdb9 . standLastCommandAt = signature , now
if command == "\115\116\111\112" then
_ve76b6087628a . standStop ( "\083\116\111\112\112\101\100\032\098\121\032\111\119\110\101\114\046" )
elseif command == "\104\101\108\112" then
local topic = string . lower ( argument or "" )
_ve76b6087628a . standStatus ( topic == "\097\116\116\097\099\107"
and "\033\097\116\116\097\099\107\044\032\033\097\116\116\097\099\107\050\045\053\044\032\033\115\110\105\112\101\032\060\110\097\109\101\062\059\032\033\098\114\105\110\103\044\032\033\102\108\105\110\103\032\060\110\097\109\101\062\046"
or topic == "\103\101\097\114"
and "\033\101\113\117\105\112\032\060\119\101\097\112\111\110\062\044\032\033\117\110\101\113\117\105\112\044\032\033\114\101\108\111\097\100\044\032\033\097\102\107\032\111\110\047\111\102\102\046"
or "\033\103\111\116\111\044\032\033\098\097\099\107\044\032\033\102\097\099\101\044\032\033\102\111\108\108\111\119\044\032\033\104\111\108\100\044\032\033\114\101\108\101\097\115\101\059\032\033\104\101\108\112\032\097\116\116\097\099\107\047\103\101\097\114\046" )
elseif command == "\097\102\107" then
local option = string . lower ( ( argument or "" ) : match ( "\094\037\115\042\040\046\045\041\037\115\042\036" ) )
if option == "\111\110" or option == "\111\102\102" then
setPermanentAfk ( option == "\111\110" , true )
_ve76b6087628a . standStatus ( "\080\101\114\109\097\110\101\110\116\032\065\070\075\032" .. option .. "\046" )
else
_ve76b6087628a . standStatus ( "\085\115\101\032\033\097\102\107\032\111\110\032\111\114\032\033\097\102\107\032\111\102\102\046" )
end
elseif command == "\115\116\097\121" then
_v94b7adb6cdb9 . standFollow = false
_v94b7adb6cdb9 . standFollowGeneration = _v94b7adb6cdb9 . standFollowGeneration + 1
_ve76b6087628a . standStatus ( "\072\111\108\100\105\110\103\032\112\111\115\105\116\105\111\110\046" )
elseif command == "\099\111\109\101" then
_ve76b6087628a . standStop ( )
_ve76b6087628a . standStatus ( _ve76b6087628a . standMoveToOwner ( )
and "\077\111\118\101\100\032\116\111\032\111\119\110\101\114\046" or "\079\119\110\101\114\032\112\111\115\105\116\105\111\110\032\117\110\097\118\097\105\108\097\098\108\101\046" )
elseif command == "\102\111\108\108\111\119" then
local followTarget = nil
if argument ~= "" then
local issue
followTarget , issue = _ve76b6087628a . standResolveTarget ( sender , argument )
if not followTarget then _ve76b6087628a . standStatus ( issue ) ; return end
end
_ve76b6087628a . standStop ( )
_v94b7adb6cdb9 . standFollow = true
_v94b7adb6cdb9 . standFollowGeneration = _v94b7adb6cdb9 . standFollowGeneration + 1
local generation = _v94b7adb6cdb9 . standFollowGeneration
_ve76b6087628a . standStatus ( followTarget and "\070\111\108\108\111\119\105\110\103\032\064" .. followTarget . Name .. "\046"
or "\070\111\108\108\111\119\105\110\103\032\111\119\110\101\114\046" )
task . spawn ( function ( )
while not _v94b7adb6cdb9 . closed and _v94b7adb6cdb9 . standEnabled and _v94b7adb6cdb9 . standFollow
and generation == _v94b7adb6cdb9 . standFollowGeneration do
local targetRoot = followTarget
and _ve76b6087628a . standTargetRoot ( followTarget )
or _ve76b6087628a . standOwnerRoot ( )
local character = _vad430fdb5ce8 . Character
local root = character and character : FindFirstChild ( "\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116" )
if targetRoot and root
and ( targetRoot . Position - root . Position ) . Magnitude > 7 then
local landing = _ve76b6087628a . safeBringLanding ( targetRoot . CFrame , character )
if landing then
pcall ( function ( )
character : PivotTo ( landing )
root . AssemblyLinearVelocity = Vector3 . zero
root . AssemblyAngularVelocity = Vector3 . zero
end )
end
end
task . wait ( 0.18 )
end
end )
elseif command == "\103\111\116\111" or command == "\102\097\099\101" then
local target , issue = _ve76b6087628a . standResolveTarget ( sender , argument )
if not target then _ve76b6087628a . standStatus ( issue ) ; return end
local targetRoot = _ve76b6087628a . standTargetRoot ( target )
local character = _vad430fdb5ce8 . Character
local root = character and character : FindFirstChild ( "\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116" )
if not targetRoot or not root then
_ve76b6087628a . standStatus ( "\067\104\097\114\097\099\116\101\114\032\111\114\032\116\097\114\103\101\116\032\112\111\115\105\116\105\111\110\032\117\110\097\118\097\105\108\097\098\108\101\046" )
return
end
if command == "\102\097\099\101" then
local toward = Vector3 . new ( targetRoot . Position . X ,
root . Position . Y , targetRoot . Position . Z )
if ( toward - root . Position ) . Magnitude < 0.2 then return end
pcall ( function ( ) root . CFrame = CFrame . lookAt ( root . Position , toward ) end )
_ve76b6087628a . standStatus ( "\070\097\099\105\110\103\032\064" .. target . Name .. "\046" )
else
_ve76b6087628a . standStop ( )
local landing , reason = _ve76b6087628a . safeBringLanding ( targetRoot . CFrame , character )
if not landing then
_ve76b6087628a . standStatus ( "\071\111\116\111\032\099\097\110\099\101\108\108\101\100\058\032" .. tostring ( reason ) )
return
end
_v94b7adb6cdb9 . standReturnCFrame = character : GetPivot ( )
pcall ( function ( )
character : PivotTo ( landing )
root . AssemblyLinearVelocity = Vector3 . zero
root . AssemblyAngularVelocity = Vector3 . zero
end )
_ve76b6087628a . standStatus ( "\077\111\118\101\100\032\110\101\097\114\032\064" .. target . Name .. "\046" )
end
elseif command == "\098\097\099\107" then
local character = _vad430fdb5ce8 . Character
local root = character and character : FindFirstChild ( "\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116" )
if not root or not _v94b7adb6cdb9 . standReturnCFrame then
_ve76b6087628a . standStatus ( "\078\111\032\115\097\118\101\100\032\083\116\097\110\100\032\112\111\115\105\116\105\111\110\046" )
return
end
_ve76b6087628a . standStop ( )
local landing , reason = _ve76b6087628a . safeBringLanding ( _v94b7adb6cdb9 . standReturnCFrame , character )
if not landing then
_ve76b6087628a . standStatus ( "\066\097\099\107\032\099\097\110\099\101\108\108\101\100\058\032" .. tostring ( reason ) )
return
end
local previous = character : GetPivot ( )
pcall ( function ( )
character : PivotTo ( landing )
root . AssemblyLinearVelocity = Vector3 . zero
root . AssemblyAngularVelocity = Vector3 . zero
end )
_v94b7adb6cdb9 . standReturnCFrame = previous
_ve76b6087628a . standStatus ( "\082\101\116\117\114\110\101\100\032\116\111\032\115\097\118\101\100\032\112\111\115\105\116\105\111\110\046" )
elseif command == "\104\111\108\100" then
_ve76b6087628a . standStop ( )
local character = _vad430fdb5ce8 . Character
local root = character and character : FindFirstChild ( "\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116" )
if not root then _ve76b6087628a . standStatus ( "\067\104\097\114\097\099\116\101\114\032\117\110\097\118\097\105\108\097\098\108\101\046" ) ; return end
local wasAnchored = root . Anchored
_v94b7adb6cdb9 . standHoldRestore = function ( )
if root . Parent then root . Anchored = wasAnchored end
end
root . AssemblyLinearVelocity = Vector3 . zero
root . AssemblyAngularVelocity = Vector3 . zero
root . Anchored = true
_ve76b6087628a . standStatus ( "\072\111\108\100\105\110\103\032\112\111\115\105\116\105\111\110\059\032\033\114\101\108\101\097\115\101\032\111\114\032\033\115\116\111\112\032\116\111\032\109\111\118\101\046" )
elseif command == "\114\101\108\101\097\115\101" then
_ve76b6087628a . standReleaseHold ( )
_ve76b6087628a . standStatus ( "\080\111\115\105\116\105\111\110\032\114\101\108\101\097\115\101\100\046" )
elseif command == "\101\113\117\105\112" then
local query = string . lower ( ( argument or "" ) : match ( "\094\037\115\042\040\046\045\041\037\115\042\036" ) )
local aliases = { rev = "\091\082\101\118\111\108\118\101\114\093" , revolver = "\091\082\101\118\111\108\118\101\114\093" ,
db = "\091\068\111\117\098\108\101\045\066\097\114\114\101\108\032\083\071\093" , shotgun = "\091\083\104\111\116\103\117\110\093" ,
tac = "\091\084\097\099\116\105\099\097\108\083\104\111\116\103\117\110\093" , smg = "\091\083\077\071\093" , knife = "\091\075\110\105\102\101\093" }
local wanted = aliases [ query ] or argument
local bag = _vad430fdb5ce8 : FindFirstChildOfClass ( "\066\097\099\107\112\097\099\107" )
local character = _vad430fdb5ce8 . Character
local hum = character and character : FindFirstChildOfClass ( "\072\117\109\097\110\111\105\100" )
local tool = bag and bag : FindFirstChild ( wanted )
if not tool and bag and query ~= "" then
for _ , candidate in ipairs ( bag : GetChildren ( ) ) do
if candidate : IsA ( "\084\111\111\108" ) and candidate . Name : lower ( ) : find ( query , 1 , true ) then
tool = candidate
break
end
end
end
if not hum or not tool then
_ve76b6087628a . standStatus ( "\087\101\097\112\111\110\032\110\111\116\032\102\111\117\110\100\032\105\110\032\098\097\099\107\112\097\099\107\046" )
return
end
_ve76b6087628a . standStop ( )
hum : EquipTool ( tool )
_ve76b6087628a . standStatus ( "\069\113\117\105\112\112\101\100\032" .. tool . Name .. "\046" )
elseif command == "\117\110\101\113\117\105\112" then
_ve76b6087628a . standStop ( )
local character = _vad430fdb5ce8 . Character
local hum = character and character : FindFirstChildOfClass ( "\072\117\109\097\110\111\105\100" )
if hum then hum : UnequipTools ( ) end
_ve76b6087628a . standStatus ( "\084\111\111\108\115\032\117\110\101\113\117\105\112\112\101\100\046" )
elseif command == "\114\101\108\111\097\100" then
local character = _vad430fdb5ce8 . Character
local tool = character and character : FindFirstChildOfClass ( "\084\111\111\108" )
local storage = _v7ab6349c26e8 : FindFirstChild ( "\083\116\111\114\097\103\101" )
local remotes = storage and storage : FindFirstChild ( "\082\101\109\111\116\101\115" )
local main = remotes and remotes : FindFirstChild ( "\077\097\105\110" )
if not tool or not main then
_ve76b6087628a . standStatus ( "\069\113\117\105\112\032\097\032\103\117\110\032\098\101\102\111\114\101\032\114\101\108\111\097\100\105\110\103\046" )
return
end
pcall ( function ( ) main : FireServer ( "\082\101\108\111\097\100" , tool ) end )
_ve76b6087628a . standStatus ( "\082\101\108\111\097\100\032\114\101\113\117\101\115\116\101\100\032\102\111\114\032" .. tool . Name .. "\046" )
elseif command == "\102\108\105\110\103" or command == "\115\112\105\110" then
local target = nil
if command == "\102\108\105\110\103" and argument ~= "" then
local issue
target , issue = _ve76b6087628a . standResolveTarget ( sender , argument )
if not target then _ve76b6087628a . standStatus ( issue ) ; return end
end
_ve76b6087628a . standStartFling ( target )
elseif command == "\106\117\109\112" then
local character = _vad430fdb5ce8 . Character
local hum = character and character : FindFirstChildOfClass ( "\072\117\109\097\110\111\105\100" )
if hum and hum . Health > 0 then
hum . Sit = false
hum . Jump = true
_ve76b6087628a . standStatus ( "\074\117\109\112\105\110\103\046" )
else _ve76b6087628a . standStatus ( "\067\104\097\114\097\099\116\101\114\032\117\110\097\118\097\105\108\097\098\108\101\046" ) end
elseif command == "\115\105\116" then
_ve76b6087628a . standStop ( )
local character = _vad430fdb5ce8 . Character
local hum = character and character : FindFirstChildOfClass ( "\072\117\109\097\110\111\105\100" )
if hum and hum . Health > 0 then
hum . Sit = true
_ve76b6087628a . standStatus ( "\083\105\116\116\105\110\103\046" )
else _ve76b6087628a . standStatus ( "\067\104\097\114\097\099\116\101\114\032\117\110\097\118\097\105\108\097\098\108\101\046" ) end
elseif command == "\115\116\097\110\100" then
local character = _vad430fdb5ce8 . Character
local hum = character and character : FindFirstChildOfClass ( "\072\117\109\097\110\111\105\100" )
if hum and hum . Health > 0 then
hum . Sit = false
hum : ChangeState ( Enum . HumanoidStateType . GettingUp )
_ve76b6087628a . standStatus ( "\083\116\097\110\100\105\110\103\046" )
else _ve76b6087628a . standStatus ( "\067\104\097\114\097\099\116\101\114\032\117\110\097\118\097\105\108\097\098\108\101\046" ) end
elseif command == "\098\114\105\110\103" then
local target , issue = _ve76b6087628a . standResolvePlayer ( argument )
if not target then _ve76b6087628a . standStatus ( issue ) ; return end
if target == _v94b7adb6cdb9 . standOwner then
_ve76b6087628a . standStatus ( "\079\119\110\101\114\032\099\097\110\110\111\116\032\098\101\032\116\104\101\032\098\114\105\110\103\032\116\097\114\103\101\116\046" )
return
end
local ownerRoot = _ve76b6087628a . standOwnerRoot ( )
if not ownerRoot then
_ve76b6087628a . standStatus ( "\079\119\110\101\114\032\112\111\115\105\116\105\111\110\032\117\110\097\118\097\105\108\097\098\108\101\046" )
return
end
_ve76b6087628a . standStop ( )
if _vfc22e7e5f23c [ target ] then
_v94b7adb6cdb9 . primary = target
syncLabels ( )
else
choosePlayer ( target )
end
if _v94b7adb6cdb9 . primary ~= target then
_ve76b6087628a . standStatus ( "\067\111\117\108\100\032\110\111\116\032\115\101\108\101\099\116\032\098\114\105\110\103\032\116\097\114\103\101\116\046" )
return
end
local generation = _v94b7adb6cdb9 . standOrderGeneration
_ve76b6087628a . standStatus ( "\082\101\115\111\108\118\105\110\103\032\064" .. target . Name .. "\032\102\111\114\032\066\114\105\110\103\046" )
task . spawn ( function ( )
local deadline = os . clock ( ) + 3
while _v94b7adb6cdb9 . standEnabled and generation == _v94b7adb6cdb9 . standOrderGeneration
and _v94b7adb6cdb9 . primary == target and not recordPresent ( target , Records [ target ] )
and os . clock ( ) < deadline do
task . wait ( 0.1 )
end
if not _v94b7adb6cdb9 . standEnabled or generation ~= _v94b7adb6cdb9 . standOrderGeneration
or _v94b7adb6cdb9 . primary ~= target then return end
if not recordPresent ( target , Records [ target ] ) then
_ve76b6087628a . standStatus ( "\066\114\105\110\103\032\116\097\114\103\101\116\032\114\105\103\032\117\110\097\118\097\105\108\097\098\108\101\046" )
return
end
local latestOwnerRoot = _ve76b6087628a . standOwnerRoot ( )
if not latestOwnerRoot then
_ve76b6087628a . standStatus ( "\079\119\110\101\114\032\112\111\115\105\116\105\111\110\032\117\110\097\118\097\105\108\097\098\108\101\046" )
return
end
local ok , err = pcall ( startAutoKill , latestOwnerRoot . CFrame , _v94b7adb6cdb9 . standOwner )
_ve76b6087628a . standStatus ( ok and _v94b7adb6cdb9 . autoKill
and ( "\066\114\105\110\103\105\110\103\032\064" .. target . Name .. "\032\116\111\032\111\119\110\101\114\046" )
or ( "\066\114\105\110\103\032\099\111\117\108\100\032\110\111\116\032\115\116\097\114\116\058\032" .. tostring ( err ) ) )
end )
elseif command == "\097\116\116\097\099\107" or command == "\097\116\116\097\099\107\050" or command == "\097\116\116\097\099\107\051"
or command == "\097\116\116\097\099\107\052" or command == "\097\116\116\097\099\107\053" or command == "\115\110\105\112\101" then
local target , issue = _ve76b6087628a . standResolveTarget ( sender , argument )
if not target then _ve76b6087628a . standStatus ( issue ) ; return end
local ownerDownOnly = false
local bag = _vad430fdb5ce8 : FindFirstChildOfClass ( "\066\097\099\107\112\097\099\107" )
local character = _vad430fdb5ce8 . Character
local revolver = ( character and character : FindFirstChild ( "\091\082\101\118\111\108\118\101\114\093" ) )
or ( bag and bag : FindFirstChild ( "\091\082\101\118\111\108\118\101\114\093" ) )
if not revolver then
_ve76b6087628a . standStatus ( "\082\101\118\111\108\118\101\114\032\105\115\032\110\111\116\032\105\110\032\121\111\117\114\032\105\110\118\101\110\116\111\114\121\046" )
return
end
_ve76b6087628a . standStop ( )
local generation = _v94b7adb6cdb9 . standOrderGeneration
_ve76b6087628a . standStatus ( "\082\101\115\111\108\118\105\110\103\032\064" .. target . Name .. "\032\102\111\114\032\097\116\116\097\099\107\046" )
task . spawn ( function ( )
local deadline = os . clock ( ) + 3
local attackRecord = _v1f40472bbaea . resolveShotRecord ( target )
while _v94b7adb6cdb9 . standEnabled and generation == _v94b7adb6cdb9 . standOrderGeneration
and not recordUsable ( target , attackRecord )
and os . clock ( ) < deadline do
task . wait ( 0.1 )
attackRecord = _v1f40472bbaea . resolveShotRecord ( target )
end
if not _v94b7adb6cdb9 . standEnabled or generation ~= _v94b7adb6cdb9 . standOrderGeneration then return end
if not recordUsable ( target , attackRecord ) then
_ve76b6087628a . standStatus ( "\084\097\114\103\101\116\032\114\105\103\032\117\110\097\118\097\105\108\097\098\108\101\059\032\097\116\116\097\099\107\032\099\097\110\099\101\108\108\101\100\046" )
return
end
if command == "\097\116\116\097\099\107\050" then
_ve76b6087628a . standStatus ( "\065\116\116\097\099\107\050\058\032\114\117\110\110\105\110\103\032\105\110\032\111\110\032\064" .. target . Name .. "\046" )
local played , completed = pcall (
_ve76b6087628a . standCinematicIntro , target , generation )
if not played or not completed then
_ve76b6087628a . standEndCinematic ( )
if generation == _v94b7adb6cdb9 . standOrderGeneration then
_ve76b6087628a . standStatus ( "\067\105\110\101\109\097\116\105\099\032\099\097\110\099\101\108\108\101\100\059\032\116\097\114\103\101\116\032\117\110\097\118\097\105\108\097\098\108\101\046" )
end
return
end
end
_ve76b6087628a . standStatus ( ( command == "\115\110\105\112\101" and "\084\097\107\105\110\103\032\097\032\115\110\105\112\101\114\032\112\111\115\105\116\105\111\110\032\102\111\114\032\064"
or "\083\116\097\114\116\105\110\103\032\065\117\116\111\032\075\105\108\108\032\111\110\032\064" ) .. target . Name .. "\046" )
local started , startError = _ve76b6087628a . startAttackOne (
target , ownerDownOnly , command , true )
if not started then
_ve76b6087628a . standStatus ( "\065\117\116\111\032\075\105\108\108\032\101\114\114\111\114\058\032" .. tostring ( startError ) )
return
end
if _v94b7adb6cdb9 . autoKill then
_ve76b6087628a . standStatus ( ownerDownOnly
and ( "\065\116\116\097\099\107\105\110\103\032\111\119\110\101\114\032\064" .. target . Name .. "\059\032\115\116\111\112\032\111\110\032\100\111\119\110\044\032\110\111\032\115\116\111\109\112\046" )
or command == "\097\116\116\097\099\107\051"
and ( "\083\107\121\032\097\116\116\097\099\107\032\111\110\032\064" .. target . Name .. "\059\032\100\101\115\099\101\110\100\032\116\111\032\115\116\111\109\112\032\111\110\032\100\111\119\110\046" )
or command == "\097\116\116\097\099\107\052"
and ( "\083\116\097\116\105\111\110\097\114\121\032\097\116\116\097\099\107\032\111\110\032\064" .. target . Name .. "\059\032\102\105\110\105\115\104\032\111\110\032\100\111\119\110\046" )
or command == "\097\116\116\097\099\107\053"
and ( "\084\105\103\104\116\032\111\114\098\105\116\032\097\116\116\097\099\107\032\111\110\032\064" .. target . Name .. "\046" )
or command == "\115\110\105\112\101"
and ( "\083\110\105\112\105\110\103\032\064" .. target . Name .. "\032\119\105\116\104\032\114\097\112\105\100\032\082\101\118\111\108\118\101\114\032\102\105\114\101\046" )
or ( "\065\116\116\097\099\107\105\110\103\032\064" .. target . Name .. "\032\119\105\116\104\032\114\101\118\111\108\118\101\114\059\032\115\116\111\109\112\032\111\110\032\100\111\119\110\046" ) )
else
stopAutoKill ( )
_ve76b6087628a . standStatus ( "\065\116\116\097\099\107\032\099\111\117\108\100\032\110\111\116\032\115\116\097\114\116\059\032\116\097\114\103\101\116\032\117\110\097\118\097\105\108\097\098\108\101\046" )
end
end )
elseif command == "\115\116\097\116\117\115" then
_ve76b6087628a . standStatus ( _v94b7adb6cdb9 . autoKill and _v1f40472bbaea . lockPlayer
and "\065\116\116\097\099\107\105\110\103\032\064" .. _v1f40472bbaea . lockPlayer . Name
or _v94b7adb6cdb9 . standFlinging and "\070\108\105\110\103\105\110\103\046"
or _v94b7adb6cdb9 . standFollow and "\070\111\108\108\111\119\105\110\103\032\116\097\114\103\101\116\046"
or _v94b7adb6cdb9 . standHoldRestore and "\072\111\108\100\105\110\103\032\112\111\115\105\116\105\111\110\046"
or ( "\083\116\097\110\100\105\110\103\032\098\121\046\032\065\070\075\032" .. ( _v94b7adb6cdb9 . afkPermanent and "\079\078" or "\079\070\070" ) .. "\046" ) )
end
end
bind ( _ve76b6087628a . StandSetOwner . MouseButton1Click : Connect ( function ( )
local owner , issue = _ve76b6087628a . standResolvePlayer ( _ve76b6087628a . StandOwnerInput . Text )
if owner then _ve76b6087628a . standSetOwner ( owner )
else _ve76b6087628a . standStatus ( issue ) end
end ) )
bind ( _ve76b6087628a . StandSetSelected . MouseButton1Click : Connect ( function ( )
_ve76b6087628a . standSetOwner ( _v94b7adb6cdb9 . primary )
end ) )
bind ( _ve76b6087628a . StandToggle . MouseButton1Click : Connect ( function ( )
if not _v94b7adb6cdb9 . standEnabled and not _v94b7adb6cdb9 . standOwner then
_ve76b6087628a . standStatus ( "\083\101\116\032\097\110\032\111\119\110\101\114\032\102\105\114\115\116\046" )
return
end
_v94b7adb6cdb9 . standEnabled = not _v94b7adb6cdb9 . standEnabled
_v5680cea30ae2 . SpectraStandEnabled = _v94b7adb6cdb9 . standEnabled
style ( _ve76b6087628a . StandToggle , _v94b7adb6cdb9 . standEnabled , "\076\073\083\084\069\078\058\032\079\078" , "\076\073\083\084\069\078\058\032\079\070\070" )
if not _v94b7adb6cdb9 . standEnabled then _ve76b6087628a . standStop ( "\076\105\115\116\101\110\105\110\103\032\115\116\111\112\112\101\100\046" )
else _ve76b6087628a . standStatus ( "\076\105\115\116\101\110\105\110\103\032\116\111\032\064" .. _v94b7adb6cdb9 . standOwner . Name .. "\046" ) end
end ) )
bind ( _ve76b6087628a . StandStop . MouseButton1Click : Connect ( function ( )
_ve76b6087628a . standStop ( "\067\117\114\114\101\110\116\032\111\114\100\101\114\032\115\116\111\112\112\101\100\046" )
end ) )
pcall ( function ( )
local chat = game : GetService ( "\084\101\120\116\067\104\097\116\083\101\114\118\105\099\101" )
bind ( chat . MessageReceived : Connect ( function ( message )
local source = message . TextSource
if not source or not _v94b7adb6cdb9 . standOwner
or source . UserId ~= _v94b7adb6cdb9 . standOwner . UserId then return end
_ve76b6087628a . standHandleChat ( _v94b7adb6cdb9 . standOwner , message . Text )
end ) )
end )
bind ( _vcd60f2e5219a . PlayerRemoving : Connect ( function ( player )
if player ~= _v94b7adb6cdb9 . standOwner then return end
_ve76b6087628a . standStop ( "\079\119\110\101\114\032\108\101\102\116\032\116\104\101\032\115\101\114\118\101\114\046" )
_v94b7adb6cdb9 . standEnabled = false
_v94b7adb6cdb9 . standOwner = nil
_v5680cea30ae2 . SpectraStandOwnerUserId = nil
_v5680cea30ae2 . SpectraStandEnabled = false
style ( _ve76b6087628a . StandToggle , false , "\076\073\083\084\069\078\058\032\079\078" , "\076\073\083\084\069\078\058\032\079\070\070" )
_ve76b6087628a . StandOwnerLabel . Text = "\079\119\110\101\114\058\032\110\111\110\101"
if _v94b7adb6cdb9 . standOwnerChatConnection then
_v94b7adb6cdb9 . standOwnerChatConnection : Disconnect ( )
_v94b7adb6cdb9 . standOwnerChatConnection = nil
end
end ) )
bind ( Bring . MouseButton1Click : Connect ( function ( )
if _v94b7adb6cdb9 . autoKill and _v94b7adb6cdb9 . killBringDestination then
stopAutoKill ( "\066\114\105\110\103\032\115\116\111\112\112\101\100\046" )
return
end
if _v94b7adb6cdb9 . autoKill then stopAutoKill ( ) end
local character = _vad430fdb5ce8 . Character
local root = character and character : FindFirstChild ( "\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116" )
if not root then say ( "\089\111\117\114\032\099\104\097\114\097\099\116\101\114\032\114\111\111\116\032\105\115\032\117\110\097\118\097\105\108\097\098\108\101\046" ) ; return end
startAutoKill ( root . CFrame )
end ) )
_ve76b6087628a . antiLockRenderName = "\082\065\067\069\082\095\065\110\116\105\076\111\099\107\077\111\118\101\109\101\110\116"
_ve76b6087628a . updateAntiLock = function ( )
pcall ( function ( ) _v286a8fc93150 : UnbindFromRenderStep ( _ve76b6087628a . antiLockRenderName ) end )
if not _v94b7adb6cdb9 . antiLock or _v94b7adb6cdb9 . closed then return end
_v286a8fc93150 : BindToRenderStep ( _ve76b6087628a . antiLockRenderName ,
Enum . RenderPriority . Input . Value + 2 , function ( )
if _v94b7adb6cdb9 . closed or not _v94b7adb6cdb9 . antiLock or _v94b7adb6cdb9 . autoKill or _v94b7adb6cdb9 . voidBlinking
or _v94b7adb6cdb9 . standFollow or _v94b7adb6cdb9 . standFlinging or _v94b7adb6cdb9 . bring then return end
local character = _vad430fdb5ce8 . Character
local hum = character and character : FindFirstChildOfClass ( "\072\117\109\097\110\111\105\100" )
if not hum or hum . Health <= 0 or hum . Sit then return end
local move = hum . MoveDirection
if move . Magnitude < 0.2 then return end
local side = Vector3 . new ( - move . Z , 0 , move . X )
if side . Magnitude < 0.01 then return end
local flip = math . floor ( os . clock ( ) * 5.2 ) % 2 == 0 and 1 or - 1
local adjusted = move . Unit + side . Unit * ( flip * 0.36 )
hum : Move ( adjusted . Unit , false )
end )
end
bind ( _ve76b6087628a . AntiLockBtn . MouseButton1Click : Connect ( function ( )
_v94b7adb6cdb9 . antiLock = not _v94b7adb6cdb9 . antiLock
style ( _ve76b6087628a . AntiLockBtn , _v94b7adb6cdb9 . antiLock ,
"\065\078\084\073\045\076\079\067\075\032\077\079\086\069\077\069\078\084\058\032\079\078" , "\065\078\084\073\045\076\079\067\075\032\077\079\086\069\077\069\078\084\058\032\079\070\070" )
_ve76b6087628a . updateAntiLock ( )
say ( _v94b7adb6cdb9 . antiLock and "\065\110\116\105\045\108\111\099\107\032\109\111\118\101\109\101\110\116\032\079\078\058\032\115\116\114\097\102\101\115\032\119\104\105\108\101\032\119\097\108\107\105\110\103\059\032\110\111\116\032\108\111\099\107\032\105\109\109\117\110\105\116\121\046"
or "\065\110\116\105\045\108\111\099\107\032\109\111\118\101\109\101\110\116\032\100\105\115\097\098\108\101\100\046" )
end ) )
_ve76b6087628a . configSlot = 1
_ve76b6087628a . configKeys = { "\113\117\105\101\116\065\117\116\111\075\105\108\108" , "\097\117\116\111\075\105\108\108\086\111\105\100" , "\097\110\116\105\086\111\105\100" , "\097\117\116\111\065\114\109\111\114" ,
"\097\110\116\105\083\116\111\109\112" , "\097\117\116\111\083\116\111\109\112" , "\115\116\111\109\112\065\110\105\109\097\116\105\111\110\069\110\097\098\108\101\100" , "\115\116\111\109\112\080\097\099\101" ,
"\114\101\115\101\116\084\104\114\101\115\104\111\108\100\073\110\100\101\120" , "\115\116\114\097\102\101\082\097\100\105\117\115" , "\118\111\105\100\068\101\112\116\104" , "\117\105\083\099\097\108\101" ,
"\114\101\115\112\097\119\110\065\116\068\101\097\116\104" , "\097\100\097\112\116\105\118\101\082\097\112\105\100" , "\110\111\082\101\099\111\105\108" , "\110\111\083\112\114\101\097\100" ,
"\105\110\118\105\115\105\098\108\101\083\104\111\116" , "\105\110\102\105\110\105\116\101\083\109\103" , "\097\117\116\111\082\101\108\111\097\100\065\108\108" , "\116\104\101\109\101\073\110\100\101\120" , "\109\097\099\114\111\076\111\099\107" ,
"\098\117\108\108\101\116\077\111\100\101" , "\097\110\116\105\076\111\099\107" }
_ve76b6087628a . configPath = function ( )
return "\083\112\101\099\116\114\097\077\117\108\116\105\095\067\111\110\102\105\103\095" .. _ve76b6087628a . configSlot .. "\046\106\115\111\110"
end
_ve76b6087628a . syncConfigSlot = function ( )
for index , slot in ipairs ( _ve76b6087628a . ConfigSlots ) do
slot . BackgroundColor3 = index == _ve76b6087628a . configSlot and C_SELECTED or C_OFF
end
end
for index , slot in ipairs ( _ve76b6087628a . ConfigSlots ) do
bind ( slot . MouseButton1Click : Connect ( function ( )
_ve76b6087628a . configSlot = index
_ve76b6087628a . syncConfigSlot ( )
_ve76b6087628a . ConfigStatus . Text = "\083\108\111\116\032" .. index .. "\032\115\101\108\101\099\116\101\100\046"
end ) )
end
_ve76b6087628a . syncConfigSlot ( )
bind ( _ve76b6087628a . ConfigSave . MouseButton1Click : Connect ( function ( )
if type ( writefile ) ~= "\102\117\110\099\116\105\111\110" then
_ve76b6087628a . ConfigStatus . Text = "\084\104\105\115\032\101\120\101\099\117\116\111\114\032\100\111\101\115\032\110\111\116\032\115\117\112\112\111\114\116\032\115\097\118\105\110\103\032\102\105\108\101\115\046"
return
end
local profile = { version = 1 , settings = { } , rapidWeapons = { } ,
autoBuys = { } , esp = { } , notify = { } }
for _ , key in ipairs ( _ve76b6087628a . configKeys ) do
profile . settings [ key ] = _v94b7adb6cdb9 [ key ]
end
for name , enabled in pairs ( _v94b7adb6cdb9 . rapidWeapons ) do
if enabled then profile . rapidWeapons [ name ] = true end
end
for name , enabled in pairs ( _v94b7adb6cdb9 . autoBuys ) do
if enabled then profile . autoBuys [ name ] = true end
end
for key , value in pairs ( _v94b7adb6cdb9 . esp ) do profile . esp [ key ] = value end
for key , value in pairs ( _v94b7adb6cdb9 . notify ) do profile . notify [ key ] = value end
local ok , err = pcall ( function ( )
writefile ( _ve76b6087628a . configPath ( ) ,
game : GetService ( "\072\116\116\112\083\101\114\118\105\099\101" ) : JSONEncode ( profile ) )
end )
_ve76b6087628a . ConfigStatus . Text = ok and
( "\083\097\118\101\100\032\115\108\111\116\032" .. _ve76b6087628a . configSlot .. "\046" ) or
( "\083\097\118\101\032\102\097\105\108\101\100\058\032" .. tostring ( err ) )
end ) )
bind ( _ve76b6087628a . ConfigLoad . MouseButton1Click : Connect ( function ( )
if type ( readfile ) ~= "\102\117\110\099\116\105\111\110" or type ( isfile ) ~= "\102\117\110\099\116\105\111\110" then
_ve76b6087628a . ConfigStatus . Text = "\084\104\105\115\032\101\120\101\099\117\116\111\114\032\100\111\101\115\032\110\111\116\032\115\117\112\112\111\114\116\032\108\111\097\100\105\110\103\032\102\105\108\101\115\046"
return
end
if not isfile ( _ve76b6087628a . configPath ( ) ) then
_ve76b6087628a . ConfigStatus . Text = "\083\108\111\116\032" .. _ve76b6087628a . configSlot .. "\032\105\115\032\101\109\112\116\121\046"
return
end
local ok , profile = pcall ( function ( )
return game : GetService ( "\072\116\116\112\083\101\114\118\105\099\101" ) : JSONDecode ( readfile ( _ve76b6087628a . configPath ( ) ) )
end )
if not ok or type ( profile ) ~= "\116\097\098\108\101" or profile . version ~= 1
or type ( profile . settings ) ~= "\116\097\098\108\101" then
_ve76b6087628a . ConfigStatus . Text = "\084\104\105\115\032\115\108\111\116\032\104\097\115\032\105\110\118\097\108\105\100\032\099\111\110\102\105\103\032\100\097\116\097\046"
return
end
if _v94b7adb6cdb9 . autoKill then stopAutoKill ( "\076\111\097\100\105\110\103\032\099\111\110\102\105\103\046" ) end
local settings = profile . settings
local previouslyAntiStomp = _v94b7adb6cdb9 . antiStomp
for _ , key in ipairs ( _ve76b6087628a . configKeys ) do
if type ( settings [ key ] ) == type ( _v94b7adb6cdb9 [ key ] ) then _v94b7adb6cdb9 [ key ] = settings [ key ] end
end
_v94b7adb6cdb9 . stompPace = math . clamp ( _v94b7adb6cdb9 . stompPace , 1e-282 , 1 )
_v94b7adb6cdb9 . resetThresholdIndex = math . clamp ( math . floor ( _v94b7adb6cdb9 . resetThresholdIndex ) , 1 , # ResetThresholds )
_v94b7adb6cdb9 . themeIndex = math . clamp ( math . floor ( _v94b7adb6cdb9 . themeIndex ) , 1 , # ThemeNames )
_v94b7adb6cdb9 . bulletMode = math . clamp ( math . floor ( _v94b7adb6cdb9 . bulletMode ) , 1 , # _ve76b6087628a . BulletModeNames )
_v94b7adb6cdb9 . bulletStep = 0
_v94b7adb6cdb9 . strafeRadius = math . clamp ( _v94b7adb6cdb9 . strafeRadius , 4 , 14 )
_v94b7adb6cdb9 . voidDepth = math . clamp ( _v94b7adb6cdb9 . voidDepth , - 300 , - 60 )
_v94b7adb6cdb9 . uiScale = math . clamp ( _v94b7adb6cdb9 . uiScale , 0.7 , 1.2 )
_vf7c4bc36ea3b . restore ( )
table . clear ( _v94b7adb6cdb9 . rapidWeapons )
if type ( profile . rapidWeapons ) == "\116\097\098\108\101" then
for name , enabled in pairs ( profile . rapidWeapons ) do
if type ( name ) == "\115\116\114\105\110\103" and enabled == true then
_v94b7adb6cdb9 . rapidWeapons [ name ] = true
end
end
end
_vf7c4bc36ea3b . forEachGun ( function ( tool ) _vf7c4bc36ea3b . applyCooldown ( tool ) end )
for name , row in pairs ( _vf7c4bc36ea3b . rows ) do
style ( row , _v94b7adb6cdb9 . rapidWeapons [ name ] , name .. "\032\032\047\032\032\079\078" , name .. "\032\032\047\032\032\079\070\070" )
end
table . clear ( _v94b7adb6cdb9 . autoBuys )
if type ( profile . autoBuys ) == "\116\097\098\108\101" then
for name , enabled in pairs ( profile . autoBuys ) do
if type ( name ) == "\115\116\114\105\110\103" and enabled == true then
_v94b7adb6cdb9 . autoBuys [ name ] = true
end
end
end
if type ( profile . esp ) == "\116\097\098\108\101" then
for key , value in pairs ( _v94b7adb6cdb9 . esp ) do
if type ( profile . esp [ key ] ) == type ( value ) then _v94b7adb6cdb9 . esp [ key ] = profile . esp [ key ] end
end
end
if type ( profile . notify ) == "\116\097\098\108\101" then
for key , value in pairs ( _v94b7adb6cdb9 . notify ) do
if type ( profile . notify [ key ] ) == type ( value ) then
_v94b7adb6cdb9 . notify [ key ] = profile . notify [ key ]
end
end
end
_ve76b6087628a . Notify . refreshButtons ( )
_v94b7adb6cdb9 . esp . rangeIndex = math . clamp ( math . floor ( _v94b7adb6cdb9 . esp . rangeIndex ) , 1 , 4 )
_v94b7adb6cdb9 . esp . colorIndex = math . clamp ( math . floor ( _v94b7adb6cdb9 . esp . colorIndex ) , 1 , 4 )
applyTheme ( _v94b7adb6cdb9 . themeIndex )
setStompPace ( ( math . log10 ( _v94b7adb6cdb9 . stompPace ) + MinStompPaceExponent )
/ MinStompPaceExponent )
_ve76b6087628a . setStrafeRadius ( ( _v94b7adb6cdb9 . strafeRadius - 4 ) / 10 )
_ve76b6087628a . setVoidDepth ( ( - _v94b7adb6cdb9 . voidDepth - 60 ) / 240 )
_ve76b6087628a . setUiScale ( ( _v94b7adb6cdb9 . uiScale - 0.7 ) / 0.5 )
style ( _ve76b6087628a . QuietKillBtn , _v94b7adb6cdb9 . quietAutoKill ,
"\081\085\073\069\084\032\065\085\084\079\032\075\073\076\076\058\032\079\078" , "\081\085\073\069\084\032\065\085\084\079\032\075\073\076\076\058\032\079\070\070" )
style ( VoidKillBtn , _v94b7adb6cdb9 . autoKillVoid ,
"\065\085\084\079\032\075\073\076\076\032\086\079\073\068\032\066\076\073\078\075\058\032\079\078" , "\065\085\084\079\032\075\073\076\076\032\086\079\073\068\032\066\076\073\078\075\058\032\079\070\070" )
style ( AntiVoidBtn , _v94b7adb6cdb9 . antiVoid , "\065\078\084\073\032\086\079\073\068\058\032\079\078" , "\065\078\084\073\032\086\079\073\068\058\032\079\070\070" )
style ( _ve76b6087628a . AntiLockBtn , _v94b7adb6cdb9 . antiLock ,
"\065\078\084\073\045\076\079\067\075\032\077\079\086\069\077\069\078\084\058\032\079\078" , "\065\078\084\073\045\076\079\067\075\032\077\079\086\069\077\069\078\084\058\032\079\070\070" )
_ve76b6087628a . updateAntiLock ( )
style ( AutoArmor , _v94b7adb6cdb9 . autoArmor ,
"\065\085\084\079\032\065\082\077\079\082\032\079\078\032\082\069\083\080\065\087\078\058\032\079\078" , "\065\085\084\079\032\065\082\077\079\082\032\079\078\032\082\069\083\080\065\087\078\058\032\079\070\070" )
style ( _v961187159855 , _v94b7adb6cdb9 . antiStomp , "\065\078\084\073\032\083\084\079\077\080\058\032\079\078" , "\065\078\084\073\032\083\084\079\077\080\058\032\079\070\070" )
if previouslyAntiStomp and not _v94b7adb6cdb9 . antiStomp then
_v94b7adb6cdb9 . resetGeneration = _v94b7adb6cdb9 . resetGeneration + 1
_v94b7adb6cdb9 . resetCharacter = nil
_v94b7adb6cdb9 . resetInFlight = false
_v94b7adb6cdb9 . antiStompReady = false
elseif not previouslyAntiStomp and _v94b7adb6cdb9 . antiStomp then
resetBeforeStomp ( _vad430fdb5ce8 . Character , ownDangerReason ( _vad430fdb5ce8 . Character ) )
end
style ( AutoStompBtn , _v94b7adb6cdb9 . autoStomp , "\065\085\084\079\032\083\084\079\077\080\058\032\079\078" , "\065\085\084\079\032\083\084\079\077\080\058\032\079\070\070" )
style ( _ve76b6087628a . StompAnimationBtn , _v94b7adb6cdb9 . stompAnimationEnabled ,
"\083\084\079\077\080\032\065\078\073\077\065\084\073\079\078\058\032\079\078" , "\083\084\079\077\080\032\065\078\073\077\065\084\073\079\078\058\032\079\070\070" )
style ( _ve76b6087628a . RespawnDeathBtn , _v94b7adb6cdb9 . respawnAtDeath ,
"\082\069\083\080\065\087\078\032\065\084\032\068\069\065\084\072\058\032\079\078" , "\082\069\083\080\065\087\078\032\065\084\032\068\069\065\084\072\058\032\079\070\070" )
style ( _ve76b6087628a . MacroBtn , _v94b7adb6cdb9 . macroLock ,
"\077\065\067\082\079\032\080\069\082\083\073\083\084\058\032\079\078" , "\077\065\067\082\079\032\080\069\082\083\073\083\084\058\032\079\070\070" )
if _v94b7adb6cdb9 . macroLock then _ve76b6087628a . ensureMacro ( _vad430fdb5ce8 . Character ) end
ResetThresholdBtn . Text = "\082\069\083\069\084\032\065\084\058\032" .. ResetThresholds [ _v94b7adb6cdb9 . resetThresholdIndex ] .. "\032\072\080"
local guns = _ve76b6087628a . GunModButtons
style ( _ve76b6087628a . BulletModeBtn , _v94b7adb6cdb9 . bulletMode ~= 1 ,
"\066\085\076\076\069\084\032\068\073\082\069\067\084\073\079\078\058\032" .. _ve76b6087628a . BulletModeNames [ _v94b7adb6cdb9 . bulletMode ] ,
"\066\085\076\076\069\084\032\068\073\082\069\067\084\073\079\078\058\032\067\085\082\083\079\082" )
if _v94b7adb6cdb9 . bulletMode ~= 1 then
local ok , reason = installRaycastHook ( )
if not ok then say ( reason ) end
end
style ( guns . invisible , _v94b7adb6cdb9 . invisibleShot , "\073\078\086\073\083\073\066\076\069\032\083\072\079\084\058\032\079\078" , "\073\078\086\073\083\073\066\076\069\032\083\072\079\084\058\032\079\070\070" )
style ( guns . adaptive , _v94b7adb6cdb9 . adaptiveRapid , "\065\068\065\080\084\073\086\069\032\082\065\080\073\068\058\032\079\078" , "\065\068\065\080\084\073\086\069\032\082\065\080\073\068\058\032\079\070\070" )
style ( guns . recoil , _v94b7adb6cdb9 . noRecoil , "\078\079\032\082\069\067\079\073\076\058\032\079\078" , "\078\079\032\082\069\067\079\073\076\058\032\079\070\070" )
style ( guns . spread , _v94b7adb6cdb9 . noSpread , "\068\066\032\078\079\032\083\080\082\069\065\068\058\032\079\078" , "\068\066\032\078\079\032\083\080\082\069\065\068\058\032\079\070\070" )
style ( guns . smg , _v94b7adb6cdb9 . infiniteSmg , "\083\077\071\032\065\085\084\079\032\082\069\076\079\065\068\058\032\079\078" , "\083\077\071\032\065\085\084\079\032\082\069\076\079\065\068\058\032\079\070\070" )
style ( guns . reload , _v94b7adb6cdb9 . autoReloadAll ,
"\065\085\084\079\032\082\069\076\079\065\068\032\065\076\076\032\071\085\078\083\058\032\079\078" , "\065\085\084\079\032\082\069\076\079\065\068\032\065\076\076\032\071\085\078\083\058\032\079\070\070" )
_ve76b6087628a . applyGunMods ( _vad430fdb5ce8 . Character )
style ( _ve76b6087628a . EspMain , _v94b7adb6cdb9 . esp . enabled , "\069\083\080\058\032\079\078" , "\069\083\080\058\032\079\070\070" )
for _ , item in ipairs ( { { "\098\111\120\101\115" , _ve76b6087628a . EspBoxes , "\066\079\088\069\083" } ,
{ "\115\107\101\108\101\116\111\110" , _ve76b6087628a . EspSkeleton , "\083\075\069\076\069\084\079\078" } ,
{ "\110\097\109\101\115" , _ve76b6087628a . EspNames , "\078\065\077\069\083" } ,
{ "\100\105\115\116\097\110\099\101" , _ve76b6087628a . EspDistance , "\068\073\083\084\065\078\067\069" } } ) do
style ( item [ 2 ] , _v94b7adb6cdb9 . esp [ item [ 1 ] ] , item [ 3 ] .. "\058\032\079\078" , item [ 3 ] .. "\058\032\079\070\070" )
end
local espRanges = { "\050\053\048" , "\053\048\048" , "\049\048\048\048" , "\065\076\076" }
local espColors = { "\067\089\065\078" , "\086\073\079\076\069\084" , "\065\077\066\069\082" , "\076\073\077\069" }
_ve76b6087628a . EspRange . Text = "\082\065\078\071\069\058\032" .. espRanges [ _v94b7adb6cdb9 . esp . rangeIndex ]
_ve76b6087628a . EspColor . Text = "\067\079\076\079\082\058\032" .. espColors [ _v94b7adb6cdb9 . esp . colorIndex ]
refreshAutoBuyControls ( )
updateAutoStomp ( )
_ve76b6087628a . ConfigStatus . Text = "\076\111\097\100\101\100\032\115\108\111\116\032" .. _ve76b6087628a . configSlot .. "\046"
end ) )
local Dragging , DragStart , GuiStart , DragInput = false , nil , nil , nil
bind ( Heading . InputBegan : Connect ( function ( input )
if input . UserInputType == Enum . UserInputType . MouseButton1
or input . UserInputType == Enum . UserInputType . Touch then
Dragging , DragStart , GuiStart = true , input . Position , _v373596433c68 . Position
end
end ) )
bind ( Heading . InputChanged : Connect ( function ( input )
if input . UserInputType == Enum . UserInputType . MouseMovement
or input . UserInputType == Enum . UserInputType . Touch then DragInput = input end
end ) )
bind ( _vcb684e26a41a . InputChanged : Connect ( function ( input )
if Dragging and input == DragInput then
local d = input . Position - DragStart
_v373596433c68 . Position = UDim2 . new ( GuiStart . X . Scale , GuiStart . X . Offset + d . X ,
GuiStart . Y . Scale , GuiStart . Y . Offset + d . Y )
end
end ) )
bind ( _vcb684e26a41a . InputEnded : Connect ( function ( input )
if input . UserInputType == Enum . UserInputType . MouseButton1
or input . UserInputType == Enum . UserInputType . Touch then Dragging = false end
end ) )
local function cleanup ( )
if _v94b7adb6cdb9 . closed then return end
_v94b7adb6cdb9 . closed = true
_v94b7adb6cdb9 . resetGeneration = _v94b7adb6cdb9 . resetGeneration + 1
_v94b7adb6cdb9 . resetCharacter = nil
_v94b7adb6cdb9 . resetInFlight = false
for p in pairs ( _ve76b6087628a . Notify . watchers ) do _ve76b6087628a . Notify . detach ( p ) end
_v94b7adb6cdb9 . jumpBypass = false
_v94b7adb6cdb9 . jumpBypassGeneration = _v94b7adb6cdb9 . jumpBypassGeneration + 1
disconnectJumpBypass ( )
setChatSpy ( false )
_ve9c0e81b802b = _ve9c0e81b802b + 1
_v94b7adb6cdb9 . armorGeneration = _v94b7adb6cdb9 . armorGeneration + 1
OwnCharacterGeneration = OwnCharacterGeneration + 1
_v1a80223b8c3b = _v1a80223b8c3b + 1
_v94b7adb6cdb9 . autoKill = false
_v94b7adb6cdb9 . autoKillGeneration = _v94b7adb6cdb9 . autoKillGeneration + 1
_v94b7adb6cdb9 . selectedStomp = false
_v94b7adb6cdb9 . selectedStompGeneration = _v94b7adb6cdb9 . selectedStompGeneration + 1
releaseSelectedStompPin ( )
_ve76b6087628a . standEndCinematic ( )
_ve76b6087628a . standCancelFling ( )
_ve76b6087628a . standReleaseHold ( )
_v94b7adb6cdb9 . standEnabled = false
_v94b7adb6cdb9 . standFollow = false
_v94b7adb6cdb9 . standFollowGeneration = _v94b7adb6cdb9 . standFollowGeneration + 1
if _v94b7adb6cdb9 . standOwnerChatConnection then
_v94b7adb6cdb9 . standOwnerChatConnection : Disconnect ( )
_v94b7adb6cdb9 . standOwnerChatConnection = nil
end
_v94b7adb6cdb9 . voidBlinking = false
_v94b7adb6cdb9 . antiLock = false
_ve76b6087628a . updateAntiLock ( )
_vf7c4bc36ea3b . restore ( )
_ve76b6087628a . restoreGunMods ( )
_ve76b6087628a . cleanupEsp ( )
if AutoStompTrack then pcall ( function ( ) AutoStompTrack : Stop ( 0.05 ) end ) end
disconnectMany ( _va6ba7af26ac1 )
_v1f40472bbaea . enabled = false
_v1f40472bbaea . part , _v1f40472bbaea . record = nil , nil
if _v1f40472bbaea . manager and _v1f40472bbaea . manager . Raycast == _v1f40472bbaea . wrapper then
pcall ( function ( ) _v1f40472bbaea . manager . Raycast = _v1f40472bbaea . original end )
end
if _v1f40472bbaea . manager and _v1f40472bbaea . manager . ReconcileDamageBatch == _v1f40472bbaea . damageWrapper then
pcall ( function ( ) _v1f40472bbaea . manager . ReconcileDamageBatch = _v1f40472bbaea . damageOriginal end )
end
_v1f40472bbaea . installed , _v1f40472bbaea . manager , _v1f40472bbaea . original , _v1f40472bbaea . wrapper = false , nil , nil , nil
_v94b7adb6cdb9 . silent , _v94b7adb6cdb9 . trigger , _v94b7adb6cdb9 . wallBang , _v94b7adb6cdb9 . bulletMode = false , false , false , 1
if _v1861b000f64a then _v1861b000f64a : Disconnect ( ) ; _v1861b000f64a = nil end
stopBring ( )
for _ , cs in pairs ( _vd12b30d97e97 ) do disconnectMany ( cs ) end
table . clear ( _vd12b30d97e97 )
for _ , c in pairs ( Folders ) do c : Disconnect ( ) end
table . clear ( Folders )
for _ , c in pairs ( RowConnections ) do c : Disconnect ( ) end
table . clear ( RowConnections )
disconnectMany ( _v85313cbfddb5 )
if _v5e8292a54b81 . Parent then _v5e8292a54b81 : Destroy ( ) end
end
_v5680cea30ae2 . SpectraSelectCleanup = cleanup
_v5680cea30ae2 . DAH_LiteCleanup = cleanup
_v5680cea30ae2 . DAH_PolishedCleanup = cleanup
bind ( Close . MouseButton1Click : Connect ( cleanup ) )
bind ( _v5e8292a54b81 . Destroying : Connect ( cleanup ) )
style ( AliveBtn , true , "\065\076\073\086\069\032\067\072\069\067\075\058\032\079\078" , "\065\076\073\086\069\032\067\072\069\067\075\058\032\079\070\070" )
style ( AutoArmor , _v94b7adb6cdb9 . autoArmor , "\065\085\084\079\032\065\082\077\079\082\032\079\078\032\082\069\083\080\065\087\078\058\032\079\078" , "\065\085\084\079\032\065\082\077\079\082\032\079\078\032\082\069\083\080\065\087\078\058\032\079\070\070" )
style ( _v961187159855 , _v94b7adb6cdb9 . antiStomp , "\065\078\084\073\032\083\084\079\077\080\058\032\079\078" , "\065\078\084\073\032\083\084\079\077\080\058\032\079\070\070" )
style ( AutoStompBtn , _v94b7adb6cdb9 . autoStomp , "\065\085\084\079\032\083\084\079\077\080\058\032\079\078" , "\065\085\084\079\032\083\084\079\077\080\058\032\079\070\070" )
style ( _ve76b6087628a . StompAnimationBtn , _v94b7adb6cdb9 . stompAnimationEnabled ,
"\083\084\079\077\080\032\065\078\073\077\065\084\073\079\078\058\032\079\078" , "\083\084\079\077\080\032\065\078\073\077\065\084\073\079\078\058\032\079\070\070" )
if type ( _v5680cea30ae2 . SpectraStandOwnerUserId ) == "\110\117\109\098\101\114" then
task . defer ( function ( )
if _v94b7adb6cdb9 . closed then return end
for _ , player in ipairs ( _vcd60f2e5219a : GetPlayers ( ) ) do
if player . UserId == _v5680cea30ae2 . SpectraStandOwnerUserId then
_ve76b6087628a . standSetOwner ( player )
_v94b7adb6cdb9 . standEnabled = _v5680cea30ae2 . SpectraStandEnabled == true
style ( _ve76b6087628a . StandToggle , _v94b7adb6cdb9 . standEnabled ,
"\076\073\083\084\069\078\058\032\079\078" , "\076\073\083\084\069\078\058\032\079\070\070" )
if _v94b7adb6cdb9 . standEnabled then
_ve76b6087628a . standStatus ( "\076\105\115\116\101\110\105\110\103\032\116\111\032\064" .. player . Name .. "\046" )
end
return
end
end
end )
end
style ( CursorToggle , _v94b7adb6cdb9 . cursorKeyEnabled , "\067\085\082\083\079\082\032\080\073\067\075\058\032\079\078" , "\067\085\082\083\079\082\032\080\073\067\075\058\032\079\070\070" )
refreshAutoBuyControls ( )
syncLabels ( )
updateAutoStomp ( )
say ( "\082\101\097\100\121\058\032\065\110\116\105\045\083\116\111\109\112\032\115\116\111\112\115\032\111\110\032\099\104\097\114\097\099\116\101\114\032\114\101\102\114\101\115\104\059\032\110\111\116\105\102\105\099\097\116\105\111\110\032\111\112\116\105\111\110\115\032\105\110\032\078\079\084\073\070\089\046" )
if _vad430fdb5ce8 . Character and ( _v94b7adb6cdb9 . autoArmor or next ( _v94b7adb6cdb9 . autoBuys ) ) then
task . spawn ( buyAutoItems , _vad430fdb5ce8 . Character )
end
_v373596433c68 . Visible = false
_ve76b6087628a . LoadOverlay = make ( "\070\114\097\109\101" , { Parent = _v5e8292a54b81 , Name = "\082\097\099\101\114\076\111\097\100\105\110\103" ,
Size = UDim2 . fromScale ( 1 , 1 ) , BackgroundColor3 = C_BG ,
BorderSizePixel = 0 , ZIndex = 100 } )
_ve76b6087628a . LoadCard = round ( make ( "\070\114\097\109\101" , { Parent = _ve76b6087628a . LoadOverlay ,
AnchorPoint = Vector2 . new ( 0.5 , 0.5 ) , Position = UDim2 . fromScale ( 0.5 , 0.5 ) ,
Size = UDim2 . fromOffset ( 390 , 170 ) , BackgroundColor3 = C_PANEL ,
BorderSizePixel = 0 , ZIndex = 101 } ) , 0 )
make ( "\085\073\083\116\114\111\107\101" , { Parent = _ve76b6087628a . LoadCard , Color = C_BORDER ,
Thickness = 1 , Transparency = 0 } )
_ve76b6087628a . LoadTitle = make ( "\084\101\120\116\076\097\098\101\108" , { Parent = _ve76b6087628a . LoadCard ,
Position = UDim2 . fromOffset ( 24 , 25 ) , Size = UDim2 . fromOffset ( 342 , 35 ) ,
BackgroundTransparency = 1 , Text = "\082\065\067\069\082" ,
TextColor3 = C_TEXT , Font = Enum . Font . GothamBold , TextSize = 23 ,
TextXAlignment = Enum . TextXAlignment . Left , ZIndex = 102 } )
_ve76b6087628a . LoadCaption = make ( "\084\101\120\116\076\097\098\101\108" , { Parent = _ve76b6087628a . LoadCard ,
Position = UDim2 . fromOffset ( 24 , 68 ) , Size = UDim2 . fromOffset ( 342 , 24 ) ,
BackgroundTransparency = 1 , Text = "\080\082\069\080\065\082\073\078\071\032\067\079\078\084\082\079\076\032\067\079\078\083\079\076\069" ,
TextColor3 = C_FAINT , Font = Enum . Font . GothamMedium , TextSize = 12 ,
TextXAlignment = Enum . TextXAlignment . Left , ZIndex = 102 } )
_ve76b6087628a . LoadTrack = round ( make ( "\070\114\097\109\101" , { Parent = _ve76b6087628a . LoadCard ,
Position = UDim2 . fromOffset ( 24 , 117 ) , Size = UDim2 . fromOffset ( 342 , 6 ) ,
BackgroundColor3 = C_OFF , BorderSizePixel = 0 , ZIndex = 102 } ) , 0 )
_ve76b6087628a . LoadFill = round ( make ( "\070\114\097\109\101" , { Parent = _ve76b6087628a . LoadTrack ,
Size = UDim2 . fromScale ( 0 , 1 ) , BackgroundColor3 = C_ACCENT ,
BorderSizePixel = 0 , ZIndex = 103 } ) , 3 )
_ve76b6087628a . LoadPercent = make ( "\084\101\120\116\076\097\098\101\108" , { Parent = _ve76b6087628a . LoadCard ,
Position = UDim2 . fromOffset ( 24 , 133 ) , Size = UDim2 . fromOffset ( 342 , 18 ) ,
BackgroundTransparency = 1 , Text = "\048\048\037" , TextColor3 = C_ACCENT ,
Font = Enum . Font . GothamBold , TextSize = 11 ,
TextXAlignment = Enum . TextXAlignment . Right , ZIndex = 102 } )
task . spawn ( function ( )
local tweenService = game : GetService ( "\084\119\101\101\110\083\101\114\118\105\099\101" )
for index , step in ipairs ( {
{ 0.32 , "\082\101\115\111\108\118\105\110\103\032\112\108\097\121\101\114\032\114\105\103\115" } ,
{ 0.68 , "\067\111\110\110\101\099\116\105\110\103\032\099\111\110\116\114\111\108\115" } ,
{ 1 , "\067\111\110\116\114\111\108\032\100\101\099\107\032\114\101\097\100\121" } ,
} ) do
if _v94b7adb6cdb9 . closed or not _ve76b6087628a . LoadOverlay . Parent then return end
_ve76b6087628a . LoadCaption . Text = step [ 2 ]
_ve76b6087628a . LoadPercent . Text = string . format ( "\037\048\050\100\037\037" , step [ 1 ] * 100 )
local tween = tweenService : Create ( _ve76b6087628a . LoadFill ,
TweenInfo . new ( 0.36 , Enum . EasingStyle . Quart , Enum . EasingDirection . Out ) ,
{ Size = UDim2 . fromScale ( step [ 1 ] , 1 ) } )
tween : Play ( )
tween . Completed : Wait ( )
end
if _v94b7adb6cdb9 . closed then return end
_v373596433c68 . Position = UDim2 . fromOffset ( _v373596433c68 . Position . X . Offset , 96 )
_v373596433c68 . Visible = true
tweenService : Create ( _v373596433c68 ,
TweenInfo . new ( 0.3 , Enum . EasingStyle . Quart , Enum . EasingDirection . Out ) ,
{ Position = UDim2 . fromOffset ( _v373596433c68 . Position . X . Offset , 80 ) } ) : Play ( )
_ve76b6087628a . LoadOverlay : Destroy ( )
end )
return cleanup
