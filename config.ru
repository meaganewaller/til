# frozen_string_literal: true

require "rack"
require "rack/session"
require "faye/websocket"
require_relative "app"
require "sequel"
require "thin"
require_relative "lib/middleware/rate_limiter"
require_relative "lib/middleware/input_validation"

use Rack::Session::Cookie,
  key: "rack.session",
  secret: ENV["SESSION_SECRET"],
  domain: "localhost:9292",
  path: "/",
  expire_after: 3600 * 24
use Til::Middleware::RateLimiter, rate_limit: 10, time_window: 60
use Til::Middleware::InputValidation

use Rack::Static, urls: ["/assets"], root: "public"

db = Sequel.connect(ENV["DATABASE_URL"] || "postgres://127.0.0.1/til_development")

Faye::WebSocket.load_adapter("thin")

app = Til::App.new(db)

run app
