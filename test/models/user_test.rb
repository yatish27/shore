require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "valid" do
    user = FactoryBot.create(:user)
    assert user.valid?
  end
end
