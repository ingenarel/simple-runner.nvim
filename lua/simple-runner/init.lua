local m = {}

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

function m.run(closeOnExit)
	local currentFiletype = vim.bo.filetype

	vim.cmd("w")

	if closeOnExit == nil then
		closeOnExit = false
	end

	local fileWithExtension = vim.fn.expand("%:p")
	local fileWithoutExtension = vim.fn.fnamemodify(fileWithExtension, ":r")

	local execute = {
		python = function()
			require("smart-floatterm").open('python "' .. fileWithExtension .. '"', closeOnExit)
		end,
		sh = function()
			require("smart-floatterm").open('"' .. fileWithExtension .. '"', closeOnExit)
		end,
		c = function()
			require("smart-floatterm").open(
				'make "' .. fileWithoutExtension .. '" && ' .. '"' .. fileWithoutExtension .. '"',
				closeOnExit
			)
		end,
		lua = function()
			require("smart-floatterm").open('luajit "' .. fileWithExtension .. '"', closeOnExit)
		end,
		dosbatch = function()
			require("smart-floatterm").open('cmd /c "' .. fileWithExtension .. '" && exit', closeOnExit)
		end,
		ps1 = function()
			require("smart-floatterm").open('powershell -File "' .. fileWithExtension .. '"', closeOnExit)
		end,
		html = function()
			vim.system({ m.browser, fileWithExtension })
		end,
	}
	execute[currentFiletype]()
end

return m
