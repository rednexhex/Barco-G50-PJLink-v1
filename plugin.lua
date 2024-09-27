-- PJLink Control Plugin
-- by Matty
-- March 2024

-- Information block for the plugin
--[[ #include "info.lua" ]]

-- Define the color of the plugin object in the design
function GetColor(props)
  return { 155, 66, 245 }
end

-- The name that will initially display when dragged into a design
function GetPrettyName(props)
  return "Barco G50-PJLink, version " .. PluginInfo.Version
end

-- Optional function used if plugin has multiple pages
local pagenames = {"Control", "Status", "Setup"}
function GetPages(props)
  local pages = {}
  for ix,name in ipairs(pagenames) do
    table.insert(pages, {name = pagenames[ix]})
  end
  return pages
end

-- Define User configurable Properties of the plugin
function GetProperties()
  local props = {}
  --[[ #include "properties.lua" ]]
  return props
end

-- Optional function to update available properties when properties are altered by the user
function RectifyProperties(props)
  --[[ #include "rectify_properties.lua" ]]
  return props
end

-- Defines the Controls used within the plugin
function GetControls(props)
  local ctrls = {}
  --[[ #include "controls.lua" ]]
  return ctrls
end

--Layout of controls and graphics for the plugin UI to display
function GetControlLayout(props)
  local layout   = {}
  local graphics = {}
      --[[ #include "layout.lua" ]]
    return layout, graphics
  end

--Start event based logic
if Controls then
  --[[ #include "runtime.lua" ]]
end
