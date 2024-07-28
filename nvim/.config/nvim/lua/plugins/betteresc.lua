-- lua with lazy.nvim
return {
  'max397574/better-escape.nvim',
  config = function()
    require('better_escape').setup({
      mappings = {
        i = { n = { e = '<Esc>' } },
        c = { n = { e = '<Esc>' } },
        v = { n = { e = '<Esc>' } },
        t = { n = { e = '<Esc>' } },
        s = { n = { e = '<Esc>' } },
      },
    })
  end,
}
