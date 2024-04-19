require "test_helper"

class HelloWorldJobTest < ActiveJob::TestCase
  test "greets hello world" do
    result = HelloWorldJob.perform_now(name: "Alice")
    assert_equal "Hello, World!, Alice", result
  end
end
