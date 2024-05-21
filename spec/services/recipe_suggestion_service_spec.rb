require 'rails_helper'

RSpec.describe RecipeSuggestionService, type: :service do
  let(:flour) { create(:ingredient, name: 'flour') }
  let(:sugar) { create(:ingredient, name: 'sugar') }
  let(:egg) { create(:ingredient, name: 'egg') }
  let(:butter) { create(:ingredient, name: 'butter') }
  let(:almond_flour) { create(:ingredient, name: 'finely ground almond flour') }

  let(:cake) { create(:recipe, title: 'Cake', cook_time_min: 30, prep_time_min: 15, rating: 5) }
  let(:cookies) { create(:recipe, title: 'Cookies', cook_time_min: 15, prep_time_min: 10, rating: 4.5) }
  let(:pancakes) { create(:recipe, title: 'Pancakes', cook_time_min: 20, prep_time_min: 5, rating: 4) }
  let(:almond_cake) { create(:recipe, title: 'Almond Cake', cook_time_min: 40, prep_time_min: 20, rating: 4.2) }

  before do
    create(:recipe_ingredient, recipe: cake, ingredient: flour)
    create(:recipe_ingredient, recipe: cake, ingredient: sugar)
    create(:recipe_ingredient, recipe: cake, ingredient: egg)

    create(:recipe_ingredient, recipe: cookies, ingredient: sugar)
    create(:recipe_ingredient, recipe: cookies, ingredient: egg)

    create(:recipe_ingredient, recipe: pancakes, ingredient: butter)

    create(:recipe_ingredient, recipe: almond_cake, ingredient: almond_flour)
  end

  describe '#perform' do
    context 'with multiple matching ingredients' do
      let(:recipes) do
        described_class.new(
          %w[flour sugar egg],
          { limit: 10, sort_by: 'rating' }
        ).perform
      end

      it 'returns recipes ordered by rating' do
        expect(recipes).to eq([cake, cookies, almond_cake])
      end
    end

    context 'with no matching recipes' do
      let(:recipes) do
        described_class.new(
          %w[chocolate milk],
          { limit: 10 }
        ).perform
      end

      it 'returns an empty array if no recipes match' do
        expect(recipes).to be_empty
      end
    end

    context 'with partial matches' do
      let(:recipes) do
        described_class.new(
          %w[flour sugar],
          { limit: 10 }
        ).perform
      end

      it 'returns recipes even with partial matches' do
        expect(recipes).to include(cake, cookies, almond_cake)
      end
    end

    context 'with partial matches and sorting by prep time' do
      let(:recipes) do
        described_class.new(
          %w[flour sugar],
          { limit: 10, sort_by: 'prep_time' }
        ).perform
      end

      it 'returns recipes sorted by prep time' do
        expect(recipes).to eq([cookies, cake, almond_cake])
      end
    end

    context 'with filtering by max prep time' do
      let(:recipes) do
        described_class.new(
          %w[flour sugar],
          { max_prep_time: 15, limit: 10 }
        ).perform
      end

      it 'returns recipes with prep time less than or equal to max prep time' do
        expect(recipes).to include(cake, cookies)
      end

      it 'does not return recipes with prep time greater than or equal to max prep time' do
        expect(recipes).not_to include(almond_cake)
      end
    end

    context 'with filtering by max cook time' do
      let(:recipes) do
        described_class.new(
          %w[flour sugar],
          { max_cook_time: 30, limit: 10 }
        ).perform
      end

      it 'returns recipes with cook time less than or equal to max cook time' do
        expect(recipes).to include(cake, cookies)
      end

      it 'does not return recipes with cook time greater than or equal to max cook time' do
        expect(recipes).not_to include(almond_cake)
      end
    end

    context 'with a limit on the number of recipes' do
      let(:recipes) do
        described_class.new(
          %w[flour sugar egg butter],
          { limit: 1, sort_by: 'prep_time' }
        ).perform
      end

      it 'limits the number of returned recipes' do
        expect(recipes.size).to eq(1)
      end
    end
  end
end
