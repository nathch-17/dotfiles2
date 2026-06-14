return {
  "nvim-java/nvim-java",
  ft = "java",
  config = function()
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    require("java").setup({
      jdtls = {
        capabilities = capabilities,
      },
    })

    -- --- KEYMAPS JAVA ---

    vim.keymap.set("n", "<F5>", function()
      require("dap").continue()
    end, { desc = "Lancer/Debug Java" })

    vim.keymap.set("n", "<S-F5>", function()
      require("dap").terminate()
    end, { desc = "Stop Java" })

    vim.keymap.set("n", "<F9>", function()
      require("dap").toggle_breakpoint()
    end, { desc = "Breakpoint" })

    vim.keymap.set("n", "<leader>g", function()
      vim.lsp.buf.code_action({ apply = true })
    end, { desc = "Code Action (auto import etc)" })
  end,
}
