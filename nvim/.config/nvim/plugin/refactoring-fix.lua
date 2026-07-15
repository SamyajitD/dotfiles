return {
  {
    "lewis6991/async.nvim",
    lazy = false,
    priority = 1000,
  },

  {
    "ThePrimeagen/refactoring.nvim",
    lazy = false,
    dependencies = {
      "lewis6991/async.nvim",
    },
    opts = {},
  },
}
