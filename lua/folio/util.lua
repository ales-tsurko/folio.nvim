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

-- OKLCH (https://bottosson.github.io/posts/oklab/) -------------------------

local function oklch_to_linear(L, C, h)
  local a, b = C * math.cos(math.rad(h)), C * math.sin(math.rad(h))
  local l = (L + 0.3963377774 * a + 0.2158037573 * b) ^ 3
  local m = (L - 0.1055613458 * a - 0.0638541728 * b) ^ 3
  local s = (L - 0.0894841775 * a - 1.2914855480 * b) ^ 3
  return 4.0767416621 * l - 3.3077115913 * m + 0.2309699292 * s,
    -1.2684380046 * l + 2.6097574011 * m - 0.3413193965 * s,
    -0.0041960863 * l - 0.7034186147 * m + 1.7076147010 * s
end

local function in_gamut(r, g, b)
  local e = 1e-4
  return r >= -e and r <= 1 + e and g >= -e and g <= 1 + e and b >= -e and b <= 1 + e
end

local function encode(x)
  x = math.min(1, math.max(0, x))
  x = x <= 0.0031308 and 12.92 * x or 1.055 * x ^ (1 / 2.4) - 0.055
  return math.floor(x * 255 + 0.5)
end

--- The most chroma sRGB can show at lightness `L` and hue `h`.
---@param L number 0..1
---@param h number degrees
---@return number
function M.max_chroma(L, h)
  local lo, hi = 0, 0.4
  for _ = 1, 20 do
    local mid = (lo + hi) / 2
    if in_gamut(oklch_to_linear(L, mid, h)) then
      lo = mid
    else
      hi = mid
    end
  end
  return lo
end

--- OKLCH -> "#rrggbb". `C` beyond the gamut is clipped to it.
---@param L number 0..1
---@param C number
---@param h number degrees
---@return string
function M.oklch(L, C, h)
  local r, g, b = oklch_to_linear(L, math.min(C, M.max_chroma(L, h)), h)
  return string.format("#%02x%02x%02x", encode(r), encode(g), encode(b))
end

return M
