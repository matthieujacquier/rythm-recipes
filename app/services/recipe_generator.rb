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
        { role: "system", content: "You are an online cooking blogger and you share detailed food recipes online." },
        { role: "user", content: prompt }
      ]
    }
  )

  raw_json = response["choices"][0]["message"]["content"]
  cleaned_json = raw_json.gsub(/\A```json\s*|\A```\s*|```$/, '').strip
  parsed_recipes = JSON.parse(cleaned_json)
  return parsed_recipes
end

  private

  def prompt
  <<~PROMPT
    Generate a valid JSON array containing 8 unique and diverse cooking recipes for:

    - difficulty: "#{@difficulty}" (one of: easy, medium, hard)
    - food_type: "#{@food_type}" (one of: meat, vegetarian, vegan, seafood)


    Each recipe must follow **this exact structure**:

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
      "description": "Short, enticing one to three sentences description of the dish",
      "difficulty": "easy",
      "food_type": "meat"
    }

    Guidelines:
    - Include the `difficulty` and `food_type` fields in **each recipe object**.
    - Recipes must be unique in name, ingredients, preparation method, and cuisine.
    - Be original in your suggestions
    - Do not repeat the following recipes : Herbed Grilled chicken, Beef Stir Fry, Honey Garlic Pork Chops, Lemon Herb Lamb Chops, Vegetarian Stuffed Bell Peppers, Caprese Salad, Thai Coconut Fish Curry, Vegetarian Fried Rice, Vegetarian Tacos, Vegan Chickpea Salad, Vegan Thai Green Curry, Vegan Mexican Tacos, Vegan Indian Lentil Soup, Garlic Butter Shrimp Pasta, Spanish Garlic Prawns, Lemon Herb Grilled Salmon, Spicy Korean Beef Stir-Fry, Moroccan Lamb Tagine, Italian Chick Cacciatore, Mexican Pork Carnitas, Thai Green Curry, Stuffed Bell Peppers, Spinach and Ricotta Cannelloni, Chickpea and Vegetable Tagine, Mushroom and Leek Risotto, Mushroom Stroganoff, Moroccan Vegetable Tagine, Vegan Paella, Seafood Paella, Grilled Miso Salmon, Thai Green Curry with Prawns, New England Clam Chowder, Beef Wellington, Coq au Vin, Eggplant Moussaka, Osso Buco, Rogan Josh, Stuffed Bell Peppers with Quinoa and Cheese, Vegetable Lasagna with Homemade Pasta, Mushroom and Truffle Risotto, Vegan Mushroom Wellington, Vegan Biryani, Vegan Ramen, Bouillabaisse Marseillaise, Paella de Marisco, Cioppino, Lobster Thermidor.
    - Difficulty levels affect the duration and complexity:
      - Easy = 15–45 min
      - Medium = 45–90 min
      - Hard = 90+ min or with complex techniques
    - Use ingredients that are appropriate to the food type:
      - `meat`: includes poultry, beef, lamb, chicken,  etc.
      - `vegetarian`: no meat or fish, but can include eggs and dairy
      - `vegan`: no animal products at all
      - `seafood`: includes fish, shellfish, and crustaceans
    - Return **only JSON** — an array of 48 recipe objects. No markdown, no explanations.

  PROMPT
end

end
