class MatchesController < ApplicationController
  def index
    @recipes = Recipe.limit(4)
end

  def create
    @recipe = Recipe.find(params[:id])
  end
end
