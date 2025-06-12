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
          { role: "system", content: "You are an online cooking blogger and you share detailed food recipes online."},
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
    Generate a valid JSON object for a cooking recipe based on the following inputs:

    - "difficulty": "#{@difficulty}" (one of: Easy, Medium, Hard)
    - "food_type": "#{@food_type}" (one of: meat, vegetarian, vegan, fish)

    The recipe must follow this exact structure:

    {
      "name": "Example Recipe Name",
      "ingredients": [
        { "name": "Ingredient 1", "quantity": "amount in grams or unit" }
      ],
      "portion_size": 4,
      "instructions": [
        { "title": "Step 1 title", "description": "Step 1 instruction" }
      ],
      "cuisine": "Cuisine type (e.g., Italian, Indian, French)",
      "duration": 45,
      "description": "Short, enticing one-sentence description of the dish"
    }

    Easy recipes shoud take less time (duration) than Median and Hard ones (3).
    Return only valid JSON with no extra text or markdown. Begin the response with `{` and end with `}`.
  PROMPT
end

end
