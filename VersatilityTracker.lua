lastVersatility = nil

local function getUnitVersatility(unit)
    local totalVersatility = 0

    for slot = 1, 19 do
        local itemLink = GetInventoryItemLink(unit, slot)
        if itemLink then
            local itemStats = GetItemStats(itemLink)
            local versatility = itemStats["ITEM_MOD_VERSATILITY"]
            if versatility then
                totalVersatility = totalVersatility + versatility
            end
        end
    end

    return totalVersatility
end

local function generateTooltip(frame, versatility)
    GameTooltip:Hide()
    GameTooltip:SetOwner(UIParent, "ANCHOR_BOTTOMLEFT")
    GameTooltip:SetText("Versatility", 0.7, 0, 1)
    GameTooltip:AddLine(versatility, 1, 1, 1)
    GameTooltip:Show()
end

local function hideTooltip(self)
    GameTooltip:Hide()
end

local function OnInspectReady(frame, event, ...)
    lastVersatility = getUnitVersatility("target")
    generateTooltip(frame, lastVersatility)
end

local function OnTargetChanged(frame, event, ...)
    lastVersatility = nil
    hideTooltip()
end

local function OnHover(frame, event, ...)
    if lastVersatility then
        generateTooltip(frame, lastVersatility)
    end
end

local f = CreateFrame("GameTooltip")
f:RegisterEvent("WORLD_CURSOR_TOOLTIP_UPDATE")
f:RegisterEvent("INSPECT_READY")
f:RegisterEvent("PLAYER_TARGET_CHANGED")

f:SetScript("OnEvent", function(self, event, ...)
    if event == "WORLD_CURSOR_TOOLTIP_UPDATE" then
        OnHover(self, event, ...)
    end
    if event == "INSPECT_READY" then
        OnInspectReady(self, event, ...)
    end
    if event == "PLAYER_TARGET_CHANGED" then
        OnTargetChanged(self, event, ...)
    end
end)