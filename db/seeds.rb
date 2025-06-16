require 'open-uri'
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

 GENRES.each do |genre|
   puts "Fetching album for genre: #{genre}"

   albums = spotify.search_albums(genre)
   next unless albums.present?

   albums.each do |album|
   music_suggestion = MusicSuggestion.find_or_initialize_by(spotify_id: album['id'])
   music_suggestion.update!(
     name: album['name'],
     image_url: album['images'][0]['url'],
     #this ensure we get the first image if there are several
     genre: genre,
     artists: album['artists'].map { |name| name['name'] },
     #album is an array of ashes. For each hash, we iterate an return an array with .map which only returns the name (there are other available parameters such as artist_id)
     tracklist: album['href'],
     preview_url: nil,
     #will not be used. I guess we can delete it from the table?
     album: true
   )

    puts "Saved: #{music_suggestion.name} (#{genre})"
  end
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

puts "Seeding recipes..."

difficulties = ["Easy", "Medium", "Hard"]
food_types = ["Vegan", "Vegetarian", "Meat", "Seafood"]

food_types.each do |food_type|
  difficulties.each do |difficulty|
    1.times do
      recipe_data = RecipeGenerator.new(difficulty: difficulty, food_type: food_type).call

      recipe_name = recipe_data["name"]
      recipe_description = recipe_data["description"]
      ingredients = recipe_data["ingredients"]
      instructions = recipe_data["instructions"]

      existing_recipe = Recipe.find_by(name: recipe_name)
      if existing_recipe
        puts "Skipping duplicate recipe: #{recipe_name}"
        next
      end
      image_url = ApifyImages.new(recipe_name).fetch_image_url
      puts "📸 Image found: #{image_url || 'No image'}"

      # Create the recipe in the database
      Recipe.create!(
        name: recipe_name,
        difficulty: difficulty,
        food_type: food_type,
        image_url: image_url,
        ingredients: ingredients,
        portion_size: 4,
        instructions: instructions,
        cuisine: recipe_data["cuisine"],
        duration: recipe_data["duration"],
        description: recipe_description
      )
      puts "Created Recipe: #{recipe_name} (#{food_type}, #{difficulty})"
    end
  end
end

food_suggestions = Recipe.all.to_a

puts "Seeding complete!"

puts "Seeding matches..."

match1 =  Match.create!(
recipe_name: "Shrimp Scampi Meets Salsa Verde",
recipe_description: "This shrimp pasta with cilantro and lime is spicy, citrusy, and bold.",
user: user1,
music_suggestion: music_suggestions.sample,
recipe: food_suggestions.sample
)
