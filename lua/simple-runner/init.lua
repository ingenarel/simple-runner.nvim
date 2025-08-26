local m = {}

function m.setup(opts)
    m.heightPercentage = opts.heightPercentage or 70
    m.widthPercentage = opts.widthPercentage or 80
    m.browser = opts.browser
end

function m.run(opts)
    opts = opts or {}
    local currentFiletype = vim.bo.filetype

    vim.cmd("w")

    if opts.closeOnExit == nil then
        opts.closeOnExit = false
    end

    local fileWithExtension = vim.fn.expand("%:p")
    local fileWithoutExtension = vim.fn.fnamemodify(fileWithExtension, ":r")

    local execute = {
        python = function()
            require("smart-term").float { 'python "' .. fileWithExtension .. '"', closeOnExit = opts.closeOnExit }
        end,
        sh = function()
            if not string.find(vim.fn.getfperm(fileWithExtension), "x") then
                vim.system({ "chmod", "u+x", fileWithExtension }):wait()
            end
            require("smart-term").float { '"' .. fileWithExtension .. '"', closeOnExit = opts.closeOnExit }
        end,
        c = function()
            require("smart-term").float {
                'make "' .. fileWithoutExtension .. '" && ' .. '"' .. fileWithoutExtension .. '"',
                closeOnExit = opts.closeOnExit,
            }
        end,
        lua = function()
            require("smart-term").float { 'luajit "' .. fileWithExtension .. '"', closeOnExit = opts.closeOnExit }
        end,
        dosbatch = function()
            require("smart-term").float {
                'cmd /c "' .. fileWithExtension .. '" && exit',
                closeOnExit = opts.closeOnExit,
            }
        end,
        ps1 = function()
            require("smart-term").float {
                'powershell -File "' .. fileWithExtension .. '"',
                closeOnExit = opts.closeOnExit,
            }
        end,
        html = function()
            vim.system { m.browser, fileWithExtension }
        end,
        rust = function()
            require("smart-term").float { "cargo run", closeOnExit = opts.closeOnExit }
        end,
    }
    execute[currentFiletype]()
end

return m
