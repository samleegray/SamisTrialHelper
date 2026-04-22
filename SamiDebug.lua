SamisAddonsDebugHelpers = SamisAddonsDebugHelpers or {}

local SAMID = SamisAddonsDebugHelpers
local STH = SamisTrialHelperAddon

function SAMID:Print(...)
  if not STH.settings or not STH.settings.enableDebug then return end

  local message = string.format(...)
  d("[SAMI DEBUG]: " .. message)
end
