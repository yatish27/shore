class BasicComponent < ApplicationComponent
  def initialize(version:)
    @version = version
  end

  def view_template(&)
  end
end
