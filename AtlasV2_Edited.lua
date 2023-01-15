--[[

ââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââ
ââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââ
ââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââ
ââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââ
ââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââ
ââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââ

Atlas v2 ROBLOX UI Library Made By RoadToGlory#9879

Website: https://www.rd2glory.com
Discord Server: https://discord.gg/rWHQSvDcc3
Discord Profile: https://rd2.vc/discord

]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local Run = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local plr = Players.LocalPlayer

local mouse = plr:GetMouse()

if not LPH_OBFUSCATED then
    local function r(f)
        return f
    end
    LPH_JIT_MAX = r
    LPH_NO_VIRTUALIZE = r
    LPH_JIT = r
end

local Library = {}

function Library:UpdateColorsUsingRegistry() -- feature is not done yet
    for _, obj in pairs(Library.Registry) do
        for prop, color in next, obj.Properties do
            obj.Instance[prop] = Library[color];
        end;
    end;
end;

local Atlas = game:GetObjects("rbxassetid://11653746072")[1]

Atlas.Blank.Enabled = false
pcall(function()
    Atlas.Test:Destroy()
end)

function Library:Lerp(start,goal,alpha)
    return ((goal-start)*alpha)+start
end

function Library:Require(a,m)
    if not a then
        error(m)
    end
end

function Library:CreateInvisButton(obj)
    -- Generated using RoadToGlory's Converter v1.1 (RoadToGlory#9879)

    -- Instances:

    local Button = Instance.new("Frame"); -- modified

    -- Properties:

    Button.Active = true
    Button.BackgroundTransparency = 1
    Button.Size = UDim2.new(1, 0, 1, 0)
    Button.Name = "Button"
    Button.Parent = obj
    Button.ZIndex = 99999999

    local selected = false
    local activated = {}
    local mousedown = {}
    local mouseup = {}
    local returnValue = {
        ["obj"] = Button;
        ["Activated"] = {};
        ["MouseButton1Down"] = {};
        ["MouseButton1Up"] = {};
        ["MouseLeave"] = Button.MouseLeave;
        ["MouseEnter"] = Button.MouseEnter;
    }
    function returnValue.Activated:Connect(func)
        table.insert(activated,func)
    end
    function returnValue.MouseButton1Down:Connect(func)
        table.insert(mousedown,func)
    end
    function returnValue.MouseButton1Up:Connect(func)
        table.insert(mouseup,func)
    end

    Button.InputBegan:Connect(function(input) -- garbage collected when destroyed
        if input.UserInputType==Enum.UserInputType.MouseButton1 then
            selected = true
            for _,v in pairs(mousedown) do
                coroutine.wrap(v)()
            end
        end
    end)

    Button.MouseLeave:Connect(function()
        selected = false
    end)

    Button.InputEnded:Connect(function(input) -- garbage collected when destroyed
        if input.UserInputType==Enum.UserInputType.MouseButton1 and selected then
            selected = false
            for _,v in pairs(activated) do
                coroutine.wrap(v)()
            end
        end
        if input.UserInputType==Enum.UserInputType.MouseButton1 then
            for _,v in pairs(mouseup) do
                coroutine.wrap(v)()
            end
        end
    end)

    return returnValue
end

function Library:InitDragging(frame,button)
    button = button or frame

    assert(button and frame,"Need a frame in order to start dragging")

    -- dragging
    local _dragging = false
    local _dragging_offset

    local inputBegan = button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            _dragging = true
            _dragging_offset = Vector2.new(mouse.X,mouse.Y)-frame.AbsolutePosition
        end
    end)

    local inputEnded = mouse.Button1Up:Connect(function()
        _dragging = false
        _dragging_offset = nil
    end)

    local updateEvent
    LPH_JIT_MAX(function()
        updateEvent = Run.RenderStepped:Connect(function(dt)
            if frame.Visible == false or not UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                _dragging = false
                _dragging_offset = nil
            end
            if _dragging and _dragging_offset then
                local lerp = 0.3
                local finalPos = UDim2.fromOffset(mouse.X-_dragging_offset.X+(frame.AbsoluteSize.X*frame.AnchorPoint.X),mouse.Y-_dragging_offset.Y+36+(frame.AbsoluteSize.Y*frame.AnchorPoint.Y))
                frame.Position = frame.Position:Lerp(finalPos,lerp*(dt*60))
            end
        end)
    end)()

    return {inputBegan,inputEnded,updateEvent}
end

function Library:FormatAsset(a)
    a = a or ""
    if type(a) == "number"  or (type(a)=="string" and tonumber(a)) then
        a = tonumber(a)
        return "rbxassetid://"..tostring(a)
    else
        return a
    end
end

function Library:FormatNumber(amount)
    local formatted = amount
    while true do
        local k
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if (k==0) then
            break
        end
    end
    return formatted
end

function Library:GetTextContrast(color)
    local r,g,b = color.R*255,color.G*255,color.B*255
    return (((r * 0.299) + (g * 0.587) + (b * 0.114)) > 150) and Color3.new(0,0,0) or Color3.new(1,1,1)
end

Library.BlankFunction = function() end

