max_threads_count = ENV.fetch("RACK_MAX_THREADS") { 5 }
min_threads_count = ENV.fetch("RACK_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

port ENV.fetch("PORT") { 9292 }
environnment ENV.fetch("RACK_ENV") { "development" }

pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }

plugin :tmp_restart
