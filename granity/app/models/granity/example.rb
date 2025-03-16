module Granity
  class Example < ApplicationRecord
    validates :name, presence: true

    # Add your model methods here
    def formatted_name
      name.to_s.upcase
    end
  end
end
