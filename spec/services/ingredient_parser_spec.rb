require 'rails_helper'

describe IngredientParser, type: :service do
  describe '.parse' do
    context 'when parsing basic ingredients' do
      it 'parses an ingredient with whole numbers' do
        expect(described_class.parse('2 cups sugar')).to eq(
          {
            quantity: 2.0,
            unit: 'cup',
            name: 'sugar'
          }
        )
      end

      it 'parses an ingredient with singular units' do
        expect(described_class.parse('1 tablespoon salt')).to eq(
          {
            quantity: 1.0,
            unit: 'tablespoon',
            name: 'salt'
          }
        )
      end

      it 'parses an ingredient with plural units' do
        expect(described_class.parse('3 cups flour')).to eq(
          {
            quantity: 3.0,
            unit: 'cup',
            name: 'flour'
          }
        )
      end
    end

    context 'when parsing ingredients with fractions' do
      it 'parses an ingredient with fractional quantities' do
        expect(described_class.parse('1/2 cup water')).to eq(
          {
            quantity: 0.5,
            unit: 'cup',
            name: 'water'
          }
        )
      end

      it 'parses an ingredient with mixed numbers' do
        expect(described_class.parse('2 1/2 cups milk')).to eq(
          {
            quantity: 2.5,
            unit: 'cup',
            name: 'milk'
          }
        )
      end
    end

    context 'when parsing ingredients with floats' do
      it 'parses an ingredient with floating quantities' do
        expect(described_class.parse('0.75 liter oil')).to eq(
          {
            quantity: 0.75,
            unit: 'liter',
            name: 'oil'
          }
        )
      end
    end

    context 'when parsing ingredients without units' do
      it 'parses an ingredient without a unit and defaults to "unit"' do
        expect(described_class.parse('1 egg')).to eq(
          {
            quantity: 1.0,
            unit: 'unit',
            name: 'egg'
          }
        )
      end

      it 'parses multiple ingredients without units' do
        expect(described_class.parse('2 eggs')).to eq(
          {
            quantity: 2.0,
            unit: 'unit',
            name: 'eggs'
          }
        )
      end
    end

    context 'when parsing complex ingredient names' do
      it 'parses an ingredient with a complex name' do
        expect(described_class.parse('1 cup chopped red bell pepper')).to eq(
          {
            quantity: 1.0,
            unit: 'cup',
            name: 'chopped red bell pepper'
          }
        )
      end

      it 'parses an ingredient with non-alphanumeric characters in the name' do
        expect(described_class.parse('1/2 teaspoon black pepper, ground')).to eq(
          {
            quantity: 0.5,
            unit: 'teaspoon',
            name: 'black pepper, ground'
          }
        )
      end
    end

    context 'when input is not parseable' do
      it 'returns an error' do
        expect(described_class.parse('something unparseable')).to include(:error)
      end
    end
  end
end
