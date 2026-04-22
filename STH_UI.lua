local STH = SamisTrialHelperAddon

STH.ui = STH.ui or {}

local ui = STH.ui
local util = STH.util

ui.playerButtons = {}

function ui.init()
  if not ui.mainFragment then
    ui.mainFragment = ZO_SimpleSceneFragment:New(SamisTrialHelperTLC)
  end

  HUD_SCENE:AddFragment(ui.mainFragment)
  HUD_UI_SCENE:AddFragment(ui.mainFragment)

  SamisTrialHelperTLC:ClearAnchors()
  SamisTrialHelperTLC:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, STH.settings.offsetX,
    STH.settings.offsetY)

  -- Create background if it doesn't exist
  if not ui.background then
    local bg = WINDOW_MANAGER:CreateControl("SamisTrialHelperTLCBackground", SamisTrialHelperTLC, CT_TEXTURE)
    bg:SetDimensions(400, 100)
    bg:SetAnchor(TOPLEFT, SamisTrialHelperTLC, TOPLEFT, 0, 0)
    bg:SetDrawLevel(-1)
    ui.background = bg
  end

  -- Create title if it doesn't exist
  if not ui.title then
    local title = WINDOW_MANAGER:CreateControl("SamisTrialHelperTLCTitle", SamisTrialHelperTLC, CT_LABEL)
    title:SetFont("ZoFontWinH5")
    title:SetColor(1, 1, 1)
    title:SetText("Get yo Loot!")
    title:SetAnchor(TOP, SamisTrialHelperTLC, TOP, 0, 2)
    ui.title = title
  end

  -- Adjust label to position below title
  SamisTrialHelperTLCLabel:ClearAnchors()
  SamisTrialHelperTLCLabel:SetAnchor(TOPLEFT, SamisTrialHelperTLC, TOPLEFT, 8, 20)

  -- Set default text color
  local r, g, b = util.hexToRgb("#FFFFFF")
  SamisTrialHelperTLCLabel:SetColor(r, g, b)

  -- Set up the background
  local bg = ui.background
  local r, g, b = util.hexToRgb("#000000")
  bg:SetColor(r, g, b, 255)
  bg:SetHidden(false)

  ui.hide()
end

function ui.hide()
  if ui.mainFragment then
    ui.mainFragment:Hide()
  end
end

function ui.show()
  if ui.mainFragment then
    ui.mainFragment:Show()
  end
end

function ui.createPlayerButton(playerDetails)
  if ui.playerButtons[playerDetails.playerName] then
    local row = ui.playerButtons[playerDetails.playerName]
    row.label:SetText(playerDetails.playerName .. " has #" .. #playerDetails.itemLinks .. " items you need")
    return
  end

  local row = WINDOW_MANAGER:CreateControl("SamisTrialHelperTLC" .. playerDetails.playerName, SamisTrialHelperTLC,
    CT_CONTROL)
  row:SetHeight(30)
  row:SetAnchor(TOPLEFT, SamisTrialHelperTLC, TOPLEFT, 8, 20 + 30 * #ui.playerButtons)
  row:SetMouseEnabled(true)

  row.label = WINDOW_MANAGER:CreateControl(nil, row, CT_LABEL)
  row.label:SetAnchor(LEFT, row, LEFT, 0, 0)
  row.label:SetText(playerDetails.playerName .. " has #" .. #playerDetails.itemLinks .. " items you need")
  row.label:SetFont("ZoFontWinH5")

  row:SetWidth(row.label:GetTextWidth() + 20)

  row:SetHandler("OnMouseUp", function(self, button)
    if button ~= MOUSE_BUTTON_INDEX_LEFT then return end

    STH:SendGroupMessage(playerDetails)
  end)

  ui.playerButtons[playerDetails.playerName] = row
end

function ui.removePlayerButton(playerName)
  local row = ui.playerButtons[playerName]
  if row then
    row:SetHidden(true)
    row:ClearAnchors()
    row:Destroy()
    ui.playerButtons[playerName] = nil
  end
end

function ui.clearPlayerButtons()
  for playerName, row in pairs(ui.playerButtons) do
    row:SetHidden(true)
    row:ClearAnchors()
    row:Destroy()
    ui.playerButtons[playerName] = nil
  end
end

function ui.setText(text)
  SamisTrialHelperTLCLabel:SetText(text or "")

  -- Resize background to match label with padding
  local label = SamisTrialHelperTLCLabel
  local width = label:GetWidth()
  local height = label:GetHeight()

  if width == 0 or height == 0 then
    -- If dimensions are 0, use the control's set dimensions
    width = 200
    height = 100
  end

  -- Add padding: 8px left/right, 4px top/bottom
  width = width + 16
  height = height + 8

  local bg = ui.background
  bg:SetDimensions(width, height)

  -- Recenter title after resizing
  local title = ui.title
  if title then
    title:ClearAnchors()
    title:SetAnchor(TOP, ui.background, TOP, 0, 2)
  end
end

function STH.savePosition()
  STH.settings.offsetX = SamisTrialHelperTLC:GetLeft()
  STH.settings.offsetY = SamisTrialHelperTLC:GetTop()
end

-- function ui.updateBackgroundColor()
--   local bg = ui.background
--   if bg then
--     local r, g, b = util.hexToRgb(STH.settings.backgroundColor)
--     bg:SetColor(r, g, b, STH.settings.backgroundOpacity)
--   end
-- end

-- function ui.updateBackgroundOpacity()
--   local bg = ui.background
--   if bg then
--     local r, g, b = util.hexToRgb(STH.settings.backgroundColor)
--     bg:SetColor(r, g, b, STH.settings.backgroundOpacity)
--   end
-- end

-- function ui.updateTextColors()
--   -- Refresh the timers to apply any color changes
--   local r, g, b = util.hexToRgb(STH.settings.defaultTextColour)
--   SamisTrialHelperTLCLabel:SetColor(r, g, b)
--   STH.updateTimer()
-- end

-- function ui.updateTitleVisibility()
--   local title = ui.title
--   if title then
--     title:SetHidden(not STH.settings.showTitle)
--   end
-- end
