class ImageScraperService
  include HTTParty
  base_uri "https://api.apify.com/v2"

  def initialize(recipe_name)
    @recipe_name = recipe_name
    @token = ENV['APIFY_API_TOKEN']
    @task_id = ENV['APIFY_TASK_ID']
  end

  def fetch_image_url
    response = self.class.post("/actor-tasks/#{@task_id}/run-sync-get-dataset-items", {
      query: { token: @token },
      headers: { 'Content-Type' => 'application/json' },
      body: {
        searchTerm: @recipe_name,
        limit: 1
      }.to_json
    })

    json = JSON.parse(response.body)
    json.first['url'] if json.any?
  rescue => e
    Rails.logger.error("Apify fetch failed: #{e.message}")
    nil
  end
end
