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
	showtabline = 0, -- always show tabs
	smartcase = true, -- smart case
	splitbelow = true, -- force all horizontal splits to go below current window
	splitright = true, -- force all vertical splits to go to the right of current window
	swapfile = false, -- creates a swapfile
	timeoutlen = 1000, -- time to wait for a mapped sequence to complete (in milliseconds)
	undofile = true, -- enable persistent undo
	number = true, -- set numbered lines
  scrolloff = 8,                           -- is one of my fav
	spelllang = en_us,
  title = true,

  -- Status bar
	laststatus = 2,
  ruler = false,
  cmdheight = 0,
  showcmdloc = "statusline",
	signcolumn = "number",
}

for k, v in pairs(options) do
	vim.opt[k] = v
end

vim.opt.iskeyword:remove("_")

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local indicators = { error = 0, warn = 0 }

autocmd("DiagnosticChanged", {
    callback = function()
        local counts = vim.diagnostic.count()
        indicators.error = counts[vim.diagnostic.severity.ERROR] or 0
        indicators.warn = counts[vim.diagnostic.severity.WARN] or 0
    end,
})

function GetIndicators()
    local warn_string = indicators.warn > 0 and "%#DiagnosticWarn# " or "  "
    local error_string = indicators.error > 0 and "%#DiagnosticError# " or "  "
    return warn_string .. error_string
end
function GetModifiedIcon()
	local icon = vim.bo.modified and " " or " "
	return icon
end

autocmd("FileType", {
    pattern = { "sh", "nix" },
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.softtabstop = 2
    end,
})

local group = augroup("vimrc_incsearch_highlight", { clear = true })

autocmd("CmdlineEnter", {
    pattern = { "/", "\\?" },
    group = group,
    command = "set hlsearch",
})

autocmd("CmdlineLeave", {
    pattern = { "/", "\\?" },
    group = group,
    command = "set nohlsearch",
})

function FormatUndotree()
  local undotree = vim.fn.undotree()
  local formatted = {}

  -- Convert Unix timestamps to readable format
  local function format_time(timestamp)
    return os.date("%Y-%m-%d %H:%M:%S", timestamp)
  end

  -- Recursively format entries and their alternatives
  local function process_entries(entries)
    local result = {}
    for _, entry in ipairs(entries) do
      local formatted_entry = {
        seq = entry.seq,
        time = format_time(entry.time),
        newhead = entry.newhead or false
      }
      if entry.alt then
        formatted_entry.alt = process_entries(entry.alt)
      end
      table.insert(result, formatted_entry)
    end
    return result
  end

  -- Build final formatted output
  formatted.seq_cur = undotree.seq_cur
  formatted.time_cur = format_time(undotree.time_cur)
  formatted.entries = process_entries(undotree.entries)

  print(vim.inspect(formatted))
end
