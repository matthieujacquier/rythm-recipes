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
