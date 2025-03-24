# highlight-active-window
A simple [Hammerspoon][1] module that draws a red line below the active window so that it is easy to identify the active window visually. 

As macOS uses subtle cues to highlight the active window, it is not always visually apparent what the active window is at the moment. Notice the red line created by this module on the bottom border of the left window in the image below. 

![screenshot-of-highlighted-window](demo.png)

## Installation

Add this to your Hammerspoon config (`~/.hammerspoon/init.lua`) after placing the `highlightActiveWindow.lua` in the `~/.hammerspoon/modules/` directory:

```
-- (002) Keeps a red border around active window so that it is
-- easy to spot the active window on the screen.

    highlighter = require('modules/highlightActiveWindow')
    highlighter.start()

    -- change to desired hotkey.
    hs.hotkey.bind('cmd', '7', nil, highlighter.toggle) 
```

[1]: https://www.hammerspoon.org/
