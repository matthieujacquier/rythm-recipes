class SpotifyClient
  include HTTParty
  base_uri 'https://api.spotify.com/v1'

  def initialize
    token_service = SpotifyTokenService.new
    @access_token = token_service.fetch_access_token
  end


  def search_album_by_artist_and_title(artist_name, album_title)
  response = SpotifyClient.get('/search', {
    headers: auth_header,
    query: {
      q: "album:\"#{album_title}\" artist:\"#{artist_name}\"",
      type: 'album',
      limit: 1
    }
  })

  return nil unless response.success?
  items = response.parsed_response.dig('albums', 'items')
  return nil unless items.is_a?(Array) && items.any?

  album_id = items.first['id']
  album_details = SpotifyClient.get("/albums/#{album_id}", headers: auth_header)
  return nil unless album_details.success?

  album_details.parsed_response
end

#   def search_albums(query, limit: 30)
#   response = SpotifyClient.get('/search', {
#     headers: auth_header,
#     query: {
#       q: query,
#       type: 'album',
#       limit: 50
#     }
#   })

#   unless response.success?
#     puts "Spotify API error for '#{query}': #{response.body}"
#     return nil
#   end

#   albums_data = response.parsed_response.dig('albums', 'items') #create a variable with the parsed response to iterate and apply conditions to it
#   return nil unless albums_data.is_a?(Array) #safeguards if somewhat doesn't return an array

#   valid_albums = []

#   albums_data.each do |album|
#     next unless album && album['id'] #safeguard to ensure we have an id to avoid errors

#       if album['name'].to_s.downcase.include?(query.downcase)
#       puts "Skipping album '#{album['name']}' for genre '#{query}' due to name overlap."
#       next
#     end

#     album_details = SpotifyClient.get("/albums/#{album['id']}", headers: auth_header)
#     next unless album_details.success?

#     album_data = album_details.parsed_response
#     artist_names = album_data['artists'].map { |a| a['name'] }
#     track_count = album_data.dig('tracks', 'items')&.size.to_i #counts the number of items into the track object

#     # Only accept if both conditions are met
#     if artist_names != ['Various Artists'] && track_count > 6
#       valid_albums << album_data
#     end
#   end

#   valid_albums
# end



  def search_playlists(query)
  response = SpotifyClient.get('/search', {
    headers: auth_header,
    query: {
      q: query,
      type: 'playlist',
      limit: 30
    }
  })

  unless response.success?
    puts "Spotify playlist API error for '#{query}': #{response.body}"
    return nil
  end

  response.parsed_response.dig('playlists','items') || [] #avoids returning nil if not found. Instead returns empty array.
end

  private

  def auth_header
    { "Authorization" => "Bearer #{@access_token}" }
  end
end
