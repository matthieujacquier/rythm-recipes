class SpotifyClient
  include HTTParty
  base_uri 'https://api.spotify.com/v1'

  def initialize
    token_service = SpotifyTokenService.new
    @access_token = token_service.fetch_access_token
  end

  def search_album(query)
  response = SpotifyClient.get('/search', {
    headers: auth_header,
    query: {
      q: query,
      type: 'album',
      limit: 3 #limiting to 3 instead of 5
    }
  })

  unless response.success?
    puts "Spotify API error for '#{query}': #{response.body}"
    return nil
  end

  albums_data = response.parsed_response.dig('albums', 'items') #create a variable with the parsed response to iterate and apply conditions to it
  return nil unless albums_data.is_a?(Array) #safeguards if somewhat doesn't return an array

  valid_albums = []

  albums_data.each do |album|
    next unless album && album['id'] #safeguard to ensure we have an id to avoid errors

    album_details = SpotifyClient.get("/albums/#{album['id']}", headers: auth_header)
    next unless album_details.success?

    album_data = album_details.parsed_response
    artist_names = album_data['artists'].map { |a| a['name'] }
    track_count = album_data.dig('tracks', 'items')&.size.to_i #counts the number of items into the track object

    # Only accept if both conditions are met
    if artist_names != ['Various Artists'] && track_count > 6
      valid_albums << album_data
    end
  end

  if valid_albums.any?
    return valid_albums.sample
  else
    puts "No suitable album found for '#{query}' with more than 6 tracks."
    return nil
  end
end



  def search_playlist(query)
  response = SpotifyClient.get('/search', {
    headers: auth_header,
    query: {
      q: query,
      type: 'playlist',
      limit: 1
    }
  })

  unless response.success?
    puts "Spotify playlist API error for '#{query}': #{response.body}"
    return nil
  end

  response.parsed_response.dig('playlists','items')&.first 
  #equivalent to response.parsed_response['playlists']['items'].first but returns nil instead of errors if it doesn't find a match for playlist & items.
end

  private

  def auth_header
    { "Authorization" => "Bearer #{@access_token}" }
  end
end
