require 'open-uri'
require 'json'

file_path = Rails.root.join('db', 'album_desc_seeds.json')
albums_by_genre = JSON.parse(File.read(file_path))

Match.delete_all
# Recipe.delete_all
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

puts "Seeding recipes..."

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


# puts "Seeding complete!"

# puts "Seeding matches..."

# match1 =  Match.create!(
# recipe_name: "Shrimp Scampi Meets Salsa Verde",
# recipe_description: "This shrimp pasta with cilantro and lime is spicy, citrusy, and bold.",
# user: user1,
# music_suggestion: music_suggestions.sample,
# recipe: food_suggestions.sample
# )

4.times do
  Recipe.create(
  name: "Meat dish",
  difficulty: "Easy",
  food_type: "Meat",
  image_url: "https://www.allrecipes.com/thmb/btUERcJpWP1SuxDjzIKqsfw31wk=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/212911-filipino-beef-steak-ddmfs-3X4-0284-ac57852ee0d54c8e875846c096effb3c.jpg",
  ingredients: ["300 g Arborio rice", "1 L vegetable stock", "250 g fresh mushrooms (e.g., cremini or button), sliced", "100 g grated Parmesan cheese", "100 mL dry white wine", "1 medium onion, finely chopped (approx. 120 g)", "2 cloves garlic, minced", "2 tbsp olive oil (approx. 30 mL)", "30 g unsalted butter", "Salt and black pepper to taste", "2 tbsp fresh parsley, chopped (approx. 8 g)"],
  portion_size: 4,
  instructions: ["Begin by finely chopping the onion and mincing the garlic. Clean and slice the mushrooms evenly. Warm the vegetable stock in a separate saucepan and keep it at a gentle simmer—this is key to maintaining the cooking temperature of the risotto. Measure out your rice, wine, cheese, and herbs so everything is ready to go.", "In a large pan, heat the olive oil over medium heat. Add the chopped onion and cook for 3–4 minutes until soft and translucent. Add the garlic and cook for another minute, stirring frequently to prevent burning. Toss in the sliced mushrooms and sauté for 6–8 minutes until they release their moisture and become golden brown. Season lightly with salt and pepper.", "Add the Arborio rice to the pan and stir to coat with the oil and mushroom mixture. Let it toast for 1–2 minutes, then pour in the white wine. Stir continuously until the wine is mostly absorbed. Begin adding the hot vegetable stock, one ladleful at a time, stirring frequently. Wait for each addition to absorb before adding the next. This process takes about 18–20 minutes.", "Once the rice is creamy and al dente, remove the pan from heat. Stir in the butter and grated Parmesan cheese until melted and well combined. Taste and adjust seasoning with salt and black pepper. Let the risotto rest for a minute, then sprinkle with chopped parsley before serving. Serve immediately while hot and creamy. Enjoy as a hearty vegetarian main or as a luxurious side dish."],
  cuisine: "world cuisine",
  duration: rand(20-90),
  description: "Creamy mushroom risotto with garlic, Parmesan, and herbs—rich, savory, and perfectly comforting."
  )
end

