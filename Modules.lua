if not game:IsLoaded() then
	game.Loaded:Wait()
end
local module = {}
local VIM = game:GetService("VirtualInputManager")
local plr = game:GetService("Players").LocalPlayer or game:GetService("Players").PlayerAdded:Wait()
local UIS = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")
local HS = game:GetService("HttpService")
local P = game:GetService("Players")
local TS = game:GetService("TeleportService")

local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/Faacts/UILibraries/main/RayfieldKey'))()

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

function module:chatNotif(text)
    game.StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = "[Pearl]: "..text,
        Color = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.SourceSansBold,
        FontSize = Enum.FontSize.Size24
    })
end

function module:Notify(title, text, t)
	Library:Notify({
		Title = title,
		Content = text,
		Duration = t or 5,
		Image = 12339537490,
	})
end

function module:copydiscord()
    setclipboard("https://discord.gg/EwFuXZTBCP")
end

function module:plrtab(Window)
	local PLRTab = Window:CreateTab("Player", 10686489468)
	local Section = PLRTab:CreateSection("Main")

	local defaultspeed = plr.Character.Humanoid.WalkSpeed
	local Slider = PLRTab:CreateSlider({
		Name = "Walk Speed",
		Range = {0, 1000},
		Increment = 1,
		Suffix = "Speed",
		CurrentValue = defaultspeed,
		Flag = "Slider1",
		Callback = function(Value)
			plr.Character.Humanoid.WalkSpeed = Value
		end,
	})

	local defaultjump = plr.Character.Humanoid.JumpPower
	local Slider = PLRTab:CreateSlider({
		Name = "Jump Power",
		Range = {0, 1000},
		Increment = 1,
		Suffix = "Power",
		CurrentValue = defaultjump,
		Flag = "Slider2",
		Callback = function(Value)
			plr.Character.Humanoid.JumpPower = Value
		end,
	})

	local Slider = PLRTab:CreateSlider({
		Name = "Field Of View",
		Range = {0, 120},
		Increment = 1,
		Suffix = "FOV",
		CurrentValue = 70,
		Flag = "Slider3",
		Callback = function(Value)
			game:GetService'Workspace'.Camera.FieldOfView = Value
		end,
	})

	local Button = PLRTab:CreateButton({
		Name = "Reset FOV",
		Callback = function()
			game:GetService'Workspace'.Camera.FieldOfView = 70
		end,
	})
end

function module:esp(Window)
	local ESPTab = Window:CreateTab("ESP", 10686484299)

	local Section = ESPTab:CreateSection("ESP")

	getgenv().esp = false
	getgenv().teamcheck = false
	getgenv().Color = Color3.fromRGB(255,0,0)

	local Toggle = ESPTab:CreateToggle({
		Name = "ESP",
		CurrentValue = false,
		Flag = "ToggleESP",
		Callback = function(Value)
		getgenv().esp = Value
		spawn(function()
		while wait() do
		    if not getgenv().esp then
			  for i,v in pairs(game.Players:GetChildren()) do
			      if v.Character and v.Character:FindFirstChild("Highlight") then
				  local Highlight = v.Character:FindFirstChild("Highlight")
				  Highlight.Enabled = false
			  end
		      end 
		      else
			  for i,v in pairs(game.Players:GetChildren()) do
			     if getgenv().teamcheck == true then
			       if v.Character and v ~= game.Players.LocalPlayer and v.TeamColor ~= game.Players.LocalPlayer.TeamColor then
				     if v.Character:FindFirstChild("Highlight") then
				     local Highlight = v.Character:FindFirstChild("Highlight") 
				     Highlight.Enabled = true
				     Highlight.FillColor = getgenv().Color
				     Highlight.Adornee = v.Character
				     else
				     local Highlight = Instance.new("Highlight",v.Character)
				     Highlight.Enabled = true
				     Highlight.FillColor = getgenv().Color
				     Highlight.Adornee = v.Character
				  end       
			       end  
				if v.TeamColor == game.Players.LocalPlayer.TeamColor then
				  if v.Character and v.Character:FindFirstChild("Highlight") then
				      local Highlight = v.Character:FindFirstChild("Highlight")
				      Highlight.Enabled = false
				  end    
				end 
			      else
				  if v.Character and v ~= game.Players.LocalPlayer then
				     if v.Character:FindFirstChild("Highlight") then
				     local Highlight = v.Character:FindFirstChild("Highlight") 
				     Highlight.Enabled = true
				     Highlight.FillColor = getgenv().Color
				     Highlight.Adornee = v.Character
				     else
				     local Highlight = Instance.new("Highlight",v.Character)
				     Highlight.Enabled = true
				     Highlight.FillColor = getgenv().Color
				     Highlight.Adornee = v.Character
				  end       
			       end    
			    end       
		      end    
		    end  
		end    
		end)
		end,
	})

	local Toggle = ESPTab:CreateToggle({
		Name = "Team Check",
		CurrentValue = false,
		Flag = "ToggleESP2", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
		Callback = function(Value)
			getgenv().teamcheck = Value
		end,
	})

	local Toggle = ESPTab:CreateToggle({
		Name = "Rainbow ESP",
		CurrentValue = false,
		Flag = "ToggleESP3", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
		Callback = function(Value)
		getgenv().Rainbow = Value
		while wait() do
		    if not getgenv().Rainbow then return end
		    getgenv().Color = Color3.new(148, 0, 211)
		    wait()
		    getgenv().Color = Color3.new(75, 0, 130)
		    wait()
		    getgenv().Color = Color3.new(0, 0, 255)
		    wait()
		    getgenv().Color = Color3.new(0, 255, 0)
		    wait()
		    getgenv().Color = Color3.new(255, 255, 0)
		    wait()
		    getgenv().Color = Color3.new(255, 127, 0)
		    wait()
		    getgenv().Color = Color3.new(255, 0 , 0)
		    wait()
		end   
		end,
	})