function Library:CreateWindow(LibArgs)
    Library:Require(LibArgs.Name,"Missing arguments for Library:CreateWindow")

    LibArgs.Watermark = LibArgs.Watermark or LibArgs.Name or "Atlas"
    -- This is a watermark that will be saved to your config file (does not interfere with script whatsoever). The purpose of this is to let people know what UI library they are using in case they want to use it themselves, please don't remove it :)
    local FlagWatermark, SiegeInvite = "Atlas v2 made by Siege Scripting Utilities","https://discord.gg/rWHQSvDcc3"
    local Configs = {
        [FlagWatermark] = SiegeInvite;
    }
    local RegisteredFlags = {
        [FlagWatermark] = true
    }

    -- Destroying any old Atlas v2 UI with same name
    local removeOldVar = "[ATLAS_STORAGE]"

    if not getgenv()[removeOldVar] then
        getgenv()[removeOldVar] = {}
    end

    if getgenv()[removeOldVar][LibArgs.Name] then
        getgenv()[removeOldVar][LibArgs.Name]()
    end

    local connections = {}

    local function connect(connection,func)
        local e = connection:Connect(func)
        table.insert(connections,e)
        return e
    end

    if LibArgs.ConfigFolder then
        local config_path = LibArgs.ConfigFolder.."/configs.json"

        if not isfolder(LibArgs.ConfigFolder) then
            makefolder(LibArgs.ConfigFolder)
        end

        if isfile(config_path) then
            Configs = HttpService:JSONDecode(readfile(config_path))
        else
            writefile(config_path,HttpService:JSONEncode(Configs))
        end

        local lastSave = os.clock()
        local SAVE_DELAY = 0.1

        local function save()
            local to_save = {}

            for i,v in pairs(Configs) do
                to_save[i] = v
            end

            to_save[FlagWatermark] = SiegeInvite

            writefile(config_path,HttpService:JSONEncode(to_save))
        end

        connect(Run.RenderStepped,function()
            if os.clock()-lastSave>SAVE_DELAY then
                lastSave = 9e9
                save()
                lastSave = os.clock()
            end
        end)
    end

    local UI = Atlas.Blank:Clone()
    UI.Name = LibArgs.Name
    local Background = UI.Background
    Background.Top.Title.Text = LibArgs.Name

    UI.Watermark.TextLabel.Text = LibArgs.Watermark

    if gethui then
        UI.Parent = gethui()
    elseif syn.protect_gui then
        syn.protect_gui(UI)
        UI.Parent = CoreGui
    elseif protectgui then
        protectgui(UI)
        UI.Parent = CoreGui
    elseif CoreGui:FindFirstChild("RobloxGui") then
        UI.Parent = CoreGui:FindFirstChild("RobloxGui")
    else
        UI.Parent = CoreGui
    end

    Background.Top.Active = true

    local function startDragging(...)
        local c = Library:InitDragging(...)
        for _,v in pairs(c) do
            table.insert(connections,v)
        end
    end

    startDragging(Background,Background.Top)

    startDragging(UI.Keybinds,UI.Keybinds)

    UI.Watermark.Active = true
    startDragging(UI.Watermark,UI.Watermark)

    local Window = {
        Obj = UI;
        Theme = {
            FontColor = Color3.fromRGB(215, 215, 215);
            MainColor = Color3.fromRGB(30, 30, 30);
            BackgroundColor = Color3.fromRGB(18, 18, 18);
            AccentColor = LibArgs.Color or Color3.fromRGB(255,0,0);
            OutlineColor = Color3.fromRGB(50, 50, 50); 
        };
    }

    function Window:RegisterCustomFlag(Flag) -- For custom flags/data saving using Atlas v2 data saving system
        Library:Require(not RegisteredFlags[Flag],"Flag already registered, pick another one ("..Flag..")")
        RegisteredFlags[Flag] = true
        return {
            ["Flag"] = Flag;
            ["Get"] = function()
                return Configs[Flag]
            end;
            ["Set"] = function(value)
                Configs[Flag] = value
            end
        }
    end

    local closeMenu do
        local menuButton = Library:CreateInvisButton(Background.Top.Menu)
        local state = false
        local tween = nil
        local pagesInfo = TweenInfo.new(0.2,Enum.EasingStyle.Sine,Enum.EasingDirection.In,0,false,0)

        Background.Pages.Size = UDim2.new(0,0,1,0)

        local function setState(new)
            if state ~= new then
                state = new

                pcall(function()
                    tween:Cancel()
                    tween:Destroy()
                    tween = nil
                end)

                tween = TS:Create(Background.Pages,pagesInfo,{
                    ["Size"] = state and UDim2.new(0,145,1,0) or UDim2.new(0,0,1,0)
                })

                tween:Play()
            end
        end

        connect(Run.RenderStepped,function()
            Background.Pages.Visible = Background.Pages.AbsoluteSize.X > 8
        end)

        connect(menuButton.Activated,function()
            setState(not state)
        end)

        function closeMenu()
            setState(false)
        end
    end

    do
        local last = nil
        connect(Run.Heartbeat,function()
            local before = UIS.MouseIconEnabled
            if Background.Visible then
                local pos = UIS:GetMouseLocation()
                UI.Mouse.Visible = true
                UI.Mouse.Position = UDim2.fromOffset(pos.X,pos.Y)
                UIS.MouseIconEnabled = false
            elseif last then
                UI.Mouse.Visible = false
                UIS.MouseIconEnabled = before
            end
            last = Background.Visible
        end)
    end

    local lastPage = 0

    local CurrentPage do
        CurrentPage = 1

        connect(Run.RenderStepped,function()
            for _,v in pairs(Background.Content.Pages:GetChildren()) do
                if v:FindFirstChild("PageNum") then
                    v.Visible = v.PageNum.Value==CurrentPage
                end
            end
            for _,v in pairs(Background.Pages.Inner.ScrollingFrame:GetChildren()) do
                if v:FindFirstChild("PageNum") then
                    v.BackgroundTransparency = v.PageNum.Value==CurrentPage and 0 or 1
                end
            end
        end)
    end

    function Window:CreatePage(p_Name,p_Icon)
        if type(p_Name)=="table" then
            p_Name = p_Name.Name
            p_Icon = p_Name.Icon
        end

        Library:Require(p_Name,"Missing Name argument for Window:CreatePage")

        if p_Icon then
            p_Icon = Library:FormatAsset(p_Icon)
        end

        local Select = Atlas.Objects.PageSelect:Clone()
        local Holder = Atlas.Objects.Page:Clone()

        lastPage = lastPage+1
        local PageNum = lastPage

        do
            local e = Instance.new("IntValue")
            e.Name = "PageNum"
            e.Value = PageNum
            e.Parent = Select

            e:Clone().Parent = Holder
        end

        local Page = {
            ["Select"] = Select;
            ["Holder"] = Holder;
        }

        connect(Select.Button.Activated,function()
            if CurrentPage~=PageNum then
                CurrentPage = PageNum

                closeMenu()
            end
        end)

        Select.Name = string.rep("a",PageNum)
        Holder.Name = string.rep("a",PageNum)
        Select.Parent = Background.Pages.Inner.ScrollingFrame
        Holder.Parent = Background.Content.Pages

        Select.Frame.TextLabel.Text = p_Name
        Select.Frame.Icon.Image = p_Icon

        local function getElementMethods(holder)
            local Elements = {}

            local elementIncrement = 1

            function Elements:CreateToggle(Flag, Args)
                -- Requirements
                Library:Require(Args.Name,"Missing Name argument for :CreateToggle")
                Library:Require(Flag,"Missing Flag argument for :CreateToggle")

                -- Checking Flag
                Library:Require(not RegisteredFlags[Flag],"Flag already registered, pick another one ("..Flag..")")
                RegisteredFlags[Flag] = true

                -- Optionals
                if Args.Default == nil then
                    Args.Default = false
                end
                Args.Callback = Args.Callback or Library.BlankFunction

                -- Config
                if LibArgs.SavingDisabled then
                    Configs[Flag] = nil
                end
                if Configs[Flag]==nil then
                    Configs[Flag] = Args.Default
                end

                -- Element
                local element = {}
                local obj = Atlas.Objects.Toggle:Clone()
                obj.Name = string.rep("a",elementIncrement)
                elementIncrement = elementIncrement+1
                obj.Title.Text = Args.Name
                obj.Parent = holder

                function element:Set(newValue)
                    if newValue~=Configs[Flag] then
                        Configs[Flag] = newValue
                        coroutine.wrap(Args.Callback)(Configs[Flag])
                    end
                end

                function element:Toggle()
                    return element:Set(not Configs[Flag])
                end

                element:Set(Configs[Flag])

                do
                    local last = Configs[Flag]
                    local lastChanged = 0

                    local toggleTweenTime = 0.1--TweenInfo.new(0.1,Enum.EasingStyle.Sine,Enum.EasingDirection.In,0,false,0)

                    obj.Frame.ImageLabel.Visible = true

                    connect(Run.RenderStepped,function()
                        if last ~= Configs[Flag] then
                            lastChanged = os.clock()
                            last = Configs[Flag]
                        end
                        local tweenTime = os.clock()-lastChanged
                        local alpha = math.clamp(tweenTime/toggleTweenTime,0,1)
                        local value = TS:GetValue(alpha,Enum.EasingStyle.Sine,Enum.EasingDirection.In)
                        obj.Frame.BackgroundColor3 = (Configs[Flag] and Window.Theme.BackgroundColor or Window.Theme.AccentColor):Lerp(Configs[Flag] and Window.Theme.AccentColor or Window.Theme.BackgroundColor,value)
                        obj.Frame.ImageLabel.ImageTransparency = Configs[Flag] and 1-alpha or alpha
                        obj.Frame.ImageLabel.ImageColor3 = Library:GetTextContrast(Window.Theme.AccentColor)
                    end)

                    local button = Library:CreateInvisButton(obj)

                    button.Activated:Connect(function()
                        element:Toggle()
                    end)
                end

                return element
            end

            function Elements:CreateButton(Name,Callback)
                -- Requirements
                Library:Require(Name,"Missing Name argument for :CreateButton")

                -- Optionals
                Callback = Callback or Library.BlankFunction

                -- Element
                local element = {}
                local obj = Atlas.Objects.Button:Clone()
                obj.Name = string.rep("a",elementIncrement)
                elementIncrement = elementIncrement+1
                obj.Title.Text = Name
                obj.Parent = holder

                function element:Trigger()
                    coroutine.wrap(pcall)(Callback)
                end

                do
                    local button = Library:CreateInvisButton(obj)
                    local holding = false
                    local function setHolding(state)
                        holding = state

                        obj.BackgroundColor3 = holding and Window.Theme.FontColor or Window.Theme.MainColor
                        obj.Title.TextColor3 = holding and Window.Theme.MainColor or Window.Theme.FontColor
                    end
                    connect(button.MouseButton1Down,function()
                        setHolding(true)
                    end)
                    connect(button.MouseButton1Up,function()
                        if holding then
                            element:Trigger()
                            setHolding(false)
                        end
                    end)
                    connect(button.MouseLeave,function()
                        setHolding(false)
                    end)
                end

                return element
            end

            function Elements:CreateSubButtons(Name1,Name2,Callback1,Callback2)
                -- Requirements
                Library:Require(Name1,"Missing Name 1 argument for :CreateSubButtons")
                Library:Require(Name2,"Missing Name 2 argument for :CreateSubButtons")

                -- Optionals
                Callback1 = Callback1 or Library.BlankFunction
                Callback2 = Callback2 or Library.BlankFunction

                -- Element
                local element = {}
                local obj = Atlas.Objects.SubButtons:Clone()
                obj.Name = string.rep("a",elementIncrement)
                elementIncrement = elementIncrement+1
                obj.Left.Title.Text = Name1
                obj.Right.Title.Text = Name2
                obj.Parent = holder

                function element:Trigger1()
                    coroutine.wrap(pcall)(Callback1)
                end

                function element:Trigger2()
                    coroutine.wrap(pcall)(Callback2)
                end

                do -- left
                    local button = Library:CreateInvisButton(obj.Left)
                    local holding = false
                    local function setHolding(state)
                        holding = state

                        obj.Left.BackgroundColor3 = holding and Window.Theme.FontColor or Window.Theme.MainColor
                        obj.Left.Title.TextColor3 = holding and Window.Theme.MainColor or Window.Theme.FontColor
                    end
                    connect(button.MouseButton1Down,function()
                        setHolding(true)
                    end)
                    connect(button.MouseButton1Up,function()
                        if holding then
                            element:Trigger1()
                            setHolding(false)
                        end
                    end)
                    connect(button.MouseLeave,function()
                        setHolding(false)
                    end)
                end

                do -- right
                    local button = Library:CreateInvisButton(obj.Right)
                    local holding = false
                    local function setHolding(state)
                        holding = state

                        obj.Right.BackgroundColor3 = holding and Window.Theme.FontColor or Window.Theme.MainColor
                        obj.Right.Title.TextColor3 = holding and Window.Theme.MainColor or Window.Theme.FontColor
                    end
                    connect(button.MouseButton1Down,function()
                        setHolding(true)
                    end)
                    connect(button.MouseButton1Up,function()
                        if holding then
                            element:Trigger2()
                            setHolding(false)
                        end
                    end)
                    connect(button.MouseLeave,function()
                        setHolding(false)
                    end)
                end

                return element
            end

            function Elements:CreateSlider(Flag, Args)
                -- Requirements
                Library:Require(Args.Name,"Missing Name argument for :CreateSlider")
                Library:Require(Flag,"Missing Flag argument for :CreateSlider")
                Library:Require(Args.Min,"Missing Min argument for :CreateSlider")
                Library:Require(Args.Max,"Missing Max argument for :CreateSlider")
                Library:Require(Args.Min<Args.Max,"Max arg must be greater than min arg for :CreateSlider")

                -- Checking Flag
                Library:Require(not RegisteredFlags[Flag],"Flag already registered, pick another one ("..Flag..")")
                RegisteredFlags[Flag] = true

                -- Optionals
                if Args.Default == nil then
                    Args.Default = (Args.Max+Args.Min)/2
                end
                Args.DecimalPlaces = Args.DecimalPlaces or 0
                if Args.AllowValuesOutsideRange==nil then
                    Args.AllowValuesOutsideRange = false
                end
                Args.Callback = Args.Callback or Library.BlankFunction

                -- Config
                if LibArgs.SavingDisabled then
                    Configs[Flag] = nil
                end
                if Configs[Flag]==nil then
                    Configs[Flag] = Args.Default
                end
                if not Args.AllowValuesOutsideRange then
                    Args.Default = math.clamp(Args.Default,Args.Min,Args.Max)
                    Configs[Flag] = math.clamp(Configs[Flag],Args.Min,Args.Max)
                end

                -- Element
                local element = {}
                local obj = Atlas.Objects.Slider:Clone()
                obj.Name = string.rep("a",elementIncrement)
                elementIncrement = elementIncrement+1
                obj.Title.Text = Args.Name
                obj.Parent = holder

                function element:UpdateText() -- only to be used internally
                    obj.TextBox.Text = Library:FormatNumber(Configs[Flag])
                end

                function element:Set(newValue)
                    newValue = math.round(newValue*(10^Args.DecimalPlaces))/(10^Args.DecimalPlaces)
                    if not Args.AllowValuesOutsideRange then
                        newValue = math.clamp(newValue,Args.Min,Args.Max)
                    end
                    if newValue~=Configs[Flag] then
                        Configs[Flag] = newValue
                        coroutine.wrap(Args.Callback)(Configs[Flag])
                    end
                    element:UpdateText()
                end

                element:Set(Configs[Flag])

                do
                    local lerp = 0.3
                    local button = Library:CreateInvisButton(obj.ImageLabel)
                    local inside = obj.ImageLabel.ImageLabel
                    button.obj.Size = UDim2.new(1,0,3,0)
                    button.obj.AnchorPoint = Vector2.new(0,0.5)
                    button.obj.Position = UDim2.fromScale(0,0.5)

                    local holding = false

                    button.MouseButton1Down:Connect(function()
                        holding = true
                    end)

                    connect(UIS.InputEnded,function(input)
                        if input.UserInputType==Enum.UserInputType.MouseButton1 then holding = false end
                    end)

                    inside.ImageLabel.Size = UDim2.fromScale((Configs[Flag]-Args.Min)/Args.Max,1)

                    connect(Run.RenderStepped,function(dt)
                        if holding then
                            local percent = ((mouse.X-(inside.AbsolutePosition.X))/inside.AbsoluteSize.X)
                            if not Args.AllowValuesOutsideRange then
                                percent = math.clamp(percent,0,1)
                            end
                            element:Set(math.round((((Args.Max-Args.Min)*percent)+Args.Min)*(10^Args.DecimalPlaces))/(10^Args.DecimalPlaces))
                        end
                        inside.ImageLabel.Size = UDim2.fromScale(math.clamp(Library:Lerp(inside.ImageLabel.Size.X.Scale,(Configs[Flag]-Args.Min)/(Args.Max-Args.Min),math.clamp(lerp*(dt*60),0,1)),0,1),1)
                    end)

                    obj.TextBox.FocusLost:Connect(function(enterPressed)
                        local new = tonumber(obj.TextBox.Text)
                        if new then
                            element:Set(new)
                        else
                            element:UpdateText()
                        end
                    end)
                end

                return element
            end

            function Elements:CreateSliderToggle(SliderFlag, ToggleFlag, Args)
                -- Requirements
                Library:Require(Args.Name,"Missing Name argument for :CreateSliderToggle")
                Library:Require(SliderFlag,"Missing SliderFlag argument for :CreateSliderToggle")
                Library:Require(ToggleFlag,"Missing ToggleFlag argument for :CreateSliderToggle")
                Library:Require(Args.Min,"Missing Min argument for :CreateSliderToggle")
                Library:Require(Args.Max,"Missing Max argument for :CreateSliderToggle")
                Library:Require(Args.Min<Args.Max,"Max arg must be greater than min arg for :CreateSliderToggle")

                -- Checking Flag
                Library:Require(not RegisteredFlags[SliderFlag],"Flag already registered, pick another one ("..SliderFlag..")")
                RegisteredFlags[SliderFlag] = true
                Library:Require(not RegisteredFlags[ToggleFlag],"Flag already registered, pick another one ("..ToggleFlag..")")
                RegisteredFlags[ToggleFlag] = true

                -- Optionals
                if Args.Default == nil then
                    Args.Default = (Args.Max+Args.Min)/2
                end
                Args.DecimalPlaces = Args.DecimalPlaces or 0
                if Args.AllowValuesOutsideRange==nil then
                    Args.AllowValuesOutsideRange = false
                end
                Args.SliderCallback = Args.SliderCallback or Library.BlankFunction
                Args.ToggleCallback = Args.ToggleCallback or Library.BlankFunction

                -- Config
                if LibArgs.SavingDisabled then
                    Configs[SliderFlag] = nil
                    Configs[ToggleFlag] = nil
                end
                if Configs[SliderFlag]==nil then
                    Configs[SliderFlag] = Args.SliderDefault
                end
                if Configs[ToggleFlag]==nil then
                    Configs[ToggleFlag] = Args.ToggleDefault
                end
                if not Args.AllowValuesOutsideRange then
                    Args.SliderDefault = math.clamp(Args.SliderDefault,Args.Min,Args.Max)
                    Configs[SliderFlag] = math.clamp(Configs[SliderFlag],Args.Min,Args.Max)
                end

                -- Element
                local element = {}
                local obj = Atlas.Objects.SliderToggle:Clone()
                obj.Name = string.rep("a",elementIncrement)
                elementIncrement = elementIncrement+1
                obj.Title.Text = Args.Name
                obj.Parent = holder

                function element:UpdateText() -- only to be used internally
                    obj.TextBox.Text = Library:FormatNumber(Configs[SliderFlag])
                end

                function element:SetSlider(newValue)
                    newValue = math.round(newValue*(10^Args.DecimalPlaces))/(10^Args.DecimalPlaces)
                    if not Args.AllowValuesOutsideRange then
                        newValue = math.clamp(newValue,Args.Min,Args.Max)
                    end
                    if newValue~=Configs[SliderFlag] then
                        Configs[SliderFlag] = newValue
                        coroutine.wrap(Args.SliderCallback)(Configs[SliderFlag])
                    end
                    element:UpdateText()
                end

                element:SetSlider(Configs[SliderFlag])

                function element:SetToggle(newValue)
                    if newValue~=Configs[ToggleFlag] then
                        Configs[ToggleFlag] = newValue
                        coroutine.wrap(Args.ToggleCallback)(Configs[ToggleFlag])
                    end
                end

                function element:Toggle()
                    return element:SetToggle(not Configs[ToggleFlag])
                end

                element:SetToggle(Configs[ToggleFlag])

                do
                    local last = Configs[ToggleFlag]
                    local lastChanged = 0

                    local toggleTweenTime = 0.1--TweenInfo.new(0.1,Enum.EasingStyle.Sine,Enum.EasingDirection.In,0,false,0)

                    obj.Frame.ImageLabel.Visible = true

                    connect(Run.RenderStepped,function()
                        if last ~= Configs[ToggleFlag] then
                            lastChanged = os.clock()
                            last = Configs[ToggleFlag]
                        end
                        local tweenTime = os.clock()-lastChanged
                        local alpha = math.clamp(tweenTime/toggleTweenTime,0,1)
                        local value = TS:GetValue(alpha,Enum.EasingStyle.Sine,Enum.EasingDirection.In)
                        obj.Frame.BackgroundColor3 = (Configs[ToggleFlag] and Window.Theme.BackgroundColor or Window.Theme.AccentColor):Lerp(Configs[ToggleFlag] and Window.Theme.AccentColor or Window.Theme.BackgroundColor,value)
                        obj.Frame.ImageLabel.ImageTransparency = Configs[ToggleFlag] and 1-alpha or alpha
                    end)

                    local button = Library:CreateInvisButton(obj)
                    button.obj.AnchorPoint = Vector2.new(0,0)
                    button.obj.Position = UDim2.fromOffset(0,0)
                    button.obj.Size = UDim2.fromScale(0.89,0.5)
                    local button2 = Library:CreateInvisButton(obj)
                    button2.obj.AnchorPoint = Vector2.new(1,0)
                    button2.obj.Position = UDim2.fromScale(1,0)
                    button2.obj.Size = UDim2.fromScale(0.11,1)

                    local function activated()
                        if not obj.TextBox:IsFocused() then
                            element:Toggle()
                        end
                    end

                    button.Activated:Connect(activated)
                    button2.Activated:Connect(activated)
                end

                do
                    local lerp = 0.3
                    local button = Library:CreateInvisButton(obj.ImageLabel)
                    local inside = obj.ImageLabel.ImageLabel
                    button.obj.Size = UDim2.new(1,0,3,0)
                    button.obj.AnchorPoint = Vector2.new(0,0.5)
                    button.obj.Position = UDim2.fromScale(0,0.5)

                    local holding = false

                    button.MouseButton1Down:Connect(function()
                        holding = true
                    end)

                    connect(UIS.InputEnded,function(input)
                        if input.UserInputType==Enum.UserInputType.MouseButton1 then holding = false end
                    end)

                    inside.ImageLabel.Size = UDim2.fromScale((Configs[SliderFlag]-Args.Min)/Args.Max,1)

                    connect(Run.RenderStepped,function(dt)
                        if holding then
                            local percent = ((mouse.X-(inside.AbsolutePosition.X))/inside.AbsoluteSize.X)
                            if not Args.AllowValuesOutsideRange then
                                percent = math.clamp(percent,0,1)
                            end
                            element:SetSlider(math.round((((Args.Max-Args.Min)*percent)+Args.Min)*(10^Args.DecimalPlaces))/(10^Args.DecimalPlaces))
                        end
                        inside.ImageLabel.Size = UDim2.fromScale(math.clamp(Library:Lerp(inside.ImageLabel.Size.X.Scale,(Configs[SliderFlag]-Args.Min)/(Args.Max-Args.Min),math.clamp(lerp*(dt*60),0,1)),0,1),1)
                    end)

                    obj.TextBox.FocusLost:Connect(function(enterPressed)
                        local new = tonumber(obj.TextBox.Text)
                        if new then
                            element:SetSlider(new)
                        else
                            element:UpdateText()
                        end
                    end)
                end

                return element
            end

            function Elements:CreateTextbox(Flag, Args)
                -- Requirements
                Library:Require(Args.Name,"Missing Name argument for :CreateTextbox")
                Library:Require(Flag,"Missing Flag argument for :CreateTextbox")

                -- Checking Flag
                Library:Require(not RegisteredFlags[Flag],"Flag already registered, pick another one ("..Flag..")")
                RegisteredFlags[Flag] = true

                -- Optionals
                Args.DefaultText = Args.DefaultText or ""
                Args.PlaceholderText = Args.PlaceholderText or "None"
                if Args.ClearTextOnFocus == nil then
                    Args.ClearTextOnFocus = true
                end
                Args.Callback = Args.Callback or Library.BlankFunction
                Args.TabComplete = Args.TabComplete or Library.BlankFunction
                Args.OnlyCallbackOnEnterPressed = Args.OnlyCallbackOnEnterPressed and true

                -- Config
                if LibArgs.SavingDisabled then
                    Configs[Flag] = nil
                end
                if Configs[Flag]==nil then
                    Configs[Flag] = Args.DefaultText
                end

                -- Element
                local element = {}
                local obj = Atlas.Objects.Textbox:Clone()
                obj.Name = string.rep("a",elementIncrement)
                elementIncrement = elementIncrement+1
                obj.Title.Text = Args.Name
                obj.Parent = holder

                local inner = obj.Textbox.Inner.Frame
                local textbox = inner.TextBox

                textbox.PlaceholderText = Args.PlaceholderText
                textbox.ClearTextOnFocus = Args.ClearTextOnFocus

                function element:UpdateTextbox() -- should only be used internally
                    textbox.Text = Configs[Flag]
                end

                function element:Set(new)
                    pcall(function()
                        textbox:ReleaseFocus()
                    end)
                    Configs[Flag] = new
                    element:UpdateTextbox()
                    coroutine.wrap(Args.Callback)(new)
                end

                do
                    element:UpdateTextbox()

                    textbox.FocusLost:Connect(function(enterPressed,input)
                        if input then
                            local runCallback = false

                            if Args.OnlyCallbackOnEnterPressed then
                                if enterPressed then
                                    runCallback = true
                                end
                            else
                                runCallback = true
                            end

                            if runCallback then
                                element:Set(textbox.Text)
                            else
                                element:UpdateTextbox()
                            end
                        end
                    end)

                    connect(UIS.InputBegan,function(input)
                        if input.UserInputType==Enum.UserInputType.Keyboard and input.KeyCode==Enum.KeyCode.Tab and textbox:IsFocused() then
                            local result
                            local s,r = pcall(function()
                                result = Args.TabComplete(textbox.Text)
                            end)
                            if not textbox:IsFocused() then return end
                            if not s then
                                warn("Error in tab completion function: "..r)
                                error()
                            elseif (type(r)~="string" and r~=nil) then
                                warn("TabComplete function must return a string")
                                error()
                            end
                            textbox.Text = result or textbox.Text
                            textbox:GetPropertyChangedSignal("Text"):Wait()
                            textbox.Text = textbox.Text:gsub("\t",""):gsub( '^%s+', '' ):gsub( '%s+$', '' )
                        end
                    end)
                end

                return element
            end

            function Elements:CreateDivider()
                -- Element
                local element = {}
                local obj = Atlas.Objects.Divider:Clone()
                obj.Name = string.rep("a",elementIncrement)
                elementIncrement = elementIncrement+1
                obj.Parent = holder

                return element
            end

            function Elements:CreateLabel(Text,TextWrapped)
                -- Requirements
                Library:Require(Text,"Missing Text argument for :CreateLabel")

                -- Optionals
                if TextWrapped then -- multi-line
                    -- Element
                    local element = {}
                    local obj = Atlas.Objects.Multiline:Clone()
                    obj.Name = string.rep("a",elementIncrement)
                    elementIncrement = elementIncrement+1
                    obj.Title.Text = Text
                    obj.Parent = holder

                    function element:Update(new)
                        obj.Title.Text = new
                    end

                    local function helpFortheRetards()
                        error("You may only create Interactables, KeyPickers, ColorPickers, etc. when TextWrapped is set to false")
                    end

                    element.CreateInteractable = helpFortheRetards
                    element.CreateKeyPicker = helpFortheRetards
                    element.CreateColorPicker = helpFortheRetards

                    return element
                else -- single line
                    -- Element
                    local parent = {}
                    local pobj = Atlas.Objects.SingleLine:Clone()
                    pobj.Name = string.rep("a",elementIncrement)
                    elementIncrement = elementIncrement+1
                    pobj.Bar.Title.Text = Text
                    pobj.Parent = holder

                    local subholder = pobj.Bar.Addons

                    function parent:Update(new)
                        pobj.Title.Text = new
                    end

                    local pickerFlag = nil
                    local pickerState = false
                    local pickerTween = nil
                    local pickerTweenInfo = TweenInfo.new(0.25,Enum.EasingStyle.Sine,Enum.EasingDirection.In,0,false,0)

                    pobj.Picker.Size = UDim2.new(0.95,0,0,0)

                    local function openPicker()
                        pcall(function()
                            pickerTween:Cancel()
                            pickerTween:Destroy()
                        end)
                        pickerTween = TS:Create(pobj.Picker,pickerTweenInfo,{
                            ["Size"] = UDim2.new(0.95,0,0,120)
                        })
                        pobj.Picker.Visible = true
                        pickerTween:Play()
                        pickerState = true
                    end
                    local function closePicker()
                        pcall(function()
                            pickerTween:Cancel()
                            pickerTween:Destroy()
                        end)
                        pickerTween = TS:Create(pobj.Picker,pickerTweenInfo,{
                            ["Size"] = UDim2.new(0.95,0,0,0)
                        })
                        pickerTween.Completed:Connect(function(playbackState)
                            if playbackState==Enum.PlaybackState.Completed then
                                pobj.Picker.Visible = false
                            end
                        end)
                        pickerTween:Play()
                        pickerState = false
                    end
                    do
                        local rainbow = pobj.Picker.Inner.Picker.Rainbow
                        local second = pobj.Picker.Inner.Picker.Second
                        local hex = pobj.Picker.Inner.Hex
                        local rgb = pobj.Picker.Inner.RGB

                        rainbow.Active = true
                        second.Active = true

                        local r_drag = false
                        local s_drag = false

                        rainbow.InputBegan:Connect(function(input)
                            if input.UserInputType==Enum.UserInputType.MouseButton1 then
                                r_drag = true
                                s_drag = false
                            end
                        end)

                        second.InputBegan:Connect(function(input)
                            if input.UserInputType==Enum.UserInputType.MouseButton1 then
                                r_drag = false
                                s_drag = true
                            end
                        end)

                        connect(UIS.InputEnded,function(input)
                            if input.UserInputType==Enum.UserInputType.MouseButton1 then
                                r_drag = false
                                s_drag = false
                            end
                        end)

                        hex.TextBox.FocusLost:Connect(function(enterPressed)
                            if enterPressed then
                                local input = hex.TextBox.Text
                                input = string.gsub(input,"#","")
                                input = string.gsub(input," ","")
                                if #input==6 and pickerFlag then
                                    local newColor = Color3.fromHex(input)
                                    if newColor then
                                        local h,s,v = newColor:ToHSV()
                                        Configs[pickerFlag] = {h,s,v}
                                    end
                                end
                            end
                        end)

                        rgb.TextBox.FocusLost:Connect(function(enterPressed)
                            if enterPressed then
                                pcall(function()
                                    local input = rgb.TextBox.Text
                                    input = string.gsub(input," ","")
                                    local numCheck,_ = string.gsub(input,",","")
                                    if tonumber(numCheck) then
                                        local split = string.split(input,",")
                                        if #split==3 then
                                            for i,v in pairs(split) do
                                                split[i] = math.round(math.clamp(v,0,255))
                                            end
                                            local finalColor = Color3.fromRGB(split[1],split[2],split[3])
                                            if finalColor then
                                                local h,s,v = finalColor:ToHSV()
                                                Configs[pickerFlag] = {h,s,v}
                                            end
                                        end
                                    end
                                end)
                            end
                        end)

                        rainbow.Frame.AnchorPoint = Vector2.new(0.5,0.5)

                        local used = {}

                        connect(Run.RenderStepped,function()
                            if pickerFlag then
                                if not used[pickerFlag] then
                                    if Configs[pickerFlag][1]==1 then
                                        local old = {unpack(Configs[pickerFlag])}
                                        old[1] = 0
                                        Configs[pickerFlag] = old
                                    end
                                end
                                used[pickerFlag] = true
                                if r_drag then
                                    local percent = math.clamp((mouse.Y-rainbow.AbsolutePosition.Y)/rainbow.AbsoluteSize.Y,0,1)
                                    local old = {unpack(Configs[pickerFlag])}
                                    old[1] = percent
                                    Configs[pickerFlag] = old
                                end
                                rainbow.Frame.Position = UDim2.fromScale(0.5,Configs[pickerFlag][1])
                                if s_drag then
                                    local percentX = math.clamp((mouse.X-second.AbsolutePosition.X)/second.AbsoluteSize.X,0,1)
                                    local percentY = math.clamp((mouse.Y-second.AbsolutePosition.Y)/second.AbsoluteSize.Y,0,1)
                                    local old = {unpack(Configs[pickerFlag])}
                                    old[2] = percentX
                                    old[3] = 1-percentY
                                    Configs[pickerFlag] = old
                                end
                                second.Black.Frame.Position = UDim2.fromScale(Configs[pickerFlag][2],1-Configs[pickerFlag][3])
                                local current = Configs[pickerFlag]
                                local color = Color3.fromHSV(current[1],1,1)
                                local final = Color3.fromHSV(current[1],current[2],current[3])
                                second.UIGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.new(1,1,1)),ColorSequenceKeypoint.new(1, color)})
                                if not hex.TextBox:IsFocused() then
                                    hex.TextBox.Text = "#"..final:ToHex()
                                end
                                if not rgb.TextBox:IsFocused() then
                                    local c = {final.R,final.G,final.B}
                                    for i,v in pairs(c) do
                                        c[i] = math.round(v*255)
                                    end
                                    rgb.TextBox.Text = table.concat(c,", ")
                                end
                            end
                        end)
                    end

                    local subElementIncrement = 1

                    function parent:CreateInteractable(InteractText,Callback)
                        -- Requirements
                        Library:Require(InteractText or Callback,"Must include at least one argument in :CreateInteractable")

                        -- Optionals
                        InteractText = InteractText or "Interact"
                        Callback = Callback or Library.BlankFunction

                        -- Element
                        local element = {}
                        local obj = Atlas.Objects.Interactable:Clone()
                        obj.Name = string.rep("a",subElementIncrement)
                        subElementIncrement = subElementIncrement+1
                        obj.Parent = subholder
                        obj.Inner:FindFirstChild("Content").Text = InteractText
                        obj.Active = true

                        local running = false

                        obj.InputBegan:Connect(function(input)
                            if input.UserInputType==Enum.UserInputType.MouseButton1 and not running then
                                running = true
                                obj.Inner.Loading.Visible = true
                                obj.Inner.Content.Visible = false

                                local s,r = pcall(Callback)

                                if not s then warn("Error occured when running Interactable callback: "..r) end

                                obj.Inner.Loading.Visible = false
                                obj.Inner.Content.Visible = true
                                running = false
                            end
                        end)
                        local mult = 0.8
                        connect(Run.RenderStepped,function()
                            obj.Inner.Loading.Loading.Rotation = (os.clock()*550)%360
                            local absp = obj.AbsolutePosition
                            local abss = obj.AbsoluteSize
                            local ap = obj.AnchorPoint
                            local inBoundsX = mouse.X>(absp.X-((1-ap.X)*abss.X)) and mouse.X<(absp.X-((1-ap.X)*abss.X)+abss.X)
                            local inBoundsY = mouse.Y>(absp.Y-((1-ap.Y)*abss.Y)+(abss.Y/2)) and mouse.Y<(absp.Y-((1-ap.Y)*abss.Y)+abss.Y+(abss.Y/2))
                            local accent = Window.Theme.AccentColor
                            obj.Inner.BackgroundColor3 = (inBoundsX and inBoundsY and (not UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1))) and Color3.new(accent.R*mult,accent.G*mult,accent.B*mult) or accent
                        end)

                        return element
                    end

                    function parent:CreateKeyPicker(Flag, Default, Callback)
                        -- Requirements
                        Library:Require(Flag,"Missing Flag argument for :CreateKeyPicker")


                        -- Checking Flag
                        Library:Require(not RegisteredFlags[Flag],"Flag already registered, pick another one ("..Flag..")")
                        RegisteredFlags[Flag] = true

                        -- Optionals
                        if typeof(Default)=="EnumItem" then
                            Default = Default.Name
                        end
                        Default = Default or "None"
                        Callback = Callback or Library.BlankFunction
                        if not Enum.KeyCode[Default] then
                            Default = "None"
                        end

                        -- Config
                        if LibArgs.SavingDisabled then
                            Configs[Flag] = nil
                        end
                        if Configs[Flag]==nil then
                            Configs[Flag] = Default
                        end
                        if Configs.IncludeGameProcessedInput then
                            Configs.IncludeGameProcessedInput = false
                        end

                        -- Element
                        local element = {}
                        local obj = Atlas.Objects.Keypicker:Clone()
                        obj.Name = string.rep("a",subElementIncrement)
                        subElementIncrement = subElementIncrement+1
                        obj.Parent = subholder

                        obj.Active = true

                        do
                            local listening = false
                            function element:UpdateDisplay()
                                obj.Inner.Key.Text = listening and "..." or (Configs[Flag] or "None")
                            end
                            element:UpdateDisplay()
                            obj.InputBegan:Connect(function(input,gpe)
                                if input.UserInputType==Enum.UserInputType.MouseButton1 and not gpe then
                                    listening = true
                                    element:UpdateDisplay()
                                end
                            end)
                            connect(UIS.InputBegan,function(input,gpe)
                                if input.UserInputType==Enum.UserInputType.Keyboard then
                                    if listening then
                                        listening = false
                                        local keycode = input.KeyCode.Name
                                        if input.KeyCode==Enum.KeyCode.Backspace then
                                            keycode = "None"
                                        end
                                        Configs[Flag] = keycode
                                        element:UpdateDisplay()
                                    else
                                        if input.KeyCode.Name==Configs[Flag] then
                                            if not Configs.IncludeGameProcessedInput then
                                                if gpe then
                                                    return
                                                end
                                            end
                                            coroutine.wrap(Callback)(input.KeyCode)
                                        end
                                    end
                                end
                            end)
                        end

                        return element
                    end

                    function parent:CreateColorPicker(Flag, Default, Callback)
                        -- Requirements
                        Library:Require(Flag,"Missing Flag argument for :CreateColorPicker")

                        -- Checking Flag
                        Library:Require(not RegisteredFlags[Flag],"Flag already registered, pick another one ("..Flag..")")
                        RegisteredFlags[Flag] = true

                        -- Optionals
                        Default = Default or Color3.new(1,0,0)
                        Callback = Callback or Library.BlankFunction
        
                        do
                            local h,s,v = Default:ToHSV()
                            Default = {h,s,v}
                        end

                        -- Config
                        if LibArgs.SavingDisabled then
                            Configs[Flag] = nil
                        end
                        if Configs[Flag]==nil then
                            Configs[Flag] = Default
                        end

                        -- Element
                        local element = {}
                        local obj = Atlas.Objects.Color:Clone()
                        obj.Name = string.rep("a",subElementIncrement)
                        subElementIncrement = subElementIncrement+1
                        obj.Parent = subholder

                        local pencil = obj.ImageLabel
                        local last = nil
                        connect(Run.RenderStepped,function()
                            local absp = obj.AbsolutePosition
                            local abss = obj.AbsoluteSize
                            local ap = obj.AnchorPoint
                            local inBoundsX = mouse.X>(absp.X-((1-ap.X)*abss.X)+abss.X) and mouse.X<(absp.X-((1-ap.X)*abss.X)+(abss.X*2))
                            local inBoundsY = mouse.Y>(absp.Y-((1-ap.Y)*abss.Y)+abss.Y) and mouse.Y<(absp.Y-((1-ap.Y)*abss.Y)+(abss.Y*2))
                            pencil.Visible = inBoundsX and inBoundsY
                            local current = Configs[Flag]
                            local color = Color3.fromHSV(current[1],current[2],current[3])
                            pencil.ImageColor3 = Library:GetTextContrast(color)
                            obj.BackgroundColor3 = color
                            if last~=color then
                                coroutine.wrap(Callback)(color)
                                last = color
                            end
                        end)

                        obj.Active = true

                        obj.InputBegan:Connect(function(input)
                            if input.UserInputType==Enum.UserInputType.MouseButton1 then
                                if pickerState then
                                    if pickerFlag==Flag then
                                        closePicker()
                                    else
                                        pickerFlag = Flag
                                    end
                                else
                                    pickerFlag = Flag
                                    openPicker()
                                end
                            end
                        end)

                        return element
                    end

                    return parent
                end
            end

            function Elements:CreateDropdown(Flag, Args)
                -- Requirements
                Library:Require(Args.Name,"Missing Name argument for :CreateDropdown")
                Library:Require(Flag,"Missing Flag argument for :CreateDropdown")
                Library:Require(Args.Values and #Args.Values>0,"Missing Flag argument for :CreateDropdown")

                -- Checking Flag
                Library:Require(not RegisteredFlags[Flag],"Flag already registered, pick another one ("..Flag..")")
                RegisteredFlags[Flag] = true

                -- Optionals
                local Acceptable = {"Single","Multi"}
                if Args.SelectType and (not table.find(Acceptable,Args.SelectType)) then
                    warn("Select type ("..Args.SelectType..") invalid. (Acceptable select types: "..table.concat(Acceptable,", ")..".")
                end
                if Args.Default == nil then
                    Args.Default = Args.Values[1]
                end
                Args.Callback = Args.Callback or Library.BlankFunction

                -- Config
                if LibArgs.SavingDisabled or Args.SavingDisabled then
                    Configs[Flag] = nil
                end
                if Configs[Flag]==nil then
                    Configs[Flag] = Args.Default
                end

                -- Element
                local element = {}
                local obj = Atlas.Objects.Dropdown:Clone()
                obj.Name = string.rep("a",elementIncrement)
                elementIncrement = elementIncrement+1
                obj.Bar.Text = Args.Name
                obj.Parent = holder

                local Values = {}

                if Args.SelectType=="Multi" and type(Configs[Flag])=="string" then
                    Configs[Flag] = {Configs[Flag]}
                end
                if Args.SelectType=="Single" and type(Configs[Flag])=="table" then
                    Configs[Flag] = Configs[Flag][1]
                end
                if not Args.SelectType then
                    Configs[Flag] = nil
                end

                local function makeDropdownButton()
                    local new = Atlas.Objects.DropdownButton:Clone()
                    new.Active = true

                    local holding = false
                    local function setHolding(state)
                        holding = state

                        new.Inner.BackgroundColor3 = holding and Window.Theme.FontColor or Window.Theme.BackgroundColor
                        new.Inner.Title.TextColor3 = holding and Window.Theme.BackgroundColor or Window.Theme.FontColor
                    end
                    new.InputBegan:Connect(function(input)
                        if input.UserInputType==Enum.UserInputType.MouseButton1 then
                            setHolding(true)
                        end
                    end)
                    new.InputEnded:Connect(function(input)
                        if holding and input.UserInputType==Enum.UserInputType.MouseButton1 then
                            if holding then
                                local content = new.Inner.Title.Text
                                coroutine.wrap(Args.Callback)(content)
                                if Args.SelectType=="Single" then
                                    Configs[Flag] = content
                                elseif Args.SelectType=="Multi" then
                                    if table.find(Configs[Flag],content) then
                                        -- remove
                                        local occ = table.find(Configs[Flag],content)
                                        table.remove(Configs[Flag],occ)
                                    else
                                        -- add
                                        table.insert(Configs[Flag],content)
                                    end
                                end
                                setHolding(false)
                            end
                        end
                    end)
                    new.MouseLeave:Connect(function()
                        setHolding(false)
                    end)
                    
                    new.Parent = obj.Content.ScrollingFrame
                    return new
                end

                function element:Set(new)
                    if Values~=new and #new>0 then
                        local seen = {}
                        for _,v in pairs(new) do
                            if seen[v] then
                                warn("Items in dropdown cannot appear twice ("..v..")")
                                return false
                            end
                            seen[v] = true
                        end
                        local newLength = #new
                        local oldLength = #Values
                        Values = new
                        if newLength>oldLength then
                            for i=1,newLength-oldLength do
                                makeDropdownButton()
                            end
                        elseif oldLength>newLength then
                            for i=1,oldLength-newLength do
                                local b = obj.Content.ScrollingFrame:FindFirstChildOfClass("Frame")
                                if b then
                                    b:Destroy()
                                end
                            end
                        end
                        local count = 1
                        for _,v in pairs(obj.Content.ScrollingFrame:GetChildren()) do
                            if v:IsA("Frame") then
                                v.Name = tostring(count)
                                v.Inner.Title.Text = new[count]
                                count = count+1
                            end
                        end
                    end
                end

                if Args.SelectType then
                    connect(Run.RenderStepped,function()
                        if Args.SelectType=="Single" then
                            obj.Bar.Text = Args.Name..": "..(Configs[Flag] or "None")
                        else
                            obj.Bar.Text = Args.Name..": "..(#Configs[Flag]==0 and "None" or table.concat(Configs[Flag],", "))
                        end
                    end)
                end

                function element:Select(new)
                    if Args.SelectType then
                        if Args.SelectType=="Multi" and type(new)=="table" then
                            Configs[Flag] = new
                        elseif Args.SelectType=="Single" and type(new)=="string" then
                            Configs[Flag] = new
                        else
                            warn("Unable to select item/s in dropdown because parameter is invalid")
                        end
                    else
                        warn("You can only use Dropdown:Select when SelectType is set")
                    end
                end

                function element:Get()
                    if Args.SelectType then
                        return Configs[Flag]
                    else
                        warn("You can only use Dropdown:Get when SelectType is set")
                    end
                end

                element:Set(Args.Values)

                do
                    local bar = obj.Bar
                    local arrow = bar.ImageLabel
                    local tween1
                    local tween2
                    local tweenInfo = TweenInfo.new(0.25,Enum.EasingStyle.Sine,Enum.EasingDirection.In,0,false,0)
                    obj["BarPadding"].Visible = false
                    local setState do
                        local state = false
                        obj.Content.Visible = false
                        obj.Content.Size = UDim2.new(0.95,0,0,0)
                        obj["!padding"].Size = UDim2.fromOffset(0,6)
                        obj["|padding"].Size = UDim2.fromOffset(0,6)
                        obj["BarPadding"].Size = UDim2.new(0,0,0,4)
                        function setState(new)
                            if new==state then return end
                            if new==nil then
                                new = not state
                            end
                            state = new
                            pcall(function()
                                tween1:Cancel()
                                tween1:Destroy()
                            end)
                            pcall(function()
                                tween2:Cancel()
                                tween2:Destroy()
                            end)
                            if state then
                                tween1 = TS:Create(obj.Content,tweenInfo,{
                                    ["Size"] = UDim2.new(0.95,0,0,126)
                                })
                                tween2 = TS:Create(arrow,tweenInfo,{
                                    ["Rotation"] = 180;
                                })
                                obj.Content.Visible = true
                                obj["BarPadding"].Visible = true
                                tween1:Play()
                                tween2:Play()
                            else
                                tween1 = TS:Create(obj.Content,tweenInfo,{
                                    ["Size"] = UDim2.new(0.95,0,0,0)
                                })
                                tween2 = TS:Create(arrow,tweenInfo,{
                                    ["Rotation"] = 0;
                                })
                                tween1.Completed:Connect(function(playbackState)
                                    if playbackState==Enum.PlaybackState.Completed then
                                        obj.Content.Visible = false
                                        obj["BarPadding"].Visible = false
                                    end
                                end)
                                tween1:Play()
                                tween2:Play()
                            end
                        end
                    end

                    bar.Active = true

                    local selected = false

                    bar.InputBegan:Connect(function(input) -- garbage collected when destroyed
                        if input.UserInputType==Enum.UserInputType.MouseButton1 then
                            selected = true
                        end
                    end)
                
                    bar.MouseLeave:Connect(function()
                        selected = false
                    end)
                
                    bar.InputEnded:Connect(function(input) -- garbage collected when destroyed
                        if input.UserInputType==Enum.UserInputType.MouseButton1 and selected then
                            selected = false
                            setState()
                        end
                    end)
                end

                return element
            end

            return Elements
        end

        local sectionIncrement = 1

        function Page:_createSection(side,s_Name)
            Library:Require(s_Name,"Missing Name argument for Page:CreateSection")

            local SectionObj = Atlas.Objects.Section:Clone()
            local Side = Holder:FindFirstChild(side)

            SectionObj.Name = string.rep("a",sectionIncrement)
            sectionIncrement = sectionIncrement+1

            local Section = getElementMethods(SectionObj)
            Section.Obj = SectionObj

            SectionObj["!title"].Text = s_Name
            SectionObj.Parent = Side

            return Section
        end

        function Page:_createTabbox(side)
            local SectionObj = Atlas.Objects.Groupbox:Clone()
            local Side = Holder:FindFirstChild(side)

            SectionObj.Name = string.rep("a",sectionIncrement)
            sectionIncrement = sectionIncrement+1

            local Tabbox = {
                ["Obj"] = SectionObj;
            }

            local tabIncrement = 1

            local CurrentTab = 1

            local sectionTitle = SectionObj["!title"].Inner

            function Tabbox:CreateTab(TabArgs)
                Library:Require(TabArgs.Name,"Missing arguments for Tabbox:CreateTab")

                local TabButton  = Atlas.Objects.GroupButton:Clone()

                local tabNum = tabIncrement
                tabIncrement = tabIncrement+1

                TabButton.Frame.TextLabel.Text = TabArgs.Name
                TabButton.Name = string.rep("a",tabNum)
                TabButton.Parent = sectionTitle
                TabButton.Active = true

                connect(TabButton.InputBegan,function(input)
                    if input.UserInputType==Enum.UserInputType.MouseButton1 then
                        CurrentTab = tabNum
                    end
                end)

                local TabInner = Atlas.Objects.InnerTabbox:Clone()

                local tabNumObj = Instance.new("IntValue")
                tabNumObj.Value = tabNum
                tabNumObj.Name = "TabNum"
                tabNumObj.Parent = TabInner
                tabNumObj:Clone().Parent = TabButton

                TabInner.Name = string.rep("a",tabNum)
                TabInner.Parent = SectionObj

                local Tab = getElementMethods(TabInner)
                Tab.Button = TabButton
                Tab.Inner = TabInner

                return Tab
            end

            connect(Run.RenderStepped,function()
                for _,v in pairs(SectionObj:GetChildren()) do
                    if v:FindFirstChild("TabNum") then
                        local e = v:FindFirstChild("TabNum")
                        v.Visible = CurrentTab==e.Value
                    end
                end
                for _,v in pairs(sectionTitle:GetChildren()) do
                    if v:FindFirstChild("TabNum") then
                        local e = v:FindFirstChild("TabNum")
                        local page = CurrentTab==e.Value
                        v.Frame.BackgroundColor3 = page and Window.Theme.FontColor or Window.Theme.MainColor
                        v.Frame.TextLabel.TextColor3 = page and Window.Theme.MainColor or Window.Theme.FontColor
                    end
                end
            end)

            SectionObj.Parent = Side

            return Tabbox
        end

        function Page:CreateLeftSection(...)
            return Page:_createSection("Left",...)
        end

        function Page:CreateRightSection(...)
            return Page:_createSection("Right",...)
        end

        function Page:CreateLeftTabbox(...)
            return Page:_createTabbox("Left",...)
        end

        function Page:CreateRightTabbox(...)
            return Page:_createTabbox("Right",...)
        end

        return Page
    end

    function Window:Destroy()
        for _,v in pairs(connections) do
            pcall(function()
                v:Disconnect()
            end)
        end
        UI:Destroy()
        for i,v in pairs(Window) do
            Window[i] = nil
        end
        Window = nil
        UIS.MouseIconEnabled = true
        getgenv()[removeOldVar][LibArgs.Name] = nil
    end

    getgenv()[removeOldVar][LibArgs.Name] = Window.Destroy

    UI.Enabled = true

    return Window
end

return Library
