class CreateRecipes < ActiveRecord::Migration[7.1]
  def change
    create_table :recipes do |t|
      t.string :name
      t.integer :difficulty
      t.string :type
      t.string :image_url
      t.jsonb :ingredients, default: []
      t.integer :portion_size
      t.jsonb :instructions, default: []
      t.string :cuisine
      t.integer :duration
      t.text :description
      t.references :match, null: false, foreign_key: true

      t.timestamps
    end
  end
end
