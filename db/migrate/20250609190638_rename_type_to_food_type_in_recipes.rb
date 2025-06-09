class RenameTypeToFoodTypeInRecipes < ActiveRecord::Migration[7.1]
  def change
    rename_column :recipes, :type, :food_type
  end
end