4.times do
  Recipe.create(
  name: "Meat dish",
  difficulty: "Medium",
  food_type: "Meat",
  image_url: "https://www.allrecipes.com/thmb/btUERcJpWP1SuxDjzIKqsfw31wk=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/212911-filipino-beef-steak-ddmfs-3X4-0284-ac57852ee0d54c8e875846c096effb3c.jpg",
  ingredients: ["300 g Arborio rice", "1 L vegetable stock", "250 g fresh mushrooms (e.g., cremini or button), sliced", "100 g grated Parmesan cheese", "100 mL dry white wine", "1 medium onion, finely chopped (approx. 120 g)", "2 cloves garlic, minced", "2 tbsp olive oil (approx. 30 mL)", "30 g unsalted butter", "Salt and black pepper to taste", "2 tbsp fresh parsley, chopped (approx. 8 g)"],
  portion_size: 4,
  instructions: ["Begin by finely chopping the onion and mincing the garlic. Clean and slice the mushrooms evenly. Warm the vegetable stock in a separate saucepan and keep it at a gentle simmer—this is key to maintaining the cooking temperature of the risotto. Measure out your rice, wine, cheese, and herbs so everything is ready to go.", "In a large pan, heat the olive oil over medium heat. Add the chopped onion and cook for 3–4 minutes until soft and translucent. Add the garlic and cook for another minute, stirring frequently to prevent burning. Toss in the sliced mushrooms and sauté for 6–8 minutes until they release their moisture and become golden brown. Season lightly with salt and pepper.", "Add the Arborio rice to the pan and stir to coat with the oil and mushroom mixture. Let it toast for 1–2 minutes, then pour in the white wine. Stir continuously until the wine is mostly absorbed. Begin adding the hot vegetable stock, one ladleful at a time, stirring frequently. Wait for each addition to absorb before adding the next. This process takes about 18–20 minutes.", "Once the rice is creamy and al dente, remove the pan from heat. Stir in the butter and grated Parmesan cheese until melted and well combined. Taste and adjust seasoning with salt and black pepper. Let the risotto rest for a minute, then sprinkle with chopped parsley before serving. Serve immediately while hot and creamy. Enjoy as a hearty vegetarian main or as a luxurious side dish."],
  cuisine: "world cuisine",
  duration: rand(20-90),
  description: "Creamy mushroom risotto with garlic, Parmesan, and herbs—rich, savory, and perfectly comforting."
  )
end

4.times do
  Recipe.create(
  name: "Meat dish",
  difficulty: "Hard",
  food_type: "Meat",
  image_url: "https://www.allrecipes.com/thmb/btUERcJpWP1SuxDjzIKqsfw31wk=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/212911-filipino-beef-steak-ddmfs-3X4-0284-ac57852ee0d54c8e875846c096effb3c.jpg",
  ingredients: ["300 g Arborio rice", "1 L vegetable stock", "250 g fresh mushrooms (e.g., cremini or button), sliced", "100 g grated Parmesan cheese", "100 mL dry white wine", "1 medium onion, finely chopped (approx. 120 g)", "2 cloves garlic, minced", "2 tbsp olive oil (approx. 30 mL)", "30 g unsalted butter", "Salt and black pepper to taste", "2 tbsp fresh parsley, chopped (approx. 8 g)"],
  portion_size: 4,
  instructions: ["Begin by finely chopping the onion and mincing the garlic. Clean and slice the mushrooms evenly. Warm the vegetable stock in a separate saucepan and keep it at a gentle simmer—this is key to maintaining the cooking temperature of the risotto. Measure out your rice, wine, cheese, and herbs so everything is ready to go.", "In a large pan, heat the olive oil over medium heat. Add the chopped onion and cook for 3–4 minutes until soft and translucent. Add the garlic and cook for another minute, stirring frequently to prevent burning. Toss in the sliced mushrooms and sauté for 6–8 minutes until they release their moisture and become golden brown. Season lightly with salt and pepper.", "Add the Arborio rice to the pan and stir to coat with the oil and mushroom mixture. Let it toast for 1–2 minutes, then pour in the white wine. Stir continuously until the wine is mostly absorbed. Begin adding the hot vegetable stock, one ladleful at a time, stirring frequently. Wait for each addition to absorb before adding the next. This process takes about 18–20 minutes.", "Once the rice is creamy and al dente, remove the pan from heat. Stir in the butter and grated Parmesan cheese until melted and well combined. Taste and adjust seasoning with salt and black pepper. Let the risotto rest for a minute, then sprinkle with chopped parsley before serving. Serve immediately while hot and creamy. Enjoy as a hearty vegetarian main or as a luxurious side dish."],
  cuisine: "world cuisine",
  duration: rand(20-90),
  description: "Creamy mushroom risotto with garlic, Parmesan, and herbs—rich, savory, and perfectly comforting."
  )
end

