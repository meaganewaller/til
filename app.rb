# frozen_string_literal: true

require 'rack'
require 'slim'
require 'faye/websocket'

module Til
  class App
    TIL_MESSAGE_TYPE = 'til_created'

    def initialize(db)
      @db = db
      @counter = read_counter
      @connections = []
    end

    def call(env)
      if Faye::WebSocket.websocket?(env)
        ws = Faye::WebSocket.new(env, nil, { ping: 5 })

        ws.on(:open) do |_event|
          @connections << ws
        end

        ws.on(:message) do |event|
          message = event.data
        end

        ws.on(:close) do |_event|
          @connections.delete(ws)
          ws = nil
        end

        ws.rack_response
      else
        request = Rack::Request.new(env)
        case request.path
        when '/'
          if request.request_method == 'GET'
            index_response
          elsif request.request_method == 'POST'
            increment_counter
          end
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
    end

    private

    def read_counter
      File.read('./til_count.txt').to_i
    end

    def increment_counter
      @counter += 1

      File.write('./til_count.txt', @counter.to_s)

      index_response
    end

    def render_view(view_name, locals = {})
      template = File.read("views/#{view_name}.slim")
      rendered = Slim::Template.new { template }.render(self, locals)
      [200, { 'content-type' => 'text/html' }, [rendered]]
    end

    def index_response
      counter = @counter
      render_view('index', { counter: counter })
    end

    def render_not_found
      template = File.read('views/not_found.slim')
      rendered = Slim::Template.new { template }.render(self)
      [404, { 'content-type' => 'text/html' }, [rendered]]
    end

    def view_tils
      tils = retrieve_tils || []

      render_view('til', { tils: tils })
    end

    def create_til(env)
      request = Rack::Request.new(env)
      content = request.params['content']

      insert_til(content)

      notify_til_update(content)

      [201, { 'content-type' => 'application/json' }, [{ message: content }.to_json]]
    end

    def notify_til_update(content)
      message = {
        type: TIL_MESSAGE_TYPE,
        content: content
      }

      @connections.each do |ws|
        ws.send(message.to_json)
      end
    end

    def insert_til(content)
      @db[:learnings].insert(content: content)
    end

    def retrieve_tils
      all_learnings = @db.from(:learnings)
      all_learnings.exclude(content: nil)
      all_learnings.order(Sequel.desc(:id))
    end
  end
end
