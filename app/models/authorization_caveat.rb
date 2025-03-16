class AuthorizationCaveat < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :definition, presence: true

  # Evaluate the caveat definition against provided context
  def evaluate(context = {})
    # A simple caveat evaluator implementation
    # In a real application, you would implement a proper expression evaluator
    # or use a rule engine
    begin
      # This is an example - real implementation would depend on your caveat language
      # For demonstration, we'll assume the definition is valid Ruby code
      # That returns a boolean when evaluated with the context
      eval(definition)
    rescue => e
      Rails.logger.error "Error evaluating caveat #{name}: #{e.message}"
      false
    end
  end

  def self.evaluate_caveat(caveat_name, context = {})
    return true if caveat_name.nil?

    caveat = find_by(name: caveat_name)
    return false unless caveat

    caveat.evaluate(context)
  end
end
