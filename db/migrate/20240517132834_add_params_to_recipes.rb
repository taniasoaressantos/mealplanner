class AddParamsToRecipes < ActiveRecord::Migration[6.0]
  def up
    change_table :recipes, bulk: true do |t|
      t.float :rating
      t.integer :cuisine
      t.string :category
      t.string :author
      t.string :image
    end
  end

  def down
    change_table :recipes, bulk: true do |t|
      t.remove :rating
      t.remove :cuisine
      t.remove :category
      t.remove :author
      t.remove :image
    end
  end
end
