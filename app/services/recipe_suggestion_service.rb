class RecipeSuggestionService
  # This service is responsible for suggesting recipes based on a list of ingredients.
  # It filters recipes by the number of matching ingredients and returns the top results.

  def initialize(ingredient_names, limit = 10)
    @ingredient_names = ingredient_names.map(&:downcase).map(&:strip).map(&:singularize)
    @limit = limit
  end

  def perform
    recipes = Recipe.all
    recipes = filter_by_ingredients(recipes)
    recipes.limit(limit)
  end

  private

  attr_reader :ingredient_names, :limit, :cuisine, :category

  def filter_by_ingredients(recipes)
    subquery = Recipe.joins(:ingredients)
                     .where(ingredients: { name: ingredient_names })
                     .select('recipes.id, COUNT(DISTINCT ingredients.id) AS match_count')
                     .group('recipes.id')

    recipes.joins("JOIN (#{subquery.to_sql}) AS sub ON recipes.id = sub.id")
           .select('recipes.*, sub.match_count')
           .order('sub.match_count DESC')
  end
end
