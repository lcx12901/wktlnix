--!nonstrict
-- OKX Position Monitor — headless service entry.
--
-- Calls okx CLI via noctalia.runAsync, publishes position data
-- and kline close prices to noctalia.state for widget and panel.
-- Kline is embedded in the positions state object to avoid
-- dynamic state key issues.

noctalia.setUpdateInterval(1000)

local STATE_DIR = noctalia.expandPath("~/.local/share/noctalia/plugins/okx-monitor")
local current_mode = noctalia.getConfig("mode") or "demo"
local pos_fetching = false
local last_kline = {} -- Preserve kline data across update cycles

local function updatePositions()
  if pos_fetching then return end
  pos_fetching = true

  local mode_flag = current_mode == "live" and "--live" or "--demo"
  local cmd = "okx account positions --instType SWAP " .. mode_flag .. " --json 2>/dev/null"

  noctalia.runAsync(cmd, function(result)
    pos_fetching = false

    local stdout = (result and result.stdout) or ""
    stdout = stdout:gsub("^%s+", ""):gsub("%s+$", "")

    local state
    if stdout ~= "" and stdout ~= "[]" then
      local ok, positions = pcall(function()
        return noctalia.json.decode(stdout)
      end)
      if ok and type(positions) == "table" then
        state = { positions = positions, kline = last_kline, _updated_at = os.time(), _mode = current_mode }
      else
        state = { positions = {}, kline = last_kline, _updated_at = os.time(), _mode = current_mode, _error = "json_parse_failed" }
      end
    else
      state = { positions = {}, kline = last_kline, _updated_at = os.time(), _mode = current_mode }
    end

    noctalia.writeFile(STATE_DIR .. "/positions.json", noctalia.json.encode(state))
    noctalia.state.set("okx-monitor.positions", state)

    -- Fetch K-line for each position (lightweight: store raw JSON, decode in panel)
    if state.positions and #state.positions > 0 then
      local pending = #state.positions
      for _, p in ipairs(state.positions) do
        if p.instId then
          local instId = p.instId
          local kline_cmd = "okx market candles " .. instId .. " --bar 1m --limit 100 " .. mode_flag .. " --json 2>/dev/null"
          noctalia.runAsync(kline_cmd, function(kline_result)
            local kline_stdout = (kline_result and kline_result.stdout) or ""
            kline_stdout = kline_stdout:gsub("^%s+", ""):gsub("%s+$", "")
            if kline_stdout ~= "" and kline_stdout ~= "[]" then
              -- Store raw JSON string; panel decodes it (avoids CPU budget overflow in callback)
              state.kline[instId] = kline_stdout
            end
            pending = pending - 1
            if pending <= 0 then
              last_kline = state.kline
              noctalia.state.set("okx-monitor.positions", state)
            end
          end)
        else
          pending = pending - 1
          if pending <= 0 then
            last_kline = state.kline
            noctalia.state.set("okx-monitor.positions", state)
          end
        end
      end
    end
  end)
end

noctalia.state.watch("okx-monitor.cmd", function(cmd)
  if cmd == "set_mode:demo" then
    current_mode = "demo"
    updatePositions()
  elseif cmd == "set_mode:live" then
    current_mode = "live"
    updatePositions()
  elseif cmd == "refresh" then
    updatePositions()
  end
end)

updatePositions()

function update()
  updatePositions()
end
