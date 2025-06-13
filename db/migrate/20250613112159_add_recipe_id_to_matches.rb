class AddRecipeIdToMatches < ActiveRecord::Migration[7.1]
  def change
     add_reference :matches, :recipe, foreign_key: true
  end
end
