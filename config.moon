import readfile from require "webchum.util.io"
config             = require "lapis.config"

config {"development", "production"}, ->
  bind_host    "0.0.0.0"
  secret       readfile "secrets/secret.txt"
  session_name "webchum_session"
  port          6563

  webssg ->
    db ->
      backend  "grasp"
      location "webchum.db"
    apps { }

config "production", ->
  num_workers  4
  code_cache   "on"