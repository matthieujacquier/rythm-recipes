class CreateMatches < ActiveRecord::Migration[7.1]
  def change
    create_table :matches do |t|
      t.boolean :saved
      t.integer :rating
      t.string :recipe_name
      t.string :recipe_description
      t.references :user, null: false, foreign_key: true
      t.references :music_suggestion, null: false, foreign_key: true

      t.timestamps
    end
  end
end
