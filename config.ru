# frozen_string_literal: true

require 'rack'
require_relative 'app'

use Rack::Static, urls: ['/assets'], root: 'public'

run Til::App.new
