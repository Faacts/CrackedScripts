local module = {Pearl={}}
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/Faacts/UILibraries/main/RayfieldKey"))()
local esp = loadstring(game:HttpGet("https://lkhub.net/s/ESP.lua"))()
local plr = game.Players.LocalPlayer
local S_UIS = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")
local S_H = game:GetService("HttpService")
local P = game:GetService("Players")
local S_T = game:GetService("TeleportService")

function module:chatNotif(text)
    game.StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = "[Pearl]: "..text,
        Color = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.SourceSansBold,
        FontSize = Enum.FontSize.Size24
    })
end

function module:notif(title,text,t)
    Rayfield:Notify({
        Title = title,
        Content = text,
        Duration = t,
        Image = 4483362458,
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
        self:notif((funcName and (funcName.." Error") or "Error"),e,10)
        return
    end
    return e
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
        self:chatNotif("Executor you are using is not fully supported. Recommended executor is Synapse X")
        local vu = game:GetService("VirtualUser")
        game:GetService("Players").LocalPlayer.Idled:Connect(function()
            vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
            task.wait(1)
            vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        end)
    end
end

local betterisfile = function(file)
    local suc, res = pcall(function() return readfile(file) end)
    return suc and res ~= nil
end

function module:makeFolder(name)
    local s,e = pcall(function()
        if isfolder(name) == false then
            makefolder(name)
        end
    end)
    if not s then
        self:notif("Error","Error making "..name.." folder to save settings. Error: "..e,10)
    end
end

function module:saveSettings()
    local s,e = pcall(function()
        local settingz = {}
        for _,v in pairs(self.LKHUB) do
            if not string.find(_,"firstTime") then
                settingz[_] = v
            end
        end
        writefile(self.settingsDir, S_H:JSONEncode(settingz))
    end)
    if not s then 
        self:notif("Error","Error saving settings. Error: "..e,10)
    end
end
function module:loadSettings()
    local s,e = pcall(function()
        if betterisfile(self.settingsDir) then
            local settingz = readfile(self.settingsDir)
            settingz = S_H:JSONDecode(settingz)
            if settingz then
                for _,v in pairs(settingz) do
                    self.LKHUB[_] = v
                end
            end
        end
    end)
    if not s then 
        self:notif("Error","Error loading settings. Error: "..e,10)
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

function module:speed(Value)
    self.LKHUB.speed = Value
    while self.LKHUB.speed do
        task.wait()
        self:getchar().HumanoidRootPart.CFrame = self:getchar().HumanoidRootPart.CFrame + self:getchar().HumanoidRootPart.CFrame.LookVector * 3
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

function module:Credits(SettingsTab)
    local Section = SettingsTab:CreateSection("Credits")
    local Label = SettingsTab:CreateLabel("Developed By Facts#3866")
    local Button = SettingsTab:CreateButton({
        Name = "Join Discord Server",
        Callback = function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/Faacts/Side/main/JoinDiscord.lua'))();
        end,
    })
end

return module,Library