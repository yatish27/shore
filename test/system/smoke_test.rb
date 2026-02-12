require "application_system_test_case"

class SmokeTest < ApplicationSystemTestCase
  test "home page loads with logo and version info" do
    visit root_url

    assert_selector "h1", text: "Shore"
    assert_text "Ruby"
    assert_text "Rails"
    assert_text "Postgresql"
  end
end
