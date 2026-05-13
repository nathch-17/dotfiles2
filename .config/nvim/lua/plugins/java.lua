return {
  "nvim-java/nvim-java",
  ft = "java",
  config = function()
    require("java").setup()
    require("lspconfig").jdtls.setup({})

    -- --- AJOUT DES RACCOURCIS POUR L'EXÉCUTION ---
    -- F5 pour Lancer / Debugger le code
    vim.keymap.set("n", "<F5>", function() require("dap").continue() end, { desc = "Lancer/Debug Java" })

    -- Shift+F5 pour arrêter l'exécution
    vim.keymap.set("n", "<S-F5>", function() require("dap").terminate() end, { desc = "Arrêter Java" })

    -- F9 pour mettre un point d'arrêt (Breakpoint) sur la ligne
    vim.keymap.set("n", "<F9>", function() require("dap").toggle_breakpoint() end, { desc = "Point d'arrêt" })


    -- Raccourci pour ouvrir le menu de génération (Getters, Setters, Equals, Constructeurs...)
    vim.keymap.set("n", "<leader>g", vim.lsp.buf.code_action, { desc = "Générer du code Java" })
  end
}
