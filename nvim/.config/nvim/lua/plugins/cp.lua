return {
  {
    "xeluxee/competitest.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    config = function()
      local fn = vim.fn
      local uv = vim.uv or vim.loop

      local practice_root = fn.expand("~/Projects/cp/CP_Nvim/practice")
      local contest_root = fn.expand("~/Projects/cp/CP_Nvim/contests")

      local practice_state_file = fn.stdpath("state") .. "/cp_practice_target.txt"
      local contest_state_file = fn.stdpath("state") .. "/cp_contest_target.txt"
      local practice_lang_file = fn.stdpath("state") .. "/cp_practice_lang.txt"
      local contest_lang_file = fn.stdpath("state") .. "/cp_contest_lang.txt"

      local function ensure_dir(path)
        fn.mkdir(path, "p")
      end

      local function read_file(path)
        local f = io.open(path, "r")
        if not f then
          return nil
        end
        local s = f:read("*a")
        f:close()
        if not s or s == "" then
          return nil
        end
        return vim.trim(s)
      end

      local function write_file(path, content)
        ensure_dir(fn.fnamemodify(path, ":h"))
        local f = assert(io.open(path, "w"))
        f:write(content)
        f:close()
      end

      local function clear_file(path)
        os.remove(path)
      end

      local function slugify(s)
        s = s or "default"
        s = s:gsub("[^%w%-_]+", "_"):gsub("^_+", ""):gsub("_+$", "")
        if s == "" then
          s = "default"
        end
        return s
      end

      local function open_dir(path)
        ensure_dir(path)
        vim.cmd("edit " .. fn.fnameescape(path))
      end

      local function norm_lang(lang)
        if not lang or lang == "" then
          return nil
        end
        lang = lang:lower()
        if lang == "cpp" or lang == "c++" or lang == "cc" then
          return "cpp"
        end
        if lang == "java" then
          return "java"
        end
        return nil
      end

      local function lang_to_ext(lang)
        if lang == "java" then
          return "java"
        end
        return "cpp"
      end

      local function lang_to_filename(lang)
        if lang == "java" then
          return "Main.java"
        end
        return "main.cpp"
      end

      local function get_bucket(kind)
        local file = (kind == "practice") and practice_state_file or contest_state_file
        return read_file(file)
      end

      local function get_lang(kind)
        local file = (kind == "practice") and practice_lang_file or contest_lang_file
        return read_file(file) or "java"
      end

      local function set_bucket(kind, name)
        local file = (kind == "practice") and practice_state_file or contest_state_file
        local root = (kind == "practice") and practice_root or contest_root
        local label = (kind == "practice") and "Practice session" or "Contest bucket"

        name = slugify(name)
        local dir = root .. "/" .. name
        ensure_dir(dir)
        write_file(file, name)
        vim.notify(label .. " -> " .. name)
        open_dir(dir)
        return dir
      end

      local function set_lang(kind, lang)
        lang = norm_lang(lang)
        if not lang then
          vim.notify("Supported languages: java, cpp", vim.log.levels.ERROR)
          return nil
        end
        local file = (kind == "practice") and practice_lang_file or contest_lang_file
        local label = (kind == "practice") and "Practice language" or "Contest language"
        write_file(file, lang)
        vim.notify(label .. " -> " .. lang)
        return lang
      end

      local function clear_harpoon_list(list)
        local ok, len = pcall(function()
          return list:length()
        end)
        if not ok then
          return
        end
        for i = len, 1, -1 do
          pcall(function()
            list:remove_at(i)
          end)
        end
      end

      local function problem_sort_key(path)
        local name = fn.fnamemodify(path, ":h:t"):upper()

        local letter = name:match("^([A-Z])$")
        if letter then
          return 0, letter
        end

        local number = tonumber(name:match("^(%d+)$"))
        if number then
          return 1, number
        end

        local letter_num_l, letter_num_n = name:match("^([A-Z])([0-9]+)$")
        if letter_num_l and letter_num_n then
          return 2, letter_num_l .. string.format("%04d", tonumber(letter_num_n))
        end

        return 3, name
      end

      local function list_problem_files(dir)
        local files = {}
        local add = function(pattern)
          local got = fn.globpath(dir, pattern, false, true)
          for _, f in ipairs(got) do
            table.insert(files, f)
          end
        end

        add("*/Main.java")
        add("*/main.cpp")
        add("*/*.java")
        add("*/*.cpp")

        table.sort(files, function(a, b)
          local ga, ka = problem_sort_key(a)
          local gb, kb = problem_sort_key(b)
          if ga ~= gb then
            return ga < gb
          end
          return ka < kb
        end)

        return files
      end

      local function refresh_harpoon_for_contest(dir)
        local ok, harpoon = pcall(require, "harpoon")
        if not ok then
          vim.notify("Harpoon is not available.", vim.log.levels.ERROR)
          return
        end

        local list = harpoon:list()
        local files = list_problem_files(dir)
        clear_harpoon_list(list)

        for _, file in ipairs(files) do
          list:append({ value = fn.fnamemodify(file, ":p") })
        end

        vim.notify("Harpoon updated: " .. #files .. " file(s)")
      end

      vim.api.nvim_create_user_command("CPSession", function(opts)
        local args = vim.split(opts.args, "%s+", { trimempty = true })
        if #args < 1 then
          vim.notify("Usage: :CPSession <name> [java|cpp]", vim.log.levels.ERROR)
          return
        end
        set_bucket("practice", args[1])
        if args[2] then
          set_lang("practice", args[2])
        end
      end, { nargs = "+" })

      vim.api.nvim_create_user_command("CPContest", function(opts)
        local args = vim.split(opts.args, "%s+", { trimempty = true })
        if #args < 1 then
          vim.notify("Usage: :CPContest <name> [java|cpp]", vim.log.levels.ERROR)
          return
        end
        set_bucket("contest", args[1])
        if args[2] then
          set_lang("contest", args[2])
        end
      end, { nargs = "+" })

      vim.api.nvim_create_user_command("CPPracticeLang", function(opts)
        set_lang("practice", opts.args)
      end, { nargs = 1 })

      vim.api.nvim_create_user_command("CPContestLang", function(opts)
        set_lang("contest", opts.args)
      end, { nargs = 1 })

      vim.api.nvim_create_user_command("CPSessionShow", function()
        vim.notify(
          "Practice -> bucket=" .. (get_bucket("practice") or "not set")
          .. " lang=" .. get_lang("practice")
        )
      end, {})

      vim.api.nvim_create_user_command("CPContestShow", function()
        vim.notify(
          "Contest -> bucket=" .. (get_bucket("contest") or "not set")
          .. " lang=" .. get_lang("contest")
        )
      end, {})

      vim.api.nvim_create_user_command("CPSessionClear", function()
        clear_file(practice_state_file)
        clear_file(practice_lang_file)
        vim.notify("Practice session cleared")
      end, {})

      vim.api.nvim_create_user_command("CPContestClear", function()
        clear_file(contest_state_file)
        clear_file(contest_lang_file)
        vim.notify("Contest bucket cleared")
      end, {})

      vim.api.nvim_create_user_command("CPHarpoonContest", function()
        local active = get_bucket("contest")
        if not active then
          vim.notify("No active contest bucket. Use :CPContest <name> first.", vim.log.levels.ERROR)
          return
        end
        refresh_harpoon_for_contest(contest_root .. "/" .. active)
      end, {})

      vim.api.nvim_create_user_command("CPReceiveContest", function()
        local active = get_bucket("contest")
        if not active then
          vim.notify("No active contest bucket. Use :CPContest <name> first.", vim.log.levels.ERROR)
          return
        end

        local dir = contest_root .. "/" .. active
        ensure_dir(dir)

        vim.cmd("CompetiTest receive contest")

        local group = vim.api.nvim_create_augroup("CPContestReceiveHarpoon", { clear = true })
        local timer = uv.new_timer()
        local done = false

        local function finish()
          if done then
            return
          end
          local files = list_problem_files(dir)
          if #files == 0 then
            return
          end
          done = true
          refresh_harpoon_for_contest(dir)
          pcall(vim.api.nvim_del_augroup_by_name, "CPContestReceiveHarpoon")
          if timer then
            timer:stop()
            timer:close()
            timer = nil
          end
        end

        vim.api.nvim_create_autocmd({ "BufAdd", "BufNewFile", "BufReadPost" }, {
          group = group,
          callback = function(ev)
            local path = fn.fnamemodify(ev.file, ":p")
            local root = fn.fnamemodify(dir, ":p")
            if vim.startswith(path, root) then
              vim.defer_fn(finish, 200)
            end
          end,
        })

        timer:start(500, 500, vim.schedule_wrap(function()
          finish()
        end))

        vim.defer_fn(function()
          if done then
            return
          end
          pcall(vim.api.nvim_del_augroup_by_name, "CPContestReceiveHarpoon")
          if timer then
            timer:stop()
            timer:close()
            timer = nil
          end
        end, 15000)
      end, {})

      require("competitest").setup({
        runner_ui = {
          interface = "split",
        },
        split_ui = {
          position = "bottom",
          relative_to_editor = true,
          total_height = 0.35,
          horizontal_layout = {
            { 2, "tc" },
            { 3, { { 1, "so" }, { 1, "si" } } },
            { 3, { { 1, "eo" }, { 1, "se" } } },
          },
        },

        save_current_file = true,
        save_all_files = false,

        compile_directory = ".",
        compile_command = {
          cpp = { exec = "g++", args = { "-std=c++20", "-O2", "-DLOCAL", "$(FNAME)", "-o", "$(FNOEXT)" } },
          java = { exec = "javac", args = { "$(FNAME)" } },
        },

        running_directory = ".",
        run_command = {
          cpp = { exec = "./$(FNOEXT)" },
          java = { exec = "java", args = { "-DLOCAL=true", "$(FNOEXT)" } },
        },

        multiple_testing = 3,
        maximum_time = 4000,
        output_compare_method = "squish",
        view_output_diff = true,

        testcases_directory = ".",
        testcases_use_single_file = false,
        testcases_auto_detect_storage = true,

        companion_port = 27121,
        receive_print_message = true,
        start_receiving_persistently_on_setup = false,

        template_file = {
          cpp = vim.fn.stdpath("config") .. "/templates/cp/main.cpp",
          java = vim.fn.stdpath("config") .. "/templates/cp/Main.java",
        },
        evaluate_template_modifiers = true,

        -- only a fallback; real extension choice is made in the path functions
        received_files_extension = "java",

        received_problems_path = function(task, _file_extension)
          local session = get_bucket("practice") or "default"
          local lang = get_lang("practice")
          local filename = lang_to_filename(lang)

          local problem_dir = string.format(
            "%s/%s/%s",
            practice_root,
            session,
            slugify(task.name or "problem")
          )
          ensure_dir(problem_dir)
          return problem_dir .. "/" .. filename
        end,
        received_problems_prompt_path = false,

        received_contests_directory = function(task, _file_extension)
          local active = get_bucket("contest")
          local bucket = active or slugify(task.group or task.name or "contest")
          local dir = contest_root .. "/" .. bucket
          ensure_dir(dir)
          return dir
        end,

        received_contests_problems_path = function(task, _file_extension)
          local lang = get_lang("contest")
          return slugify(task.name or "problem") .. "/" .. lang_to_filename(lang)
        end,
        received_contests_prompt_directory = false,
        received_contests_prompt_extension = false,

        open_received_problems = true,
        open_received_contests = true,
        replace_received_testcases = false,
      })

      vim.keymap.set("n", "<leader>rrp", "<cmd>CompetiTest receive problem<cr>", { desc = "Receive practice problem" })
      vim.keymap.set("n", "<leader>rrC", "<cmd>CPReceiveContest<cr>", { desc = "Receive contest" })
      vim.keymap.set("n", "<leader>rrP", "<cmd>CompetiTest receive persistently<cr>", { desc = "Receive persistently" })
      vim.keymap.set("n", "<leader>rrx", "<cmd>CompetiTest receive stop<cr>", { desc = "Stop receive" })

      vim.keymap.set("n", "<leader>rrt", "<cmd>CompetiTest run<cr>", { desc = "Run tests" })
      vim.keymap.set("n", "<leader>rrT", "<cmd>CompetiTest run_no_compile<cr>", { desc = "Run tests no compile" })
      vim.keymap.set("n", "<leader>rra", "<cmd>CompetiTest add_testcase<cr>", { desc = "Add testcase" })
      vim.keymap.set("n", "<leader>rre", "<cmd>CompetiTest edit_testcase<cr>", { desc = "Edit testcase" })
      vim.keymap.set("n", "<leader>rrd", "<cmd>CompetiTest delete_testcase<cr>", { desc = "Delete testcase" })
      vim.keymap.set("n", "<leader>rrH", "<cmd>CPHarpoonContest<cr>", { desc = "Refresh Harpoon from contest" })

      vim.keymap.set("n", "<leader>rrs", function()
        vim.cmd("write")
        if vim.fn.executable("cpb") == 0 then
          vim.notify("cpb not found. Install cpbooster first.", vim.log.levels.ERROR)
          return
        end
        vim.cmd("botright 12split")
        vim.cmd("terminal cpb submit " .. vim.fn.shellescape(vim.fn.expand("%:p")))
        vim.cmd("startinsert")
      end, { desc = "Submit current file" })
    end,
  },
}
