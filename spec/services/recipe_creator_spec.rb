require 'rails_helper'

RSpec.describe RecipeCreator do
  let(:recipe_data) do
    [
      {
        'title' => 'Recipe 1',
        'cook_time' => 30,
        'prep_time' => 15,
        'ratings' => 5,
        'cuisine' => 'Italian',
        'category' => 'Main Course',
        'author' => 'Chef John',
        'image' => 'image_url',
        'ingredients' => ['1 cup flour', '2 eggs']
      },
      {
        'title' => '',
        'cook_time' => 30,
        'prep_time' => 15,
        'ratings' => 5,
        'cuisine' => 'Italian',
        'category' => 'Main Course',
        'author' => 'Chef John',
        'image' => 'image_url',
        'ingredients' => ['1 cup flour', '2 eggs']
      },
      {
        'title' => 'Recipe 3',
        'cook_time' => 30,
        'prep_time' => 15,
        'ratings' => 5,
        'cuisine' => 'Italian',
        'category' => 'Main Course',
        'author' => 'Chef John',
        'image' => 'image_url',
        'ingredients' => []
      }
    ]
  end

  let(:parsed_ingredient) { { quantity: 1.0, unit: 'cup', name: 'flour' } }
  let(:logger) { instance_spy(Logger) }

  before do
    allow(Rails).to receive(:logger).and_return(logger)
    allow(IngredientParser).to receive(:parse).and_return(parsed_ingredient)
  end

  describe '.process_recipe_data' do
    it 'creates recipes for valid recipe data' do
      expect do
        described_class.process_recipe_data(recipe_data)
      end.to change(Recipe, :count).by(1)
    end

    it 'creates ingredients for valid recipe data' do
      expect do
        described_class.process_recipe_data(recipe_data)
      end.to change(RecipeIngredient, :count).by(2)
    end

    it 'logs errors during recipe processing' do
      allow(Recipe).to receive(:create!).and_raise(StandardError.new('Test Error'))

      described_class.process_recipe_data([recipe_data.first])
      expect(Rails.logger).to have_received(:error).with(/Failed to process recipe: Recipe 1. Error: Test Error/)
    end
  end

  describe '.create_recipe!' do
    let(:recipe_entry) { recipe_data.first }

    it 'creates a new recipe' do
      expect { described_class.create_recipe!(recipe_entry) }.to change(Recipe, :count).by(1)
    end
  end

  describe '.process_ingredients' do
    let(:recipe) { create(:recipe) }

    it 'processes ingredients and creates recipe ingredients' do
      expect do
        described_class.process_ingredients(recipe, recipe_data.first['ingredients'])
      end.to change(RecipeIngredient, :count).by(2)
    end

    it 'skips processing when ingredient parsing fails' do
      allow(IngredientParser).to receive(:parse).and_return({ error: 'Parsing failed' })

      expect do
        described_class.process_ingredients(recipe, recipe_data.first['ingredients'])
      end.not_to change(RecipeIngredient, :count)
    end
  end

  describe '.find_or_create_ingredient' do
    it 'finds or creates an ingredient' do
      allow(Ingredient).to receive(:find_or_create_by).and_return(instance_double(Ingredient, id: 1))

      described_class.find_or_create_ingredient('flour')
      expect(Ingredient).to have_received(:find_or_create_by).with(name: 'flour')
    end
  end

  describe '.create_recipe_ingredient!' do
    let(:recipe) { instance_double(Recipe, id: 1) }
    let(:ingredient) { instance_double(Ingredient, id: 1) }

    it 'creates a recipe ingredient' do
      allow(RecipeIngredient).to receive(:create!)

      described_class.create_recipe_ingredient!(recipe, ingredient, parsed_ingredient)
      expect(RecipeIngredient).to have_received(:create!).with(
        recipe: recipe,
        ingredient: ingredient,
        quantity: parsed_ingredient[:quantity],
        quantity_unit: parsed_ingredient[:unit]
      )
    end
  end
end
