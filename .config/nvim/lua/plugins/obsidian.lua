return {
  "epwalsh/obsidian.nvim",
  version = "*",   -- Utilise la dernière version stable
  lazy = true,
  ft = "markdown", -- Ne charge le plugin que pour les fichiers Markdown
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    workspaces = {
      {
        name = "personnel",
        path = "~/Documents/cloud vault", -- Remplacez par le chemin de VOTRE Vault
      },
    },

    -- Optionnel : Configure le comportement des nouvelles notes
    new_notes_location = "current_dir",

    -- Optionnel : Personnalise le nom des fichiers créés (par défaut, il génère un ID unique)
    note_id_func = function(title)
      -- Si vous donnez un titre "Ma super note", le fichier sera "Ma-super-note.md"
      local suffix = ""
      if title ~= nil then
        suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
      else
        suffix = tostring(os.time())
      end
      return suffix
    end,
  },
}
