require "spec_helper"

feature "app_host causes click to fail", :type => :request, :js => true do

  it "should succeed when clicking a button" do
    visit("/")
    
    expect(page).to have_content 'facebook'
    expect(page).to have_content 'google'
    expect(page).to have_content 'twitter'
  end

  it "should succeed when clicking a button" do
    visit("/auth/facebook")
    save_screenshot('file.png', :full => true)
  end
end