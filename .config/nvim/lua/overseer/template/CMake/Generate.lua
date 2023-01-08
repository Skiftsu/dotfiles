-- Переделать под LSP
return {
  name = "CMake Generate",
  builder = function()
    local root_dir = vim.fn.getcwd()
    local stat = vim.loop.fs_stat('build')
    if not stat then
      vim.loop.fs_mkdir('build', tonumber('755', 8))
      print("The Build folder has been created")
    end
    return {
      cmd = { "cmake" },
      args = { ".." },
      cwd = root_dir .. "/build",
      components = {
        { "on_exit_set_status" },
        { "unique",            replace = false },
      }
    }
  end,
  condition = {
    callback = function(search)
      local cmake_file = vim.fn.findfile(vim.fn.getcwd() .. "/CMakeLists.txt")
      return not (cmake_file == "")
    end,
  },
}
