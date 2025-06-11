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
    difficulty: rand(1..3),
    food_type: ["Vegan", "Vegetarian", "Meat", "Fish"].sample,
    image_url: "url",
    ingredients: [
      { name: "Tomatoes", quantity: "200g" },
      { name: "Pasta", quantity: "300g" },
      { name: "Basil", quantity: "10g" }
    ],
    portion_size: 4,
    instructions: [
      { title: "Boil Pasta", description: "Cook pasta in salted water until al dente." },
      { title: "Prepare Sauce", description: "Chop tomatoes and simmer with basil." },
      { title: "Combine", description: "Mix pasta with sauce and serve hot." }
    ],
    cuisine: ["Italian", "French", "Indian", "Mexican"].sample,
    duration: rand(60..180),
    description: recipe_description,
    match: self
  )
end
end
