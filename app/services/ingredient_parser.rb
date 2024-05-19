class IngredientParser
  # Parses ingredients from recipe data

  FRACTIONAL_UNICODE = {
    '¼' => 0.25,
    '½' => 0.5,
    '¾' => 0.75,
    '⅐' => 1.0 / 7,
    '⅑' => 1.0 / 9,
    '⅒' => 1.0 / 10,
    '⅓' => 1.0 / 3,
    '⅔' => 2.0 / 3,
    '⅕' => 1.0 / 5,
    '⅖' => 2.0 / 5,
    '⅗' => 3.0 / 5,
    '⅘' => 4.0 / 5,
    '⅙' => 1.0 / 6,
    '⅚' => 5.0 / 6,
    '⅛' => 1.0 / 8,
    '⅜' => 3.0 / 8,
    '⅝' => 5.0 / 8,
    '⅞' => 7.0 / 8
  }.freeze

  def self.parse(ingredient)
    regex = setup_regex_for_parsing
    match = ingredient.match(regex)

    if match && match[:quantity] && match[:name]
      build_ingredient_hash(match)
    else
      default_ingredient_hash(ingredient)
    end
  end

  def self.build_ingredient_hash(match)
    {
      quantity: convert_fraction_to_float(match[:quantity].strip),
      unit: normalize_unit(match[:unit]&.strip),
      name: match[:name]&.strip
    }
  end

  def self.default_ingredient_hash(ingredient)
    {
      quantity: 1.0,
      unit: 'qb',
      name: ingredient.strip
    }
  end

  def self.setup_regex_for_parsing
    common_units = RecipeIngredient.quantity_units.keys
    regex_pattern = common_units.map { |unit| "#{unit}s?" }.join('|')
    %r{(?<quantity>[\d¼½¾⅐⅑⅒⅓⅔⅕⅖⅗⅘⅙⅚⅛⅜⅝⅞]+(?:\.\d+)?[\d/\s]*)(?<unit>\b(?:#{regex_pattern})\b)?\s+(?<name>.*)}
  end

  def self.convert_fraction_to_float(fraction_str)
    FRACTIONAL_UNICODE.each do |fraction, value|
      fraction_str.gsub!(fraction, value.to_s)
    end
    fraction_str.split.sum do |part|
      part.include?('/') ? Rational(part).to_f : part.to_f
    end
  end

  def self.normalize_unit(unit)
    unit = unit ? unit.chomp('s') : 'unit' # Remove trailing 's' if plural
    RecipeIngredient.quantity_units.include?(unit) ? unit : 'unit'
  end
end
