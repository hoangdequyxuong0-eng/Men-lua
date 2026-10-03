print("[MenuSieuToc] bat dau")
local function BootGui(text, color)
local gui = Instance.new("ScreenGui")
gui.Name = "MenuSieuToc_Boot"
gui.ResetOnSpawn = false
gui.DisplayOrder = 100
local getters = {
function() return game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui", 5) end,
function() return gethui() end,
function() return game:GetService("CoreGui") end
}
local placed = false
for _, getter in ipairs(getters) do
local ok = pcall(function() gui.Parent = getter() end)
if ok and gui.Parent then placed = true break end
end
local label = Instance.new("TextLabel")
label.AnchorPoint = Vector2.new(0.5, 0)
label.Position = UDim2.new(0.5, 0, 0, 8)
label.Size = UDim2.new(0.9, 0, 0, 0)
label.AutomaticSize = Enum.AutomaticSize.Y
label.BackgroundColor3 = Color3.fromRGB(20, 10, 14)
label.TextColor3 = color
label.TextWrapped = true
label.TextSize = 14
label.Font = Enum.Font.GothamBold
label.Text = text
label.Parent = gui
return gui
end
local bootGui = BootGui("\226\154\161 \196\144ang t\225\186\163i menu...", Color3.fromRGB(255, 255, 255))
local bootOk, bootErr = pcall(function()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Stats = game:GetService("Stats")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local GuiParent = LocalPlayer:WaitForChild("PlayerGui")
local realInput = {
TouchEnabled = UserInputService.TouchEnabled,
KeyboardEnabled = UserInputService.KeyboardEnabled,
MouseEnabled = UserInputService.MouseEnabled,
GamepadEnabled = UserInputService.GamepadEnabled,
VREnabled = UserInputService.VREnabled
}
local Theme = {
Bg = Color3.fromRGB(16, 10, 14),
Bar = Color3.fromRGB(30, 15, 21),
Item = Color3.fromRGB(40, 21, 29),
ItemHover = Color3.fromRGB(66, 29, 41),
Accent = Color3.fromRGB(230, 57, 70),
AccentDark = Color3.fromRGB(140, 22, 38),
Text = Color3.fromRGB(250, 244, 245),
SubText = Color3.fromRGB(196, 164, 172),
On = Color3.fromRGB(52, 211, 153),
Off = Color3.fromRGB(92, 72, 80),
Red = Color3.fromRGB(255, 99, 99),
Blue = Color3.fromRGB(96, 165, 250),
Gold = Color3.fromRGB(251, 191, 36)
}
local function InstanceNew(class, props, parent)
local obj = Instance.new(class)
for prop, val in pairs(props) do
obj[prop] = val
end
if parent then
obj.Parent = parent
end
return obj
end
local function ApplyCorner(obj, radius)
return InstanceNew("UICorner", { CornerRadius = UDim.new(0, radius or 8) }, obj)
end
local function ApplyStroke(obj, color, thickness, transparency)
return InstanceNew("UIStroke", {
Color = color or Theme.Accent,
Thickness = thickness or 1,
Transparency = transparency or 0,
ApplyStrokeMode = Enum.ApplyStrokeMode.Border
}, obj)
end
local function Tween(obj, duration, props, style, direction)
local tween = TweenService:Create(
obj,
TweenInfo.new(duration, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out),
props
)
tween:Play()
return tween
end
local function AddEffects(btn, strokeColor)
local stroke = ApplyStroke(btn, strokeColor or Theme.Accent, 1, 0.78)
local scale = InstanceNew("UIScale", { Scale = 1 }, btn)
btn.MouseEnter:Connect(function()
Tween(stroke, 0.15, { Transparency = 0, Thickness = 1.8 })
end)
btn.MouseLeave:Connect(function()
Tween(stroke, 0.2, { Transparency = 0.78, Thickness = 1 })
Tween(scale, 0.12, { Scale = 1 })
end)
btn.MouseButton1Down:Connect(function()
Tween(scale, 0.08, { Scale = 0.96 })
end)
btn.MouseButton1Up:Connect(function()
Tween(scale, 0.14, { Scale = 1 }, Enum.EasingStyle.Back)
end)
return stroke
end
local orderCounter = 0
local function GetNextOrder()
orderCounter = orderCounter + 1
return orderCounter
end
local function IsEnemy(targetPlayer)
if not targetPlayer or targetPlayer == LocalPlayer then
return false
end
local myTeam = LocalPlayer.Team
local targetTeam = targetPlayer.Team
if myTeam ~= nil or targetTeam ~= nil then
return myTeam ~= nil and targetTeam ~= nil and myTeam ~= targetTeam
end
if LocalPlayer.TeamColor ~= BrickColor.new("White") or targetPlayer.TeamColor ~= BrickColor.new("White") then
return LocalPlayer.TeamColor ~= targetPlayer.TeamColor
end
return false
end
local function GetRoot(char)
return char and char:FindFirstChild("HumanoidRootPart")
end
local function GetHumanoid()
local char = LocalPlayer.Character
return char and char:FindFirstChildOfClass("Humanoid")
end
local ClickInput = game:GetService("VirtualInputManager")
local isTouchOnly = realInput.TouchEnabled and not realInput.KeyboardEnabled
local function PerformClick(x, y)
if isTouchOnly then
local char = LocalPlayer.Character
local tool = char and char:FindFirstChildOfClass("Tool")
if tool then
pcall(function() tool:Activate() end)
end
return
end
pcall(function()
ClickInput:SendMouseButtonEvent(x, y, 0, true, game, 0)
ClickInput:SendMouseButtonEvent(x, y, 0, false, game, 0)
end)
end
local function MakeDraggable(handle, target)
local dragging = false
local moved = false
local dragInput, dragStart, startPos
handle.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
dragging = true
moved = false
dragStart = input.Position
startPos = target.Position
input.Changed:Connect(function()
if input.UserInputState == Enum.UserInputState.End then
dragging = false
end
end)
end
end)
handle.InputChanged:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
dragInput = input
end
end)
UserInputService.InputChanged:Connect(function(input)
if input == dragInput and dragging then
local delta = input.Position - dragStart
if delta.Magnitude > 10 then
moved = true
end
target.Position = UDim2.new(
startPos.X.Scale, startPos.X.Offset + delta.X,
startPos.Y.Scale, startPos.Y.Offset + delta.Y
)
end
end)
return {
IsDragging = function() return dragging or moved end
}
end
local MainScreenGui = InstanceNew("ScreenGui", {
Name = "MenuSieuToc_Main",
ResetOnSpawn = false,
IgnoreGuiInset = true,
ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, GuiParent)
local FloatScreenGui = InstanceNew("ScreenGui", {
Name = "MenuSieuToc_Float",
ResetOnSpawn = false,
IgnoreGuiInset = false,
ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, GuiParent)
local floatIndex = 0
local function CreateFloatButton(text, onPress)
local col = math.floor(floatIndex / 6)
local row = floatIndex % 6
floatIndex = floatIndex + 1
local btn = InstanceNew("TextButton", {
Size = UDim2.fromOffset(120, 32),
Position = UDim2.new(0, 16 + col * 128, 0, 90 + row * 40),
BackgroundColor3 = Theme.ItemHover,
BorderSizePixel = 0,
AutoButtonColor = false,
Font = Enum.Font.GothamBold,
Text = text,
TextColor3 = Theme.Text,
TextSize = 11,
TextWrapped = true
}, FloatScreenGui)
ApplyCorner(btn, 10)
AddEffects(btn, Theme.Accent)
local drag = MakeDraggable(btn, btn)
btn.MouseButton1Click:Connect(function()
if not drag.IsDragging() then
onPress()
end
end)
return btn
end
local viewport = Workspace.CurrentCamera.ViewportSize
local winW = math.min(400, viewport.X - 20)
local winH = math.min(290, viewport.Y - 40)
local bigW = math.min(540, viewport.X - 20)
local bigH = math.min(400, viewport.Y - 20)
local TITLE_H = 36
local sizeNormal = UDim2.fromOffset(winW, winH)
local sizeBig = UDim2.fromOffset(bigW, bigH)
local sizeMin = UDim2.fromOffset(winW, TITLE_H)
local MainFrame = InstanceNew("CanvasGroup", {
Name = "MainFrame",
BackgroundColor3 = Theme.Bg,
BorderSizePixel = 0,
AnchorPoint = Vector2.new(0.5, 0),
Position = UDim2.new(0.5, 0, 0.5, -winH / 2),
Size = sizeNormal,
ClipsDescendants = true,
Active = true
}, MainScreenGui)
ApplyCorner(MainFrame, 14)
ApplyStroke(MainFrame, Theme.Accent, 2, 0.15)
local BgFrame = InstanceNew("Frame", {
BackgroundColor3 = Theme.Bg,
BorderSizePixel = 0,
Size = UDim2.new(1, 0, 1, 0)
}, MainFrame)
InstanceNew("UIGradient", {
Color = ColorSequence.new(Theme.Bg, Color3.fromRGB(38, 12, 20)),
Rotation = 90
}, BgFrame)
local mainScale = InstanceNew("UIScale", { Scale = 1 }, MainFrame)
local TitleBar = InstanceNew("Frame", {
BackgroundColor3 = Theme.Accent,
BorderSizePixel = 0,
Size = UDim2.new(1, 0, 0, TITLE_H)
}, MainFrame)
local titleGradient = InstanceNew("UIGradient", {
Color = ColorSequence.new(Theme.AccentDark, Theme.Accent),
Rotation = 0,
Offset = Vector2.new(-0.25, 0)
}, TitleBar)
TweenService:Create(
titleGradient,
TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
{ Offset = Vector2.new(0.25, 0) }
):Play()
MakeDraggable(TitleBar, MainFrame)
InstanceNew("TextLabel", {
BackgroundTransparency = 1,
Position = UDim2.new(0, 12, 0, 3),
Size = UDim2.new(1, -90, 0, 18),
Font = Enum.Font.GothamBlack,
Text = "\226\154\161 MENU SI\195\138U T\225\187\144C PRO",
TextColor3 = Theme.Text,
TextSize = 13,
TextXAlignment = Enum.TextXAlignment.Left
}, TitleBar)
InstanceNew("TextLabel", {
BackgroundTransparency = 1,
Position = UDim2.new(0, 12, 0, 21),
Size = UDim2.new(1, -90, 0, 12),
Font = Enum.Font.GothamMedium,
Text = "K\195\169o \196\145\225\187\131 di chuy\225\187\131n  \226\128\162  RightShift \225\186\169n/hi\225\187\135n",
TextColor3 = Color3.fromRGB(255, 214, 218),
TextSize = 10,
TextXAlignment = Enum.TextXAlignment.Left
}, TitleBar)
local MaximizeBtn = InstanceNew("TextButton", {
AnchorPoint = Vector2.new(1, 0.5),
Position = UDim2.new(1, -42, 0.5, 0),
Size = UDim2.fromOffset(28, 24),
BackgroundColor3 = Color3.new(0, 0, 0),
BackgroundTransparency = 0.5,
BorderSizePixel = 0,
AutoButtonColor = false,
Font = Enum.Font.GothamBold,
Text = "\240\159\151\150",
TextColor3 = Theme.Text,
TextSize = 14
}, TitleBar)
ApplyCorner(MaximizeBtn, 8)
AddEffects(MaximizeBtn, Theme.Text)
local MinimizeBtn = InstanceNew("TextButton", {
AnchorPoint = Vector2.new(1, 0.5),
Position = UDim2.new(1, -8, 0.5, 0),
Size = UDim2.fromOffset(28, 24),
BackgroundColor3 = Color3.new(0, 0, 0),
BackgroundTransparency = 0.5,
BorderSizePixel = 0,
AutoButtonColor = false,
Font = Enum.Font.GothamBold,
Text = "-",
TextColor3 = Theme.Text,
TextSize = 20
}, TitleBar)
ApplyCorner(MinimizeBtn, 8)
AddEffects(MinimizeBtn, Theme.Text)
local Body = InstanceNew("Frame", {
BackgroundTransparency = 1,
Position = UDim2.new(0, 0, 0, TITLE_H),
Size = UDim2.new(1, 0, 1, -TITLE_H)
}, MainFrame)
local TabColumn = InstanceNew("ScrollingFrame", {
BackgroundTransparency = 1,
BorderSizePixel = 0,
Position = UDim2.new(0, 8, 0, 8),
Size = UDim2.new(0, 92, 1, -16),
CanvasSize = UDim2.new(0, 0, 0, 0),
AutomaticCanvasSize = Enum.AutomaticSize.Y,
ScrollBarThickness = 0
}, Body)
InstanceNew("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }, TabColumn)
InstanceNew("Frame", {
BackgroundColor3 = Theme.Accent,
BackgroundTransparency = 0.7,
BorderSizePixel = 0,
Position = UDim2.new(0, 106, 0, 12),
Size = UDim2.new(0, 1, 1, -24)
}, Body)
local PageHolder = InstanceNew("Frame", {
BackgroundTransparency = 1,
ClipsDescendants = true,
Position = UDim2.new(0, 114, 0, 8),
Size = UDim2.new(1, -122, 1, -16)
}, Body)
local pages = {}
local tabButtons = {}
local function SelectTab(name)
for pageName, pageObj in pairs(pages) do
if pageName == name then
if not pageObj.Visible then
pageObj.Position = UDim2.new(0, 0, 0, 18)
pageObj.Visible = true
Tween(pageObj, 0.3, { Position = UDim2.new(0, 0, 0, 0) }, Enum.EasingStyle.Back)
end
else
pageObj.Visible = false
end
end
for tabName, btnObj in pairs(tabButtons) do
local isSelected = (tabName == name)
Tween(btnObj, 0.2, { BackgroundColor3 = isSelected and Theme.Accent or Theme.Item })
local indicator = btnObj:FindFirstChild("Indicator")
if indicator then
Tween(indicator, 0.2, { BackgroundTransparency = isSelected and 0 or 1 })
end
end
end
local function AddTab(name)
local btn = InstanceNew("TextButton", {
Size = UDim2.new(1, 0, 0, 32),
BackgroundColor3 = Theme.Item,
BorderSizePixel = 0,
AutoButtonColor = false,
Font = Enum.Font.GothamBold,
Text = name,
TextColor3 = Theme.Text,
TextSize = 10,
TextWrapped = true,
TextXAlignment = Enum.TextXAlignment.Left,
LayoutOrder = GetNextOrder()
}, TabColumn)
ApplyCorner(btn, 10)
InstanceNew("UIPadding", { PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 6) }, btn)
AddEffects(btn)
local indicator = InstanceNew("Frame", {
Name = "Indicator",
AnchorPoint = Vector2.new(0, 0.5),
Position = UDim2.new(0, 4, 0.5, 0),
Size = UDim2.fromOffset(4, 22),
BackgroundColor3 = Theme.Text,
BackgroundTransparency = 1,
BorderSizePixel = 0
}, btn)
ApplyCorner(indicator, 2)
local page = InstanceNew("ScrollingFrame", {
BackgroundTransparency = 1,
BorderSizePixel = 0,
Size = UDim2.new(1, 0, 1, 0),
CanvasSize = UDim2.new(0, 0, 0, 0),
AutomaticCanvasSize = Enum.AutomaticSize.Y,
ScrollBarThickness = 4,
ScrollBarImageColor3 = Theme.Accent,
Visible = false
}, PageHolder)
InstanceNew("UIListLayout", {
Padding = UDim.new(0, 8),
SortOrder = Enum.SortOrder.LayoutOrder,
HorizontalAlignment = Enum.HorizontalAlignment.Center
}, page)
InstanceNew("UIPadding", { PaddingTop = UDim.new(0, 2), PaddingBottom = UDim.new(0, 14) }, page)
pages[name] = page
tabButtons[name] = btn
btn.MouseButton1Click:Connect(function()
SelectTab(name)
end)
return page
end
local function CreateSection(page, text)
local holder = InstanceNew("Frame", {
BackgroundTransparency = 1,
Size = UDim2.new(1, -8, 0, 20),
LayoutOrder = GetNextOrder()
}, page)
local bar = InstanceNew("Frame", {
AnchorPoint = Vector2.new(0, 0.5),
Position = UDim2.new(0, 0, 0.5, 0),
Size = UDim2.fromOffset(4, 16),
BackgroundColor3 = Theme.Accent,
BorderSizePixel = 0
}, holder)
ApplyCorner(bar, 2)
InstanceNew("TextLabel", {
BackgroundTransparency = 1,
Position = UDim2.new(0, 12, 0, 0),
Size = UDim2.new(1, -12, 1, 0),
Font = Enum.Font.GothamBold,
Text = string.upper(text),
TextColor3 = Color3.fromRGB(255, 130, 140),
TextSize = 10,
TextXAlignment = Enum.TextXAlignment.Left
}, holder)
return holder
end
local function CreatePinButton(holder)
local pinBtn = InstanceNew("TextButton", {
AnchorPoint = Vector2.new(1, 0),
Position = UDim2.new(1, 0, 0, 0),
Size = UDim2.new(0, 32, 1, 0),
BackgroundColor3 = Theme.ItemHover,
BorderSizePixel = 0,
AutoButtonColor = false,
Font = Enum.Font.GothamBold,
Text = "\240\159\147\140",
TextColor3 = Theme.Text,
TextSize = 14
}, holder)
ApplyCorner(pinBtn, 10)
AddEffects(pinBtn)
return pinBtn
end
local function CreateButton(page, text, callback)
local holder = InstanceNew("Frame", {
BackgroundTransparency = 1,
Size = UDim2.new(1, -8, 0, 32),
LayoutOrder = GetNextOrder()
}, page)
local b = InstanceNew("TextButton", {
Size = UDim2.new(1, -38, 1, 0),
BackgroundColor3 = Theme.ItemHover,
BorderSizePixel = 0,
AutoButtonColor = false,
Font = Enum.Font.GothamSemibold,
Text = text,
TextColor3 = Theme.Text,
TextSize = 11,
TextWrapped = true
}, holder)
ApplyCorner(b, 10)
AddEffects(b)
local pinBtn = CreatePinButton(holder)
local floatBtn = nil
local function Fire()
task.spawn(callback, b)
if floatBtn then
floatBtn.Text = b.Text
end
end
b.MouseButton1Click:Connect(Fire)
pinBtn.MouseButton1Click:Connect(function()
if floatBtn then
floatBtn:Destroy()
floatBtn = nil
Tween(pinBtn, 0.2, { BackgroundColor3 = Theme.ItemHover })
else
floatBtn = CreateFloatButton(b.Text, Fire)
Tween(pinBtn, 0.2, { BackgroundColor3 = Theme.Accent })
end
end)
return b
end
local function CreateToggle(page, text, defaultState, callback)
local holder = InstanceNew("Frame", {
BackgroundTransparency = 1,
Size = UDim2.new(1, -8, 0, 32),
LayoutOrder = GetNextOrder()
}, page)
local b = InstanceNew("TextButton", {
Size = UDim2.new(1, -38, 1, 0),
BackgroundColor3 = Theme.Item,
BorderSizePixel = 0,
AutoButtonColor = false,
Text = ""
}, holder)
ApplyCorner(b, 10)
AddEffects(b)
InstanceNew("TextLabel", {
BackgroundTransparency = 1,
Position = UDim2.new(0, 12, 0, 0),
Size = UDim2.new(1, -76, 1, 0),
Font = Enum.Font.GothamSemibold,
Text = text,
TextColor3 = Theme.Text,
TextSize = 11,
TextWrapped = true,
TextXAlignment = Enum.TextXAlignment.Left
}, b)
local pill = InstanceNew("Frame", {
AnchorPoint = Vector2.new(1, 0.5),
Position = UDim2.new(1, -10, 0.5, 0),
Size = UDim2.fromOffset(36, 18),
BackgroundColor3 = Theme.Off,
BorderSizePixel = 0
}, b)
ApplyCorner(pill, 12)
local knob = InstanceNew("Frame", {
Position = UDim2.fromOffset(2, 2),
Size = UDim2.fromOffset(14, 14),
BackgroundColor3 = Color3.new(1, 1, 1),
BorderSizePixel = 0
}, pill)
ApplyCorner(knob, 10)
local pinBtn = CreatePinButton(holder)
local state = false
local floatBtn = nil
local function PaintFloat()
if floatBtn then
Tween(floatBtn, 0.2, { BackgroundColor3 = state and Theme.On or Theme.ItemHover })
end
end
local function SetState(val)
state = val
Tween(pill, 0.2, { BackgroundColor3 = state and Theme.On or Theme.Off })
Tween(knob, 0.2, { Position = state and UDim2.fromOffset(20, 2) or UDim2.fromOffset(2, 2) }, Enum.EasingStyle.Back)
PaintFloat()
task.spawn(callback, state)
end
b.MouseButton1Click:Connect(function()
SetState(not state)
end)
pinBtn.MouseButton1Click:Connect(function()
if floatBtn then
floatBtn:Destroy()
floatBtn = nil
Tween(pinBtn, 0.2, { BackgroundColor3 = Theme.ItemHover })
else
floatBtn = CreateFloatButton(text, function()
SetState(not state)
end)
Tween(pinBtn, 0.2, { BackgroundColor3 = Theme.Accent })
floatBtn.BackgroundColor3 = state and Theme.On or Theme.ItemHover
end
end)
if defaultState then
SetState(true)
end
return SetState
end
local function CreateInput(page, placeholder, callback)
local box = InstanceNew("TextBox", {
Size = UDim2.new(1, -8, 0, 32),
BackgroundColor3 = Theme.Item,
BorderSizePixel = 0,
Font = Enum.Font.GothamMedium,
PlaceholderText = placeholder,
PlaceholderColor3 = Theme.SubText,
Text = "",
TextColor3 = Theme.Text,
TextSize = 11,
TextXAlignment = Enum.TextXAlignment.Left,
ClearTextOnFocus = false,
LayoutOrder = GetNextOrder()
}, page)
ApplyCorner(box, 10)
InstanceNew("UIPadding", { PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 14) }, box)
local stroke = ApplyStroke(box, Theme.Accent, 1, 0.78)
box.Focused:Connect(function()
Tween(stroke, 0.15, { Transparency = 0, Thickness = 2 })
end)
box.FocusLost:Connect(function()
Tween(stroke, 0.2, { Transparency = 0.78, Thickness = 1 })
if box.Text ~= "" then
task.spawn(callback, box.Text)
end
end)
return box
end
local pageMove = AddTab("\240\159\143\131 Di Chuy\225\187\131n")
local pagePlayers = AddTab("\240\159\145\165 B\195\161m Ch\195\162n")
local pageAbility = AddTab("\226\156\168 N\196\131ng L\225\187\177c")
local pageCombat = AddTab("\240\159\142\175 Chi\225\186\191n \196\144\225\186\165u")
local pageVisual = AddTab("\240\159\145\129 H\195\172nh \225\186\162nh")
local pageGraphics = AddTab("\240\159\150\165 \196\144\225\187\147 H\225\187\141a")
local pageNet = AddTab("\240\159\147\161 M\225\186\161ng")
local menuOpen = true
local function SetMenuOpen(open)
menuOpen = open
if open then
MainFrame.Visible = true
mainScale.Scale = 0.8
MainFrame.GroupTransparency = 1
Tween(mainScale, 0.35, { Scale = 1 }, Enum.EasingStyle.Back)
Tween(MainFrame, 0.25, { GroupTransparency = 0 })
else
Tween(mainScale, 0.2, { Scale = 0.85 })
local fade = Tween(MainFrame, 0.2, { GroupTransparency = 1 })
fade.Completed:Connect(function()
if not menuOpen then
MainFrame.Visible = false
end
end)
end
end
local isMinimized, isMaximized = false, false
local function ResizeMain(size)
Tween(MainFrame, 0.35, { Size = size }, Enum.EasingStyle.Quint)
end
MinimizeBtn.MouseButton1Click:Connect(function()
isMinimized = not isMinimized
isMaximized = false
MinimizeBtn.Text = isMinimized and "+" or "-"
MaximizeBtn.Text = "\240\159\151\150"
if isMinimized then
ResizeMain(sizeMin)
task.delay(0.35, function()
if isMinimized then
Body.Visible = false
end
end)
else
Body.Visible = true
ResizeMain(sizeNormal)
end
end)
MaximizeBtn.MouseButton1Click:Connect(function()
isMaximized = not isMaximized
isMinimized = false
Body.Visible = true
MinimizeBtn.Text = "-"
MaximizeBtn.Text = isMaximized and "\240\159\151\151" or "\240\159\151\150"
ResizeMain(isMaximized and sizeBig or sizeNormal)
end)
local ICON_PARTS = {
"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"
}
local function DecodeBase64(data)
local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
local lookup = {}
for i = 1, 64 do
lookup[chars:sub(i, i)] = i - 1
end
local out, buffer, bits = {}, 0, 0
for i = 1, #data do
local v = lookup[data:sub(i, i)]
if v then
buffer = buffer * 64 + v
bits = bits + 6
if bits >= 8 then
bits = bits - 8
local byte = math.floor(buffer / 2 ^ bits)
buffer = buffer % 2 ^ bits
out[#out + 1] = string.char(byte)
end
end
end
return table.concat(out)
end
local function LoadIconAsset()
if not (writefile and getcustomasset) then
return nil
end
local ok, asset = pcall(function()
local path = "MenuSieuToc_icon.jpg"
writefile(path, DecodeBase64(table.concat(ICON_PARTS)))
return getcustomasset(path)
end)
if ok and asset and asset ~= "" then
return asset
end
return nil
end
local iconAsset = LoadIconAsset()
local ICON_SIZE = 46
local MenuIcon = InstanceNew("ImageButton", {
Position = UDim2.new(0, 12, 0, 12),
Size = UDim2.fromOffset(ICON_SIZE, ICON_SIZE),
BackgroundColor3 = Theme.Accent,
BorderSizePixel = 0,
AutoButtonColor = false,
Image = iconAsset or "",
ScaleType = Enum.ScaleType.Crop
}, FloatScreenGui)
ApplyCorner(MenuIcon, ICON_SIZE / 2)
local iconStroke = ApplyStroke(MenuIcon, Theme.Accent, 3, 0)
TweenService:Create(
iconStroke,
TweenInfo.new(1.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
{ Transparency = 0.75, Thickness = 5 }
):Play()
local iconScale = InstanceNew("UIScale", { Scale = 1 }, MenuIcon)
MenuIcon.MouseEnter:Connect(function()
Tween(iconScale, 0.15, { Scale = 1.1 })
end)
MenuIcon.MouseLeave:Connect(function()
Tween(iconScale, 0.15, { Scale = 1 })
end)
MenuIcon.MouseButton1Down:Connect(function()
Tween(iconScale, 0.08, { Scale = 0.92 })
end)
MenuIcon.MouseButton1Up:Connect(function()
Tween(iconScale, 0.15, { Scale = 1.1 }, Enum.EasingStyle.Back)
end)
if not iconAsset then
InstanceNew("TextLabel", {
BackgroundTransparency = 1,
Size = UDim2.new(1, 0, 1, 0),
Font = Enum.Font.GothamBold,
Text = "\226\154\161",
TextColor3 = Theme.Text,
TextSize = 26
}, MenuIcon)
end
local iconDrag = MakeDraggable(MenuIcon, MenuIcon)
MenuIcon.MouseButton1Click:Connect(function()
if not iconDrag.IsDragging() then
SetMenuOpen(not menuOpen)
end
end)
UserInputService.InputBegan:Connect(function(inp, gameProcessed)
if not gameProcessed and inp.KeyCode == Enum.KeyCode.RightShift then
SetMenuOpen(not menuOpen)
end
end)
local currentJump = 50
local jumpLock = false
local function RunIntro()
local introGui = InstanceNew("ScreenGui", {
Name = "MenuSieuToc_Intro",
ResetOnSpawn = false,
IgnoreGuiInset = true,
DisplayOrder = 50,
ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, GuiParent)
local cover = InstanceNew("Frame", {
Size = UDim2.new(1, 0, 1, 0),
BackgroundColor3 = Theme.Bg,
BackgroundTransparency = 0.25,
BorderSizePixel = 0,
Active = true
}, introGui)
InstanceNew("UIGradient", {
Color = ColorSequence.new(Theme.Bg, Color3.fromRGB(70, 14, 26)),
Rotation = 90
}, cover)
local center = InstanceNew("Frame", {
AnchorPoint = Vector2.new(0.5, 0.5),
Position = UDim2.new(0.5, 0, 0.5, 0),
Size = UDim2.fromOffset(280, 230),
BackgroundTransparency = 1
}, cover)
local logo = InstanceNew("ImageLabel", {
AnchorPoint = Vector2.new(0.5, 0),
Position = UDim2.new(0.5, 0, 0, 0),
Size = UDim2.fromOffset(110, 110),
BackgroundColor3 = Theme.Accent,
BorderSizePixel = 0,
Image = iconAsset or "",
ScaleType = Enum.ScaleType.Crop
}, center)
ApplyCorner(logo, 55)
local logoStroke = ApplyStroke(logo, Theme.Accent, 4, 0)
TweenService:Create(
logoStroke,
TweenInfo.new(0.7, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
{ Transparency = 0.7, Thickness = 8 }
):Play()
if not iconAsset then
InstanceNew("TextLabel", {
BackgroundTransparency = 1,
Size = UDim2.new(1, 0, 1, 0),
Font = Enum.Font.GothamBold,
Text = "\226\154\161",
TextColor3 = Theme.Text,
TextSize = 48
}, logo)
end
InstanceNew("TextLabel", {
BackgroundTransparency = 1,
Position = UDim2.new(0, 0, 0, 122),
Size = UDim2.new(1, 0, 0, 26),
Font = Enum.Font.GothamBlack,
Text = "\226\154\161 MENU SI\195\138U T\225\187\144C PRO",
TextColor3 = Theme.Text,
TextSize = 20
}, center)
local title = InstanceNew("TextLabel", {
BackgroundTransparency = 1,
Position = UDim2.new(0, 0, 0, 154),
Size = UDim2.new(1, 0, 0, 20),
Font = Enum.Font.GothamMedium,
Text = "\196\144ang kh\225\187\159i \196\145\225\187\153ng... 5s",
TextColor3 = Theme.SubText,
TextSize = 13
}, center)
local track = InstanceNew("Frame", {
AnchorPoint = Vector2.new(0.5, 0),
Position = UDim2.new(0.5, 0, 0, 188),
Size = UDim2.new(1, 0, 0, 8),
BackgroundColor3 = Theme.Item,
BorderSizePixel = 0
}, center)
ApplyCorner(track, 4)
local fill = InstanceNew("Frame", {
Size = UDim2.new(0, 0, 1, 0),
BackgroundColor3 = Theme.Accent,
BorderSizePixel = 0
}, track)
ApplyCorner(fill, 4)
local outline = nil
local pulse = nil
local function Attach(char)
if outline then outline:Destroy() end
if pulse then pulse:Cancel() end
if not char then return end
outline = InstanceNew("Highlight", {
Name = "IntroOutline",
Adornee = char,
FillTransparency = 1,
OutlineColor = Color3.fromRGB(255, 0, 0),
OutlineTransparency = 0,
DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
}, char)
pulse = TweenService:Create(
outline,
TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
{ OutlineTransparency = 0.6, FillTransparency = 0.8 }
)
pulse:Play()
end
Attach(LocalPlayer.Character)
local respawnConn = LocalPlayer.CharacterAdded:Connect(function(char)
task.wait(0.2)
Attach(char)
end)
Tween(fill, 5, { Size = UDim2.new(1, 0, 1, 0) }, Enum.EasingStyle.Linear)
local startTime = tick()
while true do
local left = 5 - (tick() - startTime)
if left <= 0 then break end
title.Text = string.format("\196\144ang kh\225\187\159i \196\145\225\187\153ng... %ds", math.ceil(left))
task.wait(0.1)
end
respawnConn:Disconnect()
if pulse then pulse:Cancel() end
if outline then outline:Destroy() end
introGui:Destroy()
end
MainFrame.Visible = false
MenuIcon.Visible = false
menuOpen = false
task.spawn(function()
pcall(RunIntro)
MenuIcon.Visible = true
SelectTab("\240\159\143\131 Di Chuy\225\187\131n")
SetMenuOpen(true)
end)
do
local currentSpeed = 16 * 1.05
local speedLock = true
RunService.Heartbeat:Connect(function()
local hum = GetHumanoid()
if hum then
if speedLock and hum.WalkSpeed ~= currentSpeed then
hum.WalkSpeed = currentSpeed
end
if jumpLock then
if not hum.UseJumpPower then hum.UseJumpPower = true end
if hum.JumpPower ~= currentJump then hum.JumpPower = currentJump end
end
end
end)
local function SetSpeed(speed)
currentSpeed = speed
speedLock = true
local hum = GetHumanoid()
if hum then hum.WalkSpeed = speed end
end
CreateSection(pageMove, "T\225\187\145c \196\144\225\187\153 Di Chuy\225\187\131n")
CreateInput(pageMove, "Nh\225\186\173p t\225\187\145c \196\145\225\187\153 (VD: 100)", function(val)
local n = tonumber(val)
if n then SetSpeed(n) end
end)
CreateButton(pageMove, "T\225\187\145c \196\144\225\187\153 Si\195\170u T\225\187\145c (100)", function() SetSpeed(100) end)
CreateButton(pageMove, "\196\144\225\186\183t L\225\186\161i M\225\186\183c \196\144\225\187\139nh (16)", function()
currentSpeed = 16
speedLock = false
local hum = GetHumanoid()
if hum then hum.WalkSpeed = 16 end
end)
CreateSection(pageMove, "K\195\173ch Th\198\176\225\187\155c C\198\161 Th\225\187\131")
CreateInput(pageMove, "Nh\225\186\173p T\225\187\183 L\225\187\135 K\195\173ch Th\198\176\225\187\155c (VD: 2.5)", function(val)
local scale = tonumber(val)
local char = LocalPlayer.Character
if scale and scale > 0 and char then
for _, part in ipairs(char:GetDescendants()) do
if part:IsA("BasePart") then
if not part:FindFirstChild("OriginalSize") then
InstanceNew("Vector3Value", { Name = "OriginalSize", Value = part.Size }, part)
end
part.Size = (part.Name == "HumanoidRootPart") and Vector3.new(2, 2, 1) * scale or part.OriginalSize.Value * scale
end
end
local hum = GetHumanoid()
if hum then hum.HipHeight = 2 * scale end
end
end)
CreateSection(pageMove, "B\225\186\163o V\225\187\135 & Ch\225\187\145ng Kh\225\187\145ng Ch\225\186\191")
local antiStunConn = nil
CreateToggle(pageMove, "Ch\225\187\145ng Stun/\196\144\195\179ng B\196\131ng/Kh\225\187\145ng Ch\225\186\191", false, function(enabled)
if enabled then
antiStunConn = RunService.Heartbeat:Connect(function()
local char = LocalPlayer.Character
local hum = GetHumanoid()
if hum then
hum.PlatformStand = false
hum.Sit = false
hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
hum:SetStateEnabled(Enum.HumanoidStateType.Stunned, false)
if hum.WalkSpeed <= 0 then hum.WalkSpeed = currentSpeed end
end
if char then
for _, child in ipairs(char:GetChildren()) do
if child:IsA("ValueBase") then
local name = child.Name:lower()
if name:find("stun") or name:find("freeze") or name:find("slow") or name:find("bind") then
child:Destroy()
end
end
end
end
end)
elseif antiStunConn then
antiStunConn:Disconnect()
antiStunConn = nil
end
end)
CreateSection(pageMove, "\196\144i\225\187\131m Teleport")
local waypoints = {}
for i = 1, 3 do
local row = InstanceNew("Frame", {
BackgroundTransparency = 1,
Size = UDim2.new(1, -8, 0, 28),
LayoutOrder = GetNextOrder()
}, pageMove)
InstanceNew("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 6) }, row)
local btnSave = InstanceNew("TextButton", {
Size = UDim2.new(0.5, -3, 1, 0),
BackgroundColor3 = Theme.ItemHover,
BorderSizePixel = 0,
Font = Enum.Font.GothamSemibold,
Text = "\240\159\146\190 L\198\176u " .. i,
TextColor3 = Theme.Text,
TextSize = 12
}, row)
ApplyCorner(btnSave, 8)
local btnTp = InstanceNew("TextButton", {
Size = UDim2.new(0.5, -3, 1, 0),
BackgroundColor3 = Color3.fromRGB(16, 185, 129),
BorderSizePixel = 0,
Font = Enum.Font.GothamBold,
Text = "\226\154\161 TP " .. i,
TextColor3 = Theme.Text,
TextSize = 12
}, row)
ApplyCorner(btnTp, 8)
btnSave.MouseButton1Click:Connect(function()
local root = GetRoot(LocalPlayer.Character)
if root then
waypoints[i] = root.CFrame
btnSave.BackgroundColor3 = Theme.On
task.delay(0.4, function() btnSave.BackgroundColor3 = Theme.ItemHover end)
end
end)
btnTp.MouseButton1Click:Connect(function()
local root = GetRoot(LocalPlayer.Character)
if root and waypoints[i] then
root.CFrame = waypoints[i]
end
end)
end
end
do
CreateSection(pageAbility, "S\225\187\169c Nh\225\186\163y")
CreateInput(pageAbility, "L\225\187\177c nh\225\186\163y (VD: 150)", function(val)
local n = tonumber(val)
if n then
currentJump = math.clamp(n, 0, 5000)
jumpLock = true
local hum = GetHumanoid()
if hum then hum.JumpPower = currentJump end
end
end)
CreateButton(pageAbility, "Nh\225\186\163y Cao (200)", function() currentJump = 200; jumpLock = true end)
local infiniteJump = false
CreateToggle(pageAbility, "Nh\225\186\163y V\195\180 H\225\186\161n Tr\195\170n Kh\195\180ng", false, function(v) infiniteJump = v end)
UserInputService.JumpRequest:Connect(function()
if infiniteJump then
local hum = GetHumanoid()
if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end
end)
CreateSection(pageAbility, "Xuy\195\170n T\198\176\225\187\157ng (Noclip)")
local noclipConn = nil
local noclipOriginal = setmetatable({}, { __mode = "k" })
local function RestoreNoclip()
for part, wasSolid in pairs(noclipOriginal) do
if wasSolid and part.Parent then
part.CanCollide = true
end
noclipOriginal[part] = nil
end
local root = GetRoot(LocalPlayer.Character)
if root then
root.AssemblyLinearVelocity = Vector3.zero
end
end
CreateToggle(pageAbility, "K\195\173ch Ho\225\186\161t Xuy\195\170n T\198\176\225\187\157ng", false, function(enabled)
if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
if enabled then
noclipConn = RunService.Stepped:Connect(function()
local char = LocalPlayer.Character
if char then
for _, p in ipairs(char:GetDescendants()) do
if p:IsA("BasePart") then
if noclipOriginal[p] == nil then
noclipOriginal[p] = p.CanCollide
end
if p.CanCollide then p.CanCollide = false end
end
end
end
end)
else
RestoreNoclip()
end
end)
CreateSection(pageAbility, "T\195\160ng H\195\172nh")
local invisConn = nil
local invisOriginal = setmetatable({}, { __mode = "k" })
local function RestoreInvisible()
for obj, value in pairs(invisOriginal) do
if obj.Parent then
obj.Transparency = value
end
invisOriginal[obj] = nil
end
end
CreateToggle(pageAbility, "T\195\160ng H\195\172nh (B\225\186\165m \196\144\225\187\131 \225\186\168n / Hi\225\187\135n)", false, function(enabled)
if invisConn then invisConn:Disconnect(); invisConn = nil end
if enabled then
invisConn = RunService.RenderStepped:Connect(function()
local char = LocalPlayer.Character
if not char then return end
for _, obj in ipairs(char:GetDescendants()) do
if (obj:IsA("BasePart") and obj.Name ~= "HumanoidRootPart") or obj:IsA("Decal") then
if invisOriginal[obj] == nil then
invisOriginal[obj] = obj.Transparency
end
if obj.Transparency ~= 1 then
obj.Transparency = 1
end
end
end
end)
else
RestoreInvisible()
end
end)
CreateSection(pageAbility, "S\195\160n \196\144\225\186\165t \225\186\162o (Platform)")
local vPlatform, vConn = nil, nil
local platformY = 0
local platformFollow = false
local function GetFeetY()
local root, hum = GetRoot(LocalPlayer.Character), GetHumanoid()
if root and hum then
return root.Position.Y - (hum.HipHeight + root.Size.Y / 2) - 0.5
end
return nil
end
local function ClearPlatform()
if vConn then vConn:Disconnect(); vConn = nil end
if vPlatform then vPlatform:Destroy(); vPlatform = nil end
end
CreateToggle(pageAbility, "T\225\186\161o \196\144\225\186\165t \196\144\225\187\169ng \225\186\162o", false, function(v)
ClearPlatform()
if v then
platformY = GetFeetY() or 0
vPlatform = InstanceNew("Part", {
Name = "VirtualPlatform",
Anchored = true,
CanCollide = true,
Size = Vector3.new(16, 1, 16),
Material = Enum.Material.Neon,
Color = Theme.Accent,
Transparency = 0.4,
CastShadow = false
}, Workspace)
vConn = RunService.Heartbeat:Connect(function()
local root = GetRoot(LocalPlayer.Character)
if root and vPlatform then
if platformFollow then
local y = GetFeetY()
if y then platformY = y end
end
vPlatform.CFrame = CFrame.new(root.Position.X, platformY, root.Position.Z)
end
end)
end
end)
CreateToggle(pageAbility, "\196\144\225\186\165t \225\186\162o B\195\161m Ch\195\162n (\196\144i Theo)", false, function(v) platformFollow = v end)
CreateButton(pageAbility, "N\195\162ng \196\144\225\186\165t +5m", function() platformY = platformY + 5 end)
CreateButton(pageAbility, "H\225\186\161 \196\144\225\186\165t -5m", function() platformY = platformY - 5 end)
CreateSection(pageAbility, "D\225\187\139ch Chuy\225\187\131n Theo Tr\225\187\165c Y")
local skyHeight = 500
CreateButton(pageAbility, "\226\152\129 Teleport L\195\170n Tr\225\187\157i", function()
local root = GetRoot(LocalPlayer.Character)
if root then
root.CFrame = root.CFrame + Vector3.new(0, skyHeight, 0)
if vPlatform then platformY = platformY + skyHeight end
end
end)
CreateButton(pageAbility, "\240\159\140\141 B\225\186\173t Nh\225\186\163y Xu\225\187\145ng \196\144\225\186\165t", function()
local root = GetRoot(LocalPlayer.Character)
if root then
local params = RaycastParams.new()
params.FilterType = Enum.RaycastFilterType.Exclude
params.FilterDescendantsInstances = { LocalPlayer.Character, vPlatform }
local hit = Workspace:Raycast(root.Position, Vector3.new(0, -10000, 0), params)
if hit then
root.CFrame = CFrame.new(hit.Position + Vector3.new(0, 4, 0))
if vPlatform then platformY = GetFeetY() or platformY end
end
end
end)
end
do
local aimEnabled = false
local aimAll = false
local aimFov = 150
local aimSmooth = 0.35
local aimWall = true
local aimPart = "Head"
local rmbHeld = false
local aimSticky = false
local lockedPart = nil
local fovCircle = InstanceNew("Frame", {
AnchorPoint = Vector2.new(0.5, 0.5),
Position = UDim2.new(0.5, 0, 0.5, 0),
Size = UDim2.fromOffset(aimFov * 2, aimFov * 2),
BackgroundTransparency = 1,
Visible = false
}, MainScreenGui)
ApplyCorner(fovCircle, 1000)
ApplyStroke(fovCircle, Theme.Text, 1, 0.4)
UserInputService.InputBegan:Connect(function(i)
if i.UserInputType == Enum.UserInputType.MouseButton2 then rmbHeld = true end
end)
UserInputService.InputEnded:Connect(function(i)
if i.UserInputType == Enum.UserInputType.MouseButton2 then rmbHeld = false end
end)
local function IsTargetVisible(part, char)
local cam = Workspace.CurrentCamera
local params = RaycastParams.new()
params.FilterType = Enum.RaycastFilterType.Exclude
params.FilterDescendantsInstances = { LocalPlayer.Character }
local res = Workspace:Raycast(cam.CFrame.Position, part.Position - cam.CFrame.Position, params)
return res == nil or res.Instance:IsDescendantOf(char)
end
local function GetAimTarget()
local cam = Workspace.CurrentCamera
local center = cam.ViewportSize / 2
local bestTarget, bestDist = nil, math.huge
for _, p in ipairs(Players:GetPlayers()) do
if p ~= LocalPlayer and (aimAll or IsEnemy(p)) and p.Character then
local hum = p.Character:FindFirstChildOfClass("Humanoid")
local part = p.Character:FindFirstChild(aimPart)
if hum and hum.Health > 0 and part then
local pos, onScreen = cam:WorldToViewportPoint(part.Position)
if onScreen then
local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
if dist <= aimFov and dist < bestDist then
if not aimWall or IsTargetVisible(part, p.Character) then
bestTarget = part
bestDist = dist
end
end
end
end
end
end
return bestTarget
end
RunService.RenderStepped:Connect(function()
fovCircle.Visible = aimEnabled
if not aimEnabled then return end
fovCircle.Size = UDim2.fromOffset(aimFov * 2, aimFov * 2)
local isTouch = realInput.TouchEnabled and not realInput.KeyboardEnabled
if isTouch or rmbHeld then
local target = nil
if aimSticky and lockedPart and lockedPart.Parent then
local lockedHum = lockedPart.Parent:FindFirstChildOfClass("Humanoid")
if lockedHum and lockedHum.Health > 0 then
target = lockedPart
end
end
if not target then
target = GetAimTarget()
lockedPart = target
end
if target then
local cam = Workspace.CurrentCamera
cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position, target.Position), aimSmooth)
end
else
lockedPart = nil
end
end)
CreateSection(pageCombat, "H\225\187\135 Th\225\187\145ng Aimbot")
CreateToggle(pageCombat, "B\225\186\173t Aimbot (Gi\225\187\175 chu\225\187\153t ph\225\186\163i)", false, function(v) aimEnabled = v end)
CreateToggle(pageCombat, "Aim T\225\186\165t C\225\186\163 Ng\198\176\225\187\157i Ch\198\161i (T\225\186\175t = Ch\225\187\137 Aim \196\144\225\187\139ch)", false, function(v) aimAll = v end)
CreateToggle(pageCombat, "Ki\225\187\131m Tra V\225\186\173t C\225\186\163n (Wallcheck)", true, function(v) aimWall = v end)
CreateButton(pageCombat, "\196\144\225\187\149i M\225\187\165c Ti\195\170u: \196\144\225\186\167u / Th\195\162n", function(b)
aimPart = (aimPart == "Head") and "HumanoidRootPart" or "Head"
b.Text = "M\225\187\165c Ti\195\170u: " .. (aimPart == "Head" and "\196\144\225\186\167u" or "Th\195\162n")
end)
CreateInput(pageCombat, "B\195\161n k\195\173nh FOV (VD: 150)", function(val)
local n = tonumber(val)
if n then aimFov = math.clamp(n, 30, 800) end
end)
CreateInput(pageCombat, "\196\144\225\187\153 b\195\161m c\225\187\169ng Aim (1 - 100, VD: 80)", function(val)
local n = tonumber(val)
if n then aimSmooth = math.clamp(n, 1, 100) / 100 end
end)
CreateToggle(pageCombat, "Kh\195\179a D\195\173nh M\225\187\165c Ti\195\170u (Kh\195\180ng \196\144\225\187\149i M\225\187\165c Ti\195\170u)", false, function(v)
aimSticky = v
if not v then lockedPart = nil end
end)
local triggerEnabled = false
local triggerRate = 12
local triggerOnTarget = false
local triggerId = 0
local triggerLastCheck = 0
local TriggerInput = game:GetService("VirtualInputManager")
local triggerParams = RaycastParams.new()
triggerParams.FilterType = Enum.RaycastFilterType.Exclude
local function GetCrosshairEnemy()
local cam = Workspace.CurrentCamera
local myChar = LocalPlayer.Character
if not (cam and myChar) then
return nil
end
triggerParams.FilterDescendantsInstances = { myChar }
local result = Workspace:Raycast(cam.CFrame.Position, cam.CFrame.LookVector * 2000, triggerParams)
if not result then
return nil
end
local node = result.Instance
while node and node ~= Workspace do
local p = Players:GetPlayerFromCharacter(node)
if p then
if p ~= LocalPlayer and (aimAll or IsEnemy(p)) then
local hum = node:FindFirstChildOfClass("Humanoid")
if hum and hum.Health > 0 then
return p
end
end
return nil
end
node = node.Parent
end
return nil
end
RunService.Heartbeat:Connect(function()
if not triggerEnabled then
triggerOnTarget = false
return
end
local now = tick()
if now - triggerLastCheck < 0.03 then
return
end
triggerLastCheck = now
triggerOnTarget = GetCrosshairEnemy() ~= nil
end)
CreateSection(pageCombat, "T\225\187\177 \196\144\225\187\153ng B\225\186\175n")
CreateToggle(pageCombat, "T\225\187\177 \196\144\225\187\153ng B\225\186\175n Khi Aim Tr\195\186ng \196\144\225\187\139ch", false, function(v)
triggerEnabled = v
triggerId = triggerId + 1
triggerOnTarget = false
if v then
local id = triggerId
task.spawn(function()
while triggerEnabled and id == triggerId do
if triggerOnTarget then
local center = Workspace.CurrentCamera.ViewportSize / 2
PerformClick(center.X, center.Y)
task.wait(1 / triggerRate)
else
task.wait()
end
end
end)
end
end)
CreateInput(pageCombat, "T\225\187\145c \196\145\225\187\153 b\225\186\175n m\225\187\151i gi\195\162y (VD: 12)", function(val)
local n = tonumber(val)
if n then triggerRate = math.clamp(n, 1, 60) end
end)
CreateSection(pageCombat, "Chi\225\186\191n Thu\225\186\173t Teleport")
CreateButton(pageCombat, "\226\154\161 TP K\225\186\187 Y\225\186\191u M\195\161u Nh\225\186\165t", function()
local myRoot = GetRoot(LocalPlayer.Character)
if not myRoot then return end
local targetRoot, lowestPct = nil, 101
for _, p in ipairs(Players:GetPlayers()) do
if p ~= LocalPlayer and p.Character then
local hum = p.Character:FindFirstChildOfClass("Humanoid")
local root = GetRoot(p.Character)
if hum and root and hum.Health > 0 then
local pct = (hum.Health / hum.MaxHealth) * 100
if pct < lowestPct then
lowestPct = pct
targetRoot = root
end
end
end
end
if targetRoot then
myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 3)
end
end)
end
do
local espEnabled = false
local espScale = 1.3
local espCache = {}
local function ClearEsp(p)
if espCache[p] then
for _, obj in pairs(espCache[p]) do
if typeof(obj) == "Instance" then pcall(function() obj:Destroy() end) end
end
espCache[p] = nil
end
end
local function BuildEsp(char)
local root, hum = GetRoot(char), char:FindFirstChildOfClass("Humanoid")
if not (root and hum) then return nil end
local hl = InstanceNew("Highlight", {
Name = "ESPHighlight",
Adornee = char,
FillTransparency = 0.65,
OutlineTransparency = 0,
DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
}, char)
local box = InstanceNew("BoxHandleAdornment", {
Name = "ESPBox",
Adornee = root,
AlwaysOnTop = true,
ZIndex = 5,
Transparency = 0.8,
Size = char:GetExtentsSize() * espScale
}, root)
local bb = InstanceNew("BillboardGui", {
Name = "ESPInfo",
Adornee = char:FindFirstChild("Head") or root,
AlwaysOnTop = true,
Size = UDim2.fromOffset(180, 40),
StudsOffset = Vector3.new(0, 2.8, 0)
}, char)
local nameLabel = InstanceNew("TextLabel", {
BackgroundTransparency = 1,
Size = UDim2.new(1, 0, 0.5, 0),
Font = Enum.Font.GothamBold,
TextSize = 10,
TextColor3 = Theme.Text
}, bb)
local infoLabel = InstanceNew("TextLabel", {
BackgroundTransparency = 1,
Position = UDim2.new(0, 0, 0.5, 0),
Size = UDim2.new(1, 0, 0.5, 0),
Font = Enum.Font.GothamMedium,
TextSize = 11
}, bb)
return { char = char, hl = hl, box = box, bb = bb, nameLabel = nameLabel, infoLabel = infoLabel }
end
local function UpdateEsp()
local myRoot = GetRoot(LocalPlayer.Character)
for _, p in ipairs(Players:GetPlayers()) do
if p ~= LocalPlayer and p.Parent then
pcall(function()
local char = p.Character
local data = espCache[p]
if not char then
ClearEsp(p)
return
end
if not data or data.char ~= char or not data.hl.Parent then
ClearEsp(p)
data = BuildEsp(char)
espCache[p] = data
end
if data then
local hum = char:FindFirstChildOfClass("Humanoid")
local root = GetRoot(char)
local pct = hum and (hum.Health / hum.MaxHealth) or 0
local enemy = IsEnemy(p)
local color = enemy and Theme.Red or Theme.Blue
if enemy and pct < 0.35 and pct > 0 then color = Theme.Gold end
data.hl.FillColor = color
data.hl.OutlineColor = color
data.box.Color3 = color
data.box.Size = char:GetExtentsSize() * espScale
data.nameLabel.Text = p.DisplayName
data.nameLabel.TextColor3 = color
local dist = myRoot and math.floor((root.Position - myRoot.Position).Magnitude) or 0
data.infoLabel.Text = string.format("\226\157\164 %d%%  \226\128\162  %dm", math.floor(pct * 100), dist)
data.infoLabel.TextColor3 = Color3.fromHSV(pct * 0.33, 0.9, 1)
end
end)
end
end
end
Players.PlayerRemoving:Connect(ClearEsp)
CreateSection(pageVisual, "C\225\186\165u H\195\172nh ESP")
CreateToggle(pageVisual, "B\225\186\173t ESP Ng\198\176\225\187\157i Ch\198\161i", false, function(v)
espEnabled = v
if v then
task.spawn(function()
while espEnabled do
UpdateEsp()
task.wait(0.1)
end
end)
else
for p in pairs(espCache) do ClearEsp(p) end
end
end)
CreateSection(pageVisual, "Chi\225\186\191u S\195\161ng")
local fullbrightConn, fullbrightOrig = nil, nil
CreateToggle(pageVisual, "Nh\195\172n Trong B\195\179ng T\225\187\145i (Fullbright)", false, function(v)
if v then
fullbrightOrig = {
Brightness = Lighting.Brightness, ClockTime = Lighting.ClockTime,
GlobalShadows = Lighting.GlobalShadows, Ambient = Lighting.Ambient
}
fullbrightConn = RunService.RenderStepped:Connect(function()
Lighting.Brightness = 2
Lighting.ClockTime = 14
Lighting.GlobalShadows = false
Lighting.Ambient = Color3.fromRGB(190, 190, 190)
end)
else
if fullbrightConn then fullbrightConn:Disconnect(); fullbrightConn = nil end
if fullbrightOrig then
for prop, val in pairs(fullbrightOrig) do
pcall(function() Lighting[prop] = val end)
end
end
end
end)
end
do
local statusLabel
CreateSection(pageGraphics, "Tr\225\186\161ng Th\195\161i \196\144\225\187\147 H\225\187\141a")
statusLabel = InstanceNew("TextLabel", {
BackgroundColor3 = Theme.Item,
BorderSizePixel = 0,
Size = UDim2.new(1, -8, 0, 34),
Font = Enum.Font.GothamMedium,
Text = "Preset hi\225\187\135n t\225\186\161i: Th\198\176\225\187\157ng",
TextColor3 = Theme.SubText,
TextSize = 10,
LayoutOrder = GetNextOrder()
}, pageGraphics)
ApplyCorner(statusLabel, 8)
local presets = {
["M\198\176\225\187\163t (FPS Boost)"] = function()
pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
Lighting.GlobalShadows = false
for _, v in ipairs(Workspace:GetDescendants()) do
if v:IsA("BasePart") then
v.Material = Enum.Material.SmoothPlastic
v.CastShadow = false
elseif v:IsA("Decal") or v:IsA("Texture") then
v.Transparency = 1
end
end
end,
["\196\144\225\186\185p"] = function()
pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level10 end)
Lighting.GlobalShadows = true
end,
["Ultra High"] = function()
pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level21 end)
Lighting.GlobalShadows = true
end
}
for name, fn in pairs(presets) do
CreateButton(pageGraphics, name, function()
pcall(fn)
statusLabel.Text = "Preset hi\225\187\135n t\225\186\161i: " .. name
end)
end
CreateSection(pageGraphics, "G\195\179c Nh\195\172n (FOV)")
CreateInput(pageGraphics, "G\195\179c nh\195\172n FOV (30 - 120)", function(val)
local n = tonumber(val)
if n then Workspace.CurrentCamera.FieldOfView = math.clamp(n, 30, 120) end
end)
local hudLabel, hudConn = nil, nil
CreateSection(pageNet, "Gi\195\161m S\195\161t Hi\225\187\135u N\196\131ng")
CreateToggle(pageNet, "Hi\225\187\135n B\225\186\163ng Ping & FPS", false, function(v)
if hudConn then hudConn:Disconnect(); hudConn = nil end
if hudLabel then hudLabel:Destroy(); hudLabel = nil end
if v then
hudLabel = InstanceNew("TextLabel", {
Position = UDim2.new(0.5, -95, 0, 10),
Size = UDim2.fromOffset(190, 32),
BackgroundColor3 = Theme.Bar,
BorderSizePixel = 0,
Font = Enum.Font.GothamBold,
Text = "\240\159\147\161 ? ms  \226\128\162  ? FPS",
TextColor3 = Theme.Text,
TextSize = 10,
Active = true
}, FloatScreenGui)
ApplyCorner(hudLabel, 8)
ApplyStroke(hudLabel, Theme.Accent, 1.2)
MakeDraggable(hudLabel, hudLabel)
local acc, frames = 0, 0
hudConn = RunService.Heartbeat:Connect(function(dt)
acc = acc + dt
frames = frames + 1
if acc >= 0.5 then
local okPing, pingVal = pcall(function()
return Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
end)
local ping = okPing and math.floor(pingVal) or 0
local fps = math.floor(frames / acc)
acc, frames = 0, 0
hudLabel.Text = string.format("\240\159\147\161 %d ms  \226\128\162  %d FPS", ping, fps)
hudLabel.TextColor3 = ping < 80 and Theme.On or (ping < 150 and Theme.Gold or Theme.Red)
end
end)
end
end)
CreateSection(pageNet, "Th\195\180ng Tin Ph\195\178ng Played")
local onlineLabel = nil
CreateToggle(pageNet, "Hi\225\187\135n S\225\187\145 Ng\198\176\225\187\157i Online", true, function(v)
if onlineLabel then onlineLabel:Destroy(); onlineLabel = nil end
if v then
onlineLabel = InstanceNew("TextLabel", {
AnchorPoint = Vector2.new(1, 0),
Position = UDim2.new(1, -12, 0, 10),
Size = UDim2.fromOffset(150, 32),
BackgroundColor3 = Theme.Bar,
BorderSizePixel = 0,
Font = Enum.Font.GothamBold,
Text = string.format("\240\159\145\165 %d / %d Online", #Players:GetPlayers(), Players.MaxPlayers),
TextColor3 = Theme.On,
TextSize = 10,
Active = true
}, FloatScreenGui)
ApplyCorner(onlineLabel, 8)
ApplyStroke(onlineLabel, Theme.Accent, 1.2)
MakeDraggable(onlineLabel, onlineLabel)
end
end)
end
do
local VirtualInputManager = game:GetService("VirtualInputManager")
local autoClickEnabled = false
local autoClickRate = 10
local autoClickId = 0
local function GetClickPoint()
if realInput.MouseEnabled and not realInput.TouchEnabled then
return UserInputService:GetMouseLocation()
end
return Workspace.CurrentCamera.ViewportSize / 2
end
CreateSection(pageCombat, "T\225\187\177 \196\144\225\187\153ng B\225\186\165m M\195\160n H\195\172nh")
CreateInput(pageCombat, "S\225\187\145 l\225\186\167n b\225\186\165m m\225\187\151i gi\195\162y (VD: 10)", function(val)
local n = tonumber(val)
if n then autoClickRate = math.clamp(n, 1, 60) end
end)
CreateToggle(pageCombat, "T\225\187\177 \196\144\225\187\153ng B\225\186\165m V\195\160o M\195\160n H\195\172nh", false, function(v)
autoClickEnabled = v
autoClickId = autoClickId + 1
if v then
local id = autoClickId
task.spawn(function()
while autoClickEnabled and id == autoClickId do
local point = GetClickPoint()
PerformClick(point.X, point.Y)
task.wait(1 / autoClickRate)
end
end)
end
end)
end
do
local NEW_JOIN_WINDOW = 30
local joinTimes = {}
local chosenList = {}
local currentTarget = nil
local stickEnabled = false
local stickConn = nil
local stickCollideConn = nil
local stickOffsetY = 0
local stickBack = 3
local stickOriginal = setmetatable({}, { __mode = "k" })
local serverRows = {}
local chosenRows = {}
local chosenSignature = ""
local RefreshAll
local RefreshChosenList
local UpdateStatus
local StartStick
local StopStick
local function AvatarUrl(p)
return "rbxthumb://type=AvatarHeadShot&id=" .. p.UserId .. "&w=150&h=150"
end
local function IsNewPlayer(p)
local t = joinTimes[p]
return t ~= nil and (tick() - t) < NEW_JOIN_WINDOW
end
local function IsAlive(p)
if not p or not p.Parent then
return false
end
local char = p.Character
local hum = char and char:FindFirstChildOfClass("Humanoid")
return hum ~= nil and hum.Health > 0 and GetRoot(char) ~= nil
end
local function DistanceTo(p)
local myRoot = GetRoot(LocalPlayer.Character)
local root = p.Character and GetRoot(p.Character)
if myRoot and root then
return (myRoot.Position - root.Position).Magnitude
end
return math.huge
end
local function DistanceText(d)
if d == math.huge then
return "? m"
end
return math.floor(d) .. " m"
end
local function MakeEmptyRow(parent, text)
return InstanceNew("TextLabel", {
BackgroundTransparency = 1,
Size = UDim2.new(1, 0, 0, 30),
Font = Enum.Font.GothamMedium,
Text = text,
TextColor3 = Theme.SubText,
TextSize = 10,
LayoutOrder = 99999
}, parent)
end
local function CreateListContainer(page)
local frame = InstanceNew("Frame", {
BackgroundColor3 = Theme.Bar,
BorderSizePixel = 0,
Size = UDim2.new(1, -8, 0, 0),
AutomaticSize = Enum.AutomaticSize.Y,
LayoutOrder = GetNextOrder()
}, page)
ApplyCorner(frame, 10)
ApplyStroke(frame, Theme.Accent, 1, 0.8)
InstanceNew("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }, frame)
InstanceNew("UIPadding", {
PaddingTop = UDim.new(0, 6),
PaddingBottom = UDim.new(0, 6),
PaddingLeft = UDim.new(0, 6),
PaddingRight = UDim.new(0, 6)
}, frame)
return frame
end
CreateSection(pagePlayers, "\196\144i\225\187\129u Khi\225\187\131n B\195\161m Ch\195\162n")
CreateToggle(pagePlayers, "B\195\161m Ch\195\162n Ng\198\176\225\187\157i \196\144\195\163 Ch\225\187\141n", false, function(v)
stickEnabled = v
if v then
StartStick()
else
StopStick()
end
end)
local statusCard = InstanceNew("Frame", {
BackgroundColor3 = Theme.Item,
BorderSizePixel = 0,
Size = UDim2.new(1, -8, 0, 60),
LayoutOrder = GetNextOrder()
}, pagePlayers)
ApplyCorner(statusCard, 10)
ApplyStroke(statusCard, Theme.Accent, 1, 0.6)
local statusAvatar = InstanceNew("ImageLabel", {
Position = UDim2.new(0, 10, 0.5, -21),
Size = UDim2.fromOffset(42, 42),
BackgroundColor3 = Theme.Bar,
BorderSizePixel = 0,
Visible = false
}, statusCard)
ApplyCorner(statusAvatar, 21)
ApplyStroke(statusAvatar, Theme.Accent, 2, 0)
local stickStatus = InstanceNew("TextLabel", {
BackgroundTransparency = 1,
Position = UDim2.new(0, 14, 0, 0),
Size = UDim2.new(1, -28, 1, 0),
Font = Enum.Font.GothamMedium,
Text = "Tr\225\186\161ng th\195\161i: \196\144ang t\225\186\175t",
TextColor3 = Theme.SubText,
TextSize = 11,
TextWrapped = true,
TextXAlignment = Enum.TextXAlignment.Left
}, statusCard)
CreateInput(pagePlayers, "Kho\225\186\163ng c\195\161ch ra sau l\198\176ng (VD: 3)", function(val)
local n = tonumber(val)
if n then stickBack = math.clamp(n, -20, 20) end
end)
CreateInput(pagePlayers, "\196\144\225\187\153 cao b\195\161m (VD: 0 ngang ch\195\162n, -3 th\225\186\165p h\198\161n)", function(val)
local n = tonumber(val)
if n then stickOffsetY = math.clamp(n, -50, 50) end
end)
CreateButton(pagePlayers, "\240\159\151\145 X\195\179a T\225\186\165t C\225\186\163 Ng\198\176\225\187\157i \196\144\195\163 Ch\225\187\141n", function()
chosenList = {}
currentTarget = nil
RefreshAll()
end)
CreateSection(pagePlayers, "\196\144\195\163 Ch\225\187\141n (B\195\161m L\225\186\167n L\198\176\225\187\163t T\225\187\171 Tr\195\170n Xu\225\187\145ng)")
local chosenContainer = CreateListContainer(pagePlayers)
local emptyChosenLabel = MakeEmptyRow(chosenContainer, "Ch\198\176a ch\225\187\141n ai. B\225\186\165m v\195\160o ng\198\176\225\187\157i ch\198\161i b\195\170n d\198\176\225\187\155i \196\145\225\187\131 ch\225\187\141n.")
CreateSection(pagePlayers, "Ng\198\176\225\187\157i Ch\198\161i Trong M\195\161y Ch\225\187\167 (G\225\186\167n \196\144\225\186\191n Xa)")
local newLabel = InstanceNew("TextLabel", {
BackgroundColor3 = Theme.Item,
BorderSizePixel = 0,
Size = UDim2.new(1, -8, 0, 28),
Font = Enum.Font.GothamBold,
Text = "\240\159\134\149 Ng\198\176\225\187\157i m\225\187\155i v\195\160o: 0",
TextColor3 = Theme.SubText,
TextSize = 10,
LayoutOrder = GetNextOrder()
}, pagePlayers)
ApplyCorner(newLabel, 10)
CreateButton(pagePlayers, "\240\159\148\132 L\195\160m M\225\187\155i Danh S\195\161ch Ng\198\176\225\187\157i Ch\198\161i", function()
RefreshAll()
end)
local serverContainer = CreateListContainer(pagePlayers)
local emptyServerLabel = MakeEmptyRow(serverContainer, "Ch\198\176a c\195\179 ng\198\176\225\187\157i ch\198\161i kh\195\161c trong m\195\161y ch\225\187\167")
local function ComputeSignature()
local parts = {}
for i, p in ipairs(chosenList) do
parts[i] = tostring(p.UserId)
end
return table.concat(parts, ",") .. "|" .. tostring(currentTarget and currentTarget.UserId) .. "|" .. tostring(stickEnabled)
end
local function UpdateChosenInfo()
for _, row in ipairs(chosenRows) do
local p = row.player
local alive = IsAlive(p)
local status = alive and "C\195\178n s\225\187\145ng" or "\240\159\146\128 \196\144\195\163 ch\225\186\191t"
if p == currentTarget and stickEnabled then
status = "\240\159\142\175 \196\144ang b\195\161m"
end
row.subLabel.Text = "@" .. p.Name .. "  \226\128\162  " .. status .. "  \226\128\162  " .. DistanceText(DistanceTo(p))
row.subLabel.TextColor3 = alive and Theme.SubText or Theme.Gold
end
end
local function CreateServerRow(p)
local btn = InstanceNew("TextButton", {
Size = UDim2.new(1, 0, 0, 52),
BackgroundColor3 = Theme.Item,
BorderSizePixel = 0,
AutoButtonColor = false,
Text = ""
}, serverContainer)
ApplyCorner(btn, 10)
AddEffects(btn)
local avatar = InstanceNew("ImageLabel", {
Position = UDim2.new(0, 8, 0.5, -18),
Size = UDim2.fromOffset(36, 36),
BackgroundColor3 = Theme.Bar,
BorderSizePixel = 0,
Image = AvatarUrl(p)
}, btn)
ApplyCorner(avatar, 18)
local nameLabel = InstanceNew("TextLabel", {
BackgroundTransparency = 1,
Position = UDim2.new(0, 54, 0, 8),
Size = UDim2.new(1, -118, 0, 18),
Font = Enum.Font.GothamBold,
Text = p.DisplayName,
TextColor3 = Theme.Text,
TextSize = 11,
TextXAlignment = Enum.TextXAlignment.Left,
TextTruncate = Enum.TextTruncate.AtEnd
}, btn)
local subLabel = InstanceNew("TextLabel", {
BackgroundTransparency = 1,
Position = UDim2.new(0, 54, 0, 28),
Size = UDim2.new(1, -118, 0, 16),
Font = Enum.Font.GothamMedium,
Text = "@" .. p.Name,
TextColor3 = Theme.SubText,
TextSize = 11,
TextXAlignment = Enum.TextXAlignment.Left,
TextTruncate = Enum.TextTruncate.AtEnd
}, btn)
local badge = InstanceNew("TextLabel", {
AnchorPoint = Vector2.new(1, 0.5),
Position = UDim2.new(1, -8, 0.5, 0),
Size = UDim2.fromOffset(46, 26),
BackgroundColor3 = Theme.Bar,
BorderSizePixel = 0,
Font = Enum.Font.GothamBold,
Text = "+",
TextColor3 = Theme.Text,
TextSize = 11
}, btn)
ApplyCorner(badge, 8)
btn.MouseButton1Click:Connect(function()
local idx = table.find(chosenList, p)
if idx then
table.remove(chosenList, idx)
if currentTarget == p then
currentTarget = nil
end
else
table.insert(chosenList, p)
end
RefreshAll()
end)
return {
btn = btn,
nameLabel = nameLabel,
subLabel = subLabel,
badge = badge,
isChosen = false
}
end
local function UpdateServerRows()
local entries = {}
for _, p in ipairs(Players:GetPlayers()) do
if p ~= LocalPlayer and p.Parent then
local row = serverRows[p]
if not row then
row = CreateServerRow(p)
serverRows[p] = row
end
table.insert(entries, { player = p, row = row, dist = DistanceTo(p) })
end
end
for p, row in pairs(serverRows) do
if not p.Parent then
row.btn:Destroy()
serverRows[p] = nil
end
end
table.sort(entries, function(a, b)
if a.dist == b.dist then
return a.player.DisplayName:lower() < b.player.DisplayName:lower()
end
return a.dist < b.dist
end)
emptyServerLabel.Visible = #entries == 0
for i, entry in ipairs(entries) do
local p, row = entry.player, entry.row
local chosenIdx = table.find(chosenList, p)
local isNew = IsNewPlayer(p)
row.btn.LayoutOrder = i
row.nameLabel.Text = (isNew and "\240\159\134\149 " or "") .. p.DisplayName
row.nameLabel.TextColor3 = isNew and Theme.Gold or Theme.Text
row.subLabel.Text = "@" .. p.Name .. "  \226\128\162  " .. DistanceText(entry.dist)
row.badge.Text = chosenIdx and ("#" .. chosenIdx) or "+"
row.badge.BackgroundColor3 = chosenIdx and Theme.Accent or Theme.Bar
local nowChosen = chosenIdx ~= nil
if row.isChosen ~= nowChosen then
row.isChosen = nowChosen
Tween(row.btn, 0.25, { BackgroundColor3 = nowChosen and Theme.AccentDark or Theme.Item })
end
end
end
RefreshChosenList = function()
for _, row in ipairs(chosenRows) do
row.frame:Destroy()
end
chosenRows = {}
emptyChosenLabel.Visible = #chosenList == 0
for i, p in ipairs(chosenList) do
local active = (p == currentTarget and stickEnabled)
local frame = InstanceNew("Frame", {
Size = UDim2.new(1, 0, 0, 52),
BackgroundColor3 = active and Theme.AccentDark or Theme.Item,
BorderSizePixel = 0,
LayoutOrder = i
}, chosenContainer)
ApplyCorner(frame, 10)
if active then
ApplyStroke(frame, Theme.Accent, 1.6, 0)
end
local avatar = InstanceNew("ImageLabel", {
Position = UDim2.new(0, 8, 0.5, -18),
Size = UDim2.fromOffset(36, 36),
BackgroundColor3 = Theme.Bar,
BorderSizePixel = 0,
Image = AvatarUrl(p)
}, frame)
ApplyCorner(avatar, 18)
InstanceNew("TextLabel", {
BackgroundTransparency = 1,
Position = UDim2.new(0, 54, 0, 8),
Size = UDim2.new(1, -102, 0, 18),
Font = Enum.Font.GothamBold,
Text = i .. ". " .. p.DisplayName,
TextColor3 = Theme.Text,
TextSize = 11,
TextXAlignment = Enum.TextXAlignment.Left,
TextTruncate = Enum.TextTruncate.AtEnd
}, frame)
local subLabel = InstanceNew("TextLabel", {
BackgroundTransparency = 1,
Position = UDim2.new(0, 54, 0, 28),
Size = UDim2.new(1, -102, 0, 16),
Font = Enum.Font.GothamMedium,
Text = "@" .. p.Name,
TextColor3 = Theme.SubText,
TextSize = 11,
TextXAlignment = Enum.TextXAlignment.Left,
TextTruncate = Enum.TextTruncate.AtEnd
}, frame)
local delBtn = InstanceNew("TextButton", {
AnchorPoint = Vector2.new(1, 0.5),
Position = UDim2.new(1, -8, 0.5, 0),
Size = UDim2.fromOffset(34, 34),
BackgroundColor3 = Theme.Red,
BorderSizePixel = 0,
AutoButtonColor = false,
Font = Enum.Font.GothamBold,
Text = "\226\156\150",
TextColor3 = Theme.Text,
TextSize = 14
}, frame)
ApplyCorner(delBtn, 8)
AddEffects(delBtn, Theme.Text)
delBtn.MouseButton1Click:Connect(function()
local idx = table.find(chosenList, p)
if idx then
table.remove(chosenList, idx)
end
if currentTarget == p then
currentTarget = nil
end
RefreshAll()
end)
table.insert(chosenRows, { frame = frame, subLabel = subLabel, player = p })
end
chosenSignature = ComputeSignature()
UpdateChosenInfo()
end
UpdateStatus = function()
local text, color = "Tr\225\186\161ng th\195\161i: \196\144ang t\225\186\175t", Theme.SubText
local showAvatar = false
if stickEnabled then
if currentTarget then
local idx = table.find(chosenList, currentTarget) or 0
text = string.format("\240\159\142\175 \196\144ang b\195\161m: %s\n@%s  \226\128\162  #%d / %d", currentTarget.DisplayName, currentTarget.Name, idx, #chosenList)
color = Theme.On
showAvatar = true
statusAvatar.Image = AvatarUrl(currentTarget)
elseif #chosenList == 0 then
text = "\226\154\160 Ch\198\176a ch\225\187\141n ng\198\176\225\187\157i n\195\160o \196\145\225\187\131 b\195\161m"
color = Theme.Gold
else
text = "\226\143\179 \196\144ang ch\225\187\157 ng\198\176\225\187\157i \196\145\198\176\225\187\163c ch\225\187\141n h\225\187\147i sinh"
color = Theme.Gold
end
end
stickStatus.Text = text
stickStatus.TextColor3 = color
statusAvatar.Visible = showAvatar
stickStatus.Position = showAvatar and UDim2.new(0, 64, 0, 0) or UDim2.new(0, 14, 0, 0)
stickStatus.Size = showAvatar and UDim2.new(1, -76, 1, 0) or UDim2.new(1, -28, 1, 0)
end
RefreshAll = function()
UpdateServerRows()
RefreshChosenList()
UpdateStatus()
end
local function SetTarget(p)
if currentTarget ~= p then
currentTarget = p
RefreshChosenList()
end
UpdateStatus()
end
local function PickNextTarget()
local n = #chosenList
if n == 0 then
return nil
end
local startIdx = currentTarget and table.find(chosenList, currentTarget) or 0
for step = 1, n do
local idx = ((startIdx - 1 + step) % n) + 1
local p = chosenList[idx]
if IsAlive(p) then
return p
end
end
return nil
end
local function StickStep()
if not IsAlive(currentTarget) then
SetTarget(PickNextTarget())
end
local myRoot = GetRoot(LocalPlayer.Character)
local myHum = GetHumanoid()
if not (currentTarget and myRoot and myHum) then
return
end
local tChar = currentTarget.Character
local tRoot = GetRoot(tChar)
local tHum = tChar and tChar:FindFirstChildOfClass("Humanoid")
if not (tRoot and tHum) then
return
end
local heightDiff = (myHum.HipHeight + myRoot.Size.Y / 2) - (tHum.HipHeight + tRoot.Size.Y / 2) + stickOffsetY
myRoot.CFrame = tRoot.CFrame * CFrame.new(0, heightDiff, stickBack)
myRoot.AssemblyLinearVelocity = Vector3.zero
myRoot.AssemblyAngularVelocity = Vector3.zero
end
local function RestoreStickCollide()
for part, wasSolid in pairs(stickOriginal) do
if wasSolid and part.Parent then
part.CanCollide = true
end
stickOriginal[part] = nil
end
end
StopStick = function()
if stickConn then stickConn:Disconnect(); stickConn = nil end
if stickCollideConn then stickCollideConn:Disconnect(); stickCollideConn = nil end
RestoreStickCollide()
currentTarget = nil
RefreshChosenList()
UpdateStatus()
end
StartStick = function()
if stickConn then stickConn:Disconnect() end
if stickCollideConn then stickCollideConn:Disconnect() end
stickConn = RunService.Heartbeat:Connect(StickStep)
stickCollideConn = RunService.Stepped:Connect(function()
local char = LocalPlayer.Character
if char and currentTarget then
for _, part in ipairs(char:GetDescendants()) do
if part:IsA("BasePart") then
if stickOriginal[part] == nil then
stickOriginal[part] = part.CanCollide
end
if part.CanCollide then
part.CanCollide = false
end
end
end
end
end)
RefreshChosenList()
UpdateStatus()
end
Players.PlayerAdded:Connect(function(p)
joinTimes[p] = tick()
RefreshAll()
end)
Players.PlayerRemoving:Connect(function(p)
joinTimes[p] = nil
local idx = table.find(chosenList, p)
if idx then
table.remove(chosenList, idx)
end
if currentTarget == p then
currentTarget = nil
end
task.delay(0.2, RefreshAll)
end)
task.spawn(function()
while true do
local now = tick()
local count, newest = 0, 0
for p, t in pairs(joinTimes) do
if p.Parent and now - t < NEW_JOIN_WINDOW then
count = count + 1
if t > newest then newest = t end
end
end
if count > 0 then
newLabel.Text = string.format(
"\240\159\134\149 Ng\198\176\225\187\157i m\225\187\155i v\195\160o: %d  \226\128\162  \196\145\225\186\183t l\225\186\161i sau %ds",
count, math.ceil(NEW_JOIN_WINDOW - (now - newest))
)
newLabel.TextColor3 = Theme.On
else
newLabel.Text = "\240\159\134\149 Ng\198\176\225\187\157i m\225\187\155i v\195\160o: 0"
newLabel.TextColor3 = Theme.SubText
end
UpdateServerRows()
if ComputeSignature() ~= chosenSignature then
RefreshChosenList()
UpdateStatus()
end
UpdateChosenInfo()
task.wait(0.5)
end
end)
RefreshAll()
end
end)
task.delay(4, function()
if bootGui then bootGui:Destroy() end
end)
if not bootOk then
warn("MenuSieuToc loi: " .. tostring(bootErr))
BootGui("\226\157\140 L\225\187\151i menu: " .. tostring(bootErr), Color3.fromRGB(255, 120, 120))
end
