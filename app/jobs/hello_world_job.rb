class HelloWorldJob < ApplicationJob
  def perform(name:)
    "Hello, World!, #{name}"
  end
end
