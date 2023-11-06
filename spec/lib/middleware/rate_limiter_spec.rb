require 'spec_helper'
require 'pry'

RSpec.describe Til::Middleware::RateLimiter do
  include Rack::Test::Methods

  let(:app) { Til::App.new(DB) }
  let(:rate_limit) { 2 }
  let(:time_window) { 30 }
  let(:options) { { rate_limit:, time_window: }}

  context 'when rate limit is not exceeded' do
    it 'returns a successful response' do
      env = Rack::MockRequest.env_for("/", "rack.session" => { "session_id" => "user123" }, method: "POST")

      middleware = Til::Middleware::RateLimiter.new(app, options)
      response = middleware.call(env)

      expect(response[0]).to eq(200)
    end
  end

  context 'when rate limit is exceeded' do
    it 'returns a 429 response' do
      env = Rack::MockRequest.env_for("/", "rack.session" => { "session_id" => "user123" }, method: "POST")

      middleware = Til::Middleware::RateLimiter.new(app, options)
      3.times { middleware.call(env) }

      response = middleware.call(env)

      expect(response[0]).to eq(429)
    end
  end

  context 'update_rate_limit method' do
    it 'adds a timestamp to an existing session' do
      middleware = Til::Middleware::RateLimiter.new(app, options)
      session_id = 'user123'

      # Simulate an existing session
      middleware.instance_variable_get(:@storage)[session_id] = []

      expect {
        middleware.send(:update_rate_limit, session_id)
      }.to change {
          middleware.instance_variable_get(:@storage)[session_id].count
        }.by(1)
    end

    it 'creates a new session when it does not exist' do
      middleware = Til::Middleware::RateLimiter.new(app, options)
      session_id = 'new_user'

      # Simulate a new session
      middleware.instance_variable_get(:@storage).clear

      expect {
        middleware.send(:update_rate_limit, session_id)
      }.to change {
          middleware.instance_variable_get(:@storage).keys
        }.from([]).to([session_id])
    end
  end
end
