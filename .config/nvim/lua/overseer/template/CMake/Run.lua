-- Добавить проверку если файлы нету - выполнить пустую команду
-- Переделать под LSP
return {
  name = "CMake Run",
  builder = function()
    local build_folder = vim.fn.getcwd() .. "/build/"
    local cmake_cache_file = build_folder .. "CMakeCache.txt"
    local search_pattern = "\"(?<=CMAKE_PROJECT_NAME:STATIC=)\\w+\""
    local command = string.format("grep -oP %s %s", search_pattern, cmake_cache_file)
    local result = vim.fn.system(command)
    return {
      cmd = { "./" .. result },
      cwd = build_folder,
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
