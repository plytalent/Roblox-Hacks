if game.PlaceId == 6032399813 or game.PlaceId == 5735553160 or game.PlaceId == 8668476218 then
    local LibraryUI =(function ()
    	--Cr. https://raw.githubusercontent.com/AlexR32/Roblox/main/BracketV3.lua
    	local Library = {Toggle = true,FirstTab = nil,TabCount = 0,ColorTable = {}}

    	local RunService = game:GetService("RunService")
    	local HttpService = game:GetService("HttpService")
    	local TweenService = game:GetService("TweenService")
    	local UserInputService = game:GetService("UserInputService")

    	local function MakeDraggable(ClickObject, Object)
    		local Dragging = nil
    		local DragInput = nil
    		local DragStart = nil
    		local StartPosition = nil

    		ClickObject.InputBegan:Connect(function(Input)
    			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
    				Dragging = true
    				DragStart = Input.Position
    				StartPosition = Object.Position

    				Input.Changed:Connect(function()
    					if Input.UserInputState == Enum.UserInputState.End then
    						Dragging = false
    					end
    				end)
    			end
    		end)

    		ClickObject.InputChanged:Connect(function(Input)
    			if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
    				DragInput = Input
    			end
    		end)

    		UserInputService.InputChanged:Connect(function(Input)
    			if Input == DragInput and Dragging then
    				local Delta = Input.Position - DragStart
    				Object.Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
    			end
    		end)
    	end

    	function Library:CreateWindow(Config, Parent)
    		local WindowInit = {}
    		local Folder = game:GetObjects("rbxassetid://7141683860")[1]
    		local Screen = Folder.Bracket:Clone()
    		local Main = Screen.Main
    		local Holder = Main.Holder
    		local Topbar = Main.Topbar
    		local TContainer = Holder.TContainer
    		local TBContainer = Holder.TBContainer.Holder
    		WindowInit.ScreenObject = Main
    		--[[
    		-- idk probably fix for exploits that dont have this function
    		if syn and syn.protect_gui then
    			syn.protect_gui(Screen)
    		end
    		]]

    		Screen.Name =  HttpService:GenerateGUID(false)
    		Screen.Parent = Parent
    		Topbar.WindowName.Text = Config.WindowName
    		MakeDraggable(Topbar,Main)
    		function WindowInit:SetTileText(name)
    			Topbar.WindowName.Text = name
    		end
    		function WindowInit:SetSizeScale(x,y)
    			Topbar.WindowName.Text = name
    		end
    		local function CloseAll()
    			for _,Tab in pairs(TContainer:GetChildren()) do
    				if Tab:IsA("ScrollingFrame") then
    					Tab.Visible = false
    				end
    			end
    		end
    		local function ResetAll()
    			for _,TabButton in pairs(TBContainer:GetChildren()) do
    				if TabButton:IsA("TextButton") then
    					TabButton.BackgroundTransparency = 1
    				end
    			end
    			for _,TabButton in pairs(TBContainer:GetChildren()) do
    				if TabButton:IsA("TextButton") then
    					TabButton.Size = UDim2.new(0,480 / Library.TabCount,1,0)
    				end
    			end
    			for _,Pallete in pairs(Screen:GetChildren()) do
    				if Pallete:IsA("Frame") and Pallete.Name ~= "Main" then
    					Pallete.Visible = false
    				end
    			end
    		end
    		local function KeepFirst()
    			for _,Tab in pairs(TContainer:GetChildren()) do
    				if Tab:IsA("ScrollingFrame") then
    					if Tab.Name == Library.FirstTab .. " T" then
    						Tab.Visible = true
    					else
    						Tab.Visible = false
    					end
    				end
    			end
    			for _,TabButton in pairs(TBContainer:GetChildren()) do
    				if TabButton:IsA("TextButton") then
    					if TabButton.Name == Library.FirstTab .. " TB" then
    						TabButton.BackgroundTransparency = 0
    					else
    						TabButton.BackgroundTransparency = 1
    					end
    				end
    			end
    		end
    		local function Toggle(State)
    			if State then
    				Main.Visible = true
    			elseif not State then
    				for _,Pallete in pairs(Screen:GetChildren()) do
    					if Pallete:IsA("Frame") and Pallete.Name ~= "Main" then
    						Pallete.Visible = false
    					end
    				end
    				Screen.ToolTip.Visible = false
    				Main.Visible = false
    			end
    			Library.Toggle = State
    		end
    		local function ChangeColor(Color)
    			Config.Color = Color
    			for i, v in pairs(Library.ColorTable) do
    				if v.BackgroundColor3 ~= Color3.fromRGB(50, 50, 50) then
    					v.BackgroundColor3 = Color
    				end
    			end
    		end

    		function WindowInit:Toggle(State)
    			Toggle(State)
    		end

    		function WindowInit:ChangeColor(Color)
    			ChangeColor(Color)
    		end

    		function WindowInit:SetBackground(ImageId)
    			Holder.Image = "rbxassetid://" .. ImageId
    		end

    		function WindowInit:SetBackgroundColor(Color)
    			Holder.ImageColor3 = Color
    		end
    		function WindowInit:SetBackgroundTransparency(Transparency)
    			Holder.ImageTransparency = Transparency
    		end

    		function WindowInit:SetTileOffset(Offset)
    			Holder.TileSize = UDim2.new(0,Offset,0,Offset)
    		end
    		function WindowInit:SetTileScale(Scale)
    			Holder.TileSize = UDim2.new(Scale,0,Scale,0)
    		end

    		RunService.RenderStepped:Connect(function()
    			if Library.Toggle then
    				Screen.ToolTip.Position = UDim2.new(0,UserInputService:GetMouseLocation().X + 10,0,UserInputService:GetMouseLocation().Y - 5)
    			end
    		end)

    		function WindowInit:CreateTab(Name)
    			local TabInit = {}
    			local Tab = Folder.Tab:Clone()
    			local TabButton = Folder.TabButton:Clone()

    			Tab.Name = Name .. " T"
    			Tab.Parent = TContainer

    			TabButton.Name = Name .. " TB"
    			TabButton.Parent = TBContainer
    			TabButton.Title.Text = Name
    			TabButton.BackgroundColor3 = Config.Color

    			table.insert(Library.ColorTable, TabButton)
    			Library.TabCount = Library.TabCount + 1
    			if Library.TabCount == 1 then
    				Library.FirstTab = Name
    			end

    			CloseAll()
    			ResetAll()
    			KeepFirst()

    			local function GetSide(Longest)
    				if Longest then
    					if Tab.LeftSide.ListLayout.AbsoluteContentSize.Y > Tab.RightSide.ListLayout.AbsoluteContentSize.Y then
    						return Tab.LeftSide
    					else
    						return Tab.RightSide
    					end
    				else
    					if Tab.LeftSide.ListLayout.AbsoluteContentSize.Y > Tab.RightSide.ListLayout.AbsoluteContentSize.Y then
    						return Tab.RightSide
    					else
    						return Tab.LeftSide
    					end
    				end
    			end

    			TabButton.MouseButton1Click:Connect(function()
    				CloseAll()
    				ResetAll()
    				Tab.Visible = true
    				TabButton.BackgroundTransparency = 0
    			end)

    			Tab.LeftSide.ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    				if GetSide(true).Name == Tab.LeftSide.Name then
    					Tab.CanvasSize = UDim2.new(0,0,0,Tab.LeftSide.ListLayout.AbsoluteContentSize.Y + 15)
    				else
    					Tab.CanvasSize = UDim2.new(0,0,0,Tab.RightSide.ListLayout.AbsoluteContentSize.Y + 15)
    				end
    			end)
    			Tab.RightSide.ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    				if GetSide(true).Name == Tab.LeftSide.Name then
    					Tab.CanvasSize = UDim2.new(0,0,0,Tab.LeftSide.ListLayout.AbsoluteContentSize.Y + 15)
    				else
    					Tab.CanvasSize = UDim2.new(0,0,0,Tab.RightSide.ListLayout.AbsoluteContentSize.Y + 15)
    				end
    			end)

    			function TabInit:CreateSection(Name)
    				local SectionInit = {}
    				local Section = Folder.Section:Clone()
    				Section.Name = Name .. " S"
    				Section.Parent = GetSide(false)

    				Section.Title.Text = Name
    				Section.Title.Size = UDim2.new(0,Section.Title.TextBounds.X + 10,0,2)

    				Section.Container.ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    					Section.Size = UDim2.new(1,0,0,Section.Container.ListLayout.AbsoluteContentSize.Y + 15)
    				end)
    				function SectionInit:UpdateTitle(Text)
    	                Section.Title.Text = Text
    	                Section.Title.Size = UDim2.new(0,Section.Title.TextBounds.X + 10,0,2)
    	            end
    				function SectionInit:CreateLabel(Name)
    					local LabelInit = {}
    					local Label = Folder.Label:Clone()
    					Label.Name = Name .. " L"
    					Label.Parent = Section.Container
    					Label.Text = Name
    					Label.Size = UDim2.new(1,-10,0,Label.TextBounds.Y)
    					function LabelInit:UpdateText(Text)
    						Label.Text = Text
    						Label.Size = UDim2.new(1,-10,0,Label.TextBounds.Y)
    					end
    					return LabelInit
    				end
    				function SectionInit:CreateButton(Name, Callback)
    					local ButtonInit = {}
    					local Button = Folder.Button:Clone()
    					Button.Name = Name .. " B"
    					Button.Parent = Section.Container
    					Button.Title.Text = Name
    					Button.Size = UDim2.new(1,-10,0,Button.Title.TextBounds.Y + 5)
    					table.insert(Library.ColorTable, Button)

    					Button.MouseButton1Down:Connect(function()
    						Button.BackgroundColor3 = Config.Color
    					end)

    					Button.MouseButton1Up:Connect(function()
    						Button.BackgroundColor3 = Color3.fromRGB(50,50,50)
    					end)

    					Button.MouseLeave:Connect(function()
    						Button.BackgroundColor3 = Color3.fromRGB(50,50,50)
    					end)

    					Button.MouseButton1Click:Connect(function()
    						Callback()
    					end)
    	                function ButtonInit:UpdateText(Text)
    	                    Button.Title.Text = Text
    	                end
    					function ButtonInit:AddToolTip(Name)
    						if tostring(Name):gsub(" ", "") ~= "" then
    							Button.MouseEnter:Connect(function()
    								Screen.ToolTip.Text = Name
    								Screen.ToolTip.Size = UDim2.new(0,Screen.ToolTip.TextBounds.X + 5,0,Screen.ToolTip.TextBounds.Y + 5)
    								Screen.ToolTip.Visible = true
    							end)

    							Button.MouseLeave:Connect(function()
    								Screen.ToolTip.Visible = false
    							end)
    						end
    					end

    					return ButtonInit
    				end
    				function SectionInit:CreateTextBox(Name, PlaceHolder, NumbersOnly, Callback)
    					local TextBoxInit = {}
    					local TextBox = Folder.TextBox:Clone()
    					TextBox.Name = Name .. " T"
    					TextBox.Parent = Section.Container
    					TextBox.Title.Text = Name
    					TextBox.Background.Input.PlaceholderText = PlaceHolder
    					TextBox.Title.Size = UDim2.new(1,0,0,TextBox.Title.TextBounds.Y + 5)
    					TextBox.Size = UDim2.new(1,-10,0,TextBox.Title.TextBounds.Y + 25)

    					TextBox.Background.Input.FocusLost:Connect(function()
    						if NumbersOnly and not tonumber(TextBox.Background.Input.Text) then
    							Callback(tonumber(TextBox.Background.Input.Text))
    							--TextBox.Background.Input.Text = ""
    						else
    							Callback(TextBox.Background.Input.Text)
    							--TextBox.Background.Input.Text = ""
    						end
    					end)
    					function TextBoxInit:SetValue(String)
    						Callback(String)
    						TextBox.Background.Input.Text = String
    					end
    	                function TextBoxInit:GetValue()
    						return TextBox.Background.Input.Text or ""
    					end
    					function TextBoxInit:AddToolTip(Name)
    						if tostring(Name):gsub(" ", "") ~= "" then
    							TextBox.MouseEnter:Connect(function()
    								Screen.ToolTip.Text = Name
    								Screen.ToolTip.Size = UDim2.new(0,Screen.ToolTip.TextBounds.X + 5,0,Screen.ToolTip.TextBounds.Y + 5)
    								Screen.ToolTip.Visible = true
    							end)

    							TextBox.MouseLeave:Connect(function()
    								Screen.ToolTip.Visible = false
    							end)
    						end
    					end
    					return TextBoxInit
    				end
    				function SectionInit:CreateToggle(Name, Default, Callback)
    					local DefaultLocal = Default or false
    					local ToggleInit = {}
    					local Toggle = Folder.Toggle:Clone()
    					Toggle.Name = Name .. " T"
    					Toggle.Parent = Section.Container
    					Toggle.Title.Text = Name
    					Toggle.Size = UDim2.new(1,-10,0,Toggle.Title.TextBounds.Y + 5)

    					table.insert(Library.ColorTable, Toggle.Toggle)
    					local ToggleState = false

    					local function SetState(State)
    						if State then
    							Toggle.Toggle.BackgroundColor3 = Config.Color
    						elseif not State then
    							Toggle.Toggle.BackgroundColor3 = Color3.fromRGB(50,50,50)
    						end
    						ToggleState = State
    						Callback(State)
    					end
    	                function ToggleInit:SetText(String)
    						Toggle.Title.Text = String
    					end
    					Toggle.MouseButton1Click:Connect(function()
    						ToggleState = not ToggleState
    						SetState(ToggleState)
    					end)

    					function ToggleInit:AddToolTip(Name)
    						if tostring(Name):gsub(" ", "") ~= "" then
    							Toggle.MouseEnter:Connect(function()
    								Screen.ToolTip.Text = Name
    								Screen.ToolTip.Size = UDim2.new(0,Screen.ToolTip.TextBounds.X + 5,0,Screen.ToolTip.TextBounds.Y + 5)
    								Screen.ToolTip.Visible = true
    							end)

    							Toggle.MouseLeave:Connect(function()
    								Screen.ToolTip.Visible = false
    							end)
    						end
    					end

    					if Default == nil then
    						function ToggleInit:SetState(State)
    							SetState(State)
    						end
    					else
    						SetState(DefaultLocal)
    					end

    					function ToggleInit:GetState(State)
    						return ToggleState
    					end

    					function ToggleInit:CreateKeybind(Bind,Callback)
    						local KeybindInit = {}
    						Bind = Bind or "NONE"

    						local WaitingForBind = false
    						local Selected = Bind
    						local Blacklist = {"W","A","S","D","Slash","Tab","Backspace","Escape","Space","Delete","Unknown","Backquote"}

    						Toggle.Keybind.Visible = true
    						Toggle.Keybind.Text = "[ " .. Bind .. " ]"

    						Toggle.Keybind.MouseButton1Click:Connect(function()
    							Toggle.Keybind.Text = "[ ... ]"
    							WaitingForBind = true
    						end)

    						Toggle.Keybind:GetPropertyChangedSignal("TextBounds"):Connect(function()
    							Toggle.Keybind.Size = UDim2.new(0,Toggle.Keybind.TextBounds.X,1,0)
    							Toggle.Title.Size = UDim2.new(1,-Toggle.Keybind.Size.X.Offset - 15,1,0)
    						end)

    						UserInputService.InputBegan:Connect(function(Input)
    							if WaitingForBind and Input.UserInputType == Enum.UserInputType.Keyboard then
    								local Key = tostring(Input.KeyCode):gsub("Enum.KeyCode.", "")
    								if not table.find(Blacklist, Key) then
    									Toggle.Keybind.Text = "[ " .. Key .. " ]"
    									Selected = Key
    								else
    									Toggle.Keybind.Text = "[ NONE ]"
    									Selected = "NONE"
    								end
    								WaitingForBind = false
    							elseif Input.UserInputType == Enum.UserInputType.Keyboard then
    								local Key = tostring(Input.KeyCode):gsub("Enum.KeyCode.", "")
    								if Key == Selected then
    									ToggleState = not ToggleState
    									SetState(ToggleState)
    									if Callback then
    										Callback(Key)
    									end
    								end
    							end
    						end)

    						function KeybindInit:SetBind(Key)
    							Toggle.Keybind.Text = "[ " .. Key .. " ]"
    							Selected = Key
    						end

    						function KeybindInit:GetBind()
    							return Selected
    						end

    						return KeybindInit
    					end
    					return ToggleInit
    				end
    				function SectionInit:CreateSlider(Name, Min, Max, Default, Precise, Callback)
    					local DefaultLocal = Default or 50
    					local SliderInit = {}
    					local Slider = Folder.Slider:Clone()
    					Slider.Name = Name .. " S"
    					Slider.Parent = Section.Container

    					Slider.Title.Text = Name
    					Slider.Slider.Bar.Size = UDim2.new(Min / Max,0,1,0)
    					Slider.Slider.Bar.BackgroundColor3 = Config.Color
    					Slider.Value.PlaceholderText = tostring(Min / Max)
    					Slider.Title.Size = UDim2.new(1,0,0,Slider.Title.TextBounds.Y + 5)
    					Slider.Size = UDim2.new(1,-10,0,Slider.Title.TextBounds.Y + 15)
    					table.insert(Library.ColorTable, Slider.Slider.Bar)

    					local GlobalSliderValue = 0
    					local Dragging = false
    					local function Sliding(Input)
    	                    local Position = UDim2.new(math.clamp((Input.Position.X - Slider.Slider.AbsolutePosition.X) / Slider.Slider.AbsoluteSize.X,0,1),0,1,0)
    	                    Slider.Slider.Bar.Size = Position
    						local SliderPrecise = ((Position.X.Scale * Max) / Max) * (Max - Min) + Min
    						local SliderNonPrecise = math.floor(((Position.X.Scale * Max) / Max) * (Max - Min) + Min)
    	                    local SliderValue = Precise and SliderNonPrecise or SliderPrecise
    						SliderValue = tonumber(string.format("%.2f", SliderValue))
    						GlobalSliderValue = SliderValue
    	                    Slider.Value.PlaceholderText = tostring(SliderValue)
    	                    Callback(GlobalSliderValue)
    	                end
    					local function SetValue(Value)
    						GlobalSliderValue = Value
    						Slider.Slider.Bar.Size = UDim2.new(Value / Max,0,1,0)
    						Slider.Value.PlaceholderText = Value
    						Callback(Value)
    					end
    					Slider.Value.FocusLost:Connect(function()
    						if not tonumber(Slider.Value.Text) then
    							Slider.Value.Text = GlobalSliderValue
    						elseif Slider.Value.Text == "" or tonumber(Slider.Value.Text) <= Min then
    							Slider.Value.Text = Min
    						elseif Slider.Value.Text == "" or tonumber(Slider.Value.Text) >= Max then
    							Slider.Value.Text = Max
    						end
                        
    						GlobalSliderValue = Slider.Value.Text
    						Slider.Slider.Bar.Size = UDim2.new(Slider.Value.Text / Max,0,1,0)
    						Slider.Value.PlaceholderText = Slider.Value.Text
    						Callback(tonumber(Slider.Value.Text))
    						Slider.Value.Text = ""
    					end)

    					Slider.InputBegan:Connect(function(Input)
    	                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
    	                        Sliding(Input)
    							Dragging = true
    	                    end
    	                end)

    					Slider.InputEnded:Connect(function(Input)
    	                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
    							Dragging = false
    	                    end
    	                end)

    					UserInputService.InputBegan:Connect(function(Input)
    						if Input.KeyCode == Enum.KeyCode.LeftControl then
    							Slider.Value.ZIndex = 4
    						end
    					end)

    					UserInputService.InputEnded:Connect(function(Input)
    						if Input.KeyCode == Enum.KeyCode.LeftControl then
    							Slider.Value.ZIndex = 3
    						end
    					end)

    					UserInputService.InputChanged:Connect(function(Input)
    						if Dragging and Input.UserInputType == Enum.UserInputType.MouseMovement then
    							Sliding(Input)
    						end
    					end)

    					function SliderInit:AddToolTip(Name)
    						if tostring(Name):gsub(" ", "") ~= "" then
    							Slider.MouseEnter:Connect(function()
    								Screen.ToolTip.Text = Name
    								Screen.ToolTip.Size = UDim2.new(0,Screen.ToolTip.TextBounds.X + 5,0,Screen.ToolTip.TextBounds.Y + 5)
    								Screen.ToolTip.Visible = true
    							end)

    							Slider.MouseLeave:Connect(function()
    								Screen.ToolTip.Visible = false
    							end)
    						end
    					end

    					if Default == nil then
    						function SliderInit:SetValue(Value)
    							GlobalSliderValue = Value
    							Slider.Slider.Bar.Size = UDim2.new(Value / Max,0,1,0)
    							Slider.Value.PlaceholderText = Value
    							Callback(Value)
    						end
    					else
    						SetValue(DefaultLocal)
    					end

    					function SliderInit:GetValue(Value)
    						return GlobalSliderValue
    					end

    					return SliderInit
    				end
    				function SectionInit:CreateDropdown(Name, OptionTable, Callback, InitialValue)
    					local DropdownInit = {}
    					local Dropdown = Folder.Dropdown:Clone()
    					Dropdown.Name = Name .. " D"
    					Dropdown.Parent = Section.Container

    					Dropdown.Title.Text = Name
    					Dropdown.Title.Size = UDim2.new(1,0,0,Dropdown.Title.TextBounds.Y + 5)
    					Dropdown.Container.Position = UDim2.new(0,0,0,Dropdown.Title.TextBounds.Y + 5)
    					Dropdown.Size = UDim2.new(1,-10,0,Dropdown.Title.TextBounds.Y + 25)

    					local DropdownToggle = false

    					Dropdown.MouseButton1Click:Connect(function()
    						DropdownToggle = not DropdownToggle
    						if DropdownToggle then
    							Dropdown.Size = UDim2.new(1,-10,0,Dropdown.Container.Holder.Container.ListLayout.AbsoluteContentSize.Y + Dropdown.Title.TextBounds.Y + 30)
    							Dropdown.Container.Holder.Visible = true
    						else
    							Dropdown.Size = UDim2.new(1,-10,0,Dropdown.Title.TextBounds.Y + 25)
    							Dropdown.Container.Holder.Visible = false
    						end
    					end)

    					for _,OptionName in pairs(OptionTable) do
    						local Option = Folder.Option:Clone()
    						Option.Name = OptionName
    						Option.Parent = Dropdown.Container.Holder.Container

    						Option.Title.Text = OptionName
    						Option.BackgroundColor3 = Config.Color
    						Option.Size = UDim2.new(1,0,0,Option.Title.TextBounds.Y + 5)
    						Dropdown.Container.Holder.Size = UDim2.new(1,-5,0,Dropdown.Container.Holder.Container.ListLayout.AbsoluteContentSize.Y)
    						table.insert(Library.ColorTable, Option)

    						Option.MouseButton1Down:Connect(function()
    							Option.BackgroundTransparency = 0
    						end)

    						Option.MouseButton1Up:Connect(function()
    							Option.BackgroundTransparency = 1
    						end)

    						Option.MouseLeave:Connect(function()
    							Option.BackgroundTransparency = 1
    						end)

    						Option.MouseButton1Click:Connect(function()
    							Dropdown.Container.Value.Text = OptionName
    							Callback(OptionName)
    						end)
    					end
    					function DropdownInit:AddToolTip(Name)
    						if tostring(Name):gsub(" ", "") ~= "" then
    							Dropdown.MouseEnter:Connect(function()
    								Screen.ToolTip.Text = Name
    								Screen.ToolTip.Size = UDim2.new(0,Screen.ToolTip.TextBounds.X + 5,0,Screen.ToolTip.TextBounds.Y + 5)
    								Screen.ToolTip.Visible = true
    							end)

    							Dropdown.MouseLeave:Connect(function()
    								Screen.ToolTip.Visible = false
    							end)
    						end
    					end

    					function DropdownInit:GetOption()
    						return Dropdown.Container.Value.Text
    					end
    					function DropdownInit:SetOption(Name)
    						for _,Option in pairs(Dropdown.Container.Holder.Container:GetChildren()) do
    							if Option:IsA("TextButton") and string.find(Option.Name, Name) then
    								Dropdown.Container.Value.Text = Option.Name
    								Callback(Name)
    							end
    						end
    					end
    					function DropdownInit:RemoveOption(Name)
    						for _,Option in pairs(Dropdown.Container.Holder.Container:GetChildren()) do
    							if Option:IsA("TextButton") and string.find(Option.Name, Name) then
    								Option:Destroy()
    							end
    						end
    						Dropdown.Container.Holder.Size = UDim2.new(1,-5,0,Dropdown.Container.Holder.Container.ListLayout.AbsoluteContentSize.Y)
    								Dropdown.Size = UDim2.new(1,-10,0,Dropdown.Container.Holder.Container.ListLayout.AbsoluteContentSize.Y + Dropdown.Title.TextBounds.Y + 30)
    					end
    					function DropdownInit:ClearOptions()
    						for _, Option in pairs(Dropdown.Container.Holder.Container:GetChildren()) do
    							if Option:IsA("TextButton") then
    								Option:Destroy()
    							end
    						end
    						Dropdown.Container.Holder.Size = UDim2.new(1,-5,0,Dropdown.Container.Holder.Container.ListLayout.AbsoluteContentSize.Y)
    						Dropdown.Size = UDim2.new(1,-10,0,Dropdown.Container.Holder.Container.ListLayout.AbsoluteContentSize.Y + Dropdown.Title.TextBounds.Y + 30)
    					end
    					if InitialValue then
    						DropdownInit:SetOption(InitialValue)
    					end
    					return DropdownInit
    				end
    				function SectionInit:CreateColorpicker(Name,Callback)
    					local ColorpickerInit = {}
    					local Colorpicker = Folder.Colorpicker:Clone()
    					local Pallete = Folder.Pallete:Clone()

    					Colorpicker.Name = Name .. " CP"
    					Colorpicker.Parent = Section.Container
    					Colorpicker.Title.Text = Name
    					Colorpicker.Size = UDim2.new(1,-10,0,Colorpicker.Title.TextBounds.Y + 5)

    					Pallete.Name = Name .. " P"
    					Pallete.Parent = Screen

    					local ColorTable = {
    						Hue = 1,
    						Saturation = 0,
    						Value = 0
    					}
    					local ColorRender = nil
    					local HueRender = nil
    					local ColorpickerRender = nil
    					local function UpdateColor()
    						Colorpicker.Color.BackgroundColor3 = Color3.fromHSV(ColorTable.Hue,ColorTable.Saturation,ColorTable.Value)
    						Pallete.GradientPallete.BackgroundColor3 = Color3.fromHSV(ColorTable.Hue,1,1)
    						Pallete.Input.InputBox.PlaceholderText = "RGB: " .. math.round(Colorpicker.Color.BackgroundColor3.R* 255) .. "," .. math.round(Colorpicker.Color.BackgroundColor3.G * 255) .. "," .. math.round(Colorpicker.Color.BackgroundColor3.B * 255)
    						Callback(Colorpicker.Color.BackgroundColor3)
    					end

    					Colorpicker.MouseButton1Click:Connect(function()
    						if not Pallete.Visible then
    							ColorpickerRender = RunService.RenderStepped:Connect(function()
    								Pallete.Position = UDim2.new(0,Colorpicker.Color.AbsolutePosition.X - 129,0,Colorpicker.Color.AbsolutePosition.Y + 52)
    							end)
    							Pallete.Visible = true
    						else
    							Pallete.Visible = false
    							ColorpickerRender:Disconnect()
    						end
    					end)

    					Pallete.GradientPallete.InputBegan:Connect(function(Input)
    						if Input.UserInputType == Enum.UserInputType.MouseButton1 then
    	                        if ColorRender then
    	                            ColorRender:Disconnect()
    	                        end
    							ColorRender = RunService.RenderStepped:Connect(function()
    								local Mouse = UserInputService:GetMouseLocation()
    								local ColorX = math.clamp(Mouse.X - Pallete.GradientPallete.AbsolutePosition.X, 0, Pallete.GradientPallete.AbsoluteSize.X) / Pallete.GradientPallete.AbsoluteSize.X
    	                            local ColorY = math.clamp((Mouse.Y - 37) - Pallete.GradientPallete.AbsolutePosition.Y, 0, Pallete.GradientPallete.AbsoluteSize.Y) / Pallete.GradientPallete.AbsoluteSize.Y
    								Pallete.GradientPallete.Dot.Position = UDim2.new(ColorX,0,ColorY,0)
    								ColorTable.Saturation = ColorX
    								ColorTable.Value = 1 - ColorY
    								UpdateColor()
    							end)
    						end
    					end)

    					Pallete.GradientPallete.InputEnded:Connect(function(Input)
    						if Input.UserInputType == Enum.UserInputType.MouseButton1 then
    	                        if ColorRender then
    	                            ColorRender:Disconnect()
    	                        end
    						end
    					end)

    					Pallete.ColorSlider.InputBegan:Connect(function(Input)
    						if Input.UserInputType == Enum.UserInputType.MouseButton1 then
    	                        if HueRender then
    	                            HueRender:Disconnect()
    	                        end
    							HueRender = RunService.RenderStepped:Connect(function()
    								local Mouse = UserInputService:GetMouseLocation()
    								local HueX = math.clamp(Mouse.X - Pallete.ColorSlider.AbsolutePosition.X, 0, Pallete.ColorSlider.AbsoluteSize.X) / Pallete.ColorSlider.AbsoluteSize.X
    								ColorTable.Hue = 1 - HueX
    								UpdateColor()
    							end)
    	                    end
    					end)

    					Pallete.ColorSlider.InputEnded:Connect(function(Input)
    						if Input.UserInputType == Enum.UserInputType.MouseButton1 then
    	                        if HueRender then
    	                            HueRender:Disconnect()
    	                        end
    	                    end
    					end)

    					function ColorpickerInit:UpdateColor(Color)
    						local Hue, Saturation, Value = Color:ToHSV()
    						Colorpicker.Color.BackgroundColor3 = Color3.fromHSV(Hue,Saturation,Value)
    						Pallete.GradientPallete.BackgroundColor3 = Color3.fromHSV(Hue,1,1)
    						Pallete.Input.InputBox.PlaceholderText = "RGB: " .. math.round(Colorpicker.Color.BackgroundColor3.R* 255) .. "," .. math.round(Colorpicker.Color.BackgroundColor3.G * 255) .. "," .. math.round(Colorpicker.Color.BackgroundColor3.B * 255)
    						ColorTable = {
    							Hue = Hue,
    							Saturation = Saturation,
    							Value = Value
    						}
    						Callback(Color)
    					end

    					Pallete.Input.InputBox.FocusLost:Connect(function(Enter)
    						if Enter then
    							local ColorString = string.split(string.gsub(Pallete.Input.InputBox.Text," ", ""), ",")
    							ColorpickerInit:UpdateColor(Color3.fromRGB(ColorString[1],ColorString[2],ColorString[3]))
    							Pallete.Input.InputBox.Text = ""
    						end
    					end)

    					function ColorpickerInit:AddToolTip(Name)
    						if tostring(Name):gsub(" ", "") ~= "" then
    							Colorpicker.MouseEnter:Connect(function()
    								Screen.ToolTip.Text = Name
    								Screen.ToolTip.Size = UDim2.new(0,Screen.ToolTip.TextBounds.X + 5,0,Screen.ToolTip.TextBounds.Y + 5)
    								Screen.ToolTip.Visible = true
    							end)

    							Colorpicker.MouseLeave:Connect(function()
    								Screen.ToolTip.Visible = false
    							end)
    						end
    					end

    					return ColorpickerInit
    				end
    				return SectionInit
    			end
    			return TabInit
    		end
    		return WindowInit
    	end

    	return Library
    end)()
    local camera = workspace.CurrentCamera
    local RunService = game:GetService("RunService")
    local Config = {
    	WindowName = "RubyTheSilent Hub [Deepwoken]",
    	Color = Color3.fromRGB(255,128,64),
    }
    local variables = {
        limit_distant = 6000,
        Text_Size = 18,
        NameTagColor = Color3.new(1,0,0),
        DistantTagColor = Color3.new(1,1,1)
    }
    local Keybinds = {
        OpenUIKeyBind = Enum.KeyCode.LeftAlt.Name
    }
    if _G.Data == nil then
        _G.Data = {}
    end

    local Window = LibraryUI:CreateWindow(Config, game:GetService("CoreGui"))
    Window:Toggle(false)

    local Tab1 = Window:CreateTab("Main")
    local Tab2 = Window:CreateTab("Debug")
    local Tab3 = Window:CreateTab("UI")
    
    local UI_1_1 = Tab1:CreateSection("ESP")
    local UI_2_1 = Tab2:CreateSection("Debug")
    local UI_3_1 = Tab3:CreateSection("UI")

    local Toggle4 = UI_3_1:CreateToggle("UI Toggle", nil, function(State)
        Window:Toggle(State)
    end)
    local ColorPick1 = UI_1_1:CreateColorpicker("NameTag Color", function(Color)
        variables.NameTagColor = Color
    end)
    local ColorPick2 = UI_1_1:CreateColorpicker("DistantTag Color", function(Color)
        variables.DistantTagColor = Color
    end)
    local Distant_Slider = UI_1_1:CreateSlider("Distant", 0, 6000, 6000, false, function(x)
    	variables.limit_distant = x
    end)
    local SizeText_Slider = UI_1_1:CreateSlider("Distant", 10, 24, 18, false, function(x)
    	variables.Text_Size = x
    end)

    local Mob_toggle = UI_1_1:CreateToggle("Toggle Mob ESP", true, function()end)
    local Error_log_toggle = UI_2_1:CreateToggle("Toggle Error Log", true, function()end)

    function synTextLabel()
        local TextLabel = Drawing.new("Text")
        if not getgenv().Syn_Drawing then
            getgenv().Syn_Drawing = {}
        end
        getgenv().Syn_Drawing[#getgenv().Syn_Drawing+1] = TextLabel
        TextLabel.Text = "Place"
        TextLabel.Size = 24
        TextLabel.Center = true
        TextLabel.Outline = true
        TextLabel.Color = Color3.new(255/255, 0/255, 0/255)
        TextLabel.OutlineColor = Color3.new(0, 0, 0)
        return TextLabel
    end

    function worldpoint_to_viewpoint(pos)
        local pos, in_fov = camera.WorldToViewportPoint(camera,pos)
        return in_fov, Vector2.new(pos.X,pos.Y)
    end
    RunService:BindToRenderStep("ESP Update",Enum.RenderPriority.Character.Value+1,function()
        local s,err = pcall(function()
            local live_child = workspace.Live:GetChildren()
            local cam_pos = camera.CFrame.Position
            for index = 1, #live_child do
                local character = live_child[index]
                if character.Name:split("")[1] == "." then
                    local data = _G.Data[character]
                    if data == nil then
                        data = {
                            NameTag = synTextLabel(),
                            DistantTag = synTextLabel()
                        }
                        _G.Data[character] = data
                    end
                    local part = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso") or character:FindFirstChildOfClass("Part") or character:FindFirstChildOfClass("MeshPart")
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if part then
                        local distant = (cam_pos - part.Position).Magnitude
                        if distant <= variables.limit_distant then
                            local on_screen, opos = worldpoint_to_viewpoint(part.Position)
                            data.NameTag.Text = character.Name
                            if humanoid then
                                data.DistantTag.Text = string.format("[%.2f] [%.2f/%.2f] [%.2f%%]", distant, humanoid.Health, humanoid.MaxHealth, (humanoid.Health/humanoid.MaxHealth)*100)
                            else
                                data.DistantTag.Text = string.format("[%.2f] [null/null] [null%%]", distant)
                            end
                            data.NameTag.Position = opos
                            if on_screen then
                                on_screen = Mob_toggle:GetState()
                            end
                            data.NameTag.Visible = on_screen
                            data.NameTag.Size = variables.Text_Size
                            data.DistantTag.Size = data.NameTag.Size-1
                            data.NameTag.Color = variables.NameTagColor
                            data.DistantTag.Color = variables.DistantTagColor
                            data.DistantTag.Visible = data.NameTag.Visible
                            data.DistantTag.Position = data.NameTag.Position + Vector2.new(0,data.NameTag.TextBounds.Y)
                        end
                    end
                end
            end
        end)
        if not s and Error_log_toggle:GetState() then
            rconsoleinfo("Updator Error:"..tostring(err))
        end
    end)
    RunService:BindToRenderStep("List Update",Enum.RenderPriority.Character.Value-1,function()
        local s,err = pcall(function()
            for character, list_drawing in pairs(_G.Data) do
                if character.Parent == nil then
                    local s1,err1 = pcall(function()
                        list_drawing.DistantTag.Visible = false
                        list_drawing.DistantTag:Remove()
                    end)
                    local s2,err2 = pcall(function()
                        list_drawing.NameTag.Visible = false
                        list_drawing.NameTag:Remove()
                    end)
                    if not s1 and Error_log_toggle:GetState() then
                        rconsoleinfo("DistantTag Remove Error:"..tostring(err))
                    end
                    if not s2 and Error_log_toggle:GetState() then
                        rconsoleinfo("NameTag Remove Error:"..tostring(err))
                    end
                    if s1 or s2 then
                        _G.Data[character] = nil
                    end
                end
            end
        end)
        if not s and Error_log_toggle:GetState() then
            rconsoleinfo("Remover Error:"..tostring(err))
        end
    end)
    Toggle4:CreateKeybind(Keybinds.OpenUIKeyBind, function(Key)
        Keybinds.OpenUIKeyBind = Enum.KeyCode[Key].Name
    end)
    Toggle4:SetState(true)
else
    rconsoleinfo("WTF WRONG GAME BRO!!!!")
end
