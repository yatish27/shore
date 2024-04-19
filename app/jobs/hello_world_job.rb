class HelloWorldJob < ApplicationJob
  def perform(name:)
    greeting = "Hello, World!, #{name}"
    puts greeting
    greeting
  end
end
