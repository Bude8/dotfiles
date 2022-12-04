-----------------------------------------------------------
-- Define keymaps of Neovim and installed plugins.
-----------------------------------------------------------

local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Change leader to a space
vim.g.mapleader = ' '

-----------------------------------------------------------
-- Neovim shortcuts
-----------------------------------------------------------
-- Unmap <C-z>
map('', '<C-z>', '<nop>')

-- Paste hack
map('', '<leader>p', '\"_dP')

-- Clear search highlighting with <leader> and c
map('n', '<leader>c', ':noh<CR>')

-- Move around splits using Ctrl + {h,j,k,l}
map('', '<C-h>', '<C-w>h')
map('', '<C-j>', '<C-w>j')
map('', '<C-k>', '<C-w>k')
map('', '<C-l>', '<C-w>l')

-- Make split adjustments easier
map('', '<C-Left>', ':vertical resize +3<CR>')
map('', '<C-Right>', ':vertical resize -3<CR>')
map('', '<C-Up>', ':resize +3<CR>')
map('', '<C-Down>', ':resize +3<CR>')

-- Change split orientation
map('n', '<leader>tk', '<C-w>t<C-w>K') -- change vertical to horizontal
map('n', '<leader>th', '<C-w>t<C-w>H') -- change horizontal to vertical

-- Move around splits using Ctrl + {h,j,k,l}
map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')

-- Move around buffers using Shift + {h, l}
map('n', '<S-h>', ':bp<CR>')
map('n', '<S-l>', ':bn<CR>')

-- Swap to last buffer to Alt + \
map('n', '<M-Bslash>', '<C-^><CR>')

-- Reload configuration without restart nvim
map('n', '<leader>r', ':so %<CR>')

-- Fast saving with <leader> and s/w
map('n', '<leader>s', ':w<CR>')
map('n', '<leader>w', ':w<CR>')

-- Close all windows and exit from Neovim with <leader> and q
map('n', '<leader>q', ':qa!<CR>')

-----------------------------------------------------------
-- Applications and Plugins shortcuts
-----------------------------------------------------------

-- NvimTree
map('n', '<C-n>', ':NvimTreeToggle<CR>')            -- open/close
map('n', '<leader>f', ':NvimTreeRefresh<CR>')       -- refresh
map('n', '<leader>n', ':NvimTreeFindFile<CR>')      -- search file

-- FZF
map('n', '<C-f>', ':FZF<CR>')
map('n', '<leader>rg', ':Rg<CR>')

-- Undotree
map('n', '<F4>', ':UndotreeToggle<CR>')
