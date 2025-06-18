require_relative '../config/environment'  # Load Rails environment
require 'json'

recipes = Recipe.all.as_json(only: [:id, :name, :description, :created_at])

File.open("recipes.json", "w") do |f|
  f.write(JSON.pretty_generate(recipes))
end

puts "Recipes saved to recipes.json"
