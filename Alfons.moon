DEPENDENCIES = {
  "lapis", "moonscript", "openssl" -- lapis
  "argon2"                         -- security
  "filekit", "grasp"               -- io
  "htmlparser", "discount"         -- parsing
  "inspect"                        -- debugging
}

tasks:
  -- compile
  compile: (...) =>
    print style "%{blue}:%{white} Compiling files"
    flags = toflags ...
    if flags.noskip
      for file in wildcard "**.moon"
        continue if file\match "Alfons"
        moonc file
    else
      build (wildcard "**.moon"), (file) ->
        return if file\match "Alfons"
        moonc file

  -- clean
  clean: =>
    print style "%{blue}:%{white} Cleaning files"
    for file in wildcard "**.lua"
      fs.delete file
    for dir in wildcard "*_temp"
      fs.delete dir
    fs.delete "webchum.db"

  -- server
  server: =>
    print style "%{blue}:%{white} Running server"
    sh "lapis server development --trace"

  -- setup
  setup: =>
    print style "%{blue}:%{white} Setting up database"
    sh "moon webchum/db/setup.moon"

  -- install dependencies
  install: (bin="luarocks") =>
    print style "%{blue}:%{white} Installng dependencies"
    for dep in *DEPENDENCIES
      print "==> installing dependency: #{dep}"
      sh "#{bin} install #{dep}"

  -- slow
  slow: =>
    print style "%{blue}:%{white} Running server (slow)..."
    tasks.clean!
    tasks.setup!
    --tasks.populate!
    tasks.compile "noskip"
    tasks.server!
  
  -- fast
  fast: =>
    print style "%{blue}:%{white} Running server (fast)..."
    tasks.compile!
    tasks.server!