ENV['RACK_ENV'] = 'test'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'silver_mother'
require 'webmock/rspec'
WebMock.disable_net_connect!(allow_localhost: true)

def fixture_path
  File.expand_path('../fixtures', __FILE__)
end

def fixture(file)
  File.read(fixture_path + '/' + file).strip
end
