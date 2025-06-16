class RemoveNotNullConstraintFromMatchIdInRecipes < ActiveRecord::Migration[7.1]
  def change
    change_column_null :recipes, :match_id, true
  end
end
