FactoryBot.define do
  factory :granity_example, class: 'Granity::Example' do
    sequence(:name) { |n| "Example #{n}" }
    description { "A sample description" }
    active { true }
  end
end
