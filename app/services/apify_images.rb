require 'net/http'
require 'uri'
require 'json'

class ApifyImages
  def initialize(query)
    @query = query
  end

  def fetch_image_url
    task_id = ENV['APIFY_TASK_ID']
    token = ENV['APIFY_API_TOKEN']

    uri = URI("https://api.apify.com/v2/actor-tasks/#{task_id}/run-sync-get-dataset-items?token=#{token}&format=json&clean=true&limit=1")

    body = {
      queries: [@query],
      maxResultsPerQuery: 1
    }.to_json
    headers = { "Content-Type" => "application/json" }
    response = Net::HTTP.post(uri, body, headers)
    puts "🚀 Run response: #{response.body}"

    items = JSON.parse(response.body)
    items.dig(0, "imageUrl") || items.dig(0, "url")
  rescue => e
    Rails.logger.error("Image Fetch failed: #{e.message}")
    nil
  end
end