end

function module:Credits(Window)
	local Creditss = Window:CreateTab("Credits", 3944704135)
	
	local Section = Creditss:CreateSection("Credits")

	local Label = Creditss:CreateLabel("Developed By Facts#3866")
	local Button = Creditss:CreateButton({
		Name = "Join Discord Server",
		Callback = function()
			module:Discord()
		end,
	})
end

function module:speed(Value)
	getgenv().speed = Value
	while true do
	    if getgenv().speed then
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame *= CFrame.new(0, 0, -1)
	    end
	    task.wait()
	end

end

function module:Discord()
	local httprequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
	HttpService = game:GetService("HttpService")
	if httprequest then
	httprequest({
	Url = 'http://127.0.0.1:6463/rpc?v=1',
	Method = 'POST',
	Headers = {
	['Content-Type'] = 'application/json',
	Origin = 'https://discord.com'
	},
	Body = HttpService:JSONEncode({
	cmd = 'INVITE_BROWSER',
	nonce = HttpService:GenerateGUID(false),
	args = {code = 'EwFuXZTBCP'}
	})
	})
	end
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
        self:Notify("Error","Your executor doesn't support 'firetouchinterest'",5)
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
            return self:Notify("Pearl", "You almost got kicked! Successfully prevented.", 5)
        end
        
        return OldNameCall(Self, ...)
    end)
end

function module:errorHandler(func, funcname, ...)
    local s,e = pcall(func, ...)
    if not s then
        self:Notify((funcname and (funcname.." Error") or "Error"),e,10)
        return e
    end
    return
end

function module:antiafk()
    local GC = getconnections or get_signal_cons
    if GC then
        for i,v in pairs(GC(plr.Idled)) do
            if v["Disable"] then
                v["Disable"](v)
            elseif v["Disconnect"] then
                v["Disconnect"](v)
            end
        end
    else
        self:chatNotif("Executor you are using is not fully supported.")
        local vu = game:GetService("VirtualUser")
        game:GetService("Players").LocalPlayer.Idled:Connect(function()
            vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
            task.wait(1)
            vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        end)
    end
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

