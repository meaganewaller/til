require 'rack'

module Til
  class App
    def initialize
      @app = Rack::Builder.new do
        run -> (env) { [200, {}, ["TIL!"]] }
      end.to_app
    end

    def call(env)
      @app.call(env)
    end
  end
end
