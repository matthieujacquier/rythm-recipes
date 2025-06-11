class MatchesController < ApplicationController

  def index
    @recipes = Recipe.limit(4)
    genre = params[:genre]

    genre = GENRES.sample if genre == "surprise me"

    if genre.present?
    @music_suggestions = MusicSuggestion.where(genre: genre).sample(3)
    else
    @music_suggestions = []
    end
  end

  def create
    @recipe = Recipe.find(params[:recipe_id])
    @match = Match.new(recipe: @recipe, user: current_user)
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
