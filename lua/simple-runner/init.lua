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
            table.insert(opts, 'python "' .. fileWithExtension .. '"')
            return true
        end,
        sh = function()
            if not string.find(vim.fn.getfperm(fileWithExtension), "x") then
                vim.system({ "chmod", "u+x", fileWithExtension }):wait()
            end
            table.insert(opts, '"' .. fileWithExtension .. '"')
            return true
        end,
        c = function()
            table.insert(opts, 'make "' .. fileWithoutExtension .. '" && ' .. '"' .. fileWithoutExtension .. '"')
            return true
        end,
        lua = function()
            table.insert(opts, 'luajit "' .. fileWithExtension .. '"')
            return true
        end,
        dosbatch = function()
            table.insert(opts, 'cmd /c "' .. fileWithExtension .. '" && exit')
            return true
        end,
        ps1 = function()
            table.insert(opts, 'powershell -File "' .. fileWithExtension .. '"')
            return true
        end,
        html = function()
            vim.system { m.browser, fileWithExtension }
        end,
        rust = function()
            table.insert(opts, "cargo run")
            return true
        end,
    }
    if execute[currentFiletype]() then
        require("smart-term").open(opts)
    end
end

return m
