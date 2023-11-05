require 'rack'
require 'slim'

module Til
  class App
    def initialize(db)
      @db = db
    end

    def call(env)
      request = Rack::Request.new(env)
      case request.path
      when '/'
        index_response
      when '/til'
        if request.request_method == 'GET'
          view_tils
        elsif request.request_method == 'POST'
          create_til(env)
        end
      else
        render_not_found
      end
    end

    private

    def render_view(view_name, locals = {})
      template = File.read("views/#{view_name}.slim")
      rendered = Slim::Template.new { template }.render(self, locals)
      [200, { 'Content-Type' => 'text/html' }, [rendered]]
    end

    def index_response
      render_view('index')
    end

    def render_not_found
      template = File.read('views/not_found.slim')
      rendered = Slim::Template.new { template }.render(self)
      [404, { 'Content-Type' => 'text/html' }, [rendered]]
    end

    def view_tils
      tils = retrieve_tils || []

      render_view('til', { tils: })
    end

    def create_til(env)
      request = Rack::Request.new(env)
      content = request.params['content']

      insert_til(content)

      view_tils
    end

    def insert_til(content)
      @db[:learnings].insert(content:)
    end

    def retrieve_tils
      all_learnings = @db.from(:learnings)
      all_learnings.exclude(content: nil)
      all_learnings.order(Sequel.desc(:id))
    end
  end
end
