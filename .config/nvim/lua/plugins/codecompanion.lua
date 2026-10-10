return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  cmd = {
    "CodeCompanion",
    "CodeCompanionChat",
    "CodeCompanionActions",
    "CodeCompanionCmd",
  },
  keys = {
    { "<leader>cc", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "CodeCompanion Chat" },
    { "<leader>ca", "<cmd>CodeCompanionActions<cr>",     mode = { "n", "v" }, desc = "CodeCompanion Actions" },
    { "<leader>ce", ":CodeCompanion /explain<cr>",       mode = "v",          desc = "CodeCompanion Explain" },
  },
  config = function()
    local secrets = require("utils.secrets")
    -- Pense à créer ce fichier et à y mettre ta clé API Google Gemini
    local gemini_key = secrets.read("~/.config/gemini/api_key")

    require("codecompanion").setup({
      adapters = {
        gemini = function()
          return require("codecompanion.adapters").extend("gemini", {
            env = {
              api_key = gemini_key,
            },
            -- Optionnel : Tu peux forcer un modèle spécifique ici (ex: gemini-1.5-pro)
            -- schema = {
            --   model = {
            --     default = "gemini-1.5-flash",
            --   },
            -- },
          })
        end,
      },
      strategies = {
        chat   = { adapter = "gemini" },
        inline = { adapter = "gemini" },
        agent  = { adapter = "gemini" },
      },
    })
  end,
}
