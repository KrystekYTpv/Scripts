-- ill make a proper header later

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local Run = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local plr = Players.LocalPlayer

local mouse = plr:GetMouse()

-- in case of obfuscation with luraph (i wont anyways)
if not LPH_OBFUSCATED then
    local function r(f)
        return f
    end
    LPH_JIT_MAX = r
    LPH_NO_VIRTUALIZE = r
    LPH_JIT = r
end

local Library = {}

function Library:UpdateColorsUsingRegistry()
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

Library.BlankFunction = function() end

function Library:CreateWindow(LibArgs)
    Library:Require(LibArgs.Name,"Missing arguments for Library:CreateWindow")

    --LibArgs.Watermark = LibArgs.Watermark or LibArgs.Name or "Atlas"
    ---- This is a watermark that will be saved to your config file (does not interfere with script whatsoever). The purpose of this is to let people know what UI library they are using in case they want to use it themselves, please don't remove it :)
    --local FlagWatermark, SiegeInvite = "Atlas v2 made by Siege Scripting Utilities","https://discord.gg/rWHQSvDcc3"
    --local Configs = {
    --    [FlagWatermark] = SiegeInvite;
    --}
    --local RegisteredFlags = {
    --    [FlagWatermark] = true
    --}

    local connections = {}

    local function connect(connection,func)
        local e = connection:Connect(func)
        table.insert(connections,e)
        return e
    end

    if LibArgs.ConfigFolder then
        local json_signifier = "f139de2d47fe88c-[JSON DO NOT MODIFY, MADE WITH ATLAS V2 https://discord.gg/rWHQSvDcc3]-0ca1651877166cd76:"

        local config_path = LibArgs.ConfigFolder.."/configs.json"

        if not isfolder(LibArgs.ConfigFolder) then
            makefolder(LibArgs.ConfigFolder)
        end

        if isfile(config_path) then
            Configs = HttpService:JSONDecode(readfile(config_path))
        else
            writefile(config_path,HttpService:JSONEncode(Configs))
        end

        for i,v in pairs(Configs) do
            if type(v)=="string" and v:find(json_signifier) then
                v = string.gsub(v,json_signifier,"")
                Configs[i] = HttpService:JSONDecode(v) or nil
            end
        end

        local lastSave = os.clock()
        local SAVE_DELAY = 1

        local function save()
            local to_save = {}

            for i,v in pairs(Configs) do
                to_save[i] = v
            end

            for i,v in pairs(to_save) do
                if type(v)=="table" then
                    to_save[i] = json_signifier..HttpService:JSONEncode(v)
                end
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
            table.insert(connections,v) -- we need to store all the connections for proper destroying when i eventually code :Destroy
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
            AccentColor = LibArgs.Color or Color3.fromRGB(255,0,0); -- may change this behavior in the future
            OutlineColor = Color3.fromRGB(50, 50, 50); 
        };
    }

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
            --[[
            local invis = false
            mouse:GetPropertyChangedSignal("Icon"):Connect(function()
                if mouse.Icon ~= invis then
                    before = mouse.Icon
                end
            end)]]
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

    function Window:CreatePage(PageArgs)
        Library:Require(PageArgs.Name,"Missing arguments for Window:CreatePage")

        PageArgs.Icon = Library:FormatAsset(PageArgs.Icon)

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

        Select.Frame.TextLabel.Text = PageArgs.Name
        Select.Frame.Icon.Image = PageArgs.Icon

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
                if Configs.SavingDisabled then
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
                if Configs.SavingDisabled then
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
                    button.obj.Size = UDim2.new(1,0,1,0)

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
                if Configs.SavingDisabled then
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

                    button.Activated:Connect(function()
                        element:Toggle()
                    end)
                end

                do
                    local lerp = 0.3
                    local button = Library:CreateInvisButton(obj.ImageLabel)
                    local inside = obj.ImageLabel.ImageLabel
                    button.obj.Size = UDim2.new(1,0,1,0)

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

            return Elements
        end

        local sectionIncrement = 1

        function Page:_createSection(side,SectionArgs)
            Library:Require(SectionArgs.Name,"Missing arguments for Page:CreateSection")

            local SectionObj = Atlas.Objects.Section:Clone()
            local Side = Holder:FindFirstChild(side)

            SectionObj.Name = string.rep("a",sectionIncrement)
            sectionIncrement = sectionIncrement+1

            local Section = getElementMethods(SectionObj)
            Section.Obj = SectionObj

            SectionObj["!title"].Text = SectionArgs.Name
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
    end

    UI.Enabled = true

    return Window
end

-- might test this and fix any errors

return Library
