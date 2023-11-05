module Til::Middleware
  class RateLimiter
    def initialize(app, options = {})
      @app = app
      @rate_limit = options[:rate_limit] || 10
      @time_window = options[:time_window] || 60
      @storage = {}
    end

    def call(env)
      session_id = env['rack.session']['session_id']

      if rate_limit_exceeded?(session_id, env['REQUEST_METHOD'] == 'POST')
        return [429, { 'Content-Type' => 'text/plain' }, ['Rate limit exceeded']]
      end

      status, headers, response = @app.call(env)
      update_rate_limit(session_id)

      [status, headers, response]
    end

    private

    def rate_limit_exceeded?(session_id, is_post_request)
      return false if !is_post_request ||  @storage[session_id].nil?

      now = Time.now.to_i
      request_count = @storage[session_id].count
      oldest_request = @storage[session_id].first

      return false if (now - oldest_request) > @time_window

      request_count >= @rate_limit
    end

    def update_rate_limit(session_id)
      @storage[session_id] ||= []
      @storage[session_id] << Time.now.to_i

      if @storage[session_id].count > @rate_limit
        @storage[session_id].shift
      end
    end
  end
end
