require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'horizon',
    -- nightfly
  },
  sections = {
    lualine_a = {
      {
        'filename',
        path = 1,
      }
    },
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {},
    lualine_x = {'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  }
}
