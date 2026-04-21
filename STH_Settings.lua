local STH = SamisTrialHelperAddon
local LAM2 = LibAddonMenu2
local STHUtils = STH.utils

function STH.InitializeSettings()
  local panelData = {
    type = "panel",
    name = STH.displayName,
    displayName = STH.displayName,
    author = STH.styledAuthor,
    version = STH.version,
    website = "https://lethalrejection.com",
    registerForRefresh = true,
    registerForDefaults = true,
  }

  local optionsPanel = LAM2:RegisterAddonPanel(STH.name .. "Options", panelData)

  local optionsData = {
    {
      type = "description",
      text = "Configure the settings for Sami's Trial Helper.",
    },
    {
      type = "checkbox",
      name = "Enable Debug",
      tooltip = "Toggle debug messages.",
      getFunc = function() return STH.savedVariables.enableDebug end,
      setFunc = function(value) STH.savedVariables.enableDebug = value end,
      default = false,
    },
  }

  LAM2:RegisterOptionControls(STH.name .. "Options", optionsData)
end
