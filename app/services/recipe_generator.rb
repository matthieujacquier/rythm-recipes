class RecipeGenerator
  def initialize(difficulty:, food_type:)
    @difficulty = difficulty
    @food_type = food_type
  end

  def call
    response = OpenAIClient.chat(
      parameters: {
        model: "gpt-4o",
        temperature: 0.7,
        messages: [
          { role: "system", content: "You are a professional chef and creative assistant generating detailed recipes." },
          { role: "user", content: prompt }
        ]
      }
    )

    raw_json = response["choices"][0]["message"]["content"]
    parsed_recipe = JSON.parse(raw_json)
    return parsed_recipe
  end

  private

  def prompt
    <<~PROMPT
      Generate a JSON object for a recipe based on the following inputs:

      - Difficulty: #{@difficulty}
      - Food Type: #{@food_type}

      The JSON should include:
      {
        "name": string (e.g. "Creamy Vegan Mushroom Risotto"),
        "ingredients": [
          { "name": "ingredient name", "quantity": "amount in grams or unit" }
        ],
        "portion_size": 4,
        "instructions": [
          { "title": "Step 1 title", "description": "Step 1 instruction" },
          { "title": "Step 2 title", "description": "Step 2 instruction" }
        ],
        "cuisine": "Cuisine type",
        "duration": integer (in minutes),
        "description": "Short subtitle description"
      }

      Do not include image_url or match_id. Return only valid JSON, no markdown.
    PROMPT
  end
end