4.times do
  Recipe.create(
  name: "Veggie dish",
  difficulty: "Easy",
  food_type: "Vegetarian",
  image_url: "https://static01.nyt.com/images/2021/06/01/dining/11lightveg-roundup-promo/11lightveg-roundup-8-mediumSquareAt3X-v2.jpg",
  ingredients: ["300 g Arborio rice", "1 L vegetable stock", "250 g fresh mushrooms (e.g., cremini or button), sliced", "100 g grated Parmesan cheese", "100 mL dry white wine", "1 medium onion, finely chopped (approx. 120 g)", "2 cloves garlic, minced", "2 tbsp olive oil (approx. 30 mL)", "30 g unsalted butter", "Salt and black pepper to taste", "2 tbsp fresh parsley, chopped (approx. 8 g)"],
  portion_size: 4,
  instructions: ["Begin by finely chopping the onion and mincing the garlic. Clean and slice the mushrooms evenly. Warm the vegetable stock in a separate saucepan and keep it at a gentle simmer—this is key to maintaining the cooking temperature of the risotto. Measure out your rice, wine, cheese, and herbs so everything is ready to go.", "In a large pan, heat the olive oil over medium heat. Add the chopped onion and cook for 3–4 minutes until soft and translucent. Add the garlic and cook for another minute, stirring frequently to prevent burning. Toss in the sliced mushrooms and sauté for 6–8 minutes until they release their moisture and become golden brown. Season lightly with salt and pepper.", "Add the Arborio rice to the pan and stir to coat with the oil and mushroom mixture. Let it toast for 1–2 minutes, then pour in the white wine. Stir continuously until the wine is mostly absorbed. Begin adding the hot vegetable stock, one ladleful at a time, stirring frequently. Wait for each addition to absorb before adding the next. This process takes about 18–20 minutes.", "Once the rice is creamy and al dente, remove the pan from heat. Stir in the butter and grated Parmesan cheese until melted and well combined. Taste and adjust seasoning with salt and black pepper. Let the risotto rest for a minute, then sprinkle with chopped parsley before serving. Serve immediately while hot and creamy. Enjoy as a hearty vegetarian main or as a luxurious side dish."],
  cuisine: "world cuisine",
  duration: rand(20-90),
  description: "Creamy mushroom risotto with garlic, Parmesan, and herbs—rich, savory, and perfectly comforting."
  )
end

4.times do
  Recipe.create(
  name: "Veggie dish",
  difficulty: "Medium",
  food_type: "Vegetarian",
  image_url: "https://static01.nyt.com/images/2021/06/01/dining/11lightveg-roundup-promo/11lightveg-roundup-8-mediumSquareAt3X-v2.jpg",
  ingredients: ["300 g Arborio rice", "1 L vegetable stock", "250 g fresh mushrooms (e.g., cremini or button), sliced", "100 g grated Parmesan cheese", "100 mL dry white wine", "1 medium onion, finely chopped (approx. 120 g)", "2 cloves garlic, minced", "2 tbsp olive oil (approx. 30 mL)", "30 g unsalted butter", "Salt and black pepper to taste", "2 tbsp fresh parsley, chopped (approx. 8 g)"],
  portion_size: 4,
  instructions: ["Begin by finely chopping the onion and mincing the garlic. Clean and slice the mushrooms evenly. Warm the vegetable stock in a separate saucepan and keep it at a gentle simmer—this is key to maintaining the cooking temperature of the risotto. Measure out your rice, wine, cheese, and herbs so everything is ready to go.", "In a large pan, heat the olive oil over medium heat. Add the chopped onion and cook for 3–4 minutes until soft and translucent. Add the garlic and cook for another minute, stirring frequently to prevent burning. Toss in the sliced mushrooms and sauté for 6–8 minutes until they release their moisture and become golden brown. Season lightly with salt and pepper.", "Add the Arborio rice to the pan and stir to coat with the oil and mushroom mixture. Let it toast for 1–2 minutes, then pour in the white wine. Stir continuously until the wine is mostly absorbed. Begin adding the hot vegetable stock, one ladleful at a time, stirring frequently. Wait for each addition to absorb before adding the next. This process takes about 18–20 minutes.", "Once the rice is creamy and al dente, remove the pan from heat. Stir in the butter and grated Parmesan cheese until melted and well combined. Taste and adjust seasoning with salt and black pepper. Let the risotto rest for a minute, then sprinkle with chopped parsley before serving. Serve immediately while hot and creamy. Enjoy as a hearty vegetarian main or as a luxurious side dish."],
  cuisine: "world cuisine",
  duration: rand(20-90),
  description: "Creamy mushroom risotto with garlic, Parmesan, and herbs—rich, savory, and perfectly comforting."
  )
