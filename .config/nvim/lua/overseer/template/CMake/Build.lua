-- Переделать под LSP
return {
  name = "CMake Build",
  builder = function()
    local root_dir = vim.fn.getcwd()
    local stat = vim.loop.fs_stat('build')
    if not stat then
      return {
        cmd = "echo Build folder not found. Generate CMake files.",
        components = {
          { "on_exit_set_status" },
          { "unique",            replace = false },
        }
      }
    end
    return {
      cmd = { "cmake" },
      args = { "--build", "." },
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
