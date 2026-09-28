local M = {}

M.modules = { "editor", "syntax", "plugins" }

---@param c table colours from folio.palette
---@param config FolioConfig
---@return table<string, vim.api.keyset.highlight>
function M.get(c, config)
  local hl = {}
  for _, name in ipairs(M.modules) do
    require("folio.groups." .. name)(hl, c, config)
  end
  if config.on_highlights then
    config.on_highlights(hl, c)
  end
  return hl
end

return M
