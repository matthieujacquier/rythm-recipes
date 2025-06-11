class Match < ApplicationRecord
  belongs_to :user
  belongs_to :music_suggestion
  has_one :recipe
  after_create :create_recipe_from_seed

  def generate_final_match
    @food_type_selection    = params[:food_type_selection]
    @difficulty_selection   = params[:difficulty_selection]
    @music_genres_selection = params[:music_genres]
    @music_format_selection = params[:music_format_selection]
  end


  private

  def create_recipe_from_seed
    Recipe.create!(
      name: recipe_name,
      difficulty: rand(1..5),
      food_type: ["Vegan", "Vegetarian", "Meat", "Seafood", "Dessert"].sample,
      image_url: "url",
      ingredients: "Tomatoes, Pasta, Basil",
      portion_size: 4,
      instructions: "Boil pasta. Add sauce. Mix.",
      cuisine: ["Italian", "French", "Indian", "Mexican"].sample,
      duration: rand(60..180),
      description: recipe_description,
      match: self
    )
  end

end
