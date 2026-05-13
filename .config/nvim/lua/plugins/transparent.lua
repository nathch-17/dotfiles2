return {
  "xiyaowong/transparent.nvim",
  config = function()
    require("transparent").setup({
      extra_groups = {
        "NormalFloat", "NvimTreeNormal" -- Ajoutez ici les éléments que vous voulez rendre transparents
      },
    })
  end
}
