FactoryBot.define do
  factory :recipe_ingredient do
    recipe
    ingredient
    quantity { Faker::Number.decimal(l_digits: 2) }
    quantity_unit { RecipeIngredient.quantity_units.keys.sample }
  end
end
