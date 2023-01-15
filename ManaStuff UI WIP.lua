local LibraryUI =(function ()
	--Cr. https://raw.githubusercontent.com/AlexR32/Roblox/main/BracketV3.lua
	local Library = {Toggle = true,FirstTab = nil,TabCount = 0,ColorTable = {}}

	local RunService = game:GetService("RunService")
	local HttpService = game:GetService("HttpService")
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
			Holder.Transparency = Transparency
		end
		function WindowInit:SetImageBackgroundTransparency(Transparency)
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

						UserInputService.InputBegan:Connect(function(Input, gameprocess)
							if Input.UserInputType == Enum.UserInputType.Keyboard then
								if WaitingForBind then
									local Key = tostring(Input.KeyCode):gsub("Enum.KeyCode.", "")
									if not table.find(Blacklist, Key) then
										Toggle.Keybind.Text = "[ " .. Key .. " ]"
										Selected = Key
									else
										Toggle.Keybind.Text = "[ NONE ]"
										Selected = "NONE"
									end
									WaitingForBind = false
								elseif not gameprocess then
									local Key = tostring(Input.KeyCode):gsub("Enum.KeyCode.", "")
									if Key == Selected then
										ToggleState = not ToggleState
										SetState(ToggleState)
										if Callback then
											Callback(Key)
										end
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

local Config = {
	WindowName = "RubyTheSilent Hub [Universal]",
	Color = Color3.fromRGB(255,128,64),
}

if game.PlaceId == 8619263259 then
	Config.WindowName = "RubyTheSilent Hub [Critical Legends]"
elseif game.PlaceId == 0 then
	Config.WindowName = "RubyTheSilent Hub [World Tower Defense]"
end

local Label_config = {
	ManaSoul = "Mana Soul",
	ManaRun = "Mana Run",
	ManaFly = "Mana Fly",
	Movement = "Movement",
	Player = "Player"
}
local variables = {
	manarunspeed = 2.75,
	manaflyspeed = 2.75,
	camspeed = 2.75,
	aladin_carpet_offset = 5,
}
local Keybinds = {
	OpenUIKeyBind = Enum.KeyCode.LeftAlt.Name,
	ManaSoul = Enum.KeyCode.P.Name,
	ManaFly = Enum.KeyCode.K.Name,
	ManaRun = Enum.KeyCode.N.Name
}
if isfile then
	if isfile("ManaStuff UI Labels.properties") then
		local content = readfile("ManaStuff UI Labels.properties")
		if content ~= "" then
			local lines = content:split("\n")
			for i=1,#lines do
				local index_and_value = lines[i]:split("=")
				Label_config[index_and_value[1]] = index_and_value[2]
			end
		end
	end
end
if isfile then
	if isfile("ManaStuff UI Variables.properties") then
		local content = readfile("ManaStuff UI Variables.properties")
		if content ~= "" then
			local lines = content:split("\n")
			for i=1,#lines do
				if lines[i] and lines[i] ~= "" then
					local index_and_typeandvalue = lines[i]:split("=")
					local typeandvalue = index_and_typeandvalue[2]:split(":")
					local tofuncs = {
						["string"] = tostring,
						["number"] = tonumber,
						["color"] = function(string_rgb)
							local r,g,b = unpack(string_rgb:split(","))
							return Color3.new(tonumber(r)/255,tonumber(g)/255,tonumber(b)/255)
						end
					}
					if tofuncs[typeandvalue[1]] then
						variables[index_and_typeandvalue[1]] = tofuncs[typeandvalue[1]](typeandvalue[2])
					end
				end
			end
		end
	end
end
if isfile then
	if isfile("ManaStuff UI Keybinds.properties") then
		local content = readfile("ManaStuff UI Keybinds.properties")
		if content ~= "" then
			local lines = content:split("\n")
			for i=1,#lines do
				local index_and_value = lines[i]:split("=")
				Keybinds[index_and_value[1]] = index_and_value[2]
			end
		end
	end
end

local Playerobj = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local vu = game:GetService("VirtualUser")

local cf_character_update = CFrame.new()
local currentcam_rotation_x, currentcam_rotation_y = 0, 0
local Part
local camfc
function create_aladin_carpet()
	Part = Instance.new("Part",workspace)
	Part.Name = "Floatly"
	Part.Position = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position-Vector3.new(0,game:GetService("Players").LocalPlayer.Character["Left Leg"].Size.Y+2,0)
	Part.Size = Vector3.new(10,0,10)
	Part.Anchored = true
end

--==================================[[AFHB]]==================================--
local Artificial_Event_Module = function()
    
    local ArtificialEV = {
        target_frame = 60,
        allow_frame_loss = false,
        toss_remaining = false,
        Event = game:GetService("RunService").Stepped,
        Internal_Events = {}
    }
    
    function ArtificialEV:Bind(Name,func)
       rawget(ArtificialEV,"Internal_Events")[Name] = func
    end

    function ArtificialEV:Unbind(Name)
       rawget(ArtificialEV,"Internal_Events")[Name] = nil
    end

    function ArtificialEV:Wait()
       local current_state = rawget(ArtificialEV, "Internal_Wait_FlipFlop")
       local wait_skip = 0
       local max_skip = 5

       while current_state == rawget(ArtificialEV, "Internal_Wait_FlipFlop") do
           if wait_skip > max_skip then
               wait_skip = 0
               wait()
           else
               wait_skip = wait_skip + 1
           end
       end

       return rawget(ArtificialEV,"Internal_Wait_Delta")
    end

    local tf = 0
    local lastframe = tick()
    local math_floor = math.floor
	local string_format = string.format

    local ArtificialEV_mt = {
        __index = function(t,index)
            if index:find("Internal") then
                return nil
            end
            return rawget(t, index)
        end,
        __newindex = function(t,index,value)
            if rawget(t,index) ~= nil and index:find("Internal") == nil and type(rawget(t,index)) ~= "function" and type(rawget(t,index)) == type(value) then
                rawset(t, index, value)
            end
        end
    }
    function FireAll(delta)
        coroutine.wrap(function()
            local name_and_funcs = rawget(ArtificialEV,"Internal_Events")
            rawset(ArtificialEV, "Internal_Wait_FlipFlop", not rawget(ArtificialEV, "Internal_Wait_FlipFlop"))
            rawset(ArtificialEV, "Internal_Wait_Delta", delta)
            for name, func in pairs(name_and_funcs) do
                local additional_delta = tick()
                local s, e = pcall(func,delta)
                delta = delta + (tick() - additional_delta)
                if not s then
                    local msg = string_format("[Artificial Event] Error in Function With binding Name '%s':\n%s",name ,e)
                    if printconsole then
                        printconsole(msg)
                    else
                        print(msg)
                    end
                end
            end
        end)()
    end
    coroutine.wrap(function()
        while true do
            local delta = tick()
            ArtificialEV.Event:Wait()
            delta = tick() - delta
            local current_target_frame = 1 / ArtificialEV.target_frame
            tf = tf + delta
            if tf >= current_target_frame then
                local delta = tick() - lastframe
                if ArtificialEV.allow_frame_loss then
                    FireAll(delta)
                    lastframe = tick()
                else
                    for _ = 1, math_floor(tf / current_target_frame) do
                        local delta = tick() - lastframe
                        FireAll(delta)
                        lastframe = tick()
                        tf = tf + delta
                    end
                    lastframe = tick()
                end
                if ArtificialEV.toss_remaining then
                    tf = 0
                else
                    tf = tf - current_target_frame * math_floor(tf / current_target_frame)
                end
            end
        end
    end)()
    return setmetatable(ArtificialEV,ArtificialEV_mt)
end
--==================================[[AFHB]]==================================--

function fill_decimal(string_decimal)
	local numbers = string_decimal:split(".")
	if #numbers == 2 then
		if numbers[2]:len() ~= 2 then
			if numbers[2]:len() > 2 then
				numbers[2] = numbers[2]:sub(1,2)
			else
				local newdecimal = ""
				while numbers[2]:len() < 2 do
					newdecimal = newdecimal .. numbers[2] .. "0"
				end
			end
		end
		return numbers[1] .. "." .. numbers[2]
	end
	return "00.00"
end

local Artificial = Artificial_Event_Module()

local watch = {}

function placeid_check(placeid)
    local places = {
        ["5735553160"] = "Deepwoken",
        ["6032399813"] = "Deepwoken",
        ["6473861193"] = "Deepwoken",
		["8668476218"] = "Deepwoken"
    }
    return places[tostring(placeid)]
end
local Window = LibraryUI:CreateWindow(Config, game:GetService("CoreGui"))
Window:Toggle(false)

local Tab1 = Window:CreateTab("Main")
local CEV = Window:CreateTab("Artificial Event Settings")
local ETVFO = Window:CreateTab("Execution Time View For Optimization")
local Tab2 = Window:CreateTab("UI Settings")

local ExecutionTimes = ETVFO:CreateSection("Execution Time")
local movement = Tab1:CreateSection(Label_config.Movement)
local player = Tab1:CreateSection(Label_config.Player)
local Event = CEV:CreateSection("Artificial Heartbeat")
local UI_1 = Tab2:CreateSection("Menu")
local UI_2 = Tab2:CreateSection("Background")
local etc_tab = Tab1:CreateSection("Etc...")
local cuesp = etc_tab:CreateButton("UnNamedESP With Custom Patch",function()
	loadstring(game:HttpGet('https://github.com/plytalent/Roblox-Hacks/raw/main/Unnamed%20ESP%20Patcher.lua'))()
end)

local ManaRun = movement:CreateToggle(Label_config.ManaRun, false, function()
	if Playerobj.Character then
		cf_character_update = Playerobj.Character:GetPrimaryPartCFrame()
	end
end)
local ManaFly = movement:CreateToggle(Label_config.ManaFly, false, function()
	if Playerobj.Character then
		cf_character_update = Playerobj.Character:GetPrimaryPartCFrame()
	end
end)
local ManaSoul = player:CreateToggle(Label_config.ManaSoul, false, function()end)
local Anti_AFK = player:CreateToggle("Anti-AFK", true, function()end)
Playerobj.Idled:Connect(function()
	if Anti_AFK:GetState() then
    	vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
		printconsole("Mouse Hold Down!")
		local starttick = tick()
		local current_tick = 0
    	while current_tick >= 1 do
			current_tick = tick() - starttick
			Artificial:Wait()
		end
    	vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
		printconsole("Mouse Released!")
	end
end)
local aladin_carpet, observe
if placeid_check(game.PlaceId) ~= "Deepwoken" then
	observe = player:CreateToggle("Observe", false, function(State)
		camfc = workspace.CurrentCamera.CFrame
		currentcam_rotation_x, currentcam_rotation_y = 0, 0
		local PlayerModule = require(Playerobj.PlayerScripts:WaitForChild("PlayerModule"))
		local Controls = PlayerModule:GetControls()
		if not State then
			Controls:Enable()
		else
			Controls:Disable()
		end
	end)
	aladin_carpet = player:CreateToggle("Aladin Carpet", false, function()end)
end

ManaSoul:CreateKeybind(Keybinds.ManaSoul, function(Key)
	Keybinds.ManaSoul = Enum.KeyCode[Key].Name
end)
ManaFly:CreateKeybind(Keybinds.ManaFly, function(Key)
	Keybinds.ManaFly = Enum.KeyCode[Key].Name
end)
ManaRun:CreateKeybind(Keybinds.ManaRun, function(Key)
	Keybinds.ManaRun = Enum.KeyCode[Key].Name
end)

local Toggle4 = UI_1:CreateToggle("UI Toggle", nil, function(State)
	Window:Toggle(State)
end)

local Toggle7 = UI_1:CreateToggle("TASTE THE RAINBOW", nil, function(State)
	if State then
		Window:ChangeColor(Config.Color)
	end
end)
Toggle4:CreateKeybind(Keybinds.OpenUIKeyBind, function(Key)
	Keybinds.OpenUIKeyBind = Enum.KeyCode[Key].Name
end)
local Slider1 = movement:CreateSlider(Label_config.ManaRun.." Multiplier", 0, 300, variables.manarunspeed*100, true, function(x)
	variables.manarunspeed = (x/100)
	if x == 0 then
		variables.manarunspeed = 0
	end
end)
local Slider2 = movement:CreateSlider(Label_config.ManaFly.." Multiplier", 0, 300, variables.manaflyspeed*100, true, function(x)
	variables.manaflyspeed = (x/100)
	if x == 0 then
		variables.manaflyspeed = 0
	end
end)
if observe then
	local Slider3 = player:CreateSlider("Observe Speed Multiplier", 0, 300, variables.camspeed*100, true, function(x)
		variables.camspeed = (x/100)
		if x == 0 then
			variables.camspeed = 0
		end
	end)
end
if aladin_carpet then
	local Slider4 = player:CreateSlider("Aladin Carpet Offset", -10, 10, variables.aladin_carpet_offset, true, function(x)
		variables.aladin_carpet_offset = x
	end)
end
local Colorpicker3 = UI_1:CreateColorpicker("UI Color", function(Color)
	Config.Color = Color
	Window:ChangeColor(Color)
end)
-- credits to jan for patterns
local Dropdown3 = UI_2:CreateDropdown("Image", {"Default","Hearts","Abstract","Hexagon","Circles","Lace With Flowers","Floral"}, function(Name)
	if Name == "Default" then
		Window:SetBackground("2151741365")
	elseif Name == "Hearts" then
		Window:SetBackground("6073763717")
	elseif Name == "Abstract" then
		Window:SetBackground("6073743871")
	elseif Name == "Hexagon" then
		Window:SetBackground("6073628839")
	elseif Name == "Circles" then
		Window:SetBackground("6071579801")
	elseif Name == "Lace With Flowers" then
		Window:SetBackground("6071575925")
	elseif Name == "Floral" then
		Window:SetBackground("5553946656")
	end
end)
local Warning = Event:CreateLabel("WARN: DO NOT ENABLE Toss Remainder")
local Label1 = Event:CreateLabel("Current Event Frame")
local Label2 = Event:CreateLabel("Current Event Frame Time: -NaN(%ind) ms")
local Slider5 = Event:CreateSlider("Event Target Frame Time",1,60,60,true, function(Value)
	Artificial.target_frame = Value
	local stringtime = fill_decimal(string.format("%.2f",((1/Artificial.target_frame)*1000)))
	Label2:UpdateText(string.format("Current Target Event Frame Time: %s ms",stringtime))
end)
local Options_Events = Event:CreateDropdown("Event", {"Stepped","RenderStepped","Heartbeat"}, function(Name)
	Artificial.Event = game:GetService("RunService")[Name]
end,"Stepped")
local Toggle5 = Event:CreateToggle("Allow Frame Lost", false, function(State)
	Artificial.allow_frame_loss = State
end)
local Toggle6 = Event:CreateToggle("Toss Remaind Frame Time", false, function(State)
	Artificial.toss_remaining = State
end)
local Colorpicker4 = UI_2:CreateColorpicker("Color", function(Color)
	Window:SetBackgroundColor(Color)
end)
local Slider5 = UI_2:CreateSlider("Image Transparency",0,1,0,false, function(Value)
	Window:SetImageBackgroundTransparency(Value)
end)
local Slider6 = UI_2:CreateSlider("Transparency",0,0.99,0,false, function(Value)
	Window:SetBackgroundTransparency(Value)
end)
local Slider7 = UI_2:CreateSlider("Tile Scale",0,1,1,false, function(Value)
	Window:SetTileScale(Value)
end)
function save_to_files()
	if writefile then
		local new_file_content = ""
		local new_keybind_file_content = ""
		for index, value in pairs(variables) do
			new_file_content = string.format("%s\n%s=%s:%s",new_file_content,index,typeof(value),tostring(value))
		end
		for index, value in pairs(Keybinds) do
			new_keybind_file_content = string.format("%s\n%s=%s",new_keybind_file_content,index,tostring(value))
		end
		writefile("ManaStuff UI Variables.properties",new_file_content)
		writefile("ManaStuff UI Keybinds.properties",new_keybind_file_content)
	end
end
local SaveButton = UI_2:CreateButton("Save Variables And Keybinds Value", save_to_files)
local last_auto_save = tick()
RunService.Stepped:Connect(function()
	local start = tick()
	if start - last_auto_save > 5 then
		save_to_files()
	end
	watch["AutoSave"] = tick() - start
end)
RunService.Stepped:Connect(function()
	local start = tick()
	if ManaSoul:GetState() then
		local Character = Playerobj.Character
        if Character then
		    for _,v in pairs(Character:GetDescendants())do
		    	if v:IsA("BasePart") then
		    		v.CanCollide =  false
		    	end
		    end
        end
	end
	watch["ManaSoul"] = tick() - start
end)

RunService:BindToRenderStep("Update Camera",Enum.RenderPriority.Camera.Value+1,function()
	if observe then
		local start = tick()
		if observe:GetState() then
			local leftorright,upordown,backorforward = 0,0,0
			if UIS:IsKeyDown(Enum.KeyCode.S) then
				backorforward = backorforward + variables.camspeed
			end
			if UIS:IsKeyDown(Enum.KeyCode.W) then
				backorforward = backorforward - variables.camspeed
			end
			if UIS:IsKeyDown(Enum.KeyCode.D) then
				leftorright = leftorright + variables.camspeed
			end
			if UIS:IsKeyDown(Enum.KeyCode.A) then
				leftorright = leftorright - variables.camspeed
			end
			if UIS:IsKeyDown(Enum.KeyCode.Q) then
				upordown = upordown + variables.camspeed
			end
			if UIS:IsKeyDown(Enum.KeyCode.E) then
				upordown = upordown - variables.camspeed
			end
			if UIS:IsKeyDown(Enum.KeyCode.R) then
				currentcam_rotation_x = currentcam_rotation_x + variables.camspeed
			end
			if UIS:IsKeyDown(Enum.KeyCode.T) then
				currentcam_rotation_x = currentcam_rotation_x - variables.camspeed
			end
			if UIS:IsKeyDown(Enum.KeyCode.F) then
				currentcam_rotation_y = currentcam_rotation_y + variables.camspeed
			end
			if UIS:IsKeyDown(Enum.KeyCode.G) then
				currentcam_rotation_y = currentcam_rotation_y - variables.camspeed
			end
			camfc = CFrame.new(camfc * CFrame.new(leftorright,upordown,backorforward).Position) * CFrame.Angles(0,math.rad(currentcam_rotation_y),0) * CFrame.Angles(math.rad(currentcam_rotation_x),0,0)
			workspace.CurrentCamera.CFrame = camfc
		end
		watch["Observe"] = tick() - start
	end
end)

RunService:BindToRenderStep("Update UI",1,function()
	local start = tick()
	if Toggle7:GetState() then
		Window:ChangeColor(Color3.fromHSV(tick() * 128 % 255/255, 1, 0.75))
		Window:SetBackgroundColor(Color3.fromHSV(tick() * 128 % 255/255, 1, 0.5))
	elseif not Toggle7:GetState() then
		Window:ChangeColor(Config.Color)
	end
	watch["UI Update"] = tick() - start
end)
Artificial:Bind("Fly",function(d)
	local start_overall = tick()
	Label1:UpdateText(string.format("Frame:%s",fill_decimal(string.format("%.2f",1/d))))
	local Character = Playerobj.Character
	if game.PlaceId == 4691401390 then
		if workspace:FindFirstChild'Players' then
			Character = workspace.Players:FindFirstChild(Playerobj.Name);
		end
	end
	local start = tick()
	if ManaFly:GetState() then
        if Character ~= nil then
			if Character:FindFirstChild("HumanoidRootPart") then
				local leftorright,backorforward = 0,0
				if UIS:IsKeyDown(Enum.KeyCode.S) then
					backorforward = backorforward + variables.manaflyspeed
				end
				if UIS:IsKeyDown(Enum.KeyCode.W) then
					backorforward = backorforward - variables.manaflyspeed
				end
				if UIS:IsKeyDown(Enum.KeyCode.D) then
					leftorright = leftorright + variables.manaflyspeed
				end
				if UIS:IsKeyDown(Enum.KeyCode.A) then
					leftorright = leftorright - variables.manaflyspeed
				end
				if Character.PrimaryPart then
					local rz, rx, ry = workspace.CurrentCamera.CFrame:ToOrientation()
					targetCF = (CFrame.new(cf_character_update.Position)*CFrame.Angles(0,rx,0))*CFrame.Angles(rz,0,0)
            		cf_character_update = (targetCF*CFrame.new(leftorright,0,backorforward))
					local rz_ch, rx_ch, ry_ch = Character:GetPrimaryPartCFrame():ToOrientation() --Z X Y ToOrientation
					Character:SetPrimaryPartCFrame(CFrame.new(cf_character_update.Position) * CFrame.Angles(rz_ch, rx_ch, ry_ch))
					Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
				end
			end
		end
	end
	watch["ManaFly"] = tick() - start
	local start2 = tick()
	if ManaRun:GetState() then
		if Character ~= nil then
			local leftorright,backorforward = 0,0
        	if UIS:IsKeyDown(Enum.KeyCode.S) then
        	    backorforward = backorforward + variables.manarunspeed
        	end
        	if UIS:IsKeyDown(Enum.KeyCode.W) then
        	    backorforward = backorforward - variables.manarunspeed
        	end
        	if UIS:IsKeyDown(Enum.KeyCode.D) then
        	    leftorright = leftorright + variables.manarunspeed
        	end
        	if UIS:IsKeyDown(Enum.KeyCode.A) then
        	    leftorright = leftorright - variables.manarunspeed
        	end
			local targetCF = workspace.CurrentCamera.CFrame
			local _, rx, _ = targetCF:ToOrientation() --Z X Y
			if Character.PrimaryPart then
				if aladin_carpet then
					if aladin_carpet:GetState()then
						Part.CFrame = (CFrame.new(Character:GetPrimaryPartCFrame().Position)*CFrame.Angles(0,rx,0)) * CFrame.new(leftorright,0,backorforward)
					end
				end
				local rz_ch, rx_ch, ry_ch = Character:GetPrimaryPartCFrame():ToOrientation() --Z X Y ToOrientation
				Character:SetPrimaryPartCFrame(CFrame.new(((CFrame.new(Character:GetPrimaryPartCFrame().Position)*CFrame.Angles(0,rx,0)) * CFrame.new(leftorright,0,backorforward)).Position) * CFrame.Angles(rz_ch, rx_ch, ry_ch))
			end
		end
	end
	watch["ManaRun"] = tick() - start2
	if aladin_carpet then
		local start3 = tick()
		if aladin_carpet:GetState() then
			if not Part then
				create_aladin_carpet()
			end
			if not Part.Parent then
				create_aladin_carpet()
			end
			Part.Name = "Floatly"
			Part.CFrame = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame*CFrame.new(0,-variables.aladin_carpet_offset,0)
			Part.Size = Vector3.new(10,0,10)
			Part.Anchored = true
		end
		watch["aladin_carpet"] = tick() - start
	end
	watch["Overall Mana"] = tick() - start_overall
end)

function tablefind(tb,value)
	for _,v in pairs(tb) do
		if v == value then
			return true
		end
	end
	return false
end

function console_error(...)
	local args = {...}
	for i=1, #args do
		args[i] = tostring(args[i])
	end
	local printer = printconsole and printconsole or rconsoleerror and rconsoleerror or print
	printer(table.concat(args, " "))
end

function loadmodules(id)
	if id == 8619263259 then
		if firetouchinterest then
			local target = nil
			local targets = {}
			if not variables.safe_offset_cf_x then
				variables.safe_offset_cf_x = 0
			end
			if not variables.safe_offset_cf_y then
				variables.safe_offset_cf_y = 85
			end
			if not variables.safe_offset_cf_z then
				variables.safe_offset_cf_z = 0
			end
			for _,zone in pairs(workspace.Enemies:GetChildren()) do
				for _, enemy in pairs(zone:GetChildren()) do
					if enemy:IsA("Model") and enemy:FindFirstChild("Model") then
						if not tablefind(targets,enemy.Model.Value.Name) then
							targets[#targets+1] = enemy.Model.Value.Name
						end
					end
				end
			end
			table.sort(targets)
			local Critical_Legends_Tab = Window:CreateTab("Critical Legends")
			local AutoFarmSection = Critical_Legends_Tab:CreateSection("Auto Farm")
			local TargetHealth = AutoFarmSection:CreateLabel("Target Health: 0/0")
			local Slider6 = AutoFarmSection:CreateSlider("OffsetX", -150, 150, variables.safe_offset_cf_x, false, function(Value)
				variables.safe_offset_cf_x = Value
			end)
			local Slider7 = AutoFarmSection:CreateSlider("OffsetY", -150, 150, variables.safe_offset_cf_y, false, function(Value)
				variables.safe_offset_cf_y = Value
			end)
			local Slider8 = AutoFarmSection:CreateSlider("OffsetZ", -150, 150, variables.safe_offset_cf_z, false, function(Value)
				variables.safe_offset_cf_z = Value
			end)
			local AutoFarm_Toggle = AutoFarmSection:CreateToggle("AutoFarm", false,function()end)
			local AutoOrb_Toggle = AutoFarmSection:CreateToggle("AutoOrb", false,function()end)
			local Dropdown = AutoFarmSection:CreateDropdown("Targets", targets, function(Name)
				for _, model in pairs(workspace.Enemies:GetDescendants()) do
					if model:IsA("ObjectValue") then
						if model.Value.Name == Name then
							target = model.Parent
						end
					end
				end
			end)
			Artificial:Bind("AutoOrb",function()
				if AutoOrb_Toggle:GetState() or AutoFarm_Toggle:GetState() then
					if workspace:FindFirstChild("CombatFolder") then
						if workspace.CombatFolder:FindFirstChild(Playerobj.Name) then
							if Playerobj.Character:FindFirstChild("Combat Border") then
								Playerobj.Character["Combat Border"]:Destroy()
							end
							local models = workspace.CombatFolder[Playerobj.Name]:GetChildren()
							if #models > 0 then
								for i=1, 128 do
									coroutine.resume(coroutine.create(function()
										local index = i
										local s,err = pcall(function()
											if models[index] then
												if models[index]:FindFirstChild("Base") then
													local part = models[index].Base
													firetouchinterest(part,Playerobj.Character.HumanoidRootPart,1)
													firetouchinterest(part,Playerobj.Character.HumanoidRootPart,0)
												end
											end
										end)
										if not s then
											console_error(err)
										end
									end))
								end
							end
						end
					end
				end
				if AutoFarm_Toggle:GetState() then
					if target then
						local CBF = workspace:FindFirstChild("CombatFolder")
						if CBF then
							if CBF:FindFirstChild("Owner") then
								if CBF.Owner.Value then
									if CBF.Owner.Value:FindFirstChild("Health") then
										TargetHealth:UpdateText(string.format("Target Health: %.2f/%.2f", CBF.Owner.Value.Health.Value, CBF.Owner.Value.MaxHealth.Value))
									end
								end
							else
								TargetHealth:UpdateText(string.format("Target Health: 0/0"))
							end
							if CBF:FindFirstChild(Playerobj.Name) then
								Playerobj.Character.HumanoidRootPart.CFrame = target.EnemyLocation.CFrame * CFrame.new(variables.safe_offset_cf_x, variables.safe_offset_cf_y, variables.safe_offset_cf_z)
								Playerobj.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
								Playerobj.Character.HumanoidRootPart.Anchored = false
							else
								Playerobj.Character.HumanoidRootPart.CFrame = target.EnemyLocation.CFrame * CFrame.new(0,10,0)
								Playerobj.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
								Playerobj.Character.HumanoidRootPart.Anchored = false
							end
						else
							Playerobj.Character.HumanoidRootPart.CFrame = target.EnemyLocation.CFrame * CFrame.new(0,10,0)
							Playerobj.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
							Playerobj.Character.HumanoidRootPart.Anchored = false
						end
					end
				end
			end)
		end
	elseif placeid_check(id) == "Deepwoken" and Drawing then
		local s, e = pcall(function()
			local Deepwoken_Tab = Window:CreateTab("Deepwoken")
	
			if _G.Mob_Data == nil then
				_G.Mob_Data = {}
			end
	
			local string_format = string.format
			local newv2 = Vector2.new
			local FindFirstChildOfClass_f = game.FindFirstChildOfClass
			local live_fd = workspace.Live
			local FindFirstChild_func = game.FindFirstChild
			local camera = workspace.CurrentCamera
			local wtvp = camera.WorldToViewportPoint
	
			local NewDraw = Drawing.new

			local base_zindex = -1000
			local lock_create_label = {}
			local last_clear = tick()
			
			function m1()
				mouse1press()
				Artificial:Wait()
				mouse1release()
			end
			
			local startpos = player.Character.HumanoidRootPart.Position
			local lastpress = tick()
			local pressed = false
	
			getgenv = getgenv and getgenv or function() if not _G.Mob_Data.getgenv then _G.Mob_Data.getgenv = {} end return _G.Mob_Data.getgenv end
			function synTextLabel()
				local TextLabel = NewDraw("Text")
				if not getgenv().Syn_Drawing then
					getgenv().Syn_Drawing = {}
				end
				getgenv().Syn_Drawing[#getgenv().Syn_Drawing+1] = TextLabel
				TextLabel.Text = "Place"
				TextLabel.Size = 24
				TextLabel.ZIndex = 1
				TextLabel.Center = true
				TextLabel.Outline = true
				TextLabel.Color = Color3.new(255/255, 0/255, 0/255)
				TextLabel.OutlineColor = Color3.new(0, 0, 0)
				return TextLabel
			end
	
			
			function worldpoint_to_viewpoint(pos)
				local pos, in_fov = wtvp(camera,pos)
				return in_fov, Vector2.new(pos.X,pos.Y), pos.Z
			end
	
			local Mob_Section = Deepwoken_Tab:CreateSection("Mob ESP")
			local Auto_Section = Deepwoken_Tab:CreateSection("Automation")
			local NoFall_Section = Deepwoken_Tab:CreateSection("No Fall")
			if typeof(hookmetamethod) == "function" and typeof(newcclosure) == "function" and typeof(checkcaller) == "function" then
				local NoFall_Toggle = NoFall_Section:CreateToggle("Toggle", true, function()end)
				local original
				original = hookmetamethod(game, "__namecall", newcclosure(function(remote, ...)
					if typeof(remote) == "Instance" and not checkcaller() then
						local args = { ... }
						local methodName = getnamecallmethod()
						local validInstance, remoteName = pcall(function()
							return remote.Name
						end)
						if NoFall_Toggle:GetState() then
							if validInstance and (methodName == "FireServer" or methodName == "fireServer") and #args == 2 and typeof(args[1]) == "number" and typeof(args[2]) == "boolean" then
								return original(remote, math.random(0,5), false)
							end
						end
					end
					return original(remote, ...)
				end))
			else
				local functions_check ={
					['hookmetamethod'] = hookmetamethod,
					['newcclosure']    = newcclosure,
					['checkcaller']    = checkcaller
				}
				local missingfunctions = {}
				for funcname, func in pairs(functions_check) do
					if typeof(func) ~= "function" then
						missingfunctions[#missingfunctions+1] = funcname
					end
				end
				local Label_Not_Support = NoFall_Section:CreateLabel("Not Support[missing '" .. table.concat(missingfunctions,"' and '") .. "']")
			end
			variables.Mob_NameTagColor = variables.Mob_NameTagColor or Color3.new(1,0,0)
			variables.Mob_DistantTagColor = variables.Mob_DistantTagColor or Color3.new(1,1,1)
			variables.limit_distant = variables.limit_distant or 6000
			variables.Text_Size = variables.Text_Size or 18
			
			local Mob_toggle = Mob_Section:CreateToggle("Toggle Mob ESP", false, function()end)
			
			local AutoFish_toggle = Auto_Section:CreateToggle("Toggle Fishing", false, function()
				startpos = player.Character.HumanoidRootPart.Position
			end)

			Mob_toggle:CreateKeybind(Keybinds.Mob_Toggle_ESP or "F5", function(Key)
				Keybinds.Mob_Toggle_ESP = Enum.KeyCode[Key].Name
			end)

			local Mob_ColorPick1 = Mob_Section:CreateColorpicker("NameTag Color", function(Color)
				variables.Mob_NameTagColor = Color
			end)
			local Mob_ColorPick2 = Mob_Section:CreateColorpicker("DistantTag Color", function(Color)
				variables.Mob_DistantTagColor = Color
			end)
			local Mob_Distant_Slider = Mob_Section:CreateSlider("Distant", 0, 25000, variables.limit_distant, true, function(x)
				variables.limit_distant = x
			end)
			local Mob_SizeText_Slider = Mob_Section:CreateSlider("Text Size", 10, 24, variables.Text_Size, true, function(x)
				variables.Text_Size = x
			end)

			Artificial:Bind("Auto-Fishing",function()
				local start = tick()
				if iswindowactive() and AutoFish_toggle:GetState() then
					local character = player.Character
					if character then
						local hrp = character:FindFirstChild("HumanoidRootPart")
						local t = character:FindFirstChild("Torso")
						if hrp and t then
							local hrpcf = hrp.CFrame
							local tcf = t.CFrame
							local zhrp, xhrp, yhrp = hrpcf:ToOrientation()
							local zt, xt, yt = tcf:ToOrientation()
							local dir = Vector3.new(math.floor(math.deg(xhrp-xt)),math.floor(math.deg(yhrp-yt)),math.floor(math.deg(zhrp-zt)))
							if dir.x == 0 and dir.z <= -15 then
								lastpress = tick()
								pressed = false
								keypress(0x53)   -- s
								keyrelease(0x41) -- a
								keyrelease(0x44) -- d
								m1()
							--elseif (dir.x <= -25 and dir.x > -330) and dir.z <= -15 then --elseif dir.x >= 25 and dir.z <= -15 then
							elseif ((dir.x <= -25 and dir.x <= -320) or (dir.x >= 25 and dir.x <= 320)) and dir.z <= -15 then
								lastpress = tick()
								pressed = false
								keyrelease(0x53)
								keypress(0x41)
								keyrelease(0x44)
								m1()
							--elseif dir.x <= -330 and dir.z <= -15 then --elseif dir.x >= 330 and dir.z <= -15 then
							elseif ((dir.x <= -25 and dir.x > -320) or (dir.x > 25 and dir.x >= 320)) and dir.z <= -15 then
								lastpress = tick()
								pressed = false
								keyrelease(0x53)
								keyrelease(0x41)
								keypress(0x44)
								m1()
							elseif dir.x == -1 and dir.y == -1 and (dir.z > -65 and dir.z < -55) then
								keyrelease(0x53)
								keyrelease(0x41)
								keyrelease(0x44)
								m1()
							end
							if tick() - lastpress >= 0.1 and not pressed then
								pressed = true
								keyrelease(0x53)
								keyrelease(0x41)
								keyrelease(0x44)
								character.Humanoid:MoveTo(startpos)
								m1()
							end
						end
					end
				end
				watch["DeepWoken[AutoFishing]"] = tick() - start
			end)

			RunService:BindToRenderStep("ESP(Mob) Update",Enum.RenderPriority.Character.Value+1,function()
				local start_overall = tick()
				local already_updated = {}
				local distant_limit = variables.limit_distant
				local nametag_size = variables.Text_Size
				local distanttag_size = nametag_size-1
				local ntc = variables.Mob_NameTagColor
				local dtc = variables.Mob_DistantTagColor
				local state = Mob_toggle:GetState()
				local cam_pos = camera.CFrame.Position
				local current_data = _G.Mob_Data
				if state then
					local s,err = pcall(function()
						local live_child = live_fd:GetChildren()
						for character, data in pairs(current_data) do
							already_updated[character] = true
							if data ~= nil then
								local part = FindFirstChild_func(character, "HumanoidRootPart") or FindFirstChild_func(character, "Torso") or FindFirstChildOfClass_f(character, "Part") or FindFirstChildOfClass_f(character, "MeshPart")
								local humanoid = FindFirstChildOfClass_f(character, "Humanoid")
								local Name_tag = data.NameTag
								local Distant_tag = data.DistantTag
								if part then
									local distant = (cam_pos - part.Position).Magnitude
									local on_screen, opos, ZIndex = worldpoint_to_viewpoint(part.Position)
									Name_tag.Text = character.Name
									if humanoid then
										Distant_tag.Text = string_format("[%.2f] [%.2f/%.2f] [%.2f%%]", distant, humanoid.Health, humanoid.MaxHealth, (humanoid.Health/humanoid.MaxHealth)*100)
									else
										Distant_tag.Text = string_format("[%.2f] [null/null] [null%%]", distant)
									end
									on_screen = on_screen and distant <= distant_limit
								
									Name_tag.Position = opos
									Name_tag.Visible = on_screen and state
									Name_tag.Size = nametag_size
									Name_tag.Color = ntc
								
									Distant_tag.Size = distanttag_size
									Distant_tag.Color = dtc
									Distant_tag.Visible =  on_screen and state
									Distant_tag.Position = opos + newv2(0,data.NameTag.TextBounds.Y)
									Name_tag.ZIndex = base_zindex + ZIndex
								else
									Name_tag.Visible = false
									Distant_tag.Visible = false
								end
							end
						end
						for index = 1, #live_child do
							local character = live_child[index]
							if character then
								if character.Name:split("")[1] == "." and already_updated[character] == nil and not lock_create_label[character] and not _G.Mob_Data[character] then
									lock_create_label[character] = true
									local data = {
										NameTag = synTextLabel(),
										DistantTag = synTextLabel()
									}
									_G.Mob_Data[character] = data
									lock_create_label[character] = false
									local part = FindFirstChild_func(character, "HumanoidRootPart") or FindFirstChild_func(character, "Torso") or FindFirstChildOfClass_f(character, "Part") or FindFirstChildOfClass_f(character, "MeshPart")
									local humanoid = FindFirstChildOfClass_f(character, "Humanoid")
									if part then
										local Name_tag = data.NameTag
										local Distant_tag = data.DistantTag
										local distant = (cam_pos - part.Position).Magnitude
										local on_screen, opos, ZIndex = worldpoint_to_viewpoint(part.Position)
										data.NameTag.Text = character.Name
										if humanoid then
											data.DistantTag.Text = string_format("[%.2f] [%.2f/%.2f] [%.2f%%]", distant, humanoid.Health, humanoid.MaxHealth, (humanoid.Health/humanoid.MaxHealth)*100)
										else
											data.DistantTag.Text = string_format("[%.2f] [null/null] [null%%]", distant)
										end
										on_screen = on_screen and distant <= distant_limit
									
										Name_tag.Position = opos
										Name_tag.Visible = on_screen and state
										Name_tag.Size = nametag_size
									
										Name_tag.Color = ntc
										Distant_tag.Size = distanttag_size
										Distant_tag.Color = dtc
										Distant_tag.Visible = on_screen and state
										Distant_tag.Position = opos + newv2(0,data.NameTag.TextBounds.Y)
										Name_tag.ZIndex = base_zindex + ZIndex
									end
								end
							end
						end
					end)
					if not s then
						console_error("Mob Updator Error:"..tostring(err))
					end
				elseif start_overall - last_clear > 1 then
					for character, data in pairs(current_data) do
						if data ~= nil then
							local Name_tag = data.NameTag
							local Distant_tag = data.DistantTag
							if Name_tag then
								Name_tag.Visible = false
							end
							if Distant_tag then
								Distant_tag.Visible =  false
							end
						end
					end
					last_clear = tick()
				end
				watch["DeepWoken[Esp Tag Update]"] = tick() - start_overall
			end)
			RunService:BindToRenderStep("List Update",Enum.RenderPriority.Character.Value-1,function()
				local start_overall = tick()
				local s,err = pcall(function()
					for character, list_drawing in pairs(_G.Mob_Data) do
						if character.Parent == nil then
							local s1,err1 = pcall(function()
								list_drawing.DistantTag.Visible = false
								list_drawing.DistantTag:Remove()
							end)
							local s2,err2 = pcall(function()
								list_drawing.NameTag.Visible = false
								list_drawing.NameTag:Remove()
							end)
							if s1 or s2 then
								_G.Mob_Data[character] = nil
							end
							if not s1 then
								console_error("DistantTag Mob Remove Error:"..tostring(err1))
							end
							if not s2 then
								console_error("NameTag Mob Remove Error:"..tostring(err2))
							end
						end
					end
				end)
				if not s then
					console_error("Remover Error:"..tostring(err))
				end
				watch["DeepWoken[List Update]"] = tick() - start_overall
			end)
		end)
		if not s then
			console_error("Deepwoken Module Error:"..tostring(e))
		end
	end
end
loadmodules(game.PlaceId)
local watcher_labels = {["Watcher"]=ExecutionTimes:CreateLabel("%s: %.2f")}
Artificial:Bind("Watcher",function()
	local start_overall = tick()
	for watchname, executiontime in pairs(watch) do
		local label = watcher_labels[watchname]
		if label == nil then
			label = ExecutionTimes:CreateLabel(string.format("%s: %.2f",watchname,executiontime*1000))
			watcher_labels[watchname] = label
		else
			label:UpdateText(string.format("%s: %.2f",watchname,executiontime*1000))
		end
	end
	watch["Watcher"] = tick() - start_overall
end)
Colorpicker3:UpdateColor(Config.Color)
Dropdown3:SetOption("Abstract")
Colorpicker4:UpdateColor(Color3.new(1,1,1))
Artificial:Wait()
Toggle4:SetState(true)
