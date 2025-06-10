# app/services/spotify_token_service.rb

class SpotifyTokenService
  include HTTParty
  base_uri 'https://accounts.spotify.com'

  def initialize(client_id = ENV['SPOTIFY_CLIENT_ID'], client_secret = ENV['SPOTIFY_CLIENT_SECRET'])
    @client_id = client_id
    @client_secret = client_secret
  end

  def fetch_access_token
    auth = Base64.strict_encode64("#{@client_id}:#{@client_secret}")
    response = SpotifyTokenService.post('/api/token',
      headers: {
        'Authorization' => "Basic #{auth}",
        'Content-Type' => 'application/x-www-form-urlencoded'
      },
      body: {
        grant_type: 'client_credentials'
      }
    )

    if response.success?
      response.parsed_response["access_token"]
    else
      raise "Spotify token request failed: #{response.body}"
    end
  end
end
