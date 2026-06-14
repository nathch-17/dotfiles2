return {
  'everviolet/nvim',
  name = 'evergarden',
  priority = 1, -- Colorscheme plugin is loaded first before any other plugins
  opts = {
    theme = {
      variant = 'summer', -- 'winter'|'fall'|'spring'|'summer'
      accent = 'green',
    },
    editor = {
      transparent_background = true,
      sign = { color = 'none' },
      float = {
        color = 'mantle',
        solid_border = false,
      },
      completion = {
        color = 'surface0',
      },
    },
  }
}
