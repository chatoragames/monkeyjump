function love.conf(t)
	t.identity = nil 
	t.version = "0.10.1"
	t.console = false         
	t.window.title = "Monkey VS Totem"         -- The window title (string)
    t.window.icon = nil                 -- Filepath to an image to use as the window's icon (string)
    t.window.width = 480                -- The window width (number)
    t.window.height = 600               -- The window height (number)
end