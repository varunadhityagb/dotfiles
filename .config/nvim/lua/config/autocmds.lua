-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
local theme_file = vim.fn.stdpath("config") .. "/lua/plugins/matugen.lua"
local last_mtime = nil

vim.api.nvim_create_autocmd("FocusGained", {
  callback = function()
    local stat = vim.loop.fs_stat(theme_file)
    if stat and (not last_mtime or stat.mtime.sec > last_mtime) then
      last_mtime = stat.mtime.sec
      vim.cmd("colorscheme matugen")
    end
  end,
})
