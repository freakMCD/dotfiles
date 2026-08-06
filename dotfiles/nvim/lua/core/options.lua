local options = {
  breakindent = true,
	expandtab = true, -- convert tabs to spaces
	shiftwidth = 2, -- the number of spaces inserted for each indentation
	tabstop = 2, -- insert 2 spaces for a tab
  softtabstop = 2,
	backup = false, -- creates a backup file
	completeopt = { "menuone", "noselect" }, -- mostly just for cmp
	pumheight = 10, -- pop up menu height
	mouse = "",
	showtabline = 0, -- never show tabs
	smartcase = true, -- smart case
	splitbelow = true, -- force all horizontal splits to go below current window
	splitright = true, -- force all vertical splits to go to the right of current window
	swapfile = false, -- creates a swapfile
	timeoutlen = 1000, -- time to wait for a mapped sequence to complete (in milliseconds)
	undofile = true, -- enable persistent undo
	number = true, -- set numbered lines
  scrolloff = 8,
  title = true,

  -- Status bar
	laststatus = 2,
  ruler = false,
  cmdheight = 1,
  showcmdloc = "statusline",
	signcolumn = "number",
}

for k, v in pairs(options) do
	vim.opt[k] = v
end

vim.opt.iskeyword:remove("_")
