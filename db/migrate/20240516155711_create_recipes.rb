class CreateRecipes < ActiveRecord::Migration[6.0]
  def change
    create_table :recipes do |t|
      t.string :title
      t.integer :servings
      t.integer :prep_time_min
      t.integer :cook_time_min
      t.string :instructions
      t.timestamps
    end
  end
end
