function love.conf(t)
    t.window.title = "Meowrio"         -- The window title (string)
    t.window.borderless = false         -- Remove all border visuals from the window (boolean)
    t.window.resizable = true          -- Let the window be user-resizable (boolean)
    t.window.fullscreen = true         -- Enable fullscreen (boolean)
    t.window.vsync = 1               -- Enable vertical sync (boolean)
    t.releases = {
        title = 'meowrio',
        package = 'meowrio',
        loveVersion = '11.3',
        version = nil,
        author = nil,
        email = nil,
        description = nil,
        homepage = nil,
        identifier = "co.bepbep.meowrio",
        excludeFileList = { '/specs?/' , 'lib/bump/img/', 'lib/shack/game.png', '.*.rockspec', '.*.md', '*.yml', 'lib/hump/docs/.*'} ,
        compile = true,
        projectDirectory = '/home/bep/meowrio',
        releaseDirectory = '/home/bep/meowrio/releases',
    }
  end
