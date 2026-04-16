return {
  {
    "nvim-mini/mini.snippets",
    opts = function(_, opts)
      local snippets = require("mini.snippets")
      local config_path = vim.fn.stdpath("config")

      opts.snippets = {
        snippets.gen_loader.from_file(config_path .. "/snippets/global.json"),
        snippets.gen_loader.from_lang(),
      }

      return opts
    end,
  },
}
