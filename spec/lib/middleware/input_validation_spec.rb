require 'spec_helper'

RSpec.describe Til::Middleware::InputValidation do
  include Rack::Test::Methods

  let(:app) { Til::App.new(DB) }

  it 'sanitizes the content parameter' do
    input = '<script>alert("XSS")</script><b>hey there!</b>'
    expected_output = 'hey there!'

    env = Rack::MockRequest.env_for('/til', method: 'POST', params: { content: input })
    middleware = Til::Middleware::InputValidation.new(app)
    response = middleware.call(env)

    expect(response[2][0]).to include(expected_output)
  end
end
