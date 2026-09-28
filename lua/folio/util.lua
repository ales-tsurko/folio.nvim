local M = {}

local function rgb(hex)
  hex = hex:gsub("^#", "")
  return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16)
end

--- Mix `fg` over `bg` with opacity `alpha` (0..1).
---@param fg string
---@param bg string
---@param alpha number
---@return string
function M.blend(fg, bg, alpha)
  local r1, g1, b1 = rgb(fg)
  local r2, g2, b2 = rgb(bg)
  local function mix(a, b)
    return math.floor(a * alpha + b * (1 - alpha) + 0.5)
  end
  return string.format("#%02x%02x%02x", mix(r1, r2), mix(g1, g2), mix(b1, b2))
end

return M