end

4.times do
  Recipe.create(
  name: "Veggie dish",
  difficulty: "Hard",
  food_type: "Vegetarian",
  image_url: "https://static01.nyt.com/images/2021/06/01/dining/11lightveg-roundup-promo/11lightveg-roundup-8-mediumSquareAt3X-v2.jpg",
  ingredients: ["300 g Arborio rice", "1 L vegetable stock", "250 g fresh mushrooms (e.g., cremini or button), sliced", "100 g grated Parmesan cheese", "100 mL dry white wine", "1 medium onion, finely chopped (approx. 120 g)", "2 cloves garlic, minced", "2 tbsp olive oil (approx. 30 mL)", "30 g unsalted butter", "Salt and black pepper to taste", "2 tbsp fresh parsley, chopped (approx. 8 g)"],
  portion_size: 4,
  instructions: ["Begin by finely chopping the onion and mincing the garlic. Clean and slice the mushrooms evenly. Warm the vegetable stock in a separate saucepan and keep it at a gentle simmer—this is key to maintaining the cooking temperature of the risotto. Measure out your rice, wine, cheese, and herbs so everything is ready to go.", "In a large pan, heat the olive oil over medium heat. Add the chopped onion and cook for 3–4 minutes until soft and translucent. Add the garlic and cook for another minute, stirring frequently to prevent burning. Toss in the sliced mushrooms and sauté for 6–8 minutes until they release their moisture and become golden brown. Season lightly with salt and pepper.", "Add the Arborio rice to the pan and stir to coat with the oil and mushroom mixture. Let it toast for 1–2 minutes, then pour in the white wine. Stir continuously until the wine is mostly absorbed. Begin adding the hot vegetable stock, one ladleful at a time, stirring frequently. Wait for each addition to absorb before adding the next. This process takes about 18–20 minutes.", "Once the rice is creamy and al dente, remove the pan from heat. Stir in the butter and grated Parmesan cheese until melted and well combined. Taste and adjust seasoning with salt and black pepper. Let the risotto rest for a minute, then sprinkle with chopped parsley before serving. Serve immediately while hot and creamy. Enjoy as a hearty vegetarian main or as a luxurious side dish."],
  cuisine: "world cuisine",
  duration: rand(20-90),
  description: "Creamy mushroom risotto with garlic, Parmesan, and herbs—rich, savory, and perfectly comforting."
  )
end

4.times do
  Recipe.create(
  name: "Vegan dish",
  difficulty: "Easy",
  food_type: "Vegan",
  image_url: "https://images.immediate.co.uk/production/volatile/sites/2/2017/10/Harissa-Cauliflower-19c65cd.jpg?quality=90&resize=556,505",
  ingredients: ["300 g Arborio rice", "1 L vegetable stock", "250 g fresh mushrooms (e.g., cremini or button), sliced", "100 g grated Parmesan cheese", "100 mL dry white wine", "1 medium onion, finely chopped (approx. 120 g)", "2 cloves garlic, minced", "2 tbsp olive oil (approx. 30 mL)", "30 g unsalted butter", "Salt and black pepper to taste", "2 tbsp fresh parsley, chopped (approx. 8 g)"],
  portion_size: 4,
  instructions: ["Begin by finely chopping the onion and mincing the garlic. Clean and slice the mushrooms evenly. Warm the vegetable stock in a separate saucepan and keep it at a gentle simmer—this is key to maintaining the cooking temperature of the risotto. Measure out your rice, wine, cheese, and herbs so everything is ready to go.", "In a large pan, heat the olive oil over medium heat. Add the chopped onion and cook for 3–4 minutes until soft and translucent. Add the garlic and cook for another minute, stirring frequently to prevent burning. Toss in the sliced mushrooms and sauté for 6–8 minutes until they release their moisture and become golden brown. Season lightly with salt and pepper.", "Add the Arborio rice to the pan and stir to coat with the oil and mushroom mixture. Let it toast for 1–2 minutes, then pour in the white wine. Stir continuously until the wine is mostly absorbed. Begin adding the hot vegetable stock, one ladleful at a time, stirring frequently. Wait for each addition to absorb before adding the next. This process takes about 18–20 minutes.", "Once the rice is creamy and al dente, remove the pan from heat. Stir in the butter and grated Parmesan cheese until melted and well combined. Taste and adjust seasoning with salt and black pepper. Let the risotto rest for a minute, then sprinkle with chopped parsley before serving. Serve immediately while hot and creamy. Enjoy as a hearty vegetarian main or as a luxurious side dish."],
  cuisine: "world cuisine",
  duration: rand(20-90),
  description: "Creamy mushroom risotto with garlic, Parmesan, and herbs—rich, savory, and perfectly comforting."
  )
