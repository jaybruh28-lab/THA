local DiscordLib = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local HttpService = game:GetService("HttpService")
local pfp
local user
local tag
local userinfo = {}

pcall(function()
	userinfo = HttpService:JSONDecode(readfile("discordlibinfo.txt"));
end)

pfp = userinfo["pfp"] or "https://www.roblox.com/headshot-thumbnail/image?userId=".. game.Players.LocalPlayer.UserId .."&width=420&height=420&format=png"
user =  userinfo["user"] or game.Players.LocalPlayer.Name
tag = userinfo["tag"] or tostring(math.random(1000,9999))

local function SaveInfo()
	userinfo["pfp"] = pfp
	userinfo["user"] = user
	userinfo["tag"] = tag
	writefile("discordlibinfo.txt", HttpService:JSONEncode(userinfo));
end

local function MakeDraggable(topbarobject, object)
	local Dragging = nil
	local DragInput = nil
	local DragStart = nil
	local StartPosition = nil

	local function Update(input)
		local Delta = input.Position - DragStart
		local pos =
			UDim2.new(
				StartPosition.X.Scale,
				StartPosition.X.Offset + Delta.X,
				StartPosition.Y.Scale,
				StartPosition.Y.Offset + Delta.Y
			)
		object.Position = pos
	end

	topbarobject.InputBegan:Connect(
		function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				Dragging = true
				DragStart = input.Position
				StartPosition = object.Position

				input.Changed:Connect(
					function()
						if input.UserInputState == Enum.UserInputState.End then
							Dragging = false
						end
					end
				)
			end
		end
	)

	topbarobject.InputChanged:Connect(
		function(input)
			if
				input.UserInputType == Enum.UserInputType.MouseMovement or
					input.UserInputType == Enum.UserInputType.Touch
			then
				DragInput = input
			end
		end
	)

	UserInputService.InputChanged:Connect(
		function(input)
			if input == DragInput and Dragging then
				Update(input)
			end
		end
	)
end

local Discord = Instance.new("ScreenGui")
Discord.Name = "Discord"
Discord.Parent = game.CoreGui
Discord.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

