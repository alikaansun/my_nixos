-- luaConfigRC.datFileType
vim.filetype.add({
  extension = {
    dat = "csv",
  },
})

-- luaConfigRC.autoSave
vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave", "WinLeave" }, {
  command = "silent! wall",
})
