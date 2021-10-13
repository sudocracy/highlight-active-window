return (function()

    local windowFilteringCriteria = { 
        visible = true, 
        hasTitlebar = true, 
        focused = true,
        allowTitles = 1,
        allowRoles = 'AXStandardWindow'
    }

    local highlightedWindowBorder = nil
    local windows = hs.window.filter.new(nil):setAppFilter('Application Windows', windowFilteringCriteria)

    local running = false

    function drawWindowBorder(window)

        if window == nil then return end

        -- putting a border around the whole window works, but it cuts across transient dialogs     --
        -- that we might open such as Spotlight Search or Alfred. So, this rectangle, effectively   --
        -- only highlights the bottom border                                                        --

        local frame = hs.window.focusedWindow():frame()
              frame = { x = frame.x, y = frame.y + frame.h - 5 , w = frame.w, h = 5}

        local focusedWindowBorder = hs.drawing.rectangle (frame)

        focusedWindowBorder:setStrokeColor ({
            ["red"]   = 1,
            ["blue"]  = 0,
            ["green"] = 0,
            ["alpha"] = 1
        })

        focusedWindowBorder:setFill(false)
        focusedWindowBorder:setStrokeWidth(5)
        focusedWindowBorder:show()

        return focusedWindowBorder
    
    end
    
    function eraseWindowBorder(border)
        
        -- It looks like the border object can be in a state
        -- where it is not nil, but the delete property in 
        -- the metatable is and can result in this error:
        -- method 'delete' is not callable (a nil value)
        -- Perhaps the 'delete' key is not weak, but the its
        -- value is and was garbage collected. This can be 
        -- reproduced by removing this check and calling the 
        -- start method again after calling stop.

        if border == nil or border.delete  == nil then 
            return 
        else
            border:delete()
        end
       
    end

    function highlightWindow()

        eraseWindowBorder(highlightedWindowBorder)

        local focusedWindow = hs.window.focusedWindow()
        highlightedWindowBorder = drawWindowBorder(focusedWindow)
    end

    function subscribe()

        windows:subscribe (
            hs.window.filter.windowFocused, 
            highlightWindow
        )

        windows:subscribe (
            hs.window.filter.windowMoved, 
            highlightWindow
        )

        windows:subscribe (
            hs.window.filter.windowNotOnScreen, 
            highlightWindow
        )
    
    end

    function unsubscribe()

        windows:unsubscribe(nil, highlightWindow)

    end

    function start()

        highlightWindow()
        subscribe()

        running = true
    end

    function stop()

        unsubscribe()
        eraseWindowBorder(highlightedWindowBorder)

        running = false

    end

    function toggle()

        if running then 
            stop()
        else 
            start()
        end
    end

    return { start = start, stop = stop, toggle = toggle }
    
end)()

