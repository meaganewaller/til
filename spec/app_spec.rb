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

  it 'responds with "TIL!" in the body' do
    get '/'
    expect(last_response.body).to eq('TIL!')
  end
end