end

4.times do
  Recipe.create(
  name: "Vegan dish",
  difficulty: "Medium",
  food_type: "Vegan",
  image_url: "https://images.immediate.co.uk/production/volatile/sites/2/2017/10/Harissa-Cauliflower-19c65cd.jpg?quality=90&resize=556,505",
  ingredients: ["300 g Arborio rice", "1 L vegetable stock", "250 g fresh mushrooms (e.g., cremini or button), sliced", "100 g grated Parmesan cheese", "100 mL dry white wine", "1 medium onion, finely chopped (approx. 120 g)", "2 cloves garlic, minced", "2 tbsp olive oil (approx. 30 mL)", "30 g unsalted butter", "Salt and black pepper to taste", "2 tbsp fresh parsley, chopped (approx. 8 g)"],
  portion_size: 4,
  instructions: ["Begin by finely chopping the onion and mincing the garlic. Clean and slice the mushrooms evenly. Warm the vegetable stock in a separate saucepan and keep it at a gentle simmer—this is key to maintaining the cooking temperature of the risotto. Measure out your rice, wine, cheese, and herbs so everything is ready to go.", "In a large pan, heat the olive oil over medium heat. Add the chopped onion and cook for 3–4 minutes until soft and translucent. Add the garlic and cook for another minute, stirring frequently to prevent burning. Toss in the sliced mushrooms and sauté for 6–8 minutes until they release their moisture and become golden brown. Season lightly with salt and pepper.", "Add the Arborio rice to the pan and stir to coat with the oil and mushroom mixture. Let it toast for 1–2 minutes, then pour in the white wine. Stir continuously until the wine is mostly absorbed. Begin adding the hot vegetable stock, one ladleful at a time, stirring frequently. Wait for each addition to absorb before adding the next. This process takes about 18–20 minutes.", "Once the rice is creamy and al dente, remove the pan from heat. Stir in the butter and grated Parmesan cheese until melted and well combined. Taste and adjust seasoning with salt and black pepper. Let the risotto rest for a minute, then sprinkle with chopped parsley before serving. Serve immediately while hot and creamy. Enjoy as a hearty vegetarian main or as a luxurious side dish."],
  cuisine: "world cuisine",
  duration: rand(20-90),
  description: "Creamy mushroom risotto with garlic, Parmesan, and herbs—rich, savory, and perfectly comforting."
  )
end

4.times do
  Recipe.create(
  name: "Vegan dish",
  difficulty: "Hard",
  food_type: "Vegan",
  image_url: "https://images.immediate.co.uk/production/volatile/sites/2/2017/10/Harissa-Cauliflower-19c65cd.jpg?quality=90&resize=556,505",
  ingredients: ["300 g Arborio rice", "1 L vegetable stock", "250 g fresh mushrooms (e.g., cremini or button), sliced", "100 g grated Parmesan cheese", "100 mL dry white wine", "1 medium onion, finely chopped (approx. 120 g)", "2 cloves garlic, minced", "2 tbsp olive oil (approx. 30 mL)", "30 g unsalted butter", "Salt and black pepper to taste", "2 tbsp fresh parsley, chopped (approx. 8 g)"],
  portion_size: 4,
  instructions: ["Begin by finely chopping the onion and mincing the garlic. Clean and slice the mushrooms evenly. Warm the vegetable stock in a separate saucepan and keep it at a gentle simmer—this is key to maintaining the cooking temperature of the risotto. Measure out your rice, wine, cheese, and herbs so everything is ready to go.", "In a large pan, heat the olive oil over medium heat. Add the chopped onion and cook for 3–4 minutes until soft and translucent. Add the garlic and cook for another minute, stirring frequently to prevent burning. Toss in the sliced mushrooms and sauté for 6–8 minutes until they release their moisture and become golden brown. Season lightly with salt and pepper.", "Add the Arborio rice to the pan and stir to coat with the oil and mushroom mixture. Let it toast for 1–2 minutes, then pour in the white wine. Stir continuously until the wine is mostly absorbed. Begin adding the hot vegetable stock, one ladleful at a time, stirring frequently. Wait for each addition to absorb before adding the next. This process takes about 18–20 minutes.", "Once the rice is creamy and al dente, remove the pan from heat. Stir in the butter and grated Parmesan cheese until melted and well combined. Taste and adjust seasoning with salt and black pepper. Let the risotto rest for a minute, then sprinkle with chopped parsley before serving. Serve immediately while hot and creamy. Enjoy as a hearty vegetarian main or as a luxurious side dish."],
  cuisine: "world cuisine",
  duration: rand(20-90),
  description: "Creamy mushroom risotto with garlic, Parmesan, and herbs—rich, savory, and perfectly comforting."
  )
