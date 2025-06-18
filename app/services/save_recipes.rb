require_relative '../../config/environment'
require 'json'

class SaveRecipes
  def self.call
    recipes = Recipe.all.as_json(except: [:id, :created_at, :updated_at])

    File.open("recipes.json", "w") do |f|
      f.write(JSON.pretty_generate(recipes))
    end

    puts "Recipes saved to recipes.json"
  end
end
