--[[
    Sonoran Plugins

    Plugin Configuration

    Put all needed configuration in this file.
]]
config = {
    enabled = true,
    pluginName = "fivepdcad", -- name your plugin here
    pluginAuthor = "SonoranCAD", -- author
    requiresPlugins = {"locations"}, -- required plugins for this plugin to work, separated by commas

    -- put your configuration options below
    origin = 1, -- 0 = CALLER / 1 = RADIO DISPATCH / 2 = OBSERVED / 3 = WALK_UP
    status = 1, -- 0 = PENDING / 1 = ACTIVE / 2 = CLOSED
    priority = 3, -- 1, 2, or 3
    title = "Callout", -- This is the title of the call by default it is sent as "Traffic Stop"
    code = "", -- Change this to reflect your communities 10 Code for a Traffic Stop
    callCommand = "fivepdcad" -- command to trigger the traffic stop
}

if config.enabled then
    Config.RegisterPluginConfig(config.pluginName, config)
end