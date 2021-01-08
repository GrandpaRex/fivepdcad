--[[
    Sonaran CAD Plugins

    Plugin Name: trafficstop
    Creator: SonoranCAD
    Description: Implements ts command
]]

local pluginConfig = Config.GetPluginConfig("fivepdcad")

if pluginConfig.enabled then

    if pluginConfig.fivepdcadCommand == nil then
        pluginConfig.fivepdcadCommand = "fivepdcad"
    end

    registerApiType("NEW_DISPATCH", "emergency")

    -- Traffic Stop Handler
    function Handlefivepdcad(type, source, args, rawCommand)
        local identifier = GetIdentifiers(source)[Config.primaryIdentifier]
        local index = findIndex(identifier)
        local origin = pluginConfig.origin 
        local status =  pluginConfig.status
        local priority =  pluginConfig.priority
        local address = LocationCache[source] ~= nil and LocationCache[source].location or 'Unknown'
        local postal = isPluginLoaded("postals") and getNearestPostal(source) or ""
        local title =  pluginConfig.title
        local code =  pluginConfig.code
        local units = {identifier}
        local notes = {}
        local notesStr = ""
        address = address:gsub('%b[]', '')
        -- Checking if there are any description arguments.
		local description = 'Change to description'
        notesStr = table.concat(notes, " ")
		TriggerEvent('SonoranCAD::fivepdcad:SendTrafficApi', origin, status, priority, address, postal, title, code, description, units, notesStr, source)
        TriggerClientEvent("chat:addMessage", source, {args = {"^0^5^*[SonoranCAD]^r ", "^7Callout processed automatically"}})
    end

    RegisterCommand(pluginConfig.fivepdcadCommand, function(source, args, rawCommand)
        Handlefivepdcad("fivepdcad", source, args, rawCommand)
    end, true)

    -- Client TraficStop request
    RegisterServerEvent('SonoranCAD::fivepdcad:SendTrafficApi')
    AddEventHandler('SonoranCAD::fivepdcad:SendTrafficApi', function(origin, status, priority, address, postal, title, code, description, units, notes, source)
        -- send an event to be consumed by other resources
        TriggerEvent("SonoranCAD::fivepdcad:cadIncomingTraffic", origin, status, priority, address, postal, title, code, description, units, notes, source)
        if Config.apiSendEnabled then
            local data = {
                ['serverId'] = Config.serverId, 
                ['origin'] = origin, 
                ['status'] = status, 
                ['priority'] = priority, 
                ['block'] = "", -- not used, but required
                ['postal'] = postal, --TODO
                ['address'] = address, 
                ['title'] = title, 
                ['code'] = code, 
                ['description'] = description, 
                ['units'] = units,
                ['notes'] = notes -- required
            }
            debugLog("sending fivepdcadout!")
            performApiRequest({data}, 'NEW_DISPATCH', function() end)
        else
            debugPrint("[SonoranCAD] API sending is disabled. fivepdcadout ignored.")
        end
    end)

end