class AiRecipeJob < ApplicationJob
  queue_as :default

  def perform(difficulty, food_type)
    recipe = RecipeGenerator.new(difficulty: difficulty, food_type: food_type).call
    Rails.logger.info("Generated Recipe: #{recipe}")

    recipe_name = recipe[:name]
    image_url = ApifyImages.new(recipe_name).fetch_image_url

    Recipe.create!(
      name: recipe_name,
      description: recipe[:description],
      difficulty: difficulty,
      food_type: food_type,
      image_url: image_url
    )
    puts "📸 Image URL fetched: #{image_url}"
  end
end
