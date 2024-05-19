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
    let(:recipe) { create(:recipe, title: 'Cake') }
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

    it 'limits the number of returned recipes' do
      get :suggestions, params: { ingredients: 'flour', limit: 1 }
      expect(assigns(:recipes).size).to eq(1)
    end
  end
end
