class IngredientParser
  # Parses ingredients from recipe data

  def self.parse(ingredient)
    regex = setup_regex_for_parsing
    match = ingredient.match(regex)

    if match
      build_ingredient_hash(match)
    else
      ingredient_error(ingredient)
    end
  end

  def self.build_ingredient_hash(match)
    {
      quantity: convert_fraction_to_float(match[:quantity].strip),
      unit: normalize_unit(match[:unit]&.strip),
      name: match[:name]&.strip
    }
  end

  def self.ingredient_error(ingredient)
    Rails.logger.error("Ingredient parsing failed: #{ingredient}")
    { error: "Parsing failed for: #{ingredient}" }
  end

  def self.setup_regex_for_parsing
    common_units = RecipeIngredient.quantity_units.keys
    regex_pattern = common_units.map { |unit| "#{unit}s?" }.join('|')
    %r{(?<quantity>\d+(?:\.\d+)?[\d/\s]*)(?<unit>\b(?:#{regex_pattern})\b)?\s+(?<name>.*)}
  end

  def self.convert_fraction_to_float(fraction_str)
    fraction_str.split.sum do |part|
      part.include?('/') ? Rational(part).to_f : part.to_f
    end
  end

  def self.normalize_unit(unit)
    unit = unit ? unit.chomp('s') : 'unit' # Remove trailing 's' if plural
    RecipeIngredient.quantity_units.include?(unit) ? unit : 'unit'
  end
end
