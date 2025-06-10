require 'open-uri'

Recipe.delete_all
Match.delete_all
User.delete_all
MusicSuggestion.delete_all

puts "Defining genres"

GENRES = [
  'Pop', 'Rock', 'Hip-Hop', 'Rap', 'R&B', 'Indie',
  'Electronic', 'Dance', 'Alternative', 'Jazz', 'Classical',
  'Folk', 'Country', 'Metal', 'Punk', 'Blues', 'Reggae', 'Soul', 'Funk', 'Techno'
]

spotify = SpotifyClient.new

GENRES.each do |genre|
  puts "Fetching album for genre: #{genre}"

  album = spotify.search_album(genre)
  next unless album

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
    #nil for now. Will update later once I look at the embedding
    album: true
  )

  puts "Saved: #{music_suggestion.name} (#{genre})"
end

puts "Fetching playlists..."

GENRES.each do |genre|
  puts "Fetching playlist for genre: #{genre}"

  playlist = spotify.search_playlist(genre)
  next unless playlist

  music_suggestion = MusicSuggestion.find_or_initialize_by(spotify_id: playlist['id'])
  music_suggestion.update!(
    name: playlist['name'],
    image_url: playlist['images'][0]['url'],
    genre: genre,
    #the playlist search doesn't returns artists directly. Putting a placeholder for now
    artists: ["Various Artists"],
    tracklist: playlist['href'],
    preview_url: nil,
    album: false
  )

  puts "Saved playlist: #{music_suggestion.name} (#{genre})"
end

#turns MusicSuggestion object into an array. So that we can sample over it
music_suggestions = MusicSuggestion.all.to_a

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


puts "Seeding matches and recipes..."

matches = 5.times.map do |i|
  Match.create!(
    saved: [true, false].sample,
    rating: rand(1..5),
    recipe_name: "Delicious Dish #{i + 1}",
    recipe_description: "A tasty treat you’ll love.",
    user: users.sample,
    music_suggestion: music_suggestions.sample
  )
end

puts "Created #{Match.count} Matches and their associated Recipes"


puts "Seeding complete!"
