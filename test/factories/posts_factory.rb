FactoryBot.define do
  factory :post do
    title { Faker::Book.title }
    content { Faker::Markdown.sandwich(sentences: 5) }
    published_at { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now) }
  end
end
