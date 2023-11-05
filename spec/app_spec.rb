require_relative 'spec_helper'

RSpec.describe Til::App do
  include Rack::Test::Methods

  def app
    Til::App.new(DB)
  end

  it 'responds with a 200 status code' do
    get '/'

    expect(last_response.status).to eq(200)
  end

  it 'responds with html content in the body' do
    get '/'

    expect(last_response.body).to include('<!DOCTYPE html>')
  end

  it 'responds with a button with I learned something!' do
    get '/'

    expect(last_response.body).to include('I learned something!')
  end

  describe 'post /' do
    it 'increments the counter' do
      post '/'

      expect(last_response.body).to include('1')
    end
  end

  describe 'get /til' do
    it 'responds with html content in the body' do
      get '/til'

      expect(last_response.body).to include('<!DOCTYPE html>')
    end

    it 'responds with a 200 status code' do
      get '/til'

      expect(last_response.status).to eq(200)
    end

    it 'responds with textarea in the body' do
      get '/til'

      expect(last_response.body).to include('textarea')
    end
  end

  describe 'post /til' do
    it 'creates a new learning' do
      post '/til', { content: 'I learned something!' }

      expect(last_response.body).to include('I learned something!')
    end
  end

  describe 'not found' do
    it 'responds with a 404 status code' do
      get '/foobar'

      expect(last_response.status).to eq(404)
    end

    it 'responds with a not found message' do
      get '/foobar'

      expect(last_response.body).to include('Not Found')
    end
  end
end
