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
      limit: 1
    }
  })

  unless response.success?
    puts "Spotify playlist API error for '#{query}': #{response.body}"
    return nil
  end

  response.parsed_response['playlists']['items'].first
end

  private

  def auth_header
    { "Authorization" => "Bearer #{@access_token}" }
  end
end
