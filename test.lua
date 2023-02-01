local module = {}

function module:errorHandler(func, funcname, ...)
    local args = {...}
    local s,e = pcall(func, args)
    if not s then
        print((funcname and (funcname.." Error") or "Error"),e,10)
        --self:Notify((funcName and (funcName.." Error") or "Error"),e,10)
        return e
    end
    return
end

return module