function DiscordLib:Window(text)
	local currentservertoggled = ""
	local minimized = false
	local fs = false
	local settingsopened = false
	local MainFrame = Instance.new("Frame")
	local TopFrame = Instance.new("Frame")
	local Title = Instance.new("TextLabel")
	local CloseBtn = Instance.new("TextButton")
	local CloseIcon = Instance.new("ImageLabel")
	local MinimizeBtn = Instance.new("TextButton")
	local MinimizeIcon = Instance.new("ImageLabel")
	local ServersHolder = Instance.new("Folder")
	local Userpad = Instance.new("Frame")
	local UserIcon = Instance.new("Frame")
	local UserIconCorner = Instance.new("UICorner")
	local UserImage = Instance.new("ImageLabel")
	local UserCircleImage = Instance.new("ImageLabel")
	local UserName = Instance.new("TextLabel")
	local UserTag = Instance.new("TextLabel")
	local ServersHoldFrame = Instance.new("Frame")
	local ServersHold = Instance.new("ScrollingFrame")
	local ServersHoldLayout = Instance.new("UIListLayout")
	local ServersHoldPadding = Instance.new("UIPadding")
	local TopFrameHolder = Instance.new("Frame")

	MainFrame.Name = "MainFrame"
	MainFrame.Parent = Discord
	MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	MainFrame.BackgroundColor3 = Color3.fromRGB(32, 34, 37)
	MainFrame.BorderSizePixel = 0
	MainFrame.ClipsDescendants = true
	MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	MainFrame.Size = UDim2.new(0, 681, 0, 396)

	TopFrame.Name = "TopFrame"
	TopFrame.Parent = MainFrame
	TopFrame.BackgroundColor3 = Color3.fromRGB(32, 34, 37)
	TopFrame.BackgroundTransparency = 1.000
	TopFrame.BorderSizePixel = 0
	TopFrame.Position = UDim2.new(-0.000658480625, 0, 0, 0)
	TopFrame.Size = UDim2.new(0, 681, 0, 22)
	
	TopFrameHolder.Name = "TopFrameHolder"
	TopFrameHolder.Parent = TopFrame
	TopFrameHolder.BackgroundColor3 = Color3.fromRGB(32, 34, 37)
	TopFrameHolder.BackgroundTransparency = 1.000
	TopFrameHolder.BorderSizePixel = 0
	TopFrameHolder.Position = UDim2.new(-0.000658480625, 0, 0, 0)
	TopFrameHolder.Size = UDim2.new(0, 681, 0, 22)

	Title.Name = "Title"
	Title.Parent = TopFrame
	Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Title.BackgroundTransparency = 1.000
	Title.Position = UDim2.new(0.0102790017, 0, 0, 0)
	Title.Size = UDim2.new(0, 192, 0, 23)
	Title.Font = Enum.Font.Gotham
	Title.Text = text
	Title.TextColor3 = Color3.fromRGB(99, 102, 109)
	Title.TextSize = 13.000
	Title.TextXAlignment = Enum.TextXAlignment.Left

	CloseBtn.Name = "CloseBtn"
	CloseBtn.Parent = TopFrame
	CloseBtn.BackgroundColor3 = Color3.fromRGB(32, 34, 37)
	CloseBtn.BackgroundTransparency = 0
	CloseBtn.Position = UDim2.new(0.959063113, 0, -0.0169996787, 0)
	CloseBtn.Size = UDim2.new(0, 28, 0, 22)
	CloseBtn.Font = Enum.Font.Gotham
	CloseBtn.Text = ""
	CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	CloseBtn.TextSize = 14.000
	CloseBtn.BorderSizePixel = 0
	CloseBtn.AutoButtonColor = false

	CloseIcon.Name = "CloseIcon"
	CloseIcon.Parent = CloseBtn
	CloseIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	CloseIcon.BackgroundTransparency = 1.000
	CloseIcon.Position = UDim2.new(0.189182192, 0, 0.128935531, 0)
	CloseIcon.Size = UDim2.new(0, 17, 0, 17)
	CloseIcon.Image = "http://www.roblox.com/asset/?id=6035047409"
	CloseIcon.ImageColor3 = Color3.fromRGB(220, 221, 222)

	MinimizeBtn.Name = "MinimizeButton"
	MinimizeBtn.Parent = TopFrame
	MinimizeBtn.BackgroundColor3 = Color3.fromRGB(32, 34, 37)
	MinimizeBtn.BackgroundTransparency = 0
	MinimizeBtn.Position = UDim2.new(0.917947114, 0, -0.0169996787, 0)
	MinimizeBtn.Size = UDim2.new(0, 28, 0, 22)
	MinimizeBtn.Font = Enum.Font.Gotham
	MinimizeBtn.Text = ""
	MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	MinimizeBtn.TextSize = 14.000
	MinimizeBtn.BorderSizePixel = 0
	MinimizeBtn.AutoButtonColor = false

	MinimizeIcon.Name = "MinimizeLabel"
	MinimizeIcon.Parent = MinimizeBtn
	MinimizeIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	MinimizeIcon.BackgroundTransparency = 1.000
	MinimizeIcon.Position = UDim2.new(0.189182192, 0, 0.128935531, 0)
	MinimizeIcon.Size = UDim2.new(0, 17, 0, 17)
	MinimizeIcon.Image = "http://www.roblox.com/asset/?id=6035067836"
	MinimizeIcon.ImageColor3 = Color3.fromRGB(220, 221, 222)

	ServersHolder.Name = "ServersHolder"
	ServersHolder.Parent = TopFrameHolder

	Userpad.Name = "Userpad"
	Userpad.Parent = TopFrameHolder
	Userpad.BackgroundColor3 = Color3.fromRGB(41, 43, 47)
	Userpad.BorderSizePixel = 0
	Userpad.Position = UDim2.new(0.106243297, 0, 15.9807148, 0)
	Userpad.Size = UDim2.new(0, 179, 0, 43)

	UserIcon.Name = "UserIcon"
	UserIcon.Parent = Userpad
	UserIcon.BackgroundColor3 = Color3.fromRGB(31, 33, 36)
	UserIcon.BorderSizePixel = 0
	UserIcon.Position = UDim2.new(0.0340000018, 0, 0.123999998, 0)
	UserIcon.Size = UDim2.new(0, 32, 0, 32)

	UserIconCorner.CornerRadius = UDim.new(1, 8)
	UserIconCorner.Name = "UserIconCorner"
	UserIconCorner.Parent = UserIcon

	UserImage.Name = "UserImage"
	UserImage.Parent = UserIcon
	UserImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	UserImage.BackgroundTransparency = 1.000
	UserImage.Size = UDim2.new(0, 32, 0, 32)
	UserImage.Image = pfp 
	
	UserCircleImage.Name = "UserImage"
	UserCircleImage.Parent = UserImage
	UserCircleImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	UserCircleImage.BackgroundTransparency = 1.000
	UserCircleImage.Size = UDim2.new(0, 32, 0, 32)
	UserCircleImage.Image = "rbxassetid://4031889928"
	UserCircleImage.ImageColor3 = Color3.fromRGB(41, 43, 47)
	
	UserName.Name = "UserName"
	UserName.Parent = Userpad
	UserName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	UserName.BackgroundTransparency = 1.000
	UserName.BorderSizePixel = 0
	UserName.Position = UDim2.new(0.230000004, 0, 0.115999997, 0)
	UserName.Size = UDim2.new(0, 98, 0, 17)
	UserName.Font = Enum.Font.GothamSemibold
	UserName.TextColor3 = Color3.fromRGB(255, 255, 255)
	UserName.TextSize = 13.000
	UserName.TextXAlignment = Enum.TextXAlignment.Left
	UserName.ClipsDescendants = true

	UserTag.Name = "UserTag"
	UserTag.Parent = Userpad
	UserTag.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	UserTag.BackgroundTransparency = 1.000
	UserTag.BorderSizePixel = 0
	UserTag.Position = UDim2.new(0.230000004, 0, 0.455000013, 0)
	UserTag.Size = UDim2.new(0, 95, 0, 17)
	UserTag.Font = Enum.Font.Gotham
	UserTag.TextColor3 = Color3.fromRGB(255, 255, 255)
	UserTag.TextSize = 13.000
	UserTag.TextTransparency = 0.300
	UserTag.TextXAlignment = Enum.TextXAlignment.Left
	
	UserName.Text = user
	UserTag.Text = "#" .. tag

	ServersHoldFrame.Name = "ServersHoldFrame"
	ServersHoldFrame.Parent = MainFrame
	ServersHoldFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ServersHoldFrame.BackgroundTransparency = 1.000
	ServersHoldFrame.BorderColor3 = Color3.fromRGB(27, 42, 53)
	ServersHoldFrame.Size = UDim2.new(0, 71, 0, 396)

	ServersHold.Name = "ServersHold"
	ServersHold.Parent = ServersHoldFrame
	ServersHold.Active = true
	ServersHold.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ServersHold.BackgroundTransparency = 1.000
	ServersHold.BorderSizePixel = 0
	ServersHold.Position = UDim2.new(-0.000359333731, 0, 0.0580808073, 0)
	ServersHold.Size = UDim2.new(0, 71, 0, 373)
	ServersHold.ScrollBarThickness = 1
	ServersHold.ScrollBarImageTransparency = 1
	ServersHold.CanvasSize = UDim
