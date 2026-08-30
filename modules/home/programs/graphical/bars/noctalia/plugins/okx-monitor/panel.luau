--!nonstrict
-- OKX Position Panel — shows position details and K-line chart.
-- Reads positions and kline from single noctalia.state key.
-- Panel does NOT support state.watch — polls via update() only.

local positions = {}
local kline_prices = {} -- { ["instId"] = { close1, close2, ... } }
local mode = "demo"

local function formatPrice(price)
  local p = tonumber(price)
  if not p then return "--" end
  if p >= 1000 then
    return string.format("%.2f", p)
  elseif p >= 1 then
    return string.format("%.4f", p)
  else
    return string.format("%.6f", p)
  end
end

local function formatRatio(ratio)
  local r = tonumber(ratio)
  if not r then return "--" end
  return string.format("%.2f%%", r * 100)
end

local function pnlColor(value)
  local v = tonumber(value)
  if not v then return "on_surface_variant" end
  if v > 0 then return "tertiary" end
  if v < 0 then return "error" end
  return "on_surface_variant"
end

local function renderChart(instId, width)
  local prices = kline_prices[instId]
  if not prices or #prices == 0 then
    return ui.row({ padding = 8 }, {
      ui.label({ text = "暂无K线数据", color = "on_surface_variant" }),
    })
  end

  return ui.column({ gap = 4, padding = 8 }, {
    ui.label({ text = "K线 (1分钟)", fontSize = 12, fontWeight = "bold", color = "on_surface" }),
    ui.graph({
      values = prices,
      color = "tertiary",
      lineWidth = 2,
      fillOpacity = 0.2,
      width = width - 32,
      height = 120,
    }),
  })
end

local function renderPositionCard(p, cardWidth)
  local instId = p.instId or "?"
  local pos = p.pos or "0"
  local avgPx = p.avgPx or "0"
  local upl = p.upl or "0"
  local uplRatio = p.uplRatio or "0"
  local lever = p.lever or "?"
  local mgnRatio = p.mgnRatio or "--"
  local liqPx = p.liqPx or "--"
  local color = pnlColor(upl)
  local sign = (tonumber(upl) or 0) > 0 and "+" or ""

  return ui.column({ gap = 8, padding = 12, fill = "surface_variant/0.35", radius = 6, border = "outline", borderWidth = 1, width = cardWidth }, {
    ui.row({ justify = "space_between" }, {
      ui.label({ text = instId, fontSize = 14, fontWeight = "bold", color = "on_surface" }),
      ui.label({ text = sign .. formatPrice(upl) .. " USDT", fontSize = 14, fontWeight = "bold", color = color }),
    }),
    renderChart(instId, cardWidth),
    ui.row({ gap = 12 }, {
      ui.label({ text = "数量: " .. pos, fontSize = 11, color = "on_surface_variant" }),
      ui.label({ text = "均价: " .. formatPrice(avgPx), fontSize = 11, color = "on_surface_variant" }),
      ui.label({ text = "盈亏: " .. formatRatio(uplRatio), fontSize = 11, color = color }),
    }),
    ui.row({ gap = 12 }, {
      ui.label({ text = "杠杆: " .. lever .. "x", fontSize = 11, color = "on_surface_variant" }),
      ui.label({ text = "保证金: " .. formatRatio(mgnRatio), fontSize = 11, color = "on_surface_variant" }),
      liqPx ~= "--" and ui.label({ text = "强平: " .. formatPrice(liqPx), fontSize = 11, color = "error" }) or ui.label({}),
    }),
  })
end

local function render()
  if #positions == 0 then
    panel.render(ui.column({ gap = 12, padding = 24, align = "center" }, {
      ui.label({ text = "暂无持仓", fontSize = 16, color = "on_surface_variant" }),
      ui.label({ text = "模式: " .. mode, fontSize = 12, color = "on_surface_variant" }),
    }))
    return
  end

  local children = {
    ui.row({ justify = "space_between" }, {
      ui.label({ text = "OKX 持仓", fontSize = 18, fontWeight = "bold", color = "primary" }),
      ui.label({ text = "模式: " .. mode, fontSize = 12, color = "on_surface_variant" }),
    }),
  }

  local panelWidth = 760
  local cardCount = #positions
  local cardWidth = math.floor((panelWidth - 16 * (cardCount - 1)) / cardCount)

  if cardCount == 1 then
    table.insert(children, renderPositionCard(positions[1], panelWidth))
  else
    local cards = {}
    for _, p in ipairs(positions) do
      table.insert(cards, renderPositionCard(p, cardWidth))
    end
    table.insert(children, ui.row({ gap = 16, flexGrow = 1 }, cards))
  end

  panel.render(ui.column({ gap = 12, padding = 16, flexGrow = 1 }, children))
end

-- Decode raw kline JSON string into normalized close prices (0..1)
local function decodeKline(kline_raw)
  if not kline_raw or type(kline_raw) ~= "string" then return nil end
  if kline_raw == "[]" then return nil end
  local ok, data = pcall(function() return noctalia.json.decode(kline_raw) end)
  if not ok or type(data) ~= "table" or #data == 0 then return nil end
  -- OKX candle format: [ts, open, high, low, close, vol, ...], index 5 = close
  -- Reverse to chronological order (oldest first)
  local close_prices = {}
  for i = #data, 1, -1 do
    local candle = data[i]
    local close = tonumber(candle[5]) or 0
    table.insert(close_prices, 1, close)
  end
  -- Normalize to 0..1 for ui.graph (which defaults minValue=0, maxValue=100)
  local minVal = close_prices[1]
  local maxVal = close_prices[1]
  for _, v in ipairs(close_prices) do
    if v < minVal then minVal = v end
    if v > maxVal then maxVal = v end
  end
  local range = maxVal - minVal
  if range == 0 then range = 1 end
  local paddedMin = minVal - range * 0.1
  local paddedRange = range * 1.2
  local normalized = {}
  for i, v in ipairs(close_prices) do
    normalized[i] = (v - paddedMin) / paddedRange
  end
  return normalized
end

-- Read positions + kline from state
local function syncState()
  local raw = noctalia.state.get("okx-monitor.positions")
  if raw and type(raw) == "table" then
    if raw.positions then positions = raw.positions end
    if raw._mode then mode = raw._mode end
  end
  -- Kline stored as JSON string per instId in the positions state
  if raw and type(raw) == "table" and raw.kline and type(raw.kline) == "table" then
    for instId, kline_raw in pairs(raw.kline) do
      local prices = decodeKline(kline_raw)
      if prices then
        kline_prices[instId] = prices
      end
    end
  end
end

function onOpen(_context)
  syncState()
  panel.setWantsSecondTicks(true)
  render()
end

function update()
  syncState()
  render()
end
