require 'rails_helper'

RSpec.describe DataImporter do
  subject(:data_importer) { described_class.new(source, type: type) }

  let(:source) { 'path/to/source.json' }
  let(:type) { :json }
  let(:data_fetcher) { instance_double(DataFetcher) }
  let(:recipe_data) { [{ title: 'Recipe 1', ingredients: ['1 cup flour'] }] }

  before do
    allow(DataFetcher).to receive(:new).with(source, type: type).and_return(data_fetcher)
    allow(data_fetcher).to receive(:perform).and_return(recipe_data)
    allow(RecipeCreator).to receive(:process_recipe_data)
  end

  describe '#perform' do
    it 'fetches data from the data fetcher and processes it to create recipes' do
      data_importer.perform
      expect(data_fetcher).to have_received(:perform)
    end

    it 'calls RecipeCreator to create recipes' do
      data_importer.perform
      expect(RecipeCreator).to have_received(:process_recipe_data).with(recipe_data)
    end
  end
end
