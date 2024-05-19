class RecipeIngredient < ApplicationRecord
  belongs_to :recipe
  belongs_to :ingredient

  validates :quantity, numericality: { greater_than: 0 }, allow_nil: false

  enum quantity_unit: {
    gram: 0,
    kilogram: 1,
    milliliter: 2,
    liter: 3,
    teaspoon: 4,
    tablespoon: 5,
    cup: 6,
    piece: 7,
    pinch: 8,
    bunch: 9,
    unit: 10,
    qb: 11
  }
end