end

4.times do
  Recipe.create(
  name: "Seafood dish",
  difficulty: "Easy",
  food_type: "Seafood",
  image_url: "https://www.foodandwine.com/thmb/ClPnka2WSnl5PtrMYOjlmXsXw1k=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/escovitch-fish-FT-RECIPE0920-8a733638c2ba4b72b48737782fa616c2.jpg",
  ingredients: ["300 g Arborio rice", "1 L vegetable stock", "250 g fresh mushrooms (e.g., cremini or button), sliced", "100 g grated Parmesan cheese", "100 mL dry white wine", "1 medium onion, finely chopped (approx. 120 g)", "2 cloves garlic, minced", "2 tbsp olive oil (approx. 30 mL)", "30 g unsalted butter", "Salt and black pepper to taste", "2 tbsp fresh parsley, chopped (approx. 8 g)"],
  portion_size: 4,
  instructions: ["Begin by finely chopping the onion and mincing the garlic. Clean and slice the mushrooms evenly. Warm the vegetable stock in a separate saucepan and keep it at a gentle simmer—this is key to maintaining the cooking temperature of the risotto. Measure out your rice, wine, cheese, and herbs so everything is ready to go.", "In a large pan, heat the olive oil over medium heat. Add the chopped onion and cook for 3–4 minutes until soft and translucent. Add the garlic and cook for another minute, stirring frequently to prevent burning. Toss in the sliced mushrooms and sauté for 6–8 minutes until they release their moisture and become golden brown. Season lightly with salt and pepper.", "Add the Arborio rice to the pan and stir to coat with the oil and mushroom mixture. Let it toast for 1–2 minutes, then pour in the white wine. Stir continuously until the wine is mostly absorbed. Begin adding the hot vegetable stock, one ladleful at a time, stirring frequently. Wait for each addition to absorb before adding the next. This process takes about 18–20 minutes.", "Once the rice is creamy and al dente, remove the pan from heat. Stir in the butter and grated Parmesan cheese until melted and well combined. Taste and adjust seasoning with salt and black pepper. Let the risotto rest for a minute, then sprinkle with chopped parsley before serving. Serve immediately while hot and creamy. Enjoy as a hearty vegetarian main or as a luxurious side dish."],
  cuisine: "world cuisine",
  duration: rand(20-90),
  description: "Creamy mushroom risotto with garlic, Parmesan, and herbs—rich, savory, and perfectly comforting."
  )
end

