class Match < ApplicationRecord
  belongs_to :user
  belongs_to :music_suggestion
  belongs_to :recipe

  def generate_final_match
    @food_type_selection    = params[:food_type_selection]
    @difficulty_selection   = params[:difficulty_selection]
    @music_genres_selection = params[:music_genres]
    @music_format_selection = params[:music_format_selection]
  end

end
