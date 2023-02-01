local module = {}

function module:errorHandler(func,funcName)
    local s,e = pcall(func)
    if not s then
        print(e)
        return e
    end
    return
end
