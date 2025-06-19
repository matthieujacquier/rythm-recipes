require 'open-uri'
require 'json'

file_path = Rails.root.join('db', 'album_desc_seeds.json')
albums_by_genre = JSON.parse(File.read(file_path))

Match.delete_all
Recipe.delete_all
User.delete_all
MusicSuggestion.delete_all

puts "Defining genres"

GENRES = [
  'Pop','Rock', 'Hip-Hop', 'Rap', 'R&B', 'Indie',
  'Electronic', 'Dance', 'Alternative', 'Jazz', 'Classical',
  'Folk', 'Country', 'Metal', 'Punk', 'Blues', 'Reggae', 'Soul', 'Funk', 'Techno', 'Afro'
]

spotify = SpotifyClient.new

albums_by_genre.each do |album_info|
    genre = album_info["genre"]
    artist_name = album_info["artist"]
    album_title = album_info["album"]
    description = album_info["description"]

    puts "Searching album '#{album_title}' by '#{artist_name}'"

    album_data = spotify.search_album_by_artist_and_title(artist_name, album_title)
    unless album_data
      puts "Album not found: #{album_title} by #{artist_name}"
      next
    end

    music_suggestion = MusicSuggestion.find_or_initialize_by(spotify_id: album_data['id'])
    music_suggestion.update!(
      name: album_data['name'],
      image_url: album_data['images'][0]['url'],
      genre: genre,
      artists: album_data['artists'].map { |a| a['name'] },
      tracklist: album_data['href'],
      preview_url: nil,
      album: true,
      description: description
    )
    puts "Saved: #{album_data['name']} (#{genre})"
end

puts "Fetching playlists..."

GENRES.each do |genre|
  puts "Fetching playlist for genre: #{genre}"

  playlists = spotify.search_playlists(genre)
  next unless playlists.present?

  playlists.each do |playlist|
  next unless playlist.is_a?(Hash) && playlist['id']
  music_suggestion = MusicSuggestion.find_or_initialize_by(spotify_id: playlist['id'])
  music_suggestion.update!(
    name: playlist['name'],
    image_url: playlist['images'][0]['url'],
    genre: genre,
    artists: ["Various Artists"],
    tracklist: playlist['href'],
    preview_url: nil,
    album: false
  )

    puts "Saved playlist: #{music_suggestion.name} (#{genre})"
  end
end

#turns MusicSuggestion object into an array. So that we can sample over it
music_suggestions = MusicSuggestion.all.to_a

puts "Seeding users..."

user5 = User.create(
  email: "matthieu@example.com",
  password: "password123",
  first_name: "Matthieu",
  last_name: "Rap",
  admin: true
)

user1 = User.create(
  email: "sam@example.com",
  password: "password123",
  first_name: "Sam",
  last_name: "Techno",
  admin: true
)

user2 = User.create(
  email: "marta@example.com",
  password: "password123",
  first_name: "Marta",
  last_name: "Rock",
  admin: true
)

user3 = User.create(
  email: "pelin@example.com",
  password: "password123",
  first_name: "Pelin",
  last_name: "Jazz",
  admin: true
)

user4 = User.create(
  email: "sneha@example.com",
  password: "password123",
  first_name: "Sneha",
  last_name: "Reggae",
  admin: true
)

users = [user1, user2, user3, user4, user5]

puts "Created #{User.count} users"

puts "Seeding recipes with JSON..."

# Load recipes from JSON file
file_path_recipes = Rails.root.join('db', 'recipes.json')
seed_recipes = JSON.parse(File.read(file_path_recipes))

# Seed from JSON file first
seed_recipes.each do |recipe_data|
  recipe_name = recipe_data["name"]
  next if Recipe.exists?(name: recipe_name)

  begin
    image_url = recipe_data["image_url"].presence || ApifyImages.new(recipe_name).fetch_image_url

    Recipe.create!(
      name: recipe_name,
      difficulty: recipe_data["difficulty"],
      food_type: recipe_data["food_type"],
      image_url: image_url,
      ingredients: recipe_data["ingredients"],
      portion_size: recipe_data["portion_size"],
      instructions: recipe_data["instructions"],
      cuisine: recipe_data["cuisine"],
      duration: recipe_data["duration"],
      description: recipe_data["description"]
    )

    puts " Seeded from file: #{recipe_name}"
  rescue => e
    puts "⚠️ Failed to seed from file: #{recipe_name} - #{e.message}"
  end
  puts "📦 Found #{seed_recipes.size} recipes to seed"
end


# puts "Seeding recipes with openAI..."

# ["easy", "medium", "hard"].each do |difficulty|
#   ["meat", "vegetarian", "vegan", "seafood"].each do |food_type|
#     puts "🔄 Generating recipes for: #{difficulty.capitalize} / #{food_type.capitalize}"
#     begin
#       recipes = RecipeGenerator.new(difficulty: difficulty, food_type: food_type).call

#       recipes.each do |recipe_data|
#         begin
#           recipe_name = recipe_data["name"]
#           next if Recipe.exists?(name: recipe_name)

#           image_url = ApifyImages.new(recipe_name).fetch_image_url

#           Recipe.create!(
#             name: recipe_name,
#             difficulty: difficulty,
#             food_type: food_type,
#             image_url: image_url,
#             ingredients: recipe_data["ingredients"],
#             portion_size: 4,
#             instructions: recipe_data["instructions"],
#             cuisine: recipe_data["cuisine"],
#             duration: recipe_data["duration"],
#             description: recipe_data["description"]
#           )

#           puts "✅ Created: #{recipe_name}"
#         rescue => e
#           puts "⚠️ Failed to create recipe: #{e.message}"
#         end
#       end
#     rescue => e
#       puts "⚠️ Failed for #{difficulty}/#{food_type}: #{e.message}"
#     end
#   end
# end


# food_suggestions = Recipe.all.to_a


puts "Seeding complete!"
