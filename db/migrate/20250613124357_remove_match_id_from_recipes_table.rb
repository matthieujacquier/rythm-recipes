class RemoveMatchIdFromRecipesTable < ActiveRecord::Migration[7.1]
  def change
    remove_reference :recipes, :match
  end
end
