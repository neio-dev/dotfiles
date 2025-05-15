local n,o,x,v = "n","o","x","v"

function kmap(_modes, _lhs, _rhs, _desc)
    return { modes = _modes, lhs = _lhs, rhs = _rhs, desc = _desc }
end

local mappings = {
    kmap({n},"<leader><leader>","<C-w>",""),
    -- Directions
    kmap({n,o,x},"n","h","Left"),
    kmap({n,o,x},"e","j","Down"),
    kmap({n,o,x},"i","k","Up"),
    kmap({n,o,x},"o","l","Right"),

    -- Beginning/end of line
    kmap({n,o,x},"L","^","Right"),
    kmap({n,o,x},"Y","$","Right"),

    -- PU/PD
    kmap({n,x},"j","<PageUp>","Right"),
    kmap({n,x},"h","<PageDown>","Right"),

    -- Jumplist nav
    kmap({n},"<C-u>","<C-i>","Jumplist forward"),
    --  kmap({n},"<C-e>","<C-o>","Jumplist forward"),

    -- Word left/right
    kmap({n,o,x},"l","b","Word back"),
    kmap({n,o,x},"y","w","Word back"),
    kmap({n,o,v},"<C-l>","B","WORD back"),
    kmap({n,o,v},"<C-y>","W","WORD back"),


    -- End of word left/right
    kmap({n,o,x},"L","ge","Word back"),
    kmap({n,o,x},"<M-l>","gE","Word back"),
    kmap({n,o,x},"Y","e","Word back"),
    kmap({n,o,x},"<M-Y>","i","Word back"),

    -- Text objects
    -- diw > drw, daw > dtw
    kmap({o,v},"r","i","desc"),
    kmap({o,v},"t","a","desc"),
    -- MOve visual replace from 'r' to 'R'
    kmap({v},"R","r","Visual replace"),

    -- Folds
    kmap({n,x},"b","z",""),
    kmap({n,x},"bb","zb","Scroll line and cursor to bottom"),
    kmap({n,x},"bu","zk","Move up to fold"),
    kmap({n,x},"be","zj","Move down to fold"),

    -- Copy/paste
    kmap({n,o,x},"c","y","copy"),
    kmap({n,x},"v","p","paste"),
    kmap({n},"C","y$",""),
    kmap({x},"C","y",""),
    kmap({n,x},"V","P",""), 

    -- Undo/redo
    kmap({n},"z","u",""), 
    kmap({n},"gz","U",""),
    kmap({n},"Z","<C-r>",""), 

    -- insert/append
    kmap({n},"s","i","Right"),
    kmap({n},"S","I","Right"),
    kmap({n},"t","a","Right"),
    kmap({n},"T","a","Right"),

    -- Change
    kmap({n,o,x},"w","c",""),
    kmap({n,x},"W","C",""),

    -- Visual mode
    kmap({n,x},"a","v",""), 
    kmap({n,x},"A","V",""),

    -- Insert in visual mode
    kmap({v},"S","I",""),

    -- Search
    kmap({n,o,x},"k","n",""),
    kmap({n,o,x},"K","N",""),

    --'til
    -- Breaks diffput
    kmap({n,o,x},"p","t",""),
    kmap({n,o,x},"P","T",""), 

    -- Fix diffput (t for 'transfer')
    kmap({n},"dt","dp","diffput (t for 'transfer'"),

    -- Macros (replay the macro recorded by qq)
    kmap({n},"Q","@q","relay the 'q' macro"),

    -- Cursor to bot of screen
    kmap({n,v},"B","L",""),

    -- Misc overriden keys must be prefixed with g
    kmap({n,x},"gX","X",""),
    kmap({n,x},"gU","U",""), 
    kmap({n,x},"gQ","Q",""), 
    kmap({n,x},"gK","K",""),
    -- extraalias
    kmap({n,x},"gh","K",""), 

    -- Window nav
    kmap({n},"<leader><leader>n","<C-w>h",""), 
    kmap({n},"<leader><leader>e","<C-w>j",""), 
    kmap({n},"<leader><leader>i","<C-w>k",""), 
    kmap({n},"<leader><leader>o","<C-w>l",""), 
    kmap({n},"<leader><leader>N","<C-w>H",""), 
    kmap({n},"<leader><leader>E","<C-w>J",""), 
    kmap({n},"<leader><leader>I","<C-w>K",""), 
    kmap({n},"<leader><leader>O","<C-w>L",""), 
    
    -- Disable spawning empty buffer
    kmap({n},"<C-w><C=n>","<nop>",""),
}

local colemak = {
    setup = function(_)
        _.apply()

        vim.api.nvim_create_user_command(
            "ColemakEnable",
            _.apply,
            { desc = "Applies Colemak mappings" }
        )

        vim.api.nvim_create_user_command(
            "ColemakDisable",
            _.unapply,
            { desc = "Removes Colemak mappings" }
        )
    end,
    apply = function()
        for _, mapping in pairs(mappings) do
            vim.keymap.set(
                mapping.modes,
                mapping.lhs,
                mapping.rhs,
                { desc = mapping.desc .. "(" .. mapping.rhs.. ")" }
            )
        end
    end,
    unapply = function()
        for _, mapping in pairs(mappings) do
            vim.keymap.del(mapping.modes, mapping.lhs)
        end
    end
}

return colemak
