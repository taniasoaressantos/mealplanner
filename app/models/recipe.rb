class Recipe < ApplicationRecord
  mount_uploader :image, ImageUploader

  has_many :recipe_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients

  validates :title, presence: true, length: { maximum: 255 }
  validates :instructions, length: { maximum: 5000 }
  validates :servings, numericality: { greater_than: 0, only_integer: true, allow_nil: true }
  validates :prep_time_min, numericality: { greater_than_or_equal_to: 0, only_integer: true, allow_nil: true }
  validates :cook_time_min, numericality: { greater_than_or_equal_to: 0, only_integer: true, allow_nil: true }

  enum cuisine: {
    italian: 0,
    chinese: 1,
    indian: 2,
    mexican: 3,
    french: 4,
    japanese: 5,
    thai: 6,
    spanish: 7,
    mediterranean: 8,
    greek: 9
  }
end
