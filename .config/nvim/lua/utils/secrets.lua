local M = {}

---Lit un secret depuis un fichier
---@param path string Chemin du fichier (supporte ~)
---@return string|nil
function M.read(path)
  path = vim.fn.expand(path)
  local file = io.open(path, "r")
  if not file then
    vim.notify("Secret introuvable : " .. path, vim.log.levels.WARN)
    return nil
  end
  local content = file:read("*a"):gsub("%s+$", "")
  file:close()
  return content
end

return M
