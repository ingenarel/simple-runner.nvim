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
            require("smart-term").openFloaTerm { 'python "' .. fileWithExtension .. '"', closeOnExit = opts.closeOnExit }
        end,
        sh = function()
            require("smart-term").openFloaTerm { '"' .. fileWithExtension .. '"', closeOnExit = opts.closeOnExit }
        end,
        c = function()
            require("smart-term").openFloaTerm {
                'make "' .. fileWithoutExtension .. '" && ' .. '"' .. fileWithoutExtension .. '"',
                closeOnExit = opts.closeOnExit,
            }
        end,
        lua = function()
            require("smart-term").openFloaTerm { 'luajit "' .. fileWithExtension .. '"', closeOnExit = opts.closeOnExit }
        end,
        dosbatch = function()
            require("smart-term").openFloaTerm {
                'cmd /c "' .. fileWithExtension .. '" && exit',
                closeOnExit = opts.closeOnExit,
            }
        end,
        ps1 = function()
            require("smart-term").openFloaTerm {
                'powershell -File "' .. fileWithExtension .. '"',
                closeOnExit = opts.closeOnExit,
            }
        end,
        html = function()
            vim.system { m.browser, fileWithExtension }
        end,
    }
    execute[currentFiletype]()
end

return m
