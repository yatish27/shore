require "application_system_test_case"

class SmokeTest < ApplicationSystemTestCase
  test "home page loads with logo and version info" do
    visit root_url

    assert_selector "h1", text: "Shore"
    assert_text "ruby"
    assert_text "rails"
    assert_text "postgresql"
  end

  test "health check returns successfully" do
    visit rails_health_check_url

    assert_selector "body"
    assert_no_text "error"
  end
end
