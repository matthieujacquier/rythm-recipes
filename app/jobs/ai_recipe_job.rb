class AiRecipeJob < ApplicationJob
  queue_as :default

  def perform(difficulty, food_type)
  recipe = RecipeGenerator.new(difficulty: difficulty, food_type: food_type).call
    Rails.logger.info("Generated Recipe: #{recipe}")
  end
end
