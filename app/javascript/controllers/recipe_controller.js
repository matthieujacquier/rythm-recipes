import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["food", "difficulty"]

  triggerJob(event) {
    console.log("testing");

    const difficulty = event.target.value;
    const foodType = document.querySelector('input[name="food_type_selection"]:checked')?.value;

    if (!foodType) return;

    fetch('/generate_recipe', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector("meta[name='csrf-token']").content
      },
      body: JSON.stringify({ difficulty_selection: difficulty, food_type_selection: foodType })
    });
  }
}
