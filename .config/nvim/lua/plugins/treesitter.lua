return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    -- On utilise pcall pour éviter le crash si le plugin est absent
    local status_ok, configs = pcall(require, "nvim-treesitter.configs")
    if not status_ok then
      vim.notify("Treesitter est en cours d'installation, redémarrez Neovim après.", vim.log.levels.WARN)
      return
    end

    configs.setup({
      ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "java" },
      highlight = {
        enable = true,
      },
    })
  end,
}
