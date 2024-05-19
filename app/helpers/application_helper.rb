module ApplicationHelper
  def float_to_fraction(float)
    # If the number is an integer, just return it as a string
    return float.to_s if (float % 1).zero?

    # Convert float to a fraction
    fraction = Rational(float).rationalize(0.01)
    numerator = fraction.numerator
    denominator = fraction.denominator

    "#{numerator}/#{denominator}"
  end
end
