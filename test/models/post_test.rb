require "test_helper"

class PostTest < ActiveSupport::TestCase
  test "valid" do
    post = FactoryBot.create(:post)
    assert post.valid?
  end
end
