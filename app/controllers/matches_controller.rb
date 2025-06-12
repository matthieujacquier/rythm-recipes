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

    # redirect_to match_results_path
    redirect_to music_suggestions_matches_path
  end

  def match_results
    Rails.logger.debug "📦 Session data in match_results: #{session[:match_data].inspect}"

    # if session[:match_data].present?
      @selected_food = session[:match_data]["food_type"]
      @difficulty = session[:match_data]["difficulty"]
      @genres = session[:match_data]["genres"]
      @format = session[:match_data]["format"]
    # else
    #   redirect_to root_path, alert: "Please complete the form first."
    # end
  end

  def music_suggestions

    @genres = session[:match_data]["genres"]
    @format = session[:match_data]["format"]
    @music_suggestions = MusicSuggestion.where(genre: @genres)
  end
end
