class BasicComponent < ApplicationComponent
  def initialize(version:)
    @version = version
  end

  def view_template(&)
    p(class: "text-lg text-gray-600") { "Hello from Phlex #{@version} 💪🏼" }
  end
end
