class AddDescriptionColumnToMusicSuggestion < ActiveRecord::Migration[7.1]
  def change
     add_column :music_suggestions, :description, :string
  end
end
