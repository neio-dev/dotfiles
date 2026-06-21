local InnerView = {}
InnerView.__index = InnerView
InnerView.class_name = "View"
function InnerView:props(tbl)
    self.props_tbl = tbl

    return self
end

function View(fn)
    return function(children)
        local instance = setmetatable({}, { __index = InnerView })
        instance.fn = fn
        instance.children = children

        return instance
    end
end

return View
