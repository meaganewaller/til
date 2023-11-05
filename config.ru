# frozen_string_literal: true

require 'rack'
require_relative 'app'
require 'sequel'
require_relative 'lib/middleware/rate_limiter'

use Rack::Session::Cookie, key: 'rack.session', secret: ENV['SESSION_SECRET']
use Til::Middleware::RateLimiter, rate_limit: 10, time_window: 60

use Rack::Static, urls: ['/assets'], root: 'public'

db = Sequel.connect(ENV['DATABASE_URL'] || 'postgres://127.0.0.1/til_development')

run Til::App.new(db)
