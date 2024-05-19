require 'rails_helper'

RSpec.describe RecipeSuggestionService, type: :service do
  let(:flour) { create(:ingredient, name: 'flour') }
  let(:sugar) { create(:ingredient, name: 'sugar') }
  let(:egg) { create(:ingredient, name: 'egg') }
  let(:butter) { create(:ingredient, name: 'butter') }

  let(:cake) { create(:recipe, title: 'Cake') }
  let(:cookies) { create(:recipe, title: 'Cookies') }
  let(:pancakes) { create(:recipe, title: 'Pancakes') }

  before do
    create(:recipe_ingredient, recipe: cake, ingredient: flour)
    create(:recipe_ingredient, recipe: cake, ingredient: sugar)
    create(:recipe_ingredient, recipe: cake, ingredient: egg)

    create(:recipe_ingredient, recipe: cookies, ingredient: sugar)
    create(:recipe_ingredient, recipe: cookies, ingredient: egg)

    create(:recipe_ingredient, recipe: pancakes, ingredient: butter)
  end

  describe '#perform' do
    context 'with multiple matching ingredients' do
      let(:ingredient_names) { %w[flour sugar egg] }
      let(:recipes) { described_class.new(ingredient_names).perform }

      it 'returns recipes ordered by the number of matching ingredients' do
        expect(recipes).to eq([cake, cookies])
      end

      it 'returns the correct match count for the first recipe' do
        expect(recipes.first.match_count).to eq(3)
      end

      it 'returns the correct match count for the second recipe' do
        expect(recipes.second.match_count).to eq(2)
      end
    end

    context 'with no matching recipes' do
      let(:ingredient_names) { %w[chocolate milk] }
      let(:recipes) { described_class.new(ingredient_names).perform }

      it 'returns an empty array if no recipes match' do
        expect(recipes).to be_empty
      end
    end

    context 'with partial matches' do
      let(:ingredient_names) { %w[flour sugar] }
      let(:recipes) { described_class.new(ingredient_names).perform }

      it 'returns recipes even with partial matches' do
        expect(recipes).to include(cake, cookies)
      end

      it 'returns the correct match count for the first recipe with partial matches' do
        expect(recipes.first.match_count).to eq(2)
      end
    end

    context 'with a limit on the number of recipes' do
      let(:ingredient_names) { %w[flour sugar egg butter] }
      let(:recipes) { described_class.new(ingredient_names, 1).perform }

      it 'limits the number of returned recipes' do
        expect(recipes.size).to eq(1)
      end
    end
  end
end
