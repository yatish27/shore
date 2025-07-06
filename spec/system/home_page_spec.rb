require "rails_helper"

RSpec.describe "Home Page", type: :system do
  it "displays the Shore application" do
    visit "/"

    expect(page).to have_content("Shore")
  end
end
