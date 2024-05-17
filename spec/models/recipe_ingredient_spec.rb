require 'rails_helper'

RSpec.describe RecipeIngredient do
  let(:recipe_ingredient) { create(:recipe_ingredient) }

  it 'has a valid factory' do
    expect(recipe_ingredient).to be_valid
  end

  describe 'ActiveRecord associations' do
    it { is_expected.to belong_to(:recipe) }
    it { is_expected.to belong_to(:ingredient) }
  end

  describe 'ActiveModel validations' do
    context 'when setting quantity' do
      subject(:recipe_ingredient) { build(:recipe_ingredient) }

      it 'validates numericality of quantity greater than 0' do
        expect(recipe_ingredient).to validate_numericality_of(:quantity).is_greater_than(0)
      end
    end

    context 'when recipe_id is nil' do
      subject(:recipe_ingredient) { build(:recipe_ingredient, recipe_id: nil) }

      it 'is not valid' do
        expect(recipe_ingredient).not_to be_valid
      end
    end

    context 'when ingredient_id is nil' do
      subject(:recipe_ingredient) { build(:recipe_ingredient, ingredient_id: nil) }

      it 'is not valid' do
        expect(recipe_ingredient).not_to be_valid
      end
    end
  end

  describe 'quantity_unit enum' do
    it 'is defined' do
      expect(described_class.quantity_units).to be_present
    end
  end
end
