require_relative 'spec_helper'

RSpec.describe Til::App do
  include Rack::Test::Methods

  def app
    Til::App.new
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

  describe "get /til" do
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
end
