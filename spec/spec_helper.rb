require 'simplecov'
ENV["SPI_ENV"] = "test"
SimpleCov.start

require 'bundler/setup'
Bundler.setup

require 'capybara/rspec'

# SET UP DESKTOP
ENV["DB_NAME"] = "magisTestDB"
require 'magis' # and any other gems you need

RSpec.configure do |config|
	config.before(:each) do
		WebMock.disable_net_connect!(:allow_localhost => true)
  	end
	
end

module TestHelpers
	def root_folder
		@root_folder ||= File.expand_path("..", File.dirname(__FILE__))
	end
end

yaml = YAML.load_file(File.dirname(__FILE__)  + "/support/omniauth_fb.yml")
FBTether.store(yaml)


Capybara.app = Magis.application

include Capybara::DSL
include RSpec::Matchers


ENV['RACK_ENV'] = 'test'
ENV['DB_NAME'] = "magisTestDB"
require 'magis'
require 'test/unit'
require 'rack/test'
require 'webmock'