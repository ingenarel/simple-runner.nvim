local m = {}

function m.openFloatingTerm(command)
	---@type integer
	local win_width = math.floor(vim.o.columns / 100 * m.widthPercentage)
	---@type integer
	local win_height = math.floor(vim.o.lines / 100 * m.heightPercentage)
	---@type integer
	local bufID = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_open_win(bufID, true, {
		relative = "editor",
		width = win_width,
		height = win_height,
		col = math.floor((vim.o.columns - win_width - 2) / 2),
		row = math.floor((vim.o.lines - win_height - 2) / 2),
		border = "rounded",
		style = "minimal",
	})
	vim.cmd.term(command)
end

function m.setup(opts)
	m.heightPercentage = opts.heightPercentage
	m.widthPercentage = opts.widthPercentage
	m.browser = opts.browser

	if m.heightPercentage == nil then
		m.heightPercentage = 70
	end
	if m.widthPercentage == nil then
		m.widthPercentage = 80
	end

	-- TODO: make a function for autoselecting the browser
end

function m.run()
	local currentFiletype = vim.bo.filetype

	vim.cmd("w")

	local fileWithExtension = vim.fn.expand("%:p")
	local fileWithoutExtension = vim.fn.fnamemodify(fileWithExtension, ":r")

	local execute = {
		python = function()
			m.openFloatingTerm('python "' .. fileWithExtension .. '"')
		end,
		sh = function()
			m.openFloatingTerm('"' .. fileWithExtension .. '"')
		end,
		c = function()
			m.openFloatingTerm('make "' .. fileWithoutExtension .. '" && ' .. '"' .. fileWithoutExtension .. '"')
		end,
		lua = function()
			m.openFloatingTerm('luajit "' .. fileWithExtension .. '"')
		end,
		dosbatch = function()
			m.openFloatingTerm('cmd /c "' .. fileWithExtension .. '" && exit')
		end,
		ps1 = function()
			m.openFloatingTerm('powershell -File "' .. fileWithExtension .. '"')
		end,
		html = function()
			vim.system({ m.browser, fileWithExtension })
		end,
	}
	execute[currentFiletype]()
end

return m
