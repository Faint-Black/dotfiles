-- TODO:  lsp-attach coding specific keybinds

-------------------------------------------------------------------------------
-- PACKAGE/PLUGIN CONFIGS
-------------------------------------------------------------------------------

-- Install package manager, if not installed already
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)



-- Set up and configure packages
local plugins = {
    {
        -- syntax highlighter
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function ()
            local configs = require("nvim-treesitter.configs")
            configs.setup({
                ensure_installed = { "lua", "vim", "vimdoc", "c", "cpp", "haskell", "zig" },
                sync_install = false,
                highlight = { enable = true },
                indent = { enable = true },
            })
        end
    },
    {
        -- github themed color scheme
        'projekt0n/github-nvim-theme',
        name = 'github-theme',
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            require('github-theme').setup({
                -- ...
            })
            vim.cmd('colorscheme github_dark_default')
        end,
    },
    {
        -- file tree explorer
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        }
    },
    {
        -- fuzzy file finder
        'nvim-telescope/telescope.nvim', tag = '0.1.8',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    {
        -- lsp package manager
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end
    },
    {
        -- lsp installer
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "clangd", "zls" }
            })
        end
    },
    {
        -- lsp configurer
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")
            -- manually add every language server below this point
            lspconfig.lua_ls.setup({})
            lspconfig.clangd.setup({})
            lspconfig.zls.setup({})
        end
    },
    {
        -- snippet provider
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp"
    },
    {
        -- auto-completion server
        "hrsh7th/nvim-cmp",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-path",
            "f3fora/cmp-spell",
            "hrsh7th/cmp-nvim-lsp-signature-help",
            "saadparwaiz1/cmp_luasnip",
            "lukas-reineke/cmp-under-comparator",
        },
        config = function()
            local kind_icons = {
                Text = "󰉿",
                Method = "󰆧",
                Function = "󰊕",
                Constructor = "",
                Field = "󰜢",
                Variable = "󰀫",
                Class = "󰠱",
                Interface = "",
                Module = "",
                Property = "󰜢",
                Unit = "󰑭",
                Value = "󰎠",
                Enum = "",
                Keyword = "󰌋",
                Snippet = "",
                Color = "󰏘",
                File = "󰈙",
                Reference = "󰈇",
                Folder = "󰉋",
                EnumMember = "",
                Constant = "󰏿",
                Struct = "󰙅",
                Event = "",
                Operator = "󰆕",
                TypeParameter = "",
            }
            local cmp = require("cmp")
            local cmplsp = require("cmp_nvim_lsp")
            local compare = require("cmp.config.compare")
            local luasnip = require("luasnip")
            cmplsp.setup()
            cmp.setup({
                preselect = false,
                completion = {
                    completeopt = "menu,menuone,preview,noselect",
                },
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                formatting = {
                    fields = { "abbr", "kind", "menu" },
                    format = function(entry, vim_item)
                        local kind = vim_item.kind
                        vim_item.kind = " " .. (kind_icons[kind] or "?") .. ""
                        local source = entry.source.name
                        vim_item.menu = "[" .. source .. "]"
                        return vim_item
                    end,
                },
                sorting = {
                    priority_weight = 1.0,
                    comparators = {
                        compare.offset,
                        compare.exact,
                        compare.score,
                        compare.recently_used,
                        require("cmp-under-comparator").under,
                        compare.kind,
                    },
                },
                matching = {
                    disallow_fuzzy_matching = true,
                    disallow_fullfuzzy_matching = true,
                    disallow_partial_fuzzy_matching = true,
                    disallow_partial_matching = false,
                    disallow_prefix_unmatching = true,
                },
                min_length = 1,
                mapping = cmp.mapping.preset.insert({
                    ["<CR>"] = cmp.mapping.confirm({ select = false }), -- do not select first item
                    ['<Down>'] = {
                        i = cmp.mapping.abort() -- only use TAB to select auto-completion option
                    },
                    ['<Up>'] = {
                        i = cmp.mapping.abort() -- only use TAB to select auto-completion option
                    },
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = {
                    { name = "luasnip", max_item_count = 3 },
                    { name = "nvim_lsp", max_item_count = 5 },
                    { name = "nvim_lua", max_item_count = 5 },
                    { name = "buffer", max_item_count = 5, keyword_length = 3 },
                    { name = "nvim_lsp_signature_help", max_item_count = 5 },
                    {
                        name = "spell",
                        max_item_count = 5,
                        keyword_length = 3,
                        option = {
                            keep_all_entries = false,
                            enable_in_context = function()
                                return true
                            end,
                        },
                    },
                },
                performance = {
                    max_view_entries = 20,
                },
                window = {
                    documentation = {
                        border = 'rounded',
                        winhighlight = 'Normal:StatusLine,FloatBorder:StatusLine,CursorLine:Visual,Search:None'
                    },
                    completion = {
                        border = 'rounded',
                        winhighlight = 'Normal:StatusLine,FloatBorder:StatusLine,CursorLine:Visual,Search:None'
                    }
                },
            })
            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path" },
                }, {
                    { name = "cmdline" },
                }),
                matching = { disallow_symbol_nonprefix_matching = false },
            })
        end,
    }
}
require("lazy").setup(plugins, {})



-------------------------------------------------------------------------------
-- KEYMAP/BINDINGS CONFIGS
-------------------------------------------------------------------------------

-- Unbindings
vim.api.nvim_set_keymap('n', '<C-b>', '<nop>', { noremap = true, silent = true }) -- unbind Ctrl+b
vim.api.nvim_set_keymap('n', '<C-f>', '<nop>', { noremap = true, silent = true }) -- unbind Ctrl+f

-- Bindings
vim.keymap.set('n', '<C-b>', ':Neotree filesystem toggle left<CR>', {}) -- Ctrl+b to open file tree in side bar
vim.keymap.set('n', '<C-f>', ':Telescope find_files<CR>', {})           -- Ctrl+f to search/find file
vim.keymap.set('n', '<C-k>', vim.lsp.buf.hover, {})                     -- Ctrl+k to show hovered function documentation



-------------------------------------------------------------------------------
-- VIM CONFIGS
-------------------------------------------------------------------------------

-- Aesthetics
vim.cmd ([[
highlight MatchParen   guibg=none    guifg=#fc9803 gui=bold,underline
highlight WinSeparator guifg=#111122 guibg=#202030
highlight Normal       guibg=#111111
highlight LineNr       guibg=#202020 guifg=#555555
highlight CursorLineNr guibg=#383838 guifg=#909090 gui=bold,italic
highlight CursorLine   guibg=#1d1d1d
highlight EndOfBuffer  guibg=#141414 guifg=#662222
highlight StatusLine   guibg=#202030 guifg=#8888cc gui=bold,italic
highlight MsgArea      guifg=#ffffff guibg=#111122
]])

-- Basic settings
vim.opt.cursorline = true
vim.opt.cursorlineopt = number
vim.opt.mouse = ''
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true
vim.opt.wrap = true
vim.opt.linebreak = true
vim.o.scrolloff = 4

-- Custom commands
vim.cmd ([[
command! TrimTrailingWhitespaces %s/\s\+$//e | noh
]])

