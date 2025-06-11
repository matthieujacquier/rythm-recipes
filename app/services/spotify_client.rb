# app/services/spotify_client.rb

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
        limit: 1
      }
    })

    unless response.success?
      puts "Spotify API error for '#{query}': #{response.body}"
      return nil
    end

    response.parsed_response['albums']['items'].first
  end

  def search_playlist(query)
  response = SpotifyClient.get('/search', {
    headers: auth_header,
    query: {
      q: query,
      type: 'playlist',
      limit: 5
    }
  })

  unless response.success?
    puts "Spotify playlist API error for '#{query}': #{response.body}"
    return nil
  end

  playlists_data = response.parsed_response.dig('playlists', 'items')
  return nil unless playlists_data.is_a?(Array)

  valid_playlists = []

  playlists_data.each do |playlist|
    next unless playlist && playlist['id']

    details = SpotifyClient.get("/playlists/#{playlist['id']}", headers: auth_header)
    next unless details.success?

    if details.parsed_response.dig('tracks', 'total').to_i > 8
      valid_playlists << details.parsed_response
    end
  end

  if valid_playlists.any?
    return valid_playlists.sample
  else
    puts "No suitable playlist found for '#{query}' with more than 8 tracks."
    return nil
  end
end



  private

  def auth_header
    { "Authorization" => "Bearer #{@access_token}" }
  end
end
