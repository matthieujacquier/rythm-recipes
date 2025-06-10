class MatchesController < ApplicationController

  def index
    @recipes = Recipe.limit(4)
    @music_suggestions = MusicSuggestion.all
  end

  def create
    @recipe = Recipe.find(params[:recipe_id])
    @match = Match.new(recipe: @recipe, user: current_user) #Creates a new match with the current user and the selected recipe.
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

end
