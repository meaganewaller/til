require 'rack'
require 'slim'

module Til
  class App
    def initialize
      @app = Rack::Builder.new do
        run lambda { |_env|
          [
            200,
            { 'Content-Type' => 'text/html' },
            [Til::App.render_template('index')]
          ]
        }
      end.to_app
    end

    def call(env)
      @app.call(env)
    end

    def self.render_template(template_name)
      template_path = File.join(File.dirname(__FILE__), 'views', "#{template_name}.slim")
      template = File.read(template_path)
      Slim::Template.new { template }.render(self)
    end
  end
end
