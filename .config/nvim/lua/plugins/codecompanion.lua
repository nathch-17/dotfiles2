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
    local mammouth_key = secrets.read("~/.config/mammouth/api_key")

    require("codecompanion").setup({
      adapters = {
        http = {
          mammouth = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              env = {
                url = "https://api.mammouth.ai",
                api_key = mammouth_key,
                chat_url = "/v1/chat/completions",
              },
              schema = {
                model = {
                  default = "gpt-4.1",
                },
              },
            })
          end,
        },
      },
      strategies = {
        chat   = { adapter = "mammouth" },
        inline = { adapter = "mammouth" },
        agent  = { adapter = "mammouth" },
      },
    })
  end,
}
