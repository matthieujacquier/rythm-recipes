class MatchesController < ApplicationController

  def index
    @recipes = Recipe.limit(4)
    genre = params[:genre]

    genre = GENRES.sample if genre == "surprise me"

    @music_suggestions = MusicSuggestion.limit(3)
    #if genre.present?
    #@music_suggestions = MusicSuggestion.where(genre: genre).sample(3)
    #else
    #@music_suggestions = []
    #end
  end

  def create
     @music = MusicSuggestion.find(session[:match_data]["selected_music_id"])
    @recipe_data = Recipe.find(14)

    @match = Match.new(
      user: current_user,
      music_suggestion: @music,
      recipe_name: @recipe_data.name,
      recipe_description: @recipe_data.description
    )

    @match.recipe = Recipe.find(14)

    @match.save!

    redirect_to match_path(@match)
  end

  def show
    @match = Match.find(params[:id])
  end

  def save
    @match = Match.find(params[:id])
    @match.update(saved: true)
    redirect_to match_path(@match), notice: "Match has been saved."
  end

  def unsave
    @match = Match.find(params[:id])
    @match.update(saved: false)
    redirect_to match_path(@match), notice: "Match is no longer saved."
  end

  def generate
    Rails.logger.debug "🎯 Params received in generate: #{params.inspect}"

    session[:match_data] = {
      food_type: params[:food_type_selection],
      difficulty: params[:difficulty_selection],
      genres: params[:music_genres],
      format: params[:music_format_selection]

    }

    Rails.logger.debug "💾 Stored in session: #{session[:match_data].inspect}"

    redirect_to music_suggestions_matches_path
  end

  def match_results
    Rails.logger.debug "📦 Session data in match_results: #{session[:match_data].inspect}"

    # if session[:match_data].present?
      @selected_food = session[:match_data]["food_type"]
      @difficulty = session[:match_data]["difficulty"]
      # @genres = session[:match_data]["genres"]
      # @format = session[:match_data]["format"]
    # else
    #   redirect_to root_path, alert: "Please complete the form first."
    # end
  end

  def music_suggestions

    @genres = session[:match_data]["genres"]
    @format = session[:match_data]["format"]
    if @format == "Album"
      @albums_by_genre = MusicSuggestion.where(genre: @genres, album: true).sample(3)
      @music_suggestions = @albums_by_genre.sample(3)
    elsif @format == "Playlist"
      @playlists_by_genre = MusicSuggestion.where(genre: @genres, album: false)
      @music_suggestions = @playlists_by_genre.sample(3)
    end
  end

  def select_music
    session[:match_data][:selected_music_id] = params[:music_suggestion_id]
    redirect_to recipe_selection_matches_path
  end

  def recipe_selection
    @selected_food = session[:match_data]["food_type"]
    @difficulty = session[:match_data]["difficulty"]
    @recipes = Recipe.where(food_type: @selected_food, difficulty: @difficulty).sample(4)
  end
end
