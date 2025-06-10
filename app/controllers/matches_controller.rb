class MatchesController < ApplicationController
  def index
  end
  
  def generate
    selected_option = params[:food_type_selection]
    food_types_to_match = []

    case selected_option
    when "Meat", "Vegan", "Vegetarian", "Fish"
      food_types_to_match << selected_option
    when "Shuffle"
      all_food_types = ["Meat", "Vegan", "Vegetarian", "Fish"]
      num_types_to_pick = rand(1..all_food_types.length)
      food_types_to_match = all_food_types.sample(num_types_to_pick)
    end
  end
end
