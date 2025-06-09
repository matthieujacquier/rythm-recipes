Recipe.delete_all
Match.delete_all
User.delete_all
MusicSuggestion.delete_all

puts "Seeding users..."

user1 = User.create(
  email: "sam@example.com",
  password: "password123",
  first_name: "Sam",
  last_name: "Techno"
)

user2 = User.create(
  email: "marta@example.com",
  password: "password123",
  first_name: "Marta",
  last_name: "Rock"
)

user3 = User.create(
  email: "pelin@example.com",
  password: "password123",
  first_name: "Pelin",
  last_name: "Jazz"
)

user4 = User.create(
  email: "sneha@example.com",
  password: "password123",
  first_name: "Sneha",
  last_name: "Reggae"
)

user5 = User.create(
  email: "matthieu@example.com",
  password: "password123",
  first_name: "Matthieu",
  last_name: "Rap"
)

users = [user1, user2, user3, user4, user5]

puts "Created #{User.count} users"

puts "Seeding music suggestions..."
music_suggestions = 5.times.map do |i|
  MusicSuggestion.create!(
    name: "Chill Beats Vol. #{i + 1}",
    image_url: "https://example.com/image#{i + 1}.jpg",
    genre: ["Lo-fi", "Jazz", "Rock", "Pop", "Classical"].sample,
    artists: ["Artist A", "Artist B", "Artist C"],
    tracklist: "Track 1\nTrack 2\nTrack 3",
    preview_url: "https://spotify.com/preview#{i + 1}",
    album: [true, false].sample,
    spotify_id: "spotify_id_#{i + 1}"
  )
end

puts "Created #{MusicSuggestion.count} Music Suggestions"

puts "Seeding matches..."
matches = 5.times.map do |i|
  Match.create!(
    saved: [true, false].sample,
    rating: rand(1..5),
    recipe_name: "Delicious Dish #{i + 1}",
    recipe_description: "A tasty treat you’ll love.",
    user: users[i],
    music_suggestion: music_suggestions[i]
  )
end

puts "Created #{Match.count} Matches"

puts "Seeding recipes..."
5.times do |i|
  Recipe.create!(
    name: "Pasta Primavera #{i + 1}",
    difficulty: rand(1..5),
    food_type: ["Vegan", "Vegetarian", "Meat", "Seafood", "Dessert"].sample, # replace `type`
    image_url: "https://example.com/recipe#{i + 1}.jpg",
    ingredients: "Tomatoes, Pasta, Basil",
    portion_size: 2,
    instructions: "Boil pasta. Add sauce. Mix.",
    cuisine: ["Italian", "French", "Indian", "Mexican"].sample,
    duration: rand(10..60),
    description: "A fresh and vibrant pasta dish.",
    match: matches[i]
  )
end

puts "Created #{Recipe.count} Recipes"

puts "Seeding complete!"
