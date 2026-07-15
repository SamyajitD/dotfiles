return {
  {
    "xeluxee/competitest.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("competitest").setup({
        runner_ui = {
          interface = "split",
        },
        split_ui = {
          position = "bottom",
          total_height = 0.35,
        },
        save_current_file = true,
        save_all_files = false,
        testcases_use_single_file = false,
        testcases_auto_detect_storage = true,
        companion_port = 27121,
        received_problems_path = "$(HOME)/Projects/cp/$(JUDGE)/$(CONTEST)/$(PROBLEM).$(FEXT)",
        received_contests_directory = "$(HOME)/Projects/cp/$(JUDGE)/$(CONTEST)",
        received_contests_problems_path = "$(PROBLEM)/$(JAVA_TASK_CLASS).$(FEXT)",
      })
    end,
    keys = {
      { "<leader>za", "<cmd>CompetiTest add_testcase<cr>",    desc = "Add testcase" },
      { "<leader>ze", "<cmd>CompetiTest edit_testcase<cr>",   desc = "Edit testcase" },
      { "<leader>zd", "<cmd>CompetiTest delete_testcase<cr>", desc = "Delete testcase" },
      { "<leader>zt", "<cmd>CompetiTest run<cr>",             desc = "Run testcases" },
      { "<leader>zT", "<cmd>CompetiTest run_no_compile<cr>",  desc = "Run no compile" },
      { "<leader>zp", "<cmd>CompetiTest receive problem<cr>", desc = "Receive problem" },
      { "<leader>zC", "<cmd>CompetiTest receive contest<cr>", desc = "Receive contest" },
      { "<leader>zS", "<cmd>CompetiTest show_ui<cr>",         desc = "Show testcase UI" },
    },
  },
}
