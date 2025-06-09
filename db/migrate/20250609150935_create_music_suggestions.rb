class CreateMusicSuggestions < ActiveRecord::Migration[7.1]
  def change
    create_table :music_suggestions do |t|
      t.string :name
      t.string :image_url
      t.string :genre
      t.string :artists, array: true
      t.text :tracklist
      t.string :preview_url
      t.boolean :album
      t.string :spotify_id

      t.timestamps
    end
  end
end
