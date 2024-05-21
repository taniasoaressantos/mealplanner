class RecipeSuggestionService
  # This service is responsible for suggesting recipes based on a list of ingredients
  # and optional filters for cook time and prep time and rating.
  def initialize(ingredient_names, options = {})
    @ingredient_names = ingredient_names.map(&:downcase).map(&:strip).map(&:singularize)
    @max_cook_time = options.fetch(:max_cook_time, nil)
    @max_prep_time = options.fetch(:max_prep_time, nil)
    @min_rating = options.fetch(:min_rating, nil)
    @limit = options.fetch(:limit, 10)
    @sort_by = options.fetch(:sort_by, 'rating')
  end

  def perform
    recipes = Recipe.all
    recipes = filter_by_time(recipes)
    recipes = filter_by_rating(recipes)
    recipes = filter_by_ingredients(recipes)
    recipes = sort_results(recipes)
    recipes.limit(limit)
  end

  private

  attr_reader :ingredient_names, :max_cook_time, :max_prep_time, :min_rating, :limit, :sort_by

  def filter_by_time(recipes)
    recipes = recipes.where('cook_time_min <= ?', max_cook_time) if max_cook_time.present?
    recipes = recipes.where('prep_time_min <= ?', max_prep_time) if max_prep_time.present?
    recipes
  end

  def filter_by_rating(recipes)
    recipes.where('rating >= ?', min_rating) if min_rating.present?
    recipes
  end

  def filter_by_ingredients(recipes)
    patterns = ingredient_names.map { |name| "%#{name}%" }

    recipes.joins(:ingredients)
           .where('ingredients.name ILIKE ANY (array[?])', patterns)
           .distinct
  end

  def sort_results(recipes)
    case sort_by
    when 'prep_time'
      recipes.order('prep_time_min ASC')
    when 'cook_time'
      recipes.order('cook_time_min ASC')
    else
      recipes.order('rating DESC')
    end
  end
end
