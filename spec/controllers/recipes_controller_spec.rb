require 'rails_helper'

RSpec.describe RecipesController do
  describe 'GET #index' do
    let!(:recipes) { create_list(:recipe, 10) }

    it 'assigns @initial_recipes' do
      get :index
      expect(assigns(:initial_recipes)).to eq(recipes.first(10))
    end

    it 'assigns @all_recipes' do
      get :index
      expect(assigns(:all_recipes)).to eq(recipes)
    end

    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #show' do
    let(:recipe) { create(:recipe) }

    it 'assigns the requested recipe to @recipe' do
      get :show, params: { id: recipe.id }
      expect(assigns(:recipe)).to eq(recipe)
    end

    it 'returns http success' do
      get :show, params: { id: recipe.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #suggestions' do
    let(:ingredient) { create(:ingredient, name: 'flour') }
    let(:recipe) { create(:recipe, title: 'Cake', cook_time_min: 30, prep_time_min: 15, rating: 4.5) }
    let(:service) { instance_double(RecipeSuggestionService, perform: [recipe]) }

    before do
      create(:recipe_ingredient, recipe: recipe, ingredient: ingredient)
      allow(RecipeSuggestionService).to receive(:new).and_return(service)
    end

    it 'returns http success' do
      get :suggestions, params: { ingredients: 'flour' }
      expect(response).to have_http_status(:success)
    end

    it 'assigns @recipes' do
      get :suggestions, params: { ingredients: 'flour' }
      expect(assigns(:recipes)).to eq([recipe])
    end

    it 'calls RecipeSuggestionService with correct parameters' do
      get :suggestions, params: { ingredients: 'flour' }
      expect(RecipeSuggestionService).to have_received(:new).with(
        ['flour'], hash_including(max_cook_time: nil, max_prep_time: nil,
                                  min_rating: nil, limit: nil, sort_by: nil)
      )
    end

    it 'calls RecipeSuggestionService with all parameters' do
      get :suggestions, params: {
        ingredients: 'flour', max_cook_time: '30', max_prep_time: '15',
        min_rating: '4.0', limit: '1', sort: 'prep_time'
      }

      expect(RecipeSuggestionService).to have_received(:new).with(
        ['flour'], hash_including(max_cook_time: '30', max_prep_time: '15',
                                  min_rating: '4.0', limit: '1', sort_by: 'prep_time')
      )
    end
  end
end
