# frozen_string_literal: true

require 'rack'
require_relative 'app'
require 'sequel'

use Rack::Static, urls: ['/assets'], root: 'public'

db = Sequel.connect(ENV['DATABASE_URL'] || 'postgres://127.0.0.1/til_development')

run Til::App.new(db)
