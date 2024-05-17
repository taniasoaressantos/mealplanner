class Recipe < ApplicationRecord
  has_many :recipe_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients

  validates :title, presence: true, length: { maximum: 255 }
  validates :instructions, presence: true, length: { maximum: 5000 }
  validates :servings, numericality: { greater_than: 0, only_integer: true, allow_nil: true }
  validates :prep_time_min, numericality: { greater_than_or_equal_to: 0, only_integer: true, allow_nil: true }
  validates :cook_time_min, numericality: { greater_than_or_equal_to: 0, only_integer: true, allow_nil: true }
end
