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

function m.run()
	local currentFiletype = vim.bo.filetype

	vim.cmd("w")

	local fileWithExtension = vim.fn.expand("%:p")
	local fileWithoutExtension = vim.fn.fnamemodify(fileWithExtension, ":r")

	local execute = {
		python = function()
			require("smart-floatterm").open('python "' .. fileWithExtension .. '"')
		end,
		sh = function()
			require("smart-floatterm").open('"' .. fileWithExtension .. '"')
		end,
		c = function()
			require("smart-floatterm").open(
				'make "' .. fileWithoutExtension .. '" && ' .. '"' .. fileWithoutExtension .. '"'
			)
		end,
		lua = function()
			require("smart-floatterm").open('luajit "' .. fileWithExtension .. '"')
		end,
		dosbatch = function()
			require("smart-floatterm").open('cmd /c "' .. fileWithExtension .. '" && exit')
		end,
		ps1 = function()
			require("smart-floatterm").open('powershell -File "' .. fileWithExtension .. '"')
		end,
		html = function()
			vim.system({ m.browser, fileWithExtension })
		end,
	}
	execute[currentFiletype]()
end

return m
