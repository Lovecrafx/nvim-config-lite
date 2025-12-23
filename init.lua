--[[
  Neovim 配置主入口
  加载基础设置、键位映射和插件管理器
--]]

-- 加载基础配置
require("config.options")
require("config.keymaps")
require("config.autocmds")

-- 加载插件管理
require("config.lazy")
