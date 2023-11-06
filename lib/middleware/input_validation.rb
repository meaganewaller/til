require 'sanitize'

module Til::Middleware
  class InputValidation
    def initialize(app)
      @app = app
    end

    def call(env)
      request = Rack::Request.new(env)

      content_param = request.params['content']
      sanitized_input = sanitize(content_param)

      request.update_param('content', sanitized_input)

      @app.call(env)
    end

    private

    def sanitize(input)
      sanitize_html(input)
    end

    def sanitize_html(input)
      Sanitize.fragment(input)
    end
  end
end
