class DataImporter
  # Fetches data from a source and processes it to create recipes

  def initialize(source, type: :json)
    @fetcher = DataFetcher.new(source, type: type)
  end

  def perform
    data = fetcher.perform
    RecipeCreator.process_recipe_data(data)
  end

  private

  attr_reader :fetcher
end
