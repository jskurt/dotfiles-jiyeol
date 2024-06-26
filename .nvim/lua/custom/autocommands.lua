vim.cmd [[
  augroup _markdown
    autocmd!
    autocmd FileType markdown nmap <buffer> <Space> :VimwikiToggleListItem<CR>
    autocmd FileType markdown vmap <buffer> <Space> :VimwikiToggleListItem<CR>
  augroup end
]]

local function is_in_xxx_directory(directoryName, filePath)
  local pattern = "^(.-/?)" .. directoryName .. "/.+%.md$"

  return string.match(filePath, pattern) ~= nil
end

local function get_xxx_directory(directoryName, filePath)
  local pattern = "(.-" .. directoryName .. ")/"
  local match = string.match(filePath, pattern)
  if match then
    -- Return the match including 'xxx'
    return match
  else
    -- Return nil if 'xxx' is not found in the path
    return nil
  end
end

local buf_hash = {}

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  callback = function()
    local filepath = vim.api.nvim_buf_get_name(0)

    if is_in_xxx_directory("vimwiki", filepath) then
      local vimwiki_root = get_xxx_directory("vimwiki", filepath)
      -- Set current directory to vimwiki root
      vim.api.nvim_set_current_dir(vimwiki_root)
    elseif is_in_xxx_directory("dotfiles", filepath) then
      local dotfiles_root = get_xxx_directory("dotfiles", filepath)
      -- Set current directory to dotfiles root
      vim.api.nvim_set_current_dir(dotfiles_root)
    else
      local bufnr = vim.api.nvim_get_current_buf()
      local current_dir = vim.fn.getcwd()

      if buf_hash[bufnr] ~= nil then
        if buf_hash[bufnr] ~= current_dir then
          -- Set current directory to saved directory
          vim.api.nvim_set_current_dir(buf_hash[bufnr])
        end
      else
        buf_hash[bufnr] = current_dir
      end
    end
  end,
})
