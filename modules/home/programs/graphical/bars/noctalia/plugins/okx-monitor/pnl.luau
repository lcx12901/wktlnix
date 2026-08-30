--!nonstrict
-- OKX PnL bar widget — shows each position's PnL amount and ratio.
-- Tertiary color for positive, error for negative. Click to open the panel.

local positions = {}
local mode = "demo"

local function formatPnl(value)
  local v = tonumber(value)
  if not v or v == 0 then return "--" end
  local sign = v > 0 and "+" or ""
  return sign .. string.format("%.2f", v)
end

local function formatRatio(value)
  local v = tonumber(value)
  if not v or v == 0 then return "" end
  local sign = v > 0 and "+" or ""
  return " (" .. sign .. string.format("%.2f%%", v * 100) .. ")"
end

-- Theme color roles: tertiary = positive, error = negative
local function getPnlColor(value)
  local v = tonumber(value)
  if not v then return "on_surface_variant" end
  if v > 0 then return "tertiary" end
  if v < 0 then return "error" end
  return "on_surface_variant"
end

local function render()
  local prefix = mode == "live" and "⚡ " or "₿ "

  if #positions == 0 then
    barWidget.render(ui.row({ gap = 6, align = "center" }, {
      ui.glyph({ name = "chart-line", color = "on_surface_variant" }),
      ui.label({ text = prefix .. "--", color = "on_surface_variant" }),
    }))
    return
  end

  local children = {
    ui.glyph({ name = "chart-line", color = getPnlColor(positions[1].upl) }),
  }

  for i, p in ipairs(positions) do
    local instId = p.instId or "?"
    local upl = p.upl or "0"
    local uplRatio = p.uplRatio or "0"
    local color = getPnlColor(upl)
    local text = instId .. " " .. formatPnl(upl) .. formatRatio(uplRatio)

    table.insert(children, ui.label({ text = text, fontWeight = "bold", color = color }))

    -- Add separator between positions
    if i < #positions then
      table.insert(children, ui.label({ text = " │ ", color = "outline" }))
    end
  end

  barWidget.render(ui.row({ gap = 6, align = "center" }, children))
end

function update()
  render()
end

noctalia.state.watch("okx-monitor.positions", function(value)
  if value and value.positions then
    positions = value.positions
  end
  render()
end)

noctalia.state.watch("okx-monitor.mode", function(value)
  mode = value or "demo"
  render()
end)

function onClick()
  noctalia.togglePanel("wktl/okx-monitor:panel")
end
