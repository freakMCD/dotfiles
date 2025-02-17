local options = {
	expandtab = true, -- convert tabs to spaces
	shiftwidth = 2, -- the number of spaces inserted for each indentation
	tabstop = 2, -- insert 2 spaces for a tab
    softtabstop = 2,
	backup = false, -- creates a backup file
	completeopt = { "menuone", "noselect" }, -- mostly just for cmp
	pumheight = 10, -- pop up menu height
	mouse = "",
	showtabline = 0, -- always show tabs
	smartcase = true, -- smart case
	splitbelow = true, -- force all horizontal splits to go below current window
	splitright = true, -- force all vertical splits to go to the right of current window
	swapfile = false, -- creates a swapfile
	timeoutlen = 1000, -- time to wait for a mapped sequence to complete (in milliseconds)
	undofile = true, -- enable persistent undo
	number = true, -- set numbered lines
	laststatus = 0,
	ruler = true,
	signcolumn = "number", -- always show the sign column, otherwise it would shift the text each time
	scrolloff = 8,                           -- is one of my fav
	spellang = en_us,
    title = true,
}

vim.opt.fillchars:append({ eob = " ", stl = " " })
vim.opt.shortmess:append("c")

for k, v in pairs(options) do
	vim.opt[k] = v
end

vim.cmd[[ 
    colorscheme gruvbox
    highlight Normal ctermbg=NONE guibg=NONE
    highlight LineNr guibg=NONE
]]

function GetIndicators()
	local counts = vim.diagnostic.count()
	local errors = counts[vim.diagnostic.severity.ERROR] or 0
	local warnings = counts[vim.diagnostic.severity.WARN] or 0
	local warn_string = warnings > 0 and "%#DiagnosticWarn# " or "  "
	local error_string = errors > 0 and "%#DiagnosticError# " or "  "
	return warn_string .. error_string
end
function GetRulerIcon()
	local icon = vim.bo.modified and " " or " "
	return "%#CustomRulerSeparator#%#CustomRulerIcon#" .. icon .. " "
end
vim.opt.rulerformat = "%40(%=%{%v:lua.GetIndicators()%}%{%v:lua.GetRulerIcon()%}%#CustomRulerFile# %t %)"

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "sh", "nix" },
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.softtabstop = 2
    end,
})

