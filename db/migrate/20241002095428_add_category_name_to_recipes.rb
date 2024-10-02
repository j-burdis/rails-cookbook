class AddCategoryNameToRecipes < ActiveRecord::Migration[7.2]
  def change
    add_column :recipes, :category_name, :string
  end
end
