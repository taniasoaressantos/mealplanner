require 'rails_helper'

RSpec.describe Recipe do
  let(:recipe) { create(:recipe) }

  it 'has a valid factory' do
    expect(build(:recipe)).to be_valid
  end

  describe 'ActiveRecord associations' do
    it { is_expected.to have_many(:recipe_ingredients) }
    it { is_expected.to have_many(:ingredients).through(:recipe_ingredients) }
  end

  describe 'ActiveModel validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_length_of(:title).is_at_most(255) }
    it { is_expected.to validate_presence_of(:instructions) }
    it { is_expected.to validate_length_of(:instructions).is_at_most(5000) }
    it { is_expected.to validate_numericality_of(:servings).is_greater_than(0).only_integer.allow_nil }
    it { is_expected.to validate_numericality_of(:prep_time_min).is_greater_than_or_equal_to(0).only_integer.allow_nil }
    it { is_expected.to validate_numericality_of(:cook_time_min).is_greater_than_or_equal_to(0).only_integer.allow_nil }
  end

  describe 'cuisine enum' do
    it 'is defined' do
      expect(described_class.cuisines).to be_present
    end
  end
end
