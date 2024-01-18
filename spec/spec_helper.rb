require "active_support"
require "active_support/core_ext/object/conversions"
require "active_support/core_ext/object/json"
require "webmock/rspec"
require "pry"
require "simplecov"

SimpleCov.start :test_frameworks

require "Traitify"

Dir[File.expand_path("spec/support/**/*.rb", __FILE__)].each{ |f| require f }

RSpec.configure do |config|
  config.color = true
  config.order = "random"
end

def stub_it(http_method, endpoint, response, body: nil, status: 200)
  url = "https://example.com/v1#{endpoint}"
  stub = stub_request(http_method, url)
  stub = stub.with(body: body.to_json) if body
  stub.to_return(
    status: status,
    body: File.read(File.expand_path("../support/mocks/#{response}.json", __FILE__)),
    headers: {"Content-type" => "application/json"}
  )
end
