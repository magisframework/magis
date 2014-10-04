require "spec_helper"

describe 'Main Test', :type => :feature do
  include Rack::Test::Methods
  include TestHelpers
  include Capybara::DSL

  def app
    Magis.application
  end

  it "can reach home" do
  	Dir.chdir([root_folder, "/boilerplate/project"].join)
    get '/'
    
    expect(last_response.body).to eq(File.read("public/index.html"))

    Dir.chdir(root_folder)
  end

  it "prints js properly" do
  	Dir.chdir([root_folder, "/boilerplate/project"].join)
    get '/magis.js'
    
    expect(last_response.body.include? "currentUser = {\"_id\":\"\"};").to eq(true)
    expect(last_response.body.include? File.read('../../magis/js/main.js')).to eq(true)
    expect(last_response.body.include? File.read('../../magis/js/finch.min.js')).to eq(true)

    Dir.chdir(root_folder)
  end

  it "loads home page with user", js: true do
    Dir.chdir([root_folder, "/boilerplate/project"].join)

    visit '/'

    p expect(page.body).to have_link("facebook")

    Dir.chdir(root_folder)
  end

  it "shows friends" do
    Dir.chdir([root_folder, "/boilerplate/project"].join)
    yaml = YAML.load_file(File.dirname(__FILE__)  + "/support/omniauth_fb.yml")
    user = FBTether.store(yaml)

    get '/'

    expect(last_response.body).to_not eq("")

    Dir.chdir(root_folder)
  end
end