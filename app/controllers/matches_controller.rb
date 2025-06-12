class MatchesController < ApplicationController

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

  redirect_to match_results_path
  end

  def recipe_suggestions
    Rails.logger.debug "🔍 Params in recipe_suggestions: #{params.inspect}"
    Rails.logger.debug "📦 Session data in recipe_suggestions: #{session[:match_data].inspect}"
    if session[:match_data].present?
      @selected_food = session[:match_data][:food_type]
      @difficulty = session[:match_data][:difficulty]
      if @selected_food.present? && @difficulty.present?
        @recipes = Recipe.where(food_type: @selected_food, difficulty: @difficulty).limit(4)
      else
        @recipes = Recipe.limit(4)
      end
    else
      redirect_to root_path, alert: "Please complete the form first."
    end
  end


  def music_suggestions
    Rails.logger.debug "🎶 Params in music_suggestions: #{params.inspect}"
    Rails.logger.debug "📦 Session data in music_suggestions: #{session[:match_data].inspect}"
    if session[:match_data].present?
      @genres = session[:match_data][:genres] || []
      if @genres.present?
        @music_suggestions = MusicSuggestion.where(genre: @genres).sample(3)
      else
        @music_suggestions = MusicSuggestion.limit(3)
      end
    else
      redirect_to root_path, alert: "Please complete the form first."
    end
  end

  def match_results
  Rails.logger.debug "📦 Session data in match_results: #{session[:match_data].inspect}"

  if session[:match_data].present?
    @selected_food = session[:match_data][:food_type]
    @difficulty = session[:match_data][:difficulty]
    @genres = session[:match_data][:genres] || []
    @format = session[:match_data][:format]
    else
      redirect_to root_path, alert: "Please complete the form first."
    end
  end
end
