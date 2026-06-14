return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  lazy = false,

  config = function()
    -- 1. LE FILET DE SÉCURITÉ (empêche le crash si le dossier est absent)
    local ok, treesitter = pcall(require, "nvim-treesitter.configs")
    if not ok then
      return -- On coupe court sans planter pour laisser Lazy télécharger
    end

    -- 2. LA CONFIGURATION
    treesitter.setup({
      ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "java" },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
    })

    -- 3. LE CONTOURNEMENT NATIF (pour forcer tes couleurs)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "c", "cpp", "lua", "java" },
      callback = function(args)
        -- On force l'activation de Treesitter après un micro-délai
        vim.defer_fn(function()
          pcall(vim.treesitter.start, args.buf)
        end, 100)
      end,
    })
  end,
}
