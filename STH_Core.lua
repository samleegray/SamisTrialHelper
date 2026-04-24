SamisTrialHelperAddon = SamisTrialHelperAddon or {}

local STH = SamisTrialHelperAddon

STH.name = "SamisTrialHelper"
STH.displayName = "Sami's Trial Helper"
STH.version = "1.0.0"
STH.author = "samihaize"
STH.styledAuthor = "|cf500e2s|r|ceb00e5a|r|ce100e9m|r|cd700edi|r|cce00f0h|r|cc400f4a|r|cba00f8i|r|cb000fbz|r|ca600ffe|r"

STH.settings = {}

STH.defaults = {
  enableDebug = false,
  clearOnZoneChange = true,
  offsetX = 100,
  offsetY = 200,
  timeoutDuration = 8,
  warningDuration = 60,
  alertDuration = 15,
  warningColour = "FFAA00",
  alertColour = "FF0000",
  defaultTextColour = "FFFFFF",
  wipeOnZoneChange = false,
  debug = false,
  backgroundColor = "000000",
  backgroundOpacity = 0.8,
  showTitle = true,
  listenToSayChannel = false,
  listenToGroupChannel = true,
  whisperPlayer = false,
}

STH.uncollectedItems = {}
STH.lastMessage = nil
STH.lastRequestRecord = nil

function STH:RemoveUncollectedItemRecord(record)
  if not record then return end

  STH.uncollectedItems[record.playerName] = nil
  -- for index, existingRecord in ipairs(STH.uncollectedItems) do
  --   if existingRecord == record or existingRecord.playerName == record.playerName then
  --     table.remove(STH.uncollectedItems, index)
  --     return
  --   end
  -- end
end

function STH:CreateUncollectedItemRecord(fromDisplayName, fromName, itemLinks)
  return {
    playerName = fromDisplayName or fromName,
    itemLinks = itemLinks,
    requested = false,
  }
end

function STH:SendGroupMessage(record)
  if not record.requested then
    local fromDisplayName = record.playerName
    local uncollectedItems = record.itemLinks

    local formattedMessage = string.format("I need these items: %s from %s. [SamisTrialHelper]",
      table.concat(uncollectedItems, ", "),
      fromDisplayName)

    STH.lastMessage = formattedMessage
    STH.lastRequestRecord = record

    local prefix = nil
    local chatChannel = nil
    if STH.settings.whisperPlayer then
      prefix = string.format("/w %s ", fromDisplayName)
      chatChannel = CHAT_CHANNEL_WHISPER
    else
      prefix = "/g "
      chatChannel = CHAT_CHANNEL_PARTY
    end

    CHAT_SYSTEM:StartTextEntry(string.format("%s%s", prefix, formattedMessage), chatChannel)
  end
end
