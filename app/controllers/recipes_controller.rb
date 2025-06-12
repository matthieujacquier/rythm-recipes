class RecipesController < ApplicationController
  def generate
    difficulty = params[:difficulty_selection]
    food_type = params[:food_type_selection]

    AiRecipeJob.perform_later(difficulty, food_type)
    head :ok
  end
end
