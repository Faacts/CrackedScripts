if not game:IsLoaded() then
	game.Loaded:Wait()
end

local VirtualInputManager = game:GetService("VirtualInputManager")
local Player = game:GetService("Players").LocalPlayer or game:GetService("Players").PlayerAdded:Wait()
local HttpService = game:GetService("HttpService")

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/Faacts/UILibraries/main/RayfieldKey'))()

task.spawn(function()
	pcall(function()
		repeat task.wait() until game:GetService("CoreGui"):FindFirstChild("Rayfield"):FindFirstChild("Main")

		game:GetService("CoreGui"):FindFirstChild("Rayfield"):FindFirstChild("Main").Visible = false
	end)
end)

local function Click(v)
	VirtualInputManager:SendMouseButtonEvent(v.AbsolutePosition.X+v.AbsoluteSize.X/2,v.AbsolutePosition.Y+50,0,true,v,1)
	VirtualInputManager:SendMouseButtonEvent(v.AbsolutePosition.X+v.AbsoluteSize.X/2,v.AbsolutePosition.Y+50,0,false,v,1)
end

local function comma(amount)
	local formatted = amount
	local k
	while true do  
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		if (k==0) then
			break
		end
	end
	return formatted
end

local function Notify(Message, Duration)
	Rayfield:Notify({
		Title = "🔥 Inferno X",
		Content = Message,
		Duration = Duration or 5,
		Image = 4483362458,
		Actions = {},
	})
end

