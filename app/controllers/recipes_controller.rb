class RecipesController < ApplicationController
  def index
    @initial_recipes = Recipe.limit(10)
    @all_recipes = Recipe.all
  end

  def show
    @recipe = Recipe.find(params[:id])
  end

  def suggestions
    ingredient_names = params[:ingredients]&.split(',') || []
    limit = params[:limit] || 10

    @recipes = RecipeSuggestionService.new(ingredient_names, limit).perform
  end
end