4.times do
  Recipe.create(
  name: "Seafood dish",
  difficulty: "Medium",
  food_type: "Seafood",
  image_url: "https://www.foodandwine.com/thmb/ClPnka2WSnl5PtrMYOjlmXsXw1k=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/escovitch-fish-FT-RECIPE0920-8a733638c2ba4b72b48737782fa616c2.jpg",
  ingredients: ["300 g Arborio rice", "1 L vegetable stock", "250 g fresh mushrooms (e.g., cremini or button), sliced", "100 g grated Parmesan cheese", "100 mL dry white wine", "1 medium onion, finely chopped (approx. 120 g)", "2 cloves garlic, minced", "2 tbsp olive oil (approx. 30 mL)", "30 g unsalted butter", "Salt and black pepper to taste", "2 tbsp fresh parsley, chopped (approx. 8 g)"],
  portion_size: 4,
  instructions: ["Begin by finely chopping the onion and mincing the garlic. Clean and slice the mushrooms evenly. Warm the vegetable stock in a separate saucepan and keep it at a gentle simmer—this is key to maintaining the cooking temperature of the risotto. Measure out your rice, wine, cheese, and herbs so everything is ready to go.", "In a large pan, heat the olive oil over medium heat. Add the chopped onion and cook for 3–4 minutes until soft and translucent. Add the garlic and cook for another minute, stirring frequently to prevent burning. Toss in the sliced mushrooms and sauté for 6–8 minutes until they release their moisture and become golden brown. Season lightly with salt and pepper.", "Add the Arborio rice to the pan and stir to coat with the oil and mushroom mixture. Let it toast for 1–2 minutes, then pour in the white wine. Stir continuously until the wine is mostly absorbed. Begin adding the hot vegetable stock, one ladleful at a time, stirring frequently. Wait for each addition to absorb before adding the next. This process takes about 18–20 minutes.", "Once the rice is creamy and al dente, remove the pan from heat. Stir in the butter and grated Parmesan cheese until melted and well combined. Taste and adjust seasoning with salt and black pepper. Let the risotto rest for a minute, then sprinkle with chopped parsley before serving. Serve immediately while hot and creamy. Enjoy as a hearty vegetarian main or as a luxurious side dish."],
  cuisine: "world cuisine",
  duration: rand(20-90),
  description: "Creamy mushroom risotto with garlic, Parmesan, and herbs—rich, savory, and perfectly comforting."
  )
end

4.times do
  Recipe.create(
  name: "Seafood dish",
  difficulty: "Hard",
  food_type: "Seafood",
  image_url: "https://www.foodandwine.com/thmb/ClPnka2WSnl5PtrMYOjlmXsXw1k=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/escovitch-fish-FT-RECIPE0920-8a733638c2ba4b72b48737782fa616c2.jpg",
  ingredients: ["300 g Arborio rice", "1 L vegetable stock", "250 g fresh mushrooms (e.g., cremini or button), sliced", "100 g grated Parmesan cheese", "100 mL dry white wine", "1 medium onion, finely chopped (approx. 120 g)", "2 cloves garlic, minced", "2 tbsp olive oil (approx. 30 mL)", "30 g unsalted butter", "Salt and black pepper to taste", "2 tbsp fresh parsley, chopped (approx. 8 g)"],
  portion_size: 4,
  instructions: ["Begin by finely chopping the onion and mincing the garlic. Clean and slice the mushrooms evenly. Warm the vegetable stock in a separate saucepan and keep it at a gentle simmer—this is key to maintaining the cooking temperature of the risotto. Measure out your rice, wine, cheese, and herbs so everything is ready to go.", "In a large pan, heat the olive oil over medium heat. Add the chopped onion and cook for 3–4 minutes until soft and translucent. Add the garlic and cook for another minute, stirring frequently to prevent burning. Toss in the sliced mushrooms and sauté for 6–8 minutes until they release their moisture and become golden brown. Season lightly with salt and pepper.", "Add the Arborio rice to the pan and stir to coat with the oil and mushroom mixture. Let it toast for 1–2 minutes, then pour in the white wine. Stir continuously until the wine is mostly absorbed. Begin adding the hot vegetable stock, one ladleful at a time, stirring frequently. Wait for each addition to absorb before adding the next. This process takes about 18–20 minutes.", "Once the rice is creamy and al dente, remove the pan from heat. Stir in the butter and grated Parmesan cheese until melted and well combined. Taste and adjust seasoning with salt and black pepper. Let the risotto rest for a minute, then sprinkle with chopped parsley before serving. Serve immediately while hot and creamy. Enjoy as a hearty vegetarian main or as a luxurious side dish."],
  cuisine: "world cuisine",
  duration: rand(20-90),
  description: "Creamy mushroom risotto with garlic, Parmesan, and herbs—rich, savory, and perfectly comforting."
  )
end
puts "Created #{Recipe.count} recipes"
