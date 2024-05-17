require 'rails_helper'

RSpec.describe Ingredient do
  let(:ingredient) { create(:ingredient) }

  it 'has a valid factory' do
    expect(build(:ingredient)).to be_valid
  end

  describe 'ActiveRecord associations' do
    it { expect(ingredient).to have_many(:recipe_ingredients) }
    it { expect(ingredient).to have_many(:recipes).through(:recipe_ingredients) }
  end

  describe 'ActiveModel validations' do
    it { expect(ingredient).to validate_presence_of(:name) }
    it { expect(ingredient).to validate_uniqueness_of(:name).case_insensitive }
  end
end