local function CreateWindow()
		setclipboard(game:HttpGet('https://raw.githubusercontent.com/Faacts/FactsHub/main/Side/CopyDiscordInvite.lua'))
		local Window = Rayfield:CreateWindow({
			Name = "Pearl ・ "..game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name,
			LoadingTitle = "Pearl is Loading..",
			LoadingSubtitle = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name,
			ConfigurationSaving = {
				Enabled = true,
				FolderName = "Pearl",
				FileName = game.PlaceId.."-"..Player.Name
			},
				Discord = {
					Enabled = true,
					Invite = "wP6XfkXmAk",
					RememberJoins = true
				},
			KeySystem = true,
			KeySettings = {
				Title = "Pearl",
				Subtitle = "Authentication",
				Note = "Key Link copied!",
				FileName = "SiriusKey",
				SaveKey = false,
				GrabKeyFromSite = false,
				Key = "Zero"
			}
		})

		task.delay(1.5, function()
		local Universal = Window:CreateTab("Universal", 4483362458)
		
		Universal:CreateSection("AFKing")

		Universal:CreateToggle({
			Name = "Anti-AFK",
			CurrentValue = false,
			Flag = "Universal-AntiAFK",
			Callback = function(Value)	end,
		})

		local VirtualUser = game:GetService("VirtualUser")
		Player.Idled:Connect(function()
			if Rayfield.Flags["Universal-AntiAFK"].CurrentValue then
				VirtualUser:CaptureController()
				VirtualUser:ClickButton2(Vector2.new())
			end
		end)

		local AutoRejoin = Universal:CreateToggle({
			Name = "Auto Rejoin",
			CurrentValue = false,
			Flag = "Universal-AutoRejoin",
			Callback = function(Value)
				if Value then
					repeat task.wait() until game.CoreGui:FindFirstChild('RobloxPromptGui')

					local lp,po,ts = game:GetService('Players').LocalPlayer,game.CoreGui.RobloxPromptGui.promptOverlay,game:GetService('TeleportService')

					po.ChildAdded:connect(function(a)
						if Rayfield.Flags["Universal-AutoRejoin"].CurrentValue and a.Name == 'ErrorPrompt' then
							while true do
								ts:Teleport(game.PlaceId)
								task.wait(2)
							end
						end
					end)
				end
			end,
		})

		Universal:CreateToggle({
			Name = "Auto Re-Execute",
			CurrentValue = false,
			Flag = "Universal-AutoRe-Execute",
			Callback = function(Value)
				if Value then
					local queueteleport = (syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport)

					if queueteleport then
						queueteleport('loadstring(game:HttpGet("https://ppearl.vercel.app"))()')
					end
				end
			end,
		})

		Universal:CreateSection("Safety")

		local GroupId = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Creator.CreatorTargetId

		Universal:CreateToggle({
			Name = "Leave Upon Staff Join",
			Info = "Kicks you if a player above the group role 1 joins/is in the server",
			CurrentValue = false,
			Flag = "Universal-AutoLeave",
			Callback = function(Value)
				if Value then
					for i,v in pairs(game.Players:GetPlayers()) do
						pcall(function()
							if v:IsInGroup(GroupId) and v:GetRankInGroup(GroupId) > 1 then
								AutoRejoin:Set(false)
								Player:Kick("Detected Staff!")
							end
						end)
					end
				end
			end,
		})

		game:GetService("Players").PlayerAdded:Connect(function(v)
			if Rayfield.Flags["Universal-AutoLeave"].CurrentValue then
				pcall(function()
					if v:IsInGroup(GroupId) and v:GetRankInGroup(GroupId) > 1 then
						AutoRejoin:Set(false)
						Player:Kick("Detected Staff!")
					end
				end)
			end
		end)

		Universal:CreateSection("Misc")

		local function ServerHop()
			local Http = game:GetService("HttpService")
			local TPS = game:GetService("TeleportService")
			local Api = "https://games.roblox.com/v1/games/"

			local _place,_id = game.PlaceId, game.JobId
			local _servers = Api.._place.."/servers/Public?sortOrder=Desc&limit=100"

			local function ListServers(cursor)
				local Raw = game:HttpGet(_servers .. ((cursor and "&cursor="..cursor) or ""))
				return Http:JSONDecode(Raw)
			end

			local Next; repeat
				local Servers = ListServers(Next)
				for i,v in next, Servers.data do
					if v.playing < v.maxPlayers and v.id ~= _id then
						local s,r = pcall(TPS.TeleportToPlaceInstance,TPS,_place,v.id,Player)
						if s then break end
					end
				end

				Next = Servers.nextPageCursor
			until not Next
		end

		Universal:CreateButton({
			Name = "One-Time Server Hop",
			Callback = function()
				ServerHop()
			end,
		})

		Universal:CreateToggle({
			Name = "Server Hop",
			Info = "Automatically server hops after the interval",
			CurrentValue = false,
			Flag = "Universal-ServerHop",
			Callback = function(Value)	end,
		})

		Universal:CreateSlider({
			Name = "Server Hop Interval",
			Info = "Sets the interval in seconds for the Server Hop",
			Range = {5, 600},
			Increment = 1,
			CurrentValue = 5,
			Flag = "Universal-ServerhopIntervals",
			Callback = function(Value)	end,
		})

		task.spawn(function()
			while task.wait(Rayfield.Flags["Universal-ServerhopIntervals"].CurrentValue) do
				if Rayfield.Flags["Universal-ServerHop"].CurrentValue then
					ServerHop()
				end
			end
		end)

		local Credits = Window:CreateTab("Credits", 3944704135)
		
		local Section = Credits:CreateSection("Credits")

		local Label = Credits:CreateLabel("Developed By Facts#3866")
		local Button = Credits:CreateButton({
			Name = "Join Discord Server",
			Callback = function()
				loadstring(game:HttpGet('https://factshub.vercel.app/Discord.lua'))();
			end,
		})
		
		Rayfield:LoadConfiguration()
	end)

	return Window
end

return Player, Rayfield, Click, comma, Notify, CreateWindow, CurrentVersion

-- local Player, Rayfield, Click, comma, Notify, CreateWindow, CurrentVersion = loadstring(game:HttpGet("https://raw.githubusercontent.com/Faacts/Side/main/Modules2.lua"))()
