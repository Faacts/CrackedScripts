if not game:IsLoaded() then
	game.Loaded:Wait()
end
local module = {}
local VIM = game:GetService("VirtualInputManager")
local Player = game:GetService("Players").LocalPlayer or game:GetService("Players").PlayerAdded:Wait()
local UIS = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")
local HS = game:GetService("HttpService")
local P = game:GetService("Players")
local TS = game:GetService("TeleportService")

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/Faacts/UILibraries/main/RayfieldKey'))()

task.spawn(function()
	pcall(function()
		repeat task.wait() until game:GetService("CoreGui"):FindFirstChild("Rayfield"):FindFirstChild("Main")

		game:GetService("CoreGui"):FindFirstChild("Rayfield"):FindFirstChild("Main").Visible = false
	end)
end)

function module:Click(v)
	VIM:SendMouseButtonEvent(v.AbsolutePosition.X+v.AbsoluteSize.X/2,v.AbsolutePosition.Y+50,0,true,v,1)
	VIM:SendMouseButtonEvent(v.AbsolutePosition.X+v.AbsoluteSize.X/2,v.AbsolutePosition.Y+50,0,false,v,1)
end

function module:comma(amount)
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

function module:Notify(Message, Duration)
	Rayfield:Notify({
		Title = "Pearl",
		Content = Message,
		Duration = Duration or 5,
		Image = 4483362458,
		Actions = {},
	})
end

function module:Credits()
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

function module:getchar(player)
    player = player or plr
    return player.Character or player.CharacterAdded:Wait()
end

function module:touch(obj,plrPart)
    if not obj then return error("'Touch' function error: object is invalid") end
    local char = self:getchar()
    plrPart = plrPart or char.PrimaryPart
    if firetouchinterest then
        firetouchinterest(plrPart,obj,0)
        task.wait()
        firetouchinterest(plrPart,obj,1)
    else
        local pos = plrPart.CFrame
        self:notif("Error","Your executor doesn't support 'firetouchinterest'",5)
        char:PivotTo(obj.CFrame)
        task.wait()
        char:PivotTo(pos)
    end
end

function module:searchClosure(script, name, upvalueIndex)
    return self:errorHandler(function()
        local getInfo = debug.getinfo or getinfo
        local getUpvalue = debug.getupvalue or getupvalue or getupval
        local isLClosure = islclosure or is_l_closure or (iscclosure and function(f) return not iscclosure(f) end)

        assert(getgc and getInfo and getUpvalue and isLClosure, "Your exploit is not supported")

        for i, v in pairs(getgc()) do
            local parentScript = rawget(getfenv(v), "script")
    
            if type(v) == "function" and isLClosure(v) and script == parentScript and pcall(getUpvalue, v, upvalueIndex) and getInfo(v).name == name then
                return v
            end
        end
    end,"Search Closure")
end


function module:checkChar(char)
    return char and char:FindFirstChildOfClass("Humanoid") and char:FindFirstChildOfClass("Humanoid").Health > 0
end

function module:sameTeam(player)
   return #game:GetService("Teams"):GetChildren() > 0 and player.Team == plr.Team
end

function module:antikick(ignoreSetting)
    local Players = game:GetService("Players")
    local OldNameCall = nil
    OldNameCall = hookmetamethod(game, "__namecall", function(Self, ...)
        local NameCallMethod = getnamecallmethod()

        if tostring(string.lower(NameCallMethod)) == "kick" then
            notif("Pearl","You almost got kicked! Successfully prevented.",5)
            return nil
        end
        
        return OldNameCall(Self, ...)
    end)
end

function module:errorHandler(func,funcName)
    local s,e = pcall(func)
    if not s then
        self:Notify((funcName and (funcName.." Error") or "Error"),e,10)
        return
    end
    return e
end

function module:formatNum(num,formatType)
    local u1 = { "k", "m", "b", "t", "q" }
    local function Abbreviated(p1)
        local v2 = math.max(math.abs(p1), math.pow(10, -(#u1) * 3))
        local v3 = 10 ^ (math.ceil(math.log10(v2)) - 3)
        local v4 = math.round(v2 / v3) * v3
        local v5 = math.min(math.floor(math.log10(math.max(v4, 1)) / 3), #u1)
        local v1 = v4 * math.sign(p1) / 10 ^ (v5 * 3)
        if not (v5 >= 1) then
            return string.format("%g", v1)
        end
        return string.format("%g%s", v1, u1[v5])
    end
    if formatType == "Abb" then
        return Abbreviated(num)
    end
end

function module:btools()
    Instance.new("HopperBin", plr.Backpack).BinType = 1
    Instance.new("HopperBin", plr.Backpack).BinType = 2
    Instance.new("HopperBin", plr.Backpack).BinType = 3
    Instance.new("HopperBin", plr.Backpack).BinType = 4
end

function module:f3x()
    loadstring(game:GetObjects("rbxassetid://6695644299")[1].Source)()
end

function module:rejoin()
    if #P:GetPlayers() <= 1 then
        plr:Kick("\nRejoining...")
        task.wait()
        S_T:Teleport(game.PlaceId)
    else
        S_T:TeleportToPlaceInstance(game.PlaceId, game.JobId)
    end
end

function module:smallestSrv()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Faacts/Side/main/JoinSmallestServer.lua"))()
end

function module:srvhop()
    local serverhop = loadstring(game:HttpGet("https://raw.githubusercontent.com/Faacts/Side/main/serverhop.lua"))()
    serverhop:Teleport(game.PlaceId)
end

return module, Player, Rayfield

-- local module, Player, Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/Faacts/Side/main/Modules2.lua"))()
