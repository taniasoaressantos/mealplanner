class RecipeCreator
  # Manages creation of recipes and related entities in the database

  def self.process_recipe_data(data)
    data.each do |recipe_entry|
      next if recipe_entry['title'].blank? || recipe_entry['ingredients'].blank?

      ActiveRecord::Base.transaction do
        recipe = create_recipe!(recipe_entry)
        next unless recipe

        process_ingredients(recipe, recipe_entry['ingredients'])
      rescue StandardError => e
        Rails.logger.error("Failed to process recipe: #{recipe_entry['title']}. Error: #{e.message}")
      end
    end
  end

  def self.create_recipe!(entry)
    Recipe.create!(
      title: entry['title'],
      cook_time_min: entry['cook_time'],
      prep_time_min: entry['prep_time'],
      rating: entry['ratings'],
      cuisine: entry['cuisine'].singularize.downcase.strip,
      category: entry['category'],
      author: entry['author'],
      image: entry['image']
    )
  end

  def self.process_ingredients(recipe, ingredients)
    ingredients.each do |ingredient_entry|
      parsed_ingredient = IngredientParser.parse(ingredient_entry)
      next if parsed_ingredient[:error]

      ingredient = find_or_create_ingredient(parsed_ingredient[:name])
      next unless ingredient

      create_recipe_ingredient!(recipe, ingredient, parsed_ingredient)
    end
  end

  def self.find_or_create_ingredient(name)
    Ingredient.find_or_create_by(name: name.singularize.downcase.strip)
  end

  def self.create_recipe_ingredient!(recipe, ingredient, parsed_ingredient)
    RecipeIngredient.create!(
      recipe: recipe,
      ingredient: ingredient,
      quantity: parsed_ingredient[:quantity],
      quantity_unit: parsed_ingredient[:unit]
    )
  end
end
