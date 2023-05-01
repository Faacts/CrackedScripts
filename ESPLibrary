local RunService = game:GetService("RunService")

local ESP = {}

local espList = {}
local screenCenter = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)

function worldToView(pos)
    local camera = workspace.CurrentCamera
    local vector, onscreen = camera:WorldToViewportPoint(pos)
    if onscreen then
        return Vector2.new(vector.X, vector.Y), vector.Z
    else
        return nil
    end
end

----------- Misc Functions -----------

function ESP:hasEsp(object, type)
    for i,v in pairs(espList) do
        if v["type"] == type and v["part"] == object then
            return true
        end
    end
    return false
end

function returnDepth(part)
    return workspace.CurrentCamera:WorldToViewportPoint(part.Position).Z
end

function removeItem(list, item)
    for i,v in pairs(list) do
        if v == item then
            table.remove(list, i)
        end
    end
end

----------- Removal Functions -----------

function ESP:clearNil()
    for i,v in pairs(espList) do
        if v["part"] == nil then
            print(v["part"])
            v["drawing"].Visible = false
            removeItem(espList, v)
        end
    end
end

function ESP:removeEsp(object)
    for i,v in pairs(espList) do
        if v["part"] == object then
            v["drawing"].Visible = false
            removeItem(espList, v)
        end
    end
end


function ESP:removeTracer(object)
    for i,v in pairs(espList) do
        if v["part"] == object and v["type"] == "tracer" then
            v["drawing"].Visible = false
            removeItem(espList, v)
        end
    end
end

function ESP:removeTracer(object)
    for i,v in pairs(espList) do
        if v["part"] == object and v["type"] == "tracer" then
            v["drawing"].Visible = false
            removeItem(espList, v)
        end
    end
end

function ESP:removeBox(object)
    for i,v in pairs(espList) do
        if v["part"] == object and v["type"] == "box" then
            v["drawing"].Visible = false
            removeItem(espList, v)   
        end
    end
end

function ESP:removeHighlight(object)
    for i,v in pairs(espList) do
        if v["part"] == object and v["type"] == "highlight" then
            v["drawing"]:Destroy()
            removeItem(espList, v)
        end
    end
end

function ESP:clearTracers()
    for i,v in pairs(espList) do
        if v["type"] == "tracer" then
            v["drawing"].Visible = false
            removeItem(espList, v)
        end 
    end
end

function ESP:clearBoxes()
    for i,v in pairs(espList) do
        if v["type"] == "box" then
            v["drawing"].Visible = false
            removeItem(espList, v)
        end
    end
end

function ESP:clearHighlights()
    for i,v in pairs(espList) do
        if v["type"] == "highlight" then
            v["drawing"]:Destroy()
            removeItem(espList, v)
        end
    end
end

function ESP:clearEsp()
    for i,v in pairs(espList) do
        v["drawing"]:Remove()
    end
    espList = {}
end

----------- Shape Creators -----------

function makeLine(pos, options)
    local line = Drawing.new("Line", true)
    line.Thickness = 1
    line.From = screenCenter
    line.To = pos
    line.Visible = true
    line.Color = options.Color
    return line
end

function makeBox(pos, options)
    local box = Drawing.new("Square", true)
    box.Thickness = 1
    box.Size = options.Size
    box.Position = pos
    box.Visible = true
    box.Color = options.Color
    box.Filled = options.Filled
    return box
end

function makeHighlight(object, options)
    local highlight = Instance.new("Highlight")
    highlight.Adornee = object
    highlight.Enabled = true
    highlight.OutlineColor = options.OutlineColor
    highlight.FillColor = options.FillColor
    highlight.FillTransparency = options.FillTransparency
    highlight.Parent = object
    return highlight
end

----------- Add Esp Functions -----------

function ESP:addHighlight(object, options)
    local options = options or {}

    options.FillColor = options.FillColor or Color3.new(255, 0, 0)
    options.FillTransparency = options.FillTransparency or 0.5
    options.OutlineColor = options.OutlineColor or Color3.new(255, 255, 255)
    options.OutlineTransparency = options.OutlineTransparency or 0
    
    options.Autoremove = options.Autoremove or true
    
    local part = {
        ["part"] = object,
        ["drawing"] = makeHighlight(object, options),
        ["type"] = "highlight",
        ["options"] = {}
    }
    table.insert(espList, part)
end


function ESP:addTracer(object, options)
    local options = options or {}
    local objectPos = worldToView(object.Position) or screenCenter
    
    options.Color = options.Color or Color3.new(0, 0, 0)

    local part = {
        ["part"] = object,
        ["drawing"] = makeLine(objectPos, options),
        ["type"] = "tracer",
        ["options"] = {
            Color = options.Color
        }
    }
    table.insert(espList, part)
end


function ESP:addBox(object, options)
    local options = options or {}
    local objectPos = worldToView(object.Position) or screenCenter  

    options.Size = Vector2.new(0,0) or options.Size
    options.Color = options.Color or Color3.new(0, 0, 0)
    options.Filled = options.Filled or false
    options.Autoremove = options.Autoremove or true

    if options.IsPlayer == nil then
        options.IsPlayer = true
    end
    
    if options.Autosize == nil then
        options.Autosize = true
    end


    local part = {
        ["part"] = object,
        ["drawing"] = makeBox(objectPos, options),
        ["type"] = "box",
        ["options"] = {
            IsPlayer = options.IsPlayer,
            Autosize = options.Autosize,
            Size = options.Size,
            Autoremove = options.Autoremove
        }

    }
        
    table.insert(espList, part)
end


RunService.Stepped:Connect(function()
    for i,v in ipairs(espList) do
        if v["type"] ~= "highlight" then
            local objectPos, depth = worldToView(v["part"].Position)
            if objectPos then
                
                if v["options"].Autoremove then
                    if v["part"] == nil then
                        print("Part nil, removing", v["part"])
                        v["drawing"].Visible = false
                        removeItem(espList, v)
                    end
                end


                if v["type"] == "tracer" then
                    v["drawing"].To = objectPos
                end

                if v["type"] == "box" then
                    -- local depth = returnDepth(v["part"])
                    
                    if v["options"].Autosize then

                        --- Size handling

                        local size
                        if v["options"].IsPlayer then
                            size = Vector2.new(3000 / depth, 4200 / depth)
                        else
                            size = Vector2.new((v["part"].Size.x * 850) / depth, (v["part"].Size.y * 850) / depth)
                        end                      
    
                        v["drawing"].Size = Vector2.new(size.x, size.y)

                        -- Position Handling

                        if v["options"].IsPlayer then
                            v["drawing"].Position = objectPos - Vector2.new(size.x / 2, size.y / 2.4)
                        else
                            v["drawing"].Position = objectPos - Vector2.new(size.x / 2, size.y / 2)
                        end

                    else
                        v["drawing"].Position = objectPos - Vector2.new(v["options"].Size.x / 2, v["options"].Size.y / 2)
                    end  

                end
                v["drawing"].Visible = true
            else
                v["drawing"].Visible = false
            end
        end
    end
end)

return ESP
