require "rails_helper"

RSpec.describe "Homepage", type: :system do
  it "displays the homepage" do
    visit root_path
    expect(page).to have_content("Shore")
  end
end
