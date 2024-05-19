class BackfillRecipes
  include Rake::DSL
  require 'json'

  # Usage: rake db:import_json

  FILE_PATH = Rails.root.join('db/seed_data/recipes-en.json')

  def initialize
    namespace :db do
      desc 'Import data from a JSON file'
      task import_json: :environment do
        start_time = Time.zone.now
        log_start_time(start_time)
        import_data
        log_elapsed_time(start_time)
        log_results
      end
    end
  end

  private

  def import_data
    DataImporter.new(FILE_PATH, type: :json).perform
  end

  def log_start_time(start_time)
    puts "Starting backfill process at #{start_time}"
  end

  def log_elapsed_time(start_time)
    end_time = Time.zone.now
    puts "Backfill process finished at #{end_time}, duration: #{end_time - start_time} seconds"
  end

  def log_results
    data = JSON.parse(File.read(FILE_PATH))
    puts "Total recipes in JSON file: #{data.size}"

    puts 'Backfill process completed.'
    puts "Total recipes created: #{Recipe.count}"
    puts "Total ingredients created: #{Ingredient.count}"
    puts "Total recipe ingredients created: #{RecipeIngredient.count}"
  end
end

BackfillRecipes.new
