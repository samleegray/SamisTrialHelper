local STH = SamisTrialHelperAddon
local SAMID = SamisAddonsDebugHelpers

local function itemsNotCollected(message, fromDisplayName)
  local links = {}
  ZO_ExtractLinksFromText(message, { [ITEM_LINK_TYPE] = true }, links)

  local uncollected = {}

  for _, originalItemLink in ipairs(links) do
    if IsItemLinkSetCollectionPiece(originalItemLink.link) and not IsItemSetCollectionPieceUnlocked(GetItemLinkItemId(originalItemLink.link)) then
      table.insert(uncollected, originalItemLink.link)
    end
  end

  return uncollected
end

local function handleChatMessage(event, channelType, fromName, messageText, isCustomerService, fromDisplayName)
  -- if channelType ~= CHAT_CHANNEL_PARTY then return end

  -- if fromName == GetUnitName("player") and STH.lastMessage == messageText then
  --   STH.lastRequestRecord.requested = true
  --   STH.lastMessage = nil
  --   STH.lastRequestRecord = nil

  --   return
  -- end

  SAMID:Print("Chat Message - Channel: %s, From: %s, Message: %s", channelType, fromName, messageText)

  local uncollectedItems = itemsNotCollected(messageText, fromDisplayName)
  local uncollectedItemRecord = STH:CreateUncollectedItemRecord(fromDisplayName, fromName, uncollectedItems)

  if #uncollectedItems > 0 then
    table.insert(STH.uncollectedItems, uncollectedItemRecord)

    SAMID:Print("Found %d uncollected item(s) in the message from %s.", #uncollectedItems,
      uncollectedItemRecord.playerName)
    for _, itemLink in ipairs(uncollectedItemRecord.itemLinks) do
      SAMID:Print("Uncollected Item Link: %s", itemLink)
    end

    STH.ui.show()
    STH.ui.createPlayerButton(uncollectedItemRecord)
  else
    SAMID:Print("No uncollected items found in the message.")
  end
end

local function reset()
  STH.uncollectedItems = {}
  STH.lastMessage = nil
  STH.lastRequestRecord = nil
  STH.ui.clearPlayerButtons()
  STH.ui.hide()
end

local function onZoneChanged()
  if STH.settings.clearOnZoneChange then
    reset()
  end
end

local function initialize()
  STH.settings = ZO_SavedVars:NewAccountWide("SamisTrialHelperSavedVariables", 1, nil, STH.defaults)

  EVENT_MANAGER:RegisterForEvent(STH.name .. "ChatMessage", EVENT_CHAT_MESSAGE_CHANNEL, handleChatMessage)
  EVENT_MANAGER:RegisterForEvent(STH.name .. "ZoneChange", EVENT_PLAYER_ACTIVATED, onZoneChanged)

  STH.InitializeSettings()
  STH.ui.init()
end

local function onAddOnLoaded(_, addonName)
  if addonName ~= STH.name then
    return
  end

  EVENT_MANAGER:UnregisterForEvent(STH.name, EVENT_ADD_ON_LOADED)
  initialize()
end

EVENT_MANAGER:RegisterForEvent(STH.name, EVENT_ADD_ON_LOADED, onAddOnLoaded)
