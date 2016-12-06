$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "mobile_iron"
require "factory_girl"
require "pry"
require "webmock/rspec"

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    FactoryGirl.find_definitions
  end
end

def mobile_iron_url(path:)
  "https://mobile_iron_host/api/v2/#{path}"
end

def api_response_json(filename:)
  File.read File.join('spec', 'files', filename)
end
