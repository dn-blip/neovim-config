---@brief Handles the installation, removal, and updating of Tree-sitter parsers, thanks to https://github.com/dzfrias/tree-sitter-dl/
---@brief I need to come back to this at some point and finish it.
local config = vim.fn.stdpath('config')
local scripts_dir = config .. 'scripts/'

local M = {}

---@param langs string[]
local install_parsers = function(langs) end