function module:tableF()
    local TableUtil = {}
    local function CopyTable(t)
        assert(type(t) == "table", "First argument must be a table")
        local tCopy = table.create(#t)
        for k,v in pairs(t) do
            if (type(v) == "table") then
                tCopy[k] = CopyTable(v)
            else
                tCopy[k] = v
            end
        end
        return tCopy
    end


    local function Print(tbl, label, deepPrint)

        assert(type(tbl) == "table", "First argument must be a table")
        assert(label == nil or type(label) == "string", "Second argument must be a string or nil")
        
        label = (label or "TABLE")
        
        local strTbl = {}
        local indent = " - "
        
        local function Insert(s, l)
            strTbl[#strTbl + 1] = (indent:rep(l) .. s .. "\n")
        end
        
        local function AlphaKeySort(a, b)
            return (tostring(a.k) < tostring(b.k))
        end
        
        local function PrintTable(t, lvl, lbl)
            Insert(lbl .. ":", lvl - 1)
            local nonTbls = {}
            local tbls = {}
            local keySpaces = 0
            for k,v in pairs(t) do
                if (type(v) == "table") then
                    table.insert(tbls, {k = k, v = v})
                else
                    table.insert(nonTbls, {k = k, v = "[" .. typeof(v) .. "] " .. tostring(v)})
                end
                local spaces = #tostring(k) + 1
                if (spaces > keySpaces) then
                    keySpaces = spaces
                end
            end
            table.sort(nonTbls, AlphaKeySort)
            table.sort(tbls, AlphaKeySort)
            for _,v in ipairs(nonTbls) do
                Insert(tostring(v.k) .. ":" .. (" "):rep(keySpaces - #tostring(v.k)) .. v.v, lvl)
            end
            if (deepPrint) then
                for _,v in ipairs(tbls) do
                    PrintTable(v.v, lvl + 1, tostring(v.k) .. (" "):rep(keySpaces - #tostring(v.k)) .. " [Table]")
                end
            else
                for _,v in ipairs(tbls) do
                    Insert(tostring(v.k) .. ":" .. (" "):rep(keySpaces - #tostring(v.k)) .. "[Table]", lvl)
                end
            end
        end
        
        PrintTable(tbl, 1, label)
        
        print(table.concat(strTbl, ""))
    end


    local function Reverse(tbl)
        local n = #tbl
        local tblRev = table.create(n)
        for i = 1,n do
            tblRev[i] = tbl[n - i + 1]
        end
        return tblRev
    end


    local function Shuffle(tbl)
        assert(type(tbl) == "table", "First argument must be a table")
        local rng = Random.new()
        for i = #tbl, 2, -1 do
            local j = rng:NextInteger(1, i)
            tbl[i], tbl[j] = tbl[j], tbl[i]
        end
    end


    local function IsEmpty(tbl)
        return (next(tbl) == nil)
    end


    TableUtil.Copy = CopyTable
    TableUtil.Print = Print
    TableUtil.Reverse = Reverse
    TableUtil.Shuffle = Shuffle

    return TableUtil
end

local flingtbl = {}
local flingA = true
function module:fling(Value)
    if flingA then
        flingA = false
        return
    end
    if not Value then
        --disable
        local char = getchar()
        local rootpart = char.HumanoidRootPart
        if not rootpart then return end
        flingtbl.OldPos = rootpart.CFrame
        local Charr = char:GetChildren()
        if flingtbl.bv ~= nil then
            flingtbl.bv:Destroy()
            flingtbl.bv = nil
        end
        if flingtbl.Noclipping2 ~= nil then
            flingtbl.Noclipping2:Disconnect()
            flingtbl.Noclipping2 = nil
        end
        for i, v in next, Charr do
            if v:IsA("BasePart") then
                v.CanCollide = true
                v.Massless = false
            end
        end
        flingtbl.isRunning = game:GetService("RunService").Stepped:Connect(function()
            if flingtbl.OldPos then
                rootpart.CFrame = flingtbl.OldPos
            end
            if flingtbl.OldVelocity then
                rootpart.Velocity = flingtbl.OldVelocity
            end
        end)
        rootpart.RotVelocity = Vector3.new(0,0,0)
        rootpart.Velocity = Vector3.new(0,0,0)
        task.wait(2)
        rootpart.Anchored = true
        if flingtbl.isRunning then
            flingtbl.isRunning:Disconnect()
            flingtbl.isRunning = nil
        end
        rootpart.Anchored = false
        if flingtbl.OldVelocity then
            rootpart.Velocity = flingtbl.OldVelocity
        end
        if flingtbl.OldPos then
            rootpart.CFrame = flingtbl.OldPos
        end
        task.wait()
        flingtbl.OldVelocity = nil
        flingtbl.OldPos = nil
    else
        --enable

        local char = getchar()
        local rootpart = char.HumanoidRootPart
        if not rootpart then return end
        flingtbl.OldVelocity = rootpart.Velocity
        local bv = Instance.new("BodyAngularVelocity")
        flingtbl.bv = bv
        bv.MaxTorque = Vector3.new(1, 1, 1) * math.huge
        bv.P = math.huge
        bv.AngularVelocity = Vector3.new(0, 9e5, 0)
        bv.Parent = rootpart
        local Charr = char:GetChildren()
        for i, v in next, Charr do
            if v:IsA("BasePart") then
                v.CanCollide = false
                v.Massless = true
                v.Velocity = Vector3.new(0, 0, 0)
            end
        end
        flingtbl.Noclipping2 = game:GetService("RunService").Stepped:Connect(function()
            for i, v in next, Charr do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end)
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
        TS:Teleport(game.PlaceId)
    else
        TS:TeleportToPlaceInstance(game.PlaceId, game.JobId)
    end
end

function module:smallestSrv()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Faacts/Side/main/JoinSmallestServer.lua"))()
end

function module:srvhop()
    local serverhop = loadstring(game:HttpGet("https://raw.githubusercontent.com/Faacts/Side/main/serverhop.lua"))()
    serverhop:Teleport(game.PlaceId)
end

return module, plr, Library

-- local module, plr, Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Faacts/Side/main/Modules.lua"))()
