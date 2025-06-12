class SpotifyClient
  include HTTParty
  base_uri 'https://api.spotify.com/v1'

  def initialize
    token_service = SpotifyTokenService.new
    @access_token = token_service.fetch_access_token
  end

  def search_album(query) #calling it 3 times to be able to select the first that will match the criterias of track_count & artist_name
  response = SpotifyClient.get('/search', {
    headers: auth_header,
    query: {
      q: query,
      type: 'album',
      limit: 3
    }
  })

  unless response.success?
    puts "Spotify API error for '#{query}': #{response.body}"
    return nil
  end

  albums_data = response.parsed_response.dig('albums', 'items') #find the items array inside the album json response
  return nil unless albums_data.is_a?(Array) #safeguarding against the use case where albums_data is not an array (e.g weird response from Spotify API)

  valid_albums = []

  albums_data.each do |album|
    next unless album && album['id'] #safeguards against objects that could miss the album id (which is necessary to trigger the API call below - prevents errors)
    artist_names = album['artists'].map { |a| a['name'] }
    next if artist_names == ['Various Artists'] #skips Various Artists because I saw weird uses cases where Albums were actualluy kind of playlists. Especially for the Classical genre

    details = SpotifyClient.get("/albums/#{album['id']}", headers: auth_header)
    next unless details.success?

    track_count = details.parsed_response.dig('tracks', 'items')&.size.to_i

    if track_count > 6 #skips Single Albums
      valid_albums << details.parsed_response
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

  response.parsed_response.dig('playlists','items')&.first #the .first doesn't really make sense here because I'm only calling with a limit of 1 right ?
  #equivalent to response.parsed_response['playlists']['items'].first but returns nil instead of errors if it doesn't find a match for playlist & items.
end

  private

  def auth_header
    { "Authorization" => "Bearer #{@access_token}" }
  end
end
