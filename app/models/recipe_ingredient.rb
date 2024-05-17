class RecipeIngredient < ApplicationRecord
  belongs_to :recipe
  belongs_to :ingredient

  validates :quantity, numericality: { greater_than: 0 }, allow_nil: false

  enum quantity_unit: {
    grams: 0,
    kilograms: 1,
    milliliters: 2,
    liters: 3,
    teaspoons: 4,
    tablespoons: 5,
    cups: 6,
    pieces: 7,
    pinch: 8,
    bunch: 9,
    slices: 10
  }
end
