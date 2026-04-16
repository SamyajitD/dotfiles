-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local function open_term_and_run(cmd)
  vim.cmd("botright 12split")
  vim.cmd("terminal")
  local job = vim.b.terminal_job_id
  if job then
    vim.api.nvim_chan_send(job, cmd .. "\n")
  end
  vim.cmd("startinsert")
end

local function run_current_file()
  vim.cmd("write")
  local ft = vim.bo.filetype
  local dir = vim.fn.expand("%:p:h")
  local file = vim.fn.expand("%:t")
  local stem = vim.fn.expand("%:t:r")

  local cmd
  if ft == "java" then
    cmd = "cd " .. vim.fn.shellescape(dir)
        .. " && javac " .. vim.fn.shellescape(file)
        .. " && java " .. stem
  elseif ft == "cpp" then
    cmd = "cd " .. vim.fn.shellescape(dir)
        .. " && g++ -std=c++20 -O2 -Wall -Wextra -o " .. stem .. " " .. vim.fn.shellescape(file)
        .. " && ./" .. stem
  elseif ft == "c" then
    cmd = "cd " .. vim.fn.shellescape(dir)
        .. " && gcc -O2 -Wall -Wextra -o " .. stem .. " " .. vim.fn.shellescape(file)
        .. " && ./" .. stem
  elseif ft == "python" then
    cmd = "cd " .. vim.fn.shellescape(dir)
        .. " && python3 " .. vim.fn.shellescape(file)
  else
    vim.notify("No run command configured for filetype: " .. ft, vim.log.levels.WARN)
    return
  end

  open_term_and_run(cmd)
end

vim.keymap.set("n", "<leader>zr", run_current_file, { desc = "Run current file" })
vim.keymap.set("n", "<leader>zc", "<cmd>write<cr>", { desc = "Save file" })
vim.keymap.set("n", "<leader>zn", "<cmd>enew<cr>", { desc = "New scratch buffer" })
