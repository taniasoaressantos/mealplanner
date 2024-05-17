FactoryBot.define do
  factory :recipe do
    title { Faker::Food.dish }
    servings { Faker::Number.between(from: 1, to: 10) }
    prep_time_min { Faker::Number.between(from: 10, to: 60) }
    cook_time_min { Faker::Number.between(from: 10, to: 120) }
    instructions { Faker::Food.description }
    rating { Faker::Number.between(from: 1, to: 5) }
    cuisine { Recipe.cuisines.keys.sample }
    category { Faker::Food.dish }
    author { Faker::Name.name }
    image { Faker::Avatar.image }
  end
end
