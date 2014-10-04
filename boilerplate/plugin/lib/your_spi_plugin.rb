require "your_magis_plugin/version"
require "sinatra"

class Web < Sinatra::Base
  get "/your_magis_plugin" do
    "Here I am"
  end
end
