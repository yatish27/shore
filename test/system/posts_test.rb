require "application_system_test_case"

class PostsSystemTest < ApplicationSystemTestCase
  test "full CRUD flow: create, view, and delete a post" do
    visit posts_path

    click_on "New Post"

    fill_in "Title", with: "System Test Post"
    fill_in "Body", with: "This post was created by a system test."
    click_on "Create Post"

    assert_text "System Test Post"
    assert_text "This post was created by a system test."

    accept_confirm do
      click_on "Delete"
    end

    assert_current_path posts_path
    assert_no_text "System Test Post"
  end
end
