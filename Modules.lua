if not game:IsLoaded() then
	game.Loaded:Wait()
end
local modules = {}
local VIM = game:GetService("VirtualInputManager")
local Player = game:GetService("Players").LocalPlayer or game:GetService("Players").PlayerAdded:Wait()
local HttpService = game:GetService("HttpService")

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/Faacts/UILibraries/main/RayfieldKey'))()

task.spawn(function()
	pcall(function()
		repeat task.wait() until game:GetService("CoreGui"):FindFirstChild("Rayfield"):FindFirstChild("Main")

		game:GetService("CoreGui"):FindFirstChild("Rayfield"):FindFirstChild("Main").Visible = false
	end)
end)

function modules:Click(v)
	VIM:SendMouseButtonEvent(v.AbsolutePosition.X+v.AbsoluteSize.X/2,v.AbsolutePosition.Y+50,0,true,v,1)
	VIM:SendMouseButtonEvent(v.AbsolutePosition.X+v.AbsoluteSize.X/2,v.AbsolutePosition.Y+50,0,false,v,1)
end

function modules:comma(amount)
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

function modules:Notify(Message, Duration)
	Rayfield:Notify({
		Title = "Pearl",
		Content = Message,
		Duration = Duration or 5,
		Image = 4483362458,
		Actions = {},
	})
end

function modules:Credits()
	local Credits = Window:CreateTab("Credits", 3944704135)
	
	local Section = Credits:CreateSection("Credits")

	local Label = Credits:CreateLabel("Developed By Facts#3866")
	local Button = Credits:CreateButton({
		Name = "Join Discord Server",
		Callback = function()
			loadstring(game:HttpGet('https://factshub.vercel.app/Discord.lua'))();
		end,
	})
end

return modules, Player, Rayfield

-- local modules, Player, Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/Faacts/Side/main/Modules2.lua"))()
