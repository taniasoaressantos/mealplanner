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
    options = {
      max_cook_time: params[:max_cook_time],
      max_prep_time: params[:max_prep_time],
      min_rating: params[:min_rating],
      limit: params[:limit],
      sort_by: params[:sort]
    }

    @recipes = RecipeSuggestionService.new(ingredient_names, options).perform
  end
end
